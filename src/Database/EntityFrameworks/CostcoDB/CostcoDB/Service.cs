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
    
    public partial class Service
    {
        public System.Guid ServiceGuid { get; set; }
        public System.Guid CarrierGuid { get; set; }
        public string CarrierServiceId { get; set; }
        public string CarrierBillCode { get; set; }
        public string Title { get; set; }
        public Nullable<decimal> MonthlyFee { get; set; }
        public string CartTypeId { get; set; }
    }
}
