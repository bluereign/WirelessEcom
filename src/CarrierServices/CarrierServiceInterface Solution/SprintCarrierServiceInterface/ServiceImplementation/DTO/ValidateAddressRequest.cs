// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ValidateAddressRequest.cs" company="">
//   
// </copyright>
// <summary>
//   The validate address request.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation.DTO
{
    using WirelessAdvocates;

    /// <summary>The validate address request.</summary>
    public class ValidateAddressRequest
    {
        #region Public Properties

        /// <summary>Gets or sets the address.</summary>
        public Address Address { get; set; }

        /// <summary>Gets or sets the address type.</summary>
        public Address.AddressEnum AddressType { get; set; }

        /// <summary>Gets or sets the reference number.</summary>
        public string ReferenceNumber { get; set; }

        #endregion
    }
}