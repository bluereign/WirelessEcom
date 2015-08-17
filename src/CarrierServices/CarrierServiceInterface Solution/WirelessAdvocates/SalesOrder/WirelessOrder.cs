// --------------------------------------------------------------------------------------------------------------------
// <copyright file="WirelessOrder.cs" company="">
//   
// </copyright>
// <summary>
//   The wireless order.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace WirelessAdvocates.SalesOrder
{
    using System;
    using System.Data;
    using System.Data.Linq;
    using System.Linq;

    using DB;

    /// <summary>The wireless order.</summary>
    public class WirelessOrder : Order
    {
        #region Fields

        /// <summary>The _activation status.</summary>
        private int? activationStatus = 0;

        /// <summary>The _bill cycle date.</summary>
        private DateTime? billCycleDate;

        /// <summary>The _carrier order date.</summary>
        private DateTime carrierOrderDate;

        /// <summary>
        ///     Reference Id that is used by the carriers.
        /// </summary>
        private string carrierOrderId = string.Empty;

        /// <summary>The _current acct number.</summary>
        private string currentAcctNumber;

        /// <summary>The _current acct pin.</summary>
        private string currentAcctPin;

        /// <summary>The _dob.</summary>
        private DateTime? dob;

        /// <summary>The _drivers license expires.</summary>
        private DateTime? driversLicenseExpires;

        /// <summary>The _drivers license number.</summary>
        private string driversLicenseNumber = string.Empty;

        /// <summary>The _drivers license state.</summary>
        private string driversLicenseState = string.Empty;

        /// <summary>The _family plan.</summary>
        private short? familyPlan;

        /// <summary>The _is dirty.</summary>
        private bool isDirty;

        /// <summary>The _ssn.</summary>
        private string ssn = string.Empty;

        /// <summary>The _wireless account id.</summary>
        private int wirelessAccountId;

        /// <summary>The _wirelesslines.</summary>
        private WirelessLine[] wirelesslines;

        #endregion

        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="WirelessOrder"/> class.</summary>
        /// <param name="orderId">The order id.</param>
        /// <exception cref="Exception"></exception>
        public WirelessOrder(int orderId) : base(orderId)
        {
            // Get the WirelessAccountId from the OrderId
            var db = new DbUtility().GetDataContext();

            var query = from p in db.WirelessAccounts where p.OrderId == orderId select p;

            var wirelessAccount = query.FirstOrDefault();

            if (wirelessAccount == null)
            {
                throw new Exception(string.Format("No matching account found in local WirelessOrder db for order {0}", orderId));
            }

            this.wirelessAccountId = wirelessAccount.WirelessAccountId;

            this.FillWirelessOrder();
        }

        /// <summary>Initializes a new instance of the <see cref="WirelessOrder"/> class.</summary>
        /// <param name="carrierAccountNumber">The carrier account number.</param>
        /// <param name="activationStatus">The activation status.</param>
        /// <exception cref="Exception"></exception>
        public WirelessOrder(string carrierAccountNumber, int activationStatus)
        {
            var db = new DbUtility().GetDataContext();

            var query = from p in db.WirelessAccounts
                        where p.CurrentAcctNumber == carrierAccountNumber && p.ActivationStatus == activationStatus
                        select p;

            var wirelessAccount = query.FirstOrDefault();

            if (wirelessAccount == null)
            {
                throw new Exception(string.Format("No matching Account found in local WirelessOrder db for SQL query for Account {0} in Activation Status  {1} ", carrierAccountNumber, activationStatus));
            }

            this.wirelessAccountId = wirelessAccount.WirelessAccountId;
            this.Fill(wirelessAccount.OrderId);

            this.FillWirelessOrder();
        }

        /// <summary>Initializes a new instance of the <see cref="WirelessOrder"/> class.</summary>
        /// <param name="referenceNumber">The reference number.</param>
        /// <exception cref="Exception"></exception>
        ////public WirelessOrder(string referenceNumber) : base(referenceNumber)
        ////{
        ////    int orderId = OrderId;

        ////    // Get the WirelessAccountId from the OrderId
        ////    WirelessAdvocatesDataClassesDataContext db = new DbUtility().GetDataContext();
            

        ////    IQueryable<WirelessAccount> wirelessAccounts = from p in db.WirelessAccounts
        ////                                                   where p.OrderId == orderId
        ////                                                   select p;

        ////    if (wirelessAccounts.Count() == 0)
        ////    {
        ////        throw new Exception("WirelessAccounts should only contain 1 record.");
        ////    }

        ////    WirelessAccount account = wirelessAccounts.First();
        ////    this.wirelessAccountId = account.WirelessAccountId;

        ////    this.FillWirelessOrder();
        ////}

        #endregion

        #region Public Properties

        /// <summary>Gets or sets the activation status.</summary>
        public int? ActivationStatus
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

        /// <summary>Gets or sets the bill cycle date.</summary>
        public DateTime? BillCycleDate
        {
            get
            {
                return this.billCycleDate;
            }

            set
            {
                this.billCycleDate = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the carrier order date.</summary>
        public DateTime CarrierOrderDate
        {
            get
            {
                return this.carrierOrderDate;
            }

            set
            {
                this.carrierOrderDate = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the carrier order id.</summary>
        public string CarrierOrderId
        {
            get
            {
                return this.carrierOrderId;
            }

            set
            {
                this.carrierOrderId = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the current account number.</summary>
        public string CurrentAccountNumber
        {
            get
            {
                return this.currentAcctNumber;
            }

            set
            {
                this.currentAcctNumber = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the current account pin.</summary>
        public string CurrentAccountPIN
        {
            get
            {
                if (this.currentAcctPin == null && this.ssn != null)
                {
                    return this.ssn.Substring(this.SSN.Length - 4);
                }

                return this.currentAcctPin;
            }

            set
            {
                this.currentAcctPin = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the dob.</summary>
        public DateTime? Dob
        {
            get
            {
                return this.dob;
            }

            set
            {
                this.dob = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the drivers license expires.</summary>
        public DateTime? DriversLicenseExpires
        {
            get
            {
                return this.driversLicenseExpires;
            }

            set
            {
                this.driversLicenseExpires = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the drivers license number.</summary>
        public string DriversLicenseNumber
        {
            get
            {
                return this.driversLicenseNumber;
            }

            set
            {
                this.driversLicenseNumber = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the drivers license state.</summary>
        public string DriversLicenseState
        {
            get
            {
                return this.driversLicenseState;
            }

            set
            {
                this.driversLicenseState = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets a value indicating whether is family plan.</summary>
        public bool IsFamilyPlan
        {
            get
            {
                return this.familyPlan != null && this.familyPlan > 0;
            }
        }

        /// <summary>Gets or sets the ssn.</summary>
        public string SSN
        {
            get
            {
                return this.ssn;
            }

            set
            {
                this.ssn = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the wireless account id.</summary>
        public int WirelessAccountId
        {
            get
            {
                return this.wirelessAccountId;
            }

            set
            {
                this.wirelessAccountId = value;
                this.isDirty = true;
            }
        }

        /// <summary>Gets or sets the wireless lines.</summary>
        public WirelessLine[] WirelessLines
        {
            get
            {
                return this.wirelesslines;
            }

            set
            {
                this.wirelesslines = value;
                this.isDirty = true;
            }
        }

        #endregion

        #region Public Methods and Operators

        /// <summary>The get wireless line.</summary>
        /// <param name="mdn">The mdn.</param>
        /// <returns>The <see cref="WirelessLine"/>.</returns>
        public WirelessLine GetWirelessLine(string mdn)
        {
            return this.WirelessLines.FirstOrDefault(line => (line.CurrentMDN != null && line.CurrentMDN == mdn) || (line.NewMDN != null && line.NewMDN == mdn));
        }

        /// <summary>The save.</summary>
        /// <returns>The <see cref="bool"/>.</returns>
        public bool Save()
        {
            if (this.isDirty)
            {
                var db = new DbUtility().GetDataContext();
                
                try
                {
                    // var wirelessOrder = db.WirelessAccounts.First(p => p.WirelessAccountId == _wirelessAccountId);
                    ISingleResult<GetWirelessAccountByWirelessAccountIdResult> wirelessAccounts =
                        db.GetWirelessAccountByWirelessAccountId(this.wirelessAccountId); // Used for encrypted version

                    // var wirelessAccounts = from p in db.WirelessAccounts where p.WirelessAccountId == _wirelessAccountId select p; //used for non encrypted version.
                    GetWirelessAccountByWirelessAccountIdResult wirelessOrder = wirelessAccounts.First();

                    db.UpdateWirelessAccount(
                        this.wirelessAccountId, 
                        this.OrderId, 
                        wirelessOrder.FamilyPlan, 
                        this.carrierOrderDate, 
                        wirelessOrder.SSN, 
                        this.dob, 
                        wirelessOrder.DrvLicNumber, 
                        this.driversLicenseState, 
                        this.driversLicenseExpires, 
                        wirelessOrder.FirstName, 
                        wirelessOrder.Initial, 
                        wirelessOrder.LastName, 
                        this.carrierOrderId, 
                        this.currentAcctNumber, 
                        this.currentAcctPin, 
                        wirelessOrder.CurrentTotalLines, 
                        wirelessOrder.CurrentPlanType, 
                        wirelessOrder.CreditCode, 
                        wirelessOrder.MaxLinesAllowed, 
                        wirelessOrder.DepositReq, 
                        wirelessOrder.DepositAccept, 
                        wirelessOrder.DepositTypeId, 
                        wirelessOrder.DepositId, 
                        wirelessOrder.DepositAmount, 
                        wirelessOrder.ActivationAmount, 
                        wirelessOrder.PrePayId, 
                        wirelessOrder.PrePayAmount, 
                        wirelessOrder.NewAccountNo, 
                        wirelessOrder.NewAccountType, 
                        this.billCycleDate, 
                        wirelessOrder.CarrierStatus, 
                        wirelessOrder.CarrierStatusDate, 
                        wirelessOrder.CarrierId, 
                        this.activationStatus, 
                        wirelessOrder.CarrierTermsTimeStamp);

                    /*
                    wirelessOrder.ActivationStatus = _activationStatus;
                    if (_billCycleDate != null)
                        wirelessOrder.BillCycleDate = _billCycleDate;
                    if (_carrierOrderDate != null)
                        wirelessOrder.CarrierOrderDate = _carrierOrderDate;
                    wirelessOrder.CarrierOrderId = _carrierOrderId;
                    wirelessOrder.CurrentAcctNumber = _currentAcctNumber;
                    wirelessOrder.CurrentAcctPIN = _currentAcctPIN;
                    if (_dob != null)
                        wirelessOrder.DOB = _dob;
                    if (_driversLicenseExpires != null)
                        wirelessOrder.DrvLicExpiry = _driversLicenseExpires;
                    //wirelessOrder.DrvLicNumber = _driversLicenseNumber;
                    wirelessOrder.DrvLicState = _driversLicenseState;
                    //wirelessOrder.SSN = _ssn;
                    //wirelessOrder.WirelessAccountId = _wirelessAccountId;
                    
                    * */
                    db.SubmitChanges();
                    this.Save();
                }
                finally
                {
                    if (db.Connection.State != ConnectionState.Closed)
                    {
                        db.Connection.Close();
                    }
                }
            }

            foreach (WirelessLine line in this.WirelessLines)
            {
                line.Save();
            }

            return !this.isDirty;
        }

        #endregion

        // fill the wireless account from the WirelessAccountId
        #region Methods

        /// <summary>The fill wireless order.</summary>
        private void FillWirelessOrder()
        {
            var db = new DbUtility().GetDataContext();

            var wirelessAccounts = db.GetWirelessAccountByWirelessAccountId(this.wirelessAccountId);

            this.wirelesslines = new WirelessLines().GetWirelessLinesFromOrder(this.OrderId);
      
            var wirelessOrder = wirelessAccounts.First();

            if (wirelessOrder.ActivationStatus != null)
            {
                this.activationStatus = wirelessOrder.ActivationStatus.Value;
            }

            if (wirelessOrder.BillCycleDate != null)
            {
                this.billCycleDate = wirelessOrder.BillCycleDate;
            }

            if (wirelessOrder.CarrierOrderDate != null)
            {
                this.carrierOrderDate = wirelessOrder.CarrierOrderDate.Value;
            }

            this.carrierOrderId = wirelessOrder.CarrierOrderId;
            this.currentAcctNumber = wirelessOrder.CurrentAcctNumber;
            this.currentAcctPin = wirelessOrder.CurrentAcctPIN;
            if (wirelessOrder.DOB != null)
            {
                this.dob = wirelessOrder.DOB.Value;
            }

            if (wirelessOrder.DrvLicExpiry != null)
            {
                this.driversLicenseExpires = wirelessOrder.DrvLicExpiry.Value;
            }

            this.driversLicenseNumber = wirelessOrder.DrvLicNumber;
            this.driversLicenseState = wirelessOrder.DrvLicState;
            this.ssn = wirelessOrder.SSN;
            this.familyPlan = wirelessOrder.FamilyPlan;
            this.isDirty = false;
        }

        #endregion
    }
}