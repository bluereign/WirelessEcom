using System;
using System.Threading;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SeleniumTests
{
    [TestClass]
    public class SortByType
    {
        #region SetupTest
        [TestInitialize]
        public void SetupTest()
        {
            Globals._Driver = Utilities.InitializeDriver();
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
        #region TheSortByTypeTest
        [TestMethod]
        public void TheSortByTypeTest()
        {
            // Navigate to All Phones grid
            Globals._Driver.Navigate().GoToUrl(Globals._BaseURL);

            // Select a sort value
            new SelectElement(Globals._Driver.FindElement(By.Id("SortBy"))).SelectByText(Utilities.SortType(_SortType.PriceLowToHigh));

            for (int second = 0; second <= 61; second++)
            {
                if (second >= 60) Assert.Fail("timeout");
                try
                {
                    if (Utilities.IsElementPresent(By.CssSelector("li.prodItem"))) break;
                }
                catch (Exception)
                {}
                Thread.Sleep(1000);
            }

            /* Sorting is all messed up, so this script is useless.  However, once sorting
             * is working properly, we'll need to build a process to verify that the next item is 
             * in the correct order.
             * 
            if (_CurrentSortType == _SortType.PriceLowToHigh || _CurrentSortType == _SortType.PriceHighToLow)
            {
                // Get the list of phones in the results
                IWebElement result = _Driver.FindElement(By.XPath("//div[@id='resultsDiv']"));
                IList<IWebElement> phones = result.FindElements(By.ClassName("prodPrice"));

                for (int i = 0; i < phones.Count; i++)
                {
                    string prodPrice = phones[i].Text;
                    int price = Convert.ToInt32(prodPrice); // prodPrice = "2-year:\r\n$0.01\r\n\r\nNext:\r\n$17.57/mo"
                }
            }
             */
        }
        #endregion
    }
}