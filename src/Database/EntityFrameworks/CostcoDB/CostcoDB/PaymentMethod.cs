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
    
    public partial class PaymentMethod
    {
        public PaymentMethod()
        {
            this.Payment1 = new HashSet<Payment1>();
        }
    
        public int PaymentMethodId { get; set; }
        public string Name { get; set; }
        public Nullable<int> Sort { get; set; }
        public Nullable<bool> IsActive { get; set; }
        public string GersMopCd { get; set; }
    
        public virtual ICollection<Payment1> Payment1 { get; set; }
    }
}
