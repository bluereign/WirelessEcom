// --------------------------------------------------------------------------------------------------------------------
// <copyright file="Repository.cs" company="">
//   
// </copyright>
// <summary>
//   The repository.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SWGData
{
    using System;
    using System.Collections.Generic;
    using System.Linq;

    using SWGErrorHandle;

    /// <summary>The repository.</summary>
    public class Repository : IRepository
    {
        #region Public Methods and Operators

        /// <summary>The get.</summary>
        /// <param name="errorKey">The error key.</param>
        /// <returns>The <see cref="Activation"/>.</returns>
        /// <exception cref="NotImplementedException"></exception>
        public Activation Get(string errorKey)
        {
            using (var context = new SWGErrorHandleEntities())
            {
                IQueryable<Activation> query = from a in context.Activations where a.ErrorKeyAct == errorKey select a;
                return query.FirstOrDefault();
            }
        }

        /// <summary>The get all.</summary>
        /// <returns>The <see cref="List" />.</returns>
        public List<Activation> GetAll()
        {
            using (var context = new SWGErrorHandleEntities())
            {
                IQueryable<Activation> query = from a in context.Activations select a;
                return query.ToList();
            }
        }

        #endregion
    }
}