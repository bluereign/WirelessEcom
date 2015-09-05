using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using OpenQA.Selenium;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SeleniumTests
{
    [TestClass]
    public class SearchForPhones
    {
        #region SetupTest
        [TestInitialize]
        public void SetupTest()
        {
            Globals._Driver = Utilities.InitializeDriver();
            Globals._BaseURL = "http://10.7.0.144";
            Globals._VerificationErrors = new StringBuilder();
        }
        #endregion
        #region TeardownTest
        [TestCleanup]
        public void TeardownTest()
        {
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
        #region TheSearchForPhonesTest
        [TestMethod]
        public void TheSearchForPhonesTest()
        {
            string searchTerm = "iphone";

            Globals._Driver.Navigate().GoToUrl(Globals._BaseURL + "/index.cfm/go/shop/do/browsePhones");
            Globals._Driver.FindElement(By.Id("q")).Clear();
            Globals._Driver.FindElement(By.Id("q")).SendKeys(searchTerm);
            Globals._Driver.FindElement(By.CssSelector("input.searchGo")).Click();

            for (int second = 0; ; second++)
            {
                if (second >= 60) Assert.Fail("timeout");
                try
                {
                    if (Utilities.IsElementPresent(By.CssSelector("li.prodItem"))) break;
                }
                catch (Exception)
                { }
                Thread.Sleep(1000);
            }

            // Get the list of phones in the results
            IWebElement result = Globals._Driver.FindElement(By.XPath("//div[@id='resultsDiv']"));
            IList<IWebElement> phones = result.FindElements(By.ClassName("bottomContainer"));
            string phoneDetails = "";

            // Verify that each item contains the search term
            try
            {
                for (int i = 0; i < phones.Count; i++)
                {
                    phoneDetails = phones[i].Text.ToLower();
                    Assert.IsTrue(phoneDetails.Contains(searchTerm.ToLower()));
                }
            }
            catch (Exception e)
            {
                Globals._VerificationErrors.Append(e.Message);
            }
        }
        #endregion
    }
}
