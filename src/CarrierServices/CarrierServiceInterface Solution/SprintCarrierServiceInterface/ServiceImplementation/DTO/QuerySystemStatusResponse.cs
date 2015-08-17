// --------------------------------------------------------------------------------------------------------------------
// <copyright file="QuerySystemStatusResponse.cs" company="">
//   
// </copyright>
// <summary>
//   The query system status response.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace SprintCSI.ServiceImplementation.DTO
{
    /// <summary>The query system status response.</summary>
    public class QuerySystemStatusResponse : SoapBaseResponse
    {
        #region Public Properties

        /// <summary>Gets or sets a value indicating whether ping response.</summary>
        public bool PingResponse { get; set; }

        #endregion
    }
}