// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ResponseBase.cs" company="">
//   
// </copyright>
// <summary>
//   The response base.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCarrierServiceTests.ServiceBus
{
    using System.Runtime.Serialization;

    using ServiceStack;

    using WirelessAdvocates.Services.CarrierInterface.ATT.Common;

    /// <summary>The response base.</summary>
    [DataContract(Namespace = Constants.ATT_SERVICE_NAMESPACE)]
    public class ResponseBase
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="ResponseBase"/> class.</summary>
        public ResponseBase()
        {
            this.ResponseStatus = new ResponseStatus { ErrorCode = "0" };
        }

        #endregion

        #region Public Properties

        /// <summary>Gets or sets the response status.</summary>
        [DataMember]
        public ResponseStatus ResponseStatus { get; set; }

        #endregion
    }
}