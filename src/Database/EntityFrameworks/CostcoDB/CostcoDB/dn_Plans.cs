//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace CostcoDB
{
    using System;
    using System.Collections.Generic;
    
    public partial class dn_Plans
    {
        public System.Guid RateplanGuid { get; set; }
        public Nullable<System.Guid> ProductGuid { get; set; }
        public int planId { get; set; }
        public int ProductId { get; set; }
        public string GersSku { get; set; }
        public string CarrierBillCode { get; set; }
        public string PlanName { get; set; }
        public string PlanType { get; set; }
        public Nullable<bool> IsShared { get; set; }
        public string PageTitle { get; set; }
        public string SummaryTitle { get; set; }
        public string DetailTitle { get; set; }
        public int FamilyPlan { get; set; }
        public string CompanyName { get; set; }
        public string CarrierName { get; set; }
        public Nullable<int> CarrierId { get; set; }
        public System.Guid CarrierGuid { get; set; }
        public string CarrierLogoSmall { get; set; }
        public string CarrierLogoMedium { get; set; }
        public string CarrierLogoLarge { get; set; }
        public string SummaryDescription { get; set; }
        public string DetailDescription { get; set; }
        public Nullable<decimal> PlanPrice { get; set; }
        public Nullable<decimal> MonthlyFee { get; set; }
        public Nullable<int> IncludedLines { get; set; }
        public Nullable<int> MaxLines { get; set; }
        public Nullable<decimal> AdditionalLineFee { get; set; }
        public string minutes_anytime { get; set; }
        public string minutes_offpeak { get; set; }
        public string minutes_mobtomob { get; set; }
        public string minutes_friendsandfamily { get; set; }
        public Nullable<bool> unlimited_offpeak { get; set; }
        public Nullable<bool> unlimited_mobtomob { get; set; }
        public Nullable<bool> unlimited_friendsandfamily { get; set; }
        public Nullable<bool> unlimited_data { get; set; }
        public Nullable<bool> unlimited_textmessaging { get; set; }
        public Nullable<bool> free_longdistance { get; set; }
        public Nullable<bool> free_roaming { get; set; }
        public string data_limit { get; set; }
        public string additional_data_usage { get; set; }
        public string MetaKeywords { get; set; }
        public string DataLimitGb { get; set; }
    }
}
