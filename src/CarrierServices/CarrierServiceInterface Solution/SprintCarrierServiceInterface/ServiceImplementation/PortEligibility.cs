// --------------------------------------------------------------------------------------------------------------------
// <copyright file="PortEligibility.cs" company="">
//   
// </copyright>
// <summary>
//   The port eligibility request.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation
{
    using System;
    using System.Collections.Generic;

    using SprintCSI.Response;
    using SprintCSI.ServiceImplementation.DTO;

    using WirelessAdvocates;
    using WirelessAdvocates.Enum;
    using WirelessAdvocates.ServiceResponse;

    using NEW_REQUEST = SprintCSI.Request;
    using NEW_RESPONSE = SprintCSI.Response;
    using REQUEST = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;
    using RESPONSE = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.response;

    /// <summary>The port eligibility impl.</summary>
    public class PortEligibility : OvmBase<PortEligibilityRequest, SprintValidatePortInResponse>
    {
        #region Fields

        /// <summary>The response.</summary>
        private readonly SprintValidatePortInResponse response = new SprintValidatePortInResponse();

        #endregion

        #region Public Methods and Operators

        /// <summary>The get response.</summary>
        /// <returns>The <see cref="SprintValidatePortInResponse" />.</returns>
        public override SprintValidatePortInResponse GetResponse()
        {
            return this.response;
        }

        /// <summary>The map error code.</summary>
        /// <param name="ovmResponse">The ovm response.</param>
        /// <exception cref="ServiceException"></exception>
        public override void MapErrorCode(RESPONSE.ovm ovmResponse)
        {
            var errorCode = ServiceResponseCode.Success;

            if (ovmResponse == null || ovmResponse.ovmerrorinfo == null)
            {
                return;
            }

            RESPONSE.ErrorInfo[] errorInfo = ovmResponse.ovmerrorinfo;

            if (errorInfo.Length > 0)
            {
                uint sprintErrorType = errorInfo[0].errortype;

                if (sprintErrorType == 1 || sprintErrorType == 2 || sprintErrorType == 3)
                {
                    errorCode = ServiceResponseCode.Failure;
                }
            }

            if (errorCode == ServiceResponseCode.Failure)
            {
                throw new ServiceException(string.Empty) { ErrorCode = errorCode, ServiceResponseSubCode = ServiceResponseSubCode.NpaNoMarketDataForZip, ErrorInfo = errorInfo, };
            }
        }

        /// <summary>The map request.</summary>
        /// <param name="req">The req.</param>
        /// <param name="sprintRequest">The sprint request.</param>
        public override void MapRequest(PortEligibilityRequest req, ref REQUEST.ovm sprintRequest)
        {
            sprintRequest.ovmheader.messagetype = REQUEST.RequestMessageType.PORT_ELIGIBILITY_REQUEST;

            // convert he MDN list into a list of numbers to pass into the request.
            var numbers = new string[req.MDNList.Count];
            int i = 0;
            foreach (MDNSet set in req.MDNList)
            {
                numbers[i] = set.MDN;
                i++;
            }

            sprintRequest.ovmrequest.Item = new REQUEST.PortRequest { portinnumber = numbers };
            sprintRequest.ovmrequest.ItemElementName = REQUEST.ItemChoiceType19.portrequest;
        }

        /// <summary>The new map response.</summary>
        /// <param name="ovmresponseType">The ovmresponse type.</param>
        /// <returns>The <see cref="SprintValidatePortInResponse"/>.</returns>
        /// <exception cref="NotImplementedException"></exception>
        public override SprintValidatePortInResponse NewMapResponse(OvmResponseType ovmresponseType)
        {
            var setList = new List<MDNSet>();

            var sprintValidatePortInResponse = new SprintValidatePortInResponse();

            if (ovmresponseType == null)
            {
                return sprintValidatePortInResponse;
            }

            var portResponse = (PortResponse)ovmresponseType.Item;

            if (portResponse.portresponseinfo == null || portResponse.portresponseinfo.Length <= 0)
            {
                return sprintValidatePortInResponse;
            }

            foreach (PortResponseInfo info in portResponse.portresponseinfo)
            {
                var set = new MDNSet { MDN = info.portinnumber, IsPortable = info.porteligibility };
                setList.Add(set);
            }

            sprintValidatePortInResponse.MDNSet = setList;

            return sprintValidatePortInResponse;
        }

        /// <summary>The new set error obj.</summary>
        /// <param name="errorCode">The error code.</param>
        /// <param name="subErrorCode">The sub error code.</param>
        /// <param name="primaryErrorMessage">The primary error message.</param>
        /// <param name="errorInfo">The error info.</param>
        /// <returns>The <see cref="SprintValidatePortInResponse"/>.</returns>
        /// <exception cref="NotImplementedException"></exception>
        public override SprintValidatePortInResponse NewSetErrorObj(ServiceResponseCode errorCode, ServiceResponseSubCode subErrorCode, string primaryErrorMessage, ErrorInfo[] errorInfo = null)
        {
            var sprintValidatePortInResponse = new SprintValidatePortInResponse((int)errorCode, (int)subErrorCode, primaryErrorMessage, errorInfo);

            // For parsing error return the parsing information saved already in the class variable
            return this.ParseResponse != null ? this.response : sprintValidatePortInResponse;
        }

        #endregion
    }
}