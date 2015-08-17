// --------------------------------------------------------------------------------------------------------------------
// <copyright file="OvmBase.cs" company="">
//   
// </copyright>
// <summary>
//   The base impl.
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace SprintCSI.ServiceImplementation
{
    using System;
    using System.Configuration;
    using System.Diagnostics;
    using System.Runtime.CompilerServices;

    using SprintCSI.Utils;

    using SWGData;

    using WirelessAdvocates;
    using WirelessAdvocates.Enum;
    using WirelessAdvocates.Logger;

    using NEW_REQUEST = SprintCSI.Request;
    using NEW_RESPONSE = SprintCSI.Response;
    using REQUEST = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.request;
    using RESPONSE = WirelessAdvocate.CarrierServices.Proxies.Sprint.ovm.response;

    /// <summary>The ovm base.</summary>
    /// <typeparam name="TWaRequest"></typeparam>
    /// <typeparam name="TWaResponse"></typeparam>
    public abstract class OvmBase<TWaRequest, TWaResponse>
    {
        #region Constants

        /// <summary>The carrie r_ name.</summary>
        private const string CarrierName = "Sprint";

        #endregion

        #region Constructors and Destructors

        /// <summary>Initializes a new instance of the <see cref="OvmBase{TWaRequest,TWaResponse}" /> class.</summary>
        protected OvmBase()
        {
            this.ServiceUrl = ConfigurationManager.AppSettings["Service-URL"];
            this.VendorCode = ConfigurationManager.AppSettings["Vendor-Code"];
            this.VendorPin = ConfigurationManager.AppSettings["Vendor-PIN"];
            this.ApplicationId = ConfigurationManager.AppSettings["Application-Id"];
            this.ApplicationUserId = ConfigurationManager.AppSettings["Application-UserId"];
            this.CustType = REQUEST.CustomerType.INDIVIDUAL;
            this.NewCustType = NEW_REQUEST.CustomerType.INDIVIDUAL;
            this.TestReferenceBase = ConfigurationManager.AppSettings["Test-Reference"];
            this.RequestXmlHelper = new XmlHelper();
            this.ResponseXmlHelper = new XmlHelper();
        }

        #endregion

        #region Public Properties

        /// <summary>Gets the application id.</summary>
        public string ApplicationId { get; private set; }

        /// <summary>Gets the application user id.</summary>
        public string ApplicationUserId { get; private set; }

        /// <summary>Gets the cust type.</summary>
        public REQUEST.CustomerType CustType { get; private set; }

        /// <summary>Gets the cust type.</summary>
        public NEW_REQUEST.CustomerType NewCustType { get; private set; }

        /// <summary>Gets or sets the parse response.</summary>
        public RESPONSE.ParseResponse ParseResponse { get; set; }

        /// <summary>Gets the reference number.</summary>
        public string ReferenceNumber { get; private set; }

        /// <summary>Gets the xml helper.</summary>
        public XmlHelper RequestXmlHelper { get; private set; }

        /// <summary>Gets the xml helper.</summary>
        public XmlHelper ResponseXmlHelper { get; private set; }

        /// <summary>Gets the service url.</summary>
        public string ServiceUrl { get; private set; }

        /// <summary>Gets or sets the test reference base.</summary>
        public string TestReferenceBase { get; set; }

        /// <summary>Gets the vendor code.</summary>
        public string VendorCode { get; private set; }

        /// <summary>Gets the vendor pin.</summary>
        public string VendorPin { get; private set; }

        #endregion

        #region Public Methods and Operators

        /// <summary>The execute.</summary>
        /// <param name="req">The req.</param>
        /// <param name="refNum">The ref num.</param>
        /// <returns>The <see cref="TWaResponse"/>.</returns>
        /// <exception cref="Exception"></exception>
        public TWaResponse Execute(TWaRequest req, string refNum)
        {
            this.ReferenceNumber = refNum;
            return this.WaResponse(req, refNum);
        }

        /// <summary>The get response.</summary>
        /// <returns>The <see cref="TWaResponse" />.</returns>
        public abstract TWaResponse GetResponse();

        /// <summary>The map error code.</summary>
        /// <param name="ovmResponse">The ovm response.</param>
        public virtual void MapErrorCode(RESPONSE.ovm ovmResponse)
        {
            // Does nothing if the concrete class does not implement this method
            Trace.WriteLine("ALERT: Empty Base.MapErrorCode called");
        }

        /// <summary>The map request.</summary>
        /// <param name="req">The req.</param>
        /// <param name="sprintRequest">The sprint request.</param>
        public virtual void MapRequest(TWaRequest req, ref REQUEST.ovm sprintRequest)
        {
            // Does nothing if the concrete class does not implement this method
            Trace.WriteLine("ALERT: Empty Base.MapRequest called");
        }

        /// <summary>The map response.</summary>
        /// <param name="ovmresponseType">The ovmresponse type.</param>
        /// <returns>The <see cref="TWaResponse"/>.</returns>
        public virtual TWaResponse MapResponse(RESPONSE.OvmResponseType ovmresponseType)
        {
            throw new NotImplementedException("Called Deprecated MapResponse");
        }

        /// <summary>The map error code.</summary>
        /// <param name="ovmResponse">The ovm response.</param>
        public virtual void NewMapErrorCode(NEW_RESPONSE.ovm ovmResponse)
        {
            // Does nothing if the concrete class does not implement this method
            Trace.WriteLine("ALERT: Empty Base.NewMapErrorCode called");
        }

        /// <summary>The map request.</summary>
        /// <param name="req">The req.</param>
        /// <param name="sprintRequest">The sprint request.</param>
        public virtual void NewMapRequest(TWaRequest req, ref NEW_REQUEST.ovm sprintRequest)
        {
            // Does nothing if the concrete class does not implement this method
            Trace.WriteLine("ALERT: Empty Base.NewMapRequest called");
        }

        /// <summary>The map response.</summary>
        /// <param name="ovmresponseType">The ovmresponse type.</param>
        /// <returns>The <see cref="TWaResponse"/>.</returns>
        public abstract TWaResponse NewMapResponse(NEW_RESPONSE.OvmResponseType ovmresponseType);

        /// <summary>The set error obj.</summary>
        /// <param name="errorCode">The error code.</param>
        /// <param name="subErrorCode">The sub error code.</param>
        /// <param name="primaryErrorMessage">The primary error message.</param>
        /// <param name="errorInfo">The error Info</param>
        /// <returns>The <see cref="TWaResponse"/>.</returns>
        public abstract TWaResponse NewSetErrorObj(ServiceResponseCode errorCode, ServiceResponseSubCode subErrorCode, string primaryErrorMessage, NEW_RESPONSE.ErrorInfo[] errorInfo = null);

        /// <summary>The set error obj.</summary>
        /// <param name="errorCode">The error code.</param>
        /// <param name="subErrorCode">The sub error code.</param>
        /// <param name="primaryErrorMessage">The primary error message.</param>
        /// <param name="errorInfo">The error Info</param>
        /// <returns>The <see cref="TWaResponse"/>.</returns>
        public virtual TWaResponse SetErrorObj(ServiceResponseCode errorCode, ServiceResponseSubCode subErrorCode, string primaryErrorMessage, RESPONSE.ErrorInfo[] errorInfo = null)
        {
            throw new NotImplementedException("Called Deprecated SetErrorObj");
        }

        #endregion

        #region Methods

        /// <summary>The add random value.</summary>
        /// <param name="reference">The reference.</param>
        /// <returns>The <see cref="string"/>.</returns>
        protected string AddRandomValue(string reference)
        {
            Trace.WriteLine("\n************* Randomizing the Reference number\n");
            string randomizedOrderId = reference + (new Random()).Next(100000, 999999);
            return randomizedOrderId.Length > 23 ? randomizedOrderId.Substring(0, 23) : randomizedOrderId;
        }

        /// <summary>The get sprint response advice.</summary>
        /// <param name="sprintErrorCodeInfo">The sprint error code.</param>
        /// <returns>The <see cref="string"/>.</returns>
        protected string GetSprintResponseAdvice(RESPONSE.ErrorInfo[] sprintErrorCodeInfo)
        {
            if (sprintErrorCodeInfo == null)
            {
                return string.Empty;
            }

            var errorRepository = new Repository();
            string key = string.Format("{0}-{1}-{2}", sprintErrorCodeInfo[0].errorcode, sprintErrorCodeInfo[0].errortype, sprintErrorCodeInfo[0].errorsubname);
            SWGErrorHandle.Activation sprintResponseAdvice = errorRepository.Get(key);
            return sprintResponseAdvice != null ? string.Format("{0}  {1}  {2}", sprintResponseAdvice.Description, sprintResponseAdvice.Scenario, sprintResponseAdvice.Resolution) : string.Empty;
        }

        /// <summary>The get sprint response advice.</summary>
        /// <param name="sprintErrorCodeInfo">The sprint error code.</param>
        /// <returns>The <see cref="string"/>.</returns>
        protected string GetSprintResponseAdvice(NEW_RESPONSE.ErrorInfo[] sprintErrorCodeInfo)
        {
            if (sprintErrorCodeInfo == null)
            {
                return string.Empty;
            }

            var errorRepository = new Repository();
            string key = string.Format("{0}-{1}-{2}", sprintErrorCodeInfo[0].errorcode, sprintErrorCodeInfo[0].errortype, sprintErrorCodeInfo[0].errorsubname);
            SWGErrorHandle.Activation sprintResponseAdvice = errorRepository.Get(key);
            return sprintResponseAdvice != null ? string.Format("{0}  {1}  {2}", sprintResponseAdvice.Description, sprintResponseAdvice.Scenario, sprintResponseAdvice.Resolution) : string.Empty;
        }

        /// <summary>The handle invalid cast.</summary>
        /// <param name="ovmresponseType">The ovmresponse type.</param>
        /// <param name="caller">The caller.</param>
        /// <param name="sourceLineNumber">The source line number.</param>
        protected virtual void HandleInvalidCast(RESPONSE.OvmResponseType ovmresponseType, [CallerMemberName] string caller = null, [CallerLineNumber] int sourceLineNumber = 0)
        {
            throw new NotImplementedException("HandleInvalidCast called by " + caller + "at " + sourceLineNumber);
        }

        /// <summary>The handle invalid cast.</summary>
        /// <param name="ovmresponseType">The ovmresponse type.</param>
        /// <param name="caller">The caller.</param>
        /// <param name="sourceLineNumber">The source line number.</param>
        protected virtual void NewHandleInvalidCast(NEW_RESPONSE.OvmResponseType ovmresponseType, [CallerMemberName] string caller = null, [CallerLineNumber] int sourceLineNumber = 0)
        {
            throw new NotImplementedException("NewHandleInvalidCast called by " + caller + "at " + sourceLineNumber);
        }

        /// <summary>The validate request.</summary>
        /// <param name="request">The request.</param>
        /// <param name="caller">The caller.</param>
        /// <param name="sourceLineNumber">The source line number.</param>
        protected virtual void ValidateRequest(TWaRequest request, [CallerMemberName] string caller = null, [CallerLineNumber] int sourceLineNumber = 0)
        {
            // Does nothing if the concrete class does not implement this method
            Trace.WriteLine("ALERT: Empty Base.ValidateRequest called");
        }

        /// <summary>The validate response.</summary>
        /// <param name="response">The response.</param>
        /// <returns>The <see cref="TWaResponse"/>.</returns>
        protected virtual TWaResponse ValidateResponse(TWaResponse response)
        {
            // Does nothing if the concrete class does not implement this method
            Trace.WriteLine("ALERT: Empty Base.ValidateResponse called");
            return response;
        }

        /// <summary>The wa response.</summary>
        /// <param name="req">The req.</param>
        /// <param name="refNum">The ref num.</param>
        /// <returns>The <see cref="TWaResponse"/>.</returns>
        /// <exception cref="Exception"></exception>
        private TWaResponse WaResponse(TWaRequest req, string refNum)
        {
            string requestXml = string.Empty;
            string responseXml = string.Empty;

            try
            {
                this.ValidateRequest(req);

                // map incoming WA request into sprint request
                var sprintRequest = new REQUEST.ovm();
                sprintRequest.ovmheader = new REQUEST.RequestMessageHeader
                                              {
                                                  pin = this.VendorPin, 
                                                  vendorcode = this.VendorCode, 
                                                  brandtype = REQUEST.BrandType.SP, 
                                                  brandtypeSpecified = true, 
                                                  timestamp = DateTime.Now
                                              };
                sprintRequest.ovmrequest = new REQUEST.ovmOvmrequest();

                // NOTE [pcrawford,20140106] Per Sprint: ActivateReservedDevice orderid must be unique - munging orderid there....
                sprintRequest.ovmheader.orderid = refNum;

                this.MapRequest(req, ref sprintRequest);

                // convert the request into XML & submit it as payload
                requestXml = this.RequestXmlHelper.GenerateXml(sprintRequest);

                // log the request
                new Log().LogRequest(requestXml, CarrierName, this.GetType().Name, refNum);

                // service call
                var requestHelper = new RequestHelper { RefNum = this.ReferenceNumber, CarrierName = CarrierName };
                responseXml = requestHelper.SubmitRequest(requestXml, this.ServiceUrl);

                if (responseXml.Trim() == string.Empty)
                {
                    throw new Exception("No response returned from the carrier");
                }

                this.ResponseXmlHelper = new XmlHelper { XmlString = responseXml, CarrierName = CarrierName, RefNum = refNum, TypeName = this.GetType().Name };

                // log the response
                new Log().LogResponse(responseXml, CarrierName, this.GetType().Name, refNum);

                // deserialized the XML into an RESPONSE.ovm object
                var obj = (NEW_RESPONSE.ovm)this.ResponseXmlHelper.DeserializeOvmXMLResponse(responseXml);

                if (obj == null)
                {
                    // Take this exit only when Deserialize fails 
                    // new Log().LogException("Deserialization Failed for" + responseXml, CarrierName, this.GetType().Name, refNum);
                    return this.GetResponse();
                }

                // no errors found, map the response
                TWaResponse mappedResponse = this.NewMapResponse(obj.ovmresponse);

                // serialize wa response.
                new Log().LogOutput(new Utility().SerializeXML(mappedResponse), CarrierName, this.GetType().Name, refNum);

                new CheckoutSessionState().Add(refNum, obj.ovmresponse.GetType().Name, this.GetType().Name, responseXml);
                new CheckoutSessionState().Add(refNum, mappedResponse.GetType().Name, this.GetType().Name, mappedResponse);

                // assert for errors
                this.NewMapErrorCode(obj);

                // validate the response
                return this.ValidateResponse(mappedResponse);
            }
            catch (ServiceException ex)
            {
                string msg = string.Format(
                    "STATUS: {0}, CAUSE: {1}, MSG: {2}", 
                    ex.ErrorCode, 
                    ex.ServiceResponseSubCode, 
                    ex.NewErrorInfo != null ? string.Format("{0}: {1}", ex.Message, ex.NewErrorInfo[0].errordetails) : ex.Message);

                new Log().LogException(msg, CarrierName, this.GetType().Name, refNum);

                return this.NewSetErrorObj(ex.ErrorCode, ex.ServiceResponseSubCode, msg, ex.NewErrorInfo);
            }
            catch (Exception ex)
            {
                new Log().LogRequest(requestXml, CarrierName, this.GetType().Name, refNum);
                new Log().LogResponse(responseXml, CarrierName, this.GetType().Name, refNum);
                new Log().LogException(ex.Message, CarrierName, this.GetType().Name, refNum);

                return this.NewSetErrorObj(ServiceResponseCode.Success, ServiceResponseSubCode.CCError, ex.Message);
            }
        }

        #endregion
    }
}