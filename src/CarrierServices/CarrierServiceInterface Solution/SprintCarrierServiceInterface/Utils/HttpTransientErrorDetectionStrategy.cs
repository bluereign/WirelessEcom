// --------------------------------------------------------------------------------------------------------------------
// <copyright file="HttpTransientErrorDetectionStrategy.cs" company="">
//   
// </copyright>
// <summary>
//   The http transient error detection strategy.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCSI.Utils
{
    using System;
    using System.Collections.Generic;
    using System.Net;

    using Microsoft.Practices.TransientFaultHandling;

    /// <summary>The http transient error detection strategy.</summary>
    public class HttpTransientErrorDetectionStrategy : ITransientErrorDetectionStrategy
    {
        #region Fields

        /// <summary>The status codes.</summary>
        private readonly List<HttpStatusCode> statusCodes = new List<HttpStatusCode> { HttpStatusCode.GatewayTimeout, HttpStatusCode.RequestTimeout, HttpStatusCode.ServiceUnavailable, };

        #endregion

        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="HttpTransientErrorDetectionStrategy"/> class.</summary>
        /// <param name="isNotFoundAsTransient">The is not found as transient.</param>
        public HttpTransientErrorDetectionStrategy(bool isNotFoundAsTransient = false)
        {
            if (isNotFoundAsTransient)
            {
                this.statusCodes.Add(HttpStatusCode.NotFound);
            }
        }

        #endregion

        #region Public Methods and Operators

        /// <summary>The is transient.</summary>
        /// <param name="ex">The ex.</param>
        /// <returns>The <see cref="bool"/>.</returns>
        public bool IsTransient(Exception ex)
        {
            var we = ex as WebException;
            if (we == null)
            {
                return false;
            }

            var response = we.Response as HttpWebResponse;

            bool isTransient = response != null && this.statusCodes.Contains(response.StatusCode);
            return isTransient;
        }

        #endregion
    }
}