using System;
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
        public enum _ServicePlan { vzw500MBMoreEverythingUnlimitedTalkText, vzw1GBMoreEverythingUnlimitedTalkText,
            vzw2GBMoreEverythingUnlimitedTalkText, vzw3GBMoreEverythingUnlimitedTalkText, vzw1GBPromotionalUnlimitedTalkTextForSmartphones,
            vzw4GBMoreEverythingUnlimitedTalkText, vzw6GBMoreEverythingUnlimitedTalkText, vzw2GBPromotionalUnlimitedTalkTextForSmartphones,
            vzw10GBMoreEverythingUnlimitedTalkText, vzw15GBMoreEverythingUnlimitedTalkText, vzw20GBMoreEverythingUnlimitedTalkText, 
            vzw30GBMoreEverythingUnlimitedTalkText, vzw40GBMoreEverythingUnlimitedTalkText, vzw50GBMoreEverythingUnlimitedTalkText}
        public enum _Services { vzwMoreEverythingSmartphoneMonthlyLineAccess, vzwMoreEverythingSmartphoneMonthlyLineAccessRingbackTones,
        vzwMoreEverythingSmartphoneMonthlyLineAccessRingbackTonesVisualVoiceMail }
        public enum _CarrierName { verizon, sprint, tmobile, att }

        // Generic Actions
        #region AddDeviceToCart()
        public static bool AddDeviceToCart(string zipCode, _AccountType accountType)
        {
            Utilities.Log("++ AddDeviceToCart", false);
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("Add to Cart", SeleniumTests._By.linkText, Globals._DefaultTimeoutValue));

                Globals._Driver.FindElement(By.LinkText("Add to Cart")).Click();
                switch(accountType)
                {
                    case _AccountType.upgradePhoneKeepCurrentPlanMoreEverything:
                        Utilities.Log("+ upgradePhoneKeepCurrentPlanMoreEverything", false);
                        Assert.IsTrue(Utilities.WaitForElement("upgrade-activation", SeleniumTests._By.id, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.Id("upgrade-activation")).Click();
                        ProceedToNextStep(zipCode);
                        UpgradeDeviceStep2();
                        break;
                    case _AccountType.addNewDeviceToExistingAccountFamilySharedPlan:
                        Utilities.Log("+ addNewDeviceToExistingAccountFamilySharedPlan", false);
                        Assert.IsTrue(Utilities.WaitForElement("aal-activation", _By.id, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.Id("aal-activation")).Click();
                        ProceedToNextStep(zipCode);
                        AddALineStep2();
                        break;
                    case _AccountType.newAccount:
                        Utilities.Log("+ newAccount", false);
                        Assert.IsTrue(Utilities.WaitForElement("new-activation", _By.id, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.Id("new-activation")).Click();
                        ProceedToNextStep(zipCode);
                        break;
                    default:
                        Utilities.Log("- No device selected", false);
                        break;
                }

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("-- " + e.Message, false);
                Assert.Fail();

                return false;
            }
        }
        private static bool AddALineStep2()
        {
            Utilities.Log("++ AddALineStep2", false);
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("aalFamily", _By.id, Globals._DefaultTimeoutValue));

                Globals._Driver.FindElement(By.Id("aalFamily")).Click();
                Globals._Driver.FindElement(By.Id("submit")).Click();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("-- " + e.Message, false);
                Assert.Fail();

                return false;
            }
        }
        private static bool UpgradeDeviceStep2()
        {
            Utilities.Log("++ UpgradeDeviceStep2", false);
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
                Utilities.Log("-- " + e.Message, false);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region AcceptAgreementTerms()
        public static bool AcceptAgreementTerms(_AgreementType agreement)
        {
            Utilities.Log("++ AggreeTerms", false);
            try
            {
                if (agreement == _AgreementType.agreeToContractExtension)
                {
                    Utilities.Log("++ agreeToContractExtension", false);
                    Assert.IsTrue(Utilities.WaitForElement("agreeToContractExtension", SeleniumTests._By.name, Globals._DefaultTimeoutValue));
                    Globals._Driver.FindElement(By.Name("agreeToContractExtension")).Click();
                }
                else
                {
                    Utilities.Log("+ agreeToContract", false);
                    Assert.IsTrue(Utilities.WaitForElement("agreeToContract", SeleniumTests._By.name, Globals._DefaultTimeoutValue));
                    Globals._Driver.FindElement(By.Name("agreeToContract")).Click();
                }

                Globals._Driver.FindElement(By.Name("agreeToCarrierTermsAndConditions")).Click();
                Globals._Driver.FindElement(By.Name("agreeToCustomerLetter")).Click();
                Globals._Driver.FindElement(By.LinkText("Continue")).Click();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("-- " + e.Message, false);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region AcknowledgeCompletionOfOrder()
        public static bool AcknowledgeCompletionOfOrder()
        {
            Utilities.Log("++ AcknowledgeCompletionOfOrder", false);
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("input[type=\"submit\"]", SeleniumTests._By.cssSelector, 10));

                Globals._Driver.FindElement(By.CssSelector("input[type=\"submit\"]")).Click();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("-- " + e.Message, false);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region BillingAndShipping()
        public static bool BillingAndShipping(string emailAddress, string password, string firstName, string lasstName,
            string streetAddress, string city, string state, string zipCode)
        {
            Utilities.Log("++ BillingAndShipping", false);
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("emailAddress", SeleniumTests._By.name, Globals._DefaultTimeoutValue));

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
                        Utilities.Log("+ type " + emailAddress, false);
                        Globals._Driver.FindElement(By.Name("emailAddress")).SendKeys(emailAddress);
                        Globals._Driver.FindElement(By.Id("txtBillingFirstName")).Clear();
                    }
                    catch (Exception)
                    {
                        // Otherwise raise an exception and move on
                    }
                }

                // If the Password field is visible, proceed to type it in the field
                Assert.IsTrue(Utilities.WaitForElement("existingUserPassword", SeleniumTests._By.name, Globals._DefaultTimeoutValue));
                try
                {
                    System.Threading.Thread.Sleep(1000);    // Sometimes it's a little slow to show the password field.  As a result, some of the password characters get eaten
                    Utilities.Log("+ type " + password, false);
                    Assert.IsFalse(!Globals._Driver.FindElement(By.Name("existingUserPassword")).Displayed);
                    Globals._Driver.FindElement(By.Name("existingUserPassword")).Clear();
                    Globals._Driver.FindElement(By.Name("existingUserPassword")).SendKeys(password);
                    Globals._Driver.FindElement(By.LinkText("Ok")).Click();
                }
                catch (Exception)
                {
                    // Otherwise raise an exception and move on
                }

                // Populate the remaining fields
                string contactPhoneAreaCode;
                if (Globals._SplitString == null)
                    contactPhoneAreaCode = "425";
                else
                    contactPhoneAreaCode = Globals._SplitString[0];

                Utilities.Log("+ type " + firstName, false);
                Globals._Driver.FindElement(By.Id("txtBillingFirstName")).Clear();
                Globals._Driver.FindElement(By.Id("txtBillingFirstName")).SendKeys(firstName);
                Globals._Driver.FindElement(By.Id("txtBillingLastName")).Clear();
                Utilities.Log("+ type " + lasstName, false);
                Globals._Driver.FindElement(By.Id("txtBillingLastName")).SendKeys(lasstName);
                Globals._Driver.FindElement(By.Id("txtBillingAddress1")).Clear();
                Utilities.Log("+ type " + streetAddress, false);
                Globals._Driver.FindElement(By.Id("txtBillingAddress1")).SendKeys(streetAddress);
                Globals._Driver.FindElement(By.Id("txtBillingCity")).Clear();
                Utilities.Log("+ type " + city, false);
                Globals._Driver.FindElement(By.Id("txtBillingCity")).SendKeys(city);
                Utilities.Log("+ select " + state, false);
                new SelectElement(Globals._Driver.FindElement(By.Id("selBillingState"))).SelectByText(state);
                Globals._Driver.FindElement(By.Id("txtBillingZip")).Clear();
                Utilities.Log("+ type " + zipCode, false);
                Globals._Driver.FindElement(By.Id("txtBillingZip")).SendKeys(zipCode);
                Globals._Driver.FindElement(By.Id("txtBillingDayPhone")).Clear();
                Utilities.Log("+ type " + contactPhoneAreaCode + "-" + "788-1234", false);
                Globals._Driver.FindElement(By.Id("txtBillingDayPhone")).SendKeys(contactPhoneAreaCode + "-788-1234");
                Globals._Driver.FindElement(By.Id("txtBillingEvePhone")).Clear();
                Utilities.Log("+ type " + contactPhoneAreaCode + "-" + "788-1235", false);
                Globals._Driver.FindElement(By.Id("txtBillingEvePhone")).SendKeys(contactPhoneAreaCode + "-788-1235");
                Globals._Driver.FindElement(By.LinkText("Continue")).Click();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("-- " + e.Message, false);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region CardholderInfo()
        public static bool CardholderInfo(string cardNumber, string expireMonth, string expireYr, string cvv)
        {
            Utilities.Log("++ CardholderInfo", false);
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("process", SeleniumTests._By.name, Globals._DefaultTimeoutValue));

                Globals._Driver.FindElement(By.Name("process")).Click();
                Utilities.WaitForElement("xxxCard_Number", SeleniumTests._By.id, Globals._DefaultTimeoutValue);
                Globals._Driver.FindElement(By.Id("xxxCard_Number")).Clear();
                Utilities.Log("+ type " + cardNumber, false);
                Globals._Driver.FindElement(By.Id("xxxCard_Number")).SendKeys(cardNumber);
                Globals._Driver.FindElement(By.Id("xxxCCMonth")).Clear();
                Utilities.Log("+ type " + expireMonth, false);
                Globals._Driver.FindElement(By.Id("xxxCCMonth")).SendKeys(expireMonth);
                Globals._Driver.FindElement(By.Id("xxxCCYear")).Clear();
                Utilities.Log("+ type " + expireYr, false);
                Globals._Driver.FindElement(By.Id("xxxCCYear")).SendKeys(expireYr);
                Globals._Driver.FindElement(By.Id("CVV2")).Clear();
                Utilities.Log("+ type " + cvv, false);
                Globals._Driver.FindElement(By.Id("CVV2")).SendKeys(cvv);
                Globals._Driver.FindElement(By.Name("process")).Click();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("-- " + e.Message, false);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region CarrierApplication()
        public static bool CarrierApplication(string last4Ssn, string state)
        {
            Utilities.Log("++ CarrierApplication", false);
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("txtDOB", _By.id, Globals._DefaultTimeoutValue));

                Globals._Driver.FindElement(By.Id("txtDOB")).Clear();
                Globals._Driver.FindElement(By.Id("txtDOB")).SendKeys(Utilities.GetDate(-20));
                Globals._Driver.FindElement(By.Id("txtSSN")).Clear();
                Utilities.Log("+ type 555-55-" + last4Ssn, false);
                Globals._Driver.FindElement(By.Id("txtSSN")).SendKeys("555-55-" + last4Ssn);
                Globals._Driver.FindElement(By.Id("txtDriver")).Clear();
                Utilities.Log("+ type 19028347129", false);
                Globals._Driver.FindElement(By.Id("txtDriver")).SendKeys("19028347129");    // we just need to sent a random set of numbers
                Globals._Driver.FindElement(By.Id("txtDLExp")).Clear();
                string date = Utilities.GetDate(1);
                Utilities.Log("+ type " + date, false);
                Globals._Driver.FindElement(By.Id("txtDLExp")).SendKeys(date);
                Utilities.Log("+ select " + state, false);
                new SelectElement(Globals._Driver.FindElement(By.Name("dlState"))).SelectByText(state);
                Utilities.WaitForElement("Continue", _By.linkText, Globals._DefaultTimeoutValue);
                Utilities.Log("+ click Continue", false);
                Globals._Driver.FindElement(By.LinkText("Continue")).Click();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("-- " + e.Message, false);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region CartContinue()
        private static bool ProceedToNextStep(string zipCode)
        {
            Utilities.Log("++ ProceedToNextStep", false);
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("zipCode", SeleniumTests._By.name, Globals._DefaultTimeoutValue));

                Globals._Driver.FindElement(By.Name("zipCode")).Clear();
                Globals._Driver.FindElement(By.Name("zipCode")).SendKeys(zipCode);
                Globals._Driver.FindElement(By.CssSelector("div.button-container > a.ActionButton > span")).Click();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("-- " + e.Message, false);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region CertRecovery
        public static bool CertRecovery()
        {
            Utilities.Log("++ CertRecovery", false);
            try
            {
                Globals._Driver.Navigate().GoToUrl("javascript:document.getElementById('overridelink').click()");

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("-- " + e.Message, false);

                return false;
            }
        }
        #endregion
        #region ChoosServicePlan()
        public static bool ChooseServicePlan(_ServicePlan servicePlan)
        {
            Utilities.Log("++ ChooseServicePlan", false);

            try
            {
                Assert.IsTrue(Utilities.WaitForElement("Choose a Service Plan", _By.linkText, Globals._DefaultTimeoutValue));
                Globals._Driver.FindElement(By.LinkText("Choose a Service Plan")).Click();
                Utilities.Log("+ " + servicePlan, false);

                switch(servicePlan)
                {
                    case _ServicePlan.vzw1GBMoreEverythingUnlimitedTalkText:
                        Assert.IsTrue(Utilities.WaitForElement("//ul[@id='prodList']/li[2]/div[3]/div/div[4]/a/span", _By.xPath, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.XPath("//ul[@id='prodList']/li[2]/div[3]/div/div[4]/a/span")).Click();
                        break;
                    case _ServicePlan.vzw2GBMoreEverythingUnlimitedTalkText:
                        Assert.IsTrue(Utilities.WaitForElement("//ul[@id='prodList']/li[3]/div[3]/div/div[4]/a/span", _By.xPath, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.XPath("//ul[@id='prodList']/li[3]/div[3]/div/div[4]/a/span")).Click();
                        break;
                    case _ServicePlan.vzw3GBMoreEverythingUnlimitedTalkText:
                        Assert.IsTrue(Utilities.WaitForElement("//ul[@id='prodList']/li[4]/div[3]/div/div[4]/a/span", _By.xPath, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.XPath("//ul[@id='prodList']/li[4]/div[3]/div/div[4]/a/span")).Click();
                        break;
                    case _ServicePlan.vzw1GBPromotionalUnlimitedTalkTextForSmartphones:
                        Assert.IsTrue(Utilities.WaitForElement("//ul[@id='prodList']/li[5]/div[3]/div/div[4]/a/span", _By.xPath, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.XPath("//ul[@id='prodList']/li[5]/div[3]/div/div[4]/a/span")).Click();
                        break;
                    case _ServicePlan.vzw4GBMoreEverythingUnlimitedTalkText:
                        Assert.IsTrue(Utilities.WaitForElement("//ul[@id='prodList']/li[6]/div[3]/div/div[4]/a/span", _By.xPath, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.XPath("//ul[@id='prodList']/li[6]/div[3]/div/div[4]/a/span")).Click();
                        break;
                    case _ServicePlan.vzw6GBMoreEverythingUnlimitedTalkText:
                        Assert.IsTrue(Utilities.WaitForElement("//ul[@id='prodList']/li[7]/div[3]/div/div[4]/a/span", _By.xPath, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.XPath("//ul[@id='prodList']/li[7]/div[3]/div/div[4]/a/span")).Click();
                        break;
                    case _ServicePlan.vzw2GBPromotionalUnlimitedTalkTextForSmartphones:
                        Assert.IsTrue(Utilities.WaitForElement("//ul[@id='prodList']/li[8]/div[3]/div/div[4]/a/span", _By.xPath, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.XPath("//ul[@id='prodList']/li[8]/div[3]/div/div[4]/a/span")).Click();
                        break;
                    case _ServicePlan.vzw10GBMoreEverythingUnlimitedTalkText:
                        Assert.IsTrue(Utilities.WaitForElement("//ul[@id='prodList']/li[9]/div[3]/div/div[4]/a/span", _By.xPath, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.XPath("//ul[@id='prodList']/li[9]/div[3]/div/div[4]/a/span")).Click();
                        break;
                    case _ServicePlan.vzw15GBMoreEverythingUnlimitedTalkText:
                        Assert.IsTrue(Utilities.WaitForElement("//ul[@id='prodList']/li[10]/div[3]/div/div[4]/a/span", _By.xPath, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.XPath("//ul[@id='prodList']/li[10]/div[3]/div/div[4]/a/span")).Click();
                        break;
                    case _ServicePlan.vzw20GBMoreEverythingUnlimitedTalkText:
                        Assert.IsTrue(Utilities.WaitForElement("//ul[@id='prodList']/li[11]/div[3]/div/div[4]/a/span", _By.xPath, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.XPath("//ul[@id='prodList']/li[11]/div[3]/div/div[4]/a/span")).Click();
                        break;
                    case _ServicePlan.vzw30GBMoreEverythingUnlimitedTalkText:
                        Assert.IsTrue(Utilities.WaitForElement("//ul[@id='prodList']/li[12]/div[3]/div/div[4]/a/span", _By.xPath, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.XPath("//ul[@id='prodList']/li[12]/div[3]/div/div[4]/a/span")).Click();
                        break;
                    case _ServicePlan.vzw40GBMoreEverythingUnlimitedTalkText:
                        Assert.IsTrue(Utilities.WaitForElement("//ul[@id='prodList']/li[13]/div[3]/div/div[4]/a/span", _By.xPath, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.XPath("//ul[@id='prodList']/li[13]/div[3]/div/div[4]/a/span")).Click();
                        break;
                    case _ServicePlan.vzw50GBMoreEverythingUnlimitedTalkText:
                        Assert.IsTrue(Utilities.WaitForElement("//ul[@id='prodList']/li[14]/div[3]/div/div[4]/a/span", _By.xPath, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.XPath("//ul[@id='prodList']/li[14]/div[3]/div/div[4]/a/span")).Click();
                        break;
                    default:
                        Assert.IsTrue(Utilities.WaitForElement("//ul[@id='prodList']/li/div[3]/div/div[4]/a/span", _By.xPath, Globals._DefaultTimeoutValue));
                        Globals._Driver.FindElement(By.XPath("//ul[@id='prodList']/li/div[3]/div/div[4]/a/span")).Click();
                        break;
                }

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("-- " + e.Message, false);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region ClearCart()
        public static bool ClearCart()
        {
            Utilities.Log("++ ClearCart", false);
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("lnkMyCart", SeleniumTests._By.id, Globals._DefaultTimeoutValue));

                Globals._Driver.FindElement(By.Id("lnkMyCart")).Click();
                Assert.IsTrue(Utilities.WaitForElement("//a[contains(text(),'Clear Cart')]", SeleniumTests._By.xPath, Globals._DefaultTimeoutValue));
                Globals._Driver.FindElement(By.XPath("//a[contains(text(),'Clear Cart')]")).Click();
                Assert.IsTrue(Regex.IsMatch(Utilities.CloseAlertAndGetItsText(), "^Are you sure you want to clear your cart[\\s\\S]$"));
                Globals._Driver.FindElement(By.LinkText("Close Cart")).Click();
                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("-- " + e.Message, false);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region NavigateToSite()
        public static bool NavigateToSite(string url)
        {
            Utilities.Log("++ NavigateToSite: " + url, false);
            try
            {
                Globals._Driver.Navigate().GoToUrl(url);
                Assert.IsTrue(Utilities.WaitForElement("lnkMyCart", SeleniumTests._By.id, 60));
                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("-- " + e.Message, false);
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

                Utilities.Log("+ select New Number", false);
                Globals._Driver.FindElement(By.Id("newNumber_1")).Click();
                Globals._Driver.FindElement(By.LinkText("Continue")).Click();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("-- " + e.Message, false);
                Assert.Fail();

                return false;
            }

        }
        public static bool RetainCurrentMobileNumber(string currentNumber, string existingCarrier, string existingCarrierAccountNumber, string existingCarrierPin)
        {
            Utilities.Log("++ KeepCurrentNumber", false);

            // Add dashes if they don't already exist so the data can be parsed
            if (!currentNumber.Contains("-"))
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

                Utilities.Log("+ type sameNumber", false);
                Globals._Driver.FindElement(By.Id("sameNumber_1")).Click();
                Globals._Driver.FindElement(By.Id("areacode1")).Clear();
                Utilities.Log("+ type " + splitString[0], false);
                Globals._Driver.FindElement(By.Id("areacode1")).SendKeys(splitString[0]);
                Globals._Driver.FindElement(By.Id("lnp1")).Clear();
                Utilities.Log("+ type " + splitString[1], false);
                Globals._Driver.FindElement(By.Id("lnp1")).SendKeys(splitString[1]);
                Globals._Driver.FindElement(By.Id("lastfour1")).Clear();
                Utilities.Log("+ type " + splitString[2], false);
                Globals._Driver.FindElement(By.Id("lastfour1")).SendKeys(splitString[2]);
                Utilities.Log("+ select " + existingCarrier, false);
                new SelectElement(Globals._Driver.FindElement(By.Id("portInCurrentCarrier1"))).SelectByText(existingCarrier);
                Globals._Driver.FindElement(By.Id("portInCurrentCarrierAccountNumber1")).Clear();
                Utilities.Log("+ type " + existingCarrierAccountNumber, false);
                Globals._Driver.FindElement(By.Id("portInCurrentCarrierAccountNumber1")).SendKeys(existingCarrierAccountNumber);
                Globals._Driver.FindElement(By.Id("portInCurrentCarrierPin1")).Clear();
                Utilities.Log("+ type " + existingCarrierPin, false);
                Globals._Driver.FindElement(By.Id("portInCurrentCarrierPin1")).SendKeys(existingCarrierPin);

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("-- " + e.Message, false);
                Assert.Fail();
    
                return false;
            }
        }
        #endregion
        #region ProceedToCheckout()
        public static bool ProceedToCheckout()
        {
            Utilities.Log("++ ProceedToCheckout", false);
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("a.ActionButton > span", SeleniumTests._By.cssSelector, Globals._DefaultTimeoutValue));
                Globals._Driver.FindElement(By.CssSelector("a.ActionButton > span")).Click();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("-- " + e.Message, false);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region ReviewCart()
        public static bool ReviewCart()
        {
            Utilities.Log("++ ReviewCart", false);
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("Cart Review", SeleniumTests._By.linkText, Globals._DefaultTimeoutValue));
                Globals._Driver.FindElement(By.LinkText("Cart Review")).Click();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("-- " + e.Message, false);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region ReviewOrder()
        public static bool ReviewOrder()
        {
            Utilities.Log("++ ReviewOrder", false);
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("Continue", SeleniumTests._By.linkText, Globals._DefaultTimeoutValue));

                Globals._Driver.FindElement(By.LinkText("Continue")).Click();
                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("-- " + e.Message, false);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region ReviewPayment()
        public static bool ReviewPayment(string name, string streetAddress, string city, string state, string zipCode, string phone, string email)
        {
            Utilities.Log("++ ReviewPayment", false);

            try
            {
                Assert.IsTrue(Utilities.WaitForElement("xxxName", SeleniumTests._By.name, Globals._DefaultTimeoutValue));

                Globals._Driver.FindElement(By.Name("xxxName")).Clear();
                Utilities.Log("+ type " + name, false);
                Globals._Driver.FindElement(By.Name("xxxName")).SendKeys(name);
                Globals._Driver.FindElement(By.Name("xxxAddress")).Clear();
                Utilities.Log("+ type " + streetAddress, false);
                Globals._Driver.FindElement(By.Name("xxxAddress")).SendKeys(streetAddress);
                Globals._Driver.FindElement(By.Name("xxxCity")).Clear();
                Utilities.Log("+ type " + city, false);
                Globals._Driver.FindElement(By.Name("xxxCity")).SendKeys(city);
                Globals._Driver.FindElement(By.Name("xxxZipcode")).Clear();
                Utilities.Log("+ select " + state, false);
                new SelectElement(Globals._Driver.FindElement(By.Name("xxxState"))).SelectByText(state);
                Globals._Driver.FindElement(By.Name("xxxZipcode")).SendKeys(zipCode);
                Globals._Driver.FindElement(By.Name("xxxPhone")).Clear();
                Utilities.Log("+ type " + phone, false);
                Globals._Driver.FindElement(By.Name("xxxPhone")).SendKeys(phone);
                Globals._Driver.FindElement(By.Name("xxxEmail")).Clear();
                Utilities.Log("+ type " + email, false);
                Globals._Driver.FindElement(By.Name("xxxEmail")).SendKeys(email);
                //Globals._Driver.FindElement(By.LinkText("Continue")).Click();
                Globals._Driver.FindElement(By.Name("process")).Click();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("-- " + e.Message, false);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region SelectDeviceAccessories()
        public static bool SelectDeviceAccessories(_DeviceAccessories deviceType)
        {
            Utilities.Log("++ SelectDeviceAccessories", false);
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("No Thanks", SeleniumTests._By.linkText, Globals._DefaultTimeoutValue));

                if (deviceType == _DeviceAccessories.none)
                    Globals._Driver.FindElement(By.LinkText("No Thanks")).Click();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("-- " + e.Message, false);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region SelectPhone()
        public static bool SelectPhone(string phoneId, string phoneName)
        {
            Utilities.Log("++ SelectPhone", false);
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("(//div[@onclick=\"window.location.href ='/" + phoneId + "/" + phoneName + "'\"])[2]", SeleniumTests._By.xPath, Globals._DefaultTimeoutValue));

                //Globals._Driver.FindElement(By.Id("filterOption_3")).Click();
                //Globals._Driver.FindElement(By.Id("filterOption_6")).Click();
                Globals._Driver.FindElement(By.XPath("(//div[@onclick=\"window.location.href ='/" + phoneId + "/" + phoneName + "'\"])[2]")).Click();
                if (Utilities.WaitForElement("Add to Cart", SeleniumTests._By.linkText, Globals._DefaultTimeoutValue))
                    return true;
                else
                    return false;
            }
            catch (Exception e)
            {
                Utilities.Log("-- " + e.Message, false);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region SelectProtectionPlan()
        public static bool SelectProtectionPlan(_ProtectionPlanType planType)
        {
            Utilities.Log("++ SelectProtectionPlan", false);
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

                return true;
            }
            catch(Exception e)
            {
                Utilities.Log("-- " + e.Message, false);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region SelectServices()
        public static bool SelectDeviceServices(_Services service)
        {
            Utilities.Log("++ SelectDeviceServices", false);
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
                Assert.IsTrue(Utilities.WaitForElement("chk_features_5324", _By.id, Globals._DefaultTimeoutValue));
                Utilities.Log("+ " + service, false);

                switch (service)
                {
                    case _Services.vzwMoreEverythingSmartphoneMonthlyLineAccessRingbackTones:
                        Globals._Driver.FindElement(By.Id("chk_features_5324")).Click();
                        Globals._Driver.FindElement(By.Id("chk_features_453")).Click();
                        //Globals._Driver.FindElement(By.XPath("(//input[@name='chk_features_7fe87700-bea7-4421-880d-7704a8989c9e'])[2]")).Click();
                        break;
                    case _Services.vzwMoreEverythingSmartphoneMonthlyLineAccessRingbackTonesVisualVoiceMail:
                        Globals._Driver.FindElement(By.Id("chk_features_5324")).Click();
                        Globals._Driver.FindElement(By.Id("chk_features_453")).Click();
                        Globals._Driver.FindElement(By.Id("chk_features_481")).Click();
                        break;
                    default:
                       Globals._Driver.FindElement(By.Id("chk_features_5324")).Click();
                       //Globals._Driver.FindElement(By.XPath("(//input[@name='chk_features_79063a6a-7576-4ad5-9241-ce61fb341eca'])[2]")).Click();
                       //Globals._Driver.FindElement(By.XPath("(//input[@name='chk_features_7fe87700-bea7-4421-880d-7704a8989c9e'])[2]")).Click();
                        break;
                }

                Globals._Driver.FindElement(By.LinkText("Add Selected Services")).Click();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("-- " + e.Message, false);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region VerizonAccountLookup()
        public static bool VerizonAccountLookup(string mdn, string last4Ssn, string zipCode, string password)
        {
            Utilities.Log("++ Checkout", false);

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
                Utilities.Log("+ type " + Globals._SplitString[0], false);
                Globals._Driver.FindElement(By.Id("areacode")).SendKeys(Globals._SplitString[0]);
                Globals._Driver.FindElement(By.Id("lnp")).Clear();
                Utilities.Log("+ type " + Globals._SplitString[1], false);
                Globals._Driver.FindElement(By.Id("lnp")).SendKeys(Globals._SplitString[1]);
                Globals._Driver.FindElement(By.Id("lastfour")).Clear();
                Utilities.Log("+ type " + Globals._SplitString[2], false);
                Globals._Driver.FindElement(By.Id("lastfour")).SendKeys(Globals._SplitString[2]);
                Globals._Driver.FindElement(By.Id("txtPin")).Clear();
                Utilities.Log("+ type " + last4Ssn, false);
                Globals._Driver.FindElement(By.Id("txtPin")).SendKeys(last4Ssn);
                Globals._Driver.FindElement(By.Id("billingZip")).Clear();
                Utilities.Log("+ type " + zipCode, false);
                Globals._Driver.FindElement(By.Id("billingZip")).SendKeys(zipCode);
                Globals._Driver.FindElement(By.Id("accountPassword")).Clear();
                Utilities.Log("+ type " + password, false);
                Globals._Driver.FindElement(By.Id("accountPassword")).SendKeys(password);
                Globals._Driver.FindElement(By.LinkText("Continue")).Click();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("-- " + e.Message, false);
                Assert.Fail();

                return false;
            }
        }
        #endregion

        // Direct Delivery Actions
        #region ddSignInToDirectDelivery()
        public static bool ddSignInToDirectDelivery()
        {
            Utilities.Log("++ SelectPhone", false);
            try
            {
                Assert.IsTrue(Utilities.WaitForElement("loginButton", SeleniumTests._By.id, Globals._DefaultTimeoutValue));

                Globals._Driver.FindElement(By.Id("loginButton")).Click();

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("-- " + e.Message, false);
                Assert.Fail();

                return false;
            }
        }
        #endregion
        #region ddSelectCarrier()
        public static bool ddSelectCarrier(_CarrierName carrier)
        {
            Utilities.Log("++ SelectPhone", false);
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

                return true;
            }
            catch (Exception e)
            {
                Utilities.Log("-- " + e.Message, false);
                Assert.Fail();

                return false;
            }
        }
        #endregion
    }
}