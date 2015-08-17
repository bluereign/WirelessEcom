// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ErrorEventArgs.cs" company="">
//   
// </copyright>
// <summary>
//   The error event args.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCarrierServiceTests.WCF
{
    using System;

    /// <summary>The error event args.</summary>
    public class ErrorEventArgs : EventArgs
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="ErrorEventArgs"/> class.</summary>
        /// <param name="providerErrorCode">The provider error code.</param>
        /// <param name="providerErrorText">The provider error text.</param>
        public ErrorEventArgs(string providerErrorCode, string providerErrorText)
        {
            this.ProviderErrorCode = providerErrorCode;
            this.ProviderErrorText = providerErrorText;
        }

        /// <summary>Prevents a default instance of the <see cref="ErrorEventArgs" /> class from being created.</summary>
        private ErrorEventArgs()
        {
        }

        #endregion

        #region Public Properties

        /// <summary>Gets or sets the provider error code.</summary>
        public string ProviderErrorCode { get; private set; }

        /// <summary>Gets or sets the provider error text.</summary>
        public string ProviderErrorText { get; private set; }

        #endregion
    }
}