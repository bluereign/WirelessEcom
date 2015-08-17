// --------------------------------------------------------------------------------------------------------------------
// <copyright file="CheckCreditResponse.cs" company="">
//   
// </copyright>
// <summary>
//   The check credit response.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation.DTO
{
    using System.ComponentModel;

    using WirelessAdvocates.Enum;
    using WirelessAdvocates.Extensions;
    using WirelessAdvocates.ServiceResponse;

    using NEW_REQUEST = SprintCSI.Request;
    using NEW_RESPONSE = SprintCSI.Response;
    using REQUEST = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;
    using RESPONSE = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.response;


    // public class SprintCreditCheckResponse : CreditCheckResponse, ISprintErrorInfo

    /// <summary>The check credit response.</summary>
          public class SprintCreditCheckResponse : CreditCheckResponse
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="SprintCreditCheckResponse"/> class.</summary>
        /// <param name="errorCode">The error code.</param>
        /// <param name="subErrorCode">The sub error code.</param>
        /// <param name="primaryErrorMessage">The primary error message.</param>
        /// <param name="errorInfo">The error info.</param>
        public SprintCreditCheckResponse(ServiceResponseCode errorCode, ServiceResponseSubCode subErrorCode, string primaryErrorMessage, NEW_RESPONSE.ErrorInfo[] errorInfo)
        {
            this.ErrorCode = (int)errorCode;
            this.ServiceResponseSubCode = (int)subErrorCode;
            this.PrimaryErrorMessage = primaryErrorMessage;
            this.NewErrorInfo = errorInfo;
            this.ErrorCodeEnum = errorCode;

            //// this.ServiceResponseSubCodeEnum = subErrorCode;  This line was causing an XML exception...
            this.ServiceResponseSubCodeDescription = subErrorCode.GetAttributeOfType<DescriptionAttribute>().Description;
        }

        /// <summary>Initializes a new instance of the <see cref="SprintCreditCheckResponse" /> class.</summary>
        public SprintCreditCheckResponse()
        {
        }

        #endregion

        #region Public Properties

        ///// <summary>Gets or sets the caller line number.</summary>
        //public int CallerLineNumber { get; set; }

        ///// <summary>Gets or sets the caller member name.</summary>
        //public string CallerMemberName { get; set; }

        /// <summary>Gets or sets the error code enum.</summary>
        public ServiceResponseCode ErrorCodeEnum { get; set; }

        ///// <summary>Gets or sets the error info.</summary>
        //public RESPONSE.ErrorInfo[] ErrorInfo { get; set; }

        /// <summary>Gets or sets the new error info.</summary>
        public NEW_RESPONSE.ErrorInfo[] NewErrorInfo { get; set; }

        ///// <summary>Gets or sets the primary error message brief.</summary>
        //public string PrimaryErrorMessageBrief { get; set; }

        ///// <summary>Gets or sets the primary error message .</summary>
        //public string PrimaryErrorMessageLong { get; set; }

        /// <summary>Gets or sets the service response sub code description.</summary>
        public string ServiceResponseSubCodeDescription { get; set; }

        /// <summary>Gets or sets the service response sub code enum.</summary>
        public ServiceResponseSubCode ServiceResponseSubCodeEnum { get; set; }

        ///// <summary>Gets or sets the service response sub code name.</summary>
        //public string ServiceResponseSubCodeName { get; set; }

        ///// <summary>Gets or sets the sprint error code.</summary>
        //public int SprintErrorCode { get; set; }

        ///// <summary>
        /////     Gets or sets the sprint error code enum.
        /////     Exists solely to provide compatibility for checkout path
        ///// </summary>
        //public string SprintErrorCodeEnum { get; set; }

        ///// <summary>Gets or sets the sprint error code name.</summary>
        //public string SprintErrorCodeName { get; set; }

        ///// <summary>Gets or sets the sprint response advice.</summary>
        //public string SprintResponseAdvice { get; set; }

        ///// <summary>Gets or sets the sprint response message.</summary>
        //public string SprintResponseMessage { get; set; }

        #endregion
    }
}