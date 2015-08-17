// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ActivationResponse.cs" company="">
//   
// </copyright>
// <summary>
//   The wa activation response.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation.DTO
{
    using WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.response;

    using WirelessAdvocates.Enum;
    using WirelessAdvocates.ServiceResponse;

    /// <summary>The wa activation response.</summary>
    public class ActivationResponse : OrderResponse, ISprintErrorInfo
    {
        #region Public Properties

        /// <summary>Gets or sets the caller line number.</summary>
        public int CallerLineNumber { get; set; }

        /// <summary>Gets or sets the caller member name.</summary>
        public string CallerMemberName { get; set; }

        /// <summary>Gets or sets the error code enum.</summary>
        public ServiceResponseCode ErrorCodeEnum { get; set; }

        /// <summary>Gets or sets the error info.</summary>
        public ErrorInfo[] ErrorInfo { get; set; }

        /// <summary>Gets or sets the new error info.</summary>
        public Response.ErrorInfo[] NewErrorInfo { get; set; }

        /// <summary>Gets or sets the primary error message .</summary>
        public string PrimaryErrorMessageLong { get; set; }
        
        /// <summary>Gets or sets the primary error message brief.</summary>
        public string PrimaryErrorMessageBrief { get; set; }

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