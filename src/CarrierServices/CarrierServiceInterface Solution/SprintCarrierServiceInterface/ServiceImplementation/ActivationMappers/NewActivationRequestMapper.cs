// --------------------------------------------------------------------------------------------------------------------
// <copyright file="NewActivationRequestMapper.cs" company="">
//   
// </copyright>
// <summary>
//   The new activation request mapper.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation.ActivationMappers
{
    using WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;

    /// <summary>The new activation request mapper.</summary>
    public class NewActivationRequestMapper : BaseActivationRequestMapper
    {
        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="NewActivationRequestMapper"/> class.</summary>
        /// <param name="referenceNumber">The reference number.</param>
        public NewActivationRequestMapper(string referenceNumber)
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
                return OrderType.NEW;
            }
        }

        #endregion
    }
}