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
    
    public partial class ServiceMaster
    {
        public System.Guid ServiceMasterGuid { get; set; }
        public Nullable<System.Guid> ServiceMasterGroupGuid { get; set; }
        public string Label { get; set; }
        public Nullable<System.Guid> ServiceGUID { get; set; }
        public Nullable<int> Ordinal { get; set; }
    
        public virtual ServiceMasterGroup ServiceMasterGroup { get; set; }
    }
}
