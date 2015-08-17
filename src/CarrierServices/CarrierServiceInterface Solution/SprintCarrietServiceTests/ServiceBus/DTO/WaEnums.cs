// --------------------------------------------------------------------------------------------------------------------
// <copyright file="WaTypes.cs" company="">
//   
// </copyright>
// <summary>
//   The name.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace WirelessAdvocates.Services.CarrierInterface.ATT.Common.Types
{
    using System.ComponentModel;

    /// <summary>The account status code.</summary>
    public enum AccountStatusCode
    {
        /// <summary>The closed.</summary>
        CLOSED, 

        /// <summary>The cancelled.</summary>
        CANCELLED, 

        /// <summary>The operational.</summary>
        OPERATIONAL, 

        /// <summary>The tentative.</summary>
        TENTATIVE, 

        /// <summary>The suspended.</summary>
        SUSPENDED, 

        /// <summary>The unknown.</summary>
        UNKNOWN
    }

    /// <summary>The eligibility status info.</summary>
    public enum EligibilityStatusInfo
    {
        /// <summary>The a.</summary>
        /// <remarks></remarks>
        A, 

        /// <summary>The u.</summary>
        /// <remarks></remarks>
        U, 

        /// <summary>The i.</summary>
        /// <remarks></remarks>
        I, 

        /// <summary>The p.</summary>
        /// <remarks></remarks>
        P, 

        /// <summary>The s.</summary>
        /// <remarks></remarks>
        S, 
    }

    /// <summary>The service response code.</summary>
    public enum ServiceResponseCode
    {
        /// <summary>The success.</summary>
        Success = 0, 

        /// <summary>The failure.</summary>
        Failure = 1, 

        /// <summary>The timeout.</summary>
        Timeout = 2
    }

    /// <summary>The service methods.</summary>
    public enum ServiceMethods
    {
        /// <summary>The address validation.</summary>
        AddressValidation, 

        /// <summary>The port in validation.</summary>
        PortInValidation, 

        /// <summary>The credit check.</summary>
        CreditCheck, 

        /// <summary>The order.</summary>
        Order
    }

    /// <summary>The address type.</summary>
    public enum AddressType
    {
        /// <summary>The shipping.</summary>
        Shipping, 

        /// <summary>The billing.</summary>
        Billing, 

        /// <summary>The ppu.</summary>
        PPU
    }

    /// <summary>The wa activation status.</summary>
    public enum WAActivationStatus
    {
        /// <summary>The none.</summary>
        None = 0, 

        /// <summary>The request submitted.</summary>
        RequestSubmitted = 1, 

        /// <summary>The success.</summary>
        Success = 2, 

        /// <summary>The partial success.</summary>
        PartialSuccess = 3, 

        /// <summary>The failure.</summary>
        Failure = 4, 

        /// <summary>The error.</summary>
        Error = 5, 

        /// <summary>The manual.</summary>
        Manual = 6, 

        /// <summary>The canceled.</summary>
        Canceled = 7
    }

    /// <summary>The service response sub code.</summary>
    public enum ServiceResponseSubCode
    {
        /*
        100 - 199   Portin
        200 - 299   Address Validation
        300 - 399   Credit Check
        400 - 499   Customer Lookup
        500 - 699   EquipmentUprade
        700 - 799   Miscellaneous
        1000 - 1099 Activation
        */

        // ADDRESS VALIDATION
        /// <summary>The a v_ invali d_ address.</summary>
        [Description("Invalid address entered.")]
        AV_INVALID_ADDRESS = 200, 

        // CREDIT CHECK
        /// <summary>The c c_ existin g_ customer.</summary>
        [Description("")]
        CC_EXISTING_CUSTOMER = 300, 

        /// <summary>The c c_ credi t_ declined.</summary>
        [Description("")]
        CC_CREDIT_DECLINED = 301, 

        /// <summary>The c c_ statu s_ unknown.</summary>
        [Description("")]
        CC_STATUS_UNKNOWN = 302, 

        /// <summary>The c c_ credi t_ approved.</summary>
        [Description("Credit approved.")]
        CC_CREDIT_APPROVED = 303, 

        /// <summary>The c c_ error.</summary>
        [Description("")]
        CC_ERROR = 304, // General hard error in cc processing

        /// <summary>The c c_ recen t_ cancel.</summary>
        [Description(
            "Existing Account found but status is Cancelled in less than 90 days. Please Contact T-Mobile Customer Care"
            )]
        CC_RECENT_CANCEL = 305, 

        /// <summary>The c c_ denie d_ flexpay.</summary>
        [Description("")]
        CC_DENIED_FLEXPAY = 306, 

        /// <summary>The c c_ accoun t_ delinquent.</summary>
        [Description("")]
        CC_ACCOUNT_DELINQUENT = 307, 

        // CUSTOMER LOOKUP
        /// <summary>The c l_ custome r_ found.</summary>
        [Description("Customer found.")]
        CL_CUSTOMER_FOUND = 400, 

        /// <summary>The c l_ custome r_ no t_ found.</summary>
        [Description("Customer not found.")]
        CL_CUSTOMER_NOT_FOUND = 401, 

        /// <summary>The c l_ unsupporte d_ custome r_ type.</summary>
        [Description("Unsupported account type.")]
        CL_UNSUPPORTED_CUSTOMER_TYPE = 402, 

        /// <summary>The c l_ accoun t_ locked.</summary>
        [Description("Account Locked")]
        CL_ACCOUNT_LOCKED = 404, 

        /// <summary>The c l_ accoun t_ nopin.</summary>
        [Description("Acount does not require a pin")]
        // services should be rerun without the sec-pin element in the request.
        CL_ACCOUNT_NOPIN = 405, 

        // EQUIPMENT UPGRADE
        /// <summary>The e u_ success.</summary>
        [Description("Equipment was upgraded successfully.")]
        EU_SUCCESS = 500, 

        /// <summary>The e u_ partial.</summary>
        [Description("Equipment upgrade partially successful.")]
        EU_PARTIAL = 501, 

        /// <summary>The e u_ failed.</summary>
        [Description("Equipment upgrade failed.")]
        EU_FAILED = 502, 

        /// <summary>The e u_ no t_ eligible.</summary>
        [Description("Not eligible for an equipment upgrade.")]
        EU_NOT_ELIGIBLE = 503, 

        /// <summary>The e u_ pi n_ no t_ matched.</summary>
        [Description("Account Pin does not match.")]
        EU_PIN_NOT_MATCHED = 504, 

        /// <summary>The e u_ succes s_ n o_ commission.</summary>
        [Description("Equipment upgrade successful, no commission.")]
        EU_SUCCESS_NO_COMMISSION = 505, 

        /// <summary>The np a_ n o_ marketdat a_ fo r_ zip.</summary>
        [Description("There was no market areas returned for the zip code.")]
        NPA_NO_MARKETDATA_FOR_ZIP = 700, 

        // ACTIVATION
        /// <summary>The ac t_ successfu l_ activation.</summary>
        [Description("Successful Activation.")]
        ACT_SUCCESSFUL_ACTIVATION = 1000, 

        /// <summary>The ac t_ partia l_ handse t_ activation.</summary>
        [Description("Partial Activation, handset only.")]
        ACT_PARTIAL_HANDSET_ACTIVATION = 1001, 

        /// <summary>The ac t_ partia l_ servic e_ conflict.</summary>
        [Description("There are conflicting services, please manually activate.")]
        ACT_PARTIAL_SERVICE_CONFLICT = 1002, 

        /// <summary>The ac t_ manua l_ only.</summary>
        [Description("Requires manual activation. Invalid service selected for rateplan.")]
        ACT_MANUAL_ONLY = 1003, 

        /// <summary>The ac t_ fai l_ handset.</summary>
        [Description("Handset activation failed, please handle manually")]
        ACT_FAIL_HANDSET = 1004, 

        /// <summary>The ac t_ fail.</summary>
        [Description("Activation failed.")]
        ACT_FAIL = 1005, 

        /// <summary>The ac t_ n o_ services.</summary>
        [Description("There are no services to activate.")]
        ACT_NO_SERVICES = 1006, 

        /// <summary>The ac t_ unknown.</summary>
        [Description("Activation status unknown.")]
        ACT_UNKNOWN = 1007, 

        /// <summary>The ac t_ invali d_ orde r_ number.</summary>
        [Description("Invalid order number.")]
        ACT_INVALID_ORDER_NUMBER = 1008, 

        /// <summary>The ac t_ ratepla n_ matches.</summary>
        [Description("Rateplan matches existing rate plan.")]
        ACT_RATEPLAN_MATCHES = 1009, 

        /// <summary>The ac t_ requested.</summary>
        [Description("Activation requested, waiting for response")]
        ACT_REQUESTED = 1010
    }

    /// <summary>The carrier enum.</summary>
    public enum CarrierEnum
    {
        /// <summary>The verizon.</summary>
        Verizon = 42, 

        /// <summary>The att.</summary>
        Att = 109, 

        /// <summary>The t mobile.</summary>
        TMobile = 128
    }

    /// <summary>The wireless line type.</summary>
    public enum WirelessLineType
    {
        /// <summary>The undefined.</summary>
        Undefined = 0, 

        /// <summary>The line.</summary>
        Line = 1, 

        /// <summary>The data.</summary>
        Data = 2
    }

    /// <summary>The wireless account type.</summary>
    public enum WirelessAccountType
    {
        /// <summary>The undefined.</summary>
        Undefined = 0, 

        /// <summary>The individual.</summary>
        Individual = 1, 

        /// <summary>The multi line.</summary>
        MultiLine = 2, 

        /// <summary>The family.</summary>
        Family = 3, 

        /// <summary>The shared.</summary>
        Shared = 4
    }
}