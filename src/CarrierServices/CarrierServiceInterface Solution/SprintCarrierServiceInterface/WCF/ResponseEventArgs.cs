// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ResponseEventArgs.cs" company="">
//   
// </copyright>
// <summary>
//   The response event args
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.WCF
{
    using System;

    /// <summary>The response event args.</summary>
    public class ResponseEventArgs : EventArgs  
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="ResponseEventArgs"/> class.</summary>
        /// <param name="responseXml">The request Xml.</param>
        public ResponseEventArgs(string responseXml)
        {
            this.ResponseXml = responseXml;
        }

        /// <summary>Prevents a default instance of the <see cref="ResponseEventArgs" /> class from being created.</summary>
        private ResponseEventArgs()
        {
        }

        #endregion

        #region Public Properties

        /// <summary>Gets the Response Xml.</summary>
        public string ResponseXml { get; private set; }

    

        #endregion
    }
}