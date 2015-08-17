// --------------------------------------------------------------------------------------------------------------------
// <copyright file="RequestHeader.cs" company="">
//   
// </copyright>
// <summary>
//   The request header.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace WirelessAdvocates.Services.CarrierInterface.ATT.Common.Types
{
    using System.Runtime.Serialization;

    using WirelessAdvocates.Services.CarrierInterface.ATT.Common;

    /// <summary>The request header.</summary>
    [DataContract(Namespace = Constants.ATT_SERVICE_NAMESPACE)]
    public class RequestHeader
    {
        #region Public Properties

        /// <summary>Gets or sets the api version.</summary>
        [DataMember]
        public string APIVersion { get; set; }

        /// <summary>Gets or sets the client app name.</summary>
        [DataMember]
        public string ClientAppName { get; set; }

        /// <summary>Gets or sets the client app user name.</summary>
        [DataMember]
        public string ClientAppUserName { get; set; }

        /// <summary>Gets or sets the reference number.</summary>
        [DataMember]
        public string ReferenceNumber { get; set; }

        /// <summary>Gets or sets the url.</summary>
        [DataMember]
        public string URL { get; set; }

        #endregion
    }
}