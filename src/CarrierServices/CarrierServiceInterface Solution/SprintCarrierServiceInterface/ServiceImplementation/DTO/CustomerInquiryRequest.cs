// --------------------------------------------------------------------------------------------------------------------
// <copyright file="CustomerInquiryRequest.cs" company="">
//   
// </copyright>
// <summary>
//   The customer inquiry request.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation.DTO
{
    /// <summary>The customer inquiry request.</summary>
    public class CustomerInquiryRequest
    {
        #region Public Properties

        /// <summary>Gets or sets the mdn.</summary>
        public string Mdn { get; set; }

        /// <summary>Gets or sets the question answer.</summary>
        public string QuestionAnswer { get; set; }

        /// <summary>Gets or sets the reference_ no.</summary>
        public string ReferenceNo { get; set; }

        /// <summary>Gets or sets the secret_ key.</summary>
        public string SecretKey { get; set; }

        /// <summary>Gets or sets the ssn.</summary>
        public string Ssn { get; set; }

        #endregion
    }
}