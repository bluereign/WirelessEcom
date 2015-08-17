// --------------------------------------------------------------------------------------------------------------------
// <copyright file="IRepository.cs" company="">
//   
// </copyright>
// <summary>
//   The Repository interface.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintOrdersData
{
    using System;
    using System.Collections.Generic;

    using SprintOrders;

    /// <summary>The Repository interface.</summary>
    public interface IRepository
    {
        #region Public Methods and Operators

        /// <summary>The get all.</summary>
        /// <returns>The <see cref="List" />.</returns>
        List<Device> GetAllDevices();

        /// <summary>The get complete order.</summary>
        /// <param name="orderId">The order id.</param>
        /// <returns>The <see cref="Order"/>.</returns>
        List<OrderDetail> GetCompleteOrderDetail(int orderId);

        /// <summary>The get device.</summary>
        /// <param name="deviceGuid">The device guid.</param>
        /// <returns>The <see cref="Device"/>.</returns>
        Device GetDevice(Guid deviceGuid);

        /// <summary>The get order.</summary>
        /// <param name="orderId">The order id.</param>
        /// <returns>The <see cref="Order"/>.</returns>
        Order GetOrder(int orderId);

        /// <summary>The get wireless line.</summary>
        /// <param name="wirelessLineId">The wireless line id.</param>
        /// <returns>The <see cref="WirelessLine"/>.</returns>
        WirelessLine GetWirelessLine(int wirelessLineId);

        /// <summary>The get complete order.</summary>
        /// <param name="orderId">The order id.</param>
        /// <returns>The <see cref="Order"/>.</returns>
        List<OrderDetail> GetWirelessLineOrderDetail(int orderId);

        #endregion
    }
}