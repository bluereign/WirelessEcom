// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ServiceClientWrapper.cs" company="">
//   
// </copyright>
// <summary>
//   The service client wrapper.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCarrierServiceTests.APIHelper
{
    using System;
    using System.Net;
    using System.Net.Security;
    using System.ServiceModel;

    /// <summary>The service client wrapper.</summary>
    /// <typeparam name="TClient"></typeparam>
    /// <typeparam name="TService"></typeparam>
    public class ServiceClientWrapper<TClient, TService> : IDisposable
        where TClient : ClientBase<TService>, TService where TService : class
    {
        #region Fields

        /// <summary>The _service client.</summary>
        private TClient _serviceClient;

        #endregion

        #region Public Methods and Operators

        /// <summary>The dispose.</summary>
        public void Dispose()
        {
            this.DisposeExistingServiceClientIfRequired();
        }

        /// <summary>The execute.</summary>
        /// <param name="config">The config.</param>
        /// <param name="serviceCall">The service call.</param>
        /// <param name="commsExceptionHandler">The comms exception handler.</param>
        /// <param name="numberOfTimesToRetry">The number of times to retry.</param>
        public void Execute(
            WebServiceConfig config, 
            Action<TService> serviceCall, 
            Action<CommunicationException> commsExceptionHandler = null, 
            int numberOfTimesToRetry = 1)
        {
            this.Execute<object>(
                config, 
                service =>
                    {
                        serviceCall.Invoke(service);
                        return null;
                    }, 
                commsExceptionHandler, 
                numberOfTimesToRetry);
        }

        /// <summary>The execute.</summary>
        /// <param name="config">The config.</param>
        /// <param name="serviceCall">The service call.</param>
        /// <param name="commsExceptionHandler">The comms exception handler.</param>
        /// <param name="numberOfTimesToRetry">The number of times to retry.</param>
        /// <typeparam name="TResult"></typeparam>
        /// <returns>The <see cref="TResult"/>.</returns>
        /// <exception cref="CommunicationException"></exception>
        public TResult Execute<TResult>(
            WebServiceConfig config, 
            Func<TService, TResult> serviceCall, 
            Action<CommunicationException> commsExceptionHandler = null, 
            int numberOfTimesToRetry = 1)
        {
            SetupSecurity(config);

            int i = 0;
            CommunicationException thrownException = null;

            while (i < numberOfTimesToRetry)
            {
                this.DisposeExistingServiceClientIfRequired();

                try
                {
                    return serviceCall.Invoke(this.CreateServiceClient(config));
                }
                catch (CommunicationException faultEx)
                {
                    thrownException = faultEx;

                    if (commsExceptionHandler != null)
                    {
                        try
                        {
                            commsExceptionHandler.Invoke(thrownException);
                        }
                        catch (CommunicationException rethrownEx)
                        {
                            thrownException = rethrownEx;
                        }
                    }

                    ++i;
                }
                finally
                {
                    this.DisposeExistingServiceClientIfRequired();
                }
            }

            throw thrownException;
        }

        #endregion

        #region Methods

        /// <summary>The create service client.</summary>
        /// <param name="config">The config.</param>
        /// <returns>The <see cref="TService"/>.</returns>
        protected virtual TService CreateServiceClient(WebServiceConfig config)
        {
            // Or you can use:
            // this._serviceClient = (TClient)typeof(TClient).GetInstance(
            // config.Binding,
            // new EndpointAddress(config.Endpoint));
            this._serviceClient =
                (TClient)Activator.CreateInstance(typeof(TClient), config.Binding, new EndpointAddress(config.Endpoint));

            return this._serviceClient;
        }

        /// <summary>The setup security.</summary>
        /// <param name="config">The config.</param>
        private static void SetupSecurity(WebServiceConfig config)
        {
            if (config.IgnoreSslErrors)
            {
                ServicePointManager.ServerCertificateValidationCallback = (obj, certificate, chain, errors) => true;
            }
            else
            {
                ServicePointManager.ServerCertificateValidationCallback =
                    (obj, certificate, chain, errors) => errors == SslPolicyErrors.None;
            }
        }

        /// <summary>The dispose existing service client if required.</summary>
        private void DisposeExistingServiceClientIfRequired()
        {
            if (this._serviceClient != null)
            {
                try
                {
                    if (this._serviceClient.State == CommunicationState.Faulted)
                    {
                        this._serviceClient.Abort();
                    }
                    else
                    {
                        this._serviceClient.Close();
                    }
                }
                catch
                {
                    this._serviceClient.Abort();
                }

                this._serviceClient = null;
            }
        }

        #endregion
    }
}