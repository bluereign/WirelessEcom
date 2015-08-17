// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ActivationStatus.cs" company="">
//   
// </copyright>
// <summary>
//   The activation status.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace WirelessAdvocates.Enum
{
    /// <summary>The activation status.</summary>
    public enum ActivationStatus
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
}