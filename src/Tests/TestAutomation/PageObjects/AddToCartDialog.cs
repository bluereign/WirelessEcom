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
    public class AddToCartDialog : ICartDialog
    {
        string CarrierName { get; set; }
        string ProductTitle { get; set; }
        string ProductPrice { get; set; }
        ContractType Type { get; set; }

        public IWebDriver Driver { get; set; }

        public string ZipCode { get; set; }

        IWebElement DeviceLogo;
        IWebElement DeviceImage;
        IWebElement NewActivationButton;
        IWebElement UpgradeActivationButton;
        IWebElement AddALineActivationButton;
        IWebElement ZipCodeField;
        IWebElement ContinueButton;

        public AddToCartDialog(IWebDriver driver, string carrierName, string productTitle, string productPrice)
        {
            Driver = driver;
            CarrierName = carrierName;
            ProductTitle = productTitle;
            ProductPrice = productPrice;
        }

        public void Initialize()
        {
            Driver.SwitchTo().ActiveElement();
            WebDriverWait wait = new WebDriverWait(Driver, TimeSpan.FromSeconds(5));
            wait.Until(ExpectedConditions.ElementIsVisible(By.XPath(AddToCartDialogUI.DeviceLogoXPath)));
            DeviceLogo = Driver.FindElement(By.XPath(AddToCartDialogUI.DeviceLogoXPath));
            DeviceImage = Driver.FindElement(By.ClassName(AddToCartDialogUI.DeviceImageClassName));

            NewActivationButton = Driver.FindElement(By.Id(AddToCartDialogUI.NewActivationInputId));
            UpgradeActivationButton = Driver.FindElement(By.Id(AddToCartDialogUI.UpgradeActivationInputId));
            AddALineActivationButton = Driver.FindElement(By.Id(AddToCartDialogUI.AddALineActivationInputId));

            ZipCodeField = Driver.FindElement(By.Id(AddToCartDialogUI.ZipCodeInputFieldId));
            ContinueButton = Driver.FindElement(By.XPath(AddToCartDialogUI.ContinueButtonXPath));
        }

        public void ChooseContractType(ContractType contractType)
        {
            switch(contractType)
            {
                case ContractType.New:
                    Type = ContractType.New;
                    NewActivationButton.Click();
                    break;
                case ContractType.Upgrade:
                    Type = ContractType.Upgrade;
                    UpgradeActivationButton.Click();
                    break;
                case ContractType.AddALine:
                    Type = ContractType.AddALine;
                    AddALineActivationButton.Click();
                    break;
                default:
                    Type = ContractType.New;
                    NewActivationButton.Click();
                    break;
            }
        }

        public void EnterZipCode(string zipcode)
        {
            ZipCodeField.SendKeys(zipcode);
            ZipCode = zipcode;
        }

        public ICartDialog Continue()
        {
            ContinueButton.Click();

            if(Type.Equals(ContractType.New))
            {
                return new NewContractCartDialog(Driver, CarrierName, ProductTitle, ProductPrice, ZipCode);
            }
            else if (Type.Equals(ContractType.Upgrade))
            {
                return new UpgradeCartDialog(Driver, CarrierName, ProductTitle, ProductPrice, ZipCode);
            }
            else if (Type.Equals(ContractType.AddALine))
            {
                return new AddALineCartDialog(Driver, CarrierName, ProductTitle, ProductPrice, ZipCode);
            }
            else
            {
                Console.WriteLine("Invalid ContractType");
                return null;
            }
        }
    }
}
