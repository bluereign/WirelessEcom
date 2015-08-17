// --------------------------------------------------------------------------------------------------------------------
// <copyright file="NpaRequest.cs" company="">
//   
// </copyright>
// <summary>
//   The npa request.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCSI.ServiceImplementation.DTO
{
    /// <summary>The npa request.</summary>
    public class NpaRequest
    {
        #region Public Properties

        /// <summary>Gets or sets the reference number.</summary>
        public string ReferenceNumber { get; set; }

        /// <summary>Gets or sets the zip.</summary>
        public string Zip { get; set; }

        #endregion
    }
}