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
    
    public partial class ReleaseTemplateCarrier
    {
        public long ReleaseTemplateCarrierID { get; set; }
        public long ReleaseTemplateID { get; set; }
        public long CarrierID { get; set; }
    
        public virtual Carrier Carrier { get; set; }
        public virtual ReleaseTemplate ReleaseTemplate { get; set; }
    }
}
