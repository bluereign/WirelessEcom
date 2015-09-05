using System;
using System.Text;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SeleniumTests
{
    [TestClass]
    public class PortInAndCompleteNewMoreEverythingActivation
    {
        #region SetupTest
        [TestInitialize]
        public void SetupTest()
        {
            /* ==================================================================
             * ==   Must get the settings file before generating the log file. ==
             * ================================================================== */
            Utilities.GetSettings("D:\\source\\WA_Costco\\src\\Tests\\Scripts\\Tests\\Collateral\\vzwPortInAndCompleteNewMoreEverythingActivation_settings.xml");
            Utilities.Log("+++ Begin test", true);
            Globals._Driver = Utilities.InitializeDriver();
            Globals._VerificationErrors = new StringBuilder();
        }
        #endregion
        #region TeardownTest
        [TestCleanup]
        public void TeardownTest()
        {
            Utilities.Log("+++ End Test");
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
        #region VzwPortInAndCompleteNewMoreEverythingActivation
        [TestMethod]
        public void VzwPortInAndCompleteNewMoreEverythingActivation()
        {
            // Navigate to the site
            Actors.NavigateToSite(Globals._BaseURL + "/index.cfm/go/shop/do/browsePhones");

            // Select phone
            Actors.ClearCart();
            Actors.SelectPhone(Globals._DeviceId, Globals._DeviceName);

            // Add phone to cart
            Actors.AddDeviceToCart(Globals._CustomerZipCode, Actors._AccountType.newAccount);

            // Service plan
            Actors.ChooseServicePlan(Actors._VerizonServicePlans.vzwMedium3GB);

            // Cart - services
            Actors.SelectDeviceServices(Actors._Services.vzwMoreEverythingSmartphoneMonthlyLineAccess);

            // Select protection plan
            Actors.SelectProtectionPlan(Actors._ProtectionPlanType.none);

            // Select device accessories
            Actors.SelectDeviceAccessories(Actors._DeviceAccessories.none);

            // Review cart
            Actors.ReviewCart();
            Actors.ProceedToCheckout();

            // Keep current number and provide previous carrier information
            Actors.RetainCurrentMobileNumber(Globals._RetainNumber, "Sprint",
                /* random account number */ "928347978",
                /* 6 digit random pin for Sprint */ "785398");

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
            string orderNumber = Utilities.GetOrderNumber();

            // Activate the line in OMT
            if (Globals._ActivateLineInOmt)
                Actors.ActivateLine(Globals._AdminUsername, Globals._AdminUsername, orderNumber,
                    Globals._Imei, Globals._Sim, Convert.ToBoolean(Globals._RemoveLine));
        }
        #endregion
    }
}
