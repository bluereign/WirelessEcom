// --------------------------------------------------------------------------------------------------------------------
// <copyright file="PortEligibilityRequest.cs" company="">
//   
// </copyright>
// <summary>
//   The port eligibility request.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCSI.ServiceImplementation.DTO
{
    using System.Collections.Generic;

    using WirelessAdvocates;

    /// <summary>The port eligibility request.</summary>
    public class PortEligibilityRequest
    {
        #region Public Properties

        /// <summary>Gets or sets the mdn list.</summary>
        public List<MDNSet> MDNList { get; set; }

        /// <summary>Gets or sets the reference number.</summary>
        public string ReferenceNumber { get; set; }

        #endregion
    }
}