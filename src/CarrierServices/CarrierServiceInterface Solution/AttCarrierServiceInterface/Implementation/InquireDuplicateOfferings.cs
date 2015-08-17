using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Security.Cryptography.X509Certificates;
using System.Web.Services;
using System.Web.Services.Protocols;
using AttCarrierServiceInterface.Interfaces.AttProxy;
using Microsoft.Web.Services2.Security.Tokens;
using WirelessAdvocates;
using WirelessAdvocates.ServiceResponse;
using WirelessAdvocates.SalesOrder;

namespace AttCarrierServiceInterface
{
    public class InquireDuplicateOfferings : AttServiceBase
    {
        InquireDuplicateOfferingsSoapHttpBinding _attService;
        InquireDuplicateOfferingsRequestInfo _attRequest;
        InquireDuplicateOfferingsResponseInfo _attResponse;
        CustomerLookup _customer;

        string _referenceNumber = String.Empty;

        WirelessOrder _order;
        WirelessLine _line;
        List<OfferingsAdditionalInfo> _additionalOfferings;
        List<OfferingsAdditionalInfo> _conflictingFeatureCodes;

        bool _ratePlanExists = false;

        public InquireDuplicateOfferings(WirelessOrder wirelessOrder, WirelessLine line)
        {
            this.ReferenceNumber = wirelessOrder.CheckoutReferenceNumber;

            _attService = new InquireDuplicateOfferingsSoapHttpBinding();
            _attService.Url = GetUrl("InquireDuplicateOfferingsEndpoint");
            _attService.MessageHeader = GetMessageHeader(_referenceNumber);

            this.AddCerts(_attService.ClientCertificates);

            ExtendedAddress billingAddress = (ExtendedAddress)CheckoutSessionState.GetByReference(wirelessOrder.CheckoutReferenceNumber, WirelessAdvocates.Address.AddressEnum.Billing.ToString(), "AddressValidation", typeof(ExtendedAddress));
            ExtendedAddress shippingAddress = (ExtendedAddress)CheckoutSessionState.GetByReference(wirelessOrder.CheckoutReferenceNumber, WirelessAdvocates.Address.AddressEnum.Shipping.ToString(), "AddressValidation", typeof(ExtendedAddress));

            _customer = new CustomerLookup(wirelessOrder.CurrentAccountNumber, wirelessOrder.CurrentAccountPIN, shippingAddress.ZipCode, billingAddress.ZipCode, CustomerLookup.SelectionMethod.Ban, wirelessOrder.CheckoutReferenceNumber);
            _order = wirelessOrder;
            _line = line;

            CheckOfferings();
        }

        public List<OfferingsAdditionalInfo> ConflictingFeatures
        {
            get
            {
                if (_conflictingFeatureCodes == null)
                {
                    if (_attResponse.DuplicateOfferingResultsInfo != null && _attResponse.DuplicateOfferingResultsInfo.Length > 0)
                    {
                        foreach (InquireDuplicateOfferingsResponseInfoDuplicateOfferingResultsInfo duplicate in _attResponse.DuplicateOfferingResultsInfo)
                        {
                            if (duplicate.PairConflictingOfferingInfo != null && duplicate.PairConflictingOfferingInfo.ConflictingOfferingInfo != null)
                            {
                                if (_conflictingFeatureCodes == null)
                                {
                                    _conflictingFeatureCodes = new List<OfferingsAdditionalInfo>();
                                }

                                _conflictingFeatureCodes.Add(duplicate.PairConflictingOfferingInfo.ConflictingOfferingInfo);
                            }
                        }
                    }
                }

                return _conflictingFeatureCodes;
            }
        }

        public bool RatePlanAlreadyExists
        {
            get { return _ratePlanExists; }
        }

        private void CheckOfferings()
        {
            _attRequest = new InquireDuplicateOfferingsRequestInfo();

            if (_line.CarrierPlanId != null)
            {
                _attRequest.PricePlan = new PricePlanInfo();
                _attRequest.PricePlan.actionCode = ActionInfo.A;    // Add
                _attRequest.PricePlan.actionCodeSpecified = true;

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
                    else
                    {
                        _ratePlanExists = true;
                    }
                }
                else
                {
                    if (_line.CarrierPlanId != _customer.GetRatePlan(_line.CurrentMDN))
                    {
                        _attRequest.PricePlan.Item = _line.CarrierPlanId;
                    }
                    else
                    {
                        _ratePlanExists = true;
                    }
                }

                _attRequest.PricePlan.Commission = new DealerCommissionInfo();
                _attRequest.PricePlan.Commission.dealer = new DealerInfo();
                _attRequest.PricePlan.Commission.dealer.code = GetAppSetting("DealerCode");
            }

            _attRequest.Subscriber = _line.CurrentMDN;

            if (_line.WirelessLineServices != null && _line.WirelessLineServices.Length > 0)
            {
                _additionalOfferings = new List<OfferingsAdditionalInfo>();

                foreach (WirelessLineService service in _line.WirelessLineServices)
                {
                    OfferingsAdditionalInfo addService = new OfferingsAdditionalInfo();

                    addService.action = ActionInfo.A;
                    addService.offeringCode = service.CarrierServiceId;
                    addService.Commission = new DealerCommissionInfo();
                    addService.Commission.dealer = new DealerInfo();
                    addService.Commission.dealer.code = GetAppSetting("DealerCode");

                    _additionalOfferings.Add(addService);
                }
            }

            if (_additionalOfferings != null && _additionalOfferings.Count > 0)
            {
                _attRequest.AdditionalOfferings = _additionalOfferings.ToArray();
            }

            try
            {
                _attResponse = _attService.InquireDuplicateOfferings(_attRequest);
            }
            catch (SoapException soapEx)
            {
                WirelessAdvocates.Logger.new Log().LogException(WirelessAdvocates.new Utility().SerializeXML(soapEx.Detail), "Att", "InquireDuplicateOfferings", _order.CheckoutReferenceNumber);

                throw;
            }
            catch (Exception ex)
            {
                WirelessAdvocates.Logger.new Log().LogException(ex.Message, "Att", "InquireDuplicateOfferings", _order.CheckoutReferenceNumber);

                throw;
            }
            finally
            {
                LogRequest(_attRequest, "InquireDuplicateOfferings");
                LogResponse(_attResponse, "InquireDuplicateOfferings");
            }
        }
    }
}