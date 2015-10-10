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
    public class UpgradeCartDialog : BaseCartDialog, ICartDialog
    {
        public UpgradeCartDialog(IWebDriver Driver, string carrierName, string productTitle, string productPrice, string ZipCode) : base(Driver, ZipCode)
        {

        }
    }
}
