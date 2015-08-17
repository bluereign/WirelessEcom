// --------------------------------------------------------------------------------------------------------------------
// <copyright file="SprintHeader.cs" company="">
//   
// </copyright>
// <summary>
//   The sprint header.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCSI.Utils
{
    using System;
    using System.Configuration;

    /// <summary>The sprint header.</summary>
    public class SoapHeader 

 
    {
        private static readonly string ApplicationId = ConfigurationManager.AppSettings["Application-Id"];
        private static readonly string ApplicationUserId = ConfigurationManager.AppSettings["Application-UserId"];
        private static readonly string ConsumerId = "wirelessadvocates";
        
        #region Methods

        /// <summary>The create message header.</summary>
        /// <returns>The <see cref="QPOService.WsMessageHeaderType" />.</returns>
        public QPOService.WsMessageHeaderType CreateQPOMessageHeader()
        {
            var trackingMessageHeader = new QPOService.TrackingMessageHeaderType
            {
                applicationId = ApplicationId,
                applicationUserId = ApplicationUserId,
                consumerId = ConsumerId,
                conversationId = "0",
                messageDateTimeStamp = DateTime.Now,
                messageId = "0",
                replyCompletionCode = 0,
                replyCompletionCodeSpecified = true,
                timeToLive = "0"
            };

            var securityMessageHeader = new QPOService.SecurityMessageHeaderType();

            return new QPOService.WsMessageHeaderType { trackingMessageHeader = trackingMessageHeader, securityMessageHeader = securityMessageHeader };
        }

        /// <summary>The create message header.</summary>
        /// <returns>The <see cref="QPOService.WsMessageHeaderType" />.</returns>
        public QueryDeviceInfoService.WsMessageHeaderType CreateQDIMessageHeader()
        {
            var trackingMessageHeader = new QueryDeviceInfoService.TrackingMessageHeaderType
            {
                applicationId = ApplicationId,
                applicationUserId = ApplicationUserId,
                consumerId = ConsumerId,
                conversationId = "0",
                messageDateTimeStamp = DateTime.Now,
                messageId = "0",
                replyCompletionCode = 0,
                replyCompletionCodeSpecified = true,
                timeToLive = "0"
            };

            var securityMessageHeader = new QueryDeviceInfoService.SecurityMessageHeaderType();

            return new QueryDeviceInfoService.WsMessageHeaderType { trackingMessageHeader = trackingMessageHeader, securityMessageHeader = securityMessageHeader };
        }


        /// <summary>The create message header.</summary>
        /// <returns>The <see cref="AddressMgmtService.WsMessageHeaderType" />.</returns>
        internal AddressMgmtService.WsMessageHeaderType CreateAMSMessageHeader()
        {
            var trackingMessageHeader = new AddressMgmtService.TrackingMessageHeaderType
            {
                applicationId = ApplicationId,
                applicationUserId = ApplicationUserId,
                consumerId = ConsumerId,
                conversationId = "0",
                messageDateTimeStamp = DateTime.Now,
                messageId = "0",
                replyCompletionCode = 0,
                replyCompletionCodeSpecified = true,
                timeToLive = "0"
            };

            var securityMessageHeader = new AddressMgmtService.SecurityMessageHeaderType();

            return new AddressMgmtService.WsMessageHeaderType { trackingMessageHeader = trackingMessageHeader, securityMessageHeader = securityMessageHeader };
        }


        #endregion
    }
}