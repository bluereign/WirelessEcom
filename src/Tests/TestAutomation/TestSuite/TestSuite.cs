using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TestAutomation.PageObjects;
using TestAutomation.BusinessObjects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Firefox;
using OpenQA.Selenium.IE;

namespace TestAutomation.TestSuite
{
    [TestClass]
    public class PhoneBrowsing
    {
        HomePage homePage;

        [TestInitialize]
        public void Setup()
        {
            Console.WriteLine("Loading HomePage");
            homePage = new HomePage(new FirefoxDriver()); //Select browser from config file
            homePage.Initialize();
        }

        [TestMethod]
        public void BrowsePhones()
        {
            homePage.NavigateToPhones();
        }

        [TestMethod]
        public void BrowseTMobilePhones()
        {

        }

        [TestMethod]
        public void BrowseVerizonPhones()
        {

        }

        [TestMethod]
        public void BrowseSprintPhones()
        {

        }

        [TestCleanup]
        public void Teardown()
        {
            //BasePage.CloseBrowser();
        }
    }
}
