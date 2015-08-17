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
    using System.ServiceModel;
    using System.ServiceModel.Channels;
    using System.ServiceModel.Security;

    using SprintCarrierServiceTests.QueryDeviceInfoService;

    using SprintCSI.Utils;

    using Xunit;

    /// <summary>The sprint query device info service api facts.</summary>
    public class SprintQueryDeviceInfoServiceAPIFacts
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

        /// <summary>The assert validate deviceV8 with bad data returns 701.</summary>
        [Fact]
        public void AssertValidateDeviceV8WithBadDataReturns701()
        {
            const string Expected = "701";

            WsMessageHeaderType messageHeader = this.sprintHeader.CreateQDIMessageHeader();

            var wcfEventHelper = new WcfEventHelper();

            this.ValidateDeviceV8(messageHeader, "12345678901234", wcfEventHelper);
            string actual = wcfEventHelper.ProviderErrorCode;
            Assert.Equal(Expected, actual);
        }

        /// <summary>The assert validate plans and options with good data succeeds.</summary>
        [Fact]
        public void AssertValidateDeviceV8WithGood3GDataSucceeds()
        {
            const string Expected = null;

            WsMessageHeaderType messageHeader = this.sprintHeader.CreateQDIMessageHeader();

            var wcfEventHelper = new WcfEventHelper();

            this.ValidateDeviceV8(messageHeader, "268435460203170911", wcfEventHelper);

            var xmlHelper = new XmlHelper { XmlString = wcfEventHelper.ResponseXml };
            string actual = xmlHelper.GetXmlValue("iccId", false);

            Assert.Equal(Expected, actual);
        }

        /// <summary>The assert validate plans and options with good data succeeds.</summary>
        [Fact]
        public void AssertValidateDeviceV8WithGood4GDataSucceeds()
        {
            const string Expected = "89011201000037997408";

            WsMessageHeaderType messageHeader = this.sprintHeader.CreateQDIMessageHeader();

            var wcfEventHelper = new WcfEventHelper();

            this.ValidateDeviceV8(messageHeader, "089792538103608937", wcfEventHelper);

            var xmlHelper = new XmlHelper { XmlString = wcfEventHelper.ResponseXml };
            string actual = xmlHelper.GetXmlValue("iccId", false);

            Assert.Equal(Expected, actual);
        }

        #endregion

        #region Methods

        /// <summary>The validate device v 8.</summary>
        /// <param name="messageHeader">The message header.</param>
        /// <param name="meid">The meid.</param>
        /// <param name="wcfEventHelper">The wcf event helper.</param>
        /// <returns>The <see cref="ValidateDeviceV8ResponseType"/>.</returns>
        private ValidateDeviceV8ResponseType ValidateDeviceV8(WsMessageHeaderType messageHeader, string meid, WcfEventHelper wcfEventHelper)
        {
            // ServicePointManager.ServerCertificateValidationCallback = Callbacks.OnValidationCallback;
            var service = new QueryDeviceInfoPortTypeClient();

            service.Endpoint.Behaviors.Add(new SimpleEndpointBehavior());

            // service.Endpoint.Behaviors.Add(new MessageViewerInspector());

            // service.Endpoint.Contract.Operations.Find("ValidateDeviceV8").Behaviors.Add(new FormatterBehavior());
            // foreach (var operation in service.Endpoint.Contract.Operations)
            // {
            // operation.Behaviors.Add(new Extensions.MyFormatterBehavior());
            // }
            // ExceptionHandler.AsynchronousThreadExceptionHandler = new MyExceptionHandler();
            service.Open();

            var deviceDetailInfoType2 = new DeviceDetailInfoType2 { ItemElementName = ItemChoiceType11.esnMeidDec, Item = meid };

            var deviceInfoType6 = new DeviceInfoType6 { deviceDetailInfo = deviceDetailInfoType2 };

            var validateDeviceV8Info = new ValidateDeviceV8RequestType { brandCode = "XXX", deviceInfo = deviceInfoType6, userId = this.VendorCode };

            try
            {
                ValidateDeviceV8ResponseType validateDeviceResponse = service.ValidateDeviceV8(ref messageHeader, validateDeviceV8Info);
                this.headers = OperationContext.Current.IncomingMessageHeaders;
                wcfEventHelper.DisposeSubscriptions();
                service.Close();
                return validateDeviceResponse;
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

                // service.Close();
                return null;
            }
            catch (CommunicationObjectFaultedException ex)
            {
                this.headers = OperationContext.Current.IncomingMessageHeaders;
                Trace.WriteLine("\nCommunicationObjectFaultedException Message ==> " + ex.Message);
                wcfEventHelper.DisposeSubscriptions();
                service.Close();
                return null;
            }
            catch (FaultException<ProviderErrorType[]> ex)
            {
                this.headers = OperationContext.Current.IncomingMessageHeaders;
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
                service.Close();
                return null;
            }
            catch (FaultException ex)
            {
                this.headers = OperationContext.Current.IncomingMessageHeaders;
                Trace.WriteLine("Fault Exception ==> " + ex.Message);
                MessageFault msgFault = ex.CreateMessageFault();
                var elm = msgFault.GetDetail<ProviderErrorType[]>();
                if (elm[0] != null)
                {
                    Trace.WriteLine("ProviderErrorType ==> " + elm[0].providerErrorText);
                }

                wcfEventHelper.DisposeSubscriptions();
                service.Close();
                return null;
            }
            catch (Exception ex)
            {
                // this.headers = OperationContext.Current.IncomingMessageHeaders;
                Trace.WriteLine(ex.GetType().Name + " ==> " + ex.Message);
                wcfEventHelper.DisposeSubscriptions();

                // service.Close();
                return null;
            }
        }

        #endregion
    }
}