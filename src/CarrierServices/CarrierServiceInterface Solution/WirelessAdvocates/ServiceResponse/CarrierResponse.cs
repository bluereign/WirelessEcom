// --------------------------------------------------------------------------------------------------------------------
// <copyright file="CarrierResponse.cs" company="">
//   
// </copyright>
// <summary>
//   The carrier response.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace WirelessAdvocates.ServiceResponse
{
    /// <summary>The carrier response.</summary>
    public class CarrierResponse
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="CarrierResponse"/> class.</summary>
        public CarrierResponse()
        {
            this.PrimaryErrorMessage = null;
            this.ServiceResponseSubCode = 0;
            this.ErrorCode = 0;
            this.Result = null;
        }

        #endregion

        #region Public Properties

        /// <summary>Gets or sets the error code.</summary>
        public int ErrorCode { get; set; }

        /// <summary>Gets or sets the primary error message.</summary>
        public string PrimaryErrorMessage { get; set; }

        /// <summary>Gets or sets the result.</summary>
        public object Result { get; set; }

        /// <summary>Gets or sets the service response sub code.</summary>
        public int ServiceResponseSubCode { get; set; }

        #endregion
    }
}