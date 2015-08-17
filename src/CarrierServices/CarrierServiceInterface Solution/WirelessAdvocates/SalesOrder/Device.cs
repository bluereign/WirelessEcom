// --------------------------------------------------------------------------------------------------------------------
// <copyright file="Device.cs" company="">
//   
// </copyright>
// <summary>
//   The device.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace WirelessAdvocates.SalesOrder
{
    using System;
    using System.Collections.Generic;
    using System.Linq;

    /// <summary>The device.</summary>
    public class Device : OrderDetail
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="Device"/> class.</summary>
        /// <param name="orderDetailId">The order detail id.</param>
        public Device(int orderDetailId) : base(orderDetailId)
        {
            this.Title = string.Empty;
            this.CarrierBillCode = string.Empty;
            this.FillDeviceAttributes();
        }

        #endregion

        #region Public Properties

        /// <summary>Gets the carrier bill code.</summary>
        public string CarrierBillCode { get; private set; }

        /// <summary>Gets the title.</summary>
        public string Title { get; private set; }

        #endregion

        // TODO: CONVERT TO LINQ expression
        #region Methods

        /// <summary>The fill device attributes.</summary>
        /// <exception cref="Exception"></exception>
        private void FillDeviceAttributes()
        {
            int productId = this.ProductId;

            WirelessAdvocatesDataClassesDataContext db = new DbUtility().GetDataContext();

            string sql = "select d.* from catalog.Device d ";
            sql += "    inner join catalog.Product p on p.ProductGuid = d.DeviceGuid  ";
            sql += "    where p.ProductId = {0} ";

            IEnumerable<DB.Device> devices = db.ExecuteQuery<DB.Device>(sql, productId);
            DB.Device device = devices.First();

            if (device != null)
            {
                this.CarrierBillCode = device.UPC;
                this.Title = device.Name;
            }
            else
            {
                throw new Exception("Device is not defined.");
            }
        }

        #endregion
    }
}