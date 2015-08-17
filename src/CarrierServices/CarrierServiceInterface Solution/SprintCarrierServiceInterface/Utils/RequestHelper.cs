// --------------------------------------------------------------------------------------------------------------------
// <copyright file="RequestHelper.cs" company="">
//   
// </copyright>
// <summary>
//   The rest helper.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCSI.Utils
{
    using System;
    using System.Diagnostics;
    using System.IO;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using System.Threading;
    using System.Threading.Tasks;

    using SprintCSI.ServiceImplementation;

    using WirelessAdvocates.Enum;
    using WirelessAdvocates.Logger;

    /// <summary>The rest helper.</summary>
    public class RequestHelper
    {
        #region Public Properties

        /// <summary>Gets or sets the carrier.</summary>
        public string CarrierName { get; set; }

        /// <summary>Gets or sets the refnum.</summary>
        public string RefNum { get; set; }

        #endregion

        #region Public Methods and Operators

        /// <summary>The submit request.</summary>
        /// <param name="xml">The xml.</param>
        /// <param name="url">The url.</param>
        /// <param name="needsCert">The needs Cert.</param>
        /// <returns>The <see cref="string"/>.</returns>
        public string SubmitRequest(string xml, string url, bool needsCert = false)
        {
            string responseXml = string.Empty;

            // Create a request using a URL that can receive a post.
            var request = (HttpWebRequest)WebRequest.Create(url);

            // Set the read-write timeout to 10 minutes
            request.ReadWriteTimeout = 600000;

            // NOTE [pcrawford,20140428] Adding the following timeout will require a full regression pass 
            // request.Timeout = 60000;

            // Post the request
            try
            {
                // Set the Method property of the request to POST.
                request.Method = "POST";
                var postData = xml;
                var byteArray = Encoding.UTF8.GetBytes(postData);
                request.ContentType = "application/x-www-form-urlencoded";
                request.ContentLength = byteArray.Length;
                if (needsCert)
                {
                    this.LoadCerts(ref request);
                }

                using (var requestDataStream = request.GetRequestStream())
                {
                    requestDataStream.Write(byteArray, 0, byteArray.Length);

                    using (var webResp = request.GetResponse())
                    using (var responseDataStream = webResp.GetResponseStream())
                    {
                        if (responseDataStream != null)
                        {
                            using (var reader = new StreamReader(responseDataStream))
                            {
                                responseXml = reader.ReadToEnd();
                            }
                        }
                        else
                        {
                            throw new EndOfStreamException();
                        }
                    }
                }
            }
            catch (TimeoutException ex)
            {
                this.ThrowServiceException(url, ex, "Timeout Exception ");
            }
            catch (WebException ex)
            {
                this.ThrowServiceException(url, ex, "web Exception");
            }
            catch (EndOfStreamException ex)
            {
                this.ThrowServiceException(url, ex, "End of Stream Exception");
            }
            catch (ThreadAbortException ex)
            {
                this.ThreadResetAbort(url, ex, "Thread Abort Exception");
            }
            catch (Exception ex)
            {
                this.ThrowServiceException(url, ex, "Unexpected");
            }
            finally
            {
                var message = string.Format("Entered Finally Block {0} {1} {2}", this.CarrierName, this.GetType().Name, this.RefNum);
                Trace.WriteLine(message);
                // new Log().LogInformation("Entered Finally Block", this.CarrierName, this.GetType().Name, this.RefNum);
            }

            return responseXml;
        }

        #endregion

        #region Methods

        /// <summary>The thread reset abort.</summary>
        /// <param name="url">The url.</param>
        /// <param name="ex">The ex.</param>
        /// <param name="exceptionName">The exception name.</param>
        private void ThreadResetAbort(string url, Exception ex, string exceptionName)
        {
            Debug.WriteLine(exceptionName + ex.Message);
            var errorText = string.Format("Post to {0} received thread aborted and Thread.ResetAbort was performed  {1}", url, ex.StackTrace);
            new Log().LogException(errorText, this.CarrierName, this.GetType().Name, this.RefNum);
            // http://stackoverflow.com/questions/1014439/asp-net-exception-thread-was-being-aborted-causes-method-to-exit
            Thread.ResetAbort();
            // throw new ServiceException(string.Format("Post to {0} failed with exception: {1}", url, ex.Message), ex)
        }

        /// <summary>The throw service exception.</summary>
        /// <param name="url">The url.</param>
        /// <param name="ex">The ex.</param>
        /// <param name="exceptionName">The exception name.</param>
        /// <exception cref="ServiceException"></exception>
        private void ThrowServiceException(string url, Exception ex, string exceptionName)
        {
            Debug.WriteLine(exceptionName + ex.Message);
            var errorText = string.Format("Post to {0} failed with exception: {1} StackTrace: {2}", url, ex.Message, ex.StackTrace);
            new Log().LogException(errorText, this.CarrierName, this.GetType().Name, this.RefNum);
            // Thread.ResetAbort();
            ServiceException sex;
            if (ex.Message.Contains("The operation has timed out"))
            {
                sex = new ServiceException(string.Format("Post to {0} failed with exception: {1}", url, ex.Message), ex) { ErrorCode = ServiceResponseCode.Timeout };
                throw sex;
            } 

            sex = new ServiceException(string.Format("Post to {0} failed with exception: {1}", url, ex.Message), ex) { ErrorCode = ServiceResponseCode.Failure };
            throw sex;
        }


        /// <summary>The post with http client.</summary>
        /// <param name="xml">The xml.</param>
        /// <param name="url">The url.</param>
        /// <param name="needsCert">The needs Cert.</param>
        /// <returns>The <see cref="string"/>.</returns>
        private async Task<string> PostWithHttpClient(string xml, string url, bool needsCert = false)
        {
            using (var httpClient = new HttpClient())
            {
                var request = new HttpRequestMessage(HttpMethod.Post, "http://domain.com");
                request.Content = new StringContent(xml, Encoding.UTF8, "text/xml");
                var response = await httpClient.SendAsync(request);
                return await response.Content.ReadAsStringAsync();
            }
        }

        /// <summary>The load certs.</summary>
        /// <param name="request">The request.</param>
        private void LoadCerts(ref HttpWebRequest request)
        {
            // var certFiles = Directory.GetFiles(ATTServiceConfig.Instance.CertLocation);
            // foreach (var s in certFiles.Where(s => s.EndsWith("cer")))
            // {
            // request.ClientCertificates.Add(X509Certificate.CreateFromCertFile(s));
            // }
        }

        #endregion
    }
}