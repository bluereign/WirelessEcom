using System;
using System.Collections.Generic;
using System.Configuration;
using System.Xml;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SprintCarrierServiceInterface;
using SprintCarrierServiceInterface.Utils;
using WirelessAdvocates.Common;
using REQUEST = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;
using WirelessAdvocates.SalesOrder;
using IMPL = SprintCarrierServiceInterface.ServiceImplementation;

namespace TestProject
{
    [TestClass]
    public class ActivationTest
    {
        [TestMethod]
        public void Activation_Serialization_WirelessOrder_Test()
        {
            WirelessOrder order = new WirelessOrder(430);
            Assert.IsNotNull(order);

            var lines = order.WirelessLines;
            Assert.IsNotNull(lines);

            var xml = XmlHelper.GenerateXML(order);
            Assert.IsNotNull(xml);
        }

        [TestMethod]
        public void Activation_Serialization_ActivationRequest_Test()
        {
            var ovm = OvmSetup("430");

            IMPL.ActivationImpl imp = new IMPL.ActivationImpl();
            var req = new IMPL.WAActivationRequest("430");
            req.ActivationType = 'N';
            imp.MapRequest(req, ref ovm);

            var activationRequest = ovm.ovmrequest.Item as REQUEST.ActivationRequest;
            Assert.IsNotNull(activationRequest);

            var xml = XmlHelper.GenerateXML(ovm);
            Assert.IsNotNull(xml);
        }

        [TestMethod]
        public void Activation_Serialization_ActivationRequestOrder_Test()
        {
            var ovm = OvmSetup("430");

            IMPL.ActivationImpl imp = new IMPL.ActivationImpl();
            var req = new IMPL.WAActivationRequest("430");
            req.ActivationType = 'N';
            imp.MapRequest(req, ref ovm);

            var activationRequest = ovm.ovmrequest.Item as REQUEST.ActivationRequest;
            Assert.IsNotNull(activationRequest);

            var order = activationRequest.order;
            Assert.IsNotNull(order);
            Assert.IsNotNull(order.type);
            Assert.IsNotNull(activationRequest.orderdate);
            Assert.IsTrue(activationRequest.orderdateSpecified);

            var xml = XmlHelper.GenerateXML(ovm);
            Assert.IsNotNull(xml);
        }

        [TestMethod]
        public void Activation_Serialization_ActivationRequestShipping_Test()
        {
            var ovm = OvmSetup("430");

            IMPL.ActivationImpl imp = new IMPL.ActivationImpl();
            var req = new IMPL.WAActivationRequest("430");
            req.ActivationType = 'N';
            imp.MapRequest(req, ref ovm);

            var activationRequest = ovm.ovmrequest.Item as REQUEST.ActivationRequest;
            Assert.IsNotNull(activationRequest);

            var shipping = activationRequest.shipping;
            Assert.IsNotNull(shipping);
            Assert.IsNotNull(shipping.name);
            Assert.IsNotNull(shipping.name.firstname);
            Assert.IsNotNull(shipping.name.lastname);
            Assert.IsNotNull(shipping.address);
            Assert.IsNotNull(shipping.address.Items);
            Assert.IsTrue(shipping.address.Items.Length > 0);
            Assert.IsNotNull(shipping.address.ItemsElementName);
            Assert.IsTrue(shipping.address.ItemsElementName.Length > 0);
            Assert.IsNotNull(shipping.homephone);
            Assert.IsNotNull(shipping.workphone);
            Assert.IsNotNull(shipping.workphone.Value);

            var xml = XmlHelper.GenerateXML(ovm);
            Assert.IsNotNull(xml);
        }

        [TestMethod]
        public void Activation_Serialization_ActivationRequestDepositPayment_Test()
        {
            var ovm = OvmSetup("430");

            IMPL.ActivationImpl imp = new IMPL.ActivationImpl();
            var req = new IMPL.WAActivationRequest("430");
            req.ActivationType = 'N';
            imp.MapRequest(req, ref ovm);

            var activationRequest = ovm.ovmrequest.Item as REQUEST.ActivationRequest;
            Assert.IsNotNull(activationRequest);

            var depositPayment = activationRequest.depositpayment;
            Assert.IsNotNull(depositPayment);
            Assert.IsNotNull(depositPayment.Items);
            Assert.IsTrue(depositPayment.Items.Length == 5);

            var xml = XmlHelper.GenerateXML(ovm);
            Assert.IsNotNull(xml);
        }

        [TestMethod]
        public void Activation_Serialization_ActivationRequestEquipmentPayment_Test()
        {
            var ovm = OvmSetup("430");

            IMPL.ActivationImpl imp = new IMPL.ActivationImpl();
            var req = new IMPL.WAActivationRequest("430");
            req.ActivationType = 'N';
            imp.MapRequest(req, ref ovm);

            var activationRequest = ovm.ovmrequest.Item as REQUEST.ActivationRequest;
            Assert.IsNotNull(activationRequest);

            var equipmentPayment = activationRequest.equipmentpayment;
            var equipmentPaymentType = activationRequest.equipmentpaymenttype;
            Assert.IsNotNull(equipmentPayment);
            Assert.IsNotNull(equipmentPayment.Items);
            Assert.IsTrue(equipmentPayment.Items.Length > 0);
            Assert.IsNotNull(equipmentPaymentType);

            var xml = XmlHelper.GenerateXML(ovm);
            Assert.IsNotNull(xml);
        }

        [TestMethod]
        public void Activation_Serialization_ActivationRequestRccpPayment_Test()
        {
            var ovm = OvmSetup("430");

            IMPL.ActivationImpl imp = new IMPL.ActivationImpl();
            var req = new IMPL.WAActivationRequest("430");
            req.ActivationType = 'N';
            imp.MapRequest(req, ref ovm);

            var activationRequest = ovm.ovmrequest.Item as REQUEST.ActivationRequest;
            Assert.IsNotNull(activationRequest);

            var rccpPayments = activationRequest.rccppayment;
            Assert.IsNotNull(rccpPayments);
            Assert.IsNotNull(rccpPayments.Items);
            Assert.IsTrue(rccpPayments.Items.Length > 0);

            var xml = XmlHelper.GenerateXML(ovm);
            Assert.IsNotNull(xml);
        }

        [TestMethod]
        public void Activation_Serialization_ActivationRequestService_Test()
        {
            var ovm = OvmSetup("430");

            IMPL.ActivationImpl imp = new IMPL.ActivationImpl();
            var req = new IMPL.WAActivationRequest("430");
            req.ActivationType = 'N';
            imp.MapRequest(req, ref ovm);

            var activationRequest = ovm.ovmrequest.Item as REQUEST.ActivationRequest;
            Assert.IsNotNull(activationRequest);

            var service = activationRequest.service;
            Assert.IsNotNull(service);
            Assert.IsNotNull(service.Items);
            Assert.IsTrue(service.Items.Length > 0);

            var xml = XmlHelper.GenerateXML(ovm);
            Assert.IsNotNull(xml);
        }

        [TestMethod]
        public void Activation_Serialization_ActivationRequestOrderShipping_Test()
        {
            var ovm = OvmSetup("430");

            IMPL.ActivationImpl imp = new IMPL.ActivationImpl();
            var req = new IMPL.WAActivationRequest("430");
            req.ActivationType = 'N';                 
            imp.MapRequest(req, ref ovm);

            var activationRequest = ovm.ovmrequest.Item as REQUEST.ActivationRequest;
            Assert.IsNotNull(activationRequest);

            var orderShipping = activationRequest.ordershipping;
            Assert.IsNotNull(orderShipping);
            Assert.IsNotNull(orderShipping.method);
            Assert.IsNotNull(orderShipping.vendor);

            var xml = XmlHelper.GenerateXML(ovm);
            Assert.IsNotNull(xml);
        }


        [TestMethod]
        public void Activation_SubmitOrder_New_Test()
        {
            string refNumber = "1308180906384";
            string orderId = "19034";
            //string orderId = "325";
            var svc = new SprintService();

            // validation address
            WirelessAdvocates.Address address = new WirelessAdvocates.Address();
            address.AddressLine1 = "5628 Airport Way S.";
            address.AddressLine2 = "Suite 110";
            address.City = "Seattle";
            address.State = "WA";
            address.ZipCode = "98108";
            //var result = svc.ValidateAddress(address, WirelessAdvocates.Address.AddressType.Billing, orderId);

            // credit check
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Test", LastName = "Tester" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "101480662", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };
            //var creditCheckResp = svc.CheckCredit(name, "98108", contact, personal, 1, refNumber);

            // activaiton
            var activationResp = svc.SubmitOrder(orderId);
            Assert.IsNotNull(activationResp);
            Assert.IsTrue(activationResp.ErrorCode == 0);
        }

        [TestMethod]
        public void Activation_SubmitOrder_RetrieveOrderFormDb_Test()
        {
            SprintService svc = new SprintService();
            //var result = svc.SubmitOrder("19230"); // single-line with multiple service options
            //Assert.IsNotNull(result);
            var result2 = svc.SubmitOrder("19233"); // single-line with multiple service options
            Assert.IsNotNull(result2);

        }

        #region Private

        private REQUEST.ovm OvmSetup(string orderId)
        {
            var sprintRequest = new REQUEST.ovm();
            sprintRequest.ovmheader = new REQUEST.RequestMessageHeader();
            sprintRequest.ovmheader.pin = ConfigurationManager.AppSettings["Vendor-PIN"];
            sprintRequest.ovmheader.vendorcode = ConfigurationManager.AppSettings["Vendor-Code"];
            sprintRequest.ovmheader.brandtype = REQUEST.BrandType.SP;
            sprintRequest.ovmheader.timestamp = DateTime.Now;
            sprintRequest.ovmrequest = new REQUEST.ovmOvmrequest();
            sprintRequest.ovmheader.orderid = orderId;
            return sprintRequest;
        }

        #endregion

    }
}
