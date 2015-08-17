// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ISprintErrorInfo.cs" company="">
//   
// </copyright>
// <summary>
//   The SprintErrorInfo interface.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation
{
    using WirelessAdvocates.Enum;

    /// <summary>The SprintErrorInfo interface.</summary>
    internal interface ISprintSoapInfo
    {
        #region Public Properties

        /// <summary>Gets or sets the caller line number.</summary>
        int CallerLineNumber { get; set; }

        /// <summary>Gets or sets the caller member name.</summary>
        string CallerMemberName { get; set; }

        /// <summary>Gets or sets the error code.</summary>
        ServiceResponseCode ErrorCodeEnum { get; set; }

        /// <summary>Gets or sets the primary error message brief.</summary>
        string PrimaryErrorMessageBrief { get; set; }

        /// <summary>Gets or sets the primary error message.</summary>
        string PrimaryErrorMessageLong { get; set; } 

        /// <summary>Gets or sets the service response sub code description.</summary>
        string ServiceResponseSubCodeDescription { get; set; }

        /// <summary>Gets or sets the service response sub code enum.</summary>
        ServiceResponseSubCode ServiceResponseSubCodeEnum { get; set; }

        /// <summary>Gets or sets the sprint error code.</summary>
        int SprintErrorCode { get; set; }

        /// <summary>Gets or sets the sprint error code enum.</summary>
        string SprintErrorCodeName { get; set; }

        /// <summary>Gets or sets the sprint response advice.</summary>
        string SprintResponseAdvice { get; set; }

        /// <summary>Gets or sets the sprint response message.</summary>
        string SprintResponseMessage { get; set; }

        #endregion
    }
}