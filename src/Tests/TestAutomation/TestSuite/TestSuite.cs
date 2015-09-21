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
using System.Media;

namespace TestAutomation.TestSuite
{
    [TestClass]
    public class PhoneBrowsing
    {
        HomePage homePage;
        BrowsePhonesPage browsePhonesPage;
        BaseDeviceDetailsPage deviceDetailsPage;


        [TestInitialize]
        public void Setup()
        {
            homePage = new HomePage(new FirefoxDriver()); //Select browser from config file
            //homePage = new HomePage(new InternetExplorerDriver()); //Select browser from config file
            //homePage = new HomePage(new ChromeDriver()); //Select browser from config file
            homePage.Initialize();
        }

        [TestMethod]
        public void BrowseAllPhones()
        {
            browsePhonesPage = homePage.BrowsePhones();
            browsePhonesPage.Initialize();
            browsePhonesPage.PrintDeviceList();
        }

        [TestMethod]
        public void BrowseAttPhones()
        {
            browsePhonesPage = homePage.BrowseAttPhones();
            browsePhonesPage.Initialize();
            browsePhonesPage.PrintDeviceList();
        }

        [TestMethod]
        public void BrowseVerizonPhones()
        {
            browsePhonesPage = homePage.BrowseVerizonPhones();
            browsePhonesPage.Initialize();
            browsePhonesPage.PrintDeviceList();
        }

        [TestMethod]
        public void SelectVerizonPhone()
        {
            browsePhonesPage = homePage.BrowseVerizonPhones();
            browsePhonesPage.Initialize();
            string carrierName = BasePageUI.VerizonName;
            string productTitle = "Apple® iPhone® 6 Plus 64GB Silver";
            browsePhonesPage.SelectAPhone(carrierName, productTitle);
        }

        [TestMethod]
        public void SelectTMobilePhone()
        {
            browsePhonesPage = homePage.BrowseTMobilePhones();
            browsePhonesPage.Initialize();
            string carrierName = BasePageUI.TMobileName;
            string productTitle = "Obsidian - Prepaid";
            deviceDetailsPage = browsePhonesPage.SelectAPhone(carrierName, productTitle);
        }

        [TestMethod]
        public void SelectAttPhone()
        {
            browsePhonesPage = homePage.BrowseAttPhones();
            browsePhonesPage.Initialize();
            string carrierName = BasePageUI.AttName;
            string productTitle = "HTC One M9 - 32 GB Gunmetal Gray";
            browsePhonesPage.SelectAPhone(carrierName, productTitle);
        }

        [TestMethod]
        public void SelectSprintPhone()
        {
            browsePhonesPage = homePage.BrowseSprintPhones();
            browsePhonesPage.Initialize();
            string carrierName = BasePageUI.SprintName;
            string productTitle = "Samsung Galaxy S6 Edge Plus Gold 32GB";
            browsePhonesPage.SelectAPhone(carrierName, productTitle);
        }
        
        [TestMethod]
        public void BrowseTMobilePhones()
        {
            browsePhonesPage = homePage.BrowseTMobilePhones();
            browsePhonesPage.Initialize();
            browsePhonesPage.PrintDeviceList();
        }

        [TestMethod]
        public void BrowseSprintPhones()
        {
            browsePhonesPage = homePage.BrowseSprintPhones();
            browsePhonesPage.Initialize();
            browsePhonesPage.PrintDeviceList();
        }

        [TestCleanup]
        public void Teardown()
        {            
            BasePage.CloseBrowser();
        }

        [ClassCleanup]
        public static void TestSuiteTearDown()
        {
            SystemSounds.Asterisk.Play();
            SystemSounds.Beep.Play();
            SystemSounds.Exclamation.Play();
        }
    }
}
