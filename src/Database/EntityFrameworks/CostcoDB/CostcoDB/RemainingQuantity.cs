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
    
    public partial class RemainingQuantity
    {
        public int PromotionDurationId { get; set; }
        public Nullable<int> PromotionId { get; set; }
        public Nullable<int> RemainingQuantity1 { get; set; }
    
        public virtual PromotionCode PromotionCode { get; set; }
    }
}
