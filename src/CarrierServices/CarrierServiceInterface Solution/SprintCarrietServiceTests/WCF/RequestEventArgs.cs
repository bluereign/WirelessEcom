// --------------------------------------------------------------------------------------------------------------------
// <copyright file="RequestEventArgs.cs" company="">
//   
// </copyright>
// <summary>
//   The request event args
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCarrierServiceTests
{
    using System;

    /// <summary>The request event args.</summary>
    public class RequestEventArgs : EventArgs
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="RequestEventArgs"/> class.</summary>
        /// <param name="requestXml">The request Xml.</param>
        public RequestEventArgs(string requestXml)
        {
            this.RequestXml = requestXml;
        }

        /// <summary>Prevents a default instance of the <see cref="RequestEventArgs" /> class from being created.</summary>
        private RequestEventArgs()
        {
        }

        #endregion

        #region Public Properties

        /// <summary>Gets the Request Xml.</summary>
        public string RequestXml { get; private set; }

    

        #endregion
    }
}