using System;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SeleniumTests
{
    public class Actors
    {
        public enum _AccountType { newAccount, upgradePhoneKeepCurrentPlan2GB, upgradePhoneKeepCurrentPlan5GB, 
            upgradePhoneKeepCurrentPlan10GB, upgradePhoneKeepCurrentPlanMoreEverything, upgradePhoneChangePlanIndividual,
            upgradePhoneChangePlanShared, addNewDeviceToExistingAccountFamilySharedPlan,
            addNewDeviceToExistingAccountIndividualBusiness, addNewDeviceToExistingAccountNoPlan }
        public enum _ProtectionPlanType { none, SquareTradeDeviceProtection, AppleCareForIphone  }
        public enum _DeviceAccessories { none }
        public enum _AgreementType { agreeToContractExtension, agreeToContract }
        public enum _VerizonServicePlans {vzwMedium3GB, vzwLarge6GB, vzwXLarge12GB, vzw20GB, vzw25GB, vzw30GB, vzw40GB,
            vzw50GB, vzw60GB, vzw80GB,  vzw100GB,}
        public enum _Services { vzwMoreEverythingSmartphoneMonthlyLineAccess, vzwMoreEverythingSmartphoneMonthlyLineAccessRingbackTones,
        vzwMoreEverythingSmartphoneMonthlyLineAccessRingbackTonesVisualVoiceMail, vzwRequiredServiceFor3GAnd4GSmartphones,
            TheVerizonPlanSmartphoneLineAccess }
        public enum _CarrierName { verizon, sprint, tmobile, att }

        // Generic Actions
        #region ActivateLine()
        public static bool ActivateLine(string adminUsername, string adminPassword, string orderId, string imei, string sim, bool removeLine)
        {
            // Get the order details
            string orderDetailId = GetOrderDetailId(Globals._ServerName, Globals._DatabaseName, orderId);
            GetCheckoutReferenceNumber(Globals._ServerName, Globals._DatabaseName, orderId);

            // Update the database with the IMEI and SIM
            UpdateDeviceWithImeiAndSim(Globals._ServerName, Globals._DatabaseName, orderDetailId);
            UpdateOrderStatusToShowPaymentCompleted(Globals._ServerName, Globals._DatabaseName, orderId);

            // Begin the activation process
            Utilities.Log("** ActivateLine");

            // Open a new tab in the browser
            Globals._Driver.Navigate().GoToUrl("about:blank");
            Globals._Driver.Navigate().GoToUrl(Globals._BaseURL + "/admin");

            try
            {
                Utilities.Log("+ type username: " + adminUsername);
                Assert.IsTrue(Utilities.WaitForElement("username", SeleniumTests._By.name, Globals._DefaultTimeoutValue));
                Globals._Driver.FindElement(By.Name("username")).Clear();
                Globals._Driver.FindElement(By.Name("username")).SendKeys(adminUsername);

                Utilities.Log("+ type password: " + adminUsername);
                Globals._Driver.FindElement(By.Name("password")).Clear();
                Globals._Driver.FindElement(By.Name("password")).SendKeys("jcardon1");

                Utilities.Log("+ Enter order number: " + orderId);
                Globals._Driver.FindElement(By.CssSelector("a.button > span")).Click();
                Assert.IsTrue(Utilities.WaitForElement("orderId", SeleniumTests._By.id, Globals._DefaultTimeoutValue));
                Globals._Driver.FindElement(By.Id("orderId")).Clear();
                Globals._Driver.FindElement(By.Id("orderId")).SendKeys(orderId);
                Globals._Driver.FindElement(By.Id("submit")).Click();

                Utilities.Log("+ NavigateToDetailsTab");
                Globals._Driver.FindElement(By.Id("ui-id-2")).Click();

                // Get the IMEI and SIM from the page and compare them to the original to ensure they match
                Assert.IsTrue(Utilities.WaitForElement("//div[@id='tabs-2']/div/div/div[2]/div[2]/div[2]", SeleniumTests._By.xPath, Globals._DefaultTimeoutValue));
                string imeiOnPage = Globals._Driver.FindElement(By.XPath("//div[@id='tabs-2']/div/div/div[2]/div[2]/div[2]")).Text;
                imeiOnPage = imeiOnPage.Remove(0, 5);
                string simOnPage = Globals._Driver.FindElement(By.XPath("//div[@id='tabs-2']/div/div/div[2]/div[2]/div[3]")).Text;
                simOnPage = simOnPage.Remove(0, 5);
                Utilities.Log("+ imei: " + Globals._Imei + ", imeiOnPage: " + imeiOnPage + ", sim: " + Globals._Sim + ", simOnPage: " + simOnPage);
                if (imeiOnPage != imei)
                    Assert.Fail("IMEI does not match, original: " + imei + ", imeiOnPage: " + imeiOnPage);
                if (simOnPage != sim)
                    Assert.Fail("Sim doe not match, original: " + sim + ", simOnPage: " + simOnPage);

                // Navigate to the Activations tab
                Utilities.Log("+ NavigateToActivationsTab");
                Globals._Driver.FindElement(By.Id("ui-id-3")).Click();

                // For orders where the More Everything plan is invalid, (such as ALP), 
                // the service must be removed from the line before activating the device
                if (removeLine)
                {
                    Assert.IsTrue(Utilities.WaitForElement("Line 1", SeleniumTests._By.linkText, Globals._DefaultTimeoutValue));
                    Utilities.Log("+ RemoveLineForAlp");
                    Globals._Driver.FindElement(By.LinkText("Line 1")).Click();
                    Assert.IsTrue(Utilities.WaitForElement("Remove", SeleniumTests._By.linkText, Globals._DefaultTimeoutValue));
                    Globals._Driver.FindElement(By.LinkText("Remove")).Click();
                }

                // Click the Activate All button
                Utilities.Log("+ ActivateLine");
                Assert.IsTrue(Utilities.WaitForElement("autoActivationSubmit", SeleniumTests._By.id, Globals._DefaultTimeoutValue));
                Globals._Driver.FindElement(By.Id("autoActivationSubmit")).Click();

                // Wait for a period of time to give time for the service to respond
                //System.Threading.Thread.Sleep(10000);

                // Get the result message
                Assert.IsTrue(Utilities.WaitForElement("//div[@id='mid-col']/div/div/div/a/div", SeleniumTests._By.xPath, 240));
                string result = Globals._Driver.FindElement(By.XPath("//div[@id='mid-col']/div/div/div/a/div")).Text;
                Utilities.Log("+ Result of device activation:\r\n" + result);

                // Check for errors on the page
                Utilities.CheckForProblemsOnPage();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region AddDeviceToCart()
        public static bool AddDeviceToCart(string zipCode, _AccountType accountType)
        {
            Utilities.Log("** AddDeviceToCart");
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("Add to Cart", SeleniumTests._By.linkText, Globals._DefaultTimeoutValue));

                Globals._Driver.FindElement(By.LinkText("Add to Cart")).Click();
                switch(accountType)
                {
                    case _AccountType.upgradePhoneKeepCurrentPlanMoreEverything:
                        Utilities.Log("+ upgradePhoneKeepCurrentPlanMoreEverything");
                        Assert.IsTrue(Utilities.WaitForElement("upgrade-activation", SeleniumTests._By.id, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.Id("upgrade-activation")).Click();
                        ProceedToNextStep(zipCode);
                        UpgradeDeviceStep2();
                        break;
                    case _AccountType.addNewDeviceToExistingAccountFamilySharedPlan:
                        Utilities.Log("+ addNewDeviceToExistingAccountFamilySharedPlan");
                        Assert.IsTrue(Utilities.WaitForElement("aal-activation", _By.id, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.Id("aal-activation")).Click();
                        ProceedToNextStep(zipCode);
                        AddALineStep2();
                        break;
                    case _AccountType.newAccount:
                        Utilities.Log("+ newAccount");
                        Assert.IsTrue(Utilities.WaitForElement("new-activation", _By.id, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.Id("new-activation")).Click();
                        ProceedToNextStep(zipCode);
                        break;
                    default:
                        Utilities.Log("- No device selected");
                        break;
                }

                // Check for errors on the page
                Utilities.CheckForProblemsOnPage();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }
        }
        private static bool AddALineStep2()
        {
            Utilities.Log("** AddALineStep2");
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("aalFamily", _By.id, Globals._DefaultTimeoutValue));

                Globals._Driver.FindElement(By.Id("aalFamily")).Click();
                Globals._Driver.FindElement(By.Id("submit")).Click();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }
        }
        private static bool UpgradeDeviceStep2()
        {
            Utilities.Log("** UpgradeDeviceStep2");
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("upgradeType", SeleniumTests._By.name, Globals._DefaultTimeoutValue));
                Globals._Driver.FindElement(By.Name("upgradeType")).Click();
                Utilities.WaitForElement("chk_features_5324", SeleniumTests._By.id, Globals._DefaultTimeoutValue);
                Globals._Driver.FindElement(By.Id("chk_features_5324")).Click();
                Globals._Driver.FindElement(By.Id("nextBtn")).Click();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region AcceptAgreementTerms()
        public static bool AcceptAgreementTerms(_AgreementType agreement)
        {
            Utilities.Log("** AggreeTerms");
            try
            {
                if (agreement == _AgreementType.agreeToContractExtension)
                {
                    Utilities.Log("** agreeToContractExtension");
                    Assert.IsTrue(Utilities.WaitForElement("agreeToContractExtension", SeleniumTests._By.name, Globals._DefaultTimeoutValue));
                    Globals._Driver.FindElement(By.Name("agreeToContractExtension")).Click();
                }
                else
                {
                    Utilities.Log("+ agreeToContract");
                    Assert.IsTrue(Utilities.WaitForElement("agreeToContract", SeleniumTests._By.name, Globals._DefaultTimeoutValue));
                    Globals._Driver.FindElement(By.Name("agreeToContract")).Click();
                }

                Globals._Driver.FindElement(By.Name("agreeToCarrierTermsAndConditions")).Click();
                Globals._Driver.FindElement(By.Name("agreeToCustomerLetter")).Click();
                Globals._Driver.FindElement(By.LinkText("Continue")).Click();

                // Check for errors on the page
                Utilities.CheckForProblemsOnPage();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region AcknowledgeCompletionOfOrder()
        public static bool AcknowledgeCompletionOfOrder()
        {
            Utilities.Log("** AcknowledgeCompletionOfOrder");
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("input[type=\"submit\"]", SeleniumTests._By.cssSelector, 10));

                Globals._Driver.FindElement(By.CssSelector("input[type=\"submit\"]")).Click();

                // Check for errors on the page
                Utilities.CheckForProblemsOnPage();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region BillingAndShipping()
        public static bool BillingAndShipping(string emailAddress, string password, string firstName, string lasstName,
            string streetAddress, string city, string state, string zipCode)
        {
            Utilities.Log("** BillingAndShipping");
            try
            {
                // If the email address field is enabled and visible, proceed to type it in the field
                if (Utilities.IsElementPresent(By.Name("emailAddress")))
                {
                    // The page doesn't like an empty email address field and displays a warning, close it
                    try
                    {
                        try
                        {
                            // Clear the email address field to prevent appending and invalidating the email address
                            Globals._Driver.FindElement(By.Name("emailAddress")).Clear();
                            Assert.AreEqual("Please provide a valid email address.", Utilities.CloseAlertAndGetItsText());
                        }
                        catch (Exception)
                        {
                            // Raise exception and move on
                        }
                        Globals._Driver.FindElement(By.Id("txtEmailAddress")).Clear();
                        Globals._Driver.FindElement(By.Id("txtEmailAddress")).SendKeys("");

                        // Type the new email address and move to the next field, which triggers the password field to appear
                        Utilities.Log("+ type " + emailAddress);
                        Globals._Driver.FindElement(By.Name("emailAddress")).SendKeys(emailAddress);
                        Globals._Driver.FindElement(By.Id("txtBillingFirstName")).Clear();
                    }
                    catch (Exception)
                    {
                        // Otherwise raise an exception and move on
                    }
                }

                System.Threading.Thread.Sleep(2000);    // Sometimes it's a little slow to show the password field.  As a result, some of the password characters get eaten
                // If the Password field is visible, proceed to type it in the field
                if (Utilities.IsElementPresent(By.Name("existingUserPassword")))
                    {
                    try
                    {
                        // Sometimes a label appears stating the following "Checking your email address against our database.  Please wait.
                        while (Utilities.IsElementPresent(By.Id("progressLabel")))
                            System.Threading.Thread.Sleep(500);

                        Utilities.Log("+ type " + password);
                        Assert.IsFalse(!Globals._Driver.FindElement(By.Name("existingUserPassword")).Displayed);
                        Globals._Driver.FindElement(By.Name("existingUserPassword")).Clear();
                        Globals._Driver.FindElement(By.Name("existingUserPassword")).SendKeys(password);
                        Globals._Driver.FindElement(By.LinkText("Ok")).Click();
                    }
                    catch (Exception)
                    {
                        // Otherwise raise an exception and move on
                    }
                }

                // Populate the remaining fields
                string contactPhoneAreaCode;
                if (Globals._SplitString == null)
                    contactPhoneAreaCode = "425";
                else
                    contactPhoneAreaCode = Globals._SplitString[0];

                Utilities.Log("+ type " + firstName);
                Globals._Driver.FindElement(By.Id("txtBillingFirstName")).Clear();
                Globals._Driver.FindElement(By.Id("txtBillingFirstName")).SendKeys(firstName);
                Globals._Driver.FindElement(By.Id("txtBillingLastName")).Clear();
                Utilities.Log("+ type " + lasstName);
                Globals._Driver.FindElement(By.Id("txtBillingLastName")).SendKeys(lasstName);
                Globals._Driver.FindElement(By.Id("txtBillingAddress1")).Clear();
                Utilities.Log("+ type " + streetAddress);
                Globals._Driver.FindElement(By.Id("txtBillingAddress1")).SendKeys(streetAddress);
                Globals._Driver.FindElement(By.Id("txtBillingCity")).Clear();
                Utilities.Log("+ type " + city);
                Globals._Driver.FindElement(By.Id("txtBillingCity")).SendKeys(city);
                Utilities.Log("+ select " + state);
                new SelectElement(Globals._Driver.FindElement(By.Id("selBillingState"))).SelectByText(state);
                Globals._Driver.FindElement(By.Id("txtBillingZip")).Clear();
                Utilities.Log("+ type " + zipCode);
                Globals._Driver.FindElement(By.Id("txtBillingZip")).SendKeys(zipCode);
                Globals._Driver.FindElement(By.Id("txtBillingDayPhone")).Clear();
                Utilities.Log("+ type " + contactPhoneAreaCode + "-" + "788-1234");
                Globals._Driver.FindElement(By.Id("txtBillingDayPhone")).SendKeys(contactPhoneAreaCode + "-788-1234");
                Globals._Driver.FindElement(By.Id("txtBillingEvePhone")).Clear();
                Utilities.Log("+ type " + contactPhoneAreaCode + "-" + "788-1235");
                Globals._Driver.FindElement(By.Id("txtBillingEvePhone")).SendKeys(contactPhoneAreaCode + "-788-1235");
                Globals._Driver.FindElement(By.LinkText("Continue")).Click();

                // Check for errors on the page
                Utilities.CheckForProblemsOnPage();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region CardholderInfo()
        public static bool CardholderInfo(string cardNumber, string expireMonth, string expireYr, string cvv)
        {
            Utilities.Log("** CardholderInfo");
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("process", SeleniumTests._By.name, Globals._DefaultTimeoutValue));

                Globals._Driver.FindElement(By.Name("process")).Click();
                Utilities.WaitForElement("xxxCard_Number", SeleniumTests._By.id, Globals._DefaultTimeoutValue);
                Globals._Driver.FindElement(By.Id("xxxCard_Number")).Clear();
                Utilities.Log("+ type " + cardNumber);
                Globals._Driver.FindElement(By.Id("xxxCard_Number")).SendKeys(cardNumber);
                Globals._Driver.FindElement(By.Id("xxxCCMonth")).Clear();
                Utilities.Log("+ type " + expireMonth);
                Globals._Driver.FindElement(By.Id("xxxCCMonth")).SendKeys(expireMonth);
                Globals._Driver.FindElement(By.Id("xxxCCYear")).Clear();
                Utilities.Log("+ type " + expireYr);
                Globals._Driver.FindElement(By.Id("xxxCCYear")).SendKeys(expireYr);
                Globals._Driver.FindElement(By.Id("CVV2")).Clear();
                Utilities.Log("+ type " + cvv);
                Globals._Driver.FindElement(By.Id("CVV2")).SendKeys(cvv);
                Globals._Driver.FindElement(By.Name("process")).Click();

                // Check for errors on the page
                Utilities.CheckForProblemsOnPage();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region CarrierApplication()
        public static bool CarrierApplication(string last4Ssn, string state)
        {
            Utilities.Log("** CarrierApplication");
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("txtDOB", _By.id, Globals._DefaultTimeoutValue));

                Globals._Driver.FindElement(By.Id("txtDOB")).Clear();
                Globals._Driver.FindElement(By.Id("txtDOB")).SendKeys(Utilities.GetDate(-20));
                Globals._Driver.FindElement(By.Id("txtSSN")).Clear();
                Utilities.Log("+ type 555-55-" + last4Ssn);
                Globals._Driver.FindElement(By.Id("txtSSN")).SendKeys("555-55-" + last4Ssn);
                Globals._Driver.FindElement(By.Id("txtDriver")).Clear();
                string randomNumber = Utilities.RandNumberGenerator(9).ToString();
                Utilities.Log("+ type " + randomNumber);
                Globals._Driver.FindElement(By.Id("txtDriver")).SendKeys(randomNumber);    // we just need to send a random set of numbers
                Globals._Driver.FindElement(By.Id("txtDLExp")).Clear();
                string date = Utilities.GetDate(1);
                Utilities.Log("+ type " + date);
                Globals._Driver.FindElement(By.Id("txtDLExp")).SendKeys(date);
                Utilities.Log("+ select " + state);
                new SelectElement(Globals._Driver.FindElement(By.Name("dlState"))).SelectByText(state);
                Utilities.WaitForElement("Continue", _By.linkText, Globals._DefaultTimeoutValue);
                Utilities.Log("+ click Continue");
                Globals._Driver.FindElement(By.LinkText("Continue")).Click();

                // Check for errors on the page
                Utilities.CheckForProblemsOnPage();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region CartContinue()
        private static bool ProceedToNextStep(string zipCode)
        {
            Utilities.Log("** ProceedToNextStep");
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("zipCode", SeleniumTests._By.name, Globals._DefaultTimeoutValue));

                Globals._Driver.FindElement(By.Name("zipCode")).Clear();
                Globals._Driver.FindElement(By.Name("zipCode")).SendKeys(zipCode);
                Globals._Driver.FindElement(By.CssSelector("div.button-container > a.ActionButton > span")).Click();

                // Check for errors on the page
                Utilities.CheckForProblemsOnPage();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region CertRecovery
        public static bool CertRecovery()
        {
            Utilities.Log("** CertRecovery");
            try
            {
                Globals._Driver.Navigate().GoToUrl("javascript:document.getElementById('overridelink').click()");

                // Check for errors on the page
                Utilities.CheckForProblemsOnPage();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);

                return false;
            }
        }
        #endregion
        #region ChoosServicePlan()
        public static bool ChooseServicePlan(_VerizonServicePlans servicePlan)
        {
            Utilities.Log("** ChooseServicePlan");

            try
            {
                Assert.IsTrue(Utilities.WaitForElement("Choose a Service Plan", _By.linkText, Globals._DefaultTimeoutValue));
                Globals._Driver.FindElement(By.LinkText("Choose a Service Plan")).Click();
                Utilities.Log("+ " + servicePlan);

                switch(servicePlan)
                {
                    case _VerizonServicePlans.vzwMedium3GB:
                        Assert.IsTrue(Utilities.WaitForElement("//ul[@id='prodList']/li[2]/div[3]/div/div[4]/a/span", _By.xPath, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.XPath("//ul[@id='prodList']/li[2]/div[3]/div/div[4]/a/span")).Click();
                        break;
                    case _VerizonServicePlans.vzwLarge6GB:
                        Assert.IsTrue(Utilities.WaitForElement("//ul[@id='prodList']/li[3]/div[3]/div/div[4]/a/span", _By.xPath, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.XPath("//ul[@id='prodList']/li[3]/div[3]/div/div[4]/a/span")).Click();
                        break;
                    case _VerizonServicePlans.vzwXLarge12GB:
                        Assert.IsTrue(Utilities.WaitForElement("//ul[@id='prodList']/li[4]/div[3]/div/div[4]/a/span", _By.xPath, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.XPath("//ul[@id='prodList']/li[4]/div[3]/div/div[4]/a/span")).Click();
                        break;
                    case _VerizonServicePlans.vzw20GB:
                        Assert.IsTrue(Utilities.WaitForElement("//ul[@id='prodList']/li[5]/div[3]/div/div[4]/a/span", _By.xPath, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.XPath("//ul[@id='prodList']/li[5]/div[3]/div/div[4]/a/span")).Click();
                        break;
                    case _VerizonServicePlans.vzw25GB:
                        Assert.IsTrue(Utilities.WaitForElement("//ul[@id='prodList']/li[6]/div[3]/div/div[4]/a/span", _By.xPath, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.XPath("//ul[@id='prodList']/li[6]/div[3]/div/div[4]/a/span")).Click();
                        break;
                    case _VerizonServicePlans.vzw30GB:
                        Assert.IsTrue(Utilities.WaitForElement("//ul[@id='prodList']/li[7]/div[3]/div/div[4]/a/span", _By.xPath, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.XPath("//ul[@id='prodList']/li[7]/div[3]/div/div[4]/a/span")).Click();
                        break;
                    case _VerizonServicePlans.vzw40GB:
                        Assert.IsTrue(Utilities.WaitForElement("//ul[@id='prodList']/li[8]/div[3]/div/div[4]/a/span", _By.xPath, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.XPath("//ul[@id='prodList']/li[8]/div[3]/div/div[4]/a/span")).Click();
                        break;
                    case _VerizonServicePlans.vzw50GB:
                        Assert.IsTrue(Utilities.WaitForElement("//ul[@id='prodList']/li[9]/div[3]/div/div[4]/a/span", _By.xPath, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.XPath("//ul[@id='prodList']/li[9]/div[3]/div/div[4]/a/span")).Click();
                        break;
                    case _VerizonServicePlans.vzw60GB:
                        Assert.IsTrue(Utilities.WaitForElement("//ul[@id='prodList']/li[10]/div[3]/div/div[4]/a/span", _By.xPath, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.XPath("//ul[@id='prodList']/li[10]/div[3]/div/div[4]/a/span")).Click();
                        break;
                    case _VerizonServicePlans.vzw80GB:
                        Assert.IsTrue(Utilities.WaitForElement("//ul[@id='prodList']/li[11]/div[3]/div/div[4]/a/span", _By.xPath, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.XPath("//ul[@id='prodList']/li[11]/div[3]/div/div[4]/a/span")).Click();
                        break;
                    case _VerizonServicePlans.vzw100GB:
                        Assert.IsTrue(Utilities.WaitForElement("//ul[@id='prodList']/li[12]/div[3]/div/div[4]/a/span", _By.xPath, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.XPath("//ul[@id='prodList']/li[12]/div[3]/div/div[4]/a/span")).Click();
                        break;
                    default:
                        Assert.IsTrue(Utilities.WaitForElement("//ul[@id='prodList']/li/div[3]/div/div[4]/a/span", _By.xPath, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.XPath("//ul[@id='prodList']/li/div[3]/div/div[4]/a/span")).Click();
                        break;
                }

                // Check for errors on the page
                Utilities.CheckForProblemsOnPage();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region ClearCart()
        public static bool ClearCart()
        {
            Utilities.Log("** ClearCart");
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("lnkMyCart", SeleniumTests._By.id, Globals._DefaultTimeoutValue));

                Globals._Driver.FindElement(By.Id("lnkMyCart")).Click();
                Assert.IsTrue(Utilities.WaitForElement("//a[contains(text(),'Clear Cart')]", SeleniumTests._By.xPath, Globals._DefaultTimeoutValue));
                Globals._Driver.FindElement(By.XPath("//a[contains(text(),'Clear Cart')]")).Click();
                Assert.IsTrue(Regex.IsMatch(Utilities.CloseAlertAndGetItsText(), "^Are you sure you want to clear your cart[\\s\\S]$"));
                Globals._Driver.FindElement(By.LinkText("Close Cart")).Click();

                // Check for errors on the page
                Utilities.CheckForProblemsOnPage();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region GetCheckoutReferenceNumber()
        public static bool GetCheckoutReferenceNumber(string serverName, string databaseName, string orderId)
        {
            // Sample server name: 10.7.0.22
            // Sample database name: COSTCO.TEST

            Utilities.Log("** GetCheckoutReferenceNumber");
            try
            {
                string credentials = "";
                string trustedConnection = "";
                if (Globals._DatabaseUsername != "" && Globals._DatabasePassword != "")
                {
                    credentials = "user id=" + Globals._DatabaseUsername + ";password=" + Globals._DatabasePassword + ";";
                    trustedConnection = "";
                }
                else
                    trustedConnection = "Integrated Security=true";

                using (SqlConnection conn = new SqlConnection())
                {
                    conn.ConnectionString = credentials + "Data Source=" + serverName + ";Initial Catalog=" + databaseName + ";" + trustedConnection;
                    SqlCommand command = new SqlCommand("select CheckoutReferenceNumber from [COSTCO.TEST].[salesorder].[Order] where orderid = " + orderId, conn);

                    conn.Open();

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            object crn = reader[0];
                            Globals._CheckoutReferenceNumber = crn.ToString();
                            Utilities.Log("+ CheckoutReferenceNumber: " + crn.ToString());
                        }
                    }

                    //conn.Close(); leave the connection open for the next call
                }

                // Check for errors on the page
                Utilities.CheckForProblemsOnPage();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region GetOrderDetailId()
        public static string GetOrderDetailId(string serverName, string databaseName, string orderId)
        {
            // Sample server name: 10.7.0.22
            // Sample database name: COSTCO.TEST

            Utilities.Log("** GetOrderDetailId");
            try
            {
                string credentials = "";
                string trustedConnection = "";
                string orderDetailId = "";

                if (Globals._DatabaseUsername != "" && Globals._DatabasePassword != "")
                {
                    credentials = "user id=" + Globals._DatabaseUsername + ";password=" + Globals._DatabasePassword + ";";
                    trustedConnection = "";
                }
                else
                    trustedConnection = "Integrated Security=true";

                using (SqlConnection conn = new SqlConnection())
                {
                    conn.ConnectionString = credentials + "Data Source=" + serverName + ";Initial Catalog=" + databaseName + ";" + trustedConnection;
                    SqlCommand command = new SqlCommand("select OrderDetailId from salesorder.[OrderDetail] where orderid = " + orderId, conn);

                    conn.Open();

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            object odid = reader[0];
                            Globals._OrderDetailId = odid.ToString();
                            orderDetailId = odid.ToString();
                            Utilities.Log("+ OrderDetailId: " + orderDetailId);
                        }
                    }

                    //conn.Close();  Leave the database open for the next call
                }

                // Check for errors on the page
                Utilities.CheckForProblemsOnPage();

                return orderDetailId;
            }
            catch(Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return "";
            }
        }
        #endregion
        #region NavigateToSite()
        public static bool NavigateToSite(string url)
        {
            Utilities.Log("** NavigateToSite: " + url);
            try
            {
                Globals._Driver.Navigate().GoToUrl(url);
                Assert.IsTrue(Utilities.WaitForElement("lnkMyCart", SeleniumTests._By.id, 60));

                // Check for errors on the page
                Utilities.CheckForProblemsOnPage();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region ObtainNewMobileNumber()
        public static bool ObtainNewMobileNumber()
        {
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("newNumber_1", SeleniumTests._By.id, Globals._DefaultTimeoutValue));

                Utilities.Log("+ select New Number");
                Globals._Driver.FindElement(By.Id("newNumber_1")).Click();
                Globals._Driver.FindElement(By.LinkText("Continue")).Click();

                // Check for errors on the page
                Utilities.CheckForProblemsOnPage();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }

        }
        public static bool RetainCurrentMobileNumber(string currentNumber, string existingCarrier, string existingCarrierAccountNumber, string existingCarrierPin)
        {
            Utilities.Log("** KeepCurrentNumber");

            // Add dashes if they don't already exist so the data can be parsed
            if (!currentNumber.Contains("-") && currentNumber != "")
            {
                currentNumber = currentNumber.Insert(3, "-");
                currentNumber = currentNumber.Insert(7, "-");
            }

            string[] splitString;
            string splitCharacter = "-";
            char[] delimiter = splitCharacter.ToCharArray();
            splitString = currentNumber.Split(delimiter);

            try
            {
                Assert.IsTrue(Utilities.WaitForElement("sameNumber_1", SeleniumTests._By.id, Globals._DefaultTimeoutValue));

                Utilities.Log("+ type sameNumber");
                Globals._Driver.FindElement(By.Id("sameNumber_1")).Click();
                Globals._Driver.FindElement(By.Id("areacode1")).Clear();
                Utilities.Log("+ type " + splitString[0]);
                Globals._Driver.FindElement(By.Id("areacode1")).SendKeys(splitString[0]);
                Globals._Driver.FindElement(By.Id("lnp1")).Clear();
                Utilities.Log("+ type " + splitString[1]);
                Globals._Driver.FindElement(By.Id("lnp1")).SendKeys(splitString[1]);
                Globals._Driver.FindElement(By.Id("lastfour1")).Clear();
                Utilities.Log("+ type " + splitString[2]);
                Globals._Driver.FindElement(By.Id("lastfour1")).SendKeys(splitString[2]);
                Utilities.Log("+ select " + existingCarrier);
                new SelectElement(Globals._Driver.FindElement(By.Id("portInCurrentCarrier1"))).SelectByText(existingCarrier);
                Globals._Driver.FindElement(By.Id("portInCurrentCarrierAccountNumber1")).Clear();
                Utilities.Log("+ type " + existingCarrierAccountNumber);
                Globals._Driver.FindElement(By.Id("portInCurrentCarrierAccountNumber1")).SendKeys(existingCarrierAccountNumber);
                Globals._Driver.FindElement(By.Id("portInCurrentCarrierPin1")).Clear();
                Utilities.Log("+ type " + existingCarrierPin);
                Globals._Driver.FindElement(By.Id("portInCurrentCarrierPin1")).SendKeys(existingCarrierPin);
                Assert.IsTrue(Utilities.WaitForElement("Continue", SeleniumTests._By.linkText, Globals._DefaultTimeoutValue));
                Globals._Driver.FindElement(By.LinkText("Continue")).Click();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();
    
                return false;
            }
        }
        #endregion
        #region ProceedToCheckout()
        public static bool ProceedToCheckout()
        {
            Utilities.Log("** ProceedToCheckout");
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("a.ActionButton > span", SeleniumTests._By.cssSelector, Globals._DefaultTimeoutValue));
                Globals._Driver.FindElement(By.CssSelector("a.ActionButton > span")).Click();

                // Check for errors on the page
                Utilities.CheckForProblemsOnPage();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region ReviewCart()
        public static bool ReviewCart()
        {
            Utilities.Log("** ReviewCart");
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("Cart Review", SeleniumTests._By.linkText, Globals._DefaultTimeoutValue));
                Globals._Driver.FindElement(By.LinkText("Cart Review")).Click();

                // Check for errors on the page
                Utilities.CheckForProblemsOnPage();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region ReviewOrder()
        public static bool ReviewOrder()
        {
            Utilities.Log("** ReviewOrder");
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("Continue", SeleniumTests._By.linkText, Globals._DefaultTimeoutValue));

                Globals._Driver.FindElement(By.LinkText("Continue")).Click();

                // Check for errors on the page
                Utilities.CheckForProblemsOnPage();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region ReviewPayment()
        public static bool ReviewPayment(string name, string streetAddress, string city, string state, string zipCode, string phone, string email)
        {
            Utilities.Log("** ReviewPayment");

            try
            {
                Assert.IsTrue(Utilities.WaitForElement("xxxName", SeleniumTests._By.name, Globals._DefaultTimeoutValue));

                Globals._Driver.FindElement(By.Name("xxxName")).Clear();
                Utilities.Log("+ type " + name);
                Globals._Driver.FindElement(By.Name("xxxName")).SendKeys(name);
                Globals._Driver.FindElement(By.Name("xxxAddress")).Clear();
                Utilities.Log("+ type " + streetAddress);
                Globals._Driver.FindElement(By.Name("xxxAddress")).SendKeys(streetAddress);
                Globals._Driver.FindElement(By.Name("xxxCity")).Clear();
                Utilities.Log("+ type " + city);
                Globals._Driver.FindElement(By.Name("xxxCity")).SendKeys(city);
                Globals._Driver.FindElement(By.Name("xxxZipcode")).Clear();
                Utilities.Log("+ select " + state);
                new SelectElement(Globals._Driver.FindElement(By.Name("xxxState"))).SelectByText(state);
                Globals._Driver.FindElement(By.Name("xxxZipcode")).SendKeys(zipCode);
                Globals._Driver.FindElement(By.Name("xxxPhone")).Clear();
                Utilities.Log("+ type " + phone);
                Globals._Driver.FindElement(By.Name("xxxPhone")).SendKeys(phone);
                Globals._Driver.FindElement(By.Name("xxxEmail")).Clear();
                Utilities.Log("+ type " + email);
                Globals._Driver.FindElement(By.Name("xxxEmail")).SendKeys(email);
                //Globals._Driver.FindElement(By.LinkText("Continue")).Click();
                Globals._Driver.FindElement(By.Name("process")).Click();

                // Check for errors on the page
                Utilities.CheckForProblemsOnPage();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region SelectDeviceAccessories()
        public static bool SelectDeviceAccessories(_DeviceAccessories deviceType)
        {
            Utilities.Log("** SelectDeviceAccessories");
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("No Thanks", SeleniumTests._By.linkText, Globals._DefaultTimeoutValue));

                if (deviceType == _DeviceAccessories.none)
                    Globals._Driver.FindElement(By.LinkText("No Thanks")).Click();

                // Check for errors on the page
                Utilities.CheckForProblemsOnPage();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region SelectPhone()
        public static bool SelectPhone(string phoneId, string phoneName)
        {
            Utilities.Log("** SelectPhone");
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("(//div[@onclick=\"window.location.href ='/" + phoneId + "/" + phoneName + "'\"])[2]", SeleniumTests._By.xPath, Globals._DefaultTimeoutValue));
                Globals._Driver.FindElement(By.XPath("(//div[@onclick=\"window.location.href ='/" + phoneId + "/" + phoneName + "'\"])[2]")).Click();
                if (Utilities.WaitForElement("Add to Cart", SeleniumTests._By.linkText, Globals._DefaultTimeoutValue))
                    return true;
                else
                    return false;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region SelectProtectionPlan()
        public static bool SelectProtectionPlan(_ProtectionPlanType planType)
        {
            Utilities.Log("** SelectProtectionPlan");
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("AddProtectionPlan", SeleniumTests._By.name, Globals._DefaultTimeoutValue));

                switch (planType)
                {
                    case _ProtectionPlanType.SquareTradeDeviceProtection:
                        // Not yet implemented
                        Globals._Driver.FindElement(By.Id("AddProtectionPlan_10048")).Click();
                        break;
                    case _ProtectionPlanType.AppleCareForIphone:
                        // Not yet implemented
                        Globals._Driver.FindElement(By.Id("AddProtectionPlan_26039")).Click();
                        break;
                    default:    //None
                        Globals._Driver.FindElement(By.Name("AddProtectionPlan")).Click();
                        break;
                }

                // Check for errors on the page
                Utilities.CheckForProblemsOnPage();

                return true;
            }
            catch(Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region SelectDeviceServices()
        public static bool SelectDeviceServices(_Services service)
        {
            Utilities.Log("** SelectDeviceServices");
            string serviceLinkText = "Select Services for this ";

            // The link in the cart will vary depending on the plan selected and scenario being executed.  Here we
            // try selecting the first link, and if not available, try the next.
            if (Utilities.WaitForElement("Select Services for this Line", _By.linkText, 3))
                serviceLinkText += "Line";
            else if (Utilities.WaitForElement("Select Services for this Plan", _By.linkText, 3))
                serviceLinkText += "Plan";

            try
            {
                Assert.IsTrue(Utilities.WaitForElement(serviceLinkText, _By.linkText, Globals._DefaultTimeoutValue));

                //To Do: Provide methods to select each available service
                Globals._Driver.FindElement(By.LinkText(serviceLinkText)).Click();
                Utilities.Log("+ " + service);

                switch (service)
                {
                    case _Services.vzwRequiredServiceFor3GAnd4GSmartphones:
                        Assert.IsTrue(Utilities.WaitForElement("chk_features_46598", _By.id, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.Id("chk_features_46598")).Click();
                        break;
                    case _Services.vzwMoreEverythingSmartphoneMonthlyLineAccessRingbackTones:
                        Assert.IsTrue(Utilities.WaitForElement("chk_features_5324", _By.id, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.Id("chk_features_5324")).Click();
                        Globals._Driver.FindElement(By.Id("chk_features_453")).Click();
                        break;
                    case _Services.vzwMoreEverythingSmartphoneMonthlyLineAccessRingbackTonesVisualVoiceMail:
                        Assert.IsTrue(Utilities.WaitForElement("chk_features_5324", _By.id, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.Id("chk_features_5324")).Click();
                        Globals._Driver.FindElement(By.Id("chk_features_453")).Click();
                        Globals._Driver.FindElement(By.Id("chk_features_481")).Click();
                        break;
                    case _Services.TheVerizonPlanSmartphoneLineAccess:
                        Assert.IsTrue(Utilities.WaitForElement("chk_features_46598", _By.id, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.Id("chk_features_46598")).Click();
                        break;
                    default:
                        Assert.IsTrue(Utilities.WaitForElement("chk_features_5324", _By.id, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.Id("chk_features_5324")).Click();
                        break;
                }

                Globals._Driver.FindElement(By.LinkText("Add Selected Services")).Click();

                // Check for errors on the page
                Utilities.CheckForProblemsOnPage();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region UpdateOrderStatusToShowPaymentCompleted()
        public static bool UpdateOrderStatusToShowPaymentCompleted(string serverName, string databaseName, string orderId)
        {
            // Sample server name: 10.7.0.22
            // Sample database name: COSTCO.TEST

            Utilities.Log("** UpdateOrderStatusToShowPaymentCompleted");
            try
            {
                string credentials = "";
                string trustedConnection = "";
                if (Globals._DatabaseUsername != "" && Globals._DatabasePassword != "")
                {
                    credentials = "user id=" + Globals._DatabaseUsername + ";password=" + Globals._DatabasePassword + ";";
                    trustedConnection = "";
                }
                else
                    trustedConnection = "Integrated Security=true";

                using (SqlConnection conn = new SqlConnection())
                {
                    conn.ConnectionString = credentials + "Data Source=" + serverName + ";Initial Catalog=" + databaseName + ";" + trustedConnection;
                    SqlCommand command = new SqlCommand("UPDATE salesorder.[Order] SET Status = 2 Where orderid = " + orderId, conn);

                    conn.Open();

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        Utilities.Log("+ Device status updated: 2");
                    }

                    conn.Close();   // Close the connection now that we're finished with it
                }

                // Check for errors on the page
                Utilities.CheckForProblemsOnPage();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region UpdateDeviceWithImeiAndSim()
        public static bool UpdateDeviceWithImeiAndSim(string serverName, string databaseName, string orderDetailId)
        {
            // Sample server name: 10.7.0.22
            // Sample database name: COSTCO.TEST

            Utilities.Log("** UpdateDeviceWithImeiAndSim");
            try
            {
                string credentials = "";
                string trustedConnection = "";
                if (Globals._DatabaseUsername != "" && Globals._DatabasePassword != "")
                {
                    credentials = "user id=" + Globals._DatabaseUsername + ";password=" + Globals._DatabasePassword + ";";
                    trustedConnection = "";
                }
                else
                    trustedConnection = "Integrated Security=true";

                using (SqlConnection conn = new SqlConnection())
                {
                    conn.ConnectionString = credentials + "Data Source=" + serverName + ";Initial Catalog=" + databaseName + ";" + trustedConnection;
                    SqlCommand command = new SqlCommand("UPDATE salesorder.WirelessLine SET IMEI = '" + Globals._Imei + "', SIM = '" + 
                        Globals._Sim + "' WHERE orderdetailid = " + orderDetailId, conn);

                    conn.Open();

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        Utilities.Log("+ Device updated with IMEI: " + Globals._Imei + ", and SIM: " + Globals._Sim);
                    }

                    //conn.Close();  leave the connection open for the next call
                }

                // Check for errors on the page
                Utilities.CheckForProblemsOnPage();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region VerizonAccountLookup()
        public static bool VerizonAccountLookup(string mdn, string last4Ssn, string zipCode, string password)
        {
            Utilities.Log("** Checkout");

            // Add dashes if they don't already exist so the data can be parsed
            if (!mdn.Contains("-"))
            {
                mdn = mdn.Insert(3, "-");
                mdn = mdn.Insert(7, "-");
            }

            string splitCharacter = "-";
            char[] delimiter = splitCharacter.ToCharArray();
            Globals._SplitString = mdn.Split(delimiter);

            try
            {
                Assert.IsTrue(Utilities.WaitForElement("areacode", SeleniumTests._By.id, Globals._DefaultTimeoutValue));
                Globals._Driver.FindElement(By.Id("areacode")).Clear();
                Utilities.Log("+ type " + Globals._SplitString[0]);
                Globals._Driver.FindElement(By.Id("areacode")).SendKeys(Globals._SplitString[0]);
                Globals._Driver.FindElement(By.Id("lnp")).Clear();
                Utilities.Log("+ type " + Globals._SplitString[1]);
                Globals._Driver.FindElement(By.Id("lnp")).SendKeys(Globals._SplitString[1]);
                Globals._Driver.FindElement(By.Id("lastfour")).Clear();
                Utilities.Log("+ type " + Globals._SplitString[2]);
                Globals._Driver.FindElement(By.Id("lastfour")).SendKeys(Globals._SplitString[2]);
                Globals._Driver.FindElement(By.Id("txtPin")).Clear();
                Utilities.Log("+ type " + last4Ssn);
                Globals._Driver.FindElement(By.Id("txtPin")).SendKeys(last4Ssn);
                Globals._Driver.FindElement(By.Id("billingZip")).Clear();
                Utilities.Log("+ type " + zipCode);
                Globals._Driver.FindElement(By.Id("billingZip")).SendKeys(zipCode);
                Globals._Driver.FindElement(By.Id("accountPassword")).Clear();
                Utilities.Log("+ type " + password);
                Globals._Driver.FindElement(By.Id("accountPassword")).SendKeys(password);
                Globals._Driver.FindElement(By.LinkText("Continue")).Click();

                // Check for errors on the page
                Utilities.CheckForProblemsOnPage();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }
        }
        #endregion

        // Direct Delivery Actions
        #region ddSignInToDirectDelivery()
        public static bool ddSignInToDirectDelivery()
        {
            Utilities.Log("** SelectPhone");
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("loginButton", SeleniumTests._By.id, Globals._DefaultTimeoutValue));

                Globals._Driver.FindElement(By.Id("loginButton")).Click();

                // Check for errors on the page
                Utilities.CheckForProblemsOnPage();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region ddSelectCarrier()
        public static bool ddSelectCarrier(_CarrierName carrier)
        {
            Utilities.Log("** SelectPhone");
            try
            {
                switch (carrier)
                {
                    case _CarrierName.att:
                        Assert.IsTrue(Utilities.WaitForElement("div.carrier-box > img", SeleniumTests._By.cssSelector, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.CssSelector("div.carrier-box > img")).Click();
                        break;
                    case _CarrierName.sprint:
                        Assert.IsTrue(Utilities.WaitForElement("a[alt=\"Shop for Sprint Phones\"] > div.carrier-box", SeleniumTests._By.cssSelector, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.CssSelector("a[alt=\"Shop for Sprint Phones\"] > div.carrier-box")).Click();
                        break;
                    case _CarrierName.tmobile:
                        Assert.IsTrue(Utilities.WaitForElement("a[alt=\"Shop for T-Mobile Phones\"] > div.carrier-box", SeleniumTests._By.cssSelector, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.CssSelector("a[alt=\"Shop for T-Mobile Phones\"] > div.carrier-box")).Click();
                        break;
                    default:
                        Assert.IsTrue(Utilities.WaitForElement("a[alt=\"Shop for Verizon Wireless Phones\"] > div.carrier-box > img", SeleniumTests._By.cssSelector, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.CssSelector("a[alt=\"Shop for Verizon Wireless Phones\"] > div.carrier-box > img")).Click();
                        break;
                }

                // Check for errors on the page
                Utilities.CheckForProblemsOnPage();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("- " + e.Message);
                Assert.Fail();

                return false;
            }
        }
        #endregion
    }
}