// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ActivationReplace.cs" company="">
//   
// </copyright>
// <summary>
//   The validate address request.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCSI.ServiceImplementation
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Linq;
    using System.Runtime.CompilerServices;
    using System.Xml.Linq;

    using SprintCSI.Properties;
    using SprintCSI.ServiceImplementation.DTO;
    using SprintCSI.Utils;

    using WirelessAdvocates.Enum;
    using WirelessAdvocates.Extensions;

    using NEW_REQUEST = SprintCSI.Request;
    using NEW_RESPONSE = SprintCSI.Response;
    using REQUEST = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;
    using RESPONSE = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.response;

    /// <summary>The upgrade replace.</summary>
    public class ActivationReplace : OvmXmlBase<ActivationReplaceRequest, ActivationReplaceResponse>
    {
        #region Fields

        /// <summary>The response.</summary>
        private readonly ActivationReplaceResponse response = new ActivationReplaceResponse();

        #endregion

        #region Public Methods and Operators

        /// <summary>The map request.</summary>
        /// <param name="activationReplaceRequest">The activation replace request.</param>
        public override void MapRequest(ActivationReplaceRequest activationReplaceRequest)
        {
            this.RequestXmlHelper = new XmlHelper { XmlString = activationReplaceRequest.ActivationRequestXml };
            this.RequestXmlHelper.SetOrderTypeToReplace();

            // Set the order-id to the last CheckCreditExisting Account value
            this.RequestXmlHelper.SetXmlValue(Resources.ovmOrderId, activationReplaceRequest.TransactionOrderId);

            var subscriberXmlHelper = this.GetSubscriberInfo(activationReplaceRequest.SprintCustomerInquiryResponseXml);

            var pricePlanCode = subscriberXmlHelper.GetXmlValue(Resources.accountValidationResponsePricePlanCode);
            this.RequestXmlHelper.SetXmlValue(Resources.activationRequestCode, pricePlanCode);

            var serialNumber = subscriberXmlHelper.GetXmlValue(Resources.accountValidationResponseSerialNumber);
            this.RequestXmlHelper.SetXmlValue(Resources.activationRequestMeid, serialNumber);

            var iccId = subscriberXmlHelper.GetXmlValue(Resources.activationRequestIccId);
            if (iccId == null)
            {
                this.RequestXmlHelper.DeleteElement(Resources.activationRequestIccId);
            }
            else
            {
                this.RequestXmlHelper.SetXmlValue(Resources.activationRequestIccId, iccId);
            }

            this.RequestXmlHelper.DeleteElement(Resources.activationRequestFeature);

            var options = subscriberXmlHelper.GetXmlValues(Resources.accountValidationResponseOption);

            var query = from option in options
                                        where subscriberXmlHelper.GetXmlValue(option, Resources.accountValidationResponseOptionPrice) != "0.0"
                                        select subscriberXmlHelper.GetXmlValue(option, Resources.accountValidationResponseOptionCode);

            var optionsToBeAdded = query.ToList();
            foreach (var optionToBeAdded in optionsToBeAdded)
            {
                this.RequestXmlHelper.InsertNewFeatureCode(optionToBeAdded);
            }

            this.RequestXmlHelper.SetXmlValue(Resources.activationRequestServiceAgreement, "0");
        }

        /// <summary>The new map response.</summary>
        /// <param name="ovmResponse">The ovm Response.</param>
        /// <returns>The <see cref="ActivationReplaceResponse"/>.</returns>
        /// <exception cref="NotImplementedException"></exception>
        public override ActivationReplaceResponse NewMapResponse(NEW_RESPONSE.OvmResponseType ovmResponse)
        {
            NEW_RESPONSE.ActivationResponse sprintActivationResponse;

            // var activationUpgradeResponse = new ActivationResponse(); 
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

            var phone = activationResponsePlan.phone[0];

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
        /// <returns>The <see cref="ActivationReplaceResponse"/>.</returns>
        /// <exception cref="NotImplementedException"></exception>
        public override ActivationReplaceResponse NewSetErrorObj(
            ServiceResponseCode errorCode, 
            ServiceResponseSubCode subErrorCode, 
            string primaryErrorMessage, 
            NEW_RESPONSE.ErrorInfo[] errorInfo = null)
        {
            throw new NotImplementedException("ActivationReplace.NewSetErrorObj not implemented");
        }

        #endregion

        #region Methods

        /// <summary>The get subscriber info.</summary>
        /// <param name="sprintCustomerInquiryResponseXml">The sprint customer inquiry response xml.</param>
        /// <returns>The <see cref="XmlHelper"/>.</returns>
        private XmlHelper GetSubscriberInfo(string sprintCustomerInquiryResponseXml)
        {
            var inquiryXMLHelper = new XmlHelper { XmlString = sprintCustomerInquiryResponseXml };

            var subscribers = inquiryXMLHelper.GetXmlValues("subscriber");

            var subscriberXmlHelper = new XmlHelper();

            var requestPtn = this.RequestXmlHelper.GetXmlValue("reference-ptn");

            foreach (var subscriber in subscribers)
            {
                subscriberXmlHelper = new XmlHelper { XmlString = subscriber.ToString() };
                var subscriberPtn = subscriberXmlHelper.GetXmlValue("ptn");
                if (subscriberPtn != requestPtn)
                {
                    continue;
                }

                break;
            }

            return subscriberXmlHelper;
        }

        /// <summary>The set common error fields.</summary>
        private void SetCommonErrorFields()
        {
            this.response.PrimaryErrorMessage = this.response.PrimaryErrorMessageLong;
            this.response.ServiceResponseSubCodeEnum = ServiceResponseSubCode.ACT_FAIL;
            this.response.ServiceResponseSubCode = (int)this.response.ServiceResponseSubCodeEnum;
            this.response.ErrorCodeEnum = ServiceResponseCode.Success;
            this.response.ErrorCode = (int)this.response.ErrorCodeEnum;

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