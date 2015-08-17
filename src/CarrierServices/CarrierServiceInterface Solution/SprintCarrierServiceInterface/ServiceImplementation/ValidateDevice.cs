// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ValidateDevice.cs" company="">
//   
// </copyright>
// <summary>
//   The validate device request.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation
{
    using System;
    using System.Diagnostics;

    using SprintCSI.Annotations;
    using SprintCSI.QueryDeviceInfoService;
    using SprintCSI.ServiceImplementation.DTO;
    using SprintCSI.Utils;
    using SprintCSI.WCF;

    using WirelessAdvocates.Enum;
    using WirelessAdvocates.Logger;

    /// <summary>The validate device.</summary>
    public class ValidateDevice : SoapBase
    {
        #region Public Methods and Operators

        /// <summary>The execute.</summary>
        /// <param name="req">The req.</param>
        /// <param name="refnum">The refnum.</param>
        /// <param name="isHex">The is hex.</param>
        /// <returns>The <see cref="SprintDeviceValidationResponse"/>.</returns>
        public SprintDeviceValidationResponse Execute(ValidateDeviceRequest req, string refnum, bool isHex = true)
        {
            this.RefNum = refnum;
            return this.ValidateDeviceV8(req.Meid);
        }

        #endregion

        #region Methods

        /// <summary>The extract intercepted result.</summary>
        /// <returns>The <see cref="SprintDeviceValidationResponse" />.</returns>
        /// <exception cref="NotImplementedException"></exception>
        private SprintDeviceValidationResponse ReturnInterceptedResult()
        {
            var responseHelper = new XmlHelper { XmlString = this.WcfEventHelper.ResponseXml };

            // log the request
            new Log().LogRequest(this.WcfEventHelper.RequestXml, CarrierName, this.GetType().Name, this.RefNum);

            // log the response
            new Log().LogResponse(this.WcfEventHelper.ResponseXml, CarrierName, this.GetType().Name, this.RefNum);

            var serviceResponseSubCode = ServiceResponseSubCode.ACT_UNKNOWN;

            string iccId = responseHelper.GetXmlValue("iccId", false);
            string deviceType = responseHelper.GetXmlValue("deviceType", false);

            if (iccId == null)
            {
                serviceResponseSubCode = ServiceResponseSubCode.ActNoIccId;
            }

            return new SprintDeviceValidationResponse
                       {
                           ErrorCodeEnum = ServiceResponseCode.Success, 
                           ErrorCode = (int)ServiceResponseCode.Success, 
                           ServiceResponseSubCodeEnum = serviceResponseSubCode, 
                           PrimaryErrorMessageBrief = this.WcfEventHelper.ProviderErrorCode, 
                           PrimaryErrorMessage = this.WcfEventHelper.ProviderErrorText, 
                           PrimaryErrorMessageLong = this.WcfEventHelper.ProviderErrorText, 
                           IccId = iccId, 
                           DeviceType = deviceType
                       };
        }

        /// <summary>The validate device v 8.</summary>
        /// <param name="meid">The meid.</param>
        /// <param name="isHex">The is hex.</param>
        /// <returns>The <see cref="SprintDeviceValidationResponse"/>.</returns>
        [NotNull]
        private SprintDeviceValidationResponse ValidateDeviceV8([NotNull] string meid, bool isHex = true)
        {
            WsMessageHeaderType messageHeader = this.SprintHeader.CreateQDIMessageHeader();

            var service = new QueryDeviceInfoPortTypeClient();

            service.Endpoint.Behaviors.Add(new SimpleEndpointBehavior());

            service.Open();

            DeviceDetailInfoType2 deviceDetailInfoType2;
            if (isHex)
            {
                deviceDetailInfoType2 = new DeviceDetailInfoType2 { ItemElementName = ItemChoiceType11.esnMeidHex, Item = meid };
            }
            else
            {
                deviceDetailInfoType2 = new DeviceDetailInfoType2 { ItemElementName = ItemChoiceType11.esnMeidDec, Item = meid };
            }

            var deviceInfoType6 = new DeviceInfoType6 { deviceDetailInfo = deviceDetailInfoType2 };

            var validateDeviceV8Info = new ValidateDeviceV8RequestType { brandCode = "XXX", deviceInfo = deviceInfoType6, userId = this.VendorCode };

            try
            {
                service.ValidateDeviceV8(ref messageHeader, validateDeviceV8Info);
                service.Close();
                this.WcfEventHelper.DisposeSubscriptions();
                return this.ReturnInterceptedResult();
            }
            catch (Exception ex)
            {
                Trace.WriteLine(ex.GetType().Name + " ==> " + ex.Message);
                this.WcfEventHelper.DisposeSubscriptions();
                return this.ReturnInterceptedResult();
            }
        }

        #endregion
    }
}