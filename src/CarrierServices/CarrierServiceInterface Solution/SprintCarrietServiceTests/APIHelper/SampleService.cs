// --------------------------------------------------------------------------------------------------------------------
// <copyright file="SampleService.cs" company="">
//   
// </copyright>
// <summary>
//   The service.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCarrierServiceTests.APIHelper
{
    /// <summary>The service.</summary>
    public class Service
    {
        #region Fields

        /// <summary>The _config.</summary>
        private readonly WebServiceConfig _config;

        /// <summary>The _service client wrapper.</summary>
       //  private readonly ServiceClientWrapper<ManagementServiceClient, IManagementService> _serviceClientWrapper;

        #endregion

        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="Service"/> class.</summary>
        /// <param name="config">The config.</param>
        /// <param name="serviceClientWrapper">The service client wrapper.</param>
        //public Service(
        //    WebServiceConfig config, 
        //    ServiceClientWrapper<ManagementServiceClient, IManagementService> serviceClientWrapper)
        //{
        //    this._config = config;
        //    this._serviceClientWrapper = serviceClientWrapper;
        //}

        #endregion

        #region Public Methods and Operators

        /// <summary>The get response.</summary>
        /// <returns>The <see cref="string"/>.</returns>
        //public string GetResponse()
        //{
        //    return this._serviceClientWrapper.Execute(this._config, serviceClient => serviceClient.GetResponse());
        //}

        #endregion
    }
}