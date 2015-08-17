// --------------------------------------------------------------------------------------------------------------------
// <copyright file="Callbacks.cs" company="">
//   
// </copyright>
// <summary>
//   The callbacks.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCarrierServiceTests.WCF
{
    using System.Diagnostics;
    using System.Net.Security;
    using System.Security.Cryptography.X509Certificates;

    /// <summary>The callbacks.</summary>
    internal class Callbacks
    {
        #region Public Methods and Operators

        /// <summary>The on validation callback.</summary>
        /// <param name="sender">The sender.</param>
        /// <param name="cert">The cert.</param>
        /// <param name="chain">The chain.</param>
        /// <param name="errors">The errors.</param>
        /// <returns>The <see cref="bool"/>.</returns>
        public static bool OnValidationCallback(object sender, X509Certificate cert, X509Chain chain, SslPolicyErrors errors)
        {
            Trace.WriteLine("\nOnValidationCallback ==> \n");
            return true;
        }

        #endregion
    }
}