// --------------------------------------------------------------------------------------------------------------------
// <copyright file="Common.cs" company="">
//   
// </copyright>
// <summary>
//   The common.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCarrierServiceTests.APIHelper
{
    using System;

    using SprintCarrierServiceTests.QueryPlansAndOptionsService;

    /// <summary>The common.</summary>
    internal class Common
    {
        #region Public Methods and Operators

        /// <summary>The get message header.</summary>
        /// <param name="t">The t.</param>
        /// <typeparam name="T"></typeparam>
        /// <returns>The <see cref="WsMessageHeaderType"/>.</returns>
        public WsMessageHeaderType GetMessageHeader<T>(T t) where T : new()
        {
            var temp = new T();
            var header = new WsMessageHeaderType();
            // var header = new T.WsMessageHeaderType();
            //header.trackingMessageHeader = new TrackingMessageHeaderType();
            //header.trackingMessageHeader.consumerId = string.Empty;
            //header.trackingMessageHeader.applicationId = string.Empty;
            //header.trackingMessageHeader.messageId = referenceNumber;
            //header.trackingMessageHeader.timeToLive = "9999";
            //header.trackingMessageHeader.messageDateTimeStamp = DateTime.UtcNow;
            return header;
        }

        #endregion
    }
}