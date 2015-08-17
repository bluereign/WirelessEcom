// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ProductCatalog.cs" company="">
//   
// </copyright>
// <summary>
//   The product catalog.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace TMobileCarrierServiceInterface.Implementation
{
    using System;
    using System.IO;
    using System.Web;

    using TMobileCarrierServiceInterface.Interfaces.Common;
    using TMobileCarrierServiceInterface.Interfaces.OfflineProductCatalog;

    using WirelessAdvocates;

    /// <summary>The product catalog.</summary>
    public class ProductCatalog
    {
        #region Fields

        /// <summary>The _reference number.</summary>
        private readonly string referenceNumber;

        /// <summary>The _service.</summary>
        private readonly OfflineProductCatalogService service;

        /// <summary>The _call status.</summary>
        private ServiceStatus callStatus;

/*
        /// <summary>The _catalog file.</summary>
        private string _catalogFile;
*/

        #endregion

        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="ProductCatalog"/> class.</summary>
        /// <param name="referenceNumber">The reference number.</param>
        public ProductCatalog(string referenceNumber)
        {
            this.service = new OfflineProductCatalogService();
            this.referenceNumber = referenceNumber;
            this.service.Url = ServiceHelper.Instance.GetUrl("OfflineCatalogEndpoint");
            ServiceHelper.Instance.AddCerts(this.service.ClientCertificates);
            this.service.RequestSoapContext.Security.Tokens.Add(ServiceHelper.Instance.GetUsernameToken());
        }

        #endregion

        #region Public Methods and Operators

        /// <summary>The retrieve catalog.</summary>
        /// <returns>The <see cref="string"/>.</returns>
        public string RetrieveCatalog()
        {
            string catalogPath = string.Empty;
            var tmoRequest = new PartnerConfigurationAsZipAttachmentRequest();
            PartnerConfigurationAsAttachmentResponse tmoResponse;
            tmoRequest.effectiveDate = DateTime.Now;
            tmoRequest.header = ServiceHelper.Instance.GetHeader(this.referenceNumber);

            tmoResponse = this.service.getPartnerConfigurationAsAttachment(tmoRequest);

            if (tmoResponse == null || tmoResponse.serviceStatus == null)
            {
                return catalogPath;
            }

            this.callStatus = tmoResponse.serviceStatus;

            if (this.callStatus.serviceStatusCode == ServiceStatusEnum.Item100)
            {
                catalogPath = this.CatalogPath();
                var bw = new BinaryWriter(File.Open(catalogPath, FileMode.Create));
                bw.Write(tmoResponse.partnerConfigurationFile.fileAsAttachment);
                bw.Flush();
                bw.Close();
            }

            return catalogPath;
        }

        #endregion

        #region Methods

        /// <summary>The catalog path.</summary>
        /// <returns>The <see cref="string"/>.</returns>
        private string CatalogPath()
        {
            var config = new WaConfigurationManager(HttpContext.Current.Server.MapPath(string.Empty));
            string catalog = config.AppSetting("CatalogDownloadLocation").Trim();
            if (!catalog.EndsWith(@"\"))
            {
                catalog += @"\";
            }

            return HttpContext.Current.Server.MapPath(catalog + "Catalog_" + DateTime.Now.ToString("yyyyMMdd") + ".zip");
        }

        #endregion
    }
}