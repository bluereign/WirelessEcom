using System;
using System.Collections.Generic;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using OpenQA.Selenium.Support;
using OpenQA.Selenium.Support.Events;
using OpenQA.Selenium.Support.UI;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Firefox;
using OpenQA.Selenium.IE;
using TestAutomation.WebDriverExtensions;
using TestAutomation.PageObjects;

namespace TestAutomation.ConsoleTest
{
    class ConsoleTest
    {
        public static void Main()
        {
            //string TestUrl = "http://membershipwireless.com/45125/htc-one-m9-32-gb-gunmetal-gray";
            //PrintTitleAndPrice();
            //PrintImage();
            ClickOnPhone();


            Console.ReadKey();
        }

        public static void ClickOnPhone()
        {
            string root = "http://membershipwireless.com"; 
            string CostcoUrl = "http://membershipwireless.com/index.cfm/go/shop/do/browsePhones";
            IWebDriver driver = new FirefoxDriver();
            driver.Navigate().GoToUrl(CostcoUrl);
            driver.Manage().Window.Maximize();
            IJavaScriptExecutor js = (IJavaScriptExecutor) driver;

            var divXPath = ".//*[@id='prodList']/li[1]/div[3]";
            var divXPath2 = ".//*[@id='prodList']/li[1]/div[4]";

            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(20));
            wait.Until(ExpectedConditions.ElementIsVisible(By.XPath(divXPath)));
            wait.Until(ExpectedConditions.ElementIsVisible(By.XPath(divXPath2)));
            IWebElement element= driver.FindElement(By.XPath(divXPath));
            IWebElement element2 = driver.FindElement(By.XPath(divXPath2));
            string attrib = element.GetAttribute("onclick").Split('=')[1].Trim('\'').Trim();
            string devicePageUrl = root + attrib;
            Console.WriteLine("devicePageUrl: " + devicePageUrl);
            driver.Navigate().GoToUrl(devicePageUrl);
            //element.Click();
        }


        public static void PrintTitleAndPrice()
        {
            string CostcoUrl = "http://membershipwireless.com/index.cfm/go/shop/do/browsePhones";
            IWebDriver driver = new FirefoxDriver();
            driver.Navigate().GoToUrl(CostcoUrl);
            driver.Manage().Window.Maximize();
            string prodTitleXPath1 = ".//*[@id='prodList']/li[2]/div[4]/div[1]";
            string prodTitleXPath2 = ".//*[@id='prodList']/li[3]/div[4]/div[1]";
            string priceXPath1 = ".//*[@id='prodList']/li[2]/div[4]/div[2]";
            string priceXPath2 = ".//*[@id='prodList']/li[3]/div[4]/div[2]";
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(10));
            wait.Until(ExpectedConditions.ElementIsVisible(By.XPath(priceXPath1)));
            IWebElement prodTitle1 = driver.FindElement(By.XPath(prodTitleXPath1));
            IWebElement priceElement1 = driver.FindElement(By.XPath(priceXPath1));
            Console.WriteLine("Product Title1: " + prodTitle1.Text);
            Console.WriteLine("Price1: " + priceElement1.Text);
            Console.WriteLine("--------");
            IWebElement prodTitle2 = driver.FindElement(By.XPath(prodTitleXPath2));
            IWebElement priceElement2 = driver.FindElement(By.XPath(priceXPath2));
            Console.WriteLine("Product Title2 " + prodTitle2.Text);
            Console.WriteLine("Price2: " + priceElement2.Text);

            driver.Close();
        }

        public static void PrintOutOfStockStatus()
        {
            string CostcoUrl = "http://membershipwireless.com/index.cfm/go/shop/do/browsePhones";
            IWebDriver driver = new FirefoxDriver();
            driver.Navigate().GoToUrl(CostcoUrl);
            driver.Manage().Window.Maximize();
            string prodImgXPath = "//ul[@id='prodList']/li[2]/div[3]/img";
            IWebElement prodImageElement = driver.FindElement(By.XPath(prodImgXPath));
            IWebElement productImageElement = prodImageElement.FindElement(By.TagName("img"));
            string imageSrcAttribute = productImageElement.GetAttribute("src");
            Console.WriteLine(imageSrcAttribute);

            driver.Close();
        }

        public static void PrintImage()
        {            
            string CostcoUrl = "http://membershipwireless.com/index.cfm/go/shop/do/browsePhones";
            IWebDriver driver = new FirefoxDriver();
            driver.Navigate().GoToUrl(CostcoUrl);
            driver.Manage().Window.Maximize();
            string prodImgXPath = ".//*[@id='prodList']/li[15]/div[3]";
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(10));
            wait.Until(ExpectedConditions.ElementIsVisible(By.XPath(prodImgXPath)));
            IWebElement prodImageElement = driver.FindElement(By.XPath(prodImgXPath));
            string imageSrcAttribute = prodImageElement.GetAttribute("style");
            Console.WriteLine(imageSrcAttribute);

            driver.Close();
        }

    }
}