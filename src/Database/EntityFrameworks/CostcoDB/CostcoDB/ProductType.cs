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
    
    public partial class ProductType
    {
        public ProductType()
        {
            this.ProductGuids = new HashSet<ProductGuid>();
        }
    
        public byte ProductTypeId { get; set; }
        public string ProductType1 { get; set; }
    
        public virtual ICollection<ProductGuid> ProductGuids { get; set; }
    }
}
