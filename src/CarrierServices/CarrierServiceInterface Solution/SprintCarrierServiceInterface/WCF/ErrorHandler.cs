// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ErrorHandler.cs" company="">
//   
// </copyright>
// <summary>
//   The error handler.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCSI.WCF
{
    using System;
    using System.Diagnostics;
    using System.ServiceModel.Channels;
    using System.ServiceModel.Dispatcher;

    /// <summary>The error handler.</summary>
    public class ErrorHandler : IErrorHandler
    {
        #region Public Methods and Operators

        /// <summary>The handle error.</summary>
        /// <param name="error">The error.</param>
        /// <returns>The <see cref="bool"/>.</returns>
        public bool HandleError(Exception error)
        {
            Trace.WriteLine("ErrorHandler.HandleError Called");
            return false;
        }

        /// <summary>The provide fault.</summary>
        /// <param name="error">The error.</param>
        /// <param name="version">The version.</param>
        /// <param name="fault">The fault.</param>
        public void ProvideFault(Exception error, MessageVersion version, ref Message fault)
        {
            Trace.WriteLine("ErrorHandler.ProvideFault Called");
        }

        #endregion
    }
}