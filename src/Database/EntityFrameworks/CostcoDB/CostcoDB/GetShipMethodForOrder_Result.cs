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
    
    public partial class GetShipMethodForOrder_Result
    {
        public int OrderId { get; set; }
        public Nullable<int> ShipMethodId { get; set; }
        public Nullable<System.DateTime> ShipmentDeliveryDate { get; set; }
        public string Zip { get; set; }
        public string DestinationZipRange { get; set; }
        public string ServiceName { get; set; }
        public string ServiceTitle { get; set; }
        public Nullable<int> GersZone { get; set; }
        public Nullable<int> GroundZone { get; set; }
        public Nullable<int> Zone { get; set; }
        public Nullable<int> TransitDays { get; set; }
        public Nullable<System.DateTime> ExpectedDeliveryDate { get; set; }
        public Nullable<int> ServiceOrdinal { get; set; }
        public Nullable<long> ServiceRank { get; set; }
    }
}
