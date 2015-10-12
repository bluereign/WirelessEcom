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
    public class TMobileRedirectDialog
    {
        IWebDriver Driver { get; set; }
        IWebElement CancelButton;
        IWebElement ApproveAndProceedButton;

        public TMobileRedirectDialog(IWebDriver webDriver)
        {
            Driver = webDriver;
        }
        
        public void Initialize()
        {
            Driver.SwitchTo().ActiveElement();
            WebDriverWait wait = new WebDriverWait(Driver, TimeSpan.FromSeconds(5));
            wait.Until(ExpectedConditions.ElementIsVisible(By.XPath(TMobileDeviceDetailsUI.ModalDialogCancelButtonXPath)));
            CancelButton = Driver.FindElement(By.XPath(TMobileDeviceDetailsUI.ModalDialogCancelButtonXPath));
            ApproveAndProceedButton = Driver.FindElement(By.XPath(TMobileDeviceDetailsUI.ModalDialogRedirectButtonXPath));
            Console.WriteLine("CancelButton is Displayed : " + CancelButton.Displayed);
            Console.WriteLine("ApproveAndProceedButton is Displayed: " + ApproveAndProceedButton.Displayed);

            Console.WriteLine("CancelButton is Selected: " + CancelButton.Selected);
            Console.WriteLine("ApproveAndProceedButton is Selected: " + ApproveAndProceedButton.Selected);
        }

        public void ApproveAndProceed()
        {
            ApproveAndProceedButton.Click();
        }

        public void Cancel()
        {
            CancelButton.Click();
        }
    }
}
