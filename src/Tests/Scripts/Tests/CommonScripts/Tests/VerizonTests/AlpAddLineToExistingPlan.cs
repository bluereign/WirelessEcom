using System;
using System.Text;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SeleniumTests
{
    [TestClass]
    public class AlpAddLineToExistingPlan
    {
        #region SetupTest
        [TestInitialize]
        public void SetupTest()
        {
            /* ==================================================================
             * ==   Must get the settings file before generating the log file. ==
             * ================================================================== */
            Utilities.GetSettings("D:\\source\\WA_Costco\\src\\Tests\\Scripts\\Tests\\Collateral\\AlpAddLineToExistingPlan_settings.xml");
            Utilities.Log("+++ Begin test", true);
            Globals._Driver = Utilities.InitializeDriver();
            Globals._VerificationErrors = new StringBuilder();
        }
        #endregion
        #region TeardownTest
        [TestCleanup]
        public void TeardownTest()
        {
            Utilities.Log("+++ End Test", false);
            try
            {
                Globals._Driver.Quit();
            }
            catch (Exception)
            {
                // Ignore errors if unable to close the browser
            }
            Assert.AreEqual("", Globals._VerificationErrors.ToString());
        }
        #endregion
        #region VzwAlpAddLineToExistingPlan
        [TestMethod]
        public void VzwAlpAddLineToExistingPlan()
        {
            // Navigate to the site
            Actors.NavigateToSite(Globals._BaseURL);

            // Select phone
            if (!Actors.SelectPhone(Globals._DeviceId, Globals._DeviceName))
                Actors.ClearCart();

            // Cart -- zip code
            Actors.AddDeviceToCart(Globals._CustomerZipCode, Actors._AccountType.addNewDeviceToExistingAccountFamilySharedPlan);

            // Cart - services
            Actors.SelectDeviceServices(Actors._Services.vzwMoreEverythingSmartphoneMonthlyLineAccess);

            // Select protection plan
            Actors.SelectProtectionPlan(Actors._ProtectionPlanType.none);

            // Select device accessories
            Actors.SelectDeviceAccessories(Actors._DeviceAccessories.none);

            // Review cart
            Actors.ReviewCart();
            Actors.ProceedToCheckout();

            // Checkout
            Actors.VerizonAccountLookup(Globals._CustomerMobileNumber, Globals._CustomerLast4Ssn, Globals._CarrierZipCode, 
                Globals._CarrierPassword);

            // Keep current number
            Actors.ObtainNewMobileNumber();

            // Billing and Shipping
            Actors.BillingAndShipping(Globals._CustomerEmail, Globals._CustomerAccountPassword, Globals._CustomerFirstName,
                Globals._CustomerLastName, Globals._CustomerStreetAddress, Globals._CustomerCity, Globals._CustomerState, 
                Globals._CustomerZipCode);

            // Carrier Application
            Actors.CarrierApplication(Globals._CustomerLast4Ssn, Globals._CustomerState);

            // Review order
            Actors.ReviewOrder();

            // Agree to terms
            Actors.AcceptAgreementTerms(Actors._AgreementType.agreeToContract);

            // Cardholder Information
            Actors.ReviewPayment(Globals._CustomerFirstName + " " + Globals._CustomerLastName, Globals._CustomerStreetAddress,
                Globals._CustomerCity, Globals._CustomerState, Globals._CustomerZipCode, Globals._CustomerMobileNumber, 
                Globals._CustomerEmail);
            Actors.CardholderInfo(Globals._CustomerCreditCard, Globals._CustomerCcExpirationMonth, Globals._CustomerCcExpirationYear, 
                Globals._CustomerCcCvv);

            // Submit order
            Actors.AcknowledgeCompletionOfOrder();

            // Recover from cert warning
            if (Globals._Driver.Title.Contains("Certificate Error"))
                Actors.CertRecovery();

            // Log the order number
            Utilities.GetOrderNumber();
        }
        #endregion
    }
}
