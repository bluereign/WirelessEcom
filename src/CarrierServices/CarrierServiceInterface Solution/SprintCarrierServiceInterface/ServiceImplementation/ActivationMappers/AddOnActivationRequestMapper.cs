// --------------------------------------------------------------------------------------------------------------------
// <copyright file="AddOnActivationRequestMapper.cs" company="">
//   
// </copyright>
// <summary>
//   The add on activation request mapper.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation.ActivationMappers
{
    using WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;

    /// <summary>The add on activation request mapper.</summary>
    public class AddOnActivationRequestMapper : BaseActivationRequestMapper
    {
        #region Properties

        /// <summary>Initializes a new instance of the <see cref="AddOnActivationRequestMapper"/> class.</summary>
        /// <param name="referenceNumber">The reference number.</param>
        public AddOnActivationRequestMapper(string referenceNumber)
            : base(referenceNumber)
        {
        }

        /// <summary>Gets the order type.</summary>
        protected override OrderType OrderType
        {
            get
            {
                return OrderType.ADD_ON;
            }
        }

        #endregion
    }
}