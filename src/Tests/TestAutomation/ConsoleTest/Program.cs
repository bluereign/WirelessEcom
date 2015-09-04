using System;
using System.Collections.Generic;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Firefox;
using OpenQA.Selenium.IE;
using TestAutomation.WebDriverExtensions;

namespace TestAutomation.ConsoleTest
{
    class ConsoleTest
    {
        public static void Main()
        {
            string EntryUrl = "http://membershipwireless.com/45125/htc-one-m9-32-gb-gunmetal-gray";
            IWebDriver Driver = new FirefoxDriver();
            Driver.Navigate().GoToUrl(EntryUrl);
            IWebElement tableElement = Driver.FindElement(By.XPath(".//*[@id='price-slide-AT&T Next24']"));
            IList<IWebElement> elements = tableElement.FindElements(By.TagName("tr"));
            Console.WriteLine(elements[0].Text);
            Driver.Close();

            Console.ReadKey();
        }
    }
}