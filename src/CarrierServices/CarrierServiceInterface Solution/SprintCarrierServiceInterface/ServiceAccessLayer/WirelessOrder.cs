// --------------------------------------------------------------------------------------------------------------------
// <copyright file="WirelessOrder.cs" company="">
//   
// </copyright>
// <summary>
//   The wireless order dal.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceAccessLayer
{
    using System.Linq;

    using WirelessAdvocates;
    using WirelessAdvocates.SalesOrder;

    /// <summary>The wireless order.</summary>
    public class WirelessOrder : IWirelessOrder
    {
        #region Public Methods and Operators

        /// <summary>The get name.</summary>
        /// <param name="wirelessAccountId">The wireless account id.</param>
        /// <param name="orderId">The order id.</param>
        /// <returns>The <see cref="Name"/>.</returns>
        public Name GetName(int wirelessAccountId, int orderId)
        {
            using (var context = new DbUtility().GetDataContext())
            {
                var query = from w in context.WirelessAccounts
                    where w.WirelessAccountId == wirelessAccountId && w.OrderId == orderId
                    select new Name
                            {
                                FirstName = w.FirstName, 
                                MiddleInitial = w.Initial, 
                                LastName = w.LastName
                            };
                return query.FirstOrDefault();
            }
        }

        #endregion
    }
}