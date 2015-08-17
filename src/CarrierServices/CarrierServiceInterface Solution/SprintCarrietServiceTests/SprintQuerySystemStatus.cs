// --------------------------------------------------------------------------------------------------------------------
// <copyright file="SprintQueryDeviceInfoServiceAPIFacts.cs" company="">
//   
// </copyright>
// <summary>
//   The sprint query device info service api facts.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCarrierServiceTests
{
    using System;
    using System.Configuration;
    using System.Diagnostics;
    using System.IdentityModel.Tokens;
    using System.Net;
    using System.Net.Security;
    using System.ServiceModel;
    using System.ServiceModel.Security;

    using SprintCarrierServiceTests.QuerySystemStatusService;
    using SprintCarrierServiceTests.WCF;

    using Xunit;

    /// <summary>The sprint query device info service api facts.</summary>
    public class QuerySystemStatusServiceAPIFacts
    {
        #region Fields

        /// <summary>The vendor code.</summary>
        protected readonly string VendorCode = ConfigurationManager.AppSettings["Vendor-Code"];

        /// <summary>The vendor pin.</summary>
        protected readonly string VendorPin = ConfigurationManager.AppSettings["Vendor-PIN"];

        /// <summary>The sprint header.</summary>
        private readonly SprintHeader sprintHeader = new SprintHeader();

        #endregion

        #region Public Methods and Operators

        /// <summary>The assert validate plans and options with bad data throws fault exception.</summary>
        [Fact]
        public void AssertQuerySystemStatusServiceWithBadDataThrowsFaultException()
        {
            bool expected = true;

            string myProviderErrorCode;
            string myProviderErrorText;

            bool actual = this.QuerySystemStatus(out myProviderErrorCode, out myProviderErrorText);
            Assert.Equal(expected, actual);
        }

        /// <summary>The assert validate plans and options with good data succeeds.</summary>
        [Fact]
        public void AssertQuerySystemStatusServiceWithGoodDataSucceeds()
        {
            bool expected = true;

            string myProviderErrorCode;
            string myProviderErrorText;

            bool actual = this.QuerySystemStatus(out myProviderErrorCode, out myProviderErrorText);
            Assert.Equal(expected, actual);
        }

        #endregion

        #region Methods

        /// <summary>The query system status.</summary>
        /// <param name="myProviderErrorCode">The my provider error code.</param>
        /// <param name="myProviderErrorText">The my provider error text.</param>
        /// <returns>The <see cref="bool" />.</returns>
        private bool QuerySystemStatus(out string myProviderErrorCode, out string myProviderErrorText)
        {
            myProviderErrorCode = string.Empty;
            myProviderErrorText = string.Empty;

            var wcfEventHelper = new WcfEventHelper();

            QuerySystemStatusPortTypeClient service;
            try
            {
                service = new QuerySystemStatusPortTypeClient();
            }
            catch (InvalidOperationException ex)
            {
                Trace.WriteLine("InvalidOperationException Exception ==> " + ex.Message);
                wcfEventHelper.DisposeSubscriptions();
                return false;
            }

            service.Endpoint.Behaviors.Add(new SimpleEndpointBehavior());

            service.Open();

            try
            {
                bool pingResponse = service.ping();
                wcfEventHelper.DisposeSubscriptions();
                return pingResponse;
            }

            catch (SecurityTokenValidationException ex)
            {
                Trace.WriteLine("SecurityTokenValidationException  Exception ==> " + ex.Message);
                return false;
            }
            catch (MessageSecurityException ex)
            {
                Trace.WriteLine("MessageSecurityException ==> " + ex.Message);
                wcfEventHelper.DisposeSubscriptions();
                return false;
            }
            catch (NotSupportedException ex)
            {
                Trace.WriteLine("NotSupportedException ==> " + ex.Message);
                wcfEventHelper.DisposeSubscriptions();
                return false;
            }
            catch (FaultException ex)
            {
                Trace.WriteLine("Fault Exception ==> " + ex.Message);
                //var msgFault = ex.CreateMessageFault();
                //var elm = msgFault.GetDetail<ProviderErrorType[]>();
                //if (elm[0] != null)
                //{
                //    Trace.WriteLine("ProviderErrorType ==> " + elm[0].providerErrorText);
                //}

                wcfEventHelper.DisposeSubscriptions();
                return false;
            }
            catch (Exception ex)
            {
                Trace.WriteLine(ex.GetType().Name + " ==> " + ex.Message);
                wcfEventHelper.DisposeSubscriptions();
                return false;
            }
        }

        #endregion
    }
}