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
    
    public partial class GersPriceGroup
    {
        public GersPriceGroup()
        {
            this.GersPrices = new HashSet<GersPrice>();
        }
    
        public string PriceGroupCode { get; set; }
        public string PriceGroupDescription { get; set; }
    
        public virtual ICollection<GersPrice> GersPrices { get; set; }
    }
}
