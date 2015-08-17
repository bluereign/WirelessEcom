// --------------------------------------------------------------------------------------------------------------------
// <copyright file="SprintAddressValidationResponse.cs" company="">
//   
// </copyright>
// <summary>
//   The sprint address validation response.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation.DTO
{
    using WirelessAdvocates.Enum;
    using WirelessAdvocates.ServiceResponse;

    using NEW_REQUEST = SprintCSI.Request;
    using NEW_RESPONSE = SprintCSI.Response;

    /// <summary>The sprint device validation response.</summary>
    public class SprintAddressValidationResponse : AddressValidationResponse, ISprintSoapInfo
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="SprintAddressValidationResponse"/> class.</summary>
        /// <param name="errorCode">The error code.</param>
        /// <param name="serviceResponseSubCode">The service response sub code.</param>
        /// <param name="primaryErrorMessage">The primary error message.</param>
        public SprintAddressValidationResponse(int errorCode, int serviceResponseSubCode, string primaryErrorMessage)
        {
            this.ErrorCode = errorCode;
            this.ServiceResponseSubCode = serviceResponseSubCode;
            this.PrimaryErrorMessage = primaryErrorMessage;
            this.PrimaryErrorMessageLong = primaryErrorMessage;
        }

        /// <summary>Initializes a new instance of the <see cref="SprintAddressValidationResponse" /> class.</summary>
        public SprintAddressValidationResponse()
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
    }
}