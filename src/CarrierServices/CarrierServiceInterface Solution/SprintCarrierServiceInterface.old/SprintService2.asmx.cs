using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using WirelessAdvocates;
using System.Collections.Generic;
using SprintCarrierServiceInterface.Interfaces.SprintServiceBus;

using SprintCarrierServiceInterface.Interfaces.controller.NpaResponse;
using SprintCarrierServiceInterface.Interfaces.controller.PortValidationResponse;
using SprintCarrierServiceInterface.Interfaces.controller.CheckCreditResponse;
using SprintCarrierServiceInterface.Interfaces.controller.CustomerValidationResponse;
using SprintInterfaces = SprintCarrierServiceInterface.Interfaces;

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
        /// 2. Providing the range of the vaue of the data type used by the object
        /// </summary>
        /// <returns></returns>
        SprintServiceBus serviceBus = new SprintServiceBus();

        [WebMethod]
        public NpaResponse NpaLookupByZip(string zipCode, string referenceNumber)
        {
            NpaResponse response = new NpaResponse();
           
            SprintInterfaces.model.getNpaNxx.NpaNxxResponse request = serviceBus.NpaNxx(zipCode, referenceNumber);

            foreach (SprintInterfaces.model.getNpaNxx.NpaNxxInfo npaInfo in request.npanxxinfo)
            {
                SprintInterfaces.controller.NpaResponse.NpaInfo thisNpa = new SprintInterfaces.controller.NpaResponse.NpaInfo();
                //members to return NpaSet(coldfusion method)
                thisNpa.Npa = npaInfo.npanxx.Substring(0, 3);
                thisNpa.NpaNxx = npaInfo.npanxx;
                thisNpa.Ngp = String.Empty;
                thisNpa.Description = npaInfo.ratecenter;
                response.NpaSet.Add(thisNpa);
            }
            return response;
        }

        [WebMethod]
        public PortValidationResponse ValidatePortIn(List<SprintInterfaces.controller.PortValidationResponse.MDNSet> MDNList, string referenceNumber)
        {
            PortValidationResponse response = new PortValidationResponse();
           
            SprintInterfaces.model.getPortInInfo.PortResponse request = serviceBus.PortEligibility(MDNList, referenceNumber);

            foreach (SprintInterfaces.model.getPortInInfo.PortResponseInfo portInfo in request.portresponseinfo)
            {
                SprintInterfaces.controller.PortValidationResponse.MDNSet thisMdn = new SprintInterfaces.controller.PortValidationResponse.MDNSet();

                thisMdn.MDN = portInfo.portinnumber; //mdn number : int (phone number)
                thisMdn.IsPortable = portInfo.porteligibility; //IsPortable bool
                thisMdn.serviceZipCode = String.Empty;
                response.MDNSet.Add(thisMdn);
            }
            return response;
        }

        [WebMethod]
        public CheckCreditResponse CheckCredit(List<SprintInterfaces.controller.CheckCreditResponse.CheckCreditResponse.Names> billingName, string servicezipcode, List<SprintInterfaces.controller.CheckCreditResponse.CheckCreditResponse.PersonalInfo> contactInfo, List<SprintInterfaces.controller.CheckCreditResponse.CheckCreditResponse.PersonalCreds> billingContactCredentials, int numberOfLines, string existingCustomerMDN, string referenceNumber)
     // public CheckCreditResponse CheckCredit(string billingName, string servicezipcode, string contactInfo, string billingContactCredentials, string numberOfLines, string existingCustomerMDN, string referenceNumber)
        {
            // Get a valid response from CreditResponse of ServiceBus

            SprintInterfaces.model.doCreditCheck.CreditResponse request = serviceBus.CreditCheck2(billingName, servicezipcode, contactInfo, billingContactCredentials,numberOfLines, existingCustomerMDN, referenceNumber);
            
            CheckCreditResponse response = new CheckCreditResponse();
                SprintInterfaces.controller.CheckCreditResponse.CheckCreditResponse.CheckCreditResponseSet thisCreditChk = new SprintInterfaces.controller.CheckCreditResponse.CheckCreditResponse.CheckCreditResponseSet();

                // try here
                
                thisCreditChk.PrimaryErrorMessage = String.Empty;
                thisCreditChk.CreditCode = String.Empty;
                thisCreditChk.CreditStatus = String.Empty;
//                thisCreditChk.CreditStatus = request.result.ToString();

               // thisCreditChk.CreditApplicationNumber = Convert.ToInt16(request.appnumber);
                //thisCreditChk.Deposit = Convert.ToDouble(request.totaldeposit);
                thisCreditChk.CreditApplicationNumber = 0;
                thisCreditChk.Deposit = 0.00;
                thisCreditChk.CustomerAccountNumber = 0;
                thisCreditChk.NoOfLines = 1;
                thisCreditChk.ErrorCode = String.Empty;
            return response;
        }

        [WebMethod]
       // public CustomerValidationResponse CustomerLookupByMsiSdn(string referenceNumber)
        public CustomerValidationResponse CustomerLookupByMsiSdn(int msiSdn, int billingZip, int pin, int referenceNumber)
        {
            //get valid response from AccountValidationResponse of ServiceBus
            SprintCarrierServiceInterface.Interfaces.model.doAccountValidation.AccountValidationResponse request = serviceBus.AccountValidation(msiSdn, billingZip, pin, referenceNumber);
         //   SprintCarrierServiceInterface.Interfaces.model.doAccountValidation.AccountValidationResponse request = serviceBus.AccountValidation(referenceNumber);
            CustomerValidationResponse response = new CustomerValidationResponse();
            
            SprintInterfaces.controller.CustomerValidationResponse.CustomerLookupbyMDNInfo thisCustLkUp = new  CustomerLookupbyMDNInfo();

            thisCustLkUp.ErrorCode = 0;
            thisCustLkUp.ServiceResponseSubCode = 0;
            thisCustLkUp.CustomerAccountNumber = 0;
            thisCustLkUp.IsEquipmentUpgradeAvailable = false;
            thisCustLkUp.ExistingAccountMonthlyCharges = 0;
            thisCustLkUp.WirelessAccountType = String.Empty;
            thisCustLkUp.LinesAvailable = false;
            thisCustLkUp.IsPrimaryLine = false;
            thisCustLkUp.ExistingLineMonthlyCharges = 0;
            response.CustLookupByMDNInfoSet.Add(thisCustLkUp);
           return response;
        }

        [WebMethod]
        public int ErrorCode()
        { 
            return 111;
        }

         [WebMethod] //Test for web service - cold fusion connectivity
        public string Echo(string str)
        {
            str = "Testing";
            return str;
        }

        // Tests for Services to be moved to a diff file
       //[WebMethod]
       
    }
}
