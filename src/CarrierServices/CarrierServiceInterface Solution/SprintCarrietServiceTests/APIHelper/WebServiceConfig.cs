// --------------------------------------------------------------------------------------------------------------------
// <copyright file="WebServiceConfig.cs" company="">
//   
// </copyright>
// <summary>
//   WebServiceConfig.cs
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCarrierServiceTests.APIHelper
{
    using System.Security.Cryptography.X509Certificates;

    /// <summary>The web service config.</summary>
    public class WebServiceConfig
    {
        #region Public Properties

        /// <summary>Gets or sets the binding.</summary>
        public string Binding { get; set; }

        /// <summary>Gets or sets the client certificate.</summary>
        public X509Certificate2 ClientCertificate { get; set; }

        /// <summary>Gets or sets the endpoint.</summary>
        public string Endpoint { get; set; }

        /// <summary>Gets or sets a value indicating whether ignore ssl errors.</summary>
        public bool IgnoreSslErrors { get; set; }

        #endregion
    }
}