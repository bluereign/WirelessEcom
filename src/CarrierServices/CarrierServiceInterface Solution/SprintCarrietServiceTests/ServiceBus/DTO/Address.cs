// --------------------------------------------------------------------------------------------------------------------
// <copyright file="Address.cs" company="">
//   
// </copyright>
// <summary>
//   The address.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace WirelessAdvocates.Services.CarrierInterface.ATT.Common.Types
{
    /// <summary>The address.</summary>
    public class Address
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="Address" /> class.</summary>
        public Address()
        {
            this.Contact = null;
            this.AddressLine1 = string.Empty;
            this.AddressLine2 = string.Empty;
            this.AddressLine3 = string.Empty;
            this.City = string.Empty;
            this.CompanyName = string.Empty;
            this.Country = "US";
            this.ExtendedZipCode = string.Empty;
            this.Name = new Name();
            this.State = string.Empty;
            this.ZipCode = string.Empty;
        }

        #endregion

        #region Enums

        /// <summary>The address type.</summary>
        public enum AddressType
        {
            /// <summary>The shipping.</summary>
            Shipping, 

            /// <summary>The billing.</summary>
            Billing, 

            /// <summary>The ppu.</summary>
            PPU
        }

        #endregion

        #region Public Properties

        /// <summary>Gets or sets the address line 1.</summary>
        public string AddressLine1 { get; set; }

        /// <summary>Gets or sets the address line 2.</summary>
        public string AddressLine2 { get; set; }

        /// <summary>Gets or sets the address line 3.</summary>
        public string AddressLine3 { get; set; }

        /// <summary>Gets or sets the city.</summary>
        public string City { get; set; }

        /// <summary>Gets or sets the company name.</summary>
        public string CompanyName { get; set; }

        /// <summary>Gets or sets the contact.</summary>
        public Contact Contact { get; set; }

        /// <summary>Gets or sets the country.</summary>
        public string Country { get; set; }

        /// <summary>Gets or sets the extended zip code.</summary>
        public string ExtendedZipCode { get; set; }

        /// <summary>Gets or sets the name.</summary>
        public Name Name { get; set; }

        /// <summary>Gets or sets the state.</summary>
        public string State { get; set; }

        /// <summary>Gets or sets the zip code.</summary>
        public string ZipCode { get; set; }

        #endregion
    }
}