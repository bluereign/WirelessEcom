// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ActivationResponse.cs" company="">
//   
// </copyright>
// <summary>
//   The order activation response.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace WirelessAdvocates.ServiceResponse
{
    using System.Collections.Generic;

    /// <summary>The order activation response.</summary>
    public class OrderActivationResponse : CarrierResponse
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="OrderActivationResponse" /> class.</summary>
        public OrderActivationResponse()
        {
            this.LineActivationResponses = new List<LineActivationResponse>();
        }

        #endregion

        #region Public Properties

        /// <summary>Gets the line activation responses.</summary>
        public List<LineActivationResponse> LineActivationResponses { get; private set; }

        #endregion

        #region Public Methods and Operators

        /// <summary>The add line activation.</summary>
        /// <param name="lineActivation">The line activation.</param>
        public void AddLineActivation(LineActivationResponse lineActivation)
        {
            this.LineActivationResponses.Add(lineActivation);
        }

        #endregion
    }
}