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
    public class CustomerLookup : AttServiceBase
    {

        public enum SelectionMethod
        {
            Ban,
            MDN
        }

        const string ObjectName = "CustomerLookup";

        InquireAccountProfileSoapHttpBinding _attService = new InquireAccountProfileSoapHttpBinding();
        InquireAccountProfileRequestInfo _attRequest = new InquireAccountProfileRequestInfo();
        InquireAccountProfileResponseInfo _attResponse = null;
        InquireSubscriberProfileResponseInfo _mostRecentSubscriber = null;

        WirelessOrder _order;
        WirelessLine _line;
        string _ban = null;
        List<OfferingsAdditionalInfo> _additionalOfferings;

        public CustomerLookup(object selectInfo, string pin, string serviceZip, string billingZip, SelectionMethod method, string referenceNumber) //WirelessOrder wirelessOrder, WirelessLine line, string referenceNumber)
        {


            this.ReferenceNumber = referenceNumber;

            _attService.Url = GetUrl("InquireAccountProfileEndpoint");
            _attService.MessageHeader = GetMessageHeader(this.ReferenceNumber);
            AddCerts(_attService.ClientCertificates);

            _attRequest.AccountSelector = new AccountSelectorInfo();


            switch (method)
            {
                case SelectionMethod.MDN:
                    _attRequest.AccountSelector.Items = new object[1];
                    _attRequest.AccountSelector.Items[0] = selectInfo;
                    _attRequest.AccountSelector.ItemsElementName = new ItemsChoiceType2[1];
                    _attRequest.AccountSelector.ItemsElementName[0] = new ItemsChoiceType2();
                    _attRequest.AccountSelector.ItemsElementName[0] = ItemsChoiceType2.subscriberNumber;
                    break;
                case SelectionMethod.Ban:
                    _attRequest.AccountSelector.Items = new object[2];

                    MarketAndZipServiceInfo market = new MarketAndZipServiceInfo();
                    market.ItemsElementName = new ItemsChoiceType[1];
                    market.ItemsElementName[0] = ItemsChoiceType.serviceZipCode;
                    market.Items = new string[1];
                    market.Items[0] = serviceZip;

                    _attRequest.AccountSelector.Items[0] = market;
                    _attRequest.AccountSelector.Items[1] = selectInfo;

                   // this.LogException("selectInfo", selectInfo.ToString());

                    _attRequest.AccountSelector.ItemsElementName = new ItemsChoiceType2[2];
                    _attRequest.AccountSelector.ItemsElementName[0] = ItemsChoiceType2.MarketServiceInfo;
                    _attRequest.AccountSelector.ItemsElementName[1] = ItemsChoiceType2.billingAccountNumber;
                    break;
                default:
                    throw new Exception("Invalid selection method");
            }


            _attRequest.AccountVerification = new AccountVerificationInfo();
            _attRequest.AccountVerification.billingZipCode = billingZip;
            _attRequest.AccountVerification.last4SSN = pin;


            _attRequest.UpgradeEligibilityCriteria = new SecureUpgradeEligibilityInfo();
            _attRequest.UpgradeEligibilityCriteria.newSalesChannel = GetAppSetting("NewSalesChannel");
            _attRequest.mask = GetAppSetting("IAPMask");

            try
            {
                this.LogRequest(_attRequest, ObjectName);
                _attResponse = _attService.InquireAccountProfile(_attRequest);
                this.LogResponse(_attResponse, ObjectName);
                CaptureConversationId(_attService.MessageHeader.TrackingMessageHeader.conversationId, this.ReferenceNumber);
            }
            catch (SoapException se)
            {
                WirelessAdvocates.Logger.new Log().LogException(se.Message, "Att", "CustomerLookup", this.ReferenceNumber);
                throw;
            }
            catch (Exception ex)
            {
                WirelessAdvocates.Logger.new Log().LogException(ex.Message, "Att", "CustomerLookupByMdn", this.ReferenceNumber);
                throw;
            }
        }

        public string Ban
        {
            get
            {
                if (_ban == null && _attResponse != null && _attResponse.Account != null)
                {
                    _ban = _attResponse.Account.billingAccountNumber;
                }
                return _ban;
            }
        }

        public InquireAccountProfileResponseInfo AccountProfile
        {
            get
            {
                return _attResponse;
            }
        }

        public string PrimaryMdn
        {
            get
            {
                return _attResponse.Account.primaryAccountHolder;
            }
        }

        public bool IsFamily(string mdn)
        {
            InquireSubscriberProfileResponseInfo subscriber = this.GetSubscriberInfo(mdn);
            if (subscriber != null)
            {
                try
                {
                    PricePlanGroupDetailsInfo groupInfo = (PricePlanGroupDetailsInfo)subscriber.Subscriber.PricePlan.Item;
                    return true;
                }
                catch
                {
                    return false;
                }

            }
            return false;
        }

        public string GetFamilyPlanCode()
        {
            string code = null;
            foreach (InquireSubscriberProfileResponseInfo subscriberInfo in _attResponse.Account.Subscriber)
            {
                if (subscriberInfo.Subscriber != null && subscriberInfo.Subscriber.PricePlan != null)
                {
                    try
                    {
                        PricePlanGroupDetailsInfo groupInfo = (PricePlanGroupDetailsInfo)subscriberInfo.Subscriber.PricePlan.Item;
                        if (groupInfo.primarySubscriber)
                        {
                            code = groupInfo.groupPlanCode;
                            break;
                        }
                    }
                    catch
                    {
                    }
                }
            }
            return code;
        }

        private InquireSubscriberProfileResponseInfo GetSubscriberInfo(string mdn)
        {
            if (_mostRecentSubscriber != null && _mostRecentSubscriber.Subscriber.subscriberNumber == mdn)
            {
                return _mostRecentSubscriber;
            }
            _mostRecentSubscriber = null;

            foreach (InquireSubscriberProfileResponseInfo subscriberInfo in _attResponse.Account.Subscriber)
            {
                if (subscriberInfo.Subscriber != null && subscriberInfo.Subscriber.subscriberNumber == mdn)
                {
                    _mostRecentSubscriber = subscriberInfo;
                }
            }
            return _mostRecentSubscriber;
        }

        public string GetRatePlan(string mdn)
        {
            InquireSubscriberProfileResponseInfo subscriberInfo = this.GetSubscriberInfo(mdn);

            string rateplan = null;

            if (subscriberInfo != null && subscriberInfo.Subscriber != null && subscriberInfo.Subscriber.PricePlan != null && subscriberInfo.Subscriber.PricePlan.Item != null)
            {
                if (subscriberInfo.Subscriber.PricePlan.Item.GetType() == typeof(string))
                {
                    rateplan = (string)subscriberInfo.Subscriber.PricePlan.Item;
                }
                else
                {
                    PricePlanGroupDetailsInfo group = (PricePlanGroupDetailsInfo)subscriberInfo.Subscriber.PricePlan.Item;
                    rateplan = group.groupPlanCode;
                }
            }

            return rateplan;
        }
    }
}

