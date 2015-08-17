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
    class InquireUpgradeEligibility : AttServiceBase
    {
        private InquireUpgradeEligibilityResponseInfo _inquireUpgradeEligibility;
        private InquireUpgradeEligibilityRequestInfo _attRequest = new InquireUpgradeEligibilityRequestInfo();
        private InquireUpgradeEligibilitySoapHttpBinding _attService = new InquireUpgradeEligibilitySoapHttpBinding();

        public InquireUpgradeEligibility(string mdn, string referenceNumber)
        {

            _attService.Url = GetUrl("InquireUpgradeEligibilityEndpoint");
            _attService.MessageHeader = GetMessageHeader(referenceNumber);
            AddCerts(_attService.ClientCertificates);

            _attRequest.subscriberNumber = mdn;
            _attRequest.UpgradeEligibility = new SecureUpgradeEligibilityInfo();
            _attRequest.UpgradeEligibility.dealerCode = new DealerInfo();
            _attRequest.UpgradeEligibility.dealerCode.code = GetAppSetting("DealerCode");
            _attRequest.UpgradeEligibility.newSalesChannel = GetAppSetting("NewSalesChannel");
            try
            {
                WirelessAdvocates.Logger.new Log().LogRequest(WirelessAdvocates.new Utility().SerializeXML(_attRequest), "Att", "InquireUpgradeEligibility", referenceNumber);
                _inquireUpgradeEligibility = _attService.InquireUpgradeEligibility(_attRequest);
                WirelessAdvocates.Logger.new Log().LogResponse(WirelessAdvocates.new Utility().SerializeXML(_inquireUpgradeEligibility), "Att", "InquireUpgradeEligibility", referenceNumber);
            }
            catch (SoapException soapEx)
            {
                WirelessAdvocates.Logger.new Log().LogException(WirelessAdvocates.new Utility().SerializeXML(soapEx.Detail), "Att", "InquireUpgradeEligibility", referenceNumber);
                _inquireUpgradeEligibility = null;
                throw;
            }
            catch (Exception ex)
            {
                WirelessAdvocates.Logger.new Log().LogException(ex.Message, "Att", "InquireUpgradeEligibility", referenceNumber);
                _inquireUpgradeEligibility = null;
                throw;
            }
        }

        public bool IsUpgradeEligible
        {
            get
            {
                if (_inquireUpgradeEligibility != null && _inquireUpgradeEligibility.Eligibility != null)
                {
                    return (_inquireUpgradeEligibility.Eligibility.eligibilityStatus == UpgradeEligibilityStatusInfo.A);
                }
                return false;
            }
        }

        public UpgradeEligibilityStatusInfo EligiblityStatus
        {
            get
            {
                return (_inquireUpgradeEligibility.Eligibility.eligibilityStatus);
            }
        }


        public string ApprovalNumber
        {
            get
            {
                if (_inquireUpgradeEligibility != null && _inquireUpgradeEligibility.Eligibility != null)
                {
                    return _inquireUpgradeEligibility.Eligibility.approvalNumber;
                }
                else
                {
                    return null;
                }
            }
        }

        public InquireUpgradeEligibilityResponseInfo UpgradeEligibilityInfo()
        {
            return _inquireUpgradeEligibility;
        }

    }
}