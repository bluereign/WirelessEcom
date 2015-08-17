// --------------------------------------------------------------------------------------------------------------------
// <copyright file="OrderDetail.cs" company="">
//   
// </copyright>
// <summary>
//   The order detail.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace WirelessAdvocates.SalesOrder
{
    using System;
    using System.Linq;

    /// <summary>The order detail.</summary>
    public class OrderDetail
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="OrderDetail"/> class.</summary>
        /// <param name="orderDetailId">The order detail id.</param>
        public OrderDetail(int orderDetailId)
        {
            this.TotalWeight = 0;
            this.ProductTitle = string.Empty;
            this.PartNumber = string.Empty;
            this.OrderDetailType = string.Empty;
            this.Message = string.Empty;
            this.GroupName = string.Empty;
            this.GERSSKU = string.Empty;
            this.OrderDetailId = orderDetailId;
            this.FillOrderDetail();
        }

        #endregion

        #region Public Properties

        /// <summary>Gets the cogs.</summary>
        public decimal COGS { get; private set; }

        /// <summary>Gets the gerssku.</summary>
        public string GERSSKU { get; private set; }

        /// <summary>Gets the group name.</summary>
        public string GroupName { get; private set; }

        /// <summary>Gets the group number.</summary>
        public int? GroupNumber { get; private set; }

        /// <summary>Gets the message.</summary>
        public string Message { get; private set; }

        /// <summary>Gets the net price.</summary>
        public decimal NetPrice { get; private set; }

        /// <summary>Gets the order detail id.</summary>
        public int OrderDetailId { get; protected set; }

        /// <summary>Gets the order detail type.</summary>
        public string OrderDetailType { get; private set; }

        /// <summary>Gets the order id.</summary>
        public int OrderId { get; private set; }

        /// <summary>Gets the part number.</summary>
        public string PartNumber { get; private set; }

        /// <summary>Gets the product id.</summary>
        public int ProductId { get; private set; }

        /// <summary>Gets the product title.</summary>
        public string ProductTitle { get; private set; }

        /// <summary>Gets the qty.</summary>
        public int Qty { get; private set; }

        /// <summary>Gets the retail price.</summary>
        public decimal RetailPrice { get; private set; }

        /// <summary>Gets the shipment id.</summary>
        public int ShipmentId { get; private set; }

        /// <summary>Gets a value indicating whether taxable.</summary>
        public bool Taxable { get; private set; }

        /// <summary>Gets the taxes.</summary>
        public decimal Taxes { get; private set; }

        /// <summary>Gets the total weight.</summary>
        public int? TotalWeight { get; private set; }

        /// <summary>Gets the weight.</summary>
        public double Weight { get; private set; }

        #endregion

        #region Methods

        /// <summary>The fill order detail.</summary>
        private void FillOrderDetail()
        {
            var db = new DbUtility().GetDataContext();

            var details = from p in db.OrderDetails where p.OrderDetailId == this.OrderDetailId select p;

            if (!details.Any())
            {
                return;
            }

            var orderDetail = details.First();
            this.OrderDetailId = orderDetail.OrderDetailId;
            if (orderDetail.OrderDetailType != null)
            {
                this.OrderDetailType = Convert.ToString(orderDetail.OrderDetailType.Value);
            }

            if (orderDetail.OrderId != null)
            {
                this.OrderId = orderDetail.OrderId.Value;
            }

            this.GroupNumber = orderDetail.GroupNumber;
            this.GroupName = orderDetail.GroupName;
            if (orderDetail.ProductId != null)
            {
                this.ProductId = orderDetail.ProductId.Value;
            }

            this.GERSSKU = orderDetail.GersSku;
            this.ProductTitle = orderDetail.ProductTitle;
            this.PartNumber = orderDetail.PartNumber;
            if (orderDetail.Qty != null)
            {
                this.Qty = orderDetail.Qty.Value;
            }

            if (orderDetail.COGS != null)
            {
                this.COGS = orderDetail.COGS.Value;
            }

            this.RetailPrice = orderDetail.RetailPrice.Value;
            if (orderDetail.NetPrice != null)
            {
                this.NetPrice = orderDetail.NetPrice.Value;
            }

            if (orderDetail.Weight != null)
            {
                this.Weight = orderDetail.Weight.Value;
            }

            if (orderDetail.TotalWeight != null)
            {
                this.TotalWeight = orderDetail.TotalWeight.Value;
            }

            if (orderDetail.Taxable != null)
            {
                this.Taxable = orderDetail.Taxable.Value;
            }

            if (orderDetail.Taxes != null)
            {
                this.Taxes = orderDetail.Taxes.Value;
            }

            this.Message = orderDetail.Message;
            if (orderDetail.ShipmentId != null)
            {
                this.ShipmentId = orderDetail.ShipmentId.Value;
            }
        }

        #endregion
    }
}