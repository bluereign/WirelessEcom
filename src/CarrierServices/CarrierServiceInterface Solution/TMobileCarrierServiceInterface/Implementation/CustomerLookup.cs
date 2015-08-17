//// --------------------------------------------------------------------------------------------------------------------
//// <copyright file="CustomerLookup.cs" company="">
////   
//// </copyright>
//// <summary>
////   The customer lookup.
//// </summary>
//// --------------------------------------------------------------------------------------------------------------------
//namespace TMobileCarrierServiceInterface.Implementation
//{
//    using TMobileCarrierServiceInterface.Interfaces.Common;

//    /// <summary>The customer lookup.</summary>
//    public class CustomerLookup
//    {
//        #region Fields

//        /// <summary>The _reference number.</summary>
//        private readonly string referenceNumber;

//        /// <summary>The _call status.</summary>
//        private ServiceStatus callStatus;

//        #endregion

//        #region Enums

//        // public CustomerLookup(string referenceNumber)
//        // {
//        // _service = new OfflineProductCatalogService();
//        // this.referenceNumber = referenceNumber;
//        // _service.Url = ServiceHelper.Instance.GetUrl("OfflineCatalogEndpoint");
//        // ServiceHelper.Instance.AddCerts(_service.ClientCertificates);
//        // _service.RequestSoapContext.Security.Tokens.Add(ServiceHelper.Instance.GetUsernameToken());
//        // }
//        #endregion

//        #region Enums

//        /// <summary>Initializes a new instance of the <see cref="CustomerLookup" /> class.</summary>
//        /// <param name="referenceNumber">The reference number.</param>
//        /// <summary>The customer lookup method.</summary>
//        public enum CustomerLookupMethod
//        {
//            /// <summary>The ban.</summary>
//            BAN, 

//            /// <summary>The fein.</summary>
//            Fein, 

//            /// <summary>The msi sdn.</summary>
//            MsiSdn, 

//            /// <summary>The sim.</summary>
//            SIM, 

//            /// <summary>The ssn.</summary>
//            SSN, 

//            /// <summary>The wip.</summary>
//            WIP
//        }

//        #endregion

//        #region Public Methods and Operators

//        /// <summary>The retrieve catalog.</summary>
//        public void RetrieveCatalog()
//        {
//            // var tmoRequest = new PartnerConfigurationAsZipAttachmentRequest();
//            // PartnerConfigurationAsAttachmentResponse tmoResponse;
//            // tmoRequest.effectiveDate = DateTime.Now;
//            // tmoRequest.header = ServiceHelper.Instance.GetHeader(this.referenceNumber);

//            // tmoResponse = _service.getPartnerConfigurationAsAttachment(tmoRequest);

//            // if (tmoResponse != null && tmoResponse.serviceStatus != null)
//            // {
//            // this.callStatus = tmoResponse.serviceStatus;

//            // if (this.callStatus.serviceStatusCode == ServiceStatusEnum.Item100)
//            // {
//            // var bw = new BinaryWriter(File.Open(@"C:\Catalog.zip", FileMode.Create));
//            // bw.Write(tmoResponse.partnerConfigurationFile.fileAsAttachment);
//            // bw.Flush();
//            // bw.Close();
//            // }
//            // }
//        }

//        #endregion
//    }
//}