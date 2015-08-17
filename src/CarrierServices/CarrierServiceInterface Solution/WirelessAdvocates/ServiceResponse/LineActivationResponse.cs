// --------------------------------------------------------------------------------------------------------------------
// <copyright file="LineActivationResponse.cs" company="">
//   
// </copyright>
// <summary>
//   The line activation response.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace WirelessAdvocates.ServiceResponse
{

    /// <summary>The line activation response.</summary>
    public class LineActivationResponse : CarrierResponse
    {
        #region Public Properties

        /// <summary>Gets or sets the equipment upgrade response.</summary>
        public EquipmentUpgradeResponse EquipmentUpgradeResponse { get; set; }

        /// <summary>Gets or sets the imei.</summary>
        public string IMEI { get; set; }

        /// <summary>Gets or sets the mdn.</summary>
        public string MDN { get; set; }

        /// <summary>Gets or sets the services activation response.</summary>
        public ServicesActivationResponse ServicesActivationResponse { get; set; }

        #endregion
    }
}