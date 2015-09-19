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
    public class BaseDeviceDetailsPage : BasePage
    {
        IWebElement DebugInfo { get; set; }

        public string DevicePageUrl { get; set; }

        public BaseDeviceDetailsPage(IWebDriver Driver, string devicePageUrl) : base(Driver)
        {
            base.Initialize();
            DevicePageUrl = devicePageUrl;
        }

        public override void Initialize()
        {
            DebugInfo = Driver.FindElement(By.XPath(CommonDeviceDetailsUI.DebugInfoButtonXPath));
        }

        enum PricingType 
        { 
            NewContract=1, 
            Finance, 
            Upgrade,  
            AddALine
        };

        public void ChoosePricing(string carrierName, int pricingType)
        {
        }
        public string GetNewContractPrice()
        {
            return "new contract";
        }

        public string GetUpgradePrice()
        {
            return "upgrade";
        }
        
        public string GetAddAlinePrice()
        {
            return "addaline";
        }

        public string GetFinancePrice()
        {
            return "finance";
        }
        public string GetProductTitle()
        {
            return "title";
        }

        public string GetGersSku()
        {
            return "Sku";
        }

        public string GetManufacturerName()
        {
            return "Manufacturer";
        }
    }
}
