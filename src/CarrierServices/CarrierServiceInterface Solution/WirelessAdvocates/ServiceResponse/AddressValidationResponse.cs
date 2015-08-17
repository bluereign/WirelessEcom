// --------------------------------------------------------------------------------------------------------------------
// <copyright file="AddressValidationResponse.cs" company="">
//   
// </copyright>
// <summary>
//   The address validation response.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace WirelessAdvocates.ServiceResponse
{
    /// <summary>The address validation response.</summary>
    public class AddressValidationResponse : CarrierResponse
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="AddressValidationResponse"/> class.</summary>
        public AddressValidationResponse()
        {
            this.PossibleAddressMatch = null;
            this.ValidAddress = null;
        }

        #endregion

        #region Public Properties

        /// <summary>Gets or sets the possible address match.</summary>
        public ExtendedAddress[] PossibleAddressMatch { get; set; }

        /// <summary>Gets or sets the valid address.</summary>
        public ExtendedAddress ValidAddress { get; set; }

        #endregion
    }
}