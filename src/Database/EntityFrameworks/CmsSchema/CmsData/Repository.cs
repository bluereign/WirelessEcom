// --------------------------------------------------------------------------------------------------------------------
// <copyright file="Repository.cs" company="">
//   
// </copyright>
// <summary>
//   The repository.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace CmsData
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Linq;

    using CmsSchema;

    /// <summary>The repository.</summary>
    public class Repository : IRepository
    {
        #region Public Methods and Operators

        /// <summary>The get active rebate.</summary>
        /// <param name="sku">The sku.</param>
        /// <param name="carrier">The carrier.</param>
        public void GetActiveRebate(string sku, string carrier)
        {
            using (var context = new CmsContents())
            {
                int fred = context.sp_GetActiveRebate(DateTime.Now, sku, carrier, null);
                Trace.WriteLine(fred);
            }
        }

        /// <summary>The get all rebate skus.</summary>
        /// <returns>The <see cref="List" />.</returns>
        public List<RebateSKU> GetAllRebateSkus()
        {
            using (var context = new CmsContents())
            {
                IQueryable<RebateSKU> query = from a in context.RebateSKUs select a;
                return query.ToList();
            }
        }

        /// <summary>The get all rebates.</summary>
        /// <returns>The <see cref="List" />.</returns>
        public List<Rebate> GetAllRebates()
        {
            using (var context = new CmsContents())
            {
                IQueryable<Rebate> query = from a in context.Rebates select a;
                return query.ToList();
            }
        }

        #endregion
    }
}