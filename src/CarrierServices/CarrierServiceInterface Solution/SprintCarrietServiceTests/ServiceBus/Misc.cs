// --------------------------------------------------------------------------------------------------------------------
// <copyright file="Misc.cs" company="">
//   
// </copyright>
// <summary>
//   The device technology.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace WirelessAdvocates.Services.CarrierInterface.ATT.Common.Types
{
    using System.Collections.Generic;

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

    /// <summary>The upgrade statusenum.</summary>
    public enum UpgradeStatusenum
    {
        /// <summary>The a.</summary>
        A, 

        /// <summary>The u.</summary>
        U, 

        /// <summary>The i.</summary>
        I, 

        /// <summary>The p.</summary>
        P, 

        /// <summary>The s.</summary>
        S, 
    }

    /// <summary>The order type enum.</summary>
    public enum OrderTypeEnum
    {
        /// <summary>The new.</summary>
        New, 

        /// <summary>The aal.</summary>
        AAL, 

        /// <summary>The upgrade.</summary>
        Upgrade, 

        /// <summary>The none.</summary>
        None
    }

    /// <summary>The account type.</summary>
    public enum AccountType
    {
        /// <summary>The guid.</summary>
        /// <remarks></remarks>
        GUID, 

        /// <summary>The billing account number.</summary>
        /// <remarks></remarks>
        billingAccountNumber, 
    }

    /// <summary>The equipment typeenum.</summary>
    public enum EquipmentTypeenum
    {
        /// <summary>The c.</summary>
        C, 

        /// <summary>The g.</summary>
        G, 
    }

    /// <summary>The action info.</summary>
    public enum ActionInfo
    {
        /// <summary>The a.</summary>
        A, 

        /// <summary>The r.</summary>
        R, 

        /// <summary>The q.</summary>
        Q, 

        /// <summary>The u.</summary>
        U, 
    }

    /// <summary>The request type.</summary>
    public enum RequestType
    {
        /// <summary>The park.</summary>
        Park, 

        /// <summary>The activate.</summary>
        Activate
    }

    /// <summary>The activation detail.</summary>
    public class ActivationDetail
    {
        #region Public Properties

        /// <summary>Gets or sets the mdn.</summary>
        public string mdn { get; set; }

        /// <summary>Gets or sets the status.</summary>
        public WAActivationStatus status { get; set; }

        #endregion
    }

    /// <summary>The conflicting offer.</summary>
    public class ConflictingOffer
    {
        #region Public Properties

        /// <summary>Gets or sets the action.</summary>
        public ActionInfo action { get; set; }

        /// <summary>Gets or sets the offering code.</summary>
        public string offeringCode { get; set; }

        /// <summary>Gets or sets the subscriber number.</summary>
        public string subscriberNumber { get; set; }

        #endregion
    }

    /// <summary>The inquire incompatible offering type.</summary>
    public class InquireIncompatibleOfferingType
    {
        #region Public Properties

        /// <summary>Gets or sets the wireless line.</summary>
        public Order_Line wirelessLine { get; set; }

        /// <summary>Gets or sets the wireless order.</summary>
        public Order wirelessOrder { get; set; }

        #endregion
    }

    /// <summary>The mdn set.</summary>
    public class mdnSet
    {
        #region Public Properties

        /// <summary>Gets or sets a value indicating whether is portable.</summary>
        public bool isPortable { get; set; }

        /// <summary>Gets or sets the mdn.</summary>
        public string mdn { get; set; }

        /// <summary>Gets or sets the reason.</summary>
        public string reason { get; set; }

        /// <summary>Gets or sets the service area.</summary>
        public string[] serviceArea { get; set; }

        #endregion
    }

    /// <summary>The credit details.</summary>
    public class CreditDetails
    {
        #region Public Properties

        /// <summary>Gets or sets the approved subscriber lines.</summary>
        public string approvedSubscriberLines { get; set; }

        /// <summary>Gets or sets the credit class.</summary>
        public string creditClass { get; set; }

        /// <summary>Gets or sets the decision code.</summary>
        public string decisionCode { get; set; }

        /// <summary>Gets or sets the decision code description.</summary>
        public string decisionCodeDescription { get; set; }

        /// <summary>Gets or sets the decision reason code.</summary>
        public string decisionReasonCode { get; set; }

        /// <summary>Gets or sets the decision reference number.</summary>
        public string decisionReferenceNumber { get; set; }

        /// <summary>Gets or sets the deposit amount.</summary>
        public int[] depositAmount { get; set; }

        /// <summary>Gets or sets the number of lines available.</summary>
        public int numberOfLinesAvailable { get; set; }

        #endregion
    }

    /// <summary>The offerings additional details.</summary>
    public class OfferingsAdditionalDetails
    {
        #region Public Properties

        /// <summary>Gets or sets the action.</summary>
        public ActionInfo action { get; set; }

        /// <summary>Gets or sets the offering code.</summary>
        public string offeringCode { get; set; }

        #endregion
    }

    /// <summary>The dealer commission info.</summary>
    public class DealerCommissionInfo
    {
        #region Public Properties

        /// <summary>Gets or sets the dealer code.</summary>
        public string dealerCode { get; set; }

        /// <summary>Gets or sets the location.</summary>
        public string location { get; set; }

        /// <summary>Gets or sets the sales representative.</summary>
        public string salesRepresentative { get; set; }

        #endregion
    }

    // public class CustomerRates
    // {
    // public string mdn { get; set; }
    // public string planCode { get; set; }
    // }

    // public class Customer
    // {
    // public string primaryAccountHolder { get; set; }
    // public List<CustomerRates> customerRates { get; set; }
    // }

    /// <summary>The order.</summary>
    public class Order
    {
        #region Public Properties

        /// <summary>Gets or sets the activation type.</summary>
        public string ActivationType { get; set; }

        /// <summary>Gets or sets the approval number.</summary>
        public string ApprovalNumber { get; set; }

        /// <summary>Gets or sets the authorized user.</summary>
        public string AuthorizedUser { get; set; }

        /// <summary>Gets or sets the billing account number.</summary>
        public string BillingAccountNumber { get; set; }

        /// <summary>Gets or sets a value indicating whether family plan.</summary>
        public bool FamilyPlan { get; set; }

        /// <summary>Gets or sets the new sales channel.</summary>
        public string NewSalesChannel { get; set; }

        /// <summary>Gets or sets the order details.</summary>
        public List<Order_Line> OrderDetails { get; set; }

        /// <summary>Gets or sets the pin.</summary>
        public string PIN { get; set; }

        /// <summary>Gets or sets the qty subscriber numbers.</summary>
        public int QtySubscriberNumbers { get; set; }

        /// <summary>Gets or sets the ssn.</summary>
        public string SSN { get; set; }

        /// <summary>Gets or sets the service zip code.</summary>
        public string ServiceZipCode { get; set; }

        #endregion
    }

    /// <summary>The order_ line.</summary>
    public class Order_Line
    {
        #region Public Properties

        /// <summary>Gets or sets the activation date.</summary>
        public string ActivationDate { get; set; }

        /// <summary>Gets or sets the address line 1.</summary>
        public string AddressLine1 { get; set; }

        /// <summary>Gets or sets the address line 2.</summary>
        public string AddressLine2 { get; set; }

        /// <summary>Gets or sets the city.</summary>
        public string City { get; set; }

        /// <summary>Gets or sets the contact first name.</summary>
        public string ContactFirstName { get; set; }

        /// <summary>Gets or sets the contact last name.</summary>
        public string ContactLastName { get; set; }

        /// <summary>Gets or sets the contact middle name.</summary>
        public string ContactMiddleName { get; set; }

        /// <summary>Gets or sets the contract term.</summary>
        public int ContractTerm { get; set; }

        /// <summary>Gets or sets the deposit amount.</summary>
        public int DepositAmount { get; set; }

        /// <summary>Gets or sets the email address.</summary>
        public string EmailAddress { get; set; }

        /// <summary>Gets or sets the equipment type.</summary>
        public string EquipmentType { get; set; }

        /// <summary>Gets or sets the group plan code.</summary>
        public string GroupPlanCode { get; set; }

        /// <summary>Gets or sets the home phone.</summary>
        public string HomePhone { get; set; }

        /// <summary>Gets or sets the imei.</summary>
        public string IMEI { get; set; }

        /// <summary>Gets or sets a value indicating whether is mdn port.</summary>
        public bool IsMDNPort { get; set; }

        /// <summary>Gets or sets the npa requested.</summary>
        public string NPARequested { get; set; }

        /// <summary>Gets or sets the port in carrier account.</summary>
        public string PortInCarrierAccount { get; set; }

        /// <summary>Gets or sets the port in carrier pin.</summary>
        public string PortInCarrierPin { get; set; }

        /// <summary>Gets or sets the primary subscriber.</summary>
        public string PrimarySubscriber { get; set; }

        /// <summary>Gets or sets the qualifications.</summary>
        public object Qualifications { get; set; }

        /// <summary>Gets or sets the sim.</summary>
        public string SIM { get; set; }

        /// <summary>Gets or sets the service area.</summary>
        public string ServiceArea { get; set; }

        /// <summary>Gets or sets the services.</summary>
        public List<Order_Service> Services { get; set; }

        /// <summary>Gets or sets the single user plan code.</summary>
        public string SingleUserPlanCode { get; set; }

        /// <summary>Gets or sets the state.</summary>
        public string State { get; set; }

        /// <summary>Gets or sets the subscriber number.</summary>
        public string SubscriberNumber { get; set; }

        /// <summary>Gets or sets a value indicating whether suspend immediate.</summary>
        public bool SuspendImmediate { get; set; }

        /// <summary>Gets or sets the technology type.</summary>
        public DeviceTechnology TechnologyType { get; set; }

        /// <summary>Gets or sets the terms condition status.</summary>
        public string TermsConditionStatus { get; set; }

        /// <summary>Gets or sets the work phone.</summary>
        public string WorkPhone { get; set; }

        /// <summary>Gets or sets the work phone extension.</summary>
        public string WorkPhoneExtension { get; set; }

        /// <summary>Gets or sets the zip code.</summary>
        public string ZipCode { get; set; }

        /// <summary>Gets or sets the zip code extension.</summary>
        public string ZipCodeExtension { get; set; }

        #endregion
    }

    /// <summary>The order_ service.</summary>
    public class Order_Service
    {
        #region Public Properties

        /// <summary>Gets or sets the features.</summary>
        public List<Order_ServiceFeature> Features { get; set; }

        /// <summary>Gets or sets the offering action.</summary>
        public string OfferingAction { get; set; }

        /// <summary>Gets or sets the offering code.</summary>
        public string OfferingCode { get; set; }

        #endregion
    }

    /// <summary>The order_ service feature.</summary>
    public class Order_ServiceFeature
    {
        #region Public Properties

        /// <summary>Gets or sets the feature code.</summary>
        public string FeatureCode { get; set; }

        #endregion
    }

    /// <summary>The reserved numbers.</summary>
    public class ReservedNumbers
    {
        #region Public Properties

        /// <summary>Gets or sets a value indicating whether allocated.</summary>
        public bool Allocated { get; set; }

        /// <summary>Gets or sets the service area.</summary>
        public string ServiceArea { get; set; }

        /// <summary>Gets or sets the subscriber number.</summary>
        public string SubscriberNumber { get; set; }

        #endregion
    }

    /// <summary>The customer.</summary>
    public class Customer
    {
        #region Public Properties

        /// <summary>Gets or sets the authorized user name 1.</summary>
        public string AuthorizedUserName1 { get; set; }

        /// <summary>Gets or sets the authorized user name 2.</summary>
        public string AuthorizedUserName2 { get; set; }

        /// <summary>Gets or sets the customer account number.</summary>
        public string CustomerAccountNumber { get; set; }

        /// <summary>Gets or sets the customer account password.</summary>
        public string CustomerAccountPassword { get; set; }

        /// <summary>Gets or sets the customer inquiry lines.</summary>
        public List<CustomerInquiryLine> CustomerInquiryLines { get; set; }

        /// <summary>Gets or sets the existing account monthly charges.</summary>
        public decimal ExistingAccountMonthlyCharges { get; set; }

        /// <summary>Gets or sets the lines active.</summary>
        public int LinesActive { get; set; }

        /// <summary>Gets or sets the lines approved.</summary>
        public int LinesApproved { get; set; }

        /// <summary>Gets or sets the lines available.</summary>
        public int LinesAvailable { get; set; }

        // public object AccountResponse { get; set; }     
        /// <summary>Gets or sets the plan code.</summary>
        public string PlanCode { get; set; }

        /// <summary>Gets or sets the primary account holder.</summary>
        public string PrimaryAccountHolder { get; set; }

        /// <summary>Gets or sets the subscriber number.</summary>
        public string SubscriberNumber { get; set; }

        /// <summary>Gets or sets the wireless account type.</summary>
        public WirelessAccountType WirelessAccountType { get; set; }

        #endregion
    }
}