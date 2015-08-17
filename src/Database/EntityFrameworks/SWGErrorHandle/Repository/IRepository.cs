// --------------------------------------------------------------------------------------------------------------------
// <copyright file="IRepository.cs" company="">
//   
// </copyright>
// <summary>
//   The Repository interface.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SWGData
{
    using System.Collections.Generic;

    using SWGErrorHandle;

    /// <summary>The Repository interface.</summary>
    internal interface IRepository
    {
        #region Public Methods and Operators

        /// <summary>The get.</summary>
        /// <param name="errorKey">The error key.</param>
        /// <returns>The <see cref="Activation"/>.</returns>
        Activation Get(string errorKey);

        /// <summary>The get all.</summary>
        /// <returns>The <see cref="List" />.</returns>
        List<Activation> GetAll();

        #endregion
    }
}