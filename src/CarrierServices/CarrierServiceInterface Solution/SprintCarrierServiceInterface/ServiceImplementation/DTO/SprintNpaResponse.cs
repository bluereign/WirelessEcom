// --------------------------------------------------------------------------------------------------------------------
// <copyright file="SprintNpaResponse.cs" company="">
//   
// </copyright>
// <summary>
//   The npa response.
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

    /// <summary>The npa response.</summary>
    public class SprintNpaResponse : NpaResponse, ISprintErrorInfo
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="SprintNpaResponse"/> class. Initializes a new instance of the<see cref="NpaResponse"/> class.</summary>
        /// <param name="errorCode">The error Code.</param>
        /// <param name="serviceResponseSubCode">The service Response Sub Code.</param>
        /// <param name="primaryErrorMessage">The primary Error Message.</param>
        /// <param name="errorInfo">The error info.</param>
        public SprintNpaResponse(
            int errorCode, 
            int serviceResponseSubCode, 
            string primaryErrorMessage, 
            RESPONSE.ErrorInfo[] errorInfo)
        {
            this.ErrorCode = errorCode;
            this.ServiceResponseSubCode = serviceResponseSubCode;
            this.PrimaryErrorMessage = primaryErrorMessage;
            this.PrimaryErrorMessageLong = primaryErrorMessage;
            this.ErrorInfo = errorInfo;
        }

        /// <summary>
        ///     Initializes a new instance of the <see cref="SprintNpaResponse" /> class. Prevents a default instance of the
        ///     <see cref="SprintNpaResponse" /> class from being created.
        /// </summary>
        public SprintNpaResponse()
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