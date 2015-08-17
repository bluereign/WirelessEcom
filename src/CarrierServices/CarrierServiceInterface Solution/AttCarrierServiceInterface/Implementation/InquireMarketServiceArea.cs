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
    public class InquireMarketServiceArea : AttServiceBase
    {

        public enum SelectionMethod
        {
            ZIP,
            MDN
        }

        private InquireMarketServiceAreasSoapHttpBinding _attService;
        private InquireMarketServiceAreasRequestInfo _attRequest;
        private InquireMarketServiceAreasResponseInfo _attResponse;
        private List<NpaInfo> _npaList;
        const string requestType = "NpaLookupByZip";

        List<OfferingsAdditionalInfo> _additionalOfferings;



        public InquireMarketServiceArea(string selectInfo, string referenceNumber, SelectionMethod method)
        {
            this.ReferenceNumber = referenceNumber;
            _attService = new InquireMarketServiceAreasSoapHttpBinding();
            _attService.Url = GetUrl("InquireMarketServiceAreasEndpoint");
            _attService.MessageHeader = GetMessageHeader(this.ReferenceNumber);
            this.AddCerts(_attService.ClientCertificates);



            if (method == SelectionMethod.ZIP)
            {
                InquireMarketServiceAreasRequestInfoServiceAreasSelector selector;
                InquireMarketServiceAreasRequestInfoServiceAreasSelectorSelectorsWithMarketType selectWithMarketType;
                selector = new InquireMarketServiceAreasRequestInfoServiceAreasSelector();
                selectWithMarketType = new InquireMarketServiceAreasRequestInfoServiceAreasSelectorSelectorsWithMarketType();

                selectWithMarketType.Item = selectInfo;
                selectWithMarketType.marketType = MarketTypeInfo.Both;
                selector.Item = selectWithMarketType;

                _attRequest = new InquireMarketServiceAreasRequestInfo();
                _attRequest.ServiceAreasSelector = selector;
                _attRequest.FilterOptions = new InquireMarketServiceAreasRequestInfoFilterOptions();
                _attRequest.FilterOptions.LocationBasedFilters = new InquireMarketServiceAreasRequestInfoFilterOptionsLocationBasedFilters();
                _attRequest.FilterOptions.LocationBasedFilters.numberOfServiceAreas = 10;
                _attRequest.FilterOptions.LocationBasedFilters.numberOfServiceAreasSpecified = true;
                _attRequest.FilterOptions.LocationBasedFilters.restrictToLocalMarket = true;
            }
            else
            {
                _attRequest = new InquireMarketServiceAreasRequestInfo();
                _attRequest.requestType = InquireMarketServiceAreasRequestInfoRequestType.Portin;
                _attRequest.ServiceAreasSelector = new InquireMarketServiceAreasRequestInfoServiceAreasSelector();
                InquireMarketServiceAreasRequestInfoServiceAreasSelectorSelectorsWithMarketType selector = new InquireMarketServiceAreasRequestInfoServiceAreasSelectorSelectorsWithMarketType();

                NpaNxxLineInfo npaNxxLineInfo = new NpaNxxLineInfo();
                npaNxxLineInfo.npa = selectInfo.Substring(0, 3);
                npaNxxLineInfo.nxx = selectInfo.Substring(3, 3);
                npaNxxLineInfo.line = selectInfo.Substring(6, 4);
                selector.marketType = MarketTypeInfo.Both;
                selector.Item = npaNxxLineInfo;
                _attRequest.ServiceAreasSelector.Item = selector;

            }

            try
            {
                _attResponse = _attService.InquireMarketServiceAreas(_attRequest);

                if (_attResponse.Response.code == "0")
                {
                    _npaList = new List<NpaInfo>();
                    foreach (ServiceAreaLookupInfo serviceArea in _attResponse.ServiceAreas)
                    {
                        NpaInfo npaItem = new NpaInfo();
                        npaItem.Description = serviceArea.serviceAreaDescription;
                        if (serviceArea.Location != null && serviceArea.Location.Length > 0 && serviceArea.Location[0].market != null)
                        {
                            npaItem.MarketCode = serviceArea.Location[0].market.billingMarket;
                        }
                        if (serviceArea.NumberBlock != null && serviceArea.NumberBlock.Length > 0)
                        {
                            npaItem.Npa = serviceArea.NumberBlock[0].npa;
                            npaItem.NpaNxx = serviceArea.NumberBlock[0].nxx;
                            _npaList.Add(npaItem);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                this.LogResponse(ex.Message, "EXCEPTION-" + requestType);
            }

        }

        public string GetServiceArea(string npa)
        {
            try
            {
                string testServiceArea;
                testServiceArea = GetAppSetting("TestServiceArea");
                return testServiceArea;
            }
            catch
            {
                // should not exist unless testing
            }
            if (_attResponse != null && _attResponse.ServiceAreas != null)
            {
                foreach (ServiceAreaLookupInfo sa in _attResponse.ServiceAreas)
                {
                    if (sa.NumberBlock != null)
                    {
                        foreach (NpaNxxLineInfo npaInfo in sa.NumberBlock)
                        {
                            if (npaInfo.npa == npa)
                            {
                                if (sa.Location != null && sa.Location.Length > 0)
                                {
                                    return sa.Location[0].serviceAreaCode;
                                }
                            }
                        }
                    }
                }
            }
            throw new KeyNotFoundException("Npa not found");
        }

        public InquireMarketServiceAreasResponseInfo Response
        {
            get
            {
                return _attResponse;
            }
        }

        public bool HasErrors()
        {
            return (_attResponse != null && _attResponse.Response != null && _attResponse.Response.code != "0");
        }

        public List<NpaInfo> NpaList
        {
            get
            {
                return _npaList;
            }
        }

        private void Log()
        {
            this.LogRequest(_attRequest, requestType);
            this.LogResponse(_attResponse, requestType);
        }
    }
}