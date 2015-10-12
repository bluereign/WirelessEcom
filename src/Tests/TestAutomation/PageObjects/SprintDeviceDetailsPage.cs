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
    public class SprintDeviceDetailsPage : BaseDeviceDetailsPage
    {
        public SprintDeviceDetailsPage(IWebDriver Driver, string DevicePageUrl, string CarrierName, string ProductTitle) : base(Driver, DevicePageUrl, SprintCarrierName, ProductTitle)
        {
        }

        public override void Initialize()
        {
            base.Initialize();
        }
    }
}
