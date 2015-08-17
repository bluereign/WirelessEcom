// --------------------------------------------------------------------------------------------------------------------
// <copyright file="MyExceptionHandler.cs" company="">
//   
// </copyright>
// <summary>
//   The my exception handler.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCarrierServiceTests.WCF
{
    using System;
    using System.Diagnostics;
    using System.ServiceModel;
    using System.ServiceModel.Dispatcher;

    /// <summary>The my exception handler.</summary>
    internal class MyExceptionHandler : ExceptionHandler
    {
        #region Public Methods and Operators

        /// <summary>The handle exception.</summary>
        /// <param name="exception">The exception.</param>
        /// <returns>The <see cref="bool"/>.</returns>
        public override bool HandleException(Exception exception)
        {
            Trace.WriteLine("\nHandleException ==> \n");
            Type exceptionType = exception.GetType();
            if (typeof(CommunicationException).IsAssignableFrom(exceptionType))
            {
                Console.WriteLine(string.Format("NOT terminating the process after receiving the following exception: '{0}'"), exception);
                return true;
            }

            return false;
        }

        #endregion
    }
}