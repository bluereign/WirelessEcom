using System;
using System.Collections.Generic;
using System.Configuration;
using System.Xml;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SprintCarrierServiceInterface;
using SprintCarrierServiceInterface.Utils;
using WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;
using WirelessAdvocates.Common;
using REQUEST = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;

namespace TestProject
{
    [TestClass]
    public class CustomerLookupTest
    {
        [TestMethod]
        public void CustomerLookup_ValidPayload_Test()
        {
            ovm o = new ovm();
            o.ovmheader = new RequestMessageHeader();
            o.ovmheader.pin = ConfigurationManager.AppSettings["Vendor-PIN"];
            o.ovmheader.vendorcode = ConfigurationManager.AppSettings["Vendor-Code"];
            o.ovmheader.messagetype = RequestMessageType.ACCOUNT_VALIDATION_REQUEST;
            o.ovmheader.timestamp = DateTime.Parse("2008-11-25T00:00:00");

            o.ovmrequest = new ovmOvmrequest();
            AccountValidationRequest theRequest = new AccountValidationRequest();
            theRequest.Item = "";
            theRequest.singlesubscriber = true;
            theRequest.singlesubscriberSpecified = true;
            theRequest.secpin = "9119";
            theRequest.billingzip = "98118";
            theRequest.ItemElementName = ItemChoiceType.referenceptn;
            o.ovmrequest.Item = theRequest;
            o.ovmrequest.ItemElementName = ItemChoiceType13.accountvalidationrequest;

            var uri = ConfigurationManager.AppSettings["Service-URL"];

            string xml = XmlHelper.GenerateXML(o);

            var result = RestHelper.SubmitRequest(xml, uri);
            Assert.IsNotNull(result);
        }

        [TestMethod]
        public void CustomerLookup_HappyPath_Test()
        {
            var orderId = Guid.NewGuid().ToString().Substring(0, 10);
            var svc = new SprintService();
            var result = svc.CustomerLookupByMDN("8643563354", "123456", orderId);
            Assert.IsNotNull(result);
            Assert.IsNotNull(result.ErrorCode == 0);
        }

        [TestMethod]
        public void CustomerLookup_Mdn_Empty_Test()
        {
            var orderId = Guid.NewGuid().ToString().Substring(0, 10);
            var svc = new SprintService();
            var result = svc.CustomerLookupByMDN("", "123456", orderId);
            Assert.IsNotNull(result.ErrorCode == 1);
        }

        [TestMethod]
        public void CustomerLookup_Mdn_TooLong_Test()
        {
            var orderId = Guid.NewGuid().ToString().Substring(0, 10);
            var svc = new SprintService();
            var result = svc.CustomerLookupByMDN("12345678901112", "123456", orderId);
            Assert.IsNotNull(result.ErrorCode == 1);
        }

        [TestMethod]
        public void CustomerLookup_Mdn_TooShort_Test()
        {
            var orderId = Guid.NewGuid().ToString().Substring(0, 10);
            var svc = new SprintService();
            var result = svc.CustomerLookupByMDN("12345", "123456", orderId);
            Assert.IsNotNull(result.ErrorCode == 1);
        }

        [TestMethod]
        public void CustomerLookup_SecretKey_Missing_Test()
        {
            var orderId = Guid.NewGuid().ToString().Substring(0, 10);
            var svc = new SprintService();
            var result = svc.CustomerLookupByMDN("2144172474", "", orderId);
            Assert.IsNotNull(result.ErrorCode == 1);
        }

        [TestMethod]
        public void CustomerLookup_SecretKey_NonNumeric_Test()
        {
            var orderId = Guid.NewGuid().ToString().Substring(0, 10);
            var svc = new SprintService();
            var result = svc.CustomerLookupByMDN("2144172474", "abc", orderId);
            Assert.IsNotNull(result.ErrorCode == 1);
        }

        [TestMethod]
        public void CustomerLookup_SecretKey_TooShort_Test()
        {
            var orderId = Guid.NewGuid().ToString().Substring(0, 10);
            var svc = new SprintService();
            var result = svc.CustomerLookupByMDN("2144172474", "12", orderId);
            Assert.IsNotNull(result.ErrorCode == 1);
        }

        [TestMethod]
        public void CustomerLookup_SecretKey_TooLong_Test()
        {
            var orderId = Guid.NewGuid().ToString().Substring(0, 10);
            var svc = new SprintService();
            var result = svc.CustomerLookupByMDN("2144172474", "01234567891012", orderId);
            Assert.IsNotNull(result.ErrorCode == 1);
        }

        [TestMethod]
        public void CustomerLookup_SecretKey_Incorrect_Test()
        {
            var orderId = Guid.NewGuid().ToString().Substring(0, 10);
            var svc = new SprintService();
            var result = svc.CustomerLookupByMDN("2144172474", "222212345", orderId);
            Assert.IsNotNull(result.ErrorCode == 1);
        }

        [TestMethod]
        public void CustomerLookup_RefNo_Empty_Test()
        {
            //var orderId = Guid.NewGuid().ToString().Substring(0, 10);
            var orderId = string.Empty;
            var svc = new SprintService();
            var result = svc.CustomerLookupByMDN("2144172474", "123456", orderId);
            Assert.IsNotNull(result.ErrorCode == 1);
        }

        [TestMethod]
        public void CustomerLookup_RefNo_Toolong_Test()
        {
            var orderId = Guid.NewGuid().ToString().Substring(0, 25);
            var svc = new SprintService();
            var result = svc.CustomerLookupByMDN("2144172474", "123456", orderId);
            Assert.IsNotNull(result.ErrorCode == 1);
        }
    }
}
