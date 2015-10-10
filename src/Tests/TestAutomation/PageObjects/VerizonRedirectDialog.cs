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
    public class VerizonRedirectDialog
    {
        IWebDriver Driver { get; set; }
        IWebElement GetMoreDetailsButton;
        IWebElement ModalDialogBody;

        public VerizonRedirectDialog(IWebDriver webDriver)
        {
            Driver = webDriver;
        }
        
        public void Initialize()
        {
            Driver.SwitchTo().ActiveElement();
            WebDriverWait wait = new WebDriverWait(Driver, TimeSpan.FromSeconds(5));
            wait.Until(ExpectedConditions.ElementIsVisible(By.XPath(CommonDeviceDetailsUI.FinanceModalDialogBodyXPath)));
            ModalDialogBody = Driver.FindElement(By.XPath(CommonDeviceDetailsUI.FinanceModalDialogBodyXPath));
            GetMoreDetailsButton = ModalDialogBody.FindElement(By.TagName("img"));
        }

        public void GetMoreDetailsAboutPaymentAgreement()
        {
            GetMoreDetailsButton.Click();
        }
    }
}
