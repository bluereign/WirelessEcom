// --------------------------------------------------------------------------------------------------------------------
// <copyright file="MessageViewerInspector.cs" company="">
//   
// </copyright>
// <summary>
//   The message viewer inspector.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCarrierServiceTests.WCF
{
    using System.Diagnostics;
    using System.ServiceModel;
    using System.ServiceModel.Channels;
    using System.ServiceModel.Description;
    using System.ServiceModel.Dispatcher;

    /// <summary>The message viewer inspector.</summary>
    public class MessageViewerInspector : IEndpointBehavior, IClientMessageInspector
    {
        #region Public Properties

        /// <summary>Gets or sets the request message.</summary>
        public string RequestMessage { get; set; }

        /// <summary>Gets or sets the response message.</summary>
        public string ResponseMessage { get; set; }

        #endregion

        #region Public Methods and Operators

        /// <summary>The add binding parameters.</summary>
        /// <param name="endpoint">The endpoint.</param>
        /// <param name="bindingParameters">The binding parameters.</param>
        public void AddBindingParameters(ServiceEndpoint endpoint, BindingParameterCollection bindingParameters)
        {
        }

        /// <summary>The apply client behavior.</summary>
        /// <param name="endpoint">The endpoint.</param>
        /// <param name="clientRuntime">The client runtime.</param>
        public void ApplyClientBehavior(ServiceEndpoint endpoint, ClientRuntime clientRuntime)
        {
            // adds our inspector to the runtime
            clientRuntime.MessageInspectors.Add(this);
        }

        /// <summary>The apply dispatch behavior.</summary>
        /// <param name="endpoint">The endpoint.</param>
        /// <param name="endpointDispatcher">The endpoint dispatcher.</param>
        public void ApplyDispatchBehavior(ServiceEndpoint endpoint, EndpointDispatcher endpointDispatcher)
        {
        }

        /// <summary>The validate.</summary>
        /// <param name="endpoint">The endpoint.</param>
        public void Validate(ServiceEndpoint endpoint)
        {
        }

        #endregion

        #region Explicit Interface Methods

        /// <summary>The after receive reply.</summary>
        /// <param name="reply">The reply.</param>
        /// <param name="correlationState">The correlation state.</param>
        void IClientMessageInspector.AfterReceiveReply(ref Message reply, object correlationState)
        {

            this.ResponseMessage = reply.ToString();
            Trace.WriteLine("\nMessageViewerInspector.AfterReceiveReply ==> " + this.ResponseMessage);
        }

        /// <summary>The before send request.</summary>
        /// <param name="request">The request.</param>
        /// <param name="channel">The channel.</param>
        /// <returns>The <see cref="object"/>.</returns>
        object IClientMessageInspector.BeforeSendRequest(ref Message request, IClientChannel channel)
        {
            this.RequestMessage = request.ToString();
            Trace.WriteLine("\nMessageViewerInspector.BeforeSendRequest ==> " + this.RequestMessage);
            return null;
        }

        #endregion
    }
}