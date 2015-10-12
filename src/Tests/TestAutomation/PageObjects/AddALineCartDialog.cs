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
    public enum ServicePlanType
    {
        FamilyOrShared,
        IndividualOrBusinessAccount,
        NoPlan
    }

    public class AddALineCartDialog : BaseCartDialog, ICartDialog
    {
        string CarrierName { get; set; }
        string ProductTitle { get; set; }
        string ProductPrice { get; set; }

        IWebElement FamilyorSharedPlanButton;
        IWebElement IndividualOrBusinessAccountButton;
        IWebElement NoPlanButton;
        IWebElement CancelButton;
        IWebElement NextButton;

        public AddALineCartDialog(IWebDriver Driver, string carrierName, string productTitle, string productPrice, string ZipCode) : base(Driver, ZipCode)
        {
            CarrierName = carrierName;
            ProductTitle = productTitle;
            ProductPrice = productPrice;
        }

        public override void Initialize()
        {
            Driver.SwitchTo().ActiveElement();
            WebDriverWait wait = new WebDriverWait(Driver, TimeSpan.FromSeconds(5));
            wait.Until(ExpectedConditions.ElementIsVisible(By.XPath(AddALineCartDialogUI.CurrentZipCodeLinkXPath)));
            FamilyorSharedPlanButton = Driver.FindElement(By.Id(AddALineCartDialogUI.FamilyOrSharedPlanButtonId));
            IndividualOrBusinessAccountButton = Driver.FindElement(By.Id(AddALineCartDialogUI.IndividualOrBusinessAccountButtonId));
            NoPlanButton = Driver.FindElement(By.Id(AddALineCartDialogUI.NextPlanButtonId));
            CancelButton = Driver.FindElement(By.Id(AddALineCartDialogUI.CancelButtonId));
            NextButton = Driver.FindElement(By.Id(AddALineCartDialogUI.NextPlanButtonId));
        }

        public void ChoosePlan(ServicePlanType Type)
        {
            switch (Type)
            {
                case ServicePlanType.FamilyOrShared:
                    FamilyorSharedPlanButton.Click();
                    break;
                case ServicePlanType.IndividualOrBusinessAccount:
                    IndividualOrBusinessAccountButton.Click();
                    break;
                case ServicePlanType.NoPlan:
                    NoPlanButton.Click();
                    break;
            }
        }

        public void CancelPlanSelection()
        {
            CancelButton.Click();
        }

        public void SubmitSelectedPlan()
        {
            NextButton.Click();
        }
    }
}
