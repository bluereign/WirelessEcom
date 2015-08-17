using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using SprintCarrierServiceInterface.Interfaces.model.checkOrderStatus;
using SprintCarrierServiceInterface.Interfaces.model.doAccountValidation;
using SprintCarrierServiceInterface.Interfaces.model.doActivateReservedDevice;
using SprintCarrierServiceInterface.Interfaces.model.doActivation;
using SprintCarrierServiceInterface.Interfaces.model.performAuthenticationResendPin;
using SprintCarrierServiceInterface.Interfaces.model.getBillSummary;
using SprintCarrierServiceInterface.Interfaces.model.getCorporateDiscount;
using SprintCarrierServiceInterface.Interfaces.model.doCoverageCheck;
using SprintCarrierServiceInterface.Interfaces.model.doCreditCancel;
using SprintCarrierServiceInterface.Interfaces.model.doDeactivation;
using SprintCarrierServiceInterface.Interfaces.model.getDeviceInfo;
using SprintCarrierServiceInterface.Interfaces.model.doInventoryCheck;
using SprintCarrierServiceInterface.Interfaces.model.getNpaNxx;
using SprintCarrierServiceInterface.Interfaces.model.getOptionsInfo;
using SprintCarrierServiceInterface.Interfaces.model.queryPlansDetailInfo;
using SprintCarrierServiceInterface.Interfaces.model.getPortInInfo;
using SprintCarrierServiceInterface.Interfaces.model.doPreAuthorization;
using SprintCarrierServiceInterface.Interfaces.model.getSecurityQuestion;
using SprintCarrierServiceInterface.Interfaces.model.performServiceValidation;
using SprintCarrierServiceInterface.Interfaces.model.doValidation;
using SprintCarrierServiceInterface.Interfaces.model.doCreditCheck;
using SprintCarrierServiceInterface.Interfaces.controller.PortValidationResponse;
using SprintCarrierServiceInterface.Interfaces.common.PostResponse;
using SprintInterfaces= SprintCarrierServiceInterface.Interfaces;

namespace SprintCarrierServiceInterface.Interfaces.SprintServiceBus
{
    public class SprintServiceBus
    {
        // API: Account Validation
        //public AccountValidationResponse AccountValidation()
        //public AccountValidationResponse AccountValidation(string ReferenceNumber)
        public AccountValidationResponse AccountValidation(int msiSdn, int billingZip, int pin, int ReferenceNumber)
            
        {
            //Create Request
            AccountValidationRequest accountValidationRequest = new AccountValidationRequest();

            accountValidationRequest.billingzip = "98007"; // String 5/9 (Optional)
            //accountValidationRequest.lastname = "last name"; // String Min 2 Max 50 (Optional)
            //accountValidationRequest.secanswer = "secanswer"; //String Min 2 Max 30 (Optional)
            //accountValidationRequest.secpin = "sec pin"; // String Min 2 Max 10 (Optional)
            //accountValidationRequest.singlesubscriberSpecified = true;

            //	Account Validation Request (Customer Account Number)
            accountValidationRequest.Item = "account number";
            accountValidationRequest.ItemElementName = SprintInterfaces.model.doAccountValidation.ItemChoiceType.accountnumber;

            //  Account Validation Request (Customer Cell Phone Number)
            accountValidationRequest.Item = "ref ptn";
            accountValidationRequest.ItemElementName = SprintInterfaces.model.doAccountValidation.ItemChoiceType.referenceptn;
            accountValidationRequest.singlesubscriber = false;

            //  Account Validation Request (Customer Cell Phone Number and Billing Zip)
            accountValidationRequest.Item = "ref ptn";
            accountValidationRequest.ItemElementName = SprintInterfaces.model.doAccountValidation.ItemChoiceType.referenceptn;
            accountValidationRequest.singlesubscriber = true;
            accountValidationRequest.singlesubscriberSpecified = true;
            

            # region accountValidationResponseDECLns
            /*
            AccountValidationResponse accountValidationResponse = new AccountValidationResponse();
            accountValidationResponse.accountstatus = AccountStatus.ACTIVE;
            accountValidationResponse.accountnumber = "Account Number=12345";
            accountValidationResponse.accountinfo = new Interfaces.doAccountValidation.AccountInfo()
            {
                currentsubscribers = 1,
                subscriber = new SprintCarrierServiceInterface.Interfaces.doAccountValidation.Subscriber[1]
                { 
                    new Interfaces.doAccountValidation.Subscriber
                    {
                        priceplancode = "Test priceplancode ",
                        priceplanname = "Test Price plan name",
                        priceplanprice = Convert.ToDecimal(69.99),
                        plantype = SprintCarrierServiceInterface.Interfaces.doAccountValidation.PlanType.ind,
                        phonemodelid = "Test phone model-id",
                        phonename = "Phone name",
                        ptn = "Test ptn",
                        ptnstatus=Interfaces.doAccountValidation.PTNStatus.ACTIVE,
                        initactivationdate = DateTime.Now.Date,
                        contractstartdate=DateTime.Now.Date,
                        contractenddate = DateTime.Now.Date,
                        handsetactivationdate = DateTime.Now.Date,
                        upgrade = new Interfaces.doAccountValidation.UpgradeData
                        {
                            eligible = false,
                            eligibledate = DateTime.Now.Date,
                            eligibletier = new Interfaces.doAccountValidation.EligibleTierData[2]
                                                {
                                                    new Interfaces.doAccountValidation.EligibleTierData()
                                                        { 
                                                            date = DateTime.Now.Date,
                                                            tierlevel = "Test tier level 1"
                                                        },
                                                    new Interfaces.doAccountValidation.EligibleTierData()
                                                        { 
                                                            date=DateTime.Now.Date,
                                                            tierlevel="Test tier level 2"
                                                        } 
                                                },
                        },
                        existingcommittedorder = SprintCarrierServiceInterface.Interfaces.doAccountValidation.YesNoType.N,
                        option = new Interfaces.doAccountValidation.AddOnOptionType[4] 
                        {  
                            new Interfaces.doAccountValidation.AddOnOptionType() { optionname="Option name 1", optioncode="Option code 1"},
                            new Interfaces.doAccountValidation.AddOnOptionType() { optionname="Option name 2", optioncode="Option code 2"},
                            new Interfaces.doAccountValidation.AddOnOptionType() { optionname="Option name 3", optioncode="Option code 3"},
                            new Interfaces.doAccountValidation.AddOnOptionType() { optionname="Option name 4", optioncode="Option code 4"},
                        }
                    }
                }//Subscriber
            };//Account info
             
            accountValidationResponse.billingname = new BillingName()
                {
                    firstname = "first name",
                    lastbusinessname = "last business name"
                };
             
             * AccountValidationResponse accountValidationResponse = new AccountValidationResponse();   
            accountValidationRequest.billingzip = String.Empty;
            // accountValidationRequest.Item=String.Empty;
            // accountValidationRequest.ItemElementName= Interfaces.doAccountValidation.ItemChoiceType.accountnumber;

            // TODO: meid
            accountValidationRequest.lastname = String.Empty; // MIN 2 Max 50 (Optional)
            accountValidationRequest.requesteddevices= String.Empty;
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
            #endregion

             //Serialize
            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(accountValidationRequest), "Sprint", "AccountValidation", ReferenceNumber.ToString());

            try
            {
               // string strNpaNxxResponse = responseXml.getResponse(WirelessAdvocates.Utility.GetAppSetting("SprintHostTest1"), WirelessAdvocates.Utility.SerializeXML(npaNxxRequest));

                // Do Request; returns response.
                string strAccountValidationResponse = @"<account-validation-response xmlns=""http://nextel.com/ovm"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xsi:schemaLocation=""http://nextel.com/ovm http://tdas4208.test.sprint.com:4613/ovm/xsd/ovm-response.xsd"">
            <account-status>ACTIVE</account-status>
            <account-number>122453152</account-number>
            <account-info>
                <current-subscribers>1</current-subscribers>
                <subscriber id=""1"">
                    <price-plan-code>PDSB1234E</price-plan-code>
                    <price-plan-name>Everything Data 450 BlackBerry</price-plan-name>
                    <price-plan-price>69.99</price-plan-price003E
                    <plan-type>ind</plan-type>
                    <phone-model-id>S8330RIMAR</phone-model-id>
                    <phone-name>Blackberry Curve 8330 (Red)</phone-name>
                    <ptn>5125730193</ptn>
                    <ptn-status>ACTIVE</ptn-status>
                    <init-activation-date>2009-09-21</init-activation-date>
                    <contract-start-date>2009-09-21</contract-start-date>
                    <contract-end-date>2011-09-20</contract-end-date>
                    <handset-activation-date>2009-09-21</handset-activation-date>
                    <upgrade>
                        <eligible>false</eligible>
                        <eligible-date>2010-10-01</eligible-date>
                        <eligible-tier>
                            <date>2010-10-01</date>
                            <tier-level>1</tier-level>
                        </eligible-tier>
                        <eligible-tier>
                            <date>2011-08-01</date>
                            <tier-level>2</tier-level>
                        </eligible-tier>
                    </upgrade>
                    <existing-committed-order>N</existing-committed-order>
                    <option>
                        <option-name>Unlimited Nights&Weekends-7pm</option-name>
                        <option-code>NWUNL7PM</option-code>
                        <option-price>0.0</option-price>
                    </option>
                    <option>
                        <option-name>Unlimited Night & Wknd Min 9pm</option-name>
                        <option-code>NWUNL9PM</option-code>
                        <option-price>0.0</option-price>
                    </option>
                    <option>
                        <option-name>Sprint Navigation</option-name>
                        <option-code>PDSNAVCO</option-code>
                        <option-price>0.0</option-price>
                    </option>
                    <option>
                        <option-name>Data Usage</option-name>
                        <option-code>UNTETH</option-code>
                        <option-price>0.0</option-price>
                    </option>
                </subscriber>
            </account-info>
            <billing-name>
                <first-name>Test</first-name>
                <last-business-name>Test</last-business-name>
            </billing-name>
        </account-validation-response>
";
                strAccountValidationResponse = strAccountValidationResponse.Trim();

                //Deserialize
                AccountValidationResponse response = (AccountValidationResponse)WirelessAdvocates.Utility.DeserializeXML(strAccountValidationResponse, typeof(AccountValidationResponse));

                //Log
                WirelessAdvocates.Logger.Log.LogResponse(WirelessAdvocates.Utility.SerializeXML(response), "Sprint", "AccountValidation", ReferenceNumber.ToString());

                //return response;
                return response;
            }
            catch(Exception e) {
                throw new Exception(e.Message);
            }
        }

        // API: Activate Reserved Device
        public ActivateReservedDeviceRequest ActivateReservedDevice()
        {
            // Create Request
            ActivateReservedDeviceRequest activateReservedDeviceRequest = new ActivateReservedDeviceRequest();

            string[] sp_o_id = new string[2];
            sp_o_id[0] = "sprint-order-id"; // String pattern: [a-z]{2}-[a-z0-9]{4,5}-\d+ (Optional)
            sp_o_id[1] = "";  // String Min 1 Max 24 (Optional)

            if (sp_o_id[0] == "") // when sprint-order-id is blank
            {
                activateReservedDeviceRequest.Item = sp_o_id[1];
                activateReservedDeviceRequest.ItemElementName = SprintCarrierServiceInterface.Interfaces.model.doActivateReservedDevice.ItemChoiceType.orderid;

            }
            if (sp_o_id[1] == "") // when order-id is blank
            {
                activateReservedDeviceRequest.Item = sp_o_id[0];
                activateReservedDeviceRequest.ItemElementName = SprintCarrierServiceInterface.Interfaces.model.doActivateReservedDevice.ItemChoiceType.sprintorderid;

            }

            activateReservedDeviceRequest.Item = sp_o_id[0] + sp_o_id[1];

            string[] stValues = new string[1];

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
        public ActivationRequest Activation()
        {
            // Create Request
            ActivationRequest activationRequest = new ActivationRequest();

            Interfaces.model.doActivation.Address ccAddress = new Interfaces.model.doActivation.Address();
            Interfaces.model.doActivation.OrderInfoType orderInfoType_Object = new Interfaces.model.doActivation.OrderInfoType();
            Interfaces.model.doActivation.OrderShippingType oderShippingType_Object = new Interfaces.model.doActivation.OrderShippingType();
            Interfaces.model.doActivation.CreditCard creditCard_Object = new Interfaces.model.doActivation.CreditCard();
            Interfaces.model.doActivation.ServiceType serviceType_Object = new Interfaces.model.doActivation.ServiceType();
            Interfaces.model.doActivation.ShippingType shippingType_Object = new Interfaces.model.doActivation.ShippingType();

            //Order

            // activationRequest.affiliatename = "Catalog says no longer used"; //String
            activationRequest.agentcode = "agent code"; // String Min 1 Max 8  (Optional)
            activationRequest.defaultservicechange = false; // Boolean (Optional)
            // activationRequest.defaultservicechangeSpecified = false;


            object[] ccRequestedvalues = new object[5];

            ccRequestedvalues[0] = ccAddress;
            ccRequestedvalues[1] = "Test card-handle";
            ccRequestedvalues[2] = "";

            activationRequest.Item = ccRequestedvalues;

            //activationRequest.depositpayment= needs type,number, security code, expiration, address 

            activationRequest.ebillemail = " Test ebillemail ";
            activationRequest.emailaddress = " Test email address ";
            //activationRequest.equipmentpayment= needs Type, number, security code, expiration, address

            //activationRequest.equipmentpaymenttype= needs CC / INV 

            activationRequest.equipmentpaymenttypeSpecified = false;
            activationRequest.nextelfulfilled = false;
            activationRequest.nextelfulfilledSpecified = false;
            //activationRequest.order= needs Attribute type, account-number, reference-ptn, subscriber-id
            activationRequest.orderdate = DateTime.Now;
            activationRequest.orderdateSpecified = false;
            activationRequest.orderreferraldcnumber = "Test order referral dc number";

            //activationRequest.ordershipping= needs  method, vendor, requested-ship-date

            //activationRequest.rccppayment= needs type, number, security code, expiration, address

            activationRequest.rccpwanted = false;
            activationRequest.rccpwantedSpecified = false;
            activationRequest.saleschannel = "Test saleschannel";
            activationRequest.secpin = "Test secpin";
            //activationRequest.service= needs Plan{}, address, ec-ref-1, ec-ref-2, ec-ref-3, ec-ref-4, urban-id, fleet-id, service-phone-number, plan-order-key, feature{}, phone{}, phone-number-or-range, effective-date, effective-bill-cycle
            //activationRequest.shipping= needs company-name, Name {}, address{}, home-phone, work-phone, alternate-phone, email-address, waive-shipping-fee
            activationRequest.statusurl = "Test statusurl";
            activationRequest.summarybill = false;
            activationRequest.summarybillSpecified = false;

            //activationRequest.depositpayment=

            return activationRequest;

            /*
            
             * ActivationResponse activationResponse = new ActivationResponse();

             * activationResponse.accountnumber = String.Empty;
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

            */
        }

        // API: Authenticate PIN/Resend PIN
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

            authenticationResendPinRequest.ItemsElementName = new SprintCarrierServiceInterface.Interfaces.model.performAuthenticationResendPin.ItemsChoiceType[4] { 
                SprintCarrierServiceInterface.Interfaces.model.performAuthenticationResendPin.ItemsChoiceType.authenticatecustomer,
                SprintCarrierServiceInterface.Interfaces.model.performAuthenticationResendPin.ItemsChoiceType.resendpin,
                SprintCarrierServiceInterface.Interfaces.model.performAuthenticationResendPin.ItemsChoiceType.secanswer,
                SprintCarrierServiceInterface.Interfaces.model.performAuthenticationResendPin.ItemsChoiceType.secpin
            };

            authenticationResendPinRequest.Item = "account-number";
            authenticationResendPinRequest.ItemElementName = Interfaces.model.performAuthenticationResendPin.ItemChoiceType.accountnumber;

            authenticationResendPinRequest.Item = "reference-ptn";
            authenticationResendPinRequest.ItemElementName = Interfaces.model.performAuthenticationResendPin.ItemChoiceType.referenceptn;

            /* WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(authenticationResendPinRequest), String.Empty, "AuthenticationResendPin", String.Empty);

             string strAuthenticationResendPinResponse = String.Empty;

             authenticationResendPinResponse = (AuthenticationResendPinResponse)WirelessAdvocates.Utility.DeserializeXML(strAuthenticationResendPinResponse, typeof(AuthenticationResendPinResponse));
             */
            return authenticationResendPinRequest;
        }

        // API: Bill Summary
        public BillSummaryRequest BillSummary()
        {
            BillSummaryRequest billSummaryRequest = new BillSummaryRequest();
            BillSummaryResponse billSummaryResponse = new BillSummaryResponse();
            BillSummaryPlan billSummaryPlan = new BillSummaryPlan();

            billSummaryPlan.code = String.Empty; // String: 10 (Optional)
            billSummaryPlan.id = String.Empty;
            billSummaryPlan.subscribercount = String.Empty; // Integer (Optional)
            SprintCarrierServiceInterface.Interfaces.model.getBillSummary.Feature planFeature = new SprintCarrierServiceInterface.Interfaces.model.getBillSummary.Feature(); // Structure: Min: 0 Max: 20

            planFeature.featurecode = String.Empty;// String: 10

            billSummaryPlan.feature = new SprintCarrierServiceInterface.Interfaces.model.getBillSummary.Feature[] {
                planFeature
            };

            object[] requestValues = new object[6];

            requestValues[0] = "test1"; // account number --> String length: 9 (Optional)
            requestValues[1] = "test2"; // activation zipcode --> String length: 5 or 9 (Optional)
            requestValues[2] = SprintCarrierServiceInterface.Interfaces.model.getBillSummary.OrderType.NEW; // String Enumeration
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

            billSummaryRequest.ItemsElementName = new SprintCarrierServiceInterface.Interfaces.model.getBillSummary.ItemsChoiceType[6] { 
                SprintCarrierServiceInterface.Interfaces.model.getBillSummary.ItemsChoiceType.accountnumber, 
                SprintCarrierServiceInterface.Interfaces.model.getBillSummary.ItemsChoiceType.activationzipcode,
                SprintCarrierServiceInterface.Interfaces.model.getBillSummary.ItemsChoiceType.ordertype,
                SprintCarrierServiceInterface.Interfaces.model.getBillSummary.ItemsChoiceType.plan,
                SprintCarrierServiceInterface.Interfaces.model.getBillSummary.ItemsChoiceType.referenceptn,
                SprintCarrierServiceInterface.Interfaces.model.getBillSummary.ItemsChoiceType.secondbill
            };

            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(billSummaryRequest), String.Empty, "BillSummary", String.Empty);

            string strBillSummaryResponse = String.Empty;

            //  billSummaryResponse = (BillSummaryResponse)WirelessAdvocates.Utility.DeserializeXML(strBillSummaryResponse, typeof(BillSummaryResponse));

            return billSummaryRequest;
        }

        // API: Corporate Discount
        public CorporateDiscountRequest CorporateDiscount()
        {
            CorporateDiscountRequest corporateDiscountRequest = new CorporateDiscountRequest();
            CorporateDiscountResponse corporateDiscountResponse = new CorporateDiscountResponse();

            object[] CDvalues = new object[6];
            {
                CDvalues[0] = "Acc no"; // String length:10 (Optional)
                CDvalues[1] = "integer val=10"; // Integer (Optional)
                CDvalues[2] = "CorpGovId"; // String Min 1 Max 20 (Optional)
                CDvalues[3] = false; // Boolean (Optional)
                CDvalues[4] = "master-company-name"; // String Min 2 Max 128 (Optional)
                CDvalues[5] = "reference-ptn"; // String length = 10
            }

            corporateDiscountRequest.Items = new object[6]   
            {
                CDvalues[0],
                CDvalues[1],
                CDvalues[2],
                CDvalues[3],
                CDvalues[4],
                CDvalues[5]
            };

            corporateDiscountRequest.ItemsElementName = new Interfaces.model.getCorporateDiscount.ItemsChoiceType[6]
            {
                SprintCarrierServiceInterface.Interfaces.model.getCorporateDiscount.ItemsChoiceType.accountnumber,
                SprintCarrierServiceInterface.Interfaces.model.getCorporateDiscount.ItemsChoiceType.companyid,
                SprintCarrierServiceInterface.Interfaces.model.getCorporateDiscount.ItemsChoiceType.corpgovid,
                SprintCarrierServiceInterface.Interfaces.model.getCorporateDiscount.ItemsChoiceType.employeeproof,
                SprintCarrierServiceInterface.Interfaces.model.getCorporateDiscount.ItemsChoiceType.mastercompanyname,
                SprintCarrierServiceInterface.Interfaces.model.getCorporateDiscount.ItemsChoiceType.referenceptn
            };

            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(corporateDiscountRequest), String.Empty, "BillSummary", String.Empty);

            string strCorporateDiscountResponse = String.Empty;

            corporateDiscountResponse = (CorporateDiscountResponse)WirelessAdvocates.Utility.DeserializeXML(strCorporateDiscountResponse, typeof(CorporateDiscountResponse));

            return corporateDiscountRequest;
        }

        // API: Coverage Check
        public CoverageCheckRequest CoverageCheck()
        {
            CoverageCheckRequest coverageCheckRequest = new CoverageCheckRequest();
            CoverageCheckResponse coverageCheckResponse = new CoverageCheckResponse();

            string[] serviceZipCode = new string[2];
            {
                serviceZipCode[1] = "01234 - 5678";
            }

            coverageCheckRequest.servicezip = serviceZipCode;

            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(coverageCheckRequest), String.Empty, "CoverageCheck", String.Empty);

            string strCoverageCheckResponse = String.Empty;

            coverageCheckResponse = (CoverageCheckResponse)WirelessAdvocates.Utility.DeserializeXML(strCoverageCheckResponse, typeof(CoverageCheckResponse));

            WirelessAdvocates.Logger.Log.LogResponse(strCoverageCheckResponse, String.Empty, "CoverageCheck", String.Empty);

            return coverageCheckRequest;
        }

        // API: Credit Cancel
        public CreditCancelRequest CreditCancel()
        {
            CreditCancelRequest creditCancelRequest = new CreditCancelRequest();
            CreditCancelResponse creditCancelResponse = new CreditCancelResponse();

            Interfaces.model.doCreditCancel.Name name = new Interfaces.model.doCreditCancel.Name();

            name.sirname = "Test Sirname";    //String Min 1 Max 5  (Optional)
            name.firstname = "Test firstname";  //String Min 1 Max 35
            name.middleinitial = "Test middleinitial"; //String length: 1
            name.lastname = "Test lastname"; //String Min 2 Max 35
            name.suffix = "Test suffix";   //String Min 1 Max 5

            creditCancelRequest.name = name;

            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(creditCancelRequest), String.Empty, "CreditCancel", String.Empty);

            string strCreditCancelResponse = String.Empty;

            creditCancelResponse = (CreditCancelResponse)WirelessAdvocates.Utility.DeserializeXML(strCreditCancelResponse, typeof(CoverageCheckResponse));

            WirelessAdvocates.Logger.Log.LogResponse(strCreditCancelResponse, String.Empty, "CreditCancel", String.Empty);

            return creditCancelRequest;
        }

        // API: Credit Check
        public CreditResponse CreditCheck()
        {
            CreditRequest creditRequest = new CreditRequest();
            creditRequest.activationzipcode = String.Empty;
            creditRequest.ccpincode = String.Empty;
            creditRequest.dateofbirth = DateTime.Now;
            creditRequest.dateofbirthSpecified = true;
            creditRequest.debugscore = String.Empty;
            creditRequest.handsetcount = 1;
            creditRequest.intlhandsetcount = 1;
            creditRequest.intlhandsetcountSpecified = true;
            creditRequest.Item = String.Empty;
            creditRequest.language = String.Empty;
            creditRequest.passcode = String.Empty;
            creditRequest.programcode = String.Empty;
            creditRequest.repid = String.Empty;
            creditRequest.secanswer = String.Empty;
            creditRequest.secpin = String.Empty;
            creditRequest.secquestioncode = String.Empty;
            creditRequest.subscriberagreement = true;

            //Serialize
            //   WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(creditRequest), String.Empty, "CreditCheck", String.Empty);

            // Do Request; returns response.
            string strcreditResponse = @"<credit-response xmlns=""http://nextel.com/ovm"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xsi:schemaLocation=""http://nextel.com/ovm http://oebg-http.nextel.com:8006/ovm/xsd/ovm-response.xsd"">
            <nextel-order-id>oa-teoa-123456789</nextel-order-id>
            <result>NO_DEPOSIT_REQUIRED_SL_REQUIRED</result>
            <app-number>000E8637267C</app-number>
            <tiered-deposit id=""1"">
                <deposit-amount>0.0</deposit-amount>
                <spending-limit-amount>600.0</spending-limit-amount>
            </tiered-deposit>
            <tiered-deposit id=""2"">
                <deposit-amount>0.0</deposit-amount>
                <spending-limit-amount>0.0</spending-limit-amount>
            </tiered-deposit>
            <tiered-deposit id=""3"">
                <deposit-amount>0.0</deposit-amount>
                <spending-limit-amount>0.0</spending-limit-amount>
            </tiered-deposit>
            <tiered-deposit id=""4"">
                <deposit-amount>0.0</deposit-amount>
                <spending-limit-amount>0.0</spending-limit-amount>
            </tiered-deposit>
            <tiered-deposit id=""5"">
                <deposit-amount>0.0</deposit-amount>
                <spending-limit-amount>0.0</spending-limit-amount>
            </tiered-deposit>
            <total-deposit>0.0</total-deposit>
            <number-handsets-approved>5</number-handsets-approved>
            <bill-to-account-allowed>false</bill-to-account-allowed>
            <hybrid-phone-allowed>true</hybrid-phone-allowed>
            <order type=""NEW""/>
            <customer-type>INDIVIDUAL</customer-type>
            <billing>
                <name>
                    <first-name>Test</first-name>
                    <last-name>Test</last-name>
                </name>
                <address>
                    <street-address-1>2000 Edmund Halley Drive</street-address-1>
                    <city>Reston</city>
                    <state-code>VA</state-code>
                    <zip-code>20191</zip-code>
                </address>
                <home-phone>7034331234</home-phone>
            </billing>
            <date-of-birth>1981-01-27</date-of-birth>
        </credit-response>";

            strcreditResponse = strcreditResponse.Trim();

            //Deserialize
            CreditResponse creditResponse = (CreditResponse)WirelessAdvocates.Utility.DeserializeXML(strcreditResponse, typeof(CreditResponse));

            //Log
            WirelessAdvocates.Logger.Log.LogResponse(WirelessAdvocates.Utility.SerializeXML(strcreditResponse), String.Empty, "CreditCheck", String.Empty);

            return creditResponse;

        }
        
        // API: Credit Check


        //public CreditResponse CreditCheck2(string billingName, string serviceZipCode, string contactInfo, string billingContactCredentials, string numberOfLines, string existingCustomerMDN, string referenceNumber)
        public CreditResponse CreditCheck2(List<SprintInterfaces.controller.CheckCreditResponse.CheckCreditResponse.Names> billingName, string servicezipcode, List<SprintInterfaces.controller.CheckCreditResponse.CheckCreditResponse.PersonalInfo> contactInfo, List<SprintInterfaces.controller.CheckCreditResponse.CheckCreditResponse.PersonalCreds> billingContactCredentials, int numberOfLines, string existingCustomerMDN, string referenceNumber)
        //public CreditResponse CreditCheck2(string zipcode)
       
        {
            CreditRequest creditRequest = new CreditRequest();
            /*
              creditRequest.activationzipcode = zipcode;
              creditRequest.billing.name.firstname = Name;
              creditRequest.billing.emailaddress = PersonalCreds;
              creditRequest.driverslicense.id = PersonalCreds;
             * */

            creditRequest.intlhandsetcountSpecified = true;

            //creditRequest.intlhandsetcount = Convert.ToByte(NoofLines);

            //creditRequest.billing.name = new model.doCreditCheck.Name(){ firstname="", lastname="", middleinitial="", sirname="", suffix=""};
           // creditRequest.billing.emailaddress=PersonalInfo;
            
            //creditRequest.driverslicense = new DriversLicense() { expirationdate = DateTime.Now, expirationdateSpecified = true, id = "", state = "" };

                #region CCDeclarations

            Interfaces.model.doCreditCheck.Address billingAddress = new Interfaces.model.doCreditCheck.Address();
            Interfaces.model.doCreditCheck.Name billingName1 = new Interfaces.model.doCreditCheck.Name();
            Interfaces.model.doCreditCheck.PhoneExtType billingWorkPhone = new Interfaces.model.doCreditCheck.PhoneExtType();

            BillingInfoType billing = new BillingInfoType();
            ContactType billingContact = new ContactType();
            Interfaces.model.doCreditCheck.Name billingContactName = new Interfaces.model.doCreditCheck.Name();
            Interfaces.model.doCreditCheck.CorporateGovernmentInfo corpGovInfo = new Interfaces.model.doCreditCheck.CorporateGovernmentInfo();
            DriversLicense driversLicense = new DriversLicense();
            Interfaces.model.doCreditCheck.OrderInfoType order = new Interfaces.model.doCreditCheck.OrderInfoType();
            PhysicalInfoType physical = new PhysicalInfoType();
            Interfaces.model.doCreditCheck.Address physicalAddress = new Interfaces.model.doCreditCheck.Address();

            creditRequest.activationzipcode = String.Empty;
            //creditRequest.billing = billing;
            creditRequest.billing = new BillingInfoType()
            {
                    accountemailaction = Interfaces.model.doCreditCheck.EmailAction.A,
                    accountemailactionSpecified = true,
                    address = billingAddress,
                    alternatephone = String.Empty,
                    besttimetocallalternate = BestTimeToCall.A,
                    besttimetocallalternateSpecified = true,
                    besttimetocallhome = BestTimeToCall.A,
                    besttimetocallhomeSpecified = true,
                    besttimetocallwork = BestTimeToCall.A,
                    besttimetocallworkSpecified = true,
                    companyname = String.Empty,
                    ebill = String.Empty,
                    emailaddress = String.Empty,
                    homephone = String.Empty,
                    marketingpreference = MarketingPrefType.N,
                    marketingpreferenceSpecified = true,
                    name = billingName1,
                    workphone = billingWorkPhone
            };
            creditRequest.ccpincode = String.Empty;
            creditRequest.contact = new ContactType()
            {
                name = new Interfaces.model.doCreditCheck.Name()
                {
                    additionalline = String.Empty,
                    firstname = String.Empty,
                    lastname = String.Empty,
                    middleinitial = String.Empty,
                    sirname = String.Empty,
                    suffix = String.Empty,
                }
            };
            //creditRequest.corpgovinfo = corpGovInfo;
            creditRequest.corpgovinfo = new Interfaces.model.doCreditCheck.CorporateGovernmentInfo()
            {
                    corpgovid = String.Empty,
                    dacid = new uint(),
                    dacidSpecified = true,
                    employeeid = String.Empty,
                    equipmentpo = String.Empty,
                    nodeid = new uint(),
                    nodeidSpecified = true,
                    servicecostcenter = String.Empty,
                    servicepo = String.Empty,
                    taxexemptid = String.Empty,
            };
            creditRequest.customertype = Interfaces.model.doCreditCheck.CustomerType.INDIVIDUAL;
            creditRequest.dateofbirth = DateTime.Now;
            creditRequest.dateofbirthSpecified = true;
            creditRequest.debugscore = String.Empty;
            // creditRequest.driverslicense = driversLicense;
            creditRequest.driverslicense = new DriversLicense()
            {
                expirationdate = DateTime.Now,
                expirationdateSpecified = true,
                id = String.Empty,
                state = String.Empty
            };
            creditRequest.handsetcount = 0;
            creditRequest.identificationmethod = new IdentificationMethod()
            {
                primaryid = new IdentificationData()
                {
                    idcode = "idcode-p",
                    idexpdt = DateTime.Now,
                    idexpdtSpecified = true,
                    idtext1 = "idtext1-p",
                    idtext2 = "idtext2-p"
                },
                secondaryid = new IdentificationData()
                {
                    idcode = "idcode-s",
                    idexpdt = DateTime.Now,
                    idexpdtSpecified = true,
                    idtext1 = "idtext1-s",
                    idtext2 = "idtext2-s"
                }
            };
            creditRequest.intlhandsetcount = 0;
            creditRequest.intlhandsetcountSpecified = true;
            creditRequest.ItemElementName = Interfaces.model.doCreditCheck.ItemChoiceType1.federaltaxid;
            creditRequest.Item = "Test federal-tax id";
            creditRequest.language = String.Empty;
            //creditRequest.order = order;
            creditRequest.passcode = String.Empty;
            creditRequest.physical = physical;
            creditRequest.programcode = String.Empty;
            creditRequest.repid = String.Empty;
            creditRequest.secanswer = String.Empty;
            creditRequest.secpin = String.Empty;
            creditRequest.secquestioncode = String.Empty;
            creditRequest.subscriberagreement = true;

            object[] CCrequestValues = new object[6];
            {
                CCrequestValues[0] = "Test ST Add1"; // street-address-1 --> String Min 1 Max 50 
                CCrequestValues[1] = "Test ST Add2"; // street-address-2 --> String Min 1 Max 50 (Optional)
                CCrequestValues[2] = "Test City"; //City --> String Min 1 Max 50
                CCrequestValues[3] = "TestStateCode"; // String --> String[A-Z] length=2
                CCrequestValues[4] = "TestZipCode"; // String --> length=5 or 9
                CCrequestValues[5] = "TestCountryCode"; // String -->Enumeration (Optional)
            }

            billingAddress.Items = new object[6]    {
                // Add Values
                CCrequestValues[0],
                CCrequestValues[1],
                CCrequestValues[2],
                CCrequestValues[3],
                CCrequestValues[4],
                CCrequestValues[5]
            };

            billingAddress.ItemsElementName = new Interfaces.model.doCreditCheck.ItemsChoiceType[6]   {
                // Add Items   
                SprintCarrierServiceInterface.Interfaces.model.doCreditCheck.ItemsChoiceType.streetaddress1,
                SprintCarrierServiceInterface.Interfaces.model.doCreditCheck.ItemsChoiceType.streetaddress2,
                SprintCarrierServiceInterface.Interfaces.model.doCreditCheck.ItemsChoiceType.city,
                SprintCarrierServiceInterface.Interfaces.model.doCreditCheck.ItemsChoiceType.statecode,
                SprintCarrierServiceInterface.Interfaces.model.doCreditCheck.ItemsChoiceType.zipcode,
                SprintCarrierServiceInterface.Interfaces.model.doCreditCheck.ItemsChoiceType.countrycode
            };

            billingName1.additionalline = String.Empty;
            billingName1.firstname = String.Empty;
            billingName1.lastname = String.Empty;
            billingName1.middleinitial = String.Empty;
            billingName1.sirname = String.Empty;
            billingName1.suffix = String.Empty;

            billingWorkPhone.ext = String.Empty;
            billingWorkPhone.Value = String.Empty;
            billing.accountemailaction = Interfaces.model.doCreditCheck.EmailAction.A;
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
            billing.name = billingName1;
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
            corpGovInfo.dacidSpecified = true;
            corpGovInfo.employeeid = String.Empty;
            corpGovInfo.equipmentpo = String.Empty;
            corpGovInfo.nodeid = new uint();
            corpGovInfo.nodeidSpecified = true;
            corpGovInfo.servicecostcenter = String.Empty;
            corpGovInfo.servicepo = String.Empty;
            corpGovInfo.taxexemptid = String.Empty;

            driversLicense.expirationdate = DateTime.Now;
            driversLicense.expirationdateSpecified = true;
            driversLicense.id = String.Empty;
            driversLicense.state = String.Empty;

            order.ipaddress = String.Empty;
            order.Item = String.Empty;
            order.Item = "";
            order.ItemElementName = new Interfaces.model.doCreditCheck.ItemChoiceType();
            //order.ItemElementName = ?;
            //order.type = ?;
            order.webprofileid = String.Empty;

            object[] PArequestValues = new object[6];

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

            physicalAddress.ItemsElementName = new Interfaces.model.doCreditCheck.ItemsChoiceType[6]   {
                // Add Items  
                SprintCarrierServiceInterface.Interfaces.model.doCreditCheck.ItemsChoiceType.streetaddress1,
                SprintCarrierServiceInterface.Interfaces.model.doCreditCheck.ItemsChoiceType.streetaddress2,
                SprintCarrierServiceInterface.Interfaces.model.doCreditCheck.ItemsChoiceType.city,
                SprintCarrierServiceInterface.Interfaces.model.doCreditCheck.ItemsChoiceType.statecode,
                SprintCarrierServiceInterface.Interfaces.model.doCreditCheck.ItemsChoiceType.zipcode,
                SprintCarrierServiceInterface.Interfaces.model.doCreditCheck.ItemsChoiceType.countrycode
            };

            physical.address = physicalAddress;
            #endregion
           
            //Serialize
            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(creditRequest), "Sprint", "CreditCheck2", String.Empty);
            try
            {
            // Do Request; returns response.
            string strcreditResponse = @"<credit-response xmlns=""http://nextel.com/ovm"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xsi:schemaLocation=""http://nextel.com/ovm http://oebg-http.nextel.com:8006/ovm/xsd/ovm-response.xsd"">
            <nextel-order-id>oa-teoa-123456789</nextel-order-id>
            <result>NO_DEPOSIT_REQUIRED_SL_REQUIRED</result>
            <app-number>000E8637267C</app-number>
            <tiered-deposit id=""1"">
                <deposit-amount>0.0</deposit-amount>
                <spending-limit-amount>600.0</spending-limit-amount>
            </tiered-deposit>
            <tiered-deposit id=""2"">
                <deposit-amount>0.0</deposit-amount>
                <spending-limit-amount>0.0</spending-limit-amount>
            </tiered-deposit>
            <tiered-deposit id=""3"">
                <deposit-amount>0.0</deposit-amount>
                <spending-limit-amount>0.0</spending-limit-amount>
            </tiered-deposit>
            <tiered-deposit id=""4"">
                <deposit-amount>0.0</deposit-amount>
                <spending-limit-amount>0.0</spending-limit-amount>
            </tiered-deposit>
            <tiered-deposit id=""5"">
                <deposit-amount>0.0</deposit-amount>
                <spending-limit-amount>0.0</spending-limit-amount>
            </tiered-deposit>
            <total-deposit>0.0</total-deposit>
            <number-handsets-approved>5</number-handsets-approved>
            <bill-to-account-allowed>false</bill-to-account-allowed>
            <hybrid-phone-allowed>true</hybrid-phone-allowed>
            <order type=""NEW""/>
            <customer-type>INDIVIDUAL</customer-type>
            <billing>
                <name>
                    <first-name>Test</first-name>
                    <last-name>Test</last-name>
                </name>
                <address>
                    <street-address-1>2000 Edmund Halley Drive</street-address-1>
                    <city>Reston</city>
                    <state-code>VA</state-code>
                    <zip-code>20191</zip-code>
                </address>
                <home-phone>7034331234</home-phone>
            </billing>
            <date-of-birth>1981-01-27</date-of-birth>
        </credit-response>";

            strcreditResponse = strcreditResponse.Trim();

            //Deserialize
            CreditResponse creditResponse = (CreditResponse)WirelessAdvocates.Utility.DeserializeXML(strcreditResponse, typeof(CreditResponse));

            //Log
            WirelessAdvocates.Logger.Log.LogResponse(WirelessAdvocates.Utility.SerializeXML(strcreditResponse),"Sprint", "CreditCheck2", String.Empty);

            return creditResponse;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        // API: Deactivation
        public DeactivationResponse Deactivation()
        {
            DeactivationResponse deactivationResponse = new DeactivationResponse();
            DeactivationRequest deactivationRequest = new DeactivationRequest();

            //-----Stub----//

            //Serialize
            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(deactivationRequest), String.Empty, "Deactivation", String.Empty);

            //Post Request
            String strdeactivationReposnse = String.Empty;
            WirelessAdvocates.Logger.Log.LogResponse(strdeactivationReposnse, String.Empty, "Deactivation", String.Empty);

            //Parse Request
            deactivationResponse = (DeactivationResponse)WirelessAdvocates.Utility.DeserializeXML(strdeactivationReposnse, typeof(DeactivationResponse));
            return deactivationResponse;

        }

        // API: Device Info
        public DeviceInfoRequest DeviceInfo()
        {
            DeviceInfoResponse deviceInfoResponse = new DeviceInfoResponse();
            DeviceInfoRequest deviceInfoRequest = new DeviceInfoRequest();

            //-----Stub----//

            deviceInfoRequest.deviceattributes = false;
            deviceInfoRequest.saleschannel = "Sales channel";

            //Serialize
            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(deviceInfoRequest), String.Empty, "DeviceInfo", String.Empty);

            //Post Request
            String strdeviceInfoResponse = String.Empty;
            WirelessAdvocates.Logger.Log.LogResponse(strdeviceInfoResponse, String.Empty, "DeviceInfo", String.Empty);

            //Parse Request
            // deviceInfoResponse = (DeviceInfoResponse)WirelessAdvocates.Utility.DeserializeXML(strdeviceInfoResponse, typeof(DeviceInfoResponse));
            return deviceInfoRequest;
        }

        // API: Inventory Check
        public InventoryCheckRequest InventoryCheck()
        {
            InventoryCheckRequest inventoryCheckRequest = new InventoryCheckRequest();

            string[][] hschk = new string[][] { new string[] { "phone1" }, new string[] { "phone2", " datacard 2", "accessories 2" } };
            inventoryCheckRequest.handsetcheck = hschk; // String Min 1 Max 30

            //inventoryCheckRequest.handsetcheck=

            return inventoryCheckRequest;

            /*
            //-----Stub----//
            InventoryCheckResponse inventoryCheckResponse = new InventoryCheckResponse();

            //Serialize
            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(inventoryCheckRequest), String.Empty, "InventoryCheck", String.Empty);

            //Post Request
            String strinventoryCheckResponse = String.Empty;
            WirelessAdvocates.Logger.Log.LogResponse(strinventoryCheckResponse, String.Empty, "InventoryCheck", String.Empty);

            //Parse Request
            inventoryCheckResponse = (InventoryCheckResponse)WirelessAdvocates.Utility.DeserializeXML(strinventoryCheckResponse, typeof(InventoryCheckResponse));
            return inventoryCheckResponse;
             * */
        }

        // API: Npa Nxx
        public NpaNxxResponse NpaNxx(string zipcode, string referenceNumber)
        {
            NpaNxxRequest npaNxxRequest = new NpaNxxRequest();
            PostResponse responseXml = new PostResponse();
            
#region tried to Post request
            /*
            // 1. static request with header --- > snipp out the header and serialize the request and  send response
            //Test Data request: NPA_NXX_req
           
            string strSample= @"<?xml version= ""1.0"" encoding= ""UTF-8""?>
                                <ovm xmlns=""http://nextel.com/ovm"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"">
	                                <ovm-header>
		                                <pin>6654</pin>
		                                <vendor-code>CO</vendor-code>
		                                <message-type>NPA_NXX_REQUEST</message-type>
		                                <timestamp>2011-03-11T00:00:00</timestamp>
	                                </ovm-header>
	                                <ovm-request>
		                                <npa-nxx-request>
			                                <activation-zip-code>20191</activation-zip-code>
		                                </npa-nxx-request>
	                                </ovm-request>
                                </ovm>";

            string strSampleOutput = responseXml.getResponseXml(model.ovmCommon.RequestMessageType.NPA_NXX_REQUEST, strSample);
            // string request= responseXml.generateRequest(model.ovmCommon.RequestMessageType.ACTIVATION_REQUEST, requestXml,
             */
# endregion

            npaNxxRequest.activationzipcode = zipcode.Trim(); // String Length 5 or 9

            //Generate Request concatenating the dynamic --header-- using Postresponse object
            //Serialize
            //Get resposne
            //Generate XML response - --header--

            //Serialize
            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(npaNxxRequest), "Sprint", "NpaNxx", referenceNumber);

            try
            {
               // string strNpaNxxResponse = responseXml.getResponse(WirelessAdvocates.Utility.GetAppSetting("SprintHostTest1"), WirelessAdvocates.Utility.SerializeXML(npaNxxRequest));

                // Do Request; returns response.
                string strNpaNxxResponse = @"<npa-nxx-response xmlns=""http://nextel.com/ovm"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xsi:schemaLocation=""http://nextel.com/ovm http://oebg-http.nextel.com:8006/ovm/xsd/ovm-response.xsd"" >
                    <npa-nxx-count>10</npa-nxx-count>
                    <npa-nxx-info id=""0"">
                        <npa-nxx>410858</npa-nxx>
                        <rate-center>ANNAPOLIS</rate-center>
                    </npa-nxx-info>
                    <npa-nxx-info id=""1"">
                        <npa-nxx>410940</npa-nxx>
                        <rate-center>ANNAPOLIS</rate-center>
                    </npa-nxx-info>
                    <npa-nxx-info id=""2"">
                        <npa-nxx>443481</npa-nxx>
                        <rate-center>ANNAPOLIS</rate-center>
                    </npa-nxx-info>
                    <npa-nxx-info id=""3"">
                        <npa-nxx>443758</npa-nxx>
                        <rate-center>ANNAPOLIS</rate-center>
                    </npa-nxx-info>
                    <npa-nxx-info id=""4"">
                        <npa-nxx>443837</npa-nxx>
                        <rate-center>ANNAPOLIS</rate-center>
                    </npa-nxx-info>
                    <npa-nxx-info id=""5"">
                        <npa-nxx>443871</npa-nxx>
                        <rate-center>ANNAPOLIS</rate-center>
                    </npa-nxx-info>
                    <npa-nxx-info id=""6"">
                        <npa-nxx>443951</npa-nxx>
                        <rate-center>ANNAPOLIS</rate-center>
                    </npa-nxx-info>
                    <npa-nxx-info id=""7"">
                        <npa-nxx>410500</npa-nxx>
                        <rate-center>BALTIMORE</rate-center>
                    </npa-nxx-info>
                    <npa-nxx-info id=""8"">
                        <npa-nxx>410558</npa-nxx>
                        <rate-center>BALTIMORE</rate-center>
                    </npa-nxx-info>
                    <npa-nxx-info id=""9"">
                        <npa-nxx>410637</npa-nxx>
                        <rate-center>BALTIMORE</rate-center>
                    </npa-nxx-info>
                </npa-nxx-response>";

                strNpaNxxResponse = strNpaNxxResponse.Trim();

                //Deserialize
                NpaNxxResponse response = (NpaNxxResponse)WirelessAdvocates.Utility.DeserializeXML(strNpaNxxResponse, typeof(NpaNxxResponse));

                //Log
                WirelessAdvocates.Logger.Log.LogResponse(WirelessAdvocates.Utility.SerializeXML(response), "Sprint", "NpaNxx", referenceNumber);

                //return response;
                return response;
            }
            catch(Exception e) {
                throw new Exception(e.Message);
            }
        }

        // API: Options
        public OptionsResponse Options()
        {
            OptionsResponse optionsResponse = new OptionsResponse();
            OptionsRequest optionsRequest = new OptionsRequest();
            //-----Stub----//

            //Serialize
            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(optionsRequest),"", "Options", String.Empty);

            //Post Request
            String stroptionsResponse = String.Empty;
            WirelessAdvocates.Logger.Log.LogResponse(stroptionsResponse, String.Empty, "Options", String.Empty);

            //Parse Request
            optionsResponse = (OptionsResponse)WirelessAdvocates.Utility.DeserializeXML(stroptionsResponse, typeof(OptionsResponse));
            return optionsResponse;
        }

        // API: Plans
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

        // API: Port Eligibility to return mdnset
        public PortResponse PortEligibility(List<MDNSet> MDNList, string referencenumber)
        {
            PortRequest portRequest = new PortRequest();
            portRequest.portinnumber = new string[2] { "123", "456" }; // String Min: 1 Max: Unbounded
            
            //Serialize
            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(portRequest), "Sprint", "PortEligibility", referencenumber);

            PortResponse postResponse = new PortResponse();

            //-----Stub----//

            /* PortResponse portResponse = new PortResponse();
              portResponse.portresponseinfo = new PortResponseInfo[1] 
              {
                  new PortResponseInfo()
                  { 
                      portinnumber="123456", 
                      porteligibility=true, 
                      porteligibilitydetails="Eligible", 
                      carrier="carrier1", 
                      estimatedduedateSpecified=true,
                      estimatedduedate=DateTime.Now
                  }
              };
             * */

            //Post Request
            String strportsResponse = @"<port-response xmlns=""http://nextel.com/ovm"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xsi:schemaLocation=""http://nextel.com/ovm http://oebg-http.nextel.com:8006/ovm/xsd/ovm-response.xsd"">
            <port-response-info>
                <port-in-number>3373653600</port-in-number>
                <port-eligibility>true</port-eligibility>
                <port-eligibility-details>PTN eligible.</port-eligibility-details>
                <carrier>BELLSOUTH SO CN WRLN</carrier>
                <estimated-due-date>2008-12-08T00:00:00-05:00</estimated-due-date>
            </port-response-info>
            <port-response-info>
                <port-in-number>5713345691</port-in-number>
                <port-eligibility>false</port-eligibility>
                <port-eligibility-details>Number not currently eligible. Please check back at a later date.</port-eligibility-details>
                <carrier>SPRINT</carrier>
            </port-response-info>
        </port-response>";

            strportsResponse = strportsResponse.Trim();

            //Parse Request
            //Deserialize
            PortResponse portResponse = (PortResponse)WirelessAdvocates.Utility.DeserializeXML(strportsResponse, typeof(PortResponse));

            //Log
            WirelessAdvocates.Logger.Log.LogResponse(WirelessAdvocates.Utility.SerializeXML(portResponse), "Sprint", "PortEligibility", referencenumber);

            return portResponse;
        }

        //API: Port Status
        public PortStatusRequest PortStatus()
        {
            PortStatusRequest portStatusRequest = new PortStatusRequest();
            portStatusRequest.portinnumber = "Test port in number";

            PortStatusResponse portStatusResponse = new PortStatusResponse();
            portStatusResponse.portinnumber = "Test port in number";
            portStatusResponse.portstatusmessage = "Test Port status message";


            //Serialize
            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(portStatusRequest), String.Empty, "PortStatus", String.Empty);

            //Post Request
            string strPortStatusResponse = String.Empty;
            WirelessAdvocates.Logger.Log.LogResponse(strPortStatusResponse, String.Empty, "PortStatus", String.Empty);

            //Parse Request

            // portStatusResponse = (PortStatusResponse)WirelessAdvocates.Utility.DeserializeXML(strPortStatusResponse, typeof(PortStatusResponse));

            return portStatusRequest;
        }

        // API: Pre Authorization
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
        public SecurityQuestionResponse SecurityQuestion()
        {
            SecurityQuestionResponse securityQuestionResponse = new SecurityQuestionResponse();
            SecurityQuestionRequest securityQuestionRequest = new SecurityQuestionRequest();
            //-----Stub----//

            //Serialize
            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(securityQuestionRequest), String.Empty, "SecurityQuestion", String.Empty);

            //Post Request
            String strsecurityQuestionResponse = String.Empty;
            WirelessAdvocates.Logger.Log.LogResponse(strsecurityQuestionResponse, String.Empty, "SecurityQuestion", String.Empty);

            //Parse Request
            securityQuestionResponse = (SecurityQuestionResponse)WirelessAdvocates.Utility.DeserializeXML(strsecurityQuestionResponse, typeof(PlansResponse));
            return securityQuestionResponse;

        }

        // API: Service Validation
        public ServiceValidationResponse ServiceValidation()
        {
            ServiceValidationResponse serviceValidationResponse = new ServiceValidationResponse();
            ServiceValidationRequest serviceValidationRequest = new ServiceValidationRequest();
            //-----Stub----//


            //Serialize
            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(serviceValidationRequest), String.Empty, "ServiceValidation", String.Empty);

            //Post Request
            String strserviceValidationResponse = String.Empty;
            WirelessAdvocates.Logger.Log.LogResponse(strserviceValidationResponse, String.Empty, "ServiceValidation", String.Empty);

            //Parse Request
            serviceValidationResponse = (ServiceValidationResponse)WirelessAdvocates.Utility.DeserializeXML(strserviceValidationResponse, typeof(PlansResponse));
            return serviceValidationResponse;

        }

        // API: Validation
        public ValidationResponse Validation()
        {
            ValidationResponse validationResponse = new ValidationResponse();
            ValidationRequest validationRequest = new ValidationRequest();
            //-----Stub----//
            validationRequest.order = new Interfaces.model.doValidation.OrderInfoType()
            {
                type = Interfaces.model.doValidation.OrderType.REPLACE, // enum
                Item = "ref-ptn", // String: 10
                ItemElementName = SprintCarrierServiceInterface.Interfaces.model.doValidation.ItemChoiceType.referenceptn
            };
            validationRequest.corpgovinfo = new Interfaces.model.doValidation.CorporateGovernmentInfo()
            {
                corpgovid = "Test Corp-Gov-Id", // String Min 1 Max 20
            };
            validationRequest.activationzipcode = "98007"; // Stirnf 5 or 9
            validationRequest.handsetcount = 1; // unsignedByte Min 0 Max 50
            //return validationRequest;

            //Serialize
            WirelessAdvocates.Logger.Log.LogRequest(WirelessAdvocates.Utility.SerializeXML(validationRequest), String.Empty, "Validation", String.Empty);

            //Post Request
            string strvalidationResponse = String.Empty;
            WirelessAdvocates.Logger.Log.LogResponse(strvalidationResponse, String.Empty, "Validation", String.Empty);

            //Parse Request

            //validationResponse = (ValidationResponse)WirelessAdvocates.Utility.DeserializeXML(strvalidationResponse, typeof(PortStatusResponse));

            validationResponse.nextelorderid = "Test nextel order id "; // String pattern,  ex: oa-teoa-228261520 (optional)
            validationResponse.validationresult = true; //Boolean 

            return validationResponse;
        }
    }
}