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
    public class AttNextMarketingPage : BasePage
    {
        public AttNextMarketingPage(IWebDriver Driver) : base(Driver)
        {

        }

        public override void Initialize()
        {
            base.Initialize();
        }
    }
}
