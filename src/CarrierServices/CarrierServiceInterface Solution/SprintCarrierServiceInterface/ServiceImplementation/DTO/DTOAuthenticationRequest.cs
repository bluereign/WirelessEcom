// --------------------------------------------------------------------------------------------------------------------
// <copyright file="WAAuthenticationRequest.cs" company="">
//   
// </copyright>
// <summary>
//   The wa authentication request.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCSI.ServiceImplementation.DTO
{
    /// <summary>The wa authentication request.</summary>
    public class DTOAuthenticationRequest
    {
        #region Public Properties

        /// <summary>Gets or sets the mdn.</summary>
        public string MDN { get; set; }

        /// <summary>Gets or sets the reference_ no.</summary>
        public string ReferenceNo { get; set; }

        #endregion
    }
}