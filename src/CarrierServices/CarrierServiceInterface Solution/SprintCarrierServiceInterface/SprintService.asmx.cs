// --------------------------------------------------------------------------------------------------------------------
// <copyright file="SprintService.asmx.cs" company="">
//   
// </copyright>
// <summary>
//   The sprint service.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCSI
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Web.Services;

    using SprintCSI.ServiceImplementation;
    using SprintCSI.ServiceImplementation.DTO;
    using SprintCSI.Utils;

    using WirelessAdvocates;
    using WirelessAdvocates.Enum;
    using WirelessAdvocates.Extensions;
    using WirelessAdvocates.Logger;
    using WirelessAdvocates.ServiceResponse;

    using REQUEST = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;

    /// <summary>The sprint service.</summary>
    [WebService(Namespace = "http://membershipwireless.com/services/sprint/v1/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [ToolboxItem(false)]
    public class SprintService : WebService
    {
        #region Constants

        /// <summary>The carrier name.</summary>
        private const string CarrierName = "Sprint";

        #endregion

        #region Fields

        /// <summary>
        ///     The customer inquiry request.
        ///     This inquiry is made Following both Activate calls to create 'after image' log entries
        /// </summary>
        private CustomerInquiryRequest customerInquiryRequest;

        #endregion

        #region Public Methods and Operators

        /// <summary>The activate upgrade.</summary>
        /// <param name="orderNumber">The order number.</param>
        /// <param name="mdn">The mdn.</param>
        /// <param name="secretPin">The secret pin.</param>
        /// <param name="answer">The answer.</param>
        /// <param name="ssn">The ssn.</param>
        /// <param name="customerType">The customer type.</param>
        /// <param name="orderType">The order type.</param>
        /// <param name="handsetCount">The handset count.</param>
        /// <param name="wirelessLineId">The wireless line id.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="ActivationUpgradeResponse"/>.</returns>
        [WebMethod]
        public ActivationUpgradeResponse ActivateUpgrade(
            string orderNumber, 
            string mdn, 
            string secretPin, 
            string answer, 
            string ssn, 
            REQUEST.CustomerType customerType, 
            REQUEST.OrderType orderType, 
            int handsetCount, 
            int wirelessLineId, 
            string referenceNumber)
        {
            SprintCustomerInquiryResponse sprintCustomerInquiryResponse;
            ActivationUpgradeResponse activateUpgradeFailed;

            var paramString =
                string.Format(
                    "orderNumber: {0} mdn: {1} secretPin: {2} answer: {3} ssn:{4} customerType: {5} orderType: {6} handsetCount: {7} wirelessLineId: {8} referenceNumber: {9}", 
                    orderNumber, 
                    mdn, 
                    secretPin, 
                    answer, 
                    ssn, 
                    customerType, 
                    orderType, 
                    handsetCount, 
                    wirelessLineId, 
                    referenceNumber);

            new Log().LogInput(paramString, CarrierName, "ActivationUpgrade", referenceNumber);

            // Prevent calling credit check without correct parameters
            if (string.IsNullOrEmpty(secretPin) && string.IsNullOrEmpty(answer) & string.IsNullOrEmpty(ssn))
            {
                return new ActivationUpgradeResponse
                           {
                               PrimaryErrorMessage = string.Empty, 
                               PrimaryErrorMessageLong = "No credentials available for credit check", 
                               PrimaryErrorMessageBrief = "Unable to Process", 
                               ErrorCode = (int)ServiceResponseCode.Success, 
                               ErrorCodeEnum = ServiceResponseCode.Success, 
                               ServiceResponseSubCode = (int)ServiceResponseSubCode.ACT_FAIL, 
                               ServiceResponseSubCodeEnum = ServiceResponseSubCode.ACT_FAIL, 
                               ServiceResponseSubCodeDescription = ServiceResponseSubCode.ACT_FAIL.GetAttributeOfType<DescriptionAttribute>().Description, 
                               SprintErrorCode = 0, 
                               SprintErrorCodeName = string.Empty, 
                               SprintResponseMessage = string.Empty, 
                               SprintResponseAdvice = string.Empty, 
                               ActivationStatus = ActivationStatus.Failure, 
                           };
            }

            if (this.DoCustomerLookupByMDNFails(mdn, secretPin, answer, ssn, referenceNumber, out sprintCustomerInquiryResponse, out activateUpgradeFailed))
            {
                // Log output of web service
                new Log().LogOutput(new Utility().SerializeXML(activateUpgradeFailed), CarrierName, this.GetType().Name, referenceNumber);
                return activateUpgradeFailed;
            }

            ActivationUpgradeRequest activationUpgradeRequest;

            if (this.MakeActivationUpgradeRequestFails(
                sprintCustomerInquiryResponse.TransactionOrderId, 
                orderNumber, 
                wirelessLineId, 
                REQUEST.OrderType.UPGRADE, 
                out activationUpgradeRequest, 
                out activateUpgradeFailed))
            {
                return activateUpgradeFailed;
            }

            ActivationUpgradeResponse upgradeResponse;

            if (this.DoActivationUpgradeFails(referenceNumber, activationUpgradeRequest, out upgradeResponse, out activateUpgradeFailed))
            {
                return activateUpgradeFailed;
            }

            if (this.DoActivateReservedDeviceFails(referenceNumber, upgradeResponse, out activateUpgradeFailed))
            {
                return activateUpgradeFailed;
            }

            // this is a throw-away variable which exists only to deliver a new TransactionOrderId for REPLACE from CreditCheck
            // Also we want to log the Customer Inquiry Response  from the initial ActivationUpgrade in [CarrierInterfaceLog] 
            SprintCustomerInquiryResponse throwAwayCustomerInquiryResponse;

            if (this.DoCustomerLookupByMDNFails(mdn, secretPin, answer, ssn, referenceNumber, out throwAwayCustomerInquiryResponse, out activateUpgradeFailed))
            {
                // Log output of web service
                new Log().LogOutput(new Utility().SerializeXML(activateUpgradeFailed), CarrierName, this.GetType().Name, referenceNumber);
                return activateUpgradeFailed;
            }

            ActivationUpgradeResponse replaceResponse;
            ActivationUpgradeResponse activateReplaceFailed;

            var replaceRequest = new ActivationReplaceRequest
                                     {
                                         TransactionOrderId = throwAwayCustomerInquiryResponse.TransactionOrderId, 
                                         ActivationRequestXml = upgradeResponse.RequestXml, 
                                         SprintCustomerInquiryResponseXml = sprintCustomerInquiryResponse.ResponseXml, 
                                         ServiceAgreement = 0
                                     };

            if (this.DoActivationReplaceFails(referenceNumber, replaceRequest, out replaceResponse, out activateReplaceFailed))
            {
                return activateReplaceFailed;
            }

            replaceResponse.PrimaryErrorMessageBrief = replaceResponse.ActivationResult;

            return replaceResponse;
        }

        /// <summary>The check credit.</summary>
        /// <param name="billingName">The billing name.</param>
        /// <param name="serviceZipCode">The service zip code.</param>
        /// <param name="contactInfo">The contact info.</param>
        /// <param name="billingContactCredentials">The billing contact credentials.</param>
        /// <param name="numberOfLines">The number of lines.</param>
        /// <param name="question">The question.</param>
        /// <param name="answer">The answer.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="WirelessAdvocates.ServiceResponse.CreditCheckResponse"/>.</returns>
        [WebMethod]
        public SprintCreditCheckResponse CheckCredit(
            Name billingName, 
            string serviceZipCode, 
            Contact contactInfo, 
            PersonalCredentials billingContactCredentials, 
            int numberOfLines, 
            string question, 
            string answer, 
            string referenceNumber)
        {
            var request = new CheckCreditRequest
                              {
                                  BillingName = billingName, 
                                  ServiceZipCode = serviceZipCode, 
                                  ContactInfo = contactInfo, 
                                  BillingContactCredentials = billingContactCredentials, 
                                  NumberOfLines = numberOfLines, 
                                  QuestionCode = question, 
                                  QuestionAnswer = answer, 
                                  ReferenceNumber = referenceNumber
                              };
            return new CheckCredit().Execute(request, referenceNumber);
        }

        /// <summary>The check credit existing account.</summary>
        /// <param name="mdn">The mdn.</param>
        /// <param name="accountNumber">The account number.</param>
        /// <param name="secretPin">The secret pin.</param>
        /// <param name="answer">The answer.</param>
        /// <param name="ssn">The ssn.</param>
        /// <param name="customerType">The customer type.</param>
        /// <param name="orderType">The order type.</param>
        /// <param name="handsetCount">The handset count.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="object"/>.</returns>
        [WebMethod]
        public SprintCheckCreditExistingAccountResponse CheckCreditExistingAccount(
            string mdn, 
            string accountNumber, 
            string secretPin, 
            string answer, 
            string ssn, 
            REQUEST.CustomerType customerType, 
            REQUEST.OrderType orderType, 
            int handsetCount, 
            string referenceNumber)
        {
            var request = new CheckCreditExistingAccountRequest
                              {
                                  AccountNumber = accountNumber, 
                                  SecretPin = secretPin, 
                                  CustomerType = customerType, 
                                  HandsetCount = (byte)handsetCount, 
                                  ReferenceNumber = referenceNumber, 
                                  OrderType = orderType, 
                                  QuestionAnswer = answer, 
                                  SSN = ssn
                              };

            return new CheckCreditExistingAccount().Execute(request, referenceNumber);
        }

        /// <summary>The customer lookup by mdn.</summary>
        /// <param name="mdn">The mdn.</param>
        /// <param name="secretKey">The secret key.</param>
        /// <param name="ssn">The ssn.</param>
        /// <param name="questionAnswer">The question answer.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <param name="orderType">The order type</param>
        /// <returns>The <see cref="CustomerInquiryResponse"/>.</returns>
        [WebMethod]
        public SprintCustomerInquiryResponse CustomerLookupByMDN(string mdn, string secretKey, string ssn, string questionAnswer, string referenceNumber, REQUEST.OrderType orderType)
        {
            this.customerInquiryRequest = new CustomerInquiryRequest { Mdn = mdn, SecretKey = secretKey, ReferenceNo = referenceNumber, QuestionAnswer = questionAnswer, Ssn = ssn, };

            var customerInquiryResponse = (new CustomerLookupByMdn()).Execute(this.customerInquiryRequest, referenceNumber);

            if (customerInquiryResponse == null || customerInquiryResponse.ErrorCode != 0)
            {
                return customerInquiryResponse;
            }

            switch (customerInquiryResponse.ServiceResponseSubCode)
            {
                case (int)ServiceResponseSubCode.CL_INVALID_PIN:
                case (int)ServiceResponseSubCode.CL_ACCOUNT_LOCKED:
                case (int)ServiceResponseSubCode.ClCustomerNotFound:
                    return customerInquiryResponse;
                case (int)ServiceResponseSubCode.CL_ACCOUNT_NOPIN:

                    // rerun the request because no pin needs to be supplied.
                    customerInquiryResponse = this.CustomerLookupByMDN(mdn, string.Empty, string.Empty, string.Empty, referenceNumber, orderType);
                    break;
            }

            // total lines approved & address data need to be retrieved from credit check web service call
            var checkCreditExistingAccountRequest = new CheckCreditExistingAccountRequest
                                                        {
                                                            AccountNumber = customerInquiryResponse.CustomerAccountNumber, 
                                                            SecretPin = secretKey, 
                                                            SSN = ssn, 
                                                            Mdn = mdn, 
                                                            QuestionAnswer = questionAnswer, 
                                                            CustomerType = REQUEST.CustomerType.INDIVIDUAL, 
                                                            HandsetCount = 1, 
                                                            ReferenceNumber = referenceNumber, 
                                                            OrderType = orderType
                                                        };

            var checkCreditExistingAccountResult = (new CheckCreditExistingAccount()).Execute(checkCreditExistingAccountRequest, referenceNumber);

            if (checkCreditExistingAccountResult == null || checkCreditExistingAccountResult.ErrorCodeEnum != ServiceResponseCode.Success)
            {
                if (checkCreditExistingAccountResult != null)
                {
                    customerInquiryResponse.PrimaryErrorMessage = checkCreditExistingAccountResult.PrimaryErrorMessage;
                    customerInquiryResponse.PrimaryErrorMessageLong = checkCreditExistingAccountResult.PrimaryErrorMessageLong;
                    customerInquiryResponse.ServiceResponseSubCode = checkCreditExistingAccountResult.ServiceResponseSubCode;
                    customerInquiryResponse.ServiceResponseSubCodeEnum = (ServiceResponseSubCode)checkCreditExistingAccountResult.ServiceResponseSubCode;
                    customerInquiryResponse.ServiceResponseSubCodeDescription =
                        ((ServiceResponseSubCode)checkCreditExistingAccountResult.ServiceResponseSubCode).GetAttributeOfType<DescriptionAttribute>().Description;
                    customerInquiryResponse.ErrorCode = checkCreditExistingAccountResult.ErrorCode;
                    customerInquiryResponse.ErrorCodeEnum = checkCreditExistingAccountResult.ErrorCodeEnum;
                    customerInquiryResponse.ServiceResponseSubCodeEnum = checkCreditExistingAccountResult.ServiceResponseSubCodeEnum;
                    customerInquiryResponse.SprintErrorCode = checkCreditExistingAccountResult.SprintErrorCode;
                    customerInquiryResponse.SprintErrorCodeName = checkCreditExistingAccountResult.SprintErrorCodeName;
                    customerInquiryResponse.SprintResponseMessage = checkCreditExistingAccountResult.SprintResponseMessage;
                    customerInquiryResponse.SprintResponseAdvice = checkCreditExistingAccountResult.SprintResponseAdvice;
                }

                customerInquiryResponse.ServiceResponseSubCode = (int)ServiceResponseSubCode.ClCustomerNotFound;
                return customerInquiryResponse;
            }

            // populate the LinesApproved & LinesAvailable fields
            customerInquiryResponse.LinesApproved = customerInquiryResponse.LinesActive + checkCreditExistingAccountResult.NumberOfLines;
            customerInquiryResponse.LinesAvailable = checkCreditExistingAccountResult.NumberOfLines;

            // populate address for every subscriber
            foreach (var subscriber in customerInquiryResponse.CustomerInquiryLines)
            {
                subscriber.BillingAddress = checkCreditExistingAccountResult.BillingAddress;
            }

            customerInquiryResponse.TransactionOrderId = checkCreditExistingAccountResult.TransactionOrderId;

            return customerInquiryResponse;
        }

        /// <summary>The npa lookup by zip.</summary>
        /// <param name="zipCode">The zip code.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="NpaResponse"/>.</returns>
        [WebMethod]
        public NpaResponse NpaLookupByZip(string zipCode, string referenceNumber)
        {
            return new NpaLookupByZip().Execute(zipCode, referenceNumber);
        }

        /// <summary>The npa nxx.</summary>
        /// <param name="zipCode">The zip code.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="NpaResponse"/>.</returns>
        [WebMethod]
        public SprintNpaResponse NpaNxx(string zipCode, string referenceNumber)
        {
            return new NpaNxx().Execute(new NpaRequest { Zip = zipCode, ReferenceNumber = referenceNumber }, referenceNumber);
        }

        /// <summary>The ping.</summary>
        /// <returns>The <see cref="QuerySystemStatusResponse" />.</returns>
        [WebMethod]
        public QuerySystemStatusResponse Ping()
        {
            var querySystemStatusResponse = new QuerySystemStatus().Execute(new QuerySystemStatusRequest());
            return querySystemStatusResponse;
        }

        /// <summary>The resend pin.</summary>
        /// <param name="Mdn">The mdn.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="DTOAuthenticationResponse"/>.</returns>
        [WebMethod]
        public DTOAuthenticationResponse ResendPin(string Mdn, string referenceNumber)
        {
            return new AuthenticationResend().Execute(new DTOAuthenticationRequest { MDN = Mdn, ReferenceNo = referenceNumber }, referenceNumber);
        }

        /// <summary>The submit order.</summary>
        /// <param name="orderNumber">The order number.</param>
        /// <returns>The <see cref="OrderResponse"/>.</returns>
        public OrderResponse SubmitOrder(string orderNumber)
        {
            var request = new ActivationRequest(short.Parse(orderNumber));

            return new Activation().Execute(request, request.CheckoutReferenceNumber);
        }

        /// <summary>The update order.</summary>
        /// <param name="xmlResponse">The xml response.</param>
        /// <returns>The <see cref="OrderResponse"/>.</returns>
        /// <exception cref="NotImplementedException"></exception>
        /// [WebMethod]
        public OrderResponse UpdateOrder(string xmlResponse)
        {
            throw new NotImplementedException("Service UpdateOrder");
        }

        /// <summary>The upgrade eligible.</summary>
        /// <param name="zipCode">The zip code.</param>
        /// <param name="mdn">The mdn.</param>
        /// <param name="secretKey">The secret key.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="bool"/>.</returns>
        /// <exception cref="NotImplementedException"></exception>
        /// [WebMethod]
        public bool UpgradeEligible(string zipCode, string mdn, string secretKey, string referenceNumber)
        {
            throw new NotImplementedException("UpgradeEligible");
        }

        /// <summary>The validate address.</summary>
        /// <param name="addressToValidate">The address to validate.</param>
        /// <param name="addressType">The address type.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="AddressValidationResponse"/>.</returns>
        [WebMethod]
        public SprintAddressValidationResponse ValidateAddress(Address addressToValidate, Address.AddressEnum addressType, string referenceNumber)
        {
            // var address = SessionHelper.Instance.AddAddress(addressToValidate, addressType, referenceNumber);
            //var response = new SprintAddressValidationResponse
            //{
            //    ErrorCode = (int)ServiceResponseCode.Success,
            //    ValidAddress = address
            //};

            //return response;

            // NOTE [pcrawford,20130918] To be fully implemented
            return new ValidateAddress().Execute(new ValidateAddressRequest { Address = addressToValidate, AddressType = addressType, ReferenceNumber = referenceNumber });
        }

        /// <summary>The validate device.</summary>
        /// <param name="validateDeviceRequest">The validate device request.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="SprintDeviceValidationResponse"/>.</returns>
        /// [WebMethod]
        public SprintDeviceValidationResponse ValidateDevice(ValidateDeviceRequest validateDeviceRequest, string referenceNumber)
        {
            return new ValidateDevice().Execute(validateDeviceRequest, referenceNumber);
        }

        /// <summary>The validate plans and options.</summary>
        /// <param name="validatePlansAndOptionsRequest">The validate plans and options request.</param>
        /// <returns>The <see cref="SprintDeviceValidationResponse"/>.</returns>
        [WebMethod]
        public SprintPlansAndOptionsValidationResponse ValidatePlansAndOptions(ValidatePlansAndOptionsRequest validatePlansAndOptionsRequest)
        {
            // var response = new AddressValidationResponse
            // {
            // ErrorCode = (int)ServiceResponseCode.Success,
            // ValidAddress = address
            // };

            // return response;

            // NOTE [pcrawford,20130918] This web service has always been stubbed out
            return new ValidatePlansAndOptions().Execute(validatePlansAndOptionsRequest);
        }

        /// <summary>The validate port in.</summary>
        /// <param name="mdnList">The mdn list.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="ValidatePortInResponse"/>.</returns>
        [WebMethod]
        public SprintValidatePortInResponse ValidatePortIn(List<MDNSet> mdnList, string referenceNumber)
        {
            return new PortEligibility().Execute(new PortEligibilityRequest { MDNList = mdnList, ReferenceNumber = referenceNumber }, referenceNumber);
        }

        #endregion

        #region Methods

        /// <summary>The activate now fails.</summary>
        /// <param name="referenceNumber">The reference number.</param>
        /// <param name="upgradeResponse">The upgrade response.</param>
        /// <param name="activateUpgradeFailed">The activate upgrade.</param>
        /// <returns>The <see cref="bool"/>.</returns>
        private bool DoActivateNowFails(string referenceNumber, ActivationUpgradeResponse upgradeResponse, out ActivationUpgradeResponse activateUpgradeFailed)
        {
            try
            {
                var activateNowRequest = new ActivateNowRequest { Meid = upgradeResponse.Meid, SprintOrderId = upgradeResponse.SprintOrderId };

                var nowResponse = new ActivateNow().Execute(activateNowRequest, referenceNumber);
            }
            catch (Exception ex)
            {
                {
                    activateUpgradeFailed = new ActivationUpgradeResponse
                                                {
                                                    PrimaryErrorMessage = ex.Message, 
                                                    PrimaryErrorMessageLong = ex.Message, 
                                                    ErrorCode = (int)ServiceResponseCode.Success, 
                                                    ErrorCodeEnum = ServiceResponseCode.Success, 
                                                    ServiceResponseSubCode = (int)ServiceResponseSubCode.ACT_FAIL, 
                                                    ServiceResponseSubCodeEnum = ServiceResponseSubCode.ACT_FAIL, 
                                                    ServiceResponseSubCodeDescription = ServiceResponseSubCode.ACT_FAIL.GetAttributeOfType<DescriptionAttribute>().Description, 
                                                    SprintErrorCode = 0, 
                                                    SprintErrorCodeName = string.Empty, 
                                                    SprintResponseMessage = string.Empty, 
                                                    SprintResponseAdvice = string.Empty, 
                                                    ActivationStatus = ActivationStatus.PartialSuccess, 
                                                };
                    return true;
                }
            }

            activateUpgradeFailed = null;
            return false;
        }

        /// <summary>The do activate reserved device fails.</summary>
        /// <param name="referenceNumber">The reference number.</param>
        /// <param name="upgradeResponse">The upgrade response.</param>
        /// <param name="activateUpgradeFailed">The activate upgrade failed.</param>
        /// <returns>The <see cref="bool"/>.</returns>
        private bool DoActivateReservedDeviceFails(string referenceNumber, ActivationUpgradeResponse upgradeResponse, out ActivationUpgradeResponse activateUpgradeFailed)
        {
            try
            {
                var activateReservedDeviceRequest = new ActivateReservedDeviceRequest { Mdn = upgradeResponse.Mdn, SprintOrderId = upgradeResponse.SprintOrderId };

                var response = new ActivateReservedDevice().Execute(activateReservedDeviceRequest, referenceNumber);
            }
            catch (Exception ex)
            {
                {
                    activateUpgradeFailed = new ActivationUpgradeResponse
                                                {
                                                    PrimaryErrorMessage = ex.Message, 
                                                    PrimaryErrorMessageLong = ex.Message, 
                                                    ErrorCode = (int)ServiceResponseCode.Success, 
                                                    ErrorCodeEnum = ServiceResponseCode.Success, 
                                                    ServiceResponseSubCode = (int)ServiceResponseSubCode.ACT_FAIL, 
                                                    ServiceResponseSubCodeEnum = ServiceResponseSubCode.ACT_FAIL, 
                                                    ServiceResponseSubCodeDescription = ServiceResponseSubCode.ACT_FAIL.GetAttributeOfType<DescriptionAttribute>().Description, 
                                                    SprintErrorCode = 0, 
                                                    SprintErrorCodeName = string.Empty, 
                                                    SprintResponseMessage = string.Empty, 
                                                    SprintResponseAdvice = string.Empty, 
                                                    ActivationStatus = ActivationStatus.PartialSuccess, 
                                                };
                    return true;
                }
            }

            activateUpgradeFailed = null;
            return false;
        }

        /// <summary>The do activation replace fails.</summary>
        /// <param name="referenceNumber">The reference number.</param>
        /// <param name="activationReplaceRequest">The activation replace request.</param>
        /// <param name="upgradeResponse">The activation replace response.</param>
        /// <param name="upgradeFailed">The activation replace failed.</param>
        /// <returns>The <see cref="bool"/>.</returns>
        private bool DoActivationReplaceFails(
            string referenceNumber, 
            ActivationReplaceRequest activationReplaceRequest, 
            out ActivationUpgradeResponse upgradeResponse, 
            out ActivationUpgradeResponse upgradeFailed)
        {
            upgradeResponse = null;
            upgradeFailed = null;

            ActivationReplaceResponse replaceResponse = null;

            try
            {
                replaceResponse = new ActivationReplace().Execute(activationReplaceRequest, referenceNumber);
                if (replaceResponse.ActivationStatus != ActivationStatus.Success)
                {
                    replaceResponse.ActivationStatus = ActivationStatus.Failure;
                    replaceResponse.ErrorCodeEnum = ServiceResponseCode.Success;
                    replaceResponse.ErrorCode = (int)replaceResponse.ErrorCodeEnum;
                    {
                        upgradeFailed = new ActivationUpgradeResponse(replaceResponse);
                        return true;
                    }
                }
            }
            catch (Exception ex)
            {
                if (replaceResponse != null)
                {
                    replaceResponse.ActivationStatus = ActivationStatus.Failure;
                    {
                        upgradeFailed = new ActivationUpgradeResponse(replaceResponse);
                        return true;
                    }
                }
                {
                    upgradeFailed = new ActivationUpgradeResponse
                                        {
                                            PrimaryErrorMessageLong = ex.Message, 
                                            ErrorCode = (int)ServiceResponseCode.Success, 
                                            ErrorCodeEnum = ServiceResponseCode.Success, 
                                            ServiceResponseSubCode = (int)ServiceResponseSubCode.ACT_FAIL, 
                                            ServiceResponseSubCodeEnum = ServiceResponseSubCode.ACT_FAIL, 
                                            ServiceResponseSubCodeDescription = ServiceResponseSubCode.ACT_FAIL.GetAttributeOfType<DescriptionAttribute>().Description, 
                                            SprintErrorCode = 0, 
                                            SprintErrorCodeName = string.Empty, 
                                            SprintResponseMessage = string.Empty, 
                                            SprintResponseAdvice = string.Empty, 
                                            ActivationStatus = ActivationStatus.Failure, 
                                        };
                    return true;
                }
            }

            upgradeResponse = new ActivationUpgradeResponse(replaceResponse);
            return false;
        }

        /// <summary>The do activation upgrade fails.</summary>
        /// <param name="referenceNumber">The reference number.</param>
        /// <param name="activationUpgradeRequest">The activation upgrade request.</param>
        /// <param name="upgradeResponse">The upgrade response.</param>
        /// <param name="activateUpgradeFailed">The activate upgrade failed.</param>
        /// <returns>The <see cref="bool"/>.</returns>
        private bool DoActivationUpgradeFails(
            string referenceNumber, 
            ActivationUpgradeRequest activationUpgradeRequest, 
            out ActivationUpgradeResponse upgradeResponse, 
            out ActivationUpgradeResponse activateUpgradeFailed)
        {
            upgradeResponse = null;
            try
            {
                upgradeResponse = new ActivationUpgrade().Execute(activationUpgradeRequest, referenceNumber);
                if (upgradeResponse.ActivationStatus != ActivationStatus.Success)
                {
                    upgradeResponse.ActivationStatus = ActivationStatus.Failure;
                    upgradeResponse.ErrorCodeEnum = ServiceResponseCode.Success;
                    upgradeResponse.ErrorCode = (int)upgradeResponse.ErrorCodeEnum;
                    {
                        activateUpgradeFailed = upgradeResponse;
                        return true;
                    }
                }
            }
            catch (Exception ex)
            {
                if (upgradeResponse != null)
                {
                    upgradeResponse.ActivationStatus = ActivationStatus.Failure;
                    {
                        activateUpgradeFailed = upgradeResponse;
                        return true;
                    }
                }
                {
                    activateUpgradeFailed = new ActivationUpgradeResponse
                                                {
                                                    PrimaryErrorMessageLong = ex.Message, 
                                                    ErrorCode = (int)ServiceResponseCode.Success, 
                                                    ErrorCodeEnum = ServiceResponseCode.Success, 
                                                    ServiceResponseSubCode = (int)ServiceResponseSubCode.ACT_FAIL, 
                                                    ServiceResponseSubCodeEnum = ServiceResponseSubCode.ACT_FAIL, 
                                                    ServiceResponseSubCodeDescription = ServiceResponseSubCode.ACT_FAIL.GetAttributeOfType<DescriptionAttribute>().Description, 
                                                    SprintErrorCode = 0, 
                                                    SprintErrorCodeName = string.Empty, 
                                                    SprintResponseMessage = string.Empty, 
                                                    SprintResponseAdvice = string.Empty, 
                                                    ActivationStatus = ActivationStatus.Failure, 
                                                };
                    return true;
                }
            }

            activateUpgradeFailed = null;
            return false;
        }

        /// <summary>The do customer lookup by mdn fails.</summary>
        /// <param name="mdn">The mdn.</param>
        /// <param name="secretPin">The secret pin.</param>
        /// <param name="answer">The answer.</param>
        /// <param name="ssn">The ssn.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <param name="cir">The cir.</param>
        /// <param name="activateUpgradeFailure">The activate upgrade failure.</param>
        /// <returns>The <see cref="bool"/>.</returns>
        private bool DoCustomerLookupByMDNFails(
            string mdn, 
            string secretPin, 
            string answer, 
            string ssn, 
            string referenceNumber, 
            out SprintCustomerInquiryResponse cir, 
            out ActivationUpgradeResponse activateUpgradeFailure)
        {
            cir = this.CustomerLookupByMDN(mdn, secretPin, ssn, answer, referenceNumber, REQUEST.OrderType.UPGRADE);

            if (cir.ServiceResponseSubCode != (int)ServiceResponseSubCode.CL_CUSTOMER_FOUND)
            {
                {
                    activateUpgradeFailure = new ActivationUpgradeResponse
                                                 {
                                                     PrimaryErrorMessage = cir.PrimaryErrorMessage, 
                                                     PrimaryErrorMessageLong = cir.PrimaryErrorMessage, 
                                                     ErrorCode = cir.ErrorCode, 
                                                     ErrorCodeEnum = cir.ErrorCodeEnum, 
                                                     ServiceResponseSubCode = cir.ServiceResponseSubCode, 
                                                     ServiceResponseSubCodeEnum = cir.ServiceResponseSubCodeEnum, 
                                                     ServiceResponseSubCodeDescription = cir.ServiceResponseSubCodeDescription, 
                                                     SprintErrorCode = cir.SprintErrorCode, 
                                                     SprintErrorCodeName = cir.SprintErrorCodeName, 
                                                     SprintResponseMessage = cir.SprintResponseMessage, 
                                                     SprintResponseAdvice = cir.SprintResponseAdvice, 
                                                     ActivationStatus = ActivationStatus.Error
                                                 };
                    return true;
                }
            }

            activateUpgradeFailure = new ActivationUpgradeResponse();
            return false;
        }

        /// <summary>The do validate device.</summary>
        /// <param name="meid">The meid.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="string"/>.</returns>
        /// <exception cref="ServiceException"></exception>
        private string DoValidateDevice(string meid, string referenceNumber)
        {
            var validateDeviceRequest = new ValidateDeviceRequest { Meid = meid };

            var validateDeviceResponse = new ValidateDevice().Execute(validateDeviceRequest, referenceNumber, false);

            if (validateDeviceResponse.ServiceResponseSubCodeEnum == ServiceResponseSubCode.ACT_UNKNOWN)
            {
                return validateDeviceResponse.IccId;
            }

            throw new ServiceException(validateDeviceResponse.PrimaryErrorMessageLong)
                      {
                          ErrorCode = validateDeviceResponse.ErrorCodeEnum, 
                          ServiceResponseSubCode = validateDeviceResponse.ServiceResponseSubCodeEnum, 
                      };
        }

        /// <summary>The make activation upgrade request fails.</summary>
        /// <param name="transactionOrderId">The transaction Order Id.</param>
        /// <param name="orderNumber">The order number.</param>
        /// <param name="wirelessLineId">The wireless line id.</param>
        /// <param name="upgradeRequest">The upgrade request.</param>
        /// <param name="activationUpgradeRequest">The activation upgrade request.</param>
        /// <param name="activateUpgrade">The activate upgrade.</param>
        /// <returns>The <see cref="bool"/>.</returns>
        private bool MakeActivationUpgradeRequestFails(
            string transactionOrderId, 
            string orderNumber, 
            int wirelessLineId, 
            REQUEST.OrderType upgradeRequest, 
            out ActivationUpgradeRequest activationUpgradeRequest, 
            out ActivationUpgradeResponse activateUpgrade)
        {
            try
            {
                activationUpgradeRequest = new ActivationUpgradeRequest(orderNumber, wirelessLineId, upgradeRequest, transactionOrderId);
            }
            catch (Exception ex)
            {
                {
                    activateUpgrade = new ActivationUpgradeResponse
                                          {
                                              PrimaryErrorMessage = ex.Message, 
                                              PrimaryErrorMessageLong = ex.Message, 
                                              ErrorCode = (int)ServiceResponseCode.Success, 
                                              ErrorCodeEnum = ServiceResponseCode.Success, 
                                              ServiceResponseSubCode = (int)ServiceResponseSubCode.ACT_FAIL, 
                                              ServiceResponseSubCodeEnum = ServiceResponseSubCode.ACT_FAIL, 
                                              ServiceResponseSubCodeDescription = ServiceResponseSubCode.ACT_FAIL.GetAttributeOfType<DescriptionAttribute>().Description, 
                                              SprintErrorCode = 0, 
                                              SprintErrorCodeName = string.Empty, 
                                              SprintResponseMessage = string.Empty, 
                                              SprintResponseAdvice = string.Empty, 
                                              ActivationStatus = ActivationStatus.PartialSuccess, 
                                          };
                    activationUpgradeRequest = null;
                    return true;
                }
            }

            activateUpgrade = null;
            return false;
        }

        #endregion
    }
}