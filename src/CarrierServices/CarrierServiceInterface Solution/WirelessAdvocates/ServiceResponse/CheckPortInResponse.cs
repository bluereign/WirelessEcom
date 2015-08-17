// --------------------------------------------------------------------------------------------------------------------
// <copyright file="CheckPortInResponse.cs" company="">
//   
// </copyright>
// <summary>
//   The validate port in response.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace WirelessAdvocates.ServiceResponse
{
    using System.Collections.Generic;

    /// <summary>The validate port in response.</summary>
    public class ValidatePortInResponse : CarrierResponse
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="ValidatePortInResponse"/> class.</summary>
        public ValidatePortInResponse()
        {
            this.MDNSet = new List<MDNSet>();
        }

        #endregion

        #region Public Properties

        /// <summary>Gets or sets the mdn set.</summary>
        public List<MDNSet> MDNSet { get; set; }

        #endregion
    }
}