// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ActivateSubscriberRequest.cs" company="">
//   
// </copyright>
// <summary>
//   The activate subscriber request.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace AttCarrierServiceInterface
{
    using System;
    using System.Collections.Generic;
    using System.Web.Services.Protocols;

    using AttCarrierServiceInterface.Interfaces.AttProxy;

    using WirelessAdvocates;
    using WirelessAdvocates.Enum;
    using WirelessAdvocates.Logger;
    using WirelessAdvocates.SalesOrder;

    using Address = WirelessAdvocates.Address;

    /// <summary>The activate subscriber request.</summary>
    public class ActivateSubscriberRequest : AttServiceBase
    {
        #region Constants

        /// <summary>The object name.</summary>
        private const string ObjectName = "ActivateSubscriberRequest";

        #endregion

        #region Fields

        /// <summary>The _billing address.</summary>
        private readonly ExtendedAddress billingAddress;

        /// <summary>The _customer.</summary>
        private readonly CustomerLookup customer;

        /// <summary>The _order.</summary>
        private readonly WirelessOrder order;

        /// <summary>The _reserve numbers.</summary>
        private readonly ReserveSubscriberNumber reserveNumbers;

        /// <summary>The _shipping address.</summary>
        private readonly ExtendedAddress shippingAddress;

/*
        /// <summary>The _additional offerings.</summary>
        private List<OfferingsAdditionalInfo> _additionalOfferings;
*/

        /// <summary>The _att request.</summary>
        private ActivateSubscriberRequestInfo attRequest;

        /// <summary>The _att response.</summary>
        private RequestAcknowledgementInfo attResponse;

        /// <summary>The _att service.</summary>
        private ActivateSubscriberRequestSoapHttpBinding attService;

        /// <summary>The _port numbers.</summary>
        private AddPort portNumbers;

        #endregion

        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="ActivateSubscriberRequest"/> class.</summary>
        /// <param name="wirelessOrder">The wireless order.</param>
        public ActivateSubscriberRequest(WirelessOrder wirelessOrder)
        {
            this.order = wirelessOrder;
            this.ReferenceNumber = this.order.CheckoutReferenceNumber;

            this.billingAddress =
                (ExtendedAddress)
                CheckoutSessionState.GetByReference(
                    this.ReferenceNumber, 
                    Address.AddressEnum.Billing.ToString(), 
                    "AddressValidation", 
                    typeof(ExtendedAddress));
            this.shippingAddress =
                (ExtendedAddress)
                CheckoutSessionState.GetByReference(
                    this.ReferenceNumber, 
                    Address.AddressEnum.Shipping.ToString(), 
                    "AddressValidation", 
                    typeof(ExtendedAddress));

            this.customer = new CustomerLookup(
                wirelessOrder.CurrentAccountNumber, 
                wirelessOrder.CurrentAccountPIN, 
                this.shippingAddress.ZipCode, 
                this.billingAddress.ZipCode, 
                CustomerLookup.SelectionMethod.Ban, 
                wirelessOrder.CheckoutReferenceNumber);
            this.reserveNumbers = new ReserveSubscriberNumber(wirelessOrder);

            this.portNumbers = new AddPort(wirelessOrder);
            this.Activate();
        }

        #endregion

        #region Methods

        /// <summary>The activate.</summary>
        /// <exception cref="Exception"></exception>
        private void Activate()
        {
            this.attService = new ActivateSubscriberRequestSoapHttpBinding();
            this.attService.Url = this.GetUrl("ActivateSubscriberRequestEndPoint");
            this.AddCerts(this.attService.ClientCertificates);
            this.attService.MessageHeader = this.GetMessageHeader(this.order.CheckoutReferenceNumber);
            this.attService.MessageHeader.TrackingMessageHeader.returnURL = this.GetAppSetting("AsyncCallbackUrl");

            this.attRequest = new ActivateSubscriberRequestInfo { billingAccountNumber = this.customer.Ban };

            var market = new InquireMarketServiceArea(
                this.shippingAddress.ZipCode,
                this.order.CheckoutReferenceNumber,
                InquireMarketServiceArea.SelectionMethod.ZIP);
            this.attRequest.MarketServiceInfo = new MarketAndZipServiceInfo { Items = new string[1] };
            this.attRequest.MarketServiceInfo.Items[0] = this.shippingAddress.ZipCode;
            this.attRequest.MarketServiceInfo.ItemsElementName = new ItemsChoiceType[1];
            this.attRequest.MarketServiceInfo.ItemsElementName[0] = ItemsChoiceType.serviceZipCode;

            if (this.order.WirelessLines == null || this.order.WirelessLines.Length <= 0)
            {
                throw new Exception("Nothing to activate");
            }

            double addDays; // Default

            if (!double.TryParse(this.GetAppSetting("ActivateAfterDays"), out addDays))
            {
                addDays = 2; // default if not set
            }

            var subscribers = new List<ActivateSubscriberRequestInfoSubscriber>();

            ActivateSubscriberRequestInfoSubscriberContactInformation contactInfo = null;

            foreach (var line in this.order.WirelessLines)
            {
                var subscriber = new ActivateSubscriberRequestInfoSubscriber();

                subscriber.activationDate = DateTime.Now.AddDays(addDays).ToString("yyyy-MM-ddZ");
                subscriber.activationDateSpecified = true;
                subscriber.PricePlan = new PricePlanInfo();
                subscriber.PricePlan.actionCode = ActionInfo.A;
                subscriber.PricePlan.Commission = new DealerCommissionInfo();
                subscriber.PricePlan.Commission.dealer = new DealerInfo { code = this.GetAppSetting("DealerCode") };
                subscriber.subscriberNumber = line.NewMDN;

                string familyCode = this.customer.GetFamilyPlanCode();

                if (familyCode != null)
                {
                    var pricePlanGroupDetail = new PricePlanGroupDetailsInfo { groupPlanCode = familyCode };
                    subscriber.PricePlan.Item = pricePlanGroupDetail;
                }
                else
                {
                    subscriber.PricePlan.Item = line.CarrierPlanId;
                }

                subscriber.Contract = new ActivateSubscriberRequestInfoSubscriberContract();
                subscriber.Contract.ContractTerm = new ContractTermInfo();
                subscriber.Contract.ContractTerm.Commission = new DealerCommissionInfo();
                subscriber.Contract.ContractTerm.Commission.dealer = new DealerInfo();
                subscriber.Contract.ContractTerm.Commission.dealer.code = this.GetAppSetting("DealerCode");
                subscriber.Contract.ContractTerm.term = 24;
                subscriber.Contract.termsConditionStatus = TermsConditionsStatusInfo.W;

                if (line.WirelessLineServices != null && line.WirelessLineServices.Length > 0)
                {
                    List<OfferingsAdditionalInfo> offerings = null;

                    foreach (WirelessLineService service in line.WirelessLineServices)
                    {
                        if (line.GroupNumber != service.GroupNumber)
                        {
                            continue;
                        }

                        if (offerings == null)
                        {
                            offerings = new List<OfferingsAdditionalInfo>();
                        }

                        var addService = new OfferingsAdditionalInfo();
                        addService.action = ActionInfo.A;
                        addService.offeringCode = service.CarrierServiceId;
                        addService.Commission = new DealerCommissionInfo();
                        addService.Commission.dealer = new DealerInfo();
                        addService.Commission.dealer.code = this.GetAppSetting("DealerCode");
                        offerings.Add(addService);
                    }

                    if (offerings != null)
                    {
                        subscriber.AdditionalOfferings = offerings.ToArray();
                    }
                }

                if (contactInfo == null)
                {
                    contactInfo = new ActivateSubscriberRequestInfoSubscriberContactInformation();
                    contactInfo.Address = new AddressInfo();
                    contactInfo.Address.AddressLine1 = this.billingAddress.AddressLine1;
                    contactInfo.Address.AddressLine2 = this.billingAddress.AddressLine2;
                    contactInfo.Address.addressType = AddressTypeInfo.S;
                    contactInfo.Address.City = this.billingAddress.City;
                    contactInfo.Address.State =
                        (AddressStateInfo)Enum.Parse(typeof(AddressStateInfo), this.billingAddress.State);
                    contactInfo.Address.Zip = new AddressZipInfo();
                    contactInfo.Address.Zip.zipCode = this.billingAddress.ZipCode;
                    contactInfo.Address.Zip.zipCodeExtension = this.billingAddress.ExtendedZipCode;
                    contactInfo.Phone = new PhoneInfo();
                    contactInfo.Phone = this.customer.AccountProfile.Account.Customer.Phone;
                    contactInfo.Email = new EmailInfo();
                    contactInfo.Email.emailAddress = this.order.Email;
                }

                contactInfo.Item = this.customer.AccountProfile.Account.Customer.Items[0];
                subscriber.ContactInformation = contactInfo;

                // TODO Additional Offerings
                subscriber.Deposit = new ActivateSubscriberRequestInfoSubscriberDeposit { depositAmount = 0 };

                if (!(bool)line.IsMdnPort && this.reserveNumbers != null)
                {
                    var reservationInfo = this.reserveNumbers.GetReservationInfo(line.NewMDN);
                    if (reservationInfo != null)
                    {
                        subscriber.Deposit.depositAmount = reservationInfo.depositAmount;
                    }
                }

                subscriber.suspendImmediate = false;

                subscriber.Device = new DeviceInfo { equipmentType = EquipmentTypeInfo.G };

                switch (line.DeviceType)
                {
                    case DeviceTechnology.UMTS:
                        subscriber.Device.technologyType = TechnologyTypeInfo.UMTS;
                        break;
                    default:
                        subscriber.Device.technologyType = TechnologyTypeInfo.GSM;
                        break;
                }

                subscriber.Device.IMEI = line.IMEI;
                subscriber.Device.SIM = line.UnmodifiedSim;

                if ((bool)line.IsMdnPort)
                {
                    subscriber.serviceArea = market.GetServiceArea(line.NewMDN.Substring(0, 3));
                }
                else
                {
                    subscriber.serviceArea = market.GetServiceArea(line.NPARequested);
                }

                subscribers.Add(subscriber);
                line.ActivationStatus = ActivationStatus.RequestSubmitted; // Requested
            }

            this.attRequest.Subscriber = subscribers.ToArray();

            try
            {
                this.LogRequest(this.attService.MessageHeader.TrackingMessageHeader.conversationId, "ConversationId");
                this.attResponse = this.attService.ActivateSubscriberRequest(this.attRequest);
                this.order.ActivationStatus = (int)ActivationStatus.RequestSubmitted;
            }
            catch (SoapException soapEx)
            {
                new Log().LogException(
                    new Utility().SerializeXML(soapEx.Detail),
                    "Att",
                    "ActivateSubscriberRequest",
                    this.order.CheckoutReferenceNumber);
                this.order.ActivationStatus = (int)ActivationStatus.Failure;
                throw;
            }
            catch (Exception ex)
            {
                new Log().LogException(ex.Message, "Att", "ActivateSubscriberRequest", this.order.CheckoutReferenceNumber);
                this.order.ActivationStatus = (int)ActivationStatus.Failure;
                throw;
            }
            finally
            {
                this.order.Save();
                this.LogRequest(this.attRequest, ObjectName);
                if (this.attResponse != null)
                {
                    this.LogResponse(this.attResponse, ObjectName);
                }
            }
        }

        #endregion
    }
}