// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ValidatePlansAndOptionsRequest.cs" company="">
//   
// </copyright>
// <summary>
//   The validate plans and options request.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation.DTO
{
    using WirelessAdvocates;

    /// <summary>The validate plans and options request.</summary>
    public class ValidatePlansAndOptionsRequest
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