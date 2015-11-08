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
        static string _PreviousError = "";
        static string _PreviousMessage = "";
        static int _ScreenshotNum = 0;

        #region CloseAlertAndGetItsText()
        public static string CloseAlertAndGetItsText()
        {
            Log("++ CloseAlertAndGetItsText");
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
                Log("+ AlertText: " + alertText);
                return alertText;
            }
            finally
            {
                Globals._AcceptNextAlert = true;
            }
        }
        #endregion
        #region ClearLogFolder()
        public static void ClearLogFolder()
        {
            string logFolder = Environment.GetEnvironmentVariable("USERPROFILE") + "\\Documents\\logging";

            try
            {
                string[] files = Directory.GetFiles(logFolder);

                foreach (string file in files)
                    File.Delete(file);
            }
            catch (Exception e)
            {
                Assert.Fail();
                Console.WriteLine(e.Message);
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

            if (m <= 9)
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
        #region GetOrderNumber()
        public static string GetOrderNumber()
        {
            Log("++ GetOrderNumber");
            string orderNumber = "";

            try
            {
                string pageText = Globals._Driver.FindElement(By.XPath("//div[@id='mainContent']/div/div/p")).Text;
                int o = pageText.IndexOf("#");
                pageText = pageText.Remove(0, o + 1);
                int space = pageText.IndexOf(" ");
                orderNumber = pageText.Remove(space);
                Globals._OrderNumber = orderNumber;
                Log("+ OrderNumber: " + orderNumber);

                return orderNumber;
            }
            catch (Exception e)
            {
                Log("- " + e.Message);
                return "false";
            }
        }
        #endregion
        #region CheckForProblemsOnPage()
        public static string CheckForProblemsOnPage()
        {
            try
            {
                if (Utilities.IsElementPresent(By.Id("progressLabel")))
                    Log(Globals._Driver.FindElement(By.Id("progressLabel")).Text);

                string messageContent = Globals._Driver.FindElement(By.XPath("//div[@id='mainContent']/div/div")).Text;

                if (messageContent.ToLower().Contains("error") || messageContent.ToLower().Contains("technical difficulties"))
                {
                    Log(messageContent);
                    Assert.Fail(messageContent);
                }

                return messageContent;
            }
            catch
            {
                return "";
            }
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
                XmlElement admin = (XmlElement)xmlDoc.SelectSingleNode("//Admin");
                XmlElement line = (XmlElement)xmlDoc.SelectSingleNode("//Line");
                XmlElement database = (XmlElement)xmlDoc.SelectSingleNode("//Database");

                string timeoutOverride = testCase.GetAttribute("timeoutHalfSeconds");
                if (timeoutOverride != "")
                    Globals._DefaultTimeoutValue = Convert.ToInt32(timeoutOverride);
                if (testCase != null)
                {
                    Globals._TestCaseName = testCase.GetAttribute("name");
                    Globals._BaseURL = testCase.GetAttribute("baseUrl");
                }
                if (name != null)
                {
                    Globals._CustomerFirstName = name.GetAttribute("firstName");
                    Globals._CustomerLastName = name.GetAttribute("lastName");
                }
                if (home != null)
                {
                    Globals._CustomerStreetAddress = home.GetAttribute("streetAddress");
                    Globals._CustomerCity = home.GetAttribute("city");
                    Globals._CustomerState = home.GetAttribute("state");
                    Globals._CustomerZipCode = home.GetAttribute("zipCode");
                }
                if (contact != null)
                {
                    Globals._CustomerMobileNumber = contact.GetAttribute("mobileNumber");
                    Globals._RetainNumber = contact.GetAttribute("retainNumber");
                    Globals._CustomerEmail = contact.GetAttribute("email");
                }
                if (financial != null)
                {
                    Globals._CustomerCreditCard = financial.GetAttribute("cardNumber");
                    Globals._CustomerCcExpirationMonth = financial.GetAttribute("expireMonth");
                    Globals._CustomerCcExpirationYear = financial.GetAttribute("expireYear");
                    Globals._CustomerCcCvv = financial.GetAttribute("cvv");
                }
                if (personal != null)
                {
                    Globals._CustomerLast4Ssn = personal.GetAttribute("last4Ssn");
                    Globals._CustomerAccountPassword = personal.GetAttribute("accountPassword");
                }
                if (device != null)
                {
                    Globals._DeviceId = device.GetAttribute("id");
                    Globals._DeviceName = device.GetAttribute("name");
                }
                if (carrier != null)
                {
                    Globals._CarrierPassword = carrier.GetAttribute("password");
                    Globals._CarrierZipCode = carrier.GetAttribute("zipCode");
                }
                if (admin != null)
                {
                    Globals._AdminUsername = admin.GetAttribute("omtUsername");
                    Globals._AdminPassword = admin.GetAttribute("omtPassword");
                }
                if (line != null)
                {
                    Globals._Imei = line.GetAttribute("imei");
                    Globals._Sim = line.GetAttribute("sim");
                    Globals._RemoveLine = Convert.ToBoolean(line.GetAttribute("removeLine"));
                }
                if (testCase != null)
                    Globals._ActivateLineInOmt = Convert.ToBoolean(testCase.GetAttribute("activateDevice"));
                if (database != null)
                {
                    Globals._ServerName = database.GetAttribute("serverName");
                    Globals._DatabaseName = database.GetAttribute("databaseName");
                    Globals._DatabaseUsername = database.GetAttribute("username");
                    Globals._DatabasePassword = database.GetAttribute("password");
                }

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

            Log("++ InitializeDriver " + _BrowserType.ToString());

            return driver;
        }
        #endregion
        #region IsElementEnabled()
        public static bool IsElementEnabled(By by)
        {
            Log("++ IsElementEnabled");
            try
            {
                return Globals._Driver.FindElement(by).Enabled;
            }
            catch (NoSuchElementException e)
            {
                Log("- " + e.Message);
                return false;
            }
        }
        #endregion
        #region IsElementPresent()
        public static bool IsElementPresent(By by)
        {
            Log("++ IsElementPresent");
            try
            {
                return Globals._Driver.FindElement(by).Displayed;
            }
            catch (NoSuchElementException e)
            {
                Log("- " + e.Message);
                return false;
            }
        }
        #endregion
        #region Logging()
        public static void Log(string message, bool createNewLogFile)
        {
            // Exit if the message is identical to the previous message to avoid unnecessary noise
            if (message == _PreviousError || message == _PreviousMessage)
                return;

            // Variable to store whether a screenshot is needed
            bool takeScreenshot = false;

            if (message.StartsWith("-"))
            {
                // Set the screenshot variable to true, increment the screenshot ID number, and store the previous error
                takeScreenshot = true;
                _ScreenshotNum++;
                _PreviousError = message;
            }
            else
                // Otherwise store the previous log message
                _PreviousMessage = message;

            // Assemble the timestamp to be used in the logfile name
            string month = DateTime.Now.Month.ToString();
            string day = DateTime.Now.Day.ToString();
            string year = DateTime.Now.Year.ToString();
            string hour = DateTime.Now.Hour.ToString();
            string minute = DateTime.Now.Minute.ToString();
            string assembledDate = month + "-" + day + "-" + year + "_" + hour + "-" + minute;

            // Prepend the timestamp to the log message
            message = DateTime.Now.ToString() + ":\t" + message;

            // Match the screenshot name with the failure message in the log message
            if (takeScreenshot)
                message += ", screenshot:" + _ScreenshotNum.ToString();

            // Create a new log file if the flag is set, otherwise we just append the log message
            if (createNewLogFile)
                Globals._LogFilename = Globals._TestCaseName + " (" + assembledDate + ").txt";

            // Store the location of the log file in the <Drive>:\Users\<user ID>\Documents\logging folder
            string logFileLocation = Environment.GetEnvironmentVariable("USERPROFILE") + "\\Documents\\logging";

            // Create the folder if it doesn't already exist
            if (!Directory.Exists(logFileLocation))
                Directory.CreateDirectory(logFileLocation);

            try
            {
                // Write the log file
                File.AppendAllText(logFileLocation + "\\" + Globals._LogFilename, message + "\r\n");

                // Take a screenshot
                if (takeScreenshot)
                    Screenshot(logFileLocation, Globals._TestCaseName + " - " + _ScreenshotNum.ToString() + ".png");
            }
            catch (Exception e)
            {
                Assert.Fail(e.Message);
            }
        }
        public static void Log(string message)
        {
            Log(message, false);
        }
        #endregion
        #region RandNumberGenerator()
        public static int RandNumberGenerator(int digits)
        {
            if (digits > 9)
                digits = 9;

            string randomNumber = null;

            for (int i = 0; i < digits; i++)
                randomNumber += Globals._RandomNumberGenerator.Next(1, 9);

            return Convert.ToInt32(randomNumber);
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
                Log(e.Message);
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
            Log("++ WaitForElement");
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

            Log("- Unable to find " + element);
            return false;
        }
        #endregion
    }
}
