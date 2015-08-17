// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ExtendedAddress.cs" company="">
//   
// </copyright>
// <summary>
//   The extended address.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace WirelessAdvocates
{
    using System.Xml.Serialization;

    /// <summary>The extended address.</summary>
    [XmlInclude(typeof(ExtendedAddress))]
    public class ExtendedAddress : Address
    {
        #region Fields

        /// <summary>The _street type.</summary>
        private string _streetType = string.Empty;

        #endregion

        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="ExtendedAddress"/> class.</summary>
        public ExtendedAddress()
        {
            this.StreetName = string.Empty;
            this.HouseNumber = string.Empty;
            this.DirectionalSuffix = string.Empty;
            this.DirectionalPrefix = string.Empty;
            this.DeliveryPointBarCode = string.Empty;
            this.CountyName = string.Empty;
            this.AptNumber = string.Empty;
            this.AptDesignator = string.Empty;
            this.AddressType = string.Empty;
        }

        #endregion

        #region Public Properties

        /// <summary>Gets or sets the address type.</summary>
        public string AddressType { get; set; }

        /// <summary>Gets or sets the apt designator.</summary>
        public string AptDesignator { get; set; }

        /// <summary>Gets or sets the apt number.</summary>
        public string AptNumber { get; set; }

        /// <summary>Gets or sets the county name.</summary>
        public string CountyName { get; set; }

        /// <summary>Gets or sets the delivery point bar code.</summary>
        public string DeliveryPointBarCode { get; set; }

        /// <summary>Gets or sets the directional prefix.</summary>
        public string DirectionalPrefix { get; set; }

        /// <summary>Gets or sets the directional suffix.</summary>
        public string DirectionalSuffix { get; set; }

        /// <summary>Gets or sets the house number.</summary>
        public string HouseNumber { get; set; }

        /// <summary>Gets or sets the street name.</summary>
        public string StreetName { get; set; }

        /// <summary>Gets or sets the street type.</summary>
        public string StreetType
        {
            get
            {
                return this._streetType;
            }

            set
            {
                this._streetType = value;
            }
        }

        #endregion
    }
}