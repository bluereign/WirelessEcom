// --------------------------------------------------------------------------------------------------------------------
// <copyright file="SoapBaseResponse.cs" company="">
//   
// </copyright>
// <summary>
//   The soap base response.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCSI.ServiceImplementation.DTO
{
    /// <summary>The soap base response.</summary>
    public class SoapBaseResponse
    {
        #region Public Properties

        /// <summary>Gets or sets the provider error code.</summary>
        public string ProviderErrorCode { get; set; }

        /// <summary>Gets or sets the provider error text.</summary>
        public string ProviderErrorText { get; set; }

        #endregion
    }
}