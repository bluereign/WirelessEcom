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
    
    public partial class Rebate1
    {
        public System.Guid RebateGuid { get; set; }
        public string Title { get; set; }
        public decimal Amount { get; set; }
        public bool Active { get; set; }
        public string URL { get; set; }
        public string Type { get; set; }
        public string DisplayType { get; set; }
        public string Description { get; set; }
        public string SpecialInstructions { get; set; }
        public Nullable<System.DateTime> StartDate { get; set; }
        public Nullable<System.DateTime> EndDate { get; set; }
        public string RebateCode { get; set; }
    }
}
