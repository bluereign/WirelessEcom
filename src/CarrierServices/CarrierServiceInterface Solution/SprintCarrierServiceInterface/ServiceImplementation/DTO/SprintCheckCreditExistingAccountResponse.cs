// --------------------------------------------------------------------------------------------------------------------
// <copyright file="CheckCreditExistingAccountResponse.cs" company="">
//   
// </copyright>
// <summary>
//   The check credit existing account response.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation.DTO
{
    using SprintCSI.Utils;

    using WirelessAdvocates;
    using WirelessAdvocates.Enum;
    using WirelessAdvocates.ServiceResponse;

    using NEW_REQUEST = SprintCSI.Request;
    using NEW_RESPONSE = SprintCSI.Response;
    using REQUEST = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;
    using RESPONSE = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.response;

    /// <summary>The check credit existing account response.</summary>
    public class SprintCheckCreditExistingAccountResponse : CreditCheckResponse, ISprintErrorInfo
    {
        #region Public Properties

        /// <summary>Gets or sets the billing address.</summary>
        public Address BillingAddress { get; set; }

        /// <summary>Gets or sets the caller line number.</summary>
        public int CallerLineNumber { get; set; }

        /// <summary>Gets or sets the caller member name.</summary>
        public string CallerMemberName { get; set; }

        /// <summary>Gets or sets the error code enum.</summary>
        public ServiceResponseCode ErrorCodeEnum { get; set; }

        /// <summary>Gets or sets the error info.</summary>
        public RESPONSE.ErrorInfo[] ErrorInfo { get; set; }

        /// <summary>Gets or sets the new error info.</summary>
        public NEW_RESPONSE.ErrorInfo[] NewErrorInfo { get; set; }

        /// <summary>Gets or sets the primary error message brief.</summary>
        public string PrimaryErrorMessageBrief { get; set; }

        /// <summary>Gets or sets the primary error message .</summary>
        public string PrimaryErrorMessageLong { get; set; }

        /// <summary>Gets or sets the service response sub code description.</summary>
        public string ServiceResponseSubCodeDescription { get; set; }

        /// <summary>Gets or sets the service response sub code enum.</summary>
        public ServiceResponseSubCode ServiceResponseSubCodeEnum { get; set; }

        /// <summary>Gets or sets the service response sub code name.</summary>
        public string ServiceResponseSubCodeName { get; set; }

        /// <summary>Gets or sets the sprint error code.</summary>
        public int SprintErrorCode { get; set; }

        /// <summary>Gets or sets the sprint error code enum.</summary>
        public string SprintErrorCodeName { get; set; }

        /// <summary>Gets or sets the sprint response advice.</summary>
        public string SprintResponseAdvice { get; set; }

        /// <summary>Gets or sets the sprint response message.</summary>
        public string SprintResponseMessage { get; set; }

        #endregion

        #region Properties

        /// <summary>Gets or sets the transaction order id.</summary>
        internal string TransactionOrderId { get; set; }

        /// <summary>Gets or sets the xml helper.</summary>
        internal XmlHelper XmlHelper { get; set; }

        #endregion
    }
}