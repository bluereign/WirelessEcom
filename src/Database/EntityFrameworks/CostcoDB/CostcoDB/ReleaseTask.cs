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
    
    public partial class ReleaseTask
    {
        public long ReleaseTaskID { get; set; }
        public string GroupName { get; set; }
        public string Task { get; set; }
        public string ResponsibleGroup { get; set; }
        public bool AllowRequested { get; set; }
        public bool AllowRequired { get; set; }
    }
}
