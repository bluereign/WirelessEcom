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
    
    public partial class vw_GetUncommittedTax
    {
        public Nullable<System.DateTime> OrderDate { get; set; }
        public int Invoice_Number { get; set; }
        public string Ship_To_Name { get; set; }
        public Nullable<decimal> Gross_Amount { get; set; }
        public string SalesTaxTransactionId { get; set; }
    }
}
