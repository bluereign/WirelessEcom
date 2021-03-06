﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.239
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace TMobileCarrierServiceInterface.Interfaces.AddressVerification
{
    using System;
    using System.ComponentModel;
    using System.Diagnostics;
    using System.Web.Services;
    using System.Web.Services.Protocols;
    using System.Xml.Serialization;
    using TMobileCarrierServiceInterface.Interfaces.Common;
    // 
    // This source code was auto-generated by wsdl, Version=4.0.30319.1.
    // 


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Web.Services.WebServiceBindingAttribute(Name = "AddressVerificationServiceSOAPBinding", Namespace = "http://retail.tmobile.com/service")]
    [System.Xml.Serialization.XmlIncludeAttribute(typeof(RspRequest))]
    public partial class AddressVerificationService : Microsoft.Web.Services2.WebServicesClientProtocol
    {

        private System.Threading.SendOrPostCallback verifyE911AddressOperationCompleted;

        private System.Threading.SendOrPostCallback verifyAddressOperationCompleted;

        private System.Threading.SendOrPostCallback validateAndClassifyAddressOperationCompleted;

        /// <remarks/>
        public AddressVerificationService()
        {
            this.Url = "http://localhost:7001/eProxy/service/AddressVerificationService_SOAP_V1";
        }

        /// <remarks/>
        public event verifyE911AddressCompletedEventHandler verifyE911AddressCompleted;

        /// <remarks/>
        public event verifyAddressCompletedEventHandler verifyAddressCompleted;

        /// <remarks/>
        public event validateAndClassifyAddressCompletedEventHandler validateAndClassifyAddressCompleted;

        /// <remarks/>
        [System.Web.Services.Protocols.SoapDocumentMethodAttribute("verifyE911Address", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Bare)]
        [return: System.Xml.Serialization.XmlElementAttribute("addressVerificationResponse", Namespace = "http://retail.tmobile.com/sdo")]
        public AddressVerificationResponse verifyE911Address([System.Xml.Serialization.XmlElementAttribute(Namespace = "http://retail.tmobile.com/sdo")] AddressVerificationForE911Request addressVerificationForE911Request)
        {
            object[] results = this.Invoke("verifyE911Address", new object[] {
                    addressVerificationForE911Request});
            return ((AddressVerificationResponse)(results[0]));
        }

        /// <remarks/>
        public System.IAsyncResult BeginverifyE911Address(AddressVerificationForE911Request addressVerificationForE911Request, System.AsyncCallback callback, object asyncState)
        {
            return this.BeginInvoke("verifyE911Address", new object[] {
                    addressVerificationForE911Request}, callback, asyncState);
        }

        /// <remarks/>
        public AddressVerificationResponse EndverifyE911Address(System.IAsyncResult asyncResult)
        {
            object[] results = this.EndInvoke(asyncResult);
            return ((AddressVerificationResponse)(results[0]));
        }

        /// <remarks/>
        public void verifyE911AddressAsync(AddressVerificationForE911Request addressVerificationForE911Request)
        {
            this.verifyE911AddressAsync(addressVerificationForE911Request, null);
        }

        /// <remarks/>
        public void verifyE911AddressAsync(AddressVerificationForE911Request addressVerificationForE911Request, object userState)
        {
            if ((this.verifyE911AddressOperationCompleted == null))
            {
                this.verifyE911AddressOperationCompleted = new System.Threading.SendOrPostCallback(this.OnverifyE911AddressOperationCompleted);
            }
            this.InvokeAsync("verifyE911Address", new object[] {
                    addressVerificationForE911Request}, this.verifyE911AddressOperationCompleted, userState);
        }

        private void OnverifyE911AddressOperationCompleted(object arg)
        {
            if ((this.verifyE911AddressCompleted != null))
            {
                System.Web.Services.Protocols.InvokeCompletedEventArgs invokeArgs = ((System.Web.Services.Protocols.InvokeCompletedEventArgs)(arg));
                this.verifyE911AddressCompleted(this, new verifyE911AddressCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState));
            }
        }

        /// <remarks/>
        [System.Web.Services.Protocols.SoapDocumentMethodAttribute("verifyAddress", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Bare)]
        [return: System.Xml.Serialization.XmlElementAttribute("addressVerificationResponse", Namespace = "http://retail.tmobile.com/sdo")]
        public AddressVerificationResponse verifyAddress([System.Xml.Serialization.XmlElementAttribute(Namespace = "http://retail.tmobile.com/sdo")] AddressVerificationRequest addressVerificationRequest)
        {
            object[] results = this.Invoke("verifyAddress", new object[] {
                    addressVerificationRequest});
            return ((AddressVerificationResponse)(results[0]));
        }

        /// <remarks/>
        public System.IAsyncResult BeginverifyAddress(AddressVerificationRequest addressVerificationRequest, System.AsyncCallback callback, object asyncState)
        {
            return this.BeginInvoke("verifyAddress", new object[] {
                    addressVerificationRequest}, callback, asyncState);
        }

        /// <remarks/>
        public AddressVerificationResponse EndverifyAddress(System.IAsyncResult asyncResult)
        {
            object[] results = this.EndInvoke(asyncResult);
            return ((AddressVerificationResponse)(results[0]));
        }

        /// <remarks/>
        public void verifyAddressAsync(AddressVerificationRequest addressVerificationRequest)
        {
            this.verifyAddressAsync(addressVerificationRequest, null);
        }

        /// <remarks/>
        public void verifyAddressAsync(AddressVerificationRequest addressVerificationRequest, object userState)
        {
            if ((this.verifyAddressOperationCompleted == null))
            {
                this.verifyAddressOperationCompleted = new System.Threading.SendOrPostCallback(this.OnverifyAddressOperationCompleted);
            }
            this.InvokeAsync("verifyAddress", new object[] {
                    addressVerificationRequest}, this.verifyAddressOperationCompleted, userState);
        }

        private void OnverifyAddressOperationCompleted(object arg)
        {
            if ((this.verifyAddressCompleted != null))
            {
                System.Web.Services.Protocols.InvokeCompletedEventArgs invokeArgs = ((System.Web.Services.Protocols.InvokeCompletedEventArgs)(arg));
                this.verifyAddressCompleted(this, new verifyAddressCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState));
            }
        }

        /// <remarks/>
        [System.Web.Services.Protocols.SoapDocumentMethodAttribute("validateAndClassifyAddress", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Bare)]
        [return: System.Xml.Serialization.XmlElementAttribute("validateAndClassifyAddressResponse", Namespace = "http://retail.tmobile.com/sdo")]
        public ValidateAndClassifyAddressResponse validateAndClassifyAddress([System.Xml.Serialization.XmlElementAttribute(Namespace = "http://retail.tmobile.com/sdo")] ValidateAndClassifyAddressRequest validateAndClassifyAddressRequest)
        {
            object[] results = this.Invoke("validateAndClassifyAddress", new object[] {
                    validateAndClassifyAddressRequest});
            return ((ValidateAndClassifyAddressResponse)(results[0]));
        }

        /// <remarks/>
        public System.IAsyncResult BeginvalidateAndClassifyAddress(ValidateAndClassifyAddressRequest validateAndClassifyAddressRequest, System.AsyncCallback callback, object asyncState)
        {
            return this.BeginInvoke("validateAndClassifyAddress", new object[] {
                    validateAndClassifyAddressRequest}, callback, asyncState);
        }

        /// <remarks/>
        public ValidateAndClassifyAddressResponse EndvalidateAndClassifyAddress(System.IAsyncResult asyncResult)
        {
            object[] results = this.EndInvoke(asyncResult);
            return ((ValidateAndClassifyAddressResponse)(results[0]));
        }

        /// <remarks/>
        public void validateAndClassifyAddressAsync(ValidateAndClassifyAddressRequest validateAndClassifyAddressRequest)
        {
            this.validateAndClassifyAddressAsync(validateAndClassifyAddressRequest, null);
        }

        /// <remarks/>
        public void validateAndClassifyAddressAsync(ValidateAndClassifyAddressRequest validateAndClassifyAddressRequest, object userState)
        {
            if ((this.validateAndClassifyAddressOperationCompleted == null))
            {
                this.validateAndClassifyAddressOperationCompleted = new System.Threading.SendOrPostCallback(this.OnvalidateAndClassifyAddressOperationCompleted);
            }
            this.InvokeAsync("validateAndClassifyAddress", new object[] {
                    validateAndClassifyAddressRequest}, this.validateAndClassifyAddressOperationCompleted, userState);
        }

        private void OnvalidateAndClassifyAddressOperationCompleted(object arg)
        {
            if ((this.validateAndClassifyAddressCompleted != null))
            {
                System.Web.Services.Protocols.InvokeCompletedEventArgs invokeArgs = ((System.Web.Services.Protocols.InvokeCompletedEventArgs)(arg));
                this.validateAndClassifyAddressCompleted(this, new validateAndClassifyAddressCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState));
            }
        }

        /// <remarks/>
        public new void CancelAsync(object userState)
        {
            base.CancelAsync(userState);
        }
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public partial class AddressVerificationForE911Request : RspRequest
    {

        private Address addressToVerifyField;

        /// <remarks/>
        public Address addressToVerify
        {
            get
            {
                return this.addressToVerifyField;
            }
            set
            {
                this.addressToVerifyField = value;
            }
        }
    }

    /// <remarks/>
    [System.Xml.Serialization.XmlIncludeAttribute(typeof(ReferencedAddress))]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public partial class Address
    {

        private AddressClassificationEnum addressClassificationField;

        private bool addressClassificationFieldSpecified;

        private string address1Field;

        private string address2Field;

        private string cityField;

        private StateEnum stateField;

        private bool stateFieldSpecified;

        private string zipCodeField;

        private string postalCodeField;

        private string zipCodeExtensionField;

        private bool internationalField;

        private bool internationalFieldSpecified;

        private string geoCodeField;

        private sbyte uncertaintyIndField;

        private bool uncertaintyIndFieldSpecified;

        private string latLongField;

        private string urbanizationField;

        private string countryCodeField;

        private string attentionField;

        private string addressTypeField;

        /// <remarks/>
        public AddressClassificationEnum addressClassification
        {
            get
            {
                return this.addressClassificationField;
            }
            set
            {
                this.addressClassificationField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlIgnoreAttribute()]
        public bool addressClassificationSpecified
        {
            get
            {
                return this.addressClassificationFieldSpecified;
            }
            set
            {
                this.addressClassificationFieldSpecified = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "normalizedString")]
        public string address1
        {
            get
            {
                return this.address1Field;
            }
            set
            {
                this.address1Field = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "normalizedString")]
        public string address2
        {
            get
            {
                return this.address2Field;
            }
            set
            {
                this.address2Field = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "normalizedString")]
        public string city
        {
            get
            {
                return this.cityField;
            }
            set
            {
                this.cityField = value;
            }
        }

        /// <remarks/>
        public StateEnum state
        {
            get
            {
                return this.stateField;
            }
            set
            {
                this.stateField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlIgnoreAttribute()]
        public bool stateSpecified
        {
            get
            {
                return this.stateFieldSpecified;
            }
            set
            {
                this.stateFieldSpecified = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "token")]
        public string zipCode
        {
            get
            {
                return this.zipCodeField;
            }
            set
            {
                this.zipCodeField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "normalizedString")]
        public string postalCode
        {
            get
            {
                return this.postalCodeField;
            }
            set
            {
                this.postalCodeField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "token")]
        public string zipCodeExtension
        {
            get
            {
                return this.zipCodeExtensionField;
            }
            set
            {
                this.zipCodeExtensionField = value;
            }
        }

        /// <remarks/>
        public bool international
        {
            get
            {
                return this.internationalField;
            }
            set
            {
                this.internationalField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlIgnoreAttribute()]
        public bool internationalSpecified
        {
            get
            {
                return this.internationalFieldSpecified;
            }
            set
            {
                this.internationalFieldSpecified = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "normalizedString")]
        public string geoCode
        {
            get
            {
                return this.geoCodeField;
            }
            set
            {
                this.geoCodeField = value;
            }
        }

        /// <remarks/>
        public sbyte uncertaintyInd
        {
            get
            {
                return this.uncertaintyIndField;
            }
            set
            {
                this.uncertaintyIndField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlIgnoreAttribute()]
        public bool uncertaintyIndSpecified
        {
            get
            {
                return this.uncertaintyIndFieldSpecified;
            }
            set
            {
                this.uncertaintyIndFieldSpecified = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "normalizedString")]
        public string latLong
        {
            get
            {
                return this.latLongField;
            }
            set
            {
                this.latLongField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "normalizedString")]
        public string urbanization
        {
            get
            {
                return this.urbanizationField;
            }
            set
            {
                this.urbanizationField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "token")]
        public string countryCode
        {
            get
            {
                return this.countryCodeField;
            }
            set
            {
                this.countryCodeField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "normalizedString")]
        public string attention
        {
            get
            {
                return this.attentionField;
            }
            set
            {
                this.attentionField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "token")]
        public string addressType
        {
            get
            {
                return this.addressTypeField;
            }
            set
            {
                this.addressTypeField = value;
            }
        }
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public partial class ClassifyAddress
    {

        private bool isValidPPUAddressField;

        private bool isValidE911AddressField;

        private bool isValidBillingAddressField;

        private bool isValidUserAddressField;

        private bool isValidMailingAddressField;

        private StatusItem errorStatusField;

        private Address addressField;

        /// <remarks/>
        public bool isValidPPUAddress
        {
            get
            {
                return this.isValidPPUAddressField;
            }
            set
            {
                this.isValidPPUAddressField = value;
            }
        }

        /// <remarks/>
        public bool isValidE911Address
        {
            get
            {
                return this.isValidE911AddressField;
            }
            set
            {
                this.isValidE911AddressField = value;
            }
        }

        /// <remarks/>
        public bool isValidBillingAddress
        {
            get
            {
                return this.isValidBillingAddressField;
            }
            set
            {
                this.isValidBillingAddressField = value;
            }
        }

        /// <remarks/>
        public bool isValidUserAddress
        {
            get
            {
                return this.isValidUserAddressField;
            }
            set
            {
                this.isValidUserAddressField = value;
            }
        }

        /// <remarks/>
        public bool isValidMailingAddress
        {
            get
            {
                return this.isValidMailingAddressField;
            }
            set
            {
                this.isValidMailingAddressField = value;
            }
        }

        /// <remarks/>
        public StatusItem errorStatus
        {
            get
            {
                return this.errorStatusField;
            }
            set
            {
                this.errorStatusField = value;
            }
        }

        /// <remarks/>
        public Address address
        {
            get
            {
                return this.addressField;
            }
            set
            {
                this.addressField = value;
            }
        }
    }


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public partial class ValidateAndClassifyAddressRequest : RspRequest
    {

        private Address[] addressField;

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("address")]
        public Address[] address
        {
            get
            {
                return this.addressField;
            }
            set
            {
                this.addressField = value;
            }
        }
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public partial class AddressVerificationRequest : RspRequest
    {

        private Address addressToVerifyField;

        /// <remarks/>
        public Address addressToVerify
        {
            get
            {
                return this.addressToVerifyField;
            }
            set
            {
                this.addressToVerifyField = value;
            }
        }
    }


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public partial class ValidateAndClassifyAddressResponse : RspResponse
    {

        private ClassifyAddress[] classifyAddressField;

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("classifyAddress")]
        public ClassifyAddress[] classifyAddress
        {
            get
            {
                return this.classifyAddressField;
            }
            set
            {
                this.classifyAddressField = value;
            }
        }
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public partial class AddressVerificationResponse : RspResponse
    {

        private Address verifiedAddressField;

        /// <remarks/>
        public Address verifiedAddress
        {
            get
            {
                return this.verifiedAddressField;
            }
            set
            {
                this.verifiedAddressField = value;
            }
        }
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public partial class ReferencedAddress : Address
    {

        private long addressIdField;

        private long linkSeqNbrField;

        private bool linkSeqNbrFieldSpecified;

        /// <remarks/>
        public long addressId
        {
            get
            {
                return this.addressIdField;
            }
            set
            {
                this.addressIdField = value;
            }
        }

        /// <remarks/>
        public long linkSeqNbr
        {
            get
            {
                return this.linkSeqNbrField;
            }
            set
            {
                this.linkSeqNbrField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlIgnoreAttribute()]
        public bool linkSeqNbrSpecified
        {
            get
            {
                return this.linkSeqNbrFieldSpecified;
            }
            set
            {
                this.linkSeqNbrFieldSpecified = value;
            }
        }
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    public delegate void verifyE911AddressCompletedEventHandler(object sender, verifyE911AddressCompletedEventArgs e);

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    public partial class verifyE911AddressCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
    {

        private object[] results;

        internal verifyE911AddressCompletedEventArgs(object[] results, System.Exception exception, bool cancelled, object userState) :
            base(exception, cancelled, userState)
        {
            this.results = results;
        }

        /// <remarks/>
        public AddressVerificationResponse Result
        {
            get
            {
                this.RaiseExceptionIfNecessary();
                return ((AddressVerificationResponse)(this.results[0]));
            }
        }
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    public delegate void verifyAddressCompletedEventHandler(object sender, verifyAddressCompletedEventArgs e);

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    public partial class verifyAddressCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
    {

        private object[] results;

        internal verifyAddressCompletedEventArgs(object[] results, System.Exception exception, bool cancelled, object userState) :
            base(exception, cancelled, userState)
        {
            this.results = results;
        }

        /// <remarks/>
        public AddressVerificationResponse Result
        {
            get
            {
                this.RaiseExceptionIfNecessary();
                return ((AddressVerificationResponse)(this.results[0]));
            }
        }
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    public delegate void validateAndClassifyAddressCompletedEventHandler(object sender, validateAndClassifyAddressCompletedEventArgs e);

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    public partial class validateAndClassifyAddressCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
    {

        private object[] results;

        internal validateAndClassifyAddressCompletedEventArgs(object[] results, System.Exception exception, bool cancelled, object userState) :
            base(exception, cancelled, userState)
        {
            this.results = results;
        }

        /// <remarks/>
        public ValidateAndClassifyAddressResponse Result
        {
            get
            {
                this.RaiseExceptionIfNecessary();
                return ((ValidateAndClassifyAddressResponse)(this.results[0]));
            }
        }
    }
}
