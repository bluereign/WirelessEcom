// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ServiceHelper.cs" company="">
//   
// </copyright>
// <summary>
//   The service helper.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace TMobileCarrierServiceInterface.Implementation
{
    using System;
    using System.Diagnostics;
    using System.IO;
    using System.Linq;
    using System.Security.Cryptography.X509Certificates;
    using System.Web;

    using Microsoft.Web.Services2.Security.Tokens;

    using TMobileCarrierServiceInterface.Interfaces.Common;

    using WirelessAdvocates;

    /// <summary>The service helper.</summary>
    public sealed class ServiceHelper
    {
        #region Static Fields

        /// <summary>The _cert collection.</summary>
        private static X509CertificateCollection certCollection;

        /// <summary>The _user name token.</summary>
        private static UsernameToken userNameToken;

        #endregion

        #region Constructors and Destructors

        /// <summary>Initializes static members of the <see cref="ServiceHelper" /> class.</summary>
        static ServiceHelper()
        {
            Instance = new ServiceHelper();
        }

        /// <summary>Prevents a default instance of the <see cref="ServiceHelper" /> class from being created.</summary>
        private ServiceHelper()
        {
            var config = new WaConfigurationManager(HttpContext.Current.Server.MapPath(string.Empty));

            if (userNameToken == null)
            {
                userNameToken = new UsernameToken(
                    config.AppSetting("Username"), 
                    config.AppSetting("Password"), 
                    PasswordOption.SendPlainText);
            }
        }

        #endregion

        #region Public Properties

        /// <summary>Gets the instance.</summary>
        public static ServiceHelper Instance { get; private set; }

        #endregion

        #region Public Methods and Operators

        /// <summary>The add certs.</summary>
        /// <param name="certs">The cert collection.</param>
        public void AddCerts(X509CertificateCollection certs)
        {
            if (certCollection == null)
            {
                string[] certFiles = Directory.GetFiles(HttpContext.Current.Server.MapPath("App_Data"));
                certCollection = new X509CertificateCollection();
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

            foreach (X509Certificate cert in certCollection)
            {
                certs.Add(cert);
            }
        }

        /// <summary>The find error code.</summary>
        /// <param name="statusItems">The status items.</param>
        /// <param name="errorCode">The error code.</param>
        /// <returns>The <see cref="StatusItem"/>.</returns>
        public StatusItem FindErrorCode(StatusItem[] statusItems, string errorCode)
        {
            return statusItems.FirstOrDefault(item => item.statusCode == errorCode);
        }

        /// <summary>The get header.</summary>
        /// <param name="reference">The reference.</param>
        /// <returns>The <see cref="Header"/>.</returns>
        public Header GetHeader(string reference)
        {
            var config = new WaConfigurationManager(HttpContext.Current.Server.MapPath(string.Empty));
            var header = new Header
                             {
                                 partnerId = config.AppSetting("partnerId"), 
                                 dealerCode = config.AppSetting("dealerCode"), 
                                 partnerTransactionId = reference, 
                                 partnerTimestamp = DateTime.Now
                             };

            return header;
        }

        /// <summary>The get url.</summary>
        /// <param name="endPointName">The end point name.</param>
        /// <returns>The <see cref="string"/>.</returns>
        public string GetUrl(string endPointName)
        {
            var config = new WaConfigurationManager(HttpContext.Current.Server.MapPath(string.Empty));
            return config.AppSetting("TMobileHost") + config.AppSetting(endPointName);
        }

        /// <summary>The get username token.</summary>
        /// <returns>The <see cref="UsernameToken" />.</returns>
        public UsernameToken GetUsernameToken()
        {
            return userNameToken;
        }

        #endregion
    }
}