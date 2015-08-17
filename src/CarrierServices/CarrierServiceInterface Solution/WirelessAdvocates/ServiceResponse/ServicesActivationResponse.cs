// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ServicesActivationResponse.cs" company="">
//   
// </copyright>
// <summary>
//   The services activation response.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace WirelessAdvocates.ServiceResponse
{
    using System.Collections.Generic;

    /// <summary>The services activation response.</summary>
    public class ServicesActivationResponse : CarrierResponse
    {
        #region Fields

        /// <summary>The _added services.</summary>
        private readonly List<ServiceActivation> addedServices;

        /// <summary>The _deleted services.</summary>
        private readonly List<ServiceActivation> deletedServices;

        #endregion

        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="ServicesActivationResponse"/> class.</summary>
        public ServicesActivationResponse()
        {
            this.addedServices = new List<ServiceActivation>();
            this.deletedServices = new List<ServiceActivation>();
        }

        #endregion

        #region Public Methods and Operators

        /// <summary>The added services.</summary>
        /// <param name="services">The services.</param>
        public void AddedServices(ServiceActivation services)
        {
            this.addedServices.Add(services);
        }

        /// <summary>The deleted services.</summary>
        /// <param name="services">The services.</param>
        public void DeletedServices(ServiceActivation services)
        {
            this.deletedServices.Add(services);
        }

        #endregion

        /// <summary>The service activation.</summary>
        public class ServiceActivation
        {
            #region Public Properties

            /// <summary>Gets or sets the activation result.</summary>
            public int ActivationResult { get; set; }

            /// <summary>Gets or sets the service code.</summary>
            public string ServiceCode { get; set; }

            #endregion
        }
    }
}