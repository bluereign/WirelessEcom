using System;
using System.Collections.Generic;
using System.Web.Services.Protocols;
using AttCarrierServiceInterface.Interfaces.AttProxy;
using WirelessAdvocates;
using WirelessAdvocates.SalesOrder;

namespace AttCarrierServiceInterface
{
    public class InquirePort : AttServiceBase
    {

        const string ObjectName = "InquirePort";
        //private InquirePortSoapHttpBinding _attService;
        //private InquirePortele _attRequest;
        //private InquirePortResponseInfo _attResponse;
        private InquirePortEligibilityBySubscriberNumberSoapHttpBinding _attService;
        private InquirePortEligibilityBySubscriberNumberRequestInfo _attRequest;
        private InquirePortEligibilityResponseInfo _attResponse;
        private WirelessOrder _order;
        private CustomerLookup _customer;
        ExtendedAddress _billingAddress;
        ExtendedAddress _shippingAddress;
        AddPortResponseInfo _addPortResponse;

        public InquirePort(WirelessOrder wirelessOrder)
        {

            #region Interface

            _attService.Url = GetUrl("AddPortEndPoint");
            AddCerts(_attService.ClientCertificates);
            _attService.MessageHeader = GetMessageHeader(wirelessOrder.CheckoutReferenceNumber);
            #endregion

            #region get stateful data
            _addPortResponse = (AddPortResponseInfo)WirelessAdvocates.CheckoutSessionState.GetByReference(wirelessOrder.CheckoutReferenceNumber, "AddPortResponse", "AddPort", typeof(AddPortResponseInfo));
            _billingAddress = (ExtendedAddress)CheckoutSessionState.GetByReference(wirelessOrder.CheckoutReferenceNumber, WirelessAdvocates.Address.AddressEnum.Billing.ToString(), "AddressValidation", typeof(ExtendedAddress));
            _shippingAddress = (ExtendedAddress)CheckoutSessionState.GetByReference(wirelessOrder.CheckoutReferenceNumber, WirelessAdvocates.Address.AddressEnum.Shipping.ToString(), "AddressValidation", typeof(ExtendedAddress));
            _customer = new CustomerLookup(wirelessOrder.CurrentAccountNumber, wirelessOrder.CurrentAccountPIN, _shippingAddress.ZipCode, _billingAddress.ZipCode, CustomerLookup.SelectionMethod.Ban, wirelessOrder.CheckoutReferenceNumber);
            _order = wirelessOrder;
            #endregion

            _attRequest = new InquirePortEligibilityBySubscriberNumberRequestInfo();

            #region Market Area
            // (basarim)
            //_attRequest.MarketServiceInfo = new MarketAndZipServiceInfo();
            //_attRequest.MarketServiceInfo.Items = new string[1];
            //_attRequest.MarketServiceInfo.Items[0] = _shippingAddress.ZipCode;
            //_attRequest.MarketServiceInfo.ItemsElementName = new ItemsChoiceType[1];
            //_attRequest.MarketServiceInfo.ItemsElementName[0] = ItemsChoiceType.serviceZipCode;
            _attRequest.marketServiceInfo = new MarketAndZipServiceInfo();
            _attRequest.marketServiceInfo.Items = new string[1];
            _attRequest.marketServiceInfo.Items[0] = _shippingAddress.ZipCode;
            _attRequest.marketServiceInfo.ItemsElementName = new ItemsChoiceType[1];
            _attRequest.marketServiceInfo.ItemsElementName[0] = ItemsChoiceType.serviceZipCode;
            #endregion

            // (basarim)
            //_attRequest.PortingSelector = new PortSelectorInfo();
            //_attRequest.PortingSelector.Item = _addPortResponse.PortingLocator;
            var portElig = new InquirePortEligibilityBySubscriberNumberRequestInfoPortEligibility();
            _attRequest.PortEligibility = new InquirePortEligibilityBySubscriberNumberRequestInfoPortEligibility[1] { portElig };
            portElig.subscriberNumber = _addPortResponse.PortingLocator.portRequestNumber;

            try
            {
                _attResponse = _attService.InquirePortEligibilityBySubscriberNumber(_attRequest);
            }
            catch (SoapException soapEx)
            {
                WirelessAdvocates.Logger.new Log().LogException(WirelessAdvocates.new Utility().SerializeXML(soapEx.Detail), "Att", ObjectName, _order.CheckoutReferenceNumber);
                throw;
            }
            catch (Exception ex)
            {
                WirelessAdvocates.Logger.new Log().LogException(ex.Message, "Att", ObjectName, _order.CheckoutReferenceNumber);
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
