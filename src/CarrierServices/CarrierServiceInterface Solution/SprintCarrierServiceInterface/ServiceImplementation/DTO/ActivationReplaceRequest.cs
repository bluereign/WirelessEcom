// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ActivationReplaceRequest.cs" company="">
//   
// </copyright>
// <summary>
//   The activate now request.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation.DTO
{
    /// <summary>The activation replace request.</summary>
    public class ActivationReplaceRequest
    {
        #region Public Properties

        /// <summary>Gets or sets the activation request xml.</summary>
        public string ActivationRequestXml { get; set; }

        /// <summary>Gets or sets the sprint customer inquiry response xml.</summary>
        public string SprintCustomerInquiryResponseXml { get; set; }

        #endregion

        #region Properties

        /// <summary>Gets or sets the service agreement.</summary>
        internal byte ServiceAgreement { get; set; }

        /// <summary>Gets or sets the transaction order id.</summary>
        internal string TransactionOrderId { get; set; }

        #endregion
    }
}