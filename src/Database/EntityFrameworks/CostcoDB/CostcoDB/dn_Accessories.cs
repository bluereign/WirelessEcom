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
    
    public partial class dn_Accessories
    {
        public System.Guid AccessoryGuid { get; set; }
        public System.Guid ProductGuid { get; set; }
        public int ProductId { get; set; }
        public int product_id { get; set; }
        public string GersSku { get; set; }
        public Nullable<int> category_id { get; set; }
        public Nullable<int> categoryName { get; set; }
        public Nullable<int> group_id { get; set; }
        public string pageTitle { get; set; }
        public string summaryTitle { get; set; }
        public string detailTitle { get; set; }
        public string summaryDescription { get; set; }
        public string detailDescription { get; set; }
        public string MetaKeywords { get; set; }
        public decimal price_retail { get; set; }
        public decimal price { get; set; }
        public System.Guid CompanyGuid { get; set; }
        public string ManufacturerName { get; set; }
        public string UPC { get; set; }
        public Nullable<int> QtyOnHand { get; set; }
        public Nullable<long> DefaultSortRank { get; set; }
    }
}
