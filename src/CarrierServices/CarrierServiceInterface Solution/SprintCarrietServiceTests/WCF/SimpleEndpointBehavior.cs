// --------------------------------------------------------------------------------------------------------------------
// <copyright file="SimpleEndpointBehavior.cs" company="">
//   
// </copyright>
// <summary>
//   The simple endpoint behavior.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCarrierServiceTests
{
    using System.ServiceModel.Channels;
    using System.ServiceModel.Description;
    using System.ServiceModel.Dispatcher;

    /// <summary>The simple endpoint behavior.</summary>
    public class SimpleEndpointBehavior : IEndpointBehavior
    {
        #region Public Methods and Operators

        /// <summary>The add binding parameters.</summary>
        /// <param name="endpoint">The endpoint.</param>
        /// <param name="bindingParameters">The binding parameters.</param>
        void IEndpointBehavior.AddBindingParameters(ServiceEndpoint endpoint, BindingParameterCollection bindingParameters)
        {
            // No implementation necessary
        }

        /// <summary>The apply client behavior.</summary>
        /// <param name="endpoint">The endpoint.</param>
        /// <param name="clientRuntime">The client runtime.</param>
        void IEndpointBehavior.ApplyClientBehavior(ServiceEndpoint endpoint, ClientRuntime clientRuntime)
        {
            clientRuntime.MessageInspectors.Add(new SimpleMessageInspector());
        }

        /// <summary>The apply dispatch behavior.</summary>
        /// <param name="endpoint">The endpoint.</param>
        /// <param name="endpointDispatcher">The endpoint dispatcher.</param>
        void IEndpointBehavior.ApplyDispatchBehavior(ServiceEndpoint endpoint, EndpointDispatcher endpointDispatcher)
        {
            // No implementation necessary
        }

        /// <summary>The validate.</summary>
        /// <param name="endpoint">The endpoint.</param>
        public void Validate(ServiceEndpoint endpoint)
        {
            // No implementation necessary
        }

        #endregion
    }
}