// --------------------------------------------------------------------------------------------------------------------
// <copyright file="SprintCustomerInquiryResponse.cs" company="">
//   
// </copyright>
// <summary>
//   The sprint customer inquiry response.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation.DTO
{
    using WirelessAdvocates.Enum;
    using WirelessAdvocates.ServiceResponse;

    using NEW_REQUEST = SprintCSI.Request;
    using NEW_RESPONSE = SprintCSI.Response;
    using REQUEST = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;
    using RESPONSE = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.response;

    /// <summary>The sprint customer inquiry response.</summary>
    public class SprintCustomerInquiryResponse : CustomerInquiryResponse, ISprintErrorInfo
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="SprintCustomerInquiryResponse"/> class.</summary>
        /// <param name="errorCode">The error code.</param>
        /// <param name="subErrorCode">The sub error code.</param>
        /// <param name="primaryErrorMessage">The primary error message.</param>
        /// <param name="errorInfo">The error info.</param>
        public SprintCustomerInquiryResponse(int errorCode, int subErrorCode, string primaryErrorMessage, RESPONSE.ErrorInfo[] errorInfo)
        {
            this.ErrorCode = errorCode;
            this.ServiceResponseSubCode = subErrorCode;
            this.PrimaryErrorMessage = primaryErrorMessage;
            this.PrimaryErrorMessageLong = primaryErrorMessage;
            this.ErrorInfo = errorInfo;
        }

        /// <summary>Initializes a new instance of the <see cref="SprintCustomerInquiryResponse"/> class.</summary>
        /// <param name="errorCode">The error code.</param>
        /// <param name="subErrorCode">The sub error code.</param>
        /// <param name="primaryErrorMessage">The primary error message.</param>
        /// <param name="errorInfo">The error info.</param>
        public SprintCustomerInquiryResponse(int errorCode, int subErrorCode, string primaryErrorMessage, NEW_RESPONSE.ErrorInfo[] errorInfo)
        {
            this.ErrorCode = errorCode;
            this.ServiceResponseSubCode = subErrorCode;
            this.PrimaryErrorMessage = primaryErrorMessage;
            this.PrimaryErrorMessageLong = primaryErrorMessage;
            this.NewErrorInfo = errorInfo;
        }

        /// <summary>Initializes a new instance of the <see cref="SprintCustomerInquiryResponse"/> class.</summary>
        /// <param name="errorCode">The error code.</param>
        /// <param name="subErrorCode">The sub error code.</param>
        /// <param name="primaryErrorMessage">The primary error message.</param>
        public SprintCustomerInquiryResponse(int errorCode, int subErrorCode, string primaryErrorMessage)
        {
            this.ErrorCode = errorCode;
            this.ServiceResponseSubCode = subErrorCode;
            this.PrimaryErrorMessage = primaryErrorMessage;
            this.PrimaryErrorMessageLong = primaryErrorMessage;
        }

        /// <summary>
        ///     Initializes a new instance of the <see cref="SprintCustomerInquiryResponse" /> class. Prevents a default
        ///     instance of the <see cref="SprintCustomerInquiryResponse" /> class from being created.
        /// </summary>
        public SprintCustomerInquiryResponse()
        {
        }

        #endregion

        #region Public Properties

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

        /// <summary>Gets or sets the response xml.</summary>
        public string ResponseXml { get; set; }

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

        /// <summary>Gets or sets the transaction order id.</summary>
        public string TransactionOrderId { get; set; }

        #endregion
    }
}