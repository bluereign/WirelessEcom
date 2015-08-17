// --------------------------------------------------------------------------------------------------------------------
// <copyright file="NpaNxx.cs" company="">
//   
// </copyright>
// <summary>
//   The npa request.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation
{
    using System;
    using System.ComponentModel;
    using System.Runtime.CompilerServices;

    using SprintCSI.Properties;
    using SprintCSI.Response;
    using SprintCSI.ServiceImplementation.DTO;

    using WirelessAdvocates;
    using WirelessAdvocates.Enum;
    using WirelessAdvocates.Extensions;
    using WirelessAdvocates.ServiceResponse;

    using NEW_REQUEST = SprintCSI.Request;
    using NEW_RESPONSE = SprintCSI.Response;
    using REQUEST = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;
    using RESPONSE = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.response;


    /// <summary>The npa nxx impl.</summary>
    public class NpaNxx : OvmBase<NpaRequest, SprintNpaResponse>
    {
        #region Fields

        /// <summary>The response.</summary>
        private readonly SprintNpaResponse response = new SprintNpaResponse();

        #endregion

        #region Public Methods and Operators

        /// <summary>The map error code.</summary>
        /// <param name="ovmResponse">The ovm response.</param>
        /// <exception cref="ServiceException"></exception>
        public override void MapErrorCode(RESPONSE.ovm ovmResponse)
        {
            throw new NotImplementedException("Called Deprecated MapResponse");
        }

        /// <summary>The map request.</summary>
        /// <param name="req">The req.</param>
        /// <param name="sprintRequest">The sprint request.</param>
        public override void MapRequest(NpaRequest req, ref REQUEST.ovm sprintRequest)
        {
            sprintRequest.ovmheader.messagetype = REQUEST.RequestMessageType.NPA_NXX_REQUEST;
            sprintRequest.ovmrequest.Item = new REQUEST.NpaNxxRequest { activationzipcode = req.Zip };
            sprintRequest.ovmrequest.ItemElementName = REQUEST.ItemChoiceType19.npanxxrequest;
        }

        /// <summary>The map response.</summary>
        /// <param name="ovmResponseType">The ovm response type.</param>
        /// <returns>The <see cref="NpaResponse"/>.</returns>
        public override SprintNpaResponse MapResponse(RESPONSE.OvmResponseType ovmResponseType)
        {
            throw new NotImplementedException("Called Deprecated MapResponse");
        }

        /// <summary>The get response.</summary>
        /// <returns>The <see cref="SprintNpaResponse"/>.</returns>
        public override SprintNpaResponse GetResponse()
        {
            return this.response;
        }

        /// <summary>The new map error code.</summary>
        /// <param name="ovmResponse">The ovm response.</param>
        /// <exception cref="NotImplementedException"></exception>
        public override void NewMapErrorCode(ovm ovmResponse) 
        {
            var errorCode = ServiceResponseCode.Success;
            ErrorInfo[] errorInfo = null;

            if (ovmResponse != null && ovmResponse.ovmerrorinfo != null)
            {
                errorInfo = ovmResponse.ovmerrorinfo;
                if (errorInfo.Length > 0)
                {
                    errorCode = ServiceResponseCode.Success;
                    uint sprintErrorType = errorInfo[0].errortype;

                    if (sprintErrorType != 0)
                    {
                        errorCode = ServiceResponseCode.Success;
                    }
                }
            }

            if (errorCode == ServiceResponseCode.Failure)
            {
                throw new ServiceException { ErrorCode = errorCode, ServiceResponseSubCode = ServiceResponseSubCode.NpaNoMarketDataForZip, NewErrorInfo = errorInfo };
            }
        }

        /// <summary>The new map request.</summary>
        /// <param name="req">The req.</param>
        /// <param name="sprintRequest">The sprint request.</param>
        /// <exception cref="NotImplementedException"></exception>
        public override void NewMapRequest(NpaRequest req, ref Request.ovm sprintRequest)
        {
            throw new NotImplementedException("Called NewMapRequest");
        }

        /// <summary>The new map response.</summary>
        /// <param name="ovmresponse">The ovmresponse type.</param>
        /// <returns>The <see cref="SprintNpaResponse"/>.</returns>
        /// <exception cref="NotImplementedException"></exception>
        public override SprintNpaResponse NewMapResponse(OvmResponseType ovmresponse)
        {
            if (ovmresponse != null)
            {
                NpaNxxResponse npaResponse;
                try
                {
                    npaResponse = (NpaNxxResponse)ovmresponse.Item;
                }
                catch (InvalidCastException)
                {
                    this.SetParseResponseErrorFields();
                    return this.response;
                }
                
                if (npaResponse != null && npaResponse.npanxxcount > 0)
                {
                    // loop response items
                    foreach (NpaNxxInfo info in npaResponse.npanxxinfo)
                    {
                        this.response.NpaSet.Add(new NpaInfo { NpaNxx = info.npanxx, Npa = info.npanxx.Substring(0, 3), Description = info.nearestcity, MarketCode = info.ratecenter });
                            
                            // end waResp.NpaSet.Add
                    }
                }
            }

            return this.response;
        }

        /// <summary>The new set error obj.</summary>
        /// <param name="errorCode">The error code.</param>
        /// <param name="subErrorCode">The sub error code.</param>
        /// <param name="primaryErrorMessage">The primary error message.</param>
        /// <param name="errorInfo">The error info.</param>
        /// <returns>The <see cref="SprintNpaResponse"/>.</returns>
        /// <exception cref="NotImplementedException"></exception>
        public override SprintNpaResponse NewSetErrorObj(ServiceResponseCode errorCode, ServiceResponseSubCode subErrorCode, string primaryErrorMessage, ErrorInfo[] errorInfo = null)
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

        /// <summary>The set error obj.</summary>
        /// <param name="errorCode">The error code.</param>
        /// <param name="subErrorCode">The sub error code.</param>
        /// <param name="primaryErrorMessage">The primary error message.</param>
        /// <param name="errorInfo">The error info</param>
        /// <returns>The <see cref="NpaResponse"/>.</returns>
        public override SprintNpaResponse SetErrorObj(ServiceResponseCode errorCode, ServiceResponseSubCode subErrorCode, string primaryErrorMessage, RESPONSE.ErrorInfo[] errorInfo = null)
        {
            SprintNpaResponse sprintNpaResponse;
            if (errorInfo != null)
            {
                string errorText = this.GetSprintResponseAdvice(errorInfo);
                sprintNpaResponse = new SprintNpaResponse((int)errorCode, (int)subErrorCode, primaryErrorMessage, errorInfo)
                                        {
                                            SprintErrorCode = Convert.ToInt32(errorInfo[0].errorcode), 
                                            SprintResponseMessage = errorInfo[0].errordetails, 
                                            SprintResponseAdvice = errorText
                                        };
            }
            else
            {
                sprintNpaResponse = new SprintNpaResponse((int)errorCode, (int)subErrorCode, primaryErrorMessage, null);
            }

            // For parsing error return the parsing information saved already in the class variable
            return this.ParseResponse != null ? this.response : sprintNpaResponse;
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
            throw new NotImplementedException();
        }

        #endregion

        #region Methods

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