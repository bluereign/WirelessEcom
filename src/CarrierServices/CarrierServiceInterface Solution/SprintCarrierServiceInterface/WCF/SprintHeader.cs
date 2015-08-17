// --------------------------------------------------------------------------------------------------------------------
// <copyright file="SprintHeader.cs" company="">
//   
// </copyright>
// <summary>
//   The sprint header.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.WCF
{
    using System;

    using SprintCSI.Annotations;
    using SprintCSI.QPOService;

    /// <summary>The sprint header.</summary>
    public class SprintHeader
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="SprintHeader"/> class.</summary>
        /// <param name="applicationId">The application id.</param>
        /// <param name="applicationUserId">The application user id.</param>
        public SprintHeader([NotNull] string applicationId, [NotNull] string applicationUserId)
        {
            this.ApplicationId = applicationId;
            this.ApplicationUserId = applicationUserId;
        }

        /// <summary>Prevents a default instance of the <see cref="SprintHeader"/> class from being created.</summary>
        private SprintHeader()
        {
        }

        #endregion

        #region Public Properties

        /// <summary>Gets or sets the application id.</summary>
        public string ApplicationId { get; set; }

        /// <summary>Gets or sets the application user id.</summary>
        public string ApplicationUserId { get; set; }

        #endregion

        #region Methods

        /// <summary>The create message header.</summary>
        /// <returns>The <see cref="QueryPlansAndOptionsService.WsMessageHeaderType" />.</returns>
        internal QueryDeviceInfoService.WsMessageHeaderType CreateQDIMessageHeader()
        {
            var trackingMessageHeader = new QueryDeviceInfoService.TrackingMessageHeaderType
                                            {
                                                applicationId = ApplicationId,
                                                applicationUserId = ApplicationUserId, 
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
        /// <returns>The <see cref="QueryPlansAndOptionsService.WsMessageHeaderType" />.</returns>
        internal WsMessageHeaderType CreateQPOMessageHeader()
        {
            var trackingMessageHeader = new TrackingMessageHeaderType
                                            {
                                                applicationId = ApplicationId,
                                                applicationUserId = ApplicationUserId, 
                                                consumerId = "wirelessadvocates", 
                                                conversationId = "0", 
                                                messageDateTimeStamp = DateTime.Now, 
                                                messageId = "0", 
                                                replyCompletionCode = 0, 
                                                replyCompletionCodeSpecified = true, 
                                                timeToLive = "0"
                                            };

            var securityMessageHeader = new SecurityMessageHeaderType();

            return new WsMessageHeaderType { trackingMessageHeader = trackingMessageHeader, securityMessageHeader = securityMessageHeader };
        }

        #endregion
    }
}