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
    
    public partial class Applied
    {
        public int PromotionAppliedId { get; set; }
        public int PromotionId { get; set; }
        public Nullable<int> UserId { get; set; }
        public Nullable<int> OrderId { get; set; }
        public Nullable<System.DateTime> ApplyDate { get; set; }
    
        public virtual PromotionCode PromotionCode { get; set; }
        public virtual User User { get; set; }
        public virtual Order1 Order { get; set; }
    }
}
