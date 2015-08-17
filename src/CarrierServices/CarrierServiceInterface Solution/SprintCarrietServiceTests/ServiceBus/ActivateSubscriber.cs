// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ActivateSubscriber.cs" company="">
//   
// </copyright>
// <summary>
//   The activate subscriber.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace WirelessAdvocates.Services.CarrierInterface.ATT.ServiceModel
{
    using System.Runtime.Serialization;

    using SprintCarrierServiceTests.ServiceBus;

    using WirelessAdvocates.Services.CarrierInterface.ATT.Common;
    using WirelessAdvocates.Services.CarrierInterface.ATT.Common.Types;

    /// <summary>The activate subscriber.</summary>
    [DataContract(Namespace = Constants.ATT_SERVICE_NAMESPACE)]
    public class ActivateSubscriber : OperationBase<ActivateSubscriberRequest>
    {
    }

    /// <summary>The activate subscriber request.</summary>
    [DataContract(Namespace = Constants.ATT_SERVICE_NAMESPACE)]
    public class ActivateSubscriberRequest : RequestBase
    {
        #region Public Properties

        /// <summary>Gets or sets the billing account number.</summary>
        [DataMember]
        public string BillingAccountNumber { get; set; }

        /// <summary>Gets or sets a value indicating whether family plan.</summary>
        [DataMember]
        public bool FamilyPlan { get; set; }

        /// <summary>Gets or sets the order line.</summary>
        [DataMember]
        public Order_Line OrderLine { get; set; }

        /// <summary>Gets or sets the service zip code.</summary>
        [DataMember]
        public string ServiceZipCode { get; set; }

        #endregion
    }

    /// <summary>The activate subscriber response.</summary>
    [DataContract(Namespace = Constants.ATT_SERVICE_NAMESPACE)]
    public class ActivateSubscriberResponse : ResponseBase
    {
    }
}