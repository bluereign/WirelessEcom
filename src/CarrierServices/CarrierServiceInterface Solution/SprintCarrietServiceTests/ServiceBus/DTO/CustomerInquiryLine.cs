// --------------------------------------------------------------------------------------------------------------------
// <copyright file="CustomerInquiryLine.cs" company="">
//   
// </copyright>
// <summary>
//   The customer inquiry line.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace WirelessAdvocates.Services.CarrierInterface.ATT.Common.Types
{
    using System;
    using System.Collections.Generic;

    using WirelessAdvocates.Enum;

    /// <summary>The customer inquiry line.</summary>
    public class CustomerInquiryLine
    {
        #region Public Properties

        /// <summary>Gets or sets the account status.</summary>
        public AccountStatusCode AccountStatus { get; set; }

        /// <summary>Gets or sets the billing address.</summary>
        public Address BillingAddress { get; set; }

        /// <summary>Gets or sets the carrier account id.</summary>
        public string CarrierAccountId { get; set; }

        /// <summary>Gets or sets the contract start.</summary>
        public DateTime ContractStart { get; set; }

        /// <summary>Gets or sets a value indicating whether contract start specified.</summary>
        public bool ContractStartSpecified { get; set; }

        /// <summary>Gets or sets a value indicating whether equipment upgrade available.</summary>
        public bool EquipmentUpgradeAvailable { get; set; }

        /// <summary>Gets or sets the existing line monthly charges.</summary>
        public decimal ExistingLineMonthlyCharges { get; set; }

        /// <summary>Gets or sets a value indicating whether is primary line.</summary>
        public bool IsPrimaryLine { get; set; }

        /// <summary>Gets or sets the mdn.</summary>
        public string Mdn { get; set; }

        /// <summary>Gets or sets the offerings.</summary>
        public List<Order_Service> Offerings { get; set; }

        /// <summary>Gets or sets a value indicating whether pending upgrade.</summary>
        public bool PendingUpgrade { get; set; }

        /// <summary>Gets or sets the plan code.</summary>
        public string PlanCode { get; set; }

        /// <summary>Gets or sets the shipping address.</summary>
        public Address ShippingAddress { get; set; }

        /// <summary>Gets or sets the upgrade available date.</summary>
        public string UpgradeAvailableDate { get; set; }

        /// <summary>Gets or sets a value indicating whether upgrade available specified.</summary>
        public bool UpgradeAvailableSpecified { get; set; }

        /// <summary>Gets or sets the wireless line type.</summary>
        public WirelessLineType WirelessLineType { get; set; }

        /// <summary>Gets or sets the eligibility status.</summary>
        public EligibilityStatusInfo eligibilityStatus { get; set; }

        #endregion
    }
}