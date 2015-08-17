// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ActivateNow.cs" company="">
//   
// </copyright>
// <summary>
//   The activate now.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation
{
    using SprintCSI.Properties;
    using SprintCSI.ServiceImplementation.DTO;

    using WirelessAdvocates.Enum;
    using WirelessAdvocates.ServiceResponse;

    using NEW_REQUEST = SprintCSI.Request;
    using NEW_RESPONSE = SprintCSI.Response;
    using REQUEST = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;
    using RESPONSE = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.response;

    /// <summary>The activate now.</summary>
    public class ActivateNow : OvmBase<ActivateNowRequest, SprintActivateNowResponse>
    {
        #region Fields

        /// <summary>The response.</summary>
        private readonly SprintActivateNowResponse response = new SprintActivateNowResponse();

        #endregion

        #region Public Methods and Operators

        /// <summary>The get response.</summary>
        /// <returns>The <see cref="SprintActivateNowResponse"/>.</returns>
        public override SprintActivateNowResponse GetResponse()
        {
            return this.response;
        }

        /// <summary>The map request.</summary>
        /// <param name="req">The req.</param>
        /// <param name="sprintRequest">The sprint request.</param>
        public override void MapRequest(ActivateNowRequest req, ref REQUEST.ovm sprintRequest)
        {
            // Request Type
            sprintRequest.ovmheader.messagetype = REQUEST.RequestMessageType.ACTIVATE_NOW_REQUEST;
            sprintRequest.ovmrequest.ItemElementName = REQUEST.ItemChoiceType19.activatenowrequest;

            // Make a new map target
            var mappedRequest = new REQUEST.ActivateNowRequest();

            // Set Type of Activity
            mappedRequest.Item1ElementName = REQUEST.Item1ChoiceType3.activatedevice;
            mappedRequest.Item1 = true;

            // Set Device Identifier
            var deviceItems = new string[1];
            deviceItems[0] = req.Meid;
            var deviceItemElementNames = new REQUEST.ItemsChoiceType14[1];
            deviceItemElementNames[0] = REQUEST.ItemsChoiceType14.meid;

            mappedRequest.ItemsElementName = deviceItemElementNames;
            mappedRequest.Items = deviceItems;

            // Set Account Identifier
            mappedRequest.ItemElementName = REQUEST.ItemChoiceType16.sprintorderid;
            mappedRequest.Item = req.SprintOrderId;

            sprintRequest.ovmrequest.Item = mappedRequest;
        }

        /// <summary>The map error code.</summary>
        /// <param name="ovmResponse">The ovm response.</param>
        /// <exception cref="ServiceException"></exception>
        public override void NewMapErrorCode(NEW_RESPONSE.ovm ovmResponse)
        {
            //// OVM will ensure that the device identifier provided is linked to the account identifier. 
            //// OVM will also ensure that the activity requested can be performed.  
            //// The following error conditions can occur during the processing of this transaction:
            //// If the device identifier provided is not linked to an active subscriber then error code 259 will be returned.
            //// If the account number is provided and is not valid then error code 135 will be returned.
            //// If the reference PTN is provided and is not valid then error code 141 will be returned.
            //// If the subscriber Id is provided and is not valid then error code 247 will be returned.
            //// If the device and account provided are not linked together then error code 402 will be returned.
            //// If the request is to activate a reserved subscriber and that subscriber is not in a state that can be activated then error code 247 will be returned.
            //// If the request is to initiate a port in and the subscriber is not in a state to perform this activity then error code 354 will be returned.
            var errorSubCode = ServiceResponseSubCode.ActSuccessfulActivation;

            if (ovmResponse == null || ovmResponse.ovmerrorinfo == null)
            {
                return;
            }

            NEW_RESPONSE.ErrorInfo[] errorInfo = ovmResponse.ovmerrorinfo;

            int sprintErrorCode = int.Parse(ovmResponse.ovmerrorinfo[0].errorcode);
            uint sprintErrorType = errorInfo[0].errortype;

            switch (sprintErrorType)
            {
                case 1:
                    errorSubCode = ServiceResponseSubCode.ACT_UNKNOWN;
                    break;
                case 3:
                case 2:
                    switch (sprintErrorCode)
                    {
                        case 135: // account number is provided and is not valid
                        case 141: // PTN is provided and is not valid
                        case 247: // subscriber is not in a state that can be activated
                        case 259: // device identifier provided is not linked to an active subscriber
                        case 354: // subscriber is not in a state that can be activated
                        case 402: // subscriber is not in a state to initiate a port in
                            errorSubCode = ServiceResponseSubCode.ACT_FAIL;
                            break;

                        default:
                            errorSubCode = ServiceResponseSubCode.ACT_FAIL;
                            break;
                    }

                    break;
            }

            throw new ServiceException("[ActivateNow] returned with error") { ErrorCode = ServiceResponseCode.Success, ServiceResponseSubCode = errorSubCode, NewErrorInfo = ovmResponse.ovmerrorinfo };
        }

        /// <summary>The new map response.</summary>
        /// <param name="ovmResponseType">The ovm response type.</param>
        /// <returns>The <see cref="SprintActivateNowResponse"/>.</returns>
        public override SprintActivateNowResponse NewMapResponse(NEW_RESPONSE.OvmResponseType ovmResponseType)
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
        public override SprintActivateNowResponse NewSetErrorObj(
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
    }
}