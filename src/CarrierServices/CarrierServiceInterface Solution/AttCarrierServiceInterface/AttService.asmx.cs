// --------------------------------------------------------------------------------------------------------------------
// <copyright file="AttService.asmx.cs" company="">
//   
// </copyright>
// <summary>
//   The att service.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace AttCarrierServiceInterface
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Diagnostics;
    using System.IO;
    using System.Security.Cryptography.X509Certificates;
    using System.Threading;
    using System.Web.Services;
    using System.Web.Services.Protocols;

    using AttCarrierServiceInterface.Implementation;
    using AttCarrierServiceInterface.Interfaces.AttProxy;

    using Microsoft.Web.Services2.Security.Tokens;

    using WirelessAdvocates;
    using WirelessAdvocates.Enum;
    using WirelessAdvocates.Logger;
    using WirelessAdvocates.SalesOrder;
    using WirelessAdvocates.ServiceResponse;

    using Address = WirelessAdvocates.Address;

    /// <summary>The att service.</summary>
    [WebService(Namespace = "http://WirelessAdvocates.ATTCarrierServiceInterface/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [ToolboxItem(false)]
    public class ATTService : WebService
    {
        #region Constants

        /// <summary>The ma x_ credi t_ retries.</summary>
        private const int MAX_CREDIT_RETRIES = 5;

        #endregion

        #region Public Methods and Operators

        /// <summary>The check credit.</summary>
        /// <param name="billingName">The billing name.</param>
        /// <param name="serviceZipCode">The service zip code.</param>
        /// <param name="contactInfo">The contact info.</param>
        /// <param name="billingContactCredentials">The billing contact credentials.</param>
        /// <param name="numberOfLines">The number of lines.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <param name="AAL">The aal.</param>
        /// <returns>The <see cref="CreditCheckResponse"/>.</returns>
        [WebMethod]
        public CreditCheckResponse CheckCredit(
            Name billingName, 
            string serviceZipCode, 
            Contact contactInfo, 
            PersonalCredentials billingContactCredentials, 
            int numberOfLines, 
            string referenceNumber, 
            bool AAL)
        {
            var response = new CreditCheckResponse();
            ExtendedAddress billingAddress;
            AddAccountResponseInfo attAccount = null;

            try
            {
                billingAddress =
                    (ExtendedAddress)
                    CheckoutSessionState.GetByReference(
                        referenceNumber, 
                        Address.AddressEnum.Billing.ToString(), 
                        "AddressValidation", 
                        typeof(ExtendedAddress));

                bool retry = false;

                if (!AAL)
                {
                    // For a new customer we need to add an account which does the credit check also
                    attAccount = this.AddAccountByZip(
                        billingName, 
                        billingAddress, 
                        serviceZipCode, 
                        contactInfo, 
                        billingContactCredentials, 
                        numberOfLines, 
                        referenceNumber);

                    this.HandleCreditResponse(response, attAccount.CreditDecision, out retry, referenceNumber);
                }

                int retryCount = 0;

                while (retry && retryCount++ < MAX_CREDIT_RETRIES)
                {
                    InquireCreditCheckResultResponseInfo creditInquiry = null;

                    if (attAccount.ItemElementName == ItemChoiceType1.GUID)
                    {
                        creditInquiry = this.CreditInquiry(null, attAccount.Item, serviceZipCode, referenceNumber);
                    }

                    if (attAccount.ItemElementName == ItemChoiceType1.billingAccountNumber)
                    {
                        creditInquiry = this.CreditInquiry(attAccount.Item, null, serviceZipCode, referenceNumber);
                    }

                    if (creditInquiry != null)
                    {
                        this.HandleCreditResponse(response, creditInquiry.CreditDecision, out retry, referenceNumber);
                    }
                    else
                    {
                        response = new CreditCheckResponse();
                        response.ErrorCode = (int)ServiceResponseCode.Failure;
                        response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CC_STATUS_UNKNOWN;

                        break;
                    }
                }
            }
            catch (Exception ex)
            {
                new Log().LogException(ex.Message, "Att", "CheckCredit", referenceNumber);

                response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CCError;
                response.ErrorCode = (int)ServiceResponseCode.Failure;
            }

            if (attAccount != null)
            {
                if (attAccount.ItemElementName == ItemChoiceType1.billingAccountNumber)
                {
                    response.CustomerAccountNumber = attAccount.Item;
                }
            }

            new Log().LogOutput(new Utility().SerializeXML(response), "Att", "CheckCredit", referenceNumber);

            return response;
        }

        /// <summary>The cust lookup by ban.</summary>
        /// <param name="ban">The ban.</param>
        /// <param name="pin">The pin.</param>
        /// <param name="serviceZip">The service zip.</param>
        /// <param name="billingZip">The billing zip.</param>
        /// <param name="referenceNumber">The reference number.</param>
        [WebMethod]
        public void CustLookupByBan(
            string ban, 
            string pin, 
            string serviceZip, 
            string billingZip, 
            string referenceNumber)
        {
            var lu = new CustomerLookup(
                ban, 
                pin, 
                serviceZip, 
                billingZip, 
                CustomerLookup.SelectionMethod.Ban, 
                referenceNumber);
            
        }

        /// <summary>The cust lookup by msi sdn.</summary>
        /// <param name="mdn">The mdn.</param>
        /// <param name="pin">The pin.</param>
        /// <param name="billingZip">The billing zip.</param>
        /// <param name="referenceNumber">The reference number.</param>
        [WebMethod]
        public void CustLookupByMsiSdn(string mdn, string pin, string billingZip, string referenceNumber)
        {
            var lu = new CustomerLookup(mdn, pin, null, billingZip, CustomerLookup.SelectionMethod.MDN, referenceNumber);
            
        }

        /// <summary>The echo.</summary>
        /// <param name="echoMe">The echo me.</param>
        /// <returns>The <see cref="string"/>.</returns>
        [WebMethod]
        public string Echo(string echoMe)
        {
            var e = new EchoRequestInfo();
            var attService = new EchoSoapHttpBinding();
            attService.Url = this.GetUrl("EchoEndpoint");
            attService.MessageHeader = this.GetMessageHeader(string.Empty);
            this.AddCerts(attService.ClientCertificates);

            e.data = echoMe;

            new Log().LogRequest(new Utility().SerializeXML(e), "Att", "Echo", "Echo");

            try
            {
                EchoResponseInfo attResponse = attService.Echo(e);

                new Log().LogResponse(new Utility().SerializeXML(attResponse), "Att", "Echo", "Echo");

                echoMe = attResponse.data;
            }
            catch (SoapException soapEx)
            {
                echoMe = soapEx.Message;
            }
            catch (Exception ex)
            {
                echoMe = ex.Message;
            }

            return echoMe;
        }

        /// <summary>The execute credit check.</summary>
        /// <param name="mdn">The mdn.</param>
        /// <param name="pin">The pin.</param>
        /// <param name="billingZip">The billing zip.</param>
        /// <param name="numberOfLines">The number of lines.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="InquireCreditCheckResultResponseInfo"/>.</returns>
        /// <exception cref="SoapException"></exception>
        /// <exception cref="Exception"></exception>
        [WebMethod]
        public InquireCreditCheckResultResponseInfo ExecuteCreditCheck(
            string mdn, 
            string pin, 
            string billingZip, 
            int numberOfLines, 
            string referenceNumber)
        {
            this.CustomerLookupByMsiSdn(mdn, billingZip, pin, referenceNumber);

            string ban = CheckoutSessionState.GetByReference(referenceNumber, "BAN", "CustomerLookup");

            this.CreditInquiry(ban, null, billingZip, referenceNumber);

            var attService = new InquireCreditCheckResultSoapHttpBinding();

            // TODO - CHRGEO - change this to use the new ExecuteCredit objects.
            var attRequest = new InquireCreditCheckResultRequestInfo();
            InquireCreditCheckResultResponseInfo attResponse;

            attService.Url = this.GetUrl("CreditCheckEndpoint");
            this.AddCerts(attService.ClientCertificates);
            attService.MessageHeader = this.GetMessageHeader(referenceNumber);

            attRequest.ItemElementName = ItemChoiceType3.billingAccountNumber;
            attRequest.Item = ban;

            var market = new MarketAndZipServiceInfo();
            market.ItemsElementName = new ItemsChoiceType[1];
            market.ItemsElementName[0] = ItemsChoiceType.serviceZipCode;
            market.Items = new object[1];
            market.Items[0] = billingZip;
            attRequest.marketServiceInfo = market;

            // (basarim) - ???
            // Question: How do we set dealer code?  Is it necessary for this call?          
            // attRequest.AccountSelector.Items[0] = market;
            // attRequest.numberOfLinesRequested = numberOfLines.ToString();
            // attRequest.numberOfLinesRequested = numberOfLines.ToString();
            // attRequest.Commission = new DealerCommissionInfo();
            // attRequest.Commission.dealer = new DealerInfo();
            // attRequest.Commission.dealer.code = GetAppSetting("DealerCode");
            try
            {
                // CHRGEO change this to use executecreditcheck
                attResponse = attService.InquireCreditCheckResult(attRequest);
            }
            catch (SoapException se)
            {
                throw se;
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return attResponse;
        }

        /// <summary>The get market service area by mdn.</summary>
        /// <param name="msiSdn">The msi sdn.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="InquireMarketServiceAreasResponseInfo"/>.</returns>
        [WebMethod]
        public InquireMarketServiceAreasResponseInfo GetMarketServiceAreaByMdn(string msiSdn, string referenceNumber)
        {
            var marketServiceArea = new InquireMarketServiceArea(
                msiSdn, 
                referenceNumber, 
                InquireMarketServiceArea.SelectionMethod.MDN);
            return marketServiceArea.Response;
        }

        /// <summary>The npa lookup by zip.</summary>
        /// <param name="zipCode">The zip code.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="NpaResponse"/>.</returns>
        [WebMethod]
        public NpaResponse NpaLookupByZip(string zipCode, string referenceNumber)
        {
            var response = new NpaResponse();
            response.ErrorCode = (int)ServiceResponseCode.Success;

            var marketServiceArea = new InquireMarketServiceArea(
                zipCode, 
                referenceNumber, 
                InquireMarketServiceArea.SelectionMethod.ZIP);

            if (marketServiceArea.NpaList != null && marketServiceArea.NpaList.Count > 0)
            {
                foreach (NpaInfo n in marketServiceArea.NpaList)
                {
                    response.NpaSet.Add(n);
                }
            }
            else
            {
                if (!marketServiceArea.HasErrors())
                {
                    response.ErrorCode = (int)ServiceResponseCode.Failure;
                }
                else
                {
                    response.ServiceResponseSubCode = (int)ServiceResponseSubCode.NpaNoMarketDataForZip;
                    
                }
            }

            return response;
        }

        /// <summary>The submit order.</summary>
        /// <param name="OrderNumber">The order number.</param>
        /// <returns>The <see cref="OrderActivationResponse"/>.</returns>
        [WebMethod]
        public OrderActivationResponse SubmitOrder(string OrderNumber)
        {
            var response = new OrderActivationResponse();

            WirelessOrder wirelessOrder = null;

            try
            {
                wirelessOrder = new WirelessOrder(Convert.ToInt32(OrderNumber));
            }
            catch (Exception)
            {
                response.ErrorCode = 1;
                response.ServiceResponseSubCode = (int)ServiceResponseSubCode.ACT_INVALID_ORDER_NUMBER;
                response.PrimaryErrorMessage = new EnumHelper().GetDescription(
                    ServiceResponseSubCode.ACT_INVALID_ORDER_NUMBER);

                new Log().LogResponse(
                    new Utility().SerializeXML(response), 
                    "Att", 
                    "SubmitOrder", 
                    wirelessOrder.CheckoutReferenceNumber);

                return response;
            }

            if (wirelessOrder.ActivationType == 'U')
            {
                response = this.SubmitUpgradeOrder(wirelessOrder);

                new Log().LogResponse(
                    new Utility().SerializeXML(response), 
                    "Att", 
                    "UpgradeActivation", 
                    wirelessOrder.CheckoutReferenceNumber);

                return response;
            }

            response.ErrorCode = (int)ServiceResponseCode.Success;

            var asr = new ActivateSubscriberRequest(wirelessOrder);

            new Log().LogRequest(new Utility().SerializeXML(asr), "Att", "SubmitOrder", wirelessOrder.CheckoutReferenceNumber);

            response.ServiceResponseSubCode = (int)ServiceResponseSubCode.ACT_REQUESTED;

            new Log().LogResponse(new Utility().SerializeXML(response), "Att", "SubmitOrder", wirelessOrder.CheckoutReferenceNumber);

            return response;
        }

        /// <summary>The ta p_ validate address.</summary>
        /// <returns>The <see cref="string"/>.</returns>
        [WebMethod]
        public string TAP_ValidateAddress()
        {
            var a = new Address();
            a.AddressLine1 = "4609 Highland Dr";
            a.City = "Bellevue";
            a.ZipCode = "98006";

            return new Utility().SerializeXML(this.ValidateAddress(a, Address.AddressEnum.Shipping, "test12345"));
        }

        /// <summary>The validate address.</summary>
        /// <param name="addressToValidate">The address to validate.</param>
        /// <param name="addressType">The address type.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="AddressValidationResponse"/>.</returns>
        [WebMethod]
        public AddressValidationResponse ValidateAddress(
            Address addressToValidate, 
            Address.AddressEnum addressType, 
            string referenceNumber)
        {
            var attRequest = new ValidateAddressRequestInfo();
            ValidateAddressResponseInfo attResponse = null;

            var attService = new ValidateAddressSoapHttpBinding();
            attService.Url = this.GetUrl("AddressValidationEndpoint");

            AddressValidationResponse response;

            attService.MessageHeader = this.GetMessageHeader(referenceNumber);
            this.AddCerts(attService.ClientCertificates);
            attRequest.Address = new AddressUnrestrictedInfo();
            attRequest.Address.addressLine1 = addressToValidate.AddressLine1;
            attRequest.Address.addressLine2 = addressToValidate.AddressLine2;
            attRequest.Address.city = addressToValidate.City;

            if (!string.IsNullOrEmpty(addressToValidate.Country))
            {
                attRequest.Address.country = addressToValidate.Country;
            }

            if (string.IsNullOrEmpty(addressToValidate.State))
            {
                attRequest.Address.stateSpecified = false;
            }
            else
            {
                attRequest.Address.stateSpecified = true;
                attRequest.Address.state =
                    (AddressStateInfo)Enum.Parse(typeof(AddressStateInfo), addressToValidate.State);
            }

            attRequest.Address.Zip = new AddressZipInfo();
            attRequest.Address.Zip.zipCode = addressToValidate.ZipCode.Trim();
            response = new AddressValidationResponse();

            try
            {
                new Log().LogRequest(new Utility().SerializeXML(attRequest), "Att", "AddressValidation", referenceNumber);

                attResponse = attService.ValidateAddress(attRequest);

                this.CaptureConversationId(
                    attService.MessageHeader.TrackingMessageHeader.conversationId, 
                    referenceNumber);

                new Log().LogResponse(new Utility().SerializeXML(attResponse), "Att", "AddressValidation", referenceNumber);

                this.MapValidationResponse(response, attResponse);

                if (response.ErrorCode == (int)ServiceResponseCode.Success)
                {
                    // Store the response into the database.
                    CheckoutSessionState.Add(
                        referenceNumber, 
                        addressType.ToString(), 
                        ServiceMethods.AddressValidation.ToString(), 
                        response.ValidAddress);
                }
            }
            catch (SoapException se)
            {
                new Log().LogException(se.Message, "Att", "AddressValidation", referenceNumber);

                response.ErrorCode = (int)ServiceResponseCode.Success;
                response.ServiceResponseSubCode = (int)ServiceResponseSubCode.AvInvalidAddress;
                response.PrimaryErrorMessage = se.Message;
            }
            catch (Exception ex)
            {
                new Log().LogException(ex.Message, "Att", "AddressValidation", referenceNumber);

                response.ErrorCode = (int)ServiceResponseCode.Failure;
                response.PrimaryErrorMessage = ex.Message;
            }

            new Log().LogOutput(new Utility().SerializeXML(response), "Att", "AddressValidation", referenceNumber);

            return response;
        }

        // [WebMethod()]
        // public void TAP_AddPort(int orderid)
        // {
        // WirelessAdvocates.SalesOrder.WirelessOrder wirelessOrder = new WirelessAdvocates.SalesOrder.WirelessOrder(orderid);

        // AddPort _portNumbers = new AddPort(wirelessOrder);           
        // }

        // [WebMethod()]
        // public string TAP_ValidatePortIn()
        // {
        // List<MDNSet> mdnList = new List<MDNSet>();
        // MDNSet mdn = new MDNSet();
        // mdn.MDN = "4258091111";
        // mdn.ServiceZipCode = "98006";
        // mdnList.Add(mdn);

        // return WirelessAdvocates.new Utility().SerializeXML(ValidatePortIn(mdnList, "test12345"));
        // }

        /// <summary>The validate port in.</summary>
        /// <param name="MDNList">The mdn list.</param>
        /// <param name="ReferenceNumber">The reference number.</param>
        /// <returns>The <see cref="ValidatePortInResponse"/>.</returns>
        [WebMethod]
        public ValidatePortInResponse ValidatePortIn(List<MDNSet> MDNList, string ReferenceNumber)
        {
            var attRequest = new InquirePortEligibilityBySubscriberNumberRequestInfo();
            var attService = new InquirePortEligibilityBySubscriberNumberSoapHttpBinding();
            InquirePortEligibilityResponseInfo attResponse = null;
            var response = new ValidatePortInResponse();

            attService.Url = this.GetUrl("PortInEndpoint");
            this.AddCerts(attService.ClientCertificates);
            attService.MessageHeader = this.GetMessageHeader(ReferenceNumber);

            attRequest.marketServiceInfo = new MarketAndZipServiceInfo();
            attRequest.marketServiceInfo.ItemsElementName = new ItemsChoiceType[1];
            attRequest.marketServiceInfo.ItemsElementName[0] = ItemsChoiceType.serviceZipCode;
            attRequest.marketServiceInfo.Items = new string[1];
            attRequest.marketServiceInfo.Items[0] = MDNList[0].ServiceZipCode;

            attRequest.PortEligibility =
                new InquirePortEligibilityBySubscriberNumberRequestInfoPortEligibility[MDNList.Count];

            int i = 0;

            foreach (MDNSet set in MDNList)
            {
                attRequest.PortEligibility[i] = new InquirePortEligibilityBySubscriberNumberRequestInfoPortEligibility();
                attRequest.PortEligibility[i].subscriberNumber = set.MDN;
                attRequest.PortEligibility[i].equipmentType = new EquipmentTypeInfo();
                attRequest.PortEligibility[i].equipmentType = EquipmentTypeInfo.G;

                i++;
            }

            try
            {
                new Log().LogRequest(new Utility().SerializeXML(attRequest), "Att", "PortIn", ReferenceNumber);

                attResponse = attService.InquirePortEligibilityBySubscriberNumber(attRequest);

                this.CaptureConversationId(
                    attService.MessageHeader.TrackingMessageHeader.conversationId, 
                    ReferenceNumber);

                new Log().LogResponse(new Utility().SerializeXML(attResponse), "Att", "PortIn", ReferenceNumber);
            }
            catch (Exception ex)
            {
                response.ErrorCode = (int)ServiceResponseCode.Failure;
                response.PrimaryErrorMessage = ex.Message;

                new Log().LogException(ex.Message, "Att", "PortIn", ReferenceNumber);
            }

            if (attResponse != null && attResponse.PortEligibilityResponse != null)
            {
                response.ErrorCode = (int)this.MapAttPortInResponse(MDNList, attResponse);
                response.MDNSet = MDNList;
            }

            new Log().LogOutput(new Utility().SerializeXML(response), "Att", "PortIn", ReferenceNumber);

            return response;
        }

        #endregion

        // Called if account doesn't exist (should be internal to web services)
        #region Methods

        /// <summary>The add account by zip.</summary>
        /// <param name="billingName">The billing name.</param>
        /// <param name="billingAddress">The billing address.</param>
        /// <param name="serviceZipCode">The service zip code.</param>
        /// <param name="contactInfo">The contact info.</param>
        /// <param name="billingContactCredentials">The billing contact credentials.</param>
        /// <param name="numberOfLines">The number of lines.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="AddAccountResponseInfo"/>.</returns>
        private AddAccountResponseInfo AddAccountByZip(
            Name billingName, 
            ExtendedAddress billingAddress, 
            string serviceZipCode, 
            Contact contactInfo, 
            PersonalCredentials billingContactCredentials, 
            int numberOfLines, 
            string referenceNumber)
        {
            var acct = new AddAccount(
                billingName, 
                billingAddress, 
                serviceZipCode, 
                contactInfo, 
                billingContactCredentials, 
                numberOfLines, 
                referenceNumber);
            AddAccountResponseInfo attResponse;

            try
            {
                

                var attService = new AddAccountSoapHttpBinding();
                var attRequest = new AddAccountRequestInfo();

                attService.Url = this.GetUrl("AddAccountEndpoint");
                this.AddCerts(attService.ClientCertificates);
                attService.MessageHeader = this.GetMessageHeader(referenceNumber);

                

                #region Account Information

                attRequest.Account = new AddAccountRequestInfoAccount();
                attRequest.Account.AccountType = new RestrictedAccountTypeInfo();
                attRequest.Account.AccountType.accountType = "I";
                attRequest.Account.AccountType.accountSubType = "R";
                attRequest.Account.AccountType.openChannel = OpenChannelInfo.R;
                attRequest.Account.taxExemptionRequest = false;

                #endregion

                #region Market Info

                attRequest.marketServiceInfo = new MarketAndZipServiceInfo();
                attRequest.marketServiceInfo.ItemsElementName = new ItemsChoiceType[1];
                attRequest.marketServiceInfo.Items = new string[1];
                attRequest.marketServiceInfo.ItemsElementName[0] = ItemsChoiceType.serviceZipCode;
                attRequest.marketServiceInfo.Items[0] = serviceZipCode;

                #endregion

                #region Customer Name

                attRequest.Customer = new AddAccountRequestInfoCustomer();
                attRequest.Customer.Items = new object[1];

                var name = new ExtendedNameInfo();
                name.firstName = billingName.FirstName;
                name.lastName = billingName.LastName;

                attRequest.Customer.Items[0] = name;

                attRequest.Customer.CreditCheckName = new AddAccountRequestInfoCustomerCreditCheckName();

                var nameInfo = new NameInfo();
                nameInfo.firstName = billingName.FirstName;
                nameInfo.lastName = billingName.LastName;
                nameInfo.middleName = billingName.MiddleInitial;

                attRequest.Customer.CreditCheckName.Item = nameInfo;

                #endregion

                #region Addresses

                attRequest.Customer.CreditCheckAddress = new AddressInfo();
                attRequest.Customer.CreditCheckAddress.AddressLine1 = billingAddress.AddressLine1;
                attRequest.Customer.CreditCheckAddress.AddressLine2 = billingAddress.AddressLine2;
                attRequest.Customer.CreditCheckAddress.City = billingAddress.City;
                attRequest.Customer.CreditCheckAddress.Zip = new AddressZipInfo();
                attRequest.Customer.CreditCheckAddress.Zip.zipCode = billingAddress.ZipCode;
                attRequest.Customer.CreditCheckAddress.Zip.zipCodeExtension = billingAddress.ExtendedZipCode;
                attRequest.Customer.CreditCheckAddress.State =
                    (AddressStateInfo)Enum.Parse(typeof(AddressStateInfo), billingAddress.State);

                attRequest.Customer.Address = new AddressInfo();
                attRequest.Customer.Address.AddressLine1 = billingAddress.AddressLine1;
                attRequest.Customer.Address.AddressLine2 = billingAddress.AddressLine2;
                attRequest.Customer.Address.City = billingAddress.City;
                attRequest.Customer.Address.Country = billingAddress.Country;
                attRequest.Customer.Address.State =
                    (AddressStateInfo)Enum.Parse(typeof(AddressStateInfo), billingAddress.State);
                attRequest.Customer.Address.Zip = new AddressZipInfo();
                attRequest.Customer.Address.Zip.zipCode = billingAddress.ZipCode;
                attRequest.Customer.Address.Zip.zipCodeExtension = billingAddress.ExtendedZipCode;

                #endregion

                #region Identity

                attRequest.Customer.Identity = new AddAccountRequestInfoCustomerIdentity();
                attRequest.Customer.Identity.Identification = new RestrictedIdentificationInfo();

                attRequest.Customer.Identity.Identification.expirationDate =
                    billingContactCredentials.IdExpiration.ToString("yyyy-MM-ddZ");

                attRequest.Customer.Identity.Identification.idNumber = billingContactCredentials.Id;
                attRequest.Customer.Identity.Identification.idType = IdentificationTypeInfo.DL;
                attRequest.Customer.Identity.Identification.issuingAuthority = billingContactCredentials.State;

                attRequest.Customer.Identity.ItemsElementName = new ItemsChoiceType1[2];
                attRequest.Customer.Identity.ItemsElementName[0] = ItemsChoiceType1.Birth;
                attRequest.Customer.Identity.ItemsElementName[1] = ItemsChoiceType1.socialSecurityNumber;

                attRequest.Customer.Identity.Items = new object[2];
                var birthInfo = new BirthInfo();

                birthInfo.dateOfBirth = billingContactCredentials.Dob.ToString("yyyy-MM-ddZ");
                attRequest.Customer.Identity.Items[0] = birthInfo;
                attRequest.Customer.Identity.Items[1] = billingContactCredentials.SSN;

                attRequest.creditApplicationType = CreditApplicationTypeInfo.CRR;

                #endregion

                #region Contact / Phone

                attRequest.Customer.Phone = new PhoneInfo();
                attRequest.Customer.Phone.canBeReachedPhone = "false";

                if (!string.IsNullOrEmpty(contactInfo.EveningPhone))
                {
                    attRequest.Customer.Phone.homePhone = contactInfo.EveningPhone;
                    attRequest.Customer.Phone.workPhone = contactInfo.EveningPhone;
                    attRequest.Customer.Phone.canBeReachedPhone = "true";
                }

                if (!string.IsNullOrEmpty(contactInfo.WorkPhone))
                {
                    attRequest.Customer.Phone.workPhone = contactInfo.WorkPhone;
                    attRequest.Customer.Phone.workPhoneExtension = contactInfo.WorkPhoneExt;
                    attRequest.Customer.Phone.canBeReachedPhone = "true";
                }

                #endregion

                #region Dealer

                attRequest.Commission = new DealerCommissionInfo();
                attRequest.Commission.dealer = new DealerInfo();
                attRequest.Commission.dealer.code = this.GetAppSetting("DealerCode");

                #endregion

                attRequest.desiredNumberOfLines = numberOfLines.ToString();

                var reservedNumbers = new List<AddAccountRequestInfoReserveSubscriberNumber>();
                var reservedSubscriberNumber = new AddAccountRequestInfoReserveSubscriberNumber();

                new Log().LogRequest(new Utility().SerializeXML(attRequest), "Att", "AddAccountByZip", referenceNumber);

                attResponse = attService.AddAccount(attRequest);

                this.CaptureConversationId(
                    attService.MessageHeader.TrackingMessageHeader.conversationId, 
                    referenceNumber);

                new Log().LogResponse(new Utility().SerializeXML(attResponse), "Att", "AddAccountByZip", referenceNumber);
            }
            catch (Exception ex)
            {
                new Log().LogException(ex.Message, "Att", "AddAccountByZip", referenceNumber);

                throw;
            }

            return attResponse;
        }

        /// <summary>The add certs.</summary>
        /// <param name="certCollection">The cert collection.</param>
        private void AddCerts(X509CertificateCollection certCollection)
        {
            string[] certFiles = Directory.GetFiles(this.Server.MapPath("App_Data"));
            foreach (string s in certFiles)
            {
                if (s.EndsWith("cer"))
                {
                    certCollection.Add(X509Certificate.CreateFromCertFile(s));
                    Trace.WriteLine("Cert: " + s);
                    Trace.WriteLine(Environment.UserName);
                    Trace.Flush();
                }
            }
        }

        /// <summary>The capture conversation id.</summary>
        /// <param name="conversationId">The conversation id.</param>
        /// <param name="referenceNumber">The reference number.</param>
        private void CaptureConversationId(string conversationId, string referenceNumber)
        {
            if (!string.IsNullOrEmpty(conversationId))
            {
                string existingConversationId = string.Empty;

                try
                {
                    existingConversationId = CheckoutSessionState.GetByReference(
                        referenceNumber, 
                        "ConversationId", 
                        "Any");
                }
                catch (Exception)
                {
                    existingConversationId = string.Empty;
                }

                if (string.IsNullOrEmpty(existingConversationId))
                {
                    CheckoutSessionState.Add(referenceNumber, "ConversationId", "Any", conversationId);
                }
            }
        }

        /// <summary>The copy address.</summary>
        /// <param name="address">The address.</param>
        /// <param name="attAddress">The att address.</param>
        private void CopyAddress(ExtendedAddress address, AddressUnrestrictedInfo attAddress)
        {
            address.AddressLine1 = attAddress.addressLine1;
            address.AddressLine2 = attAddress.addressLine2;
            address.City = attAddress.city;
            address.State = attAddress.state.ToString();
            address.Country = attAddress.country;

            if (attAddress.Street != null)
            {
                address.StreetName = attAddress.Street.streetName;
                address.StreetType = attAddress.Street.streetType;
                address.HouseNumber = attAddress.Street.streetNumber;
                address.DirectionalPrefix = attAddress.Street.streetDirection;
                address.DirectionalSuffix = attAddress.Street.streetTrailingDirection;
            }

            if (attAddress.Unit != null)
            {
                address.AptNumber = attAddress.Unit.value;
            }

            if (attAddress.Zip != null)
            {
                address.ZipCode = attAddress.Zip.zipCode;
                address.ExtendedZipCode = attAddress.Zip.zipCodeExtension;
            }
        }

        // [WebMethod()]
        // public void Tap_IAP_UE(string mdn, string pin, string billingZip, string referenceNumber)
        // {
        // CustomerLookupByMsiSdn(mdn, billingZip, pin, referenceNumber);

        // string ban = WirelessAdvocates.CheckoutSessionState.GetByReference(referenceNumber, "BAN", "CustomerLookup");

        // InquireUpgradeEligibility(mdn, referenceNumber);
        // }

        ////[WebMethod()]
        // public void TestAttAddAccount()
        // {
        // Name name = new Name();
        // ExtendedAddress extAddress = new ExtendedAddress();
        // Contact contact = new Contact();
        // PersonalCredentials personalCreds = new PersonalCredentials();

        // name.FirstName = null;// "Joe";
        // name.MiddleInitial = "A";
        // name.LastName = null;// "Jones";
        // extAddress.AddressLine1 = "725 Medical Drive";
        // extAddress.City = "Abilene";
        // extAddress.State = "TX";
        // extAddress.ZipCode = "79601";
        // extAddress.ExtendedZipCode = "7108";
        // contact.CellPhone = "4259221019";
        // contact.Email = "testemail@service.com";
        // contact.EveningPhone = "4259329191";
        // contact.WorkPhone = "4256993212";
        // personalCreds.DOB = DateTime.Parse("1/28/1950");
        // personalCreds.Id = "dkskkkd";
        // personalCreds.IdExpiration = DateTime.Parse("1/28/2011");
        // personalCreds.IdType = PersonalCredentials.IdentificationType.DL;
        // personalCreds.SSN = "0000000";  // personal
        // personalCreds.State = "TX";

        // AddAccount account = new AddAccount(name, extAddress, "79601", contact, personalCreds, 1, "testreference");
        // }

        // [WebMethod()]
        // public string TempEOActivation(int orderid)
        // {
        // WirelessAdvocates.SalesOrder.WirelessOrder wirelessOrder = new WirelessAdvocates.SalesOrder.WirelessOrder(orderid);

        // string ues = string.Empty;

        // foreach (WirelessAdvocates.SalesOrder.WirelessLine line in wirelessOrder.WirelessLines)
        // {
        // InquireDuplicateOfferings dups = new InquireDuplicateOfferings(wirelessOrder, line);
        // UpgradeEquipment ue = new UpgradeEquipment(wirelessOrder, line, UpgradeEquipment.RequestType.Park);//, "temp");
        // UpdateSubscriberProfile usp = new UpdateSubscriberProfile(wirelessOrder, line, dups);

        // ues = WirelessAdvocates.new Utility().SerializeXML(ue);
        // }

        // return ues;
        // }

        // [WebMethod()]
        // public void TestOrderQueries(int OrderNumber)
        // {
        // WirelessOrder wirelessOrder = null;
        // wirelessOrder = new WirelessOrder(OrderNumber);

        // bool waiting = !wirelessOrder.WirelessLines.Any(s => s.ActivationStatus == ActivationStatus.RequestSubmitted);
        // bool failures = wirelessOrder.WirelessLines.Any(s => s.ActivationStatus == ActivationStatus.Failure);
        // bool success = wirelessOrder.WirelessLines.Any(s => s.ActivationStatus == ActivationStatus.Success);
        // }

        // Calls AT&T to do a credit inquiry for one they have already done.
        // If the Lines Approved is more than Requested, need to run ExecuteCreditCheck.
        /// <summary>The credit inquiry.</summary>
        /// <param name="ban">The ban.</param>
        /// <param name="guid">The guid.</param>
        /// <param name="serviceZipCode">The service zip code.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="InquireCreditCheckResultResponseInfo"/>.</returns>
        /// <exception cref="Exception"></exception>
        private InquireCreditCheckResultResponseInfo CreditInquiry(
            string ban, 
            string guid, 
            string serviceZipCode, 
            string referenceNumber)
        {
            var attRequest = new InquireCreditCheckResultRequestInfo();
            var attResponse = new InquireCreditCheckResultResponseInfo();
            var attService = new InquireCreditCheckResultSoapHttpBinding();

            try
            {
                attService.Url = this.GetUrl("InquireCreditCheckResultEndpoint");
                this.AddCerts(attService.ClientCertificates);
                attService.MessageHeader = this.GetMessageHeader(referenceNumber);

                if (!string.IsNullOrEmpty(ban))
                {
                    attRequest.Item = ban;
                    attRequest.ItemElementName = ItemChoiceType3.billingAccountNumber;
                }
                else if (!string.IsNullOrEmpty(guid))
                {
                    attRequest.Item = guid;
                    attRequest.ItemElementName = ItemChoiceType3.GUID;
                }
                else
                {
                    throw new Exception("System Error: Cannot perform a credit check inquiry without a ban or guid");
                }

                attRequest.marketServiceInfo = new MarketAndZipServiceInfo();
                attRequest.marketServiceInfo.Items = new object[1];
                attRequest.marketServiceInfo.ItemsElementName = new ItemsChoiceType[1];

                attRequest.marketServiceInfo.Items[0] = serviceZipCode;
                attRequest.marketServiceInfo.ItemsElementName[0] = ItemsChoiceType.serviceZipCode;

                new Log().LogRequest(new Utility().SerializeXML(attRequest), "Att", "CreditInquiryByGuid", referenceNumber);

                attResponse = attService.InquireCreditCheckResult(attRequest);

                new Log().LogResponse(new Utility().SerializeXML(attResponse), "Att", "CreditInquiryByGuid", referenceNumber);
            }
            catch (Exception ex)
            {
                new Log().LogException(ex.Message, "Att", "CreditInquiryByGuid", referenceNumber);

                throw;
            }

            return attResponse;
        }

        /// <summary>The credit inquiry retriable.</summary>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="bool"/>.</returns>
        private bool CreditInquiryRetriable(string referenceNumber)
        {
            bool retry = false;
            int attempts = 0;

            try
            {
                attempts =
                    (int)
                    CheckoutSessionState.GetByReference(referenceNumber, "Credit", "CreditInquiryCount", typeof(int));
            }
            catch (Exception)
            {
                attempts = 0;
            }

            int retries = 0;

            if (int.TryParse(this.GetAppSetting("CreditInquiryRetries"), out retries))
            {
                if (attempts < retries)
                {
                    attempts++;

                    CheckoutSessionState.Add(referenceNumber, "Credit", "CreditInquiryCount", attempts);

                    int delayInSeconds = 0;

                    if (int.TryParse(this.GetAppSetting("CreditRetryDelay"), out delayInSeconds))
                    {
                        Thread.Sleep(delayInSeconds * 1000);
                    }

                    retry = true;
                }
            }

            return retry;
        }

        /// <summary>The customer lookup by msi sdn.</summary>
        /// <param name="msiSdn">The msi sdn.</param>
        /// <param name="billingZip">The billing zip.</param>
        /// <param name="pin">The pin.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="CustomerInquiryResponse"/>.</returns>
        /// <exception cref="Exception"></exception>
        [WebMethod]
        private CustomerInquiryResponse CustomerLookupByMsiSdn(
            string msiSdn, 
            string billingZip, 
            string pin, 
            string referenceNumber)
        {
            var response = new CustomerInquiryResponse();
            var attService = new InquireAccountProfileSoapHttpBinding();
            var attRequest = new InquireAccountProfileRequestInfo();
            InquireAccountProfileResponseInfo attResponse = null;

            if (msiSdn.Length != 10)
            {
                throw new Exception("Phone number must be 10 digits.");
            }

            attService.Url = this.GetUrl("InquireAccountProfileEndpoint");
            attService.MessageHeader = this.GetMessageHeader(referenceNumber);
            this.AddCerts(attService.ClientCertificates);

            attRequest.AccountSelector = new AccountSelectorInfo();
            attRequest.AccountSelector.Items = new string[1];
            attRequest.AccountSelector.Items[0] = msiSdn;
            attRequest.AccountSelector.ItemsElementName = new ItemsChoiceType2[1];
            attRequest.AccountSelector.ItemsElementName[0] = new ItemsChoiceType2();
            attRequest.AccountSelector.ItemsElementName[0] = ItemsChoiceType2.subscriberNumber;

            attRequest.AccountVerification = new AccountVerificationInfo();
            attRequest.AccountVerification.billingZipCode = billingZip;
            attRequest.AccountVerification.last4SSN = pin;
            attRequest.UpgradeEligibilityCriteria = new SecureUpgradeEligibilityInfo();
            attRequest.UpgradeEligibilityCriteria.newSalesChannel = this.GetAppSetting("NewSalesChannel");
            attRequest.mask = this.GetAppSetting("IAPMask");

            try
            {
                new Log().LogRequest(new Utility().SerializeXML(attRequest), "Att", "CustomerLookupByMdn", referenceNumber);

                attResponse = attService.InquireAccountProfile(attRequest);

                new Log().LogResponse(new Utility().SerializeXML(attResponse), "Att", "CustomerLookupByMdn", referenceNumber);

                this.CaptureConversationId(
                    attService.MessageHeader.TrackingMessageHeader.conversationId, 
                    referenceNumber);

                long responseCode = 0;

                if (long.TryParse(attResponse.Response.code, out responseCode))
                {
                    if (responseCode == 0)
                    {
                        CheckoutSessionState.Add(referenceNumber, "MDN", "CustomerLookup", msiSdn);
                        CheckoutSessionState.Add(
                            referenceNumber, 
                            "BAN", 
                            "CustomerLookup", 
                            attResponse.Account.billingAccountNumber);

                        response.ErrorCode = (int)ServiceResponseCode.Success;
                    }
                    else
                    {
                        response.ErrorCode = (int)ServiceResponseCode.Failure;
                    }
                }
                else
                {
                    response.ErrorCode = (int)ServiceResponseCode.Failure;
                }

                response.PrimaryErrorMessage = attResponse.Response.description;

                Address billingAddress = null;

                

                if (attResponse.Account != null && attResponse.Account.Customer != null
                    && attResponse.Account.Customer.Address != null)
                {
                    // set ban
                    response.CustomerAccountNumber = attResponse.Account.billingAccountNumber;

                    // set Account Password for use in UI. - CHRGEO   .
                    response.CustomerAccountPassword = string.Empty;

                    if (attResponse.Account.billingAccountPassword != null)
                    {
                        response.CustomerAccountPassword = attResponse.Account.billingAccountPassword;
                            
                            // CHRGEO - new to support AT&T 4th Validation field..
                    }

                    // set address
                    billingAddress = new Address();

                    billingAddress.AddressLine1 = attResponse.Account.Customer.Address.AddressLine1;

                    if (attResponse.Account.Customer.Address.AddressLine2 != null)
                    {
                        billingAddress.AddressLine2 = attResponse.Account.Customer.Address.AddressLine2;
                    }

                    billingAddress.City = attResponse.Account.Customer.Address.City;
                    billingAddress.Country = attResponse.Account.Customer.Address.Country;
                    billingAddress.ExtendedZipCode = attResponse.Account.Customer.Address.Zip.zipCodeExtension;
                    billingAddress.ZipCode = attResponse.Account.Customer.Address.Zip.zipCode;
                }

                

                #region Lines Available for Customer - Credit Check

                response.LinesApproved = 0;
                response.LinesAvailable = 0;

                InquireCreditCheckResultResponseInfo creditInfo;

                try
                {
                    creditInfo = this.CreditInquiry(
                        attResponse.Account.billingAccountNumber, 
                        null, 
                        billingZip, 
                        referenceNumber);

                    if (creditInfo != null && creditInfo.CreditDecision != null)
                    {
                        response.LinesAvailable = creditInfo.CreditDecision.numberOfLinesAvailable;

                        if (creditInfo.CreditDecision.approvedSubscriberLines != null)
                        {
                            int approved = 0;

                            if (int.TryParse(creditInfo.CreditDecision.approvedSubscriberLines, out approved))
                            {
                                response.LinesApproved = approved;
                            }
                        }
                    }
                }
                catch (Exception)
                {
                }

                #endregion Available Lines

                int activeLines = 0;

                response.WirelessAccountType = WirelessAccountType.Individual; // default

                bool accountMonthlyChargeSet = false;

                foreach (InquireSubscriberProfileResponseInfo profile in attResponse.Account.Subscriber)
                {
                    var lineItem = new CustomerInquiryLine();

                    lineItem.AccountStatus = AccountStatusCode.Unknown;
                    lineItem.WirelessLineType = WirelessLineType.Line;

                    if (profile.Subscriber != null)
                    {
                        if (profile.Subscriber.SubscriberStatus != null
                            && this.MapLineStatus(profile.Subscriber.SubscriberStatus.subscriberStatus)
                            == AccountStatusCode.Operational)
                        {
                            if (profile.Subscriber.PricePlan != null)
                            {
                                if (!accountMonthlyChargeSet)
                                {
                                    response.ExistingAccountMonthlyCharges =
                                        profile.Subscriber.PricePlan.recurringCharge;
                                }

                                try
                                {
                                    // Family plan, will have groupInfo object returned in this case
                                    var groupInfo = (PricePlanGroupDetailsInfo)profile.Subscriber.PricePlan.Item;

                                    response.WirelessAccountType = WirelessAccountType.Family;

                                    lineItem.ExistingLineMonthlyCharges = groupInfo.additionalLineCharge;
                                    lineItem.IsPrimaryLine = groupInfo.primarySubscriber;

                                    // CHRGEO - Added for GERS PlanCode work
                                    lineItem.PlanCode = string.Empty;

                                    if (groupInfo.groupPlanCode != null)
                                    {
                                        lineItem.PlanCode = groupInfo.groupPlanCode;
                                    }
                                }
                                catch
                                {
                                    // Individual single or multiline account
                                    lineItem.IsPrimaryLine = true;
                                    lineItem.ExistingLineMonthlyCharges = profile.Subscriber.PricePlan.recurringCharge;

                                    // CHRGEO - Added for GERS PlanCode work
                                    lineItem.PlanCode = string.Empty;

                                    if (profile.Subscriber.PricePlan != null)
                                    {
                                        PricePlanInfo planInfo = profile.Subscriber.PricePlan;
                                        lineItem.PlanCode = planInfo.Item.ToString();
                                    }

                                    if (attResponse.Account.Subscriber.Length > 1)
                                    {
                                        response.ExistingAccountMonthlyCharges = 0;
                                        response.WirelessAccountType = WirelessAccountType.MultiLine;
                                    }
                                    else
                                    {
                                        response.WirelessAccountType = WirelessAccountType.Individual;
                                    }
                                }
                            }

                            #region Upgrade Eligibility Check

                            lineItem.UpgradeAvailableDate = string.Empty;

                            // Need an accurate way to determine if its NEW, UPGRADE or AAL

                            // Current Customer - CanUpgrade
                            if (profile.Subscriber.UpgradeEligibility != null)
                            {
                                lineItem.UpgradeAvailableSpecified = true;
                                lineItem.EquipmentUpgradeAvailable =
                                    profile.Subscriber.UpgradeEligibility.eligibilityStatus
                                     != UpgradeEligibilityStatusInfo.I; // Not Ineligible

                                if (profile.Subscriber.UpgradeEligibility.futureEligibilityDate != null)
                                {
                                    DateTime futureDate;
                                    if (DateTime.TryParse(
                                        profile.Subscriber.UpgradeEligibility.futureEligibilityDate, 
                                        out futureDate))
                                    {
                                        // futureDate = futureDate.AddDays(-1);
                                        lineItem.UpgradeAvailableDate = futureDate.ToString("d"); // CHRGEO
                                    }
                                }
                            }
                            else
                            {
                                // Current Customer can't upgrade
                                InquireUpgradeEligibilityResponseInfo upgradeResponse =
                                    this.InquireUpgradeEligibility(profile.Subscriber.subscriberNumber, referenceNumber);

                                lineItem.UpgradeAvailableSpecified = true;

                                // Debug.WriteLine("Eligibility 1");
                                if (upgradeResponse != null && upgradeResponse.Eligibility != null)
                                {
                                    // Debug.WriteLine("Eligibility 2");
                                    // Debug.WriteLine("upgradeResponse.Eligibility.eligibilityStatus:" + upgradeResponse.Eligibility.eligibilityStatus);
                                    lineItem.EquipmentUpgradeAvailable = upgradeResponse.Eligibility.eligibilityStatus
                                                                          != UpgradeEligibilityStatusInfo.I;

                                    // Debug.WriteLine("EquipmentUpgradeAvailable: " + lineItem.EquipmentUpgradeAvailable);
                                    if (upgradeResponse.Eligibility.futureEligibilityDate != null)
                                    {
                                        // Debug.WriteLine("Eligibility 4");
                                        DateTime futureDate;
                                        if (DateTime.TryParse(
                                            upgradeResponse.Eligibility.futureEligibilityDate, 
                                            out futureDate))
                                        {
                                            // futureDate = futureDate.AddDays(-1);
                                            lineItem.UpgradeAvailableDate = futureDate.ToString("d"); // CHRGEO
                                        }
                                    }
                                }
                                else
                                {
                                    lineItem.EquipmentUpgradeAvailable = false;
                                    if (profile.Subscriber.UpgradeEligibility.futureEligibilityDate != null)
                                    {
                                        DateTime futureDate;
                                        if (DateTime.TryParse(
                                            upgradeResponse.Eligibility.futureEligibilityDate, 
                                            out futureDate))
                                        {
                                            // futureDate = futureDate.AddDays(-1);
                                            lineItem.UpgradeAvailableDate = futureDate.ToString("d"); // CHRGEO
                                        }
                                    }
                                }
                            }

                            #endregion Upgrade Eligibility Check

                            #region Customer Status/Contract Details

                            if (profile.Subscriber.Contract != null && profile.Subscriber.Contract.ContractTerm != null
                                && profile.Subscriber.Contract.ContractTerm.startDate != null)
                            {
                                lineItem.ContractStart =
                                    DateTime.Parse(profile.Subscriber.Contract.ContractTerm.startDate);
                                lineItem.ContractStartSpecified =
                                    profile.Subscriber.Contract.ContractTerm.startDateSpecified;
                            }
                            else
                            {
                                lineItem.ContractStartSpecified = false;
                            }

                            if (profile.Subscriber.SubscriberStatus != null)
                            {
                                lineItem.AccountStatus =
                                    this.MapLineStatus(profile.Subscriber.SubscriberStatus.subscriberStatus);
                            }

                            if (lineItem.AccountStatus == AccountStatusCode.Operational)
                            {
                                activeLines++;
                            }

                            #endregion Customer Status/Contract Details

                            #region Customer Addresses

                            lineItem.BillingAddress = billingAddress;

                            if (profile.Subscriber.ContactInformation.PpuAddress != null)
                            {
                                lineItem.ShippingAddress = new Address();
                                lineItem.ShippingAddress.AddressLine1 =
                                    profile.Subscriber.ContactInformation.PpuAddress.AddressLine1;
                                lineItem.ShippingAddress.AddressLine2 =
                                    profile.Subscriber.ContactInformation.PpuAddress.AddressLine2;
                                lineItem.ShippingAddress.City = profile.Subscriber.ContactInformation.PpuAddress.City;
                                lineItem.ShippingAddress.Country =
                                    profile.Subscriber.ContactInformation.PpuAddress.Country;
                                lineItem.ShippingAddress.ExtendedZipCode =
                                    profile.Subscriber.ContactInformation.PpuAddress.Zip.zipCodeExtension;
                                lineItem.ShippingAddress.ZipCode =
                                    profile.Subscriber.ContactInformation.PpuAddress.Zip.zipCode;
                                lineItem.ShippingAddress.State =
                                    profile.Subscriber.ContactInformation.PpuAddress.State.ToString();
                            }
                            else
                            {
                                lineItem.ShippingAddress = billingAddress;
                            }

                            #endregion Customer Addresses

                            lineItem.Mdn = profile.Subscriber.subscriberNumber;

                            if (lineItem.Mdn == msiSdn)
                            {
                                response.CustomerInquiryLines.Insert(0, lineItem);
                                    
                                    // Put the entered mdn first in the list;
                            }
                            else
                            {
                                response.CustomerInquiryLines.Add(lineItem);
                            }
                        }
                    }
                }

                response.LinesActive = activeLines;
                response.LinesApproved = response.LinesAvailable + response.LinesActive;
                response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CL_CUSTOMER_FOUND;

                Debug.WriteLine("LinesAvailable: " + response.LinesAvailable);
                Debug.WriteLine("LinesApproved: " + response.LinesApproved);
                Debug.WriteLine("LinesActive: " + response.LinesActive);
            }
            catch (SoapException se)
            {
                new Log().LogException(se.Message, "Att", "CustomerLooup", referenceNumber);

                response.ErrorCode = (int)ServiceResponseCode.Success;
                response.ServiceResponseSubCode = (int)ServiceResponseSubCode.ClCustomerNotFound;
                response.PrimaryErrorMessage = se.Message;
            }
            catch (Exception ex)
            {
                new Log().LogException(ex.Message, "Att", "CustomerLookupByMdn", referenceNumber);

                response.ErrorCode = (int)ServiceResponseCode.Failure;
                response.PrimaryErrorMessage = ex.Message;
            }

            try
            {
                new Log().LogOutput(new Utility().SerializeXML(response), "Att", "CustomerLookupByMdn", referenceNumber);
            }
            catch (Exception ex1)
            {
                new Log().LogException(ex1.ToString(), "Att", "CustomerLookupByMsiSdn", referenceNumber);
            }

            new Log().LogOutput(new Utility().SerializeXML(response), "Att", "CustomerLookupByMsiSdn", referenceNumber);

            return response;
        }

        /// <summary>The get app setting.</summary>
        /// <param name="key">The key.</param>
        /// <returns>The <see cref="string"/>.</returns>
        private string GetAppSetting(string key)
        {
            var config = new WaConfigurationManager(this.Server.MapPath(string.Empty));

            return config.AppSetting(key);
        }

        /// <summary>The get message header.</summary>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="MessageHeaderInfo"/>.</returns>
        private MessageHeaderInfo GetMessageHeader(string referenceNumber)
        {
            var header = new MessageHeaderInfo();
            header.SecurityMessageHeader = new MessageHeaderSecurity();
            header.SecurityMessageHeader.userName = this.GetAppSetting("UserName");
            header.SecurityMessageHeader.userPassword = this.GetAppSetting("Password");
            header.SequenceMessageHeader = new MessageHeaderSequence();
            header.SequenceMessageHeader.sequenceNumber = "1";
            header.SequenceMessageHeader.totalInSequence = "1";

            header.TrackingMessageHeader = new MessageHeaderTracking();
            header.TrackingMessageHeader.messageId = Guid.NewGuid().ToString();
            header.TrackingMessageHeader.dateTimeStamp = DateTime.UtcNow.ToString("s") + "Z";
            header.TrackingMessageHeader.version = this.GetAppSetting("apiVersion");

            try
            {
                string ConversationId;

                ConversationId = CheckoutSessionState.GetByReference(referenceNumber, "ConversationId", "Any");

                if (!string.IsNullOrEmpty(ConversationId))
                {
                    header.TrackingMessageHeader.conversationId = ConversationId;
                }
            }
            catch (Exception)
            {
                // Don't set the conversation, first call of the sequence.
            }

            return header;
        }

        /// <summary>The get url.</summary>
        /// <param name="endPointName">The end point name.</param>
        /// <returns>The <see cref="string"/>.</returns>
        private string GetUrl(string endPointName)
        {
            string url;

            url = this.GetAppSetting("AttHost") + this.GetAppSetting(endPointName);
            return url;
        }

        /// <summary>The get username token.</summary>
        /// <returns>The <see cref="UsernameToken"/>.</returns>
        private UsernameToken GetUsernameToken()
        {
            var userToken = new UsernameToken(
                this.GetAppSetting("Username"), 
                this.GetAppSetting("Password"), 
                PasswordOption.SendPlainText);
            return userToken;
        }

        /// <summary>The handle credit response.</summary>
        /// <param name="response">The response.</param>
        /// <param name="creditDecision">The credit decision.</param>
        /// <param name="retry">The retry.</param>
        /// <param name="referenceNumber">The reference number.</param>
        private void HandleCreditResponse(
            CreditCheckResponse response, 
            CreditDecisionInfo creditDecision, 
            out bool retry, 
            string referenceNumber)
        {
            retry = false;
            response.CreditCode = creditDecision.creditClass;
            response.CreditApplicationNumber = creditDecision.decisionReferenceNumber;

            int lines = 0;

            if (int.TryParse(creditDecision.approvedSubscriberLines, out lines))
            {
                response.NumberOfLines = lines;
            }
            else
            {
                response.NumberOfLines = 0;
            }

            switch (creditDecision.decisionCode)
            {
                case "CA":
                    response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CC_CREDIT_APPROVED;

                    break;
                case "PA":
                    retry = this.CreditInquiryRetriable(referenceNumber);

                    if (!retry)
                    {
                        response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CC_STATUS_UNKNOWN;
                    }

                    break;
                case "AR":
                    response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CC_STATUS_UNKNOWN;
                    retry = false;

                    break;
                default:
                    response.ServiceResponseSubCode = (int)ServiceResponseSubCode.CC_STATUS_UNKNOWN;
                    retry = false;

                    break;
            }

            response.Deposit = 0;

            foreach (int lineDeposit in creditDecision.depositAmount)
            {
                response.Deposit += lineDeposit;
            }
        }

        /// <summary>The inquire upgrade eligibility.</summary>
        /// <param name="mdn">The mdn.</param>
        /// <param name="referenceNumber">The reference number.</param>
        /// <returns>The <see cref="InquireUpgradeEligibilityResponseInfo"/>.</returns>
        private InquireUpgradeEligibilityResponseInfo InquireUpgradeEligibility(string mdn, string referenceNumber)
        {
            var attRequest = new InquireUpgradeEligibilityRequestInfo();
            InquireUpgradeEligibilityResponseInfo attResponse;
            var attService = new InquireUpgradeEligibilitySoapHttpBinding();

            attService.Url = this.GetUrl("InquireUpgradeEligibilityEndpoint");
            attService.MessageHeader = this.GetMessageHeader(referenceNumber);
            this.AddCerts(attService.ClientCertificates);

            attRequest.subscriberNumber = mdn;
            attRequest.UpgradeEligibility = new SecureUpgradeEligibilityInfo();
            attRequest.UpgradeEligibility.dealerCode = new DealerInfo();
            attRequest.UpgradeEligibility.dealerCode.code = this.GetAppSetting("DealerCode");
            attRequest.UpgradeEligibility.newSalesChannel = this.GetAppSetting("NewSalesChannel");

            try
            {
                new Log().LogRequest(new Utility().SerializeXML(attRequest), "Att", "InquireUpgradeEligibility", referenceNumber);

                attResponse = attService.InquireUpgradeEligibility(attRequest);

                new Log().LogResponse(new Utility().SerializeXML(attResponse), "Att", "InquireUpgradeEligibility", referenceNumber);
            }
            catch (Exception ex)
            {
                new Log().LogResponse(ex.Message, "Att", "InquireUpgradeEligibility", referenceNumber);

                attResponse = null;
            }

            return attResponse;
        }

        /// <summary>The map att port in response.</summary>
        /// <param name="MDNList">The mdn list.</param>
        /// <param name="attResponse">The att response.</param>
        /// <returns>The <see cref="ServiceResponseCode"/>.</returns>
        private ServiceResponseCode MapAttPortInResponse(
            List<MDNSet> MDNList, 
            InquirePortEligibilityResponseInfo attResponse)
        {
            ServiceResponseCode responseCode;

            // ValidatePortInResponse response = new ValidatePortInResponse();
            if (attResponse.PortEligibilityResponse == null || attResponse.PortEligibilityResponse.Length == 0)
            {
                responseCode = ServiceResponseCode.Failure;

                // response.ErrorCode = (int)ServiceResponseCode.Failure;
                // response.PrimaryErrorMessage = "No eligibility data returned";
            }
            else
            {
                foreach (MDNSet set in MDNList)
                {
                    set.IsPortable = false;
                }

                // response.MDNSet = new List<MDNSet>(attResponse.PortEligibilityResponse.Length);
                foreach (PortEligibilityResponseInfo detail in attResponse.PortEligibilityResponse)
                {
                    foreach (MDNSet set in MDNList)
                    {
                        if (set.MDN == detail.subscriberNumber)
                        {
                            set.IsPortable = detail.eligibilityFlag;
                            break;
                        }
                    }
                }

                responseCode = ServiceResponseCode.Success;
            }

            return responseCode;
        }

        /// <summary>The map line status.</summary>
        /// <param name="attStatus">The att status.</param>
        /// <returns>The <see cref="AccountStatusCode"/>.</returns>
        private AccountStatusCode MapLineStatus(SubscriberStatusInfo attStatus)
        {
            AccountStatusCode status;

            switch (attStatus)
            {
                case SubscriberStatusInfo.A:
                    status = AccountStatusCode.Operational;
                    break;
                case SubscriberStatusInfo.C:
                    status = AccountStatusCode.Cancelled;
                    break;
                case SubscriberStatusInfo.R:
                    status = AccountStatusCode.Tentative;
                    break;
                case SubscriberStatusInfo.S:
                    status = AccountStatusCode.Suspended;
                    break;
                default:
                    status = AccountStatusCode.Unknown;
                    break;
            }

            return status;
        }

        /// <summary>The map validation response.</summary>
        /// <param name="response">The response.</param>
        /// <param name="attResponse">The att response.</param>
        private void MapValidationResponse(AddressValidationResponse response, ValidateAddressResponseInfo attResponse)
        {
            if (attResponse == null || attResponse.Response == null)
            {
                response.ErrorCode = (int)ServiceResponseCode.Failure;
            }
            else
            {
                long responseCode = 0;
                long.TryParse(attResponse.Response.code, out responseCode);

                if (responseCode != 0)
                {
                    response.ErrorCode = (int)ServiceResponseCode.Failure;
                }
                else
                {
                    response.ErrorCode = (int)ServiceResponseCode.Success;
                }

                response.PrimaryErrorMessage = attResponse.Response.description;

                if (attResponse.isMatchedAddress && attResponse.AddressMatchResult != null
                    && attResponse.AddressMatchResult.Length == 1)
                {
                    AddressUnrestrictedInfo address = attResponse.AddressMatchResult[0].Address;
                    response.ValidAddress = new ExtendedAddress();

                    this.CopyAddress(response.ValidAddress, address);
                }
                else
                {
                    if (attResponse.AddressMatchResult != null && attResponse.AddressMatchResult.Length > 1)
                    {
                        var address = new ExtendedAddress[attResponse.AddressMatchResult.Length];
                        int i = 0;

                        foreach (AddressValidationResultInfo addressMatch in attResponse.AddressMatchResult)
                        {
                            address[i] = new ExtendedAddress();
                            this.CopyAddress(address[i], addressMatch.Address);
                            i++;
                        }

                        response.PossibleAddressMatch = address;
                    }
                }
            }
        }

        /// <summary>The submit upgrade order.</summary>
        /// <param name="wirelessOrder">The wireless order.</param>
        /// <returns>The <see cref="OrderActivationResponse"/>.</returns>
        private OrderActivationResponse SubmitUpgradeOrder(WirelessOrder wirelessOrder)
        {
            string lineErrors = string.Empty;

            var response = new OrderActivationResponse();

            foreach (WirelessLine line in wirelessOrder.WirelessLines)
            {
                try
                {
                    var dups = new InquireDuplicateOfferings(wirelessOrder, line);

                    var ue = new UpgradeEquipment(wirelessOrder, line, UpgradeEquipment.RequestType.Park);

                    var usp = new UpdateSubscriberProfile(wirelessOrder, line, dups);

                    line.ActivationStatus = ActivationStatus.Success;
                    line.Save();

                    wirelessOrder.ActivationStatus = (int)ActivationStatus.Success;
                    wirelessOrder.Save();
                }
                catch (Exception ex)
                {
                    lineErrors += line.CurrentMDN + " " + ex.Message + ":";
                }
            }

            if (lineErrors != string.Empty)
            {
                response.ErrorCode = (int)ServiceResponseCode.Failure;
                response.PrimaryErrorMessage = lineErrors;

                new Log().LogResponse(
                    new Utility().SerializeXML(response), 
                    "Att", 
                    "UpgradeActivation", 
                    wirelessOrder.CheckoutReferenceNumber);

                wirelessOrder.ActivationStatus = (int)ActivationStatus.Error;
                wirelessOrder.Save();
            }
            else
            {
                response.ErrorCode = (int)ServiceResponseCode.Success;

                new Log().LogResponse(
                    new Utility().SerializeXML(response), 
                    "Att", 
                    "UpgradeActivation", 
                    wirelessOrder.CheckoutReferenceNumber);
            }

            return response;
        }

        #endregion
    }
}