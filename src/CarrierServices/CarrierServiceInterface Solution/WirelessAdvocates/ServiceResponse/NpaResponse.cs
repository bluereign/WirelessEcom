// --------------------------------------------------------------------------------------------------------------------
// <copyright file="NpaResponse.cs" company="">
//   
// </copyright>
// <summary>
//   The npa response.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace WirelessAdvocates.ServiceResponse
{
    using System.Collections.Generic;

    /// <summary>The npa response.</summary>
    public class NpaResponse : CarrierResponse
    {
        #region Fields

        #endregion

        public NpaResponse()
        {
            NpaSet = new List<NpaInfo>();
        }

        #region Public Properties

        /// <summary>Gets or sets the npa set.</summary>
        public List<NpaInfo> NpaSet { get; set; }

        #endregion
    }
}