﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace SprintOrders
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Entity.Core.Objects;
    using System.Linq;
    
    public partial class SprintOrders : DbContext
    {
        public SprintOrders()
            : base("name=SprintOrders")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<Address> Addresses { get; set; }
        public virtual DbSet<LineService> LineServices { get; set; }
        public virtual DbSet<Order> Orders { get; set; }
        public virtual DbSet<OrderDetail> OrderDetails { get; set; }
        public virtual DbSet<WirelessAccount> WirelessAccounts { get; set; }
        public virtual DbSet<WirelessLine> WirelessLines { get; set; }
        public virtual DbSet<CarrierInterfaceLog> CarrierInterfaceLogs { get; set; }
        public virtual DbSet<CheckoutSessionState> CheckoutSessionStates { get; set; }
        public virtual DbSet<Device> Devices { get; set; }
        public virtual DbSet<Service> Services { get; set; }
    
        public virtual ObjectResult<GetWirelessAccountByOrderId_Result> GetWirelessAccountByOrderId(Nullable<int> orderId)
        {
            var orderIdParameter = orderId.HasValue ?
                new ObjectParameter("OrderId", orderId) :
                new ObjectParameter("OrderId", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<GetWirelessAccountByOrderId_Result>("GetWirelessAccountByOrderId", orderIdParameter);
        }
    
        public virtual ObjectResult<GetWirelessAccountByWirelessAccountId_Result> GetWirelessAccountByWirelessAccountId(Nullable<int> wirelessAccountId)
        {
            var wirelessAccountIdParameter = wirelessAccountId.HasValue ?
                new ObjectParameter("WirelessAccountId", wirelessAccountId) :
                new ObjectParameter("WirelessAccountId", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<GetWirelessAccountByWirelessAccountId_Result>("GetWirelessAccountByWirelessAccountId", wirelessAccountIdParameter);
        }
    
        public virtual int UpdateWirelessAccount(Nullable<int> wirelessAccountId, Nullable<int> orderId, Nullable<short> familyPlan, Nullable<System.DateTime> carrierOrderDate, string sSN, Nullable<System.DateTime> dOB, string drvLicNumber, string drvLicState, Nullable<System.DateTime> drvLicExpiry, string firstName, string initial, string lastName, string carrierOrderId, string currentAcctNumber, string currentAcctPIN, Nullable<int> currentTotalLines, string currentPlanType, string creditCode, Nullable<int> maxLinesAllowed, Nullable<bool> depositReq, Nullable<bool> depositAccept, Nullable<int> depositTypeId, string depositId, Nullable<decimal> depositAmount, Nullable<decimal> activationAmount, string prePayId, Nullable<decimal> prePayAmount, string newAccountNo, string newAccountType, Nullable<System.DateTime> billCycleDate, string carrierStatus, Nullable<System.DateTime> carrierStatusDate, Nullable<int> carrierId, Nullable<int> activationStatus, Nullable<System.DateTime> activationDate, Nullable<System.DateTime> carrierTermsTimeStamp, string accountPassword, string accountZipCode, Nullable<int> activatedById, Nullable<int> selectedSecurityQuestionId, string securityQuestionAnswer)
        {
            var wirelessAccountIdParameter = wirelessAccountId.HasValue ?
                new ObjectParameter("WirelessAccountId", wirelessAccountId) :
                new ObjectParameter("WirelessAccountId", typeof(int));
    
            var orderIdParameter = orderId.HasValue ?
                new ObjectParameter("OrderId", orderId) :
                new ObjectParameter("OrderId", typeof(int));
    
            var familyPlanParameter = familyPlan.HasValue ?
                new ObjectParameter("FamilyPlan", familyPlan) :
                new ObjectParameter("FamilyPlan", typeof(short));
    
            var carrierOrderDateParameter = carrierOrderDate.HasValue ?
                new ObjectParameter("CarrierOrderDate", carrierOrderDate) :
                new ObjectParameter("CarrierOrderDate", typeof(System.DateTime));
    
            var sSNParameter = sSN != null ?
                new ObjectParameter("SSN", sSN) :
                new ObjectParameter("SSN", typeof(string));
    
            var dOBParameter = dOB.HasValue ?
                new ObjectParameter("DOB", dOB) :
                new ObjectParameter("DOB", typeof(System.DateTime));
    
            var drvLicNumberParameter = drvLicNumber != null ?
                new ObjectParameter("DrvLicNumber", drvLicNumber) :
                new ObjectParameter("DrvLicNumber", typeof(string));
    
            var drvLicStateParameter = drvLicState != null ?
                new ObjectParameter("DrvLicState", drvLicState) :
                new ObjectParameter("DrvLicState", typeof(string));
    
            var drvLicExpiryParameter = drvLicExpiry.HasValue ?
                new ObjectParameter("DrvLicExpiry", drvLicExpiry) :
                new ObjectParameter("DrvLicExpiry", typeof(System.DateTime));
    
            var firstNameParameter = firstName != null ?
                new ObjectParameter("FirstName", firstName) :
                new ObjectParameter("FirstName", typeof(string));
    
            var initialParameter = initial != null ?
                new ObjectParameter("Initial", initial) :
                new ObjectParameter("Initial", typeof(string));
    
            var lastNameParameter = lastName != null ?
                new ObjectParameter("LastName", lastName) :
                new ObjectParameter("LastName", typeof(string));
    
            var carrierOrderIdParameter = carrierOrderId != null ?
                new ObjectParameter("CarrierOrderId", carrierOrderId) :
                new ObjectParameter("CarrierOrderId", typeof(string));
    
            var currentAcctNumberParameter = currentAcctNumber != null ?
                new ObjectParameter("CurrentAcctNumber", currentAcctNumber) :
                new ObjectParameter("CurrentAcctNumber", typeof(string));
    
            var currentAcctPINParameter = currentAcctPIN != null ?
                new ObjectParameter("CurrentAcctPIN", currentAcctPIN) :
                new ObjectParameter("CurrentAcctPIN", typeof(string));
    
            var currentTotalLinesParameter = currentTotalLines.HasValue ?
                new ObjectParameter("CurrentTotalLines", currentTotalLines) :
                new ObjectParameter("CurrentTotalLines", typeof(int));
    
            var currentPlanTypeParameter = currentPlanType != null ?
                new ObjectParameter("CurrentPlanType", currentPlanType) :
                new ObjectParameter("CurrentPlanType", typeof(string));
    
            var creditCodeParameter = creditCode != null ?
                new ObjectParameter("CreditCode", creditCode) :
                new ObjectParameter("CreditCode", typeof(string));
    
            var maxLinesAllowedParameter = maxLinesAllowed.HasValue ?
                new ObjectParameter("MaxLinesAllowed", maxLinesAllowed) :
                new ObjectParameter("MaxLinesAllowed", typeof(int));
    
            var depositReqParameter = depositReq.HasValue ?
                new ObjectParameter("DepositReq", depositReq) :
                new ObjectParameter("DepositReq", typeof(bool));
    
            var depositAcceptParameter = depositAccept.HasValue ?
                new ObjectParameter("DepositAccept", depositAccept) :
                new ObjectParameter("DepositAccept", typeof(bool));
    
            var depositTypeIdParameter = depositTypeId.HasValue ?
                new ObjectParameter("DepositTypeId", depositTypeId) :
                new ObjectParameter("DepositTypeId", typeof(int));
    
            var depositIdParameter = depositId != null ?
                new ObjectParameter("DepositId", depositId) :
                new ObjectParameter("DepositId", typeof(string));
    
            var depositAmountParameter = depositAmount.HasValue ?
                new ObjectParameter("DepositAmount", depositAmount) :
                new ObjectParameter("DepositAmount", typeof(decimal));
    
            var activationAmountParameter = activationAmount.HasValue ?
                new ObjectParameter("ActivationAmount", activationAmount) :
                new ObjectParameter("ActivationAmount", typeof(decimal));
    
            var prePayIdParameter = prePayId != null ?
                new ObjectParameter("PrePayId", prePayId) :
                new ObjectParameter("PrePayId", typeof(string));
    
            var prePayAmountParameter = prePayAmount.HasValue ?
                new ObjectParameter("PrePayAmount", prePayAmount) :
                new ObjectParameter("PrePayAmount", typeof(decimal));
    
            var newAccountNoParameter = newAccountNo != null ?
                new ObjectParameter("NewAccountNo", newAccountNo) :
                new ObjectParameter("NewAccountNo", typeof(string));
    
            var newAccountTypeParameter = newAccountType != null ?
                new ObjectParameter("NewAccountType", newAccountType) :
                new ObjectParameter("NewAccountType", typeof(string));
    
            var billCycleDateParameter = billCycleDate.HasValue ?
                new ObjectParameter("BillCycleDate", billCycleDate) :
                new ObjectParameter("BillCycleDate", typeof(System.DateTime));
    
            var carrierStatusParameter = carrierStatus != null ?
                new ObjectParameter("CarrierStatus", carrierStatus) :
                new ObjectParameter("CarrierStatus", typeof(string));
    
            var carrierStatusDateParameter = carrierStatusDate.HasValue ?
                new ObjectParameter("CarrierStatusDate", carrierStatusDate) :
                new ObjectParameter("CarrierStatusDate", typeof(System.DateTime));
    
            var carrierIdParameter = carrierId.HasValue ?
                new ObjectParameter("CarrierId", carrierId) :
                new ObjectParameter("CarrierId", typeof(int));
    
            var activationStatusParameter = activationStatus.HasValue ?
                new ObjectParameter("ActivationStatus", activationStatus) :
                new ObjectParameter("ActivationStatus", typeof(int));
    
            var activationDateParameter = activationDate.HasValue ?
                new ObjectParameter("ActivationDate", activationDate) :
                new ObjectParameter("ActivationDate", typeof(System.DateTime));
    
            var carrierTermsTimeStampParameter = carrierTermsTimeStamp.HasValue ?
                new ObjectParameter("CarrierTermsTimeStamp", carrierTermsTimeStamp) :
                new ObjectParameter("CarrierTermsTimeStamp", typeof(System.DateTime));
    
            var accountPasswordParameter = accountPassword != null ?
                new ObjectParameter("AccountPassword", accountPassword) :
                new ObjectParameter("AccountPassword", typeof(string));
    
            var accountZipCodeParameter = accountZipCode != null ?
                new ObjectParameter("AccountZipCode", accountZipCode) :
                new ObjectParameter("AccountZipCode", typeof(string));
    
            var activatedByIdParameter = activatedById.HasValue ?
                new ObjectParameter("ActivatedById", activatedById) :
                new ObjectParameter("ActivatedById", typeof(int));
    
            var selectedSecurityQuestionIdParameter = selectedSecurityQuestionId.HasValue ?
                new ObjectParameter("SelectedSecurityQuestionId", selectedSecurityQuestionId) :
                new ObjectParameter("SelectedSecurityQuestionId", typeof(int));
    
            var securityQuestionAnswerParameter = securityQuestionAnswer != null ?
                new ObjectParameter("SecurityQuestionAnswer", securityQuestionAnswer) :
                new ObjectParameter("SecurityQuestionAnswer", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("UpdateWirelessAccount", wirelessAccountIdParameter, orderIdParameter, familyPlanParameter, carrierOrderDateParameter, sSNParameter, dOBParameter, drvLicNumberParameter, drvLicStateParameter, drvLicExpiryParameter, firstNameParameter, initialParameter, lastNameParameter, carrierOrderIdParameter, currentAcctNumberParameter, currentAcctPINParameter, currentTotalLinesParameter, currentPlanTypeParameter, creditCodeParameter, maxLinesAllowedParameter, depositReqParameter, depositAcceptParameter, depositTypeIdParameter, depositIdParameter, depositAmountParameter, activationAmountParameter, prePayIdParameter, prePayAmountParameter, newAccountNoParameter, newAccountTypeParameter, billCycleDateParameter, carrierStatusParameter, carrierStatusDateParameter, carrierIdParameter, activationStatusParameter, activationDateParameter, carrierTermsTimeStampParameter, accountPasswordParameter, accountZipCodeParameter, activatedByIdParameter, selectedSecurityQuestionIdParameter, securityQuestionAnswerParameter);
        }
    }
}
