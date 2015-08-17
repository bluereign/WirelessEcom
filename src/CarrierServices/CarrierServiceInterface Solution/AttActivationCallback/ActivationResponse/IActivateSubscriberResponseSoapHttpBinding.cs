// --------------------------------------------------------------------------------------------------------------------
// <copyright file="IActivateSubscriberResponseSoapHttpBinding.cs" company="">
//   
// </copyright>
// <summary>
//   The ActivateSubscriberResponseSoapHttpBinding interface.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace ActivationResponse
{
    using System.CodeDom.Compiler;
    using System.Web.Services;
    using System.Web.Services.Description;
    using System.Web.Services.Protocols;
    using System.Xml.Serialization;

    using AttCarrierServiceInterface.Interfaces.AttProxy;

    /// <summary>The ActivateSubscriberResponseSoapHttpBinding interface.</summary>
    /// <remarks></remarks>
    [GeneratedCode("wsdl", "2.0.50727.3038")]
    [WebServiceBinding(Name = "ActivateSubscriberResponseSoapHttpBinding", 
        Namespace = "http://csi.cingular.com/CSI/Namespaces/v32/wsdl/CingularWirelessCSI.wsdl")]
    [XmlInclude(typeof(PreviousUsageInfo))]
    [XmlInclude(typeof(UsageInfo))]
    public interface IActivateSubscriberResponseSoapHttpBinding
    {
        #region Public Properties

        /// <summary>Gets or sets the message header.</summary>
        MessageHeaderInfo MessageHeader { get; set; }

        #endregion

        #region Public Methods and Operators

        /// <summary>The activate subscriber response.</summary>
        /// <param name="activateSubscriberResponse">The Activate Subscriber Response.</param>
        /// <remarks></remarks>
        /// <returns>The <see cref="RequestAcknowledgementInfo"/>.</returns>
        [SoapHeader("MessageHeader", Direction = SoapHeaderDirection.InOut)]
        [WebMethod]
        [SoapDocumentMethod("", Use = SoapBindingUse.Literal, ParameterStyle = SoapParameterStyle.Bare)]
        [return: XmlElement("RequestAcknowledgement", Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/RequestAcknowledgement.xs" + "d")]
        RequestAcknowledgementInfo ActivateSubscriberResponse(ActivateSubscriberResponseInfo activateSubscriberResponse);

        #endregion
    }
}