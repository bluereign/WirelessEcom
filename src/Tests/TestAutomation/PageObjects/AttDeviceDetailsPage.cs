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
    public class AttDeviceDetailsPage : BaseDeviceDetailsPage
    {        
        public AttDeviceDetailsPage(IWebDriver Driver, string DevicePageUrl): base(Driver, DevicePageUrl)
        { }
    }
}
