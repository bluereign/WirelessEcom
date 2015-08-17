// --------------------------------------------------------------------------------------------------------------------
// <copyright file="CertHelper.cs" company="">
//   
// </copyright>
// <summary>
//   The cert helper.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCarrierServiceTests
{
    using System;
    using System.IO;
    using System.Linq;
    using System.Security.Cryptography.X509Certificates;

    /// <summary>The cert helper.</summary>
    internal class CertHelper
    {
        #region Methods

        /// <summary>The get certs from file system.</summary>
        /// <returns>The <see cref="X509CertificateCollection"/>.</returns>
        internal X509CertificateCollection GetCertsFromFileSystem()
        {
            var certCollection = new X509CertificateCollection();

            var certFiles = Directory.GetFiles(AppDomain.CurrentDomain.BaseDirectory + "\\App_Data");

            foreach (var cert in certFiles)
            {
                certCollection.Add(X509Certificate.CreateFromCertFile(cert));
            }

            return certCollection;
        }



        /// <summary>The select cert.</summary>
        /// <param name="store">The store.</param>
        /// <param name="location">The location.</param>
        /// <param name="windowTitle">The window title.</param>
        /// <param name="windowMsg">The window msg.</param>
        /// <returns>The <see cref="X509Certificate2"/>.</returns>
        internal X509Certificate2 selectCert(StoreName store, StoreLocation location, string windowTitle, string windowMsg)
        {
            X509Certificate2 certSelected = null;
            var x509Store = new X509Store(store, location);
            x509Store.Open(OpenFlags.ReadOnly);

            var col = x509Store.Certificates;
            var sel = X509Certificate2UI.SelectFromCollection(col, windowTitle, windowMsg, X509SelectionFlag.SingleSelection);

            x509Store.Certificates.OfType<X509Certificate2>().FirstOrDefault(cert => cert.IssuerName.Name.EndsWith("DC=mysite, DC=com"));

            if (sel.Count > 0)
            {
                var en = sel.GetEnumerator();
                en.MoveNext();
                certSelected = en.Current;
            }

            x509Store.Close();

            return certSelected;
        }
        #endregion
    }
}