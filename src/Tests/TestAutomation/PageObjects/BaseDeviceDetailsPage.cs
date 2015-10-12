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
    public enum PricingType
    {
        Contract,
        Finance,
    };

    public enum ContractType
    {
        New = 1,
        Upgrade,
        AddALine
    };

    public class BaseDeviceDetailsPage : BasePage, IDeviceDetails
    {
        public string DevicePageUrl { get; set; }

        public string CarrierName { get; set; }

        public string ProductTitle { get; set; }

        public bool IsOutOfStock { get; set; }

        public bool IsFinanceEnabled { get; set; }

        public bool IsContractEnabled { get; set; }

        public string ProductPrice { get; set; }

        IWebElement DeviceLogo;
        IWebElement DeviceImage;
        IWebElement ContractButton;
        IWebElement ContractButtonHeader;
        IWebElement NewPriceButton;
        IWebElement NewRegularPrice;
        IWebElement UpgradePriceButton;
        IWebElement UpgradeRegularPrice;
        IWebElement AddALinePriceButton;

        //Duplicate ID blocks this element from getting found by WebDriver!
        //IWebElement AddALineRegularPrice;

        IWebElement FinanceButton;
        IWebElement FinanceLearnMoreButton;
        IWebElement FinanceActionButton;
        IWebElement NewAddToCartButton;
        IWebElement NewActionButton;

        IWebElement UpgradeAddToCartButton;
        IWebElement UpgradeActionButton;

        IWebElement AddALineAddToCartButton;
        IWebElement AddALineActionButton;

        Actions Moves;
        public IAction MouseOverUpgradePriceButton;
        public IAction MouseOverAddALinePriceButton;

        public BaseDeviceDetailsPage(IWebDriver Driver, string devicePageUrl, string carrierName, string productTitle) : base(Driver)
        {
            DevicePageUrl = devicePageUrl;
            CarrierName = carrierName;
            ProductTitle = productTitle;
            Moves = new Actions(Driver);
        }

        void SetOutOfStockState()
        {
            IWebElement IsOutOfStockElement = Driver.FindElement(By.XPath(CommonDeviceDetailsUI.OutOfStockXPath));
            string OutOfStockText = CommonDeviceDetailsUI.OutOfStockText;

            if ((IsOutOfStockElement.Text).Equals(OutOfStockText))
            {
                IsOutOfStock = true;
            }
            else
            {
                IsOutOfStock = false;
            }
            Console.WriteLine("IsOutOfStock: " + IsOutOfStock);
        }

        void SetContractAndFinanceState()
        {
            string type;
            string id;
            bool isDisplayed;
            IWebElement pricingTypeRoot = Driver.FindElement(By.XPath(CommonDeviceDetailsUI.PricingTypeRootXPath));
            IList<IWebElement> pricingTypes = pricingTypeRoot.FindElements(By.TagName("button"));

            if (pricingTypes.Count < 1)
            {
                Console.WriteLine("No Pricing Information Found!!!");
                return;
            }

            foreach (IWebElement element in pricingTypes)
            {
                type = element.GetAttribute("type");
                id = element.GetAttribute("id");
                isDisplayed = element.Displayed;

                if (id.Equals(CommonDeviceDetailsUI.ContractButtonId) && (isDisplayed.Equals(true)))
                {
                    IsContractEnabled = true;
                }

                if (id.Equals(CommonDeviceDetailsUI.FinanceButtonId) && (isDisplayed.Equals(true)))
                {
                    IsFinanceEnabled = true;
                }

                if (!IsContractEnabled)
                {
                    IsContractEnabled = false;
                }

                if (!IsFinanceEnabled)
                {
                    IsFinanceEnabled = false;
                }
            }

            Console.WriteLine("IsFinanceEnabled : " + IsFinanceEnabled);
            Console.WriteLine("IsContractEnabled : " + IsContractEnabled);
        }

        public override void Initialize()
        {
            base.Initialize();
            WebDriverWait wait = new WebDriverWait(Driver, TimeSpan.FromSeconds(5));
            wait.Until(ExpectedConditions.ElementIsVisible(By.ClassName(CommonDeviceDetailsUI.DeviceLogoClassName)));
            DeviceLogo = Driver.FindElement(By.ClassName(CommonDeviceDetailsUI.DeviceLogoClassName));
            DeviceImage = Driver.FindElement(By.Id(CommonDeviceDetailsUI.DeviceImageId));
            SetOutOfStockState();
            SetContractAndFinanceState();

            if ((!IsOutOfStock) && (IsContractEnabled))
            {
                wait.Until(ExpectedConditions.ElementIsVisible(By.Id(CommonDeviceDetailsUI.ContractButtonId)));
                ContractButton = Driver.FindElement(By.Id(CommonDeviceDetailsUI.ContractButtonId));
                ProductPrice = ContractButton.Text;
                ContractButtonHeader = Driver.FindElement(By.XPath(CommonDeviceDetailsUI.ContractButtonHeaderXPath));
                NewPriceButton = Driver.FindElement(By.Id(CommonDeviceDetailsUI.NewPriceButtonId));
                NewRegularPrice = Driver.FindElement(By.XPath(CommonDeviceDetailsUI.NewRegularPriceXPath));
                UpgradePriceButton = Driver.FindElement(By.Id(CommonDeviceDetailsUI.UpgradePriceButtonId));
                MouseOverUpgradePriceButton = Moves.MoveToElement(UpgradePriceButton).Build();
                UpgradeRegularPrice = Driver.FindElement(By.XPath(CommonDeviceDetailsUI.UpgradeRegularPriceXPath));                
                AddALinePriceButton = Driver.FindElement(By.Id(CommonDeviceDetailsUI.AddALinetPriceButtonId));
                MouseOverAddALinePriceButton = Moves.MoveToElement(AddALinePriceButton).Build();
                //AddALineRegularPrice = Driver.FindElement(By.XPath(DeviceDetailsUI.AddALineRegularPriceXPath));

                wait.Until(ExpectedConditions.ElementIsVisible(By.Id(CommonDeviceDetailsUI.NewAddToCartButtonId)));
                NewAddToCartButton = Driver.FindElement(By.Id(CommonDeviceDetailsUI.NewAddToCartButtonId));
                //NewActionButton = Driver.FindElement(By.XPath(DeviceDetailsUI.NewActionButtonXPath));
                UpgradeAddToCartButton = Driver.FindElement(By.Id(CommonDeviceDetailsUI.UpgradeAddToCartButtonId));
                UpgradeActionButton = Driver.FindElement(By.XPath(CommonDeviceDetailsUI.UpgradeActionButtonXPath));
                AddALineAddToCartButton = Driver.FindElement(By.Id(CommonDeviceDetailsUI.AddALineAddToCartButtonId));
                AddALineActionButton = Driver.FindElement(By.XPath(CommonDeviceDetailsUI.AddALineActionButtonXPath));
            }
            else
            {
                ContractButton = null;
                ContractButtonHeader = null;
                NewPriceButton = null;
                NewRegularPrice = null;
                UpgradePriceButton = null;
                UpgradeRegularPrice = null;
                AddALinePriceButton = null;
            }
            
            if((!IsOutOfStock) && (IsFinanceEnabled))
            {
                wait.Until(ExpectedConditions.ElementIsVisible(By.Id(CommonDeviceDetailsUI.FinanceButtonId)));
                FinanceButton = Driver.FindElement(By.Id(CommonDeviceDetailsUI.FinanceButtonId));
                FinanceLearnMoreButton = Driver.FindElement(By.Id(CommonDeviceDetailsUI.FinanceLearnMoreButtonId));
                //FinanceActionButton = Driver.FindElement(By.XPatCommonDeviceDetailsUIUI.FinanceActionButtonXPath));
            }
            else
            {
                FinanceButton = null;
                FinanceLearnMoreButton = null;
                FinanceActionButton = null;
            }
        }

        public AddToCartDialog CheckOutContract(ContractType Type)
        {
            if (!IsContractEnabled)
            {
                Console.WriteLine("No Contract pricing is available for this phone");
                return null;
            }

            ContractButton.Click();
            Console.WriteLine("Clicked ContractButton");

            switch(Type)
            {
                case ContractType.New:
                    NewAddToCartButton.Click();
                    Console.WriteLine("Clicked NewAddToCartButton");

                    NewActionButton = Driver.FindElementSafe(By.XPath(CommonDeviceDetailsUI.NewActionButtonXPath));

                    if (NewActionButton.Exists())
                    {
                        NewActionButton.Click();
                    }

                    return new AddToCartDialog(Driver, CarrierName, ProductTitle, ProductPrice);
                case ContractType.Upgrade:
                    MouseOverUpgradePriceButton.Perform();
                    UpgradePriceButton.Click();
                    UpgradeAddToCartButton.Click();
                    Console.WriteLine("Clicked UpgradeAddToCartButton");
                    UpgradeActionButton.Click();
                    return new AddToCartDialog(Driver, CarrierName, ProductTitle, ProductPrice);
                case ContractType.AddALine:
                    MouseOverAddALinePriceButton.Perform();
                    AddALinePriceButton.Click();
                    AddALineAddToCartButton.Click();
                    Console.WriteLine("Clicked AddALineAddToCartButton");
                    AddALineActionButton.Click();
                    return new AddToCartDialog(Driver, CarrierName, ProductTitle, ProductPrice);
                default:
                    Console.WriteLine("Invalid Contract type specified");
                    return null;
            }
        }

        public void FinanceLearnMore()
        {
            if(!IsFinanceEnabled)
            {
                Console.WriteLine("No financing available for this phone!");
                return;
            }

            FinanceLearnMoreButton.Click();
            Console.WriteLine("Clicked FinanceLearnMoreButton");

            FinanceActionButton = Driver.FindElementSafe(By.XPath(CommonDeviceDetailsUI.FinanceActionButtonXPath));

            if (FinanceActionButton.Exists())
            {
                FinanceActionButton.Click();
            }
        }

        public void ChoosePricing(PricingType pricingType)
        {
            if(pricingType == PricingType.Contract)
            {
                ContractButton.Click();
            }
            else if(pricingType == PricingType.Finance)
            {
                FinanceButton.Click();
            }
        }
        
        public string GetNewContractPrice()
        {
            return "new contract";
        }

        public string GetUpgradePrice()
        {
            return "upgrade";
        }
        
        public string GetAddALinePrice()
        {
            return "addaline";
        }

        public string GetFinancePrice()
        {
            return "finance";
        }

        public string GetGersSku()
        {
            return "Sku";
        }

        public string GetManufacturerName()
        {
            return "Manufacturer";
        }
    }
}
