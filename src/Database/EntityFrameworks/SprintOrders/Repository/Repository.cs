// --------------------------------------------------------------------------------------------------------------------
// <copyright file="Repository.cs" company="">
//   
// </copyright>
// <summary>
//   The repository.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintOrdersData
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;

    using SprintOrders;

    /// <summary>The repository.</summary>
    public class Repository : IRepository
    {
        #region Public Methods and Operators

        /// <summary>The get all devices.</summary>
        /// <returns>The <see cref="List" />.</returns>
        public List<Device> GetAllDevices()
        {
            using (var context = new SprintOrders())
            {
                var query = from a in context.Devices select a;
                return query.ToList();
            }
        }

        /// <summary>The get complete order detail.</summary>
        /// <param name="orderId">The order id.</param>
        /// <returns>The <see cref="OrderDetail"/>.</returns>
        public List<OrderDetail> GetCompleteOrderDetail(int orderId)
        {
            using (var context = new SprintOrders())
            {
                var order = context.OrderDetails
                    .Include(a => a.WirelessLines)
                    .Include(a => a.LineServices)
                    .Where(a => a.OrderId == orderId);

                return order.ToList();
            }
        }

        /// <summary>The get device.</summary>
        /// <param name="deviceGuid">The device guid.</param>
        /// <returns>The <see cref="Device"/>.</returns>
        public Device GetDevice(Guid deviceGuid)
        {
            using (var context = new SprintOrders())
            {
                var query = from a in context.Devices where a.DeviceGuid == deviceGuid select a;
                return query.FirstOrDefault();
            }
        }

        /// <summary>The get order.</summary>
        /// <param name="orderId">The order id.</param>
        /// <returns>The <see cref="Order"/>.</returns>
        public Order GetOrder(int orderId)
        {
            using (var context = new SprintOrders())
            {
                var query = from a in context.Orders where a.OrderId == orderId select a;
                return query.FirstOrDefault();
            }
        }

        /// <summary>The get wireless line.</summary>
        /// <param name="wirelessLineId">The wireless line id.</param>
        /// <returns>The <see cref="WirelessLine"/>.</returns>
        public WirelessLine GetWirelessLine(int wirelessLineId)
        {
            using (var context = new SprintOrders())
            {
                var query = from a in context.WirelessLines where a.WirelessLineId == wirelessLineId select a;
                return query.FirstOrDefault();
            }
        }

        /// <summary>The get wireless line order detail.</summary>
        /// <param name="orderId">The order id.</param>
        /// <returns>The <see cref="List"/>.</returns>
        public List<OrderDetail> GetWirelessLineOrderDetail(int orderId)
        {
            using (var context = new SprintOrders())
            {
                var order = context.OrderDetails
                    .Include(a => a.WirelessLines)
                    .Include(a => a.LineServices)
                    .Where(a => a.OrderId == orderId)
                    .Where(a => a.OrderDetailType == "d");

                return order.ToList();
            }
        }

        #endregion
    }
}