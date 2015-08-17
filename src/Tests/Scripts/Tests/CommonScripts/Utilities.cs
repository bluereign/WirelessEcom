using System;
using System.Drawing.Imaging;
using System.Threading;
using System.IO;
using System.Xml;
using OpenQA.Selenium;
using OpenQA.Selenium.Firefox;
using OpenQA.Selenium.IE;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Safari;
using OpenQA.Selenium.Opera;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SeleniumTests
{
    enum _Browser { InternetExplorer, Chrome, Firefox, Safari, Opera }
    public enum _By { className, cssSelector, id, linkText, name, partialLinkText, tagName, xPath }
    public enum _SortType { PriceLowToHigh, PriceHighToLow, NameAtoZ, NameZtoA, ManufacturerAtoZ, ManufacturerZtoA, Popular, Default }

    class Utilities
    {
        private static _Browser _BrowserType;

        #region CloseAlertAndGetItsText()
        public static string CloseAlertAndGetItsText()
        {
            Log("++ CloseAlertAndGetItsText", false);
            try
            {
                IAlert alert = Globals._Driver.SwitchTo().Alert();
                string alertText = alert.Text;
                if (Globals._AcceptNextAlert)
                {
                    alert.Accept();
                }
                else
                {
                    alert.Dismiss();
                }
                Log("++ AlertText: " + alertText, false);
                return alertText;
            }
            finally
            {
                Globals._AcceptNextAlert = true;
            }
        }
        #endregion
        #region GetDate()
        public static string GetDate(int timeDiff)
        {
            int m = DateTime.Now.Month;
            int d = DateTime.Now.Day;
            int y = DateTime.Now.Year;

            y += timeDiff;

            string date;

            if (m >= 9)
                date = "0" + m.ToString();
            else
                date = m.ToString();

            date += "/";

            if (d <= 9)
                date += "0" + d.ToString();
            else
                date += d.ToString();

            date += "/" + y.ToString();

            return date;
        }
        #endregion
        #region GetSettings()
        public static void GetSettings(string locationOfSettingsFile)
        {
            if (File.Exists(locationOfSettingsFile))
            {
                string xml = File.ReadAllText(locationOfSettingsFile);
                XmlDocument xmlDoc = new XmlDocument();
                xmlDoc.LoadXml(xml);
                XmlElement testCase = (XmlElement)xmlDoc.SelectSingleNode("//TestCase");
                XmlElement name = (XmlElement)xmlDoc.SelectSingleNode("//Name");
                XmlElement home = (XmlElement)xmlDoc.SelectSingleNode("//Home");
                XmlElement contact = (XmlElement)xmlDoc.SelectSingleNode("//Contact");
                XmlElement financial = (XmlElement)xmlDoc.SelectSingleNode("//CreditCard");
                XmlElement personal = (XmlElement)xmlDoc.SelectSingleNode("//CustomerInfo");
                XmlElement device = (XmlElement)xmlDoc.SelectSingleNode("//Device");
                XmlElement carrier = (XmlElement)xmlDoc.SelectSingleNode("//Carrier");

                string timeoutOverride = testCase.GetAttribute("timeoutHalfSeconds");
                if (timeoutOverride != "")
                    Globals._DefaultTimeoutValue = Convert.ToInt32(timeoutOverride);
                Globals._TestCaseName = testCase.GetAttribute("name");
                Globals._BaseURL = testCase.GetAttribute("baseUrl");
                Globals._CustomerFirstName = name.GetAttribute("firstName");
                Globals._CustomerLastName = name.GetAttribute("lastName");
                Globals._CustomerStreetAddress = home.GetAttribute("streetAddress");
                Globals._CustomerCity = home.GetAttribute("city");
                Globals._CustomerState = home.GetAttribute("state");
                Globals._CustomerZipCode = home.GetAttribute("zipCode");
                Globals._CustomerMobileNumber = contact.GetAttribute("mobileNumber");
                Globals._RetainNumber = contact.GetAttribute("retainNumber");
                Globals._CustomerEmail = contact.GetAttribute("email");
                Globals._CustomerCreditCard = financial.GetAttribute("cardNumber");
                Globals._CustomerCcExpirationMonth = financial.GetAttribute("expireMonth");
                Globals._CustomerCcExpirationYear = financial.GetAttribute("expireYear");
                Globals._CustomerCcCvv = financial.GetAttribute("cvv");
                Globals._CustomerLast4Ssn = personal.GetAttribute("last4Ssn");
                Globals._CustomerAccountPassword = personal.GetAttribute("accountPassword");
                Globals._DeviceId = device.GetAttribute("id");
                Globals._DeviceName = device.GetAttribute("name");
                Globals._CarrierPassword = carrier.GetAttribute("password");
                Globals._CarrierZipCode = carrier.GetAttribute("zipCode");

                string browser = testCase.GetAttribute("browser");
                switch(browser.ToLower())
                {
                    case "opera":
                        _BrowserType = _Browser.Opera;
                        break;
                    case "safari":
                        _BrowserType = _Browser.Safari;
                        break;
                    case "firefox":
                        _BrowserType = _Browser.Firefox;
                        break;
                    case "chrome":
                        _BrowserType = _Browser.Chrome;
                        break;
                    default:
                        _BrowserType = _Browser.InternetExplorer;
                        break;
                }
            }
            else
            {
                Assert.Fail("No settings file found at " + locationOfSettingsFile);
            }
        }
        #endregion
        #region InitializeDriver()
        public static IWebDriver InitializeDriver()
        {
            IWebDriver driver;

            switch (_BrowserType)
            {
                case _Browser.InternetExplorer:
                    driver = new InternetExplorerDriver();
                    break;
                case _Browser.Chrome:
                    driver = new ChromeDriver();
                    break;
                case _Browser.Safari:
                    driver = new SafariDriver();
                    break;
                case _Browser.Opera:
                    driver = new OperaDriver();
                    break;
                default:
                    driver = new FirefoxDriver();
                    break;
            }

            Log("++ InitializeDriver " + _BrowserType.ToString(), false);

            return driver;
        }
        #endregion
        #region IsElementPresent()
        public static bool IsElementPresent(By by)
        {
            Log("++ IsElementPresent", false);
            try
            {
                Globals._Driver.FindElement(by);
                return true;
            }
            catch (NoSuchElementException e)
            {
                Log("-- " + e.Message, false);
                return false;
            }
        }
        #endregion
        #region Logging()
        public static void Log(string message, bool createNewLogFile)
        {
            bool takeScreenshot = false;
            if (message.StartsWith("-"))
                takeScreenshot = true;
            string month = DateTime.Now.Month.ToString();
            string day = DateTime.Now.Day.ToString();
            string year = DateTime.Now.Year.ToString();
            string hour = DateTime.Now.Hour.ToString();
            string minute = DateTime.Now.Minute.ToString();
            string assembledDate = month + " - " + day + " - " + year + "_" + hour + " - " + minute;

            message = DateTime.Now.ToString() + ":\t" + message;

            if (createNewLogFile)
                Globals._LogFilename = Globals._TestCaseName + " (" + assembledDate + ").txt";

            string logFileLocation = Environment.GetEnvironmentVariable("USERPROFILE") + "\\Documents\\logging";

            if (!Directory.Exists(logFileLocation))
                Directory.CreateDirectory(logFileLocation);

            try
            {
                File.AppendAllText(logFileLocation + "\\" + Globals._LogFilename, message + "\r\n");
                if (takeScreenshot)
                    Screenshot(logFileLocation, Globals._TestCaseName + "_" + assembledDate.Replace(" ", "") + ".png");
            }
            catch (Exception e)
            {
                Assert.Fail(e.Message);
            }
        }
        #endregion
        #region Screenshot()
        public static void Screenshot(string fileLocation, string filename)
        {
            try
            {
                ITakesScreenshot screenshotDriver = Globals._Driver as ITakesScreenshot;
                Screenshot screenshot = screenshotDriver.GetScreenshot();
                screenshot.SaveAsFile(fileLocation + "\\" + filename, ImageFormat.Png);
            }
            catch(Exception e)
            {
                Log(e.Message, false);
            }
        }
        #endregion
        #region SortType()
        public static string SortType(_SortType sortType)
        {
            string sortName = "";
            switch (sortType)
            {
                case _SortType.Popular:
                    sortName = "Popular";
                    break;
                case _SortType.PriceLowToHigh:
                    sortName = "Price: Low to High";
                    break;
                case _SortType.PriceHighToLow:
                    sortName = "Price: High to Low";
                    break;
                case _SortType.NameAtoZ:
                    sortName = "Name: A-Z";
                    break;
                case _SortType.NameZtoA:
                    sortName = "Name: Z-A";
                    break;
                case _SortType.ManufacturerAtoZ:
                    sortName = "Manufacturer: A-Z";
                    break;
                case _SortType.ManufacturerZtoA:
                    sortName = "Manufacturer: Z-A";
                    break;
                default:
                case _SortType.Default:
                    sortName = "Sort Devices By...";
                    break;
            }

            return sortName;
        }
        #endregion
        #region WaitForElement()
        public static bool WaitForElement(string element, _By by, int timeoutHalfSeconds)
        {
            Log("++ WaitForElement", false);
            for (int i = 0; i < timeoutHalfSeconds; i++)
            {
                switch (by)
                {
                    case _By.className:
                        if (IsElementPresent(By.ClassName(element)))
                        {
                            i = timeoutHalfSeconds;
                            return true;
                        }
                        break;
                    case _By.cssSelector:
                        if (IsElementPresent(By.CssSelector(element)))
                        { 
                            i = timeoutHalfSeconds;
                            return true;
                        }
                        break;
                    case _By.id:
                        if (IsElementPresent(By.Id(element)))
                        { 
                            i = timeoutHalfSeconds;
                            return true;
                        }
                        break;
                    case _By.linkText:
                        if (IsElementPresent(By.LinkText(element)))
                        { 
                            i = timeoutHalfSeconds;
                            return true;
                        }
                        break;
                    case _By.partialLinkText:
                        if (IsElementPresent(By.PartialLinkText(element)))
                        {
                            i = timeoutHalfSeconds;
                            return true;
                        }
                        break;
                    case _By.tagName:
                        if (IsElementPresent(By.TagName(element)))
                        { 
                            i = timeoutHalfSeconds;
                            return true;
                        }
                        break;
                    case _By.xPath:
                        if (IsElementPresent(By.XPath(element)))
                        { 
                            i = timeoutHalfSeconds;
                            return true;
                        }
                        break;
                    default:
                        if (IsElementPresent(By.Name(element)))
                        { 
                            i = timeoutHalfSeconds;
                            return true;
                        }
                        break;
                }

                Thread.Sleep(500);
            }
            Log("-- Unable to find " + element, false);
            return false;
        }
        #endregion
        #region GetOrderNumber()
        public static string GetOrderNumber()
        {
            Log("++ GetOrderNumber", false);
            string orderNumber = "";

            try
            {
                string pageText = Globals._Driver.FindElement(By.XPath("//div[@id='mainContent']/div/div/p")).Text;
                int o = pageText.IndexOf("#");
                pageText = pageText.Remove(0, o + 1);
                int space = pageText.IndexOf(" ");
                orderNumber = pageText.Remove(space);
                Log("+ OrderNumber: " + orderNumber, false);

                return orderNumber;
            }
            catch (Exception e)
            {
                Log("-- " + e.Message, false);
                return "false";
            }
        }
        #endregion
    }
}
