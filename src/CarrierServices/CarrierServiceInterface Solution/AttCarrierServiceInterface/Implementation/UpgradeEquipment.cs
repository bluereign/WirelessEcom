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
    public class UpgradeEquipment : AttServiceBase
    {
        public enum RequestType
        {
            Park,
            Activate
        }

        const string ObjectName = "UpgradeEquipment";
        private UpgradeEquipmentSoapHttpBinding _attService;
        private UpgradeEquipmentRequestInfo _attRequest;
        private UpgradeEquipmentResponseInfo _attResponse;
        private InquireDuplicateOfferings _duplicateOfferings;
        private InquireUpgradeEligibility _upgradeEligibility;
        private CustomerLookup _customer;

        List<OfferingsAdditionalInfo> _additionalOfferings;

        public UpgradeEquipment(WirelessOrder order, WirelessLine line, RequestType ueRequestType)
        {
            try
            {
                this.ReferenceNumber = order.CheckoutReferenceNumber;

                _upgradeEligibility = new InquireUpgradeEligibility(line.CurrentMDN, order.CheckoutReferenceNumber);

                if (!_upgradeEligibility.IsUpgradeEligible)
                {
                    throw new Exception("Line is not upgrade eligible");
                }

                _duplicateOfferings = new InquireDuplicateOfferings(order, line);

                #region Interface

                _attService = new UpgradeEquipmentSoapHttpBinding();
                _attService.Url = GetUrl("UpgradeEquipmentEndpoint");
                AddCerts(_attService.ClientCertificates);
                _attService.MessageHeader = GetMessageHeader(order.CheckoutReferenceNumber);

                #endregion

                #region Build Request

                _attRequest = new UpgradeEquipmentRequestInfo();
                _attRequest.billingAccountNumber = order.CurrentAccountNumber;
                _attRequest.Control = new UpgradeEquipmentRequestInfoControl();

                ExtendedAddress shippingAddress = (ExtendedAddress)CheckoutSessionState.GetByReference(order.CheckoutReferenceNumber, WirelessAdvocates.Address.AddressEnum.Shipping.ToString(), "AddressValidation", typeof(WirelessAdvocates.ExtendedAddress));
                ExtendedAddress billingAddress = (ExtendedAddress)CheckoutSessionState.GetByReference(order.CheckoutReferenceNumber, WirelessAdvocates.Address.AddressEnum.Billing.ToString(), "AddressValidation", typeof(WirelessAdvocates.ExtendedAddress));

                _customer = new CustomerLookup(order.CurrentAccountNumber, order.CurrentAccountPIN, shippingAddress.ZipCode, billingAddress.ZipCode, CustomerLookup.SelectionMethod.Ban, order.CheckoutReferenceNumber);

                _attRequest.MarketServiceInfo = new MarketAndZipServiceInfo();
                _attRequest.MarketServiceInfo.ItemsElementName = new ItemsChoiceType[1];
                _attRequest.MarketServiceInfo.Items = new string[1];
                _attRequest.MarketServiceInfo.ItemsElementName[0] = ItemsChoiceType.serviceZipCode;
                _attRequest.MarketServiceInfo.Items[0] = shippingAddress.ZipCode;
                _attRequest.newSalesChannel = GetAppSetting("NewSalesChannel");
                _attRequest.Subscriber = new UpgradeEquipmentRequestInfoSubscriber();
                _attRequest.Subscriber.subscriberNumber = line.CurrentMDN;
                _attRequest.Subscriber.Contract = new UpgradeEquipmentRequestInfoSubscriberContract();
                _attRequest.Subscriber.Contract.ContractTerm = new ContractTermInfo();
                _attRequest.Subscriber.Contract.ContractTerm.term = 24;

                double addDays;

                if (!double.TryParse(GetAppSetting("ActivateAfterDays"), out addDays))
                {
                    addDays = 2;
                }

                _attRequest.Subscriber.Contract.ContractTerm.startDateSpecified = false;

                _attRequest.Subscriber.Contract.ContractTerm.Commission = new DealerCommissionInfo();
                _attRequest.Subscriber.Contract.ContractTerm.Commission.dealer = new DealerInfo();
                _attRequest.Subscriber.Contract.ContractTerm.Commission.dealer.code = GetAppSetting("DealerCode");

                _attRequest.Control.activateUpgrade = false;
                _attRequest.Control.parkType = ParkTypeInfo.E;      // Park equipment, set if activate is false
                _attRequest.Subscriber.Contract.termsConditionStatus = TermsConditionsStatusInfo.W;
                _attRequest.Control.approvalNumber = _upgradeEligibility.ApprovalNumber;

                if (line.WirelessLineServices != null && line.WirelessLineServices.Length > 0)
                {
                    if (_additionalOfferings == null)
                    {
                        _additionalOfferings = new List<OfferingsAdditionalInfo>();
                    }

                    foreach (WirelessLineService service in line.WirelessLineServices)
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

                if (_duplicateOfferings != null && _duplicateOfferings.ConflictingFeatures != null)
                {
                    foreach (OfferingsAdditionalInfo conflict in _duplicateOfferings.ConflictingFeatures)
                    {
                        if (_additionalOfferings == null)
                        {
                            _additionalOfferings = new List<OfferingsAdditionalInfo>();
                        }

                        OfferingsAdditionalInfo objectToRemove = null;

                        foreach (OfferingsAdditionalInfo offer in _additionalOfferings)
                        {
                            if (offer.action == ActionInfo.A && conflict.offeringCode == offer.offeringCode)
                            {
                                objectToRemove = offer;

                                break;
                            }
                        }

                        if (objectToRemove == null)
                        {
                            conflict.action = ActionInfo.R;

                            _additionalOfferings.Add(conflict);
                        }
                        else
                        {
                            _additionalOfferings.Remove(objectToRemove);
                        }
                    }
                }

                if (_additionalOfferings != null && _additionalOfferings.Count > 0)
                {
                    _attRequest.Subscriber.AdditionalOfferings = _additionalOfferings.ToArray();
                }

                _attRequest.Subscriber.Device = new DeviceInfo();
                _attRequest.Subscriber.Device.IMEI = line.IMEI;
                _attRequest.Subscriber.Device.SIM = line.UnmodifiedSim;
                _attRequest.Subscriber.Device.equipmentType = EquipmentTypeInfo.G;

                //Send device SKU/UPC in ESN field to resolve ETF issue
                _attRequest.Subscriber.Device.ESN = line.WirelessLineDevices[0].CarrierBillCode;

                if (line.DeviceType == DeviceTechnology.UMTS)
                {
                    _attRequest.Subscriber.Device.technologyType = TechnologyTypeInfo.UMTS;
                }
                else
                {
                    _attRequest.Subscriber.Device.technologyType = TechnologyTypeInfo.GSM;
                }

                #endregion

                #region Activation

                LogRequest(_attService.MessageHeader.TrackingMessageHeader.conversationId, "ConversationId");

                _attResponse = _attService.UpgradeEquipment(_attRequest);

                #endregion
            }
            catch (SoapException soapEx)
            {
                WirelessAdvocates.Logger.new Log().LogException(_attService.MessageHeader.TrackingMessageHeader.conversationId, "Att", "ConversationId", order.CheckoutReferenceNumber);
                WirelessAdvocates.Logger.new Log().LogException(WirelessAdvocates.new Utility().SerializeXML(soapEx.Detail), "Att", ObjectName, order.CheckoutReferenceNumber);

                throw;
            }
            catch (Exception ex)
            {
                System.Diagnostics.StackTrace trace = new System.Diagnostics.StackTrace(ex, true);

                if (_attService != null)
                {
                    WirelessAdvocates.Logger.new Log().LogException(_attService.MessageHeader.TrackingMessageHeader.conversationId + " " + ex.Message, "Att", "ConversationId", order.CheckoutReferenceNumber);
                    WirelessAdvocates.Logger.new Log().LogException(_attService.Url, "Att", "URL", order.CheckoutReferenceNumber);
                }

                //LogRequest(WirelessAdvocates.new Utility().SerializeXML(_attService), ObjectName);
                WirelessAdvocates.Logger.new Log().LogException("EX " + ex.Message + " ST: " + ex.StackTrace + "Line: " + trace.GetFrame(0).GetFileLineNumber() + "Column: " + trace.GetFrame(0).GetFileColumnNumber(), "Att", ObjectName, order.CheckoutReferenceNumber);

                throw;
            }
            finally
            {
                LogRequest(_attRequest, ObjectName);
                LogResponse(_attResponse, ObjectName);
            }
        }
    }
}


