using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TestAutomation.PageObjects
{
    public static class BasePageUI
    {
        public static string HomePageUrl = "http://membershipwireless.com/";
        public static string PhonesMenuXPath = ".//*[@id='nav-menu']/li[3]/a";
        public static string AllPhonesMenuXPath = ".//*[@id='nav-menu']/li[3]/ul/li[1]/a";
        public static string AttMenuXPath = ".//*[@id='nav-menu']/li[3]/ul/li[2]/a";
        public static string TMobileMenuXPath = ".//*[@id='nav-menu']/li[3]/ul/li[3]/a";
        public static string VerizonMenuXPath = ".//*[@id='nav-menu']/li[3]/ul/li[4]/a";
        public static string SprintMenuXPath = ".//*[@id='nav-menu']/li[3]/ul/li[5]/a";
        public static string UpgradePhoneMenuXPath = ".//*[@id='nav-menu']/li[3]/ul/li[6]/a";
        public static string PrepaidPhonesMenuXPath = ".//*[@id='nav-menu']/li[3]/ul/li[7]/a";
        public static string ServicePlansMenuXPath = ".//*[@id='nav-menu']/li[3]/ul/li[8]/a";
    }

    public static class CommonDeviceDetailsUI
    {
        public static string DeviceImageId = "prodDetailImg";
        public static string ContractButtonId = "btn-contract";
        public static string ContractButtonHeaderXPath = ".//*[@id='btn-contract']/div";
        public static string ContractPriceNewButtonXPath = ".//*[@id='priceBlockHeader-new']";
        public static string ContractPriceUpgradeButtonXPath = ".//*[@id='priceBlockHeader-upgrade']";
        public static string ContractPriceAalButtonXPath = ".//*[@id='priceBlockHeader-aal']";
        public static string FinanceButtonId = "btn-finance";
        public static string LearnMoreButtonClassName = "ActionButton";
        public static string ContinueButtonClassName = "ActionButton";
        public static string AvailabilityStatusId = "availability-container-nonfinance";
    }
    
    public static class AttDeviceDetailsUI
    {
        public static string AttNext24ButtonId = "priceBlockHeader-AT&T Next24";
        public static string AttNext24RegularPriceXPath = ".//*[@id='price-slide-AT&T Next24']/table/tbody/tr[1]/td[2]";
        public static string AttNext18ButtonId = "priceBlockHeader-AT&T Next18";
        public static string AttNext18RegularPriceXPath = ".//*[@id='price-slide-AT&T Next18']/table/tbody/tr[1]/td[2]"; //FirePath cannot find this element!
        public static string AttNext12ButtonId = "priceBlockHeader-AT&T Next12";
        public static string AttNext12RegularPriceXPath = ".//*[@id='price-slide-AT&T Next12']/table/tbody/tr[1]/td[2]";
        public static string AttNextMoreInfoUrl = "http://membershipwireless.com/content/att-next";
        public static string FinanceModalDialogImageXPath = ".//*[@id='financeModal']/div/div/div/a/img";
        public static string FinanceModalDialogCloseButtonXPath = ".//*[@id='financeModal']/div/div/div/button";
    }
    
    public static class VerizonDeviceDetailsUI
    {
        public static string DeviceTitleClassName = "productTitle";
        public static string DeviceDownPaymentXPath = "/html/body/div[2]/div[1]/div/div[1]/div[1]/div[2]/div[3]/div/div/button/div[2]";
        public static string DevicePaymentPlanXPath = "/html/body/div[2]/div[1]/div/div[1]/div[1]/div[2]/div[3]/div/div/div[1]/table/tbody/tr[1]/td[2]";
        public static string DeviceFullRetailPriceXPath = "/html/body/div[2]/div[1]/div/div[1]/div[1]/div[2]/div[3]/div/div/div[1]/table/tbody/tr[2]/td[2]";
        public static string VerizonNewPriceButtonId = "priceBlockHeader-new";
        public static string VerizonAddToCartNewButonId = "addtocart-new";
        public static string VerizonUpgradePriceButtonId = "priceBlockHeader-upgrade";
        public static string VerizonAddToCartUpgradeButtonId = "addtocart-upgrade";
        public static string VerizonAddLinePriceButtonId = "priceBlockHeader-addaline";
        public static string VerizonAddToCartAddLineButtonId = "addtocart-addaline";


        //public static string availabilityStatusXpath = "/html/body/div[2]/div[1]/div/div[1]/div[1]/div[2]/div[4]/div[1]/div/em";
    }
    
    public static class CartDialog
    {
        public static string DeviceImageClassName = "device-image";
        public static string DeviceLogoXpath = "/html/body/div[5]/div[2]/div/div/div/div/div/div/img[2]";
        public static string DeviceTitleId = "product-title";
        public static string DevicePriceClassName = "final-price-container";
        public static string NewActivationId = "new-activation";
        public static string UpgradeActivationId = "upgrade-activation";
        public static string AddNewDeviceId = "aal-activation";
        public static string ZipCodeFieldId = "zipCodeInput";
        public static string ContinueButtonClassName = "ActionButton";
    }

    public static class BrowsePhonesUI
    {

    }

    public static class ComparePhonesUI
    {

    }

    public static class BrowsePlansUI
    {

    }
    public static class TMobileDeviceDetailsUI
    {
        public static string TMobilePriceXPath = "";
    }
  


    public static class SprintDeviceDetailsUI
    {
        public static string SprintPriceXPath = "";
    }
}
