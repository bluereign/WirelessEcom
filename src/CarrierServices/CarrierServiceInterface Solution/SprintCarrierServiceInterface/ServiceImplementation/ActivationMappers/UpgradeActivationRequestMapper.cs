// --------------------------------------------------------------------------------------------------------------------
// <copyright file="UpgradeActivationRequestMapper.cs" company="">
//   
// </copyright>
// <summary>
//   The upgrade activation request mapper.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation.ActivationMappers
{
    using WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;

    /// <summary>The upgrade activation request mapper.</summary>
    public class UpgradeActivationRequestMapper : BaseActivationRequestMapper
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="UpgradeActivationRequestMapper"/> class.</summary>
        /// <param name="referenceNumber">The reference number.</param>
        public UpgradeActivationRequestMapper(string referenceNumber)
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
                return OrderType.UPGRADE;
            }
        }

        #endregion
    }
}