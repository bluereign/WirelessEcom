// --------------------------------------------------------------------------------------------------------------------
// <copyright file="Log.cs" company="">
//   
// </copyright>
// <summary>
//   The log.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace WirelessAdvocates.Logger
{
    using System;

    using DB;

    using WirelessAdvocates.SalesOrder;

    /// <summary>The log.</summary>
    public class Log
    {
        #region Public Methods and Operators

        /// <summary>The log exception.</summary>
        /// <param name="exception">The exception.</param>
        /// <param name="carrierName">The carrier name.</param>
        /// <param name="requestType">The request type.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <param name="dataType">The data Type.</param>
        public void LogException(string exception, string carrierName, string requestType, string referenceNumber, string dataType = "Exception")
        {
            this.Write(exception, carrierName, requestType, referenceNumber, dataType);
        }

        /// <summary>The log information.</summary>
        /// <param name="information">The information.</param>
        /// <param name="carrierName">The carrier name.</param>
        /// <param name="requestType">The request type.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <param name="dataType">The data type.</param>
        public void LogInformation(string information, string carrierName, string requestType, string referenceNumber, string dataType = "Information")
        {
            this.Write(information, carrierName, requestType, referenceNumber, dataType);
        }

        /// <summary>The log input.</summary>
        /// <param name="paramValues">The param Values.</param>
        /// <param name="carrierName">The carrier name.</param>
        /// <param name="requestType">The request type.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <param name="dataType">The data type.</param>
        public void LogInput(string paramValues, string carrierName, string requestType, string referenceNumber, string dataType = "Input")
        {
            this.Write(paramValues, carrierName, requestType, referenceNumber, dataType);
        }

        /// <summary>The log input.</summary>
        /// <param name="paramValues">The param Values.</param>
        /// <param name="carrierName">The carrier name.</param>
        /// <param name="requestType">The request type.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <param name="dataType">The data type.</param>
        public void LogOutput(string paramValues, string carrierName, string requestType, string referenceNumber, string dataType = "Output")
        {
            this.Write(paramValues, carrierName, requestType, referenceNumber, dataType);
        }

        /// <summary>The log request.</summary>
        /// <param name="requestXML">The request xml.</param>
        /// <param name="carrierName">The carrier name.</param>
        /// <param name="requestType">The request type.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <param name="dataType">The data Type.</param>
        /// <exception cref="Exception"></exception>
        public void LogRequest(string requestXML, string carrierName, string requestType, string referenceNumber, string dataType = "Request")
        {
            this.Write(requestXML, carrierName, requestType, referenceNumber, dataType);
        }

        /// <summary>The log response.</summary>
        /// <param name="responseXML">The response xml.</param>
        /// <param name="carrierName">The carrier name.</param>
        /// <param name="requestType">The request type.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <param name="dataType">The data Type.</param>
        /// <exception cref="Exception"></exception>
        public void LogResponse(string responseXML, string carrierName, string requestType, string referenceNumber, string dataType = "Response")
        {
            this.Write(responseXML, carrierName, requestType, referenceNumber, dataType);
        }

        #endregion

        #region Methods

        /// <summary>The write.</summary>
        /// <param name="data">The data.</param>
        /// <param name="carrierName">The carrier name.</param>
        /// <param name="requestType">The request type.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <param name="dataType">The data type.</param>
        /// <exception cref="Exception"></exception>
        private void Write(string data, string carrierName, string requestType, string referenceNumber, string dataType = "unknown")
        {
            try
            {
                WirelessAdvocatesDataClassesDataContext db = new DbUtility().GetDataContext();
                var log = new CarrierInterfaceLog { Carrier = carrierName, Data = data, LoggedDateTime = DateTime.Now, ReferenceNumber = referenceNumber, RequestType = requestType, Type = dataType };

                db.CarrierInterfaceLogs.InsertOnSubmit(log);
                db.SubmitChanges();
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        #endregion
    }
}