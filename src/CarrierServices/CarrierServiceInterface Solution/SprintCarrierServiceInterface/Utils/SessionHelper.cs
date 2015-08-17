// --------------------------------------------------------------------------------------------------------------------
// <copyright file="SessionHelper.cs" company="">
//   
// </copyright>
// <summary>
//   Retrieves data from HttpSession state.  If not found, then search will be performed on the database
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.Utils
{
    using WirelessAdvocates;

    using RESPONSE = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.response;

    /// <summary>
    ///     Retrieves data from HttpSession state.  If not found, then search will be performed on the database
    /// </summary>
    public sealed class SessionHelper
    {
        #region Static Fields

        /// <summary>The sync lock.</summary>
        private static readonly object SyncLock = new object();

        /// <summary>The instance.</summary>
        private static volatile SessionHelper instance;

        #endregion

        #region Constructors and Destructors

        /// <summary>Prevents a default instance of the <see cref="SessionHelper" /> class from being created.</summary>
        private SessionHelper()
        {
        }

        #endregion

        #region Public Properties

        /// <summary>Gets the instance.</summary>
        public static SessionHelper Instance
        {
            get
            {
                if (instance != null)
                {
                    return instance;
                }

                lock (SyncLock)
                {
                    if (instance == null)
                    {
                        instance = new SessionHelper();
                    }
                }

                return instance;
            }
        }

        #endregion

        #region Public Methods and Operators

        /// <summary>The add address.</summary>
        /// <param name="address">The address.</param>
        /// <param name="addressType">The address type.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="ExtendedAddress"/>.</returns>
        public ExtendedAddress AddAddress(Address address, Address.AddressEnum addressType, string referenceNumber)
        {
            // build the address that is returned, this is the extended address.
            var extendedAddress = new ExtendedAddress
                                      {
                                          AddressLine1 = address.AddressLine1, 
                                          AddressLine2 = address.AddressLine2, 
                                          AddressType = addressType.ToString(), 
                                          City = address.City, 
                                          State = address.State, 
                                          ZipCode = address.ZipCode
                                      };

            // save the extended address to the database
            new CheckoutSessionState().Add(referenceNumber, addressType.ToString(), "AddressValidation", extendedAddress);
            return extendedAddress;
        }

        /// <summary>The get sprint customer inquiry response.</summary>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.response.ovm"/>.</returns>
        public RESPONSE.AccountValidationResponse GetAccountValidationResponse(string referenceNumber)
        {
            return (RESPONSE.AccountValidationResponse)new CheckoutSessionState().GetByReference(referenceNumber, "OvmResponseType", "CustomerLookupByMdn", typeof(RESPONSE.AccountValidationResponse));
        }

        /// <summary>The get address.</summary>
        /// <param name="referenceNumber">The reference number.</param>
        /// <param name="addressType">The address type.</param>
        /// <returns>The <see cref="ExtendedAddress"/>.</returns>
        public ExtendedAddress GetAddress(string referenceNumber, Address.AddressEnum addressType)
        {
            return (ExtendedAddress)new CheckoutSessionState().GetByReference(referenceNumber, addressType.ToString(), "AddressValidation", typeof(ExtendedAddress));
        }

        #endregion
    }
}