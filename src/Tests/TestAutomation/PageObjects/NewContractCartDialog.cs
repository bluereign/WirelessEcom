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
    public class NewContractCartDialog : BaseCartDialog, ICartDialog
    {
        Dictionary<int,IWebElement> Lines { get; set; }
        public NewContractCartDialog(IWebDriver Driver, string CarrierName, string ProductTitle, string ProductPrice, string ZipCode) : base(Driver, ZipCode)
        {
            Lines = new Dictionary<int, IWebElement>();
        }

        IWebElement ViewDeviceLink;
        IWebElement ChangeDeviceLink;
        IWebElement RemoveDeviceLink;
        IWebElement FirstLineLink;
        IWebElement AddALineLink;
        IWebElement AccessoriesLink;

        public override void Initialize()
        {
            ViewDeviceLink = Driver.FindElement(By.XPath(AddToCartDialogUI.ViewDeviceLinkXPath));
            ChangeDeviceLink = Driver.FindElement(By.XPath(AddToCartDialogUI.ChangeDeviceLinkXPath));
            RemoveDeviceLink = Driver.FindElement(By.XPath(AddToCartDialogUI.RemoveDeviceLinkXPath));
            FirstLineLink = Driver.FindElement(By.Id(AddToCartDialogUI.FirstLineLinkId));
            Lines.Add(1, FirstLineLink);
            AddALineLink = Driver.FindElement(By.Id(AddToCartDialogUI.AddALineButtonId));
            AccessoriesLink = Driver.FindElement(By.Id(AddToCartDialogUI.AccessoriesLinkId));
        }

        public void ViewDevice()
        {
            ViewDeviceLink.Click();
        }

        public void ChangeDevice(string NewProductTitle)
        {
            ChangeDeviceLink.Click();
        }

        public void RemoveDevice()
        {
            RemoveDeviceLink.Click();
        }

        public void AddLine()
        {
            int newLineNumber = Lines.Count;
            AddALineLink.Click();
            string newLineLinkId = AddToCartDialogUI.LineLinkXPathRoot +  Convert.ToString(newLineNumber);
            IWebElement newLine = Driver.FindElement(By.Id(newLineLinkId));
            Lines.Add(newLineNumber, newLine);
        }
    }
}
