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
    public class BaseCartDialog
    {
        public static IWebDriver Driver { get; set; }
        public string ZipCode { get; set; }
        public BaseCartDialog(IWebDriver webDriver, string zipCode)
        {
            Driver = webDriver;
            ZipCode = zipCode;
        }

        IWebElement CurrentZipCodeLink;
        IWebElement EditZipCodeInput;
        IWebElement SaveNewZipCodeButton;
        IWebElement CancelEditZipCodeButton;

        IWebElement ClearCartButton;
        IWebElement CloseCartButton;
        IWebElement CartReviewButton;

        public virtual void Initialize()
        {
            CurrentZipCodeLink = Driver.FindElement(By.XPath(AddALineCartDialogUI.CurrentZipCodeLinkXPath));
            EditZipCodeInput = Driver.FindElement(By.XPath(AddALineCartDialogUI.EditZipCodeInputXPath));
            SaveNewZipCodeButton = Driver.FindElement(By.XPath(AddALineCartDialogUI.SaveNewZipCodeButtonXPath));
            CancelEditZipCodeButton = Driver.FindElement(By.XPath(AddALineCartDialogUI.CancelEditZipCodeButtonXPath));
            ClearCartButton = Driver.FindElement(By.XPath(AddALineCartDialogUI.ClearCartButtonXPath));
            CloseCartButton = Driver.FindElement(By.XPath(AddALineCartDialogUI.CloseCartButtonXPath));
            CartReviewButton = Driver.FindElement(By.Id(AddALineCartDialogUI.CartReviewButtonId));
        }

        public void ChangeZipCode(string newZipCode)
        {
            CurrentZipCodeLink.Click();
            EditZipCodeInput.Clear();
            EditZipCodeInput.SendKeys(newZipCode);
            SaveNewZipCodeButton.Click();
        }

        public void SaveNewZipCode()
        {
            SaveNewZipCodeButton.Click();
        }

        public void CancelEditZipCode()
        {
            CancelEditZipCodeButton.Click();
        }

        public void ClearCart()
        {
            ClearCartButton.Click();
        }

        public void CloseCart()
        {
            CloseCartButton.Click();
        }

        public void CartReview()
        {
            CartReviewButton.Click();
        }

        public void DismissAlert()
        {
            IAlert Alert = Driver.SwitchTo().Alert();
            Alert.Dismiss();
        }
    }
}
