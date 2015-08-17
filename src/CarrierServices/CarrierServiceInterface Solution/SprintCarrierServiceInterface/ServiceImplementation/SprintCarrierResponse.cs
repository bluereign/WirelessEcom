// --------------------------------------------------------------------------------------------------------------------
// <copyright file="CarrierResponse.cs" company="">
//   
// </copyright>
// <summary>
//   The sprint carrier response.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCSI.ServiceImplementation
{
    using WirelessAdvocates.ServiceResponse;

    /// <summary>The carrier response.</summary>
    public class SprintCarrierResponse : CarrierResponse
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="SprintCarrierResponse"/> class.</summary>
        public SprintCarrierResponse()
        {
            this.ErrorInfo = null;
        }

        #endregion

        #region Public Properties

        /// <summary>Gets or sets the request error info.</summary>
        public WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.response.ErrorInfo[] ErrorInfo { get; set; }

        #endregion
    }
}