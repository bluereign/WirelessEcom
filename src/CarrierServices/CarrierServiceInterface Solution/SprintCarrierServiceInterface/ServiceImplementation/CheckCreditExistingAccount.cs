// --------------------------------------------------------------------------------------------------------------------
// <copyright file="CheckCreditExistingAccount.cs" company="">
//   
// </copyright>
// <summary>
//   The check credit existing account request.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation
{
    using System;
    using System.ComponentModel;
    using System.Linq;
    using System.Runtime.CompilerServices;

    using SprintCSI.Properties;
    using SprintCSI.ServiceImplementation.DTO;

    using WirelessAdvocates;
    using WirelessAdvocates.Enum;
    using WirelessAdvocates.Extensions;

    using NEW_REQUEST = SprintCSI.Request;
    using NEW_RESPONSE = SprintCSI.Response;
    using REQUEST = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;
    using RESPONSE = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.response;

    /// <summary>The check credit existing account implementation.</summary>
    public class CheckCreditExistingAccount : OvmBase<CheckCreditExistingAccountRequest, SprintCheckCreditExistingAccountResponse>
    {
        #region Fields

        /// <summary>The response.</summary>
        private readonly SprintCheckCreditExistingAccountResponse response = new SprintCheckCreditExistingAccountResponse();

        /// <summary>The reference.</summary>
        private string referenceNumber;

        #endregion

        #region Public Methods and Operators

        /// <summary>The get response.</summary>
        /// <returns>The <see cref="SprintCheckCreditExistingAccountResponse"/>.</returns>
        public override SprintCheckCreditExistingAccountResponse GetResponse()
        {
            return this.response;
        }

        /// <summary>The map credit check error code.</summary>
        /// <param name="ovmResponse">The ovm response.</param>
        /// <returns>The <see cref="ServiceResponseSubCode"/>.</returns>
        /// <exception cref="ServiceException"></exception>
        public ServiceResponseSubCode MapCreditCheckErrorCode(NEW_RESPONSE.ovm ovmResponse)
        {
            var errorSubCode = ServiceResponseSubCode.CC_CREDIT_APPROVED;

            if (ovmResponse != null && ovmResponse.ovmerrorinfo != null)
            {
                if (ovmResponse.ovmerrorinfo.Length == 0)
                {
                    throw new ServiceException("Credit Approved") { ErrorCode = ServiceResponseCode.Success, ServiceResponseSubCode = errorSubCode, NewErrorInfo = ovmResponse.ovmerrorinfo };
                }

                NEW_RESPONSE.ErrorInfo[] errorInfo = ovmResponse.ovmerrorinfo;

                int sprintErrorCode = int.Parse(ovmResponse.ovmerrorinfo[0].errorcode);
                uint sprintErrorType = errorInfo[0].errortype;

                switch (sprintErrorType)
                {
                    case 1:
                        return ServiceResponseSubCode.CC_STATUS_UNKNOWN;
                    case 3:
                    case 2:
                        switch (sprintErrorCode)
                        {
                            case 103: // invalid address

                                // return ServiceResponseSubCode.AV_INVALID_ADDRESS;
                                // break;
                            case 114: // credit check in process
                                return ServiceResponseSubCode.CC_STATUS_UNKNOWN;
                            case 400: // account e-mails exists
                            case 134: // account exists for SSN
                                return ServiceResponseSubCode.CC_EXISTING_CUSTOMER;
                            case 102: // declined
                            case 140: // delinquent account
                               return ServiceResponseSubCode.CC_ACCOUNT_DELINQUENT;
                            case 142: // delinquent score
                            case 198: // bad file
                                return ServiceResponseSubCode.CC_CREDIT_DECLINED;

                                // case 200: //cancelled account
                                // errorSubCode = ServiceResponseSubCode.CC_RECENT_CANCEL;
                                // break;
                            default: // Declined
                                return ServiceResponseSubCode.CC_CREDIT_DECLINED;
                        }
                } 

                //throw new ServiceException("[CheckCreditExistingAccount.1] Credit Check service call returned with error")
                //          {
                //              ErrorCode = ServiceResponseCode.Failure, 
                //              ServiceResponseSubCode = errorSubCode, 
                //              NewErrorInfo = ovmResponse.ovmerrorinfo
                //          };
            }

            string result = string.Empty;

            if (ovmResponse != null)
            {
                result = ((NEW_RESPONSE.CreditResponse)ovmResponse.ovmresponse.Item).result.ToString();
            }

            switch (result)
            {
                case "CREDIT_UNKNOWN":
                    return ServiceResponseSubCode.CC_STATUS_UNKNOWN;
                case "NO_DEPOSIT_REQUIRED_SL_REQUIRED":
                case "NO_DEPOSIT_REQUIRED":

                    // errorSubCode = ServiceResponseSubCode.CC_CREDIT_APPROVED;
                    return errorSubCode;

                case "BAN_EXISTS_FOR_FTI":
                case "BAN_EXISTS_FOR_SSN":
                    return ServiceResponseSubCode.CC_EXISTING_CUSTOMER;

                default:
                    return ServiceResponseSubCode.CC_CREDIT_DECLINED;
            }

            //throw new ServiceException("[CheckCreditExistingAccount.2]Credit Check service call returned with error")
            //          {
            //              ErrorCode = ServiceResponseCode.Failure, 
            //              ServiceResponseSubCode = errorSubCode, 
            //              NewErrorInfo = ovmResponse.ovmerrorinfo
            //          };
        }

        /// <summary>The map error code.</summary>
        /// <param name="ovmResponse">The ovm response.</param>
        public override void MapErrorCode(RESPONSE.ovm ovmResponse)
        {
            throw new NotImplementedException("Deprecated MapErrorCode called");
        }

        /// <summary>The map request.</summary>
        /// <param name="req">The req.</param>
        /// <param name="sprintRequest">The sprint request.</param>
        /// <exception cref="NotImplementedException"></exception>
        public override void MapRequest(CheckCreditExistingAccountRequest req, ref REQUEST.ovm sprintRequest)
        {
            this.referenceNumber = req.ReferenceNumber;

            sprintRequest.ovmheader.messagetype = REQUEST.RequestMessageType.CREDIT_CHECK_REQUEST;

            // NOTE [pcrawford,20140106]  Per Sprint: "The order-id on this transaction MUST be unique and must match the order id submitted with the activation." 
            sprintRequest.ovmheader.orderid = this.AddRandomValue(this.referenceNumber);

            // NOTE [pcrawford,20140113] We preserve and re-use this order-id so it can be the same across all the calls to activate a line except ActivateReservedDevice
            this.response.TransactionOrderId = sprintRequest.ovmheader.orderid;

            // build the request OrderInfoType
            var svcOrder = new REQUEST.OrderInfoType { type = req.OrderType };

            switch (req.OrderType)
            {
                case REQUEST.OrderType.ADD_ON:
                    svcOrder.ItemElementName = REQUEST.ItemChoiceType2.accountnumber;
                    svcOrder.Item = req.AccountNumber;
                    break;
                case REQUEST.OrderType.UPGRADE:
                    svcOrder.ItemElementName = REQUEST.ItemChoiceType2.referenceptn;
                    svcOrder.Item = req.Mdn;
                    break;
                default:
                    throw new NotImplementedException("CheckCreditExistingAccount.MapRequest: OrderType neither ADD_ON or UPGRADE");
            }

            // build the entire request.
            sprintRequest.ovmrequest.ItemElementName = REQUEST.ItemChoiceType19.creditrequest;

            var cr = new REQUEST.CreditRequest { order = svcOrder, subscriberagreement = true, customertype = req.CustomerType, handsetcount = req.HandsetCount };

            if (!string.IsNullOrEmpty(req.SecretPin))
            {
                cr.secpin = req.SecretPin;
            }

            if (!string.IsNullOrEmpty(req.SSN))
            {
                cr.ItemElementName = REQUEST.ItemChoiceType9.ssn;
                cr.Item = req.SSN;
            }

            if (!string.IsNullOrEmpty(req.QuestionCode))
            {
                cr.secquestioncode = req.QuestionCode;
            }

            if (!string.IsNullOrEmpty(req.QuestionAnswer))
            {
                cr.secanswer = req.QuestionAnswer;
            }

            sprintRequest.ovmrequest.Item = cr;
        }

        /// <summary>The new map error code.</summary>
        /// <param name="ovmResponse">The ovm response.</param>
        /// <exception cref="NotImplementedException"></exception>
        public override void NewMapErrorCode(NEW_RESPONSE.ovm ovmResponse) 
        {
            this.response.ServiceResponseSubCodeEnum = this.MapCreditCheckErrorCode(ovmResponse);
            this.SetResponseErrorFields();
        }

        /// <summary>The new map request.</summary>
        /// <param name="req">The req.</param>
        /// <param name="sprintRequest">The sprint request.</param>
        /// <exception cref="NotImplementedException"></exception>
        public override void NewMapRequest(CheckCreditExistingAccountRequest req, ref NEW_REQUEST.ovm sprintRequest)
        {
            throw new NotImplementedException("called CheckCreditExistingAccount.NewMapRequest");
        }

        /// <summary>The map response.</summary>
        /// <param name="ovmresponseType">The ovmresponse type.</param>
        /// <returns>The <see cref="SprintCheckCreditExistingAccountResponse"/>.</returns>
        public override SprintCheckCreditExistingAccountResponse NewMapResponse(NEW_RESPONSE.OvmResponseType ovmresponseType)
        {
            NEW_RESPONSE.CreditResponse creditResponse;

            // TODO [pcrawford,20131002] This Try/Catch pattern needs to be implemented across the service
            try
            {
                creditResponse = (NEW_RESPONSE.CreditResponse)ovmresponseType.Item;
            }
            catch (InvalidCastException)
            {
                this.SetParseResponseErrorFields();
                return this.response;
            }

                 this.SetResponseErrorFields();

            // get deposit amount on number of handsets passed
            this.response.Deposit = creditResponse.totaldeposit;
            this.response.NumberOfLines = Convert.ToInt16(creditResponse.numberhandsetsapproved);
            this.response.CreditStatus = creditResponse.result.ToString();
            this.response.CreditApplicationNumber = creditResponse.appnumber;

            NEW_RESPONSE.OrderInfoType svcOrderResponse = creditResponse.order;
            svcOrderResponse.ItemElementName = NEW_RESPONSE.ItemChoiceType2.accountnumber;
            this.response.CustomerAccountNumber = svcOrderResponse.Item;

            // TODO: build sub codes based on customers whose credit was not approved.

            // populate Address object with data returned from sprint
            if (creditResponse.billing == null)
            {
                return this.response;
            }

            NEW_RESPONSE.Address billingAddress = creditResponse.billing.address;
            if (billingAddress == null)
            {
                return this.response;
            }

            this.response.BillingAddress = new Address();
            for (int ii = 0; ii < billingAddress.ItemsElementName.Count(); ii++)
            {
                NEW_RESPONSE.ItemsChoiceType1 item = billingAddress.ItemsElementName[ii];
                switch (item)
                {
                    case NEW_RESPONSE.ItemsChoiceType1.streetaddress1:
                        this.response.BillingAddress.AddressLine1 = (string)billingAddress.Items[ii];
                        break;
                    case NEW_RESPONSE.ItemsChoiceType1.streetaddress2:
                        this.response.BillingAddress.AddressLine2 = (string)billingAddress.Items[ii];
                        break;
                    case NEW_RESPONSE.ItemsChoiceType1.city:
                        this.response.BillingAddress.City = (string)billingAddress.Items[ii];
                        break;
                    case NEW_RESPONSE.ItemsChoiceType1.statecode:
                        this.response.BillingAddress.State = (string)billingAddress.Items[ii];
                        break;
                    case NEW_RESPONSE.ItemsChoiceType1.zipcode:
                        this.response.BillingAddress.ZipCode = (string)billingAddress.Items[ii];
                        break;
                    case NEW_RESPONSE.ItemsChoiceType1.countrycode:
                        this.response.BillingAddress.Country = (string)billingAddress.Items[ii];
                        break;
                }
            }

            if (creditResponse.billing.name == null)
            {
                return this.response;
            }

            this.response.BillingAddress.Name = new Name
                                                    {
                                                        FirstName = creditResponse.billing.name.firstname, 
                                                        MiddleInitial = creditResponse.billing.name.middleinitial, 
                                                        LastName = creditResponse.billing.name.lastname
                                                    };


            return this.response;
        }

        /// <summary>The new set error obj.</summary>
        /// <param name="errorCode">The error code.</param>
        /// <param name="subErrorCode">The sub error code.</param>
        /// <param name="primaryErrorMessage">The primary error message.</param>
        /// <param name="errorInfo">The error info.</param>
        /// <returns>The <see cref="SprintCheckCreditExistingAccountResponse"/>.</returns>
        /// <exception cref="NotImplementedException"></exception>
        public override SprintCheckCreditExistingAccountResponse NewSetErrorObj(
            ServiceResponseCode errorCode, 
            ServiceResponseSubCode subErrorCode, 
            string primaryErrorMessage, 
            NEW_RESPONSE.ErrorInfo[] errorInfo = null)
        {
            {
                this.response.ErrorCode = (int)errorCode;
                this.response.ServiceResponseSubCode = (int)subErrorCode;
                this.response.PrimaryErrorMessage = primaryErrorMessage;
                this.response.PrimaryErrorMessageLong = this.response.PrimaryErrorMessage;
                this.response.NewErrorInfo = errorInfo;

                if (this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorInfo) == null)
                {
                    return this.response;
                }

                int tryInt;
                int.TryParse(this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorCode), out tryInt);
                this.response.SprintErrorCode = tryInt;
                this.response.SprintResponseMessage = this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorDetails);
                this.response.SprintResponseAdvice = this.GetSprintResponseAdvice(errorInfo);

                return this.response;
            }
        }

        /// <summary>The set error obj.</summary>
        /// <param name="errorCode">The error code.</param>
        /// <param name="subErrorCode">The sub error code.</param>
        /// <param name="primaryErrorMessage">The primary error message.</param>
        /// <param name="errorInfo">The error info</param>
        /// <returns>The <see cref="SprintCheckCreditExistingAccountResponse"/>.</returns>
        public override SprintCheckCreditExistingAccountResponse SetErrorObj(ServiceResponseCode errorCode, ServiceResponseSubCode subErrorCode, string primaryErrorMessage, RESPONSE.ErrorInfo[] errorInfo)
        {
            throw new NotImplementedException("called Deprecated CheckCreditExistingAccount.SetErrorObj");
        }

        #endregion

        #region Methods

        /// <summary>The handle invalid cast.</summary>
        /// <param name="ovmresponseType">The ovmresponse type.</param>
        /// <param name="caller">The caller.</param>
        /// <param name="sourceLineNumber">The source Line Number.</param>
        protected override void HandleInvalidCast(RESPONSE.OvmResponseType ovmresponseType, [CallerMemberName] string caller = null, [CallerLineNumber] int sourceLineNumber = 0)
        {
            this.SetParseResponseErrorFields();
        }

        /// <summary>The new handle invalid cast.</summary>
        /// <param name="ovmresponseType">The ovmresponse type.</param>
        /// <param name="caller">The caller.</param>
        /// <param name="sourceLineNumber">The source line number.</param>
        /// <exception cref="NotImplementedException"></exception>
        protected override void NewHandleInvalidCast(NEW_RESPONSE.OvmResponseType ovmresponseType, string caller = null, int sourceLineNumber = 0)
        {
            throw new NotImplementedException("Called CheckCreditExistingAccount.NewHandleInvalidCast");
        }

        /// <summary>The set common error fields.</summary>
        private void SetCommonErrorFields()
        {
            this.response.PrimaryErrorMessage = this.response.PrimaryErrorMessageLong;
            // this.response.ServiceResponseSubCodeEnum = ServiceResponseSubCode.ACT_FAIL;
            this.response.ServiceResponseSubCode = (int)this.response.ServiceResponseSubCodeEnum;
            
            //NOTE [pcrawford,20140124] All this code means is that we had a conversation with Sprint!
            this.response.ErrorCodeEnum = ServiceResponseCode.Success;
            this.response.ErrorCode = (int)this.response.ErrorCodeEnum;

            // TODO [pcrawford,20140108] Add Activation Status or delete this class entirely
            // this.response.ActivationStatus = ActivationStatus.Failure;
            this.response.ServiceResponseSubCodeDescription = ServiceResponseSubCode.ACT_FAIL.GetAttributeOfType<DescriptionAttribute>().Description;
            this.response.PrimaryErrorMessageBrief = this.response.ServiceResponseSubCodeDescription;
            this.response.SprintErrorCode = Convert.ToInt32(this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorCode));
        }

        /// <summary>The set parse response error fields.</summary>
        /// <param name="caller">The caller.</param>
        /// <param name="sourceLineNumber">The source line number.</param>
        private void SetParseResponseErrorFields([CallerMemberName] string caller = null, [CallerLineNumber] int sourceLineNumber = 0)
        {
            this.response.CallerMemberName = string.Format("{0}.{1}", typeof(CheckCreditExistingAccount), caller);
            this.response.CallerLineNumber = sourceLineNumber;

            this.response.PrimaryErrorMessageLong = this.ResponseXmlHelper.GetXmlValue(Resources.parseResponseDetails);
            this.response.SprintErrorCodeName = this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorDetails);
            this.SetCommonErrorFields();
        }

        /// <summary>The set response error fields.</summary>
        /// <param name="caller">The caller.</param>
        /// <param name="sourceLineNumber">The source line number.</param>
        private void SetResponseErrorFields([CallerMemberName] string caller = null, [CallerLineNumber] int sourceLineNumber = 0)
        {
            this.response.CallerMemberName = string.Format("{0}.{1}", typeof(CheckCreditExistingAccount), caller);
            this.response.CallerLineNumber = sourceLineNumber;

            this.response.PrimaryErrorMessageLong = this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorDetails);
            this.response.SprintErrorCodeName = this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorSubName);
            this.SetCommonErrorFields();
        }

        #endregion
    }
}