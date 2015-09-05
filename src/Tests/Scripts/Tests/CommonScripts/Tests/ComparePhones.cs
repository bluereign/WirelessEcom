using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using OpenQA.Selenium;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SeleniumTests
{
    [TestClass]
    public class ComparePhones
    {
        #region SetupTest
        [TestInitialize]
        public void SetupTest()
        {
            Globals._Driver = Utilities.InitializeDriver();
            Globals._BaseURL = "http://10.7.0.144/";
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
        #region TheComparePhonesTest
        [TestMethod]
        public void TheComparePhonesTest()
        {
            // Navigate to the site
            Globals._Driver.Navigate().GoToUrl(Globals._BaseURL + "/index.cfm/go/shop/do/browsePhones");

            // Get the list of phones from the results
            IWebElement result = Globals._Driver.FindElement(By.XPath("//div[@id='resultsDiv']"));
            IList<IWebElement> phones = result.FindElements(By.ClassName("prodItem"));
            IList<IWebElement> checkboxes = result.FindElements(By.ClassName("compareCheck"));

            // Variable to hold the phone details for comparison purposes
            string[] phoneDetailNames = new string[4];

            for (int i = 0; i < 4; i++)
            {
                // Get the name of the phone from the results
                phoneDetailNames[i] = phones[i].Text;

                // Get the checkbox ID for the phone
                string checkBoxId = checkboxes[i].GetAttribute("id");

                // Check the checkbox
                Globals._Driver.FindElement(By.Id(checkBoxId)).Click();
            }

            // Click the Compare Phones button
            Globals._Driver.FindElement(By.CssSelector("button.compareBtn")).Click();

            // Get the contents of the compared phones
            for (int i = 0; i < 4; i++)
            {
                int compareImageCounter = i + 2;

                // Get the phone details
                string phoneCompareName = Globals._Driver.FindElement(By.XPath("//div[@id='mainContent']/div/table/thead/tr[2]/th[" + compareImageCounter + "]")).Text;

                try
                {
                    // Verify the phone details are found inside the expected name
                    Assert.IsTrue(phoneDetailNames[i].Contains(phoneCompareName));
                }
                catch (Exception e)
                {
                    Globals._VerificationErrors.Append(e.Message);
                }

            }

            // The test passes here, so clear
            Globals._VerificationErrors.Clear();
        }
        #endregion
    }
}
