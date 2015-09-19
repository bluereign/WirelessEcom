using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using TestAutomation.WebDriverExtensions;
using OpenQA.Selenium.Interactions;

namespace TestAutomation.PageObjects
{
    public class BasePage
    {
        public IWebElement PhonesMenu { get; set; }
        public IWebElement AllPhonesMenu { get; set; } 
        public IWebElement AttPhonesMenu { get; set; }
        public IWebElement TMobilePhonesMenu { get; set; }
        public IWebElement VerizonPhonesMenu { get; set; }
        public IWebElement SprintPhonesMenu { get; set; }
        public IWebElement UpgradePhoneMenu { get; set; }
        public IWebElement PrepaidPhonesMenu { get; set; }
        public IWebElement ServicePlansMenu { get; set; }

        public const string AttCarrierName = "AT&T";
        public const string VerizonCarrierName = "Verizon Wireless";
        public const string TMobileCarrierName = "T-Mobile";
        public const string SprintCarrierName = "Sprint";

        public static IWebDriver Driver { get; set; }

        //public string UserName { get; set; }

        Actions Moves;
        public IAction MouseOverPhonesMenu;

        public BasePage(IWebDriver webDriver)
        {
            Driver = webDriver;
            Moves = new Actions(Driver);
            Driver.Manage().Window.Maximize();
        }

        public virtual void Initialize()
        {
            WebDriverWait wait = new WebDriverWait(Driver, TimeSpan.FromSeconds(5));
            wait.Until(ExpectedConditions.ElementIsVisible(By.XPath(BasePageUI.PhonesMenuXPath)));
            PhonesMenu = Driver.FindElement(By.XPath(BasePageUI.PhonesMenuXPath));
            AllPhonesMenu = Driver.FindElement(By.XPath(BasePageUI.AllPhonesMenuXPath));
            AttPhonesMenu = Driver.FindElement(By.XPath(BasePageUI.AttMenuXPath));
            TMobilePhonesMenu = Driver.FindElement(By.XPath(BasePageUI.TMobileMenuXPath));
            VerizonPhonesMenu = Driver.FindElement(By.XPath(BasePageUI.VerizonMenuXPath));
            SprintPhonesMenu = Driver.FindElement(By.XPath(BasePageUI.SprintMenuXPath));
            UpgradePhoneMenu = Driver.FindElement(By.XPath(BasePageUI.UpgradePhoneMenuXPath));
            PrepaidPhonesMenu = Driver.FindElement(By.XPath(BasePageUI.PrepaidPhonesMenuXPath));
            ServicePlansMenu = Driver.FindElement(By.XPath(BasePageUI.ServicePlansMenuXPath));
            MouseOverPhonesMenu = Moves.MoveToElement(PhonesMenu).Build();
        }

        public BrowsePhonesPage BrowsePhones()
        {
            PhonesMenu.Click();
            return new BrowsePhonesPage(Driver);
        }

        public BrowsePhonesPage BrowseAllPhones()
        {            
            AllPhonesMenu.Click();
            return new BrowsePhonesPage(Driver);
        }

        public BrowsePhonesPage BrowseAttPhones()
        {

            return new BrowsePhonesPage(Driver, AttCarrierName);
        }

        public BrowsePhonesPage BrowseVerizonPhones()
        {
            return new BrowsePhonesPage(Driver, VerizonCarrierName);
        }

        public BrowsePhonesPage BrowseTMobilePhones()
        {
            return new BrowsePhonesPage(Driver, TMobileCarrierName);
        }

        public BrowsePhonesPage BrowseSprintPhones()
        {
            return new BrowsePhonesPage(Driver, SprintCarrierName);
        }

        public void BrowseServicePlans()
        {
            ServicePlansMenu.Click();
        }

        public static void CloseBrowser()
        {
            Driver.Close();
        }
    }
}
