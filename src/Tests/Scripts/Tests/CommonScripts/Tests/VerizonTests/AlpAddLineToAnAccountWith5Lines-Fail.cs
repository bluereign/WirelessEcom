using System;
using System.Text;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SeleniumTests
{
    [TestClass]
    public class AlpAddLineToAnAccountWith5LinesFail
    {
        #region SetupTest
        [TestInitialize]
        public void SetupTest()
        {
            Utilities.ClearLogFolder();
            /* ==================================================================
             * ==   Must get the settings file before generating the log file. ==
             * ================================================================== */
            Utilities.GetSettings("D:\\source\\WA_Costco\\src\\Tests\\Scripts\\Tests\\Collateral\\vzwAlpAddLineToAnAccountWith5LinesFail_Settings.xml");
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
        #region vzwAlpAddLineToAnAccountWith5LinesFail
        [TestMethod]
        public void vzwAlpAddLineToAnAccountWith5LinesFail()
        {
            // Navigate to the site
            Actors.NavigateToSite(Globals._BaseURL + "/index.cfm/go/shop/do/browsePhones");

            // Select phone
            Actors.ClearCart();
            Actors.SelectPhone(Globals._DeviceId, Globals._DeviceName);

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
        }
        #endregion
    }
}
