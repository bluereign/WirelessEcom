// --------------------------------------------------------------------------------------------------------------------
// <copyright file="SprintAddresMgmtServiceAPIFacts.cs" company="">
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
    using System.ServiceModel;
    using System.ServiceModel.Channels;
    using System.ServiceModel.Security;

    using SprintCarrierServiceTests.AddressMgmtService;

    using SprintCSI.Utils;

    using Xunit;

    /// <summary>The sprint query device info service api facts.</summary>
    public class SprintAddressMgmtServiceAPIFacts
    {
        #region Fields

        /// <summary>The vendor code.</summary>
        protected readonly string VendorCode = ConfigurationManager.AppSettings["Vendor-Code"];

        /// <summary>The vendor pin.</summary>
        protected readonly string VendorPin = ConfigurationManager.AppSettings["Vendor-PIN"];

        /// <summary>The sprint header.</summary>
        private readonly SprintHeader sprintHeader = new SprintHeader();

        /// <summary>The headers.</summary>
        private MessageHeaders headers;

        #endregion

        #region Public Methods and Operators

        /// <summary>The assert validate deviceV8 with bad data returns 705.</summary>
        [Fact]
        public void AssertValidateAddressWithInvalidInputReturns705()
        {
            const string Expected = "Client.705";

            var messageHeader = this.sprintHeader.CreateAMSMessageHeader();

            var addressInfo = new RequestAddressType
                                  {
                                      addressLine1 = "6105 158th Ct Ne", 
                                      addressLine2 = string.Empty, 
                                      city = "Redmond", 
                                      country = "usa", 
                                      companyName = "Wireless Advocates", 
                                      state = "WA", 
                                      zipCode = "98052"
                                  };

            var wcfEventHelper = new WcfEventHelper();

            this.ValidateAddress(messageHeader, addressInfo, wcfEventHelper);

            var actual = wcfEventHelper.ProviderErrorCode;

            Assert.Equal(Expected, actual);
        }

        /// <summary>The assert validate address with good data succeeds.</summary>
        [Fact]
        public void AssertValidateAddressWithSlightlyBadDataSucceeds()
        {
            const string Expected = "92";

            var messageHeader = this.sprintHeader.CreateAMSMessageHeader();

            var addressInfo = new RequestAddressType { addressLine1 = "6105 158th Ct Ne", city = "Redmond", country = "usa", companyName = "Wireless Advocates", state = "WV", zipCode = "98052" };

            var wcfEventHelper = new WcfEventHelper();

            this.ValidateAddress(messageHeader, addressInfo, wcfEventHelper);

            var xmlHelper = new XmlHelper { XmlString = wcfEventHelper.ResponseXml };
            var actual = xmlHelper.GetXmlValue("confidence", false);

            Assert.Equal(Expected, actual);
        }

        /// <summary>The assert validate address with more good data succeeds.</summary>
        [Fact]
        public void AssertValidateAddressWithYetMoreGoodDataSucceeds()
        {
            const string Expected = "100";

            var addressInfo = new RequestAddressType { addressLine1 = "2101 4th Ave", addressLine2 = "Suite 1250", city = "Seattle", country = "usa", companyName = "Wireless Advocates", state = "WA", zipCode = "98121" };

            var messageHeader = this.sprintHeader.CreateAMSMessageHeader();

            var wcfEventHelper = new WcfEventHelper();

            this.ValidateAddress(messageHeader, addressInfo, wcfEventHelper);

            var xmlHelper = new XmlHelper { XmlString = wcfEventHelper.ResponseXml };
            var actual = xmlHelper.GetXmlValue("confidence", false);

            Assert.Equal(Expected, actual);
        }

        /// <summary>The assert validate address with more good data succeeds.</summary>
        [Fact]
        public void AssertValidateAddressWithMoreGoodDataSucceeds()
        {
            const string Expected = "100";

            var addressInfo = new RequestAddressType { addressLine1 = "6105 158th Ct Ne", city = "Redmond", country = "usa", companyName = "Wireless Advocates", state = "WA", zipCode = "98052" };

            var messageHeader = this.sprintHeader.CreateAMSMessageHeader();

            var wcfEventHelper = new WcfEventHelper();

            this.ValidateAddress(messageHeader, addressInfo, wcfEventHelper);

            var xmlHelper = new XmlHelper { XmlString = wcfEventHelper.ResponseXml };
            var actual = xmlHelper.GetXmlValue("confidence", false);

            Assert.Equal(Expected, actual);
        }

        #endregion

        #region Methods

        /// <summary>The validate address.</summary>
        /// <param name="messageHeader">The message header.</param>
        /// <param name="addressInfo">The address info.</param>
        /// <param name="wcfEventHelper">The wcf event helper.</param>
        /// <returns>The <see cref="ValidateAddressResponseType"/>.</returns>
        private ValidateAddressResponseType ValidateAddress(WsMessageHeaderType messageHeader, RequestAddressType addressInfo, WcfEventHelper wcfEventHelper)
        {
            var service = new AddressManagementServicePortTypeClient();

            service.Endpoint.Behaviors.Add(new SimpleEndpointBehavior());

            service.Open();

            var validateAddress = new ValidateAddressType { addressInfo = addressInfo };

            try
            {
                var validateAddressResponse = service.ValidateAddress(ref messageHeader, validateAddress);
                wcfEventHelper.DisposeSubscriptions();
                service.Close();
                return validateAddressResponse;
            }
            catch (MessageSecurityException ex)
            {
                // this.headers = OperationContext.Current.IncomingMessageHeaders;
                if (ex.InnerException != null)
                {
                    Trace.WriteLine("\n\n\nMessageSecurityException Exception ==> " + ex.Message + " ==> " + ex.InnerException.Message);
                }
                else
                {
                    Trace.WriteLine("\n\n\nMessageSecurityException Exception ==> " + ex.Message);
                }

                wcfEventHelper.DisposeSubscriptions();
                return null;
            }
            catch (CommunicationObjectFaultedException ex)
            {
                Trace.WriteLine("\nCommunicationObjectFaultedException Message ==> " + ex.Message);
                wcfEventHelper.DisposeSubscriptions();
                return null;
            }
            catch (FaultException<ProviderErrorType[]> ex)
            {
                Trace.WriteLine("\nFaultException<ProviderErrorType[]> Message ==> " + ex.Message);
                if (ex.Detail.Length > 0)
                {
                    Trace.WriteLine("FaultException<ProviderErrorType[]> errorProgramId ==> " + ex.Detail[0].errorProgramId);
                    Trace.WriteLine("FaultException<ProviderErrorType[]> errorSystem ==> " + ex.Detail[0].errorSystem);
                    Trace.WriteLine("FaultException<ProviderErrorType[]> errorTransactionId ==> " + ex.Detail[0].errorTransactionId);
                    Trace.WriteLine("FaultException<ProviderErrorType[]> fieldInError ==> " + ex.Detail[0].fieldInError);
                    Trace.WriteLine("FaultException<ProviderErrorType[]> providerErrorCode==> " + ex.Detail[0].providerErrorCode);
                    Trace.WriteLine("FaultException<ProviderErrorType[]> providerErrorText ==> " + ex.Detail[0].providerErrorText);
                }

                wcfEventHelper.DisposeSubscriptions();
                return null;
            }
            catch (FaultException ex)
            {
                Trace.WriteLine("Fault Exception ==> " + ex.Message);
                var msgFault = ex.CreateMessageFault();
                var elm = msgFault.GetDetail<ProviderErrorType[]>();
                if (elm[0] != null)
                {
                    Trace.WriteLine("ProviderErrorType ==> " + elm[0].providerErrorText);
                }

                wcfEventHelper.DisposeSubscriptions();
                return null;
            }
            catch (Exception ex)
            {
                // this.headers = OperationContext.Current.IncomingMessageHeaders;
                Trace.WriteLine(ex.GetType().Name + " ==> " + ex.Message);
                wcfEventHelper.DisposeSubscriptions();

                return null;
            }
        }

        #endregion
    }
}