// --------------------------------------------------------------------------------------------------------------------
// <copyright file="TMobileService.asmx.cs" company="">
//   
// </copyright>
// <summary>
//   The activation management.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace TMobileCarrierServiceInterface
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Diagnostics;
    using System.IO;
    using System.Linq;
    using System.Security.Cryptography.X509Certificates;
    using System.Web;
    using System.Web.Script.Services;
    using System.Web.Services;

    using Microsoft.Web.Services2.Security.Tokens;

    using TMobileCarrierServiceInterface.Implementation;
    using TMobileCarrierServiceInterface.Interfaces.Activation;
    using TMobileCarrierServiceInterface.Interfaces.AddressVerification;
    using TMobileCarrierServiceInterface.Interfaces.Common;
    using TMobileCarrierServiceInterface.Interfaces.CustomerLookup;
    using TMobileCarrierServiceInterface.Interfaces.CustomerQualification;
    using TMobileCarrierServiceInterface.Interfaces.HandsetUpgrade;
    using TMobileCarrierServiceInterface.Interfaces.NpaNxxLookup;
    using TMobileCarrierServiceInterface.Interfaces.PortIn;
    using TMobileCarrierServiceInterface.Interfaces.RateplanChange;
    using TMobileCarrierServiceInterface.Interfaces.RateplanConversionValidation;
    using TMobileCarrierServiceInterface.Interfaces.RsaToken;

    using WirelessAdvocates;
    using WirelessAdvocates.Enum;
    using WirelessAdvocates.Logger;
    using WirelessAdvocates.SalesOrder;
    using WirelessAdvocates.ServiceResponse;

    using AccountTypeEnum = TMobileCarrierServiceInterface.Interfaces.Common.AccountTypeEnum;
    using AccountTypeSubTypeEnum = TMobileCarrierServiceInterface.Interfaces.Common.AccountTypeSubTypeEnum;
    using Address = WirelessAdvocates.Address;
    using CustomerStatusEnum = TMobileCarrierServiceInterface.Interfaces.CustomerQualification.CustomerStatusEnum;
    using ItemChoiceType = TMobileCarrierServiceInterface.Interfaces.CustomerQualification.ItemChoiceType;
    using Service = TMobileCarrierServiceInterface.Interfaces.Activation.Service;

    /// <summary>The t mobile service.</summary>
    [WebService(Namespace = "http://WirelessAdvocates.TMobileCarrierServiceInterface/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [ToolboxItem(false)]
    public class TMobileService : WebService
    {
        #region Constants

        /// <summary>The carrier.</summary>
        private const string CARRIER = "TMobile";

        #endregion

        #region Public Methods and Operators

        /// <summary>The can automatically upgrade.</summary>
        /// <param name="OrderNumber">The order number.</param>
        /// <returns>The <see cref="bool"/>.</returns>
        [WebMethod]
        public bool CanAutomaticallyUpgrade(string OrderNumber)
        {
            // get the details of the order from the database.
            var wirelessOrder = new WirelessOrder(Convert.ToInt32(OrderNumber));

            var activation = new ActivationManagement(wirelessOrder);
            return this.checkServicesUpgrade(activation);
        }

        /// <summary>The check credit.</summary>
        /// <param name="billingName">The billing name.</param>
        /// <param name="serviceZipCode">The service zip code.</param>
        /// <param name="contactInfo">The contact info.</param>
        /// <param name="billingContactCredentials">The billing contact credentials.</param>
        /// <param name="numberOfLines">The number of lines.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="CreditCheckResponse"/>.</returns>
        [WebMethod]
        public CreditCheckResponse CheckCredit(Name billingName, string serviceZipCode, Contact contactInfo, PersonalCredentials billingContactCredentials, int numberOfLines, string referenceNumber)
        {
            var tmoService = new CustomerQualificationService();
            var tmoRequest = new CustomerQualificationRequest();
            var tmoResponse = new CustomerQualificationResponse();
            CreditCheckResponse response = null;

            try
            {
                tmoService.Url = this.GetUrl("CreditCheckEndpoint");
                this.AddCerts(tmoService.ClientCertificates);
                tmoRequest.header = this.GetHeader(referenceNumber);
                tmoService.RequestSoapContext.Security.Tokens.Add(this.GetUsernameToken());

                tmoRequest.creditApplication = new CreditApplication();

                tmoRequest.acceptedCreditcheck = true;
                tmoRequest.creditApplication.billingAddress = new Interfaces.CustomerQualification.Address();

                tmoRequest.creditApplication.firstName = billingName.FirstName;
                tmoRequest.creditApplication.lastName = billingName.LastName;

                if (!string.IsNullOrEmpty(billingName.MiddleInitial) && billingName.MiddleInitial.Trim().Length > 0)
                {
                    // || billingName.MiddleInitial.Trim().Length == 0)
                    tmoRequest.creditApplication.middleInitial = billingName.MiddleInitial;
                }

                tmoRequest.creditApplication.nameSuffix = billingName.Suffix;
                tmoRequest.creditApplication.nameTitle = billingName.Prefix;

                // Load billing address from the database
                var billingAddress = (ExtendedAddress)(new CheckoutSessionState()).GetByReference(referenceNumber, Address.AddressEnum.Billing.ToString(), "AddressValidation", typeof(ExtendedAddress));
                tmoRequest.creditApplication.billingAddress.address1 = billingAddress.AddressLine1;
                tmoRequest.creditApplication.billingAddress.address2 = billingAddress.AddressLine2;
                tmoRequest.creditApplication.billingAddress.city = billingAddress.City;
                tmoRequest.creditApplication.billingAddress.state = (StateEnum)Enum.Parse(typeof(StateEnum), billingAddress.State, true);
                tmoRequest.creditApplication.billingAddress.zipCode = billingAddress.ZipCode;

                tmoRequest.creditApplication.billingAddress.zipCodeExtension = billingAddress.ExtendedZipCode;
                tmoRequest.creditApplication.billingAddress.uncertaintyIndSpecified = false;

                // populate personal contact information
                tmoRequest.creditApplication.emailAddress = contactInfo.Email;
                tmoRequest.creditApplication.homePhone = contactInfo.EveningPhone;
                tmoRequest.creditApplication.mobileNumber = contactInfo.CellPhone;
                tmoRequest.creditApplication.workPhone = contactInfo.WorkPhone;

                tmoRequest.creditApplication.contract = true;
                tmoRequest.creditApplication.contractSpecified = false;

                // Populate credentials
                tmoRequest.creditApplication.dateOfBirth = billingContactCredentials.Dob;
                tmoRequest.creditApplication.identification = new PersonalIdentification
                                                                  {
                                                                      idExpirationDate = billingContactCredentials.IdExpiration, 
                                                                      idExpirationDateSpecified = true, 
                                                                      idIssuingState = (StateEnum)Enum.Parse(typeof(StateEnum), billingContactCredentials.State, true), 
                                                                      idIssuingStateSpecified = true, 
                                                                      idNumber = billingContactCredentials.Id, 
                                                                      idType =
                                                                          (IdTypeEnum)
                                                                          Enum.Parse(
                                                                              typeof(IdTypeEnum), 
                                                                              Enum.GetName(typeof(PersonalCredentials.IdentificationType), billingContactCredentials.IdType), 
                                                                              true), 
                                                                      idTypeSpecified = true
                                                                  };
                tmoRequest.creditApplication.ItemElementName = ItemChoiceType.ssn;
                tmoRequest.creditApplication.Item = billingContactCredentials.SSN;

                new Log().LogRequest(new Utility().SerializeXML(tmoRequest), CARRIER, "CreditCheck", referenceNumber);

                tmoResponse = tmoService.submitCreditApplication(tmoRequest);

                new Log().LogResponse(new Utility().SerializeXML(tmoResponse), CARRIER, "CreditCheck", referenceNumber);

                response = this.MapTMOCreditResponse(numberOfLines, tmoRequest, tmoResponse, referenceNumber);

                response.CreditCode = tmoResponse.customerQualificationInfo != null ? tmoResponse.customerQualificationInfo.creditScore : string.Empty;

                if (tmoResponse.customerQualificationInfo != null && tmoResponse.customerQualificationInfo.customerQualificationResult != null
                    && tmoResponse.customerQualificationInfo.customerQualificationResult.Length > 0)
                {
                    response.CreditApplicationNumber = tmoResponse.customerQualificationInfo.customerQualificationResult[0].creditApplicationRefNumber;
                    response.CustomerAccountNumber = tmoResponse.customerQualificationInfo.customerQualificationResult[0].ban;
                }
            }
            catch (Exception ex)
            {
                if (response == null)
                {
                    response = new CreditCheckResponse();
                }

                response.ErrorCode = (int)ServiceResponseCode.Failure;

                response.ServiceResponseSubCode = tmoResponse.serviceStatus.serviceStatusCode.Equals(ServiceStatusEnum.Item102) ? (int)ServiceStatusEnum.Item102 : 0;

                response.PrimaryErrorMessage = ex.Message;

                var trace = new StackTrace(ex, true);

                new Log().LogException(
                    "EX " + ex.Message + " ST: " + ex.StackTrace + "Line: " + trace.GetFrame(0).GetFileLineNumber() + "Column: " + trace.GetFrame(0).GetFileColumnNumber(), 
                    CARRIER, 
                    "CreditCheck", 
                    referenceNumber);
            }

            new Log().LogOutput(new Utility().SerializeXML(response), CARRIER, "CreditCheck", referenceNumber);

            return response;
        }

        /// <summary>The check elig.</summary>
        /// <param name="orderId">The order id.</param>
        /// <param name="msiSdn">The msi sdn.</param>
        /// <returns>The <see cref="string"/>.</returns>
        [WebMethod]
        public string CheckElig(int orderId, string msiSdn)
        {
            var checkSocChangeEligibility = new CheckSocChangeEligibility(orderId, msiSdn);
            return checkSocChangeEligibility.UpgradeEligible().ToString();
        }

        /// <summary>The customer lookup.</summary>
        /// <param name="mdn">The mdn.</param>
        /// <param name="pin">The pin.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="CustomerLookupByMSISDNResponse"/>.</returns>
        [WebMethod]
        public CustomerLookupByMSISDNResponse CustomerLookup(string mdn, string pin, string referenceNumber)
        {
            var tmoRequest = new CustomerLookupByMSISDNRequest();
            CustomerLookupByMSISDNResponse tmoResponse = null;

            var tmoService = new CustomerLookupService();

            if (string.IsNullOrEmpty(mdn) || string.IsNullOrEmpty(pin))
            {
                mdn = (new CheckoutSessionState()).GetByReference(referenceNumber, "MDN", "CustomerLookup");
                pin = (new CheckoutSessionState()).GetByReference(referenceNumber, "PIN", "CustomerLookup");
            }

            try
            {
                this.AddCerts(tmoService.ClientCertificates);
                tmoService.RequestSoapContext.Security.Tokens.Add(this.GetUsernameToken());
                tmoService.Url = this.GetUrl("CustomerLookupEndPoint");

                tmoRequest.header = this.GetHeader(referenceNumber);
                tmoRequest.msisdn = mdn;
                tmoRequest.pin = pin;

                new Log().LogRequest(new Utility().SerializeXML(tmoRequest), CARRIER, "LookupByMDN", referenceNumber);

                tmoResponse = tmoService.lookupByMSISDN(tmoRequest);

                new Log().LogResponse(new Utility().SerializeXML(tmoResponse), CARRIER, "LookupByMDN", referenceNumber);
            }
                
                // TODO HANDLE KNOWN CONDITIONS
                // catch (SoapException sx)
                // {
                // Switch (sx.Code
                // //18001	Provided lookup value is invalid
                // //18002	No Customer data found
                // //18003	Provided CustomerID is invalid
                // //18004	No Subscriber data found
                // //18005	Invalid AccountType returned in CustomerLookup.
                // //18006	No Account data found
                // //18007	Too many Customer records found
                // //18008	Invalid ID Type found in CustomerLookup.
                // //18009	CustomerLookup By WIPCustomerID FAILED
                // //18016	Ban with large number of subscribers
                // //18017	Account number or MSISDN are missing. Either the account number of MSISDN are required.
                // //18018	The PIN submitted does not match the account pin or the last 4 digits of SSN.
                // //18019	Existing customer rateplan not available for sale to the requested partner.
                // //18020	PIN is not specified in the request
                // }
            catch
            {
                throw;
            }

            return tmoResponse;
        }

        /// <summary>The customer lookup by msi sdn.</summary>
        /// <param name="msiSdn">The msi sdn.</param>
        /// <param name="pin">The pin.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="CustomerInquiryResponse"/>.</returns>
        [WebMethod]
        public CustomerInquiryResponse CustomerLookupByMsiSdn(string msiSdn, string pin, string referenceNumber)
        {
            var tmoRequest = new CustomerLookupByMSISDNRequest();
            CustomerLookupByMSISDNResponse tmoResponse;
            var tmoService = new CustomerLookupService();
            var response = new CustomerInquiryResponse();

            this.AddCerts(tmoService.ClientCertificates);
            tmoService.RequestSoapContext.Security.Tokens.Add(this.GetUsernameToken());
            tmoService.Url = this.GetUrl("CustomerLookupEndPoint");

            tmoRequest.header = this.GetHeader(referenceNumber);
            tmoRequest.msisdn = msiSdn;
            tmoRequest.pin = pin;

            (new CheckoutSessionState()).Add(referenceNumber, "MDN", "CustomerLookup", msiSdn);
            (new CheckoutSessionState()).Add(referenceNumber, "PIN", "CustomerLookup", pin);

            try
            {
                new Log().LogRequest(new Utility().SerializeXML(tmoRequest), CARRIER, "ServiceCustomerLookup", referenceNumber);

                tmoResponse = tmoService.lookupByMSISDN(tmoRequest);

                new Log().LogResponse(new Utility().SerializeXML(tmoResponse), CARRIER, "ServiceCustomerLookup", referenceNumber);

                if (tmoResponse.customerDetails == null)
                {
                    response.ServiceResponseSubCode = (int)ServiceResponseSubCode.ClCustomerNotFound;
                    response.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.ClCustomerNotFound);
                }
                else
                {
                    response.CustomerAccountNumber = tmoResponse.accountDetails.ban;

                    response.AuthorizedUserName1 = string.Empty;
                    if (tmoResponse.accountDetails.authUser1Name != null)
                    {
                        response.AuthorizedUserName1 = tmoResponse.accountDetails.authUser1Name;
                    }

                    response.AuthorizedUserName2 = string.Empty;
                    if (tmoResponse.accountDetails.authUser2Name != null)
                    {
                        response.AuthorizedUserName2 = tmoResponse.accountDetails.authUser2Name;
                    }

                    (new CheckoutSessionState()).Add(referenceNumber, "BAN", "CustomerLookup", tmoResponse.accountDetails.ban);

                    if (tmoResponse.accountDetails != null && !ValidCustomerType(tmoResponse.accountDetails.accountTypeCode, tmoResponse.accountDetails.accountSubTypeCode))
                    {
                        response.ErrorCode = (int)ServiceResponseCode.Success;
                        response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CL_UNSUPPORTED_CUSTOMER_TYPE;
                        response.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.CL_UNSUPPORTED_CUSTOMER_TYPE);

                        new Log().LogOutput(new Utility().SerializeXML(response), CARRIER, "ServiceCustomerLookup", referenceNumber);

                        return response;
                    }

                    response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CL_CUSTOMER_FOUND;

                    var responseLine = new CustomerInquiryLine();
                    response.WirelessAccountType = WirelessAccountType.Individual;

                    responseLine.WirelessLineType = WirelessLineType.Line;
                    response.WirelessAccountType = WirelessAccountType.Individual;

                    if (tmoResponse.subscriberDetails.ratePlan != null && tmoResponse.subscriberDetails.ratePlan.rateplanInfo != null)
                    {
                        responseLine.ExistingLineMonthlyCharges = tmoResponse.subscriberDetails.ratePlan.rateplanInfo.price;

                        switch (tmoResponse.subscriberDetails.ratePlan.rateplanInfo.planType)
                        {
                            case PlanTypeEnum.POOLING:
                                response.WirelessAccountType = WirelessAccountType.Family;
                                break;
                            case PlanTypeEnum.DATA_ONLY:
                                responseLine.WirelessLineType = WirelessLineType.Data;
                                break;
                        }
                    }

                    response.ExistingAccountMonthlyCharges = 0; // Will be included in the line data;
                    responseLine.UpgradeAvailableSpecified = tmoResponse.subscriberDetails.canUpgradeSpecified;
                    responseLine.EquipmentUpgradeAvailable = tmoResponse.subscriberDetails.canUpgrade == EligibilityLevel.YES || tmoResponse.subscriberDetails.canUpgrade == EligibilityLevel.PARTIAL;
                    responseLine.UpgradeAvailableDate = this.GetEligible(tmoResponse.customerDetails.billingAddress.zipCode, msiSdn, pin, referenceNumber);

                    if (tmoResponse.customerDetails.billingAddress != null)
                    {
                        responseLine.BillingAddress = new Address();
                        this.CopyAddress(tmoResponse.customerDetails.billingAddress, responseLine.BillingAddress);
                    }

                    if (tmoResponse.subscriberDetails.ppuAddress != null)
                    {
                        responseLine.ShippingAddress = new Address();
                        this.CopyAddress(tmoResponse.subscriberDetails.ppuAddress, responseLine.ShippingAddress);
                    }

                    responseLine.AccountStatus = this.MapAccountStatus(tmoResponse.accountDetails.accountStatusCode);

                    responseLine.ExistingLineMonthlyCharges = tmoResponse.subscriberDetails.ratePlan.rateplanInfo.price;
                    responseLine.PlanCode = tmoResponse.subscriberDetails.ratePlan.rateplanInfo.rateplanCode;

                    response.CustomerInquiryLines.Add(responseLine);

                    if (tmoResponse.accountDetails != null)
                    {
                        responseLine.ContractStartSpecified = false;
                        responseLine.ContractStart = tmoResponse.accountDetails.serviceStartDate;
                        response.ErrorCode = (int)ServiceResponseCode.Success;

                        (new CheckoutSessionState()).Add(referenceNumber, "WIP", ServiceMethods.CreditCheck.ToString(), tmoResponse.customerQualificationInfo.wipCustomerId);
                        if (tmoResponse.customerQualificationInfo != null && tmoResponse.customerQualificationInfo.customerQualificationResult != null
                            && tmoResponse.customerQualificationInfo.customerQualificationResult.Length > 0)
                        {
                            int linesActive;

                            if (int.TryParse(tmoResponse.customerQualificationInfo.numberOfLinesActive, out linesActive))
                            {
                                response.LinesActive = linesActive;
                            }

                            foreach (var qualResult in
                                tmoResponse.customerQualificationInfo.customerQualificationResult)
                            {
                                if (qualResult.accountEligibility != AccountEligibilityEnum.EXISTING || qualResult.billingAccountType != BillingAccountTypeEnum.POSTPAID)
                                {
                                    continue;
                                }

                                // Only take the lines approved without deposit if specified.
                                int linesApproved;
                                if (qualResult.lineDeposits != null && qualResult.lineDeposits.numberOfLinesWithoutDeposit != null)
                                {
                                    if (int.TryParse(qualResult.lineDeposits.numberOfLinesWithoutDeposit, out linesApproved))
                                    {
                                        response.LinesApproved = linesApproved;
                                    }
                                }
                                else
                                {
                                    if (int.TryParse(qualResult.numberOfLinesApproved, out linesApproved))
                                    {
                                        response.LinesApproved = linesApproved;
                                    }
                                }

                                break;
                            }

                            response.LinesAvailable = response.LinesApproved - response.LinesActive;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                response.ErrorCode = (int)ServiceResponseCode.Failure;
                response.PrimaryErrorMessage = ex.Message + ex.StackTrace;

                new Log().LogException(ex.Message, CARRIER, "ServiceCustomerLookup", referenceNumber);
            }

            new Log().LogOutput(new Utility().SerializeXML(response), CARRIER, "ServiceCustomerLookup", referenceNumber);

            return response;
        }

        /// <summary>The download catalog.</summary>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="string"/>.</returns>
        [WebMethod]
        public string DownloadCatalog(string referenceNumber)
        {
            return new ProductCatalog(referenceNumber).RetrieveCatalog();
        }

        /// <summary>The generate rsa token for kiosk.</summary>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="GenerateRsaOneTimeTokenResponse"/>.</returns>
        [WebMethod]
        public GenerateRsaOneTimeTokenResponse GenerateRSATokenForKiosk(string referenceNumber)
        {
            var response = string.Empty;

            var tmoService = new RsaTokenService();
            var tmoRequest = new GenerateRsaOneTimeTokenRequest();
            var tmoResponse = new GenerateRsaOneTimeTokenResponse();

            tmoService.Url = "https://rsp-ext.t-mobile.com:6448/eProxy/service/RsaTokenService_SOAP_V1";
            this.AddCerts(tmoService.ClientCertificates);

            tmoRequest.header = this.GetHeader(referenceNumber);

            tmoService.RequestSoapContext.Security.Tokens.Add(this.GetUsernameToken());
            tmoService.RequestSoapContext.Security.Timestamp.TtlInSeconds = 86400;

            tmoResponse = tmoService.generateRsaOneTimeToken(tmoRequest);

            // response = tmoResponse;
            return tmoResponse;
        }

        /// <summary>The generate rsa token for kiosk pit.</summary>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="GenerateRsaOneTimeTokenResponse"/>.</returns>
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Xml)]
        public GenerateRsaOneTimeTokenResponse GenerateRSATokenForKioskPit(string referenceNumber)
        {
            var response = string.Empty;

            var tmoService = new RsaTokenService();
            var tmoRequest = new GenerateRsaOneTimeTokenRequest();
            var tmoResponse = new GenerateRsaOneTimeTokenResponse();

            tmoService.Url = "https://rsp-pit.t-mobile.com:6556/eProxy/service/RsaTokenService_SOAP_V1";
            this.AddCerts(tmoService.ClientCertificates);

            tmoRequest.header = this.GetHeader(referenceNumber);

            tmoService.RequestSoapContext.Security.Tokens.Add(this.GetUsernameToken());
            tmoService.RequestSoapContext.Security.Timestamp.TtlInSeconds = 86400;

            tmoResponse = tmoService.generateRsaOneTimeToken(tmoRequest);

            return tmoResponse;
        }

        /// <summary>The get eligible.</summary>
        /// <param name="zipCode">The zip code.</param>
        /// <param name="msiSdn">The msi sdn.</param>
        /// <param name="pin">The pin.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="string"/>.</returns>
        [WebMethod]
        public string GetEligible(string zipCode, string msiSdn, string pin, string referenceNumber)
        {
            var history = string.Empty;

            GetAllSubscribersEligibilityRequest req = null;
            GetAllSubscribersEligibilityResponse resp = null;

            try
            {
                req = new GetAllSubscribersEligibilityRequest();

                var tmoService2 = new HandsetUpgradeService();

                this.AddCerts(tmoService2.ClientCertificates);
                tmoService2.RequestSoapContext.Security.Tokens.Add(this.GetUsernameToken());
                tmoService2.Url = this.GetUrl("HandsetUpgradeEndpoint");

                req.header = this.GetHeader(referenceNumber);
                req.ItemElementName = Interfaces.HandsetUpgrade.ItemChoiceType.msisdn;
                req.Item = msiSdn;
                req.allSubscribers = true;
                req.zipCode = zipCode;

                new Log().LogRequest(new Utility().SerializeXML(req), CARRIER, "getAllSubscribers", referenceNumber);

                resp = tmoService2.getAllSubscribersEligibility(req);
                if (resp != null)
                {
                    new Log().LogResponse(new Utility().SerializeXML(resp), CARRIER, "getAllSubscribers", referenceNumber);

                    if (resp.subscriberEligibility != null)
                    {
                        foreach (
                            var sd in resp.subscriberEligibility.Where(sd => (sd.msisdn == msiSdn) && (sd.eligibilityDetails.eligibilityLevel == EligibilityLevel.NO)))
                        {
                            if ((sd.eligibilityDetails.nextEligibilityDate.ToString().Length > 0) && (sd.eligibilityDetails.nextEligibilityDate.ToString() != "1/1/0001 12:00:00 AM"))
                            {
                                try
                                {
                                    history = DateTime.Parse(sd.eligibilityDetails.nextEligibilityDate.ToString()).ToString("d");
                                }
                                catch (Exception ex)
                                {
                                    new Log().LogException(ex.Message, CARRIER, "getAllSubscribers", referenceNumber);
                                }

                                break;
                            }

                            if ((sd.eligibilityDetails.contractEndDate.ToString().Length <= 0) || (sd.eligibilityDetails.contractEndDate.ToString() == "1/1/0001 12:00:00 AM"))
                            {
                                continue;
                            }

                            try
                            {
                                history = DateTime.Parse(sd.eligibilityDetails.contractEndDate.ToString()).ToString("d");
                            }
                            catch (Exception ex)
                            {
                                new Log().LogException(ex.Message, CARRIER, "getAllSubscribers", referenceNumber);
                            }

                            break;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                new Log().LogException(ex.Message, CARRIER, "getAllSubscribers", referenceNumber);

                // history +=  ex.Message + " errorLocation: " + errorlocation;
            }

            return history;
        }

        /// <summary>The npa lookup by zip.</summary>
        /// <param name="zipCode">The zip code.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="NpaResponse"/>.</returns>
        [WebMethod]
        public NpaResponse NpaLookupByZip(string zipCode, string referenceNumber)
        {
            var response = new NpaResponse();

            var tmoRequest = new NpaLookupByZipRequestType();
            NpaNxxLookupResponse tmoResponse;
            var tmoService = new NpaNxxLookupService();

            this.AddCerts(tmoService.ClientCertificates);
            tmoService.RequestSoapContext.Security.Tokens.Add(this.GetUsernameToken());
            tmoService.Url = this.GetUrl("NpaLookupEndPoint");

            tmoRequest.header = this.GetHeader(referenceNumber);
            tmoRequest.zipCode = zipCode;

            try
            {
                new Log().LogRequest(new Utility().SerializeXML(tmoRequest), CARRIER, "NpaLookupByZip", referenceNumber);

                tmoResponse = tmoService.getNpaByZip(tmoRequest);

                new Log().LogResponse(new Utility().SerializeXML(tmoResponse), CARRIER, "NpaLookupByZip", referenceNumber);

                if (tmoResponse.serviceStatus != null && tmoResponse.serviceStatus.serviceStatusCode == ServiceStatusEnum.Item100)
                {
                    response.ErrorCode = (int)ServiceResponseCode.Success;
                    response.NpaSet = new List<NpaInfo>();

                    foreach (var tmoNpa in tmoResponse.npaNxx)
                    {
                        var npaItem = new NpaInfo();
                        npaItem.Description = tmoNpa.description;
                        npaItem.MarketCode = tmoNpa.marketCode;
                        npaItem.Ngp = tmoNpa.ngp;
                        npaItem.Npa = tmoNpa.npa;
                        npaItem.NpaNxx = tmoNpa.npaNxx;
                        response.NpaSet.Add(npaItem);
                    }
                }
                else
                {
                    response.ErrorCode = (int)ServiceResponseCode.Failure;

                    if (tmoResponse.serviceStatus != null)
                    {
                        if (tmoResponse.serviceStatus.serviceStatusItem != null)
                        {
                            foreach (var item in tmoResponse.serviceStatus.serviceStatusItem)
                            {
                                response.PrimaryErrorMessage += item.statusCode + "-" + item.statusDescription + "|";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                response.ErrorCode = (int)ServiceResponseCode.Failure;
                response.PrimaryErrorMessage = ex.Message;
                new Log().LogException(ex.Message, CARRIER, "NpaLookupByZip", referenceNumber);
            }

            new Log().LogOutput(new Utility().SerializeXML(response), CARRIER, "NpaLookupByZip", referenceNumber);

            return response;
        }

        /// <summary>The submit order.</summary>
        /// <param name="OrderNumber">The order number.</param>
        /// <returns>The <see cref="OrderActivationResponse"/>.</returns>
        [WebMethod]
        public OrderActivationResponse SubmitOrder(string OrderNumber)
        {
            var response = new OrderActivationResponse();

            var referenceNumber = string.Empty;
            var customerWip = string.Empty;

            // get the details of the order from the database.
            WirelessOrder wirelessOrder = null;

            try
            {
                wirelessOrder = new WirelessOrder(Convert.ToInt32(OrderNumber));
            }
            catch (Exception ex)
            {
                response.ErrorCode = 1;
                response.ServiceResponseSubCode = (int)ServiceResponseSubCode.ACT_INVALID_ORDER_NUMBER;
                response.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.ACT_INVALID_ORDER_NUMBER);

                new Log().LogResponse(new Utility().SerializeXML(response) + ex.Message, CARRIER, "SubmitOrderGetWirelessOrder", referenceNumber);

                return response;
            }

            referenceNumber = wirelessOrder.CheckoutReferenceNumber;

            CustomerLookupByMSISDNResponse custLookup = null;

            if (wirelessOrder.ActivationType == 'A')
            {
                custLookup = this.CustomerLookup(null, null, referenceNumber);
            }

            var activation = new ActivationManagement(wirelessOrder);

            if (wirelessOrder.ActivationType == 'U')
            {
                response = this.SubmitUpgradeOrder(activation);

                new Log().LogResponse(new Utility().SerializeXML(response), CARRIER, "UpgradeActivation", referenceNumber);

                return response;
            }

            customerWip = (new CheckoutSessionState()).GetByReference(referenceNumber, "WIP", ServiceMethods.CreditCheck.ToString());

            // TODO: Validate the WIP

            // get the extended addresses
            ExtendedAddress extendedBillingAddress = null;
            ExtendedAddress extendedShippingAddress = null;

            try
            {
                extendedBillingAddress =
                    (ExtendedAddress)(new CheckoutSessionState()).GetByReference(referenceNumber, Address.AddressEnum.Billing.ToString(), "AddressValidation", typeof(ExtendedAddress));
                extendedShippingAddress =
                    (ExtendedAddress)(new CheckoutSessionState()).GetByReference(referenceNumber, Address.AddressEnum.Shipping.ToString(), "AddressValidation", typeof(ExtendedAddress));
            }
            catch (Exception ex1)
            {
                new Log().LogException(ex1.Message, CARRIER, "SubmitOrderExtendedAddress", referenceNumber);
            }

            var tmoRequest = new ActivationRequest();
            var tmoResponse = new ActivationResponse();
            var tmoService = new ActivationService();

            tmoRequest.header = this.GetHeader(referenceNumber);
            tmoService.RequestSoapContext.Security.Tokens.Add(this.GetUsernameToken());
            this.AddCerts(tmoService.ClientCertificates);

            tmoService.Url = this.GetUrl("ActivationEndpoint");

            tmoRequest.accountType = AccountTypeSubTypeEnum.INDIVIDUAL_REGULAR;
            tmoRequest.billFormatOptionSpecified = false;
            tmoRequest.billLanguageOption = LanguageEnum.ENGLISH;
            tmoRequest.customerLookup = new CustomerLookup();
            tmoRequest.customerLookup.ItemElementName = Interfaces.Activation.ItemChoiceType.wipCustomerId;
            tmoRequest.customerLookup.Item = customerWip;
            tmoRequest.flexpayAmountCollectedSpecified = false;

            var isPortIn = false;

            if (wirelessOrder.WirelessLines != null && wirelessOrder.WirelessLines.Length > 0)
            {
                tmoRequest.lineDetails = new ActivationLineDetails[wirelessOrder.WirelessLines.Length];

                for (var i = 0; i < wirelessOrder.WirelessLines.Length; i++)
                {
                    var line = wirelessOrder.WirelessLines[i];

                    isPortIn = !string.IsNullOrEmpty(line.NewMDN);

                    tmoRequest.lineDetails[i] = new ActivationLineDetails();
                    tmoRequest.lineDetails[i].lineId = wirelessOrder.WirelessLines[i].WirelessLineId.ToString();

                    if (wirelessOrder.ActivationType == 'A')
                    {
                        tmoRequest.lineDetails[i].selectedRateplan = custLookup.subscriberDetails.ratePlan.rateplanInfo.rateplanCode;
                        tmoRequest.lineDetails[i].marketCode = custLookup.subscriberDetails.ratePlan.rateplanInfo.marketCode;
                    }
                    else
                    {
                        tmoRequest.lineDetails[i].selectedRateplan = wirelessOrder.WirelessLines[i].CarrierPlanId;
                        tmoRequest.lineDetails[i].marketCode = wirelessOrder.WirelessLines[i].MarketCode;
                    }

                    // Shipping address as ppu
                    tmoRequest.lineDetails[i].ppuAddress = new Interfaces.Activation.Address();
                    tmoRequest.lineDetails[i].ppuAddress.address1 = extendedShippingAddress.AddressLine1;
                    tmoRequest.lineDetails[i].ppuAddress.address2 = extendedShippingAddress.AddressLine2;
                    tmoRequest.lineDetails[i].ppuAddress.addressClassificationSpecified = false;
                    tmoRequest.lineDetails[i].ppuAddress.city = extendedShippingAddress.City;
                    tmoRequest.lineDetails[i].ppuAddress.state = (StateEnum)Enum.Parse(typeof(StateEnum), extendedShippingAddress.State);
                    tmoRequest.lineDetails[i].ppuAddress.zipCode = extendedShippingAddress.ZipCode;
                    tmoRequest.lineDetails[i].ppuAddress.zipCodeExtension = extendedShippingAddress.ExtendedZipCode;

                    if (wirelessOrder.WirelessLines[i].IsMdnPort != null && wirelessOrder.WirelessLines[i].IsMdnPort.Value)
                    {
                        tmoRequest.lineDetails[i].portInLineDetail = new PortInLineDetail();
                        tmoRequest.lineDetails[i].portInLineDetail.numberToPort = wirelessOrder.WirelessLines[i].NewMDN;
                        tmoRequest.lineDetails[i].portInLineDetail.originalAccountNum = wirelessOrder.WirelessLines[i].NewMDN;

                        if (wirelessOrder.CurrentAccountPIN != null)
                        {
                            tmoRequest.lineDetails[i].portInLineDetail.originalAccountPasswordPin = wirelessOrder.CurrentAccountPIN;
                        }
                        else
                        {
                            if (!string.IsNullOrEmpty(wirelessOrder.SSN) && wirelessOrder.SSN.Length > 3)
                            {
                                tmoRequest.lineDetails[i].portInLineDetail.originalAccountPasswordPin = wirelessOrder.SSN.Substring(wirelessOrder.SSN.Length - 4);
                            }
                            else
                            {
                                tmoRequest.lineDetails[i].portInLineDetail.originalAccountPasswordPin = string.Empty;
                            }
                        }
                    }
                    else
                    {
                        tmoRequest.lineDetails[i].npaInfo = new NpaNxx();
                        tmoRequest.lineDetails[i].npaInfo.npa = wirelessOrder.WirelessLines[i].NPARequested;
                        tmoRequest.lineDetails[i].npaInfo.marketCode = wirelessOrder.WirelessLines[i].MarketCode;

                        if (wirelessOrder.ActivationType == 'A')
                        {
                            tmoRequest.lineDetails[i].npaInfo.marketCode = custLookup.subscriberDetails.ratePlan.rateplanInfo.marketCode;
                        }
                        else
                        {
                            tmoRequest.lineDetails[i].npaInfo.marketCode = wirelessOrder.WirelessLines[i].MarketCode;
                        }
                    }

                    /*if (wirelessOrder.WirelessLines[i].RequestedActivationDate != null)
                    {
                        tmoRequest.lineDetails[i].serviceBeginDate = (DateTime)wirelessOrder.WirelessLines[i].RequestedActivationDate;
                    }
                    else
                    {
                        tmoRequest.lineDetails[i].serviceBeginDate = DateTime.Now;
                    }*/
                    tmoRequest.lineDetails[i].serviceBeginDate = DateTime.Now.AddDays(3);

                    try
                    {
                        tmoRequest.lineDetails[i].contractLength = (ContractLengthEnum)Enum.Parse(typeof(ContractLengthEnum), "Item" + wirelessOrder.WirelessLines[i].ContractLength);
                        tmoRequest.lineDetails[i].contractLengthSpecified = true;
                    }
                    catch
                    {
                        tmoRequest.lineDetails[i].contractLengthSpecified = false;
                    }

                    tmoRequest.multiBanRequest = false;

                    tmoRequest.mailingAddress = new Interfaces.Activation.Address();
                    tmoRequest.mailingAddress.address1 = extendedShippingAddress.AddressLine1;
                    tmoRequest.mailingAddress.address2 = extendedShippingAddress.AddressLine2;
                    tmoRequest.mailingAddress.city = extendedShippingAddress.City;
                    tmoRequest.mailingAddress.zipCode = extendedShippingAddress.ZipCode;
                    tmoRequest.mailingAddress.zipCodeExtension = extendedShippingAddress.ExtendedZipCode;
                    tmoRequest.mailingAddress.state = (StateEnum)Enum.Parse(typeof(StateEnum), extendedShippingAddress.State);
                    tmoRequest.mailingAddress.addressClassificationSpecified = false;

                    var theServices = new List<Service>();

                    Service aService;

                    if (wirelessOrder.WirelessLines[i].WirelessLineServices != null && wirelessOrder.WirelessLines[i].WirelessLineServices.Length > 0)
                    {
                        // tmoRequest.lineDetails[i].selectedService = new Interfaces.Activation.Service[wirelessOrder.WirelessLines[i].WirelessLineServices.Length];    
                        for (var j = 0; j < wirelessOrder.WirelessLines[i].WirelessLineServices.Length; j++)
                        {
                            if (wirelessOrder.WirelessLines[i].GroupNumber == wirelessOrder.WirelessLines[i].WirelessLineServices[j].GroupNumber)
                            {
                                aService = new Service();
                                aService.soc = wirelessOrder.WirelessLines[i].WirelessLineServices[j].CarrierServiceId;
                                theServices.Add(aService);
                            }
                        }
                    }

                    if (wirelessOrder.ActivationType == 'A')
                    {
                        tmoRequest.pin = wirelessOrder.CurrentAccountPIN;
                        tmoRequest.customerLookup.ItemElementName = Interfaces.Activation.ItemChoiceType.ban;
                        tmoRequest.customerLookup.Item = wirelessOrder.CurrentAccountNumber;
                    }

                    if (theServices != null && theServices.Count > 0)
                    {
                        tmoRequest.lineDetails[i].selectedService = theServices.ToArray();
                    }

                    tmoRequest.lineDetails[i].productType = ProductType.GSM;
                    tmoRequest.lineDetails[i].sim = wirelessOrder.WirelessLines[i].Sim;
                    tmoRequest.lineDetails[i].imei = wirelessOrder.WirelessLines[i].IMEI;
                    tmoRequest.lineDetails[i].voicemailLanguageOption = LanguageEnum.ENGLISH;
                }
            }

            new Log().LogRequest(new Utility().SerializeXML(tmoRequest), CARRIER, "SubmitOrder", referenceNumber);

            try
            {
                tmoResponse = tmoService.activateSubscribers(tmoRequest);
            }
            catch (Exception ex)
            {
                response.ErrorCode = (int)ServiceResponseCode.Failure;
                response.PrimaryErrorMessage = ex.Message;
                new Log().LogException(ex.Message, CARRIER, "SubmitOrder", referenceNumber);
            }

            if (tmoResponse != null)
            {
                new Log().LogResponse(new Utility().SerializeXML(tmoResponse), CARRIER, "SubmitOrder", referenceNumber);

                if (tmoResponse.serviceStatus != null)
                {
                    response.ErrorCode = (int)ServiceResponseCode.Success;

                    if (tmoResponse.serviceStatus.serviceStatusCode == ServiceStatusEnum.Item100)
                    {
                        response.ServiceResponseSubCode = (int)ServiceResponseSubCode.ActSuccessfulActivation;
                    }
                    else if (tmoResponse.serviceStatus.serviceStatusCode == ServiceStatusEnum.Item101)
                    {
                        response.ServiceResponseSubCode = (int)ServiceResponseSubCode.ACT_PARTIAL_HANDSET_ACTIVATION;
                    }
                    else
                    {
                        response.ServiceResponseSubCode = (int)ServiceResponseSubCode.ACT_MANUAL_ONLY;

                        // need to manually activate
                    }

                    if (tmoResponse.serviceStatus.serviceStatusItem != null && tmoResponse.serviceStatus.serviceStatusItem.Length > 0)
                    {
                        foreach (var status in tmoResponse.serviceStatus.serviceStatusItem)
                        {
                            response.PrimaryErrorMessage += status.statusCode + " " + status.statusDescription + " ::: ";
                        }
                    }
                }
            }

            this.UpdateOrder(OrderNumber, referenceNumber, tmoResponse);

            return response;
        }

        /// <summary>The test a validate port in.</summary>
        /// <param name="ReferenceNumber">The reference number.</param>
        [WebMethod]
        public void TestAValidatePortIn(string ReferenceNumber)
        {
            var set = new MDNSet();
            set.MDN = "2068506299";
            set.ServiceZipCode = "98102";
            var list = new List<MDNSet>();
            list.Add(set);
            var response = this.ValidatePortIn(list, ReferenceNumber);

            // return response;
        }

        /// <summary>The test generate rsa token for kiosk.</summary>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="string"/>.</returns>
        [WebMethod]
        public string TestGenerateRSATokenForKiosk(string referenceNumber)
        {
            return referenceNumber;
        }

        /// <summary>The test validate address.</summary>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="AddressValidationResponse"/>.</returns>
        [WebMethod(EnableSession = true)]
        public AddressValidationResponse TestValidateAddress(string referenceNumber)
        {
            var addressToValidate = new Address();
            addressToValidate.AddressLine1 = "1027 Bellevue Ct";
            addressToValidate.City = "Seattle";
            addressToValidate.State = "WA";
            addressToValidate.ZipCode = "98102";

            return this.ValidateAddress(addressToValidate, Address.AddressEnum.Billing, referenceNumber);
        }

        /// <summary>The upgrade handset.</summary>
        /// <param name="wirelessOrder">The wireless order.</param>
        /// <param name="line">The line.</param>
        /// <returns>The <see cref="EquipmentUpgradeResponse"/>.</returns>
        public EquipmentUpgradeResponse UpgradeHandset(WirelessOrder wirelessOrder, WirelessLine line)
        {
            // , CustomerLookupByMSISDNResponse customerInfo)
            var response = new EquipmentUpgradeResponse();
            var tmoEligibilityRequest = new GetEligibilityRequest();
            GetEligibilityResponse tmoEligibilityResponse;
            var tmoHandsetOrderRequest = new SaveExternalDealerOrderRequest();
            SaveExternalDealerOrderResponse tmoHandsetOrderResponse;

            var tmoService = new HandsetUpgradeService();
            tmoService.Url = this.GetUrl("HandsetUpgradeEndpoint");
            response.ServiceResponseSubCode = (int)ServiceResponseSubCode.EU_FAILED;
            response.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.EU_FAILED);

            tmoEligibilityRequest.header = this.GetHeader(wirelessOrder.CheckoutReferenceNumber);
            tmoService.RequestSoapContext.Security.Tokens.Add(this.GetUsernameToken());
            this.AddCerts(tmoService.ClientCertificates);

            try
            {
                string ban;
                ban = (new CheckoutSessionState()).GetByReference(wirelessOrder.CheckoutReferenceNumber, "BAN", "CustomerLookup");
                tmoEligibilityRequest.ban = ban;
                tmoEligibilityRequest.listOfMobileNumbers = new string[1];

                if (line.CurrentMDN != null)
                {
                    tmoHandsetOrderRequest.msisdn = line.CurrentMDN;
                }
                else
                {
                    tmoHandsetOrderRequest.msisdn = (new CheckoutSessionState()).GetByReference(wirelessOrder.CheckoutReferenceNumber, "MDN", "CustomerLookup");
                }

                tmoEligibilityRequest.listOfMobileNumbers[0] = tmoHandsetOrderRequest.msisdn;

                new Log().LogRequest(new Utility().SerializeXML(tmoEligibilityRequest), CARRIER, "GetUpgradeEligbility", wirelessOrder.CheckoutReferenceNumber);

                tmoEligibilityResponse = tmoService.getEligibility(tmoEligibilityRequest);

                new Log().LogResponse(new Utility().SerializeXML(tmoEligibilityResponse), CARRIER, "GetUpgradeEligbility", wirelessOrder.CheckoutReferenceNumber);

                if (tmoEligibilityResponse.customerEligibility != null && tmoEligibilityResponse.customerEligibility.Length == 1)
                {
                    if (tmoEligibilityResponse.customerEligibility[0].eligibilityLevel == EligibilityLevel.YES)
                    {
                        tmoHandsetOrderRequest.header = this.GetHeader(wirelessOrder.CheckoutReferenceNumber);
                        tmoHandsetOrderRequest.ban = ban; // customerInfo.accountDetails.ban;
                        tmoHandsetOrderRequest.imei = line.IMEI;

                        tmoHandsetOrderRequest.termsAccepting = SaveOrderContractLengthEnum.Item24;

                        new Log().LogRequest(new Utility().SerializeXML(tmoHandsetOrderRequest), CARRIER, "SaveExternalDealerOrder", wirelessOrder.CheckoutReferenceNumber);

                        tmoHandsetOrderResponse = tmoService.saveExternalDealerOrder(tmoHandsetOrderRequest);

                        new Log().LogResponse(new Utility().SerializeXML(tmoHandsetOrderResponse), CARRIER, "SaveExternalDealerOrder", wirelessOrder.CheckoutReferenceNumber);

                        if (tmoHandsetOrderResponse.serviceStatus != null)
                        {
                            if (tmoHandsetOrderResponse.serviceStatus.serviceStatusItem != null)
                            {
                                foreach (var status in tmoHandsetOrderResponse.serviceStatus.serviceStatusItem)
                                {
                                    response.PrimaryErrorMessage += status.statusCode + status.statusDescription + ":";
                                }
                            }

                            switch (tmoHandsetOrderResponse.serviceStatus.serviceStatusCode)
                            {
                                case ServiceStatusEnum.Item100:
                                    response.ErrorCode = (int)ServiceResponseCode.Success;
                                    response.ServiceResponseSubCode = (int)ServiceResponseSubCode.EU_SUCCESS;
                                    response.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.EU_SUCCESS);
                                    break;
                                case ServiceStatusEnum.Item101:
                                    response.ErrorCode = (int)ServiceResponseCode.Success;
                                    response.ServiceResponseSubCode = (int)ServiceResponseSubCode.EU_PARTIAL; // GENERAL
                                    response.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.EU_PARTIAL);
                                    foreach (var status in tmoHandsetOrderResponse.serviceStatus.serviceStatusItem)
                                    {
                                        if (status.statusCode == "22001")
                                        {
                                            response.ServiceResponseSubCode = (int)ServiceResponseSubCode.EU_SUCCESS_NO_COMMISSION;
                                            response.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.EU_SUCCESS_NO_COMMISSION);

                                            break;
                                        }

                                        response.ServiceResponseSubCode = (int)ServiceResponseSubCode.EU_FAILED;
                                        response.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.EU_FAILED);

                                        break;
                                    }

                                    break;
                            }

                            if (response.ServiceResponseSubCode != (int)ServiceResponseSubCode.EU_FAILED)
                            {
                                foreach (var wl in wirelessOrder.WirelessLines.Where(wl => wl.IMEI == line.IMEI))
                                {
                                    wl.ActivationStatus = ActivationStatus.Success;
                                }

                                wirelessOrder.ActivationStatus = (int)ActivationStatus.Success;

                                // wirelessOrder.Save();
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                new Log().LogException(ex.Message, CARRIER, "UpgradeHandset", wirelessOrder.CheckoutReferenceNumber);
                response.ErrorCode = (int)ServiceResponseCode.Failure;
                response.ServiceResponseSubCode = (int)ServiceResponseSubCode.EU_FAILED;
                response.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.EU_FAILED);
                response.PrimaryErrorMessage += " (" + ex.Message + ")";
            }

            return response;
        }

        /// <summary>The upgrade rate plan.</summary>
        /// <param name="OrderNumber">The order number.</param>
        /// <returns>The <see cref="string"/>.</returns>
        [WebMethod]
        public string UpgradeRatePlan(int OrderNumber)
        {
            var resultInfo = string.Empty;

            var response = new ServicesActivationResponse();

            // get the details of the order from the database.
            WirelessOrder wirelessOrder = null;

            try
            {
                wirelessOrder = new WirelessOrder(Convert.ToInt32(OrderNumber));
            }
            catch (Exception ex)
            {
                // new Log().LogException(ex.Message, CARRIER, "UpgradeRatePlan", referenceNumber);
                return ex.Message;
            }

            foreach (var line in wirelessOrder.WirelessLines)
            {
                var eligible = new CheckSocChangeEligibility(OrderNumber, line.CurrentMDN);

                if (eligible.UpgradeEligible())
                {
                    response = this.UpgradeRatePlanServices(wirelessOrder, line, eligible);
                }

                resultInfo += new Utility().SerializeXML(response);
            }

            new Log().LogResponse(resultInfo, CARRIER, "UpgradeRatePlan", wirelessOrder.CheckoutReferenceNumber);

            return resultInfo;
        }

        /// <summary>The validate address.</summary>
        /// <param name="addressToValidate">The address to validate.</param>
        /// <param name="addressType">The address type.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="AddressValidationResponse"/>.</returns>
        [WebMethod(EnableSession = true)]
        public AddressValidationResponse ValidateAddress(Address addressToValidate, Address.AddressEnum addressType, string referenceNumber)
        {
            var tmoService = new AddressVerificationService();
            var response = new AddressValidationResponse();

            try
            {
                var config = new WaConfigurationManager(HttpContext.Current.Server.MapPath(string.Empty));
                tmoService.Url = this.GetUrl("AddressValidationEndpoint");
                var tmoRequest = this.CreateAddressVerificationRequest(addressToValidate, referenceNumber);
                this.AddCerts(tmoService.ClientCertificates);

                tmoService.RequestSoapContext.Security.Tokens.Add(this.GetUsernameToken());
                new Log().LogRequest(new Utility().SerializeXML(tmoRequest), CARRIER, "AddressValidation", referenceNumber);

                response = this.VerifyAddress(tmoService, tmoRequest, addressType, referenceNumber);
            }
            catch (Exception ex)
            {
                if (response == null)
                {
                    response = new AddressValidationResponse();
                }

                response.ErrorCode = (int)ServiceResponseCode.Failure;
                response.PrimaryErrorMessage = ex.Message;
                new Log().LogException(ex.Message, CARRIER, "AddressValidation", referenceNumber);
            }

            new Log().LogOutput(new Utility().SerializeXML(response), CARRIER, "AddressValidation", referenceNumber);

            return response;
        }

        /// <summary>The validate port in.</summary>
        /// <param name="mdnList">The mdn list.</param>
        /// <param name="ReferenceNumber">The reference number.</param>
        /// <returns>The <see cref="ValidatePortInResponse"/>.</returns>
        [WebMethod]
        public ValidatePortInResponse ValidatePortIn(List<MDNSet> mdnList, string ReferenceNumber)
        {
            var tmoService = new PortInService();
            var tmoRequest = new PortInEligibilityRequest();
            var tmoResponse = new PortInEligibilityResponse();

            tmoRequest.header = this.GetHeader(ReferenceNumber);
            tmoService.RequestSoapContext.Security.Tokens.Add(this.GetUsernameToken());
            this.AddCerts(tmoService.ClientCertificates);

            tmoService.Url = this.GetUrl("PortInEndpoint");

            tmoRequest.portEligibilityDetails = new PortInEligibilityRequestDetail[mdnList.Count];

            var i = 0;

            foreach (var mdnSet in mdnList)
            {
                tmoRequest.portEligibilityDetails[i] = new PortInEligibilityRequestDetail();
                tmoRequest.portEligibilityDetails[i++].numberToBePorted = mdnSet.MDN;
            }

            new Log().LogRequest(new Utility().SerializeXML(tmoRequest), CARRIER, "PortIn", ReferenceNumber);
            ValidatePortInResponse response = null;

            try
            {
                tmoResponse = tmoService.checkPortinEligibility(tmoRequest);
                new Log().LogResponse(new Utility().SerializeXML(tmoResponse), CARRIER, "PortIn", ReferenceNumber);
                response = this.MapTMOPortInResponse(tmoResponse);
            }
            catch (Exception ex)
            {
              
                if (response == null)
                {
                    response = new ValidatePortInResponse();
                }

                response.ErrorCode = (int)ServiceResponseCode.Failure;
                response.PrimaryErrorMessage = ex.Message;
                new Log().LogException(ex.Message, CARRIER, "PortIn", ReferenceNumber);
            }

            new Log().LogOutput(new Utility().SerializeXML(response), CARRIER, "PortIn", ReferenceNumber);

            return response;
        }

        #endregion

        #region Methods

        /// <summary>The valid customer type.</summary>
        /// <param name="accountType">The account type.</param>
        /// <param name="accountSubType">The account sub type.</param>
        /// <returns>The <see cref="bool"/>.</returns>
        private static bool ValidCustomerType(AccountTypeEnum accountType, AccountTypeSubTypeEnum accountSubType)
        {
            switch (accountType)
            {
                case AccountTypeEnum.INDIVIDUAL:
                    switch (accountSubType)
                    {
                        case AccountTypeSubTypeEnum.INDIVIDUAL_REGULAR:
                        case AccountTypeSubTypeEnum.INDIVIDUAL_MCSA:
                        case AccountTypeSubTypeEnum.INDIVIDUAL_SOLE_PROPRIETORSHIP:
                            return true;
                        default:
                            return false;
                    }

                default:
                    return false;
            }
        }

        /// <summary>The add certs.</summary>
        /// <param name="certCollection">The cert collection.</param>
        private void AddCerts(X509CertificateCollection certCollection)
        {
            // LOAD ALL CERTS
            var certFiles = Directory.GetFiles(this.Server.MapPath("App_Data"));

            foreach (var s in certFiles.Where(s => s.EndsWith("crt") || s.EndsWith("cer")))
            {
                certCollection.Add(X509Certificate.CreateFromCertFile(s));
                Trace.WriteLine("Cert: " + s);
                Trace.WriteLine(Environment.UserName);
                Trace.Flush();
            }
        }

        /// <summary>The check order upgrade eligibility.</summary>
        /// <param name="activation">The activation.</param>
        /// <returns>The <see cref="bool"/>.</returns>
        private bool CheckOrderUpgradeEligibility(ActivationManagement activation)
        {
            var wirelessOrder = activation.WirelessOrder;
            var line = wirelessOrder.WirelessLines.First();

            var eligibility = new CheckSocChangeEligibility(wirelessOrder.OrderId, line.CurrentMDN);

            return eligibility.UpgradeEligible();
        }

        /// <summary>The copy address.</summary>
        /// <param name="source">The source.</param>
        /// <param name="dest">The dest.</param>
        private void CopyAddress(Interfaces.CustomerLookup.Address source, Address dest)
        {
            if (source != null && dest != null)
            {
                dest.AddressLine1 = source.address1;
                dest.AddressLine2 = source.address2;
                dest.City = source.city;
                dest.State = source.state.ToString();
                dest.ZipCode = source.zipCode;
                dest.ExtendedZipCode = source.zipCodeExtension;
            }
        }

        /// <summary>The create address verification request.</summary>
        /// <param name="input">The input.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="AddressVerificationRequest"/>.</returns>
        private AddressVerificationRequest CreateAddressVerificationRequest(Address input, string referenceNumber)
        {
            var addressRequest = new AddressVerificationRequest
                                     {
                                         addressToVerify =
                                             new Interfaces.AddressVerification.Address
                                                 {
                                                     address1 = input.AddressLine1,
                                                     address2 = input.AddressLine2,
                                                     addressClassificationSpecified = false,
                                                     city = input.City,
                                                     state = (StateEnum)Enum.Parse(typeof(StateEnum), input.State),
                                                     zipCode = input.ZipCode.Trim()
                                                 },
                                         header = this.GetHeader(referenceNumber)
                                     };

            return addressRequest;
        }

        /// <summary>The get header.</summary>
        /// <param name="reference">The reference.</param>
        /// <returns>The <see cref="Header"/>.</returns>
        private Header GetHeader(string reference)
        {
            // TODO: pull header from somewhere configurable
            var header = new Header();
            var config = new WaConfigurationManager(HttpContext.Current.Server.MapPath(string.Empty));
            header.partnerId = config.AppSetting("partnerId");
            header.partnerTransactionId = reference;
            header.partnerTimestamp = DateTime.Now;
            header.dealerCode = config.AppSetting("dealerCode");

            return header;
        }

        /// <summary>The get url.</summary>
        /// <param name="endPointName">The end point name.</param>
        /// <returns>The <see cref="string"/>.</returns>
        private string GetUrl(string endPointName)
        {
           var config = new WaConfigurationManager(this.Server.MapPath(string.Empty));

           return config.AppSetting("TMobileHost") + config.AppSetting(endPointName);
        }

        /// <summary>The get username token.</summary>
        /// <returns>The <see cref="UsernameToken" />.</returns>
        private UsernameToken GetUsernameToken()
        {
            var config = new WaConfigurationManager(HttpContext.Current.Server.MapPath(string.Empty));
            return new UsernameToken(config.AppSetting("Username"), config.AppSetting("Password"), PasswordOption.SendPlainText);
        }

        /// <summary>The map account status.</summary>
        /// <param name="tmoAccountStatus">The tmo account status.</param>
        /// <returns>The <see cref="AccountStatusCode"/>.</returns>
        private AccountStatusCode MapAccountStatus(AccountStatusCodeEnum tmoAccountStatus)
        {
            AccountStatusCode result;

            // WA interface matches TMO, but is considered generic list for all carriers so map it in case of changes
            switch (tmoAccountStatus)
            {
                case AccountStatusCodeEnum.CANCELLED:
                    return AccountStatusCode.Cancelled;
                case AccountStatusCodeEnum.CLOSED:
                    return AccountStatusCode.Closed;
                case AccountStatusCodeEnum.OPERATIONAL:
                    return AccountStatusCode.Operational;
                case AccountStatusCodeEnum.SUSPENDED:
                    return AccountStatusCode.Suspended;
                case AccountStatusCodeEnum.TENTATIVE:
                    return AccountStatusCode.Tentative;
                default:
                    return AccountStatusCode.Unknown;
            }
        }

        /// <summary>The map tmo credit response.</summary>
        /// <param name="linesRequested">The lines requested.</param>
        /// <param name="tmoRequest">The tmo request.</param>
        /// <param name="tmoResponse">The tmo response.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="CreditCheckResponse"/>.</returns>
        private CreditCheckResponse MapTMOCreditResponse(int linesRequested, CustomerQualificationRequest tmoRequest, CustomerQualificationResponse tmoResponse, string referenceNumber)
        {
            var response = new CreditCheckResponse();

            if (tmoResponse.customerQualificationInfo == null || tmoResponse.customerQualificationInfo.customerQualificationResult == null
                || tmoResponse.customerQualificationInfo.customerQualificationResult.Length <= 0)
            {
                if (tmoResponse.customerQualificationInfo != null)
                {
                    if (tmoResponse.customerQualificationInfo.creditScore != null && tmoResponse.customerQualificationInfo.creditApplicationStatus == CreditApplicationStatusEnum.REJECTED)
                    {
                        response.ErrorCode = (int)ServiceResponseCode.Success;
                        response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CC_CREDIT_DECLINED;
                        response.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.CC_CREDIT_DECLINED);
                    }
                    else
                    {
                        response.ErrorCode = (int)ServiceResponseCode.Failure;
                        response.PrimaryErrorMessage = "No customer qualification information received.";
                    }
                }
                else
                {
                    response.ErrorCode = (int)ServiceResponseCode.Failure;
                    response.PrimaryErrorMessage = "No customer qualification information received.";
                }
            }
            else
            {
                if (tmoResponse.customerQualificationInfo.customerQualificationResult[0].billingAccountType != BillingAccountTypeEnum.POSTPAID)
                {
                    response.ErrorCode = (int)ServiceResponseCode.Success;
                    response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CC_DENIED_FLEXPAY;
                    response.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.CC_DENIED_FLEXPAY);
                    response.NumberOfLines = 0;
                }
                else
                {
                    response.CreditApplicationNumber = tmoResponse.customerQualificationInfo.customerQualificationResult[0].creditApplicationRefNumber;
                    response.CreditCode = tmoResponse.customerQualificationInfo.creditScore;

                    try
                    {
                        response.CreditStatus = Enum.GetName(typeof(CreditApplicationStatusEnum), tmoResponse.customerQualificationInfo.creditApplicationStatus);
                    }
                    catch
                    {
                        response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CC_STATUS_UNKNOWN;
                        response.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.CC_STATUS_UNKNOWN);
                    }

                    var depositFreeLineCount = 0;

                    try
                    {
                        int.TryParse(tmoResponse.customerQualificationInfo.customerQualificationResult[0].lineDeposits.numberOfLinesWithoutDeposit, out depositFreeLineCount);
                    }
                    catch
                    {
                    }

                    try
                    {
                        response.Deposit = (linesRequested <= depositFreeLineCount) ? 0 : tmoResponse.customerQualificationInfo.customerQualificationResult[0].lineDeposits.depositAmount;
                    }
                    catch
                    {
                    }

                    switch (tmoResponse.serviceStatus.serviceStatusCode)
                    {
                        case ServiceStatusEnum.Item100:
                            if (tmoResponse.customerQualificationInfo != null)
                            {
                                if (tmoResponse.customerQualificationInfo.creditApplicationStatusSpecified
                                    && tmoResponse.customerQualificationInfo.creditApplicationStatus != CreditApplicationStatusEnum.COMPLETE)
                                {
                                    switch (tmoResponse.customerQualificationInfo.creditApplicationStatus)
                                    {
                                        case CreditApplicationStatusEnum.FAILURE:
                                            response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CCError;
                                            response.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.CCError);
                                            break;
                                        case CreditApplicationStatusEnum.PENDING:
                                            response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CC_PENDING;
                                            response.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.CC_PENDING);
                                            break;
                                        case CreditApplicationStatusEnum.REVIEW:
                                            response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CC_REVIEW;
                                            response.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.CC_REVIEW);
                                            break;
                                        case CreditApplicationStatusEnum.REJECTED:
                                            response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CC_CREDIT_DECLINED;
                                            response.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.CC_CREDIT_DECLINED);
                                            break;
                                        default:
                                            response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CC_STATUS_UNKNOWN;
                                            response.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.CC_STATUS_UNKNOWN);
                                            break;
                                    }
                                }

                                response.ErrorCode = (int)ServiceResponseCode.Success;
                            }

                            break;
                        default:
                            if (tmoResponse.serviceStatus != null && tmoResponse.serviceStatus.serviceStatusItem != null && tmoResponse.serviceStatus.serviceStatusItem.Length > 0)
                            {
                                switch (tmoResponse.serviceStatus.serviceStatusItem[0].statusCode)
                                {
                                    case "1022":
                                        response.ErrorCode = (int)ServiceResponseCode.Success;
                                        response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CC_RECENT_CANCEL;
                                        response.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.CC_RECENT_CANCEL);

                                        break;
                                    default:
                                        response.ErrorCode = (int)ServiceResponseCode.Success;
                                        response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CC_CREDIT_DECLINED;
                                        response.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.CC_CREDIT_DECLINED);

                                        break;
                                }

                                /*
                            19001 Customer must be at least 18 years old. 
                            19002 Photo ID is expired. 
                            19003 Identification type is mandatory for personal credit check. 
                            19004 Identification number is mandatory for personal credit check. 
                            19005 Identification issue state is mandatory for personal credit check. 
                            19006 Customer must provide SSN or federal Tax ID, when credit check accepted. 
                            19007 Home phone number is mandatory for personal credit check. 
                            19008 Unable to get the Credit Status. 
                            19009 Contract indicator should be false if customer doesn't accept credit check. 
                            19010 Billing address can not be PO BOX address. 
                            19011 Invalid SSN or Federal Tax ID provided, SSN or Federal Tax ID must be 9 digits. 
                            19012 Customer credit class is invalid. 
                            19013 Requested SSN does not match the loopback pattern  
                         */
                            }

                            break;
                    }

                    int numberOfLines;
                    int.TryParse(tmoResponse.customerQualificationInfo.customerQualificationResult[0].numberOfLinesApproved, out numberOfLines);

                    response.NumberOfLines = numberOfLines;
                    response.Result = new Utility().SerializeXML(tmoResponse);

                    if (tmoResponse.customerQualificationInfo.wipCustomerId == null)
                    {
                        if (tmoResponse.customerQualificationInfo.customerStatus != CustomerStatusEnum.EXISTING)
                        {
                            return response;
                        }

                        response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CC_EXISTING_CUSTOMER;
                        response.PrimaryErrorMessage = "No customer WIP value returned";
                    }
                    else
                    {
                        new CheckoutSessionState().Add(referenceNumber, "WIP", ServiceMethods.CreditCheck.ToString(), tmoResponse.customerQualificationInfo.wipCustomerId);
                    }
                }
            }

            return response;
        }

        /// <summary>The map tmo port in response.</summary>
        /// <param name="tmoResponse">The tmo response.</param>
        /// <returns>The <see cref="ValidatePortInResponse"/>.</returns>
        private ValidatePortInResponse MapTMOPortInResponse(PortInEligibilityResponse tmoResponse)
        {
            var response = new ValidatePortInResponse { MDNSet = new List<MDNSet>(tmoResponse.portInEligibilityResponseDetails.Length) };

            foreach (var detail in tmoResponse.portInEligibilityResponseDetails)
            {
                var mdnSet = new MDNSet { MDN = detail.numberToBePorted, IsPortable = detail.portInAllowed };

                response.MDNSet.Add(mdnSet);
            }

            response.ErrorCode = (int)ServiceResponseCode.Success;

            return response;
        }

        /// <summary>The rateplan validation.</summary>
        /// <param name="wirelessOrder">The wireless order.</param>
        /// <returns>The <see cref="RateplanConversionValidationResponse"/>.</returns>
        private RateplanConversionValidationResponse RateplanValidation(WirelessOrder wirelessOrder)
        {
            var tmoRequest = new RateplanConversionValidationRequest();
            RateplanConversionValidationResponse tmoResponse = null;
            var tmoRatePlanInfo = new RateplanConversionValidationInfo();
            var tmoService = new RateplanConversionValidationService();

            tmoService.Url = this.GetUrl("RatePlanConversionValidationEndpoint");

            try
            {
                string ban = new CheckoutSessionState().GetByReference(wirelessOrder.CheckoutReferenceNumber, "BAN", "CustomerLookup");

                tmoService.RequestSoapContext.Security.Tokens.Add(this.GetUsernameToken());
                this.AddCerts(tmoService.ClientCertificates);
                tmoRequest.header = this.GetHeader(wirelessOrder.CheckoutReferenceNumber);

                tmoRatePlanInfo.ban = ban;

                if (wirelessOrder.WirelessLines != null && wirelessOrder.WirelessLines.Length > 0)
                {
                    tmoRatePlanInfo.marketCode = wirelessOrder.WirelessLines[0].MarketCode;
                    tmoRatePlanInfo.selectedRateplan = wirelessOrder.WirelessLines[0].CarrierPlanId;

                    var services = new List<Interfaces.RateplanConversionValidation.Service>();

                    foreach (var wlService in wirelessOrder.WirelessLines[0].WirelessLineServices)
                    {
                        var newService = new Interfaces.RateplanConversionValidation.Service();
                        newService.soc = wlService.CarrierServiceId;
                        services.Add(newService);
                    }

                    tmoRatePlanInfo.selectedService = services.ToArray();
                }

                tmoRequest.rateplanConversionValidationInfo = tmoRatePlanInfo;
                tmoResponse = tmoService.validateRateplanConversion(tmoRequest);
            }
            catch (Exception)
            {
                throw;
            }

            return null;
        }

        /// <summary>The submit upgrade order.</summary>
        /// <param name="activation">The activation.</param>
        /// <returns>The <see cref="OrderActivationResponse"/>.</returns>
        private OrderActivationResponse SubmitUpgradeOrder(ActivationManagement activation)
        {
            // WirelessOrder wirelessOrder)
            EquipmentUpgradeResponse euResponse;
            var response = new OrderActivationResponse();
            var activationRequiresIntervention = false;
            var wirelessOrder = activation.WirelessOrder;

            if (this.CheckOrderUpgradeEligibility(activation))
            {
                // checkServicesUpgrade(activation))
                foreach (var line in wirelessOrder.WirelessLines)
                {
                    var lineActivation = new LineActivationResponse { ServiceResponseSubCode = (int)ServiceResponseSubCode.ACT_UNKNOWN };

                    if (!string.IsNullOrEmpty(line.CurrentMDN))
                    {
                        lineActivation.MDN = line.CurrentMDN;
                    }
                    else if (!string.IsNullOrEmpty(line.NewMDN))
                    {
                        lineActivation.MDN = line.NewMDN;
                    }

                    lineActivation.IMEI = line.IMEI;

                    var eligibility = new CheckSocChangeEligibility(wirelessOrder.OrderId, line.CurrentMDN);

                    if (!eligibility.UpgradeEligible())
                    {
                        lineActivation.ServiceResponseSubCode = (int)ServiceResponseSubCode.ACT_MANUAL_ONLY;
                        lineActivation.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.ACT_MANUAL_ONLY);
                        activationRequiresIntervention = true;
                    }
                    else
                    {
                        lineActivation.EquipmentUpgradeResponse = this.UpgradeHandset(wirelessOrder, line);

                        if (lineActivation.EquipmentUpgradeResponse != null && lineActivation.EquipmentUpgradeResponse.ErrorCode == (int)ServiceResponseCode.Success)
                        {
                            if (lineActivation.EquipmentUpgradeResponse.ServiceResponseSubCode != (int)ServiceResponseSubCode.EU_SUCCESS
                                && lineActivation.EquipmentUpgradeResponse.ServiceResponseSubCode != (int)ServiceResponseSubCode.EU_SUCCESS_NO_COMMISSION)
                            {
                                lineActivation.ErrorCode = (int)ServiceResponseCode.Success;
                                lineActivation.ServiceResponseSubCode = (int)ServiceResponseSubCode.ACT_FAIL_HANDSET;
                                lineActivation.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.ACT_FAIL_HANDSET);
                                activationRequiresIntervention = true;
                            }
                            else
                            {
                                activation.LineActivated();

                                lineActivation.ServicesActivationResponse = this.UpgradeRatePlanServices(wirelessOrder, line, eligibility);

                                switch ((ServiceResponseSubCode)lineActivation.ServiceResponseSubCode)
                                {
                                    case ServiceResponseSubCode.ACT_UNKNOWN:
                                    case ServiceResponseSubCode.ActSuccessfulActivation:
                                        switch ((ServiceResponseSubCode)lineActivation.ServicesActivationResponse.ServiceResponseSubCode)
                                        {
                                            case ServiceResponseSubCode.ACT_NO_SERVICES:
                                            case ServiceResponseSubCode.ActSuccessfulActivation:
                                                lineActivation.ServiceResponseSubCode = (int)ServiceResponseSubCode.ActSuccessfulActivation;
                                                lineActivation.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.ActSuccessfulActivation);

                                                break;
                                            default:
                                                lineActivation.ServiceResponseSubCode = (int)ServiceResponseSubCode.ACT_PARTIAL_HANDSET_ACTIVATION;
                                                lineActivation.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.ACT_PARTIAL_HANDSET_ACTIVATION);
                                                activationRequiresIntervention = true;

                                                break;
                                        }

                                        break;
                                    default:
                                        lineActivation.ServiceResponseSubCode = (int)ServiceResponseSubCode.ACT_MANUAL_ONLY;
                                        lineActivation.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.ACT_MANUAL_ONLY);

                                        activationRequiresIntervention = true;

                                        break;
                                }
                            }
                        }
                    }

                    response.ErrorCode = (int)ServiceResponseCode.Success;

                    if (activationRequiresIntervention)
                    {
                        activation.HasErrors = true;
                        response.ServiceResponseSubCode = (int)ServiceResponseSubCode.ACT_MANUAL_ONLY;
                        response.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.ACT_MANUAL_ONLY);
                    }
                    else
                    {
                        response.ServiceResponseSubCode = (int)ServiceResponseSubCode.ActSuccessfulActivation;
                        response.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.ActSuccessfulActivation);
                    }

                    line.ActivationStatus = lineActivation.ServiceResponseSubCode == (int)ServiceResponseSubCode.ActSuccessfulActivation ? ActivationStatus.Success : ActivationStatus.Failure;

                    response.AddLineActivation(lineActivation);
                }

                if (activation.HasErrors || !activation.HasSuccess)
                {
                    wirelessOrder.ActivationStatus = activation.HasErrors && activation.HasSuccess ? (int)ActivationStatus.PartialSuccess : (int)ActivationStatus.None;
                }
                else
                {
                    wirelessOrder.ActivationStatus = (int)ActivationStatus.Success;
                }

                wirelessOrder.Save();
            }
            else
            {
                response.ErrorCode = (int)ServiceResponseCode.Success;
                response.ServiceResponseSubCode = (int)ServiceResponseSubCode.ACT_MANUAL_ONLY;
                response.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.ACT_MANUAL_ONLY);
            }

            return response;
        }

        /// <summary>UpdateOrder writes the activation details back to the wireless order table</summary>
        /// <param name="orderNumber">The Order Number.</param>
        /// <param name="referenceNumber">The Reference Number.</param>
        /// <param name="tmoResponse">The tmo Response.</param>
        /// <returns>The <see cref="bool"/>.</returns>
        private bool UpdateOrder(string orderNumber, string referenceNumber, ActivationResponse tmoResponse)
        {
            try
            {
                var wirelessOrder = new WirelessOrder(Convert.ToInt32(orderNumber));

                if (tmoResponse.serviceStatus.serviceStatusCode == ServiceStatusEnum.Item100)
                {
                    wirelessOrder.ActivationStatus = (int)ActivationStatus.Success;
                }
                else if (tmoResponse.serviceStatus.serviceStatusCode == ServiceStatusEnum.Item101)
                {
                    wirelessOrder.ActivationStatus = (int)ActivationStatus.PartialSuccess;
                }
                else
                {
                    wirelessOrder.ActivationStatus = (int)ActivationStatus.Failure;
                }

                // make sure the account is valid befor assigning to the current account number
                if (tmoResponse.activationDetails != null && !string.IsNullOrEmpty(tmoResponse.activationDetails.ban))
                {
                    int tmp;
                    int.TryParse(tmoResponse.activationDetails.ban, out tmp);

                    if (tmp > 0)
                    {
                        wirelessOrder.CurrentAccountNumber = tmoResponse.activationDetails.ban;
                    }
                }

                foreach (var line in wirelessOrder.WirelessLines)
                {
                    line.ActivationStatus = ActivationStatus.Failure; // default unless match

                    foreach (var tmoDetail in tmoResponse.activationDetails.lineDetails.Where(tmoDetail => tmoDetail.imei == line.IMEI))
                    {
                        if (tmoDetail.contractLengthSpecified)
                        {
                            switch (tmoDetail.contractLength)
                            {
                                case ContractLengthEnum.Item0:
                                    line.ContractLength = 0;
                                    break;
                                case ContractLengthEnum.Item12:
                                    line.ContractLength = 12;
                                    break;
                                case ContractLengthEnum.Item24:
                                    line.ContractLength = 24;
                                    break;
                            }
                        }

                        if (tmoDetail.lineStatus == null)
                        {
                            line.ActivationStatus = ActivationStatus.Success;
                        }

                        line.CurrentCarrier = (int)CarrierEnum.TMobile;

                        if (tmoDetail.portInLineDetail != null)
                        {
                            line.IsMdnPort = tmoDetail.portInLineDetail.numberToPort != null;
                        }

                        line.MarketCode = tmoDetail.marketCode;

                        if (tmoDetail.feeDetail != null && tmoDetail.feeDetail.monthlyChargeSpecified)
                        {
                            line.MonthlyFee = tmoDetail.feeDetail.monthlyCharge;
                        }

                        if (tmoDetail.npaInfo != null)
                        {
                            line.NPARequested = tmoDetail.npaInfo.npa;
                        }

                        if (tmoDetail.portInLineDetail != null && tmoDetail.portInLineDetail.portInDueDateSpecified)
                        {
                            line.PortInDueDate = tmoDetail.portInLineDetail.portInDueDate;
                            line.PortRequestedId = tmoDetail.portInLineDetail.portinRequestId;
                            line.PortResponse = tmoDetail.portInLineDetail.responseNumber;
                        }

                        line.CurrentMDN = tmoDetail.msisdn;
                        line.NewMDN = null;

                        break;
                    }
                }

                wirelessOrder.Save();
            }
            catch (Exception ex)
            {
                new Log().LogException(ex.Message, CARRIER, "UpdateOrder", referenceNumber);

                return false;
            }

            return true;
        }

        /// <summary>The upgrade rateplan services.</summary>
        /// <param name="wirelessOrder">The wireless order.</param>
        /// <param name="line">The line.</param>
        /// <param name="eligibility">The eligibility.</param>
        /// <returns>The <see cref="ServicesActivationResponse"/>.</returns>
        private ServicesActivationResponse UpgradeRatePlanServices(WirelessOrder wirelessOrder, WirelessLine line, CheckSocChangeEligibility eligibility)
        {
            var tmoService = new RateplanChangeService();
            var tmoRequest = new RateplanChangeSubmitRequest();
            RateplanChangeSubmitResponse tmoResponse = null;
            var ratePlanChangeInfo = new RatePlanChangeInfo();
            var serviceActivationResponse = new ServicesActivationResponse();

            if (eligibility.NothingToActivate)
            {
                serviceActivationResponse.ServiceResponseSubCode = (int)ServiceResponseSubCode.ActSuccessfulActivation;
                serviceActivationResponse.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.ActSuccessfulActivation);

                return serviceActivationResponse;
            }

            tmoService.Url = this.GetUrl("RatePlanChangeEndpoint");
            tmoRequest.header = this.GetHeader(wirelessOrder.CheckoutReferenceNumber);
            tmoService.RequestSoapContext.Security.Tokens.Add(this.GetUsernameToken());
            this.AddCerts(tmoService.ClientCertificates);

            ratePlanChangeInfo.msisdn = eligibility.MSIMDN; // DO THIS AT THE LINE LEVEL
            ratePlanChangeInfo.ban = eligibility.BAN;
            ratePlanChangeInfo.upgradedImei = line.IMEI;

            if (eligibility.ServicesToAdd != null)
            {
                ratePlanChangeInfo.addedServices = new RatePlanChangeInfoAddedServices();
                ratePlanChangeInfo.addedServices.serviceChangeInfo = eligibility.ServicesToAdd;
            }

            if (eligibility.ServicesToDelete != null)
            {
                ratePlanChangeInfo.deletedServices = new RatePlanChangeInfoDeletedServices();
                ratePlanChangeInfo.deletedServices.serviceChangeInfo = eligibility.ServicesToDelete;
                ratePlanChangeInfo.deletedServices.managerOverrideSpecified = false;
            }

            if (eligibility.RatePlanToSubmit != null)
            {
                ratePlanChangeInfo.ratePlan = new RatePlanChangeInfoRatePlan();
                ratePlanChangeInfo.ratePlan.serviceChangeInfo = eligibility.RatePlanToSubmit;
            }

            tmoRequest.rateplanChangeInfo = ratePlanChangeInfo;

            new Log().LogRequest(new Utility().SerializeXML(tmoRequest), "TMobile", "UpgradeRatePlanServices", wirelessOrder.CheckoutReferenceNumber);

            tmoResponse = tmoService.submitServiceChange(tmoRequest);

            new Log().LogResponse(new Utility().SerializeXML(tmoResponse), "TMobile", "UpgradeRatePlanServices", wirelessOrder.CheckoutReferenceNumber);

            if (tmoResponse != null && tmoResponse.serviceStatus.serviceStatusCode == ServiceStatusEnum.Item100)
            {
                serviceActivationResponse.ServiceResponseSubCode = (int)ServiceResponseSubCode.ActSuccessfulActivation;
                serviceActivationResponse.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.ActSuccessfulActivation);
            }
            else
            {
                if (tmoResponse.serviceStatus != null && tmoResponse.serviceStatus.serviceStatusItem != null && tmoResponse.serviceStatus.serviceStatusItem.Length > 0)
                {
                    serviceActivationResponse.PrimaryErrorMessage = tmoResponse.serviceStatus.serviceStatusItem[0].statusDescription + "(" + tmoResponse.serviceStatus.serviceStatusItem[0].statusCode
                                                                    + ")";
                    serviceActivationResponse.ServiceResponseSubCode = (int)ServiceResponseSubCode.ACT_PARTIAL_SERVICE_CONFLICT;
                    serviceActivationResponse.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.ACT_PARTIAL_SERVICE_CONFLICT);
                }
            }

            return serviceActivationResponse;
        }

        /// <summary>The upgrade rate plan services_old.</summary>
        /// <param name="wirelessOrder">The wireless order.</param>
        /// <param name="line">The line.</param>
        /// <returns>The <see cref="ServicesActivationResponse"/>.</returns>
        private ServicesActivationResponse UpgradeRatePlanServicesOld(WirelessOrder wirelessOrder, WirelessLine line)
        {
            var tmoService = new RateplanChangeService();
            var tmoRequest = new RateplanChangeSubmitRequest();
            RateplanChangeSubmitResponse tmoResponse = null;
            var ratePlanChangeInfo = new RatePlanChangeInfo();
            var effectiveDateRequest = new GetSocEffectiveDatesRequest();
            GetSocEffectiveDatesResponse effectiveDateResponse = null;
            var socEligibilityRequest = new CheckSocChangeEligibilityRequest();
            CheckSocChangeEligibilityResponse socEligibilityResponse;
            var serviceActivationResponse = new ServicesActivationResponse();

            int i;

            tmoService.Url = this.GetUrl("RatePlanChangeEndpoint");

            if (line != null)
            {
                try
                {
                    var ban = new CheckoutSessionState().GetByReference(wirelessOrder.CheckoutReferenceNumber, "BAN", "CustomerLookup");
                    var mdn = new CheckoutSessionState().GetByReference(wirelessOrder.CheckoutReferenceNumber, "MDN", "CustomerLookup");
                    tmoRequest.header = this.GetHeader(wirelessOrder.CheckoutReferenceNumber);
                    tmoService.RequestSoapContext.Security.Tokens.Add(this.GetUsernameToken());
                    this.AddCerts(tmoService.ClientCertificates);

                    RatePlanChangeInfoAddedServices newServices = null;

                    var socCodeCount = 0;
                    var socCodes = new List<string>();

                    if (line.WirelessLineServices != null && line.WirelessLineServices.Length > 0)
                    {
                        socCodeCount += line.WirelessLineServices.Length; // All soc codes for effective date

                        foreach (var service in line.WirelessLineServices)
                        {
                            if (line.GroupNumber == service.GroupNumber)
                            {
                                socCodes.Add(service.CarrierServiceId);
                            }
                        }
                    }

                    if (!string.IsNullOrEmpty(line.CarrierPlanId))
                    {
                        socCodes.Add(line.CarrierPlanId);
                    }

                    if (socCodes.Count > 0)
                    {
                        // Need to get the effective dates 
                        effectiveDateRequest.serviceCode = socCodes.ToArray();
                        effectiveDateRequest.ban = ban;
                        effectiveDateRequest.msisdn = line.CurrentMDN; // mdn;
                        effectiveDateRequest.header = this.GetHeader(wirelessOrder.CheckoutReferenceNumber);

                        new Log().LogRequest(new Utility().SerializeXML(effectiveDateRequest), "TMobile", "GetSocEffectiveDatesRequest", wirelessOrder.CheckoutReferenceNumber);

                        effectiveDateResponse = tmoService.getSocEffectiveDates(effectiveDateRequest);

                        new Log().LogResponse(new Utility().SerializeXML(effectiveDateResponse), "TMobile", "GetSocEffectiveDatesRequest", wirelessOrder.CheckoutReferenceNumber);

                        newServices = new RatePlanChangeInfoAddedServices();

                        if (line.CarrierPlanId == null)
                        {
                            newServices.serviceChangeInfo = new ServiceChangeInfo[socCodes.Count];
                        }
                        else
                        {
                            ratePlanChangeInfo.ratePlan = new RatePlanChangeInfoRatePlan { serviceChangeInfo = new ServiceChangeInfo() };
                            newServices.serviceChangeInfo = new ServiceChangeInfo[socCodes.Count - 1];

                            // exclude rate plan
                        }

                        socEligibilityRequest.checkSocChangeEligibilityInfo = new CheckSocChangeEligibilityInfo { ban = ban, msisdn = line.CurrentMDN };

                        for (i = 0; i < effectiveDateResponse.socEffectiveDatesDetail.Length; i++)
                        {
                            if (line.CarrierPlanId != null && effectiveDateResponse.socEffectiveDatesDetail[i].serviceCode == line.CarrierPlanId)
                            {
                                ratePlanChangeInfo.ratePlan.serviceChangeInfo.service = line.CarrierPlanId;
                                ratePlanChangeInfo.ratePlan.serviceChangeInfo.effectiveDate = DateTime.Now;

                                // .ParseExact(effectiveDateResponse.socEffectiveDatesDetail[i].effectiveDate[1], "yyyyMMdd", System.Globalization.CultureInfo.InvariantCulture);  // TAKE FIRST / TODO: ERROR CHK                                
                                socEligibilityRequest.checkSocChangeEligibilityInfo.ratePlan = new ServiceChangeInfo
                                                                                                   {
                                                                                                       service = ratePlanChangeInfo.ratePlan.serviceChangeInfo.service, 
                                                                                                       effectiveDate = ratePlanChangeInfo.ratePlan.serviceChangeInfo.effectiveDate
                                                                                                   };
                            }
                            else
                            {
                                newServices.serviceChangeInfo[i] = new ServiceChangeInfo { service = effectiveDateResponse.socEffectiveDatesDetail[i].serviceCode, effectiveDate = DateTime.Now };

                                // .ParseExact(effectiveDateResponse.socEffectiveDatesDetail[i].effectiveDate[1], "yyyyMMdd", System.Globalization.CultureInfo.InvariantCulture);  // TAKE FIRST / TODO: ERROR CHK      
                            }
                        }

                        socEligibilityRequest.checkSocChangeEligibilityInfo.addedServices = newServices.serviceChangeInfo;
                        socEligibilityRequest.header = this.GetHeader(wirelessOrder.CheckoutReferenceNumber);

                        new Log().LogRequest(new Utility().SerializeXML(socEligibilityRequest), "TMobile", "socEligibilityRequest", string.Empty);

                        socEligibilityResponse = tmoService.checkSocChangeEligibility(socEligibilityRequest);

                        new Log().LogResponse(new Utility().SerializeXML(socEligibilityResponse), "TMobile", "socEligibilityResponse", string.Empty);

                        if (socEligibilityResponse.valid && socEligibilityResponse.serviceStatus.serviceStatusCode == ServiceStatusEnum.Item100)
                        {
                            if (newServices.serviceChangeInfo != null && newServices.serviceChangeInfo.Length > 0)
                            {
                                ratePlanChangeInfo.addedServices = newServices;
                            }

                            ratePlanChangeInfo.msisdn = line.CurrentMDN; // DO THIS AT THE LINE LEVEL
                            ratePlanChangeInfo.ban = ban;
                            ratePlanChangeInfo.upgradedImei = line.IMEI;
                            tmoRequest.rateplanChangeInfo = ratePlanChangeInfo;
                            tmoResponse = tmoService.submitServiceChange(tmoRequest);

                            serviceActivationResponse.ErrorCode = (int)ServiceResponseCode.Success;

                            if (tmoResponse != null && tmoResponse.serviceStatus.serviceStatusCode == ServiceStatusEnum.Item100)
                            {
                                serviceActivationResponse.ServiceResponseSubCode = (int)ServiceResponseSubCode.ActSuccessfulActivation;
                                serviceActivationResponse.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.ActSuccessfulActivation);
                            }
                            else
                            {
                                if (tmoResponse.serviceStatus != null && tmoResponse.serviceStatus.serviceStatusItem != null && tmoResponse.serviceStatus.serviceStatusItem.Length > 0)
                                {
                                    serviceActivationResponse.PrimaryErrorMessage = tmoResponse.serviceStatus.serviceStatusItem[0].statusDescription + "("
                                                                                    + tmoResponse.serviceStatus.serviceStatusItem[0].statusCode + ")";
                                    serviceActivationResponse.ServiceResponseSubCode = (int)ServiceResponseSubCode.ACT_PARTIAL_SERVICE_CONFLICT;
                                    serviceActivationResponse.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.ACT_PARTIAL_SERVICE_CONFLICT);
                                }
                            }
                        }
                        else
                        {
                            if (socEligibilityResponse.serviceStatus.serviceStatusItem.Any(statusItem => statusItem.statusCode == "29014"))
                            {
                                serviceActivationResponse.ErrorCode = (int)ServiceResponseCode.Success;
                                serviceActivationResponse.ServiceResponseSubCode = (int)ServiceResponseSubCode.ACT_RATEPLAN_MATCHES;

                                return serviceActivationResponse;
                            }

                            serviceActivationResponse.ErrorCode = (int)ServiceResponseCode.Success;
                            serviceActivationResponse.ServiceResponseSubCode = (int)ServiceResponseSubCode.ACT_MANUAL_ONLY;

                            if (socEligibilityResponse.serviceStatus != null && socEligibilityResponse.serviceStatus.serviceStatusItem != null
                                && socEligibilityResponse.serviceStatus.serviceStatusItem.Length > 0)
                            {
                                serviceActivationResponse.PrimaryErrorMessage = socEligibilityResponse.serviceStatus.serviceStatusItem[0].statusDescription + "("
                                                                                + socEligibilityResponse.serviceStatus.serviceStatusItem[0].statusCode + ")";
                            }
                        }
                    }
                    else
                    {
                        serviceActivationResponse.ErrorCode = (int)ServiceResponseCode.Success;
                        serviceActivationResponse.ServiceResponseSubCode = (int)ServiceResponseSubCode.ACT_NO_SERVICES;
                        serviceActivationResponse.PrimaryErrorMessage = new EnumHelper().GetDescription(ServiceResponseSubCode.ACT_NO_SERVICES);
                    }
                }
                catch (Exception ex)
                {
                    serviceActivationResponse.ErrorCode = (int)ServiceResponseCode.Failure;
                    serviceActivationResponse.PrimaryErrorMessage = ex.Message;
                }
            }

            return serviceActivationResponse;
        }

        /// <summary>The verify address.</summary>
        /// <param name="tmoService">The tmo service.</param>
        /// <param name="request">The request.</param>
        /// <param name="addressType">The address type.</param>
        /// <param name="ReferenceNumber">The reference number.</param>
        /// <returns>The <see cref="AddressValidationResponse"/>.</returns>
        private AddressValidationResponse VerifyAddress(AddressVerificationService tmoService, AddressVerificationRequest request, Address.AddressEnum addressType, string ReferenceNumber)
        {
            AddressVerificationResponse tmoResponse = null;
            var response = new AddressValidationResponse();

            try
            {
                tmoResponse = tmoService.verifyAddress(request);
                new Log().LogResponse(new Utility().SerializeXML(tmoResponse), CARRIER, "AddressValidation", ReferenceNumber);

                // TODO: Is 101 Partial an ok response also
                if (tmoResponse.serviceStatus.serviceStatusCode == ServiceStatusEnum.Item100)
                {
                    response.ErrorCode = (int)ServiceResponseCode.Success;

                    if (tmoResponse.verifiedAddress != null)
                    {
                        response.ValidAddress = new ExtendedAddress();
                        response.ValidAddress.AddressLine1 = tmoResponse.verifiedAddress.address1;
                        response.ValidAddress.AddressLine2 = string.Concat(string.Empty, tmoResponse.verifiedAddress.address2);
                        response.ValidAddress.City = tmoResponse.verifiedAddress.city;
                        response.ValidAddress.ZipCode = tmoResponse.verifiedAddress.zipCode;
                        response.ValidAddress.ExtendedZipCode = tmoResponse.verifiedAddress.zipCodeExtension;
                        response.ValidAddress.State = tmoResponse.verifiedAddress.state.ToString();
                    }

                    new CheckoutSessionState().Add(ReferenceNumber, addressType.ToString(), ServiceMethods.AddressValidation.ToString(), response.ValidAddress);
                }
                else if (tmoResponse.serviceStatus.serviceStatusCode == ServiceStatusEnum.Item102 | tmoResponse.serviceStatus.serviceStatusCode == ServiceStatusEnum.Item102)
                {
                    // check the service status item array for a code.
                    if (tmoResponse.serviceStatus.serviceStatusItem.Length > 0)
                    {
                        // TODO: look at additional codes if we want to. For now, just the first one.
                        if (tmoResponse.serviceStatus.serviceStatusItem[0].statusCode == "1001")
                        {
                            // address was invalid, return a success code, but do not fill the verified address.
                            response.ErrorCode = (int)ServiceResponseCode.Success;
                        }
                    }
                    else
                    {
                        // just a general failure.
                        response.ErrorCode = (int)ServiceResponseCode.Failure;
                    }
                }
                else
                {
                    // TODO: Add more error checking
                    response.ErrorCode = (int)ServiceResponseCode.Failure;

                    if (tmoResponse.serviceStatus != null && tmoResponse.serviceStatus.serviceStatusItem != null && tmoResponse.serviceStatus.serviceStatusItem.Length > 0)
                    {
                        response.PrimaryErrorMessage = tmoResponse.serviceStatus.serviceStatusItem[0].statusDescription;
                    }
                }
            }
            catch (Exception e)
            {
                if (tmoResponse != null)
                {
                    new Log().LogResponse(new Utility().SerializeXML(tmoResponse), CARRIER, "AddressValidation", ReferenceNumber);
                }

                response.ErrorCode = (int)ServiceResponseCode.Failure;
                response.PrimaryErrorMessage = e.Message;
            }

            return response;
        }

        /// <summary>The check services upgrade.</summary>
        /// <param name="activation">The activation.</param>
        /// <returns>The <see cref="bool"/>.</returns>
        private bool checkServicesUpgrade(ActivationManagement activation)
        {
            var tmoService = new RateplanChangeService();
            var effectiveDateRequest = new GetSocEffectiveDatesRequest();
            var socEligibilityRequest = new CheckSocChangeEligibilityRequest();

            var wirelessOrder = activation.WirelessOrder;
            var line = wirelessOrder.WirelessLines.First();

            tmoService.Url = this.GetUrl("RatePlanChangeEndpoint");

            try
            {
                var ban = new CheckoutSessionState().GetByReference(wirelessOrder.CheckoutReferenceNumber, "BAN", "CustomerLookup");
                var mdn = new CheckoutSessionState().GetByReference(wirelessOrder.CheckoutReferenceNumber, "MDN", "CustomerLookup");
                tmoService.RequestSoapContext.Security.Tokens.Add(this.GetUsernameToken());
                this.AddCerts(tmoService.ClientCertificates);

                var socCodes = new List<string>();

                if (line != null)
                {
                    socCodes.AddRange(line.WirelessLineServices.Select(service => service.CarrierServiceId));
                }

                if (line.CarrierPlanId != null)
                {
                    socCodes.Add(line.CarrierPlanId);
                }

                if (socCodes.Count > 0)
                {
                    // Need to get the effective dates 
                    effectiveDateRequest.serviceCode = socCodes.ToArray();
                    effectiveDateRequest.ban = ban;
                    effectiveDateRequest.msisdn = mdn;
                    effectiveDateRequest.header = this.GetHeader(wirelessOrder.CheckoutReferenceNumber);
                    new Log().LogRequest(new Utility().SerializeXML(effectiveDateRequest), "TMobile", "GetSocEffectiveDates", wirelessOrder.CheckoutReferenceNumber);
                    var effectiveDateResponse = tmoService.getSocEffectiveDates(effectiveDateRequest);
                    new Log().LogResponse(new Utility().SerializeXML(effectiveDateResponse), "TMobile", "GetSocEffectiveDates", wirelessOrder.CheckoutReferenceNumber);

                    var newServices = new RatePlanChangeInfoAddedServices();
                    var newSvcs = new List<ServiceChangeInfo>();

                    socEligibilityRequest.checkSocChangeEligibilityInfo = new CheckSocChangeEligibilityInfo { ban = ban, msisdn = mdn };

                    int i;
                    for (i = 0; i < effectiveDateResponse.socEffectiveDatesDetail.Length; i++)
                    {
                        if (line.CarrierPlanId != null && effectiveDateResponse.socEffectiveDatesDetail[i].serviceCode == line.CarrierPlanId)
                        {
                            socEligibilityRequest.checkSocChangeEligibilityInfo.ratePlan = new ServiceChangeInfo { service = line.CarrierPlanId, effectiveDate = DateTime.Now };
                        }
                        else
                        {
                            newSvcs.Add(new ServiceChangeInfo { service = effectiveDateResponse.socEffectiveDatesDetail[i].serviceCode, effectiveDate = DateTime.Now });
                        }
                    }

                    newServices.serviceChangeInfo = newSvcs.ToArray();
                    socEligibilityRequest.checkSocChangeEligibilityInfo.addedServices = newServices.serviceChangeInfo;
                    socEligibilityRequest.header = this.GetHeader(wirelessOrder.CheckoutReferenceNumber);

                    new Log().LogRequest(new Utility().SerializeXML(socEligibilityRequest), "TMobile", "SocUpgradeEligibility", wirelessOrder.CheckoutReferenceNumber);

                    var socEligibilityResponse = tmoService.checkSocChangeEligibility(socEligibilityRequest);

                    new Log().LogResponse(new Utility().SerializeXML(socEligibilityResponse), "TMobile", "SocUpgradeEligibility", wirelessOrder.CheckoutReferenceNumber);

                    if (socEligibilityResponse != null)
                    {
                        if (socEligibilityResponse.serviceStatus.serviceStatusCode == ServiceStatusEnum.Item102)
                        {
                            foreach (var s in socEligibilityResponse.serviceStatus.serviceStatusItem)
                            {
                                if (s.statusCode == "29014")
                                {
                                    // Rate plan matches existing RP, drop from request.
                                    activation.RatePlanMatches = true;
                                    socEligibilityRequest.checkSocChangeEligibilityInfo.ratePlan = null;

                                    new Log().LogRequest(new Utility().SerializeXML(socEligibilityRequest), "TMobile", "SocUpgradeEligibility_NORP", wirelessOrder.CheckoutReferenceNumber);

                                    socEligibilityResponse = tmoService.checkSocChangeEligibility(socEligibilityRequest);

                                    new Log().LogResponse(new Utility().SerializeXML(socEligibilityResponse), "TMobile", "SocUpgradeEligibility_NORP", wirelessOrder.CheckoutReferenceNumber);

                                    break;
                                }
                            }
                        }

                        switch (socEligibilityResponse.serviceStatus.serviceStatusCode)
                        {
                            case ServiceStatusEnum.Item100:
                                if (socEligibilityResponse.valid)
                                {
                                    activation.Activateable = true;

                                    return true;
                                }

                                if (socEligibilityResponse.checkSocChangeEligibilityOutput != null)
                                {
                                    if (socEligibilityResponse.checkSocChangeEligibilityOutput.Any(changeEligible => !changeEligible.autoResolveInd))
                                    {
                                        activation.Activateable = false;
                                        activation.SocConflicts = true;

                                        return false; // If anything is not auto-resolvable, for manual
                                    }
                                }

                                activation.Activateable = true;
                                return true;
                        }
                    }
                }
                else
                {
                    activation.Activateable = true;

                    return true;
                }
            }
            catch (Exception)
            {
                throw;
            }

            return false;
        }

        #endregion
    }
}