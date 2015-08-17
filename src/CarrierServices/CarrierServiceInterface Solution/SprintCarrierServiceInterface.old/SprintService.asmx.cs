using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using SprintCarrierServiceInterface.Interfaces;

using SprintCarrierServiceInterface.Interfaces.checkOrderStatus;
using SprintCarrierServiceInterface.Interfaces.doAccountValidation;
using SprintCarrierServiceInterface.Interfaces.doActivateReservedDevice;
using SprintCarrierServiceInterface.Interfaces.doActivation;
using SprintCarrierServiceInterface.Interfaces.performAuthenticationResendPin;
using SprintCarrierServiceInterface.Interfaces.getBillSummary;
using SprintCarrierServiceInterface.Interfaces.getCorporateDiscount;
using SprintCarrierServiceInterface.Interfaces.doCoverageCheck;
using SprintCarrierServiceInterface.Interfaces.doCreditCancel;
using SprintCarrierServiceInterface.Interfaces.doCreditCheck;
using SprintCarrierServiceInterface.Interfaces.doDeactivation;
using SprintCarrierServiceInterface.Interfaces.getDeviceInfo;
using SprintCarrierServiceInterface.Interfaces.doInventoryCheck;
using SprintCarrierServiceInterface.Interfaces.getNpaNxx;
using SprintCarrierServiceInterface.Interfaces.getOptionsInfo;
using SprintCarrierServiceInterface.Interfaces.queryPlansDetailInfo;
using SprintCarrierServiceInterface.Interfaces.getPortInInfo;
using SprintCarrierServiceInterface.Interfaces.doPreAuthorization;
using SprintCarrierServiceInterface.Interfaces.getSecurityQuestion;
using SprintCarrierServiceInterface.Interfaces.performServiceValidation;
using SprintCarrierServiceInterface.Interfaces.doValidation;

using SprintCarrierServiceInterface.Interfaces.ovmCommon;
using WirelessAdvocates;


namespace SprintCarrierServiceInterface
{
    /// <summary>
    /// Summary description for Service1
    /// </summary>
    [WebService(Namespace = "http://WirelessAdvocates.SprintCarrierServiceInterface/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    public class SprintService : System.Web.Services.WebService
    {
        /// <summary>
        /// 1. Stubbing all the objects in each class
        /// 2. Providing the range of the vaue of the data type used by thee object
        /// </summary>
        /// <returns></returns>

        // API: Account Validation
        //[WebMethod]
        public AccountValidationRequest AccountValidation()
        {
            AccountValidationRequest accountValidationRequest = new AccountValidationRequest();

            accountValidationRequest.billingzip = " Test Billing zip"; // String 5/9 (Optional)
            accountValidationRequest.lastname = "last name"; // String Min 2 Max 50 (Optional)
            accountValidationRequest.secanswer = "secanswer"; //String Min 2 Max 30 (Optional)
            accountValidationRequest.secpin = "sec pin"; // String Min 2 Max 10 (Optional)
            accountValidationRequest.singlesubscriberSpecified = false;

            //accountValidationRequest.ItemElementName = Interfaces.doAccountValidation.ItemChoiceType.accountnumber;
            //accountValidationRequest.ItemElementName = Interfaces.doAccountValidation.ItemChoiceType.meid;
            //accountValidationRequest.ItemElementName = Interfaces.doAccountValidation.ItemChoiceType.referenceptn;
            //accountValidationRequest.ItemElementName = Interfaces.doAccountValidation.ItemChoiceType.sim;

            return accountValidationRequest;
            
            /*
             * AccountValidationResponse accou  ntValidationResponse = new AccountValidationResponse();   

            accountValidationRequest.billingzip = String.Empty;
            // accountValidationRequest.Item=String.Empty;
            // accountValidationRequest.ItemElementName= Interfaces.doAccountValidation.ItemChoiceType.accountnumber;

            // TODO: meid

            accountValidationRequest.lastname = String.Empty; // MIN 2 Max 50 (Optional)
            
           // accountValidationRequest.requesteddevices= String.Empty;

            accountValidationRequest.returnBogxInd = false;
            accountValidationRequest.returnBogxIndSpecified=false;
            accountValidationRequest.secanswer = String.Empty; // MIN 2 Max 30 (Optional)
            accountValidationRequest.secpin= String.Empty; // MIN 6 MAX 10 (Optional)
            accountValidationRequest.singlesubscriber = false; //Boolean (Optional)
            accountValidationRequest.singlesubscriberSpecified= false;

            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(accountValidationRequest), String.Empty, "AccountValidation", String.Empty);  

            // Post Request
            string strAccountValidationResponse = String.Empty;

            WirelessAdvocates.Logger.Log.LogResponse(strAccountValidationResponse, String.Empty, "AccountValidation", String.Empty);  

            // Parse Response

            accountValidationResponse = (AccountValidationResponse)WirelessAdvocates.Utility.DeserializeXML(strAccountValidationResponse, typeof(AccountValidationResponse));

            return accountValidationResponse;
             * */
        }

        // API: Activate Reserved Device
        ////[WebMethod]
        public ActivateReservedDeviceRequest ActivateReservedDevice()
        {
            // Create Request
            ActivateReservedDeviceRequest activateReservedDeviceRequest = new ActivateReservedDeviceRequest();
           
            //SprintCarrierServiceInterface.Interfaces.doActivateReservedDevice.ParseResponse parseResponse = new SprintCarrierServiceInterface.Interfaces.doActivateReservedDevice.ParseResponse();
            //SprintCarrierServiceInterface.Interfaces.doActivateReservedDevice.ResponseMessageHeader responseMessageHeader = new SprintCarrierServiceInterface.Interfaces.doActivateReservedDevice.ResponseMessageHeader();
            
            //parseResponse.sprintorderid = "or-bynr-12345678";
            //responseMessageHeader.orderid = "Order-Id";

            string[] stValues=new string[1];

            activateReservedDeviceRequest.ptnlist = new string[1] {
                stValues[0]= "Ref-ptn"
            };

            
            //SprintCarrierServiceInterface.Interfaces.doActivateReservedDevice.ItemChoiceType.orderid,=?
            //SprintCarrierServiceInterface.Interfaces.doActivateReservedDevice.ItemChoiceType.sprintorderid=?

            return activateReservedDeviceRequest;

            /*
            activateReservedDeviceResponse.accountnumber = String.Empty;
            activateReservedDeviceResponse.activationfee = Convert.ToDecimal(0);
            activateReservedDeviceResponse.activationfeeSpecified= false;
            activateReservedDeviceResponse.comment= String.Empty;
            //activateReservedDeviceResponse.service = ;

            ActivateReservedDeviceResponse activateReservedDeviceResponse = new ActivateReservedDeviceResponse();
            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(activateReservedDeviceRequest), String.Empty, "ActivateReservedDevice", String.Empty);  

            // Post Request
            string strActivateReservedDeviceResponse = String.Empty;

            WirelessAdvocates.Logger.Log.LogResponse(strActivateReservedDeviceResponse, String.Empty, "ActivateReservedDevice", String.Empty);  

            // Parse Response

            activateReservedDeviceResponse = (ActivateReservedDeviceResponse)WirelessAdvocates.Utility.DeserializeXML(strActivateReservedDeviceResponse, typeof(ActivateReservedDeviceResponse));

            return activateReservedDeviceResponse;
             * */
        }
       
        // API: Activation
        //[WebMethod]
        public ActivationResponse Activation()
        { 
            // Create Request
            ActivationRequest activationRequest = new ActivationRequest();
            ActivationResponse activationResponse = new ActivationResponse();

            activationResponse.accountnumber = String.Empty;
            activationResponse.activationdate = Convert.ToDateTime(0);
            activationResponse.activationdateSpecified = false;
            activationResponse.activationfee = Convert.ToDecimal(0);
            activationResponse.activationfeeSpecified = false;
            activationResponse.activationtalkingpoints = String.Empty;
            activationResponse.anniversarydate = Convert.ToDateTime(0);
            activationResponse.anniversarydateSpecified = false;
            
            //activationResponse.appliedpromos = Convert.

            activationResponse.cancellationdate = Convert.ToDateTime(0);
            activationResponse.cancellationdateSpecified = false;
            activationResponse.comment = String.Empty;
            activationResponse.currentbalance = Convert.ToDecimal(0);
            activationResponse.currentbalanceSpecified = false;
            activationResponse.errorreason = String.Empty;
            activationResponse.expirationdate = Convert.ToDateTime(0);
            activationResponse.expirationdateSpecified = false;
            activationResponse.firstname = String.Empty;
            activationResponse.futureportinnumber = String.Empty;
            activationResponse.lastname = String.Empty;
            activationResponse.lowbalthreshold = Convert.ToDecimal(0);
            activationResponse.lowbalthresholdSpecified = false;
            activationResponse.minamount = Convert.ToDecimal(0);
            activationResponse.minamountSpecified = false;
            activationResponse.nextsteps = String.Empty;
            activationResponse.OfferTrxId = String.Empty;
            activationResponse.orderdate = Convert.ToDateTime(0);
            activationResponse.orderdateSpecified = false;
            
            //activationResponse.orderfulfillment = 

            activationResponse.rccpallowed = false;
            activationResponse.rccpallowedSpecified = false;
            activationResponse.reactivationfee = Convert.ToDecimal(0);
            activationResponse.reactivationfeeSpecified = false;
            activationResponse.saleschannel = String.Empty;
            //activationResponse.service = Convert.

            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(activationRequest), String.Empty, "Activation", String.Empty);

            string strActivationResponse = String.Empty;

            activationResponse = (ActivationResponse)WirelessAdvocates.Utility.DeserializeXML(strActivationResponse, typeof(ActivateReservedDeviceResponse));

            WirelessAdvocates.Logger.Log.LogResponse(WirelessAdvocates.Utility.SerializeXML(activationResponse), String.Empty, "Activation", String.Empty);

            return activationResponse;
        }
        
        // API: Authenticate PIN/Resend PIN
        //[WebMethod]
        public AuthenticationResendPinRequest AuthenticationResendPin()
        {
            //Create Request
            AuthenticationResendPinRequest authenticationResendPinRequest = new AuthenticationResendPinRequest();
            AuthenticationResendPinResponse authenticationResendPinResponse = new AuthenticationResendPinResponse();

            object[] Arequestvalues = new object[4];
                Arequestvalues[0] = false; // Boolean (Oprional)
                Arequestvalues[1] = false; // Boolean (Oprional)
                Arequestvalues[2] = "Test sec-answer"; // String Min 2 Max 30 (Oprional)
                Arequestvalues[3] = "Test SEC-PIN"; // String Min 6 Max 10 (Oprional)

            authenticationResendPinRequest.Items = new object[4]{
                Arequestvalues[0],
                Arequestvalues[1],
                Arequestvalues[2],
                Arequestvalues[3]
            };

            authenticationResendPinRequest.ItemsElementName = new SprintCarrierServiceInterface.Interfaces.performAuthenticationResendPin.ItemsChoiceType[4] { 
                SprintCarrierServiceInterface.Interfaces.performAuthenticationResendPin.ItemsChoiceType.authenticatecustomer,
                SprintCarrierServiceInterface.Interfaces.performAuthenticationResendPin.ItemsChoiceType.resendpin,
                SprintCarrierServiceInterface.Interfaces.performAuthenticationResendPin.ItemsChoiceType.secanswer,
                SprintCarrierServiceInterface.Interfaces.performAuthenticationResendPin.ItemsChoiceType.secpin
            };

            authenticationResendPinRequest.Item = "account-number";
            authenticationResendPinRequest.ItemElementName = Interfaces.performAuthenticationResendPin.ItemChoiceType.accountnumber;

            authenticationResendPinRequest.Item = "reference-ptn";
            authenticationResendPinRequest.ItemElementName = Interfaces.performAuthenticationResendPin.ItemChoiceType.referenceptn;

            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(authenticationResendPinRequest), String.Empty, "AuthenticationResendPin", String.Empty);

            string strAuthenticationResendPinResponse = String.Empty;

            authenticationResendPinResponse = (AuthenticationResendPinResponse)WirelessAdvocates.Utility.DeserializeXML(strAuthenticationResendPinResponse, typeof(AuthenticationResendPinResponse));

            return authenticationResendPinRequest;
        }

        // API: Bill Summary
        //[WebMethod]

        // API: Corporate Discount
        public BillSummaryRequest BillSummary()
        {
            BillSummaryRequest billSummaryRequest = new BillSummaryRequest();
            BillSummaryResponse billSummaryResponse = new BillSummaryResponse();
            BillSummaryPlan billSummaryPlan = new BillSummaryPlan();

            billSummaryPlan.code = String.Empty; // String: 10 (Optional)
            billSummaryPlan.id = String.Empty;
            billSummaryPlan.subscribercount = String.Empty; // Integer (Optional)
            SprintCarrierServiceInterface.Interfaces.getBillSummary.Feature planFeature = new SprintCarrierServiceInterface.Interfaces.getBillSummary.Feature(); // Structure: Min: 0 Max: 20

            planFeature.featurecode = String.Empty;// String: 10

            billSummaryPlan.feature = new SprintCarrierServiceInterface.Interfaces.getBillSummary.Feature[] {
                planFeature
            };

            object[] requestValues = new object[6];

            requestValues[0] = "test1"; // account number --> String length: 9 (Optional)
            requestValues[1] = "test2"; // activation zipcode --> String length: 5 or 9 (Optional)
            requestValues[2] = SprintCarrierServiceInterface.Interfaces.getBillSummary.OrderType.NEW; // String Enumeration
            requestValues[3] = billSummaryPlan; // chk billsummary plan above
            requestValues[4] = "test5"; // referenceptn --> String length: 10 (Optional)
            requestValues[5] = false; // secondbill --> Boolean (Optional)

            billSummaryRequest.Items = new object[6] { 
                requestValues[0], 
                requestValues[1],
                requestValues[2],
                requestValues[3],
                requestValues[4],
                requestValues[5]
            };

            billSummaryRequest.ItemsElementName = new SprintCarrierServiceInterface.Interfaces.getBillSummary.ItemsChoiceType[6] { 
                SprintCarrierServiceInterface.Interfaces.getBillSummary.ItemsChoiceType.accountnumber, 
                SprintCarrierServiceInterface.Interfaces.getBillSummary.ItemsChoiceType.activationzipcode,
                SprintCarrierServiceInterface.Interfaces.getBillSummary.ItemsChoiceType.ordertype,
                SprintCarrierServiceInterface.Interfaces.getBillSummary.ItemsChoiceType.plan,
                SprintCarrierServiceInterface.Interfaces.getBillSummary.ItemsChoiceType.referenceptn,
                SprintCarrierServiceInterface.Interfaces.getBillSummary.ItemsChoiceType.secondbill
            };

            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(billSummaryRequest), String.Empty, "BillSummary", String.Empty);
            
            string strBillSummaryResponse = String.Empty;

            billSummaryResponse = (BillSummaryResponse)WirelessAdvocates.Utility.DeserializeXML(strBillSummaryResponse, typeof(BillSummaryResponse));

            return billSummaryRequest;
        }
        //[WebMethod]
        public CorporateDiscountRequest CorporateDiscount()
        {
            //Create Request
            
            CorporateDiscountRequest corporateDiscountRequest = new CorporateDiscountRequest();

            object[] CDvalues= new object[6];
            CDvalues[0]="Acc no";   //String length:10 (Optional)
            CDvalues[1] = "integer val=10";     //Integer (Optional)
            CDvalues[2]="CorpGovId"; // String Min 1 Max 20 (Optional)
            CDvalues[3]=false;      //Boolean (Optional)
            CDvalues[4]="master-company-name";  // String Min 2 Max 128 (Optional)
            CDvalues[5]="reference-ptn";        // String length = 10

            corporateDiscountRequest.Items= new object[6]
            {
            CDvalues[0],
            CDvalues[1],
            CDvalues[2],
            CDvalues[3],
            CDvalues[4],
            CDvalues[5]
            };

            corporateDiscountRequest.ItemsElementName = new Interfaces.getCorporateDiscount.ItemsChoiceType[6]{

                SprintCarrierServiceInterface.Interfaces.getCorporateDiscount.ItemsChoiceType.accountnumber,
                SprintCarrierServiceInterface.Interfaces.getCorporateDiscount.ItemsChoiceType.companyid,
                SprintCarrierServiceInterface.Interfaces.getCorporateDiscount.ItemsChoiceType.corpgovid,
                SprintCarrierServiceInterface.Interfaces.getCorporateDiscount.ItemsChoiceType.employeeproof,
                SprintCarrierServiceInterface.Interfaces.getCorporateDiscount.ItemsChoiceType.mastercompanyname,
                SprintCarrierServiceInterface.Interfaces.getCorporateDiscount.ItemsChoiceType.referenceptn
            };

            return corporateDiscountRequest;


            /*CorporateDiscountResponse corporateDiscountResponse = new CorporateDiscountResponse();
            //-----Stub----//

            //Serialize
            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(corporateDiscountRequest), String.Empty, "BillSummary", String.Empty);  
            
            //Post Request
            String strCorporateDiscountResponse = String.Empty;
            WirelessAdvocates.Logger.Log.LogResponse(strCorporateDiscountResponse, String.Empty, "BillSummary", String.Empty);

            //Parse Request
            corporateDiscountResponse = (CorporateDiscountResponse)WirelessAdvocates.Utility.DeserializeXML(strCorporateDiscountResponse, typeof(CorporateDiscountResponse));
            return corporateDiscountResponse;
             * */

        }

        // API: Coverage Check
        //[WebMethod]
        public CoverageCheckRequest CoverageCheck()
        {
            //Create Request
            
            CoverageCheckRequest coverageCheckRequest = new CoverageCheckRequest();

            string[] servicezipcode=new string[2];


          //servicezipcode[0] = "01234";
            servicezipcode[1] = "01234 - 5678";

            coverageCheckRequest.servicezip = servicezipcode;
         
            return coverageCheckRequest;

         /*   //-----Stub----//
              CoverageCheckResponse coverageCheckResponse = new CoverageCheckResponse();
          
              //Serialize
            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(coverageCheckRequest), String.Empty, "CoverageCheck", String.Empty);  
            

            //Post Request
            String strCoverageCheckResponse = String.Empty;
            WirelessAdvocates.Logger.Log.LogResponse(strCoverageCheckResponse,String.Empty,"CoverageCheck",String.Empty);

            //Parse Request
            coverageCheckResponse=(CoverageCheckResponse)WirelessAdvocates.Utility.DeserializeXML(strCoverageCheckResponse,typeof(CoverageCheckResponse));
            return coverageCheckResponse;
          */  
        }
        
        // API: Credit Cancel
        //[WebMethod]
        public CreditCancelRequest CreditCancel()
        {
            
            CreditCancelRequest creditCancelRequest = new CreditCancelRequest();

            Interfaces.doCreditCancel.Name name= new Interfaces.doCreditCancel.Name();

            name.sirname = "Test Sirname";    //String Min 1 Max 5  (Optional)
            name.firstname = "Test firstname";  //String Min 1 Max 35
            name.middleinitial = "Test middleinitial"; //String length: 1
            name.lastname = "Test lastname"; //String Min 2 Max 35
            name.suffix = "Test suffix";   //String Min 1 Max 5

            creditCancelRequest.name = name;

            return creditCancelRequest;

          /*
           * //-----Stub----//
            CreditCancelResponse creditCancelResponse = new CreditCancelResponse();
           
            //Serialize
            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(creditCancelRequest), String.Empty, "CreditCancel", String.Empty);


            //Post Request
            String strCreditCancelResponse = String.Empty;
            WirelessAdvocates.Logger.Log.LogResponse(strCreditCancelResponse, String.Empty, "CreditCancel", String.Empty);

            //Parse Request
            creditCancelResponse = (CreditCancelResponse)WirelessAdvocates.Utility.DeserializeXML(strCreditCancelResponse, typeof(CoverageCheckResponse));
            return creditCancelResponse;
           */
        }

        // API: Credit Check
        //[WebMethod]
        public CreditRequest CreditCheck()
        {
            CreditRequest creditRequest = new CreditRequest();

            BillingInfoType billing = new BillingInfoType();
            Interfaces.doCreditCheck.Address billingAddress = new Interfaces.doCreditCheck.Address();
            Interfaces.doCreditCheck.Name billingName = new Interfaces.doCreditCheck.Name();
            Interfaces.doCreditCheck.PhoneExtType billingWorkPhone = new Interfaces.doCreditCheck.PhoneExtType();
            ContactType billingContact = new ContactType();
            Interfaces.doCreditCheck.Name billingContactName = new Interfaces.doCreditCheck.Name();
            Interfaces.doCreditCheck.CorporateGovernmentInfo corpGovInfo = new Interfaces.doCreditCheck.CorporateGovernmentInfo();
            DriversLicense driversLicense = new DriversLicense();
            Interfaces.doCreditCheck.OrderInfoType order = new Interfaces.doCreditCheck.OrderInfoType();
            PhysicalInfoType physical = new PhysicalInfoType();
            Interfaces.doCreditCheck.Address physicalAddress = new Interfaces.doCreditCheck.Address();

            object[] CCrequestValues = new object[6];
            CCrequestValues[0] = "Test ST Add1"; // street-address-1 --> String Min 1 Max 50 
            CCrequestValues[1] = "Test ST Add2"; // street-address-2 --> String Min 1 Max 50 (Optional)
            CCrequestValues[2] = "Test City"; //City --> String Min 1 Max 50
            CCrequestValues[3] = "TestStateCode"; // String --> String[A-Z] length=2
            CCrequestValues[4] = "TestZipCode"; // String --> length=5 or 9
            CCrequestValues[5] = "TestCountryCode"; // String -->Enumeration (Optional)

            billingAddress.Items = new object[6]    {
                // Add Values
                CCrequestValues[0],
                CCrequestValues[1],
                CCrequestValues[2],
                CCrequestValues[3],
                CCrequestValues[4],
                CCrequestValues[5]
            };

            billingAddress.ItemsElementName = new Interfaces.doCreditCheck.ItemsChoiceType[6]   {
                // Add Items   
                SprintCarrierServiceInterface.Interfaces.doCreditCheck.ItemsChoiceType.streetaddress1,
                SprintCarrierServiceInterface.Interfaces.doCreditCheck.ItemsChoiceType.streetaddress2,
                SprintCarrierServiceInterface.Interfaces.doCreditCheck.ItemsChoiceType.city,
                SprintCarrierServiceInterface.Interfaces.doCreditCheck.ItemsChoiceType.statecode,
                SprintCarrierServiceInterface.Interfaces.doCreditCheck.ItemsChoiceType.zipcode,
                SprintCarrierServiceInterface.Interfaces.doCreditCheck.ItemsChoiceType.countrycode
            };

            billingName.additionalline = String.Empty;
            billingName.firstname = String.Empty;
            billingName.lastname = String.Empty;
            billingName.middleinitial = String.Empty;
            billingName.sirname = String.Empty;
            billingName.suffix = String.Empty;

            billingWorkPhone.ext = String.Empty;
            billingWorkPhone.Value = String.Empty;
            
            billing.accountemailaction = Interfaces.doCreditCheck.EmailAction.A;
            billing.accountemailactionSpecified = true;
            billing.address = billingAddress;
            billing.alternatephone = String.Empty;
            billing.besttimetocallalternate = BestTimeToCall.A;
            billing.besttimetocallalternateSpecified = true;
            billing.besttimetocallhome = BestTimeToCall.A;
            billing.besttimetocallhomeSpecified = true;
            billing.besttimetocallwork = BestTimeToCall.A;
            billing.besttimetocallworkSpecified = true;
            billing.companyname = String.Empty;
            billing.ebill = String.Empty;
            billing.emailaddress = String.Empty;
            billing.homephone = String.Empty;
            billing.marketingpreference = MarketingPrefType.N;
            billing.marketingpreferenceSpecified = true;
            billing.name = billingName;
            billing.workphone = billingWorkPhone;

            billingContactName.additionalline = String.Empty;
            billingContactName.firstname = String.Empty;
            billingContactName.lastname = String.Empty;
            billingContactName.middleinitial = String.Empty;
            billingContactName.sirname = String.Empty;
            billingContactName.suffix = String.Empty;

            billingContact.name = billingContactName;

            corpGovInfo.corpgovid = String.Empty;
            corpGovInfo.dacid = new uint();
            corpGovInfo.dacidSpecified=true;
            corpGovInfo.employeeid=String.Empty;
            corpGovInfo.equipmentpo=String.Empty;
            corpGovInfo.nodeid = new uint();
            corpGovInfo.nodeidSpecified=true;
            corpGovInfo.servicecostcenter=String.Empty;
            corpGovInfo.servicepo=String.Empty;
            corpGovInfo.taxexemptid=String.Empty;   

            driversLicense.expirationdate = DateTime.Now;
            driversLicense.expirationdateSpecified = true;
            driversLicense.id = String.Empty;
            driversLicense.state = String.Empty;

            order.ipaddress = String.Empty;
            order.Item = String.Empty;
            //order.ItemElementName = ?;
            //order.type = ?;
            order.webprofileid = String.Empty;

            object[] PArequestValues=new object[6];

            PArequestValues[0] = "Test PA ST Add1"; // street-address-1 --> String Min 1 Max 50 
            PArequestValues[1] = "Test PA ST Add2"; // street-address-2 --> String Min 1 Max 50 (Optional)
            PArequestValues[2] = "Test PA City"; //City --> String Min 1 Max 50
            PArequestValues[3] = "Test PA StateCode"; // String --> String[A-Z] length=2
            PArequestValues[4] = "Test PA ZipCode"; // String --> length=5 or 9
            PArequestValues[5] = "Test PA CountryCode"; // String -->Enumeration (Optional)

            physicalAddress.Items = new object[6]    {
                // Add Values
                PArequestValues[0],
                PArequestValues[1],
                PArequestValues[2],
                PArequestValues[3],
                PArequestValues[4],
                PArequestValues[5]
            };

            physicalAddress.ItemsElementName = new Interfaces.doCreditCheck.ItemsChoiceType[6]   {
                // Add Items  
                SprintCarrierServiceInterface.Interfaces.doCreditCheck.ItemsChoiceType.streetaddress1,
                SprintCarrierServiceInterface.Interfaces.doCreditCheck.ItemsChoiceType.streetaddress2,
                SprintCarrierServiceInterface.Interfaces.doCreditCheck.ItemsChoiceType.city,
                SprintCarrierServiceInterface.Interfaces.doCreditCheck.ItemsChoiceType.statecode,
                SprintCarrierServiceInterface.Interfaces.doCreditCheck.ItemsChoiceType.zipcode,
                SprintCarrierServiceInterface.Interfaces.doCreditCheck.ItemsChoiceType.countrycode
            };

            physical.address = physicalAddress;

            creditRequest.activationzipcode = String.Empty;
            creditRequest.billing = billing;
            creditRequest.ccpincode = String.Empty;
            creditRequest.contact = billingContact;
            creditRequest.corpgovinfo = corpGovInfo;
            creditRequest.customertype = Interfaces.doCreditCheck.CustomerType.INDIVIDUAL;
            creditRequest.dateofbirth = DateTime.Now;
            creditRequest.dateofbirthSpecified = true;
            creditRequest.debugscore = String.Empty;
            creditRequest.driverslicense = driversLicense;
            creditRequest.handsetcount = 0;
            // creditRequest.identificationmethod = ?;
            creditRequest.intlhandsetcount = 0;
            creditRequest.intlhandsetcountSpecified = true;
            //creditRequest.Item = ?;
            //creditRequest.ItemElementName = ?;
            creditRequest.language = String.Empty;
            creditRequest.order = order;
            creditRequest.passcode = String.Empty;
            creditRequest.physical = physical;
            creditRequest.programcode = String.Empty;
            creditRequest.repid = String.Empty;
            creditRequest.secanswer = String.Empty;
            creditRequest.secpin = String.Empty;
            creditRequest.secquestioncode = String.Empty;
            creditRequest.subscriberagreement = true;

            return creditRequest;
        }

        // API: Deactivation
        //[WebMethod]
        public DeactivationRequest Deactivation()
        {
            DeactivationRequest deactivationRequest = new DeactivationRequest();
            ResponseMessageHeader responseMessageHeader = new ResponseMessageHeader();
            responseMessageHeader.vendorcode = "";

            return deactivationRequest;

            /*
            DeactivationResponse deactivationReposnse = new DeactivationResponse();

            //-----Stub----//

            //Serialize
            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(deactivationRequest),String.Empty,"Deactivation", String.Empty);

            //Post Request
            String strdeactivationReposnse = String.Empty;
            WirelessAdvocates.Logger.Log.LogResponse(strdeactivationReposnse, String.Empty, "Deactivation", String.Empty);

            //Parse Request
            deactivationReposnse = (DeactivationResponse)WirelessAdvocates.Utility.DeserializeXML(strdeactivationReposnse, typeof(DeactivationResponse));
            return deactivationReposnse;
             * */
        }

        // API: Device Info
        //[WebMethod]
        public DeviceInfoResponse DeviceInfo()
        {
            DeviceInfoResponse deviceInfoResponse = new DeviceInfoResponse();
            DeviceInfoRequest deviceInfoRequest = new DeviceInfoRequest();
            //-----Stub----//

            //Serialize
            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(deviceInfoRequest), String.Empty, "DeviceInfo", String.Empty);

            //Post Request
            String strdeviceInfoResponse = String.Empty;
            WirelessAdvocates.Logger.Log.LogResponse(strdeviceInfoResponse, String.Empty, "DeviceInfo", String.Empty);

            //Parse Request
            deviceInfoResponse = (DeviceInfoResponse)WirelessAdvocates.Utility.DeserializeXML(strdeviceInfoResponse, typeof(DeviceInfoResponse));
            return deviceInfoResponse;

        }

        // API: Inventory Check
        [WebMethod]
        public InventoryCheckRequest InventoryCheck()
        {
            InventoryCheckRequest inventoryCheckRequest = new InventoryCheckRequest();

            inventoryCheckRequest.modelid = ""; // String Min 1 Max 30
            
            return inventoryCheckRequest;

            //InventoryCheckResponse inventoryCheckResponse = new InventoryCheckResponse();

            ////-----Stub----//

            ////Serialize
            //WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(inventoryCheckRequest), String.Empty, "InventoryCheck", String.Empty);

            ////Post Request
            //String strinventoryCheckResponse = String.Empty;
            //WirelessAdvocates.Logger.Log.LogResponse(strinventoryCheckResponse, String.Empty, "InventoryCheck", String.Empty);

            ////Parse Request
            //inventoryCheckResponse = (InventoryCheckResponse)WirelessAdvocates.Utility.DeserializeXML(strinventoryCheckResponse, typeof(InventoryCheckResponse));
            //return inventoryCheckResponse;

        }

        // API: NPA NXX
        //[WebMethod]
        public NpaNxxRequest NpaNxx()
        {
            NpaNxxRequest npaNxxRequest = new NpaNxxRequest();

            npaNxxRequest.activationzipcode = String.Empty; // String Length 5 or 9
            
            return npaNxxRequest;

            /*NpaNxxResponse npaNxxResponse = new NpaNxxResponse();
              
            //-----Stub----//


            //Serialize
            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(npaNxxRequest), String.Empty, "NpaNxx", String.Empty);

            //Post Request
            String strnpaNxxReposnse = String.Empty;
            WirelessAdvocates.Logger.Log.LogResponse(strnpaNxxReposnse, String.Empty, "NpaNxx", String.Empty);

            //Parse Request
            npaNxxResponse = (NpaNxxResponse)WirelessAdvocates.Utility.DeserializeXML(strnpaNxxReposnse, typeof(NpaNxxResponse));
            return npaNxxResponse;
            */
        }

        // API: Options
        //[WebMethod]
        public OptionsResponse Options()
        {
            OptionsRequest optionsRequest = new OptionsRequest();


            return optionsRequest;
             /* //-----Stub----//

            OptionsResponse optionsResponse = new OptionsResponse();

            //Serialize
            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(optionsRequest), String.Empty, "Options", String.Empty);

            //Post Request
            String stroptionsResponse = String.Empty;
            WirelessAdvocates.Logger.Log.LogResponse(stroptionsResponse, String.Empty, "Options", String.Empty);

            //Parse Request
            optionsResponse = (OptionsResponse)WirelessAdvocates.Utility.DeserializeXML(stroptionsResponse, typeof(OptionsResponse));
            return optionsResponse;
              * */
        }

        // API: Plans
        //[WebMethod]
        public PlansResponse Plans()
        {
            PlansResponse plansResponse = new PlansResponse();
            PlansRequest plansRequest = new PlansRequest();
            //-----Stub----//

            //Serialize
            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(plansRequest), String.Empty, "Plans", String.Empty);

            //Post Request
            String strplansResponse = String.Empty;
            WirelessAdvocates.Logger.Log.LogResponse(strplansResponse, String.Empty, "Plans", String.Empty);

            //Parse Request
            plansResponse = (PlansResponse)WirelessAdvocates.Utility.DeserializeXML(strplansResponse, typeof(PlansResponse));
            return plansResponse;

            
        }

        // API: Port Eligibility
        // API: Port Status
        //[WebMethod]
        public PortRequest PortEligibilityNStatus()
        {
            PortRequest portRequest = new PortRequest();

            portRequest.portinnumber = "Test Port in number"; // String Min 1 Max Unbounded

            /*PortResponse portResponse = new PortResponse();
            //-----Stub----//

            //Serialize
            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(portRequest), String.Empty, "PortEligibilityNStatus", String.Empty);

            //Post Request
            String strplansResponse = String.Empty;
            WirelessAdvocates.Logger.Log.LogResponse(strplansResponse, String.Empty, "PortEligibilityNStatus", String.Empty);

            //Parse Request
            portResponse = (PortResponse)WirelessAdvocates.Utility.DeserializeXML(strplansResponse, typeof(PlansResponse));
            return portResponse;
             * */

            return portRequest;
        }

        // API: Pre Authorization
        //[WebMethod]
        public PreAuthorizationResponse PreAuthorization()
        {
            PreAuthorizationResponse preAuthorizationResponse = new PreAuthorizationResponse();
            PreAuthorizationRequest preAuthorizationRequest = new PreAuthorizationRequest();
            //-----Stub----//

            //Serialize
            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(preAuthorizationRequest), String.Empty, "PreAuthorization", String.Empty);

            //Post Request
            String strpreAuthorizationResponse = String.Empty;
            WirelessAdvocates.Logger.Log.LogResponse(strpreAuthorizationResponse, String.Empty, "PreAuthorization", String.Empty);

            //Parse Request
            preAuthorizationResponse = (PreAuthorizationResponse)WirelessAdvocates.Utility.DeserializeXML(strpreAuthorizationResponse, typeof(PlansResponse));
            return preAuthorizationResponse;
        
        }

        // API: Security Question
        //[WebMethod]
        public SecurityQuestionRequest SecurityQuestion()
        {
            SecurityQuestionRequest securityQuestionRequest = new SecurityQuestionRequest();

          //  securityQuestionRequest.

            return securityQuestionRequest;

            /*
            //-----Stub----//

            // SecurityQuestionResponse securityQuestionResponse = new SecurityQuestionResponse();

            //Serialize
            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(securityQuestionRequest), String.Empty, "SecurityQuestion", String.Empty);

            //Post Request
            String strsecurityQuestionResponse = String.Empty;
            WirelessAdvocates.Logger.Log.LogResponse(strsecurityQuestionResponse, String.Empty, "SecurityQuestion", String.Empty);

            //Parse Request
            securityQuestionResponse = (SecurityQuestionResponse)WirelessAdvocates.Utility.DeserializeXML(strsecurityQuestionResponse, typeof(PlansResponse));
            return securityQuestionResponse;
             * */

        }

        // API: Service Validation
        //[WebMethod]
        public ServiceValidationRequest ServiceValidation()
        {
            ServiceValidationRequest serviceValidationRequest = new ServiceValidationRequest();
            
            /*
            //-----Stub----//

            ServiceValidationResponse serviceValidationResponse = new ServiceValidationResponse();
            //Serialize
            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(serviceValidationRequest), String.Empty, "ServiceValidation", String.Empty);

            //Post Request
            String strserviceValidationResponse = String.Empty;
            WirelessAdvocates.Logger.Log.LogResponse(strserviceValidationResponse, String.Empty, "ServiceValidation", String.Empty);

            //Parse Request
            serviceValidationResponse = (ServiceValidationResponse)WirelessAdvocates.Utility.DeserializeXML(strserviceValidationResponse, typeof(PlansResponse));
            return serviceValidationResponse;
        */
            return serviceValidationRequest;
        }

        // API: Validation
        //[WebMethod]
        public ValidationRequest Validation()
        {
           
            ValidationRequest validationRequest = new ValidationRequest();
            //-----Stub----//
            // ValidationResponse validationResponse = new ValidationResponse();

            return validationRequest;
        }
    }
}
