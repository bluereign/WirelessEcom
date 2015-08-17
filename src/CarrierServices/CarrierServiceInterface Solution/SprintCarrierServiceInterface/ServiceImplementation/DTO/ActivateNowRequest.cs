// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ActivateNowRequest.cs" company="">
//   
// </copyright>
// <summary>
//   The activate now request.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation.DTO
{
    /// <summary>The activate now request.</summary>
    public class ActivateNowRequest
    {
        #region Public Properties

        /// <summary>Gets or sets the meid.</summary>
        public string Meid { get; set; }

        /// <summary>Gets or sets the sprint order id.</summary>
        public string SprintOrderId { get; set; }

        #endregion

        #region Properties

        /// <summary>Gets or sets the transaction order id.</summary>
        internal string TransactionOrderId { get; set; }

        #endregion
    }
}