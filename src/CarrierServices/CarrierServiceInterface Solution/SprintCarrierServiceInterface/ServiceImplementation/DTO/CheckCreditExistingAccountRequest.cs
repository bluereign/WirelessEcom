// --------------------------------------------------------------------------------------------------------------------
// <copyright file="CheckCreditExistingAccountRequest.cs" company="">
//   
// </copyright>
// <summary>
//   The check credit existing account request.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation.DTO
{
    using WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;

    /// <summary>The check credit existing account request.</summary>
    public class CheckCreditExistingAccountRequest
    {
        #region Public Properties

        /// <summary>Gets or sets the account number.</summary>
        public string AccountNumber { get; set; }

        /// <summary>Gets or sets the customer type.</summary>
        public CustomerType CustomerType { get; set; }

        /// <summary>Gets or sets the handset count.</summary>
        public byte HandsetCount { get; set; }

        /// <summary>Gets or sets the mdn.</summary>
        public string Mdn { get; set; }

        /// <summary>Gets or sets the order type.</summary>
        public OrderType OrderType { get; set; }

        /// <summary>Gets or sets the question answer.</summary>
        public string QuestionAnswer { get; set; }

        /// <summary>Gets or sets the question code.</summary>
        public string QuestionCode { get; set; }

        /// <summary>Gets or sets the reference number.</summary>
        public string ReferenceNumber { get; set; }

        /// <summary>Gets or sets the ssn.</summary>
        public string SSN { get; set; }

        /// <summary>Gets or sets the secret pin.</summary>
        public string SecretPin { get; set; }

        #endregion
    }
}