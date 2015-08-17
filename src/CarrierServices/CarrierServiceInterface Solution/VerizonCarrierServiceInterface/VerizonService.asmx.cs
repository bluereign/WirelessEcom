using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using System.Net;
using System.IO;
using System.Text;
using System.Configuration;
using System.Collections.Generic;
using System.Windows.Forms;
using WirelessAdvocates.Common;
using WirelessAdvocates.ServiceResponse;
using Response;
using System.Data.SqlClient;
using WirelessAdvocates;
using System.Xml;

namespace VerizonCarrierServiceInterface
{
    /// <summary>
    /// Summary description for Service1
    /// </summary>
    [WebService(Namespace = "http://membershipwireless.com/services/verizon/v1/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    
    [ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class VerizonService : System.Web.Services.WebService
    {
        [WebMethod()]
        public void TestSave(int OrderId)
        {
            WirelessAdvocates.SalesOrder.WirelessOrder o = new WirelessAdvocates.SalesOrder.WirelessOrder(OrderId);
            o.SSN = "535980243";
            o.Save();
        }
        
       

        [WebMethod()]
        public WirelessAdvocates.ServiceResponse.AddressValidationResponse ValidateAddress(WirelessAdvocates.Address AddressToValidate, WirelessAdvocates.Address.AddressType AddressType, string ReferenceNumber)
        {
            // Prepare the response
            WirelessAdvocates.ServiceResponse.AddressValidationResponse response = new WirelessAdvocates.ServiceResponse.AddressValidationResponse();
            WirelessAdvocates.ExtendedAddress extendedAddress = null;

            // Build request
            Request.retailOrder order = new Request.retailOrder();
            order.messageHeader = Interfaces.Helper.BuildMessageHeader("VALIDATEADDRESS", "TRDSLND", "INTERNET", ReferenceNumber); //"SVCSLND", ReferenceNumber);

            Request.addressValidationType addressValidationType = new Request.addressValidationType();
            addressValidationType.address = new Request.oasAddressType[1];
            addressValidationType.address[0] = new Request.oasAddressType();
            Interfaces.Helper.prepOasAddress(addressValidationType.address[0]);
            addressValidationType.address[0].addressLine1.Value = AddressToValidate.AddressLine1;
            addressValidationType.address[0].addressLine2.Value = AddressToValidate.AddressLine2;
            addressValidationType.address[0].city.Value = AddressToValidate.City;
            addressValidationType.address[0].state.Value = AddressToValidate.State;
            addressValidationType.address[0].zipCode.Value = AddressToValidate.ZipCode.Trim();
            
            order.Item = addressValidationType;

            try
            {
                // Generate the XML and submit the request
                string xml = Interfaces.Helper.GenerateXML(order);
                
                WirelessAdvocates.Logger.Log.LogRequest(xml, "Verizon", "AddressValidation", ReferenceNumber);
                
                string responseXML = Interfaces.Helper.SubmitRequest(xml);
                
                WirelessAdvocates.Logger.Log.LogResponse(responseXML, "Verizon", "AddressValidation", ReferenceNumber);

                // Convert the object from a request
                VerizonCarrierServiceInterface.Interfaces.AddressValidation.oasOrderResponse resp = (VerizonCarrierServiceInterface.Interfaces.AddressValidation.oasOrderResponse)Interfaces.Helper.DeserializeXML(responseXML, typeof(VerizonCarrierServiceInterface.Interfaces.AddressValidation.oasOrderResponse));

                // Get the orderResponse from the response. Error codes are in this object.
                VerizonCarrierServiceInterface.Interfaces.AddressValidation.oasOrderResponseOrderResponse orderResponse = (VerizonCarrierServiceInterface.Interfaces.AddressValidation.oasOrderResponseOrderResponse)resp.Items[2];

                // Fill the response objects
                if (orderResponse.errorCode == "00")
                {
                    VerizonCarrierServiceInterface.Interfaces.AddressValidation.oasOrderResponseAddressValidationResponse addressResponse = (VerizonCarrierServiceInterface.Interfaces.AddressValidation.oasOrderResponseAddressValidationResponse)resp.Items[1];
                    VerizonCarrierServiceInterface.Interfaces.AddressValidation.oasOrderResponseAddressValidationResponseAddress address = addressResponse.address[0];
                    
                    System.Diagnostics.Debug.WriteLine("Success! So you know, here is the street name response:" + address.streetName);

                    // Build out the extended address object
                    extendedAddress = new WirelessAdvocates.ExtendedAddress();
                    extendedAddress.AddressLine1 = address.addressLine1;
                    extendedAddress.AddressLine2 = address.addressLine2;
                    extendedAddress.AddressType = address.addressType;
                    extendedAddress.AptDesignator = address.aptDesignator;
                    extendedAddress.AptNumber = address.aptNumber;
                    extendedAddress.City = address.city;
                    extendedAddress.CountyName = address.countyName;
                    extendedAddress.DeliveryPointBarCode = address.deliveryPointBarCode;
                    extendedAddress.DirectionalPrefix = address.directionalPrefix;
                    extendedAddress.DirectionalSuffix = address.directionalSuffix;
                    extendedAddress.ExtendedZipCode = address.zip10;
                    extendedAddress.HouseNumber = address.houseNum;
                    extendedAddress.State = address.state;
                    extendedAddress.StreetName = address.streetName;
                    extendedAddress.StreetType = address.streetType;
                    extendedAddress.ZipCode = address.zipCode;

                    // Store the response into the database
                    WirelessAdvocates.CheckoutSessionState.Add(ReferenceNumber, AddressType.ToString(), "AddressValidation", extendedAddress);

                    // Set the result object
                    response.ErrorCode = (int)ServiceResponseCode.Success;
                    response.ValidAddress = extendedAddress;
                }
                else if (orderResponse.errorCode == "01")
                {
                    // Set the result object
                    response.ErrorCode = (int)ServiceResponseCode.Success;
                    response.ValidAddress = null;
                }
                else
                {
                    response.ErrorCode = (int)ServiceResponseCode.Failure;
                    response.PrimaryErrorMessage = orderResponse.errorMessage;

                    System.Diagnostics.Debug.WriteLine("Error!");
                    System.Diagnostics.Debug.WriteLine(orderResponse.errorMessage);
                    
                }
            }
            catch(Exception exRequest)
            {
                response.ErrorCode = (int)ServiceResponseCode.Failure;
                
                WirelessAdvocates.Logger.Log.LogException(exRequest.ToString(), "Verizon", "AddressValidation", ReferenceNumber);
            }

            return response;
        }

        [WebMethod()]
        public bool UpgradeEligible(string ZipCode, string Mdn, string SecretKey, string ReferenceNumber)
        {
            bool returnValue = false;
            
            // Build the request
            Request.oasOrder order = new Request.oasOrder();
            order.messageHeader = Interfaces.Helper.BuildMessageHeader("AUTHENTICATELINE", "INQSLND", "INDIRECT", ReferenceNumber);

            Request.orderType orderType = new Request.orderType();
            order.Item = new Request.orderType();
            order.Item = orderType;

            orderType.orderTimeStamp = new Request.oasStringType();
            orderType.orderTimeStamp.Value = DateTime.Now.ToString();
            orderType.Item = new Request.zipCodeType();
            ((Request.zipCodeType)orderType.Item).Value = ZipCode;

            orderType.subOrder = new Request.subOrderType[1];
            orderType.subOrder[0] = new Request.subOrderType();

            Request.authenticateSubscriberRequestType authType = new Request.authenticateSubscriberRequestType();
            orderType.subOrder[0].ItemElementName = Request.ItemChoiceType19.authenticateSubscriberRequest;
            orderType.subOrder[0].Item = authType;

            authType.subReferenceNumber = new Request.oasStringType();
            authType.subReferenceNumber.Value = ReferenceNumber + "-1";
            authType.Item = new Request.zipCodeType();
            ((Request.zipCodeType)authType.Item).Value = ZipCode;
            authType.mdn = new Request.mdnType();
            authType.mdn.Value = Mdn;
            authType.billingZipCode = new Request.zipCodeType();
            authType.billingZipCode.Value = ZipCode;
            authType.ssnL4 = new Request.ssnL4Type();
            authType.ssnL4.Value = SecretKey;
            
            string xml = Interfaces.Helper.GenerateXML(order);

            WirelessAdvocates.Logger.Log.LogRequest(xml, "Verizon", "UpgradeEligibility", ReferenceNumber);

            // Submit the request
            string responseXML = Interfaces.Helper.SubmitRequest(xml);

            WirelessAdvocates.Logger.Log.LogResponse(responseXML, "Verizon", "UpgradeEligibility", ReferenceNumber);

            // Convert the object from a request
            Interfaces.UpgradeResponse.oasOrderResponse orderResponse = (Interfaces.UpgradeResponse.oasOrderResponse)Interfaces.Helper.DeserializeXML(responseXML, typeof(Interfaces.UpgradeResponse.oasOrderResponse));

            // Get the orderResponse from the response. Error codes are in this object.
            VerizonCarrierServiceInterface.Interfaces.UpgradeResponse.oasOrderResponseAuthenticateSubscriberResponse authResponse = (VerizonCarrierServiceInterface.Interfaces.UpgradeResponse.oasOrderResponseAuthenticateSubscriberResponse)orderResponse.Items[1];

            if (authResponse != null && authResponse.authResponse[0].statusCode.ToUpper() != "ERROR")
            {
                //TODO: finish, by getting the BAN
                if (authResponse.lineInformation != null && authResponse.lineInformation.Length > 0 && authResponse.authResponse != null && authResponse.authResponse.Length == authResponse.lineInformation.Length)
                {
                    for (int i = 0; i < authResponse.lineInformation.Length; i++)
                    {
                        if (authResponse.lineInformation[i].mdn == Mdn && authResponse.authResponse[i].statusCode.ToUpper() == "APPROVED")
                        {
                            returnValue = true;

                            break;
                        }
                    }
                }
            }

            return returnValue;
        }

        [WebMethod()]
        public WirelessAdvocates.ServiceResponse.CustomerInquiryResponse CustomerLookupByMDN(string ZipCode,string Mdn, string SecretKey, string ReferenceNumber)
        {
            CustomerInquiryResponse response = new CustomerInquiryResponse();

            // Build the request
            Request.oasOrder order = new Request.oasOrder();
            order.messageHeader = Interfaces.Helper.BuildMessageHeader("LINEINQUIRY", "INQSLND", "INDIRECT", ReferenceNumber);

            Request.orderType orderType = new Request.orderType();
            order.Item = new Request.orderType();
            order.Item = orderType;

            orderType.orderTimeStamp = new Request.oasStringType();
            orderType.orderTimeStamp.Value = DateTime.Now.ToString();
            orderType.Item = new Request.zipCodeType();
            ((Request.zipCodeType)orderType.Item).Value = ZipCode;

            orderType.subOrder = new Request.subOrderType[1];
            orderType.subOrder[0] = new Request.subOrderType();

            Request.authenticateSubscriberRequestType authType = new Request.authenticateSubscriberRequestType();
            orderType.subOrder[0].Item = new Request.authenticateSubscriberRequestType();
            orderType.subOrder[0].ItemElementName = Request.ItemChoiceType19.authenticateSubscriberRequest;
            orderType.subOrder[0].Item = authType;

            authType.subReferenceNumber = new Request.oasStringType();
            authType.subReferenceNumber.Value = ReferenceNumber + "-1";
            authType.Item = new Request.zipCodeType();
            ((Request.zipCodeType)authType.Item).Value = ZipCode;
            authType.mdn = new Request.mdnType();
            authType.mdn.Value = Mdn;
            authType.billingZipCode = new Request.zipCodeType();
            authType.billingZipCode.Value = ZipCode;
            authType.ssnL4 = new Request.ssnL4Type();
            authType.ssnL4.Value = SecretKey;

            string xml = Interfaces.Helper.GenerateXML(order);

            WirelessAdvocates.Logger.Log.LogRequest(xml, "Verizon", "CustomerLookup", ReferenceNumber);

            // Submit the request
            string responseXML = Interfaces.Helper.SubmitRequest(xml);

            WirelessAdvocates.Logger.Log.LogResponse(responseXML, "Verizon", "CustomerLookup", ReferenceNumber);

            // Convert the object from a request
            Interfaces.UpgradeResponse.oasOrderResponse orderResponse = (Interfaces.UpgradeResponse.oasOrderResponse)Interfaces.Helper.DeserializeXML(responseXML, typeof(Interfaces.UpgradeResponse.oasOrderResponse));

            // Get the orderResponse from the response. Error codes are in this object.
            VerizonCarrierServiceInterface.Interfaces.UpgradeResponse.oasOrderResponseAuthenticateSubscriberResponse authResponse = (VerizonCarrierServiceInterface.Interfaces.UpgradeResponse.oasOrderResponseAuthenticateSubscriberResponse)orderResponse.Items[1];

            if (authResponse != null &&  authResponse.authResponse[0].statusCode.ToUpper() != "ERROR")
            {
                //TODO: finish, by getting the BAN
                if (authResponse.lineInformation != null && authResponse.lineInformation.Length > 0)
                {
                    response.CustomerAccountNumber = authResponse.lineInformation[0].accountNumber;
                    response.LinesActive = authResponse.lineInformation.Length;

                    if (string.IsNullOrEmpty(authResponse.lineInformation[0].planCode))
                    {
                      //  response.PlanCode = authResponse.lineInformation[0].planCode;
                    }

                    for (int i = 0; i < authResponse.lineInformation.Length; i++)
                    {
                        CustomerInquiryLine line = new CustomerInquiryLine();
                        line.CarrierAccountId = authResponse.lineInformation[i].accountNumber;                       

                        line.WirelessLineType = WirelessLineType.Line;
                        line.IsPrimaryLine = true;

                        if (string.IsNullOrEmpty(authResponse.lineInformation[i].planCode))
                        {
                            line.PlanCode = authResponse.lineInformation[i].planCode;
                        }

                        if (string.IsNullOrEmpty(authResponse.lineInformation[i].familyShareLineIndicator))
                        {
                            response.WirelessAccountType = WirelessAccountType.Individual;
                        }
                        else
                        {
                            response.WirelessAccountType = WirelessAccountType.Family;
                            line.IsPrimaryLine = (authResponse.lineInformation[i].familyShareLineIndicator == "P");
                        }

                        line.Mdn = authResponse.lineInformation[i].mdn;
                        line.UpgradeAvailableSpecified = true;
                        line.EquipmentUpgradeAvailable = UpgradeEligible(ZipCode, Mdn, SecretKey, ReferenceNumber);

                        if (!string.IsNullOrEmpty(authResponse.lineInformation[i].eCustomerDate))
                        {
                            line.ContractStart = DateTime.Parse(authResponse.lineInformation[i].eCustomerDate);
                        }
                        
                        line.AccountStatus = AccountStatusCode.OPERATIONAL;

                        // Billing address
                        line.BillingAddress = new WirelessAdvocates.Address();
                        line.BillingAddress.AddressLine1 = authResponse.lineInformation[i].billingAddress[0].addressLine1;
                        line.BillingAddress.AddressLine2 = authResponse.lineInformation[i].billingAddress[0].addressLine2;
                        line.BillingAddress.City = authResponse.lineInformation[i].billingAddress[0].city;
                        line.BillingAddress.State = authResponse.lineInformation[i].billingAddress[0].state;
                        line.BillingAddress.ZipCode = authResponse.lineInformation[i].billingAddress[0].zipCode;

                        // Shipping address
                        //Not provided by VERIZON.

                        line.ExistingLineMonthlyCharges = authResponse.lineInformation[i].planAccessChargeAmount;

                        // Add this responseline to the response.
                        response.CustomerInquiryLines.Add(line);
                    }

                    response.ErrorCode = (int)ServiceResponseCode.Success;
                    response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CL_CUSTOMER_FOUND;
                }
            }
            else
            {
                response.ErrorCode = (int)ServiceResponseCode.Success;
                response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CL_CUSTOMER_NOT_FOUND;
            }

            string waReponse = WirelessAdvocates.Utility.SerializeXML(response);

            WirelessAdvocates.Logger.Log.LogResponse(waReponse, "Verizon", "CustomerLookup-WA", ReferenceNumber);

            return response;
        }

        [WebMethod()]
        public WirelessAdvocates.ServiceResponse.CreditCheckResponse CheckCredit(WirelessAdvocates.Name BillingName, string ServiceZipCode, WirelessAdvocates.Contact ContactInfo, WirelessAdvocates.PersonalCredentials BillingContactCredentials, int NumberOfLines, string ExistingCustomerMDN, string ReferenceNumber)
        {
            // Prepare the response
            WirelessAdvocates.ServiceResponse.CreditCheckResponse response = new WirelessAdvocates.ServiceResponse.CreditCheckResponse();

            // Get the stored billing address from the database. This should have been stored in a previous call.
            WirelessAdvocates.ExtendedAddress extendedAddress = null;
            
            try
            {
                extendedAddress = (WirelessAdvocates.ExtendedAddress)WirelessAdvocates.CheckoutSessionState.GetByReference(ReferenceNumber, WirelessAdvocates.Address.AddressType.Billing.ToString(), "AddressValidation", typeof(WirelessAdvocates.ExtendedAddress));
            }
            catch
            {
                throw new Exception("The address with subreference of Billing could not be found in the database");
            }

            // Build the request
            Request.retailOrder order = new Request.retailOrder();
            order.messageHeader = Interfaces.Helper.BuildMessageHeader("CREDIT", "SVCSLND", "INDIRECT", ReferenceNumber);

            Request.retailOrderType retailOrderType = new Request.retailOrderType();
            retailOrderType.orderTimeStamp = new Request.oasStringType();
            retailOrderType.orderTimeStamp.Value = Interfaces.Helper.FormatVerizonDate(DateTime.Now);
            retailOrderType.addToExistingAccount = new Request.yesNoType();

            // Handle existing customer scenario
            if (string.IsNullOrEmpty(ExistingCustomerMDN))
            {
                retailOrderType.addToExistingAccount.Value = "N";
            }
            else
            {
                retailOrderType.addToExistingAccount.Value = "Y";
            }

            retailOrderType.subOrder = new Request.retailSubOrderType[1];
           
            Request.retailSubOrderType retailSubOrderType = new Request.retailSubOrderType();
            retailOrderType.subOrder[0] = new Request.retailSubOrderType();
            retailOrderType.subOrder[0] = retailSubOrderType;

            Request.retailCreditRequestType retailCreditRequestType = new Request.retailCreditRequestType();
            retailSubOrderType.Item = retailCreditRequestType;
            retailSubOrderType.ItemElementName = Request.ItemChoiceType18.retailCreditRequest;

            // Sub reference
            retailCreditRequestType.subReferenceNumber = new Request.oasStringType();
            retailCreditRequestType.subReferenceNumber.Value = ReferenceNumber + "-1";

            // Service zip
            retailCreditRequestType.systemData = new Request.systemDataType();
            retailCreditRequestType.systemData.serviceZipCode = new Request.zipCodeType();
            retailCreditRequestType.systemData.serviceZipCode.Value = ServiceZipCode;

            // Billing name
            retailCreditRequestType.billingName = new Request.nameType();
            retailCreditRequestType.billingName.firstName = new Request.oasStringType();
            retailCreditRequestType.billingName.firstName.Value = BillingName.FirstName;
            retailCreditRequestType.billingName.lastName = new Request.oasStringType();
            retailCreditRequestType.billingName.lastName.Value = BillingName.LastName;
            retailCreditRequestType.billingName.middleInitial = new Request.oasSingleCharacterType();
            retailCreditRequestType.billingName.middleInitial.Value = BillingName.MiddleInitial;
            retailCreditRequestType.billingName.prefix = new Request.oasStringType();
            retailCreditRequestType.billingName.prefix.Value = BillingName.Prefix;
            retailCreditRequestType.billingName.suffix = new Request.oasStringType();
            retailCreditRequestType.billingName.suffix.Value = BillingName.Suffix;

            // Contact info
            Request.contactType contactType = new Request.contactType();
            retailCreditRequestType.contact = new Request.contactType();
            contactType.email = new Request.oasStringType();
            contactType.email.Value = ContactInfo.Email;
            contactType.cellular = new Request.oasStringType();
            contactType.cellular.Value = ContactInfo.CellPhone;
            contactType.homeNumber = new Request.phoneExtType();
            contactType.homeNumber.Value = ContactInfo.EveningPhone;
            contactType.workNumber = new Request.phoneExtType();
            contactType.workNumber.Value = ContactInfo.WorkPhone;
            contactType.workExtension = new Request.phoneExtType();
            contactType.workExtension.Value = ContactInfo.WorkPhoneExt;
            retailCreditRequestType.contact = contactType;
            
            // Billing address (from session)
            Request.oasAddressType billingAddress = new Request.oasAddressType();
            retailCreditRequestType.billingAddress = new Request.oasAddressType();
            billingAddress = Interfaces.Helper.ConvertExtendedAddressToVerizonAddress(extendedAddress);
            retailCreditRequestType.billingAddress = billingAddress;

            // Credentials.
            retailCreditRequestType.credential = new Request.retailCredentialType();
            retailCreditRequestType.credential.ssn = new Request.ssnType();
            retailCreditRequestType.credential.ssn.Value = BillingContactCredentials.SSN;
            retailCreditRequestType.credential.dob = new Request.oasDateType();
            retailCreditRequestType.credential.dob.Value = Interfaces.Helper.FormatVerizonDate(BillingContactCredentials.DOB);
            retailCreditRequestType.credential.drvLicenseNum = new Request.drvLicenseNumType();
            retailCreditRequestType.credential.drvLicenseNum.Value = BillingContactCredentials.Id;
            retailCreditRequestType.credential.drvLicenseState = new Request.drvLicenseStateType();
            retailCreditRequestType.credential.drvLicenseState.Value = BillingContactCredentials.State;
            retailCreditRequestType.credential.noOfLines = new Request.oasStringType();
            retailCreditRequestType.credential.noOfLines.Value = NumberOfLines.ToString();

            // Handle existing customer scenarios.
            if (!string.IsNullOrEmpty(ExistingCustomerMDN))
            {
                retailCreditRequestType.credential.existingPhoneNumber = new Request.phoneExtType();
                retailCreditRequestType.credential.existingPhoneNumber.Value = ExistingCustomerMDN;
                retailCreditRequestType.credential.accountNumber = new Request.oasStringType();
            }

            order.Item = retailOrderType;
            
            // Submit the request.
            try
            {
                string xml = Interfaces.Helper.GenerateXML(order);
                
                WirelessAdvocates.Logger.Log.LogRequest(xml, "Verizon", "CreditCheck", ReferenceNumber);

                string responseXML = Interfaces.Helper.SubmitRequest(xml);
                
                WirelessAdvocates.Logger.Log.LogResponse(responseXML, "Verizon", "CreditCheck", ReferenceNumber);

                // Convert the object from a request
                VerizonCarrierServiceInterface.Interfaces.CreditCheck.oasOrderResponse resp = (VerizonCarrierServiceInterface.Interfaces.CreditCheck.oasOrderResponse)Interfaces.Helper.DeserializeXML(responseXML, typeof(VerizonCarrierServiceInterface.Interfaces.CreditCheck.oasOrderResponse));

                // Get the orderResponse from the response. Error codes are in this object.
                VerizonCarrierServiceInterface.Interfaces.CreditCheck.oasOrderResponseOrderResponse orderResponse = (VerizonCarrierServiceInterface.Interfaces.CreditCheck.oasOrderResponseOrderResponse)resp.Items[2];

                // Fill the response objects
                if (orderResponse.errorCode != "00")
                {
                    response.ErrorCode = (int)ServiceResponseCode.Failure;
                    response.PrimaryErrorMessage = orderResponse.errorMessage;

                    System.Diagnostics.Debug.WriteLine("Error!");
                    System.Diagnostics.Debug.WriteLine(orderResponse.errorMessage);
                }
                else
                {
                    VerizonCarrierServiceInterface.Interfaces.CreditCheck.oasOrderResponseCreditResponse creditResponse = (VerizonCarrierServiceInterface.Interfaces.CreditCheck.oasOrderResponseCreditResponse)resp.Items[1];
                    System.Diagnostics.Debug.WriteLine("creditResponse.response:" + creditResponse.creditCode);

                    // Build response
                    response.ErrorCode = (int)ServiceResponseCode.Success;
                    response.Deposit = Convert.ToDecimal(creditResponse.depositAmount);
                    
                    if (!string.IsNullOrEmpty(creditResponse.noOfLinesApproved.Trim()))
                    {
                        try
                        {
                            response.NumberOfLines = Convert.ToInt32(creditResponse.noOfLinesApproved.Trim());
                        }
                        catch
                        {
                            response.NumberOfLines = 0;
                        }
                    }
                    else
                    {
                        response.NumberOfLines = 0;
                    }
                    
                    response.CreditApplicationNumber = creditResponse.creditApplicationNumber;
                    response.CreditCode = creditResponse.creditCode;
                    response.CreditStatus = creditResponse.creditStatus;

                    if (creditResponse.creditCode.ToUpper() == "AP")
                    {
                        System.Diagnostics.Debug.WriteLine("Success! So you know, deposit amount:" + creditResponse.depositAmount);
                    }

                    WirelessAdvocates.Logger.Log.LogResponse(WirelessAdvocates.Utility.SerializeXML(response), "Verizon", "CreditCheck-WA", ReferenceNumber);   
                }
            }
            catch (Exception exRequest)
            {
                WirelessAdvocates.Logger.Log.LogException(exRequest.ToString(), "Verizon", "CreditCheck", ReferenceNumber);
            }

            return response;
        }

        [WebMethod()]
        public string TestValidatePortIn(string mdn, string serviceZipCode, string referenceNumber)
        {
            WirelessAdvocates.MDNSet set = new MDNSet();
            set.MDN = mdn;
            set.ServiceZipCode = serviceZipCode;
            List<WirelessAdvocates.MDNSet> list = new List<MDNSet>();
            list.Add(set);
            WirelessAdvocates.ServiceResponse.ValidatePortInResponse response = ValidatePortIn(list, referenceNumber);
            
            return "";
        }

        [WebMethod()]
        public WirelessAdvocates.ServiceResponse.ValidatePortInResponse ValidatePortIn(List<WirelessAdvocates.MDNSet> MDNList, string ReferenceNumber)
        {
            WirelessAdvocates.ServiceResponse.ValidatePortInResponse response = new WirelessAdvocates.ServiceResponse.ValidatePortInResponse();

            foreach (WirelessAdvocates.MDNSet mdnSet in MDNList)
            {
                Request.oasOrder order = new Request.oasOrder();

                order.messageHeader = Interfaces.Helper.BuildMessageHeader("PORTINVALIDATION", "INQSLND", "INDIRECT", ReferenceNumber);

                Request.orderType orderType = new Request.orderType();
                orderType.orderTimeStamp = new Request.oasStringType();
                orderType.orderTimeStamp.Value = Interfaces.Helper.FormatVerizonDate(DateTime.Now);

                orderType.Item = new Request.zipCodeType();
                ((Request.zipCodeType)orderType.Item).Value = mdnSet.ServiceZipCode;
                orderType.subOrder = new Request.subOrderType[1];
                orderType.subOrder[0] = new Request.subOrderType();

                orderType.subOrder[0].ItemElementName = Request.ItemChoiceType19.validatePortIn;
                orderType.subOrder[0].Item = new Request.retailServiceOnlyType();
                Request.validatePortInType portIn = new Request.validatePortInType();
                portIn.subReferenceNumber = new Request.oasStringType();
                portIn.subReferenceNumber.Value = ReferenceNumber + "-0";

                portIn.Item = new Request.zipCodeType();
                ((Request.zipCodeType)portIn.Item).Value = mdnSet.ServiceZipCode; //TODO: remove hard coded value.
                portIn.mdn = new Request.mdnType();
                portIn.mdn.Value = mdnSet.MDN; 

                orderType.subOrder[0].Item = portIn;

                order.Item = orderType;

                string xml = Interfaces.Helper.GenerateXML(order);
                System.Diagnostics.Debug.WriteLine("Order:" + xml);

                WirelessAdvocates.Logger.Log.LogRequest(xml, "Verizon", "PortInValidation", ReferenceNumber);

                //submit the request.
                try
                {
                    string responseXML = Interfaces.Helper.SubmitRequest(xml);
                    //log the response.
                
                    WirelessAdvocates.Logger.Log.LogResponse(responseXML, "Verizon", "PortInValidation", ReferenceNumber);
                  
                    // Convert the object from a request

                    Interfaces.PortIn.oasOrderResponse resp = (Interfaces.PortIn.oasOrderResponse)Interfaces.Helper.DeserializeXML(responseXML, typeof(Interfaces.PortIn.oasOrderResponse));
                  

                    // Get the orderResponse from the response. Error codes are in this object.
                    Interfaces.PortIn.oasOrderResponseOrderResponse orderResponse = (Interfaces.PortIn.oasOrderResponseOrderResponse)resp.Items[2];
                 
                    // Fill the response objects
                    if (orderResponse.errorCode == "10")
                    {
                        mdnSet.IsPortable = false;
                        response.ErrorCode = (int)ServiceResponseCode.Success;
                    }
                    else if (orderResponse.errorCode != "00")
                    {
                        response.ErrorCode = (int)ServiceResponseCode.Failure;
                        response.PrimaryErrorMessage = orderResponse.errorMessage;

                        System.Diagnostics.Debug.WriteLine("Error!");
                        System.Diagnostics.Debug.WriteLine(orderResponse.errorMessage);
                    }
                    else
                    {
                        Interfaces.PortIn.oasOrderResponseValidatePortInResponse validateResponse = (Interfaces.PortIn.oasOrderResponseValidatePortInResponse)resp.Items[1];
                        Interfaces.PortIn.oasOrderResponseValidatePortInResponsePortInInformation portInInfo = validateResponse.portInInformation[0];
                        System.Diagnostics.Debug.WriteLine("Success! on MDN:" + mdnSet.MDN + ", So you know,  billingSystem is:" + portInInfo.billingSystem);

                        mdnSet.IsPortable = true;
                        response.ErrorCode = (int)ServiceResponseCode.Success;
                    }
                }
                catch (Exception exRequest)
                {
                    WirelessAdvocates.Logger.Log.LogException(exRequest.ToString() , "Verizon", "PortInValidation", ReferenceNumber);
                                        
                    break;
                }
            }

            // Set the response MDNSet to the modified MDNSet.
            response.MDNSet = MDNList;
            
            return response;
        }

        [WebMethod()]
        public WirelessAdvocates.ServiceResponse.OrderResponse SubmitOrder(string OrderNumber)
        {
            WirelessAdvocates.ServiceResponse.OrderResponse response = new WirelessAdvocates.ServiceResponse.OrderResponse();

            string orderType = "SVCSLND";
            string referenceNumber = "";

            // Get the details of the order from the database.
            WirelessAdvocates.SalesOrder.WirelessOrder wirelessOrder = new WirelessAdvocates.SalesOrder.WirelessOrder(Convert.ToInt32(OrderNumber));

            // Carrier reference number comes from the order.
            referenceNumber = wirelessOrder.CheckoutReferenceNumber;
            
            // Check to see if any orders that are a port in. If so, set the orderType. 
            foreach (WirelessAdvocates.SalesOrder.WirelessLine line in wirelessOrder.WirelessLines)
            {
                if (!string.IsNullOrEmpty(line.NewMDN))
                {
                    orderType = "SNPSLND";

                    break;
                }
            }
            
            // Get the extended addresses.
            WirelessAdvocates.ExtendedAddress extendedBillingAddress = null;
            
            try
            {
                extendedBillingAddress = (WirelessAdvocates.ExtendedAddress)WirelessAdvocates.CheckoutSessionState.GetByReference(referenceNumber, WirelessAdvocates.Address.AddressType.Shipping.ToString(), "AddressValidation", typeof(WirelessAdvocates.ExtendedAddress));
            }
            catch(Exception ex1)
            {
                throw new Exception(ex1.ToString());
            }

            // Build the details from wireless account / order.
            // Build the lines from wireless lines.
            Request.retailOrder order = new Request.retailOrder();
            order.messageHeader = Interfaces.Helper.BuildMessageHeader("ORDER", orderType, "INDIRECT", referenceNumber);

            Request.retailOrderType retailOrderType = new Request.retailOrderType();
            retailOrderType.orderTimeStamp = new Request.oasStringType();
            retailOrderType.orderTimeStamp.Value = Interfaces.Helper.FormatVerizonDate(DateTime.Now);
            retailOrderType.addToExistingAccount = new Request.yesNoType();

            if (wirelessOrder.ActivationType.Value.ToString() == "U" || wirelessOrder.ActivationType.Value.ToString() == "A")
            {
                retailOrderType.credential = new Request.retailCredentialType();
                retailOrderType.credential.ssn = new Request.ssnType();
                retailOrderType.credential.ssn.Value = wirelessOrder.CurrentAccountPIN;
                retailOrderType.credential.noOfLines = new Request.oasStringType();
                retailOrderType.credential.noOfLines.Value = wirelessOrder.WirelessLines.Length.ToString();
                retailOrderType.credential.existingPhoneNumber = new Request.phoneExtType();
                retailOrderType.credential.existingPhoneNumber.Value = GetCurrentMDN(referenceNumber);
                retailOrderType.credential.accountNumber = new Request.oasStringType();
                retailOrderType.credential.accountNumber.Value = "";

                retailOrderType.addToExistingAccount.Value = "Y"; //TODO: need to change this based on customer type.
                retailOrderType.newCustomer = new Request.yesNoType();
                retailOrderType.newCustomer.Value = "N"; //TODO: need to change this based on customer type.
            }
            else
            {
                retailOrderType.addToExistingAccount.Value = "N"; //TODO: need to change this based on customer type.
                retailOrderType.newCustomer = new Request.yesNoType();
                retailOrderType.newCustomer.Value = "Y"; //TODO: need to change this based on customer type.
            }
            
            retailOrderType.corporateInfo = new Request.corporateInfoType();

            // Begin credit card.
            retailOrderType.creditCard = new Request.creditCardInfoType();
            retailOrderType.creditCard.creditCardNumber = new Request.creditCardNumberType();
            retailOrderType.creditCard.creditCardNumber.Value = "0000000000000000";
            retailOrderType.creditCard.creditCardAmount = new Request.amountType();
            retailOrderType.creditCard.creditCardAmount.Value = 0M;
            retailOrderType.creditCard.expirationDate = new Request.creditCardExpirationDateType();
            retailOrderType.creditCard.expirationDate.Value = DateTime.Now.AddDays(1).ToString("MMyyyy");
            retailOrderType.creditCard.creditCardType = new Request.creditCardEnumType();
            retailOrderType.creditCard.creditCardType = Request.creditCardEnumType.VISA;

            retailOrderType.creditCard.creditCardName = new Request.nameType();
            retailOrderType.creditCard.creditCardName.firstName = new Request.oasStringType();
            retailOrderType.creditCard.creditCardName.firstName.Value = wirelessOrder.BillAddress.Name.FirstName;
            retailOrderType.creditCard.creditCardName.lastName = new Request.oasStringType();
            retailOrderType.creditCard.creditCardName.lastName.Value = wirelessOrder.BillAddress.Name.LastName;
            retailOrderType.creditCard.creditCardName.middleInitial = new Request.oasSingleCharacterType();
            retailOrderType.creditCard.creditCardName.middleInitial.Value = wirelessOrder.BillAddress.Name.MiddleInitial;

            Request.oasAddressType creditCardAddress = new Request.oasAddressType();
            creditCardAddress = Interfaces.Helper.ConvertExtendedAddressToVerizonAddress(extendedBillingAddress, true);
            retailOrderType.creditCard.creditCardAddress = new Request.oasAddressType();
            retailOrderType.creditCard.creditCardAddress = creditCardAddress;
            
            // Begin billing info
            retailOrderType.billingName = new Request.nameType();
            retailOrderType.billingName.firstName = new Request.oasStringType();
            retailOrderType.billingName.firstName.Value = wirelessOrder.BillAddress.Name.FirstName;
            retailOrderType.billingName.lastName = new Request.oasStringType();
            retailOrderType.billingName.lastName.Value = wirelessOrder.BillAddress.Name.LastName;
            retailOrderType.billingName.middleInitial = new Request.oasSingleCharacterType();
            retailOrderType.billingName.middleInitial.Value = wirelessOrder.BillAddress.Name.MiddleInitial;

            retailOrderType.contact = new Request.contactType();
            retailOrderType.contact.email = new Request.oasStringType();
            retailOrderType.contact.email.Value = wirelessOrder.Email;
            retailOrderType.contact.homeNumber = new Request.phoneExtType();
            retailOrderType.contact.homeNumber.Value = wirelessOrder.BillAddress.Contact.EveningPhone;
            retailOrderType.contact.workNumber = new Request.phoneExtType();
            retailOrderType.contact.workNumber.Value = wirelessOrder.BillAddress.Contact.WorkPhone;
            retailOrderType.contact.workExtension = new Request.phoneExtType();
            retailOrderType.contact.workExtension.Value = wirelessOrder.BillAddress.Contact.WorkPhoneExt;

            retailOrderType.billingAddress = new Request.oasAddressType();
            retailOrderType.billingAddress = Interfaces.Helper.ConvertExtendedAddressToVerizonAddress(extendedBillingAddress, true);
            
            // Begin revenue info
            retailOrderType.revenueInfo = new Request.revenueInfoType();
            retailOrderType.revenueInfo.orderAmount = new Request.amountType();
            retailOrderType.revenueInfo.orderAmount.Value = 0M;
            retailOrderType.revenueInfo.depositAmount = new Request.amountType();
            retailOrderType.revenueInfo.depositAmount.Value = 0M;
            retailOrderType.revenueInfo.taxAmount = new Request.amountType();
            retailOrderType.revenueInfo.taxAmount.Value = 0M;
            retailOrderType.revenueInfo.shCharges = new Request.amountType();
            retailOrderType.revenueInfo.shCharges.Value = 0M;
            retailOrderType.revenueInfo.paymentType = new Request.paymentEnumType();
            retailOrderType.revenueInfo.paymentType = Request.paymentEnumType.CREDITCARD;
            retailOrderType.revenueInfo.depositAccepted = new Request.yesNoPendType();
            retailOrderType.revenueInfo.depositAccepted.Value = "N";
            
            // Begin wireless lines
            retailOrderType.subOrder = new Request.retailSubOrderType[wirelessOrder.WirelessLines.Length];

            int lineCounter = 0;
            string serviceZipCode = "";

            foreach (WirelessAdvocates.SalesOrder.WirelessLine line in wirelessOrder.WirelessLines)
            {
                bool isPortIn = line.IsMdnPort.Value;

                //TODO: Add equipment
                Request.retailEquipmentType[] equipmentList = new Request.retailEquipmentType[line.WirelessLineDevices.Length];
                
                int equipmentCounter = 0;
                
                foreach (WirelessAdvocates.SalesOrder.Device device in line.WirelessLineDevices)
                {
                    Request.retailEquipmentType equipment = new Request.retailEquipmentType();
                    equipment.name = new Request.oasString120Type();
                    equipment.name.Value = device.Title; 
                    equipment.make = new Request.oasStringType();
                    equipment.make.Value = "Verizon Wireless"; //TODO: can this be hardcoded?
                    equipment.model = new Request.oasStringType();
                    equipment.model.Value = device.CarrierBillCode; //TODO: can this be the same as the billcode?

                    equipment.ItemElementName = Request.ItemChoiceType6.productType;
                    equipment.Item = new Request.oasStringType();
                    equipment.Item.Value = "PHONE"; //TODO: what should this be?

                    equipment.amount = new Request.oasStringType();
                    equipment.amount.Value = "0.00";
                    equipment.retailPrice = new Request.oasStringType();
                    equipment.retailPrice.Value = "0.00";
                    equipment.listPrice = new Request.oasStringType();
                    equipment.listPrice.Value = "0.00";
                    equipment.quantitySpecified = true;
                    equipment.quantity = 1;
                    equipment.productCode = new Request.oasStringType();
                    equipment.productCode.Value = device.CarrierBillCode;
                    equipment.discountCode = new Request.oasStringType();
                    equipment.discountCode.Value = ""; //this can be blank.
                    equipment.discountCodeDescription = new Request.oasStringType();
                    equipment.discountCodeDescription.Value = ""; //this can be blank.
                    equipment.discountAmount = new Request.oasStringType();
                    equipment.discountAmount.Value = "0.00";

                    equipmentList[equipmentCounter] = new Request.retailEquipmentType();
                    equipmentList[equipmentCounter] = equipment;
                    equipmentCounter++;
                }

                int f = 0;
                
                Request.retailFeatureType[] features = new Request.retailFeatureType[line.WirelessLineServices.Length];
  
                foreach (WirelessAdvocates.SalesOrder.WirelessLineService service in line.WirelessLineServices)
                {
                    Request.retailFeatureType feature = new Request.retailFeatureType();
                    feature = new Request.retailFeatureType();
                    feature.name = new Request.oasString130Type();
                    feature.name.Value = service.Title;
                    feature.description = new Request.oasString500Type();
                    feature.description.Value = ""; //TODO: // add the real description
                    feature.featureCode = new Request.oasStringType();
                    feature.featureCode.Value = service.CarrierServiceId;
                    feature.featureType = new Request.oasStringType();
                    feature.featureType.Value = "";
                    feature.serviceTypeCode = new Request.oasStringType();
                    feature.serviceTypeCode.Value = "DIGITAL"; //TODO: replace this.
                    feature.monthlyCharge = new Request.oasStringType();

                    if (service.MonthlyFee > 0)
                    {
                        feature.monthlyCharge.Value = service.MonthlyFee.ToString("#.00");
                    }
                    else
                    {
                        feature.monthlyCharge.Value = "0.00";
                    }
                    
                    feature.includedWithPlan = new Request.includedWithPlanType();
                    feature.includedWithPlan.Value = "Y"; //TODO: adjust this based on the catalog data.
                    feature.subscribe = new Request.addDeleteType();
                    feature.subscribe.Value = "A"; //TODO: what is this?

                    // Add this feature to the list.
                    features[f] = feature;
                    f++;
                }

                // Build the plan
                Request.retailPlanType plan = new Request.retailPlanType();
                plan.name = new Request.oasString220Type();
                plan.name.Value = line.ProductTitle;
                plan.description = new Request.oasString500Type();
                plan.description.Value = line.ProductTitle; //TODO: is this ok as title instead of description?
                plan.monthlyCharge = new Request.oasStringType();
                plan.monthlyCharge.Value = "0.00"; //TODO: add monthly charge.
                plan.planCode = new Request.oasStringType();
                
                if (lineCounter > 0)
                {
                    // Get Additional Bill Code by Bill Code
                    plan.planCode.Value = GetAdditionalBillCode(line.CarrierPlanId);

                    // If Additional Bill Code is empty, re-use line one's bill code.
                    if (plan.planCode.Value.Length == 0)
                    {
                        plan.planCode.Value = line.CarrierPlanId;
                    }
                }
                else
                {
                    plan.planCode.Value = line.CarrierPlanId;
                }

                if (plan.planCode.Value.Trim().Length == 0)
                {
                    plan.planCode.Value = GetPlanCodeReturn(referenceNumber);
                }
          
                plan.planCategoryCodeSpecified = false;

                plan.retailCharge = new Request.oasStringType();
                plan.retailCharge.Value = "0.00";

                plan.miscellaneous = new Request.retailMiscInfo();
                plan.miscellaneous.preferredNpaNxx = new Request.oasStringType();
                plan.miscellaneous.preferredNpaNxx.Value = line.NPARequested;
                plan.bgsa = new Request.oasStringType();
                plan.bgsa.Value = null;

                // Build order request based on order type
                if (isPortIn)
                {
                    retailOrderType.subOrder[lineCounter] = new Request.retailSubOrderType();
                    retailOrderType.subOrder[lineCounter].ItemElementName = Request.ItemChoiceType18.retailServiceOnlyPortIn; //TODO: this should change based on the order type.
                    retailOrderType.subOrder[lineCounter].Item = new Request.retailServiceOnlyPortInType();
                    Request.retailServiceOnlyPortInType subOrder = new Request.retailServiceOnlyPortInType();

                    // Build portin request
                    retailOrderType.subOrder[lineCounter].Item = subOrder;
                    subOrder.subReferenceNumber = new Request.oasStringType();
                    subOrder.subReferenceNumber.Value = referenceNumber + "-" + line.WirelessLineId.ToString();
                    subOrder.systemData = new Request.systemDataType();
                    subOrder.systemData.serviceZipCode = new Request.zipCodeType();
                    //subOrder.systemData.serviceZipCode.Value = wirelessOrder.BillAddress.ZipCode; //TODO: replace with shipping zipcode

                    serviceZipCode = GetServiceZipCode(Convert.ToInt32(OrderNumber));

                    if(serviceZipCode.Length == 0)  {
                        serviceZipCode = wirelessOrder.BillAddress.ZipCode;
                    }

                    if (serviceZipCode.Length == 0)
                    {
                        serviceZipCode = "11111";
                    }
                    
                    subOrder.systemData.serviceZipCode.Value = serviceZipCode;

                    subOrder.mdn = new Request.mdnType();
                    subOrder.mdn.Value = line.NewMDN;

                    if (!string.IsNullOrEmpty(line.ESN))
                    {
                        subOrder.ItemElementName = Request.ItemChoiceType12.esn;
                        subOrder.Item = line.ESN;
                    }
                    else if (line.IMEI.Length > 0)
                    {
                        subOrder.ItemElementName = Request.ItemChoiceType12.meid;
                        subOrder.Item = line.IMEI; 
                    }
                    else
                    {
                        //TODO: not sure what to do if this is the case.
                    }

                    subOrder.Item1ElementName = new Request.Item1ChoiceType26();
                    subOrder.Item1ElementName = Request.Item1ChoiceType26.contractLength;
                    subOrder.Item1 = new Request.oasStringType();
                    subOrder.Item1.Value = "24"; //TODO: This should not be hardcoded.

                    subOrder.ratePlanBrochureCode = new Request.oasNotNullStringType();
                    subOrder.ratePlanBrochureCode.Value = "BAPROMO101408"; //TODO: should this have any value.
                    subOrder.customerAgreementCode = new Request.oasNotNullStringType();
                    subOrder.customerAgreementCode.Value = "10105"; //TODO: add agreement code

                    subOrder.activationFee = new Request.amountType();
                    subOrder.activationFee.Value = 0M;

                    //subOrder.contractTermsCode = new Request.oasNotNullStringType();
                    //subOrder.contractTermsCode.Value = "123456"; //TODO: What is this?
                    
                    //TODO: Add LNP
                    subOrder.lnp = new Request.lnpType();
                    subOrder.lnp.ospAccountNo = new Request.oasString20Type();
                    subOrder.lnp.ospAccountNo.Value = "334436661"; //TODO: get real value.
                    subOrder.lnp.lnpAuthorizedSignerName = new Request.oasString60Type();
                    subOrder.lnp.lnpAuthorizedSignerName.Value = wirelessOrder.BillAddress.Name.FirstName + " " + wirelessOrder.BillAddress.Name.LastName;
                    subOrder.lnp.ItemElementName = Request.ItemChoiceType3.ssn;
                    subOrder.lnp.Item = new Request.ssnType();
                    subOrder.lnp.Item.Value = wirelessOrder.SSN;
                    subOrder.lnp.lnpAddress = Interfaces.Helper.ConvertExtendedAddressToVerizonAddress(extendedBillingAddress, true);
                    subOrder.lnp.directFulfillmentIndicator = new Request.yesNoType();
                    subOrder.lnp.directFulfillmentIndicator.Value = "Y";

                    // Add equipment
                    subOrder.equipment = equipmentList;

                    //add features
                    subOrder.feature = new Request.retailFeatureType[line.WirelessLineServices.Length];
                    subOrder.feature = features;

                    // Add the plan
                    subOrder.plan = new Request.retailPlanType();
                    subOrder.plan = plan;
                }
                else
                {
                    // Prepare sub order type of non port in.
                    retailOrderType.subOrder[lineCounter] = new Request.retailSubOrderType();
                    retailOrderType.subOrder[lineCounter].ItemElementName = Request.ItemChoiceType18.retailServiceOnly; //TODO: this should change based on the order type.
                    retailOrderType.subOrder[lineCounter].Item = new Request.retailServiceOnlyType();
                    Request.retailServiceOnlyType subOrder = new Request.retailServiceOnlyType();

                    // Build non portin request
                    retailOrderType.subOrder[lineCounter].Item = subOrder;
                    subOrder.subReferenceNumber = new Request.oasStringType();
                    subOrder.subReferenceNumber.Value = referenceNumber + "-" + lineCounter.ToString();
                    subOrder.systemData = new Request.systemDataType();
                    subOrder.systemData.serviceZipCode = new Request.zipCodeType();
                    // subOrder.systemData.serviceZipCode.Value = wirelessOrder.BillAddress.ZipCode; //TODO: replace with shipping zipcode

                    serviceZipCode = GetServiceZipCode(Convert.ToInt32(OrderNumber));

                    if (serviceZipCode.Length == 0)
                    {
                        serviceZipCode = wirelessOrder.BillAddress.ZipCode;
                    }

                    if (serviceZipCode.Length == 0)
                    {
                        serviceZipCode = "22222";
                    }

                    subOrder.systemData.serviceZipCode.Value = serviceZipCode;

                    if (!string.IsNullOrEmpty(line.ESN))
                    {
                        subOrder.ItemElementName = Request.ItemChoiceType11.esn;
                        subOrder.Item = line.ESN;
                    }
                    else if (!string.IsNullOrEmpty(line.IMEI))
                    {
                        subOrder.ItemElementName = Request.ItemChoiceType11.meid;
                        subOrder.Item = line.IMEI;
                    }
                    else
                    {
                        //TODO: not sure what to do if this is the case.
                    }
                    
                    subOrder.activationFee = new Request.amountType();
                    subOrder.activationFee.Value = 0M;

                    subOrder.Item1ElementName = new Request.Item1ChoiceType25();
                    subOrder.Item1ElementName = Request.Item1ChoiceType25.contractLength;
                    subOrder.Item1 = new Request.oasStringType();
                    subOrder.Item1.Value = "24"; //TODO: This should not be hardcoded.

                    subOrder.ratePlanBrochureCode = new Request.oasNotNullStringType();
                    subOrder.ratePlanBrochureCode.Value = "BAPROMO101408"; //TODO: should this have any value.
                    subOrder.customerAgreementCode = new Request.oasNotNullStringType();
                    subOrder.customerAgreementCode.Value = "10105"; //TODO: add agreement code
                    subOrder.contractTermsCode = new Request.oasNotNullStringType();
                    subOrder.contractTermsCode.Value = "123456"; //TODO: What is this?

                    // Add equipment
                    subOrder.equipment = equipmentList;

                    // Add features
                    subOrder.feature = new Request.retailFeatureType[line.WirelessLineServices.Length];
                    subOrder.feature = features;

                    // Add the plan
                    subOrder.plan = new Request.retailPlanType();
                    subOrder.plan = plan;
                }

                //TODO: seperate ESN IMEI
                //subOrder.ItemElementName = Request.ItemChoiceType12.meid;
                //subOrder.Item = "IMEI0FFF3790F8"; //TODO: line.EMEI; 
                
                lineCounter++;
            }
            // End wireless lines

            // Set the order type to the order
            order.Item = retailOrderType;
            
            // Make the order request.
            string xml = Interfaces.Helper.GenerateXML(order);
            
            System.Diagnostics.Debug.WriteLine("Order:" + xml);
           
            WirelessAdvocates.Logger.Log.LogRequest(xml, "Verizon", "Order", referenceNumber);

            string responseXML = Interfaces.Helper.SubmitRequest(xml);
            
            WirelessAdvocates.Logger.Log.LogResponse(responseXML, "Verizon", "Order", referenceNumber);

            System.Diagnostics.Debug.WriteLine("Order Response:" + responseXML);

            try
            {
                
             // Need to get the info I need from CATS

                WirelessAdvocates.Logger.Log.LogException("", "Verizon", "UpdateOrder", referenceNumber);
                wirelessOrder.CurrentAccountNumber = "";
                wirelessOrder.WirelessLines[0].CurrentMDN = "";

                wirelessOrder.Save();
            }
            catch (Exception ex)
            {
            }

            return response;
        }

        private string GetServiceZipCode(int OrderId)
        {
            string GetServiceZipCodeReturn = "33333";

            SqlConnection thisConnection = new SqlConnection(dbUtility.GetConnectionString("WirelessAdvocates.Properties.Settings.DataConnectionString"));
            thisConnection.Open();
            SqlCommand thisCommand = thisConnection.CreateCommand();

            thisCommand.CommandText = "SELECT ISNULL(o.serviceZipCode, '') AS serviceZipCode FROM salesOrder.[Order] AS o WITH (NOLOCK) WHERE o.OrderId = " + OrderId + "";

            SqlDataReader thisReader = thisCommand.ExecuteReader();

            if (thisReader != null)
            {
                while (thisReader.Read())
                {
                    GetServiceZipCodeReturn = thisReader["serviceZipCode"].ToString().Trim();
                }

                thisReader.Close();
            }

            thisConnection.Close();

            return GetServiceZipCodeReturn;
        }

        private string GetAdditionalBillCode(string BillCode)
        {
            string GetAdditionalBillCodeReturn = "";

            SqlConnection thisConnection = new SqlConnection(dbUtility.GetConnectionString("WirelessAdvocates.Properties.Settings.DataConnectionString"));
            thisConnection.Open();
            SqlCommand thisCommand = thisConnection.CreateCommand();

            thisCommand.CommandText = "SELECT ISNULL(rp.additionalLineBillCode, '') AS additionalLineBillCode FROM catalog.RatePlan AS rp WITH (NOLOCK) WHERE rp.CarrierBillCode = '" + BillCode + "'";

            SqlDataReader thisReader = thisCommand.ExecuteReader();

            if (thisReader != null)
            {
                while (thisReader.Read())
                {
                    GetAdditionalBillCodeReturn = thisReader["additionalLineBillCode"].ToString().Trim();
                }

                thisReader.Close();
            }

            thisConnection.Close();

            return GetAdditionalBillCodeReturn;
        }

        private string GetCurrentMDN(string ReferenceNumber)
        {
            string GetCurrentMDNReturn = "";

            SqlConnection thisConnection = new SqlConnection(dbUtility.GetConnectionString("WirelessAdvocates.Properties.Settings.DataConnectionString"));
            thisConnection.Open();
            SqlCommand thisCommand = thisConnection.CreateCommand();

            thisCommand.CommandText = "SELECT dbo.GetMDNFromXML('"+ReferenceNumber+"') AS currentMdn";

            SqlDataReader thisReader = thisCommand.ExecuteReader();

            if (thisReader != null)
            {
                while (thisReader.Read())
                {
                    GetCurrentMDNReturn = thisReader["currentMdn"].ToString().Trim();
                }

                thisReader.Close();
            }

            thisConnection.Close();

            return GetCurrentMDNReturn;
        }

        private string GetServiceZipCode(string ReferenceNumber)
        {
            string GetServiceZipCodeReturn = "";

            SqlConnection thisConnection = new SqlConnection(dbUtility.GetConnectionString("WirelessAdvocates.Properties.Settings.DataConnectionString"));
            thisConnection.Open();
            SqlCommand thisCommand = thisConnection.CreateCommand();

            thisCommand.CommandText = "SELECT dbo.GetServiceZipFromXML('" + ReferenceNumber + "') AS serviceZipCode";

            SqlDataReader thisReader = thisCommand.ExecuteReader();

            if (thisReader != null)
            {
                while (thisReader.Read())
                {
                    GetServiceZipCodeReturn = thisReader["serviceZipCode"].ToString().Trim();
                }

                thisReader.Close();
            }

            thisConnection.Close();

            return GetServiceZipCodeReturn;
        }

        private string GetPlanCodeReturn(string ReferenceNumber)
        {
            string GetPlanCodeReturn = "";

            SqlConnection thisConnection = new SqlConnection(dbUtility.GetConnectionString("WirelessAdvocates.Properties.Settings.DataConnectionString"));
            thisConnection.Open();
            SqlCommand thisCommand = thisConnection.CreateCommand();

            thisCommand.CommandText = "SELECT dbo.GetPlanCodeFromXML('" + ReferenceNumber + "') AS planCode";

            SqlDataReader thisReader = thisCommand.ExecuteReader();

            if (thisReader != null)
            {
                while (thisReader.Read())
                {
                    GetPlanCodeReturn = thisReader["planCode"].ToString().Trim();
                }

                thisReader.Close();
            }

            thisConnection.Close();

            return GetPlanCodeReturn;
        }    

        /// <summary>
        /// Accepts async xml order response.
        /// </summary>
        /// <param name="XMLResponse"></param>
        /// <returns></returns>
        [WebMethod()]
        public WirelessAdvocates.ServiceResponse.OrderResponse UpdateOrder(string XMLResponse)
        {
            WirelessAdvocates.ServiceResponse.OrderResponse response = new WirelessAdvocates.ServiceResponse.OrderResponse();

            oasOrderResponse resp = (oasOrderResponse)Interfaces.Helper.DeserializeXML(XMLResponse, typeof(oasOrderResponse));

            System.Diagnostics.Debug.WriteLine("Update Order Request:" + XMLResponse);

            try
            {
                // Map the response to an order number.
                WirelessAdvocates.SalesOrder.WirelessOrder wirelessOrder = new WirelessAdvocates.SalesOrder.WirelessOrder(resp.messageHeader.referenceNumber.Value);
                
                asyncOrderResponseType asyncOrder = (asyncOrderResponseType) resp.Item;

                int errorCode;
                
                if (asyncOrder == null || !int.TryParse(asyncOrder.errorCode, out errorCode) )
                {
                    WirelessAdvocates.Logger.Log.LogException("Invalid async response(" + XMLResponse + ")", "Verizon", "UpdateOrder", "");
                
                    throw new Exception("Invalid async response received");
                }
                
                if (resp.messageHeader != null && resp.messageHeader.referenceNumber != null)
                {
                    WirelessAdvocates.Logger.Log.LogResponse(XMLResponse, "Verizon", "UpdateOrder", resp.messageHeader.referenceNumber.Value);
                }

                if (errorCode == 0)
                {
                    response.ErrorCode = (int)ServiceResponseCode.Success;
                    wirelessOrder.ActivationStatus = (int)WirelessAdvocates.Common.ActivationStatus.Success;

                    wirelessOrder.CarrierOrderId = asyncOrder.billingSystemOrderNumber;
                    DateTime orderDate;
                
                    if (DateTime.TryParse( asyncOrder.orderTimeStamp, out orderDate))
                    {
                        wirelessOrder.CarrierOrderDate = orderDate;
                    }   
                    
                    foreach (WirelessAdvocates.SalesOrder.WirelessLine line in wirelessOrder.WirelessLines)
                    {
                        line.ActivationStatus = ActivationStatus.Failure; // default unless match
                    
                        int wirelessLineId = 0;
                        
                        foreach (lineResponseType vzLine in asyncOrder.lines)
                        {
                            string[] subreferenceParts = vzLine.subReferenceNumber.Value.Split('-');
                        
                            if (subreferenceParts == null || subreferenceParts.Length != 2)
                            {
                                throw new Exception(string.Format("Unexpected line format in order response {0}", vzLine.subReferenceNumber.Value));
                            }
                            else
                            {
                                if (!int.TryParse(subreferenceParts[1], out wirelessLineId))
                                {
                                    throw new Exception(string.Format("Unexpected line id, not an integer {0}", subreferenceParts[1]));
                                }
                            }

                            if (line.WirelessLineId == wirelessLineId)
                            {

                                if (vzLine.mdn != null)
                                {
                                    line.CurrentMDN = vzLine.mdn.Value;
                                    line.NewMDN = null;
                                }
                            
                                line.Save();
                                
                                break;
                            }
                        }
                    }

                    wirelessOrder.Save();
                }
                else
                {
                    response.ErrorCode = (int)ServiceResponseCode.Failure;
                    wirelessOrder.ActivationStatus = (int)WirelessAdvocates.Common.ActivationStatus.Failure;
                }
            }
            catch (Exception e)
            {
                response.ErrorCode = (int)ServiceResponseCode.Failure;
                WirelessAdvocates.Logger.Log.LogResponse(e.Message, "Verizon", "UpdateOrder", resp.messageHeader.referenceNumber.Value);
            }

            return response;
        }
    
        [WebMethod()]
        public AddressValidationResponse TestValidateAddress(string TestReferenceNumber)
        {
            // Build a valid address
            WirelessAdvocates.Address address = new WirelessAdvocates.Address();
            address.AddressLine1 = "1027 Bellevue Ct";
            address.AddressLine2 = "#406";
            address.City = "Seattle";
            address.State = "WA";
            address.ZipCode = "98102";
            //address.Country = "USA";
            
            WirelessAdvocates.ServiceResponse.AddressValidationResponse response = ValidateAddress(address, WirelessAdvocates.Address.AddressType.Billing, TestReferenceNumber);

            return response;
        }
    }
}