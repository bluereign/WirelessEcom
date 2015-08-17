using System;
using System.Text;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SeleniumTests
{
    [TestClass]
    public class DdAddPhoneToCart
    {
        #region SetupTest()
        [TestInitialize]
        public void SetupTest()
        {
            /* ===================================================================
             * ==   Must get the settings file before generating the log file.  ==
             * =================================================================== */
            Utilities.GetSettings("D:\\source\\WA_Costco\\src\\Tests\\Scripts\\Tests\\Collateral\\DdAddPhoneToCart_settings.xml");
            Utilities.Log("+++ Begin test", true);
            Globals._Driver = Utilities.InitializeDriver();
            Globals._VerificationErrors = new StringBuilder();
        }
        #endregion
        #region TeardownTest()
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
        #region TheDdAddPhoneToCartTest()
        [TestMethod]
        public void TheDdAddPhoneToCartTest()
        {
            // Navigate to the site, sign in and select carrier
            Actors.NavigateToSite(Globals._BaseURL);
            Actors.ddSignInToDirectDelivery();
            Actors.ddSelectCarrier(Actors._CarrierName.verizon);

            // Select device
            if (!Actors.SelectPhone(Globals._DeviceId, Globals._DeviceName))
                Actors.ClearCart();

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
        }
        #endregion
    }
}
