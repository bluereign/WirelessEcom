// --------------------------------------------------------------------------------------------------------------------
// <copyright file="SoapBase.cs" company="">
//   
// </copyright>
// <summary>
//   The sprint query device info service api facts.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation
{
    using System.Configuration;

    using SprintCSI.Utils;
    using SprintCSI.WCF;

    /// <summary>The sprint query device info service api facts.</summary>
    public class SoapBase
    {
        #region Constants

        /// <summary>The carrier name.</summary>
        protected const string CarrierName = "Sprint";

        #endregion

        #region Fields

        /// <summary>The soap header.</summary>
        internal readonly SoapHeader SoapHeader = new SoapHeader();

        /// <summary>The sprint header.</summary>
        internal readonly SprintHeader SprintHeader;

        /// <summary>The wcf event helper.</summary>
        protected readonly WcfEventHelper WcfEventHelper;

        /// <summary>The ref num.</summary>
        protected string RefNum;

        #endregion

        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="SoapBase" /> class.</summary>
        public SoapBase()
        {
            this.ServiceUrl = ConfigurationManager.AppSettings["Service-URL"];
            this.VendorCode = ConfigurationManager.AppSettings["Vendor-Code"];
            this.VendorPin = ConfigurationManager.AppSettings["Vendor-PIN"];
            this.ApplicationId = ConfigurationManager.AppSettings["Application-Id"];
            this.ApplicationUserId = ConfigurationManager.AppSettings["Application-UserId"];
            this.SprintHeader = new SprintHeader(this.ApplicationId, this.ApplicationUserId);
            this.WcfEventHelper = new WcfEventHelper();
        }

        #endregion

        #region Public Properties

        /// <summary>Gets the application id.</summary>
        public string ApplicationId { get; private set; }

        /// <summary>Gets the application user id.</summary>
        public string ApplicationUserId { get; private set; }

        /// <summary>Gets the service url.</summary>
        public string ServiceUrl { get; private set; }

        /// <summary>Gets the vendor code.</summary>
        public string VendorCode { get; private set; }

        /// <summary>Gets the vendor pin.</summary>
        public string VendorPin { get; private set; }

        #endregion
    }
}