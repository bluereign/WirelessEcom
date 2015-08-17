using System;
using System.Linq;
using System.Collections.Generic;
using System.Web.Services.Protocols;
using AttCarrierServiceInterface.Interfaces.AttProxy;
using WirelessAdvocates;
using WirelessAdvocates.SalesOrder;

namespace AttCarrierServiceInterface
{
    public class AddPort : AttServiceBase
    {

        const string ObjectName = "AddPort";
        private AddPortSoapHttpBinding _attService = new AddPortSoapHttpBinding();
        private AddPortRequestInfo _attRequest;
        private AddPortResponseInfo _attResponse;
        private WirelessOrder _order;
        private CustomerLookup _customer;
        ExtendedAddress _billingAddress;
        ExtendedAddress _shippingAddress;
        public AddPort(WirelessOrder wirelessOrder)
        {

            #region Interface

            _attService.Url = GetUrl("AddPortEndPoint");
            AddCerts(_attService.ClientCertificates);
            _attService.MessageHeader = GetMessageHeader(wirelessOrder.CheckoutReferenceNumber);
            #endregion

            _billingAddress = (ExtendedAddress)CheckoutSessionState.GetByReference(wirelessOrder.CheckoutReferenceNumber, WirelessAdvocates.Address.AddressEnum.Billing.ToString(), "AddressValidation", typeof(ExtendedAddress));
            _shippingAddress = (ExtendedAddress)CheckoutSessionState.GetByReference(wirelessOrder.CheckoutReferenceNumber, WirelessAdvocates.Address.AddressEnum.Shipping.ToString(), "AddressValidation", typeof(ExtendedAddress));

            InquireMarketServiceArea market = new InquireMarketServiceArea(_shippingAddress.ZipCode, wirelessOrder.CheckoutReferenceNumber, InquireMarketServiceArea.SelectionMethod.ZIP);
            _customer = new CustomerLookup(wirelessOrder.CurrentAccountNumber, wirelessOrder.CurrentAccountPIN, _shippingAddress.ZipCode, _billingAddress.ZipCode, CustomerLookup.SelectionMethod.Ban, wirelessOrder.CheckoutReferenceNumber);
            _order = wirelessOrder;
            this.ReferenceNumber = _order.CheckoutReferenceNumber;  // assigned so it will be logged

            _attRequest = new AddPortRequestInfo();
            _attRequest.Commission = GetDealerCommission();

            #region Customer


            _attRequest.Customer = new AddPortRequestInfoCustomer();
            _attRequest.Customer.billingAccountNumber = _customer.Ban;
            _attRequest.Customer.Item = _customer.AccountProfile.Account.Customer.Items[0];
            _attRequest.Customer.Address = new AddressInfo();
            _attRequest.Customer.Address.AddressLine1 = _billingAddress.AddressLine1;
            if (!string.IsNullOrEmpty(_billingAddress.AddressLine2))
            {
                _attRequest.Customer.Address.AddressLine2 = _billingAddress.AddressLine2;
            }
            _attRequest.Customer.Address.City = _billingAddress.City;
            _attRequest.Customer.Address.Zip = new AddressZipInfo();
            _attRequest.Customer.Address.Zip.zipCode = _billingAddress.ZipCode;
            _attRequest.Customer.Address.Zip.zipCodeExtension = _billingAddress.ExtendedZipCode;
            #endregion
            #region Market Area
            _attRequest.marketServiceInfo = new MarketAndZipServiceInfo();
            _attRequest.marketServiceInfo.Items = new string[1];
            _attRequest.marketServiceInfo.Items[0] = _shippingAddress.ZipCode;
            _attRequest.marketServiceInfo.ItemsElementName = new ItemsChoiceType[1];
            _attRequest.marketServiceInfo.ItemsElementName[0] = ItemsChoiceType.serviceZipCode;
            #endregion

           
            _attRequest.PortRequest = new PortRequestInfo();
            //[System.Xml.Serialization.XmlElementAttribute("businessName", typeof(NameBusinessInfo))]
            //[System.Xml.Serialization.XmlElementAttribute("doingBusinessAs", typeof(string))]
            //[System.Xml.Serialization.XmlElementAttribute("name", typeof(NameInfo))]
            foreach (NameInfo name in _customer.AccountProfile.Account.Customer.Items)
            {
                _attRequest.PortRequest.authorizationName = name.firstName + " " + name.lastName;
            }


            _attRequest.PortRequest.desiredDueDate = CalcActivationDate();
            _attRequest.PortRequest.desiredDueDateSpecified = true;
            _attRequest.PortRequest.immediateAct = ImmediateActInfo.P;
            _attRequest.PortRequest.immediateActSpecified = true;
            _attRequest.PortRequest.initiatorId = GetAppSetting("DealerCode");
            _attRequest.PortRequest.Item = _order.SSN;
            _attRequest.PortRequest.ItemElementName = ItemChoiceType2.socialSecurityNumber;

            List<PortRequestLineInfo> portInLines = null;

            int i = 1;
            var linesToPort = from lines in _order.WirelessLines where (bool)lines.IsMdnPort select lines;

            foreach (WirelessLine line in linesToPort)
            {
                if (portInLines == null)
                {
                    portInLines = new List<PortRequestLineInfo>();
                    _attRequest.PortRequest.ospBillingAccountNumber = line.PortInCarrierAccount;
                    _attRequest.PortRequest.ospBillingAccountPassword = line.PortInCarrierPin;
                }
                PortRequestLineInfo portInLine = new PortRequestLineInfo();
                portInLine.equipmentType = EquipmentTypeInfo.G;
                portInLine.fromLine = line.NewMDN.Substring(6, 4);
                portInLine.npaNxx = line.NewMDN.Substring(0, 6);
                portInLine.serviceArea = market.GetServiceArea(line.NewMDN.Substring(0, 3));
                portInLine.ContactInformation = new PortRequestLineInfoContactInformation();
                // TODO:NOTE:CURRENTLY REQUIRE THAT THE PORT BILLING ADDRESS BE THE SAME AS THE NEW ACCT BILLING ADDRESS
                // WOULD REQUIRE CAPTURING ON THE FRONT END WITH THE OTHER PORT-IN INFORMATION
                portInLine.ContactInformation.Item = _customer.AccountProfile.Account.Customer.Items[0];
                portInLine.ContactInformation.Address = _customer.AccountProfile.Account.Customer.Address;
                portInLine.portRequestLineId = i++;
                portInLines.Add(portInLine);
            }
         
            if (portInLines != null && portInLines.Count > 0)
            {
                _attRequest.PortRequestLine = portInLines.ToArray();
            }
            else
            { 
                return;     // NOTHING TO DO
            }

            try
            {
                _attResponse = _attService.AddPort(_attRequest);
                CheckoutSessionState.Add(wirelessOrder.CheckoutReferenceNumber, "AddPortResponse", "AddPort", _attResponse);

                WirelessAdvocates.CheckoutSessionState.Add(wirelessOrder.CheckoutReferenceNumber, "AddPortResponse", "AddPort", _attResponse);
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
