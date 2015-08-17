// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ActivateReservedDevice.cs" company="">
//   
// </copyright>
// <summary>
//   The activate reserved device.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation
{
    using System;
    using System.ComponentModel;
    using System.Runtime.CompilerServices;

    using SprintCSI.Properties;
    using SprintCSI.ServiceImplementation.DTO;

    using WirelessAdvocates.Enum;
    using WirelessAdvocates.Extensions;
    using WirelessAdvocates.ServiceResponse;

    using NEW_REQUEST = SprintCSI.Request;
    using NEW_RESPONSE = SprintCSI.Response;
    using REQUEST = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;
    using RESPONSE = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.response;

    /// <summary>The activate reserved device.</summary>
    public class ActivateReservedDevice : OvmBase<ActivateReservedDeviceRequest, SprintActivateReservedDeviceResponse>
    {
        #region Fields

        /// <summary>The response.</summary>
        private readonly SprintActivateReservedDeviceResponse response = new SprintActivateReservedDeviceResponse();

        #endregion

        #region Public Methods and Operators

        /// <summary>The get response.</summary>
        /// <returns>The <see cref="SprintActivateReservedDeviceResponse"/>.</returns>
        public override SprintActivateReservedDeviceResponse GetResponse()
        {
            return this.response;
        }

        /// <summary>The map request.</summary>
        /// <param name="req">The req.</param>
        /// <param name="sprintRequest">The sprint request.</param>
        public override void MapRequest(ActivateReservedDeviceRequest req, ref REQUEST.ovm sprintRequest)
        {
            // Request Type
            sprintRequest.ovmheader.messagetype = REQUEST.RequestMessageType.ACTIVATE_RESERVED_DEVICE_REQUEST;
            sprintRequest.ovmrequest.ItemElementName = REQUEST.ItemChoiceType19.activatereserveddevicerequest;

            // NOTE [pcrawford,20140106]  Per Sprint: "The order id on this transaction MUST be unique and cannot match the order id submitted with the activation." 
            sprintRequest.ovmheader.orderid = this.AddRandomValue(sprintRequest.ovmheader.orderid);

            // Make a new map target
            var mappedRequest = new REQUEST.ActivateReservedDeviceRequest();

            // Set Device Identifier
            var deviceItems = new string[1];
            deviceItems[0] = req.Mdn;
            mappedRequest.ptnlist = deviceItems;

            // Set Sprint Order Id
            mappedRequest.ItemElementName = REQUEST.ItemChoiceType12.sprintorderid;
            mappedRequest.Item = req.SprintOrderId;

            sprintRequest.ovmrequest.Item = mappedRequest;
        }

        /// <summary>The map error code.</summary>
        /// <param name="ovmResponse">The ovm response.</param>
        /// <exception cref="ServiceException"></exception>
        public override void NewMapErrorCode(NEW_RESPONSE.ovm ovmResponse)
        {
            this.response.ServiceResponseSubCode = (int)ServiceResponseSubCode.ActSuccessfulActivation;

            if (this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorInfo) == null)
            {
                return;
            }

            this.SetResponseErrorFields();

            int tryInt;
            int.TryParse(this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorCode), out tryInt);
            this.response.SprintErrorCode = tryInt;

            string sprintErrorType = this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorType);

            switch (sprintErrorType)
            {
                case "1":
                    this.response.ServiceResponseSubCode = (int)ServiceResponseSubCode.ACT_UNKNOWN;
                    break;
                case "3":
                case "2":
                    switch (this.response.SprintErrorCode)
                    {
                        default:
                            this.response.ServiceResponseSubCode = (int)ServiceResponseSubCode.ACT_FAIL;
                            break;
                    }

                    break;
            }
        }

        /// <summary>The new map response.</summary>
        /// <param name="ovmResponseType">The ovm response type.</param>
        /// <returns>The <see cref="SprintActivateNowResponse"/>.</returns>
        public override SprintActivateReservedDeviceResponse NewMapResponse(NEW_RESPONSE.OvmResponseType ovmResponseType)
        {
            this.response.ServiceResponseSubCode = (int)ServiceResponseSubCode.ACT_REQUESTED;
            if (this.ResponseXmlHelper.GetXmlValue(Resources.activateNowSuccess) == Resources.activateNowSucceeded)
            {
                this.response.ErrorCode = (int)ServiceResponseCode.Success;
            }

            this.response.ErrorCode = (int)ServiceResponseCode.Success;
            return this.response;
        }

        /// <summary>The set error obj.</summary>
        /// <param name="errorCode">The error code.</param>
        /// <param name="subErrorCode">The sub error code.</param>
        /// <param name="primaryErrorMessage">The primary error message.</param>
        /// <param name="errorInfo">The error info</param>
        /// <returns>The <see cref="NpaResponse"/>.</returns>
        public override SprintActivateReservedDeviceResponse NewSetErrorObj(
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
            this.response.PrimaryErrorMessageLong = primaryErrorMessage;
            this.response.SprintResponseAdvice = this.GetSprintResponseAdvice(errorInfo);

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

            this.response.PrimaryErrorMessage = this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorDetails);
            this.response.PrimaryErrorMessageLong = this.response.PrimaryErrorMessage;
            this.response.SprintErrorCodeName = this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorSubName);
            this.SetCommonErrorFields();
        }

        #endregion
    }
}