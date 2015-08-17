// --------------------------------------------------------------------------------------------------------------------
// <copyright file="MDNSet.cs" company="">
//   
// </copyright>
// <summary>
//   The mdn set.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace WirelessAdvocates
{
    /// <summary>The mdn set.</summary>
    public class MDNSet
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="MDNSet" /> class.</summary>
        public MDNSet()
        {
            this.ServiceZipCode = string.Empty;
            this.MDN = string.Empty;
            this.IsPortable = false;
        }

        #endregion

        #region Public Properties

        /// <summary>Gets or sets a value indicating whether is portable.</summary>
        public bool IsPortable { get; set; }

        /// <summary>Gets or sets the mdn.</summary>
        public string MDN { get; set; }

        /// <summary>Gets or sets the service zip code.</summary>
        public string ServiceZipCode { get; set; }

        #endregion
    }
}