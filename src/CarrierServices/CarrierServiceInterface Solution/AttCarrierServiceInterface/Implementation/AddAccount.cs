// --------------------------------------------------------------------------------------------------------------------
// <copyright file="AddAccount.cs" company="">
//   
// </copyright>
// <summary>
//   The add account.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace AttCarrierServiceInterface.Implementation
{
    using System;
    using System.Collections.Generic;
    using System.Web.Services.Protocols;

    using AttCarrierServiceInterface.Interfaces.AttProxy;

    using WirelessAdvocates;
    using WirelessAdvocates.Logger;

    /// <summary>The add account.</summary>
    public class AddAccount : AttServiceBase
    {
        #region Constants

        /// <summary>The object name.</summary>
        private const string ObjectName = "AddAccount";

        #endregion

        #region Fields

        /// <summary>The _att request.</summary>
        private readonly AddAccountRequestInfo attRequest = new AddAccountRequestInfo();

        /// <summary>The _att response.</summary>
        private readonly AddAccountResponseInfo attResponse;

        /// <summary>The _att service.</summary>
        private readonly AddAccountSoapHttpBinding attService = new AddAccountSoapHttpBinding();

        #endregion

        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="AddAccount"/> class.</summary>
        /// <param name="billingName">The billing name.</param>
        /// <param name="billingAddress">The billing address.</param>
        /// <param name="serviceZipCode">The service zip code.</param>
        /// <param name="contactInfo">The contact info.</param>
        /// <param name="billingContactCredentials">The billing contact credentials.</param>
        /// <param name="numberOfLines">The number of lines.</param>
        /// <param name="referenceNumber">The reference number.</param>
        public AddAccount(
            Name billingName, 
            ExtendedAddress billingAddress, 
            string serviceZipCode, 
            Contact contactInfo, 
            PersonalCredentials billingContactCredentials, 
            int numberOfLines, 
            string referenceNumber)
        {
            try
            {
                this.attService.Url = this.GetUrl("AddAccountEndpoint");
                this.AddCerts(this.attService.ClientCertificates);
                this.attService.MessageHeader = this.GetMessageHeader(referenceNumber);

                this.SetRequestAccount();

                // region Market Info  

                // TODO: May need to include different information here based (zip, billing market or  billingsystemid
                this.attRequest.marketServiceInfo = new MarketAndZipServiceInfo
                                                        {
                                                            ItemsElementName =
                                                                new ItemsChoiceType[1], 
                                                            Items = new string[1]
                                                        };
                this.attRequest.marketServiceInfo.ItemsElementName[0] = ItemsChoiceType.serviceZipCode;
                this.attRequest.marketServiceInfo.Items[0] = serviceZipCode;

                // region Customer Name
                this.attRequest.Customer = new AddAccountRequestInfoCustomer();
                this.attRequest.Customer.Items = new object[1];
                var name = new ExtendedNameInfo { firstName = billingName.FirstName, lastName = billingName.LastName };
                this.attRequest.Customer.Items[0] = name;

                this.attRequest.Customer.CreditCheckName = new AddAccountRequestInfoCustomerCreditCheckName();
                var nameInfo = new NameInfo { firstName = billingName.FirstName };
                nameInfo.lastName = billingName.LastName;
                nameInfo.middleName = billingName.MiddleInitial;
                this.attRequest.Customer.CreditCheckName.Item = nameInfo;

                // region Addresses
                this.attRequest.Customer.CreditCheckAddress = new AddressInfo();
                this.attRequest.Customer.CreditCheckAddress.AddressLine1 = billingAddress.AddressLine1;
                this.attRequest.Customer.CreditCheckAddress.AddressLine2 = billingAddress.AddressLine2;
                this.attRequest.Customer.CreditCheckAddress.City = billingAddress.City;
                this.attRequest.Customer.CreditCheckAddress.Zip = new AddressZipInfo();
                this.attRequest.Customer.CreditCheckAddress.Zip.zipCode = billingAddress.ZipCode;
                this.attRequest.Customer.CreditCheckAddress.Zip.zipCodeExtension = billingAddress.ExtendedZipCode;
                this.attRequest.Customer.CreditCheckAddress.State =
                    (AddressStateInfo)Enum.Parse(typeof(AddressStateInfo), billingAddress.State);

                this.attRequest.Customer.Address = new AddressInfo();
                this.attRequest.Customer.Address.AddressLine1 = billingAddress.AddressLine1;
                this.attRequest.Customer.Address.AddressLine2 = billingAddress.AddressLine2;
                this.attRequest.Customer.Address.City = billingAddress.City;
                this.attRequest.Customer.Address.Country = billingAddress.Country;
                this.attRequest.Customer.Address.State =
                    (AddressStateInfo)Enum.Parse(typeof(AddressStateInfo), billingAddress.State);
                this.attRequest.Customer.Address.Zip = new AddressZipInfo();
                this.attRequest.Customer.Address.Zip.zipCode = billingAddress.ZipCode;
                this.attRequest.Customer.Address.Zip.zipCodeExtension = billingAddress.ExtendedZipCode;

                // region Identity
                this.attRequest.Customer.Identity = new AddAccountRequestInfoCustomerIdentity();
                this.attRequest.Customer.Identity.Identification = new RestrictedIdentificationInfo();

                this.attRequest.Customer.Identity.Identification.expirationDate =
                    billingContactCredentials.IdExpiration.ToString("yyyy-MM-ddZ");
                this.attRequest.Customer.Identity.Identification.idNumber = billingContactCredentials.Id;
                this.attRequest.Customer.Identity.Identification.idType = IdentificationTypeInfo.DL;
                this.attRequest.Customer.Identity.Identification.issuingAuthority = billingContactCredentials.State;

                this.attRequest.Customer.Identity.ItemsElementName = new ItemsChoiceType1[2];
                this.attRequest.Customer.Identity.ItemsElementName[0] = ItemsChoiceType1.Birth;

                // Note Birth is expected first in the order...
                this.attRequest.Customer.Identity.ItemsElementName[1] = ItemsChoiceType1.socialSecurityNumber;

                this.attRequest.Customer.Identity.Items = new object[2];
                var birthInfo = new BirthInfo();
                birthInfo.dateOfBirth = billingContactCredentials.Dob.ToString("yyyy-MM-ddZ");
                this.attRequest.Customer.Identity.Items[0] = birthInfo;
                this.attRequest.Customer.Identity.Items[1] = billingContactCredentials.SSN;

                this.attRequest.creditApplicationType = CreditApplicationTypeInfo.CRR;

                // region Contact / Phone
                this.attRequest.Customer.Phone = new PhoneInfo();
                this.attRequest.Customer.Phone.canBeReachedPhone = "false";
                if (!string.IsNullOrEmpty(contactInfo.EveningPhone))
                {
                    // THIS MUST HAVE A VALUE UI REQUIREMENT : TODO
                    this.attRequest.Customer.Phone.homePhone = contactInfo.EveningPhone;
                    this.attRequest.Customer.Phone.workPhone = contactInfo.EveningPhone;
                    this.attRequest.Customer.Phone.canBeReachedPhone = "true";
                }

                if (!string.IsNullOrEmpty(contactInfo.WorkPhone))
                {
                    this.attRequest.Customer.Phone.workPhone = contactInfo.WorkPhone;
                    this.attRequest.Customer.Phone.workPhoneExtension = contactInfo.WorkPhoneExt;
                    this.attRequest.Customer.Phone.canBeReachedPhone = "true";
                }

                // region Dealer
                this.attRequest.Commission = new DealerCommissionInfo();
                this.attRequest.Commission.dealer = new DealerInfo();
                this.attRequest.Commission.dealer.code = this.GetAppSetting("DealerCode");

                this.attRequest.desiredNumberOfLines = numberOfLines.ToString();

                // this.SetReserveNumbers(billingAddress, serviceZipCode, numberOfLines, referenceNumber, nameInfo);
                new Log().LogRequest(new Utility().SerializeXML(this.attRequest), "Att", "AddAccountByZip", referenceNumber);
                this.attResponse = this.attService.AddAccount(this.attRequest);

                this.CaptureConversationId(
                    this.attService.MessageHeader.TrackingMessageHeader.conversationId, 
                    referenceNumber);
                new Log().LogResponse(new Utility().SerializeXML(this.attResponse), "Att", "AddAccountByZip", referenceNumber);
            }
            catch (SoapException soapError)
            {
                new Log().LogException(soapError.Message, "Att", "AddAccountByZip", referenceNumber);
            }
            catch (Exception ex)
            {
                new Log().LogException(ex.Message, "Att", "AddAccountByZip", referenceNumber);
                throw;
            }
        }

        #endregion

        #region Methods

        /// <summary>The set request account.</summary>
        private void SetRequestAccount()
        {
            this.attRequest.Account = new AddAccountRequestInfoAccount();
            this.attRequest.Account.AccountType = new RestrictedAccountTypeInfo
                                                      {
                                                          accountType = "I", 
                                                          accountSubType = "R", 
                                                          openChannel = OpenChannelInfo.R
                                                      };
            this.attRequest.Account.taxExemptionRequest = false;
        }

        /// <summary>The set reserve numbers.</summary>
        /// <param name="billingAddress">The billing address.</param>
        /// <param name="serviceZipCode">The service zip code.</param>
        /// <param name="numberOfLines">The number of lines.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <param name="nameInfo">The name info.</param>
        [Obsolete("This method is obsolete.", false)]
        private void SetReserveNumbers(
            ExtendedAddress billingAddress, 
            string serviceZipCode, 
            int numberOfLines, 
            string referenceNumber, 
            NameInfo nameInfo)
        {
            // region ReserveNumbers (Done separately now)
            var reservedNumbers = new List<AddAccountRequestInfoReserveSubscriberNumber>();
            var reservedSubscriberNumber = new AddAccountRequestInfoReserveSubscriberNumber();
            var market = new InquireMarketServiceArea(
                serviceZipCode, 
                referenceNumber, 
                InquireMarketServiceArea.SelectionMethod.ZIP);

            reservedSubscriberNumber.Items = new object[4];

            reservedSubscriberNumber.Items[0] = market.Response.ServiceAreas[0].Location[0].serviceAreaCode;
            var reservedContactInfo = new AddAccountRequestInfoReserveSubscriberNumberContactInformation();
            reservedContactInfo.Item = nameInfo;
            reservedContactInfo.Address = new AddressInfo();
            reservedContactInfo.Address.AddressLine1 = billingAddress.AddressLine1;
            reservedContactInfo.Address.City = billingAddress.City;
            reservedContactInfo.Address.State =
                (AddressStateInfo)Enum.Parse(typeof(AddressStateInfo), billingAddress.State);
            reservedContactInfo.Address.StateSpecified = true;
            reservedContactInfo.Address.Zip = new AddressZipInfo();
            reservedContactInfo.Address.Zip.zipCode = billingAddress.ZipCode;
            reservedContactInfo.Address.Zip.zipCodeExtension = billingAddress.ExtendedZipCode;
            reservedSubscriberNumber.Items[1] = reservedContactInfo;
            reservedSubscriberNumber.Items[2] = EquipmentTypeInfo.G;
            reservedSubscriberNumber.Items[3] = (long)numberOfLines;

            // reservedSubscriberNumber.serviceArea = market.Response.ServiceAreas[0];
            var serviceInfo = new ServiceAreaLookupInfo();

            reservedSubscriberNumber.serviceArea = market.Response.ServiceAreas[0].Location[0].serviceAreaCode;
            reservedNumbers.Add(reservedSubscriberNumber);
            this.attRequest.ReserveSubscriberNumber = reservedNumbers.ToArray();
        }

        #endregion
    }
}