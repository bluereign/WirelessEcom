// --------------------------------------------------------------------------------------------------------------------
// <copyright file="SprintActivateReservedDeviceResponse.cs" company="">
//   
// </copyright>
// <summary>
//   The sprint activate now response.
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

    /// <summary>The sprint activate now response.</summary>
    public class SprintActivateReservedDeviceResponse : CarrierResponse, ISprintErrorInfo
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="SprintActivateReservedDeviceResponse"/> class. Initializes a new
        ///     instance of the <see cref="SprintActivateNowResponse"/> class.</summary>
        /// <param name="errorCode">The error code.</param>
        /// <param name="serviceResponseSubCode">The service response sub code.</param>
        /// <param name="primaryErrorMessage">The primary error message.</param>
        /// <param name="errorInfo">The error info.</param>
        public SprintActivateReservedDeviceResponse(
            int errorCode, 
            int serviceResponseSubCode, 
            string primaryErrorMessage, 
            NEW_RESPONSE.ErrorInfo[] errorInfo)
        {
            this.ErrorCode = errorCode;
            this.ServiceResponseSubCode = serviceResponseSubCode;
            this.PrimaryErrorMessage = primaryErrorMessage;
            this.PrimaryErrorMessageLong = primaryErrorMessage;
            this.NewErrorInfo = errorInfo;
        }

        /// <summary>
        ///     Initializes a new instance of the <see cref="SprintActivateReservedDeviceResponse" /> class. Initializes a new
        ///     instance of the <see cref="SprintActivateNowResponse" /> class.
        /// </summary>
        public SprintActivateReservedDeviceResponse()
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

        /// <summary>Gets or sets the primary error message.</summary>
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
    }
}