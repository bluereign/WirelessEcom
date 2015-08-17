// --------------------------------------------------------------------------------------------------------------------
// <copyright file="WirelessLineService.cs" company="">
//   
// </copyright>
// <summary>
//   The wireless line service.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace WirelessAdvocates.SalesOrder
{
    using System;
    using System.Collections.Generic;
    using System.Linq;

    using DB;

    /// <summary>The wireless line service.</summary>
    public class WirelessLineService : OrderDetail
    {
        #region Fields

        /// <summary>The _title.</summary>
        private string title = string.Empty;

        #endregion

        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="WirelessLineService"/> class.</summary>
        /// <param name="orderDetailId">The order detail id.</param>
        public WirelessLineService(int orderDetailId) : base(orderDetailId)
        {
            this.ServiceType = string.Empty;
            this.CarrierServiceId = string.Empty;
            this.FillLineService();
        }

        #endregion

        #region Public Properties

        /// <summary>Gets or sets the carrier service id.</summary>
        public string CarrierServiceId { get; set; }

        /// <summary>Gets or sets the line service id.</summary>
        public int LineServiceId { get; set; }

        /// <summary>Gets or sets the monthly fee.</summary>
        public decimal MonthlyFee { get; set; }

        /// <summary>Gets or sets the service type.</summary>
        public string ServiceType { get; set; }

        /// <summary>Gets or sets the title.</summary>
        public string Title
        {
            get
            {
                if (this.title == string.Empty & this.LineServiceId != 0)
                {
                    this.FillLineServiceAttributes();
                }

                return this.title;
            }

            set
            {
                this.title = value;
            }
        }

        #endregion

        #region Public Methods and Operators

        /// <summary>The get wireless line services by wireless line.</summary>
        /// <param name="wirelessLineId">The wireless line id.</param>
        /// <returns>The <see cref="WirelessLineService[]"/>.</returns>
        public static WirelessLineService[] GetWirelessLineServicesByWirelessLine(int wirelessLineId)
        {
            var wirelessLineServices = new WirelessLineService[0];

            WirelessAdvocatesDataClassesDataContext db = new DbUtility().GetDataContext();

            /*string sql = "SELECT LS.* ";
            sql += "    FROM salesorder.OrderDetail AS LSOD INNER JOIN ";
            sql += "         salesorder.LineService AS LS ON LSOD.OrderDetailId = LS.OrderDetailId INNER JOIN ";
            sql += "         salesorder.WirelessLine AS WL INNER JOIN ";
            sql += "         salesorder.OrderDetail AS WLOD ON WL.OrderDetailId = WLOD.OrderDetailId ON LSOD.OrderId = WLOD.OrderId ";
            sql += "    WHERE (WL.WirelessLineId = {0}) and LSOD.OrderDetailType = 's' and CarrierServiceId IS NOT NULL";*/
            string sql = "SELECT		od.OrderDetailId, od.GroupNumber, od.OrderId ";
            sql += "INTO		#DeviceLine ";
            sql += "FROM		salesorder.WirelessLine AS wl WITH (NOLOCK) ";
            sql += "INNER JOIN	salesorder.OrderDetail AS od WITH (NOLOCK) ON od.OrderDetailId = wl.OrderDetailId ";
            sql += "WHERE		wl.WirelessLineId = {0}; ";

            sql += "SELECT		ls.* ";
            sql += "FROM		salesorder.OrderDetail AS od WITH (NOLOCK) ";
            sql += "INNER JOIN	#DeviceLine AS dl ON dl.OrderId = od.OrderId AND dl.GroupNumber = od.GroupNumber ";
            sql += "INNER JOIN	salesorder.LineService AS ls WITH (NOLOCK) ON ls.OrderDetailId = od.OrderDetailId ";
            sql += "WHERE		od.OrderDetailType = 'S'; ";

            sql += "DROP TABLE #DeviceLine ";

            IEnumerable<LineService> dbServices = db.ExecuteQuery<LineService>(sql, wirelessLineId);

            if (dbServices != null)
            {
                LineService[] services = dbServices.ToArray();

                wirelessLineServices = new WirelessLineService[services.Length];
                int i = 0;

                foreach (LineService service in services)
                {
                    wirelessLineServices[i] = new WirelessLineService(service.OrderDetailId);
                    i++;
                }
            }

            return wirelessLineServices;
        }

        #endregion

        #region Methods

        /// <summary>The fill line service.</summary>
        /// <exception cref="Exception"></exception>
        private void FillLineService()
        {
            var orderDetailId = this.OrderDetailId;

            WirelessAdvocatesDataClassesDataContext db = new DbUtility().GetDataContext();
            
            IQueryable<LineService> services = from p in db.LineServices where p.OrderDetailId == orderDetailId select p;

            if (services.Count() != 0)
            {
                LineService line = services.First();
                this.LineServiceId = line.LineServiceId;
                this.OrderDetailId = line.OrderDetailId;
                this.ServiceType = line.ServiceType.Trim();
                this.CarrierServiceId = line.CarrierServiceId.Trim();
                this.MonthlyFee = line.MonthlyFee.Value;
            }
            else
            {
                throw new Exception("No line services could be found.");
            }
        }

        /// <summary>The fill line service attributes.</summary>
        /// <exception cref="Exception"></exception>
        private void FillLineServiceAttributes()
        {
            var productId = this.ProductId;

            WirelessAdvocatesDataClassesDataContext db = new DbUtility().GetDataContext();
            

            string sql = "SELECT s.* FROM catalog.Service AS s WITH (NOLOCK) ";
            sql += "INNER JOIN catalog.Product AS p WITH (NOLOCK) ON p.ProductGuid = s.ServiceGuid ";
            sql += "WHERE p.ProductId = {0} ";

            Service service = db.ExecuteQuery<Service>(sql, productId).First();

            if (service != null)
            {
                this.title = service.Title;
            }
            else
            {
                throw new Exception("No title from catalog.service");
            }
        }

        #endregion
    }
}