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
    /// <summary>
    /// TODO: Generally these are stubbed out and not entirely finished.
    /// </summary>
    [TestClass]
    public class CreditRequestTest
    {
        #region Helpers
        /// <summary>
        /// Useful to reduce repetative code
        /// </summary>
        /// <returns></returns>
        public BillingInfoType CreateBillingName() 
        {
            BillingInfoType billingIT = new BillingInfoType();
            REQUEST.Name name = new REQUEST.Name();
            name.firstname = "Test";
            name.lastname = "Tester";
            billingIT.name = name;

            Address ad = new Address();
            object[] ob = new object[4];
            ob[0] = "100 First Ave NE";
            ob[1] = "Seattle";
            ob[2] = "WA";
            ob[3] = "98201";
            ad.Items = ob;
            ItemsChoiceType1[] obn = new ItemsChoiceType1[4];
            obn[0] = ItemsChoiceType1.streetaddress1;
            obn[1] = ItemsChoiceType1.city;
            obn[2] = ItemsChoiceType1.statecode;
            obn[3] = ItemsChoiceType1.zipcode;
            ad.ItemsElementName = obn;

            billingIT.address = ad;
            billingIT.homephone = "2065551212";

            return billingIT;
        }
        #endregion

        #region CreditRequest_ValidPayload_Test
        [TestMethod]
        public void CreditRequest_ValidPayload_Test()
        {
            ovm o = new ovm();
            o.ovmheader = new RequestMessageHeader();
            o.ovmheader.pin = ConfigurationManager.AppSettings["Vendor-PIN"];
            o.ovmheader.vendorcode = ConfigurationManager.AppSettings["Vendor-Code"];
            o.ovmheader.messagetype = RequestMessageType.CREDIT_CHECK_REQUEST;
            o.ovmheader.timestamp = DateTime.Parse("2008-11-25T00:00:00");
            //--added to complete the header section
            o.ovmheader.orderid = Guid.NewGuid().ToString().Substring(1, 20);
            o.ovmheader.returnurl = "http://nolrtb2.sprint.com:39000/ovm/TestXMLReceiver";
            o.ovmheader.brandtype = BrandType.SP;
            //--

            o.ovmrequest = new ovmOvmrequest();
            CreditRequest creditrequest = new CreditRequest();
            //-- everything in this section is faked
            OrderInfoType orderIT = new OrderInfoType();
            orderIT.type = OrderType.NEW;
            creditrequest.order = orderIT;  
            creditrequest.subscriberagreement = true;  
            creditrequest.customertype = CustomerType.INDIVIDUAL; 
            creditrequest.secpin = "762538";           
            creditrequest.secquestioncode = "cd3";     
            creditrequest.secanswer = "Test";
            //--
            creditrequest.handsetcount = 2;

            BillingInfoType billingIT = new BillingInfoType();
            REQUEST.Name name = new REQUEST.Name();
            name.firstname = "Test";
            name.lastname = "Tester";
            billingIT.name = name;

            // not yet
            //creditrequest.billing = billingIT;
            //-- todo: how do we integrate extendedAddress?
            //WA.ExtendedAddress extendedAddress = new WA.ExtendedAddress();
            //extendedAddress.AddressLine1 = "100 First Ave NE";      
            //extendedAddress.City = "Seattle";
            //extendedAddress.State = "WA";
            //extendedAddress.ZipCode = "98201";

            Address ad = new Address();
            object[] ob = new object[4];
            ob[0] = "100 First Ave NE";
            ob[1] = "Seattle";
            ob[2] = "WA";
            ob[3] = "98201";
            ad.Items = ob;
            ItemsChoiceType1[] obn = new ItemsChoiceType1[4];
            obn[0] = ItemsChoiceType1.streetaddress1;
            obn[1] = ItemsChoiceType1.city;
            obn[2] = ItemsChoiceType1.statecode;
            obn[3] = ItemsChoiceType1.zipcode;
            ad.ItemsElementName = obn;

            billingIT.address = ad;
            //--
            billingIT.homephone = "2065551212";

            creditrequest.activationzipcode = "98201";
            creditrequest.Item = "123456789";
            creditrequest.ItemElementName = ItemChoiceType5.ssn;

            DriversLicense dl = new DriversLicense();
            dl.id = "112233445566";
            dl.state = "WA";
            dl.expirationdate = DateTime.Parse("2010-01-01");
            creditrequest.dateofbirth = DateTime.Parse("1981-01-27");

            
            creditrequest.driverslicense = dl;
            creditrequest.billing = billingIT;

            o.ovmrequest.Item = creditrequest;
            o.ovmrequest.ItemElementName = ItemChoiceType13.creditrequest;

            var uri = ConfigurationManager.AppSettings["Service-URL"];

            string xml = XmlHelper.GenerateXML(o);

            var result = RestHelper.SubmitRequest(xml, uri);
            
            Assert.IsNotNull(result);


        }
        #endregion

        #region CreditRequest_ServiceApiFailed_Test
        // ToDo: How do we test for this condition?
        [TestMethod]
        public void CreditRequest_ServiceApiFailed_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "00000", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ErrorCode == (int)ServiceResponseCode.Failure);
        }
        #endregion

        #region CreditRequest_CCApproved_Test                   == CC_CREDIT_APPROVED   passed.
        // ToDo: This should be golden however it's not in the TEST DATA; this does pass!
        [TestMethod]
        public void CreditRequest_CCApproved_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Test", LastName = "Tester" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "848800811", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            //string nameXml = XmlHelper.GenerateXML(name);
            //string contactXml = XmlHelper.GenerateXML(contact);
            //string personalXml = XmlHelper.GenerateXML(personal);

            var orderId = "TESTCO100";

            //var i = nameXml;
            //var j = contactXml;
            //var k = personalXml;

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, orderId);

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_CREDIT_APPROVED);
        }
        #endregion

        #region CreditRequest_CREDIT_DECLINED_Test              == CC_CREDIT_DECLINED
        // ToDo: What conditions would cause this to fail w/o triggering another type of error?
        // Note: Cannot repro a decline with the Test Data provided; all the SSNs pass CC.
        /// <summary>
        /// 1. Declined & Ineligable
        /// 2. Attempt to get score failed
        /// 3. Delinquent/defaulted
        /// 4. Exceeded authorized units
        /// 5. Credit score rejected
        /// </summary>
        [TestMethod]
        public void CreditRequest_CREDIT_DECLINED_Test()
        {
            //build the required attributes.
            var svc = new SprintService();
            //var badSSN = "123456789";
            var badSSN = "712358064"; 

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Test", LastName = "Tester" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = badSSN, DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };


            //string nameXml = XmlHelper.GenerateXML(name);
            //string contactXml = XmlHelper.GenerateXML(contact);
            //string personalXml = XmlHelper.GenerateXML(personal);

            var orderId = Guid.NewGuid().ToString().Substring(0, 10);
            //var orderId = "TESTCO1";

            //var i = nameXml;
            //var j = contactXml;
            //var k = personalXml;

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, orderId);

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_CREDIT_DECLINED);
        }
        #endregion

        #region CreditRequest_CREDIT_CHECK_IN_PROCESS_Test      == CC_STATUS_UNKNOWN
        // ToDo: What are the conditions to produce this error?
        [TestMethod]
        public void CreditRequest_CREDIT_CHECK_IN_PROCESS_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_STATUS_UNKNOWN);
        }
        #endregion

        #region CreditRequest_INVALID_SSN_Test      passed.
        /// <summary>
        /// CREATED INVALID SSN
        /// 1. Invalid *** V0
        /// 2. Missing *** V1
        /// 3. Federal ID used instead of SSN; need SSN.
        /// 4. Tax ID required; likely a corporate application.
        /// </summary>
        [TestMethod]
        public void CreditRequest_INVALID_SSN_Test_V0()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        [TestMethod]
        public void CreditRequest_INVALID_SSN_Test_V1()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "10779185A", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_INVALID_TAX_ID_Test
        /// <summary>
        /// TODO: Two subtests...
        /// 1. Federal Tax ID Invalid
        /// 2. SSN used instead of Federal ID; need Federal ID.
        /// </summary>
        [TestMethod]
        public void CreditRequest_INVALID_TAX_ID_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "000000000", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_INVALID_DOB_Test
        /// <summary>
        /// TODO: Three subtests...
        /// 1. Invalid
        /// 2. Improper format; trapped at UI likely.
        /// 3. Missing; trapped at UI likely.
        /// </summary>
        [TestMethod]
        public void CreditRequest_INVALID_DOB_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2111"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_PO_BOX_ADDR_NOT_ALLOWED_Test
        /// <summary>
        /// TODO: How do we generate a bad address?
        /// 1. Cannot accept POB for CC Billing Address
        /// 2. Cannot accept POB for CC Physical Address
        /// </summary>
        [TestMethod]
        public void CreditRequest_PO_BOX_ADDR_NOT_ALLOWED_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_MISSING_ACCOUNT_NUMBER_Test
        /// <summary>
        /// TODO: How do we generate missing account number?
        /// ...however there is no differentiation in the Spreadsheet
        /// </summary>
        [TestMethod]
        public void CreditRequest_MISSING_ACCOUNT_NUMBER_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_ACCOUNT_EXISTS_FOR_SSN_Test       == CC_EXISTING_CUSTOMER
        /// <summary>
        /// TODO: CheckCredit may not be the best method to use for this test.
        /// 1. Account already exists; can't be "NEW".
        /// 2. Multiple accts exist for this SSN
        /// 3. Account already exists; other error
        /// </summary>
        [TestMethod]
        public void CreditRequest_ACCOUNT_EXISTS_FOR_SSN_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Test", LastName = "Tester" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "100092568", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            //string nameXml = XmlHelper.GenerateXML(name);
            //string contactXml = XmlHelper.GenerateXML(contact);
            //string personalXml = XmlHelper.GenerateXML(personal);

            //var orderId = Guid.NewGuid().ToString().Substring(0, 24);
            var orderId = "TESTCO3";

            //var i = nameXml;
            //var j = contactXml;
            //var k = personalXml;

            var result = svc.CheckCredit(name, "98208", contact, personal, 1, orderId);

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_EXISTING_CUSTOMER);
        }
        #endregion

        #region CreditRequest_INVALID_ACCOUNT_NUMBER_Test
        /// <summary>
        /// TODO: How do we generate an invalid account?
        /// 1. Invalid
        /// 2. Ref PTN is not OPEN BAN; can't upgrade
        /// 3. Cannot proceed; halt
        /// 4. BAN incorrect
        /// *5. Acct or Ref PTN does not match corp/biz info; this is the only test unique to CC condition
        /// 6. Acct does not exist
        /// </summary>
        [TestMethod]
        public void CreditRequest_INVALID_ACCOUNT_NUMBER_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_ACCOUNT_WITH_SSN_FAILED_Test
        /// <summary>
        /// TODO: We do not have a method for passing account and ssn together.
        /// 1. Account w/ SSN does not match.
        /// 2. Ref PTN for Acct does not match SSN 
        /// 3. Account w/ SSN does not match. (identical to #1)
        /// </summary>
        [TestMethod]
        public void CreditRequest_ACCOUNT_WITH_SSN_FAILED_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_ACCOUNT_EXISTS_FOR_TAX_ID_Test
        /// <summary>
        /// TODO: How do we generate an account for this error?
        /// 1. Account w/ Tax ID does not match.
        /// 2. Acct exists for Tax ID; should be add-on
        /// </summary>
        [TestMethod]
        public void CreditRequest_ACCOUNT_EXISTS_FOR_TAX_ID_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_ACCOUNT_WITH_TAX_ID_FAILED_Test
        /// <summary>
        /// TODO: We need a method to pass account and tax id together.
        /// 1. Account w/ Tax ID does not match.
        /// 2. Account w/ Tax ID does not match. (nearly identical to #1)
        /// </summary>
        [TestMethod]
        public void CreditRequest_ACCOUNT_WITH_TAX_ID_FAILED_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_DELINQUENT_ACCOUNT_Test           == CC_CREDIT_DECLINED
        /// <summary>
        /// TODO: All Test Case SSN numbers pass CC so we have to find another way to trigger this.
        /// 1. Delinquent, so can't add
        /// 2. Delinquent acct for SSN
        /// 3. Unpaid balance for SSN
        /// 4. Delinquent acct for SSN
        /// 5. Acct has unpaid balance
        /// 6. Acct delinquent
        /// 7. Acct has unpaid balance for SSN
        /// 8. Delinquent acct for SSN
        /// </summary>
        [TestMethod]
        public void CreditRequest_DELINQUENT_ACCOUNT_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_CREDIT_DECLINED);
        }
        #endregion

        #region CreditRequest_DELINQUENT_SCORE_Test             == CC_CREDIT_DECLINED
        /// <summary>
        /// TODO: All Test Case SSN numbers pass CC so we have to find another way to trigger this.
        /// 1. Customer associated w/ delinquent acct
        /// 2. Customer really badboy!
        /// </summary>
        [TestMethod]
        public void CreditRequest_DELINQUENT_SCORE_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_CREDIT_DECLINED);
        }
        #endregion

        #region CreditRequest_CORP_GOV_ID_REQUIRED_Test
        /// <summary>
        /// TODO: work item
        /// 1. Corp/Gov order but no ID sent
        /// 2. Corp/Gov ID reqd for add-on
        /// </summary>
        [TestMethod]
        public void CreditRequest_CORP_GOV_ID_REQUIRED_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_INVALID_CORP_GOV_ID_Test
        /// <summary>
        /// TODO: work item
        /// </summary>
        [TestMethod]
        public void CreditRequest_INVALID_CORP_GOV_ID_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_SERVICE_PO_REQUIRED_Test
        /// <summary>
        /// TODO: We do not have a method to pass Service ids yet.
        /// 1. Service PO reqd for Corp/Gov order
        /// 2. Service PO reqd for Corp/Gov IDs
        /// </summary>
        [TestMethod]
        public void CreditRequest_SERVICE_PO_REQUIRED_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_ACCOUNT_WITH_CORP_GOV_ID_FAILED_Test
        /// <summary>
        /// TODO: Need to associate Account w/ PTN.
        /// 1. Acct or PTN not assoc w/ Corp/Gov ID
        /// 2. Acct does not have Corp/Gov ID
        /// 3. Acct does not have Corp ID
        /// </summary>
        [TestMethod]
        public void CreditRequest_ACCOUNT_WITH_CORP_GOV_ID_FAILED_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_COMPANY_NAME_REQUIRED_Test
        /// <summary>
        /// TODO: Need method to pass/ref company name.
        /// 1. Comp name reqd for this type of order
        /// 2. Comp name reqd for biz order
        /// </summary>
        [TestMethod]
        public void CreditRequest_COMPANY_NAME_REQUIRED_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_CORP_GOV_ORDER_SUB_TYPE_MISMATCH_Test
        /// <summary>
        /// TODO: work item
        /// 1. Acct subtype doesn't allow these type of orders
        /// 2. Gov Biz order ID not liable
        /// 3. Corp Biz order ID not liable
        /// 4. Customer type mismatch w/ acct type on Corp ID
        /// 5. Corp Individual order ID not liable
        /// 6. Gov Individual order ID not liable
        /// </summary>
        [TestMethod]
        public void CreditRequest_CORP_GOV_ORDER_SUB_TYPE_MISMATCH_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_REF_PTN_REQUIRED_FOR_UPGRADE_Test
        /// <summary>
        /// TODO: work item
        /// </summary>
        [TestMethod]
        public void CreditRequest_REF_PTN_REQUIRED_FOR_UPGRADE_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_REF_PTN_REQUIRED_FOR_REPLACE_Test
        /// <summary>
        /// TODO: work item
        /// </summary>
        [TestMethod]
        public void CreditRequest_REF_PTN_REQUIRED_FOR_REPLACE_Test()
        {
            var svc = new SprintService();

            string refNum = Guid.NewGuid().ToString().Substring(0,20);

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, refNum);

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_ONE_HANDSET_FOR_ORDER_TYPE_Test
        /// <summary>
        /// TODO: work item
        /// </summary>
        [TestMethod]
        public void CreditRequest_ONE_HANDSET_FOR_ORDER_TYPE_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_INVALID_ORDER_TYPE_Test
        /// <summary>
        /// TODO: work item
        /// </summary>
        [TestMethod]
        public void CreditRequest_INVALID_ORDER_TYPE_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_ORDER_ID_REQUIRED_Test
        /// <summary>
        /// TODO: work item
        /// </summary>
        [TestMethod]
        public void CreditRequest_ORDER_ID_REQUIRED_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_PUBLIC_SAFETY_GOVT_NOT_SUPPORTED_Test
        /// <summary>
        /// TODO: work item
        /// </summary>
        [TestMethod]
        public void CreditRequest_PUBLIC_SAFETY_GOVT_NOT_SUPPORTED_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_TAX_EXEMPT_ID_REQUIRED_Test
        /// <summary>
        /// TODO: work item
        /// </summary>
        [TestMethod]
        public void CreditRequest_TAX_EXEMPT_ID_REQUIRED_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_EQUIPMENT_PO_REQUIRED_Test
        /// <summary>
        /// TODO: work item
        /// 1. PO reqd for this order
        /// 2. PO reqd for this corp/gov ID
        /// </summary>
        [TestMethod]
        public void CreditRequest_EQUIPMENT_PO_REQUIRED_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_DAC_REQUIRED_FOR_CORP_GOV_ID_Test
        /// <summary>
        /// TODO: work item
        /// 1. Dept Code reqd for this order
        /// 2. DAC id reqd for corp/gov id and acct id
        /// </summary>
        [TestMethod]
        public void CreditRequest_DAC_REQUIRED_FOR_CORP_GOV_ID_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_DAC_WITH_CORP_GOV_ID_FAILED_Test
        /// <summary>
        /// TODO: work item
        /// 1. Dept Code not assoc w/ corp/gov id
        /// 2. DAC id does not match w/ corp/gov id and acct id
        /// </summary>
        [TestMethod]
        public void CreditRequest_DAC_WITH_CORP_GOV_ID_FAILED_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_NODE_ID_NOT_UNDER_CORP_GOV_ID_Test
        /// <summary>
        /// TODO: work item
        /// 1. Node ID does not match corp/gov id
        /// 2. Node ID does not match w/ corp/gov id and acct id
        /// </summary>
        [TestMethod]
        public void CreditRequest_NODE_ID_NOT_UNDER_CORP_GOV_ID_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_SUSPENDED_ACCOUNT_NUMBER_Test
        /// <summary>
        /// TODO: work item
        /// 1. Acct num provided is clsoed or sus
        /// 2. Acct is sus
        /// 3. Customer PTN is not OPEN BAN; can't upgrade
        /// 4. Sus acct exists for Tax ID
        /// 5. Sus acct exists for SSN
        /// 6. Sus acct exists for SSN
        /// </summary>
        [TestMethod]
        public void CreditRequest_SUSPENDED_ACCOUNT_NUMBER_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_HOME_PHONE_REQUIRED_Test
        /// <summary>
        /// TODO: Just needs testing.
        /// 1. HP reqd for Individual customer types
        /// 2. Work phone reqd for this customer type
        /// </summary>
        [TestMethod]
        public void CreditRequest_HOME_PHONE_REQUIRED_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "", WorkPhone = "" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_PREVIOUS_FRAUDULENT_ACTIVITY_Test         passed.
        /// <summary>
        /// Made this test work by passing an SSN of "123456789"
        /// 1. Prev fraud activity on BAN/Corp ID
        /// 2. Can't retreive customer info due to prev fraud activity
        /// </summary>
        [TestMethod]
        public void CreditRequest_PREVIOUS_FRAUDULENT_ACTIVITY_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "123456789", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_CANNOT_REOPEN_CANCELLED_BAN_Test  == CC_RECENT_CANCEL
        /// <summary>
        /// TODO: work item
        /// 1. Cancelled acct cannot be reopened
        /// 2. Customer PTN is on cancelled BAN & cannot be reopened
        /// 3. Acct is cancelled BAN & cannot be reopened
        /// 4. Cancelled BAN for Tax ID & cannot be reopened
        /// 5. Cancelled BAN for SSN & cannot be reopened
        /// 6. Cancelled BAN for SSN & cannot be reopened V2
        /// </summary>
        [TestMethod]
        public void CreditRequest_CANNOT_REOPEN_CANCELLED_BAN_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_RECENT_CANCEL);
        }
        #endregion

        #region CreditRequest_PHYSICAL_ADDRESS_REQUIRED_Test
        /// <summary>
        /// TODO: work item
        /// 1. POB acceptable for billing, though physical addr reqd for CC
        /// 2. Physical addr reqd for CC
        /// </summary>
        [TestMethod]
        public void CreditRequest_PHYSICAL_ADDRESS_REQUIRED_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_INVALID_SERVICE_ZIP_Test
        /// <summary>
        /// TODO: Pass invalid zipcode.
        /// </summary>
        [TestMethod]
        public void CreditRequest_INVALID_SERVICE_ZIP_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "00000", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_NOT_ELIGIBLE_FOR_UPGRADE_Test
        /// <summary>
        /// TODO: work item
        /// 1. PTN currently eligible for upgrade
        /// 2. Manual activation reqd
        /// 3. Current price plan not eligible
        /// </summary>
        [TestMethod]
        public void CreditRequest_NOT_ELIGIBLE_FOR_UPGRADE_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_NO_PLAN_COVERAGE_Test
        /// <summary>
        /// TODO: work item
        /// </summary>
        [TestMethod]
        public void CreditRequest_NO_PLAN_COVERAGE_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_NO_ACCOUNT_FOUND_Test
        /// <summary>
        /// TODO: work item
        /// </summary>
        [TestMethod]
        public void CreditRequest_NO_ACCOUNT_FOUND_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_NO_SUBSCRIBER_FOUND_Test          == CL_CUSTOMER_FOUND
        /// <summary>
        /// TODO: All Test Data has subscriber numbers; need another way...
        /// </summary>
        [TestMethod]
        public void CreditRequest_NO_SUBSCRIBER_FOUND_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CL_CUSTOMER_FOUND);
        }
        #endregion

        #region CreditRequest_ACCOUNT_TYPE_NOT_SUPPORTED_Test
        /// <summary>
        /// TODO: work item
        /// </summary>
        [TestMethod]
        public void CreditRequest_ACCOUNT_TYPE_NOT_SUPPORTED_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_INVALID_QUESTION_CODE_AND_ANSWER_Test
        /// <summary>
        /// TODO: The Test Data SSN "828057852" does not yet have these fields populated.
        /// </summary>
        [TestMethod]
        public void CreditRequest_INVALID_QUESTION_CODE_AND_ANSWER_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "828057852", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_INVALID_PIN_Test
        /// <summary>
        /// TODO: work item
        /// 1. Invalid Security PIN length
        /// 2. Invalid number - can't be the same
        /// 3. Invalid PIN
        /// 4. Invalid PIN cannot have 4 consecutive numbers
        /// 5. Invalid PIN cannot have consecutive number that match SSN/FTID
        /// </summary>
        [TestMethod]
        public void CreditRequest_INVALID_PIN_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_INVALID_PIN_AND_ANSWER_Test
        /// <summary>
        /// TODO: work item
        /// 1. PIN & Answer invalid
        /// 2. PIN & Answer invalid V2
        /// 3. Invalid Security Answer
        /// </summary>
        [TestMethod]
        public void CreditRequest_INVALID_PIN_AND_ANSWER_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_ALTERNATE_LINE_EXISTS_Test
        /// <summary>
        /// TODO: work item
        /// 1. Alternative Line Exists
        /// 2. Ref PTN cross-network not possible until Alt line removed 
        /// </summary>
        [TestMethod]
        public void CreditRequest_ALTERNATE_LINE_EXISTS_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_SPLIT_BILL_EXISTS_Test
        /// <summary>
        /// TODO: work item
        /// 1. Split Bill Exists
        /// 2. Ref PTN cross-network not possible 'cos split bill exists 
        /// </summary>
        [TestMethod]
        public void CreditRequest_SPLIT_BILL_EXISTS_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_INVALID_SECURITY_QUESTION_CODE_Test
        /// <summary>
        /// TODO: work item
        /// </summary>
        [TestMethod]
        public void CreditRequest_INVALID_SECURITY_QUESTION_CODE_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_MUTIPLE_ACCOUNT_EXISTS_FOR_SSN_Test
        /// <summary>
        /// TODO: work item
        /// </summary>
        [TestMethod]
        public void CreditRequest_MUTIPLE_ACCOUNT_EXISTS_FOR_SSN_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_BILLING_ZIP_CODE_MISMATCH_Test
        /// <summary>
        /// TODO: work item
        /// </summary>
        [TestMethod]
        public void CreditRequest_BILLING_ZIP_CODE_MISMATCH_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_BILLING_LAST_NAME_MISMATCH_Test
        /// <summary>
        /// TODO: work item
        /// </summary>
        [TestMethod]
        public void CreditRequest_BILLING_LAST_NAME_MISMATCH_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_CREDIT_CHECK_ALREADY_COMPLETED_Test
        /// <summary>
        /// TODO: work item
        /// </summary>
        [TestMethod]
        public void CreditRequest_CREDIT_CHECK_ALREADY_COMPLETED_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

        #region CreditRequest_CREDIT_UNKNOWN_Test               == CC_STATUS_UNKNOWN
        /// <summary>
        /// TODO: work item
        /// </summary>
        [TestMethod]
        public void CreditRequest_CREDIT_UNKNOWN_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_STATUS_UNKNOWN);
        }
        #endregion

        #region CreditRequest_IDENTITY_Test
        /// <summary>
        /// TODO: work item
        /// 1. Invalid IC provided
        /// 2. Expiration Date invalid
        /// 3. More id reqd for SSN
        /// 4. Invalid Id code
        /// 5. Unacceptable Primary ID
        /// 6. Unacceptable Secondary ID
        /// 7. Null Primary ID expected
        /// 8. Primary ID reqd
        /// 9. Primary ID value is reqd
        /// 10. Primary & Secondary ID are identical
        /// 11. Null Secondary ID expected
        /// 12. Secondary ID reqd
        /// 13. SSN & ID reqd
        /// 14. SSN reqd for this dealer
        /// 15. Invalid State
        /// 16. Tax ID reqd for this dealer
        /// </summary>
        [TestMethod]
        public void CreditRequest_IDENTITY_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref");

            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_ERROR);
        }
        #endregion

    }

    [TestClass]
    public class SprintAddressValidationTest
    {
        #region AddressValidation_ServiceApi_Success_Test
        [TestMethod]
        public void AddressValidation_ServiceApi_Success_Test()
        {
            var svc = new SprintService();

            WirelessAdvocates.Address address = new WirelessAdvocates.Address();
            address.AddressLine1 = "5628 Airport Way S.";
            address.AddressLine2 = "Suite 110";
            address.City = "Seattle";
            address.State = "WA";
            address.ZipCode = "98108";

            var result = svc.ValidateAddress(address, WirelessAdvocates.Address.AddressType.Billing, "some-ref");

            Assert.IsNotNull(result.ValidAddress);
        }
        #endregion

        #region AddressValidation_ADDRESS_VALIDATION_ERROR_Test == AV_INVALID_ADDRESS
        /// <summary>
        /// TODO: finish this
        /// 1. Addr validation error
        /// 2. Unable to reach validation service
        /// 3. Problem parsing addr
        /// </summary>
        [TestMethod]
        public void AddressValidation_ADDRESS_VALIDATION_ERROR_Test()
        {
            var svc = new SprintService();

            WirelessAdvocates.Address address = new WirelessAdvocates.Address();
            address.AddressLine1 = "5628 Airport Way S.";
            address.AddressLine2 = "Suite 110";
            address.City = "Seattle";
            address.State = "WA";
            address.ZipCode = "98108";

            var result = svc.ValidateAddress(address, WirelessAdvocates.Address.AddressType.Billing, "some-ref");

            //Assert.IsNotNull(result.ErrorCode > 0);
            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.AV_INVALID_ADDRESS);
        }
        #endregion
    
    }

    [TestClass]
    public class SprintPortInEligibilityTest
    {
        #region PortInEligibilty_ServiceApi_Deserilization_Test
        [TestMethod]
        public void PortInEligibilty_ServiceApi_Deserilization_Test()
        {
            var svc = new SprintService();

            List<WirelessAdvocates.MDNSet> mdnSetList = new List<WirelessAdvocates.MDNSet>();
            WirelessAdvocates.MDNSet set = new WirelessAdvocates.MDNSet();
            set.MDN = "206-850-6299";
            mdnSetList.Add(set);

            var result = svc.ValidatePortIn(mdnSetList, "some-ref");

            Assert.IsNotNull(result);
        }
        #endregion

        #region PortInEligibilty_ServiceApi_PortInAvailable_Test
        [TestMethod]
        public void PortInEligibilty_ServiceApi_PortInAvailable_Test()
        {
            var svc = new SprintService();

            List<WirelessAdvocates.MDNSet> mdnSetList = new List<WirelessAdvocates.MDNSet>();
            WirelessAdvocates.MDNSet set = new WirelessAdvocates.MDNSet();
            set.MDN = "3373653600";
            mdnSetList.Add(set);

            var result = svc.ValidatePortIn(mdnSetList, "some-ref");

            Assert.IsTrue(result.ErrorCode == (int)ServiceResponseCode.Success & result.MDNSet[0].IsPortable == true);
        }
        #endregion

        #region PortInEligibilty_ServiceApi_PortInFail_Test
        [TestMethod]
        public void PortInEligibilty_ServiceApi_PortInFail_Test()
        {
            var svc = new SprintService();

            List<WirelessAdvocates.MDNSet> mdnSetList = new List<WirelessAdvocates.MDNSet>();
            WirelessAdvocates.MDNSet set = new WirelessAdvocates.MDNSet();
            //set.MDN = "2065551212343434"; No MDN for this test to pass.
            mdnSetList.Add(set);

            var result = svc.ValidatePortIn(mdnSetList, "some-ref");

            Assert.IsTrue(result.ErrorCode == (int)ServiceResponseCode.Failure);
        }
        #endregion
        
    }

    [TestClass]
    public class SprintCheckCreditTest
    {
        #region CheckCredit_ServiceApi_ValidExistingCustomer_Test
        [TestMethod]
        public void CheckCredit_ServiceApi_ValidExistingCustomer_Test()
        {
            var svc = new SprintService();

            //var orderid = Guid.NewGuid().ToString().Substring(1, 20);
            var orderid = "e2829c8-356d-4436-86";
            var result = svc.CheckCreditExistingAccount("164067561", "123456", CustomerType.INDIVIDUAL, OrderType.ADD_ON, 1, orderid);

            //Assert.IsTrue(result.ErrorCode == (int)ServiceResponseCode.Success);
        }
        #endregion

        #region CheckCredit_ServiceApi_ExistingCustomerNotFound_Test
        [TestMethod]
        public void CheckCredit_ServiceApi_ExistingCustomerNotFound_Test()
        {
            var svc = new SprintService();

            //note the account number is bogus '555555555'
            var result = svc.CheckCreditExistingAccount("555555555", "123456", CustomerType.INDIVIDUAL, OrderType.ADD_ON, 1, "some-ref");

           // Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.CC_STATUS_UNKNOWN);
        }
        #endregion

        #region CheckCredit_ServiceApi_ValidNewCustomer_Test
        [TestMethod]
        public void CheckCredit_ServiceApi_ValidNewCustomer_Test()
        {
            var svc = new SprintService();


            string refNumber = Guid.NewGuid().ToString().Substring(0,20);


            WirelessAdvocates.Address address = new WirelessAdvocates.Address();
            address.AddressLine1 = "5628 Airport Way S.";
            address.AddressLine2 = "Suite 110";
            address.City = "Seattle";
            address.State = "WA";
            address.ZipCode = "98108";

            var resultA = svc.ValidateAddress(address, WirelessAdvocates.Address.AddressType.Billing, refNumber);


            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Test", LastName = "Tester" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299"};
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN="107791003", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA"};

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, refNumber); 

            Assert.IsTrue(result.ErrorCode == (int)ServiceResponseCode.Success);
        }
        #endregion

        #region CheckCredit_ServiceApi_OneLineApproved_Test
        [TestMethod]
        public void CheckCredit_ServiceApi_OneLineApproved_Test()
        {
            var svc = new SprintService();

            //build the required attributes.
            WirelessAdvocates.Name name = new WirelessAdvocates.Name { FirstName = "Mac", LastName = "McClain" };
            WirelessAdvocates.Contact contact = new WirelessAdvocates.Contact { CellPhone = "2068506299", Email = "mac@gosolid.net", EveningPhone = "2068506299", WorkPhone = "2068506299" };
            WirelessAdvocates.PersonalCredentials personal = new WirelessAdvocates.PersonalCredentials { SSN = "107791853", DOB = DateTime.Parse("1/1/2010"), Id = "878787878", IdExpiration = DateTime.Parse("1/1/2015"), IdType = WirelessAdvocates.PersonalCredentials.IdentificationType.DL, State = "WA" };

            var result = svc.CheckCredit(name, "98102", contact, personal, 1, "some-ref123");

            Assert.IsTrue(result.NumberOfLines > 0);
        }
        #endregion
    }

    [TestClass] 
    public class NpaNxxValidNpaTest
    {
        #region NpaNxx_ResponseDeserialization_Test
        [TestMethod]
        public void NpaNxx_ResponseDeserialization_Test()
        {
            XmlDocument doc = new XmlDocument();
            //doc.Load(@"c:\temp\port-response.xml");
            //doc.Load(@"c:\temp\npanxx_error.xml");
            //doc.Load(@"c:\temp\resp.xml");
            doc.Load(@"c:\temp\account_validation\av-resp.xml");
            string xml = doc.OuterXml;
            var obj = XmlHelper.DeserializeXMLResponse(xml);
            Assert.IsNotNull(obj);
        }
        #endregion

        #region NpaNxx_ValidPayload_Test
        [TestMethod]
        public void NpaNxx_ValidPayload_Test()
        {
            ovm o = new ovm();
            o.ovmheader = new RequestMessageHeader();
            o.ovmheader.pin = ConfigurationManager.AppSettings["Vendor-PIN"];
            o.ovmheader.vendorcode = ConfigurationManager.AppSettings["Vendor-Code"];
            o.ovmheader.messagetype = RequestMessageType.NPA_NXX_REQUEST;
            o.ovmheader.timestamp = DateTime.Parse("2008-11-25T00:00:00");

            o.ovmrequest = new ovmOvmrequest();
            NpaNxxRequest npaRequest = new NpaNxxRequest();
            npaRequest.activationzipcode = "29620";
            o.ovmrequest.Item = npaRequest;
            o.ovmrequest.ItemElementName = ItemChoiceType13.npanxxrequest;

            var uri = ConfigurationManager.AppSettings["Service-URL"];

            string xml = XmlHelper.GenerateXML(o);

            var result = RestHelper.SubmitRequest(xml, uri);
            Assert.IsNotNull(result);
        }

        [TestMethod]
        public void NpaNxx_ServiceApi_Deserilization_Test()
        {
            var svc = new SprintService();
            //var result = svc.NpaNxx("29620", "some-ref"); 
            var result = svc.NpaNxx("20191", "some-ref");

            Assert.IsNotNull(result);
        }

        [TestMethod]
        public void NpaNxx_ServiceApi_RespMap_Test()
        {
            var svc = new SprintService();
            var result = svc.NpaNxx("20191", "some-ref");
            Assert.IsTrue(result.NpaSet != null && result.NpaSet.Count > 0);
        }
        #endregion

        #region NpaNxx_ServiceApi_NoNpaFound_Test
        [TestMethod]
        public void NpaNxx_ServiceApi_NoNpaFound_Test()
        {
            var svc = new SprintService();
            var result = svc.NpaNxx("00000", "some-ref");
            Assert.IsTrue(result.ServiceResponseSubCode == (int)ServiceResponseSubCode.NPA_NO_MARKETDATA_FOR_ZIP);
        }
        #endregion

        #region NpaNxx_ServiceApi_NoNpaFound_Test
        [TestMethod]
        public void NpaNxx_ServiceApi_MultipleNpaFound_Test()
        {
            var svc = new SprintService();
            var result = svc.NpaNxx("17201", "some-ref");
            Assert.IsTrue(result.NpaSet.Count > 1);
        }
        #endregion
 
    }

    #region unspecified 
    // TODO: These may have been covered already but we need to make sure...
    // AUTHENTICATION_ERROR
    // INVALID_REQUEST_TYPE
    // INVALID_MARKET
    // INVALID_REFERENCE_PTN
    // REF_PTN_REQUIRED
    // INVALID_DINERS_CLUB
    // INVALID_CREDIT_CARD
    // CREDIT_CANCEL_REQUEST_NOT_ALLOWED
    // CREDIT_CANCEL_DATA_MISMATCH
    // CREDIT_CANCEL_ORDER_IN_PROCESS

    #endregion

}
