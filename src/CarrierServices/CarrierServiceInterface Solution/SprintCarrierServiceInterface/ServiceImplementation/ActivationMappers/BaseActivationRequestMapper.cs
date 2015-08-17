// --------------------------------------------------------------------------------------------------------------------
// <copyright file="BaseActivationRequestMapper.cs" company="">
//   
// </copyright>
// <summary>
//   The base activation request mapper.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation.ActivationMappers
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Runtime.InteropServices;
    using System.Text;

    using SprintCSI.Properties;
    using SprintCSI.ServiceImplementation.DTO;
    using SprintCSI.Utils;

    using WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;

    using WirelessAdvocates.Enum;
    using WirelessAdvocates.Logger;
    using WirelessAdvocates.SalesOrder;

    using Address = WirelessAdvocates.SalesOrder.Address;
    using Name = WirelessAdvocates.Name;
    using NEW_REQUEST = SprintCSI.Request;
    using NEW_RESPONSE = SprintCSI.Response;
    using REQUEST = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;
    using RESPONSE = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.response;

    /// <summary>The base activation request mapper.</summary>
    [Guid("1D781AC8-D31F-4E02-83F5-62FBAC7AA6CD")]
    public abstract class BaseActivationRequestMapper
    {
        #region Constants

        /// <summary>The carrie r_ name.</summary>
        private const string CarrierName = "Sprint";

        #endregion

        #region Fields

        /// <summary>The xml helper.</summary>
        private readonly XmlHelper xmlHelper;

        #endregion

        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="BaseActivationRequestMapper"/> class.</summary>
        /// <param name="referenceNumber">The reference Number.</param>
        protected BaseActivationRequestMapper(string referenceNumber)
        {
            this.ReferenceNumber = referenceNumber;
            this.WirelessOrder = new ServiceAccessLayer.WirelessOrder();
            this.ServiceUrl = ConfigurationManager.AppSettings["Service-URL"];
            this.VendorCode = ConfigurationManager.AppSettings["Vendor-Code"];
            this.VendorPIN = ConfigurationManager.AppSettings["Vendor-PIN"];
            this.ServiceAgreement = Settings.Default.ServiceAgreement;
            this.xmlHelper = new XmlHelper();
        }

        #endregion

        #region Properties

        /// <summary>Gets the brand type.</summary>
        internal BrandType BrandType { get; private set; }

        /// <summary>Gets or sets the cust type.</summary>
        internal CustomerType CustType { get; set; }

        /// <summary>Gets or sets a value indicating whether is family plan.</summary>
        internal bool IsFamilyPlan { get; set; }

        /// <summary>Gets or sets the request.</summary>
        internal REQUEST.ActivationRequest OvmActivationRequest { get; set; }

        /// <summary>Gets or sets the reference number.</summary>
        internal string ReferenceNumber { get; set; }

        /// <summary>Gets the service agreement.</summary>
        internal byte ServiceAgreement { get; set; }

        /// <summary>Gets the service url.</summary>
        internal string ServiceUrl { get; private set; }

        /// <summary>Gets the vendor code.</summary>
        internal string VendorCode { get; private set; }

        /// <summary>Gets the vendor pin.</summary>
        internal string VendorPIN { get; private set; }

        /// <summary>Gets or sets the order.</summary>
        internal WirelessOrder WAWirelessOrder { get; set; }

        /// <summary>Gets the data access.</summary>
        internal ServiceAccessLayer.WirelessOrder WirelessOrder { get; private set; }

        /// <summary>Gets the order type.</summary>
        protected abstract OrderType OrderType { get; }

        #endregion

        #region Public Methods and Operators

        /// <summary>The map request.</summary>
        /// <param name="wirelessOrder">The order.</param>
        /// <returns>The <see cref="WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request.ActivationRequest"/>.</returns>
        public REQUEST.ActivationRequest MapRequest(WirelessOrder wirelessOrder)
        {
            this.WAWirelessOrder = wirelessOrder;
            this.OvmActivationRequest = new REQUEST.ActivationRequest();
            this.MapOrderInfo(this.OrderType);
            this.MapServiceInfo();
            return this.OvmActivationRequest;
        }

        /// <summary>The validate mapped request.</summary>
        /// <param name="order">The order.</param>
        /// <param name="req">The req.</param>
        public void ValidateMappedRequest(WirelessOrder order, REQUEST.ActivationRequest req)
        {
            // this.ValidatePlan(order);

            // this.ValidateService(order);

            // this.ValidateOptions(order);
        }

        #endregion

        #region Methods

        /// <summary>The map order info.</summary>
        /// <param name="orderType">The order type.</param>
        protected void MapOrderInfo(OrderType orderType)
        {
            this.OvmActivationRequest.order = new OrderInfoType { type = orderType };
            this.OvmActivationRequest.orderdate = this.WAWirelessOrder.CarrierOrderDate;
            this.OvmActivationRequest.orderdateSpecified = true;
            this.OvmActivationRequest.order.type = this.OrderType;
        }

        /// <summary>The map service info.</summary>
        protected void MapServiceInfo()
        {
            var service = new ServiceType();
            var plans = new List<Plan>();

            Address extAdd = this.WAWirelessOrder.BillAddress;

            string activateAfterDaysSetting = ConfigurationManager.AppSettings["ActivateAfterDays"];
            double activateAfterDays = double.Parse(activateAfterDaysSetting);

            int planCounter = 1;
            foreach (WirelessLine line in this.WAWirelessOrder.WirelessLines)
            {
                var plan = new Plan { id = planCounter.ToString(), code = line.CarrierPlanId, serviceagreement = this.ServiceAgreement, serviceagreementSpecified = true };

                // phone
                var phones = new List<Phone>();

                var phone = new Phone { id = plan.id };
                if (line.IMEI != null)
                {
                    phone.meid = line.IMEI;
                }

                var validateDeviceRequest = new ValidateDeviceRequest { Meid = phone.meid };
                SprintDeviceValidationResponse validateDeviceResponse = new ValidateDevice().Execute(validateDeviceRequest, this.ReferenceNumber);
                if (validateDeviceResponse.DeviceType != "E")
                {
                    if (validateDeviceResponse.ServiceResponseSubCodeEnum == ServiceResponseSubCode.ACT_UNKNOWN)
                    {
                        phone.iccid = validateDeviceResponse.IccId;
                    }
                    else
                    {
                        throw new ServiceException(validateDeviceResponse.PrimaryErrorMessageLong)
                                  {
                                      ErrorCode = validateDeviceResponse.ErrorCodeEnum, 
                                      ServiceResponseSubCode = validateDeviceResponse.ServiceResponseSubCodeEnum, 
                                  };
                    }
                }

                Name name = this.WirelessOrder.GetName(this.WAWirelessOrder.WirelessAccountId, this.WAWirelessOrder.OrderId);

                phone.unitusername = new REQUEST.Name { firstname = name.FirstName, middleinitial = name.MiddleInitial, lastname = name.LastName };
                phone.Item = this.CreateSprintAddress(extAdd);

                phones.Add(phone);

                var features = new List<Feature>();

                if (this.WAWirelessOrder.ActivationType == 'R')
                {
                    RESPONSE.AccountValidationResponse accountValidationResponse = SessionHelper.Instance.GetAccountValidationResponse(this.ReferenceNumber);

                    RESPONSE.AddOnOptionType[] serviceOptions = accountValidationResponse.accountinfo.subscriber[0].option;

                    features.AddRange(serviceOptions.Select(serviceOption => new Feature { featurecode = serviceOption.optioncode }));
                }
                else
                {
                    foreach (WirelessLineService serviceOption in line.WirelessLineServices)
                    {
                        if (line.GroupNumber == serviceOption.GroupNumber)
                        {
                            // WA's service is equivalent to sprint's feature
                            features.Add(new Feature { featurecode = serviceOption.CarrierServiceId });
                        }
                    }
                }

                plan.phone = phones.ToArray();
                plan.feature = features.ToArray();
                plan.Item2 = DateTime.Now.AddDays(activateAfterDays);

                if (this.WAWirelessOrder.ActivationType == 'U')
                {
                    // <reference-ptn> only required for Upgrade
                    plan.Item = line.CurrentMDN;
                    plan.ItemElementName = ItemChoiceType4.referenceptn;
                }

                plans.Add(plan);
                planCounter++;
            }

            service.Items = plans.ToArray();

            if (this.WAWirelessOrder.BillAddress != null && this.WAWirelessOrder.BillAddress.Contact != null && !string.IsNullOrEmpty(this.WAWirelessOrder.BillAddress.Contact.EveningPhone))
            {
                service.servicephonenumber = this.WAWirelessOrder.BillAddress.Contact.EveningPhone;
            }

            this.OvmActivationRequest.service = service;
        }

        /// <summary>The build options request.</summary>
        /// <param name="planId">The plan id.</param>
        /// <param name="serviceZip">The service zip.</param>
        /// <param name="meid">The meid.</param>
        /// <param name="numberSubscriberOnOrder">The number subscriber on order.</param>
        /// <param name="orderType">The order type.</param>
        /// <param name="customerType">The customer type.</param>
        /// <returns>The <see cref="OptionsRequest"/>.</returns>
        private OptionsRequest BuildOptionsRequest(string planId, string serviceZip, string meid, int numberSubscriberOnOrder, OrderType orderType, CustomerType customerType)
        {
            var valueList = new List<object>();
            var typeList = new List<ItemsChoiceType9>();

            valueList.Add(serviceZip);
            typeList.Add(ItemsChoiceType9.servicezip);
            valueList.Add(meid);
            typeList.Add(ItemsChoiceType9.meid);
            valueList.Add(numberSubscriberOnOrder.ToString());
            typeList.Add(ItemsChoiceType9.numsubscribers);
            valueList.Add(planId);
            typeList.Add(ItemsChoiceType9.planid);
            valueList.Add(orderType);
            typeList.Add(ItemsChoiceType9.ordertype);
            valueList.Add(customerType);
            typeList.Add(ItemsChoiceType9.customertype);

            var optionsRequest = new OptionsRequest { Items = valueList.ToArray(), ItemsElementName = typeList.ToArray() };
            return optionsRequest;
        }

        /// <summary>The build plans request.</summary>
        /// <param name="serviceZip">The service zip.</param>
        /// <param name="meid">The meid.</param>
        /// <param name="numberSubscriberOnOrder">The number subscriber on order.</param>
        /// <param name="orderType">The order type.</param>
        /// <param name="customerType">The customer type.</param>
        /// <param name="planType">The plan Type.</param>
        /// <returns>The <see cref="PlansRequest"/>.</returns>
        private PlansRequest BuildPlansRequest(string serviceZip, string meid, int numberSubscriberOnOrder, OrderType orderType, CustomerType customerType, PlanType planType)
        {
            var valueList = new List<object>();
            var typeList = new List<ItemsChoiceType10>();

            valueList.Add(serviceZip);
            typeList.Add(ItemsChoiceType10.servicezip);
            valueList.Add(meid);
            typeList.Add(ItemsChoiceType10.meid);
            valueList.Add(numberSubscriberOnOrder.ToString());
            typeList.Add(ItemsChoiceType10.numsubscribers);
            valueList.Add(orderType);
            typeList.Add(ItemsChoiceType10.ordertype);
            valueList.Add(planType);
            typeList.Add(ItemsChoiceType10.plantype);
            valueList.Add(customerType);
            typeList.Add(ItemsChoiceType10.customertype);

            var plansRequest = new PlansRequest { Items = valueList.ToArray(), ItemsElementName = typeList.ToArray() };
            return plansRequest;
        }

        /// <summary>The build service validate request.</summary>
        /// <param name="planId">The plan id.</param>
        /// <param name="planLstRank">The plan lst rank.</param>
        /// <param name="optionIds">The option ids.</param>
        /// <param name="serviceZip">The service zip.</param>
        /// <param name="meid">The meid.</param>
        /// <param name="orderType">The order type.</param>
        /// <param name="customerType">The customer type.</param>
        /// <returns>The <see cref="ServiceValidationRequest"/>.</returns>
        private ServiceValidationRequest BuildServiceValidateRequest(
            string planId, 
            string planLstRank, 
            IEnumerable<string> optionIds, 
            string serviceZip, 
            string meid, 
            OrderType orderType, 
            CustomerType customerType)
        {
            var serviceValidationRequest = new ServiceValidationRequest();

            var items = new List<object> { customerType };
            serviceValidationRequest.Items = items.ToArray();

            serviceValidationRequest.Item = serviceZip;
            serviceValidationRequest.ItemElementName = ItemChoiceType11.servicezip;

            serviceValidationRequest.action = new ServiceValidationActionType();
            switch (orderType)
            {
                case OrderType.NEW:
                    serviceValidationRequest.action.actiontype = ActionType.CREATE;
                    break;
                default:
                    serviceValidationRequest.action.actiontype = ActionType.UPDATE;
                    if (orderType == OrderType.ADD_ON)
                    {
                        serviceValidationRequest.action.serviceadd = true;
                    }

                    break;
            }

            serviceValidationRequest.planoptions = new ServicePlanOptionsType { planid = planId, ltsrank = planLstRank };

            var options = new List<ServiceOptionsType>();
            int optCtr = 1;
            foreach (string optId in optionIds)
            {
                var opt = new ServiceOptionsType { optionsid = optId, ltsrank = optCtr.ToString() };
                options.Add(opt);
                optCtr++;
            }

            serviceValidationRequest.planoptions.options = options.ToArray();

            serviceValidationRequest.Item1 = meid;
            serviceValidationRequest.Item1ElementName = Item1ChoiceType2.meid;
            return serviceValidationRequest;
        }

        /// <summary>The create sprint address.</summary>
        /// <param name="waAddress">The wa address.</param>
        /// <returns>The <see cref="WirelessAdvocates.SalesOrder.Address"/>.</returns>
        private REQUEST.Address CreateSprintAddress(Address waAddress)
        {
            var address = new REQUEST.Address();
            var addressItems = new List<string>();
            var addressItemTypes = new List<ItemsChoiceType1>();
            addressItems.Add(waAddress.AddressLine1);
            addressItems.Add(waAddress.AddressLine2);
            addressItems.Add(waAddress.City);
            addressItems.Add(waAddress.State);
            addressItems.Add(waAddress.ZipCode);
            addressItemTypes.Add(ItemsChoiceType1.streetaddress1);
            addressItemTypes.Add(ItemsChoiceType1.streetaddress2);
            addressItemTypes.Add(ItemsChoiceType1.city);
            addressItemTypes.Add(ItemsChoiceType1.statecode);
            addressItemTypes.Add(ItemsChoiceType1.zipcode);
            address.Items = addressItems.ToArray();
            address.ItemsElementName = addressItemTypes.ToArray();
            return address;
        }

        /// <summary>The execute validate options.</summary>
        /// <param name="planCode">The plan code.</param>
        /// <param name="serviceZip">The service zip.</param>
        /// <param name="meid">The meid.</param>
        /// <param name="numSubsOnOrder">The num subs on order.</param>
        /// <param name="refNum">The ref num.</param>
        /// <returns>The <see cref="WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.response.ovm"/>.</returns>
        private NEW_RESPONSE.ovm ExecuteValidateOptions(string planCode, string serviceZip, string meid, int numSubsOnOrder, string refNum)
        {
            OptionsRequest optionsRequest = this.BuildOptionsRequest(planCode, serviceZip, meid, numSubsOnOrder, this.OrderType, this.CustType);

            var sprintRequest = new ovm
                                    {
                                        ovmheader = new RequestMessageHeader { pin = this.VendorPIN, vendorcode = this.VendorCode, orderid = refNum, timestamp = DateTime.Now }, 
                                        ovmrequest = new ovmOvmrequest()
                                    };

            sprintRequest.ovmheader.messagetype = RequestMessageType.OPTIONS_REQUEST;
            sprintRequest.ovmrequest.ItemElementName = ItemChoiceType19.optionsrequest;
            sprintRequest.ovmrequest.Item = optionsRequest;

            string requestXml = this.xmlHelper.GenerateXml(sprintRequest);
            new Log().LogRequest(requestXml, CarrierName, "OptionsRequest", refNum);
            var requestHelper = new RequestHelper { RefNum = this.ReferenceNumber, CarrierName = CarrierName };
            string responseXml = requestHelper.SubmitRequest(requestXml, this.ServiceUrl);
            new Log().LogResponse(responseXml, CarrierName, "OptionsRequest", refNum);

            return (NEW_RESPONSE.ovm)this.xmlHelper.DeserializeOvmXMLResponse(responseXml);
        }

        /// <summary>The validate options.</summary>
        /// <param name="order">The order.</param>
        /// <exception cref="ServiceException"></exception>
        private void ValidateOptions(WirelessOrder order)
        {
            foreach (WirelessLine line in order.WirelessLines)
            {
                string planCode = line.CarrierPlanId;
                string serviceZip = order.BillAddress.ZipCode;
                string meid = line.IMEI;
                const int NumberSubscriberOnOrder = 1;

                NEW_RESPONSE.ovm obj = this.ExecuteValidateOptions(planCode, serviceZip, meid, NumberSubscriberOnOrder, this.ReferenceNumber);

                // validate that the specified options are supported by the specified plan
                if (obj == null)
                {
                    continue;
                }

                var optionsResponse = obj.ovmresponse.Item as RESPONSE.OptionsResponse;
                if (!optionsResponse.planoptions.Any())
                {
                    throw new ServiceException("Invalid options specified.") { ErrorCode = ServiceResponseCode.Success, ServiceResponseSubCode = ServiceResponseSubCode.ACT_FAIL, };
                }

                IEnumerable<string> options = from o in optionsResponse.planoptions[0].option select o.optioncode;

                IEnumerable<string> query = from s in line.WirelessLineServices select s.CarrierServiceId;
                List<string> serviceOptions = query.ToList();

                foreach (string option in serviceOptions)
                {
                    string option1 = option;
                    string result = (from o in options.ToList() where o == option1 select o).FirstOrDefault();
                    if (result != null)
                    {
                        continue;
                    }

                    var sb = new StringBuilder();
                    foreach (string item in options.ToList())
                    {
                        sb.Append(item);
                        sb.Append(" ,");
                    }

                    string optionLists = sb.ToString().Trim(new[] { ',' });

                    string msg = string.Format("{0} is not a supported option.  Supported options are: {1}", option, optionLists);

                    throw new ServiceException(msg) { ErrorCode = ServiceResponseCode.Success, ServiceResponseSubCode = ServiceResponseSubCode.ACT_FAIL };
                }
            }
        }

        /// <summary>The validate plan.</summary>
        /// <param name="order">The order.</param>
        /// <exception cref="ServiceException"></exception>
        private void ValidatePlan(WirelessOrder order)
        {
            NEW_RESPONSE.PlanType planType = this.IsFamilyPlan ? NEW_RESPONSE.PlanType.fam : NEW_RESPONSE.PlanType.ind;

            foreach (WirelessLine line in order.WirelessLines)
            {
                string planCode = line.CarrierPlanId;
                string serviceZip = order.BillAddress.ZipCode;
                string meid = line.IMEI;

                const int NumberSubscriberOnOrder = 1;
                CustomerType customerType = this.CustType;

                PlansRequest plansRequest = this.BuildPlansRequest(serviceZip, meid, NumberSubscriberOnOrder, this.OrderType, customerType, (PlanType)planType);

                // map incoming WA request into sprint request
                var sprintRequest = new ovm();
                sprintRequest.ovmheader = new RequestMessageHeader
                                              {
                                                  pin = this.VendorPIN, 
                                                  vendorcode = this.VendorCode, 
                                                  orderid = this.ReferenceNumber, 
                                                  brandtype = BrandType.SP, 
                                                  brandtypeSpecified = true, 
                                                  timestamp = DateTime.Now
                                              };
                sprintRequest.ovmrequest = new ovmOvmrequest();

                sprintRequest.ovmheader.messagetype = RequestMessageType.PLANS_REQUEST;
                sprintRequest.ovmrequest.ItemElementName = ItemChoiceType19.plansrequest;
                sprintRequest.ovmrequest.Item = plansRequest;

                string requestXml = this.xmlHelper.GenerateXml(sprintRequest);
                new Log().LogRequest(requestXml, CarrierName, "PlansRequest", this.ReferenceNumber);
                var requestHelper = new RequestHelper { RefNum = this.ReferenceNumber, CarrierName = CarrierName };
                string responseXml = requestHelper.SubmitRequest(requestXml, this.ServiceUrl);
                new Log().LogResponse(responseXml, CarrierName, "PlansRequest", this.ReferenceNumber);
                var obj = (NEW_RESPONSE.ovm)this.xmlHelper.DeserializeOvmXMLResponse(responseXml);

                // validate the specified planCode against the supported plans for this IMEI
                if (obj == null)
                {
                    continue;
                }

                var plansResponse = obj.ovmresponse.Item as NEW_RESPONSE.PlansResponse;

                if (plansResponse != null)
                {
                    IEnumerable<NEW_RESPONSE.PricePlanType> query = from p in plansResponse.priceplan where (p.planid == planCode) && (p.plantype == planType) select p;

                    if (query.FirstOrDefault() == null)
                    {
                        throw new ServiceException("Invalid plan specified.") { ErrorCode = ServiceResponseCode.Success, ServiceResponseSubCode = ServiceResponseSubCode.ACT_FAIL, };
                    }
                }
            }
        }

        /// <summary>The validate service.</summary>
        /// <param name="order">The order.</param>
        /// <exception cref="ServiceException"></exception>
        private void ValidateService(WirelessOrder order)
        {
            int planCtr = 1;
            foreach (WirelessLine line in order.WirelessLines)
            {
                List<string> serviceOptions = (from s in line.WirelessLineServices select s.CarrierServiceId).ToList();

                string planCode = line.CarrierPlanId;
                string serviceZip = order.BillAddress.ZipCode;
                string meid = line.IMEI;
                CustomerType customerType = this.CustType;
                ServiceValidationRequest serviceValidationRequest = this.BuildServiceValidateRequest(
                    line.CarrierPlanId, 
                    planCtr.ToString(), 
                    serviceOptions, 
                    serviceZip, 
                    meid, 
                    this.OrderType, 
                    customerType);

                var sprintRequest = new ovm
                                        {
                                            ovmheader = new RequestMessageHeader { pin = this.VendorPIN, vendorcode = this.VendorCode, orderid = this.ReferenceNumber, timestamp = DateTime.Now }, 
                                            ovmrequest = new ovmOvmrequest()
                                        };

                sprintRequest.ovmheader.messagetype = RequestMessageType.SERVICE_VALIDATION_REQUEST;
                sprintRequest.ovmrequest.ItemElementName = ItemChoiceType19.servicevalidationrequest;
                sprintRequest.ovmrequest.Item = serviceValidationRequest;

                string requestXml = this.xmlHelper.GenerateXml(sprintRequest);
                new Log().LogRequest(requestXml, CarrierName, "ServiceValidationRequest", this.ReferenceNumber);
                var requestHelper = new RequestHelper { RefNum = this.ReferenceNumber, CarrierName = CarrierName };
                string responseXml = requestHelper.SubmitRequest(requestXml, this.ServiceUrl);
                new Log().LogResponse(responseXml, CarrierName, "ServiceValidationRequest", this.ReferenceNumber);

                var obj = (NEW_RESPONSE.ovm)this.xmlHelper.DeserializeOvmXMLResponse(responseXml);

                // validate that the specified options are supported by the specified plan
                var resp = obj.ovmresponse.Item as RESPONSE.ServiceValidationResponse;
                if (resp == null || !resp.validationsucceeded)
                {
                    throw new ServiceException("Service Validation failed.") { ErrorCode = ServiceResponseCode.Success, ServiceResponseSubCode = ServiceResponseSubCode.ACT_FAIL, };
                }

                planCtr++;
            }
        }

        #endregion
    }
}