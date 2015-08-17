// --------------------------------------------------------------------------------------------------------------------
// <copyright file="AuthenticationResend.cs" company="">
//   
// </copyright>
// <summary>
//   The authentication resend impl.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation
{
    using System;
    using System.Collections.Generic;
    using System.Runtime.CompilerServices;

    using SprintCSI.Response;
    using SprintCSI.ServiceImplementation.DTO;

    using WirelessAdvocates.Enum;

    using REQUEST = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;
    using RESPONSE = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.response;

    /// <summary>The authentication resend impl.</summary>
    public class AuthenticationResend : OvmBase<DTOAuthenticationRequest, DTOAuthenticationResponse>
    {
        #region Fields

        /// <summary>The response.</summary>
        private readonly DTOAuthenticationResponse response = new DTOAuthenticationResponse();

        #endregion

        #region Public Methods and Operators

        /// <summary>The get response.</summary>
        /// <returns>The <see cref="DTOAuthenticationResponse"/>.</returns>
        public override DTOAuthenticationResponse GetResponse()
        {
            return this.response;
        }

        /// <summary>The map error code.</summary>
        /// <param name="ovmResponse">The ovm response.</param>
        /// <exception cref="ServiceException"></exception>
        public override void MapErrorCode(RESPONSE.ovm ovmResponse)
        {
            if (ovmResponse == null || ovmResponse.ovmerrorinfo == null)
            {
                return;
            }

            RESPONSE.ErrorInfo[] errorInfo = ovmResponse.ovmerrorinfo;

            ServiceResponseSubCode errorSubCode;

            if (errorInfo.Length <= 0)
            {
                throw new ServiceException { ErrorCode = ServiceResponseCode.Success, ServiceResponseSubCode = ServiceResponseSubCode.CL_CUSTOMER_FOUND, ErrorInfo = errorInfo };
            }

            int sprintErrorCode = int.Parse(errorInfo[0].errorcode);

            // uint sprintErrorType = errorInfo[0].errortype;
            switch (sprintErrorCode)
            {
                case 246:
                    errorSubCode = ServiceResponseSubCode.ClCustomerNotFound;
                    break;
                case 220: // request time out
                case 358: // system error
                    errorSubCode = ServiceResponseSubCode.CC_STATUS_UNKNOWN;
                    break;
                case 324:
                    errorSubCode = ServiceResponseSubCode.CL_ACCOUNT_LOCKED;
                    break;
                case 322:
                    errorSubCode = ServiceResponseSubCode.CL_ACCOUNT_NOPIN;
                    break;
                case 140:
                    errorSubCode = ServiceResponseSubCode.CC_ACCOUNT_DELINQUENT;
                    break;
                default:
                    errorSubCode = ServiceResponseSubCode.ClCustomerNotFound;
                    break;
            }

            throw new ServiceException { ErrorCode = ServiceResponseCode.Success, ServiceResponseSubCode = errorSubCode, ErrorInfo = errorInfo };
        }

        /// <summary>The map request.</summary>
        /// <param name="req">The req.</param>
        /// <param name="sprintRequest">The sprint request.</param>
        public override void MapRequest(DTOAuthenticationRequest req, ref REQUEST.ovm sprintRequest)
        {
            sprintRequest.ovmheader.messagetype = REQUEST.RequestMessageType.AUTHENTICATE_RESEND_PIN_REQUEST;

            var theRequest = new REQUEST.AuthenticationResendPinRequest { Item = req.MDN, ItemElementName = REQUEST.ItemChoiceType8.referenceptn };

            var itemValues = new List<object>();
            var itemTypes = new List<REQUEST.ItemsChoiceType4> { REQUEST.ItemsChoiceType4.resendpin };

            // itemTypes.Add(REQUEST.ItemsChoiceType4.authenticatecustomer);

            // itemTypes.Add(REQUEST.ItemsChoiceType4.secanswer);
            // itemTypes.Add(REQUEST.ItemsChoiceType4.secpin);

            // itemValues.Add(true);
            itemValues.Add(true);

            theRequest.Items = itemValues.ToArray();
            theRequest.ItemsElementName = itemTypes.ToArray();

            sprintRequest.ovmrequest.Item = theRequest;
            sprintRequest.ovmrequest.ItemElementName = REQUEST.ItemChoiceType19.authenticateresendpinrequest;
        }

        /// <summary>The map response.</summary>
        /// <param name="ovmResponseType">The ovm response type.</param>
        /// <returns>The <see cref="DTOAuthenticationResponse"/>.</returns>
        public override DTOAuthenticationResponse MapResponse(RESPONSE.OvmResponseType ovmResponseType)
        {
            var dtoAuthenticationResponse = new DTOAuthenticationResponse { ErrorCode = (int)ServiceResponseCode.Success, ServiceResponseSubCode = (int)ServiceResponseSubCode.CL_CUSTOMER_FOUND };

            if (ovmResponseType != null && ovmResponseType.Item is RESPONSE.AuthenticationResendPinResponse)
            {
                var resp = ovmResponseType.Item as RESPONSE.AuthenticationResendPinResponse;

                dtoAuthenticationResponse.ErrorCode = (int)ServiceResponseCode.Success;
                dtoAuthenticationResponse.ServiceResponseSubCode = (int)ServiceResponseSubCode.CL_CUSTOMER_FOUND;

                RESPONSE.Notification notificationMethod = resp.notification[0];
                RESPONSE.NotificationNotificationmethod method = notificationMethod.notificationmethod;

                dtoAuthenticationResponse.NotificationMethod = method.ToString();
                dtoAuthenticationResponse.ResendSuccess = true;
            }

            return dtoAuthenticationResponse;
        }

        /// <summary>The new map error code.</summary>
        /// <param name="ovmResponse">The ovm response.</param>
        /// <exception cref="NotImplementedException"></exception>
        public override void NewMapErrorCode(ovm ovmResponse)
        {
            throw new NotImplementedException();
        }

        /// <summary>The new map request.</summary>
        /// <param name="req">The req.</param>
        /// <param name="sprintRequest">The sprint request.</param>
        /// <exception cref="NotImplementedException"></exception>
        public override void NewMapRequest(DTOAuthenticationRequest req, ref Request.ovm sprintRequest)
        {
            throw new NotImplementedException();
        }

        /// <summary>The new map response.</summary>
        /// <param name="ovmresponseType">The ovmresponse type.</param>
        /// <returns>The <see cref="DTOAuthenticationResponse"/>.</returns>
        /// <exception cref="NotImplementedException"></exception>
        public override DTOAuthenticationResponse NewMapResponse(OvmResponseType ovmresponseType)
        {
            throw new NotImplementedException();
        }

        /// <summary>The new set error obj.</summary>
        /// <param name="errorCode">The error code.</param>
        /// <param name="subErrorCode">The sub error code.</param>
        /// <param name="primaryErrorMessage">The primary error message.</param>
        /// <param name="errorInfo">The error info.</param>
        /// <returns>The <see cref="DTOAuthenticationResponse"/>.</returns>
        /// <exception cref="NotImplementedException"></exception>
        public override DTOAuthenticationResponse NewSetErrorObj(ServiceResponseCode errorCode, ServiceResponseSubCode subErrorCode, string primaryErrorMessage, ErrorInfo[] errorInfo = null)
        {
            throw new NotImplementedException("Authentication Resend.NewSetErrorObj not implemented");
        }

        /// <summary>The set error obj.</summary>
        /// <param name="errorCode">The error code.</param>
        /// <param name="subErrorCode">The sub error code.</param>
        /// <param name="primaryErrorMessage">The primary error message.</param>
        /// <param name="errorInfo">The error info</param>
        /// <returns>The <see cref="DTOAuthenticationResponse"/>.</returns>
        public override DTOAuthenticationResponse SetErrorObj(ServiceResponseCode errorCode, ServiceResponseSubCode subErrorCode, string primaryErrorMessage, RESPONSE.ErrorInfo[] errorInfo = null)
        {
            DTOAuthenticationResponse dtoAuthenticationResponse;
            if (errorInfo != null)
            {
                string errorText = this.GetSprintResponseAdvice(errorInfo);
                dtoAuthenticationResponse = new DTOAuthenticationResponse
                                                {
                                                    ErrorCode = (int)errorCode, 
                                                    ServiceResponseSubCode = (int)subErrorCode, 
                                                    PrimaryErrorMessage = primaryErrorMessage, 
                                                    PrimaryErrorMessageLong = primaryErrorMessage, 
                                                    SprintErrorCode = Convert.ToInt32(errorInfo[0].errorcode), 
                                                    SprintResponseMessage = errorInfo[0].errordetails, 
                                                    SprintResponseAdvice = errorText
                                                };
            }
            else
            {
                dtoAuthenticationResponse = new DTOAuthenticationResponse
                                                {
                                                    ErrorCode = (int)errorCode, 
                                                    ServiceResponseSubCode = (int)subErrorCode, 
                                                    PrimaryErrorMessage = primaryErrorMessage, 
                                                    PrimaryErrorMessageLong = primaryErrorMessage, 
                                                };
            }

            // For parsing error return the parsing information saved already in the class variable
            return this.ParseResponse != null ? this.response : dtoAuthenticationResponse;
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
            throw new NotImplementedException("HandleInvalidCast called by " + caller + "at " + sourceLineNumber);
        }

        /// <summary>The new handle invalid cast.</summary>
        /// <param name="ovmresponseType">The ovmresponse type.</param>
        /// <param name="caller">The caller.</param>
        /// <param name="sourceLineNumber">The source line number.</param>
        /// <exception cref="NotImplementedException"></exception>
        protected override void NewHandleInvalidCast(OvmResponseType ovmresponseType, string caller = null, int sourceLineNumber = 0)
        {
            throw new NotImplementedException("NewHandleInvalidCast called by " + caller + "at " + sourceLineNumber);
        }

        /// <summary>The validate request.</summary>
        /// <param name="request">The request.</param>
        /// <param name="caller">The caller.</param>
        /// <param name="sourceLineNumber">The source line number.</param>
        /// <exception cref="ServiceException"></exception>
        protected override void ValidateRequest(DTOAuthenticationRequest request, [CallerMemberName] string caller = null, [CallerLineNumber] int sourceLineNumber = 0)
        {
            if (request == null)
            {
                throw new ServiceException("Invalid Request.") { ErrorCode = ServiceResponseCode.Success, ServiceResponseSubCode = ServiceResponseSubCode.CCError, };
            }

            // ref number 
            if (string.IsNullOrEmpty(request.ReferenceNo) || (request.ReferenceNo.Length > 24))
            {
                throw new ServiceException("Invalid Reference Number.") { ErrorCode = ServiceResponseCode.Success, ServiceResponseSubCode = ServiceResponseSubCode.CCError, };
            }

            // phone number
            if (string.IsNullOrEmpty(request.MDN) || request.MDN.Length < 7 || request.MDN.Length > 10)
            {
                throw new ServiceException("Invalid Phone Number.") { ErrorCode = ServiceResponseCode.Success, ServiceResponseSubCode = ServiceResponseSubCode.CCError, };
            }
        }

        #endregion
    }
}