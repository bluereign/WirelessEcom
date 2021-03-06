﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TestAutomation.PageObjects
{
    public static class BasePageUI
    {
        public static string HomePageUrl = "http://membershipwireless.com";
        public static string TestHomePageUrl = "http://costco.ecom-dev-test-1.enterprise.corp/";
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
        //Device Image, Logo and Title
        public static string DeviceImageId = "prodDetailImg";
        public static string DeviceLogoClassName = "logo-container";
        public static string DeviceTitleClassName = "productTitle";

        //Pricing Type Information
        public static string PricingTypeRootXPath = ".//*[@id='mainContent']/div/div/div[1]/div[3]/div[1]";

        //Contract
        public static string ContractButtonId = "btn-contract";
        public static string ContractButtonHeaderXPath = ".//*[@id='btn-contract']/div";
        public static string NewPriceButtonId = "priceBlockHeader-new";
        public static string NewRegularPriceXPath = ".//*[@id='price-slide-contract']/table/tbody/tr[1]/td[2]";
        public static string NewAgreementDiscountXPath = ".//*[@id='price-slide-contract']/table/tbody/tr[2]/td[2]";
        public static string NewMailInRebateXPath = ".//*[@id='price-slide-contract']/table/tbody/tr[3]/td[2]";

        //Upgrade
        public static string UpgradePriceButtonId = "priceBlockHeader-upgrade";
        public static string UpgradeRegularPriceXPath = ".//*[@id='price-slide-upgrade']/table/tbody/tr[1]/td[2]";
        public static string UpgradeAgreementDiscountXPath = ".//*[@id='price-slide-upgrade']/table/tbody/tr[2]/td[2]";
        public static string UpgradeMailInRebateXPath = ".//*[@id='price-slide-upgrade']/table/tbody/tr[3]/td[2]";

        //Add A Line - Bug 585: 'price-slide-addaline' should be used instead of the duplicated 'price-slide-upgrade'
        public static string AddALinetPriceButtonId = "priceBlockHeader-addaline";
        public static string AddALineRegularPriceXPath = ".//*[@id='price-slide-addaline']/table/tbody/tr[1]/td[2]";
        public static string AddALineAgreementDiscountXPath = ".//*[@id='price-slide-addaline']/table/tbody/tr[2]/td[2]";
        public static string AddALineMailInRebateXPath = ".//*[@id='price-slide-addaline']/table/tbody/tr[3]/td[2]";
        
        //Finance
        public static string FinanceButtonId = "btn-finance";
        public static string FinanceButtonHeaderXPath = ".//*[@id='btn-finance']/div";
        public static string FinanceLearnMoreButtonId = "addtocartfinanceDiv";
        public static string FinanceActionButtonXPath = ".//*[@id='addtocartfinanceDiv']/a";
        public static string FinanceAvailabilityStatusId = "availability-container-nonfinance";
        public static string FinanceModalDialogCloseButtonXPath = ".//*[@id='financeModal']/div/div/div/button";
        public static string FinanceModalDialogBodyXPath = ".//*[@id='financeModal']/div/div/div";


        //Add to Cart
        public static string NewAddToCartButtonId = "addtocart-new";
        public static string NewActionButtonXPath = ".//*[@id='addtocart-new']/a";
        public static string UpgradeAddToCartButtonId = "addtocart-upgrade";
        public static string UpgradeActionButtonXPath = ".//*[@id='addtocart-upgrade']/a";
        public static string AddALineAddToCartButtonId = "addtocart-addaline";
        public static string AddALineActionButtonXPath = ".//*[@id='addtocart-addaline']/a";

        //Out of Stock
        
        public static string OutOfStockText = "Out of Stock";
        public static string OutOfStockXPath = ".//*[@id='addtocart-new']/a";
    }

    public static class AttDeviceDetailsUI
    {
        public static string FinanceNext24ButtonId = "priceBlockHeader-AT&T Next24";
        public static string FinanceNext24RegularPriceXPath = ".//*[@id='price-slide-AT&T Next24']/table/tbody/tr[1]/td[2]";
        public static string FinanceNext18ButtonId = "priceBlockHeader-AT&T Next18";
        public static string FinanceNext18RegularPriceXPath = ".//*[@id='price-slide-AT&T Next18']/table/tbody/tr[1]/td[2]"; //FirePath cannot find this element!
        public static string FinanceNext12ButtonId = "priceBlockHeader-AT&T Next12";
        public static string FinanceNext12RegularPriceXPath = ".//*[@id='price-slide-AT&T Next12']/table/tbody/tr[1]/td[2]";
        public static string FinanceNextMoreDetailsLink = "http://membershipwireless.com/content/att-next";
        public static string FinanceModalDialogImageXPath = ".//*[@id='financeModal']/div/div/div/a/img";
    }

    public static class VerizonDeviceDetailsUI
    {
        //Verizon Monthly
        public static string FinanceMonthlyButtonId = "priceBlockHeader-Verizon Monthly24";
        public static string FinanceFullRetailPriceXPath = ".//*[@id='price-slide-Verizon Monthly24']/table/tbody/tr[1]/td[2]";
        public static string FinanceMonthlyDevicePaymentXPath = ".//*[@id='price-slide-Verizon Monthly24']/table/tbody/tr[2]/td[2]";
        public static string FinanceLearnMoreButtonXPath = ".//*[@id='addtocartfinanceDiv']/a";
        public static string FinanceModalImageCloseButtonXPath = ".//*[@id='financeModal']/div/div/div/button";
        public static string FinanceModalImageMoreAboutLink = ".//*[@id='financeModal']/div/div/div/a/img";
    }

    public static class SprintDeviceDetailsUI
    {
        public static string FinanceSprintEasyPayButtonId = "priceBlockHeader-Sprint Easy Pay24";
        public static string FinanceSprintEasyPayRegularPriceXPath = ".//*[@id='price-slide-Sprint Easy Pay24']/table/tbody/tr[1]/td[2]";
        public static string FinanceSprintEasyPayDownPaymentXPath = ".//*[@id='price-slide-Sprint Easy Pay24']/table/tbody/tr[2]/td[2]";
        public static string MarketingDialogCloseButtonXPath = ".//*[@id='financeModal']/div/div/div/button";
    }

    public static class TMobileDeviceDetailsUI
    {
        //Simple Choice Option
        public static string SimpleChoiceButtonId = "priceBlockHeader-simplechoice";
        public static string SimpleChoiceFullRetailPriceXPath = ".//*[@id='price-slide-simplechoice']/table/tbody/tr/td[2]";
        public static string ContinueButtonId = "addtocart-finance";
        public static string ActionButtonXPath = ".//*[@id='addtocart-finance']/a";
        public static string ModalDialogCancelButtonXPath = ".//*[@id='tmoredirect']/div/div/div[3]/button";
        public static string ModalDialogRedirectButtonXPath = ".//*[@id='tmoredirect']/div/div/div[3]/a";
        public static string PriceNameXPath = "";
        public const string PriceToday = "Price Today";
        public static string PriceTodayXPath = "";
        public const string FullRetailPrice = "Full Retail Price";
        public const string FullRetailPriceXPath = "";
    }

    public static class AddToCartDialogUI
    {
        //Wireless Device selected, with Title and Final Price
        public static string DeviceImageClassName = "device-image";
        public static string DeviceLogoXPath = ".//*[@id='device-container']/img[2]"; //retrieve image file with src property
        public static string DeviceTitleId = "product-title";
        public static string DevicePriceClassName = "final-price-container";

        //Contract Type
        public static string NewActivationInputId = "new-activation";
        public static string UpgradeActivationInputId = "upgrade-activation";
        public static string AddALineActivationInputId = "aal-activation";

        public static string ZipCodeInputFieldId = "zipCodeInput";
        public static string ContinueButtonXPath = ".//*[@id='AddToCartForm']/div[2]/div/a";

        //Cart Form:
        //--Zip Code
        public static string CurrentZipCodeFieldXPath = ".//*[@id='zipHeader']/span[1]/a";
        public static string EditZipCodeFieldClassName = "input_newZipcode";
        public static string DeviceImageLinkXPath = ".//*[@id='tab1']/div/div/div[1]/div/div[2]/div[1]";

        //--Manage Device
        public static string ViewDeviceLinkXPath = ".//*[@id='tab1']/div/div/div[1]/div/div[2]/div[2]/div[1]/span[2]";
        public static string ChangeDeviceLinkXPath = ".//*[@id='tab1']/div/div/div[1]/div/div[2]/div[2]/div[1]/span[3]";
        public static string RemoveDeviceLinkXPath = ".//*[@id='tab1']/div/div/div[1]/div/div[2]/div[2]/div[1]/span[4]";
        public static string LineLinkXPathRoot = "mt-tab";
        public static string FirstLineLinkId = "mt-tab1";

        //--Add a Line
        public static string AddALineButtonId = "mt-tAdd";
        public static string RemoveThisLineLinkXPath = ".//*[@id='tab1']/div/div/div[2]/span";       

        //Add Accessories
        public static string AccessoriesLinkId = "mt-tab999";
        public static string AddAccessoriesLinkXPath = ".//*[@id='otherAccessories']/li";
        public static string RemoveFromCartLinkXPath = ".//*[@id='tab1']/div/div/div[1]/div/div[7]/ul/li[1]/a";
        public static string AddMoreAccessoriesLinkXPath = ".//*[@id='tab1']/div/div/div[1]/div/div[7]/ul/li[2]/a";

        //Service Plan
        public static string ChooseServicePlanLinkXPath = ".//*[@id='tab1']/div/div/div[1]/div/div[4]";
        public static string ChangeServicePlanLinkXPath = ".//*[@id='tab1']/div/div/div[1]/div/div[4]/div/span[2]/a[1]";
        public static string RemoveServicePlanLinkXPath = ".//*[@id='tab1']/div/div/div[1]/div/div[4]/div/span[2]/a[2]";
        public static string SelectServicesForThisPlanLinkXPath = ".//*[@id='tab1']/div/div/div[1]/div/div[5]/ul/li/a";

        //Select Protection Plan
        public static string SquareTradeProtectionInputId = "AddProtectionPlan_10048";
        public static string NoProtectionPlanXPath = ".//*[@id='tab1']/div/div/div[1]/div/div[5]/ul/li/span";

        //Manage Cart
        public static string CartReviewButtonId = ".//*[@id='btnCartReview']";
        public static string CloseCartButtonXPath = ".//*[@id='dialog_addToCart_body']/div[3]/span[2]";
        public static string ClearCartButtonXPath = ".//*[@id='dialog_addToCart_body']/div[3]/span[1]";
        public static string CartFormCloseButtonId = "ext-gen15";

    }

    public static class AddALineCartDialogUI
    {
        public static string CurrentZipCodeLinkXPath = ".//*[@id='zipHeader']/span[1]";
        public static string EditZipCodeInputXPath = ".//*[@id='zipHeader']/span[2]";
        public static string SaveNewZipCodeButtonXPath = ".//*[@id='zipHeader']/span[2]";
        public static string CancelEditZipCodeButtonXPath = ".//*[@id='zipHeader']/span[2]";
        public static string FamilyOrSharedPlanButtonId = "aalFamily";
        public static string IndividualOrBusinessAccountButtonId = "aalIndividual";
        public static string NoPlanId = "aalNoPlan";
        public static string CancelButtonId = "cancel";
        public static string NextPlanButtonId = "submit";
        public static string ClearCartButtonXPath = ".//*[@id='dialog_addToCart_body']/div[3]/span[1]";
        public static string CloseCartButtonXPath = ".//*[@id='dialog_addToCart_body']/div[3]/span[2]";
        public static string CartReviewButtonId = "btnCartReview";
    }

    public static class CartReviewPageUI
    {
        public static string ZipCodeXPath = ".//*[@id='reviewZip']/div/span";
        public static string ClearCartButtonUpXPath = ".//*[@id='mainContent']/div/div/div[3]/div[1]/span[1]";
        public static string ContinueShoppingButtonXPath = ".//*[@id='mainContent']/div/div/div[3]/div[1]/span[2]";
        public static string CheckOutButtonUpXPath = ".//*[@id='mainContent']/div/div/div[3]/div[2]/a";
        public static string ChangeButtonXPath = ".//*[@id='mainContent']/div/div/div[4]/div[1]/span/a";
        public static string ProductTitleLinkXPath = ".//*[@id='mainContent']/div/div/div[4]/div[2]/div/table/tbody/tr[2]/td[1]/a";
        public static string ServicePlanLinkXPath = ".//*[@id='mainContent']/div/div/div[4]/div[2]/div/table/tbody/tr[4]/td[1]/a";
        public static string ProtectionPlanXPath = ".//*[@id='mainContent']/div/div/div[4]/div[2]/div/table/tbody/tr[6]/td[1]/span/a";
        public static string BrowseAccessoriesXPath = ".//*[@id='mainContent']/div/div/div[4]/div[2]/div/table/tbody/tr[7]/td[1]/a";
        public static string BrowseProtectionPlanXPath = ".//*[@id='mainContent']/div/div/div[4]/div[2]/div/table/tbody/tr[8]/td[1]/a";
        public static string AddServicesButtonXPath = ".//*[@id='mainContent']/div/div/div[4]/div[2]/div/div/span[1]/a";
        public static string AddAccessoriesButtonXPath = ".//*[@id='mainContent']/div/div/div[4]/div[2]/div/div/span[2]/a";
        public static string AddPhoneLinkXPath = ".//*[@id='mainContent']/div/div/div[5]/div/a";
        public static string AddAccessoryLinkXPath = ".//*[@id='mainContent']/div/div/div[6]/div/a";
        public static string PromotionalCodesInputFieldXPath = ".//*[@id='promotions']/input";
        public static string ApplyPromoCodesButtonId = "addPromotion";
        public static string TotalDueTodayXPath = "";
        public static string TotalMonthlyXPath = "";
        public static string ClearYourCartButtonDownXPAth = "";
        public static string ContinueShoppingButttonDownXPath = "";
        public static string CheckOutButtonDownXPath = "";
    }

    public static class BrowsePhonesUI
    {
        public const string AttLogoClassValue = "logo-att-25";
        public const string VerizonLogoClassValue = "logo-verizon-25";
        public const string TMobileLogoClassValue = "logo-tmo-25";
        public const string SprintLogoClassValue = "logo-sprint-25";

        public static string DeviceLogoClassName = "logoContainer";

        //Carrier filters
        public static string AttCarrierFilterInputId = "filterOption_1";
        public static string VerizonCarrierFilterInputId = "filterOption_3";
        public static string TMobileCarrierFilterInputId = "filterOption_2";
        public static string SprintCarrierFilterInputId = "filterOption_230";

        //Operating System filters
        public static string AndroidOpSystemFilterInputId = "filterOption_15";
        public static string iOSOpSystemFilterInputId = "filterOption_380";

        //Device Type filters
        public static string BasicPhonesDeviceTypeFilterInputId = "filterOption_312";        
        public static string SmartPhonesDeviceTypeFilterInputId = "filterOption_13";

        //Device Brand filters
        public static string AppleBrandFilterInputId = "filterOption_381";
        public static string HtcBrandFilterInputId = "filterOption_8";
        public static string LgBrandFilterInputId = "filterOption_6";
        public static string MotorolaBrandFilterInputId = "filterOption_7";
        public static string PantechBrandFilterInputId = "filterOption_11";
        public static string SamsungBrandFilterInputId = "filterOption_4";

        //Device filters
        public static string SamsungGalaxyNote4Id = "filterOption_465";
        public static string HtcOneId = "filterOption_478";
        public static string iPhone6Id = "filterOption_463";
        public static string SamsungGalaxyS6Id = "filterOption_476";
        public static string SamsungGalaxyS6EdgeId = "filterOption_477";
        public static string SamsungGalaxyS5SportId = "filterOption_453";
        public static string iPhone5sId = "filterOption_408";
        public static string LGG2Id = "filterOption_407";
        public static string SamsungGalaxyNote3Id = "filterOption_410";
        public static string SamsungGalaxyS4Mini = "filterOption_417";
        public static string SamsungGalaxyS5Id = "filterOption_433";

        public static string ProductListId = "prodList";
        public static string GetDeviceLogoXPath(int deviceIndex)
        {
            return ".//*[@id='prodList']/li[" + deviceIndex + "]/div[1]";
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="deviceIndex"></param>
        /// <param name="divRank">3 or 4</param>
        /// <returns></returns>
        public static string GetDeviceXPath1(int deviceIndex)
        {
            return ".//*[@id='prodList']/li[" + deviceIndex + "]/div[3]";
        }

        public static string GetDeviceXPath2(int deviceIndex)
        {
            return ".//*[@id='prodList']/li[" + deviceIndex + "]/div[4]";
        }

        public static string GetProductTitleXPath(int deviceIndex)
        {
            return ".//*[@id='prodList']/li[" + deviceIndex + "]/div[4]/div[1]";
        }
        
        public static string GetProductPriceXPath(int deviceIndex)
        {
            return ".//*[@id='prodList']/li[" + deviceIndex + "]/div[4]/div[2]";
        }

        public static string GetOutOfStockXPath(int index)
        {

            return "xpath";
        }
    }

    public static class ComparePhonesUI
    {

    }

    public static class BrowsePlansUI
    {

    }    
    
}