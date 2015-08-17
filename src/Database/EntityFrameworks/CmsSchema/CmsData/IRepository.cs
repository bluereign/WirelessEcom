// --------------------------------------------------------------------------------------------------------------------
// <copyright file="IRepository.cs" company="">
//   
// </copyright>
// <summary>
//   The Repository interface.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace CmsData
{
    using System.Collections.Generic;

    using CmsSchema;

    /// <summary>The Repository interface.</summary>
    internal interface IRepository
    {
        #region Public Methods and Operators

        /// <summary>The get active rebate.</summary>
        /// <param name="sku">The sku.</param>
        /// <param name="carrier">The carrier.</param>
        void GetActiveRebate(string sku, string carrier);

        /// <summary>The get all rebate skus.</summary>
        /// <returns>The <see cref="List" />.</returns>
        List<RebateSKU> GetAllRebateSkus();

        /// <summary>The get all rebates.</summary>
        /// <returns>The <see cref="List" />.</returns>
        List<Rebate> GetAllRebates();

        #endregion
    }
}