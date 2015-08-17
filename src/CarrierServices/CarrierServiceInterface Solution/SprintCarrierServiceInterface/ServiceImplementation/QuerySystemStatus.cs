// --------------------------------------------------------------------------------------------------------------------
// <copyright file="QuerySystemStatus.cs" company="">
//   
// </copyright>
// <summary>
//   The query system status.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation
{
    using System;
    using System.Diagnostics;
    using System.IdentityModel.Tokens;
    using System.Security.Cryptography;
    using System.ServiceModel;
    using System.ServiceModel.Security;

    using SprintCSI.QuerySystemStatusService;
    using SprintCSI.ServiceImplementation.DTO;
    using SprintCSI.WCF;

    /// <summary>The query system status.</summary>
    public class QuerySystemStatus : SoapBase
    {
        #region Public Methods and Operators

        /// <summary>The execute.</summary>
        /// <param name="querySystemStatusRequest">The query system status request.</param>
        /// <returns>The <see cref="QuerySystemStatusResponse"/>.</returns>
        public QuerySystemStatusResponse Execute(QuerySystemStatusRequest querySystemStatusRequest)
        {
            QuerySystemStatusPortTypeClient service;
            try
            {
                service = new QuerySystemStatusPortTypeClient();
            }
            catch (InvalidOperationException ex)
            {
                Trace.WriteLine("InvalidOperationException Exception ==> " + ex.Message);
                return new QuerySystemStatusResponse { ProviderErrorCode = "InvalidOperationException", ProviderErrorText = "Exception ==> " + ex.Message, PingResponse = false };
            }

            service.Endpoint.Behaviors.Add(new SimpleEndpointBehavior());

            service.Open();

            try
            {
                bool pingResponse = service.ping();
                return new QuerySystemStatusResponse
                           {
                               ProviderErrorCode = this.WcfEventHelper.ProviderErrorCode, 
                               ProviderErrorText = this.WcfEventHelper.ProviderErrorText, 
                               PingResponse = pingResponse
                           };
            }
            catch (CryptographicException ex)
            {
                Trace.WriteLine("CryptographicException  Exception ==> " + ex.Message);
                return new QuerySystemStatusResponse { ProviderErrorCode = "CryptographicException ", ProviderErrorText = "Exception ==> " + ex.Message, PingResponse = false };
            }
            catch (SecurityTokenValidationException ex)
            {
                Trace.WriteLine("SecurityTokenValidationException  Exception ==> " + ex.Message);
                return new QuerySystemStatusResponse { ProviderErrorCode = "SecurityTokenValidationException ", ProviderErrorText = "Exception ==> " + ex.Message, PingResponse = false };
            }
            catch (NotSupportedException ex)
            {
                Trace.WriteLine("NotSupportedException  Exception ==> " + ex.Message);
                return new QuerySystemStatusResponse { ProviderErrorCode = "NotSupportedException ", ProviderErrorText = "Exception ==> " + ex.Message, PingResponse = false };
            }
            catch (InvalidOperationException ex)
            {
                Trace.WriteLine("InvalidOperationException Exception ==> " + ex.Message);
                return new QuerySystemStatusResponse { ProviderErrorCode = "InvalidOperationException", ProviderErrorText = "Exception ==> " + ex.Message, PingResponse = false };
            }
            catch (MessageSecurityException ex)
            {
                Trace.WriteLine("MessageSecurityException Exception ==> " + ex.Message);
                return new QuerySystemStatusResponse
                           {
                               ProviderErrorCode = "MessageSecurityException", 
                               ProviderErrorText = "Exception ==> " + ex.Message + " ==> " + ex.InnerException.Message, 
                               PingResponse = false
                           };
            }
            catch (FaultException ex)
            {
                Trace.WriteLine("Fault Exception ==> " + ex.Message);
                return new QuerySystemStatusResponse { ProviderErrorCode = this.WcfEventHelper.ProviderErrorCode, ProviderErrorText = this.WcfEventHelper.ProviderErrorText, PingResponse = false };
            }
            catch (Exception ex)
            {
                Trace.WriteLine(ex.GetType().Name + " ==> " + ex.Message);
                return new QuerySystemStatusResponse { ProviderErrorCode = ex.GetType().Name, ProviderErrorText = ex.Message, PingResponse = false };
            }
        }

        #endregion
    }
}