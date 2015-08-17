// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ServiceException.cs" company="">
//   
// </copyright>
// <summary>
//   The service impl exception.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation
{
    using System;

    using WirelessAdvocates.Enum;

    using NEW_RESPONSE = SprintCSI.Response;
    using RESPONSE = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.response;

    /// <summary>The service impl exception.</summary>
    public class ServiceException : Exception
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="ServiceException" /> class.</summary>
        public ServiceException()
        {
        }

        /// <summary>Initializes a new instance of the <see cref="ServiceException"/> class.</summary>
        /// <param name="message">The message.</param>
        public ServiceException(string message) : base(message)
        {
        }

        /// <summary>Initializes a new instance of the <see cref="ServiceException"/> class.</summary>
        /// <param name="message">The message.</param>
        /// <param name="inner">The inner.</param>
        public ServiceException(string message, Exception inner) : base(message, inner)
        {
        }

        #endregion

        #region Public Properties

        /// <summary>Gets or sets the error code.</summary>
        public ServiceResponseCode ErrorCode { get; set; }

        /// <summary>Gets or sets the request error info.</summary>
        public RESPONSE.ErrorInfo[] ErrorInfo { get; set; }

        /// <summary>Gets or sets the request error info.</summary>
        public NEW_RESPONSE.ErrorInfo[] NewErrorInfo { get; set; }

        /// <summary>Gets or sets the service response sub code.</summary>
        public ServiceResponseSubCode ServiceResponseSubCode { get; set; }

        #endregion
    }
}