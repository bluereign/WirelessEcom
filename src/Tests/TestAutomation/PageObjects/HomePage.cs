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
    public class HomePage : BasePage
    {
        string HomePageUrl = "http://membershipwireless.com/";
        //string TestHomePageUrl = "http://costco.ecom-dev-test-1.enterprise.corp/";
        public HomePage(IWebDriver Driver) : base(Driver)
        {
            HomePageUrl = BasePageUI.HomePageUrl;
        }

        public override void Initialize()
        {            
            Driver.Navigate().GoToUrl(HomePageUrl);
            base.Initialize();
        }
        
    }
}
