using System;
using System.Text;
using OpenQA.Selenium;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SeleniumTests
{
    [TestClass]
    public class VerifyDetailsView
    {
        #region SetupTest
        [TestInitialize]
        public void SetupTest()
        {
            /* ==================================================================
             * ==   Must get the settings file before generating the log file. ==
             * ================================================================== */
            Utilities.GetSettings("D:\\source\\WA_Costco\\src\\Tests\\Scripts\\Tests\\Collateral\\VerifyDetailsView_settings.xml");
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
        #region TheVerifyDetailsViewTest
        [TestMethod]
        public void TheVerifyDetailsViewTest()
        {
            Globals._Driver.Navigate().GoToUrl(Globals._BaseURL);

            // Get the string of the text for the phone inside the top-left container
            string expectedString = Globals._Driver.FindElement(By.CssSelector("li.prodItem")).Text;

            // Click on the top-left phone to drill down to the details
            Globals._Driver.FindElement(By.CssSelector("div.prodImg")).Click();

            // Get the phone details from the elements on the page
            string phoneName = Globals._Driver.FindElement(By.CssSelector("h1.productTitle")).Text;
            string devicePrice = Globals._Driver.FindElement(By.Id("priceBlockHeader-new")).Text;
            string financePrice = Globals._Driver.FindElement(By.Id("btn-finance")).Text;
            int contractBegin = devicePrice.IndexOf("$");
            int financeBegin = financePrice.IndexOf("$");
            devicePrice = devicePrice.Substring(contractBegin);
            financePrice = financePrice.Substring(financeBegin);

            try
            {
                // Verify the phone details are found inside the _ExpectedString
                Assert.IsTrue(expectedString.Contains(phoneName));
                Assert.IsTrue(expectedString.Contains(devicePrice));
                Assert.IsTrue(expectedString.Contains(financePrice));
            }
            catch (Exception e)
            {
                Globals._VerificationErrors.Append(e.Message);
            }
        }
        #endregion
    }
}
