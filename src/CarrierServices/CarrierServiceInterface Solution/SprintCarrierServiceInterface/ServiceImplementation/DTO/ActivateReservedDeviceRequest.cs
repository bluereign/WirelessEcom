// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ActivateReservedDeviceRequest.cs" company="">
//   
// </copyright>
// <summary>
//   The activate now request.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation.DTO
{
    /// <summary>The activate now request.</summary>
    public class ActivateReservedDeviceRequest
    {
        #region Public Properties

        /// <summary>Gets or sets the mdn.</summary>
        public string Mdn { get; set; }

        /// <summary>Gets or sets the sprint order id.</summary>
        public string SprintOrderId { get; set; }

        #endregion

        #region Properties

        /// <summary>Gets or sets the transaction order id.</summary>
        internal string TransactionOrderId { get; set; }

        #endregion
    }
}