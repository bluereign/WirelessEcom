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
    
    public partial class vRateplanDeviceServiceSPT
    {
        public System.Guid RateplanGuid { get; set; }
        public System.Guid DeviceGuid { get; set; }
        public System.Guid ServiceGuid { get; set; }
        public string RateplanBillCode { get; set; }
        public string UPC { get; set; }
        public System.Guid CarrierGuid { get; set; }
        public string CarrierName { get; set; }
        public string ServiceBillCode { get; set; }
        public string Title { get; set; }
        public Nullable<decimal> MonthlyFee { get; set; }
        public Nullable<bool> IsIncluded { get; set; }
    }
}
