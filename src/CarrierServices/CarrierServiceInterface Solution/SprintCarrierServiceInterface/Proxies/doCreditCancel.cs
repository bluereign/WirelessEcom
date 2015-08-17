﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.225
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

// 
// This source code was auto-generated by xsd, Version=4.0.30319.1.
// 
namespace WirelessAdvocate.CarrierServices.Proxies.Sprint.CreditCancel {
    using System.Xml.Serialization;
    
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://nextel.com/ovm")]
    [System.Xml.Serialization.XmlRootAttribute("fault", Namespace="http://nextel.com/ovm", IsNullable=false)]
    public partial class OVMFault {
        
        private ErrorInfo[] detailField;
        
        /// <remarks/>
        [System.Xml.Serialization.XmlArrayItemAttribute("errorInfo", IsNullable=false)]
        public ErrorInfo[] detail {
            get {
                return this.detailField;
            }
            set {
                this.detailField = value;
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://nextel.com/ovm")]
    public partial class ErrorInfo {
        
        private uint errortypeField;
        
        private string errorcodeField;
        
        private string errorsubnameField;
        
        private string errordetailsField;
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("error-type")]
        public uint errortype {
            get {
                return this.errortypeField;
            }
            set {
                this.errortypeField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("error-code", DataType="integer")]
        public string errorcode {
            get {
                return this.errorcodeField;
            }
            set {
                this.errorcodeField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("error-sub-name")]
        public string errorsubname {
            get {
                return this.errorsubnameField;
            }
            set {
                this.errorsubnameField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("error-details")]
        public string errordetails {
            get {
                return this.errordetailsField;
            }
            set {
                this.errordetailsField = value;
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://nextel.com/ovm")]
    public partial class Name {
        
        private string sirnameField;
        
        private string firstnameField;
        
        private string middleinitialField;
        
        private string lastnameField;
        
        private string suffixField;
        
        private string additionallineField;
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("sir-name")]
        public string sirname {
            get {
                return this.sirnameField;
            }
            set {
                this.sirnameField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("first-name")]
        public string firstname {
            get {
                return this.firstnameField;
            }
            set {
                this.firstnameField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("middle-initial")]
        public string middleinitial {
            get {
                return this.middleinitialField;
            }
            set {
                this.middleinitialField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("last-name")]
        public string lastname {
            get {
                return this.lastnameField;
            }
            set {
                this.lastnameField = value;
            }
        }
        
        /// <remarks/>
        public string suffix {
            get {
                return this.suffixField;
            }
            set {
                this.suffixField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("additional-line")]
        public string additionalline {
            get {
                return this.additionallineField;
            }
            set {
                this.additionallineField = value;
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://nextel.com/ovm")]
    [System.Xml.Serialization.XmlRootAttribute("requestHeader", Namespace="http://nextel.com/ovm", IsNullable=false)]
    public partial class RequestMessageHeader {
        
        private string pinField;
        
        private string vendorcodeField;
        
        private string subvendorcodeField;
        
        private string vendorusernameField;
        
        private string vendorpasswordField;
        
        private string messageidField;
        
        private string orderidField;
        
        private RequestMessageType messagetypeField;
        
        private System.DateTime timestampField;
        
        private string returnurlField;
        
        private string resendnumberField;
        
        private BrandType brandtypeField;
        
        private bool brandtypeFieldSpecified;
        
        private string storeidField;
        
        private string associateidField;
        
        /// <remarks/>
        public string pin {
            get {
                return this.pinField;
            }
            set {
                this.pinField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("vendor-code")]
        public string vendorcode {
            get {
                return this.vendorcodeField;
            }
            set {
                this.vendorcodeField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("sub-vendor-code")]
        public string subvendorcode {
            get {
                return this.subvendorcodeField;
            }
            set {
                this.subvendorcodeField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("vendor-username")]
        public string vendorusername {
            get {
                return this.vendorusernameField;
            }
            set {
                this.vendorusernameField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("vendor-password")]
        public string vendorpassword {
            get {
                return this.vendorpasswordField;
            }
            set {
                this.vendorpasswordField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("message-id")]
        public string messageid {
            get {
                return this.messageidField;
            }
            set {
                this.messageidField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("order-id")]
        public string orderid {
            get {
                return this.orderidField;
            }
            set {
                this.orderidField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("message-type")]
        public RequestMessageType messagetype {
            get {
                return this.messagetypeField;
            }
            set {
                this.messagetypeField = value;
            }
        }
        
        /// <remarks/>
        public System.DateTime timestamp {
            get {
                return this.timestampField;
            }
            set {
                this.timestampField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("return-url", DataType="anyURI")]
        public string returnurl {
            get {
                return this.returnurlField;
            }
            set {
                this.returnurlField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("resend-number", DataType="nonNegativeInteger")]
        public string resendnumber {
            get {
                return this.resendnumberField;
            }
            set {
                this.resendnumberField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("brand-type")]
        public BrandType brandtype {
            get {
                return this.brandtypeField;
            }
            set {
                this.brandtypeField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlIgnoreAttribute()]
        public bool brandtypeSpecified {
            get {
                return this.brandtypeFieldSpecified;
            }
            set {
                this.brandtypeFieldSpecified = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("store-id")]
        public string storeid {
            get {
                return this.storeidField;
            }
            set {
                this.storeidField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("associate-id")]
        public string associateid {
            get {
                return this.associateidField;
            }
            set {
                this.associateidField = value;
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://nextel.com/ovm")]
    public enum RequestMessageType {
        
        /// <remarks/>
        ACTIVATION_REQUEST,
        
        /// <remarks/>
        ACTIVATE_NOW_REQUEST,
        
        /// <remarks/>
        CREDIT_CHECK_REQUEST,
        
        /// <remarks/>
        DEACTIVATION_REQUEST,
        
        /// <remarks/>
        PORT_ELIGIBILITY_REQUEST,
        
        /// <remarks/>
        VALIDATION_REQUEST,
        
        /// <remarks/>
        PORT_STATUS_REQUEST,
        
        /// <remarks/>
        NPA_NXX_REQUEST,
        
        /// <remarks/>
        ACCOUNT_VALIDATION_REQUEST,
        
        /// <remarks/>
        CREDIT_CANCEL_REQUEST,
        
        /// <remarks/>
        PRE_AUTHORIZATION_REQUEST,
        
        /// <remarks/>
        PLANS_REQUEST,
        
        /// <remarks/>
        OPTIONS_REQUEST,
        
        /// <remarks/>
        BILL_SUMMARY_REQUEST,
        
        /// <remarks/>
        SERVICE_VALIDATION_REQUEST,
        
        /// <remarks/>
        SECURITY_QUESTION_REQUEST,
        
        /// <remarks/>
        INVENTORY_CHECK_REQUEST,
        
        /// <remarks/>
        AUTHENTICATE_RESEND_PIN_REQUEST,
        
        /// <remarks/>
        COVERAGE_CHECK_REQUEST,
        
        /// <remarks/>
        CORPORATE_DISCOUNT_REQUEST,
        
        /// <remarks/>
        ACTIVATE_RESERVED_DEVICE_REQUEST,
        
        /// <remarks/>
        DEVICE_INFO_REQUEST,
        
        /// <remarks/>
        ORDER_STATUS_REQUEST,
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://nextel.com/ovm")]
    public enum BrandType {
        
        /// <remarks/>
        NX,
        
        /// <remarks/>
        SP,
        
        /// <remarks/>
        HB,
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://nextel.com/ovm")]
    [System.Xml.Serialization.XmlRootAttribute("responseHeader", Namespace="http://nextel.com/ovm", IsNullable=false)]
    public partial class ResponseMessageHeader {
        
        private string vendorcodeField;
        
        private string messageidField;
        
        private string orderidField;
        
        private ResponseMessageType messagetypeField;
        
        private System.DateTime timestampField;
        
        private string resendnumberField;
        
        private ResponseMessageHeaderBrandtype brandtypeField;
        
        private bool brandtypeFieldSpecified;
        
        private string storeidField;
        
        private string associateidField;
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("vendor-code")]
        public string vendorcode {
            get {
                return this.vendorcodeField;
            }
            set {
                this.vendorcodeField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("message-id")]
        public string messageid {
            get {
                return this.messageidField;
            }
            set {
                this.messageidField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("order-id")]
        public string orderid {
            get {
                return this.orderidField;
            }
            set {
                this.orderidField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("message-type")]
        public ResponseMessageType messagetype {
            get {
                return this.messagetypeField;
            }
            set {
                this.messagetypeField = value;
            }
        }
        
        /// <remarks/>
        public System.DateTime timestamp {
            get {
                return this.timestampField;
            }
            set {
                this.timestampField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("resend-number", DataType="nonNegativeInteger")]
        public string resendnumber {
            get {
                return this.resendnumberField;
            }
            set {
                this.resendnumberField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("brand-type")]
        public ResponseMessageHeaderBrandtype brandtype {
            get {
                return this.brandtypeField;
            }
            set {
                this.brandtypeField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlIgnoreAttribute()]
        public bool brandtypeSpecified {
            get {
                return this.brandtypeFieldSpecified;
            }
            set {
                this.brandtypeFieldSpecified = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("store-id")]
        public string storeid {
            get {
                return this.storeidField;
            }
            set {
                this.storeidField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("associate-id")]
        public string associateid {
            get {
                return this.associateidField;
            }
            set {
                this.associateidField = value;
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://nextel.com/ovm")]
    public enum ResponseMessageType {
        
        /// <remarks/>
        ACTIVATION_RESPONSE,
        
        /// <remarks/>
        ACTIVATE_NOW_RESPONSE,
        
        /// <remarks/>
        CREDIT_CHECK_RESPONSE,
        
        /// <remarks/>
        DEACTIVATION_RESPONSE,
        
        /// <remarks/>
        PARSE_RESPONSE,
        
        /// <remarks/>
        CANCELLED_RESPONSE,
        
        /// <remarks/>
        STATUS_RESPONSE,
        
        /// <remarks/>
        PORT_ELIGIBILITY_RESPONSE,
        
        /// <remarks/>
        VALIDATION_RESPONSE,
        
        /// <remarks/>
        PORT_STATUS_RESPONSE,
        
        /// <remarks/>
        NPA_NXX_RESPONSE,
        
        /// <remarks/>
        ACCOUNT_VALIDATION_RESPONSE,
        
        /// <remarks/>
        CREDIT_CANCEL_RESPONSE,
        
        /// <remarks/>
        PRE_AUTHORIZATION_RESPONSE,
        
        /// <remarks/>
        PLANS_RESPONSE,
        
        /// <remarks/>
        OPTIONS_RESPONSE,
        
        /// <remarks/>
        BILL_SUMMARY_RESPONSE,
        
        /// <remarks/>
        SERVICE_VALIDATION_RESPONSE,
        
        /// <remarks/>
        SECURITY_QUESTION_RESPONSE,
        
        /// <remarks/>
        INVENTORY_CHECK_RESPONSE,
        
        /// <remarks/>
        AUTHENTICATE_RESEND_PIN_RESPONSE,
        
        /// <remarks/>
        COVERAGE_CHECK_RESPONSE,
        
        /// <remarks/>
        CORPORATE_DISCOUNT_RESPONSE,
        
        /// <remarks/>
        ACTIVATE_RESERVED_DEVICE_RESPONSE,
        
        /// <remarks/>
        DEVICE_INFO_RESPONSE,
        
        /// <remarks/>
        ORDER_STATUS_RESPONSE,
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType=true, Namespace="http://nextel.com/ovm")]
    public enum ResponseMessageHeaderBrandtype {
        
        /// <remarks/>
        NX,
        
        /// <remarks/>
        SP,
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://nextel.com/ovm")]
    [System.Xml.Serialization.XmlRootAttribute("ackResponse", Namespace="http://nextel.com/ovm", IsNullable=false)]
    public partial class ParseResponse {
        
        private ParseResponseType parseresultField;
        
        private string detailsField;
        
        private string sprintorderidField;
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("parse-result")]
        public ParseResponseType parseresult {
            get {
                return this.parseresultField;
            }
            set {
                this.parseresultField = value;
            }
        }
        
        /// <remarks/>
        public string details {
            get {
                return this.detailsField;
            }
            set {
                this.detailsField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("sprint-order-id")]
        public string sprintorderid {
            get {
                return this.sprintorderidField;
            }
            set {
                this.sprintorderidField = value;
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://nextel.com/ovm")]
    public enum ParseResponseType {
        
        /// <remarks/>
        ACK,
        
        /// <remarks/>
        NACK,
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://nextel.com/ovm")]
    [System.Xml.Serialization.XmlRootAttribute("doCreditCancel", Namespace="http://nextel.com/ovm", IsNullable=false)]
    public partial class CreditCancelRequest {
        
        private Name nameField;
        
        /// <remarks/>
        public Name name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://nextel.com/ovm")]
    [System.Xml.Serialization.XmlRootAttribute("doCreditCancelResponse", Namespace="http://nextel.com/ovm", IsNullable=false)]
    public partial class CreditCancelResponse {
        
        private bool cancelledField;
        
        /// <remarks/>
        public bool cancelled {
            get {
                return this.cancelledField;
            }
            set {
                this.cancelledField = value;
            }
        }
    }
}
