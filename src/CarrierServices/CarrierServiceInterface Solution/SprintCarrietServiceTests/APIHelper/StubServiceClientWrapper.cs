// --------------------------------------------------------------------------------------------------------------------
// <copyright file="StubServiceClientWrapper.cs" company="">
//   
// </copyright>
// <summary>
//   The stub service client wrapper.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCarrierServiceTests.APIHelper
{
    using System.ServiceModel;

    /// <summary>The stub service client wrapper.</summary>
    /// <typeparam name="TClient"></typeparam>
    /// <typeparam name="TService"></typeparam>
    public class StubServiceClientWrapper<TClient, TService> : ServiceClientWrapper<TClient, TService>
        where TClient : ClientBase<TService>, TService where TService : class
    {
        #region Fields

        /// <summary>The _service client to return.</summary>
        private readonly TService serviceClientToReturn;

        #endregion

        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="StubServiceClientWrapper{TClient,TService}"/> class.</summary>
        /// <param name="serviceClientToReturn">The service client to return.</param>
        public StubServiceClientWrapper(TService serviceClientToReturn)
        {
            this.serviceClientToReturn = serviceClientToReturn;
        }

        #endregion

        #region Methods

        /// <summary>The create service client.</summary>
        /// <param name="config">The config.</param>
        /// <returns>The <see cref="TService"/>.</returns>
        protected override TService CreateServiceClient(WebServiceConfig config)
        {
            return this.serviceClientToReturn;
        }

        #endregion
    }
}