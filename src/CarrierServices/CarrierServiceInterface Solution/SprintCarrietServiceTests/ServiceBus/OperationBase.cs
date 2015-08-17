// --------------------------------------------------------------------------------------------------------------------
// <copyright file="OperationBase.cs" company="">
//   
// </copyright>
// <summary>
//   The operation base.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace WirelessAdvocates.Services.CarrierInterface.ATT.ServiceModel
{
    using System.Runtime.Serialization;

    using WirelessAdvocates.Services.CarrierInterface.ATT.Common;
    using WirelessAdvocates.Services.CarrierInterface.ATT.Common.Types;

    /// <summary>The operation base.</summary>
    /// <typeparam name="T"></typeparam>
    [DataContract(Namespace = Constants.ATT_SERVICE_NAMESPACE)]
    public class OperationBase<T>
    {
        #region Public Properties

        /// <summary>Gets or sets the request body.</summary>
        [DataMember]
        public T RequestBody { get; set; }

        /// <summary>Gets or sets the request header.</summary>
        [DataMember]
        public RequestHeader RequestHeader { get; set; }

        #endregion
    }
}