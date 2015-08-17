// --------------------------------------------------------------------------------------------------------------------
// <copyright file="IWirelessOrderDALs.cs" company="">
//   
// </copyright>
// <summary>
//   The WirelessOrderDAL interface.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCSI.ServiceAccessLayer 
{
    using WirelessAdvocates;

    /// <summary>The WirelessOrderDAL interface.</summary>
    public interface IWirelessOrder
    {
        #region Public Methods and Operators

        /// <summary>The get name.</summary>
        /// <param name="wirelessAccountId">The wireless account id.</param>
        /// <param name="orderId">The order id.</param>
        /// <returns>The <see cref="Name"/>.</returns>
        Name GetName(int wirelessAccountId, int orderId);

        #endregion
    }
}