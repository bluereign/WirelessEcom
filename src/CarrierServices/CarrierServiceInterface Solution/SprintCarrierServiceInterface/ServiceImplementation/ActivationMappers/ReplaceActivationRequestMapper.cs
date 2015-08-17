// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ReplaceActivationRequestMapper.cs" company="">
//   
// </copyright>
// <summary>
//   The replace activation request mapper.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation.ActivationMappers
{
    using WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;

    /// <summary>The replace activation request mapper.</summary>
    public class ReplaceActivationRequestMapper : BaseActivationRequestMapper
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="ReplaceActivationRequestMapper"/> class.</summary>
        /// <param name="referenceNumber">The reference number.</param>
        public ReplaceActivationRequestMapper(string referenceNumber)
            : base(referenceNumber)
        {
        }

        #endregion

        #region Properties

        /// <summary>Gets the order type.</summary>
        protected override OrderType OrderType
        {
            get
            {
                return OrderType.REPLACE;
            }
        }

        #endregion
    }
}