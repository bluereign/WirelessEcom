// --------------------------------------------------------------------------------------------------------------------
// <copyright file="CustomerLookupByMDN.cs" company="">
//   
// </copyright>
// <summary>
//   The customer inquiry request.
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
    using WirelessAdvocates.ServiceResponse;

    using NEW_REQUEST = SprintCSI.Request;
    using NEW_RESPONSE = SprintCSI.Response;
    using REQUEST = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;
    using RESPONSE = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.response;

    /// <summary>The customer lookup by mdn impl.</summary>
    public class CustomerLookupByMdn : OvmBase<CustomerInquiryRequest, SprintCustomerInquiryResponse>
    {
        #region Fields

        /// <summary>The response.</summary>
        private readonly SprintCustomerInquiryResponse response = new SprintCustomerInquiryResponse();

        /// <summary>The legacy.</summary>
        private bool legacy = true;

        #endregion

        #region Public Methods and Operators

        /// <summary>The get response.</summary>
        /// <returns>The <see cref="SprintCustomerInquiryResponse"/>.</returns>
        public override SprintCustomerInquiryResponse GetResponse()
        {
            return this.response;
        }

        /// <summary>The map request.</summary>
        /// <param name="req">The req.</param>
        /// <param name="sprintRequest">The sprint request.</param>
        public override void MapRequest(CustomerInquiryRequest req, ref REQUEST.ovm sprintRequest)
        {
            sprintRequest.ovmheader.messagetype = REQUEST.RequestMessageType.ACCOUNT_VALIDATION_REQUEST;

            var accountValidationRequest = new REQUEST.AccountValidationRequest();

            if (!string.IsNullOrEmpty(req.SecretKey))
            {
                // not required for all accounts.
                accountValidationRequest.secpin = req.SecretKey;
            }

            if (!string.IsNullOrEmpty(req.QuestionAnswer))
            {
                accountValidationRequest.secanswer = req.QuestionAnswer;
            }

            if (!string.IsNullOrEmpty(req.Ssn))
            {
                accountValidationRequest.Item1 = req.Ssn;
                accountValidationRequest.Item1ElementName = REQUEST.Item1ChoiceType.ssn;
            }

            accountValidationRequest.Item = req.Mdn;
            accountValidationRequest.ItemElementName = REQUEST.ItemChoiceType.referenceptn;

            sprintRequest.ovmrequest.Item = accountValidationRequest;
            sprintRequest.ovmrequest.ItemElementName = REQUEST.ItemChoiceType19.accountvalidationrequest;
        }

        /// <summary>The map error code.</summary>
        /// <param name="ovmResponse">The ovm response.</param>
        /// <exception cref="ServiceException"></exception>
        public override void NewMapErrorCode(NEW_RESPONSE.ovm ovmResponse)
        {
            this.response.ErrorCode = (int)ServiceResponseCode.Success;
            this.response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CL_CUSTOMER_FOUND;

            if (this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorInfo) == null)
            {
                return;
            }

            this.SetResponseErrorFields();

            int tryInt;
            int.TryParse(this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorCode), out tryInt);
            this.response.SprintErrorCode = tryInt;

            switch (this.response.SprintErrorCode)
            {
                case 246:
                    this.response.ServiceResponseSubCode = (int)ServiceResponseSubCode.ClCustomerNotFound;
                    break;
                case 220: // request time out
                case 358: // system error
                    this.response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CC_STATUS_UNKNOWN;
                    break;
                case 324:
                    this.response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CL_ACCOUNT_LOCKED;
                    break;
                case 322:
                    this.response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CL_ACCOUNT_NOPIN;
                    break;
                case 323:
                    this.response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CL_INVALID_PIN;
                    break;
                case 140:
                    this.response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CC_ACCOUNT_DELINQUENT;
                    break;
                case 100:
                    this.response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CcMDNDoesnotExist;
                    break;
                default:
                    this.response.ServiceResponseSubCode = (int)ServiceResponseSubCode.ClCustomerNotFound;
                    break;
            }
        }

        /// <summary>The map response.</summary>
        /// <param name="ovmResponse">The ovm response type.</param>
        /// <returns>The <see cref="CustomerInquiryResponse"/>.</returns>
        public override SprintCustomerInquiryResponse NewMapResponse(NEW_RESPONSE.OvmResponseType ovmResponse)
        {
            // Preserve this xml for potential use in Upgrade Replace
            this.response.ResponseXml = this.ResponseXmlHelper.XmlString;

            NEW_RESPONSE.AccountValidationResponse accountValidationResponse;

            this.response.ErrorCode = (int)ServiceResponseCode.Success;

            // TODO [pcrawford,20131002] This Try/Catch pattern needs to be implemented across the service
            try
            {
                accountValidationResponse = (NEW_RESPONSE.AccountValidationResponse)ovmResponse.Item;
            }
            catch (InvalidCastException)
            {
                this.SetParseResponseErrorFields();
                return this.response;
            }

            this.response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CL_CUSTOMER_FOUND;
            this.response.CustomerAccountNumber = accountValidationResponse.accountnumber;

            this.SetResponseErrorFields();
            
            // active line
            if (accountValidationResponse.accountstatus != NEW_RESPONSE.AccountStatus.ACTIVE)
            {
                return this.response;
            }

            NEW_RESPONSE.AccountInfo accountInfo = accountValidationResponse.accountinfo;
            if (accountInfo == null)
            {
                return this.response;
            }

            this.response.LinesActive = (int)accountInfo.currentsubscribers;

            // account type
            if (accountInfo.currentsubscribers > 0)
            {
                this.response.WirelessAccountType = this.TranslatePlanType(accountInfo.subscriber[0].plantype);
                this.response.PlanCode = accountInfo.subscriber[0].priceplancode;
            }

            // existing account monthly charges
            this.response.ExistingAccountMonthlyCharges = (from s in accountInfo.subscriber select s.priceplanprice).Sum();

            // customer lines
            foreach (NEW_RESPONSE.Subscriber s in accountInfo.subscriber)
            {
                var customerInquiryLine = new CustomerInquiryLine();
                customerInquiryLine.AccountStatus = this.TranslatePtnStatus(s.ptnstatus);

                // NOTE: billing address is to be retrieved from the CreditCheck call
                customerInquiryLine.CarrierAccountId = accountValidationResponse.accountnumber;

                customerInquiryLine.ContractStart = s.contractstartdate;
                customerInquiryLine.ContractStartSpecified = true;
                customerInquiryLine.EquipmentUpgradeAvailable = s.upgrade != null && s.upgrade.eligible;

                customerInquiryLine.UpgradeAvailableDate = string.Empty;
                if (s.upgrade != null && s.upgrade.eligibledateSpecified)
                {
                    customerInquiryLine.UpgradeAvailableDate = s.upgrade.eligibledate.ToString();
                }

                customerInquiryLine.ExistingLineMonthlyCharges = s.priceplanprice;
                customerInquiryLine.IsPrimaryLine = s.id.Equals("1");

                // first subscriber holds the primary line
                customerInquiryLine.Mdn = s.ptn;
                customerInquiryLine.UpgradeAvailableSpecified = s.upgrade != null;
                customerInquiryLine.WirelessLineType = WirelessLineType.Line;
                customerInquiryLine.PlanCode = s.priceplancode;
                customerInquiryLine.CurrentImei = s.serialnumber;

                this.response.CustomerInquiryLines.Add(customerInquiryLine);
            }

            return this.response;
        }

        /// <summary>The set error obj.</summary>
        /// <param name="errorCode">The error code.</param>
        /// <param name="subErrorCode">The sub error code.</param>
        /// <param name="primaryErrorMessage">The primary error message.</param>
        /// <param name="errorInfo">The error info</param>
        /// <returns>The <see cref="CustomerInquiryResponse"/>.</returns>
        public override SprintCustomerInquiryResponse NewSetErrorObj(
            ServiceResponseCode errorCode, 
            ServiceResponseSubCode subErrorCode, 
            string primaryErrorMessage, 
            NEW_RESPONSE.ErrorInfo[] errorInfo = null)
        {
            this.response.ErrorCode = (int)errorCode;
            this.response.ServiceResponseSubCode = (int)subErrorCode;
            this.response.PrimaryErrorMessage = primaryErrorMessage;
            this.response.PrimaryErrorMessageLong = primaryErrorMessage;
            this.response.PrimaryErrorMessage = this.response.PrimaryErrorMessage;
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

            this.SetResponseErrorFields();

            return this.response;
        }

        #endregion

        #region Methods

        /// <summary>The set common error fields.</summary>
        private void SetCommonErrorFields()
        {
            this.response.PrimaryErrorMessage = this.response.PrimaryErrorMessageLong;
            this.response.ServiceResponseSubCodeEnum = ServiceResponseSubCode.ACT_FAIL;
            this.response.ServiceResponseSubCode = (int)this.response.ServiceResponseSubCodeEnum;

            // For calls from the check-out path use the original legacy meaning for ErrorCode: 
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
            this.response.CallerMemberName = string.Format("{0}.{1}", typeof(CustomerLookupByMdn), caller);
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
            this.response.CallerMemberName = string.Format("{0}.{1}", typeof(CustomerLookupByMdn), caller);
            this.response.CallerLineNumber = sourceLineNumber;

            this.response.PrimaryErrorMessageLong = this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorDetails);
            this.response.SprintErrorCodeName = this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorSubName);
            this.SetCommonErrorFields();
        }

        /// <summary>The translate plan type.</summary>
        /// <param name="planType">The plan type.</param>
        /// <returns>The <see cref="WirelessAccountType"/>.</returns>
        private WirelessAccountType TranslatePlanType(NEW_RESPONSE.PlanType planType)
        {
            switch (planType)
            {
                case NEW_RESPONSE.PlanType.ind:
                    return WirelessAccountType.Individual;
                case NEW_RESPONSE.PlanType.fam:
                    return WirelessAccountType.Family;
                case NEW_RESPONSE.PlanType.mbp:
                case NEW_RESPONSE.PlanType.pgo:
                case NEW_RESPONSE.PlanType.all:
                case NEW_RESPONSE.PlanType.dly:
                    return WirelessAccountType.Undefined;
                default:
                    return WirelessAccountType.Undefined;
            }
        }

        /// <summary>The translate ptn status.</summary>
        /// <param name="status">The status.</param>
        /// <returns>The <see cref="AccountStatusCode"/>.</returns>
        private AccountStatusCode TranslatePtnStatus(NEW_RESPONSE.PTNStatus status)
        {
            switch (status)
            {
                case NEW_RESPONSE.PTNStatus.ACTIVE:
                    return AccountStatusCode.Operational;
                case NEW_RESPONSE.PTNStatus.CANCELLED:
                    return AccountStatusCode.Cancelled;
                case NEW_RESPONSE.PTNStatus.SUSPENDED:
                    return AccountStatusCode.Suspended;
                default:
                    return AccountStatusCode.Unknown;
            }
        }

        #endregion
    }
}