// --------------------------------------------------------------------------------------------------------------------
// <copyright file="CheckCreditRequest.cs" company="">
//   
// </copyright>
// <summary>
//   The check credit request.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCSI.ServiceImplementation.DTO
{
    using WirelessAdvocates;

    /// <summary>The check credit request.</summary>
    public class CheckCreditRequest
    {
        #region Public Properties

        /// <summary>Gets or sets the billing contact credentials.</summary>
        public PersonalCredentials BillingContactCredentials { get; set; }

        /// <summary>Gets or sets the billing name.</summary>
        public Name BillingName { get; set; }

        /// <summary>Gets or sets the contact info.</summary>
        public Contact ContactInfo { get; set; }

        /// <summary>Gets or sets the number of lines.</summary>
        public int NumberOfLines { get; set; }

        /// <summary>Gets or sets the question answer.</summary>
        public string QuestionAnswer { get; set; }

        /// <summary>Gets or sets the question code.</summary>
        public string QuestionCode { get; set; }

        /// <summary>Gets or sets the reference number.</summary>
        public string ReferenceNumber { get; set; }

        /// <summary>Gets or sets the service zip code.</summary>
        public string ServiceZipCode { get; set; }

        #endregion
    }
}