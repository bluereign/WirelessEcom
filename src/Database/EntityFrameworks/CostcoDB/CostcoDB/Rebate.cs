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
    
    public partial class Rebate
    {
        public System.Guid RebateGUID { get; set; }
        public bool Active { get; set; }
        public Nullable<long> CarrierID { get; set; }
        public Nullable<int> Number { get; set; }
        public string Name { get; set; }
        public string LinkDescription { get; set; }
        public string Filename { get; set; }
        public string AltTag { get; set; }
        public System.DateTime StartDateTime { get; set; }
        public System.DateTime EndDateTime { get; set; }
        public System.Guid ImageGUID { get; set; }
        public string Keywords { get; set; }
        public string CreatedBy { get; set; }
        public Nullable<System.DateTime> CreatedOn { get; set; }
        public string ModifiedBy { get; set; }
        public Nullable<System.DateTime> ModifiedOn { get; set; }
    }
}
