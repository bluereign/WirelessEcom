// --------------------------------------------------------------------------------------------------------------------
// <copyright file="CheckSocChangeEligibility.cs" company="">
//   
// </copyright>
// <summary>
//   The check soc change eligibility.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace TMobileCarrierServiceInterface.Implementation
{
    using System;
    using System.Collections.Generic;
    using System.Linq;

    using TMobileCarrierServiceInterface.Interfaces;
    using TMobileCarrierServiceInterface.Interfaces.Common;
    using TMobileCarrierServiceInterface.Interfaces.RateplanChange;

    using WirelessAdvocates;
    using WirelessAdvocates.Logger;
    using WirelessAdvocates.SalesOrder;

    /// <summary>The check soc change eligibility.</summary>
    public class CheckSocChangeEligibility
    {
        #region Fields

        /// <summary>The _reference number.</summary>
        private readonly string referenceNumber;

        /// <summary>The _service.</summary>
        private readonly RateplanChangeService service;

        /// <summary>The _wireless order.</summary>
        private readonly WirelessOrder wirelessOrder;

        /// <summary>The _added services.</summary>
        private List<ServiceChangeInfo> addedServices;

        /*
        /// <summary>The _call status.</summary>
        private ServiceStatus _callStatus;
*/

        /// <summary>The can submit.</summary>
        private bool? canSubmit = false;

        /// <summary>The deleted services.</summary>
        private List<ServiceChangeInfo> deletedServices;

        /// <summary>The last attempt.</summary>
        private bool lastAttempt;

        /// <summary>The rateplan matches.</summary>
        private bool? ratePlanMatches;

        /// <summary>The soc eligibility request.</summary>
        private CheckSocChangeEligibilityRequest socEligibilityRequest;

        /// <summary>The soc eligibility response.</summary>
        private CheckSocChangeEligibilityResponse socEligibilityResponse;

        #endregion

        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="CheckSocChangeEligibility"/> class.</summary>
        /// <param name="orderId">The order id.</param>
        /// <param name="msiSdn">The msi sdn.</param>
        public CheckSocChangeEligibility(int orderId, string msiSdn)
        {
            this.OrderId = orderId;
            this.MSIMDN = msiSdn;
            this.wirelessOrder = new WirelessOrder(Convert.ToInt32(orderId));
            this.referenceNumber = this.wirelessOrder.CheckoutReferenceNumber;
            this.service = new RateplanChangeService { Url = ServiceHelper.Instance.GetUrl("RatePlanChangeEndpoint") };
            ServiceHelper.Instance.AddCerts(this.service.ClientCertificates);
            this.service.RequestSoapContext.Security.Tokens.Add(ServiceHelper.Instance.GetUsernameToken());
            this.BAN = (new CheckoutSessionState()).GetByReference(this.wirelessOrder.CheckoutReferenceNumber, "BAN", "CustomerLookup");
            this.socEligibilityRequest = null;
            this.socEligibilityResponse = null;
            this.CheckEligibility();
        }

        #endregion

        #region Public Properties

        /// <summary>Gets the ban.</summary>
        public string BAN { get; private set; }

        /// <summary>Gets the msimdn.</summary>
        public string MSIMDN { get; private set; }

        /// <summary>Gets a value indicating whether nothing to activate.</summary>
        public bool NothingToActivate
        {
            get
            {
                return this.RatePlanToSubmit == null && this.ServicesToDelete == null && this.ServicesToAdd == null;
            }
        }

        /// <summary>Gets the order id.</summary>
        public int OrderId { get; private set; }

        /// <summary>Gets the rate plan to submit.</summary>
        public ServiceChangeInfo RatePlanToSubmit
        {
            get
            {
                if (this.socEligibilityRequest != null
                    && this.socEligibilityRequest.checkSocChangeEligibilityInfo != null)
                {
                    return this.socEligibilityRequest.checkSocChangeEligibilityInfo.ratePlan;
                }

                return null;
            }
        }

        /// <summary>Gets the services to add.</summary>
        public ServiceChangeInfo[] ServicesToAdd
        {
            get
            {
                if (this.addedServices != null && this.addedServices.Count > 0)
                {
                    return this.addedServices.ToArray();
                }

                return null;
            }
        }

        /// <summary>Gets the services to delete.</summary>
        public ServiceChangeInfo[] ServicesToDelete
        {
            get
            {
                if (this.deletedServices != null && this.deletedServices.Count > 0)
                {
                    return this.deletedServices.ToArray();
                }

                return null;
            }
        }

        #endregion

        #region Public Methods and Operators

        /// <summary>The log messages.</summary>
        public void LogMessages()
        {
            new Log().LogRequest(
                new Utility().SerializeXML(this.socEligibilityRequest), 
                "TMobile", 
                "SocUpgradeEligibility", 
                this.referenceNumber);
            new Log().LogResponse(
                new Utility().SerializeXML(this.socEligibilityResponse), 
                "TMobile", 
                "SocUpgradeEligibility", 
                this.referenceNumber);
        }

        /// <summary>The upgrade eligible.</summary>
        /// <returns>The <see cref="bool" />.</returns>
        public bool UpgradeEligible()
        {
            if (this.canSubmit != null)
            {
                return (bool)this.canSubmit;
            }

            if (this.socEligibilityResponse.serviceStatus != null
                && this.socEligibilityResponse.serviceStatus.serviceStatusCode == ServiceStatusEnum.Item100)
            {
                this.canSubmit = this.socEligibilityResponse.valid;
            }
            else
            {
                this.canSubmit = false;
            }

            return (bool)this.canSubmit;
        }

        #endregion

        #region Methods

        /// <summary>The check eligibility.</summary>
        private void CheckEligibility()
        {
            while (true)
            {
                if (this.socEligibilityRequest == null)
                {
                    this.socEligibilityRequest = new CheckSocChangeEligibilityRequest
                                                     {
                                                         checkSocChangeEligibilityInfo = new CheckSocChangeEligibilityInfo()
                                                     };

                    var line = this.wirelessOrder.GetWirelessLine(this.MSIMDN);

                    if (line.CarrierPlanId != null)
                    {
                        this.socEligibilityRequest.checkSocChangeEligibilityInfo.ratePlan = new ServiceChangeInfo();
                        this.socEligibilityRequest.checkSocChangeEligibilityInfo.ratePlan.effectiveDate = DateTime.Now;
                        this.socEligibilityRequest.checkSocChangeEligibilityInfo.ratePlan.service = line.CarrierPlanId;
                    }

                    this.socEligibilityRequest.checkSocChangeEligibilityInfo.msisdn = this.MSIMDN;
                    if (line.WirelessLineServices != null && line.WirelessLineServices.Length > 0)
                    {
                        this.addedServices = new List<ServiceChangeInfo>();
                        foreach (var svc in line.WirelessLineServices)
                        {
                            var newService = new ServiceChangeInfo
                                                 {
                                                     effectiveDate = DateTime.Now,
                                                     service = svc.CarrierServiceId
                                                 };
                            this.addedServices.Add(newService);
                        }

                        this.socEligibilityRequest.checkSocChangeEligibilityInfo.addedServices =
                            this.addedServices.ToArray();
                    }

                    this.socEligibilityRequest.header = ServiceHelper.Instance.GetHeader(this.referenceNumber);
                    this.socEligibilityRequest.checkSocChangeEligibilityInfo.ban = this.BAN;
                    if (this.NothingToActivate)
                    {
                        this.canSubmit = true;
                        return;
                    }

                    this.socEligibilityResponse = this.service.checkSocChangeEligibility(this.socEligibilityRequest);
                    this.LogMessages();

                    if (this.Validated())
                    {
                        this.canSubmit = true;
                    }
                    else
                    {
                        // If there is something to fix, do so and resubmit.
                        if (this.FixConflicts())
                        {
                            continue;
                        }
                    }
                }
                else
                {
                    if (this.addedServices != null && this.addedServices.Count > 0)
                    {
                        this.socEligibilityRequest.checkSocChangeEligibilityInfo.addedServices =
                            this.addedServices.ToArray();
                    }
                    else
                    {
                        this.socEligibilityRequest.checkSocChangeEligibilityInfo.addedServices = null;
                    }

                    if (this.deletedServices != null && this.deletedServices.Count > 0)
                    {
                        this.socEligibilityRequest.checkSocChangeEligibilityInfo.deletedServices =
                            this.deletedServices.ToArray();
                    }
                    else
                    {
                        this.socEligibilityRequest.checkSocChangeEligibilityInfo.deletedServices = null;
                    }

                    // If there is nothing to submit, we're good to go
                    if (this.socEligibilityRequest.checkSocChangeEligibilityInfo.addedServices == null
                        && this.socEligibilityRequest.checkSocChangeEligibilityInfo.deletedServices == null
                        && this.socEligibilityRequest.checkSocChangeEligibilityInfo.ratePlan == null)
                    {
                        this.canSubmit = true;
                    }
                    else
                    {
                        this.socEligibilityResponse = this.service.checkSocChangeEligibility(this.socEligibilityRequest);
                        this.LogMessages();
                    }

                    if (this.Validated())
                    {
                        this.canSubmit = true;
                    }
                    else
                    {
                        if (this.lastAttempt)
                        {
                            return;
                        }

                        // If rateplan conflict and services conflict then one last fix is attempted.
                        this.lastAttempt = true;
                        if (this.FixConflicts())
                        {
                            continue;
                        }
                    }
                }

                break;
            }
        }

        /// <summary>The delete existing service.</summary>
        /// <param name="soc">The soc.</param>
        private void DeleteExistingService(string soc)
        {
            if (this.deletedServices == null)
            {
                this.deletedServices = new List<ServiceChangeInfo>();
            }
            else
            {
                if (this.deletedServices.Any(svc => svc.service == soc))
                {
                    return; // Exit, we already have code in the deleted list
                }
            }

            var deletedService = new ServiceChangeInfo { effectiveDate = DateTime.Now, service = soc };
            this.deletedServices.Add(deletedService);
        }

        /// <summary>The fix conflicts.</summary>
        /// <returns>The <see cref="bool" />.</returns>
        private bool FixConflicts()
        {
            if (this.UnableToFix())
            {
                return false;
            }

            if (this.RateAlreadyExists())
            {
                this.socEligibilityRequest.checkSocChangeEligibilityInfo.ratePlan = null; // Don't send the rate plan
            }

            // <explanation> Service: RSMWEBC</explanation>
            if (this.socEligibilityResponse == null)
            {
                return true;
            }

            if (this.socEligibilityResponse.serviceStatus != null)
            {
                if (this.socEligibilityResponse.serviceStatus.serviceStatusCode == ServiceStatusEnum.Item102)
                {
                    foreach (var statusItem in this.socEligibilityResponse.serviceStatus.serviceStatusItem)
                    {
                        switch (statusItem.statusCode)
                        {
                            case "29021":
                                var split = statusItem.explanation.Split(':');
                                if (split.Length == 2)
                                {
                                    this.RemoveService(split[1].Trim());
                                }
                                else
                                {
                                    return false; // Unexpected format
                                }

                                break;
                        }
                    }
                }
            }

            if (this.socEligibilityResponse.checkSocChangeEligibilityOutput != null
                && this.socEligibilityResponse.checkSocChangeEligibilityOutput.Length > 0)
            {
                // Check the service code responses
                foreach (var output in this.socEligibilityResponse.checkSocChangeEligibilityOutput)
                {
                    this.HandleServiceConflict(output.baseService, output.relatedService, output.rejectType);
                }
            }

            return true;
        }

        /// <summary>The handle service conflict.</summary>
        /// <param name="baseService">The base service.</param>
        /// <param name="relatedService">The related service.</param>
        /// <param name="rejectType">The reject type.</param>
        /// <returns>The <see cref="bool"/>.</returns>
        private bool HandleServiceConflict(string baseService, string relatedService, string rejectType)
        {
            switch (rejectType)
            {
                case "4":
                    this.DeleteExistingService(baseService);
                    break;
                case "6":
                    this.DeleteExistingService(relatedService);
                    break;
             }

            return false;
        }

        /// <summary>The rate already exists.</summary>
        /// <returns>The <see cref="bool" />.</returns>
        private bool RateAlreadyExists()
        {
            if (this.ratePlanMatches != null)
            {
                return (bool)this.ratePlanMatches;
            }

            this.ratePlanMatches = false;
            if (this.socEligibilityResponse.serviceStatus == null)
            {
                return (bool)this.ratePlanMatches;
            }

            if (this.socEligibilityResponse.serviceStatus.serviceStatusCode == ServiceStatusEnum.Item102)
            {
                this.ratePlanMatches = ServiceHelper.Instance.FindErrorCode(this.socEligibilityResponse.serviceStatus.serviceStatusItem, "29014") != null;
            }

            return (bool)this.ratePlanMatches;
        }

        /// <summary>The remove service.</summary>
        /// <param name="soc">The soc.</param>
        private void RemoveService(string soc)
        {
            if (this.addedServices == null)
            {
                return;
            }

            ServiceChangeInfo serviceToRemove = null;
            foreach (var svc in this.addedServices)
            {
                if (svc.service == soc)
                {
                    serviceToRemove = svc;
                }
            }

            if (serviceToRemove != null)
            {
                this.addedServices.Remove(serviceToRemove);
            }
        }

        /// <summary>The unable to fix.</summary>
        /// <returns>The <see cref="bool" />.</returns>
        private bool UnableToFix()
        {
            if (this.socEligibilityResponse.serviceStatus == null
                || this.socEligibilityResponse.serviceStatus.serviceStatusItem == null
                || this.socEligibilityResponse.serviceStatus.serviceStatusCode != ServiceStatusEnum.Item102)
            {
                return false;
            }

            foreach (var statusItem in this.socEligibilityResponse.serviceStatus.serviceStatusItem)
            {
                switch (statusItem.statusCode)
                {
                    case "29014":
                    case "29021":
                        break;
                    default:
                        return true; // Not a code we're sure we can resolve
                }
            }

            // didn't find anything that is a hard stop
            return false;
        }

        /// <summary>The validated.</summary>
        /// <returns>The <see cref="bool" />.</returns>
        private bool Validated()
        {
            if (this.socEligibilityResponse == null || this.socEligibilityResponse.serviceStatus == null)
            {
                return false;
            }

            return this.socEligibilityResponse.serviceStatus.serviceStatusCode == ServiceStatusEnum.Item100
                   && ((this.socEligibilityResponse.allConflictsAutoResolved
                        && this.socEligibilityResponse.checkSocChangeEligibilityOutput == null
                        && this.socEligibilityResponse.valid == false) || this.socEligibilityResponse.valid);
        }

        #endregion
    }
}