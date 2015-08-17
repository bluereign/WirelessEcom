// --------------------------------------------------------------------------------------------------------------------
// <copyright file="WirelessLines.cs" company="">
//   
// </copyright>
// <summary>
//   The device technology.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace WirelessAdvocates.SalesOrder
{
    using System;
    using System.Data;
    using System.Linq;

    /// <summary>The wireless line.</summary>
    public class WirelessLines
    {
        #region Public Methods and Operators

        /// <summary>Factory for creating Wireless Lines from db.Wireless lines.</summary>
        /// <param name="orderId">The order id.</param>
        /// <returns>The <see cref="WirelessLine[]"/>.</returns>
        public WirelessLine[] GetWirelessLinesFromOrder(int orderId)
        {
            WirelessLine[] wirelessLines;

            // get all lines for this order.
            var db = new DbUtility().GetDataContext();

            try
            {
                var query = from p in db.WirelessLines
                                                    join od in db.OrderDetails on p.OrderDetailId equals
                                                        od.OrderDetailId
                                                    where od.OrderId == orderId && od.OrderDetailType == 'd'
                                                    select p;
                var lines = query.ToList();

                wirelessLines = new WirelessLine[lines.Count];
                var i = 0;
                foreach (var line in lines)
                {
                    wirelessLines[i] = new WirelessLine(line.OrderDetailId);
                    i++;
                }
            }
            catch (Exception ex)
            {
                throw new Exception("WirelessLine.GetWirelessLinesFromOrder Failing", ex);
            }
            finally
            {
                if (db.Connection.State != ConnectionState.Closed)
                {
                    db.Connection.Close();
                }
            }

            return wirelessLines;
        }

        #endregion
    }
}