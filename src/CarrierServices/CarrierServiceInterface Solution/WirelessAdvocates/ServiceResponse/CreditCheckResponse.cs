// --------------------------------------------------------------------------------------------------------------------
// <copyright file="CreditCheckResponse.cs" company="">
//   
// </copyright>
// <summary>
//   The credit check response.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace WirelessAdvocates.ServiceResponse
{
    /// <summary>The credit check response.</summary>
    public class CreditCheckResponse : CarrierResponse
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="CreditCheckResponse" /> class.</summary>
        public CreditCheckResponse()
        {
            this.Deposit = 0;
            this.NumberOfLines = 0;
            this.CreditApplicationNumber = string.Empty;
            this.CreditCode = string.Empty;
            this.CreditStatus = string.Empty;
            this.CustomerAccountNumber = string.Empty;
        }

        #endregion

        #region Public Properties

        /// <summary>Gets or sets the credit application number.</summary>
        public string CreditApplicationNumber { get; set; }

        /// <summary>Gets or sets the credit code.</summary>
        public string CreditCode { get; set; }

        /// <summary>Gets or sets the credit status.</summary>
        public string CreditStatus { get; set; }

        /// <summary>Gets or sets the customer account number.</summary>
        public string CustomerAccountNumber { get; set; }

        /// <summary>Gets or sets the deposit.</summary>
        public decimal Deposit { get; set; }

        /// <summary>Gets or sets the number of lines.</summary>
        public int NumberOfLines { get; set; }

        #endregion
    }
}