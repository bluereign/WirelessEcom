// --------------------------------------------------------------------------------------------------------------------
// <copyright file="Order.cs" company="">
//   
// </copyright>
// <summary>
//   The order.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace WirelessAdvocates.SalesOrder
{
    using System;
    using System.Data;
    using System.Linq;

    /// <summary>The order.</summary>
    public class Order
    {
        #region Fields

        /// <summary>The _bill address guid.</summary>
        private Guid billAddressGuid;

        /// <summary>The _is dirty.</summary>
        private bool isDirty;

        /// <summary>The ship address guid.</summary>
        private Guid shipAddressGuid;

        #endregion

        // TODO: Message, IPAddress, Status, GERSStatus, TimeSentToGERS, ShipCost, CarrierId?
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="Order"/> class.</summary>
        /// <param name="orderId">The order id.</param>
        public Order(int orderId)
        {
            this.Email = string.Empty;
            this.CheckoutReferenceNumber = string.Empty;
            this.OrderId = orderId;
            this.billAddressGuid = Guid.Empty;
            this.Db = new DbUtility().GetDataContext();
            this.FillOrder();
            this.BillAddress = new Address(this.billAddressGuid);
        }

        /// <summary>Initializes a new instance of the <see cref="Order"/> class.</summary>
        /// <param name="checkoutReferenceNumber">The checkout reference number.</param>
        public Order(string checkoutReferenceNumber)
        {
            this.Email = string.Empty;
            this.CheckoutReferenceNumber = string.Empty;
            this.billAddressGuid = Guid.Empty;
            this.Db = new DbUtility().GetDataContext();

            // find the order based on the reference number. 
            var orders = this.Db.Orders.First(p => p.CheckoutReferenceNumber == checkoutReferenceNumber);

            if (orders != null)
            {
                this.OrderId = orders.OrderId;
                this.FillOrder();
                this.BillAddress = new Address(this.billAddressGuid);
            }
            else
            {
                throw new Exception(string.Format("No matching order in database for checkoutReferenceNumber => {0}", checkoutReferenceNumber));
            }
          }

        /// <summary>Initializes a new instance of the <see cref="Order" /> class.</summary>
        public Order()
        {
            this.Email = string.Empty;
            this.CheckoutReferenceNumber = string.Empty;
            this.Email = string.Empty;
            this.CheckoutReferenceNumber = string.Empty;
            this.billAddressGuid = Guid.Empty;
            this.BillAddress = new Address(this.billAddressGuid);
        }

        #endregion

        #region Public Properties

        /// <summary>Gets the activation type.</summary>
        public char? ActivationType { get; private set; }

        /// <summary>Gets the bill address.</summary>
        public Address BillAddress { get; private set; }

        /// <summary>Gets the checkout reference number.</summary>
        public string CheckoutReferenceNumber { get; private set; }

        /// <summary>Gets the email.</summary>
        public string Email { get; private set; }

        /// <summary>Gets the order id.</summary>
        public int OrderId { get; private set; }

        /// <summary>Gets the ship method id.</summary>
        public int ShipMethodId { get; private set; }

        /// <summary>Gets the order.</summary>
        public DB.Order DbOrder { get; private set; }

        #endregion

        #region Properties

        /// <summary>Gets the db.</summary>
        protected WirelessAdvocatesDataClassesDataContext Db { get; private set; }

        #endregion

        #region Public Methods and Operators

        /// <summary>The fill.</summary>
        /// <param name="id">The order id.</param>
        public void Fill(int id)
        {
            this.OrderId = id;
            this.FillOrder();
        }

        #endregion

        #region Methods

        /// <summary>The fill order.</summary>
        protected void FillOrder()
        {
            var query = from p in this.Db.Orders where p.OrderId == this.OrderId select p;

            if (!query.Any())
            {
                throw new Exception(string.Format("No order in database for  => {0}", this.OrderId));
            }

            this.DbOrder = query.First();

            if (this.DbOrder.BillAddressGuid != null)
            {
                this.billAddressGuid = this.DbOrder.BillAddressGuid.Value;
            }

            if (this.DbOrder.ShipAddressGuid != null)
            {
                this.shipAddressGuid = this.DbOrder.ShipAddressGuid.Value;
            }

            this.Email = this.DbOrder.EmailAddress;
            if (this.DbOrder.ShipMethodId != null)
            {
                this.ShipMethodId = this.DbOrder.ShipMethodId.Value;
            }

            this.CheckoutReferenceNumber = this.DbOrder.CheckoutReferenceNumber;
            this.ActivationType = this.DbOrder.ActivationType;
            this.isDirty = false;
        }

        #endregion
    }
}