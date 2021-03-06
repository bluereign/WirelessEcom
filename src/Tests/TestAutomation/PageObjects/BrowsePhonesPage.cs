﻿using System;
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
    public class BrowsePhonesPage : BasePage
    {
        public IList<DeviceUIControl> Devices { get; set; }

        public IDictionary<int, DeviceUIControl> DevicePairs { get; set; }

        public static int ProductCount { get; set; }

        public IList<IWebElement> Products { get; set; }

        public BrowsePhonesPage(IWebDriver webDriver) : base(webDriver)
        {
        }

        public BrowsePhonesPage(IWebDriver webDriver, string carrierName) : base(webDriver)
        {
            base.Initialize();

            switch(carrierName)
            {
                case AttCarrierName:
                    MouseOverPhonesMenu.Perform();
                    AttPhonesMenu.Click();
                    break;
                case VerizonCarrierName:
                    MouseOverPhonesMenu.Perform();
                    VerizonPhonesMenu.Click();
                    break;
                case TMobileCarrierName:
                    MouseOverPhonesMenu.Perform();
                    TMobilePhonesMenu.Click();
                    break;
                case SprintCarrierName:
                    MouseOverPhonesMenu.Perform();
                    SprintPhonesMenu.Click();
                    break;
                default:
                    AllPhonesMenu.Click();
                    break;
            }

        }

        public override void Initialize()
        {
            base.Initialize();
            Devices = new List<DeviceUIControl>();
            DevicePairs = new Dictionary<int, DeviceUIControl>();
            WebDriverWait wait = new WebDriverWait(Driver, TimeSpan.FromSeconds(20));
            wait.Until(ExpectedConditions.ElementIsVisible(By.Id(BrowsePhonesUI.ProductListId)));
            IWebElement ProductList = Driver.FindElement(By.Id(BrowsePhonesUI.ProductListId));
            Products = ProductList.FindElements(By.TagName("li"));
            ProductCount = Products.Count;
            Console.WriteLine("Product Count: " + ProductCount);

            IWebElement DeviceLogoElement;
            IWebElement ProductTitleElement;
            IWebElement ProductPriceElement;

            for(int index = 1; index <= ProductCount; index++)
            {
                DeviceLogoElement = Driver.FindElement(By.XPath(BrowsePhonesUI.GetDeviceLogoXPath(index)));
                ProductTitleElement = Driver.FindElement(By.XPath(BrowsePhonesUI.GetProductTitleXPath(index)));                
                ProductPriceElement = Driver.FindElement(By.XPath(BrowsePhonesUI.GetProductPriceXPath(index)));
                DeviceUIControl device = new DeviceUIControl();
                device.CarrierName = GetCarrierName(index, DeviceLogoElement);
                device.ProductTitle = GetProductTitle(index, ProductTitleElement);
                device.ProductPrice = GetProductPrice(index, ProductPriceElement);
                DevicePairs.Add(index, device);
                Devices.Add(device);
            }
        }
        
        public IDeviceDetails SelectPhone(string carrierName, string productTitle)
        {           
            int count = 0; //expecting at most 1 device
            int matchingIndex = 0;
            string devicePageUrl = "";

            if (ProductCount <= 0)
            {
                Console.WriteLine("There are no phones to select from");
                return null;
            }

            for (int index = 1; index <= ProductCount; index++)
            {
                if ((DevicePairs[index].CarrierName).Equals(carrierName) && (DevicePairs[index].ProductTitle).Equals(productTitle))
                {
                    matchingIndex = index;
                    count++;
                }
            }

            if (count == 1)
            {
                Console.WriteLine("************************");
                Console.WriteLine("Selected Phone is available, summary info below:");
                Console.WriteLine(DevicePairs[matchingIndex].CarrierName);
                Console.WriteLine(DevicePairs[matchingIndex].ProductTitle);

                string divXPath1 = BrowsePhonesUI.GetDeviceXPath1(matchingIndex);
                string divXPath2 = BrowsePhonesUI.GetDeviceXPath2(matchingIndex);

                WebDriverWait wait = new WebDriverWait(Driver, TimeSpan.FromSeconds(10));
                wait.Until(ExpectedConditions.ElementIsVisible(By.XPath(divXPath1)));
                wait.Until(ExpectedConditions.ElementIsVisible(By.XPath(divXPath2)));
                IWebElement element = Driver.FindElement(By.XPath(divXPath1));
                IWebElement element2 = Driver.FindElement(By.XPath(divXPath2));

                //Retrieve Device Page Url
                string hrefAttribute = element.GetAttribute("onclick").Split('=')[1].Trim('\'').Trim();
                devicePageUrl = BasePageUI.HomePageUrl + hrefAttribute;
                Console.WriteLine("Device Details Page Url: " + devicePageUrl);
                Console.WriteLine("***********************");
                element.Click();
            }
            else if(count > 1)
            {
                Console.WriteLine("More than one Device Found!");
                return null;
            }
            else if (count == 0)
            {
                Console.WriteLine("No such Device Found!");
                return null;
            }

            switch (carrierName)
            {
                case AttCarrierName:
                    return new AttDeviceDetailsPage(Driver, devicePageUrl, AttCarrierName, productTitle);
                case VerizonCarrierName:
                    return new VerizonDeviceDetailsPage(Driver, devicePageUrl, VerizonCarrierName, productTitle);
                case TMobileCarrierName:
                    return new TMobileDeviceDetailsPage(Driver, devicePageUrl, TMobileCarrierName, productTitle);
                case SprintCarrierName:
                    return new SprintDeviceDetailsPage(Driver, devicePageUrl, SprintCarrierName, productTitle);
                default:
                    Console.WriteLine("Invalid Carrier Name specified");
                    return null;
            }
        }
        
        public void PrintDeviceList()
        {
            if (ProductCount > 0)
            {
                foreach (DeviceUIControl device in Devices)
                {
                    Console.WriteLine(device.CarrierName);
                    Console.WriteLine(device.ProductTitle);
                    Console.WriteLine(device.ProductPrice);
                    Console.WriteLine("******************");
                }
            }
            else
            {
                Console.WriteLine("No Products found!!!");
            }
        }

        IWebElement GetDeviceWebElement(int deviceIndex)
        {
            IWebElement deviceWebElement;
            string divXPath1 = BrowsePhonesUI.GetDeviceXPath1(deviceIndex);
            string divXPath2 = BrowsePhonesUI.GetDeviceXPath2(deviceIndex);
            WebDriverWait wait = new WebDriverWait(Driver, TimeSpan.FromSeconds(10));
            wait.Until(ExpectedConditions.ElementIsVisible(By.XPath(divXPath1)));
            wait.Until(ExpectedConditions.ElementIsVisible(By.XPath(divXPath2)));
            deviceWebElement = Driver.FindElement(By.XPath(divXPath1));
            IWebElement element2 = Driver.FindElement(By.XPath(divXPath2));

            return deviceWebElement;
        }

        string GetDevicePageUrl(int deviceIndex)
        {
            string devicePageUrl;
            IWebElement element = GetDeviceWebElement(deviceIndex);
            string hrefAttribute = element.GetAttribute("onclick").Split('=')[1].Trim('\'').Trim();
            devicePageUrl = BasePageUI.HomePageUrl + hrefAttribute;
            Console.WriteLine();
            Console.WriteLine("Device Details Page Url: " + devicePageUrl);

            return devicePageUrl;
        }

        void SelectPhone(int deviceIndex)
        {
            IWebElement element = GetDeviceWebElement(deviceIndex);
            element.Click();
        }

        public void ShowButtonsDisplayStatus()
        {
            string devicePageUrl;
            string carrierName;

            if (ProductCount <= 0)
            {
                Console.WriteLine("No Devices found");
                return;
            }

            for (int deviceIndex = 1; deviceIndex <= ProductCount; deviceIndex++)
            {
                carrierName = DevicePairs[deviceIndex].CarrierName;
                devicePageUrl = GetDevicePageUrl(deviceIndex);
                Driver.Navigate().GoToUrl(devicePageUrl);

                IWebElement pricingTypeRoot = Driver.FindElement(By.XPath(CommonDeviceDetailsUI.PricingTypeRootXPath));
                IList<IWebElement> pricingTypes = pricingTypeRoot.FindElements(By.TagName("button"));

                foreach (IWebElement element in pricingTypes)
                {

                    Console.WriteLine("Type: " + element.GetAttribute("type"));
                    Console.WriteLine("Id: " + element.GetAttribute("id"));
                    Console.WriteLine("Text: " + element.Text);
                }

                new BrowsePhonesPage(Driver, carrierName);
            }
        }

        string GetCarrierName(int deviceIndex, IWebElement deviceLogoElement)
        {
            string attributeValue = deviceLogoElement.GetAttribute("Class");
            string logoAttributeValue = attributeValue.Replace(BrowsePhonesUI.DeviceLogoClassName, "").Trim();
            string carrierName = GetCarrierName(logoAttributeValue);

            return carrierName;
        }

        string GetCarrierName(string logoAttributeValue)
        {
            switch (logoAttributeValue)
            {
                case BrowsePhonesUI.AttLogoClassValue:
                    return AttCarrierName;
                case BrowsePhonesUI.VerizonLogoClassValue:
                    return VerizonCarrierName;
                case BrowsePhonesUI.TMobileLogoClassValue:
                    return TMobileCarrierName;
                case BrowsePhonesUI.SprintLogoClassValue:
                    return SprintCarrierName;
                default:
                    return null;
            }
        }

        string GetProductTitle(int deviceIndex, IWebElement productTitleElement)
        {
            string productTitle = productTitleElement.Text;

            return productTitle;
        }

        string GetProductPrice(int deviceIndex, IWebElement productPriceElement)
        {
            string productPrice = productPriceElement.Text;

            return productPrice;
        }

        bool IsOutOfStock(int deviceIndex)//Cannot retrieve the img element at this time!
        {
            return false;
        }
    }
}
