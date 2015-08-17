using System;
using System.Linq;
using System.Collections.Generic;
using System.Web.Services.Protocols;
using AttCarrierServiceInterface.Interfaces.AttProxy;
using WirelessAdvocates;
using WirelessAdvocates.SalesOrder;

namespace AttCarrierServiceInterface
{
    public class ReserveSubscriberNumber : AttServiceBase
    {

        const string ObjectName = "ReserveSubscriberNumber";
        private ReserveSubscriberNumberSoapHttpBinding _attService = new ReserveSubscriberNumberSoapHttpBinding();
        private ReserveSubscriberNumberRequestInfo _attRequest;
        private ReserveSubscriberNumberResponseInfo _attResponse;

        private WirelessOrder _order;
        private List<OfferingsAdditionalInfo> _additionalOfferings;
        private CustomerLookup _customer;
        ExtendedAddress _billingAddress;
        ExtendedAddress _shippingAddress;
        public ReserveSubscriberNumber(WirelessOrder wirelessOrder)
        {

            #region Interface

            _attService.Url = GetUrl("ReserveSubscriberNumberEndPoint");
            AddCerts(_attService.ClientCertificates);
            _attService.MessageHeader = GetMessageHeader(wirelessOrder.CheckoutReferenceNumber);
            #endregion


            _billingAddress = (ExtendedAddress)CheckoutSessionState.GetByReference(wirelessOrder.CheckoutReferenceNumber, WirelessAdvocates.Address.AddressEnum.Billing.ToString(), "AddressValidation", typeof(ExtendedAddress));
            _shippingAddress = (ExtendedAddress)CheckoutSessionState.GetByReference(wirelessOrder.CheckoutReferenceNumber, WirelessAdvocates.Address.AddressEnum.Shipping.ToString(), "AddressValidation", typeof(ExtendedAddress));

            _customer = new CustomerLookup(wirelessOrder.CurrentAccountNumber, wirelessOrder.CurrentAccountPIN, _shippingAddress.ZipCode, _billingAddress.ZipCode, CustomerLookup.SelectionMethod.Ban, wirelessOrder.CheckoutReferenceNumber);
            _order = wirelessOrder;
            this.ReferenceNumber = _order.CheckoutReferenceNumber;
            InquireMarketServiceArea market = new InquireMarketServiceArea(_shippingAddress.ZipCode, wirelessOrder.CheckoutReferenceNumber, InquireMarketServiceArea.SelectionMethod.ZIP);

            ReserveSubscriberNumberRequestInfoSubscriberContactInformation contactInfo = null;
            List<ReserveSubscriberNumberRequestInfoSubscriber> subscriberRequests = null;

            var NpasForNonPortLines = from lines in wirelessOrder.WirelessLines where !(bool)lines.IsMdnPort group lines by lines.NPARequested into g select new { NPA = g.Key, occurs = g.Count() };
            foreach (var npa in NpasForNonPortLines)
            {
                if (subscriberRequests == null)
                {
                    subscriberRequests = new List<ReserveSubscriberNumberRequestInfoSubscriber>();
                }
                ReserveSubscriberNumberRequestInfoSubscriber subscriber = new ReserveSubscriberNumberRequestInfoSubscriber();
                subscriber.serviceArea = market.GetServiceArea(npa.NPA);
                subscriber.equipmentTypeSpecified = false;
                subscriber.Commission = new DealerCommissionInfo();
                subscriber.Commission.dealer = new DealerInfo();
                subscriber.Commission.dealer.code = GetAppSetting("DealerCode");
                ReserveSubscriberNumberRequestInfoSubscriberRandom randomPhoneNumber = new ReserveSubscriberNumberRequestInfoSubscriberRandom();
                randomPhoneNumber.quantityOfRandomSubscriberNumbers = npa.occurs.ToString();
                subscriber.Item = randomPhoneNumber;
                subscriberRequests.Add(subscriber);

                if (contactInfo == null)
                {
                    contactInfo = new ReserveSubscriberNumberRequestInfoSubscriberContactInformation();
                    contactInfo.Address = new AddressInfo();
                    contactInfo.Address.AddressLine1 = _billingAddress.AddressLine1;
                    contactInfo.Address.AddressLine2 = _billingAddress.AddressLine2;
                    contactInfo.Address.addressType = AddressTypeInfo.S;
                    contactInfo.Address.City = _billingAddress.City;
                    contactInfo.Address.State = (AddressStateInfo)Enum.Parse(typeof(AddressStateInfo), _billingAddress.State);
                    contactInfo.Address.Zip = new AddressZipInfo();
                    contactInfo.Address.Zip.zipCode = _billingAddress.ZipCode;
                    contactInfo.Address.Zip.zipCodeExtension = _billingAddress.ExtendedZipCode;

                }
                contactInfo.Item = _customer.AccountProfile.Account.Customer.Items[0];
                subscriber.ContactInformation = contactInfo;

            }

            if (subscriberRequests == null || subscriberRequests.Count == 0)
            {
                return;  // nothing to do
            }

            _attRequest = new ReserveSubscriberNumberRequestInfo();
            _attRequest.billingAccountNumber = wirelessOrder.CurrentAccountNumber;


            _attRequest.marketServiceInfo = new MarketAndZipServiceInfo();
            _attRequest.marketServiceInfo.Items = new string[1];
            _attRequest.marketServiceInfo.Items[0] = _shippingAddress.ZipCode;
            _attRequest.marketServiceInfo.ItemsElementName = new ItemsChoiceType[1];
            _attRequest.marketServiceInfo.ItemsElementName[0] = ItemsChoiceType.serviceZipCode;

            _attRequest.Subscriber = subscriberRequests.ToArray();

            try
            {
                _attResponse = _attService.ReserveSubscriberNumber(_attRequest);



                List<string> reservedNumber = new List<string>();
                foreach (SubscriberNumberReservationInfo reservation in _attResponse.Subscriber)
                {
                    if (reservation.reserved)
                    {
                        reservedNumber.Add(reservation.subscriberNumber);
                    }
                }

                foreach (WirelessLine line in wirelessOrder.WirelessLines)
                {
                    if (line.IsMdnPort != null && !(bool)line.IsMdnPort)
                    {
                        if (reservedNumber != null && reservedNumber.Count > 0)
                        {
                            line.NewMDN = reservedNumber[0];
                            reservedNumber.RemoveAt(0);
                        }       
                        else
                        {
                            throw new AccessViolationException("Few reserved numbers than required");
                        }
                    }
                }
                wirelessOrder.Save();
            }
            catch (SoapException soapEx)
            {
                WirelessAdvocates.Logger.new Log().LogException(soapEx.Message + ":" + WirelessAdvocates.new Utility().SerializeXML(soapEx.Detail), "Att", ObjectName, _order.CheckoutReferenceNumber);
                throw;
            }
            catch (Exception ex)
            {
                WirelessAdvocates.Logger.new Log().LogException(WirelessAdvocates.new Utility().SerializeXML(ex), "Att", ObjectName, _order.CheckoutReferenceNumber);
                throw;
            }
            finally
            {
                this.LogRequest(_attRequest, ObjectName);
                if (_attResponse != null)
                {
                    this.LogResponse(_attResponse, ObjectName);
                }
            }
        }

        public SubscriberNumberReservationInfo GetReservationInfo(string subscriberNumber)
        {
            foreach (SubscriberNumberReservationInfo reservation in _attResponse.Subscriber)
            {
                if (reservation.subscriberNumber == subscriberNumber)
                {
                    return reservation;
                }
            }
            throw new Exception("Subscriber number reservation not found");
        }

    }
}