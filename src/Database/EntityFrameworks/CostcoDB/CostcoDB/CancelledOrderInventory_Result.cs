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
    
    public partial class CancelledOrderInventory_Result
    {
        public int OrderId { get; set; }
        public Nullable<System.DateTime> OrderDate { get; set; }
        public string GersSku { get; set; }
        public string ProductTitle { get; set; }
        public string WA_Status { get; set; }
        public string GERS_Status { get; set; }
        public Nullable<System.DateTime> PaymentDate { get; set; }
        public string AuthorizationOrigId { get; set; }
        public string CheckoutReferenceNumber { get; set; }
        public Nullable<System.DateTime> ShipmentDeliveryDate { get; set; }
        public string TrackingNumber { get; set; }
        public int Order_OrderDiD { get; set; }
        public string GroupName { get; set; }
        public Nullable<int> ProductId { get; set; }
        public string OutletId { get; set; }
        public string LocationCode { get; set; }
        public string IMEI { get; set; }
        public Nullable<int> Stock_OrderDiD { get; set; }
        public Nullable<System.DateTime> TimeSentToGERS { get; set; }
    }
}
