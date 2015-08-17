// --------------------------------------------------------------------------------------------------------------------
// <copyright file="UpgradeEligible.cs" company="">
//   
// </copyright>
// <summary>
//   The upgrade eligible impl.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation
{
    using System;

    /// <summary>The upgrade eligible impl.</summary>
    public class UpgradeEligible
    {
        #region Public Methods and Operators

        /// <summary>The execute.</summary>
        /// <param name="zipCode">The zip code.</param>
        /// <param name="mdn">The mdn.</param>
        /// <param name="secretKey">The secret key.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="bool"/>.</returns>
        /// <exception cref="NotImplementedException"></exception>
        public bool Execute(string zipCode, string mdn, string secretKey, string referenceNumber)
        {
            throw new NotImplementedException("UpgradeEligible.Execute");
        }

        #endregion
    }
}