using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Security.Cryptography.X509Certificates;
using System.Web.Services;
using System.Web.Services.Protocols;
using AttCarrierServiceInterface;
using AttCarrierServiceInterface.Interfaces.AttProxy;
using Microsoft.Web.Services2.Security.Tokens;
using WirelessAdvocates;
using WirelessAdvocates.ServiceResponse;
using WirelessAdvocates.SalesOrder;

namespace AttCarrierServiceInterface
{
    public class UpdateSubscriberProfile : AttServiceBase
    {
        const string ObjectName = "UpdateSubscriberProfile";
        private UpdateSubscriberProfileSoapHttpBinding _attService;
        private UpdateSubscriberProfileRequestInfo _attRequest;
        private UpdateSubscriberProfileResponseInfo _attResponse;
        private InquireDuplicateOfferings _duplicateOfferings;
        private WirelessLine _line;
        private WirelessOrder _order;
        private List<OfferingsAdditionalInfo> _additionalOfferings;
        private CustomerLookup _customer;

        public UpdateSubscriberProfile(WirelessOrder wirelessOrder, WirelessLine wirelessLine, InquireDuplicateOfferings duplicateOfferings)
        {
            this.ReferenceNumber = wirelessOrder.CheckoutReferenceNumber;

            _order = wirelessOrder;
            _line = wirelessLine;
            _duplicateOfferings = duplicateOfferings;

            ExtendedAddress billingAddress = (ExtendedAddress)CheckoutSessionState.GetByReference(wirelessOrder.CheckoutReferenceNumber, WirelessAdvocates.Address.AddressEnum.Billing.ToString(), "AddressValidation", typeof(ExtendedAddress));
            ExtendedAddress shippingAddress = (ExtendedAddress)CheckoutSessionState.GetByReference(wirelessOrder.CheckoutReferenceNumber, WirelessAdvocates.Address.AddressEnum.Shipping.ToString(), "AddressValidation", typeof(ExtendedAddress));

            _customer = new CustomerLookup(wirelessOrder.CurrentAccountNumber, wirelessOrder.CurrentAccountPIN, shippingAddress.ZipCode, billingAddress.ZipCode, CustomerLookup.SelectionMethod.Ban, wirelessOrder.CheckoutReferenceNumber);

            #region Interface

            _attService = new UpdateSubscriberProfileSoapHttpBinding();
            _attService.Url = GetUrl("UpdateSubscriberProfileEndPoint");
            AddCerts(_attService.ClientCertificates);
            _attService.MessageHeader = GetMessageHeader(wirelessOrder.CheckoutReferenceNumber);

            #endregion

            #region Build Request

            _attRequest = new UpdateSubscriberProfileRequestInfo();

            UpdateSubscriberProfileRequestInfoSubscriber subscriber = new UpdateSubscriberProfileRequestInfoSubscriber() { subscriberNumber = _line.CurrentMDN };

            if (!_duplicateOfferings.RatePlanAlreadyExists && _line.CarrierPlanId != null)
            {
                subscriber.PricePlan = new RestrictedPricePlanInfo();

                if (_order.IsFamilyPlan)
                {
                    PricePlanGroupDetailsInfo groupInfo = new PricePlanGroupDetailsInfo();
                    groupInfo.Item = _line.CurrentMDN;
                    groupInfo.ItemElementName = ItemChoiceType.referenceSubscriber;
                    groupInfo.primarySubscriber = (_line.CurrentMDN == _customer.PrimaryMdn);

                    if (_line.CarrierPlanId != _customer.GetRatePlan(_line.CurrentMDN))
                    {
                        groupInfo.groupPlanCode = _line.CarrierPlanId;
                    }

                    subscriber.PricePlan.Item = groupInfo;
                }
                else
                {
                    if (_line.CarrierPlanId != _customer.GetRatePlan(_line.CurrentMDN))
                    {
                        subscriber.PricePlan.Item = _line.CarrierPlanId;
                    }
                }

                subscriber.PricePlan.Commission = new DealerCommissionInfo() { dealer = new DealerInfo() { code = GetAppSetting("DealerCode") } };

                // Single line upgrade currently
                _attRequest.Subscriber = new UpdateSubscriberProfileRequestInfoSubscriber[1] { subscriber };

                try
                {
                    _attResponse = _attService.UpdateSubscriberProfile(_attRequest);
                }
                catch (SoapException soapEx)
                {
                    WirelessAdvocates.Logger.new Log().LogException(WirelessAdvocates.new Utility().SerializeXML(soapEx.Detail), "Att", "UpdateSubscriberProfile", _order.CheckoutReferenceNumber);
                    throw;
                }

                catch (Exception ex)
                {
                    WirelessAdvocates.Logger.new Log().LogException(ex.Message, "Att", "UpdateSubscriberProfile", _order.CheckoutReferenceNumber);

                    throw;
                }

                finally
                {
                    LogRequest(_attRequest, ObjectName);
                    LogResponse(_attResponse, ObjectName);
                }
            }

            #endregion
        }
    }
}



