// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ConsoleMessageTracing.cs" company="">
//   
// </copyright>
// <summary>
//   The console message tracing.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCarrierServiceTests.Extensions
{
    using System;
    using System.Collections.ObjectModel;
    using System.ServiceModel;
    using System.ServiceModel.Channels;
    using System.ServiceModel.Description;
    using System.ServiceModel.Dispatcher;

    /// <summary>The console message tracing.</summary>
    public class ConsoleMessageTracing : Attribute, IEndpointBehavior, IServiceBehavior
    {
        #region Explicit Interface Methods

        /// <summary>The add binding parameters.</summary>
        /// <param name="endpoint">The endpoint.</param>
        /// <param name="bindingParameters">The binding parameters.</param>
        void IEndpointBehavior.AddBindingParameters(ServiceEndpoint endpoint, BindingParameterCollection bindingParameters)
        {
        }

        /// <summary>The apply client behavior.</summary>
        /// <param name="endpoint">The endpoint.</param>
        /// <param name="clientRuntime">The client runtime.</param>
        void IEndpointBehavior.ApplyClientBehavior(ServiceEndpoint endpoint, ClientRuntime clientRuntime)
        {
            clientRuntime.MessageInspectors.Add(new ConsoleMessageTracer());
        }

        /// <summary>The apply dispatch behavior.</summary>
        /// <param name="endpoint">The endpoint.</param>
        /// <param name="endpointDispatcher">The endpoint dispatcher.</param>
        void IEndpointBehavior.ApplyDispatchBehavior(ServiceEndpoint endpoint, EndpointDispatcher endpointDispatcher)
        {
            endpointDispatcher.DispatchRuntime.MessageInspectors.Add(new ConsoleMessageTracer());
        }

        /// <summary>The validate.</summary>
        /// <param name="endpoint">The endpoint.</param>
        void IEndpointBehavior.Validate(ServiceEndpoint endpoint)
        {
        }

        /// <summary>The add binding parameters.</summary>
        /// <param name="serviceDescription">The service description.</param>
        /// <param name="serviceHostBase">The service host base.</param>
        /// <param name="endpoints">The endpoints.</param>
        /// <param name="bindingParameters">The binding parameters.</param>
        void IServiceBehavior.AddBindingParameters(
            ServiceDescription serviceDescription, 
            ServiceHostBase serviceHostBase, 
            Collection<ServiceEndpoint> endpoints, 
            BindingParameterCollection bindingParameters)
        {
        }

        /// <summary>The apply dispatch behavior.</summary>
        /// <param name="serviceDescription">The service description.</param>
        /// <param name="serviceHostBase">The service host base.</param>
        void IServiceBehavior.ApplyDispatchBehavior(ServiceDescription serviceDescription, ServiceHostBase serviceHostBase)
        {
            foreach (ChannelDispatcher cDispatcher in serviceHostBase.ChannelDispatchers)
            {
                foreach (var endpointDispatcher in cDispatcher.Endpoints)
                {
                    endpointDispatcher.DispatchRuntime.MessageInspectors.Add(new ConsoleMessageTracer());
                }
            }
        }

        /// <summary>The validate.</summary>
        /// <param name="serviceDescription">The service description.</param>
        /// <param name="serviceHostBase">The service host base.</param>
        void IServiceBehavior.Validate(ServiceDescription serviceDescription, ServiceHostBase serviceHostBase)
        {
        }

        #endregion
    }
}