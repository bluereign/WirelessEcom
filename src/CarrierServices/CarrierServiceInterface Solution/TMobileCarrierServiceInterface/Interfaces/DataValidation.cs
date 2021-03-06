﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.239
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace TMobileCarrierServiceInterface.Interfaces.DataValidation
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
    [System.Web.Services.WebServiceBindingAttribute(Name = "DataValidationServiceSOAPBinding", Namespace = "http://retail.tmobile.com/service")]
    [System.Xml.Serialization.XmlIncludeAttribute(typeof(RspRequest))]
    public partial class DataValidationService : Microsoft.Web.Services2.WebServicesClientProtocol
    {

        private System.Threading.SendOrPostCallback validateImeiOperationCompleted;

        /// <remarks/>
        public DataValidationService()
        {
            this.Url = "http://localhost:7001/eProxy/service/DataValidationService_SOAP_V1";
        }

        /// <remarks/>
        public event validateImeiCompletedEventHandler validateImeiCompleted;

        /// <remarks/>
        [System.Web.Services.Protocols.SoapDocumentMethodAttribute("validateImei", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Bare)]
        [return: System.Xml.Serialization.XmlElementAttribute("imeiValidationResponse", Namespace = "http://retail.tmobile.com/sdo")]
        public ImeiValidationResponse validateImei([System.Xml.Serialization.XmlElementAttribute(Namespace = "http://retail.tmobile.com/sdo")] ImeiValidationRequest imeiValidationRequest)
        {
            object[] results = this.Invoke("validateImei", new object[] {
                    imeiValidationRequest});
            return ((ImeiValidationResponse)(results[0]));
        }

        /// <remarks/>
        public System.IAsyncResult BeginvalidateImei(ImeiValidationRequest imeiValidationRequest, System.AsyncCallback callback, object asyncState)
        {
            return this.BeginInvoke("validateImei", new object[] {
                    imeiValidationRequest}, callback, asyncState);
        }

        /// <remarks/>
        public ImeiValidationResponse EndvalidateImei(System.IAsyncResult asyncResult)
        {
            object[] results = this.EndInvoke(asyncResult);
            return ((ImeiValidationResponse)(results[0]));
        }

        /// <remarks/>
        public void validateImeiAsync(ImeiValidationRequest imeiValidationRequest)
        {
            this.validateImeiAsync(imeiValidationRequest, null);
        }

        /// <remarks/>
        public void validateImeiAsync(ImeiValidationRequest imeiValidationRequest, object userState)
        {
            if ((this.validateImeiOperationCompleted == null))
            {
                this.validateImeiOperationCompleted = new System.Threading.SendOrPostCallback(this.OnvalidateImeiOperationCompleted);
            }
            this.InvokeAsync("validateImei", new object[] {
                    imeiValidationRequest}, this.validateImeiOperationCompleted, userState);
        }

        private void OnvalidateImeiOperationCompleted(object arg)
        {
            if ((this.validateImeiCompleted != null))
            {
                System.Web.Services.Protocols.InvokeCompletedEventArgs invokeArgs = ((System.Web.Services.Protocols.InvokeCompletedEventArgs)(arg));
                this.validateImeiCompleted(this, new validateImeiCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState));
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
    public partial class ImeiValidationRequest : RspRequest
    {

        private string[] imeiField;

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("imei", DataType = "token")]
        public string[] imei
        {
            get
            {
                return this.imeiField;
            }
            set
            {
                this.imeiField = value;
            }
        }
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public partial class ImeiDetail
    {

        private string imeiField;

        private bool imeiValidField;

        private StatusItem imeiStatusField;

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "token")]
        public string imei
        {
            get
            {
                return this.imeiField;
            }
            set
            {
                this.imeiField = value;
            }
        }

        /// <remarks/>
        public bool imeiValid
        {
            get
            {
                return this.imeiValidField;
            }
            set
            {
                this.imeiValidField = value;
            }
        }

        /// <remarks/>
        public StatusItem imeiStatus
        {
            get
            {
                return this.imeiStatusField;
            }
            set
            {
                this.imeiStatusField = value;
            }
        }
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public partial class ImeiValidationResponse : RspResponse
    {

        private ImeiDetail[] imeiDetailField;

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("imeiDetail")]
        public ImeiDetail[] imeiDetail
        {
            get
            {
                return this.imeiDetailField;
            }
            set
            {
                this.imeiDetailField = value;
            }
        }
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    public delegate void validateImeiCompletedEventHandler(object sender, validateImeiCompletedEventArgs e);

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    public partial class validateImeiCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
    {

        private object[] results;

        internal validateImeiCompletedEventArgs(object[] results, System.Exception exception, bool cancelled, object userState) :
            base(exception, cancelled, userState)
        {
            this.results = results;
        }

        /// <remarks/>
        public ImeiValidationResponse Result
        {
            get
            {
                this.RaiseExceptionIfNecessary();
                return ((ImeiValidationResponse)(this.results[0]));
            }
        }
    }
}