// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ActivateSubscriberResponse.asmx.cs" company="">
//   
// </copyright>
// <summary>
//   Summary description for ActivateSubscriberResponse
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace ActivationResponse
{
    using System.Web.Services;
    using System.Web.Services.Protocols;

    using AttCarrierServiceInterface.Interfaces.AttProxy;

    /// <summary> Summary description for ActivateSubscriberResponse </summary>
    [WebService(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ActivateSubscriberResponse.xsd")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [SoapDocumentService(RoutingStyle = SoapServiceRoutingStyle.RequestElement)]
    public class ActivateSubscriberResponseService : WebService, IActivateSubscriberResponseSoapHttpBinding
    {
        #region Public Properties

        /// <summary>Gets or sets the message header.</summary>
        public MessageHeaderInfo MessageHeader { get; set; }

        #endregion

        #region Public Methods and Operators

        /// <summary>The activate subscriber response.</summary>
        /// <param name="activateSubscriberResponse">The activate subscriber response.</param>
        /// <returns>The <see cref="RequestAcknowledgementInfo"/>.</returns>
        [WebMethod]
        public RequestAcknowledgementInfo ActivateSubscriberResponse(
            ActivateSubscriberResponseInfo activateSubscriberResponse)
        {
            var handler = new ActivateSubscriberResponseHandler();
            handler.Handle(activateSubscriberResponse);

            var ack = new RequestAcknowledgementInfo();
            ack.Response = new ResponseInfo { code = "0", description = "SUCCESS" };
            return ack;
        }

        #endregion
    }
}