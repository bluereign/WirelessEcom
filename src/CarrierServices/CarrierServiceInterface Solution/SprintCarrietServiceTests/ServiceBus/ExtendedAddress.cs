// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ExtendedAddress.cs" company="">
//   
// </copyright>
// <summary>
//   The extended address.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace WirelessAdvocates.Services.CarrierInterface.ATT.Common.Types
{
    using System.Xml.Serialization;

    /// <summary>The extended address.</summary>
    [XmlInclude(typeof(ExtendedAddress))]
    public class ExtendedAddress
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="ExtendedAddress" /> class.</summary>
        public ExtendedAddress()
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

            //// Extended...
            this.AddressType = string.Empty;
            this.AptDesignator = string.Empty;
            this.AptNumber = string.Empty;
            this.CountyName = string.Empty;
            this.DeliveryPointBarCode = string.Empty;
            this.DirectionalPrefix = string.Empty;
            this.DirectionalSuffix = string.Empty;
            this.HouseNumber = string.Empty;
            this.StreetName = string.Empty;
            this.StreetType = string.Empty;
        }

        #endregion

        #region Public Properties

        /// <summary>Gets or sets the address line 1.</summary>
        public string AddressLine1 { get; set; }

        /// <summary>Gets or sets the address line 2.</summary>
        public string AddressLine2 { get; set; }

        /// <summary>Gets or sets the address line 3.</summary>
        public string AddressLine3 { get; set; }

        /// <summary>Gets or sets the address type.</summary>
        public string AddressType { get; set; }

        /// <summary>Gets or sets the apt designator.</summary>
        public string AptDesignator { get; set; }

        /// <summary>Gets or sets the apt number.</summary>
        public string AptNumber { get; set; }

        /// <summary>Gets or sets the city.</summary>
        public string City { get; set; }

        /// <summary>Gets or sets the company name.</summary>
        public string CompanyName { get; set; }

        /// <summary>Gets or sets the contact.</summary>
        public Contact Contact { get; set; }

        /// <summary>Gets or sets the country.</summary>
        public string Country { get; set; }

        /// <summary>Gets or sets the county name.</summary>
        public string CountyName { get; set; }

        /// <summary>Gets or sets the delivery point bar code.</summary>
        public string DeliveryPointBarCode { get; set; }

        /// <summary>Gets or sets the directional prefix.</summary>
        public string DirectionalPrefix { get; set; }

        /// <summary>Gets or sets the directional suffix.</summary>
        public string DirectionalSuffix { get; set; }

        /// <summary>Gets or sets the extended zip code.</summary>
        public string ExtendedZipCode { get; set; }

        /// <summary>Gets or sets the house number.</summary>
        public string HouseNumber { get; set; }

        /// <summary>Gets or sets the name.</summary>
        public Name Name { get; set; }

        /// <summary>Gets or sets the state.</summary>
        public string State { get; set; }

        /// <summary>Gets or sets the street name.</summary>
        public string StreetName { get; set; }

        /// <summary>Gets or sets the street type.</summary>
        public string StreetType { get; set; }

        /// <summary>Gets or sets the zip code.</summary>
        public string ZipCode { get; set; }

        #endregion
    }
}