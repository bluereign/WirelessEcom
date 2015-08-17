// --------------------------------------------------------------------------------------------------------------------
// <copyright file="NpaLookupByZip.cs" company="">
//   
// </copyright>
// <summary>
//   The npa lookup by zip impl.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation
{
    using System;

    using WirelessAdvocates.ServiceResponse;

    /// <summary>The npa lookup by zip impl.</summary>
    public class NpaLookupByZip
    {
        #region Public Methods and Operators

        /// <summary>The execute.</summary>
        /// <param name="zipCode">The zip code.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="NpaResponse"/>.</returns>
        /// <exception cref="NotImplementedException"></exception>
        public NpaResponse Execute(string zipCode, string referenceNumber)
        {
            // 1) setup request & response objects
            // 2) make service call
            // 3) map service call response to internal response exepcted by ColdFusion
            // SprintServiceAccess service = new SprintServiceAccess();

            // map response here
            throw new NotImplementedException("NPALookupByZip.Execute");
        }

        #endregion
    }
}