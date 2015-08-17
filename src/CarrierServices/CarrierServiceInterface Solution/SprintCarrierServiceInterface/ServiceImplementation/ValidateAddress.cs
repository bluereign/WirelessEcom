// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ValidateAddress.cs" company="">
//   
// </copyright>
// <summary>
//   The validate address request.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCSI.ServiceImplementation
{
    using System;
    using System.Diagnostics;

    using SprintCSI.AddressMgmtService;
    using SprintCSI.Properties;
    using SprintCSI.ServiceImplementation.DTO;
    using SprintCSI.Utils;
    using SprintCSI.WCF;

    using WirelessAdvocates;
    using WirelessAdvocates.Enum;
    using WirelessAdvocates.Logger;
    using WirelessAdvocates.ServiceResponse;

    using ValidateAddressRequest = SprintCSI.ServiceImplementation.DTO.ValidateAddressRequest;

    /// <summary>The validate address.</summary>
    public class ValidateAddress : SoapBase
    {
        #region Public Methods and Operators

        /// <summary>The execute.</summary>
        /// <param name="req">The req.</param>
        /// <returns>The <see cref="AddressValidationResponse"/>.</returns>
        public SprintAddressValidationResponse Execute(ValidateAddressRequest req)
        {
            // TODO [pcrawford,20140226] Make call to Sprint here
            // var response = new SprintAddressValidationResponse { ErrorCode = (int)ServiceResponseCode.Success };

            // build the address that is returned, this is the extended address.
            // var extendedAddress = new ExtendedAddress
            // {
            // AddressLine1 = req.Address.AddressLine1,
            // AddressLine2 = req.Address.AddressLine2,
            // AddressType = req.AddressType.ToString(),
            // City = req.Address.City,
            // State = req.Address.State,
            // ZipCode = req.Address.ZipCode
            // };

            // new CheckoutSessionState().Add(req.ReferenceNumber, req.AddressType.ToString(), "AddressValidation", extendedAddress);

            // stuff the extended address back into the response.
            // response.ValidAddress = extendedAddress;

            // return response;

            // ===========================================================================
            this.RefNum = req.ReferenceNumber;
            var messageHeader = new SoapHeader().CreateAMSMessageHeader();

            var addressInfo = new RequestAddressType();
            addressInfo.addressLine1 = req.Address.AddressLine1;
            if (!string.IsNullOrEmpty(req.Address.AddressLine2))
            {
                addressInfo.addressLine2 = req.Address.AddressLine2;
            }

            addressInfo.city = req.Address.City;
            addressInfo.state = req.Address.State;
            addressInfo.zipCode = req.Address.ZipCode;

            var validateAddress = new ValidateAddressType { addressInfo = addressInfo };

            var service = new AddressManagementServicePortTypeClient();

            service.Endpoint.Behaviors.Add(new SimpleEndpointBehavior());

            service.Open();

            try
            {
                service.ValidateAddress(ref messageHeader, validateAddress);
                this.WcfEventHelper.DisposeSubscriptions();
                service.Close();
            }
            catch (Exception ex)
            {
                // this.headers = OperationContext.Current.IncomingMessageHeaders;
                if (ex.InnerException != null)
                {
                    Trace.WriteLine("\n\n\nMessageSecurityException Exception ==> " + ex.Message + " ==> " + ex.InnerException.Message);
                }
                else
                {
                    Trace.WriteLine("\n\n\nMessageSecurityException Exception ==> " + ex.Message);
                }

                this.WcfEventHelper.DisposeSubscriptions();
            }

            var validateAddressResponse = this.ReturnInterceptedResult();

            var validAddress = new ExtendedAddress();
            validAddress.AddressLine1 = validateAddressResponse.validatedAddressList[0].addressLine1;
            if (!string.IsNullOrEmpty(validateAddressResponse.validatedAddressList[0].addressLine2))
            {
                validAddress.AddressLine2 = validateAddressResponse.validatedAddressList[0].addressLine2;
            }

            validAddress.City = validateAddressResponse.validatedAddressList[0].city;
            validAddress.State = validateAddressResponse.validatedAddressList[0].state;
            validAddress.ZipCode = validateAddressResponse.validatedAddressList[0].zipCode;

            var sprintAddressValidationResponse = new SprintAddressValidationResponse();

            sprintAddressValidationResponse.ErrorCode = (int)ServiceResponseCode.Success;

            if (Convert.ToInt32(validateAddressResponse.validatedAddressList[0].additionalAddressInfo.confidence) < Settings.Default.AddressConfidenceThreshold)
            {
                sprintAddressValidationResponse.ServiceResponseSubCode = (int)ServiceResponseSubCode.AvInvalidAddress;
            }
            else
            {
                sprintAddressValidationResponse.ServiceResponseSubCode = (int)ServiceResponseSubCode.DefaultValue;
            }

            new CheckoutSessionState().Add(req.ReferenceNumber, req.AddressType.ToString(), "AddressValidation", validAddress);

            sprintAddressValidationResponse.ValidAddress = validAddress;

            // serialize wa response.
            new Log().LogOutput(new Utility().SerializeXML(sprintAddressValidationResponse), CarrierName, this.GetType().Name, this.RefNum);

            return sprintAddressValidationResponse;
        }

        #endregion

        #region Methods

        /// <summary>The extract intercepted result.</summary>
        /// <returns>The <see cref="SprintDeviceValidationResponse" />.</returns>
        /// <exception cref="NotImplementedException"></exception>
        private ValidateAddressResponseType ReturnInterceptedResult()
        {
            var responseHelper = new XmlHelper { XmlString = this.WcfEventHelper.ResponseXml };

            // log the request
            new Log().LogRequest(this.WcfEventHelper.RequestXml, CarrierName, this.GetType().Name, this.RefNum);

            // log the response
            new Log().LogResponse(this.WcfEventHelper.ResponseXml, CarrierName, this.GetType().Name, this.RefNum);

            var a = new ResponseAddressType[1];

            a[0] = new ResponseAddressType
                       {
                           addressLine1 = responseHelper.GetXmlValue("addressLine1", false), 
                           addressLine2 = responseHelper.GetXmlValue("addressLine2", false), 
                           city = responseHelper.GetXmlValue("city", false), 
                           state = responseHelper.GetXmlValue("state", false), 
                           zipCode = responseHelper.GetXmlValue("zipCode", false)
                       };

            var confidence = responseHelper.GetXmlValue("confidence", false);

            // check to see that the XML returned from Sprint is what we expect it to be
            if (confidence != null)
            {
                a[0].additionalAddressInfo = new AdditionalAddressInfoType { confidence = confidence };
            }
            else
            {
                a[0].additionalAddressInfo = new AdditionalAddressInfoType { confidence = "0" };
            }

            return new ValidateAddressResponseType { validatedAddressList = a };
        }

        #endregion
    }
}