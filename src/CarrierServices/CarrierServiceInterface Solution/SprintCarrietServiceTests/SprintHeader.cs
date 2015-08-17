// --------------------------------------------------------------------------------------------------------------------
// <copyright file="SprintHeader.cs" company="">
//   
// </copyright>
// <summary>
//   The sprint header.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCarrierServiceTests
{
    using System;

    /// <summary>The sprint header.</summary>
    public class SprintHeader
    {
        #region Methods

        /// <summary>The create message header.</summary>
        /// <returns>The <see cref="QueryPlansAndOptionsService.WsMessageHeaderType" />.</returns>
        internal QueryPlansAndOptionsService.WsMessageHeaderType CreateQPOMessageHeader()
        {
            var trackingMessageHeader = new QueryPlansAndOptionsService.TrackingMessageHeaderType
                                            {
                                                applicationId = "7UL", 
                                                applicationUserId = "CTCI", 
                                                consumerId = "wirelessadvocates", 
                                                conversationId = "0", 
                                                messageDateTimeStamp = DateTime.Now, 
                                                messageId = "0", 
                                                replyCompletionCode = 0, 
                                                replyCompletionCodeSpecified = true, 
                                                timeToLive = "0"
                                            };

            var securityMessageHeader = new QueryPlansAndOptionsService.SecurityMessageHeaderType();

            return new QueryPlansAndOptionsService.WsMessageHeaderType { trackingMessageHeader = trackingMessageHeader, securityMessageHeader = securityMessageHeader };
        }

        /// <summary>The create message header.</summary>
        /// <returns>The <see cref="QueryPlansAndOptionsService.WsMessageHeaderType" />.</returns>
        internal QueryDeviceInfoService.WsMessageHeaderType CreateQDIMessageHeader()
        {
            var trackingMessageHeader = new QueryDeviceInfoService.TrackingMessageHeaderType
            {
                applicationId = "7UL",
                applicationUserId = "CTCI",
                consumerId = "wirelessadvocates",
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
                applicationId = "7UL",
                applicationUserId = "CTCI",
                consumerId = "wirelessadvocates",
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