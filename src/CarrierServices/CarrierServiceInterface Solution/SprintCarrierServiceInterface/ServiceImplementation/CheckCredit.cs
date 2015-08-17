// --------------------------------------------------------------------------------------------------------------------
// <copyright file="CheckCredit.cs" company="">
//   
// </copyright>
// <summary>
//   The check credit request.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation
{
    using System;
    using System.Collections.Generic;
    using System.Runtime.CompilerServices;

    using SprintCSI.Properties;
    using SprintCSI.ServiceImplementation.DTO;
    using SprintCSI.Utils;

    using WirelessAdvocates;
    using WirelessAdvocates.Enum;

    using NEW_REQUEST = SprintCSI.Request;
    using NEW_RESPONSE = SprintCSI.Response;
    using REQUEST = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;
    using RESPONSE = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.response;

    /// <summary>The check credit impl.</summary>
    public class CheckCredit : OvmBase<CheckCreditRequest, SprintCreditCheckResponse>
    {
        #region Fields

        /// <summary>The response.</summary>
        private readonly SprintCreditCheckResponse response = new SprintCreditCheckResponse();

        #endregion

        #region Public Methods and Operators

        /// <summary>The get response.</summary>
        /// <returns>The <see cref="SprintCreditCheckResponse" />.</returns>
        public override SprintCreditCheckResponse GetResponse()
        {
            return this.response;
        }

        /// <summary>The new map error code.</summary>
        /// <param name="ovmResponse">The ovm response.</param>
        /// <exception cref="NotImplementedException"></exception>
        public override void MapErrorCode(RESPONSE.ovm ovmResponse)
        {
            throw new NotImplementedException("called CheckCredit.MapErrorCode");
        }

        /// <summary>The map request.</summary>
        /// <param name="req">The req.</param>
        /// <param name="sprintRequest">The sprint request.</param>
        /// <exception cref="ServiceException"></exception>
        public override void MapRequest(CheckCreditRequest req, ref REQUEST.ovm sprintRequest)
        {
            sprintRequest.ovmheader.messagetype = REQUEST.RequestMessageType.CREDIT_CHECK_REQUEST;

            // NOTE [pcrawford,20140106]  Per Sprint: "The order-id on this transaction MUST be unique and must match the order id submitted with the activation." 
            sprintRequest.ovmheader.orderid = this.AddRandomValue(sprintRequest.ovmheader.orderid);

            ExtendedAddress address = this.GetExtendedAddress(req);

            // Get the stored billing address from the session.
            // This should take care of ReferenceNumber mapping as well.
            var extendedAddress = new ExtendedAddress { AddressLine1 = address.AddressLine1, City = address.City, State = address.State, ZipCode = address.ZipCode };

            // build request order
            var svcOrder = new REQUEST.OrderInfoType { type = REQUEST.OrderType.NEW };

            // always new for this request. Use the CheckCreditExistingAccount for existing accounts.

            // build billing information for the request.
            var svcBilling = new REQUEST.BillingInfoType();
            var svcName = new REQUEST.Name
            {
                sirname = req.BillingName.Prefix,
                firstname = req.BillingName.FirstName,
                middleinitial = req.BillingName.MiddleInitial,
                lastname = req.BillingName.LastName,
                suffix = req.BillingName.Suffix
            };
            svcBilling.name = svcName;

            if (req.ContactInfo != null)
            {
                svcBilling.emailaddress = req.ContactInfo.Email;
            }

            var svcAddress = new REQUEST.Address();
            var ob = new object[5];
            ob[0] = extendedAddress.AddressLine1;
            ob[1] = extendedAddress.AddressLine2;
            ob[2] = extendedAddress.City;
            ob[3] = extendedAddress.State;
            ob[4] = extendedAddress.ZipCode;
            svcAddress.Items = ob;
            var obn = new REQUEST.ItemsChoiceType1[5];
            obn[0] = REQUEST.ItemsChoiceType1.streetaddress1;
            obn[1] = REQUEST.ItemsChoiceType1.streetaddress2;
            obn[2] = REQUEST.ItemsChoiceType1.city;
            obn[3] = REQUEST.ItemsChoiceType1.statecode;
            obn[4] = REQUEST.ItemsChoiceType1.zipcode;
            svcAddress.ItemsElementName = obn;
            svcBilling.address = svcAddress;

            if (!string.IsNullOrEmpty(req.ContactInfo.EveningPhone))
            {
                svcBilling.homephone = req.ContactInfo.EveningPhone;
            }
            else if (!string.IsNullOrEmpty(req.ContactInfo.CellPhone))
            {
                svcBilling.homephone = req.ContactInfo.CellPhone;
            }

            if (!string.IsNullOrEmpty(req.ContactInfo.WorkPhone))
            {
                svcBilling.workphone = new REQUEST.PhoneExtType { Value = req.ContactInfo.WorkPhone };
            }

            // build Drivers license service
            // REQUEST: 
            var svcDriversLicense = new REQUEST.DriversLicense
            {
                id = req.BillingContactCredentials.Id,
                state = req.BillingContactCredentials.State,
                expirationdate = req.BillingContactCredentials.IdExpiration,
                expirationdateSpecified = true
            };

            // populating PhysicalAddress
            var physicalAddress = new REQUEST.PhysicalInfoType();
            physicalAddress.address = new REQUEST.Address();
            var itemList = new List<object> { extendedAddress.AddressLine1, extendedAddress.AddressLine2, extendedAddress.City, extendedAddress.State, extendedAddress.ZipCode };
            var itemElementNameList = new List<REQUEST.ItemsChoiceType1>
                                          {
                                              REQUEST.ItemsChoiceType1.streetaddress1, 
                                              REQUEST.ItemsChoiceType1.streetaddress2, 
                                              REQUEST.ItemsChoiceType1.city, 
                                              REQUEST.ItemsChoiceType1.statecode, 
                                              REQUEST.ItemsChoiceType1.zipcode
                                          };
            physicalAddress.address.Items = itemList.ToArray();
            physicalAddress.address.ItemsElementName = itemElementNameList.ToArray();

            sprintRequest.ovmrequest.ItemElementName = REQUEST.ItemChoiceType19.creditrequest;

            var cr = new REQUEST.CreditRequest
            {
                order = svcOrder,
                subscriberagreement = true,
                customertype = this.CustType,
                billing = svcBilling,
                activationzipcode = req.ServiceZipCode,
                ItemElementName = REQUEST.ItemChoiceType9.ssn,
                Item = req.BillingContactCredentials.SSN,
                driverslicense = svcDriversLicense,
                dateofbirth = req.BillingContactCredentials.Dob,
                dateofbirthSpecified = true,
                handsetcount = byte.Parse(req.NumberOfLines.ToString()),
                physical = physicalAddress
            };

            if (req.QuestionCode.Length > 0)
            {
                cr.secquestioncode = req.QuestionCode;
            }

            if (req.QuestionAnswer.Length > 0)
            {
                cr.secanswer = req.QuestionAnswer;
            }

            sprintRequest.ovmrequest.Item = cr;
        }

        /// <summary>The new map response.</summary>
        /// <param name="ovmresponseType">The ovmresponse type.</param>
        /// <returns>The <see cref="SprintCreditCheckResponse"/>.</returns>
        /// <exception cref="NotImplementedException"></exception>
        public override SprintCreditCheckResponse MapResponse(RESPONSE.OvmResponseType ovmresponseType)
        {
            throw new NotImplementedException("called deprecated CheckCredit.MapResponse");
        }

        /// <summary>The map error code.</summary>
        /// <param name="ovmResponse">The ovm response.</param>
        public override void NewMapErrorCode(NEW_RESPONSE.ovm ovmResponse)
        {
            this.response.ServiceResponseSubCodeEnum = new CheckCreditExistingAccount().MapCreditCheckErrorCode(ovmResponse);
            this.SetResponseErrorFields();
        }

        /// <summary>The new map request.</summary>
        /// <param name="req">The req.</param>
        /// <param name="sprintRequest">The sprint request.</param>
        /// <exception cref="NotImplementedException"></exception>
        public override void NewMapRequest(CheckCreditRequest req, ref NEW_REQUEST.ovm sprintRequest)
        {
            throw new NotImplementedException("called  CheckCredit.NewMapRequest");
        }

        /// <summary>The map response.</summary>
        /// <param name="ovmresponseType">The ovmresponse type.</param>
        /// <returns>The <see cref="WirelessAdvocates.ServiceResponse.CreditCheckResponse"/>.</returns>
        public override SprintCreditCheckResponse NewMapResponse(NEW_RESPONSE.OvmResponseType ovmresponseType)
        {
            // NOTE [pcrawford,20140131] All this means in the rest of the code is that the code received a response from Sprint
            // But this CheckCredit module uses it to mean there was some kind of failure to be approved 
            this.response.ErrorCode = (int)ServiceResponseCode.Success;

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

            string result = creditResponse.result.ToString();

            switch (result)
            {
                case "CREDIT_UNKNOWN":
                    this.response.ServiceResponseSubCodeEnum = ServiceResponseSubCode.CC_STATUS_UNKNOWN;
                    break;

                case "NO_DEPOSIT_REQUIRED_SL_REQUIRED":
                case "NO_DEPOSIT_REQUIRED":
                    this.response.ServiceResponseSubCodeEnum = ServiceResponseSubCode.CC_CREDIT_APPROVED;
                    break;

                case "BAN_EXISTS_FOR_FTI":
                case "BAN_EXISTS_FOR_SSN":
                    this.response.ServiceResponseSubCodeEnum = ServiceResponseSubCode.CC_EXISTING_CUSTOMER;
                    break;

                default:
                    this.response.ServiceResponseSubCodeEnum = ServiceResponseSubCode.CC_CREDIT_DECLINED;
                    break;
            }

            this.SetResponseErrorFields();

            return this.response;
        }

        /// <summary>The new set error obj.</summary>
        /// <param name="errorCode">The error code.</param>
        /// <param name="subErrorCode">The sub error code.</param>
        /// <param name="primaryErrorMessage">The primary error message.</param>
        /// <param name="errorInfo">The error info.</param>
        /// <returns>The <see cref="SprintCreditCheckResponse"/>.</returns>
        /// <exception cref="NotImplementedException"></exception>
        public override SprintCreditCheckResponse NewSetErrorObj(
            ServiceResponseCode errorCode,
            ServiceResponseSubCode subErrorCode,
            string primaryErrorMessage,
            NEW_RESPONSE.ErrorInfo[] errorInfo = null)
        {
            this.response.ErrorCode = (int)errorCode;
            this.response.ServiceResponseSubCode = (int)subErrorCode;

            // this.response.PrimaryErrorMessage = primaryErrorMessage;
            // this.response.PrimaryErrorMessageLong = this.response.PrimaryErrorMessage;
            this.response.NewErrorInfo = errorInfo;

            if (this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorInfo) == null)
            {
                return this.response;
            }

            int tryInt;
            int.TryParse(this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorCode), out tryInt);

            // this.response.SprintErrorCode = tryInt;
            // this.response.SprintResponseMessage = this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorDetails);
            // this.response.SprintResponseAdvice = this.GetSprintResponseAdvice(errorInfo);
            return this.response;
        }

        /// <summary>The set error obj.</summary>
        /// <param name="errorCode">The error code.</param>
        /// <param name="subErrorCode">The sub error code.</param>
        /// <param name="primaryErrorMessage">The primary error message.</param>
        /// <param name="errorInfo">The error info</param>
        /// <returns>The <see cref="WirelessAdvocates.ServiceResponse.CreditCheckResponse"/>.</returns>
        public override SprintCreditCheckResponse SetErrorObj(ServiceResponseCode errorCode, ServiceResponseSubCode subErrorCode, string primaryErrorMessage, RESPONSE.ErrorInfo[] errorInfo = null)
        {
            throw new NotImplementedException("called deprecated CheckCredit.SetErrorObj");
        }

        #endregion

        #region Methods

        /// <summary>The handle invalid cast.</summary>
        /// <param name="ovmresponseType">The ovmresponse type.</param>
        /// <param name="caller">The caller.</param>
        /// <param name="sourceLineNumber">The source line number.</param>
        /// <exception cref="NotImplementedException"></exception>
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
            throw new NotImplementedException("called CheckCredit.NewHandleInvalidCast");
        }

        /// <summary>The validate request.</summary>
        /// <param name="request">The request.</param>
        /// <param name="caller">The caller.</param>
        /// <param name="sourceLineNumber">The source Line Number.</param>
        /// <exception cref="ServiceException"></exception>
        protected override void ValidateRequest(CheckCreditRequest request, [CallerMemberName] string caller = null, [CallerLineNumber] int sourceLineNumber = 0)
        {
            if (request == null)
            {
                throw new ServiceException("Invalid request.") { ErrorCode = ServiceResponseCode.Failure, ServiceResponseSubCode = ServiceResponseSubCode.CCError, };
            }

            if (request.BillingContactCredentials == null)
            {
                throw new ServiceException("Invalid billing credential.") { ErrorCode = ServiceResponseCode.Failure, ServiceResponseSubCode = ServiceResponseSubCode.CCError, };
            }

            if (request.BillingName == null)
            {
                throw new ServiceException("Invalid billing name.") { ErrorCode = ServiceResponseCode.Failure, ServiceResponseSubCode = ServiceResponseSubCode.CCError, };
            }

            if (request.ContactInfo == null)
            {
                throw new ServiceException("Invalid contact info.") { ErrorCode = ServiceResponseCode.Failure, ServiceResponseSubCode = ServiceResponseSubCode.CCError, };
            }

            // ref number 
            if (string.IsNullOrEmpty(request.ReferenceNumber) || (request.ReferenceNumber.Length > 24))
            {
                throw new ServiceException("Invalid Reference Number.") { ErrorCode = ServiceResponseCode.Failure, ServiceResponseSubCode = ServiceResponseSubCode.CCError, };
            }

            // ss validation
            if (string.IsNullOrEmpty(request.BillingContactCredentials.SSN) || (request.BillingContactCredentials.SSN.Length != 9))
            {
                throw new ServiceException("Invalid SSN.") { ErrorCode = ServiceResponseCode.Failure, ServiceResponseSubCode = ServiceResponseSubCode.CCError, };
            }

            // DOB validation
            if (request.BillingContactCredentials.Dob > DateTime.Now)
            {
                throw new ServiceException("Invalid DOB.") { ErrorCode = ServiceResponseCode.Failure, ServiceResponseSubCode = ServiceResponseSubCode.CCError, };
            }

            // name validation
            if (request.BillingName != null)
            {
                if (string.IsNullOrEmpty(request.BillingName.LastName))
                {
                    throw new ServiceException("Invalid Billing Name.") { ErrorCode = ServiceResponseCode.Failure, ServiceResponseSubCode = ServiceResponseSubCode.CCError, };
                }
            }

            // handset count
            if (request.NumberOfLines < 1 && request.NumberOfLines > 50)
            {
                throw new ServiceException("Invalid NumberOfLines.") { ErrorCode = ServiceResponseCode.Failure, ServiceResponseSubCode = ServiceResponseSubCode.CCError, };
            }

            // at least one phone number must be specified (according to sprint spec)
            Contact ci = request.ContactInfo;
            if (string.IsNullOrEmpty(ci.CellPhone) && string.IsNullOrEmpty(ci.EveningPhone) && string.IsNullOrEmpty(ci.WorkPhone))
            {
                throw new ServiceException("Invalid MDN.") { ErrorCode = ServiceResponseCode.Failure, ServiceResponseSubCode = ServiceResponseSubCode.CCError, };
            }

            // invalid zip
            if (string.IsNullOrEmpty(request.ServiceZipCode) || request.ServiceZipCode.Length < 5 || request.ServiceZipCode.Length > 9)
            {
                throw new ServiceException("Invalid zip code.") { ErrorCode = ServiceResponseCode.Failure, ServiceResponseSubCode = ServiceResponseSubCode.CCError, };
            }
        }

        /// <summary>The get extended address.</summary>
        /// <param name="req">The req.</param>
        /// <returns>The <see cref="ExtendedAddress"/>.</returns>
        /// <exception cref="ServiceException"></exception>
        private ExtendedAddress GetExtendedAddress(CheckCreditRequest req)
        {
            // retrieve the address from the cache
            ExtendedAddress address;
            try
            {
                string y = req.ReferenceNumber.Substring(0, this.TestReferenceBase.Length);
                if (y == this.TestReferenceBase)
                {
                    address = SessionHelper.Instance.GetAddress(this.TestReferenceBase, Address.AddressEnum.Billing);
                }
                else
                {
                    address = SessionHelper.Instance.GetAddress(req.ReferenceNumber, Address.AddressEnum.Billing);
                }
            }
            catch (Exception ex)
            {
                throw new ServiceException(ex.Message, ex) { ErrorCode = ServiceResponseCode.Failure, ServiceResponseSubCode = ServiceResponseSubCode.CCError, };
            }

            return address;
        }

        /// <summary>The set common error fields.</summary>
        private void SetCommonErrorFields()
        {
            // this.response.PrimaryErrorMessage = this.response.PrimaryErrorMessageLong;
            // this.response.PrimaryErrorMessage = this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorDetails);
            // this.response.ServiceResponseSubCodeEnum = ServiceResponseSubCode.ACT_FAIL;

            this.response.ServiceResponseSubCode = (int)this.response.ServiceResponseSubCodeEnum;
            this.response.ErrorCodeEnum = ServiceResponseCode.Failure;
            this.response.ErrorCode = (int)this.response.ErrorCodeEnum;

            // TODO [pcrawford,20140108] Add Activation Status or delete this class entirely
            // this.response.ActivationStatus = ActivationStatus.Failure;
            // this.response.ServiceResponseSubCodeDescription = ServiceResponseSubCode.ACT_FAIL.GetAttributeOfType<DescriptionAttribute>().Description;
            // this.response.PrimaryErrorMessageBrief = this.response.ServiceResponseSubCodeDescription;
            // this.response.SprintErrorCode = Convert.ToInt32(this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorCode));
            // this.response.SprintErrorCodeEnum = this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorSubName);
        }

        /// <summary>The set parse response error fields.</summary>
        /// <param name="caller">The caller.</param>
        /// <param name="sourceLineNumber">The source line number.</param>
        private void SetParseResponseErrorFields([CallerMemberName] string caller = null, [CallerLineNumber] int sourceLineNumber = 0)
        {
            // this.response.CallerMemberName = string.Format("{0}.{1}", typeof(CheckCredit), caller);
            // this.response.CallerLineNumber = sourceLineNumber;

            // this.response.PrimaryErrorMessage = this.ResponseXmlHelper.GetXmlValue(Resources.parseResponseDetails);
            // this.response.PrimaryErrorMessageLong = this.ResponseXmlHelper.GetXmlValue(Resources.parseResponseDetails);
            // this.response.SprintErrorCodeName = this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorDetails);
            this.SetCommonErrorFields();
        }

        /// <summary>The set response error fields.</summary>
        /// <param name="caller">The caller.</param>
        /// <param name="sourceLineNumber">The source line number.</param>
        private void SetResponseErrorFields([CallerMemberName] string caller = null, [CallerLineNumber] int sourceLineNumber = 0)
        {
            // this.response.CallerMemberName = string.Format("{0}.{1}", typeof(CheckCredit), caller);
            // this.response.CallerLineNumber = sourceLineNumber;

            // this.response.PrimaryErrorMessage = this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorDetails);
            // this.response.PrimaryErrorMessageLong = this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorDetails);
            // this.response.SprintErrorCodeName = this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorSubName);
            this.SetCommonErrorFields();
        }

        #endregion
    }
}