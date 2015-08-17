// --------------------------------------------------------------------------------------------------------------------
// <copyright file="WirelessLine.cs" company="">
//   
// </copyright>
// <summary>
//   The device technology.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace WirelessAdvocates.SalesOrder
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Linq;

    using DB;

    using WirelessAdvocates.Enum;

    /// <summary>The device technology.</summary>
    public enum DeviceTechnology
    {
        /// <summary>The gsm.</summary>
        GSM, 

        /// <summary>The umts.</summary>
        UMTS, 

        /// <summary>The unknown.</summary>
        UNKNOWN
    }

    /// <summary>The wireless line.</summary>
    public class WirelessLine : OrderDetail
    {
        #region Fields

        /// <summary>The _order detail id.</summary>
        private readonly int orderDetailId;

        /// <summary>The _activation status.</summary>
        private ActivationStatus? activationStatus = WirelessAdvocates.Enum.ActivationStatus.None;

        /// <summary>The _carrier plan id.</summary>
        private string carrierPlanId = string.Empty;

        /// <summary>The _contract length.</summary>
        private int contractLength;

        /// <summary>The _current carrier.</summary>
        private int? currentCarrier = 0;

        /// <summary>The _current mdn.</summary>
        private string currentMDN = string.Empty;

        /// <summary>The _device technology.</summary>
        private DeviceTechnology deviceTechnology = DeviceTechnology.UNKNOWN;

        /// <summary>The _esn.</summary>
        private string esn = string.Empty;

        /// <summary>The _full sim.</summary>
        private string fullSim = string.Empty;

        /// <summary>The _imei.</summary>
        private string imei = string.Empty;

        /// <summary>The _is dirty.</summary>
        private bool isDirty;

        /// <summary>The _is mdn port.</summary>
        private bool? isMdnPort = false;

        /// <summary>The _market code.</summary>
        private string marketCode = string.Empty;

        /// <summary>The _monthly fee.</summary>
        private decimal? monthlyFee = 0;

        /// <summary>The _new mdn.</summary>
        private string newMDN = string.Empty;

        /// <summary>The _npa requested.</summary>
        private string npaRequested = string.Empty;

        /// <summary>The _plan id.</summary>
        private int planId;

        /// <summary>The _plan type.</summary>
        private string planType = string.Empty;

        /// <summary>The _ port in carrier account.</summary>
        private string portInCarrierAccount;

        /// <summary>The _ port in carrier pin.</summary>
        private string portInCarrierPin;

        /// <summary>The _port in due date.</summary>
        private DateTime? portInDueDate;

        /// <summary>The _port requested id.</summary>
        private string portRequestedId = string.Empty;

        /// <summary>The _port response.</summary>
        private string portResponse = string.Empty;

        /// <summary>The _port status.</summary>
        private string portStatus = string.Empty;

        /// <summary>The _requested activation date.</summary>
        private DateTime? requestedActivationDate;

        /// <summary>The _sim.</summary>
        private string sim = string.Empty;

        /// <summary>The _upgrade eligible.</summary>
        private bool? upgradeEligible = false;

        /// <summary>The _wireless line devices.</summary>
        private Device[] wirelessLineDevices = new Device[0];

        /// <summary>The _wireless line id.</summary>
        private int wirelessLineId;

        /// <summary>The _wireless line services.</summary>
        private WirelessLineService[] wirelessLineServices = new WirelessLineService[0];

        #endregion

        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="WirelessLine"/> class.</summary>
        /// <param name="orderDetailId">The order detail id.</param>
        public WirelessLine(int orderDetailId)
            : base(orderDetailId)
        {
            this.orderDetailId = orderDetailId;
            this.FillWirelessLine();
        }

        #endregion

        #region Public Properties

        /// <summary>Gets or sets the activation status.</summary>
        public ActivationStatus? ActivationStatus
        {
            get
            {
                return this.activationStatus;
            }

            set
            {
                this.activationStatus = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the carrier plan id.</summary>
        public string CarrierPlanId
        {
            get
            {
                return this.carrierPlanId;
            }

            set
            {
                this.carrierPlanId = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the contract length.</summary>
        public int ContractLength
        {
            get
            {
                return this.contractLength;
            }

            set
            {
                this.contractLength = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the current carrier.</summary>
        public int? CurrentCarrier
        {
            get
            {
                return this.currentCarrier;
            }

            set
            {
                this.currentCarrier = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the current mdn.</summary>
        public string CurrentMDN
        {
            get
            {
                return this.currentMDN;
            }

            set
            {
                this.currentMDN = value;
                this.newMDN = null;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the esn.</summary>
        public string ESN
        {
            get
            {
                return this.esn;
            }

            set
            {
                this.esn = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the imei.</summary>
        public string IMEI
        {
            get
            {
                return this.imei;
            }

            set
            {
                this.imei = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets a value indicating whether is dirty.</summary>
        public bool IsDirty
        {
            get
            {
                return this.isDirty;
            }
        }

        /// <summary>Gets or sets the is mdn port.</summary>
        public bool? IsMdnPort
        {
            get
            {
                return this.isMdnPort;
            }

            set
            {
                this.isMdnPort = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the market code.</summary>
        public string MarketCode
        {
            get
            {
                return this.marketCode;
            }

            set
            {
                this.marketCode = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the monthly fee.</summary>
        public decimal? MonthlyFee
        {
            get
            {
                return this.monthlyFee;
            }

            set
            {
                this.monthlyFee = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the npa requested.</summary>
        public string NPARequested
        {
            get
            {
                return this.npaRequested;
            }

            set
            {
                this.npaRequested = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the new mdn.</summary>
        public string NewMDN
        {
            get
            {
                return this.newMDN;
            }

            set
            {
                this.newMDN = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the plan id.</summary>
        public int PlanId
        {
            get
            {
                return this.planId;
            }

            set
            {
                this.planId = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the plan type.</summary>
        public string PlanType
        {
            get
            {
                return this.planType;
            }

            set
            {
                this.planType = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the port in carrier account.</summary>
        public string PortInCarrierAccount
        {
            get
            {
                return this.portInCarrierAccount;
            }

            set
            {
                this.portInCarrierAccount = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the port in carrier pin.</summary>
        public string PortInCarrierPin
        {
            get
            {
                return this.portInCarrierPin;
            }

            set
            {
                this.portInCarrierPin = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the port in due date.</summary>
        public DateTime? PortInDueDate
        {
            get
            {
                return this.portInDueDate;
            }

            set
            {
                this.portInDueDate = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the port requested id.</summary>
        public string PortRequestedId
        {
            get
            {
                return this.portRequestedId;
            }

            set
            {
                this.portRequestedId = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the port response.</summary>
        public string PortResponse
        {
            get
            {
                return this.portResponse;
            }

            set
            {
                this.portResponse = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the port status.</summary>
        public string PortStatus
        {
            get
            {
                return this.portStatus;
            }

            set
            {
                this.portStatus = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the requested activation date.</summary>
        public DateTime? RequestedActivationDate
        {
            get
            {
                return this.requestedActivationDate;
            }

            set
            {
                this.requestedActivationDate = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the sim.</summary>
        /// <exception cref="Exception"></exception>
        public string Sim
        {
            get
            {
                // var result = string.Empty; // will hold the temp SIM.

                //// This code will grab the SIM from the order
                //// or a SIM from the database depending on the config file setting.
                // var useTestSIM = false;
                // var config = new WaConfigurationManager(HttpContext.Current.Server.MapPath(string.Empty));
                // if (!string.IsNullOrEmpty(config.AppSetting("UseTestSIM")))
                // {
                // if (config.AppSetting("UseTestSIM") == "true")
                // {
                // useTestSIM = true;
                // }
                // }

                // if (useTestSIM)
                // {
                // // use the test SIMS
                // Trace.TraceInformation(
                // "App Setting 'UseTestSIM' is set to true. For production, this should be set to false or not included in the web configuration file. When set to true, SIMS are pulled from a temp table called TestSIMS.");
                // var db = new DbUtility().GetDataContext();
                // try
                // {
                // var sim = (from p in db.TestSIMs where p.Used == false select p).First();
                // if (sim != null)
                // {
                // result = sim.SIM;

                // // update the sim as used.
                // sim.Used = true;

                // db.ExecuteCommand("update service.testsims set used = 1 where sim = '" + result + "'");
                // }
                // else
                // {
                // throw new Exception("Out of test SIMS!");
                // }
                // }
                // catch (Exception ex)
                // {
                // Trace.TraceWarning(ex.ToString());
                // }
                // finally
                // {
                // if (db.Connection.State != ConnectionState.Closed)
                // {
                // db.Connection.Close();
                // }
                // }

                // return result;
                // }

                // use the real SIM from the order.
                return this.sim;
            }

            set
            {
                this.sim = value;
            }
        }

        /// <summary>Gets the unmodified sim.</summary>
        public string UnmodifiedSim
        {
            get
            {
                return this.fullSim;
            }
        }

        /// <summary>Gets or sets the upgrade eligible.</summary>
        public bool? UpgradeEligible
        {
            get
            {
                return this.upgradeEligible;
            }

            set
            {
                this.upgradeEligible = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the wireless line id.</summary>
        public int WirelessLineId
        {
            get
            {
                return this.wirelessLineId;
            }

            set
            {
                this.wirelessLineId = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the wireless line services.</summary>
        public WirelessLineService[] WirelessLineServices
        {
            get
            {
                return this.wirelessLineServices;
            }

            set
            {
                this.wirelessLineServices = value;
                this.isDirty = true;
            }
        }

        #endregion

        #region Properties

        /// <summary>Gets the device type.</summary>
        protected DeviceTechnology DeviceType
        {
            // Currently only needed and implemented for the AT&T catalog
            get
            {
                try
                {
                    if (this.deviceTechnology == DeviceTechnology.UNKNOWN)
                    {
                        int productId = this.ProductId;

                        WirelessAdvocatesDataClassesDataContext db = new DbUtility().GetDataContext();

                        string sql = "SELECT pr.Value FROM catalog.Product AS p WITH (NOLOCK) ";
                        sql += "JOIN catalog.Property AS pr WITH (NOLOCK) ON p.ProductGuid = pr.ProductGuid ";
                        sql += "WHERE ProductId = " + productId
                               + " AND  LastModifiedBy = 'system' and Name = 'PartType'";

                        Property deviceType = db.ExecuteQuery<Property>(sql).First();

                        switch (deviceType.Value)
                        {
                            case "GSM":
                                this.deviceTechnology = DeviceTechnology.GSM;
                                break;
                            case "UMTS":
                                this.deviceTechnology = DeviceTechnology.UMTS;
                                break;
                            default:
                                this.deviceTechnology = DeviceTechnology.UNKNOWN;
                                break;
                        }

                        if (db.Connection.State == ConnectionState.Open)
                        {
                            db.Connection.Close();
                        }
                    }
                }
                catch (Exception)
                {
                    this.deviceTechnology = DeviceTechnology.UNKNOWN;
                }

                return this.deviceTechnology;
            }
        }

        /// <summary>Gets or sets the wireless line devices.</summary>
        protected Device[] WirelessLineDevices
        {
            get
            {
                // find all the device for wireless line. where OrderDetailType = 'd' and GroupNumber = OrderDetailId.GroupNumber
                if (this.wirelessLineId != 0 & this.wirelessLineDevices.Length == 0)
                {
                    // if there is an id, then there is an entry in the DB.
                    WirelessAdvocatesDataClassesDataContext db = new DbUtility().GetDataContext();

                    try
                    {
                        string sql = "SELECT DOD.* ";
                        sql += "    FROM salesorder.OrderDetail AS DOD INNER JOIN ";
                        sql += "         salesorder.WirelessLine AS WL INNER JOIN ";
                        sql +=
                            "         salesorder.OrderDetail AS WLOD ON WL.OrderDetailId = WLOD.OrderDetailId ON DOD.OrderId = WLOD.OrderId ";
                        sql += "    WHERE (WL.WirelessLineId = {0}) and DOD.OrderDetailType = 'D' ";

                        IEnumerable<DB.OrderDetail> dbDevices = db.ExecuteQuery<DB.OrderDetail>(
                            sql, 
                            this.WirelessLineId);
                        DB.OrderDetail[] devices = dbDevices.ToArray();
                        this.wirelessLineDevices = new Device[devices.Length];
                        int i = 0;
                        foreach (DB.OrderDetail device in devices)
                        {
                            this.wirelessLineDevices[i] = new Device(device.OrderDetailId);
                            i++;
                        }
                    }
                    catch (Exception ex)
                    {
                    }
                    finally
                    {
                        if (db.Connection.State != ConnectionState.Closed)
                        {
                            db.Connection.Close();
                        }
                    }
                }

                return this.wirelessLineDevices;
            }

            set
            {
                this.wirelessLineDevices = value;
            }
        }

        #endregion

        #region Public Methods and Operators

        /// <summary>The save.</summary>
        /// <returns>The <see cref="bool" />.</returns>
        public bool Save()
        {
            if (!this.isDirty)
            {
                return !this.isDirty;
            }

            WirelessAdvocatesDataClassesDataContext db = new DbUtility().GetDataContext();

            try
            {
                DB.WirelessLine line = db.WirelessLines.First(p => p.OrderDetailId == this.orderDetailId);
                ActivationStatus? status = this.activationStatus;
                if (status != null)
                {
                    line.ActivationStatus = (int)status;
                }

                line.CarrierPlanId = this.carrierPlanId;
                line.ContractLength = this.contractLength;
                line.CurrentCarrier = this.currentCarrier;
                line.CurrentMDN = this.currentMDN;
                line.ESN = this.esn;
                line.IMEI = this.imei;
                line.IsMDNPort = this.isMdnPort;
                line.MarketCode = this.marketCode;
                if (this.monthlyFee != null)
                {
                    line.MonthlyFee = this.monthlyFee;
                }

                line.NewMDN = this.newMDN;
                line.NPARequested = this.npaRequested;
                line.PlanId = this.planId;
                line.PlanType = this.planType;
                if (this.portInDueDate != null)
                {
                    line.PortInDueDate = this.portInDueDate;
                }

                line.PortRequestId = this.portRequestedId;
                line.PortInCurrentCarrierAccountNumber = this.portInCarrierAccount;
                line.PortInCurrentCarrierPin = this.portInCarrierPin;
                line.PortResponse = this.portResponse;
                line.PortStatus = this.portStatus;
                if (this.requestedActivationDate != null)
                {
                    line.RequestedActivationDate = this.requestedActivationDate;
                }

                // line.SIM = _sim;
                line.UpgradeEligible = this.upgradeEligible;
                db.SubmitChanges();

                this.Save();

                this.isDirty = false;
            }
            catch (Exception ex)
            {
                throw new Exception("WirelessLine.Save Failed", ex);
            }
            finally
            {
                if (db.Connection.State != ConnectionState.Closed)
                {
                    db.Connection.Close();
                }
            }

            return !this.isDirty;
        }

        #endregion

        #region Methods

        /// <summary>The fill wireless line.</summary>
        /// <exception cref="Exception"></exception>
        private void FillWirelessLine()
        {
            WirelessAdvocatesDataClassesDataContext db = new DbUtility().GetDataContext();

            IQueryable<DB.WirelessLine> query = from p in db.WirelessLines
                                                where p.OrderDetailId == this.orderDetailId
                                                select p;
            var lines = query.ToList();

            if (lines.Count == 0)
            {
                throw new Exception(string.Format("Expected one line, but received {0} for orderId {1}", lines.Count(), this.orderDetailId));
            } 

            try
            {
                var line = lines.First();
                this.wirelessLineId = line.WirelessLineId;

                this.wirelessLineServices =
                   WirelessLineService.GetWirelessLineServicesByWirelessLine(this.wirelessLineId);

                this.activationStatus = line.ActivationStatus != null
                                            ? (ActivationStatus)line.ActivationStatus.Value
                                            : WirelessAdvocates.Enum.ActivationStatus.None;

                this.carrierPlanId = line.CarrierPlanId;

                if (line.ContractLength != null)
                {
                    this.contractLength = line.ContractLength.Value;
                }

                this.currentCarrier = line.CurrentCarrier;
                this.currentMDN = line.CurrentMDN;
                this.esn = line.ESN;
                this.imei = line.IMEI;
                this.isMdnPort = line.IsMDNPort;
                this.marketCode = line.MarketCode;
                this.monthlyFee = line.MonthlyFee;
                this.newMDN = line.NewMDN;
                this.npaRequested = line.NPARequested;

                if (line.PlanId != null)
                {
                    this.planId = line.PlanId.Value;
                }

                this.planType = line.PlanType;
                this.portInDueDate = line.PortInDueDate;
                this.portRequestedId = line.PortRequestId;
                this.portResponse = line.PortResponse;
                this.portStatus = line.PortStatus;
                this.portInCarrierAccount = line.PortInCurrentCarrierAccountNumber;
                this.portInCarrierPin = line.PortInCurrentCarrierPin;

                if (line.RequestedActivationDate != null)
                {
                    this.requestedActivationDate = line.RequestedActivationDate.Value;
                }

                this.sim = line.SIM;

                if (line.UpgradeEligible != null)
                {
                    this.upgradeEligible = line.UpgradeEligible.Value;
                }

                this.sim = line.SIM;
                this.fullSim = line.SIM; // For some reason we truncated for TMO, ATT needs full 20!

                // Truncate the sim to 19 chars.
                if (!string.IsNullOrEmpty(this.sim))
                {
                    this.sim = this.sim.Substring(0, 19);
                }
            }
            catch (Exception ex)
            {
                throw new Exception(
                    string.Format("Error loading wireless line {0}: ({1})", this.orderDetailId, ex.Message), 
                    ex);
            }
            finally
            {
                if (db.Connection.State != ConnectionState.Closed)
                {
                    db.Connection.Close();
                }
            }
        }

        #endregion
    }
}