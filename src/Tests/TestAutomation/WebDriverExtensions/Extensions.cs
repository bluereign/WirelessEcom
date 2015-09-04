using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;

namespace TestAutomation.WebDriverExtensions
{
    public static class Extensions
    {
        /// <summary>
        /// Same as FindElement only returns null when not found instead of an exception.
        /// </summary>
        /// <param name="driver">current browser instance</param>
        /// <param name="by">The search string for finding element</param>
        /// <returns>Returns element or null if not found</returns>
        public static IWebElement FindElementSafe(this IWebDriver driver, By by)
        {
            try
            {
                return driver.FindElement(by);
            }
            catch (NoSuchElementException)
            {
                return null;
            }
        }

        /// <summary>
        /// Requires finding element by FindElementSafe(By).
        /// Returns T/F depending on if element is defined or null.
        /// </summary>
        /// <param name="element">Current element</param>
        /// <returns>Returns T/F depending on if element is defined or null.</returns>
        public static bool Exists(this IWebElement element)
        {
            if (element == null)
            { return false; }
            return true;
        }
    }
}
