// --------------------------------------------------------------------------------------------------------------------
// <copyright file="Address.cs" company="">
//   
// </copyright>
// <summary>
//   Extends the address object to an address database object.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace WirelessAdvocates.SalesOrder
{
    using System;
    using System.Linq;

    /// <summary>
    ///     Extends the address object to an address database object.
    /// </summary>
    public class Address : WirelessAdvocates.Address
    {
        #region Fields

        #endregion

        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="Address"/> class.</summary>
        /// <param name="addressGuid">The address guid.</param>
        public Address(Guid addressGuid)
        {
            this.AddressGuid = addressGuid;

            this.FillAddress();
        }

        /// <summary>Prevents a default instance of the <see cref="Address"/> class from being created.</summary>
        private Address()
        {
        }

        #endregion

        #region Public Properties

        /// <summary>Gets the address guid.</summary>
        public Guid AddressGuid { get; private set; }

        #endregion

        #region Methods

        /// <summary>The fill address.</summary>
        /// <exception cref="Exception"></exception>
        private void FillAddress()
        {
            var db = new DbUtility().GetDataContext();

            var addresses = from p in db.Addresses where p.AddressGuid == this.AddressGuid select p;

            if (addresses.Count() != 0)
            {
                var address = addresses.First();
                this.AddressLine1 = address.Address1;
                this.AddressLine2 = address.Address2;
                this.AddressLine3 = address.Address3;

                this.City = address.City;
                this.CompanyName = address.Company;
                this.Contact = new Contact();
                this.Contact.EveningPhone = address.EveningPhone;
                this.Contact.WorkPhone = address.DaytimePhone;
                this.Contact.WorkPhoneExt = string.Empty;
                this.Name = new Name
                                {
                                    FirstName = address.FirstName,
                                    LastName = address.LastName,
                                    MiddleInitial = string.Empty
                                };
                this.State = address.State;
                this.ZipCode = address.Zip;
            }
            else
            {
                throw new Exception("Missing Order Address");
            }
        }

        #endregion
    }
}