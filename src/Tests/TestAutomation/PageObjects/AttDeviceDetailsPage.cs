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
    public enum FinanceTerm
    {
        Next24,
        Next18,
        Next12
    }

    public class AttDeviceDetailsPage : BaseDeviceDetailsPage
    {
        IWebElement Next24Button;
        IWebElement Next18Button;
        IWebElement Next12Button;

        public AttDeviceDetailsPage(IWebDriver Driver, string DevicePageUrl, string CarrierName, string ProductTitle)
            : base(Driver, DevicePageUrl, AttCarrierName, ProductTitle)
        {
        }

        public override void Initialize()
        {
            base.Initialize();

            if (IsFinanceEnabled)
            {
                Next24Button = Driver.FindElement(By.Id(AttDeviceDetailsUI.FinanceNext24ButtonId));
                Next18Button = Driver.FindElement(By.Id(AttDeviceDetailsUI.FinanceNext18ButtonId));
                Next12Button = Driver.FindElement(By.Id(AttDeviceDetailsUI.FinanceNext12ButtonId));
            }
        }

        public AttRedirectDialog LearnMore()
        {
            base.FinanceLearnMore();

            return new AttRedirectDialog(Driver);
        }

        public void SelectFinanceTerm(FinanceTerm financeTerm)
        {
            switch (financeTerm)
            {
                case FinanceTerm.Next24:
                    Next24Button.Click();
                    break;
                case FinanceTerm.Next18:
                    Next18Button.Click();
                    break;
                case FinanceTerm.Next12:
                    Next12Button.Click();
                    break;
                default:
                    break;
            }
        }

    }
}
