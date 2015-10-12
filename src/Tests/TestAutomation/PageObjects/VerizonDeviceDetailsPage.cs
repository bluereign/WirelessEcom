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
    public class VerizonDeviceDetailsPage : BaseDeviceDetailsPage
    {
        public VerizonDeviceDetailsPage(IWebDriver Driver, string DevicePageUrl, string CarrierName, string ProductTitle) : base(Driver, DevicePageUrl, VerizonCarrierName, ProductTitle)
        {
        }

        public override void Initialize()
        {
            base.Initialize();
        }

        public VerizonRedirectDialog LearnMore()
        {
            base.FinanceLearnMore();

            return new VerizonRedirectDialog(Driver);
        }

        
    }
}
