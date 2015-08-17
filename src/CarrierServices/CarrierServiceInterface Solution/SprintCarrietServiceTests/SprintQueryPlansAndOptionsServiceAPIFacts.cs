// --------------------------------------------------------------------------------------------------------------------
// <copyright file="SprintQueryPlansAndOptionsServiceAPIFacts.cs" company="">
//   
// </copyright>
// <summary>
//   The unit test 1.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCarrierServiceTests
{
    using System;
    using System.Configuration;
    using System.Diagnostics;
    using System.Security.Cryptography.X509Certificates;
    using System.ServiceModel;
    using System.ServiceModel.Channels;
    using System.ServiceModel.Security;
    using System.ServiceModel.Security.Tokens;
    using System.Text;

    using SprintCarrierServiceTests.QueryPlansAndOptionsService;

    using Xunit;

    /// <summary>The unit test 1.</summary>
    public class SprintQueryPlansAndOptionsServiceAPIFacts
    {
        #region Fields

        /// <summary>The vendor code.</summary>
        protected readonly string VendorCode = ConfigurationManager.AppSettings["Vendor-Code"];

        /// <summary>The vendor pin.</summary>
        protected readonly string VendorPin = ConfigurationManager.AppSettings["Vendor-PIN"];

        /// <summary>The sprint header.</summary>
        private readonly SprintHeader sprintHeader = new SprintHeader();

        /// <summary>The provider error code.</summary>
        private string providerErrorCode;

        /// <summary>The provider error text.</summary>
        private string providerErrorText;

        #endregion

        #region Public Methods and Operators

        /// <summary>The assert can add certs.</summary>
        [Fact]
        public void AssertCanSelectCerts()
        {
            X509CertificateCollection x509CertCollection = new CertHelper().GetCertsFromFileSystem();
            Assert.True(x509CertCollection.Count > 0);
        }

        /// <summary>The assert validate plans and options with bad data throws fault exception.</summary>
        [Fact]
        public void AssertValidatePlansAndOptionsWithBadDataThrowsFaultException()
        {
            const string Expected = "Client.705";

            WsMessageHeaderType messageHeader = this.sprintHeader.CreateQPOMessageHeader();
            CallingApplicationInfoType2 callingApplicationInfo = this.CreateCallingApplicationInfoType2();

            string myProviderErrorCode;
            string myProviderErrorText;

            this.ValidatePlansAndOptions(messageHeader, callingApplicationInfo, out myProviderErrorCode, out myProviderErrorText);
            string actual = myProviderErrorCode;

            Assert.Equal(Expected, actual);
        }

        /// <summary>The assert validate plans and options with good data succeeds.</summary>
        [Fact]
        public void AssertValidatePlansAndOptionsWithGoodDataSucceeds()
        {
            const string Expected = "Client.705";

            WsMessageHeaderType messageHeader = this.sprintHeader.CreateQPOMessageHeader();
            CallingApplicationInfoType2 callingApplicationInfo = this.CreateCallingApplicationInfoType2();

            string myProviderErrorCode;
            string myProviderErrorText;

            this.ValidatePlansAndOptions(messageHeader, callingApplicationInfo, out myProviderErrorCode, out myProviderErrorText);
            string actual = myProviderErrorCode;

            Assert.Equal(Expected, actual);
        }

        #endregion

        #region Methods

        /// <summary>The create action type.</summary>
        /// <returns>The <see cref="ActionType" />.</returns>
        private ActionType CreateActionType()
        {
            return new ActionType
                       {
                           actionType = ActionTypeActionType.CHECK, 
                           addLtsServiceInd = false, 
                           addLtsServiceIndSpecified = false, 
                           addSubCount = "1", 
                           deviceSwapInd = false, 
                           deviceSwapIndSpecified = false, 
                           duplicateSubInd = false, 
                           validateSubIndSpecified = false, 
                           duplicateSubIndSpecified = false, 
                           existingServiceId = "12345678"
                       };
        }

        /// <summary>The create bad calling application info type 2.</summary>
        /// <returns>The <see cref="CallingApplicationInfoType2" />.</returns>
        private CallingApplicationInfoType2 CreateBadCallingApplicationInfoType2()
        {
            return new CallingApplicationInfoType2
                       {
                           associateId = string.Empty, 
                           brandCode = BrandCodeType2.S, 
                           brandCodeSpecified = true, 
                           orderId = ActivationOrderIdentifierType.ACTIVE_IMEI, 
                           pin = this.VendorPin, 
                           storeId = string.Empty, 
                           vendorCode = this.VendorCode
                       };
        }

        /// <summary>The create calling application info type 2.</summary>
        /// <returns>The <see cref="CallingApplicationInfoType2" />.</returns>
        private CallingApplicationInfoType2 CreateCallingApplicationInfoType2()
        {
            return new CallingApplicationInfoType2
                       {
                           associateId = "0", 
                           brandCode = BrandCodeType2.S, 
                           brandCodeSpecified = true, 
                           orderId = ActivationOrderIdentifierType.ACTIVE_IMEI, 
                           pin = this.VendorPin, 
                           storeId = "0", 
                           vendorCode = this.VendorCode
                       };
        }

        /// <summary>The create device info type.</summary>
        /// <param name="meid">The meid.</param>
        /// <returns>The <see cref="DeviceInfoType3"/>.</returns>
        private DeviceInfoType3 CreateDeviceInfoType(string meid)
        {
            return new DeviceInfoType3 { ItemElementName = ItemChoiceType9.meid, Item = meid };
        }

        /// <summary>The create service agreement info type.</summary>
        /// <returns>The <see cref="ServiceAgreementInfoType" />.</returns>
        private ServiceAgreementInfoType CreateServiceAgreementInfoType()
        {
            return new ServiceAgreementInfoType
                       {
                           deviceInfo = this.CreateDeviceInfoType("132412341234"), 
                           action = this.CreateActionType(), 
                           airaveInfo = new AirraveInfoType(), 
                           banInfo = new BanInfoType2()
                       };
        }

        /// <summary>
        ///     The get custom binding.
        ///     http://stackoverflow.com/questions/12832213/how-to-make-wcf-client-conform-to-specific-ws-security-sign-usernametoken-and
        /// </summary>
        /// <returns>The <see cref="Binding" />.</returns>
        private Binding GetCustomBinding()
        {
            var asbe = new AsymmetricSecurityBindingElement
                           {
                               MessageSecurityVersion = MessageSecurityVersion.WSSecurity11WSTrust13WSSecureConversation13WSSecurityPolicy12, 
                               InitiatorTokenParameters = new X509SecurityTokenParameters { InclusionMode = SecurityTokenInclusionMode.Never }, 
                               RecipientTokenParameters = new X509SecurityTokenParameters { InclusionMode = SecurityTokenInclusionMode.Never }, 
                               MessageProtectionOrder = MessageProtectionOrder.SignBeforeEncrypt, 
                               SecurityHeaderLayout = SecurityHeaderLayout.Strict, 
                               EnableUnsecuredResponse = true, 
                               IncludeTimestamp = false
                           };

            asbe.SetKeyDerivation(false);
            asbe.DefaultAlgorithmSuite = SecurityAlgorithmSuite.Basic128Rsa15;
            asbe.EndpointSupportingTokenParameters.Signed.Add(new UserNameSecurityTokenParameters());
            asbe.EndpointSupportingTokenParameters.Signed.Add(new X509SecurityTokenParameters());

            var myBinding = new CustomBinding();
            myBinding.Elements.Add(asbe);
            myBinding.Elements.Add(new TextMessageEncodingBindingElement(MessageVersion.Soap11, Encoding.UTF8));

            var httpsBindingElement = new HttpsTransportBindingElement { RequireClientCertificate = true };
            myBinding.Elements.Add(httpsBindingElement);

            return myBinding;
        }

        /// <summary>The validate plans and options.</summary>
        /// <param name="messageHeader">The message header.</param>
        /// <param name="callingApplicationInfo">The calling application info.</param>
        /// <param name="myProviderErrorCode">The provider error code.</param>
        /// <param name="myProviderErrorText">The provider error text.</param>
        /// <returns>The <see cref="bool"/>.</returns>
        private bool ValidatePlansAndOptions(WsMessageHeaderType messageHeader, CallingApplicationInfoType2 callingApplicationInfo, out string myProviderErrorCode, out string myProviderErrorText)
        {
            myProviderErrorCode = string.Empty;
            myProviderErrorText = string.Empty;

            ServiceAgreementInfoType serviceAgreementInfo = this.CreateServiceAgreementInfoType();
            SuggestionGroupInfoType[] suggestionGroupList;
            SecondaryBundleSubPricePlanChangeRequiredInfo[] secBundleSubPricePlanChangeRequiredList;
            PricePlanInfoType3 pricePlanInfo, expiredPricePlanInfo;
            string ltsRemainingSubscribers;
            LegacyPlanInfoType[] legacyPlanList;
            bool familySubscribersPricePlanChangeRequiredInd, dataSocInd, messagingSocInd, voiceControlValidInd;
            ResourceInfoType[] expiredResourceList, resourceList;
            ChangedSocInfoType[] changedSocList;
            AddOnSocInfoResponseType[] addOnSocList, expiredAddOnSocList;
            ValidationErrorInfoType validationErrorInfo;

            var wcfEventHelper = new WcfEventHelper();

            var service = new QueryPlansAndOptionsPortTypeClient();
            service.Endpoint.Behaviors.Add(new SimpleEndpointBehavior());

            service.Open();

            bool x = false;
            try
            {
                x = service.ValidatePlansAndOptions(
                    ref messageHeader, 
                    callingApplicationInfo, 
                    serviceAgreementInfo, 
                    out familySubscribersPricePlanChangeRequiredInd, 
                    out secBundleSubPricePlanChangeRequiredList, 
                    out ltsRemainingSubscribers, 
                    out pricePlanInfo, 
                    out addOnSocList, 
                    out expiredPricePlanInfo, 
                    out expiredAddOnSocList, 
                    out expiredResourceList, 
                    out changedSocList, 
                    out legacyPlanList, 
                    out resourceList, 
                    out suggestionGroupList, 
                    out dataSocInd, 
                    out messagingSocInd, 
                    out validationErrorInfo, 
                    out voiceControlValidInd);
            }
            catch (MessageSecurityException ex)
            {
                Trace.WriteLine("MessageSecurityException Exception ==> " + ex.Message);
                wcfEventHelper.DisposeSubscriptions();

                return x;
            }
            catch (FaultException<ProviderErrorType[]> ex)
            {
                Trace.WriteLine("FaultException<ProviderErrorType[]> Message ==> " + ex.Message);
                if (ex.Detail.Length > 0)
                {
                    Trace.WriteLine("FaultException<ProviderErrorType[]> errorProgramId ==> " + ex.Detail[0].errorProgramId);
                    Trace.WriteLine("FaultException<ProviderErrorType[]> errorSystem ==> " + ex.Detail[0].errorSystem);
                    Trace.WriteLine("FaultException<ProviderErrorType[]> errorTransactionId ==> " + ex.Detail[0].errorTransactionId);
                    Trace.WriteLine("FaultException<ProviderErrorType[]> fieldInError ==> " + ex.Detail[0].fieldInError);
                    Trace.WriteLine("FaultException<ProviderErrorType[]> providerErrorCode==> " + ex.Detail[0].providerErrorCode);
                    Trace.WriteLine("FaultException<ProviderErrorType[]> providerErrorText ==> " + ex.Detail[0].providerErrorText);
                }

                myProviderErrorCode = wcfEventHelper.ProviderErrorCode;
                myProviderErrorText = wcfEventHelper.ProviderErrorText;
                wcfEventHelper.DisposeSubscriptions();
                return x;
            }
            catch (FaultException ex)
            {
                Trace.WriteLine("Fault Exception ==> " + ex.Message);
                MessageFault msgFault = ex.CreateMessageFault();
                var elm = msgFault.GetDetail<ProviderErrorType[]>();
                if (elm[0] != null)
                {
                    Trace.WriteLine("ProviderErrorType ==> " + elm[0].providerErrorText);
                }

                wcfEventHelper.DisposeSubscriptions();
                return x;
            }
            catch (Exception ex)
            {
                Trace.WriteLine("\n" + ex.GetType().Name + " ==> " + ex.Message + "\n" + ex.StackTrace);
                wcfEventHelper.DisposeSubscriptions();
                return x;
            }

            wcfEventHelper.DisposeSubscriptions();
            return x;
        }

        #endregion
    }
}