using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using TestAutomation.WebDriverExtensions;

namespace TestAutomation.PageObjects
{
    public class TMobileDeviceDetailsPage : BasePage, IDeviceDetails
    {
        public string DevicePageUrl { get; set; }

        public string CarrierName { get; set; }

        public string ProductTitle { get; set; }

        public bool IsOutOfStock { get; set; }

        public bool IsFinanceEnabled { get; set; }

        public bool IsContractEnabled { get; set; }

        IWebElement DeviceLogo;
        IWebElement DeviceImage;
        IWebElement FinanceButton;
        IWebElement ContinueButton;
        IWebElement ActionButton;
        string PriceName;
        Decimal PriceToday;
        Decimal FullRetailPrice;
        
        public TMobileDeviceDetailsPage(IWebDriver Driver, string devicePageUrl, string carrierName, string productTitle) : base(Driver)
        {
            CarrierName = carrierName;
            IsContractEnabled = false;
            DevicePageUrl = devicePageUrl;
            ProductTitle = productTitle;
        }

        public override void Initialize()
        {
            base.Initialize();
            DeviceLogo = Driver.FindElement(By.ClassName(CommonDeviceDetailsUI.DeviceLogoClassName));
            DeviceImage = Driver.FindElement(By.Id(CommonDeviceDetailsUI.DeviceImageId));
            FinanceButton = Driver.FindElement(By.Id(TMobileDeviceDetailsUI.SimpleChoiceButtonId));
            PriceName = ((Driver.FindElement(By.XPath(TMobileDeviceDetailsUI.SimpleChoiceButtonId))).Text).Trim();
            ContinueButton = Driver.FindElement(By.Id(TMobileDeviceDetailsUI.ContinueButtonId));


            ActionButton = Driver.FindElement(By.XPath(TMobileDeviceDetailsUI.ActionButtonXPath));
        }

        public TMobileRedirectDialog Continue()
        {
            ContinueButton.Click();
            ActionButton.Click();

            return new TMobileRedirectDialog(Driver);
        }
    }
}
