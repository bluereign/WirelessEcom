// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ServiceResponseSubCode.cs" company="">
//   
// </copyright>
// <summary>
//   The service response sub code.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace WirelessAdvocates.Enum
{
    using System.ComponentModel;

    /// <summary>The service response sub code.</summary>
    public enum ServiceResponseSubCode
    {
        /*
        100 - 199   Port-in
        200 - 299   Address Validation
        300 - 399   Credit Check
        400 - 499   Customer Lookup
        500 - 699   EquipmentUpgrade
        700 - 799   Miscellaneous
        1000 - 1099 Activation
        */

        /// <summary>The default value.</summary>
        [Description("")]
        DefaultValue = 0, 

        // ADDRESS VALIDATION
        /// <summary>The a v_ invali d_ address.</summary>
        [Description("Invalid address entered.")]
        AvInvalidAddress = 200, 

        // CREDIT CHECK
        /// <summary>The c c_ existin g_ customer.</summary>
        [Description("")]
        CC_EXISTING_CUSTOMER = 300, 

        /// <summary>The c c_ credi t_ declined.</summary>
        [Description("Credit Request Declined.")]
        CC_CREDIT_DECLINED = 301, 

        /// <summary>The c c_ statu s_ unknown.</summary>
        [Description("Credit Request Status Unknown.")]
        CC_STATUS_UNKNOWN = 302, 

        /// <summary>The c c_ credi t_ approved.</summary>
        [Description("Credit approved.")]
        CC_CREDIT_APPROVED = 303,

        /// <summary>The cc error.</summary>
        [Description("Credit Request Error in processing.")]
        CCError = 304, // General hard error in cc processing

        /// <summary>The c c_ recen t_ cancel.</summary>
        [Description("Existing Account found but status is Cancelled in less than 90 days. Please Contact T-Mobile Customer Care")]
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

        /// <summary>The cl customer not found.</summary>
        [Description("Customer not found.")]
        ClCustomerNotFound = 401, 

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

        /// <summary>The c l_ invali d_ pin.</summary>
        [Description("PIN is incorrect")]
        CL_INVALID_PIN = 406, 

        /// <summary>The c c_ md n_ doesno t_ exist.</summary>
        [Description("MDN does not exist")]
        CcMDNDoesnotExist = 407, 

        /// <summary>The c c_ pending.</summary>
        [Description("Credit Check pending")]
        CC_PENDING = 408, 

        /// <summary>The c c_ review.</summary>
        [Description("Credit Check under review")]
        CC_REVIEW = 409, 

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

        /// <summary>The e u_ succes s_ n o_ commission.</summary>
        [Description("ICC ID is not valid.Resubmit with a differenct ICC ID.")]
        EU_ICC_ID_NOT_FOUND_INVENTORY = 608, 

        /// <summary>The npa no market data for zip.</summary>
        [Description("There were no market areas returned for the zip code.")]
        NpaNoMarketDataForZip = 700, 

        /// <summary>The input parse error.</summary>
        [Description("Sprint returned an input parsing error")]
        InputParseError = 799, 

        // ACTIVATION
        /// <summary>The act successful activation.</summary>
        [Description("Successful Activation.")]
        ActSuccessfulActivation = 1000, 

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
        ACT_REQUESTED = 1010,
         
           /// <summary>The ac t_ requested.</summary>
        [Description("Activation requested, no IccId matches the meid")]
        ActNoIccId = 1011
    }
}