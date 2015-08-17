// --------------------------------------------------------------------------------------------------------------------
// <copyright file="MyEndpointBehavior.cs" company="">
//   
// </copyright>
// <summary>
//   The my eb.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCarrierServiceTests.WCF
{
    using System.ServiceModel.Channels;
    using System.ServiceModel.Description;
    using System.ServiceModel.Dispatcher;
    using System.ServiceModel.Security;

    /// <summary>The my eb.</summary>
    internal class MyEndpointBehavior : IEndpointBehavior
    {
        #region Public Methods and Operators

        /// <summary>The add binding parameters.</summary>
        /// <param name="endpoint">The endpoint.</param>
        /// <param name="bindingParameters">The binding parameters.</param>
        public void AddBindingParameters(ServiceEndpoint endpoint, BindingParameterCollection bindingParameters)
        {
            var cpr = bindingParameters.Find<ChannelProtectionRequirements>();

            if (cpr == null)
            {
                cpr = new ChannelProtectionRequirements();

                bindingParameters.Add(cpr);
            }

            var encryptRmCreateSequenceBody = new ChannelProtectionRequirements();

            var body = new MessagePartSpecification { IsBodyIncluded = true };

            body.MakeReadOnly();

            encryptRmCreateSequenceBody.OutgoingEncryptionParts.AddParts(body, "http://schemas.xmlsoap.org/ws/2005/02/rm/CreateSequence");

            encryptRmCreateSequenceBody.IncomingEncryptionParts.AddParts(body, "http://schemas.xmlsoap.org/ws/2005/02/rm/CreateSequence");

            encryptRmCreateSequenceBody.OutgoingSignatureParts.AddParts(body, "http://schemas.xmlsoap.org/ws/2005/02/rm/CreateSequence");

            encryptRmCreateSequenceBody.IncomingSignatureParts.AddParts(body, "http://schemas.xmlsoap.org/ws/2005/02/rm/CreateSequence");

            encryptRmCreateSequenceBody.MakeReadOnly();

            cpr.Add(encryptRmCreateSequenceBody);
        }

        /// <summary>The apply client behavior.</summary>
        /// <param name="endpoint">The endpoint.</param>
        /// <param name="clientRuntime">The client runtime.</param>
        public void ApplyClientBehavior(ServiceEndpoint endpoint, ClientRuntime clientRuntime)
        {
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
    }
}