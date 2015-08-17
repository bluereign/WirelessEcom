// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ActivationRequest.cs" company="">
//   
// </copyright>
// <summary>
//   The wa activation request.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation.DTO
{
    using WirelessAdvocates.SalesOrder;

    /// <summary>The wa activation request.</summary>
    public class ActivationRequest : WirelessOrder
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="ActivationRequest"/> class.</summary>
        /// <param name="orderNumber">The order number.</param>
        public ActivationRequest(string orderNumber)
            : base(int.Parse(orderNumber))
        {
        }

        /// <summary>Initializes a new instance of the <see cref="ActivationRequest"/> class.</summary>
        /// <param name="orderNumber">The order number.</param>
        public ActivationRequest(int orderNumber)
            : base(orderNumber)
        {
        }

        #endregion

        #region Properties

        /// <summary>Gets or sets the transaction order id.</summary>
        internal string TransactionOrderId { get; set; }

        #endregion
    }
}