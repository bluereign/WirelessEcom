// --------------------------------------------------------------------------------------------------------------------
// <copyright file="CustomerInquiryResponse.cs" company="">
//   
// </copyright>
// <summary>
//   The account status code.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace WirelessAdvocates.ServiceResponse
{
    using System.Collections.Generic;

    using WirelessAdvocates.Enum;

    /// <summary>The customer inquiry response.</summary>
    public class CustomerInquiryResponse : CarrierResponse
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="CustomerInquiryResponse"/> class.</summary>
        public CustomerInquiryResponse()
        {
            this.CustomerInquiryLines = new List<CustomerInquiryLine>();
        }

        #endregion

        #region Public Properties

        /// <summary>Gets or sets the authorized user name 1.</summary>
        public string AuthorizedUserName1 { get; set; }

        /// <summary>Gets or sets the authorized user name 2.</summary>
        public string AuthorizedUserName2 { get; set; }

        /// <summary>Gets or sets the customer account number.</summary>
        public string CustomerAccountNumber { get; set; }

        /// <summary>Gets or sets the customer account password.</summary>
        public string CustomerAccountPassword { get; set; }

        /// <summary>Gets or sets the customer inquiry lines.</summary>
        public List<CustomerInquiryLine> CustomerInquiryLines { get; set; }

        /// <summary>Gets or sets the existing account monthly charges.</summary>
        public decimal ExistingAccountMonthlyCharges { get; set; }

        /// <summary>Gets or sets the lines active.</summary>
        public int LinesActive { get; set; }

        /// <summary>Gets or sets the lines approved.</summary>
        public int LinesApproved { get; set; }

        /// <summary>Gets or sets the lines available.</summary>
        public int LinesAvailable { get; set; }

        /// <summary>Gets or sets the plan code.</summary>
        public string PlanCode { get; set; }

        /// <summary>Gets or sets the question.</summary>
        public string Question { get; set; }

        /// <summary>Gets or sets the wireless account type.</summary>
        public WirelessAccountType WirelessAccountType { get; set; }

        #endregion
    }
}