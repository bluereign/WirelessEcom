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
    public class CartReviewPage : BasePage
    {
        string ZipCode { get; set; }
        public CartReviewPage(IWebDriver Driver, string zipCode) : base(Driver)
        {
            ZipCode = zipCode;
        }
    }
}
