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
    
    public partial class Coupon1
    {
        public int CouponId { get; set; }
        public string CouponCode { get; set; }
        public Nullable<System.DateTime> ValidStartDate { get; set; }
        public Nullable<System.DateTime> ValidEndDate { get; set; }
        public System.DateTime DateCreated { get; set; }
        public Nullable<decimal> DiscountValue { get; set; }
        public Nullable<int> CreatedBy { get; set; }
        public Nullable<System.DateTime> LastUpdated { get; set; }
        public Nullable<int> UpdatedBy { get; set; }
        public Nullable<decimal> MinPurchase { get; set; }
    }
}
