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
    
    public partial class PropertyMaster
    {
        public PropertyMaster()
        {
            this.PropertyMasterAlias = new HashSet<PropertyMasterAlia>();
        }
    
        public System.Guid PropertyMasterGuid { get; set; }
        public Nullable<System.Guid> PropertyMasterGroupGuid { get; set; }
        public string Label { get; set; }
        public Nullable<int> Ordinal { get; set; }
    
        public virtual PropertyMasterGroup PropertyMasterGroup { get; set; }
        public virtual ICollection<PropertyMasterAlia> PropertyMasterAlias { get; set; }
    }
}
