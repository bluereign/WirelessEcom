// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ServiceHelper.cs" company="">
//   
// </copyright>
// <summary>
//   The att service base.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace AttCarrierServiceInterface
{
    using System;
    using System.Diagnostics;
    using System.IO;
    using System.Security.Cryptography.X509Certificates;
    using System.Web;

    using AttCarrierServiceInterface.Interfaces.AttProxy;

    using Microsoft.Web.Services2.Security.Tokens;

    using WirelessAdvocates;
    using WirelessAdvocates.Logger;

    /// <summary>The att service base.</summary>
    public class AttServiceBase
    {
        #region Fields

        /// <summary>The _reference number.</summary>
        private string referenceNumber = string.Empty;

        #endregion

        #region Enums

        /// <summary>The activate subscriber error.</summary>
        public enum ActivateSubscriberError : long
        {
            // [Description("User ID Is Invalid")]
            // 0000000001
        }

        #endregion

        #region Public Properties

        /// <summary>Gets or sets the reference number.</summary>
        public string ReferenceNumber
        {
            get
            {
                return this.referenceNumber;
            }

            set
            {
                this.referenceNumber = value;
            }
        }

        #endregion

        #region Public Methods and Operators

        /// <summary>The add certs.</summary>
        /// <param name="certCollection">The cert collection.</param>
        public void AddCerts(X509CertificateCollection certCollection)
        {
            string[] certFiles = Directory.GetFiles(HttpContext.Current.Server.MapPath("App_Data"));
            foreach (string s in certFiles)
            {
                if (s.EndsWith("cer"))
                {
                    certCollection.Add(X509Certificate.CreateFromCertFile(s));
                    Trace.WriteLine("Cert: " + s);
                    Trace.WriteLine(Environment.UserName);
                    Trace.Flush();
                }
            }
        }

        /// <summary>The calc activation date.</summary>
        /// <param name="defaultDays">The default days.</param>
        /// <returns>The <see cref="DateTime"/>.</returns>
        public DateTime CalcActivationDate(int defaultDays)
        {
            int addDays;
            try
            {
                addDays = int.Parse(this.GetAppSetting("ActivateAfterDays"));
            }
            catch
            {
                addDays = defaultDays;
            }

            return DateTime.Now.AddDays(addDays);
        }

        // If default not specified set to 2
        /// <summary>The calc activation date.</summary>
        /// <returns>The <see cref="DateTime"/>.</returns>
        public DateTime CalcActivationDate()
        {
            return this.CalcActivationDate(2);
        }

        /// <summary>The capture conversation id.</summary>
        /// <param name="conversationId">The conversation id.</param>
        /// <param name="referenceNumber">The reference number.</param>
        public void CaptureConversationId(string conversationId, string referenceNumber)
        {
            if (!string.IsNullOrEmpty(conversationId))
            {
                string existingConversationId;
                try
                {
                    existingConversationId = CheckoutSessionState.GetByReference(
                        referenceNumber, 
                        "ConversationId", 
                        "Any");
                }
                catch (Exception)
                {
                    existingConversationId = string.Empty;
                }

                if (string.IsNullOrEmpty(existingConversationId))
                {
                    CheckoutSessionState.Add(referenceNumber, "ConversationId", "Any", conversationId);
                }
            }
        }

        /// <summary>The get app setting.</summary>
        /// <param name="key">The key.</param>
        /// <returns>The <see cref="string"/>.</returns>
        public string GetAppSetting(string key)
        {
            var config = new WaConfigurationManager(HttpContext.Current.Server.MapPath(string.Empty));
            return config.AppSetting(key);
        }

        /// <summary>The get dealer commission.</summary>
        /// <returns>The <see cref="DealerCommissionInfo"/>.</returns>
        public DealerCommissionInfo GetDealerCommission()
        {
            var commission = new DealerCommissionInfo();
            commission.dealer = new DealerInfo();
            commission.dealer.code = this.GetAppSetting("DealerCode");
            return commission;
        }

        /// <summary>The get message header.</summary>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="MessageHeaderInfo"/>.</returns>
        public MessageHeaderInfo GetMessageHeader(string referenceNumber)
        {
            var header = new MessageHeaderInfo();
            header.SecurityMessageHeader = new MessageHeaderSecurity();
            header.SecurityMessageHeader.userName = this.GetAppSetting("UserName");
            header.SecurityMessageHeader.userPassword = this.GetAppSetting("Password");
            header.SequenceMessageHeader = new MessageHeaderSequence();
            header.SequenceMessageHeader.sequenceNumber = "1";
            header.SequenceMessageHeader.totalInSequence = "1";
            header.TrackingMessageHeader = new MessageHeaderTracking();
            header.TrackingMessageHeader.messageId = Guid.NewGuid().ToString();
            header.TrackingMessageHeader.dateTimeStamp = DateTime.UtcNow.ToString("s") + "Z";
            header.TrackingMessageHeader.version = this.GetAppSetting("apiVersion");
            try
            {
                string ConversationId;
                ConversationId = CheckoutSessionState.GetByReference(referenceNumber, "ConversationId", "Any");
                if (!string.IsNullOrEmpty(ConversationId))
                {
                    header.TrackingMessageHeader.conversationId = ConversationId;
                }
            }
            catch (Exception)
            {
                // Don't set the conversation, first call of the sequence.
            }

            return header;
        }

        /// <summary>The get url.</summary>
        /// <param name="endPointName">The end point name.</param>
        /// <returns>The <see cref="string"/>.</returns>
        public string GetUrl(string endPointName)
        {
            string url;

            url = this.GetAppSetting("AttHost") + this.GetAppSetting(endPointName);
            return url;
        }

        /// <summary>The get username token.</summary>
        /// <returns>The <see cref="UsernameToken"/>.</returns>
        public UsernameToken GetUsernameToken()
        {
            var userToken = new UsernameToken(
                this.GetAppSetting("Username"), 
                this.GetAppSetting("Password"), 
                PasswordOption.SendPlainText);
            return userToken;
        }

        /// <summary>The log exception.</summary>
        /// <param name="Exception">The exception.</param>
        /// <param name="requestType">The request type.</param>
        public void LogException(string Exception, string requestType)
        {
            new Log().LogException(Exception, "Att", requestType, this.referenceNumber);
        }

        /// <summary>The log request.</summary>
        /// <param name="objectToLog">The object to log.</param>
        /// <param name="requestType">The request type.</param>
        public void LogRequest(object objectToLog, string requestType)
        {
            new Log().LogRequest(new Utility().SerializeXML(objectToLog), "Att", requestType, this.referenceNumber);
        }

        /// <summary>The log response.</summary>
        /// <param name="objectToLog">The object to log.</param>
        /// <param name="requestType">The request type.</param>
        public void LogResponse(object objectToLog, string requestType)
        {
            new Log().LogResponse(new Utility().SerializeXML(objectToLog), "Att", requestType, this.referenceNumber);
        }

        #endregion
    }
}