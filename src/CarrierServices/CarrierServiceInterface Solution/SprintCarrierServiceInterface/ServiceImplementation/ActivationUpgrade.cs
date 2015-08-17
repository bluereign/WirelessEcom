// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ActivationUpgrade.cs" company="">
//   
// </copyright>
// <summary>
//   The wa activation upgrade request.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation
{
    using System;
    using System.ComponentModel;
    using System.Runtime.CompilerServices;

    using SprintCSI.Properties;
    using SprintCSI.ServiceImplementation.ActivationMappers;
    using SprintCSI.ServiceImplementation.DTO;

    using WirelessAdvocates.Enum;
    using WirelessAdvocates.Extensions;
    using WirelessAdvocates.SalesOrder;

    using NEW_REQUEST = SprintCSI.Request;
    using NEW_RESPONSE = SprintCSI.Response;
    using REQUEST = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;
    using RESPONSE = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.response;
    using System.Configuration;

    /// <summary>The activation impl.</summary>
    public class ActivationUpgrade : OvmBase<ActivationUpgradeRequest, ActivationUpgradeResponse>
    {
        #region Fields

        /// <summary>The response.</summary>
        private readonly ActivationUpgradeResponse response = new ActivationUpgradeResponse();

        #endregion

        #region Public Methods and Operators

        /// <summary>The get response.</summary>
        /// <returns>The <see cref="ActivationUpgradeResponse"/>.</returns>
        /// <exception cref="NotImplementedException"></exception>
        public override ActivationUpgradeResponse GetResponse()
        {
            throw new NotImplementedException();
        }

        /// <summary>The map request.</summary>
        /// <param name="activationUpgradeRequest">The req.</param>
        /// <param name="sprintRequest">The sprint request.</param>
        public override void MapRequest(ActivationUpgradeRequest activationUpgradeRequest, ref REQUEST.ovm sprintRequest)
        {
            sprintRequest.ovmheader.messagetype = REQUEST.RequestMessageType.ACTIVATION_REQUEST;

            // NOTE [pcrawford,20140113] We re-use this order-id across all the calls to activate a line except ActivateReservedDevice
            sprintRequest.ovmheader.orderid = activationUpgradeRequest.TransactionOrderId;

            sprintRequest.ovmrequest.ItemElementName = REQUEST.ItemChoiceType19.activationrequest;

            BaseActivationRequestMapper mapper = this.GetActivationRequestMapper(activationUpgradeRequest);
            mapper.CustType = this.CustType;
            REQUEST.ActivationRequest mappedRequest = mapper.MapRequest(activationUpgradeRequest);

            mappedRequest.agentcode = ConfigurationManager.AppSettings["Agent-Code"];

            // validate mapped request (unique to activation)
            mapper.ValidateMappedRequest(activationUpgradeRequest, mappedRequest);
            this.response.Mdn = activationUpgradeRequest.Mdn;
            sprintRequest.ovmrequest.Item = mappedRequest;
        }

        /// <summary>The new map response.</summary>
        /// <param name="ovmResponse">The ovm response.</param>
        /// <returns>The <see cref="ActivationUpgradeResponse"/>.</returns>
        /// <exception cref="ServiceException"></exception>
        public override ActivationUpgradeResponse NewMapResponse(NEW_RESPONSE.OvmResponseType ovmResponse)
        {
            // Preserve the request XML to use as template for replace
            this.response.RequestXml = this.RequestXmlHelper.XmlString;

            NEW_RESPONSE.ActivationResponse sprintActivationResponse;

            // All this means is that there was a response from Sprint
            this.response.ErrorCode = (int)ServiceResponseCode.Success;

            // TODO [pcrawford,20131002] This Try/Catch pattern needs to be implemented across the service
            try
            {
                sprintActivationResponse = (NEW_RESPONSE.ActivationResponse)ovmResponse.Item;
            }
            catch (InvalidCastException)
            {
                this.SetParseResponseErrorFields();
                return this.response;
            }

            var activationResponsePlan = (NEW_RESPONSE.ActivationResponsePlan)sprintActivationResponse.service[0];

            NEW_RESPONSE.PhoneResponse phone = activationResponsePlan.phone[0];

            this.response.ActivationResult = phone.result.ToString();

            switch (this.response.ActivationResult)
            {
                case "SUCCESS":
                    this.response.SubscriberId = phone.subscriberid;

                    // first use of XDocument to obtain XML value
                    this.response.Meid = this.ResponseXmlHelper.GetXmlValue(Resources.activationMeid);

                    this.response.Msid = phone.msid;
                    this.response.MasterLockCode = phone.masterlockcode;
                    this.response.ActivationFeeForHandset = phone.activationfeeforhandset;
                    this.response.MeidHex = phone.meidhex;
                    this.response.ActivationFeeForHandset = phone.activationfeeforhandset;
                    this.response.ActivationFee = sprintActivationResponse.activationfee;
                    this.response.AccountNumber = sprintActivationResponse.accountnumber;
                    this.response.SprintOrderId = sprintActivationResponse.sprintorderid;

                    this.response.ServiceResponseSubCode = (int)ServiceResponseSubCode.ActSuccessfulActivation;
                    this.response.ErrorCode = (int)ServiceResponseCode.Success;
                    this.response.ActivationStatus = ActivationStatus.Success;
                    break;
                case "FAILED":
                case "CANCELLED":
                case "NOT_VALIDATED":
                case "VALID":
                case "INVALID_IMEI":
                case "INVALID_SIM":
                case "ACTIVE_IMEI":
                case "ACTIVE_SIM":
                case "NEGATIVE_IMEI":
                case "NEGATIVE_SIM":
                case "INVALID_EQUIP":
                case "RATE_CENTER_MISMATCH":
                case "INVALID_ESN":
                case "NEGATIVE_ESN":
                case "ACTIVE_ESN":
                    this.SetResponseErrorFields();
                    break;
                default:
                    this.SetResponseErrorFields();
                    break;
            }

            return this.response;
        }

        /// <summary>The new set error obj.</summary>
        /// <param name="errorCode">The error code.</param>
        /// <param name="subErrorCode">The sub error code.</param>
        /// <param name="primaryErrorMessage">The primary error message.</param>
        /// <param name="errorInfo">The error info.</param>
        /// <returns>The <see cref="ActivationUpgradeResponse"/>.</returns>
        public override ActivationUpgradeResponse NewSetErrorObj(
            ServiceResponseCode errorCode, 
            ServiceResponseSubCode subErrorCode, 
            string primaryErrorMessage, 
            NEW_RESPONSE.ErrorInfo[] errorInfo = null)
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

        #endregion

        #region Methods

        /// <summary>The get activation request mapper.</summary>
        /// <param name="order">The order.</param>
        /// <returns>The <see cref="BaseActivationRequestMapper"/>.</returns>
        /// <exception cref="NotImplementedException"></exception>
        private BaseActivationRequestMapper GetActivationRequestMapper(WirelessOrder order)
        {
            switch (order.ActivationType)
            {
                case 'N':

                    // new
                    return new NewActivationRequestMapper(this.ReferenceNumber);

                case 'A':

                    // add-a-line
                    return new AddOnActivationRequestMapper(this.ReferenceNumber);

                case 'U':

                    // upgrade
                    return new UpgradeActivationRequestMapper(this.ReferenceNumber);

                case 'R':

                    // replace
                    return new ReplaceActivationRequestMapper(this.ReferenceNumber);

                case 'E': // exchange 
                    break;
            }

            throw new NotImplementedException(string.Format("Unknown OrderType {0} encountered in ActivationUpgrade.GetActivationRequestMapper", order.ActivationType));
        }

        /// <summary>The set common error fields.</summary>
        private void SetCommonErrorFields()
        {
            this.response.ServiceResponseSubCodeEnum = ServiceResponseSubCode.ACT_FAIL;
            this.response.ServiceResponseSubCode = (int)this.response.ServiceResponseSubCodeEnum;
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
            this.response.CallerMemberName = string.Format("{0}.{1}", typeof(ActivationUpgrade), caller);
            this.response.CallerLineNumber = sourceLineNumber;

            this.response.PrimaryErrorMessage = this.ResponseXmlHelper.GetXmlValue(Resources.parseResponseDetails);
            this.response.PrimaryErrorMessageLong = this.response.PrimaryErrorMessage;
            this.response.SprintErrorCodeName = this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorDetails);
            this.SetCommonErrorFields();
        }

        /// <summary>The set response error fields.</summary>
        /// <param name="caller">The caller.</param>
        /// <param name="sourceLineNumber">The source line number.</param>
        private void SetResponseErrorFields([CallerMemberName] string caller = null, [CallerLineNumber] int sourceLineNumber = 0)
        {
            this.response.CallerMemberName = string.Format("{0}.{1}", typeof(ActivationUpgrade), caller);
            this.response.CallerLineNumber = sourceLineNumber;

            this.response.PrimaryErrorMessage = this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorDetails);
            this.response.PrimaryErrorMessageLong = this.response.PrimaryErrorMessage;
            this.response.SprintErrorCodeName = this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorSubName);
            this.SetCommonErrorFields();
        }

        #endregion
    }
}