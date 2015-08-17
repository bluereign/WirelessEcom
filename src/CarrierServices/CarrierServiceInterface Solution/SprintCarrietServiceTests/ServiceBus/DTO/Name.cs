// --------------------------------------------------------------------------------------------------------------------
// <copyright file="Name.cs" company="">
//   
// </copyright>
// <summary>
//   The name.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace WirelessAdvocates.Services.CarrierInterface.ATT.Common.Types
{
    /// <summary>The name.</summary>
    public class Name
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="Name"/> class.</summary>
        public Name()
        {
            this.FirstName = string.Empty;
            this.LastName = string.Empty;
            this.MiddleInitial = string.Empty;
            this.Prefix = string.Empty;
            this.Suffix = string.Empty;
        }

        #endregion

        #region Public Properties

        /// <summary>Gets or sets the first name.</summary>
        public string FirstName { get; set; }

        /// <summary>Gets or sets the last name.</summary>
        public string LastName { get; set; }

        /// <summary>Gets or sets the middle initial.</summary>
        public string MiddleInitial { get; set; }

        /// <summary>Gets or sets the prefix.</summary>
        public string Prefix { get; set; }

        /// <summary>Gets or sets the suffix.</summary>
        public string Suffix { get; set; }

        #endregion
    }
}