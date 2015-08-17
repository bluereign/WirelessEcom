// --------------------------------------------------------------------------------------------------------------------
// <copyright file="NoBasicEndpointValidator.cs" company="">
//   
// </copyright>
// <summary>
//   The no basic endpoint validator.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace Extensions
{
    using System;
    using System.Collections.ObjectModel;
    using System.Linq;
    using System.ServiceModel;
    using System.ServiceModel.Channels;
    using System.ServiceModel.Description;

    /// <summary>The no basic endpoint validator.</summary>
    public class NoBasicEndpointValidator : Attribute, IServiceBehavior
    {
        #region Public Methods and Operators

        /// <summary>The add binding parameters.</summary>
        /// <param name="serviceDescription">The service description.</param>
        /// <param name="serviceHostBase">The service host base.</param>
        /// <param name="endpoints">The endpoints.</param>
        /// <param name="bindingParameters">The binding parameters.</param>
        public void AddBindingParameters(ServiceDescription serviceDescription, ServiceHostBase serviceHostBase, Collection<ServiceEndpoint> endpoints, BindingParameterCollection bindingParameters)
        {
        }

        /// <summary>The apply dispatch behavior.</summary>
        /// <param name="serviceDescription">The service description.</param>
        /// <param name="serviceHostBase">The service host base.</param>
        public void ApplyDispatchBehavior(ServiceDescription serviceDescription, ServiceHostBase serviceHostBase)
        {
        }

        /// <summary>The validate.</summary>
        /// <param name="serviceDescription">The service description.</param>
        /// <param name="serviceHostBase">The service host base.</param>
        /// <exception cref="FaultException"></exception>
        public void Validate(ServiceDescription serviceDescription, ServiceHostBase serviceHostBase)
        {
            if (serviceDescription.Endpoints.Any(se => se.Binding.Name.Equals("BasicHttpBinding")))
            {
                throw new FaultException("BasicHttpBinding is not allowed. Please choose a secure binding.");
            }
        }

        #endregion
    }
}