// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ActivationUpgradeRequest.cs" company="">
//   
// </copyright>
// <summary>
//   The activation upgrade request.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCSI.ServiceImplementation.DTO
{
    using System.Collections.Generic;
    using System.Linq;

    using SprintOrdersData;

    using WirelessAdvocates;
    using WirelessAdvocates.SalesOrder;

    using OrderDetail = SprintOrders.OrderDetail;
    using REQUEST = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;
    using WIRELESSLINE = SprintOrders.WirelessLine;

    /// <summary>The activation upgrade request.</summary>
    public class ActivationUpgradeRequest : WirelessOrder
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="ActivationUpgradeRequest"/> class.</summary>
        /// <param name="orderNumber">The order number.</param>
        public ActivationUpgradeRequest(string orderNumber)
            : base(int.Parse(orderNumber))
        {
        }

        /// <summary>Initializes a new instance of the <see cref="ActivationUpgradeRequest"/> class.</summary>
        /// <param name="orderNumber">The order number.</param>
        public ActivationUpgradeRequest(int orderNumber)
            : base(orderNumber)
        {
        }

        /// <summary>Initializes a new instance of the <see cref="ActivationUpgradeRequest"/> class.</summary>
        /// <param name="orderNumber">The order number.</param>
        /// <param name="wirelessLineId">The wireless line id.</param>
        /// <param name="orderType">The order type.</param>
        /// <param name="transactionOrderId">The transaction order id.</param>
        public ActivationUpgradeRequest(string orderNumber, int wirelessLineId, REQUEST.OrderType orderType, string transactionOrderId)
            : base(int.Parse(orderNumber))
        {
            this.OrderNumber = orderNumber;
            this.WirelessLineId = wirelessLineId;
            this.OrderType = orderType;
            this.TransactionOrderId = transactionOrderId;
            this.WirelessLineKludge();
        }

        #endregion

        ////string orderNumber,
        #region Public Properties

        /// <summary>Gets the billing contact credentials.</summary>
        public PersonalCredentials BillingContactCredentials { get; private set; }

        /// <summary>Gets the billing name.</summary>
        public Name BillingName { get; private set; }

        /// <summary>Gets the contact info.</summary>
        public Contact ContactInfo { get; private set; }

        /// <summary>Gets the current imei.</summary>
        public string CurrentIMEI { get; private set; }

        /// <summary>Gets the current sim.</summary>
        public string CurrentSim { get; private set; }

        /// <summary>Gets the customer type.</summary>
        public REQUEST.CustomerType CustomerType { get; private set; }

        /// <summary>Gets the handset count.</summary>
        public int HandsetCount { get; private set; }

        /// <summary>Gets the mdn.</summary>
        public string Mdn { get; private set; }

        /// <summary>Gets the number of lines.</summary>
        public int NumberOfLines { get; private set; }

        /// <summary>Gets the order number.</summary>
        public string OrderNumber { get; private set; }

        /// <summary>Gets the order type.</summary>
        public REQUEST.OrderType OrderType { get; private set; }

        /// <summary>Gets the question answer.</summary>
        public string QuestionAnswer { get; private set; }

        /// <summary>Gets the question code.</summary>
        public string QuestionCode { get; private set; }

        /// <summary>Gets the reference number.</summary>
        public string ReferenceNumber { get; private set; }

        /// <summary>Gets the secret pin.</summary>
        public string SecretPin { get; private set; }

        /// <summary>Gets the service zip code.</summary>
        public string ServiceZipCode { get; private set; }

        /// <summary>Gets the ssn.</summary>
        public string Ssn { get; private set; }

        /// <summary>Gets or sets the transaction order id.</summary>
        public string TransactionOrderId { get; set; }

        /// <summary>Gets the wireless line id.</summary>
        public int WirelessLineId { get; private set; }

        #endregion

        #region Methods

        /// <summary>The return line.</summary>
        /// <returns>The <see cref="WirelessLine" />.</returns>
        private WIRELESSLINE ReturnLine()
        {
            var orderDetails = new Repository().GetWirelessLineOrderDetail(this.OrderId);

            var lineArray = new WIRELESSLINE[1];
            WIRELESSLINE wirelessLine = null;

            foreach (var orderDetail in orderDetails)
            {
                orderDetail.WirelessLines.CopyTo(lineArray, 0);
                if (lineArray[0].WirelessLineId == this.WirelessLineId)
                {
                    wirelessLine = lineArray[0];
                }
            }

            return wirelessLine;
        }

        /// <summary>The select only one wireless line.</summary>
        /// <returns>The <see cref="WirelessLine" />.</returns>
        private WIRELESSLINE SelectOnlyOneWirelessLine()
        {
            var selectedLine = new WirelessLine[1];

            var wirelessLine = this.ReturnLine();

            // NOTE [pcrawford,20140206] Legacy returns all lines for upgrade but by design we are only upgrading a line at a time
            // And yes, this is redundant when there is only one line
            var lines = this.WirelessLines.ToList();
            foreach (var line in lines.Where(line => line.CurrentMDN == wirelessLine.CurrentMDN))
            {
                selectedLine[0] = line;
                this.WirelessLines = selectedLine;
            }

            return wirelessLine;
        }

        /// <summary>
        ///     The legacy Link to SQL data access layer in the WirelessAdvocates project
        ///     was built using obsolete tools which do not work with Visual Studio 2012/13.
        ///     Due to time constraints it is not yet feasible to completely replace that data layer.
        ///     This WirelessLineKludge method exists to provide one place to override that data layer.
        /// </summary>
        private void WirelessLineKludge()
        {
           
            var wirelessLine = this.SelectOnlyOneWirelessLine();

            // NOTE [pcrawford,20140207] ALL Field Kludges AFTER HERE!!!!

            // NOTE [pcrawford,20140206] CurrentIMEI cannot be returned from the Legacy DB code
            this.CurrentIMEI = wirelessLine.CurrentIMEI;

            // NOTE [pcrawford,20140206] CurrentSIM is being truncated in legacy code
            this.CurrentSim = wirelessLine.CurrentSIM;
            this.WirelessLines[0].Sim = wirelessLine.SIM;

            // NOTE [pcrawford,20140206] CurrentMDN is a new field
            this.Mdn = wirelessLine.CurrentMDN;
        }

        #endregion
    }
}