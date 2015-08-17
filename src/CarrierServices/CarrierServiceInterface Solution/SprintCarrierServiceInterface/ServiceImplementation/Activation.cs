// --------------------------------------------------------------------------------------------------------------------
// <copyright file="Activation.cs" company="">
//   
// </copyright>
// <summary>
//   The wa activation request.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation
{
    using System;
    using System.ComponentModel;
    using System.Runtime.CompilerServices;

    using SprintCSI.Properties;
    using SprintCSI.Response;
    using SprintCSI.ServiceImplementation.ActivationMappers;

    using WirelessAdvocates.Enum;
    using WirelessAdvocates.Extensions;
    using WirelessAdvocates.SalesOrder;

    using DTOActivationRequest = SprintCSI.ServiceImplementation.DTO.ActivationRequest;
    using DTOActivationResponse = SprintCSI.ServiceImplementation.DTO.ActivationResponse;
    using REQUEST = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;
    using RESPONSE = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.response;
    using System.Configuration;

    /// <summary>The activation impl.</summary>
    public class Activation : OvmBase<DTOActivationRequest, DTOActivationResponse>
    {
        #region Fields

        /// <summary>The response.</summary>
        private readonly DTOActivationResponse response = new DTOActivationResponse();

        #endregion

        #region Public Methods and Operators

        /// <summary>The get response.</summary>
        /// <returns>The <see cref="ActivationResponse"/>.</returns>
        public override DTOActivationResponse GetResponse()
        {
            return this.response;
        }

        /// <summary>The map request.</summary>
        /// <param name="activationRequest">The req.</param>
        /// <param name="sprintRequest">The sprint request.</param>
        public override void MapRequest(DTOActivationRequest activationRequest, ref REQUEST.ovm sprintRequest)
        {
            sprintRequest.ovmheader.messagetype = REQUEST.RequestMessageType.ACTIVATION_REQUEST;

            // NOTE [pcrawford,20140113] We re-use this order-id across all the calls to activate a line except ActivateReservedDevice
            sprintRequest.ovmheader.orderid = activationRequest.TransactionOrderId;

            sprintRequest.ovmrequest.ItemElementName = REQUEST.ItemChoiceType19.activationrequest;

            BaseActivationRequestMapper mapper = this.GetActivationRequestMapper(activationRequest);
            mapper.CustType = this.CustType;
            REQUEST.ActivationRequest mappedRequest = mapper.MapRequest(activationRequest);

            mappedRequest.agentcode = ConfigurationManager.AppSettings["Agent-Code"];

            // validate mapped request (unique to activation)
            mapper.ValidateMappedRequest(activationRequest, mappedRequest);

            sprintRequest.ovmrequest.Item = mappedRequest;
        }

        /// <summary>The map response.</summary>
        /// <param name="ovmResponseType">The ovm response type.</param>
        /// <returns>The <see cref="ActivationResponse"/>.</returns>
        public override DTOActivationResponse MapResponse(RESPONSE.OvmResponseType ovmResponseType)
        {
            var activationResponse = new DTOActivationResponse();
            activationResponse.ErrorCode = (int)ServiceResponseCode.Success;
            return activationResponse;
        }

        /// <summary>The new map error code.</summary>
        /// <param name="ovmResponse">The ovm response.</param>
        /// <exception cref="NotImplementedException"></exception>
        public override void NewMapErrorCode(ovm ovmResponse)
        {
            throw new NotImplementedException("NewMapErrorCode");
        }

        /// <summary>The new map request.</summary>
        /// <param name="req">The req.</param>
        /// <param name="sprintRequest">The sprint request.</param>
        /// <exception cref="NotImplementedException"></exception>
        public override void NewMapRequest(DTOActivationRequest req, ref Request.ovm sprintRequest)
        {
            throw new NotImplementedException("NewMapRequest");
        }

        /// <summary>The new map response.</summary>
        /// <param name="ovmresponseType">The ovmresponse type.</param>
        /// <returns>The <see cref="ActivationResponse"/>.</returns>
        /// <exception cref="NotImplementedException"></exception>
        public override DTOActivationResponse NewMapResponse(OvmResponseType ovmresponseType)
        {
            throw new NotImplementedException("NewMapResponse");
        }

        /// <summary>The new set error obj.</summary>
        /// <param name="errorCode">The error code.</param>
        /// <param name="subErrorCode">The sub error code.</param>
        /// <param name="primaryErrorMessage">The primary error message.</param>
        /// <param name="errorInfo">The error info.</param>
        /// <returns>The <see cref="ActivationResponse"/>.</returns>
        /// <exception cref="NotImplementedException"></exception>
        public override DTOActivationResponse NewSetErrorObj(ServiceResponseCode errorCode, ServiceResponseSubCode subErrorCode, string primaryErrorMessage, ErrorInfo[] errorInfo = null)
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
        protected override void NewHandleInvalidCast(OvmResponseType ovmresponseType, string caller = null, int sourceLineNumber = 0)
        {
            throw new NotImplementedException("NewHandleInvalidCast");
        }

        /// <summary>The get activation request mapper.</summary>
        /// <param name="order">The order.</param>
        /// <returns>The <see cref="BaseActivationRequestMapper"/>.</returns>
        /// <exception cref="NotImplementedException"></exception>
        private BaseActivationRequestMapper GetActivationRequestMapper(WirelessOrder order)
        {
            switch (order.ActivationType)
            {
                case 'N':
                    {
                        // new
                        return new NewActivationRequestMapper(this.ReferenceNumber);
                    }

                case 'A':
                    {
                        // add-a-line
                        return new AddOnActivationRequestMapper(this.ReferenceNumber);
                    }

                case 'U':
                    {
                        // upgrade
                        return new UpgradeActivationRequestMapper(this.ReferenceNumber);
                    }

                case 'E': // exchange 
                    break;
            }

            throw new NotImplementedException("GetActivationRequestMapper");
        }

        /// <summary>The set common error fields.</summary>
        private void SetCommonErrorFields()
        {
            this.response.PrimaryErrorMessage = this.response.PrimaryErrorMessageLong;
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
            this.response.CallerMemberName = string.Format("{0}.{1}", typeof(Activation), caller);
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
            this.response.CallerMemberName = string.Format("{0}.{1}", typeof(Activation), caller);
            this.response.CallerLineNumber = sourceLineNumber;

            this.response.PrimaryErrorMessageLong = this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorDetails);
            this.response.SprintErrorCodeName = this.ResponseXmlHelper.GetXmlValue(Resources.ovmErrorSubName);
            this.SetCommonErrorFields();
        }

        #endregion
    }
}