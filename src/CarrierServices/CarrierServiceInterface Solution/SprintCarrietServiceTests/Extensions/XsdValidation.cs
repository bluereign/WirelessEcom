// --------------------------------------------------------------------------------------------------------------------
// <copyright file="XsdValidation.cs" company="">
//   
// </copyright>
// <summary>
//   The xsd validation.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCarrierServiceTests.Extensions
{
    using System;
    using System.Collections.ObjectModel;
    using System.Diagnostics;
    using System.ServiceModel;
    using System.ServiceModel.Channels;
    using System.ServiceModel.Description;
    using System.ServiceModel.Dispatcher;
    using System.Xml;

    /// <summary>The xsd validation.</summary>
    public class XsdValidation : Attribute, IServiceBehavior, IEndpointBehavior
    {
        #region Explicit Interface Methods

        /// <summary>The add binding parameters.</summary>
        /// <param name="endpoint">The endpoint.</param>
        /// <param name="bindingParameters">The binding parameters.</param>
        void IEndpointBehavior.AddBindingParameters(ServiceEndpoint endpoint, BindingParameterCollection bindingParameters)
        {
            Trace.WriteLine("IEndpointBehavior.AddBindingParameters");
        }

        /// <summary>The apply client behavior.</summary>
        /// <param name="endpoint">The endpoint.</param>
        /// <param name="clientRuntime">The client runtime.</param>
        void IEndpointBehavior.ApplyClientBehavior(ServiceEndpoint endpoint, ClientRuntime clientRuntime)
        {
            Trace.WriteLine("IEndpointBehavior.ApplyClientBehavior");
        }

        /// <summary>The apply dispatch behavior.</summary>
        /// <param name="endpoint">The endpoint.</param>
        /// <param name="endpointDispatcher">The endpoint dispatcher.</param>
        void IEndpointBehavior.ApplyDispatchBehavior(ServiceEndpoint endpoint, EndpointDispatcher endpointDispatcher)
        {
            Trace.WriteLine("IEndpointBehavior.ApplyDispatchBehavior");
            var wsdlExporter = new WsdlExporter();
            wsdlExporter.ExportEndpoint(endpoint);
            endpointDispatcher.DispatchRuntime.MessageInspectors.Add(new XsdValidationInspector(wsdlExporter.GeneratedXmlSchemas));
        }

        /// <summary>The validate.</summary>
        /// <param name="endpoint">The endpoint.</param>
        void IEndpointBehavior.Validate(ServiceEndpoint endpoint)
        {
            Trace.WriteLine("IEndpointBehavior.Validate");
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
            Trace.WriteLine("IEndpointBehavior.AddBindingParameters");
        }

        /// <summary>The apply dispatch behavior.</summary>
        /// <param name="serviceDescription">The service description.</param>
        /// <param name="serviceHostBase">The service host base.</param>
        void IServiceBehavior.ApplyDispatchBehavior(ServiceDescription serviceDescription, ServiceHostBase serviceHostBase)
        {
           
            var wsdlExporter = new WsdlExporter();
            wsdlExporter.ExportEndpoints(serviceDescription.Endpoints, new XmlQualifiedName(serviceDescription.Name, serviceDescription.Namespace));

            foreach (ChannelDispatcher dispatcher in serviceHostBase.ChannelDispatchers)
            {
                foreach (var endpointDispatcher in dispatcher.Endpoints)
                {
                    endpointDispatcher.DispatchRuntime.MessageInspectors.Add(new XsdValidationInspector(wsdlExporter.GeneratedXmlSchemas));
                }
            }
        }

        /// <summary>The validate.</summary>
        /// <param name="serviceDescription">The service description.</param>
        /// <param name="serviceHostBase">The service host base.</param>
        void IServiceBehavior.Validate(ServiceDescription serviceDescription, ServiceHostBase serviceHostBase)
        {
            Trace.WriteLine("IServiceBehavior.Validate");
        }

        #endregion
    }
}