using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using TestAutomation.WebDriverExtensions;

namespace TestAutomation.PageObjects
{
    public class BasePage
    {
        IWebElement PhonesMenu { get; set; }
        IWebElement AllPhonesMenu { get; set; } 
        IWebElement AttMenu { get; set; }
        IWebElement TMobileMenu { get; set; }
        IWebElement VerizonMenu { get; set; }
        IWebElement SprintMenu { get; set; }
        IWebElement UpgradePhoneMenu { get; set; }
        IWebElement ServicePlansMenu { get; set; }

        public static IWebDriver Driver { get; set; }

        //public string UserName { get; set; }

        public BasePage(IWebDriver webDriver)
        {
            Driver = webDriver;
            Driver.Manage().Window.Maximize();
        }

        public virtual void Initialize()
        {
            PhonesMenu = Driver.FindElement(By.XPath(BasePageUI.PhonesMenuXPath));
            AllPhonesMenu = Driver.FindElement(By.XPath(BasePageUI.AllPhonesMenuXPath));
            AttMenu = Driver.FindElement(By.XPath(BasePageUI.AttMenuXPath));
            TMobileMenu = Driver.FindElement(By.XPath(BasePageUI.TMobileMenuXPath));
            VerizonMenu = Driver.FindElement(By.XPath(BasePageUI.VerizonMenuXPath));
            SprintMenu = Driver.FindElement(By.XPath(BasePageUI.SprintMenuXPath));
            UpgradePhoneMenu = Driver.FindElement(By.XPath(BasePageUI.UpgradePhoneMenuXPath));
            ServicePlansMenu = Driver.FindElement(By.XPath(BasePageUI.ServicePlansMenuXPath));
        }

        public BrowsePhonesPage NavigateToPhones()
        {
            PhonesMenu.Click();
            return new BrowsePhonesPage(Driver);
        }

        public BrowsePhonesPage NavigateToAllPhones()
        {
            AllPhonesMenu.Click();
            return new BrowsePhonesPage(Driver);
        }

        
        public static void CloseBrowser()
        {
            Driver.Close();
        }
    }
}
