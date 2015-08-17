﻿using System.Diagnostics;
using System.Web.Services;
using System.ComponentModel;
using System.Web.Services.Protocols;
using System;
using System.Xml.Serialization;


/// <remarks/>
[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
[System.SerializableAttribute()]
[System.Diagnostics.DebuggerStepThroughAttribute()]
[System.ComponentModel.DesignerCategoryAttribute("code")]
[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
public partial class ResponseInfo
{

    private string codeField;

    private string descriptionField;

    /// <remarks/>
    public string code
    {
        get
        {
            return this.codeField;
        }
        set
        {
            this.codeField = value;
        }
    }

    /// <remarks/>
    public string description
    {
        get
        {
            return this.descriptionField;
        }
        set
        {
            this.descriptionField = value;
        }
    }
}

/// <remarks/>
[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
[System.SerializableAttribute()]
[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
public enum SubscriberStatusInfo
{

    /// <remarks/>
    R,

    /// <remarks/>
    A,

    /// <remarks/>
    C,

    /// <remarks/>
    S,

    /// <remarks/>
    L,
}

/// <remarks/>
[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
[System.SerializableAttribute()]
[System.Diagnostics.DebuggerStepThroughAttribute()]
[System.ComponentModel.DesignerCategoryAttribute("code")]
[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ActivateSubscriberRespons" +
    "e.xsd")]
public partial class ActivateSubscriberResponseInfoSubscriber
{

    private string subscriberNumberField;

    private SubscriberStatusInfo subscriberStatusField;

    private int requiredDepositField;

    private bool requiredDepositFieldSpecified;

    private ResponseInfo responseField;

    /// <remarks/>
    public string subscriberNumber
    {
        get
        {
            return this.subscriberNumberField;
        }
        set
        {
            this.subscriberNumberField = value;
        }
    }

    /// <remarks/>
    public SubscriberStatusInfo subscriberStatus
    {
        get
        {
            return this.subscriberStatusField;
        }
        set
        {
            this.subscriberStatusField = value;
        }
    }

    /// <remarks/>
    public int requiredDeposit
    {
        get
        {
            return this.requiredDepositField;
        }
        set
        {
            this.requiredDepositField = value;
        }
    }

    /// <remarks/>
    [System.Xml.Serialization.XmlIgnoreAttribute()]
    public bool requiredDepositSpecified
    {
        get
        {
            return this.requiredDepositFieldSpecified;
        }
        set
        {
            this.requiredDepositFieldSpecified = value;
        }
    }

    /// <remarks/>
    public ResponseInfo Response
    {
        get
        {
            return this.responseField;
        }
        set
        {
            this.responseField = value;
        }
    }
}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.Web.Services.WebServiceBindingAttribute(Name = "ActivateSubscriberRequestSoapHttpBinding", Namespace = "http://csi.cingular.com/CSI/Namespaces/v32/wsdl/CingularWirelessCSI.wsdl")]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(PreviousUsageInfo))]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(UsageInfo))]
//public interface IActivateSubscriberRequestSoapHttpBinding
//{


//    MessageHeaderInfo MessageHeader
//    {
//        get;
//        set;
//    }

//    /// <remarks/>
//    [System.Web.Services.Protocols.SoapHeaderAttribute("MessageHeader", Direction = System.Web.Services.Protocols.SoapHeaderDirection.InOut)]
//    [System.Web.Services.WebMethodAttribute()]
//    [System.Web.Services.Protocols.SoapDocumentMethodAttribute("", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Bare)]
//    [return: System.Xml.Serialization.XmlElementAttribute("RequestAcknowledgement", Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/RequestAcknowledgement.xs" +
//        "d")]
//    RequestAcknowledgementInfo ActivateSubscriberRequest([System.Xml.Serialization.XmlElementAttribute("ActivateSubscriberRequest", Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ActivateSubscriberRequest" +
//        ".xsd")] ActivateSubscriberRequestInfo ActivateSubscriberRequest1);
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.Web.Services.WebServiceBindingAttribute(Name = "ActivateSubscriberResponseSoapHttpBinding", Namespace = "http://csi.cingular.com/CSI/Namespaces/v32/wsdl/CingularWirelessCSI.wsdl")]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(PreviousUsageInfo))]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(UsageInfo))]
//public interface IActivateSubscriberResponseSoapHttpBinding
//{


//    MessageHeaderInfo MessageHeader
//    {
//        get;
//        set;
//    }

//    /// <remarks/>
//    [System.Web.Services.Protocols.SoapHeaderAttribute("MessageHeader", Direction = System.Web.Services.Protocols.SoapHeaderDirection.InOut)]
//    [System.Web.Services.WebMethodAttribute()]
//    [System.Web.Services.Protocols.SoapDocumentMethodAttribute("", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Bare)]
//    [return: System.Xml.Serialization.XmlElementAttribute("RequestAcknowledgement", Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/RequestAcknowledgement.xs" +
//        "d")]
//    RequestAcknowledgementInfo ActivateSubscriberResponse(ActivateSubscriberResponseInfo ActivateSubscriberResponse);
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.Web.Services.WebServiceBindingAttribute(Name = "AddAccountSoapHttpBinding", Namespace = "http://csi.cingular.com/CSI/Namespaces/v32/wsdl/CingularWirelessCSI.wsdl")]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(PreviousUsageInfo))]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(UsageInfo))]
//public interface IAddAccountSoapHttpBinding
//{


//    MessageHeaderInfo MessageHeader
//    {
//        get;
//        set;
//    }

//    /// <remarks/>
//    [System.Web.Services.Protocols.SoapHeaderAttribute("MessageHeader", Direction = System.Web.Services.Protocols.SoapHeaderDirection.InOut)]
//    [System.Web.Services.WebMethodAttribute()]
//    [System.Web.Services.Protocols.SoapDocumentMethodAttribute("", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Bare)]
//    [return: System.Xml.Serialization.XmlElementAttribute("AddAccountResponse", Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/AddAccountResponse.xsd")]
//    AddAccountResponseInfo AddAccount([System.Xml.Serialization.XmlElementAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/AddAccountRequest.xsd")] AddAccountRequestInfo AddAccountRequest);
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.Web.Services.WebServiceBindingAttribute(Name = "AddPortSoapHttpBinding", Namespace = "http://csi.cingular.com/CSI/Namespaces/v32/wsdl/CingularWirelessCSI.wsdl")]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(PreviousUsageInfo))]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(UsageInfo))]
//public interface IAddPortSoapHttpBinding
//{


//    MessageHeaderInfo MessageHeader
//    {
//        get;
//        set;
//    }

//    /// <remarks/>
//    [System.Web.Services.Protocols.SoapHeaderAttribute("MessageHeader", Direction = System.Web.Services.Protocols.SoapHeaderDirection.InOut)]
//    [System.Web.Services.WebMethodAttribute()]
//    [System.Web.Services.Protocols.SoapDocumentMethodAttribute("", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Bare)]
//    [return: System.Xml.Serialization.XmlElementAttribute("AddPortResponse", Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/AddPortResponse.xsd")]
//    AddPortResponseInfo AddPort([System.Xml.Serialization.XmlElementAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/AddPortRequest.xsd")] AddPortRequestInfo AddPortRequest);
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.Web.Services.WebServiceBindingAttribute(Name = "EchoSoapHttpBinding", Namespace = "http://csi.cingular.com/CSI/Namespaces/v32/wsdl/CingularWirelessCSI.wsdl")]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(PreviousUsageInfo))]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(UsageInfo))]
//public interface IEchoSoapHttpBinding
//{


//    MessageHeaderInfo MessageHeader
//    {
//        get;
//        set;
//    }

//    /// <remarks/>
//    [System.Web.Services.Protocols.SoapHeaderAttribute("MessageHeader", Direction = System.Web.Services.Protocols.SoapHeaderDirection.InOut)]
//    [System.Web.Services.WebMethodAttribute()]
//    [System.Web.Services.Protocols.SoapDocumentMethodAttribute("", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Bare)]
//    [return: System.Xml.Serialization.XmlElementAttribute("EchoResponse", Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/EchoResponse.xsd")]
//    EchoResponseInfo Echo([System.Xml.Serialization.XmlElementAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/EchoRequest.xsd")] EchoRequestInfo EchoRequest);
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.Web.Services.WebServiceBindingAttribute(Name = "ExecuteCreditCheckSoapHttpBinding", Namespace = "http://csi.cingular.com/CSI/Namespaces/v32/wsdl/CingularWirelessCSI.wsdl")]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(PreviousUsageInfo))]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(UsageInfo))]
//public interface IExecuteCreditCheckSoapHttpBinding
//{


//    MessageHeaderInfo MessageHeader
//    {
//        get;
//        set;
//    }

//    /// <remarks/>
//    [System.Web.Services.Protocols.SoapHeaderAttribute("MessageHeader", Direction = System.Web.Services.Protocols.SoapHeaderDirection.InOut)]
//    [System.Web.Services.WebMethodAttribute()]
//    [System.Web.Services.Protocols.SoapDocumentMethodAttribute("", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Bare)]
//    [return: System.Xml.Serialization.XmlElementAttribute("ExecuteCreditCheckResponse", Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ExecuteCreditCheckRespons" +
//        "e.xsd")]
//    ExecuteCreditCheckResponseInfo ExecuteCreditCheck([System.Xml.Serialization.XmlElementAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ExecuteCreditCheckRequest" +
//        ".xsd")] ExecuteCreditCheckRequestInfo ExecuteCreditCheckRequest);
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.Web.Services.WebServiceBindingAttribute(Name = "InquireAccountProfileSoapHttpBinding", Namespace = "http://csi.cingular.com/CSI/Namespaces/v32/wsdl/CingularWirelessCSI.wsdl")]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(PreviousUsageInfo))]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(UsageInfo))]
//public interface IInquireAccountProfileSoapHttpBinding
//{


//    MessageHeaderInfo MessageHeader
//    {
//        get;
//        set;
//    }

//    /// <remarks/>
//    [System.Web.Services.Protocols.SoapHeaderAttribute("MessageHeader", Direction = System.Web.Services.Protocols.SoapHeaderDirection.InOut)]
//    [System.Web.Services.WebMethodAttribute()]
//    [System.Web.Services.Protocols.SoapDocumentMethodAttribute("", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Bare)]
//    [return: System.Xml.Serialization.XmlElementAttribute("InquireAccountProfileResponse", Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireAccountProfileResp" +
//        "onse.xsd")]
//    InquireAccountProfileResponseInfo InquireAccountProfile([System.Xml.Serialization.XmlElementAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireAccountProfileRequ" +
//        "est.xsd")] InquireAccountProfileRequestInfo InquireAccountProfileRequest);
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.Web.Services.WebServiceBindingAttribute(Name = "InquireCreditCheckResultSoapHttpBinding", Namespace = "http://csi.cingular.com/CSI/Namespaces/v32/wsdl/CingularWirelessCSI.wsdl")]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(PreviousUsageInfo))]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(UsageInfo))]
//public interface IInquireCreditCheckResultSoapHttpBinding
//{


//    MessageHeaderInfo MessageHeader
//    {
//        get;
//        set;
//    }

//    /// <remarks/>
//    [System.Web.Services.Protocols.SoapHeaderAttribute("MessageHeader", Direction = System.Web.Services.Protocols.SoapHeaderDirection.InOut)]
//    [System.Web.Services.WebMethodAttribute()]
//    [System.Web.Services.Protocols.SoapDocumentMethodAttribute("", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Bare)]
//    [return: System.Xml.Serialization.XmlElementAttribute("InquireCreditCheckResultResponse", Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireCreditCheckResultR" +
//        "esponse.xsd")]
//    InquireCreditCheckResultResponseInfo InquireCreditCheckResult([System.Xml.Serialization.XmlElementAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireCreditCheckResultR" +
//        "equest.xsd")] InquireCreditCheckResultRequestInfo InquireCreditCheckResultRequest);
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.Web.Services.WebServiceBindingAttribute(Name = "InquireDuplicateOfferingsSoapHttpBinding", Namespace = "http://csi.cingular.com/CSI/Namespaces/v32/wsdl/CingularWirelessCSI.wsdl")]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(PreviousUsageInfo))]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(UsageInfo))]
//public interface IInquireDuplicateOfferingsSoapHttpBinding
//{


//    MessageHeaderInfo MessageHeader
//    {
//        get;
//        set;
//    }

//    /// <remarks/>
//    [System.Web.Services.Protocols.SoapHeaderAttribute("MessageHeader", Direction = System.Web.Services.Protocols.SoapHeaderDirection.InOut)]
//    [System.Web.Services.WebMethodAttribute()]
//    [System.Web.Services.Protocols.SoapDocumentMethodAttribute("", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Bare)]
//    [return: System.Xml.Serialization.XmlElementAttribute("InquireDuplicateOfferingsResponse", Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireDuplicateOfferings" +
//        "Response.xsd")]
//    InquireDuplicateOfferingsResponseInfo InquireDuplicateOfferings([System.Xml.Serialization.XmlElementAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireDuplicateOfferings" +
//        "Request.xsd")] InquireDuplicateOfferingsRequestInfo InquireDuplicateOfferingsRequest);
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.Web.Services.WebServiceBindingAttribute(Name = "InquireMarketServiceAreasSoapHttpBinding", Namespace = "http://csi.cingular.com/CSI/Namespaces/v32/wsdl/CingularWirelessCSI.wsdl")]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(PreviousUsageInfo))]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(UsageInfo))]
//public interface IInquireMarketServiceAreasSoapHttpBinding
//{


//    MessageHeaderInfo MessageHeader
//    {
//        get;
//        set;
//    }

//    /// <remarks/>
//    [System.Web.Services.Protocols.SoapHeaderAttribute("MessageHeader", Direction = System.Web.Services.Protocols.SoapHeaderDirection.InOut)]
//    [System.Web.Services.WebMethodAttribute()]
//    [System.Web.Services.Protocols.SoapDocumentMethodAttribute("", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Bare)]
//    [return: System.Xml.Serialization.XmlElementAttribute("InquireMarketServiceAreasResponse", Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireMarketServiceAreas" +
//        "Response.xsd")]
//    InquireMarketServiceAreasResponseInfo InquireMarketServiceAreas([System.Xml.Serialization.XmlElementAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireMarketServiceAreas" +
//        "Request.xsd")] InquireMarketServiceAreasRequestInfo InquireMarketServiceAreasRequest);
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.Web.Services.WebServiceBindingAttribute(Name = "InquirePortSoapHttpBinding", Namespace = "http://csi.cingular.com/CSI/Namespaces/v32/wsdl/CingularWirelessCSI.wsdl")]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(PreviousUsageInfo))]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(UsageInfo))]
//public interface IInquirePortSoapHttpBinding
//{


//    MessageHeaderInfo MessageHeader
//    {
//        get;
//        set;
//    }

//    /// <remarks/>
//    [System.Web.Services.Protocols.SoapHeaderAttribute("MessageHeader", Direction = System.Web.Services.Protocols.SoapHeaderDirection.InOut)]
//    [System.Web.Services.WebMethodAttribute()]
//    [System.Web.Services.Protocols.SoapDocumentMethodAttribute("", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Bare)]
//    [return: System.Xml.Serialization.XmlElementAttribute("InquirePortResponse", Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquirePortResponse.xsd")]
//    InquirePortResponseInfo InquirePort([System.Xml.Serialization.XmlElementAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquirePortRequest.xsd")] InquirePortRequestInfo InquirePortRequest);
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.Web.Services.WebServiceBindingAttribute(Name = "InquirePortActivationStatusSoapHttpBinding", Namespace = "http://csi.cingular.com/CSI/Namespaces/v32/wsdl/CingularWirelessCSI.wsdl")]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(PreviousUsageInfo))]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(UsageInfo))]
//public interface IInquirePortActivationStatusSoapHttpBinding
//{


//    MessageHeaderInfo MessageHeader
//    {
//        get;
//        set;
//    }

//    /// <remarks/>
//    [System.Web.Services.Protocols.SoapHeaderAttribute("MessageHeader", Direction = System.Web.Services.Protocols.SoapHeaderDirection.InOut)]
//    [System.Web.Services.WebMethodAttribute()]
//    [System.Web.Services.Protocols.SoapDocumentMethodAttribute("", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Bare)]
//    [return: System.Xml.Serialization.XmlElementAttribute("InquirePortActivationStatusResponse", Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquirePortActivationStat" +
//        "usResponse.xsd")]
//    InquirePortActivationStatusResponseInfo InquirePortActivationStatus([System.Xml.Serialization.XmlElementAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquirePortActivationStat" +
//        "usRequest.xsd")] InquirePortActivationStatusRequestInfo InquirePortActivationStatusRequest);
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.Web.Services.WebServiceBindingAttribute(Name = "InquirePortEligibilityBySubscriberNumberSoapHttpBinding", Namespace = "http://csi.cingular.com/CSI/Namespaces/v32/wsdl/CingularWirelessCSI.wsdl")]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(PreviousUsageInfo))]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(UsageInfo))]
//public interface IInquirePortEligibilityBySubscriberNumberSoapHttpBinding
//{


//    MessageHeaderInfo MessageHeader
//    {
//        get;
//        set;
//    }

//    /// <remarks/>
//    [System.Web.Services.Protocols.SoapHeaderAttribute("MessageHeader", Direction = System.Web.Services.Protocols.SoapHeaderDirection.InOut)]
//    [System.Web.Services.WebMethodAttribute()]
//    [System.Web.Services.Protocols.SoapDocumentMethodAttribute("", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Bare)]
//    [return: System.Xml.Serialization.XmlElementAttribute("InquirePortEligibilityResponse", Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquirePortEligibilityRes" +
//        "ponse.xsd")]
//    InquirePortEligibilityResponseInfo InquirePortEligibilityBySubscriberNumber([System.Xml.Serialization.XmlElementAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquirePortEligibilityByS" +
//        "ubscriberNumberRequest.xsd")] InquirePortEligibilityBySubscriberNumberRequestInfo InquirePortEligibilityBySubscriberNumberRequest);
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.Web.Services.WebServiceBindingAttribute(Name = "InquireUpgradeEligibilitySoapHttpBinding", Namespace = "http://csi.cingular.com/CSI/Namespaces/v32/wsdl/CingularWirelessCSI.wsdl")]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(PreviousUsageInfo))]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(UsageInfo))]
//public interface IInquireUpgradeEligibilitySoapHttpBinding
//{


//    MessageHeaderInfo MessageHeader
//    {
//        get;
//        set;
//    }

//    /// <remarks/>
//    [System.Web.Services.Protocols.SoapHeaderAttribute("MessageHeader", Direction = System.Web.Services.Protocols.SoapHeaderDirection.InOut)]
//    [System.Web.Services.WebMethodAttribute()]
//    [System.Web.Services.Protocols.SoapDocumentMethodAttribute("", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Bare)]
//    [return: System.Xml.Serialization.XmlElementAttribute("InquireUpgradeEligibilityResponse", Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireUpgradeEligibility" +
//        "Response.xsd")]
//    InquireUpgradeEligibilityResponseInfo InquireUpgradeEligibility([System.Xml.Serialization.XmlElementAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireUpgradeEligibility" +
//        "Request.xsd")] InquireUpgradeEligibilityRequestInfo InquireUpgradeEligibilityRequest);
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.Web.Services.WebServiceBindingAttribute(Name = "ReserveSubscriberNumberSoapHttpBinding", Namespace = "http://csi.cingular.com/CSI/Namespaces/v32/wsdl/CingularWirelessCSI.wsdl")]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(PreviousUsageInfo))]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(UsageInfo))]
//public interface IReserveSubscriberNumberSoapHttpBinding
//{


//    MessageHeaderInfo MessageHeader
//    {
//        get;
//        set;
//    }

//    /// <remarks/>
//    [System.Web.Services.Protocols.SoapHeaderAttribute("MessageHeader", Direction = System.Web.Services.Protocols.SoapHeaderDirection.InOut)]
//    [System.Web.Services.WebMethodAttribute()]
//    [System.Web.Services.Protocols.SoapDocumentMethodAttribute("", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Bare)]
//    [return: System.Xml.Serialization.XmlElementAttribute("ReserveSubscriberNumberResponse", Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ReserveSubscriberNumberRe" +
//        "sponse.xsd")]
//    ReserveSubscriberNumberResponseInfo ReserveSubscriberNumber([System.Xml.Serialization.XmlElementAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ReserveSubscriberNumberRe" +
//        "quest.xsd")] ReserveSubscriberNumberRequestInfo ReserveSubscriberNumberRequest);
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.Web.Services.WebServiceBindingAttribute(Name = "UpdatePortSoapHttpBinding", Namespace = "http://csi.cingular.com/CSI/Namespaces/v32/wsdl/CingularWirelessCSI.wsdl")]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(PreviousUsageInfo))]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(UsageInfo))]
//public interface IUpdatePortSoapHttpBinding
//{


//    MessageHeaderInfo MessageHeader
//    {
//        get;
//        set;
//    }

//    /// <remarks/>
//    [System.Web.Services.Protocols.SoapHeaderAttribute("MessageHeader", Direction = System.Web.Services.Protocols.SoapHeaderDirection.InOut)]
//    [System.Web.Services.WebMethodAttribute()]
//    [System.Web.Services.Protocols.SoapDocumentMethodAttribute("", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Bare)]
//    [return: System.Xml.Serialization.XmlElementAttribute("UpdatePortResponse", Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/UpdatePortResponse.xsd")]
//    UpdatePortResponseInfo UpdatePort([System.Xml.Serialization.XmlElementAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/UpdatePortRequest.xsd")] UpdatePortRequestInfo UpdatePortRequest);
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.Web.Services.WebServiceBindingAttribute(Name = "UpdateSubscriberProfileSoapHttpBinding", Namespace = "http://csi.cingular.com/CSI/Namespaces/v32/wsdl/CingularWirelessCSI.wsdl")]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(PreviousUsageInfo))]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(UsageInfo))]
//public interface IUpdateSubscriberProfileSoapHttpBinding
//{


//    MessageHeaderInfo MessageHeader
//    {
//        get;
//        set;
//    }

//    /// <remarks/>
//    [System.Web.Services.Protocols.SoapHeaderAttribute("MessageHeader", Direction = System.Web.Services.Protocols.SoapHeaderDirection.InOut)]
//    [System.Web.Services.WebMethodAttribute()]
//    [System.Web.Services.Protocols.SoapDocumentMethodAttribute("", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Bare)]
//    [return: System.Xml.Serialization.XmlElementAttribute("UpdateSubscriberProfileResponse", Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/UpdateSubscriberProfileRe" +
//        "sponse.xsd")]
//    UpdateSubscriberProfileResponseInfo UpdateSubscriberProfile([System.Xml.Serialization.XmlArrayAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/UpdateSubscriberProfileRe" +
//        "quest.xsd")] [System.Xml.Serialization.XmlArrayItemAttribute("Subscriber", IsNullable = false)] UpdateSubscriberProfileRequestInfoSubscriber[] UpdateSubscriberProfileRequest);
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.Web.Services.WebServiceBindingAttribute(Name = "UpgradeEquipmentSoapHttpBinding", Namespace = "http://csi.cingular.com/CSI/Namespaces/v32/wsdl/CingularWirelessCSI.wsdl")]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(PreviousUsageInfo))]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(UsageInfo))]
//public interface IUpgradeEquipmentSoapHttpBinding
//{


//    MessageHeaderInfo MessageHeader
//    {
//        get;
//        set;
//    }

//    /// <remarks/>
//    [System.Web.Services.Protocols.SoapHeaderAttribute("MessageHeader", Direction = System.Web.Services.Protocols.SoapHeaderDirection.InOut)]
//    [System.Web.Services.WebMethodAttribute()]
//    [System.Web.Services.Protocols.SoapDocumentMethodAttribute("", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Bare)]
//    [return: System.Xml.Serialization.XmlElementAttribute("UpgradeEquipmentResponse", Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/UpgradeEquipmentResponse." +
//        "xsd")]
//    UpgradeEquipmentResponseInfo UpgradeEquipment([System.Xml.Serialization.XmlElementAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/UpgradeEquipmentRequest.x" +
//        "sd")] UpgradeEquipmentRequestInfo UpgradeEquipmentRequest);
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.Web.Services.WebServiceBindingAttribute(Name = "ValidateAddressSoapHttpBinding", Namespace = "http://csi.cingular.com/CSI/Namespaces/v32/wsdl/CingularWirelessCSI.wsdl")]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(PreviousUsageInfo))]
//[System.Xml.Serialization.XmlIncludeAttribute(typeof(UsageInfo))]
//public interface IValidateAddressSoapHttpBinding
//{


//    MessageHeaderInfo MessageHeader
//    {
//        get;
//        set;
//    }

//    /// <remarks/>
//    [System.Web.Services.Protocols.SoapHeaderAttribute("MessageHeader", Direction = System.Web.Services.Protocols.SoapHeaderDirection.InOut)]
//    [System.Web.Services.WebMethodAttribute()]
//    [System.Web.Services.Protocols.SoapDocumentMethodAttribute("", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Bare)]
//    [return: System.Xml.Serialization.XmlElementAttribute("ValidateAddressResponse", Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ValidateAddressResponse.x" +
//        "sd")]
//    ValidateAddressResponseInfo ValidateAddress([System.Xml.Serialization.XmlElementAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ValidateAddressRequest.xs" +
//        "d")] ValidateAddressRequestInfo ValidateAddressRequest);
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/MessageHeader.xsd")]
//[System.Xml.Serialization.XmlRootAttribute("MessageHeader", Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/MessageHeader.xsd", IsNullable = false)]
//public partial class MessageHeaderInfo : System.Web.Services.Protocols.SoapHeader
//{

//    private MessageHeaderTracking trackingMessageHeaderField;

//    private MessageHeaderSecurity securityMessageHeaderField;

//    private MessageHeaderSequence sequenceMessageHeaderField;

//    private System.Xml.XmlAttribute[] anyAttrField;

//    /// <remarks/>
//    public MessageHeaderTracking TrackingMessageHeader
//    {
//        get
//        {
//            return this.trackingMessageHeaderField;
//        }
//        set
//        {
//            this.trackingMessageHeaderField = value;
//        }
//    }

//    /// <remarks/>
//    public MessageHeaderSecurity SecurityMessageHeader
//    {
//        get
//        {
//            return this.securityMessageHeaderField;
//        }
//        set
//        {
//            this.securityMessageHeaderField = value;
//        }
//    }

//    /// <remarks/>
//    public MessageHeaderSequence SequenceMessageHeader
//    {
//        get
//        {
//            return this.sequenceMessageHeaderField;
//        }
//        set
//        {
//            this.sequenceMessageHeaderField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlAnyAttributeAttribute()]
//    public System.Xml.XmlAttribute[] AnyAttr
//    {
//        get
//        {
//            return this.anyAttrField;
//        }
//        set
//        {
//            this.anyAttrField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class MessageHeaderTracking
//{

//    private string versionField;

//    private string originalVersionField;

//    private string messageIdField;

//    private string originatorIdField;

//    private string responseToField;

//    private string returnURLField;

//    private string timeToLiveField;

//    private string conversationIdField;

//    private string[] routingRegionOverrideField;

//    private System.DateTime dateTimeStampField;

//    public MessageHeaderTracking()
//    {
//        this.versionField = "v32";
//    }

//    /// <remarks/>
//    public string version
//    {
//        get
//        {
//            return this.versionField;
//        }
//        set
//        {
//            this.versionField = value;
//        }
//    }

//    /// <remarks/>
//    public string originalVersion
//    {
//        get
//        {
//            return this.originalVersionField;
//        }
//        set
//        {
//            this.originalVersionField = value;
//        }
//    }

//    /// <remarks/>
//    public string messageId
//    {
//        get
//        {
//            return this.messageIdField;
//        }
//        set
//        {
//            this.messageIdField = value;
//        }
//    }

//    /// <remarks/>
//    public string originatorId
//    {
//        get
//        {
//            return this.originatorIdField;
//        }
//        set
//        {
//            this.originatorIdField = value;
//        }
//    }

//    /// <remarks/>
//    public string responseTo
//    {
//        get
//        {
//            return this.responseToField;
//        }
//        set
//        {
//            this.responseToField = value;
//        }
//    }

//    /// <remarks/>
//    public string returnURL
//    {
//        get
//        {
//            return this.returnURLField;
//        }
//        set
//        {
//            this.returnURLField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "integer")]
//    public string timeToLive
//    {
//        get
//        {
//            return this.timeToLiveField;
//        }
//        set
//        {
//            this.timeToLiveField = value;
//        }
//    }

//    /// <remarks/>
//    public string conversationId
//    {
//        get
//        {
//            return this.conversationIdField;
//        }
//        set
//        {
//            this.conversationIdField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("routingRegionOverride")]
//    public string[] routingRegionOverride
//    {
//        get
//        {
//            return this.routingRegionOverrideField;
//        }
//        set
//        {
//            this.routingRegionOverrideField = value;
//        }
//    }

//    /// <remarks/>
//    public System.DateTime dateTimeStamp
//    {
//        get
//        {
//            return this.dateTimeStampField;
//        }
//        set
//        {
//            this.dateTimeStampField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class AddressValidationResultInfo
//{

//    private AddressUnrestrictedInfo addressField;

//    private string[] cassAddressField;

//    private string addressMatchCodeField;

//    private string addressMatchDescriptionField;

//    private string addressIdField;

//    private string exchangeCodeField;

//    private bool isAddressExceptionField;

//    private string addressExceptionCodeField;

//    private string addressExceptionDescriptionField;

//    private string crossBoundaryStateField;

//    private long confidenceField;

//    private bool confidenceFieldSpecified;

//    /// <remarks/>
//    public AddressUnrestrictedInfo Address
//    {
//        get
//        {
//            return this.addressField;
//        }
//        set
//        {
//            this.addressField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlArrayItemAttribute("addressLine", IsNullable = false)]
//    public string[] cassAddress
//    {
//        get
//        {
//            return this.cassAddressField;
//        }
//        set
//        {
//            this.cassAddressField = value;
//        }
//    }

//    /// <remarks/>
//    public string addressMatchCode
//    {
//        get
//        {
//            return this.addressMatchCodeField;
//        }
//        set
//        {
//            this.addressMatchCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string addressMatchDescription
//    {
//        get
//        {
//            return this.addressMatchDescriptionField;
//        }
//        set
//        {
//            this.addressMatchDescriptionField = value;
//        }
//    }

//    /// <remarks/>
//    public string addressId
//    {
//        get
//        {
//            return this.addressIdField;
//        }
//        set
//        {
//            this.addressIdField = value;
//        }
//    }

//    /// <remarks/>
//    public string exchangeCode
//    {
//        get
//        {
//            return this.exchangeCodeField;
//        }
//        set
//        {
//            this.exchangeCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public bool isAddressException
//    {
//        get
//        {
//            return this.isAddressExceptionField;
//        }
//        set
//        {
//            this.isAddressExceptionField = value;
//        }
//    }

//    /// <remarks/>
//    public string addressExceptionCode
//    {
//        get
//        {
//            return this.addressExceptionCodeField;
//        }
//        set
//        {
//            this.addressExceptionCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string addressExceptionDescription
//    {
//        get
//        {
//            return this.addressExceptionDescriptionField;
//        }
//        set
//        {
//            this.addressExceptionDescriptionField = value;
//        }
//    }

//    /// <remarks/>
//    public string crossBoundaryState
//    {
//        get
//        {
//            return this.crossBoundaryStateField;
//        }
//        set
//        {
//            this.crossBoundaryStateField = value;
//        }
//    }

//    /// <remarks/>
//    public long confidence
//    {
//        get
//        {
//            return this.confidenceField;
//        }
//        set
//        {
//            this.confidenceField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool confidenceSpecified
//    {
//        get
//        {
//            return this.confidenceFieldSpecified;
//        }
//        set
//        {
//            this.confidenceFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class AddressUnrestrictedInfo
//{

//    private string addressLine1Field;

//    private string addressLine2Field;

//    private AddressStreetUnrestrictedInfo streetField;

//    private AddressAttributeInfo elevationField;

//    private AddressAttributeInfo structureField;

//    private AddressAttributeInfo unitField;

//    private string postOfficeBoxField;

//    private AddressUnrestrictedInfoRuralRoute ruralRouteField;

//    private string cityField;

//    private AddressStateInfo stateField;

//    private bool stateFieldSpecified;

//    private AddressZipInfo zipField;

//    private string countryField;

//    private string countyField;

//    private string countyCodeField;

//    private string urbanizationCodeField;

//    /// <remarks/>
//    public string addressLine1
//    {
//        get
//        {
//            return this.addressLine1Field;
//        }
//        set
//        {
//            this.addressLine1Field = value;
//        }
//    }

//    /// <remarks/>
//    public string addressLine2
//    {
//        get
//        {
//            return this.addressLine2Field;
//        }
//        set
//        {
//            this.addressLine2Field = value;
//        }
//    }

//    /// <remarks/>
//    public AddressStreetUnrestrictedInfo Street
//    {
//        get
//        {
//            return this.streetField;
//        }
//        set
//        {
//            this.streetField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressAttributeInfo Elevation
//    {
//        get
//        {
//            return this.elevationField;
//        }
//        set
//        {
//            this.elevationField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressAttributeInfo Structure
//    {
//        get
//        {
//            return this.structureField;
//        }
//        set
//        {
//            this.structureField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressAttributeInfo Unit
//    {
//        get
//        {
//            return this.unitField;
//        }
//        set
//        {
//            this.unitField = value;
//        }
//    }

//    /// <remarks/>
//    public string postOfficeBox
//    {
//        get
//        {
//            return this.postOfficeBoxField;
//        }
//        set
//        {
//            this.postOfficeBoxField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressUnrestrictedInfoRuralRoute RuralRoute
//    {
//        get
//        {
//            return this.ruralRouteField;
//        }
//        set
//        {
//            this.ruralRouteField = value;
//        }
//    }

//    /// <remarks/>
//    public string city
//    {
//        get
//        {
//            return this.cityField;
//        }
//        set
//        {
//            this.cityField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressStateInfo state
//    {
//        get
//        {
//            return this.stateField;
//        }
//        set
//        {
//            this.stateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool stateSpecified
//    {
//        get
//        {
//            return this.stateFieldSpecified;
//        }
//        set
//        {
//            this.stateFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public AddressZipInfo Zip
//    {
//        get
//        {
//            return this.zipField;
//        }
//        set
//        {
//            this.zipField = value;
//        }
//    }

//    /// <remarks/>
//    public string country
//    {
//        get
//        {
//            return this.countryField;
//        }
//        set
//        {
//            this.countryField = value;
//        }
//    }

//    /// <remarks/>
//    public string county
//    {
//        get
//        {
//            return this.countyField;
//        }
//        set
//        {
//            this.countyField = value;
//        }
//    }

//    /// <remarks/>
//    public string countyCode
//    {
//        get
//        {
//            return this.countyCodeField;
//        }
//        set
//        {
//            this.countyCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string urbanizationCode
//    {
//        get
//        {
//            return this.urbanizationCodeField;
//        }
//        set
//        {
//            this.urbanizationCodeField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class AddressStreetUnrestrictedInfo
//{

//    private string streetNumberPrefixField;

//    private string streetNumberField;

//    private string streetNumberSuffixField;

//    private string streetDirectionField;

//    private string streetNameField;

//    private string streetTypeField;

//    private string streetTrailingDirectionField;

//    private string assignedStreetNumberField;

//    /// <remarks/>
//    public string streetNumberPrefix
//    {
//        get
//        {
//            return this.streetNumberPrefixField;
//        }
//        set
//        {
//            this.streetNumberPrefixField = value;
//        }
//    }

//    /// <remarks/>
//    public string streetNumber
//    {
//        get
//        {
//            return this.streetNumberField;
//        }
//        set
//        {
//            this.streetNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public string streetNumberSuffix
//    {
//        get
//        {
//            return this.streetNumberSuffixField;
//        }
//        set
//        {
//            this.streetNumberSuffixField = value;
//        }
//    }

//    /// <remarks/>
//    public string streetDirection
//    {
//        get
//        {
//            return this.streetDirectionField;
//        }
//        set
//        {
//            this.streetDirectionField = value;
//        }
//    }

//    /// <remarks/>
//    public string streetName
//    {
//        get
//        {
//            return this.streetNameField;
//        }
//        set
//        {
//            this.streetNameField = value;
//        }
//    }

//    /// <remarks/>
//    public string streetType
//    {
//        get
//        {
//            return this.streetTypeField;
//        }
//        set
//        {
//            this.streetTypeField = value;
//        }
//    }

//    /// <remarks/>
//    public string streetTrailingDirection
//    {
//        get
//        {
//            return this.streetTrailingDirectionField;
//        }
//        set
//        {
//            this.streetTrailingDirectionField = value;
//        }
//    }

//    /// <remarks/>
//    public string assignedStreetNumber
//    {
//        get
//        {
//            return this.assignedStreetNumberField;
//        }
//        set
//        {
//            this.assignedStreetNumberField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class AddressAttributeInfo
//{

//    private string typeField;

//    private string valueField;

//    /// <remarks/>
//    public string type
//    {
//        get
//        {
//            return this.typeField;
//        }
//        set
//        {
//            this.typeField = value;
//        }
//    }

//    /// <remarks/>
//    public string value
//    {
//        get
//        {
//            return this.valueField;
//        }
//        set
//        {
//            this.valueField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class AddressUnrestrictedInfoRuralRoute
//{

//    private string ruralRouteCenterNumberField;

//    private string ruralRouteBoxNumberField;

//    /// <remarks/>
//    public string ruralRouteCenterNumber
//    {
//        get
//        {
//            return this.ruralRouteCenterNumberField;
//        }
//        set
//        {
//            this.ruralRouteCenterNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public string ruralRouteBoxNumber
//    {
//        get
//        {
//            return this.ruralRouteBoxNumberField;
//        }
//        set
//        {
//            this.ruralRouteBoxNumberField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum AddressStateInfo
//{

//    /// <remarks/>
//    JA,

//    /// <remarks/>
//    AL,

//    /// <remarks/>
//    AK,

//    /// <remarks/>
//    AZ,

//    /// <remarks/>
//    AR,

//    /// <remarks/>
//    CA,

//    /// <remarks/>
//    CO,

//    /// <remarks/>
//    CT,

//    /// <remarks/>
//    DE,

//    /// <remarks/>
//    DC,

//    /// <remarks/>
//    FL,

//    /// <remarks/>
//    GA,

//    /// <remarks/>
//    HI,

//    /// <remarks/>
//    ID,

//    /// <remarks/>
//    IL,

//    /// <remarks/>
//    IN,

//    /// <remarks/>
//    IA,

//    /// <remarks/>
//    KS,

//    /// <remarks/>
//    KY,

//    /// <remarks/>
//    LA,

//    /// <remarks/>
//    ME,

//    /// <remarks/>
//    MD,

//    /// <remarks/>
//    MA,

//    /// <remarks/>
//    MI,

//    /// <remarks/>
//    MN,

//    /// <remarks/>
//    MS,

//    /// <remarks/>
//    MO,

//    /// <remarks/>
//    MT,

//    /// <remarks/>
//    NE,

//    /// <remarks/>
//    NV,

//    /// <remarks/>
//    NH,

//    /// <remarks/>
//    NJ,

//    /// <remarks/>
//    NM,

//    /// <remarks/>
//    NY,

//    /// <remarks/>
//    NC,

//    /// <remarks/>
//    ND,

//    /// <remarks/>
//    OH,

//    /// <remarks/>
//    OK,

//    /// <remarks/>
//    OR,

//    /// <remarks/>
//    PA,

//    /// <remarks/>
//    RI,

//    /// <remarks/>
//    SC,

//    /// <remarks/>
//    SD,

//    /// <remarks/>
//    TN,

//    /// <remarks/>
//    TX,

//    /// <remarks/>
//    UT,

//    /// <remarks/>
//    VT,

//    /// <remarks/>
//    VA,

//    /// <remarks/>
//    WA,

//    /// <remarks/>
//    WV,

//    /// <remarks/>
//    WI,

//    /// <remarks/>
//    WY,

//    /// <remarks/>
//    AB,

//    /// <remarks/>
//    BC,

//    /// <remarks/>
//    DR,

//    /// <remarks/>
//    MB,

//    /// <remarks/>
//    MX,

//    /// <remarks/>
//    NB,

//    /// <remarks/>
//    NF,

//    /// <remarks/>
//    NS,

//    /// <remarks/>
//    ON,

//    /// <remarks/>
//    PE,

//    /// <remarks/>
//    PQ,

//    /// <remarks/>
//    PR,

//    /// <remarks/>
//    SK,

//    /// <remarks/>
//    VI,

//    /// <remarks/>
//    DF,

//    /// <remarks/>
//    NA,

//    /// <remarks/>
//    GT,

//    /// <remarks/>
//    PU,

//    /// <remarks/>
//    YA,

//    /// <remarks/>
//    SN,

//    /// <remarks/>
//    BA,

//    /// <remarks/>
//    AP,

//    /// <remarks/>
//    CL,

//    /// <remarks/>
//    AA,

//    /// <remarks/>
//    BI,

//    /// <remarks/>
//    PB,

//    /// <remarks/>
//    AG,

//    /// <remarks/>
//    BN,

//    /// <remarks/>
//    CI,

//    /// <remarks/>
//    CP,

//    /// <remarks/>
//    CS,

//    /// <remarks/>
//    DU,

//    /// <remarks/>
//    GJ,

//    /// <remarks/>
//    GR,

//    /// <remarks/>
//    HD,

//    /// <remarks/>
//    HK,

//    /// <remarks/>
//    MC,

//    /// <remarks/>
//    MR,

//    /// <remarks/>
//    NL,

//    /// <remarks/>
//    NZ,

//    /// <remarks/>
//    OX,

//    /// <remarks/>
//    QT,

//    /// <remarks/>
//    QR,

//    /// <remarks/>
//    SL,

//    /// <remarks/>
//    SO,

//    /// <remarks/>
//    TA,

//    /// <remarks/>
//    TB,

//    /// <remarks/>
//    TL,

//    /// <remarks/>
//    VE,

//    /// <remarks/>
//    YC,

//    /// <remarks/>
//    ZA,

//    /// <remarks/>
//    ZZ,

//    /// <remarks/>
//    AE,

//    /// <remarks/>
//    BE,

//    /// <remarks/>
//    YT,

//    /// <remarks/>
//    AS,

//    /// <remarks/>
//    FM,

//    /// <remarks/>
//    GM,

//    /// <remarks/>
//    MH,

//    /// <remarks/>
//    NO,

//    /// <remarks/>
//    PL,

//    /// <remarks/>
//    UM,

//    /// <remarks/>
//    VZ,

//    /// <remarks/>
//    CE,

//    /// <remarks/>
//    CR,

//    /// <remarks/>
//    LM,

//    /// <remarks/>
//    TE,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class AddressZipInfo
//{

//    private string zipCodeField;

//    private string zipCodeExtensionField;

//    private string zipGeoCodeField;

//    /// <remarks/>
//    public string zipCode
//    {
//        get
//        {
//            return this.zipCodeField;
//        }
//        set
//        {
//            this.zipCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string zipCodeExtension
//    {
//        get
//        {
//            return this.zipCodeExtensionField;
//        }
//        set
//        {
//            this.zipCodeExtensionField = value;
//        }
//    }

//    /// <remarks/>
//    public string zipGeoCode
//    {
//        get
//        {
//            return this.zipGeoCodeField;
//        }
//        set
//        {
//            this.zipGeoCodeField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ValidateAddressResponse.x" +
//    "sd")]
//public partial class ValidateAddressResponseInfo
//{

//    private AddressValidationResultInfo[] addressMatchResultField;

//    private bool isMatchedAddressField;

//    private ResponseInfo responseField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("AddressMatchResult")]
//    public AddressValidationResultInfo[] AddressMatchResult
//    {
//        get
//        {
//            return this.addressMatchResultField;
//        }
//        set
//        {
//            this.addressMatchResultField = value;
//        }
//    }

//    /// <remarks/>
//    public bool isMatchedAddress
//    {
//        get
//        {
//            return this.isMatchedAddressField;
//        }
//        set
//        {
//            this.isMatchedAddressField = value;
//        }
//    }

//    /// <remarks/>
//    public ResponseInfo Response
//    {
//        get
//        {
//            return this.responseField;
//        }
//        set
//        {
//            this.responseField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class ResponseInfo
//{

//    private string codeField;

//    private string descriptionField;

//    /// <remarks/>
//    public string code
//    {
//        get
//        {
//            return this.codeField;
//        }
//        set
//        {
//            this.codeField = value;
//        }
//    }

//    /// <remarks/>
//    public string description
//    {
//        get
//        {
//            return this.descriptionField;
//        }
//        set
//        {
//            this.descriptionField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ValidateAddressRequest.xs" +
//    "d")]
//public partial class ValidateAddressRequestInfo
//{

//    private AddressUnrestrictedInfo addressField;

//    private ValidateAddressRequestInfoValidationParameters validationParametersField;

//    private ValidateAddressRequestInfoMode modeField;

//    public ValidateAddressRequestInfo()
//    {
//        this.modeField = ValidateAddressRequestInfoMode.U;
//    }

//    /// <remarks/>
//    public AddressUnrestrictedInfo Address
//    {
//        get
//        {
//            return this.addressField;
//        }
//        set
//        {
//            this.addressField = value;
//        }
//    }

//    /// <remarks/>
//    public ValidateAddressRequestInfoValidationParameters ValidationParameters
//    {
//        get
//        {
//            return this.validationParametersField;
//        }
//        set
//        {
//            this.validationParametersField = value;
//        }
//    }

//    /// <remarks/>
//    public ValidateAddressRequestInfoMode mode
//    {
//        get
//        {
//            return this.modeField;
//        }
//        set
//        {
//            this.modeField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ValidateAddressRequest.xs" +
//    "d")]
//public partial class ValidateAddressRequestInfoValidationParameters
//{

//    private FiberServiceLocationTypeInfo locationTypeField;

//    private int maxBasicAddressAlternativesField;

//    private bool maxBasicAddressAlternativesFieldSpecified;

//    private int maxLivingUnitAlternativesField;

//    private bool maxLivingUnitAlternativesFieldSpecified;

//    private string addressIdField;

//    private string exchangeCodeField;

//    private string crossBoundaryStateField;

//    private bool validateCityStateZipField;

//    private bool validateCityStateZipFieldSpecified;

//    private ValidateAddressRequestInfoValidationParametersFedExServiceType fedExServiceTypeField;

//    private bool fedExServiceTypeFieldSpecified;

//    public ValidateAddressRequestInfoValidationParameters()
//    {
//        this.locationTypeField = FiberServiceLocationTypeInfo.POSTALADDRESS;
//    }

//    /// <remarks/>
//    [System.ComponentModel.DefaultValueAttribute(FiberServiceLocationTypeInfo.POSTALADDRESS)]
//    public FiberServiceLocationTypeInfo locationType
//    {
//        get
//        {
//            return this.locationTypeField;
//        }
//        set
//        {
//            this.locationTypeField = value;
//        }
//    }

//    /// <remarks/>
//    public int maxBasicAddressAlternatives
//    {
//        get
//        {
//            return this.maxBasicAddressAlternativesField;
//        }
//        set
//        {
//            this.maxBasicAddressAlternativesField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool maxBasicAddressAlternativesSpecified
//    {
//        get
//        {
//            return this.maxBasicAddressAlternativesFieldSpecified;
//        }
//        set
//        {
//            this.maxBasicAddressAlternativesFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public int maxLivingUnitAlternatives
//    {
//        get
//        {
//            return this.maxLivingUnitAlternativesField;
//        }
//        set
//        {
//            this.maxLivingUnitAlternativesField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool maxLivingUnitAlternativesSpecified
//    {
//        get
//        {
//            return this.maxLivingUnitAlternativesFieldSpecified;
//        }
//        set
//        {
//            this.maxLivingUnitAlternativesFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public string addressId
//    {
//        get
//        {
//            return this.addressIdField;
//        }
//        set
//        {
//            this.addressIdField = value;
//        }
//    }

//    /// <remarks/>
//    public string exchangeCode
//    {
//        get
//        {
//            return this.exchangeCodeField;
//        }
//        set
//        {
//            this.exchangeCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string crossBoundaryState
//    {
//        get
//        {
//            return this.crossBoundaryStateField;
//        }
//        set
//        {
//            this.crossBoundaryStateField = value;
//        }
//    }

//    /// <remarks/>
//    public bool validateCityStateZip
//    {
//        get
//        {
//            return this.validateCityStateZipField;
//        }
//        set
//        {
//            this.validateCityStateZipField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool validateCityStateZipSpecified
//    {
//        get
//        {
//            return this.validateCityStateZipFieldSpecified;
//        }
//        set
//        {
//            this.validateCityStateZipFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public ValidateAddressRequestInfoValidationParametersFedExServiceType fedExServiceType
//    {
//        get
//        {
//            return this.fedExServiceTypeField;
//        }
//        set
//        {
//            this.fedExServiceTypeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool fedExServiceTypeSpecified
//    {
//        get
//        {
//            return this.fedExServiceTypeFieldSpecified;
//        }
//        set
//        {
//            this.fedExServiceTypeFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum FiberServiceLocationTypeInfo
//{

//    /// <remarks/>
//    POSTALADDRESS,

//    /// <remarks/>
//    E911ADDRESS,

//    /// <remarks/>
//    SERVICEADDRESS,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ValidateAddressRequest.xs" +
//    "d")]
//public enum ValidateAddressRequestInfoValidationParametersFedExServiceType
//{

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("01")]
//    Item01,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("03")]
//    Item03,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("05")]
//    Item05,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("06")]
//    Item06,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("20")]
//    Item20,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("70")]
//    Item70,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("80")]
//    Item80,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("83")]
//    Item83,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("90")]
//    Item90,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("92")]
//    Item92,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("111")]
//    Item111,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ValidateAddressRequest.xs" +
//    "d")]
//public enum ValidateAddressRequestInfoMode
//{

//    /// <remarks/>
//    U,

//    /// <remarks/>
//    L,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/UpgradeEquipmentResponse." +
//    "xsd")]
//public partial class UpgradeEquipmentResponseInfo
//{

//    private ResponseInfo responseField;

//    /// <remarks/>
//    public ResponseInfo Response
//    {
//        get
//        {
//            return this.responseField;
//        }
//        set
//        {
//            this.responseField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class SecuredOfferAuthorizationInfo
//{

//    private string securedOfferReasonCodeField;

//    private string securedOfferReasonNoteField;

//    private string securedOfferUserIdField;

//    /// <remarks/>
//    public string securedOfferReasonCode
//    {
//        get
//        {
//            return this.securedOfferReasonCodeField;
//        }
//        set
//        {
//            this.securedOfferReasonCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string securedOfferReasonNote
//    {
//        get
//        {
//            return this.securedOfferReasonNoteField;
//        }
//        set
//        {
//            this.securedOfferReasonNoteField = value;
//        }
//    }

//    /// <remarks/>
//    public string securedOfferUserId
//    {
//        get
//        {
//            return this.securedOfferUserIdField;
//        }
//        set
//        {
//            this.securedOfferUserIdField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class UpgradeUserInfo
//{

//    private string userIdField;

//    private string overrideIdField;

//    private string overrideOnBehalfOfField;

//    private string completeOnBehalfOfField;

//    private string approverIdField;

//    /// <remarks/>
//    public string userId
//    {
//        get
//        {
//            return this.userIdField;
//        }
//        set
//        {
//            this.userIdField = value;
//        }
//    }

//    /// <remarks/>
//    public string overrideId
//    {
//        get
//        {
//            return this.overrideIdField;
//        }
//        set
//        {
//            this.overrideIdField = value;
//        }
//    }

//    /// <remarks/>
//    public string overrideOnBehalfOf
//    {
//        get
//        {
//            return this.overrideOnBehalfOfField;
//        }
//        set
//        {
//            this.overrideOnBehalfOfField = value;
//        }
//    }

//    /// <remarks/>
//    public string completeOnBehalfOf
//    {
//        get
//        {
//            return this.completeOnBehalfOfField;
//        }
//        set
//        {
//            this.completeOnBehalfOfField = value;
//        }
//    }

//    /// <remarks/>
//    public string approverId
//    {
//        get
//        {
//            return this.approverIdField;
//        }
//        set
//        {
//            this.approverIdField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class DevicePricingInfo
//{

//    private decimal originalSellingPriceField;

//    private bool originalSellingPriceFieldSpecified;

//    private decimal finalSellingPriceField;

//    private bool finalSellingPriceFieldSpecified;

//    /// <remarks/>
//    public decimal originalSellingPrice
//    {
//        get
//        {
//            return this.originalSellingPriceField;
//        }
//        set
//        {
//            this.originalSellingPriceField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool originalSellingPriceSpecified
//    {
//        get
//        {
//            return this.originalSellingPriceFieldSpecified;
//        }
//        set
//        {
//            this.originalSellingPriceFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public decimal finalSellingPrice
//    {
//        get
//        {
//            return this.finalSellingPriceField;
//        }
//        set
//        {
//            this.finalSellingPriceField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool finalSellingPriceSpecified
//    {
//        get
//        {
//            return this.finalSellingPriceFieldSpecified;
//        }
//        set
//        {
//            this.finalSellingPriceFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/UpgradeEquipmentRequest.x" +
//    "sd")]
//public partial class UpgradeEquipmentRequestInfo
//{

//    private MarketAndZipServiceInfo marketServiceInfoField;

//    private UpgradeEquipmentRequestInfoControl controlField;

//    private string billingAccountNumberField;

//    private string newSalesChannelField;

//    private UpgradeEquipmentRequestInfoSubscriber subscriberField;

//    /// <remarks/>
//    public MarketAndZipServiceInfo MarketServiceInfo
//    {
//        get
//        {
//            return this.marketServiceInfoField;
//        }
//        set
//        {
//            this.marketServiceInfoField = value;
//        }
//    }

//    /// <remarks/>
//    public UpgradeEquipmentRequestInfoControl Control
//    {
//        get
//        {
//            return this.controlField;
//        }
//        set
//        {
//            this.controlField = value;
//        }
//    }

//    /// <remarks/>
//    public string billingAccountNumber
//    {
//        get
//        {
//            return this.billingAccountNumberField;
//        }
//        set
//        {
//            this.billingAccountNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public string newSalesChannel
//    {
//        get
//        {
//            return this.newSalesChannelField;
//        }
//        set
//        {
//            this.newSalesChannelField = value;
//        }
//    }

//    /// <remarks/>
//    public UpgradeEquipmentRequestInfoSubscriber Subscriber
//    {
//        get
//        {
//            return this.subscriberField;
//        }
//        set
//        {
//            this.subscriberField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class MarketAndZipServiceInfo
//{

//    private object[] itemsField;

//    private ItemsChoiceType[] itemsElementNameField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("billingMarket", typeof(MarketInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("billingSystemId", typeof(string))]
//    [System.Xml.Serialization.XmlElementAttribute("serviceZipCode", typeof(string))]
//    [System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")]
//    public object[] Items
//    {
//        get
//        {
//            return this.itemsField;
//        }
//        set
//        {
//            this.itemsField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("ItemsElementName")]
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public ItemsChoiceType[] ItemsElementName
//    {
//        get
//        {
//            return this.itemsElementNameField;
//        }
//        set
//        {
//            this.itemsElementNameField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class MarketInfo
//{

//    private string billingMarketField;

//    private string billingSubMarketField;

//    private string localMarketField;

//    /// <remarks/>
//    public string billingMarket
//    {
//        get
//        {
//            return this.billingMarketField;
//        }
//        set
//        {
//            this.billingMarketField = value;
//        }
//    }

//    /// <remarks/>
//    public string billingSubMarket
//    {
//        get
//        {
//            return this.billingSubMarketField;
//        }
//        set
//        {
//            this.billingSubMarketField = value;
//        }
//    }

//    /// <remarks/>
//    public string localMarket
//    {
//        get
//        {
//            return this.localMarketField;
//        }
//        set
//        {
//            this.localMarketField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd", IncludeInSchema = false)]
//public enum ItemsChoiceType
//{

//    /// <remarks/>
//    billingMarket,

//    /// <remarks/>
//    billingSystemId,

//    /// <remarks/>
//    serviceZipCode,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/UpgradeEquipmentRequest.x" +
//    "sd")]
//public partial class UpgradeEquipmentRequestInfoControl
//{

//    private string approvalNumberField;

//    private bool activateUpgradeField;

//    private ParkTypeInfo parkTypeField;

//    public UpgradeEquipmentRequestInfoControl()
//    {
//        this.activateUpgradeField = true;
//        this.parkTypeField = ParkTypeInfo.E;
//    }

//    /// <remarks/>
//    public string approvalNumber
//    {
//        get
//        {
//            return this.approvalNumberField;
//        }
//        set
//        {
//            this.approvalNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public bool activateUpgrade
//    {
//        get
//        {
//            return this.activateUpgradeField;
//        }
//        set
//        {
//            this.activateUpgradeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.ComponentModel.DefaultValueAttribute(ParkTypeInfo.E)]
//    public ParkTypeInfo parkType
//    {
//        get
//        {
//            return this.parkTypeField;
//        }
//        set
//        {
//            this.parkTypeField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum ParkTypeInfo
//{

//    /// <remarks/>
//    A,

//    /// <remarks/>
//    E,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/UpgradeEquipmentRequest.x" +
//    "sd")]
//public partial class UpgradeEquipmentRequestInfoSubscriber
//{

//    private string subscriberNumberField;

//    private UpgradeEquipmentRequestInfoSubscriberContract contractField;

//    private PricePlanInfo pricePlanField;

//    private OfferingsAdditionalInfo[] additionalOfferingsField;

//    private DeviceInfo deviceField;

//    private DevicePricingInfo devicePricingField;

//    private UpgradeQualificationsInfo qualificationField;

//    private UpgradeUserInfo userInfoField;

//    private SecuredOfferAuthorizationInfo securedOfferAuthorizationField;

//    private bool manualEarlyUpgradeIndicatorField;

//    private bool manualEarlyUpgradeIndicatorFieldSpecified;

//    /// <remarks/>
//    public string subscriberNumber
//    {
//        get
//        {
//            return this.subscriberNumberField;
//        }
//        set
//        {
//            this.subscriberNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public UpgradeEquipmentRequestInfoSubscriberContract Contract
//    {
//        get
//        {
//            return this.contractField;
//        }
//        set
//        {
//            this.contractField = value;
//        }
//    }

//    /// <remarks/>
//    public PricePlanInfo PricePlan
//    {
//        get
//        {
//            return this.pricePlanField;
//        }
//        set
//        {
//            this.pricePlanField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("AdditionalOfferings")]
//    public OfferingsAdditionalInfo[] AdditionalOfferings
//    {
//        get
//        {
//            return this.additionalOfferingsField;
//        }
//        set
//        {
//            this.additionalOfferingsField = value;
//        }
//    }

//    /// <remarks/>
//    public DeviceInfo Device
//    {
//        get
//        {
//            return this.deviceField;
//        }
//        set
//        {
//            this.deviceField = value;
//        }
//    }

//    /// <remarks/>
//    public DevicePricingInfo DevicePricing
//    {
//        get
//        {
//            return this.devicePricingField;
//        }
//        set
//        {
//            this.devicePricingField = value;
//        }
//    }

//    /// <remarks/>
//    public UpgradeQualificationsInfo qualification
//    {
//        get
//        {
//            return this.qualificationField;
//        }
//        set
//        {
//            this.qualificationField = value;
//        }
//    }

//    /// <remarks/>
//    public UpgradeUserInfo userInfo
//    {
//        get
//        {
//            return this.userInfoField;
//        }
//        set
//        {
//            this.userInfoField = value;
//        }
//    }

//    /// <remarks/>
//    public SecuredOfferAuthorizationInfo SecuredOfferAuthorization
//    {
//        get
//        {
//            return this.securedOfferAuthorizationField;
//        }
//        set
//        {
//            this.securedOfferAuthorizationField = value;
//        }
//    }

//    /// <remarks/>
//    public bool manualEarlyUpgradeIndicator
//    {
//        get
//        {
//            return this.manualEarlyUpgradeIndicatorField;
//        }
//        set
//        {
//            this.manualEarlyUpgradeIndicatorField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool manualEarlyUpgradeIndicatorSpecified
//    {
//        get
//        {
//            return this.manualEarlyUpgradeIndicatorFieldSpecified;
//        }
//        set
//        {
//            this.manualEarlyUpgradeIndicatorFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/UpgradeEquipmentRequest.x" +
//    "sd")]
//public partial class UpgradeEquipmentRequestInfoSubscriberContract
//{

//    private ContractTermInfo contractTermField;

//    private string contractCodeField;

//    private EquipmentUpgradeContractTypeInfo contractTypeField;

//    private bool contractTypeFieldSpecified;

//    private bool waivePenaltyField;

//    private bool waivePenaltyFieldSpecified;

//    private TermsConditionsStatusInfo termsConditionStatusField;

//    /// <remarks/>
//    public ContractTermInfo ContractTerm
//    {
//        get
//        {
//            return this.contractTermField;
//        }
//        set
//        {
//            this.contractTermField = value;
//        }
//    }

//    /// <remarks/>
//    public string contractCode
//    {
//        get
//        {
//            return this.contractCodeField;
//        }
//        set
//        {
//            this.contractCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public EquipmentUpgradeContractTypeInfo contractType
//    {
//        get
//        {
//            return this.contractTypeField;
//        }
//        set
//        {
//            this.contractTypeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool contractTypeSpecified
//    {
//        get
//        {
//            return this.contractTypeFieldSpecified;
//        }
//        set
//        {
//            this.contractTypeFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool waivePenalty
//    {
//        get
//        {
//            return this.waivePenaltyField;
//        }
//        set
//        {
//            this.waivePenaltyField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool waivePenaltySpecified
//    {
//        get
//        {
//            return this.waivePenaltyFieldSpecified;
//        }
//        set
//        {
//            this.waivePenaltyFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public TermsConditionsStatusInfo termsConditionStatus
//    {
//        get
//        {
//            return this.termsConditionStatusField;
//        }
//        set
//        {
//            this.termsConditionStatusField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class ContractTermInfo
//{

//    private System.DateTime startDateField;

//    private bool startDateFieldSpecified;

//    private int termField;

//    private DealerCommissionInfo commissionField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime startDate
//    {
//        get
//        {
//            return this.startDateField;
//        }
//        set
//        {
//            this.startDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool startDateSpecified
//    {
//        get
//        {
//            return this.startDateFieldSpecified;
//        }
//        set
//        {
//            this.startDateFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public int term
//    {
//        get
//        {
//            return this.termField;
//        }
//        set
//        {
//            this.termField = value;
//        }
//    }

//    /// <remarks/>
//    public DealerCommissionInfo Commission
//    {
//        get
//        {
//            return this.commissionField;
//        }
//        set
//        {
//            this.commissionField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class DealerCommissionInfo
//{

//    private DealerInfo dealerField;

//    private string locationField;

//    private string salesRepresentativeField;

//    private DualCommisionsInfo dualCommissionField;

//    private string affiliateSalesRepCodeField;

//    private string billingTelephoneNumberField;

//    private string customerCodeField;

//    /// <remarks/>
//    public DealerInfo dealer
//    {
//        get
//        {
//            return this.dealerField;
//        }
//        set
//        {
//            this.dealerField = value;
//        }
//    }

//    /// <remarks/>
//    public string location
//    {
//        get
//        {
//            return this.locationField;
//        }
//        set
//        {
//            this.locationField = value;
//        }
//    }

//    /// <remarks/>
//    public string salesRepresentative
//    {
//        get
//        {
//            return this.salesRepresentativeField;
//        }
//        set
//        {
//            this.salesRepresentativeField = value;
//        }
//    }

//    /// <remarks/>
//    public DualCommisionsInfo DualCommission
//    {
//        get
//        {
//            return this.dualCommissionField;
//        }
//        set
//        {
//            this.dualCommissionField = value;
//        }
//    }

//    /// <remarks/>
//    public string affiliateSalesRepCode
//    {
//        get
//        {
//            return this.affiliateSalesRepCodeField;
//        }
//        set
//        {
//            this.affiliateSalesRepCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string billingTelephoneNumber
//    {
//        get
//        {
//            return this.billingTelephoneNumberField;
//        }
//        set
//        {
//            this.billingTelephoneNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public string customerCode
//    {
//        get
//        {
//            return this.customerCodeField;
//        }
//        set
//        {
//            this.customerCodeField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class DealerInfo
//{

//    private string codeField;

//    private string secondaryCodeField;

//    /// <remarks/>
//    public string code
//    {
//        get
//        {
//            return this.codeField;
//        }
//        set
//        {
//            this.codeField = value;
//        }
//    }

//    /// <remarks/>
//    public string secondaryCode
//    {
//        get
//        {
//            return this.secondaryCodeField;
//        }
//        set
//        {
//            this.secondaryCodeField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class DualCommisionsInfo
//{

//    private string creditCheckAgentField;

//    private string creditCheckAgentLocationField;

//    /// <remarks/>
//    public string creditCheckAgent
//    {
//        get
//        {
//            return this.creditCheckAgentField;
//        }
//        set
//        {
//            this.creditCheckAgentField = value;
//        }
//    }

//    /// <remarks/>
//    public string creditCheckAgentLocation
//    {
//        get
//        {
//            return this.creditCheckAgentLocationField;
//        }
//        set
//        {
//            this.creditCheckAgentLocationField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum EquipmentUpgradeContractTypeInfo
//{

//    /// <remarks/>
//    S,

//    /// <remarks/>
//    E,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum TermsConditionsStatusInfo
//{

//    /// <remarks/>
//    B,

//    /// <remarks/>
//    C,

//    /// <remarks/>
//    E,

//    /// <remarks/>
//    I,

//    /// <remarks/>
//    N,

//    /// <remarks/>
//    P,

//    /// <remarks/>
//    S,

//    /// <remarks/>
//    T,

//    /// <remarks/>
//    V,

//    /// <remarks/>
//    W,

//    /// <remarks/>
//    Y,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class PricePlanInfo
//{

//    private object itemField;

//    private decimal recurringChargeField;

//    private bool recurringChargeFieldSpecified;

//    private string descriptionField;

//    private AttributeInfo[] pricePlanAttributesField;

//    private EffectiveDatesInfo effectiveDatesField;

//    private PricePlanTechnologyTypeInfo technologyTypeField;

//    private bool technologyTypeFieldSpecified;

//    private string promotionCodeField;

//    private bool cbDiscountField;

//    private bool cbDiscountFieldSpecified;

//    private bool cbBundeledDiscountField;

//    private bool cbBundeledDiscountFieldSpecified;

//    private SubMarketInfo[] restrictedSubMarketsField;

//    private DealerCommissionInfo commissionField;

//    private OfferingsBundledInfo[] offeringsBundledField;

//    private ActionInfo actionCodeField;

//    private bool actionCodeFieldSpecified;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("groupPlanDetails", typeof(PricePlanGroupDetailsInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("singleUserCode", typeof(string))]
//    public object Item
//    {
//        get
//        {
//            return this.itemField;
//        }
//        set
//        {
//            this.itemField = value;
//        }
//    }

//    /// <remarks/>
//    public decimal recurringCharge
//    {
//        get
//        {
//            return this.recurringChargeField;
//        }
//        set
//        {
//            this.recurringChargeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool recurringChargeSpecified
//    {
//        get
//        {
//            return this.recurringChargeFieldSpecified;
//        }
//        set
//        {
//            this.recurringChargeFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public string description
//    {
//        get
//        {
//            return this.descriptionField;
//        }
//        set
//        {
//            this.descriptionField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("PricePlanAttributes")]
//    public AttributeInfo[] PricePlanAttributes
//    {
//        get
//        {
//            return this.pricePlanAttributesField;
//        }
//        set
//        {
//            this.pricePlanAttributesField = value;
//        }
//    }

//    /// <remarks/>
//    public EffectiveDatesInfo EffectiveDates
//    {
//        get
//        {
//            return this.effectiveDatesField;
//        }
//        set
//        {
//            this.effectiveDatesField = value;
//        }
//    }

//    /// <remarks/>
//    public PricePlanTechnologyTypeInfo technologyType
//    {
//        get
//        {
//            return this.technologyTypeField;
//        }
//        set
//        {
//            this.technologyTypeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool technologyTypeSpecified
//    {
//        get
//        {
//            return this.technologyTypeFieldSpecified;
//        }
//        set
//        {
//            this.technologyTypeFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public string promotionCode
//    {
//        get
//        {
//            return this.promotionCodeField;
//        }
//        set
//        {
//            this.promotionCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public bool cbDiscount
//    {
//        get
//        {
//            return this.cbDiscountField;
//        }
//        set
//        {
//            this.cbDiscountField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool cbDiscountSpecified
//    {
//        get
//        {
//            return this.cbDiscountFieldSpecified;
//        }
//        set
//        {
//            this.cbDiscountFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool cbBundeledDiscount
//    {
//        get
//        {
//            return this.cbBundeledDiscountField;
//        }
//        set
//        {
//            this.cbBundeledDiscountField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool cbBundeledDiscountSpecified
//    {
//        get
//        {
//            return this.cbBundeledDiscountFieldSpecified;
//        }
//        set
//        {
//            this.cbBundeledDiscountFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("RestrictedSubMarkets")]
//    public SubMarketInfo[] RestrictedSubMarkets
//    {
//        get
//        {
//            return this.restrictedSubMarketsField;
//        }
//        set
//        {
//            this.restrictedSubMarketsField = value;
//        }
//    }

//    /// <remarks/>
//    public DealerCommissionInfo Commission
//    {
//        get
//        {
//            return this.commissionField;
//        }
//        set
//        {
//            this.commissionField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("OfferingsBundled")]
//    public OfferingsBundledInfo[] OfferingsBundled
//    {
//        get
//        {
//            return this.offeringsBundledField;
//        }
//        set
//        {
//            this.offeringsBundledField = value;
//        }
//    }

//    /// <remarks/>
//    public ActionInfo actionCode
//    {
//        get
//        {
//            return this.actionCodeField;
//        }
//        set
//        {
//            this.actionCodeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool actionCodeSpecified
//    {
//        get
//        {
//            return this.actionCodeFieldSpecified;
//        }
//        set
//        {
//            this.actionCodeFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class PricePlanGroupDetailsInfo
//{

//    private string groupPlanCodeField;

//    private bool primarySubscriberField;

//    private string itemField;

//    private ItemChoiceType itemElementNameField;

//    private string lineLimitationField;

//    private decimal additionalLineChargeField;

//    private bool additionalLineChargeFieldSpecified;

//    /// <remarks/>
//    public string groupPlanCode
//    {
//        get
//        {
//            return this.groupPlanCodeField;
//        }
//        set
//        {
//            this.groupPlanCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public bool primarySubscriber
//    {
//        get
//        {
//            return this.primarySubscriberField;
//        }
//        set
//        {
//            this.primarySubscriberField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("groupId", typeof(string))]
//    [System.Xml.Serialization.XmlElementAttribute("referenceSubscriber", typeof(string))]
//    [System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemElementName")]
//    public string Item
//    {
//        get
//        {
//            return this.itemField;
//        }
//        set
//        {
//            this.itemField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public ItemChoiceType ItemElementName
//    {
//        get
//        {
//            return this.itemElementNameField;
//        }
//        set
//        {
//            this.itemElementNameField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "integer")]
//    public string lineLimitation
//    {
//        get
//        {
//            return this.lineLimitationField;
//        }
//        set
//        {
//            this.lineLimitationField = value;
//        }
//    }

//    /// <remarks/>
//    public decimal additionalLineCharge
//    {
//        get
//        {
//            return this.additionalLineChargeField;
//        }
//        set
//        {
//            this.additionalLineChargeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool additionalLineChargeSpecified
//    {
//        get
//        {
//            return this.additionalLineChargeFieldSpecified;
//        }
//        set
//        {
//            this.additionalLineChargeFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd", IncludeInSchema = false)]
//public enum ItemChoiceType
//{

//    /// <remarks/>
//    groupId,

//    /// <remarks/>
//    referenceSubscriber,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class AttributeInfo
//{

//    private string attributeNameField;

//    private string attributeValueField;

//    /// <remarks/>
//    public string attributeName
//    {
//        get
//        {
//            return this.attributeNameField;
//        }
//        set
//        {
//            this.attributeNameField = value;
//        }
//    }

//    /// <remarks/>
//    public string attributeValue
//    {
//        get
//        {
//            return this.attributeValueField;
//        }
//        set
//        {
//            this.attributeValueField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class EffectiveDatesInfo
//{

//    private System.DateTime effectiveDateField;

//    private System.DateTime expirationDateField;

//    private bool expirationDateFieldSpecified;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime effectiveDate
//    {
//        get
//        {
//            return this.effectiveDateField;
//        }
//        set
//        {
//            this.effectiveDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime expirationDate
//    {
//        get
//        {
//            return this.expirationDateField;
//        }
//        set
//        {
//            this.expirationDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool expirationDateSpecified
//    {
//        get
//        {
//            return this.expirationDateFieldSpecified;
//        }
//        set
//        {
//            this.expirationDateFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum PricePlanTechnologyTypeInfo
//{

//    /// <remarks/>
//    GSM,

//    /// <remarks/>
//    TDMA,

//    /// <remarks/>
//    BOTH,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class SubMarketInfo
//{

//    private string codeField;

//    private string descriptionField;

//    /// <remarks/>
//    public string code
//    {
//        get
//        {
//            return this.codeField;
//        }
//        set
//        {
//            this.codeField = value;
//        }
//    }

//    /// <remarks/>
//    public string description
//    {
//        get
//        {
//            return this.descriptionField;
//        }
//        set
//        {
//            this.descriptionField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class OfferingsBundledInfo
//{

//    private ActionInfo actionField;

//    private string offeringCodeField;

//    private string offeringNameField;

//    private string offeringDescriptionField;

//    private OfferingFeaturesInfo[] offeringFeaturesField;

//    private ValueAddedParametersInfo valueAddedParametersField;

//    private SplitLiabilityInfo splitLiabilityField;

//    private string genAttributeField;

//    private bool productCategoryIndicatorField;

//    private bool productCategoryIndicatorFieldSpecified;

//    private bool productIMSIndicatorField;

//    private bool productIMSIndicatorFieldSpecified;

//    public OfferingsBundledInfo()
//    {
//        this.actionField = ActionInfo.Q;
//    }

//    /// <remarks/>
//    public ActionInfo action
//    {
//        get
//        {
//            return this.actionField;
//        }
//        set
//        {
//            this.actionField = value;
//        }
//    }

//    /// <remarks/>
//    public string offeringCode
//    {
//        get
//        {
//            return this.offeringCodeField;
//        }
//        set
//        {
//            this.offeringCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string offeringName
//    {
//        get
//        {
//            return this.offeringNameField;
//        }
//        set
//        {
//            this.offeringNameField = value;
//        }
//    }

//    /// <remarks/>
//    public string offeringDescription
//    {
//        get
//        {
//            return this.offeringDescriptionField;
//        }
//        set
//        {
//            this.offeringDescriptionField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("OfferingFeatures")]
//    public OfferingFeaturesInfo[] OfferingFeatures
//    {
//        get
//        {
//            return this.offeringFeaturesField;
//        }
//        set
//        {
//            this.offeringFeaturesField = value;
//        }
//    }

//    /// <remarks/>
//    public ValueAddedParametersInfo ValueAddedParameters
//    {
//        get
//        {
//            return this.valueAddedParametersField;
//        }
//        set
//        {
//            this.valueAddedParametersField = value;
//        }
//    }

//    /// <remarks/>
//    public SplitLiabilityInfo splitLiability
//    {
//        get
//        {
//            return this.splitLiabilityField;
//        }
//        set
//        {
//            this.splitLiabilityField = value;
//        }
//    }

//    /// <remarks/>
//    public string genAttribute
//    {
//        get
//        {
//            return this.genAttributeField;
//        }
//        set
//        {
//            this.genAttributeField = value;
//        }
//    }

//    /// <remarks/>
//    public bool productCategoryIndicator
//    {
//        get
//        {
//            return this.productCategoryIndicatorField;
//        }
//        set
//        {
//            this.productCategoryIndicatorField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool productCategoryIndicatorSpecified
//    {
//        get
//        {
//            return this.productCategoryIndicatorFieldSpecified;
//        }
//        set
//        {
//            this.productCategoryIndicatorFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool productIMSIndicator
//    {
//        get
//        {
//            return this.productIMSIndicatorField;
//        }
//        set
//        {
//            this.productIMSIndicatorField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool productIMSIndicatorSpecified
//    {
//        get
//        {
//            return this.productIMSIndicatorFieldSpecified;
//        }
//        set
//        {
//            this.productIMSIndicatorFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum ActionInfo
//{

//    /// <remarks/>
//    A,

//    /// <remarks/>
//    R,

//    /// <remarks/>
//    Q,

//    /// <remarks/>
//    U,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class OfferingFeaturesInfo
//{

//    private string featureCodeField;

//    private string featureDescriptionField;

//    private DataUsageCategoryInfo dataUsageCategoryField;

//    private bool dataUsageCategoryFieldSpecified;

//    /// <remarks/>
//    public string featureCode
//    {
//        get
//        {
//            return this.featureCodeField;
//        }
//        set
//        {
//            this.featureCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string featureDescription
//    {
//        get
//        {
//            return this.featureDescriptionField;
//        }
//        set
//        {
//            this.featureDescriptionField = value;
//        }
//    }

//    /// <remarks/>
//    public DataUsageCategoryInfo dataUsageCategory
//    {
//        get
//        {
//            return this.dataUsageCategoryField;
//        }
//        set
//        {
//            this.dataUsageCategoryField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool dataUsageCategorySpecified
//    {
//        get
//        {
//            return this.dataUsageCategoryFieldSpecified;
//        }
//        set
//        {
//            this.dataUsageCategoryFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum DataUsageCategoryInfo
//{

//    /// <remarks/>
//    SMS,

//    /// <remarks/>
//    MMS,

//    /// <remarks/>
//    GPRS,

//    /// <remarks/>
//    VSC,

//    /// <remarks/>
//    IMB,

//    /// <remarks/>
//    SMI,

//    /// <remarks/>
//    MMI,

//    /// <remarks/>
//    VXC,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class ValueAddedParametersInfo
//{

//    private object[] itemsField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("DispatchParameters", typeof(DispatchParametersInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("M2XParameters", typeof(M2XParametersInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("PdpParameters", typeof(PdpParametersInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("PriorityAccessServiceParameters", typeof(PriorityAccessServiceParametersInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("ProductAttributes", typeof(AttributeInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("UnifiedMessagingParameters", typeof(UnifiedMessagingParametersInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("auxiliaryServiceParameters", typeof(AuxiliaryServiceParametersInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("emailParameters", typeof(EmailParametersInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("voiceActivatedDialingParameters", typeof(VoiceActivatedDialingParametersInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("voiceMailParameters", typeof(VoiceMailParametersInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("vvpnParameters", typeof(VVPNParametersInfo))]
//    public object[] Items
//    {
//        get
//        {
//            return this.itemsField;
//        }
//        set
//        {
//            this.itemsField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class DispatchParametersInfo
//{

//    private string telephoneNumberField;

//    /// <remarks/>
//    public string telephoneNumber
//    {
//        get
//        {
//            return this.telephoneNumberField;
//        }
//        set
//        {
//            this.telephoneNumberField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class M2XParametersInfo
//{

//    private string telephoneNumberField;

//    /// <remarks/>
//    public string telephoneNumber
//    {
//        get
//        {
//            return this.telephoneNumberField;
//        }
//        set
//        {
//            this.telephoneNumberField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class PdpParametersInfo
//{

//    private string pdpNameField;

//    private string ipAddressField;

//    private bool companyOwnedIpField;

//    private PdpParametersInfoContext contextField;

//    private bool contextFieldSpecified;

//    /// <remarks/>
//    public string pdpName
//    {
//        get
//        {
//            return this.pdpNameField;
//        }
//        set
//        {
//            this.pdpNameField = value;
//        }
//    }

//    /// <remarks/>
//    public string ipAddress
//    {
//        get
//        {
//            return this.ipAddressField;
//        }
//        set
//        {
//            this.ipAddressField = value;
//        }
//    }

//    /// <remarks/>
//    public bool companyOwnedIp
//    {
//        get
//        {
//            return this.companyOwnedIpField;
//        }
//        set
//        {
//            this.companyOwnedIpField = value;
//        }
//    }

//    /// <remarks/>
//    public PdpParametersInfoContext context
//    {
//        get
//        {
//            return this.contextField;
//        }
//        set
//        {
//            this.contextField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool contextSpecified
//    {
//        get
//        {
//            return this.contextFieldSpecified;
//        }
//        set
//        {
//            this.contextFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum PdpParametersInfoContext
//{

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("1")]
//    Item1,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("2")]
//    Item2,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("3")]
//    Item3,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("4")]
//    Item4,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("5")]
//    Item5,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class PriorityAccessServiceParametersInfo
//{

//    private string priorityLevelField;

//    private PriorityAccessServiceSpecialHandlingInfo specialHandlingField;

//    private bool specialHandlingFieldSpecified;

//    /// <remarks/>
//    public string priorityLevel
//    {
//        get
//        {
//            return this.priorityLevelField;
//        }
//        set
//        {
//            this.priorityLevelField = value;
//        }
//    }

//    /// <remarks/>
//    public PriorityAccessServiceSpecialHandlingInfo specialHandling
//    {
//        get
//        {
//            return this.specialHandlingField;
//        }
//        set
//        {
//            this.specialHandlingField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool specialHandlingSpecified
//    {
//        get
//        {
//            return this.specialHandlingFieldSpecified;
//        }
//        set
//        {
//            this.specialHandlingFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum PriorityAccessServiceSpecialHandlingInfo
//{

//    /// <remarks/>
//    B,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class UnifiedMessagingParametersInfo
//{

//    private string mailBoxNumberField;

//    private string voiceMailAccessNumberField;

//    private string callForwardNumberField;

//    /// <remarks/>
//    public string mailBoxNumber
//    {
//        get
//        {
//            return this.mailBoxNumberField;
//        }
//        set
//        {
//            this.mailBoxNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public string voiceMailAccessNumber
//    {
//        get
//        {
//            return this.voiceMailAccessNumberField;
//        }
//        set
//        {
//            this.voiceMailAccessNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public string callForwardNumber
//    {
//        get
//        {
//            return this.callForwardNumberField;
//        }
//        set
//        {
//            this.callForwardNumberField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class AuxiliaryServiceParametersInfo
//{

//    private string associatedSubscriberNumberField;

//    private string serviceAreaField;

//    private ServiceCodeInfo serviceField;

//    private string ldcField;

//    /// <remarks/>
//    public string associatedSubscriberNumber
//    {
//        get
//        {
//            return this.associatedSubscriberNumberField;
//        }
//        set
//        {
//            this.associatedSubscriberNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public string serviceArea
//    {
//        get
//        {
//            return this.serviceAreaField;
//        }
//        set
//        {
//            this.serviceAreaField = value;
//        }
//    }

//    /// <remarks/>
//    public ServiceCodeInfo service
//    {
//        get
//        {
//            return this.serviceField;
//        }
//        set
//        {
//            this.serviceField = value;
//        }
//    }

//    /// <remarks/>
//    public string ldc
//    {
//        get
//        {
//            return this.ldcField;
//        }
//        set
//        {
//            this.ldcField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum ServiceCodeInfo
//{

//    /// <remarks/>
//    GPR,

//    /// <remarks/>
//    ALT,

//    /// <remarks/>
//    DTA,

//    /// <remarks/>
//    FAX,

//    /// <remarks/>
//    FXM,

//    /// <remarks/>
//    WAP,

//    /// <remarks/>
//    PTT,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class EmailParametersInfo
//{

//    private short domainField;

//    private ServiceCodeInfo boxNameField;

//    /// <remarks/>
//    public short domain
//    {
//        get
//        {
//            return this.domainField;
//        }
//        set
//        {
//            this.domainField = value;
//        }
//    }

//    /// <remarks/>
//    public ServiceCodeInfo boxName
//    {
//        get
//        {
//            return this.boxNameField;
//        }
//        set
//        {
//            this.boxNameField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class VoiceActivatedDialingParametersInfo
//{

//    private LanguagePreferenceInfo languageField;

//    private bool shareField;

//    private string telephoneNumberField;

//    private bool numberExistsField;

//    public VoiceActivatedDialingParametersInfo()
//    {
//        this.languageField = LanguagePreferenceInfo.E;
//        this.shareField = false;
//        this.numberExistsField = false;
//    }

//    /// <remarks/>
//    public LanguagePreferenceInfo language
//    {
//        get
//        {
//            return this.languageField;
//        }
//        set
//        {
//            this.languageField = value;
//        }
//    }

//    /// <remarks/>
//    public bool share
//    {
//        get
//        {
//            return this.shareField;
//        }
//        set
//        {
//            this.shareField = value;
//        }
//    }

//    /// <remarks/>
//    public string telephoneNumber
//    {
//        get
//        {
//            return this.telephoneNumberField;
//        }
//        set
//        {
//            this.telephoneNumberField = value;
//        }
//    }

//    /// <remarks/>
//    [System.ComponentModel.DefaultValueAttribute(false)]
//    public bool numberExists
//    {
//        get
//        {
//            return this.numberExistsField;
//        }
//        set
//        {
//            this.numberExistsField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum LanguagePreferenceInfo
//{

//    /// <remarks/>
//    E,

//    /// <remarks/>
//    S,

//    /// <remarks/>
//    N,

//    /// <remarks/>
//    P,

//    /// <remarks/>
//    B,

//    /// <remarks/>
//    L,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class VoiceMailParametersInfo
//{

//    private string forwardNumberField;

//    private LanguagePreferenceInfo languageField;

//    private string pinField;

//    /// <remarks/>
//    public string forwardNumber
//    {
//        get
//        {
//            return this.forwardNumberField;
//        }
//        set
//        {
//            this.forwardNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public LanguagePreferenceInfo language
//    {
//        get
//        {
//            return this.languageField;
//        }
//        set
//        {
//            this.languageField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "nonNegativeInteger")]
//    public string pin
//    {
//        get
//        {
//            return this.pinField;
//        }
//        set
//        {
//            this.pinField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class VVPNParametersInfo
//{

//    private string companyNameField;

//    private string userGroupField;

//    private string dialingCodeField;

//    /// <remarks/>
//    public string companyName
//    {
//        get
//        {
//            return this.companyNameField;
//        }
//        set
//        {
//            this.companyNameField = value;
//        }
//    }

//    /// <remarks/>
//    public string userGroup
//    {
//        get
//        {
//            return this.userGroupField;
//        }
//        set
//        {
//            this.userGroupField = value;
//        }
//    }

//    /// <remarks/>
//    public string dialingCode
//    {
//        get
//        {
//            return this.dialingCodeField;
//        }
//        set
//        {
//            this.dialingCodeField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class SplitLiabilityInfo
//{

//    private string targetAccountNumberField;

//    /// <remarks/>
//    public string targetAccountNumber
//    {
//        get
//        {
//            return this.targetAccountNumberField;
//        }
//        set
//        {
//            this.targetAccountNumberField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class OfferingsAdditionalInfo
//{

//    private ActionInfo actionField;

//    private string offeringCodeField;

//    private string offeringDescriptionField;

//    private DealerCommissionInfo commissionField;

//    private OfferingFeaturesInfo[] offeringFeaturesField;

//    private EffectiveDatesInfo effectiveDatesField;

//    private decimal oneTimeChargeField;

//    private bool oneTimeChargeFieldSpecified;

//    private ValueAddedParametersInfo valueAddedParametersField;

//    private string[] appIdField;

//    private SplitLiabilityInfo splitLiabilityField;

//    private string integrationFeatureIndicatorField;

//    private string transferFeatureIndicatorField;

//    private SwitchParametersInfo switchParametersField;

//    public OfferingsAdditionalInfo()
//    {
//        this.actionField = ActionInfo.Q;
//    }

//    /// <remarks/>
//    public ActionInfo action
//    {
//        get
//        {
//            return this.actionField;
//        }
//        set
//        {
//            this.actionField = value;
//        }
//    }

//    /// <remarks/>
//    public string offeringCode
//    {
//        get
//        {
//            return this.offeringCodeField;
//        }
//        set
//        {
//            this.offeringCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string offeringDescription
//    {
//        get
//        {
//            return this.offeringDescriptionField;
//        }
//        set
//        {
//            this.offeringDescriptionField = value;
//        }
//    }

//    /// <remarks/>
//    public DealerCommissionInfo Commission
//    {
//        get
//        {
//            return this.commissionField;
//        }
//        set
//        {
//            this.commissionField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("OfferingFeatures")]
//    public OfferingFeaturesInfo[] OfferingFeatures
//    {
//        get
//        {
//            return this.offeringFeaturesField;
//        }
//        set
//        {
//            this.offeringFeaturesField = value;
//        }
//    }

//    /// <remarks/>
//    public EffectiveDatesInfo EffectiveDates
//    {
//        get
//        {
//            return this.effectiveDatesField;
//        }
//        set
//        {
//            this.effectiveDatesField = value;
//        }
//    }

//    /// <remarks/>
//    public decimal oneTimeCharge
//    {
//        get
//        {
//            return this.oneTimeChargeField;
//        }
//        set
//        {
//            this.oneTimeChargeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool oneTimeChargeSpecified
//    {
//        get
//        {
//            return this.oneTimeChargeFieldSpecified;
//        }
//        set
//        {
//            this.oneTimeChargeFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public ValueAddedParametersInfo ValueAddedParameters
//    {
//        get
//        {
//            return this.valueAddedParametersField;
//        }
//        set
//        {
//            this.valueAddedParametersField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("appId")]
//    public string[] appId
//    {
//        get
//        {
//            return this.appIdField;
//        }
//        set
//        {
//            this.appIdField = value;
//        }
//    }

//    /// <remarks/>
//    public SplitLiabilityInfo splitLiability
//    {
//        get
//        {
//            return this.splitLiabilityField;
//        }
//        set
//        {
//            this.splitLiabilityField = value;
//        }
//    }

//    /// <remarks/>
//    public string integrationFeatureIndicator
//    {
//        get
//        {
//            return this.integrationFeatureIndicatorField;
//        }
//        set
//        {
//            this.integrationFeatureIndicatorField = value;
//        }
//    }

//    /// <remarks/>
//    public string transferFeatureIndicator
//    {
//        get
//        {
//            return this.transferFeatureIndicatorField;
//        }
//        set
//        {
//            this.transferFeatureIndicatorField = value;
//        }
//    }

//    /// <remarks/>
//    public SwitchParametersInfo SwitchParameters
//    {
//        get
//        {
//            return this.switchParametersField;
//        }
//        set
//        {
//            this.switchParametersField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class SwitchParametersInfo
//{

//    private string salesCodeField;

//    private string callForwardNumberField;

//    private string mailboxNumberField;

//    private string voicemailAccessNumberField;

//    /// <remarks/>
//    public string salesCode
//    {
//        get
//        {
//            return this.salesCodeField;
//        }
//        set
//        {
//            this.salesCodeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "token")]
//    public string callForwardNumber
//    {
//        get
//        {
//            return this.callForwardNumberField;
//        }
//        set
//        {
//            this.callForwardNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public string mailboxNumber
//    {
//        get
//        {
//            return this.mailboxNumberField;
//        }
//        set
//        {
//            this.mailboxNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public string voicemailAccessNumber
//    {
//        get
//        {
//            return this.voicemailAccessNumberField;
//        }
//        set
//        {
//            this.voicemailAccessNumberField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class DeviceInfo
//{

//    private EquipmentTypeInfo equipmentTypeField;

//    private TechnologyTypeInfo technologyTypeField;

//    private string iMSIField;

//    private string iMEIField;

//    private string iMEITypeField;

//    private string iMEIFrequencyField;

//    private string sIMField;

//    private string eSNField;

//    private string mSIDField;

//    private string mINField;

//    private ManufacturerInfo manufacturerField;

//    private bool umtsCapabilityField;

//    private bool umtsCapabilityFieldSpecified;

//    /// <remarks/>
//    public EquipmentTypeInfo equipmentType
//    {
//        get
//        {
//            return this.equipmentTypeField;
//        }
//        set
//        {
//            this.equipmentTypeField = value;
//        }
//    }

//    /// <remarks/>
//    public TechnologyTypeInfo technologyType
//    {
//        get
//        {
//            return this.technologyTypeField;
//        }
//        set
//        {
//            this.technologyTypeField = value;
//        }
//    }

//    /// <remarks/>
//    public string IMSI
//    {
//        get
//        {
//            return this.iMSIField;
//        }
//        set
//        {
//            this.iMSIField = value;
//        }
//    }

//    /// <remarks/>
//    public string IMEI
//    {
//        get
//        {
//            return this.iMEIField;
//        }
//        set
//        {
//            this.iMEIField = value;
//        }
//    }

//    /// <remarks/>
//    public string IMEIType
//    {
//        get
//        {
//            return this.iMEITypeField;
//        }
//        set
//        {
//            this.iMEITypeField = value;
//        }
//    }

//    /// <remarks/>
//    public string IMEIFrequency
//    {
//        get
//        {
//            return this.iMEIFrequencyField;
//        }
//        set
//        {
//            this.iMEIFrequencyField = value;
//        }
//    }

//    /// <remarks/>
//    public string SIM
//    {
//        get
//        {
//            return this.sIMField;
//        }
//        set
//        {
//            this.sIMField = value;
//        }
//    }

//    /// <remarks/>
//    public string ESN
//    {
//        get
//        {
//            return this.eSNField;
//        }
//        set
//        {
//            this.eSNField = value;
//        }
//    }

//    /// <remarks/>
//    public string MSID
//    {
//        get
//        {
//            return this.mSIDField;
//        }
//        set
//        {
//            this.mSIDField = value;
//        }
//    }

//    /// <remarks/>
//    public string MIN
//    {
//        get
//        {
//            return this.mINField;
//        }
//        set
//        {
//            this.mINField = value;
//        }
//    }

//    /// <remarks/>
//    public ManufacturerInfo Manufacturer
//    {
//        get
//        {
//            return this.manufacturerField;
//        }
//        set
//        {
//            this.manufacturerField = value;
//        }
//    }

//    /// <remarks/>
//    public bool umtsCapability
//    {
//        get
//        {
//            return this.umtsCapabilityField;
//        }
//        set
//        {
//            this.umtsCapabilityField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool umtsCapabilitySpecified
//    {
//        get
//        {
//            return this.umtsCapabilityFieldSpecified;
//        }
//        set
//        {
//            this.umtsCapabilityFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum EquipmentTypeInfo
//{

//    /// <remarks/>
//    C,

//    /// <remarks/>
//    G,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum TechnologyTypeInfo
//{

//    /// <remarks/>
//    GSM,

//    /// <remarks/>
//    TDMA,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("GSM-GAIT")]
//    GSMGAIT,

//    /// <remarks/>
//    GAIT,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("TDMA-GAIT")]
//    TDMAGAIT,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("GSM-UMTS")]
//    GSMUMTS,

//    /// <remarks/>
//    UMTS,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class ManufacturerInfo
//{

//    private string makeField;

//    private string modelField;

//    /// <remarks/>
//    public string make
//    {
//        get
//        {
//            return this.makeField;
//        }
//        set
//        {
//            this.makeField = value;
//        }
//    }

//    /// <remarks/>
//    public string model
//    {
//        get
//        {
//            return this.modelField;
//        }
//        set
//        {
//            this.modelField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class UpgradeQualificationsInfo
//{

//    private string qualificationLevelField;

//    private QualificationTypeInfo qualificationTypeField;

//    private bool qualificationTypeFieldSpecified;

//    private decimal minimumMRCField;

//    private bool minimumMRCFieldSpecified;

//    private decimal maximumMRCField;

//    private bool maximumMRCFieldSpecified;

//    private decimal discountAmountField;

//    private bool discountAmountFieldSpecified;

//    private bool waiveUpgradeFeeField;

//    private bool waiveUpgradeFeeFieldSpecified;

//    private string qualificationMessageField;

//    private int minimumCommitmentField;

//    private bool minimumCommitmentFieldSpecified;

//    private string policyCategoryField;

//    private string deviceTypeField;

//    private string discountUOMField;

//    private string priceListField;

//    private string eligibilityResultField;

//    private string reasonCodeField;

//    public UpgradeQualificationsInfo()
//    {
//        this.policyCategoryField = "C";
//        this.deviceTypeField = "N";
//    }

//    /// <remarks/>
//    public string qualificationLevel
//    {
//        get
//        {
//            return this.qualificationLevelField;
//        }
//        set
//        {
//            this.qualificationLevelField = value;
//        }
//    }

//    /// <remarks/>
//    public QualificationTypeInfo qualificationType
//    {
//        get
//        {
//            return this.qualificationTypeField;
//        }
//        set
//        {
//            this.qualificationTypeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool qualificationTypeSpecified
//    {
//        get
//        {
//            return this.qualificationTypeFieldSpecified;
//        }
//        set
//        {
//            this.qualificationTypeFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public decimal minimumMRC
//    {
//        get
//        {
//            return this.minimumMRCField;
//        }
//        set
//        {
//            this.minimumMRCField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool minimumMRCSpecified
//    {
//        get
//        {
//            return this.minimumMRCFieldSpecified;
//        }
//        set
//        {
//            this.minimumMRCFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public decimal maximumMRC
//    {
//        get
//        {
//            return this.maximumMRCField;
//        }
//        set
//        {
//            this.maximumMRCField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool maximumMRCSpecified
//    {
//        get
//        {
//            return this.maximumMRCFieldSpecified;
//        }
//        set
//        {
//            this.maximumMRCFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public decimal discountAmount
//    {
//        get
//        {
//            return this.discountAmountField;
//        }
//        set
//        {
//            this.discountAmountField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool discountAmountSpecified
//    {
//        get
//        {
//            return this.discountAmountFieldSpecified;
//        }
//        set
//        {
//            this.discountAmountFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool waiveUpgradeFee
//    {
//        get
//        {
//            return this.waiveUpgradeFeeField;
//        }
//        set
//        {
//            this.waiveUpgradeFeeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool waiveUpgradeFeeSpecified
//    {
//        get
//        {
//            return this.waiveUpgradeFeeFieldSpecified;
//        }
//        set
//        {
//            this.waiveUpgradeFeeFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public string qualificationMessage
//    {
//        get
//        {
//            return this.qualificationMessageField;
//        }
//        set
//        {
//            this.qualificationMessageField = value;
//        }
//    }

//    /// <remarks/>
//    public int minimumCommitment
//    {
//        get
//        {
//            return this.minimumCommitmentField;
//        }
//        set
//        {
//            this.minimumCommitmentField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool minimumCommitmentSpecified
//    {
//        get
//        {
//            return this.minimumCommitmentFieldSpecified;
//        }
//        set
//        {
//            this.minimumCommitmentFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    [System.ComponentModel.DefaultValueAttribute("C")]
//    public string policyCategory
//    {
//        get
//        {
//            return this.policyCategoryField;
//        }
//        set
//        {
//            this.policyCategoryField = value;
//        }
//    }

//    /// <remarks/>
//    [System.ComponentModel.DefaultValueAttribute("N")]
//    public string deviceType
//    {
//        get
//        {
//            return this.deviceTypeField;
//        }
//        set
//        {
//            this.deviceTypeField = value;
//        }
//    }

//    /// <remarks/>
//    public string discountUOM
//    {
//        get
//        {
//            return this.discountUOMField;
//        }
//        set
//        {
//            this.discountUOMField = value;
//        }
//    }

//    /// <remarks/>
//    public string priceList
//    {
//        get
//        {
//            return this.priceListField;
//        }
//        set
//        {
//            this.priceListField = value;
//        }
//    }

//    /// <remarks/>
//    public string eligibilityResult
//    {
//        get
//        {
//            return this.eligibilityResultField;
//        }
//        set
//        {
//            this.eligibilityResultField = value;
//        }
//    }

//    /// <remarks/>
//    public string reasonCode
//    {
//        get
//        {
//            return this.reasonCodeField;
//        }
//        set
//        {
//            this.reasonCodeField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum QualificationTypeInfo
//{

//    /// <remarks/>
//    B,

//    /// <remarks/>
//    S,

//    /// <remarks/>
//    O,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/UpdateSubscriberProfileRe" +
//    "sponse.xsd")]
//public partial class UpdateSubscriberProfileResponseInfo
//{

//    private UpdateSubscriberProfileResponseInfoSubscriber[] subscriberField;

//    private ResponseInfo responseField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("Subscriber")]
//    public UpdateSubscriberProfileResponseInfoSubscriber[] Subscriber
//    {
//        get
//        {
//            return this.subscriberField;
//        }
//        set
//        {
//            this.subscriberField = value;
//        }
//    }

//    /// <remarks/>
//    public ResponseInfo Response
//    {
//        get
//        {
//            return this.responseField;
//        }
//        set
//        {
//            this.responseField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/UpdateSubscriberProfileRe" +
//    "sponse.xsd")]
//public partial class UpdateSubscriberProfileResponseInfoSubscriber
//{

//    private string subscriberNumberField;

//    private ResponseInfo responseField;

//    /// <remarks/>
//    public string subscriberNumber
//    {
//        get
//        {
//            return this.subscriberNumberField;
//        }
//        set
//        {
//            this.subscriberNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public ResponseInfo Response
//    {
//        get
//        {
//            return this.responseField;
//        }
//        set
//        {
//            this.responseField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class RestrictedPricePlanInfo
//{

//    private object itemField;

//    private decimal recurringChargeField;

//    private bool recurringChargeFieldSpecified;

//    private string descriptionField;

//    private EffectiveDatesInfo effectiveDatesField;

//    private string promotionCodeField;

//    private DealerCommissionInfo commissionField;

//    private OfferingsBundledInfo[] offeringsBundledField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("groupPlanDetails", typeof(PricePlanGroupDetailsInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("singleUserCode", typeof(string))]
//    public object Item
//    {
//        get
//        {
//            return this.itemField;
//        }
//        set
//        {
//            this.itemField = value;
//        }
//    }

//    /// <remarks/>
//    public decimal recurringCharge
//    {
//        get
//        {
//            return this.recurringChargeField;
//        }
//        set
//        {
//            this.recurringChargeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool recurringChargeSpecified
//    {
//        get
//        {
//            return this.recurringChargeFieldSpecified;
//        }
//        set
//        {
//            this.recurringChargeFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public string description
//    {
//        get
//        {
//            return this.descriptionField;
//        }
//        set
//        {
//            this.descriptionField = value;
//        }
//    }

//    /// <remarks/>
//    public EffectiveDatesInfo EffectiveDates
//    {
//        get
//        {
//            return this.effectiveDatesField;
//        }
//        set
//        {
//            this.effectiveDatesField = value;
//        }
//    }

//    /// <remarks/>
//    public string promotionCode
//    {
//        get
//        {
//            return this.promotionCodeField;
//        }
//        set
//        {
//            this.promotionCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public DealerCommissionInfo Commission
//    {
//        get
//        {
//            return this.commissionField;
//        }
//        set
//        {
//            this.commissionField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("OfferingsBundled")]
//    public OfferingsBundledInfo[] OfferingsBundled
//    {
//        get
//        {
//            return this.offeringsBundledField;
//        }
//        set
//        {
//            this.offeringsBundledField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/UpdatePortResponse.xsd")]
//public partial class UpdatePortResponseInfo
//{

//    private object itemField;

//    private PortRequestStatusInfo portRequestStatusField;

//    private ResponseInfo responseField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("PortingLocator", typeof(PortingLocatorInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("subscriberNumber", typeof(string))]
//    public object Item
//    {
//        get
//        {
//            return this.itemField;
//        }
//        set
//        {
//            this.itemField = value;
//        }
//    }

//    /// <remarks/>
//    public PortRequestStatusInfo PortRequestStatus
//    {
//        get
//        {
//            return this.portRequestStatusField;
//        }
//        set
//        {
//            this.portRequestStatusField = value;
//        }
//    }

//    /// <remarks/>
//    public ResponseInfo Response
//    {
//        get
//        {
//            return this.responseField;
//        }
//        set
//        {
//            this.responseField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class PortingLocatorInfo
//{

//    private string portRequestNumberField;

//    private string portRequestVersionField;

//    private string teleportPortRecordIdField;

//    /// <remarks/>
//    public string portRequestNumber
//    {
//        get
//        {
//            return this.portRequestNumberField;
//        }
//        set
//        {
//            this.portRequestNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public string portRequestVersion
//    {
//        get
//        {
//            return this.portRequestVersionField;
//        }
//        set
//        {
//            this.portRequestVersionField = value;
//        }
//    }

//    /// <remarks/>
//    public string teleportPortRecordId
//    {
//        get
//        {
//            return this.teleportPortRecordIdField;
//        }
//        set
//        {
//            this.teleportPortRecordIdField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum PortRequestStatusInfo
//{

//    /// <remarks/>
//    OP,

//    /// <remarks/>
//    CN,

//    /// <remarks/>
//    CT,

//    /// <remarks/>
//    CF,

//    /// <remarks/>
//    DN,

//    /// <remarks/>
//    ER,

//    /// <remarks/>
//    CO,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class UpdatePortLineInfo
//{

//    private long portRequestLineIdField;

//    private string npaNxxField;

//    private string fromLineField;

//    private string toLineField;

//    private EquipmentTypeInfo equipmentTypeField;

//    private string fulfillmentOrderIdField;

//    private string serviceAreaField;

//    private UpdatePortLineInfoReplaceDeleteFromPortRequest replaceDeleteFromPortRequestField;

//    private bool replaceDeleteFromPortRequestFieldSpecified;

//    private string cingularReplacementSubscriberNumberField;

//    /// <remarks/>
//    public long portRequestLineId
//    {
//        get
//        {
//            return this.portRequestLineIdField;
//        }
//        set
//        {
//            this.portRequestLineIdField = value;
//        }
//    }

//    /// <remarks/>
//    public string npaNxx
//    {
//        get
//        {
//            return this.npaNxxField;
//        }
//        set
//        {
//            this.npaNxxField = value;
//        }
//    }

//    /// <remarks/>
//    public string fromLine
//    {
//        get
//        {
//            return this.fromLineField;
//        }
//        set
//        {
//            this.fromLineField = value;
//        }
//    }

//    /// <remarks/>
//    public string toLine
//    {
//        get
//        {
//            return this.toLineField;
//        }
//        set
//        {
//            this.toLineField = value;
//        }
//    }

//    /// <remarks/>
//    public EquipmentTypeInfo equipmentType
//    {
//        get
//        {
//            return this.equipmentTypeField;
//        }
//        set
//        {
//            this.equipmentTypeField = value;
//        }
//    }

//    /// <remarks/>
//    public string fulfillmentOrderId
//    {
//        get
//        {
//            return this.fulfillmentOrderIdField;
//        }
//        set
//        {
//            this.fulfillmentOrderIdField = value;
//        }
//    }

//    /// <remarks/>
//    public string serviceArea
//    {
//        get
//        {
//            return this.serviceAreaField;
//        }
//        set
//        {
//            this.serviceAreaField = value;
//        }
//    }

//    /// <remarks/>
//    public UpdatePortLineInfoReplaceDeleteFromPortRequest replaceDeleteFromPortRequest
//    {
//        get
//        {
//            return this.replaceDeleteFromPortRequestField;
//        }
//        set
//        {
//            this.replaceDeleteFromPortRequestField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool replaceDeleteFromPortRequestSpecified
//    {
//        get
//        {
//            return this.replaceDeleteFromPortRequestFieldSpecified;
//        }
//        set
//        {
//            this.replaceDeleteFromPortRequestFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public string cingularReplacementSubscriberNumber
//    {
//        get
//        {
//            return this.cingularReplacementSubscriberNumberField;
//        }
//        set
//        {
//            this.cingularReplacementSubscriberNumberField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum UpdatePortLineInfoReplaceDeleteFromPortRequest
//{

//    /// <remarks/>
//    R,

//    /// <remarks/>
//    D,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/UpdatePortRequest.xsd")]
//public partial class UpdatePortRequestInfo
//{

//    private MarketAndZipServiceInfo marketServiceInfoField;

//    private PortSelectorInfo portingSelectorField;

//    private DealerCommissionInfo commissionField;

//    private UpdatePortRequestInfoCustomer customerField;

//    private PortRequestInfo portRequestField;

//    private UpdatePortLineInfo[] portRequestLineField;

//    /// <remarks/>
//    public MarketAndZipServiceInfo MarketServiceInfo
//    {
//        get
//        {
//            return this.marketServiceInfoField;
//        }
//        set
//        {
//            this.marketServiceInfoField = value;
//        }
//    }

//    /// <remarks/>
//    public PortSelectorInfo PortingSelector
//    {
//        get
//        {
//            return this.portingSelectorField;
//        }
//        set
//        {
//            this.portingSelectorField = value;
//        }
//    }

//    /// <remarks/>
//    public DealerCommissionInfo Commission
//    {
//        get
//        {
//            return this.commissionField;
//        }
//        set
//        {
//            this.commissionField = value;
//        }
//    }

//    /// <remarks/>
//    public UpdatePortRequestInfoCustomer Customer
//    {
//        get
//        {
//            return this.customerField;
//        }
//        set
//        {
//            this.customerField = value;
//        }
//    }

//    /// <remarks/>
//    public PortRequestInfo PortRequest
//    {
//        get
//        {
//            return this.portRequestField;
//        }
//        set
//        {
//            this.portRequestField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("PortRequestLine")]
//    public UpdatePortLineInfo[] PortRequestLine
//    {
//        get
//        {
//            return this.portRequestLineField;
//        }
//        set
//        {
//            this.portRequestLineField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class PortSelectorInfo
//{

//    private object itemField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("PortingLocator", typeof(PortingLocatorInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("SubscriberNumber", typeof(string))]
//    public object Item
//    {
//        get
//        {
//            return this.itemField;
//        }
//        set
//        {
//            this.itemField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/UpdatePortRequest.xsd")]
//public partial class UpdatePortRequestInfoCustomer
//{

//    private object itemField;

//    private UpdatePortRequestInfoCustomerAddress addressField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("BusinessName", typeof(NameBusinessInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("Name", typeof(NameInfo))]
//    public object Item
//    {
//        get
//        {
//            return this.itemField;
//        }
//        set
//        {
//            this.itemField = value;
//        }
//    }

//    /// <remarks/>
//    public UpdatePortRequestInfoCustomerAddress Address
//    {
//        get
//        {
//            return this.addressField;
//        }
//        set
//        {
//            this.addressField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class NameBusinessInfo
//{

//    private string businessNameField;

//    private NameInfo contactField;

//    /// <remarks/>
//    public string businessName
//    {
//        get
//        {
//            return this.businessNameField;
//        }
//        set
//        {
//            this.businessNameField = value;
//        }
//    }

//    /// <remarks/>
//    public NameInfo contact
//    {
//        get
//        {
//            return this.contactField;
//        }
//        set
//        {
//            this.contactField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class NameInfo
//{

//    private string namePrefixField;

//    private string firstNameField;

//    private string middleNameField;

//    private string lastNameField;

//    private string nameSuffixField;

//    private string additionalTitleField;

//    /// <remarks/>
//    public string namePrefix
//    {
//        get
//        {
//            return this.namePrefixField;
//        }
//        set
//        {
//            this.namePrefixField = value;
//        }
//    }

//    /// <remarks/>
//    public string firstName
//    {
//        get
//        {
//            return this.firstNameField;
//        }
//        set
//        {
//            this.firstNameField = value;
//        }
//    }

//    /// <remarks/>
//    public string middleName
//    {
//        get
//        {
//            return this.middleNameField;
//        }
//        set
//        {
//            this.middleNameField = value;
//        }
//    }

//    /// <remarks/>
//    public string lastName
//    {
//        get
//        {
//            return this.lastNameField;
//        }
//        set
//        {
//            this.lastNameField = value;
//        }
//    }

//    /// <remarks/>
//    public string nameSuffix
//    {
//        get
//        {
//            return this.nameSuffixField;
//        }
//        set
//        {
//            this.nameSuffixField = value;
//        }
//    }

//    /// <remarks/>
//    public string additionalTitle
//    {
//        get
//        {
//            return this.additionalTitleField;
//        }
//        set
//        {
//            this.additionalTitleField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/UpdatePortRequest.xsd")]
//public partial class UpdatePortRequestInfoCustomerAddress
//{

//    private UnitInfo unitField;

//    private AddressStreetInfo streetField;

//    private string postOfficeBoxField;

//    private AddressRuralRouteInfo ruralRouteField;

//    private string cityField;

//    private AddressStateInfo stateField;

//    private string countryField;

//    private AddressZipInfo zipField;

//    /// <remarks/>
//    public UnitInfo Unit
//    {
//        get
//        {
//            return this.unitField;
//        }
//        set
//        {
//            this.unitField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressStreetInfo Street
//    {
//        get
//        {
//            return this.streetField;
//        }
//        set
//        {
//            this.streetField = value;
//        }
//    }

//    /// <remarks/>
//    public string PostOfficeBox
//    {
//        get
//        {
//            return this.postOfficeBoxField;
//        }
//        set
//        {
//            this.postOfficeBoxField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressRuralRouteInfo RuralRoute
//    {
//        get
//        {
//            return this.ruralRouteField;
//        }
//        set
//        {
//            this.ruralRouteField = value;
//        }
//    }

//    /// <remarks/>
//    public string City
//    {
//        get
//        {
//            return this.cityField;
//        }
//        set
//        {
//            this.cityField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressStateInfo State
//    {
//        get
//        {
//            return this.stateField;
//        }
//        set
//        {
//            this.stateField = value;
//        }
//    }

//    /// <remarks/>
//    public string Country
//    {
//        get
//        {
//            return this.countryField;
//        }
//        set
//        {
//            this.countryField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressZipInfo Zip
//    {
//        get
//        {
//            return this.zipField;
//        }
//        set
//        {
//            this.zipField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class UnitInfo
//{

//    private string unitNumberField;

//    private UnitInfoUnitDesignator unitDesignatorField;

//    /// <remarks/>
//    public string unitNumber
//    {
//        get
//        {
//            return this.unitNumberField;
//        }
//        set
//        {
//            this.unitNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public UnitInfoUnitDesignator unitDesignator
//    {
//        get
//        {
//            return this.unitDesignatorField;
//        }
//        set
//        {
//            this.unitDesignatorField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum UnitInfoUnitDesignator
//{

//    /// <remarks/>
//    APT,

//    /// <remarks/>
//    BLDG,

//    /// <remarks/>
//    DEPT,

//    /// <remarks/>
//    FL,

//    /// <remarks/>
//    HNGR,

//    /// <remarks/>
//    LOT,

//    /// <remarks/>
//    PIER,

//    /// <remarks/>
//    RM,

//    /// <remarks/>
//    SLIP,

//    /// <remarks/>
//    STE,

//    /// <remarks/>
//    SPC,

//    /// <remarks/>
//    STOP,

//    /// <remarks/>
//    TRLR,

//    /// <remarks/>
//    UNIT,

//    /// <remarks/>
//    BSMT,

//    /// <remarks/>
//    FRNT,

//    /// <remarks/>
//    OFC,

//    /// <remarks/>
//    PH,

//    /// <remarks/>
//    REAR,

//    /// <remarks/>
//    LOWR,

//    /// <remarks/>
//    LBBY,

//    /// <remarks/>
//    SIDE,

//    /// <remarks/>
//    UPPR,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("#")]
//    Item,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class AddressStreetInfo
//{

//    private string streetNumberField;

//    private AddressStreetInfoStreetDirection streetDirectionField;

//    private bool streetDirectionFieldSpecified;

//    private string streetNameField;

//    private AddressStreetInfoStreetType streetTypeField;

//    private bool streetTypeFieldSpecified;

//    private AddressStreetInfoStreetTrailingDirection streetTrailingDirectionField;

//    private bool streetTrailingDirectionFieldSpecified;

//    /// <remarks/>
//    public string streetNumber
//    {
//        get
//        {
//            return this.streetNumberField;
//        }
//        set
//        {
//            this.streetNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressStreetInfoStreetDirection streetDirection
//    {
//        get
//        {
//            return this.streetDirectionField;
//        }
//        set
//        {
//            this.streetDirectionField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool streetDirectionSpecified
//    {
//        get
//        {
//            return this.streetDirectionFieldSpecified;
//        }
//        set
//        {
//            this.streetDirectionFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public string streetName
//    {
//        get
//        {
//            return this.streetNameField;
//        }
//        set
//        {
//            this.streetNameField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressStreetInfoStreetType streetType
//    {
//        get
//        {
//            return this.streetTypeField;
//        }
//        set
//        {
//            this.streetTypeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool streetTypeSpecified
//    {
//        get
//        {
//            return this.streetTypeFieldSpecified;
//        }
//        set
//        {
//            this.streetTypeFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public AddressStreetInfoStreetTrailingDirection streetTrailingDirection
//    {
//        get
//        {
//            return this.streetTrailingDirectionField;
//        }
//        set
//        {
//            this.streetTrailingDirectionField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool streetTrailingDirectionSpecified
//    {
//        get
//        {
//            return this.streetTrailingDirectionFieldSpecified;
//        }
//        set
//        {
//            this.streetTrailingDirectionFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum AddressStreetInfoStreetDirection
//{

//    /// <remarks/>
//    E,

//    /// <remarks/>
//    N,

//    /// <remarks/>
//    NE,

//    /// <remarks/>
//    NW,

//    /// <remarks/>
//    S,

//    /// <remarks/>
//    SE,

//    /// <remarks/>
//    SW,

//    /// <remarks/>
//    W,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum AddressStreetInfoStreetType
//{

//    /// <remarks/>
//    ALY,

//    /// <remarks/>
//    ANX,

//    /// <remarks/>
//    ARC,

//    /// <remarks/>
//    AVE,

//    /// <remarks/>
//    BCH,

//    /// <remarks/>
//    BG,

//    /// <remarks/>
//    BGS,

//    /// <remarks/>
//    BLF,

//    /// <remarks/>
//    BLFS,

//    /// <remarks/>
//    BLVD,

//    /// <remarks/>
//    BND,

//    /// <remarks/>
//    BR,

//    /// <remarks/>
//    BRG,

//    /// <remarks/>
//    BRK,

//    /// <remarks/>
//    BRKS,

//    /// <remarks/>
//    BTM,

//    /// <remarks/>
//    BYP,

//    /// <remarks/>
//    BYU,

//    /// <remarks/>
//    CIR,

//    /// <remarks/>
//    CIRS,

//    /// <remarks/>
//    CLB,

//    /// <remarks/>
//    CLF,

//    /// <remarks/>
//    CLFS,

//    /// <remarks/>
//    CMN,

//    /// <remarks/>
//    COR,

//    /// <remarks/>
//    CORS,

//    /// <remarks/>
//    CP,

//    /// <remarks/>
//    CPE,

//    /// <remarks/>
//    CRES,

//    /// <remarks/>
//    CRK,

//    /// <remarks/>
//    CRSE,

//    /// <remarks/>
//    CRST,

//    /// <remarks/>
//    CSWY,

//    /// <remarks/>
//    CT,

//    /// <remarks/>
//    CTR,

//    /// <remarks/>
//    CTRS,

//    /// <remarks/>
//    CTS,

//    /// <remarks/>
//    CURV,

//    /// <remarks/>
//    CV,

//    /// <remarks/>
//    CVS,

//    /// <remarks/>
//    CYN,

//    /// <remarks/>
//    DL,

//    /// <remarks/>
//    DM,

//    /// <remarks/>
//    DR,

//    /// <remarks/>
//    DRS,

//    /// <remarks/>
//    DV,

//    /// <remarks/>
//    EST,

//    /// <remarks/>
//    ESTS,

//    /// <remarks/>
//    EXPY,

//    /// <remarks/>
//    EXT,

//    /// <remarks/>
//    EXTS,

//    /// <remarks/>
//    FALL,

//    /// <remarks/>
//    FLD,

//    /// <remarks/>
//    FLDS,

//    /// <remarks/>
//    FLS,

//    /// <remarks/>
//    FLT,

//    /// <remarks/>
//    FLTS,

//    /// <remarks/>
//    FRD,

//    /// <remarks/>
//    FRDS,

//    /// <remarks/>
//    FRG,

//    /// <remarks/>
//    FRGS,

//    /// <remarks/>
//    FRK,

//    /// <remarks/>
//    FRKS,

//    /// <remarks/>
//    FRST,

//    /// <remarks/>
//    FRY,

//    /// <remarks/>
//    FT,

//    /// <remarks/>
//    FWY,

//    /// <remarks/>
//    GDN,

//    /// <remarks/>
//    GDNS,

//    /// <remarks/>
//    GLN,

//    /// <remarks/>
//    GLNS,

//    /// <remarks/>
//    GRN,

//    /// <remarks/>
//    GRNS,

//    /// <remarks/>
//    GRV,

//    /// <remarks/>
//    GRVS,

//    /// <remarks/>
//    GTWY,

//    /// <remarks/>
//    HBR,

//    /// <remarks/>
//    HBRS,

//    /// <remarks/>
//    HCR,

//    /// <remarks/>
//    HL,

//    /// <remarks/>
//    HLS,

//    /// <remarks/>
//    HOLW,

//    /// <remarks/>
//    HTS,

//    /// <remarks/>
//    HVN,

//    /// <remarks/>
//    HWY,

//    /// <remarks/>
//    INLT,

//    /// <remarks/>
//    INST,

//    /// <remarks/>
//    IS,

//    /// <remarks/>
//    ISLE,

//    /// <remarks/>
//    ISS,

//    /// <remarks/>
//    JCT,

//    /// <remarks/>
//    JCTS,

//    /// <remarks/>
//    KNL,

//    /// <remarks/>
//    KNLS,

//    /// <remarks/>
//    KY,

//    /// <remarks/>
//    KYS,

//    /// <remarks/>
//    LAND,

//    /// <remarks/>
//    LCK,

//    /// <remarks/>
//    LCKS,

//    /// <remarks/>
//    LDG,

//    /// <remarks/>
//    LF,

//    /// <remarks/>
//    LGT,

//    /// <remarks/>
//    LGTS,

//    /// <remarks/>
//    LK,

//    /// <remarks/>
//    LKS,

//    /// <remarks/>
//    LN,

//    /// <remarks/>
//    LNDG,

//    /// <remarks/>
//    LOOP,

//    /// <remarks/>
//    MALL,

//    /// <remarks/>
//    MDW,

//    /// <remarks/>
//    MDWS,

//    /// <remarks/>
//    MEWS,

//    /// <remarks/>
//    ML,

//    /// <remarks/>
//    MLS,

//    /// <remarks/>
//    MNR,

//    /// <remarks/>
//    MNRS,

//    /// <remarks/>
//    MSN,

//    /// <remarks/>
//    MT,

//    /// <remarks/>
//    MTN,

//    /// <remarks/>
//    MTNS,

//    /// <remarks/>
//    MTWY,

//    /// <remarks/>
//    NCK,

//    /// <remarks/>
//    OPAS,

//    /// <remarks/>
//    ORCH,

//    /// <remarks/>
//    OVAL,

//    /// <remarks/>
//    PARK,

//    /// <remarks/>
//    PASS,

//    /// <remarks/>
//    PATH,

//    /// <remarks/>
//    PIKE,

//    /// <remarks/>
//    PKWY,

//    /// <remarks/>
//    PL,

//    /// <remarks/>
//    PLN,

//    /// <remarks/>
//    PLNS,

//    /// <remarks/>
//    PLZ,

//    /// <remarks/>
//    PNE,

//    /// <remarks/>
//    PNES,

//    /// <remarks/>
//    PR,

//    /// <remarks/>
//    PRT,

//    /// <remarks/>
//    PRTS,

//    /// <remarks/>
//    PSGE,

//    /// <remarks/>
//    PT,

//    /// <remarks/>
//    PTS,

//    /// <remarks/>
//    RADL,

//    /// <remarks/>
//    RAMP,

//    /// <remarks/>
//    RD,

//    /// <remarks/>
//    RDG,

//    /// <remarks/>
//    RDGS,

//    /// <remarks/>
//    RDS,

//    /// <remarks/>
//    RIV,

//    /// <remarks/>
//    RNCH,

//    /// <remarks/>
//    ROW,

//    /// <remarks/>
//    RPD,

//    /// <remarks/>
//    RPDS,

//    /// <remarks/>
//    RST,

//    /// <remarks/>
//    RTE,

//    /// <remarks/>
//    RUE,

//    /// <remarks/>
//    RUN,

//    /// <remarks/>
//    SHL,

//    /// <remarks/>
//    SHLS,

//    /// <remarks/>
//    SHR,

//    /// <remarks/>
//    SHRS,

//    /// <remarks/>
//    SKWY,

//    /// <remarks/>
//    SMT,

//    /// <remarks/>
//    SPG,

//    /// <remarks/>
//    SPGS,

//    /// <remarks/>
//    SPUR,

//    /// <remarks/>
//    SQ,

//    /// <remarks/>
//    SQS,

//    /// <remarks/>
//    ST,

//    /// <remarks/>
//    STA,

//    /// <remarks/>
//    STRA,

//    /// <remarks/>
//    STRM,

//    /// <remarks/>
//    STS,

//    /// <remarks/>
//    TER,

//    /// <remarks/>
//    TPKE,

//    /// <remarks/>
//    TRAK,

//    /// <remarks/>
//    TRCE,

//    /// <remarks/>
//    TRFY,

//    /// <remarks/>
//    TRL,

//    /// <remarks/>
//    TRLR,

//    /// <remarks/>
//    TRWY,

//    /// <remarks/>
//    TUNL,

//    /// <remarks/>
//    UN,

//    /// <remarks/>
//    UNS,

//    /// <remarks/>
//    UPAS,

//    /// <remarks/>
//    VIA,

//    /// <remarks/>
//    VIS,

//    /// <remarks/>
//    VL,

//    /// <remarks/>
//    VLG,

//    /// <remarks/>
//    VLGS,

//    /// <remarks/>
//    VLY,

//    /// <remarks/>
//    VLYS,

//    /// <remarks/>
//    VW,

//    /// <remarks/>
//    VWS,

//    /// <remarks/>
//    WALK,

//    /// <remarks/>
//    WALL,

//    /// <remarks/>
//    WAY,

//    /// <remarks/>
//    WAYS,

//    /// <remarks/>
//    WL,

//    /// <remarks/>
//    WLS,

//    /// <remarks/>
//    XING,

//    /// <remarks/>
//    XRD,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum AddressStreetInfoStreetTrailingDirection
//{

//    /// <remarks/>
//    E,

//    /// <remarks/>
//    N,

//    /// <remarks/>
//    NE,

//    /// <remarks/>
//    W,

//    /// <remarks/>
//    NW,

//    /// <remarks/>
//    S,

//    /// <remarks/>
//    SE,

//    /// <remarks/>
//    SW,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class AddressRuralRouteInfo
//{

//    private string ruralRouteCenterNumberField;

//    private string ruralRouteBoxNumberField;

//    /// <remarks/>
//    public string ruralRouteCenterNumber
//    {
//        get
//        {
//            return this.ruralRouteCenterNumberField;
//        }
//        set
//        {
//            this.ruralRouteCenterNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public string ruralRouteBoxNumber
//    {
//        get
//        {
//            return this.ruralRouteBoxNumberField;
//        }
//        set
//        {
//            this.ruralRouteBoxNumberField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class PortRequestInfo
//{

//    private string initiatorIdField;

//    private string requestRemarksField;

//    private string totalNumberOfSubscriberNumbersField;

//    private PortDirectionInfo portDirectionField;

//    private string authorizationNameField;

//    private TermsConditionsStatusInfo termsConditionStatusField;

//    private bool termsConditionStatusFieldSpecified;

//    private System.DateTime desiredDueDateField;

//    private bool desiredDueDateFieldSpecified;

//    private ImmediateActInfo immediateActField;

//    private bool immediateActFieldSpecified;

//    private string ospBillingAccountNumberField;

//    private string ospBillingAccountPasswordField;

//    private string itemField;

//    private ItemChoiceType2 itemElementNameField;

//    /// <remarks/>
//    public string initiatorId
//    {
//        get
//        {
//            return this.initiatorIdField;
//        }
//        set
//        {
//            this.initiatorIdField = value;
//        }
//    }

//    /// <remarks/>
//    public string requestRemarks
//    {
//        get
//        {
//            return this.requestRemarksField;
//        }
//        set
//        {
//            this.requestRemarksField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "integer")]
//    public string totalNumberOfSubscriberNumbers
//    {
//        get
//        {
//            return this.totalNumberOfSubscriberNumbersField;
//        }
//        set
//        {
//            this.totalNumberOfSubscriberNumbersField = value;
//        }
//    }

//    /// <remarks/>
//    public PortDirectionInfo portDirection
//    {
//        get
//        {
//            return this.portDirectionField;
//        }
//        set
//        {
//            this.portDirectionField = value;
//        }
//    }

//    /// <remarks/>
//    public string authorizationName
//    {
//        get
//        {
//            return this.authorizationNameField;
//        }
//        set
//        {
//            this.authorizationNameField = value;
//        }
//    }

//    /// <remarks/>
//    public TermsConditionsStatusInfo termsConditionStatus
//    {
//        get
//        {
//            return this.termsConditionStatusField;
//        }
//        set
//        {
//            this.termsConditionStatusField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool termsConditionStatusSpecified
//    {
//        get
//        {
//            return this.termsConditionStatusFieldSpecified;
//        }
//        set
//        {
//            this.termsConditionStatusFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public System.DateTime desiredDueDate
//    {
//        get
//        {
//            return this.desiredDueDateField;
//        }
//        set
//        {
//            this.desiredDueDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool desiredDueDateSpecified
//    {
//        get
//        {
//            return this.desiredDueDateFieldSpecified;
//        }
//        set
//        {
//            this.desiredDueDateFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public ImmediateActInfo immediateAct
//    {
//        get
//        {
//            return this.immediateActField;
//        }
//        set
//        {
//            this.immediateActField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool immediateActSpecified
//    {
//        get
//        {
//            return this.immediateActFieldSpecified;
//        }
//        set
//        {
//            this.immediateActFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public string ospBillingAccountNumber
//    {
//        get
//        {
//            return this.ospBillingAccountNumberField;
//        }
//        set
//        {
//            this.ospBillingAccountNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public string ospBillingAccountPassword
//    {
//        get
//        {
//            return this.ospBillingAccountPasswordField;
//        }
//        set
//        {
//            this.ospBillingAccountPasswordField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("businessTaxId", typeof(string))]
//    [System.Xml.Serialization.XmlElementAttribute("socialSecurityNumber", typeof(string))]
//    [System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemElementName")]
//    public string Item
//    {
//        get
//        {
//            return this.itemField;
//        }
//        set
//        {
//            this.itemField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public ItemChoiceType2 ItemElementName
//    {
//        get
//        {
//            return this.itemElementNameField;
//        }
//        set
//        {
//            this.itemElementNameField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum PortDirectionInfo
//{

//    /// <remarks/>
//    A,

//    /// <remarks/>
//    B,

//    /// <remarks/>
//    C,

//    /// <remarks/>
//    D,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum ImmediateActInfo
//{

//    /// <remarks/>
//    U,

//    /// <remarks/>
//    P,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd", IncludeInSchema = false)]
//public enum ItemChoiceType2
//{

//    /// <remarks/>
//    businessTaxId,

//    /// <remarks/>
//    socialSecurityNumber,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ReserveSubscriberNumberRe" +
//    "sponse.xsd")]
//public partial class ReserveSubscriberNumberResponseInfo
//{

//    private SubscriberNumberReservationInfo[] subscriberField;

//    private ResponseInfo responseField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("Subscriber")]
//    public SubscriberNumberReservationInfo[] Subscriber
//    {
//        get
//        {
//            return this.subscriberField;
//        }
//        set
//        {
//            this.subscriberField = value;
//        }
//    }

//    /// <remarks/>
//    public ResponseInfo Response
//    {
//        get
//        {
//            return this.responseField;
//        }
//        set
//        {
//            this.responseField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class SubscriberNumberReservationInfo
//{

//    private string subscriberNumberField;

//    private EquipmentTypeInfo equipmentTypeField;

//    private bool equipmentTypeFieldSpecified;

//    private string serviceAreaField;

//    private int depositAmountField;

//    private bool reservedField;

//    private SubscriberNumberReservationInfoError errorField;

//    private string msidField;

//    /// <remarks/>
//    public string subscriberNumber
//    {
//        get
//        {
//            return this.subscriberNumberField;
//        }
//        set
//        {
//            this.subscriberNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public EquipmentTypeInfo equipmentType
//    {
//        get
//        {
//            return this.equipmentTypeField;
//        }
//        set
//        {
//            this.equipmentTypeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool equipmentTypeSpecified
//    {
//        get
//        {
//            return this.equipmentTypeFieldSpecified;
//        }
//        set
//        {
//            this.equipmentTypeFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public string serviceArea
//    {
//        get
//        {
//            return this.serviceAreaField;
//        }
//        set
//        {
//            this.serviceAreaField = value;
//        }
//    }

//    /// <remarks/>
//    public int depositAmount
//    {
//        get
//        {
//            return this.depositAmountField;
//        }
//        set
//        {
//            this.depositAmountField = value;
//        }
//    }

//    /// <remarks/>
//    public bool reserved
//    {
//        get
//        {
//            return this.reservedField;
//        }
//        set
//        {
//            this.reservedField = value;
//        }
//    }

//    /// <remarks/>
//    public SubscriberNumberReservationInfoError error
//    {
//        get
//        {
//            return this.errorField;
//        }
//        set
//        {
//            this.errorField = value;
//        }
//    }

//    /// <remarks/>
//    public string msid
//    {
//        get
//        {
//            return this.msidField;
//        }
//        set
//        {
//            this.msidField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class SubscriberNumberReservationInfoError
//{

//    private string codeField;

//    private string descriptionField;

//    /// <remarks/>
//    public string code
//    {
//        get
//        {
//            return this.codeField;
//        }
//        set
//        {
//            this.codeField = value;
//        }
//    }

//    /// <remarks/>
//    public string description
//    {
//        get
//        {
//            return this.descriptionField;
//        }
//        set
//        {
//            this.descriptionField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class VanityTelephoneNumberInfo
//{

//    private string npaField;

//    private string vanityPatternField;

//    /// <remarks/>
//    public string npa
//    {
//        get
//        {
//            return this.npaField;
//        }
//        set
//        {
//            this.npaField = value;
//        }
//    }

//    /// <remarks/>
//    public string vanityPattern
//    {
//        get
//        {
//            return this.vanityPatternField;
//        }
//        set
//        {
//            this.vanityPatternField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ReserveSubscriberNumberRe" +
//    "quest.xsd")]
//public partial class ReserveSubscriberNumberRequestInfo
//{

//    private MarketAndZipServiceInfo marketServiceInfoField;

//    private string billingAccountNumberField;

//    private ReserveSubscriberNumberRequestInfoSubscriber[] subscriberField;

//    /// <remarks/>
//    public MarketAndZipServiceInfo marketServiceInfo
//    {
//        get
//        {
//            return this.marketServiceInfoField;
//        }
//        set
//        {
//            this.marketServiceInfoField = value;
//        }
//    }

//    /// <remarks/>
//    public string billingAccountNumber
//    {
//        get
//        {
//            return this.billingAccountNumberField;
//        }
//        set
//        {
//            this.billingAccountNumberField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("Subscriber")]
//    public ReserveSubscriberNumberRequestInfoSubscriber[] Subscriber
//    {
//        get
//        {
//            return this.subscriberField;
//        }
//        set
//        {
//            this.subscriberField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ReserveSubscriberNumberRe" +
//    "quest.xsd")]
//public partial class ReserveSubscriberNumberRequestInfoSubscriber
//{

//    private EquipmentTypeInfo equipmentTypeField;

//    private bool equipmentTypeFieldSpecified;

//    private string serviceAreaField;

//    private DealerCommissionInfo commissionField;

//    private ReserveSubscriberNumberRequestInfoSubscriberContactInformation contactInformationField;

//    private object itemField;

//    /// <remarks/>
//    public EquipmentTypeInfo equipmentType
//    {
//        get
//        {
//            return this.equipmentTypeField;
//        }
//        set
//        {
//            this.equipmentTypeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool equipmentTypeSpecified
//    {
//        get
//        {
//            return this.equipmentTypeFieldSpecified;
//        }
//        set
//        {
//            this.equipmentTypeFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public string serviceArea
//    {
//        get
//        {
//            return this.serviceAreaField;
//        }
//        set
//        {
//            this.serviceAreaField = value;
//        }
//    }

//    /// <remarks/>
//    public DealerCommissionInfo Commission
//    {
//        get
//        {
//            return this.commissionField;
//        }
//        set
//        {
//            this.commissionField = value;
//        }
//    }

//    /// <remarks/>
//    public ReserveSubscriberNumberRequestInfoSubscriberContactInformation ContactInformation
//    {
//        get
//        {
//            return this.contactInformationField;
//        }
//        set
//        {
//            this.contactInformationField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("Random", typeof(ReserveSubscriberNumberRequestInfoSubscriberRandom))]
//    [System.Xml.Serialization.XmlElementAttribute("subscriberNumber", typeof(string))]
//    public object Item
//    {
//        get
//        {
//            return this.itemField;
//        }
//        set
//        {
//            this.itemField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ReserveSubscriberNumberRe" +
//    "quest.xsd")]
//public partial class ReserveSubscriberNumberRequestInfoSubscriberContactInformation
//{

//    private object itemField;

//    private AddressInfo addressField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("BusinessName", typeof(NameBusinessInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("Name", typeof(NameInfo))]
//    public object Item
//    {
//        get
//        {
//            return this.itemField;
//        }
//        set
//        {
//            this.itemField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressInfo Address
//    {
//        get
//        {
//            return this.addressField;
//        }
//        set
//        {
//            this.addressField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class AddressInfo
//{

//    private AddressTypeInfo addressTypeField;

//    private bool addressTypeFieldSpecified;

//    private bool fieldIndicatorField;

//    private bool fieldIndicatorFieldSpecified;

//    private bool incorporatedIndicatorField;

//    private bool incorporatedIndicatorFieldSpecified;

//    private string attentionField;

//    private string addressLine1Field;

//    private string addressLine2Field;

//    private AddressStreetInfo streetField;

//    private UnitInfo unitField;

//    private string postOfficeBoxField;

//    private AddressRuralRouteInfo ruralRouteField;

//    private string cityField;

//    private AddressCountyInfo countyField;

//    private AddressStateInfo stateField;

//    private bool stateFieldSpecified;

//    private AddressZipInfo zipField;

//    private string countryField;

//    private string urbanizationCodeField;

//    private System.DateTime lastUpdateField;

//    private bool lastUpdateFieldSpecified;

//    public AddressInfo()
//    {
//        this.countryField = "US";
//    }

//    /// <remarks/>
//    public AddressTypeInfo addressType
//    {
//        get
//        {
//            return this.addressTypeField;
//        }
//        set
//        {
//            this.addressTypeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool addressTypeSpecified
//    {
//        get
//        {
//            return this.addressTypeFieldSpecified;
//        }
//        set
//        {
//            this.addressTypeFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool fieldIndicator
//    {
//        get
//        {
//            return this.fieldIndicatorField;
//        }
//        set
//        {
//            this.fieldIndicatorField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool fieldIndicatorSpecified
//    {
//        get
//        {
//            return this.fieldIndicatorFieldSpecified;
//        }
//        set
//        {
//            this.fieldIndicatorFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool incorporatedIndicator
//    {
//        get
//        {
//            return this.incorporatedIndicatorField;
//        }
//        set
//        {
//            this.incorporatedIndicatorField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool incorporatedIndicatorSpecified
//    {
//        get
//        {
//            return this.incorporatedIndicatorFieldSpecified;
//        }
//        set
//        {
//            this.incorporatedIndicatorFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public string Attention
//    {
//        get
//        {
//            return this.attentionField;
//        }
//        set
//        {
//            this.attentionField = value;
//        }
//    }

//    /// <remarks/>
//    public string AddressLine1
//    {
//        get
//        {
//            return this.addressLine1Field;
//        }
//        set
//        {
//            this.addressLine1Field = value;
//        }
//    }

//    /// <remarks/>
//    public string AddressLine2
//    {
//        get
//        {
//            return this.addressLine2Field;
//        }
//        set
//        {
//            this.addressLine2Field = value;
//        }
//    }

//    /// <remarks/>
//    public AddressStreetInfo Street
//    {
//        get
//        {
//            return this.streetField;
//        }
//        set
//        {
//            this.streetField = value;
//        }
//    }

//    /// <remarks/>
//    public UnitInfo Unit
//    {
//        get
//        {
//            return this.unitField;
//        }
//        set
//        {
//            this.unitField = value;
//        }
//    }

//    /// <remarks/>
//    public string PostOfficeBox
//    {
//        get
//        {
//            return this.postOfficeBoxField;
//        }
//        set
//        {
//            this.postOfficeBoxField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressRuralRouteInfo RuralRoute
//    {
//        get
//        {
//            return this.ruralRouteField;
//        }
//        set
//        {
//            this.ruralRouteField = value;
//        }
//    }

//    /// <remarks/>
//    public string City
//    {
//        get
//        {
//            return this.cityField;
//        }
//        set
//        {
//            this.cityField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressCountyInfo County
//    {
//        get
//        {
//            return this.countyField;
//        }
//        set
//        {
//            this.countyField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressStateInfo State
//    {
//        get
//        {
//            return this.stateField;
//        }
//        set
//        {
//            this.stateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool StateSpecified
//    {
//        get
//        {
//            return this.stateFieldSpecified;
//        }
//        set
//        {
//            this.stateFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public AddressZipInfo Zip
//    {
//        get
//        {
//            return this.zipField;
//        }
//        set
//        {
//            this.zipField = value;
//        }
//    }

//    /// <remarks/>
//    [System.ComponentModel.DefaultValueAttribute("US")]
//    public string Country
//    {
//        get
//        {
//            return this.countryField;
//        }
//        set
//        {
//            this.countryField = value;
//        }
//    }

//    /// <remarks/>
//    public string UrbanizationCode
//    {
//        get
//        {
//            return this.urbanizationCodeField;
//        }
//        set
//        {
//            this.urbanizationCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public System.DateTime lastUpdate
//    {
//        get
//        {
//            return this.lastUpdateField;
//        }
//        set
//        {
//            this.lastUpdateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool lastUpdateSpecified
//    {
//        get
//        {
//            return this.lastUpdateFieldSpecified;
//        }
//        set
//        {
//            this.lastUpdateFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum AddressTypeInfo
//{

//    /// <remarks/>
//    S,

//    /// <remarks/>
//    M,

//    /// <remarks/>
//    P,

//    /// <remarks/>
//    R,

//    /// <remarks/>
//    F,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class AddressCountyInfo
//{

//    private string countyNameField;

//    private string countyTypeField;

//    /// <remarks/>
//    public string countyName
//    {
//        get
//        {
//            return this.countyNameField;
//        }
//        set
//        {
//            this.countyNameField = value;
//        }
//    }

//    /// <remarks/>
//    public string countyType
//    {
//        get
//        {
//            return this.countyTypeField;
//        }
//        set
//        {
//            this.countyTypeField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ReserveSubscriberNumberRe" +
//    "quest.xsd")]
//public partial class ReserveSubscriberNumberRequestInfoSubscriberRandom
//{

//    private string quantityOfRandomSubscriberNumbersField;

//    private VanityTelephoneNumberInfo vanityNumberField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "positiveInteger")]
//    public string quantityOfRandomSubscriberNumbers
//    {
//        get
//        {
//            return this.quantityOfRandomSubscriberNumbersField;
//        }
//        set
//        {
//            this.quantityOfRandomSubscriberNumbersField = value;
//        }
//    }

//    /// <remarks/>
//    public VanityTelephoneNumberInfo VanityNumber
//    {
//        get
//        {
//            return this.vanityNumberField;
//        }
//        set
//        {
//            this.vanityNumberField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireUpgradeEligibility" +
//    "Response.xsd")]
//public partial class InquireUpgradeEligibilityResponseInfo
//{

//    private UpgradeEligibilityInfo eligibilityField;

//    private ResponseInfo responseField;

//    /// <remarks/>
//    public UpgradeEligibilityInfo Eligibility
//    {
//        get
//        {
//            return this.eligibilityField;
//        }
//        set
//        {
//            this.eligibilityField = value;
//        }
//    }

//    /// <remarks/>
//    public ResponseInfo Response
//    {
//        get
//        {
//            return this.responseField;
//        }
//        set
//        {
//            this.responseField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class UpgradeEligibilityInfo
//{

//    private UpgradeEligibilityStatusInfo eligibilityStatusField;

//    private UpgradeEligibilityTypeInfo eligibilityTypeField;

//    private bool eligibilityTypeFieldSpecified;

//    private System.DateTime lastUpgradeDateField;

//    private bool lastUpgradeDateFieldSpecified;

//    private System.DateTime futureEligibilityDateField;

//    private bool futureEligibilityDateFieldSpecified;

//    private System.DateTime lastEarlyUpgradeDateField;

//    private bool lastEarlyUpgradeDateFieldSpecified;

//    private System.DateTime futureEarlyEligibilityDateField;

//    private bool futureEarlyEligibilityDateFieldSpecified;

//    private string approvalNumberField;

//    private UpgradeQualificationDetailsInfo[] qualificationDetailsField;

//    private bool newAEUCheckerField;

//    private bool newAEUCheckerFieldSpecified;

//    private UpgradeEligibilityInfoReason[] reasonField;

//    /// <remarks/>
//    public UpgradeEligibilityStatusInfo eligibilityStatus
//    {
//        get
//        {
//            return this.eligibilityStatusField;
//        }
//        set
//        {
//            this.eligibilityStatusField = value;
//        }
//    }

//    /// <remarks/>
//    public UpgradeEligibilityTypeInfo eligibilityType
//    {
//        get
//        {
//            return this.eligibilityTypeField;
//        }
//        set
//        {
//            this.eligibilityTypeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool eligibilityTypeSpecified
//    {
//        get
//        {
//            return this.eligibilityTypeFieldSpecified;
//        }
//        set
//        {
//            this.eligibilityTypeFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime lastUpgradeDate
//    {
//        get
//        {
//            return this.lastUpgradeDateField;
//        }
//        set
//        {
//            this.lastUpgradeDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool lastUpgradeDateSpecified
//    {
//        get
//        {
//            return this.lastUpgradeDateFieldSpecified;
//        }
//        set
//        {
//            this.lastUpgradeDateFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime futureEligibilityDate
//    {
//        get
//        {
//            return this.futureEligibilityDateField;
//        }
//        set
//        {
//            this.futureEligibilityDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool futureEligibilityDateSpecified
//    {
//        get
//        {
//            return this.futureEligibilityDateFieldSpecified;
//        }
//        set
//        {
//            this.futureEligibilityDateFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime lastEarlyUpgradeDate
//    {
//        get
//        {
//            return this.lastEarlyUpgradeDateField;
//        }
//        set
//        {
//            this.lastEarlyUpgradeDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool lastEarlyUpgradeDateSpecified
//    {
//        get
//        {
//            return this.lastEarlyUpgradeDateFieldSpecified;
//        }
//        set
//        {
//            this.lastEarlyUpgradeDateFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime futureEarlyEligibilityDate
//    {
//        get
//        {
//            return this.futureEarlyEligibilityDateField;
//        }
//        set
//        {
//            this.futureEarlyEligibilityDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool futureEarlyEligibilityDateSpecified
//    {
//        get
//        {
//            return this.futureEarlyEligibilityDateFieldSpecified;
//        }
//        set
//        {
//            this.futureEarlyEligibilityDateFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public string approvalNumber
//    {
//        get
//        {
//            return this.approvalNumberField;
//        }
//        set
//        {
//            this.approvalNumberField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("QualificationDetails")]
//    public UpgradeQualificationDetailsInfo[] QualificationDetails
//    {
//        get
//        {
//            return this.qualificationDetailsField;
//        }
//        set
//        {
//            this.qualificationDetailsField = value;
//        }
//    }

//    /// <remarks/>
//    public bool newAEUChecker
//    {
//        get
//        {
//            return this.newAEUCheckerField;
//        }
//        set
//        {
//            this.newAEUCheckerField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool newAEUCheckerSpecified
//    {
//        get
//        {
//            return this.newAEUCheckerFieldSpecified;
//        }
//        set
//        {
//            this.newAEUCheckerFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("Reason")]
//    public UpgradeEligibilityInfoReason[] Reason
//    {
//        get
//        {
//            return this.reasonField;
//        }
//        set
//        {
//            this.reasonField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum UpgradeEligibilityStatusInfo
//{

//    /// <remarks/>
//    A,

//    /// <remarks/>
//    U,

//    /// <remarks/>
//    I,

//    /// <remarks/>
//    P,

//    /// <remarks/>
//    S,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum UpgradeEligibilityTypeInfo
//{

//    /// <remarks/>
//    S,

//    /// <remarks/>
//    E,

//    /// <remarks/>
//    O,

//    /// <remarks/>
//    D,

//    /// <remarks/>
//    C,

//    /// <remarks/>
//    M,

//    /// <remarks/>
//    P,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class UpgradeQualificationDetailsInfo
//{

//    private bool allowedForSecuredOffersField;

//    private bool allowedForSecuredOffersFieldSpecified;

//    private UpgradeQualificationsInfo[] baseOfferQualificationDetailsField;

//    private UpgradeQualificationsInfo[] securedOfferQualificationDetailsField;

//    private UpgradeQualificationsInfo[] preQualifiedOfferQualificationDetailsField;

//    /// <remarks/>
//    public bool allowedForSecuredOffers
//    {
//        get
//        {
//            return this.allowedForSecuredOffersField;
//        }
//        set
//        {
//            this.allowedForSecuredOffersField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool allowedForSecuredOffersSpecified
//    {
//        get
//        {
//            return this.allowedForSecuredOffersFieldSpecified;
//        }
//        set
//        {
//            this.allowedForSecuredOffersFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("BaseOfferQualificationDetails")]
//    public UpgradeQualificationsInfo[] BaseOfferQualificationDetails
//    {
//        get
//        {
//            return this.baseOfferQualificationDetailsField;
//        }
//        set
//        {
//            this.baseOfferQualificationDetailsField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("SecuredOfferQualificationDetails")]
//    public UpgradeQualificationsInfo[] SecuredOfferQualificationDetails
//    {
//        get
//        {
//            return this.securedOfferQualificationDetailsField;
//        }
//        set
//        {
//            this.securedOfferQualificationDetailsField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("PreQualifiedOfferQualificationDetails")]
//    public UpgradeQualificationsInfo[] PreQualifiedOfferQualificationDetails
//    {
//        get
//        {
//            return this.preQualifiedOfferQualificationDetailsField;
//        }
//        set
//        {
//            this.preQualifiedOfferQualificationDetailsField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class UpgradeEligibilityInfoReason
//{

//    private string codeField;

//    private string descriptionField;

//    /// <remarks/>
//    public string code
//    {
//        get
//        {
//            return this.codeField;
//        }
//        set
//        {
//            this.codeField = value;
//        }
//    }

//    /// <remarks/>
//    public string description
//    {
//        get
//        {
//            return this.descriptionField;
//        }
//        set
//        {
//            this.descriptionField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireUpgradeEligibility" +
//    "Request.xsd")]
//public partial class InquireUpgradeEligibilityRequestInfo
//{

//    private string subscriberNumberField;

//    private SecureUpgradeEligibilityInfo upgradeEligibilityField;

//    /// <remarks/>
//    public string subscriberNumber
//    {
//        get
//        {
//            return this.subscriberNumberField;
//        }
//        set
//        {
//            this.subscriberNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public SecureUpgradeEligibilityInfo UpgradeEligibility
//    {
//        get
//        {
//            return this.upgradeEligibilityField;
//        }
//        set
//        {
//            this.upgradeEligibilityField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class SecureUpgradeEligibilityInfo
//{

//    private string newSalesChannelField;

//    private string upgradeSecurityCodeField;

//    private string externalSystemUserIdField;

//    private DealerInfo dealerCodeField;

//    private string agentLocationField;

//    /// <remarks/>
//    public string newSalesChannel
//    {
//        get
//        {
//            return this.newSalesChannelField;
//        }
//        set
//        {
//            this.newSalesChannelField = value;
//        }
//    }

//    /// <remarks/>
//    public string upgradeSecurityCode
//    {
//        get
//        {
//            return this.upgradeSecurityCodeField;
//        }
//        set
//        {
//            this.upgradeSecurityCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string externalSystemUserId
//    {
//        get
//        {
//            return this.externalSystemUserIdField;
//        }
//        set
//        {
//            this.externalSystemUserIdField = value;
//        }
//    }

//    /// <remarks/>
//    public DealerInfo dealerCode
//    {
//        get
//        {
//            return this.dealerCodeField;
//        }
//        set
//        {
//            this.dealerCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string agentLocation
//    {
//        get
//        {
//            return this.agentLocationField;
//        }
//        set
//        {
//            this.agentLocationField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class PortEligibilityResponseInfo
//{

//    private bool eligibilityFlagField;

//    private string reasonCodeField;

//    private string reasonDescriptionField;

//    private ServiceProviderInfo oldServiceProviderField;

//    private ServiceProviderInfo newServiceProviderField;

//    private string subscriberNumberField;

//    private EquipmentTypeInfo equipmentTypeField;

//    private bool equipmentTypeFieldSpecified;

//    private string[] serviceAreaField;

//    /// <remarks/>
//    public bool eligibilityFlag
//    {
//        get
//        {
//            return this.eligibilityFlagField;
//        }
//        set
//        {
//            this.eligibilityFlagField = value;
//        }
//    }

//    /// <remarks/>
//    public string reasonCode
//    {
//        get
//        {
//            return this.reasonCodeField;
//        }
//        set
//        {
//            this.reasonCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string reasonDescription
//    {
//        get
//        {
//            return this.reasonDescriptionField;
//        }
//        set
//        {
//            this.reasonDescriptionField = value;
//        }
//    }

//    /// <remarks/>
//    public ServiceProviderInfo OldServiceProvider
//    {
//        get
//        {
//            return this.oldServiceProviderField;
//        }
//        set
//        {
//            this.oldServiceProviderField = value;
//        }
//    }

//    /// <remarks/>
//    public ServiceProviderInfo NewServiceProvider
//    {
//        get
//        {
//            return this.newServiceProviderField;
//        }
//        set
//        {
//            this.newServiceProviderField = value;
//        }
//    }

//    /// <remarks/>
//    public string subscriberNumber
//    {
//        get
//        {
//            return this.subscriberNumberField;
//        }
//        set
//        {
//            this.subscriberNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public EquipmentTypeInfo equipmentType
//    {
//        get
//        {
//            return this.equipmentTypeField;
//        }
//        set
//        {
//            this.equipmentTypeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool equipmentTypeSpecified
//    {
//        get
//        {
//            return this.equipmentTypeFieldSpecified;
//        }
//        set
//        {
//            this.equipmentTypeFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("serviceArea")]
//    public string[] serviceArea
//    {
//        get
//        {
//            return this.serviceAreaField;
//        }
//        set
//        {
//            this.serviceAreaField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class ServiceProviderInfo
//{

//    private string localIdField;

//    private string networkIdField;

//    private string resellerNameField;

//    /// <remarks/>
//    public string localId
//    {
//        get
//        {
//            return this.localIdField;
//        }
//        set
//        {
//            this.localIdField = value;
//        }
//    }

//    /// <remarks/>
//    public string networkId
//    {
//        get
//        {
//            return this.networkIdField;
//        }
//        set
//        {
//            this.networkIdField = value;
//        }
//    }

//    /// <remarks/>
//    public string resellerName
//    {
//        get
//        {
//            return this.resellerNameField;
//        }
//        set
//        {
//            this.resellerNameField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquirePortEligibilityRes" +
//    "ponse.xsd")]
//public partial class InquirePortEligibilityResponseInfo
//{

//    private PortEligibilityResponseInfo[] portEligibilityResponseField;

//    private ResponseInfo responseField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("PortEligibilityResponse")]
//    public PortEligibilityResponseInfo[] PortEligibilityResponse
//    {
//        get
//        {
//            return this.portEligibilityResponseField;
//        }
//        set
//        {
//            this.portEligibilityResponseField = value;
//        }
//    }

//    /// <remarks/>
//    public ResponseInfo Response
//    {
//        get
//        {
//            return this.responseField;
//        }
//        set
//        {
//            this.responseField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquirePortEligibilityByS" +
//    "ubscriberNumberRequest.xsd")]
//public partial class InquirePortEligibilityBySubscriberNumberRequestInfo
//{

//    private MarketAndZipServiceInfo marketServiceInfoField;

//    private InquirePortEligibilityBySubscriberNumberRequestInfoPortEligibility[] portEligibilityField;

//    private DealerInfo dealerField;

//    /// <remarks/>
//    public MarketAndZipServiceInfo marketServiceInfo
//    {
//        get
//        {
//            return this.marketServiceInfoField;
//        }
//        set
//        {
//            this.marketServiceInfoField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("PortEligibility")]
//    public InquirePortEligibilityBySubscriberNumberRequestInfoPortEligibility[] PortEligibility
//    {
//        get
//        {
//            return this.portEligibilityField;
//        }
//        set
//        {
//            this.portEligibilityField = value;
//        }
//    }

//    /// <remarks/>
//    public DealerInfo dealer
//    {
//        get
//        {
//            return this.dealerField;
//        }
//        set
//        {
//            this.dealerField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquirePortEligibilityByS" +
//    "ubscriberNumberRequest.xsd")]
//public partial class InquirePortEligibilityBySubscriberNumberRequestInfoPortEligibility
//{

//    private string subscriberNumberField;

//    private EquipmentTypeInfo equipmentTypeField;

//    /// <remarks/>
//    public string subscriberNumber
//    {
//        get
//        {
//            return this.subscriberNumberField;
//        }
//        set
//        {
//            this.subscriberNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public EquipmentTypeInfo equipmentType
//    {
//        get
//        {
//            return this.equipmentTypeField;
//        }
//        set
//        {
//            this.equipmentTypeField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquirePortActivationStat" +
//    "usResponse.xsd")]
//public partial class InquirePortActivationStatusResponseInfo
//{

//    private PortRequestStatusInfo portRequestStatusField;

//    private string totalNumberOfSubscriberNumbersField;

//    private InquirePortLineInfo[] inquirePortResponseLineField;

//    private ResponseInfo responseField;

//    /// <remarks/>
//    public PortRequestStatusInfo PortRequestStatus
//    {
//        get
//        {
//            return this.portRequestStatusField;
//        }
//        set
//        {
//            this.portRequestStatusField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "integer")]
//    public string totalNumberOfSubscriberNumbers
//    {
//        get
//        {
//            return this.totalNumberOfSubscriberNumbersField;
//        }
//        set
//        {
//            this.totalNumberOfSubscriberNumbersField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("InquirePortResponseLine")]
//    public InquirePortLineInfo[] InquirePortResponseLine
//    {
//        get
//        {
//            return this.inquirePortResponseLineField;
//        }
//        set
//        {
//            this.inquirePortResponseLineField = value;
//        }
//    }

//    /// <remarks/>
//    public ResponseInfo Response
//    {
//        get
//        {
//            return this.responseField;
//        }
//        set
//        {
//            this.responseField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class InquirePortLineInfo
//{

//    private long portRequestLineIdField;

//    private PortRequestLineStatusInfo portRequestLineStatusField;

//    private string statusReasonCodeField;

//    private string statusReasonDescriptionField;

//    private string npaNxxField;

//    private string fromLineField;

//    private string toLineField;

//    private EquipmentTypeInfo equipmentTypeField;

//    private bool equipmentTypeFieldSpecified;

//    private string fulfillmentOrderIdField;

//    private string serviceAreaField;

//    /// <remarks/>
//    public long portRequestLineId
//    {
//        get
//        {
//            return this.portRequestLineIdField;
//        }
//        set
//        {
//            this.portRequestLineIdField = value;
//        }
//    }

//    /// <remarks/>
//    public PortRequestLineStatusInfo portRequestLineStatus
//    {
//        get
//        {
//            return this.portRequestLineStatusField;
//        }
//        set
//        {
//            this.portRequestLineStatusField = value;
//        }
//    }

//    /// <remarks/>
//    public string statusReasonCode
//    {
//        get
//        {
//            return this.statusReasonCodeField;
//        }
//        set
//        {
//            this.statusReasonCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string statusReasonDescription
//    {
//        get
//        {
//            return this.statusReasonDescriptionField;
//        }
//        set
//        {
//            this.statusReasonDescriptionField = value;
//        }
//    }

//    /// <remarks/>
//    public string npaNxx
//    {
//        get
//        {
//            return this.npaNxxField;
//        }
//        set
//        {
//            this.npaNxxField = value;
//        }
//    }

//    /// <remarks/>
//    public string fromLine
//    {
//        get
//        {
//            return this.fromLineField;
//        }
//        set
//        {
//            this.fromLineField = value;
//        }
//    }

//    /// <remarks/>
//    public string toLine
//    {
//        get
//        {
//            return this.toLineField;
//        }
//        set
//        {
//            this.toLineField = value;
//        }
//    }

//    /// <remarks/>
//    public EquipmentTypeInfo equipmentType
//    {
//        get
//        {
//            return this.equipmentTypeField;
//        }
//        set
//        {
//            this.equipmentTypeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool equipmentTypeSpecified
//    {
//        get
//        {
//            return this.equipmentTypeFieldSpecified;
//        }
//        set
//        {
//            this.equipmentTypeFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public string fulfillmentOrderId
//    {
//        get
//        {
//            return this.fulfillmentOrderIdField;
//        }
//        set
//        {
//            this.fulfillmentOrderIdField = value;
//        }
//    }

//    /// <remarks/>
//    public string serviceArea
//    {
//        get
//        {
//            return this.serviceAreaField;
//        }
//        set
//        {
//            this.serviceAreaField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum PortRequestLineStatusInfo
//{

//    /// <remarks/>
//    OP,

//    /// <remarks/>
//    CN,

//    /// <remarks/>
//    CT,

//    /// <remarks/>
//    CF,

//    /// <remarks/>
//    DN,

//    /// <remarks/>
//    ER,

//    /// <remarks/>
//    CO,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquirePortActivationStat" +
//    "usRequest.xsd")]
//public partial class InquirePortActivationStatusRequestInfo
//{

//    private MarketAndZipServiceInfo marketServiceInfoField;

//    private PortingLocatorInfo portingLocatorField;

//    /// <remarks/>
//    public MarketAndZipServiceInfo MarketServiceInfo
//    {
//        get
//        {
//            return this.marketServiceInfoField;
//        }
//        set
//        {
//            this.marketServiceInfoField = value;
//        }
//    }

//    /// <remarks/>
//    public PortingLocatorInfo PortingLocator
//    {
//        get
//        {
//            return this.portingLocatorField;
//        }
//        set
//        {
//            this.portingLocatorField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquirePortResponse.xsd")]
//public partial class InquirePortResponseInfo
//{

//    private DealerCommissionInfo commissionField;

//    private InquirePortResponseInfoCustomer customerField;

//    private PortRequestInfo portRequestField;

//    private PortRequestStatusInfo portRequestStatusField;

//    private PortCancelReasonCodeInfo portCancellationReasonCodeField;

//    private bool portCancellationReasonCodeFieldSpecified;

//    private ServiceProviderInfo oldServiceProviderField;

//    private string versionNumberField;

//    private InquirePortLineInfo[] inquirePortResponseLineField;

//    private ResponseInfo responseField;

//    /// <remarks/>
//    public DealerCommissionInfo Commission
//    {
//        get
//        {
//            return this.commissionField;
//        }
//        set
//        {
//            this.commissionField = value;
//        }
//    }

//    /// <remarks/>
//    public InquirePortResponseInfoCustomer Customer
//    {
//        get
//        {
//            return this.customerField;
//        }
//        set
//        {
//            this.customerField = value;
//        }
//    }

//    /// <remarks/>
//    public PortRequestInfo PortRequest
//    {
//        get
//        {
//            return this.portRequestField;
//        }
//        set
//        {
//            this.portRequestField = value;
//        }
//    }

//    /// <remarks/>
//    public PortRequestStatusInfo PortRequestStatus
//    {
//        get
//        {
//            return this.portRequestStatusField;
//        }
//        set
//        {
//            this.portRequestStatusField = value;
//        }
//    }

//    /// <remarks/>
//    public PortCancelReasonCodeInfo portCancellationReasonCode
//    {
//        get
//        {
//            return this.portCancellationReasonCodeField;
//        }
//        set
//        {
//            this.portCancellationReasonCodeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool portCancellationReasonCodeSpecified
//    {
//        get
//        {
//            return this.portCancellationReasonCodeFieldSpecified;
//        }
//        set
//        {
//            this.portCancellationReasonCodeFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public ServiceProviderInfo OldServiceProvider
//    {
//        get
//        {
//            return this.oldServiceProviderField;
//        }
//        set
//        {
//            this.oldServiceProviderField = value;
//        }
//    }

//    /// <remarks/>
//    public string versionNumber
//    {
//        get
//        {
//            return this.versionNumberField;
//        }
//        set
//        {
//            this.versionNumberField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("InquirePortResponseLine")]
//    public InquirePortLineInfo[] InquirePortResponseLine
//    {
//        get
//        {
//            return this.inquirePortResponseLineField;
//        }
//        set
//        {
//            this.inquirePortResponseLineField = value;
//        }
//    }

//    /// <remarks/>
//    public ResponseInfo Response
//    {
//        get
//        {
//            return this.responseField;
//        }
//        set
//        {
//            this.responseField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquirePortResponse.xsd")]
//public partial class InquirePortResponseInfoCustomer
//{

//    private object itemField;

//    private InquirePortResponseInfoCustomerAddress addressField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("BusinessName", typeof(NameBusinessInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("Name", typeof(NameInfo))]
//    public object Item
//    {
//        get
//        {
//            return this.itemField;
//        }
//        set
//        {
//            this.itemField = value;
//        }
//    }

//    /// <remarks/>
//    public InquirePortResponseInfoCustomerAddress Address
//    {
//        get
//        {
//            return this.addressField;
//        }
//        set
//        {
//            this.addressField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquirePortResponse.xsd")]
//public partial class InquirePortResponseInfoCustomerAddress
//{

//    private UnitInfo unitField;

//    private AddressStreetInfo streetField;

//    private string postOfficeBoxField;

//    private AddressRuralRouteInfo ruralRouteField;

//    private string cityField;

//    private AddressStateInfo stateField;

//    private string countryField;

//    private AddressZipInfo zipField;

//    /// <remarks/>
//    public UnitInfo Unit
//    {
//        get
//        {
//            return this.unitField;
//        }
//        set
//        {
//            this.unitField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressStreetInfo Street
//    {
//        get
//        {
//            return this.streetField;
//        }
//        set
//        {
//            this.streetField = value;
//        }
//    }

//    /// <remarks/>
//    public string PostOfficeBox
//    {
//        get
//        {
//            return this.postOfficeBoxField;
//        }
//        set
//        {
//            this.postOfficeBoxField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressRuralRouteInfo RuralRoute
//    {
//        get
//        {
//            return this.ruralRouteField;
//        }
//        set
//        {
//            this.ruralRouteField = value;
//        }
//    }

//    /// <remarks/>
//    public string City
//    {
//        get
//        {
//            return this.cityField;
//        }
//        set
//        {
//            this.cityField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressStateInfo State
//    {
//        get
//        {
//            return this.stateField;
//        }
//        set
//        {
//            this.stateField = value;
//        }
//    }

//    /// <remarks/>
//    public string Country
//    {
//        get
//        {
//            return this.countryField;
//        }
//        set
//        {
//            this.countryField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressZipInfo Zip
//    {
//        get
//        {
//            return this.zipField;
//        }
//        set
//        {
//            this.zipField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum PortCancelReasonCodeInfo
//{

//    /// <remarks/>
//    CC,

//    /// <remarks/>
//    CD,

//    /// <remarks/>
//    MN,

//    /// <remarks/>
//    MV,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquirePortRequest.xsd")]
//public partial class InquirePortRequestInfo
//{

//    private MarketAndZipServiceInfo marketServiceInfoField;

//    private PortSelectorInfo portingSelectorField;

//    /// <remarks/>
//    public MarketAndZipServiceInfo MarketServiceInfo
//    {
//        get
//        {
//            return this.marketServiceInfoField;
//        }
//        set
//        {
//            this.marketServiceInfoField = value;
//        }
//    }

//    /// <remarks/>
//    public PortSelectorInfo PortingSelector
//    {
//        get
//        {
//            return this.portingSelectorField;
//        }
//        set
//        {
//            this.portingSelectorField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class ServiceAreaLookupInfo
//{

//    private ServiceAreaLookupInfoLocalMarketType localMarketTypeField;

//    private bool isLocalField;

//    private bool isLocalFieldSpecified;

//    private ServiceAreaLookupInfoMatchType matchTypeField;

//    private bool matchTypeFieldSpecified;

//    private decimal distanceField;

//    private bool distanceFieldSpecified;

//    private string serviceAreaDescriptionField;

//    private ServiceAreaLookupInfoLocation[] locationField;

//    private NpaNxxLineInfo[] numberBlockField;

//    private TechnologyTypeInfo[] technologyField;

//    /// <remarks/>
//    public ServiceAreaLookupInfoLocalMarketType localMarketType
//    {
//        get
//        {
//            return this.localMarketTypeField;
//        }
//        set
//        {
//            this.localMarketTypeField = value;
//        }
//    }

//    /// <remarks/>
//    public bool isLocal
//    {
//        get
//        {
//            return this.isLocalField;
//        }
//        set
//        {
//            this.isLocalField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool isLocalSpecified
//    {
//        get
//        {
//            return this.isLocalFieldSpecified;
//        }
//        set
//        {
//            this.isLocalFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public ServiceAreaLookupInfoMatchType matchType
//    {
//        get
//        {
//            return this.matchTypeField;
//        }
//        set
//        {
//            this.matchTypeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool matchTypeSpecified
//    {
//        get
//        {
//            return this.matchTypeFieldSpecified;
//        }
//        set
//        {
//            this.matchTypeFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public decimal distance
//    {
//        get
//        {
//            return this.distanceField;
//        }
//        set
//        {
//            this.distanceField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool distanceSpecified
//    {
//        get
//        {
//            return this.distanceFieldSpecified;
//        }
//        set
//        {
//            this.distanceFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public string serviceAreaDescription
//    {
//        get
//        {
//            return this.serviceAreaDescriptionField;
//        }
//        set
//        {
//            this.serviceAreaDescriptionField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("Location")]
//    public ServiceAreaLookupInfoLocation[] Location
//    {
//        get
//        {
//            return this.locationField;
//        }
//        set
//        {
//            this.locationField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("NumberBlock")]
//    public NpaNxxLineInfo[] NumberBlock
//    {
//        get
//        {
//            return this.numberBlockField;
//        }
//        set
//        {
//            this.numberBlockField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("technology")]
//    public TechnologyTypeInfo[] technology
//    {
//        get
//        {
//            return this.technologyField;
//        }
//        set
//        {
//            this.technologyField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum ServiceAreaLookupInfoLocalMarketType
//{

//    /// <remarks/>
//    TLG,

//    /// <remarks/>
//    CPW,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum ServiceAreaLookupInfoMatchType
//{

//    /// <remarks/>
//    E,

//    /// <remarks/>
//    C,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class ServiceAreaLookupInfoLocation
//{

//    private ServiceAreaLookupInfoLocationLocationMarketType locationMarketTypeField;

//    private string serviceAreaCodeField;

//    private ServiceAreaLookupInfoLocationMarket marketField;

//    /// <remarks/>
//    public ServiceAreaLookupInfoLocationLocationMarketType locationMarketType
//    {
//        get
//        {
//            return this.locationMarketTypeField;
//        }
//        set
//        {
//            this.locationMarketTypeField = value;
//        }
//    }

//    /// <remarks/>
//    public string serviceAreaCode
//    {
//        get
//        {
//            return this.serviceAreaCodeField;
//        }
//        set
//        {
//            this.serviceAreaCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public ServiceAreaLookupInfoLocationMarket market
//    {
//        get
//        {
//            return this.marketField;
//        }
//        set
//        {
//            this.marketField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum ServiceAreaLookupInfoLocationLocationMarketType
//{

//    /// <remarks/>
//    Local,

//    /// <remarks/>
//    NBI,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class ServiceAreaLookupInfoLocationMarket : MarketInfo
//{

//    private string marketNameField;

//    private string subMarketNameField;

//    /// <remarks/>
//    public string marketName
//    {
//        get
//        {
//            return this.marketNameField;
//        }
//        set
//        {
//            this.marketNameField = value;
//        }
//    }

//    /// <remarks/>
//    public string subMarketName
//    {
//        get
//        {
//            return this.subMarketNameField;
//        }
//        set
//        {
//            this.subMarketNameField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class NpaNxxLineInfo
//{

//    private string npaField;

//    private string nxxField;

//    private string lineField;

//    /// <remarks/>
//    public string npa
//    {
//        get
//        {
//            return this.npaField;
//        }
//        set
//        {
//            this.npaField = value;
//        }
//    }

//    /// <remarks/>
//    public string nxx
//    {
//        get
//        {
//            return this.nxxField;
//        }
//        set
//        {
//            this.nxxField = value;
//        }
//    }

//    /// <remarks/>
//    public string line
//    {
//        get
//        {
//            return this.lineField;
//        }
//        set
//        {
//            this.lineField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireMarketServiceAreas" +
//    "Response.xsd")]
//public partial class InquireMarketServiceAreasResponseInfo
//{

//    private string cityField;

//    private AddressStateInfo stateField;

//    private bool stateFieldSpecified;

//    private string regionField;

//    private WirelineLegacyFootprintInfo legacyWirelineFootprintField;

//    private bool legacyWirelineFootprintFieldSpecified;

//    private string[] zipcodeField;

//    private AddressCountyInfo[] countyField;

//    private string npaField;

//    private ServiceAreaLookupInfo[] serviceAreasField;

//    private ResponseInfo responseField;

//    /// <remarks/>
//    public string city
//    {
//        get
//        {
//            return this.cityField;
//        }
//        set
//        {
//            this.cityField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressStateInfo state
//    {
//        get
//        {
//            return this.stateField;
//        }
//        set
//        {
//            this.stateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool stateSpecified
//    {
//        get
//        {
//            return this.stateFieldSpecified;
//        }
//        set
//        {
//            this.stateFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public string region
//    {
//        get
//        {
//            return this.regionField;
//        }
//        set
//        {
//            this.regionField = value;
//        }
//    }

//    /// <remarks/>
//    public WirelineLegacyFootprintInfo legacyWirelineFootprint
//    {
//        get
//        {
//            return this.legacyWirelineFootprintField;
//        }
//        set
//        {
//            this.legacyWirelineFootprintField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool legacyWirelineFootprintSpecified
//    {
//        get
//        {
//            return this.legacyWirelineFootprintFieldSpecified;
//        }
//        set
//        {
//            this.legacyWirelineFootprintFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("zipcode")]
//    public string[] zipcode
//    {
//        get
//        {
//            return this.zipcodeField;
//        }
//        set
//        {
//            this.zipcodeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("county")]
//    public AddressCountyInfo[] county
//    {
//        get
//        {
//            return this.countyField;
//        }
//        set
//        {
//            this.countyField = value;
//        }
//    }

//    /// <remarks/>
//    public string npa
//    {
//        get
//        {
//            return this.npaField;
//        }
//        set
//        {
//            this.npaField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("ServiceAreas")]
//    public ServiceAreaLookupInfo[] ServiceAreas
//    {
//        get
//        {
//            return this.serviceAreasField;
//        }
//        set
//        {
//            this.serviceAreasField = value;
//        }
//    }

//    /// <remarks/>
//    public ResponseInfo Response
//    {
//        get
//        {
//            return this.responseField;
//        }
//        set
//        {
//            this.responseField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum WirelineLegacyFootprintInfo
//{

//    /// <remarks/>
//    SBC,

//    /// <remarks/>
//    BLS,

//    /// <remarks/>
//    UNKNOWN,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class RestrictedNpaNxxLineInfo
//{

//    private string npaField;

//    private string nxxField;

//    private string lineField;

//    /// <remarks/>
//    public string npa
//    {
//        get
//        {
//            return this.npaField;
//        }
//        set
//        {
//            this.npaField = value;
//        }
//    }

//    /// <remarks/>
//    public string nxx
//    {
//        get
//        {
//            return this.nxxField;
//        }
//        set
//        {
//            this.nxxField = value;
//        }
//    }

//    /// <remarks/>
//    public string line
//    {
//        get
//        {
//            return this.lineField;
//        }
//        set
//        {
//            this.lineField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireMarketServiceAreas" +
//    "Request.xsd")]
//public partial class InquireMarketServiceAreasRequestInfo
//{

//    private InquireMarketServiceAreasRequestInfoServiceAreasSelector serviceAreasSelectorField;

//    private RestrictedNpaNxxLineInfo localCallingAreaField;

//    private InquireMarketServiceAreasRequestInfoFilterOptions filterOptionsField;

//    private InquireMarketServiceAreasRequestInfoRequestType requestTypeField;

//    public InquireMarketServiceAreasRequestInfo()
//    {
//        this.requestTypeField = InquireMarketServiceAreasRequestInfoRequestType.Activation;
//    }

//    /// <remarks/>
//    public InquireMarketServiceAreasRequestInfoServiceAreasSelector ServiceAreasSelector
//    {
//        get
//        {
//            return this.serviceAreasSelectorField;
//        }
//        set
//        {
//            this.serviceAreasSelectorField = value;
//        }
//    }

//    /// <remarks/>
//    public RestrictedNpaNxxLineInfo LocalCallingArea
//    {
//        get
//        {
//            return this.localCallingAreaField;
//        }
//        set
//        {
//            this.localCallingAreaField = value;
//        }
//    }

//    /// <remarks/>
//    public InquireMarketServiceAreasRequestInfoFilterOptions FilterOptions
//    {
//        get
//        {
//            return this.filterOptionsField;
//        }
//        set
//        {
//            this.filterOptionsField = value;
//        }
//    }

//    /// <remarks/>
//    public InquireMarketServiceAreasRequestInfoRequestType requestType
//    {
//        get
//        {
//            return this.requestTypeField;
//        }
//        set
//        {
//            this.requestTypeField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireMarketServiceAreas" +
//    "Request.xsd")]
//public partial class InquireMarketServiceAreasRequestInfoServiceAreasSelector
//{

//    private object itemField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("SelectorsWithMarketType", typeof(InquireMarketServiceAreasRequestInfoServiceAreasSelectorSelectorsWithMarketType))]
//    [System.Xml.Serialization.XmlElementAttribute("marketCode", typeof(string))]
//    public object Item
//    {
//        get
//        {
//            return this.itemField;
//        }
//        set
//        {
//            this.itemField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireMarketServiceAreas" +
//    "Request.xsd")]
//public partial class InquireMarketServiceAreasRequestInfoServiceAreasSelectorSelectorsWithMarketType
//{

//    private object itemField;

//    private MarketTypeInfo marketTypeField;

//    public InquireMarketServiceAreasRequestInfoServiceAreasSelectorSelectorsWithMarketType()
//    {
//        this.marketTypeField = MarketTypeInfo.Both;
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("CityState", typeof(InquireMarketServiceAreasRequestInfoServiceAreasSelectorSelectorsWithMarketTypeCityState))]
//    [System.Xml.Serialization.XmlElementAttribute("SubscriberNumber", typeof(NpaNxxLineInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("zipCode", typeof(string))]
//    public object Item
//    {
//        get
//        {
//            return this.itemField;
//        }
//        set
//        {
//            this.itemField = value;
//        }
//    }

//    /// <remarks/>
//    public MarketTypeInfo marketType
//    {
//        get
//        {
//            return this.marketTypeField;
//        }
//        set
//        {
//            this.marketTypeField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireMarketServiceAreas" +
//    "Request.xsd")]
//public partial class InquireMarketServiceAreasRequestInfoServiceAreasSelectorSelectorsWithMarketTypeCityState
//{

//    private string cityField;

//    private AddressStateInfo stateField;

//    /// <remarks/>
//    public string city
//    {
//        get
//        {
//            return this.cityField;
//        }
//        set
//        {
//            this.cityField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressStateInfo state
//    {
//        get
//        {
//            return this.stateField;
//        }
//        set
//        {
//            this.stateField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum MarketTypeInfo
//{

//    /// <remarks/>
//    CPW,

//    /// <remarks/>
//    TLG,

//    /// <remarks/>
//    Both,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireMarketServiceAreas" +
//    "Request.xsd")]
//public partial class InquireMarketServiceAreasRequestInfoFilterOptions
//{

//    private string filterByMarketCodeField;

//    private InquireMarketServiceAreasRequestInfoFilterOptionsLocationBasedFilters locationBasedFiltersField;

//    private InquireMarketServiceAreasRequestInfoFilterOptionsSubscriberNumberBasedFilters subscriberNumberBasedFiltersField;

//    /// <remarks/>
//    public string filterByMarketCode
//    {
//        get
//        {
//            return this.filterByMarketCodeField;
//        }
//        set
//        {
//            this.filterByMarketCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public InquireMarketServiceAreasRequestInfoFilterOptionsLocationBasedFilters LocationBasedFilters
//    {
//        get
//        {
//            return this.locationBasedFiltersField;
//        }
//        set
//        {
//            this.locationBasedFiltersField = value;
//        }
//    }

//    /// <remarks/>
//    public InquireMarketServiceAreasRequestInfoFilterOptionsSubscriberNumberBasedFilters SubscriberNumberBasedFilters
//    {
//        get
//        {
//            return this.subscriberNumberBasedFiltersField;
//        }
//        set
//        {
//            this.subscriberNumberBasedFiltersField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireMarketServiceAreas" +
//    "Request.xsd")]
//public partial class InquireMarketServiceAreasRequestInfoFilterOptionsLocationBasedFilters
//{

//    private int numberOfServiceAreasField;

//    private bool numberOfServiceAreasFieldSpecified;

//    private bool restrictToLocalMarketField;

//    public InquireMarketServiceAreasRequestInfoFilterOptionsLocationBasedFilters()
//    {
//        this.restrictToLocalMarketField = false;
//    }

//    /// <remarks/>
//    public int numberOfServiceAreas
//    {
//        get
//        {
//            return this.numberOfServiceAreasField;
//        }
//        set
//        {
//            this.numberOfServiceAreasField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool numberOfServiceAreasSpecified
//    {
//        get
//        {
//            return this.numberOfServiceAreasFieldSpecified;
//        }
//        set
//        {
//            this.numberOfServiceAreasFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool restrictToLocalMarket
//    {
//        get
//        {
//            return this.restrictToLocalMarketField;
//        }
//        set
//        {
//            this.restrictToLocalMarketField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireMarketServiceAreas" +
//    "Request.xsd")]
//public partial class InquireMarketServiceAreasRequestInfoFilterOptionsSubscriberNumberBasedFilters
//{

//    private string filterByZipCodeField;

//    /// <remarks/>
//    public string filterByZipCode
//    {
//        get
//        {
//            return this.filterByZipCodeField;
//        }
//        set
//        {
//            this.filterByZipCodeField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireMarketServiceAreas" +
//    "Request.xsd")]
//public enum InquireMarketServiceAreasRequestInfoRequestType
//{

//    /// <remarks/>
//    Activation,

//    /// <remarks/>
//    Portin,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireDuplicateOfferings" +
//    "Response.xsd")]
//public partial class InquireDuplicateOfferingsResponseInfo
//{

//    private InquireDuplicateOfferingsResponseInfoDuplicateOfferingResultsInfo[] duplicateOfferingResultsInfoField;

//    private ResponseInfo responseField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("DuplicateOfferingResultsInfo")]
//    public InquireDuplicateOfferingsResponseInfoDuplicateOfferingResultsInfo[] DuplicateOfferingResultsInfo
//    {
//        get
//        {
//            return this.duplicateOfferingResultsInfoField;
//        }
//        set
//        {
//            this.duplicateOfferingResultsInfoField = value;
//        }
//    }

//    /// <remarks/>
//    public ResponseInfo Response
//    {
//        get
//        {
//            return this.responseField;
//        }
//        set
//        {
//            this.responseField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireDuplicateOfferings" +
//    "Response.xsd")]
//public partial class InquireDuplicateOfferingsResponseInfoDuplicateOfferingResultsInfo
//{

//    private string subscriberNumberField;

//    private InquireDuplicateOfferingsResponseInfoDuplicateOfferingResultsInfoPairConflictingOfferingInfo pairConflictingOfferingInfoField;

//    /// <remarks/>
//    public string subscriberNumber
//    {
//        get
//        {
//            return this.subscriberNumberField;
//        }
//        set
//        {
//            this.subscriberNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public InquireDuplicateOfferingsResponseInfoDuplicateOfferingResultsInfoPairConflictingOfferingInfo PairConflictingOfferingInfo
//    {
//        get
//        {
//            return this.pairConflictingOfferingInfoField;
//        }
//        set
//        {
//            this.pairConflictingOfferingInfoField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireDuplicateOfferings" +
//    "Response.xsd")]
//public partial class InquireDuplicateOfferingsResponseInfoDuplicateOfferingResultsInfoPairConflictingOfferingInfo
//{

//    private OfferingsAdditionalInfo offeringInfoField;

//    private OfferingsAdditionalInfo conflictingOfferingInfoField;

//    /// <remarks/>
//    public OfferingsAdditionalInfo OfferingInfo
//    {
//        get
//        {
//            return this.offeringInfoField;
//        }
//        set
//        {
//            this.offeringInfoField = value;
//        }
//    }

//    /// <remarks/>
//    public OfferingsAdditionalInfo ConflictingOfferingInfo
//    {
//        get
//        {
//            return this.conflictingOfferingInfoField;
//        }
//        set
//        {
//            this.conflictingOfferingInfoField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class IMEIDetailsInfo
//{

//    private string iMEITypeField;

//    private string iMEIFrequencyField;

//    private bool umtsCapabilityField;

//    private bool umtsCapabilityFieldSpecified;

//    /// <remarks/>
//    public string IMEIType
//    {
//        get
//        {
//            return this.iMEITypeField;
//        }
//        set
//        {
//            this.iMEITypeField = value;
//        }
//    }

//    /// <remarks/>
//    public string IMEIFrequency
//    {
//        get
//        {
//            return this.iMEIFrequencyField;
//        }
//        set
//        {
//            this.iMEIFrequencyField = value;
//        }
//    }

//    /// <remarks/>
//    public bool umtsCapability
//    {
//        get
//        {
//            return this.umtsCapabilityField;
//        }
//        set
//        {
//            this.umtsCapabilityField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool umtsCapabilitySpecified
//    {
//        get
//        {
//            return this.umtsCapabilityFieldSpecified;
//        }
//        set
//        {
//            this.umtsCapabilityFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireDuplicateOfferings" +
//    "Request.xsd")]
//public partial class InquireDuplicateOfferingsRequestInfo
//{

//    private string subscriberField;

//    private IMEIDetailsInfo iMEIDetailsField;

//    private PricePlanInfo pricePlanField;

//    private OfferingsAdditionalInfo[] additionalOfferingsField;

//    /// <remarks/>
//    public string Subscriber
//    {
//        get
//        {
//            return this.subscriberField;
//        }
//        set
//        {
//            this.subscriberField = value;
//        }
//    }

//    /// <remarks/>
//    public IMEIDetailsInfo IMEIDetails
//    {
//        get
//        {
//            return this.iMEIDetailsField;
//        }
//        set
//        {
//            this.iMEIDetailsField = value;
//        }
//    }

//    /// <remarks/>
//    public PricePlanInfo PricePlan
//    {
//        get
//        {
//            return this.pricePlanField;
//        }
//        set
//        {
//            this.pricePlanField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("AdditionalOfferings")]
//    public OfferingsAdditionalInfo[] AdditionalOfferings
//    {
//        get
//        {
//            return this.additionalOfferingsField;
//        }
//        set
//        {
//            this.additionalOfferingsField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireCreditCheckResultR" +
//    "esponse.xsd")]
//public partial class InquireCreditCheckResultResponseInfo
//{

//    private CreditDecisionInfo creditDecisionField;

//    private ResponseInfo responseField;

//    /// <remarks/>
//    public CreditDecisionInfo CreditDecision
//    {
//        get
//        {
//            return this.creditDecisionField;
//        }
//        set
//        {
//            this.creditDecisionField = value;
//        }
//    }

//    /// <remarks/>
//    public ResponseInfo Response
//    {
//        get
//        {
//            return this.responseField;
//        }
//        set
//        {
//            this.responseField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class CreditDecisionInfo
//{

//    private string decisionReferenceNumberField;

//    private string decisionCodeField;

//    private string decisionReasonCodeField;

//    private string decisionCodeDescriptionField;

//    private System.DateTime decisionCodeExpirationDateField;

//    private bool decisionCodeExpirationDateFieldSpecified;

//    private int[] depositAmountField;

//    private string approvedSubscriberLinesField;

//    private int numberOfLinesAvailableField;

//    private string creditClassField;

//    private System.DateTime creditDateField;

//    private bool creditDateFieldSpecified;

//    public CreditDecisionInfo()
//    {
//        this.numberOfLinesAvailableField = 0;
//    }

//    /// <remarks/>
//    public string decisionReferenceNumber
//    {
//        get
//        {
//            return this.decisionReferenceNumberField;
//        }
//        set
//        {
//            this.decisionReferenceNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public string decisionCode
//    {
//        get
//        {
//            return this.decisionCodeField;
//        }
//        set
//        {
//            this.decisionCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string decisionReasonCode
//    {
//        get
//        {
//            return this.decisionReasonCodeField;
//        }
//        set
//        {
//            this.decisionReasonCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string decisionCodeDescription
//    {
//        get
//        {
//            return this.decisionCodeDescriptionField;
//        }
//        set
//        {
//            this.decisionCodeDescriptionField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime decisionCodeExpirationDate
//    {
//        get
//        {
//            return this.decisionCodeExpirationDateField;
//        }
//        set
//        {
//            this.decisionCodeExpirationDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool decisionCodeExpirationDateSpecified
//    {
//        get
//        {
//            return this.decisionCodeExpirationDateFieldSpecified;
//        }
//        set
//        {
//            this.decisionCodeExpirationDateFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("depositAmount")]
//    public int[] depositAmount
//    {
//        get
//        {
//            return this.depositAmountField;
//        }
//        set
//        {
//            this.depositAmountField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "integer")]
//    public string approvedSubscriberLines
//    {
//        get
//        {
//            return this.approvedSubscriberLinesField;
//        }
//        set
//        {
//            this.approvedSubscriberLinesField = value;
//        }
//    }

//    /// <remarks/>
//    [System.ComponentModel.DefaultValueAttribute(0)]
//    public int numberOfLinesAvailable
//    {
//        get
//        {
//            return this.numberOfLinesAvailableField;
//        }
//        set
//        {
//            this.numberOfLinesAvailableField = value;
//        }
//    }

//    /// <remarks/>
//    public string creditClass
//    {
//        get
//        {
//            return this.creditClassField;
//        }
//        set
//        {
//            this.creditClassField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime creditDate
//    {
//        get
//        {
//            return this.creditDateField;
//        }
//        set
//        {
//            this.creditDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool creditDateSpecified
//    {
//        get
//        {
//            return this.creditDateFieldSpecified;
//        }
//        set
//        {
//            this.creditDateFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireCreditCheckResultR" +
//    "equest.xsd")]
//public partial class InquireCreditCheckResultRequestInfo
//{

//    private MarketAndZipServiceInfo marketServiceInfoField;

//    private string itemField;

//    private ItemChoiceType3 itemElementNameField;

//    /// <remarks/>
//    public MarketAndZipServiceInfo marketServiceInfo
//    {
//        get
//        {
//            return this.marketServiceInfoField;
//        }
//        set
//        {
//            this.marketServiceInfoField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("GUID", typeof(string))]
//    [System.Xml.Serialization.XmlElementAttribute("billingAccountNumber", typeof(string))]
//    [System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemElementName")]
//    public string Item
//    {
//        get
//        {
//            return this.itemField;
//        }
//        set
//        {
//            this.itemField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public ItemChoiceType3 ItemElementName
//    {
//        get
//        {
//            return this.itemElementNameField;
//        }
//        set
//        {
//            this.itemElementNameField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireCreditCheckResultR" +
//    "equest.xsd", IncludeInSchema = false)]
//public enum ItemChoiceType3
//{

//    /// <remarks/>
//    GUID,

//    /// <remarks/>
//    billingAccountNumber,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class CopayInfo
//{

//    private string receivingBanField;

//    private string allowanceIdField;

//    private System.DateTime effectiveDateField;

//    private bool effectiveDateFieldSpecified;

//    private System.DateTime enrollDateField;

//    private System.DateTime deEnrollDateField;

//    private bool deEnrollDateFieldSpecified;

//    /// <remarks/>
//    public string receivingBan
//    {
//        get
//        {
//            return this.receivingBanField;
//        }
//        set
//        {
//            this.receivingBanField = value;
//        }
//    }

//    /// <remarks/>
//    public string allowanceId
//    {
//        get
//        {
//            return this.allowanceIdField;
//        }
//        set
//        {
//            this.allowanceIdField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime effectiveDate
//    {
//        get
//        {
//            return this.effectiveDateField;
//        }
//        set
//        {
//            this.effectiveDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool effectiveDateSpecified
//    {
//        get
//        {
//            return this.effectiveDateFieldSpecified;
//        }
//        set
//        {
//            this.effectiveDateFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime enrollDate
//    {
//        get
//        {
//            return this.enrollDateField;
//        }
//        set
//        {
//            this.enrollDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime deEnrollDate
//    {
//        get
//        {
//            return this.deEnrollDateField;
//        }
//        set
//        {
//            this.deEnrollDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool deEnrollDateSpecified
//    {
//        get
//        {
//            return this.deEnrollDateFieldSpecified;
//        }
//        set
//        {
//            this.deEnrollDateFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class DeviceCapabilitiesInfo
//{

//    private string heightField;

//    private string lengthField;

//    private string widthField;

//    private string weightField;

//    private string talkTimeField;

//    private string standByTimeField;

//    private string memoryStorageField;

//    private bool hasRemovableMemoryField;

//    private bool hasRemovableMemoryFieldSpecified;

//    private string removableMemoryTypeField;

//    private string downloadSpeedField;

//    private bool isInternationalField;

//    private bool isInternationalFieldSpecified;

//    private bool isBlueToothField;

//    private bool isBlueToothFieldSpecified;

//    private bool isPrepaidField;

//    private bool isPrepaidFieldSpecified;

//    private bool hasQwertyKeyboardField;

//    private bool hasQwertyKeyboardFieldSpecified;

//    private bool supportsVoiceCommandsField;

//    private bool supportsVoiceCommandsFieldSpecified;

//    private bool supportsTtyField;

//    private bool supportsTtyFieldSpecified;

//    private bool pushToTalkIndicatorField;

//    private bool pushToTalkIndicatorFieldSpecified;

//    private bool multiLanguageSupportField;

//    private bool multiLanguageSupportFieldSpecified;

//    private bool hasPredictiveInputField;

//    private bool hasPredictiveInputFieldSpecified;

//    private bool mP3capabilityField;

//    private bool mP3capabilityFieldSpecified;

//    private string[] dataNetworksField;

//    private string[] includedAccessoriesField;

//    private string[] networkFrequencyField;

//    private string hasSpeakerPhoneField;

//    private string[] messageTypesField;

//    private string[] instantMessagingAppsField;

//    private string[] supportedEmailClientsField;

//    private string wirelessInternetField;

//    private string supportsDigitalCameraField;

//    private string[] downloadCapabilitiesField;

//    private string[] ringToneTypesField;

//    private string[] videoCapabilitiesField;

//    private string learningEdgeNumberField;

//    private string cingularUniversityNumberField;

//    private bool isExternalAntennaField;

//    private bool isExternalAntennaFieldSpecified;

//    private bool ymxIndicatorField;

//    private bool ymxIndicatorFieldSpecified;

//    private string productIdField;

//    private bool support3GField;

//    private bool support3GFieldSpecified;

//    private bool supportMobilityMusicField;

//    private bool supportMobilityMusicFieldSpecified;

//    private bool supportMobilityNavigationField;

//    private bool supportMobilityNavigationFieldSpecified;

//    private bool supportEDGEField;

//    private bool supportEDGEFieldSpecified;

//    private bool supportStreamingRadioField;

//    private bool supportStreamingRadioFieldSpecified;

//    private bool supportTouchScreenField;

//    private bool supportTouchScreenFieldSpecified;

//    private bool supportUSBField;

//    private bool supportUSBFieldSpecified;

//    private bool supportVideoShareField;

//    private bool supportVideoShareFieldSpecified;

//    private string maximumTransferRateField;

//    private string thicknessField;

//    private string[] digitalCameraResolutionField;

//    private string[] compatibleHearingAidField;

//    private string[] interfaceTypeField;

//    private string[] musicFormatField;

//    private string[] windowsMobileVersionField;

//    /// <remarks/>
//    public string height
//    {
//        get
//        {
//            return this.heightField;
//        }
//        set
//        {
//            this.heightField = value;
//        }
//    }

//    /// <remarks/>
//    public string length
//    {
//        get
//        {
//            return this.lengthField;
//        }
//        set
//        {
//            this.lengthField = value;
//        }
//    }

//    /// <remarks/>
//    public string width
//    {
//        get
//        {
//            return this.widthField;
//        }
//        set
//        {
//            this.widthField = value;
//        }
//    }

//    /// <remarks/>
//    public string weight
//    {
//        get
//        {
//            return this.weightField;
//        }
//        set
//        {
//            this.weightField = value;
//        }
//    }

//    /// <remarks/>
//    public string talkTime
//    {
//        get
//        {
//            return this.talkTimeField;
//        }
//        set
//        {
//            this.talkTimeField = value;
//        }
//    }

//    /// <remarks/>
//    public string standByTime
//    {
//        get
//        {
//            return this.standByTimeField;
//        }
//        set
//        {
//            this.standByTimeField = value;
//        }
//    }

//    /// <remarks/>
//    public string memoryStorage
//    {
//        get
//        {
//            return this.memoryStorageField;
//        }
//        set
//        {
//            this.memoryStorageField = value;
//        }
//    }

//    /// <remarks/>
//    public bool hasRemovableMemory
//    {
//        get
//        {
//            return this.hasRemovableMemoryField;
//        }
//        set
//        {
//            this.hasRemovableMemoryField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool hasRemovableMemorySpecified
//    {
//        get
//        {
//            return this.hasRemovableMemoryFieldSpecified;
//        }
//        set
//        {
//            this.hasRemovableMemoryFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public string removableMemoryType
//    {
//        get
//        {
//            return this.removableMemoryTypeField;
//        }
//        set
//        {
//            this.removableMemoryTypeField = value;
//        }
//    }

//    /// <remarks/>
//    public string downloadSpeed
//    {
//        get
//        {
//            return this.downloadSpeedField;
//        }
//        set
//        {
//            this.downloadSpeedField = value;
//        }
//    }

//    /// <remarks/>
//    public bool isInternational
//    {
//        get
//        {
//            return this.isInternationalField;
//        }
//        set
//        {
//            this.isInternationalField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool isInternationalSpecified
//    {
//        get
//        {
//            return this.isInternationalFieldSpecified;
//        }
//        set
//        {
//            this.isInternationalFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool isBlueTooth
//    {
//        get
//        {
//            return this.isBlueToothField;
//        }
//        set
//        {
//            this.isBlueToothField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool isBlueToothSpecified
//    {
//        get
//        {
//            return this.isBlueToothFieldSpecified;
//        }
//        set
//        {
//            this.isBlueToothFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool isPrepaid
//    {
//        get
//        {
//            return this.isPrepaidField;
//        }
//        set
//        {
//            this.isPrepaidField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool isPrepaidSpecified
//    {
//        get
//        {
//            return this.isPrepaidFieldSpecified;
//        }
//        set
//        {
//            this.isPrepaidFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool hasQwertyKeyboard
//    {
//        get
//        {
//            return this.hasQwertyKeyboardField;
//        }
//        set
//        {
//            this.hasQwertyKeyboardField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool hasQwertyKeyboardSpecified
//    {
//        get
//        {
//            return this.hasQwertyKeyboardFieldSpecified;
//        }
//        set
//        {
//            this.hasQwertyKeyboardFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool supportsVoiceCommands
//    {
//        get
//        {
//            return this.supportsVoiceCommandsField;
//        }
//        set
//        {
//            this.supportsVoiceCommandsField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool supportsVoiceCommandsSpecified
//    {
//        get
//        {
//            return this.supportsVoiceCommandsFieldSpecified;
//        }
//        set
//        {
//            this.supportsVoiceCommandsFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool supportsTty
//    {
//        get
//        {
//            return this.supportsTtyField;
//        }
//        set
//        {
//            this.supportsTtyField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool supportsTtySpecified
//    {
//        get
//        {
//            return this.supportsTtyFieldSpecified;
//        }
//        set
//        {
//            this.supportsTtyFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool pushToTalkIndicator
//    {
//        get
//        {
//            return this.pushToTalkIndicatorField;
//        }
//        set
//        {
//            this.pushToTalkIndicatorField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool pushToTalkIndicatorSpecified
//    {
//        get
//        {
//            return this.pushToTalkIndicatorFieldSpecified;
//        }
//        set
//        {
//            this.pushToTalkIndicatorFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool multiLanguageSupport
//    {
//        get
//        {
//            return this.multiLanguageSupportField;
//        }
//        set
//        {
//            this.multiLanguageSupportField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool multiLanguageSupportSpecified
//    {
//        get
//        {
//            return this.multiLanguageSupportFieldSpecified;
//        }
//        set
//        {
//            this.multiLanguageSupportFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool hasPredictiveInput
//    {
//        get
//        {
//            return this.hasPredictiveInputField;
//        }
//        set
//        {
//            this.hasPredictiveInputField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool hasPredictiveInputSpecified
//    {
//        get
//        {
//            return this.hasPredictiveInputFieldSpecified;
//        }
//        set
//        {
//            this.hasPredictiveInputFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool MP3capability
//    {
//        get
//        {
//            return this.mP3capabilityField;
//        }
//        set
//        {
//            this.mP3capabilityField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool MP3capabilitySpecified
//    {
//        get
//        {
//            return this.mP3capabilityFieldSpecified;
//        }
//        set
//        {
//            this.mP3capabilityFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("dataNetworks")]
//    public string[] dataNetworks
//    {
//        get
//        {
//            return this.dataNetworksField;
//        }
//        set
//        {
//            this.dataNetworksField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("includedAccessories")]
//    public string[] includedAccessories
//    {
//        get
//        {
//            return this.includedAccessoriesField;
//        }
//        set
//        {
//            this.includedAccessoriesField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("networkFrequency")]
//    public string[] networkFrequency
//    {
//        get
//        {
//            return this.networkFrequencyField;
//        }
//        set
//        {
//            this.networkFrequencyField = value;
//        }
//    }

//    /// <remarks/>
//    public string hasSpeakerPhone
//    {
//        get
//        {
//            return this.hasSpeakerPhoneField;
//        }
//        set
//        {
//            this.hasSpeakerPhoneField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("messageTypes")]
//    public string[] messageTypes
//    {
//        get
//        {
//            return this.messageTypesField;
//        }
//        set
//        {
//            this.messageTypesField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("instantMessagingApps")]
//    public string[] instantMessagingApps
//    {
//        get
//        {
//            return this.instantMessagingAppsField;
//        }
//        set
//        {
//            this.instantMessagingAppsField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("supportedEmailClients")]
//    public string[] supportedEmailClients
//    {
//        get
//        {
//            return this.supportedEmailClientsField;
//        }
//        set
//        {
//            this.supportedEmailClientsField = value;
//        }
//    }

//    /// <remarks/>
//    public string wirelessInternet
//    {
//        get
//        {
//            return this.wirelessInternetField;
//        }
//        set
//        {
//            this.wirelessInternetField = value;
//        }
//    }

//    /// <remarks/>
//    public string supportsDigitalCamera
//    {
//        get
//        {
//            return this.supportsDigitalCameraField;
//        }
//        set
//        {
//            this.supportsDigitalCameraField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("downloadCapabilities")]
//    public string[] downloadCapabilities
//    {
//        get
//        {
//            return this.downloadCapabilitiesField;
//        }
//        set
//        {
//            this.downloadCapabilitiesField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("ringToneTypes")]
//    public string[] ringToneTypes
//    {
//        get
//        {
//            return this.ringToneTypesField;
//        }
//        set
//        {
//            this.ringToneTypesField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("videoCapabilities")]
//    public string[] videoCapabilities
//    {
//        get
//        {
//            return this.videoCapabilitiesField;
//        }
//        set
//        {
//            this.videoCapabilitiesField = value;
//        }
//    }

//    /// <remarks/>
//    public string learningEdgeNumber
//    {
//        get
//        {
//            return this.learningEdgeNumberField;
//        }
//        set
//        {
//            this.learningEdgeNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public string cingularUniversityNumber
//    {
//        get
//        {
//            return this.cingularUniversityNumberField;
//        }
//        set
//        {
//            this.cingularUniversityNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public bool isExternalAntenna
//    {
//        get
//        {
//            return this.isExternalAntennaField;
//        }
//        set
//        {
//            this.isExternalAntennaField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool isExternalAntennaSpecified
//    {
//        get
//        {
//            return this.isExternalAntennaFieldSpecified;
//        }
//        set
//        {
//            this.isExternalAntennaFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool ymxIndicator
//    {
//        get
//        {
//            return this.ymxIndicatorField;
//        }
//        set
//        {
//            this.ymxIndicatorField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool ymxIndicatorSpecified
//    {
//        get
//        {
//            return this.ymxIndicatorFieldSpecified;
//        }
//        set
//        {
//            this.ymxIndicatorFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public string productId
//    {
//        get
//        {
//            return this.productIdField;
//        }
//        set
//        {
//            this.productIdField = value;
//        }
//    }

//    /// <remarks/>
//    public bool support3G
//    {
//        get
//        {
//            return this.support3GField;
//        }
//        set
//        {
//            this.support3GField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool support3GSpecified
//    {
//        get
//        {
//            return this.support3GFieldSpecified;
//        }
//        set
//        {
//            this.support3GFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool supportMobilityMusic
//    {
//        get
//        {
//            return this.supportMobilityMusicField;
//        }
//        set
//        {
//            this.supportMobilityMusicField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool supportMobilityMusicSpecified
//    {
//        get
//        {
//            return this.supportMobilityMusicFieldSpecified;
//        }
//        set
//        {
//            this.supportMobilityMusicFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool supportMobilityNavigation
//    {
//        get
//        {
//            return this.supportMobilityNavigationField;
//        }
//        set
//        {
//            this.supportMobilityNavigationField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool supportMobilityNavigationSpecified
//    {
//        get
//        {
//            return this.supportMobilityNavigationFieldSpecified;
//        }
//        set
//        {
//            this.supportMobilityNavigationFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool supportEDGE
//    {
//        get
//        {
//            return this.supportEDGEField;
//        }
//        set
//        {
//            this.supportEDGEField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool supportEDGESpecified
//    {
//        get
//        {
//            return this.supportEDGEFieldSpecified;
//        }
//        set
//        {
//            this.supportEDGEFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool supportStreamingRadio
//    {
//        get
//        {
//            return this.supportStreamingRadioField;
//        }
//        set
//        {
//            this.supportStreamingRadioField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool supportStreamingRadioSpecified
//    {
//        get
//        {
//            return this.supportStreamingRadioFieldSpecified;
//        }
//        set
//        {
//            this.supportStreamingRadioFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool supportTouchScreen
//    {
//        get
//        {
//            return this.supportTouchScreenField;
//        }
//        set
//        {
//            this.supportTouchScreenField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool supportTouchScreenSpecified
//    {
//        get
//        {
//            return this.supportTouchScreenFieldSpecified;
//        }
//        set
//        {
//            this.supportTouchScreenFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool supportUSB
//    {
//        get
//        {
//            return this.supportUSBField;
//        }
//        set
//        {
//            this.supportUSBField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool supportUSBSpecified
//    {
//        get
//        {
//            return this.supportUSBFieldSpecified;
//        }
//        set
//        {
//            this.supportUSBFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool supportVideoShare
//    {
//        get
//        {
//            return this.supportVideoShareField;
//        }
//        set
//        {
//            this.supportVideoShareField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool supportVideoShareSpecified
//    {
//        get
//        {
//            return this.supportVideoShareFieldSpecified;
//        }
//        set
//        {
//            this.supportVideoShareFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public string maximumTransferRate
//    {
//        get
//        {
//            return this.maximumTransferRateField;
//        }
//        set
//        {
//            this.maximumTransferRateField = value;
//        }
//    }

//    /// <remarks/>
//    public string thickness
//    {
//        get
//        {
//            return this.thicknessField;
//        }
//        set
//        {
//            this.thicknessField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("digitalCameraResolution")]
//    public string[] digitalCameraResolution
//    {
//        get
//        {
//            return this.digitalCameraResolutionField;
//        }
//        set
//        {
//            this.digitalCameraResolutionField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("compatibleHearingAid")]
//    public string[] compatibleHearingAid
//    {
//        get
//        {
//            return this.compatibleHearingAidField;
//        }
//        set
//        {
//            this.compatibleHearingAidField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("interfaceType")]
//    public string[] interfaceType
//    {
//        get
//        {
//            return this.interfaceTypeField;
//        }
//        set
//        {
//            this.interfaceTypeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("musicFormat")]
//    public string[] musicFormat
//    {
//        get
//        {
//            return this.musicFormatField;
//        }
//        set
//        {
//            this.musicFormatField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("windowsMobileVersion")]
//    public string[] windowsMobileVersion
//    {
//        get
//        {
//            return this.windowsMobileVersionField;
//        }
//        set
//        {
//            this.windowsMobileVersionField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class UnrestrictedDeviceInfo
//{

//    private EquipmentTypeInfo equipmentTypeField;

//    private bool equipmentTypeFieldSpecified;

//    private TechnologyTypeInfo technologyTypeField;

//    private bool technologyTypeFieldSpecified;

//    private string iMSIField;

//    private string iMEIField;

//    private string iMEITypeField;

//    private string iMEIFrequencyField;

//    private string sIMField;

//    private string eSNField;

//    private string mSIDField;

//    private string mINField;

//    private ManufacturerInfo manufacturerField;

//    private bool umtsCapabilityField;

//    private bool umtsCapabilityFieldSpecified;

//    /// <remarks/>
//    public EquipmentTypeInfo equipmentType
//    {
//        get
//        {
//            return this.equipmentTypeField;
//        }
//        set
//        {
//            this.equipmentTypeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool equipmentTypeSpecified
//    {
//        get
//        {
//            return this.equipmentTypeFieldSpecified;
//        }
//        set
//        {
//            this.equipmentTypeFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public TechnologyTypeInfo technologyType
//    {
//        get
//        {
//            return this.technologyTypeField;
//        }
//        set
//        {
//            this.technologyTypeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool technologyTypeSpecified
//    {
//        get
//        {
//            return this.technologyTypeFieldSpecified;
//        }
//        set
//        {
//            this.technologyTypeFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public string IMSI
//    {
//        get
//        {
//            return this.iMSIField;
//        }
//        set
//        {
//            this.iMSIField = value;
//        }
//    }

//    /// <remarks/>
//    public string IMEI
//    {
//        get
//        {
//            return this.iMEIField;
//        }
//        set
//        {
//            this.iMEIField = value;
//        }
//    }

//    /// <remarks/>
//    public string IMEIType
//    {
//        get
//        {
//            return this.iMEITypeField;
//        }
//        set
//        {
//            this.iMEITypeField = value;
//        }
//    }

//    /// <remarks/>
//    public string IMEIFrequency
//    {
//        get
//        {
//            return this.iMEIFrequencyField;
//        }
//        set
//        {
//            this.iMEIFrequencyField = value;
//        }
//    }

//    /// <remarks/>
//    public string SIM
//    {
//        get
//        {
//            return this.sIMField;
//        }
//        set
//        {
//            this.sIMField = value;
//        }
//    }

//    /// <remarks/>
//    public string ESN
//    {
//        get
//        {
//            return this.eSNField;
//        }
//        set
//        {
//            this.eSNField = value;
//        }
//    }

//    /// <remarks/>
//    public string MSID
//    {
//        get
//        {
//            return this.mSIDField;
//        }
//        set
//        {
//            this.mSIDField = value;
//        }
//    }

//    /// <remarks/>
//    public string MIN
//    {
//        get
//        {
//            return this.mINField;
//        }
//        set
//        {
//            this.mINField = value;
//        }
//    }

//    /// <remarks/>
//    public ManufacturerInfo Manufacturer
//    {
//        get
//        {
//            return this.manufacturerField;
//        }
//        set
//        {
//            this.manufacturerField = value;
//        }
//    }

//    /// <remarks/>
//    public bool umtsCapability
//    {
//        get
//        {
//            return this.umtsCapabilityField;
//        }
//        set
//        {
//            this.umtsCapabilityField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool umtsCapabilitySpecified
//    {
//        get
//        {
//            return this.umtsCapabilityFieldSpecified;
//        }
//        set
//        {
//            this.umtsCapabilityFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class SubscriberIndicatorsInfo
//{

//    private bool splitLiabilityField;

//    private bool splitLiabilityFieldSpecified;

//    private bool pttFeatureField;

//    private VoiceMailPlatformInfo vmPlatformTypeField;

//    private bool vmPlatformTypeFieldSpecified;

//    private double cbDiscountMRCThresholdField;

//    private bool cbDiscountMRCThresholdFieldSpecified;

//    public SubscriberIndicatorsInfo()
//    {
//        this.splitLiabilityField = true;
//        this.pttFeatureField = false;
//    }

//    /// <remarks/>
//    public bool splitLiability
//    {
//        get
//        {
//            return this.splitLiabilityField;
//        }
//        set
//        {
//            this.splitLiabilityField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool splitLiabilitySpecified
//    {
//        get
//        {
//            return this.splitLiabilityFieldSpecified;
//        }
//        set
//        {
//            this.splitLiabilityFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool pttFeature
//    {
//        get
//        {
//            return this.pttFeatureField;
//        }
//        set
//        {
//            this.pttFeatureField = value;
//        }
//    }

//    /// <remarks/>
//    public VoiceMailPlatformInfo vmPlatformType
//    {
//        get
//        {
//            return this.vmPlatformTypeField;
//        }
//        set
//        {
//            this.vmPlatformTypeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool vmPlatformTypeSpecified
//    {
//        get
//        {
//            return this.vmPlatformTypeFieldSpecified;
//        }
//        set
//        {
//            this.vmPlatformTypeFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public double cbDiscountMRCThreshold
//    {
//        get
//        {
//            return this.cbDiscountMRCThresholdField;
//        }
//        set
//        {
//            this.cbDiscountMRCThresholdField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool cbDiscountMRCThresholdSpecified
//    {
//        get
//        {
//            return this.cbDiscountMRCThresholdFieldSpecified;
//        }
//        set
//        {
//            this.cbDiscountMRCThresholdFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum VoiceMailPlatformInfo
//{

//    /// <remarks/>
//    B,

//    /// <remarks/>
//    A,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class PreviousUsageInfo
//{

//    private PreviousUsageInfoSubscriberVoiceUsage subscriberVoiceUsageField;

//    private PreviousUsageInfoGroupVoiceUsage groupVoiceUsageField;

//    private PreviousUsageInfoSubscriberDataUsage subscriberDataUsageField;

//    private GroupDataUsageInfo[] groupDataUsageField;

//    /// <remarks/>
//    public PreviousUsageInfoSubscriberVoiceUsage SubscriberVoiceUsage
//    {
//        get
//        {
//            return this.subscriberVoiceUsageField;
//        }
//        set
//        {
//            this.subscriberVoiceUsageField = value;
//        }
//    }

//    /// <remarks/>
//    public PreviousUsageInfoGroupVoiceUsage GroupVoiceUsage
//    {
//        get
//        {
//            return this.groupVoiceUsageField;
//        }
//        set
//        {
//            this.groupVoiceUsageField = value;
//        }
//    }

//    /// <remarks/>
//    public PreviousUsageInfoSubscriberDataUsage SubscriberDataUsage
//    {
//        get
//        {
//            return this.subscriberDataUsageField;
//        }
//        set
//        {
//            this.subscriberDataUsageField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlArrayItemAttribute("GroupDataUsageSummary", IsNullable = false)]
//    public GroupDataUsageInfo[] GroupDataUsage
//    {
//        get
//        {
//            return this.groupDataUsageField;
//        }
//        set
//        {
//            this.groupDataUsageField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class PreviousUsageInfoSubscriberVoiceUsage
//{

//    private PricePlanVoiceUsageInfo[] pricePlanUsageSummaryField;

//    private OfferVoiceUsageInfo[] offerUsageSummaryField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("PricePlanUsageSummary")]
//    public PricePlanVoiceUsageInfo[] PricePlanUsageSummary
//    {
//        get
//        {
//            return this.pricePlanUsageSummaryField;
//        }
//        set
//        {
//            this.pricePlanUsageSummaryField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("OfferUsageSummary")]
//    public OfferVoiceUsageInfo[] OfferUsageSummary
//    {
//        get
//        {
//            return this.offerUsageSummaryField;
//        }
//        set
//        {
//            this.offerUsageSummaryField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class PricePlanVoiceUsageInfo
//{

//    private string subscriberPricePlanCodeField;

//    private string pricePlanDescriptionField;

//    private EffectiveDateTimesInfo pricePlanEffectiveDatesField;

//    private System.DateTime eventsThroughField;

//    private double overageMinutesField;

//    private bool overageMinutesFieldSpecified;

//    private RolloverExpirationInfo rolloverExpirationField;

//    private MinutesUsageInfo[] usageDetailField;

//    /// <remarks/>
//    public string subscriberPricePlanCode
//    {
//        get
//        {
//            return this.subscriberPricePlanCodeField;
//        }
//        set
//        {
//            this.subscriberPricePlanCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string pricePlanDescription
//    {
//        get
//        {
//            return this.pricePlanDescriptionField;
//        }
//        set
//        {
//            this.pricePlanDescriptionField = value;
//        }
//    }

//    /// <remarks/>
//    public EffectiveDateTimesInfo PricePlanEffectiveDates
//    {
//        get
//        {
//            return this.pricePlanEffectiveDatesField;
//        }
//        set
//        {
//            this.pricePlanEffectiveDatesField = value;
//        }
//    }

//    /// <remarks/>
//    public System.DateTime eventsThrough
//    {
//        get
//        {
//            return this.eventsThroughField;
//        }
//        set
//        {
//            this.eventsThroughField = value;
//        }
//    }

//    /// <remarks/>
//    public double OverageMinutes
//    {
//        get
//        {
//            return this.overageMinutesField;
//        }
//        set
//        {
//            this.overageMinutesField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool OverageMinutesSpecified
//    {
//        get
//        {
//            return this.overageMinutesFieldSpecified;
//        }
//        set
//        {
//            this.overageMinutesFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public RolloverExpirationInfo RolloverExpiration
//    {
//        get
//        {
//            return this.rolloverExpirationField;
//        }
//        set
//        {
//            this.rolloverExpirationField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("UsageDetail")]
//    public MinutesUsageInfo[] UsageDetail
//    {
//        get
//        {
//            return this.usageDetailField;
//        }
//        set
//        {
//            this.usageDetailField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class EffectiveDateTimesInfo
//{

//    private System.DateTime effectiveDateTimeField;

//    private System.DateTime expirationDateTimeField;

//    private bool expirationDateTimeFieldSpecified;

//    /// <remarks/>
//    public System.DateTime effectiveDateTime
//    {
//        get
//        {
//            return this.effectiveDateTimeField;
//        }
//        set
//        {
//            this.effectiveDateTimeField = value;
//        }
//    }

//    /// <remarks/>
//    public System.DateTime expirationDateTime
//    {
//        get
//        {
//            return this.expirationDateTimeField;
//        }
//        set
//        {
//            this.expirationDateTimeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool expirationDateTimeSpecified
//    {
//        get
//        {
//            return this.expirationDateTimeFieldSpecified;
//        }
//        set
//        {
//            this.expirationDateTimeFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class RolloverExpirationInfo
//{

//    private double expiringRolloverMinutesBalanceField;

//    private System.DateTime expiringRolloverMinutesDateField;

//    /// <remarks/>
//    public double expiringRolloverMinutesBalance
//    {
//        get
//        {
//            return this.expiringRolloverMinutesBalanceField;
//        }
//        set
//        {
//            this.expiringRolloverMinutesBalanceField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime expiringRolloverMinutesDate
//    {
//        get
//        {
//            return this.expiringRolloverMinutesDateField;
//        }
//        set
//        {
//            this.expiringRolloverMinutesDateField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class MinutesUsageInfo
//{

//    private string usageCategoryField;

//    private double allottedMinutesField;

//    private double usedMinutesField;

//    private double remainingMinutesField;

//    /// <remarks/>
//    public string usageCategory
//    {
//        get
//        {
//            return this.usageCategoryField;
//        }
//        set
//        {
//            this.usageCategoryField = value;
//        }
//    }

//    /// <remarks/>
//    public double allottedMinutes
//    {
//        get
//        {
//            return this.allottedMinutesField;
//        }
//        set
//        {
//            this.allottedMinutesField = value;
//        }
//    }

//    /// <remarks/>
//    public double usedMinutes
//    {
//        get
//        {
//            return this.usedMinutesField;
//        }
//        set
//        {
//            this.usedMinutesField = value;
//        }
//    }

//    /// <remarks/>
//    public double remainingMinutes
//    {
//        get
//        {
//            return this.remainingMinutesField;
//        }
//        set
//        {
//            this.remainingMinutesField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class OfferVoiceUsageInfo
//{

//    private string offerCodeField;

//    private string offerDescriptionField;

//    private System.DateTime offerEffectiveDateField;

//    private System.DateTime offerExpirationDateField;

//    private bool offerExpirationDateFieldSpecified;

//    private System.DateTime eventsThroughField;

//    private OfferMinutesUsageInfo[] usageDetailField;

//    /// <remarks/>
//    public string offerCode
//    {
//        get
//        {
//            return this.offerCodeField;
//        }
//        set
//        {
//            this.offerCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string offerDescription
//    {
//        get
//        {
//            return this.offerDescriptionField;
//        }
//        set
//        {
//            this.offerDescriptionField = value;
//        }
//    }

//    /// <remarks/>
//    public System.DateTime offerEffectiveDate
//    {
//        get
//        {
//            return this.offerEffectiveDateField;
//        }
//        set
//        {
//            this.offerEffectiveDateField = value;
//        }
//    }

//    /// <remarks/>
//    public System.DateTime offerExpirationDate
//    {
//        get
//        {
//            return this.offerExpirationDateField;
//        }
//        set
//        {
//            this.offerExpirationDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool offerExpirationDateSpecified
//    {
//        get
//        {
//            return this.offerExpirationDateFieldSpecified;
//        }
//        set
//        {
//            this.offerExpirationDateFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public System.DateTime eventsThrough
//    {
//        get
//        {
//            return this.eventsThroughField;
//        }
//        set
//        {
//            this.eventsThroughField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("UsageDetail")]
//    public OfferMinutesUsageInfo[] UsageDetail
//    {
//        get
//        {
//            return this.usageDetailField;
//        }
//        set
//        {
//            this.usageDetailField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class OfferMinutesUsageInfo
//{

//    private string usageCategoryField;

//    private RoamingIndicator roamingIndicatorField;

//    private bool roamingIndicatorFieldSpecified;

//    private double allottedMinutesField;

//    private double usedMinutesField;

//    private double remainingMinutesField;

//    private double overageMinutesField;

//    private bool overageMinutesFieldSpecified;

//    /// <remarks/>
//    public string usageCategory
//    {
//        get
//        {
//            return this.usageCategoryField;
//        }
//        set
//        {
//            this.usageCategoryField = value;
//        }
//    }

//    /// <remarks/>
//    public RoamingIndicator roamingIndicator
//    {
//        get
//        {
//            return this.roamingIndicatorField;
//        }
//        set
//        {
//            this.roamingIndicatorField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool roamingIndicatorSpecified
//    {
//        get
//        {
//            return this.roamingIndicatorFieldSpecified;
//        }
//        set
//        {
//            this.roamingIndicatorFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public double allottedMinutes
//    {
//        get
//        {
//            return this.allottedMinutesField;
//        }
//        set
//        {
//            this.allottedMinutesField = value;
//        }
//    }

//    /// <remarks/>
//    public double usedMinutes
//    {
//        get
//        {
//            return this.usedMinutesField;
//        }
//        set
//        {
//            this.usedMinutesField = value;
//        }
//    }

//    /// <remarks/>
//    public double remainingMinutes
//    {
//        get
//        {
//            return this.remainingMinutesField;
//        }
//        set
//        {
//            this.remainingMinutesField = value;
//        }
//    }

//    /// <remarks/>
//    public double OverageMinutes
//    {
//        get
//        {
//            return this.overageMinutesField;
//        }
//        set
//        {
//            this.overageMinutesField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool OverageMinutesSpecified
//    {
//        get
//        {
//            return this.overageMinutesFieldSpecified;
//        }
//        set
//        {
//            this.overageMinutesFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum RoamingIndicator
//{

//    /// <remarks/>
//    H,

//    /// <remarks/>
//    R,

//    /// <remarks/>
//    I,

//    /// <remarks/>
//    B,

//    /// <remarks/>
//    D,

//    /// <remarks/>
//    U,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class PreviousUsageInfoGroupVoiceUsage
//{

//    private GroupPlanVoiceUsageInfo[] groupPlanUsageSummaryField;

//    private GroupOfferVoiceUsageInfo[] groupOfferUsageSummaryField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("GroupPlanUsageSummary")]
//    public GroupPlanVoiceUsageInfo[] GroupPlanUsageSummary
//    {
//        get
//        {
//            return this.groupPlanUsageSummaryField;
//        }
//        set
//        {
//            this.groupPlanUsageSummaryField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("GroupOfferUsageSummary")]
//    public GroupOfferVoiceUsageInfo[] GroupOfferUsageSummary
//    {
//        get
//        {
//            return this.groupOfferUsageSummaryField;
//        }
//        set
//        {
//            this.groupOfferUsageSummaryField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class GroupPlanVoiceUsageInfo
//{

//    private GroupPlanVoiceUsageInfoPricePlanGroupInfo pricePlanGroupInfoField;

//    private string pricePlanDescriptionField;

//    private EffectiveDateTimesInfo pricePlanEffectiveDatesField;

//    private System.DateTime eventsThroughField;

//    private double overageMinutesField;

//    private bool overageMinutesFieldSpecified;

//    private RolloverExpirationInfo rolloverExpirationField;

//    private MinutesUsageInfo[] usageDetailField;

//    private GroupPlanVoiceUsageInfoGroupSubscriberUsageDetail[] groupSubscriberUsageDetailField;

//    /// <remarks/>
//    public GroupPlanVoiceUsageInfoPricePlanGroupInfo PricePlanGroupInfo
//    {
//        get
//        {
//            return this.pricePlanGroupInfoField;
//        }
//        set
//        {
//            this.pricePlanGroupInfoField = value;
//        }
//    }

//    /// <remarks/>
//    public string pricePlanDescription
//    {
//        get
//        {
//            return this.pricePlanDescriptionField;
//        }
//        set
//        {
//            this.pricePlanDescriptionField = value;
//        }
//    }

//    /// <remarks/>
//    public EffectiveDateTimesInfo PricePlanEffectiveDates
//    {
//        get
//        {
//            return this.pricePlanEffectiveDatesField;
//        }
//        set
//        {
//            this.pricePlanEffectiveDatesField = value;
//        }
//    }

//    /// <remarks/>
//    public System.DateTime eventsThrough
//    {
//        get
//        {
//            return this.eventsThroughField;
//        }
//        set
//        {
//            this.eventsThroughField = value;
//        }
//    }

//    /// <remarks/>
//    public double OverageMinutes
//    {
//        get
//        {
//            return this.overageMinutesField;
//        }
//        set
//        {
//            this.overageMinutesField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool OverageMinutesSpecified
//    {
//        get
//        {
//            return this.overageMinutesFieldSpecified;
//        }
//        set
//        {
//            this.overageMinutesFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public RolloverExpirationInfo RolloverExpiration
//    {
//        get
//        {
//            return this.rolloverExpirationField;
//        }
//        set
//        {
//            this.rolloverExpirationField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("UsageDetail")]
//    public MinutesUsageInfo[] UsageDetail
//    {
//        get
//        {
//            return this.usageDetailField;
//        }
//        set
//        {
//            this.usageDetailField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("GroupSubscriberUsageDetail")]
//    public GroupPlanVoiceUsageInfoGroupSubscriberUsageDetail[] GroupSubscriberUsageDetail
//    {
//        get
//        {
//            return this.groupSubscriberUsageDetailField;
//        }
//        set
//        {
//            this.groupSubscriberUsageDetailField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class GroupPlanVoiceUsageInfoPricePlanGroupInfo
//{

//    private string groupPlanCodeField;

//    private string primarySubscriberField;

//    /// <remarks/>
//    public string groupPlanCode
//    {
//        get
//        {
//            return this.groupPlanCodeField;
//        }
//        set
//        {
//            this.groupPlanCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string primarySubscriber
//    {
//        get
//        {
//            return this.primarySubscriberField;
//        }
//        set
//        {
//            this.primarySubscriberField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class GroupPlanVoiceUsageInfoGroupSubscriberUsageDetail
//{

//    private string subscriberNumberField;

//    private GroupPlanVoiceUsageInfoGroupSubscriberUsageDetailSubscriberUsageDetail[] subscriberUsageDetailField;

//    /// <remarks/>
//    public string subscriberNumber
//    {
//        get
//        {
//            return this.subscriberNumberField;
//        }
//        set
//        {
//            this.subscriberNumberField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("SubscriberUsageDetail")]
//    public GroupPlanVoiceUsageInfoGroupSubscriberUsageDetailSubscriberUsageDetail[] SubscriberUsageDetail
//    {
//        get
//        {
//            return this.subscriberUsageDetailField;
//        }
//        set
//        {
//            this.subscriberUsageDetailField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class GroupPlanVoiceUsageInfoGroupSubscriberUsageDetailSubscriberUsageDetail
//{

//    private string usageCategoryField;

//    private double usedMinutesField;

//    /// <remarks/>
//    public string usageCategory
//    {
//        get
//        {
//            return this.usageCategoryField;
//        }
//        set
//        {
//            this.usageCategoryField = value;
//        }
//    }

//    /// <remarks/>
//    public double usedMinutes
//    {
//        get
//        {
//            return this.usedMinutesField;
//        }
//        set
//        {
//            this.usedMinutesField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class GroupOfferVoiceUsageInfo
//{

//    private string offerCodeField;

//    private string offerDescriptionField;

//    private System.DateTime offerEffectiveDateField;

//    private System.DateTime offerExpirationDateField;

//    private bool offerExpirationDateFieldSpecified;

//    private System.DateTime eventsThroughField;

//    private OfferMinutesUsageInfo[] usageDetailField;

//    private GroupOfferVoiceUsageInfoGroupSubscriberUsageDetail[] groupSubscriberUsageDetailField;

//    /// <remarks/>
//    public string offerCode
//    {
//        get
//        {
//            return this.offerCodeField;
//        }
//        set
//        {
//            this.offerCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string offerDescription
//    {
//        get
//        {
//            return this.offerDescriptionField;
//        }
//        set
//        {
//            this.offerDescriptionField = value;
//        }
//    }

//    /// <remarks/>
//    public System.DateTime offerEffectiveDate
//    {
//        get
//        {
//            return this.offerEffectiveDateField;
//        }
//        set
//        {
//            this.offerEffectiveDateField = value;
//        }
//    }

//    /// <remarks/>
//    public System.DateTime offerExpirationDate
//    {
//        get
//        {
//            return this.offerExpirationDateField;
//        }
//        set
//        {
//            this.offerExpirationDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool offerExpirationDateSpecified
//    {
//        get
//        {
//            return this.offerExpirationDateFieldSpecified;
//        }
//        set
//        {
//            this.offerExpirationDateFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public System.DateTime eventsThrough
//    {
//        get
//        {
//            return this.eventsThroughField;
//        }
//        set
//        {
//            this.eventsThroughField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("UsageDetail")]
//    public OfferMinutesUsageInfo[] UsageDetail
//    {
//        get
//        {
//            return this.usageDetailField;
//        }
//        set
//        {
//            this.usageDetailField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("GroupSubscriberUsageDetail")]
//    public GroupOfferVoiceUsageInfoGroupSubscriberUsageDetail[] GroupSubscriberUsageDetail
//    {
//        get
//        {
//            return this.groupSubscriberUsageDetailField;
//        }
//        set
//        {
//            this.groupSubscriberUsageDetailField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class GroupOfferVoiceUsageInfoGroupSubscriberUsageDetail
//{

//    private string subscriberNumberField;

//    private GroupOfferVoiceUsageInfoGroupSubscriberUsageDetailSubscriberUsageDetail[] subscriberUsageDetailField;

//    /// <remarks/>
//    public string subscriberNumber
//    {
//        get
//        {
//            return this.subscriberNumberField;
//        }
//        set
//        {
//            this.subscriberNumberField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("SubscriberUsageDetail")]
//    public GroupOfferVoiceUsageInfoGroupSubscriberUsageDetailSubscriberUsageDetail[] SubscriberUsageDetail
//    {
//        get
//        {
//            return this.subscriberUsageDetailField;
//        }
//        set
//        {
//            this.subscriberUsageDetailField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class GroupOfferVoiceUsageInfoGroupSubscriberUsageDetailSubscriberUsageDetail
//{

//    private string usageCategoryField;

//    private RoamingIndicator roamingIndicatorField;

//    private bool roamingIndicatorFieldSpecified;

//    private double usedMinutesField;

//    private double overageMinutesField;

//    private bool overageMinutesFieldSpecified;

//    /// <remarks/>
//    public string usageCategory
//    {
//        get
//        {
//            return this.usageCategoryField;
//        }
//        set
//        {
//            this.usageCategoryField = value;
//        }
//    }

//    /// <remarks/>
//    public RoamingIndicator roamingIndicator
//    {
//        get
//        {
//            return this.roamingIndicatorField;
//        }
//        set
//        {
//            this.roamingIndicatorField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool roamingIndicatorSpecified
//    {
//        get
//        {
//            return this.roamingIndicatorFieldSpecified;
//        }
//        set
//        {
//            this.roamingIndicatorFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public double usedMinutes
//    {
//        get
//        {
//            return this.usedMinutesField;
//        }
//        set
//        {
//            this.usedMinutesField = value;
//        }
//    }

//    /// <remarks/>
//    public double OverageMinutes
//    {
//        get
//        {
//            return this.overageMinutesField;
//        }
//        set
//        {
//            this.overageMinutesField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool OverageMinutesSpecified
//    {
//        get
//        {
//            return this.overageMinutesFieldSpecified;
//        }
//        set
//        {
//            this.overageMinutesFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class PreviousUsageInfoSubscriberDataUsage
//{

//    private decimal totalChargeAmountField;

//    private bool totalChargeAmountFieldSpecified;

//    private SubscriberDataUsageInfo[] dataUsageSummaryField;

//    /// <remarks/>
//    public decimal totalChargeAmount
//    {
//        get
//        {
//            return this.totalChargeAmountField;
//        }
//        set
//        {
//            this.totalChargeAmountField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool totalChargeAmountSpecified
//    {
//        get
//        {
//            return this.totalChargeAmountFieldSpecified;
//        }
//        set
//        {
//            this.totalChargeAmountFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("DataUsageSummary")]
//    public SubscriberDataUsageInfo[] DataUsageSummary
//    {
//        get
//        {
//            return this.dataUsageSummaryField;
//        }
//        set
//        {
//            this.dataUsageSummaryField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class SubscriberDataUsageInfo
//{

//    private string offerCodeField;

//    private string offerDescriptionField;

//    private System.DateTime offerEffectiveDateField;

//    private System.DateTime offerExpirationDateField;

//    private bool offerExpirationDateFieldSpecified;

//    private System.DateTime eventsThroughField;

//    private DataUOM unitOfMeasureField;

//    private bool unitOfMeasureFieldSpecified;

//    private RoamingIndicator roamingIndicatorField;

//    private double overageUnitsField;

//    private bool overageUnitsFieldSpecified;

//    private DataUsageInfo[] usageDetailField;

//    /// <remarks/>
//    public string offerCode
//    {
//        get
//        {
//            return this.offerCodeField;
//        }
//        set
//        {
//            this.offerCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string offerDescription
//    {
//        get
//        {
//            return this.offerDescriptionField;
//        }
//        set
//        {
//            this.offerDescriptionField = value;
//        }
//    }

//    /// <remarks/>
//    public System.DateTime offerEffectiveDate
//    {
//        get
//        {
//            return this.offerEffectiveDateField;
//        }
//        set
//        {
//            this.offerEffectiveDateField = value;
//        }
//    }

//    /// <remarks/>
//    public System.DateTime offerExpirationDate
//    {
//        get
//        {
//            return this.offerExpirationDateField;
//        }
//        set
//        {
//            this.offerExpirationDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool offerExpirationDateSpecified
//    {
//        get
//        {
//            return this.offerExpirationDateFieldSpecified;
//        }
//        set
//        {
//            this.offerExpirationDateFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public System.DateTime eventsThrough
//    {
//        get
//        {
//            return this.eventsThroughField;
//        }
//        set
//        {
//            this.eventsThroughField = value;
//        }
//    }

//    /// <remarks/>
//    public DataUOM UnitOfMeasure
//    {
//        get
//        {
//            return this.unitOfMeasureField;
//        }
//        set
//        {
//            this.unitOfMeasureField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool UnitOfMeasureSpecified
//    {
//        get
//        {
//            return this.unitOfMeasureFieldSpecified;
//        }
//        set
//        {
//            this.unitOfMeasureFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public RoamingIndicator RoamingIndicator
//    {
//        get
//        {
//            return this.roamingIndicatorField;
//        }
//        set
//        {
//            this.roamingIndicatorField = value;
//        }
//    }

//    /// <remarks/>
//    public double OverageUnits
//    {
//        get
//        {
//            return this.overageUnitsField;
//        }
//        set
//        {
//            this.overageUnitsField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool OverageUnitsSpecified
//    {
//        get
//        {
//            return this.overageUnitsFieldSpecified;
//        }
//        set
//        {
//            this.overageUnitsFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("UsageDetail")]
//    public DataUsageInfo[] UsageDetail
//    {
//        get
//        {
//            return this.usageDetailField;
//        }
//        set
//        {
//            this.usageDetailField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum DataUOM
//{

//    /// <remarks/>
//    BY,

//    /// <remarks/>
//    KB,

//    /// <remarks/>
//    MB,

//    /// <remarks/>
//    GB,

//    /// <remarks/>
//    TB,

//    /// <remarks/>
//    MI,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class DataUsageInfo
//{

//    private string usageCategoryField;

//    private decimal allottedUnitsField;

//    private decimal usedUnitsField;

//    private decimal remainingUnitsField;

//    /// <remarks/>
//    public string usageCategory
//    {
//        get
//        {
//            return this.usageCategoryField;
//        }
//        set
//        {
//            this.usageCategoryField = value;
//        }
//    }

//    /// <remarks/>
//    public decimal allottedUnits
//    {
//        get
//        {
//            return this.allottedUnitsField;
//        }
//        set
//        {
//            this.allottedUnitsField = value;
//        }
//    }

//    /// <remarks/>
//    public decimal usedUnits
//    {
//        get
//        {
//            return this.usedUnitsField;
//        }
//        set
//        {
//            this.usedUnitsField = value;
//        }
//    }

//    /// <remarks/>
//    public decimal remainingUnits
//    {
//        get
//        {
//            return this.remainingUnitsField;
//        }
//        set
//        {
//            this.remainingUnitsField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class GroupDataUsageInfo
//{

//    private string offerCodeField;

//    private string offerDescriptionField;

//    private System.DateTime offerEffectiveDateField;

//    private System.DateTime offerExpirationDateField;

//    private bool offerExpirationDateFieldSpecified;

//    private System.DateTime eventsThroughField;

//    private DataUOM unitOfMeasureField;

//    private bool unitOfMeasureFieldSpecified;

//    private RoamingIndicator roamingIndicatorField;

//    private double overageUnitsField;

//    private bool overageUnitsFieldSpecified;

//    private DataUsageInfo[] usageDetailField;

//    private GroupDataUsageInfoGroupSubscriberUsageDetail[] groupSubscriberUsageDetailField;

//    /// <remarks/>
//    public string offerCode
//    {
//        get
//        {
//            return this.offerCodeField;
//        }
//        set
//        {
//            this.offerCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string offerDescription
//    {
//        get
//        {
//            return this.offerDescriptionField;
//        }
//        set
//        {
//            this.offerDescriptionField = value;
//        }
//    }

//    /// <remarks/>
//    public System.DateTime offerEffectiveDate
//    {
//        get
//        {
//            return this.offerEffectiveDateField;
//        }
//        set
//        {
//            this.offerEffectiveDateField = value;
//        }
//    }

//    /// <remarks/>
//    public System.DateTime offerExpirationDate
//    {
//        get
//        {
//            return this.offerExpirationDateField;
//        }
//        set
//        {
//            this.offerExpirationDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool offerExpirationDateSpecified
//    {
//        get
//        {
//            return this.offerExpirationDateFieldSpecified;
//        }
//        set
//        {
//            this.offerExpirationDateFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public System.DateTime eventsThrough
//    {
//        get
//        {
//            return this.eventsThroughField;
//        }
//        set
//        {
//            this.eventsThroughField = value;
//        }
//    }

//    /// <remarks/>
//    public DataUOM unitOfMeasure
//    {
//        get
//        {
//            return this.unitOfMeasureField;
//        }
//        set
//        {
//            this.unitOfMeasureField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool unitOfMeasureSpecified
//    {
//        get
//        {
//            return this.unitOfMeasureFieldSpecified;
//        }
//        set
//        {
//            this.unitOfMeasureFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public RoamingIndicator roamingIndicator
//    {
//        get
//        {
//            return this.roamingIndicatorField;
//        }
//        set
//        {
//            this.roamingIndicatorField = value;
//        }
//    }

//    /// <remarks/>
//    public double overageUnits
//    {
//        get
//        {
//            return this.overageUnitsField;
//        }
//        set
//        {
//            this.overageUnitsField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool overageUnitsSpecified
//    {
//        get
//        {
//            return this.overageUnitsFieldSpecified;
//        }
//        set
//        {
//            this.overageUnitsFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("usageDetail")]
//    public DataUsageInfo[] usageDetail
//    {
//        get
//        {
//            return this.usageDetailField;
//        }
//        set
//        {
//            this.usageDetailField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("GroupSubscriberUsageDetail")]
//    public GroupDataUsageInfoGroupSubscriberUsageDetail[] GroupSubscriberUsageDetail
//    {
//        get
//        {
//            return this.groupSubscriberUsageDetailField;
//        }
//        set
//        {
//            this.groupSubscriberUsageDetailField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class GroupDataUsageInfoGroupSubscriberUsageDetail
//{

//    private string subscriberNumberField;

//    private GroupDataUsageInfoGroupSubscriberUsageDetailSubscriberUsageDetail[] subscriberUsageDetailField;

//    /// <remarks/>
//    public string subscriberNumber
//    {
//        get
//        {
//            return this.subscriberNumberField;
//        }
//        set
//        {
//            this.subscriberNumberField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("SubscriberUsageDetail")]
//    public GroupDataUsageInfoGroupSubscriberUsageDetailSubscriberUsageDetail[] SubscriberUsageDetail
//    {
//        get
//        {
//            return this.subscriberUsageDetailField;
//        }
//        set
//        {
//            this.subscriberUsageDetailField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class GroupDataUsageInfoGroupSubscriberUsageDetailSubscriberUsageDetail
//{

//    private string usageCategoryField;

//    private RoamingIndicator roamingIndicatorField;

//    private bool roamingIndicatorFieldSpecified;

//    private DataUOM unitOfMeasureField;

//    private bool unitOfMeasureFieldSpecified;

//    private decimal usedUnitsField;

//    private double overageUnitsField;

//    private bool overageUnitsFieldSpecified;

//    /// <remarks/>
//    public string usageCategory
//    {
//        get
//        {
//            return this.usageCategoryField;
//        }
//        set
//        {
//            this.usageCategoryField = value;
//        }
//    }

//    /// <remarks/>
//    public RoamingIndicator roamingIndicator
//    {
//        get
//        {
//            return this.roamingIndicatorField;
//        }
//        set
//        {
//            this.roamingIndicatorField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool roamingIndicatorSpecified
//    {
//        get
//        {
//            return this.roamingIndicatorFieldSpecified;
//        }
//        set
//        {
//            this.roamingIndicatorFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public DataUOM unitOfMeasure
//    {
//        get
//        {
//            return this.unitOfMeasureField;
//        }
//        set
//        {
//            this.unitOfMeasureField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool unitOfMeasureSpecified
//    {
//        get
//        {
//            return this.unitOfMeasureFieldSpecified;
//        }
//        set
//        {
//            this.unitOfMeasureFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public decimal usedUnits
//    {
//        get
//        {
//            return this.usedUnitsField;
//        }
//        set
//        {
//            this.usedUnitsField = value;
//        }
//    }

//    /// <remarks/>
//    public double overageUnits
//    {
//        get
//        {
//            return this.overageUnitsField;
//        }
//        set
//        {
//            this.overageUnitsField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool overageUnitsSpecified
//    {
//        get
//        {
//            return this.overageUnitsFieldSpecified;
//        }
//        set
//        {
//            this.overageUnitsFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class UsageInfo
//{

//    private UsageInfoSubscriberVoiceUsage subscriberVoiceUsageField;

//    private UsageInfoGroupVoiceUsage groupVoiceUsageField;

//    private SubscriberDataUsageInfo[] subscriberDataUsageField;

//    private GroupDataUsageInfo[] groupDataUsageField;

//    /// <remarks/>
//    public UsageInfoSubscriberVoiceUsage SubscriberVoiceUsage
//    {
//        get
//        {
//            return this.subscriberVoiceUsageField;
//        }
//        set
//        {
//            this.subscriberVoiceUsageField = value;
//        }
//    }

//    /// <remarks/>
//    public UsageInfoGroupVoiceUsage GroupVoiceUsage
//    {
//        get
//        {
//            return this.groupVoiceUsageField;
//        }
//        set
//        {
//            this.groupVoiceUsageField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlArrayItemAttribute("DataUsageSummary", IsNullable = false)]
//    public SubscriberDataUsageInfo[] SubscriberDataUsage
//    {
//        get
//        {
//            return this.subscriberDataUsageField;
//        }
//        set
//        {
//            this.subscriberDataUsageField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlArrayItemAttribute("GroupDataUsageSummary", IsNullable = false)]
//    public GroupDataUsageInfo[] GroupDataUsage
//    {
//        get
//        {
//            return this.groupDataUsageField;
//        }
//        set
//        {
//            this.groupDataUsageField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class UsageInfoSubscriberVoiceUsage
//{

//    private PricePlanVoiceUsageInfo[] pricePlanUsageSummaryField;

//    private OfferVoiceUsageInfo[] offerUsageSummaryField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("PricePlanUsageSummary")]
//    public PricePlanVoiceUsageInfo[] PricePlanUsageSummary
//    {
//        get
//        {
//            return this.pricePlanUsageSummaryField;
//        }
//        set
//        {
//            this.pricePlanUsageSummaryField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("OfferUsageSummary")]
//    public OfferVoiceUsageInfo[] OfferUsageSummary
//    {
//        get
//        {
//            return this.offerUsageSummaryField;
//        }
//        set
//        {
//            this.offerUsageSummaryField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class UsageInfoGroupVoiceUsage
//{

//    private GroupPlanVoiceUsageInfo[] groupPlanUsageSummaryField;

//    private GroupOfferVoiceUsageInfo[] groupOfferUsageSummaryField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("GroupPlanUsageSummary")]
//    public GroupPlanVoiceUsageInfo[] GroupPlanUsageSummary
//    {
//        get
//        {
//            return this.groupPlanUsageSummaryField;
//        }
//        set
//        {
//            this.groupPlanUsageSummaryField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("GroupOfferUsageSummary")]
//    public GroupOfferVoiceUsageInfo[] GroupOfferUsageSummary
//    {
//        get
//        {
//            return this.groupOfferUsageSummaryField;
//        }
//        set
//        {
//            this.groupOfferUsageSummaryField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class UserDefinedLabelsInfo
//{

//    private string label1Field;

//    private string label2Field;

//    private string label3Field;

//    private string label4Field;

//    /// <remarks/>
//    public string label1
//    {
//        get
//        {
//            return this.label1Field;
//        }
//        set
//        {
//            this.label1Field = value;
//        }
//    }

//    /// <remarks/>
//    public string label2
//    {
//        get
//        {
//            return this.label2Field;
//        }
//        set
//        {
//            this.label2Field = value;
//        }
//    }

//    /// <remarks/>
//    public string label3
//    {
//        get
//        {
//            return this.label3Field;
//        }
//        set
//        {
//            this.label3Field = value;
//        }
//    }

//    /// <remarks/>
//    public string label4
//    {
//        get
//        {
//            return this.label4Field;
//        }
//        set
//        {
//            this.label4Field = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class UDLInfo
//{

//    private UserDefinedLabelsInfo userDefinedLabelsField;

//    private UserDefinedValuesInfo userDefinedValuesField;

//    /// <remarks/>
//    public UserDefinedLabelsInfo userDefinedLabels
//    {
//        get
//        {
//            return this.userDefinedLabelsField;
//        }
//        set
//        {
//            this.userDefinedLabelsField = value;
//        }
//    }

//    /// <remarks/>
//    public UserDefinedValuesInfo userDefinedValues
//    {
//        get
//        {
//            return this.userDefinedValuesField;
//        }
//        set
//        {
//            this.userDefinedValuesField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class UserDefinedValuesInfo
//{

//    private string value1Field;

//    private string value2Field;

//    private string value3Field;

//    private string value4Field;

//    /// <remarks/>
//    public string value1
//    {
//        get
//        {
//            return this.value1Field;
//        }
//        set
//        {
//            this.value1Field = value;
//        }
//    }

//    /// <remarks/>
//    public string value2
//    {
//        get
//        {
//            return this.value2Field;
//        }
//        set
//        {
//            this.value2Field = value;
//        }
//    }

//    /// <remarks/>
//    public string value3
//    {
//        get
//        {
//            return this.value3Field;
//        }
//        set
//        {
//            this.value3Field = value;
//        }
//    }

//    /// <remarks/>
//    public string value4
//    {
//        get
//        {
//            return this.value4Field;
//        }
//        set
//        {
//            this.value4Field = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class SubscriberStatusDetailInfo
//{

//    private SubscriberStatusInfo subscriberStatusField;

//    private string statusReasonCodeField;

//    private System.DateTime statusDateField;

//    private bool statusDateFieldSpecified;

//    private bool isSuspensionVoluntaryField;

//    private bool isSuspensionVoluntaryFieldSpecified;

//    /// <remarks/>
//    public SubscriberStatusInfo subscriberStatus
//    {
//        get
//        {
//            return this.subscriberStatusField;
//        }
//        set
//        {
//            this.subscriberStatusField = value;
//        }
//    }

//    /// <remarks/>
//    public string statusReasonCode
//    {
//        get
//        {
//            return this.statusReasonCodeField;
//        }
//        set
//        {
//            this.statusReasonCodeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime statusDate
//    {
//        get
//        {
//            return this.statusDateField;
//        }
//        set
//        {
//            this.statusDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool statusDateSpecified
//    {
//        get
//        {
//            return this.statusDateFieldSpecified;
//        }
//        set
//        {
//            this.statusDateFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool isSuspensionVoluntary
//    {
//        get
//        {
//            return this.isSuspensionVoluntaryField;
//        }
//        set
//        {
//            this.isSuspensionVoluntaryField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool isSuspensionVoluntarySpecified
//    {
//        get
//        {
//            return this.isSuspensionVoluntaryFieldSpecified;
//        }
//        set
//        {
//            this.isSuspensionVoluntaryFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum SubscriberStatusInfo
//{

//    /// <remarks/>
//    R,

//    /// <remarks/>
//    A,

//    /// <remarks/>
//    C,

//    /// <remarks/>
//    S,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireSubscriberProfileR" +
//    "esponse.xsd")]
//public partial class InquireSubscriberProfileResponseInfo
//{

//    private InquireSubscriberProfileResponseInfoSubscriber subscriberField;

//    private ResponseInfo responseField;

//    /// <remarks/>
//    public InquireSubscriberProfileResponseInfoSubscriber Subscriber
//    {
//        get
//        {
//            return this.subscriberField;
//        }
//        set
//        {
//            this.subscriberField = value;
//        }
//    }

//    /// <remarks/>
//    public ResponseInfo Response
//    {
//        get
//        {
//            return this.responseField;
//        }
//        set
//        {
//            this.responseField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireSubscriberProfileR" +
//    "esponse.xsd")]
//public partial class InquireSubscriberProfileResponseInfoSubscriber
//{

//    private string subscriberNumberField;

//    private string subscriptionIDField;

//    private SubscriberStatusDetailInfo subscriberStatusField;

//    private InquireSubscriberProfileResponseInfoSubscriberContract contractField;

//    private InquireSubscriberProfileResponseInfoSubscriberContactInformation contactInformationField;

//    private EffectiveDatesInfo serviceActivationDateField;

//    private UDLInfo uDLField;

//    private PricePlanInfo pricePlanField;

//    private OfferingsAdditionalInfo[] additionalOfferingsField;

//    private SolicitationIndicatorsInfo[] solicitationIndicatorsField;

//    private MergerMigrationInfo mergerMigrationField;

//    private bool mergerMigrationFieldSpecified;

//    private DealerCommissionInfo commissionField;

//    private DiscountInfo[] discountsField;

//    private InquireSubscriberProfileResponseInfoSubscriberUsage usageField;

//    private SubscriberIndicatorsInfo subscriberIndicatorsField;

//    private InquireSubscriberProfileResponseInfoSubscriberDeviceInformation deviceInformationField;

//    private CopayInfo copayInfoField;

//    private UpgradeEligibilityInfo upgradeEligibilityField;

//    private InquireSubscriberProfileResponseInfoSubscriberMobileToAnyNumberDetails mobileToAnyNumberDetailsField;

//    /// <remarks/>
//    public string subscriberNumber
//    {
//        get
//        {
//            return this.subscriberNumberField;
//        }
//        set
//        {
//            this.subscriberNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public string subscriptionID
//    {
//        get
//        {
//            return this.subscriptionIDField;
//        }
//        set
//        {
//            this.subscriptionIDField = value;
//        }
//    }

//    /// <remarks/>
//    public SubscriberStatusDetailInfo SubscriberStatus
//    {
//        get
//        {
//            return this.subscriberStatusField;
//        }
//        set
//        {
//            this.subscriberStatusField = value;
//        }
//    }

//    /// <remarks/>
//    public InquireSubscriberProfileResponseInfoSubscriberContract Contract
//    {
//        get
//        {
//            return this.contractField;
//        }
//        set
//        {
//            this.contractField = value;
//        }
//    }

//    /// <remarks/>
//    public InquireSubscriberProfileResponseInfoSubscriberContactInformation ContactInformation
//    {
//        get
//        {
//            return this.contactInformationField;
//        }
//        set
//        {
//            this.contactInformationField = value;
//        }
//    }

//    /// <remarks/>
//    public EffectiveDatesInfo ServiceActivationDate
//    {
//        get
//        {
//            return this.serviceActivationDateField;
//        }
//        set
//        {
//            this.serviceActivationDateField = value;
//        }
//    }

//    /// <remarks/>
//    public UDLInfo UDL
//    {
//        get
//        {
//            return this.uDLField;
//        }
//        set
//        {
//            this.uDLField = value;
//        }
//    }

//    /// <remarks/>
//    public PricePlanInfo PricePlan
//    {
//        get
//        {
//            return this.pricePlanField;
//        }
//        set
//        {
//            this.pricePlanField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("AdditionalOfferings")]
//    public OfferingsAdditionalInfo[] AdditionalOfferings
//    {
//        get
//        {
//            return this.additionalOfferingsField;
//        }
//        set
//        {
//            this.additionalOfferingsField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("SolicitationIndicators")]
//    public SolicitationIndicatorsInfo[] SolicitationIndicators
//    {
//        get
//        {
//            return this.solicitationIndicatorsField;
//        }
//        set
//        {
//            this.solicitationIndicatorsField = value;
//        }
//    }

//    /// <remarks/>
//    public MergerMigrationInfo mergerMigration
//    {
//        get
//        {
//            return this.mergerMigrationField;
//        }
//        set
//        {
//            this.mergerMigrationField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool mergerMigrationSpecified
//    {
//        get
//        {
//            return this.mergerMigrationFieldSpecified;
//        }
//        set
//        {
//            this.mergerMigrationFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public DealerCommissionInfo Commission
//    {
//        get
//        {
//            return this.commissionField;
//        }
//        set
//        {
//            this.commissionField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("Discounts")]
//    public DiscountInfo[] Discounts
//    {
//        get
//        {
//            return this.discountsField;
//        }
//        set
//        {
//            this.discountsField = value;
//        }
//    }

//    /// <remarks/>
//    public InquireSubscriberProfileResponseInfoSubscriberUsage Usage
//    {
//        get
//        {
//            return this.usageField;
//        }
//        set
//        {
//            this.usageField = value;
//        }
//    }

//    /// <remarks/>
//    public SubscriberIndicatorsInfo subscriberIndicators
//    {
//        get
//        {
//            return this.subscriberIndicatorsField;
//        }
//        set
//        {
//            this.subscriberIndicatorsField = value;
//        }
//    }

//    /// <remarks/>
//    public InquireSubscriberProfileResponseInfoSubscriberDeviceInformation deviceInformation
//    {
//        get
//        {
//            return this.deviceInformationField;
//        }
//        set
//        {
//            this.deviceInformationField = value;
//        }
//    }

//    /// <remarks/>
//    public CopayInfo CopayInfo
//    {
//        get
//        {
//            return this.copayInfoField;
//        }
//        set
//        {
//            this.copayInfoField = value;
//        }
//    }

//    /// <remarks/>
//    public UpgradeEligibilityInfo UpgradeEligibility
//    {
//        get
//        {
//            return this.upgradeEligibilityField;
//        }
//        set
//        {
//            this.upgradeEligibilityField = value;
//        }
//    }

//    /// <remarks/>
//    public InquireSubscriberProfileResponseInfoSubscriberMobileToAnyNumberDetails MobileToAnyNumberDetails
//    {
//        get
//        {
//            return this.mobileToAnyNumberDetailsField;
//        }
//        set
//        {
//            this.mobileToAnyNumberDetailsField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireSubscriberProfileR" +
//    "esponse.xsd")]
//public partial class InquireSubscriberProfileResponseInfoSubscriberContract
//{

//    private ContractTermInfo contractTermField;

//    private TermsConditionsStatusInfo termsConditionStatusField;

//    private bool termsConditionStatusFieldSpecified;

//    /// <remarks/>
//    public ContractTermInfo ContractTerm
//    {
//        get
//        {
//            return this.contractTermField;
//        }
//        set
//        {
//            this.contractTermField = value;
//        }
//    }

//    /// <remarks/>
//    public TermsConditionsStatusInfo termsConditionStatus
//    {
//        get
//        {
//            return this.termsConditionStatusField;
//        }
//        set
//        {
//            this.termsConditionStatusField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool termsConditionStatusSpecified
//    {
//        get
//        {
//            return this.termsConditionStatusFieldSpecified;
//        }
//        set
//        {
//            this.termsConditionStatusFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireSubscriberProfileR" +
//    "esponse.xsd")]
//public partial class InquireSubscriberProfileResponseInfoSubscriberContactInformation
//{

//    private object itemField;

//    private AddressInfo ppuAddressField;

//    private PhoneInfo phoneField;

//    private EmailInfo emailField;

//    private IdentificationInfo identificationField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("Name", typeof(NameInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("businessName", typeof(NameBusinessInfo))]
//    public object Item
//    {
//        get
//        {
//            return this.itemField;
//        }
//        set
//        {
//            this.itemField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressInfo PpuAddress
//    {
//        get
//        {
//            return this.ppuAddressField;
//        }
//        set
//        {
//            this.ppuAddressField = value;
//        }
//    }

//    /// <remarks/>
//    public PhoneInfo Phone
//    {
//        get
//        {
//            return this.phoneField;
//        }
//        set
//        {
//            this.phoneField = value;
//        }
//    }

//    /// <remarks/>
//    public EmailInfo Email
//    {
//        get
//        {
//            return this.emailField;
//        }
//        set
//        {
//            this.emailField = value;
//        }
//    }

//    /// <remarks/>
//    public IdentificationInfo Identification
//    {
//        get
//        {
//            return this.identificationField;
//        }
//        set
//        {
//            this.identificationField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class PhoneInfo
//{

//    private string homePhoneField;

//    private string workPhoneField;

//    private string workPhoneExtensionField;

//    private string canBeReachedPhoneField;

//    /// <remarks/>
//    public string homePhone
//    {
//        get
//        {
//            return this.homePhoneField;
//        }
//        set
//        {
//            this.homePhoneField = value;
//        }
//    }

//    /// <remarks/>
//    public string workPhone
//    {
//        get
//        {
//            return this.workPhoneField;
//        }
//        set
//        {
//            this.workPhoneField = value;
//        }
//    }

//    /// <remarks/>
//    public string workPhoneExtension
//    {
//        get
//        {
//            return this.workPhoneExtensionField;
//        }
//        set
//        {
//            this.workPhoneExtensionField = value;
//        }
//    }

//    /// <remarks/>
//    public string canBeReachedPhone
//    {
//        get
//        {
//            return this.canBeReachedPhoneField;
//        }
//        set
//        {
//            this.canBeReachedPhoneField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class EmailInfo
//{

//    private System.DateTime effectiveDateField;

//    private bool effectiveDateFieldSpecified;

//    private string emailAddressField;

//    private EmailInfoEmailType emailTypeField;

//    private bool emailTypeFieldSpecified;

//    private bool primaryAddressIndicatorField;

//    private bool primaryAddressIndicatorFieldSpecified;

//    private LanguagePreferenceInfo languageField;

//    private bool languageFieldSpecified;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime effectiveDate
//    {
//        get
//        {
//            return this.effectiveDateField;
//        }
//        set
//        {
//            this.effectiveDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool effectiveDateSpecified
//    {
//        get
//        {
//            return this.effectiveDateFieldSpecified;
//        }
//        set
//        {
//            this.effectiveDateFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public string emailAddress
//    {
//        get
//        {
//            return this.emailAddressField;
//        }
//        set
//        {
//            this.emailAddressField = value;
//        }
//    }

//    /// <remarks/>
//    public EmailInfoEmailType emailType
//    {
//        get
//        {
//            return this.emailTypeField;
//        }
//        set
//        {
//            this.emailTypeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool emailTypeSpecified
//    {
//        get
//        {
//            return this.emailTypeFieldSpecified;
//        }
//        set
//        {
//            this.emailTypeFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool primaryAddressIndicator
//    {
//        get
//        {
//            return this.primaryAddressIndicatorField;
//        }
//        set
//        {
//            this.primaryAddressIndicatorField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool primaryAddressIndicatorSpecified
//    {
//        get
//        {
//            return this.primaryAddressIndicatorFieldSpecified;
//        }
//        set
//        {
//            this.primaryAddressIndicatorFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public LanguagePreferenceInfo language
//    {
//        get
//        {
//            return this.languageField;
//        }
//        set
//        {
//            this.languageField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool languageSpecified
//    {
//        get
//        {
//            return this.languageFieldSpecified;
//        }
//        set
//        {
//            this.languageFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum EmailInfoEmailType
//{

//    /// <remarks/>
//    B,

//    /// <remarks/>
//    P,

//    /// <remarks/>
//    O,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class IdentificationInfo
//{

//    private IdentificationTypeInfo idTypeField;

//    private string idNumberField;

//    private string issuingAuthorityField;

//    private System.DateTime expirationDateField;

//    private bool expirationDateFieldSpecified;

//    /// <remarks/>
//    public IdentificationTypeInfo idType
//    {
//        get
//        {
//            return this.idTypeField;
//        }
//        set
//        {
//            this.idTypeField = value;
//        }
//    }

//    /// <remarks/>
//    public string idNumber
//    {
//        get
//        {
//            return this.idNumberField;
//        }
//        set
//        {
//            this.idNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public string issuingAuthority
//    {
//        get
//        {
//            return this.issuingAuthorityField;
//        }
//        set
//        {
//            this.issuingAuthorityField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime expirationDate
//    {
//        get
//        {
//            return this.expirationDateField;
//        }
//        set
//        {
//            this.expirationDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool expirationDateSpecified
//    {
//        get
//        {
//            return this.expirationDateFieldSpecified;
//        }
//        set
//        {
//            this.expirationDateFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum IdentificationTypeInfo
//{

//    /// <remarks/>
//    DL,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class SolicitationIndicatorsInfo
//{

//    private SolicitationIndicatorsInfoSolicitationMedium solicitationMediumField;

//    private bool enabledField;

//    /// <remarks/>
//    public SolicitationIndicatorsInfoSolicitationMedium solicitationMedium
//    {
//        get
//        {
//            return this.solicitationMediumField;
//        }
//        set
//        {
//            this.solicitationMediumField = value;
//        }
//    }

//    /// <remarks/>
//    public bool enabled
//    {
//        get
//        {
//            return this.enabledField;
//        }
//        set
//        {
//            this.enabledField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum SolicitationIndicatorsInfoSolicitationMedium
//{

//    /// <remarks/>
//    SMS,

//    /// <remarks/>
//    EMAIL,

//    /// <remarks/>
//    MAIL,

//    /// <remarks/>
//    PHONE,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum MergerMigrationInfo
//{

//    /// <remarks/>
//    C,

//    /// <remarks/>
//    D,

//    /// <remarks/>
//    E,

//    /// <remarks/>
//    M,

//    /// <remarks/>
//    U,

//    /// <remarks/>
//    P,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class DiscountInfo
//{

//    private ActionInfo actionField;

//    private string codeField;

//    private string instanceIdField;

//    private bool sbsDiscountIndicatorField;

//    private bool sbsDiscountIndicatorFieldSpecified;

//    private string descriptionField;

//    private EffectiveDatesInfo effectiveDatesField;

//    public DiscountInfo()
//    {
//        this.actionField = ActionInfo.Q;
//    }

//    /// <remarks/>
//    public ActionInfo action
//    {
//        get
//        {
//            return this.actionField;
//        }
//        set
//        {
//            this.actionField = value;
//        }
//    }

//    /// <remarks/>
//    public string code
//    {
//        get
//        {
//            return this.codeField;
//        }
//        set
//        {
//            this.codeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "nonNegativeInteger")]
//    public string instanceId
//    {
//        get
//        {
//            return this.instanceIdField;
//        }
//        set
//        {
//            this.instanceIdField = value;
//        }
//    }

//    /// <remarks/>
//    public bool sbsDiscountIndicator
//    {
//        get
//        {
//            return this.sbsDiscountIndicatorField;
//        }
//        set
//        {
//            this.sbsDiscountIndicatorField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool sbsDiscountIndicatorSpecified
//    {
//        get
//        {
//            return this.sbsDiscountIndicatorFieldSpecified;
//        }
//        set
//        {
//            this.sbsDiscountIndicatorFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public string description
//    {
//        get
//        {
//            return this.descriptionField;
//        }
//        set
//        {
//            this.descriptionField = value;
//        }
//    }

//    /// <remarks/>
//    public EffectiveDatesInfo EffectiveDates
//    {
//        get
//        {
//            return this.effectiveDatesField;
//        }
//        set
//        {
//            this.effectiveDatesField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireSubscriberProfileR" +
//    "esponse.xsd")]
//public partial class InquireSubscriberProfileResponseInfoSubscriberUsage
//{

//    private InquireSubscriberProfileResponseInfoSubscriberUsageCurrentUsage currentUsageField;

//    private InquireSubscriberProfileResponseInfoSubscriberUsagePreviousUsage previousUsageField;

//    /// <remarks/>
//    public InquireSubscriberProfileResponseInfoSubscriberUsageCurrentUsage CurrentUsage
//    {
//        get
//        {
//            return this.currentUsageField;
//        }
//        set
//        {
//            this.currentUsageField = value;
//        }
//    }

//    /// <remarks/>
//    public InquireSubscriberProfileResponseInfoSubscriberUsagePreviousUsage PreviousUsage
//    {
//        get
//        {
//            return this.previousUsageField;
//        }
//        set
//        {
//            this.previousUsageField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireSubscriberProfileR" +
//    "esponse.xsd")]
//public partial class InquireSubscriberProfileResponseInfoSubscriberUsageCurrentUsage : UsageInfo
//{
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireSubscriberProfileR" +
//    "esponse.xsd")]
//public partial class InquireSubscriberProfileResponseInfoSubscriberUsagePreviousUsage : PreviousUsageInfo
//{
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireSubscriberProfileR" +
//    "esponse.xsd")]
//public partial class InquireSubscriberProfileResponseInfoSubscriberDeviceInformation
//{

//    private UnrestrictedDeviceInfo[] deviceField;

//    private DeviceCapabilitiesInfo deviceCapabilitiesField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("device")]
//    public UnrestrictedDeviceInfo[] device
//    {
//        get
//        {
//            return this.deviceField;
//        }
//        set
//        {
//            this.deviceField = value;
//        }
//    }

//    /// <remarks/>
//    public DeviceCapabilitiesInfo deviceCapabilities
//    {
//        get
//        {
//            return this.deviceCapabilitiesField;
//        }
//        set
//        {
//            this.deviceCapabilitiesField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireSubscriberProfileR" +
//    "esponse.xsd")]
//public partial class InquireSubscriberProfileResponseInfoSubscriberMobileToAnyNumberDetails
//{

//    private bool isEffectiveField;

//    private int callListCountField;

//    private bool callListCountFieldSpecified;

//    private bool isHistoryAvailableField;

//    private bool isHistoryAvailableFieldSpecified;

//    private int maxNumberOfCallListField;

//    private bool maxNumberOfCallListFieldSpecified;

//    private decimal minPricePlanRecurringChargeField;

//    private bool minPricePlanRecurringChargeFieldSpecified;

//    /// <remarks/>
//    public bool isEffective
//    {
//        get
//        {
//            return this.isEffectiveField;
//        }
//        set
//        {
//            this.isEffectiveField = value;
//        }
//    }

//    /// <remarks/>
//    public int callListCount
//    {
//        get
//        {
//            return this.callListCountField;
//        }
//        set
//        {
//            this.callListCountField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool callListCountSpecified
//    {
//        get
//        {
//            return this.callListCountFieldSpecified;
//        }
//        set
//        {
//            this.callListCountFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool isHistoryAvailable
//    {
//        get
//        {
//            return this.isHistoryAvailableField;
//        }
//        set
//        {
//            this.isHistoryAvailableField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool isHistoryAvailableSpecified
//    {
//        get
//        {
//            return this.isHistoryAvailableFieldSpecified;
//        }
//        set
//        {
//            this.isHistoryAvailableFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public int maxNumberOfCallList
//    {
//        get
//        {
//            return this.maxNumberOfCallListField;
//        }
//        set
//        {
//            this.maxNumberOfCallListField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool maxNumberOfCallListSpecified
//    {
//        get
//        {
//            return this.maxNumberOfCallListFieldSpecified;
//        }
//        set
//        {
//            this.maxNumberOfCallListFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public decimal minPricePlanRecurringCharge
//    {
//        get
//        {
//            return this.minPricePlanRecurringChargeField;
//        }
//        set
//        {
//            this.minPricePlanRecurringChargeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool minPricePlanRecurringChargeSpecified
//    {
//        get
//        {
//            return this.minPricePlanRecurringChargeFieldSpecified;
//        }
//        set
//        {
//            this.minPricePlanRecurringChargeFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class TaxExemptionInfo
//{

//    private System.DateTime requestDateField;

//    private bool requestDateFieldSpecified;

//    private TaxExemptionInfoStatus statusField;

//    private bool statusFieldSpecified;

//    private TaxExemptionInfoEntityType entityTypeField;

//    private bool entityTypeFieldSpecified;

//    private System.DateTime effectiveDateField;

//    private bool effectiveDateFieldSpecified;

//    private System.DateTime expirationDateField;

//    private bool expirationDateFieldSpecified;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime requestDate
//    {
//        get
//        {
//            return this.requestDateField;
//        }
//        set
//        {
//            this.requestDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool requestDateSpecified
//    {
//        get
//        {
//            return this.requestDateFieldSpecified;
//        }
//        set
//        {
//            this.requestDateFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public TaxExemptionInfoStatus status
//    {
//        get
//        {
//            return this.statusField;
//        }
//        set
//        {
//            this.statusField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool statusSpecified
//    {
//        get
//        {
//            return this.statusFieldSpecified;
//        }
//        set
//        {
//            this.statusFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public TaxExemptionInfoEntityType entityType
//    {
//        get
//        {
//            return this.entityTypeField;
//        }
//        set
//        {
//            this.entityTypeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool entityTypeSpecified
//    {
//        get
//        {
//            return this.entityTypeFieldSpecified;
//        }
//        set
//        {
//            this.entityTypeFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime effectiveDate
//    {
//        get
//        {
//            return this.effectiveDateField;
//        }
//        set
//        {
//            this.effectiveDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool effectiveDateSpecified
//    {
//        get
//        {
//            return this.effectiveDateFieldSpecified;
//        }
//        set
//        {
//            this.effectiveDateFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime expirationDate
//    {
//        get
//        {
//            return this.expirationDateField;
//        }
//        set
//        {
//            this.expirationDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool expirationDateSpecified
//    {
//        get
//        {
//            return this.expirationDateFieldSpecified;
//        }
//        set
//        {
//            this.expirationDateFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum TaxExemptionInfoStatus
//{

//    /// <remarks/>
//    P,

//    /// <remarks/>
//    C,

//    /// <remarks/>
//    R,

//    /// <remarks/>
//    N,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum TaxExemptionInfoEntityType
//{

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("01")]
//    Item01,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("02")]
//    Item02,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("03")]
//    Item03,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("04")]
//    Item04,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("05")]
//    Item05,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("06")]
//    Item06,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("07")]
//    Item07,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("08")]
//    Item08,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("09")]
//    Item09,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("10")]
//    Item10,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("11")]
//    Item11,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("12")]
//    Item12,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("13")]
//    Item13,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("14")]
//    Item14,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("15")]
//    Item15,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("16")]
//    Item16,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("17")]
//    Item17,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("18")]
//    Item18,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("19")]
//    Item19,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute("20")]
//    Item20,

//    /// <remarks/>
//    AA,

//    /// <remarks/>
//    BB,

//    /// <remarks/>
//    CC,

//    /// <remarks/>
//    DD,

//    /// <remarks/>
//    EE,

//    /// <remarks/>
//    FF,

//    /// <remarks/>
//    GG,

//    /// <remarks/>
//    HH,

//    /// <remarks/>
//    II,

//    /// <remarks/>
//    JJ,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class NBIMigrationInfo
//{

//    private string accountMigratedToField;

//    private string accountMigratedFromField;

//    private string marketMigratedToField;

//    private string marketMigratedFromField;

//    private string subMarketMigratedFromField;

//    private System.DateTime migrationDateField;

//    private NBIMigrationStatus migrationStatusField;

//    /// <remarks/>
//    public string accountMigratedTo
//    {
//        get
//        {
//            return this.accountMigratedToField;
//        }
//        set
//        {
//            this.accountMigratedToField = value;
//        }
//    }

//    /// <remarks/>
//    public string accountMigratedFrom
//    {
//        get
//        {
//            return this.accountMigratedFromField;
//        }
//        set
//        {
//            this.accountMigratedFromField = value;
//        }
//    }

//    /// <remarks/>
//    public string marketMigratedTo
//    {
//        get
//        {
//            return this.marketMigratedToField;
//        }
//        set
//        {
//            this.marketMigratedToField = value;
//        }
//    }

//    /// <remarks/>
//    public string marketMigratedFrom
//    {
//        get
//        {
//            return this.marketMigratedFromField;
//        }
//        set
//        {
//            this.marketMigratedFromField = value;
//        }
//    }

//    /// <remarks/>
//    public string subMarketMigratedFrom
//    {
//        get
//        {
//            return this.subMarketMigratedFromField;
//        }
//        set
//        {
//            this.subMarketMigratedFromField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime migrationDate
//    {
//        get
//        {
//            return this.migrationDateField;
//        }
//        set
//        {
//            this.migrationDateField = value;
//        }
//    }

//    /// <remarks/>
//    public NBIMigrationStatus migrationStatus
//    {
//        get
//        {
//            return this.migrationStatusField;
//        }
//        set
//        {
//            this.migrationStatusField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum NBIMigrationStatus
//{

//    /// <remarks/>
//    I,

//    /// <remarks/>
//    P,

//    /// <remarks/>
//    C,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class PaymentInfo
//{

//    private System.DateTime billDateField;

//    private bool billDateFieldSpecified;

//    private System.DateTime receivedDateField;

//    private bool receivedDateFieldSpecified;

//    private double amountField;

//    private bool amountFieldSpecified;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime billDate
//    {
//        get
//        {
//            return this.billDateField;
//        }
//        set
//        {
//            this.billDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool billDateSpecified
//    {
//        get
//        {
//            return this.billDateFieldSpecified;
//        }
//        set
//        {
//            this.billDateFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime receivedDate
//    {
//        get
//        {
//            return this.receivedDateField;
//        }
//        set
//        {
//            this.receivedDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool receivedDateSpecified
//    {
//        get
//        {
//            return this.receivedDateFieldSpecified;
//        }
//        set
//        {
//            this.receivedDateFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public double amount
//    {
//        get
//        {
//            return this.amountField;
//        }
//        set
//        {
//            this.amountField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool amountSpecified
//    {
//        get
//        {
//            return this.amountFieldSpecified;
//        }
//        set
//        {
//            this.amountFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class AccountBalanceInfo
//{

//    private double currentAmountDueField;

//    private double totalAmountDueField;

//    private double totalAmountPastDueField;

//    /// <remarks/>
//    public double currentAmountDue
//    {
//        get
//        {
//            return this.currentAmountDueField;
//        }
//        set
//        {
//            this.currentAmountDueField = value;
//        }
//    }

//    /// <remarks/>
//    public double totalAmountDue
//    {
//        get
//        {
//            return this.totalAmountDueField;
//        }
//        set
//        {
//            this.totalAmountDueField = value;
//        }
//    }

//    /// <remarks/>
//    public double totalAmountPastDue
//    {
//        get
//        {
//            return this.totalAmountPastDueField;
//        }
//        set
//        {
//            this.totalAmountPastDueField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class AccountBillingInfo
//{

//    private short billingCycleField;

//    private System.DateTime nextBillCycleDateField;

//    private bool nextBillCycleDateFieldSpecified;

//    private AccountBalanceInfo balanceField;

//    private CombinedBillingStatusInfo combinedBillingIndicatorField;

//    private bool combinedBillingIndicatorFieldSpecified;

//    private System.DateTime billDueDateField;

//    private bool billDueDateFieldSpecified;

//    private PaymentInfo lastPaymentField;

//    /// <remarks/>
//    public short billingCycle
//    {
//        get
//        {
//            return this.billingCycleField;
//        }
//        set
//        {
//            this.billingCycleField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime nextBillCycleDate
//    {
//        get
//        {
//            return this.nextBillCycleDateField;
//        }
//        set
//        {
//            this.nextBillCycleDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool nextBillCycleDateSpecified
//    {
//        get
//        {
//            return this.nextBillCycleDateFieldSpecified;
//        }
//        set
//        {
//            this.nextBillCycleDateFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public AccountBalanceInfo Balance
//    {
//        get
//        {
//            return this.balanceField;
//        }
//        set
//        {
//            this.balanceField = value;
//        }
//    }

//    /// <remarks/>
//    public CombinedBillingStatusInfo combinedBillingIndicator
//    {
//        get
//        {
//            return this.combinedBillingIndicatorField;
//        }
//        set
//        {
//            this.combinedBillingIndicatorField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool combinedBillingIndicatorSpecified
//    {
//        get
//        {
//            return this.combinedBillingIndicatorFieldSpecified;
//        }
//        set
//        {
//            this.combinedBillingIndicatorFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime billDueDate
//    {
//        get
//        {
//            return this.billDueDateField;
//        }
//        set
//        {
//            this.billDueDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool billDueDateSpecified
//    {
//        get
//        {
//            return this.billDueDateFieldSpecified;
//        }
//        set
//        {
//            this.billDueDateFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public PaymentInfo lastPayment
//    {
//        get
//        {
//            return this.lastPaymentField;
//        }
//        set
//        {
//            this.lastPaymentField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum CombinedBillingStatusInfo
//{

//    /// <remarks/>
//    Y,

//    /// <remarks/>
//    N,

//    /// <remarks/>
//    P,

//    /// <remarks/>
//    D,

//    /// <remarks/>
//    F,

//    /// <remarks/>
//    [System.Xml.Serialization.XmlEnumAttribute(" ")]
//    Item,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class BmgIndicatorsInfo
//{

//    private bool bmgIndicatorField;

//    private bool userOverrideField;

//    private bool userOverrideFieldSpecified;

//    private EnterpriseTypeInfo enterpriseTypeField;

//    private bool enterpriseTypeFieldSpecified;

//    private string segmentCodeField;

//    private string subsegmentCodeField;

//    private string subsegmentDescriptionField;

//    private LiabilityInfo liabilityField;

//    private bool liabilityFieldSpecified;

//    private string contractTypeField;

//    /// <remarks/>
//    public bool bmgIndicator
//    {
//        get
//        {
//            return this.bmgIndicatorField;
//        }
//        set
//        {
//            this.bmgIndicatorField = value;
//        }
//    }

//    /// <remarks/>
//    public bool userOverride
//    {
//        get
//        {
//            return this.userOverrideField;
//        }
//        set
//        {
//            this.userOverrideField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool userOverrideSpecified
//    {
//        get
//        {
//            return this.userOverrideFieldSpecified;
//        }
//        set
//        {
//            this.userOverrideFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public EnterpriseTypeInfo enterpriseType
//    {
//        get
//        {
//            return this.enterpriseTypeField;
//        }
//        set
//        {
//            this.enterpriseTypeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool enterpriseTypeSpecified
//    {
//        get
//        {
//            return this.enterpriseTypeFieldSpecified;
//        }
//        set
//        {
//            this.enterpriseTypeFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public string segmentCode
//    {
//        get
//        {
//            return this.segmentCodeField;
//        }
//        set
//        {
//            this.segmentCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string subsegmentCode
//    {
//        get
//        {
//            return this.subsegmentCodeField;
//        }
//        set
//        {
//            this.subsegmentCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string subsegmentDescription
//    {
//        get
//        {
//            return this.subsegmentDescriptionField;
//        }
//        set
//        {
//            this.subsegmentDescriptionField = value;
//        }
//    }

//    /// <remarks/>
//    public LiabilityInfo liability
//    {
//        get
//        {
//            return this.liabilityField;
//        }
//        set
//        {
//            this.liabilityField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool liabilitySpecified
//    {
//        get
//        {
//            return this.liabilityFieldSpecified;
//        }
//        set
//        {
//            this.liabilityFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public string contractType
//    {
//        get
//        {
//            return this.contractTypeField;
//        }
//        set
//        {
//            this.contractTypeField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum EnterpriseTypeInfo
//{

//    /// <remarks/>
//    GBS,

//    /// <remarks/>
//    SBA,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum LiabilityInfo
//{

//    /// <remarks/>
//    CRU,

//    /// <remarks/>
//    IRU,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class AccountTypeInfo
//{

//    private string accountTypeField;

//    private string accountSubTypeField;

//    private BusinessTypeInfo businessTypeField;

//    private bool businessTypeFieldSpecified;

//    private OpenChannelInfo openChannelField;

//    private bool openChannelFieldSpecified;

//    /// <remarks/>
//    public string accountType
//    {
//        get
//        {
//            return this.accountTypeField;
//        }
//        set
//        {
//            this.accountTypeField = value;
//        }
//    }

//    /// <remarks/>
//    public string accountSubType
//    {
//        get
//        {
//            return this.accountSubTypeField;
//        }
//        set
//        {
//            this.accountSubTypeField = value;
//        }
//    }

//    /// <remarks/>
//    public BusinessTypeInfo businessType
//    {
//        get
//        {
//            return this.businessTypeField;
//        }
//        set
//        {
//            this.businessTypeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool businessTypeSpecified
//    {
//        get
//        {
//            return this.businessTypeFieldSpecified;
//        }
//        set
//        {
//            this.businessTypeFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public OpenChannelInfo openChannel
//    {
//        get
//        {
//            return this.openChannelField;
//        }
//        set
//        {
//            this.openChannelField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool openChannelSpecified
//    {
//        get
//        {
//            return this.openChannelFieldSpecified;
//        }
//        set
//        {
//            this.openChannelFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum BusinessTypeInfo
//{

//    /// <remarks/>
//    C,

//    /// <remarks/>
//    P,

//    /// <remarks/>
//    S,

//    /// <remarks/>
//    B,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum OpenChannelInfo
//{

//    /// <remarks/>
//    R,

//    /// <remarks/>
//    J,

//    /// <remarks/>
//    S,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class AccountStatusInfo
//{

//    private AccountStatusInfoStatus statusField;

//    private bool statusFieldSpecified;

//    private System.DateTime timeField;

//    private bool timeFieldSpecified;

//    private System.DateTime dateField;

//    private bool dateFieldSpecified;

//    /// <remarks/>
//    public AccountStatusInfoStatus status
//    {
//        get
//        {
//            return this.statusField;
//        }
//        set
//        {
//            this.statusField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool statusSpecified
//    {
//        get
//        {
//            return this.statusFieldSpecified;
//        }
//        set
//        {
//            this.statusFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "time")]
//    public System.DateTime time
//    {
//        get
//        {
//            return this.timeField;
//        }
//        set
//        {
//            this.timeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool timeSpecified
//    {
//        get
//        {
//            return this.timeFieldSpecified;
//        }
//        set
//        {
//            this.timeFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime date
//    {
//        get
//        {
//            return this.dateField;
//        }
//        set
//        {
//            this.dateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool dateSpecified
//    {
//        get
//        {
//            return this.dateFieldSpecified;
//        }
//        set
//        {
//            this.dateFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum AccountStatusInfoStatus
//{

//    /// <remarks/>
//    A,

//    /// <remarks/>
//    C,

//    /// <remarks/>
//    W,

//    /// <remarks/>
//    T,

//    /// <remarks/>
//    N,

//    /// <remarks/>
//    D,

//    /// <remarks/>
//    S,

//    /// <remarks/>
//    X,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class AffiliateCombinedBillingInfo
//{

//    private string billingTelephoneNumberField;

//    private string customerCodeField;

//    private string raoField;

//    private CombinedBillingTypeInfo combinedBillingTypeField;

//    private AffiliateRegionInfo combinedBillingRegionField;

//    private bool combinedBillingRegionFieldSpecified;

//    private BusinessConsumerIndicatorInfo businessConsumerIndicatorField;

//    private bool businessConsumerIndicatorFieldSpecified;

//    private bool addressUnsyncableIndicatorField;

//    private bool addressUnsyncableIndicatorFieldSpecified;

//    private bool cbDiscountField;

//    private bool cbDiscountFieldSpecified;

//    private bool cbBundledDiscountField;

//    private bool cbBundledDiscountFieldSpecified;

//    public AffiliateCombinedBillingInfo()
//    {
//        this.combinedBillingTypeField = CombinedBillingTypeInfo.Lightspeed;
//    }

//    /// <remarks/>
//    public string billingTelephoneNumber
//    {
//        get
//        {
//            return this.billingTelephoneNumberField;
//        }
//        set
//        {
//            this.billingTelephoneNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public string customerCode
//    {
//        get
//        {
//            return this.customerCodeField;
//        }
//        set
//        {
//            this.customerCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string rao
//    {
//        get
//        {
//            return this.raoField;
//        }
//        set
//        {
//            this.raoField = value;
//        }
//    }

//    /// <remarks/>
//    [System.ComponentModel.DefaultValueAttribute(CombinedBillingTypeInfo.Lightspeed)]
//    public CombinedBillingTypeInfo combinedBillingType
//    {
//        get
//        {
//            return this.combinedBillingTypeField;
//        }
//        set
//        {
//            this.combinedBillingTypeField = value;
//        }
//    }

//    /// <remarks/>
//    public AffiliateRegionInfo combinedBillingRegion
//    {
//        get
//        {
//            return this.combinedBillingRegionField;
//        }
//        set
//        {
//            this.combinedBillingRegionField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool combinedBillingRegionSpecified
//    {
//        get
//        {
//            return this.combinedBillingRegionFieldSpecified;
//        }
//        set
//        {
//            this.combinedBillingRegionFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public BusinessConsumerIndicatorInfo businessConsumerIndicator
//    {
//        get
//        {
//            return this.businessConsumerIndicatorField;
//        }
//        set
//        {
//            this.businessConsumerIndicatorField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool businessConsumerIndicatorSpecified
//    {
//        get
//        {
//            return this.businessConsumerIndicatorFieldSpecified;
//        }
//        set
//        {
//            this.businessConsumerIndicatorFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool addressUnsyncableIndicator
//    {
//        get
//        {
//            return this.addressUnsyncableIndicatorField;
//        }
//        set
//        {
//            this.addressUnsyncableIndicatorField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool addressUnsyncableIndicatorSpecified
//    {
//        get
//        {
//            return this.addressUnsyncableIndicatorFieldSpecified;
//        }
//        set
//        {
//            this.addressUnsyncableIndicatorFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool cbDiscount
//    {
//        get
//        {
//            return this.cbDiscountField;
//        }
//        set
//        {
//            this.cbDiscountField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool cbDiscountSpecified
//    {
//        get
//        {
//            return this.cbDiscountFieldSpecified;
//        }
//        set
//        {
//            this.cbDiscountFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool cbBundledDiscount
//    {
//        get
//        {
//            return this.cbBundledDiscountField;
//        }
//        set
//        {
//            this.cbBundledDiscountField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool cbBundledDiscountSpecified
//    {
//        get
//        {
//            return this.cbBundledDiscountFieldSpecified;
//        }
//        set
//        {
//            this.cbBundledDiscountFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum CombinedBillingTypeInfo
//{

//    /// <remarks/>
//    Telco,

//    /// <remarks/>
//    Lightspeed,

//    /// <remarks/>
//    TelcoSe,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum AffiliateRegionInfo
//{

//    /// <remarks/>
//    A,

//    /// <remarks/>
//    B,

//    /// <remarks/>
//    N,

//    /// <remarks/>
//    P,

//    /// <remarks/>
//    S,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum BusinessConsumerIndicatorInfo
//{

//    /// <remarks/>
//    B,

//    /// <remarks/>
//    C,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class CpniPreferenceInfo
//{

//    private System.DateTime timeStampField;

//    private CpniValueInfo preferenceField;

//    private string preferenceDescriptionField;

//    private string selectionContextField;

//    private CPNILockValueInfo lockedField;

//    private bool lockedFieldSpecified;

//    /// <remarks/>
//    public System.DateTime timeStamp
//    {
//        get
//        {
//            return this.timeStampField;
//        }
//        set
//        {
//            this.timeStampField = value;
//        }
//    }

//    /// <remarks/>
//    public CpniValueInfo preference
//    {
//        get
//        {
//            return this.preferenceField;
//        }
//        set
//        {
//            this.preferenceField = value;
//        }
//    }

//    /// <remarks/>
//    public string preferenceDescription
//    {
//        get
//        {
//            return this.preferenceDescriptionField;
//        }
//        set
//        {
//            this.preferenceDescriptionField = value;
//        }
//    }

//    /// <remarks/>
//    public string selectionContext
//    {
//        get
//        {
//            return this.selectionContextField;
//        }
//        set
//        {
//            this.selectionContextField = value;
//        }
//    }

//    /// <remarks/>
//    public CPNILockValueInfo locked
//    {
//        get
//        {
//            return this.lockedField;
//        }
//        set
//        {
//            this.lockedField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool lockedSpecified
//    {
//        get
//        {
//            return this.lockedFieldSpecified;
//        }
//        set
//        {
//            this.lockedFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum CpniValueInfo
//{

//    /// <remarks/>
//    Y,

//    /// <remarks/>
//    N,

//    /// <remarks/>
//    P,

//    /// <remarks/>
//    I,

//    /// <remarks/>
//    F,

//    /// <remarks/>
//    T,

//    /// <remarks/>
//    X,

//    /// <remarks/>
//    R,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum CPNILockValueInfo
//{

//    /// <remarks/>
//    Y,

//    /// <remarks/>
//    N,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class AuthorizedUsersInfo
//{

//    private NameInfo authorizedUser1Field;

//    private NameInfo authorizedUser2Field;

//    /// <remarks/>
//    public NameInfo AuthorizedUser1
//    {
//        get
//        {
//            return this.authorizedUser1Field;
//        }
//        set
//        {
//            this.authorizedUser1Field = value;
//        }
//    }

//    /// <remarks/>
//    public NameInfo AuthorizedUser2
//    {
//        get
//        {
//            return this.authorizedUser2Field;
//        }
//        set
//        {
//            this.authorizedUser2Field = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireAccountProfileResp" +
//    "onse.xsd")]
//public partial class InquireAccountProfileResponseInfo
//{

//    private InquireAccountProfileResponseInfoAccount accountField;

//    private ResponseInfo responseField;

//    /// <remarks/>
//    public InquireAccountProfileResponseInfoAccount Account
//    {
//        get
//        {
//            return this.accountField;
//        }
//        set
//        {
//            this.accountField = value;
//        }
//    }

//    /// <remarks/>
//    public ResponseInfo Response
//    {
//        get
//        {
//            return this.responseField;
//        }
//        set
//        {
//            this.responseField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireAccountProfileResp" +
//    "onse.xsd")]
//public partial class InquireAccountProfileResponseInfoAccount
//{

//    private MarketInfo billingMarketField;

//    private string billingSystemIdField;

//    private string billingAccountNumberField;

//    private AuthorizedUsersInfo authorizedUsersField;

//    private CpniPreferenceInfo cpniActivePreferenceField;

//    private AffiliateCombinedBillingInfo combinedBillingInfoField;

//    private string billingAccountPasswordField;

//    private string fanField;

//    private bool sbsAccountIndicatorField;

//    private bool sbsAccountIndicatorFieldSpecified;

//    private AccountStatusInfo accountStatusField;

//    private EffectiveDatesInfo accountCreationDateField;

//    private AccountTypeInfo accountTypeField;

//    private BmgIndicatorsInfo bmgIndicatorField;

//    private AccountBillingInfo accountBillingField;

//    private string paymentMethodField;

//    private int numberOfLinesAvailableField;

//    private SolicitationIndicatorsInfo[] solicitationIndicatorsField;

//    private BillingPreferencesInfo billingPreferencesField;

//    private DiscountInfo[] discountsField;

//    private NBIMigrationInfo nBIMigrationDataField;

//    private TaxExemptionInfo taxExemptionField;

//    private InquireAccountProfileResponseInfoAccountCustomer customerField;

//    private InquireSubscriberProfileResponseInfo[] subscriberField;

//    private DealerCommissionInfo commissionField;

//    private bool coPayEnrolleesExistIndField;

//    private bool coPayEnrolleesExistIndFieldSpecified;

//    private bool coPayActiveEnrolleesExistIndField;

//    private bool coPayActiveEnrolleesExistIndFieldSpecified;

//    private string primaryAccountHolderField;

//    private AccountManagerInfo accountManagerField;

//    private bool accountManagerFieldSpecified;

//    private string totalNumberOfSubscribersField;

//    private string sbsBundledComponentSubscribersField;

//    private InquireAccountProfileResponseInfoAccountTotalByStatus[] totalByStatusField;

//    private ElectronicBillStatusInfo electronicBillStatusField;

//    private bool electronicBillStatusFieldSpecified;

//    public InquireAccountProfileResponseInfoAccount()
//    {
//        this.numberOfLinesAvailableField = 0;
//    }

//    /// <remarks/>
//    public MarketInfo billingMarket
//    {
//        get
//        {
//            return this.billingMarketField;
//        }
//        set
//        {
//            this.billingMarketField = value;
//        }
//    }

//    /// <remarks/>
//    public string billingSystemId
//    {
//        get
//        {
//            return this.billingSystemIdField;
//        }
//        set
//        {
//            this.billingSystemIdField = value;
//        }
//    }

//    /// <remarks/>
//    public string billingAccountNumber
//    {
//        get
//        {
//            return this.billingAccountNumberField;
//        }
//        set
//        {
//            this.billingAccountNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public AuthorizedUsersInfo AuthorizedUsers
//    {
//        get
//        {
//            return this.authorizedUsersField;
//        }
//        set
//        {
//            this.authorizedUsersField = value;
//        }
//    }

//    /// <remarks/>
//    public CpniPreferenceInfo CpniActivePreference
//    {
//        get
//        {
//            return this.cpniActivePreferenceField;
//        }
//        set
//        {
//            this.cpniActivePreferenceField = value;
//        }
//    }

//    /// <remarks/>
//    public AffiliateCombinedBillingInfo CombinedBillingInfo
//    {
//        get
//        {
//            return this.combinedBillingInfoField;
//        }
//        set
//        {
//            this.combinedBillingInfoField = value;
//        }
//    }

//    /// <remarks/>
//    public string billingAccountPassword
//    {
//        get
//        {
//            return this.billingAccountPasswordField;
//        }
//        set
//        {
//            this.billingAccountPasswordField = value;
//        }
//    }

//    /// <remarks/>
//    public string fan
//    {
//        get
//        {
//            return this.fanField;
//        }
//        set
//        {
//            this.fanField = value;
//        }
//    }

//    /// <remarks/>
//    public bool sbsAccountIndicator
//    {
//        get
//        {
//            return this.sbsAccountIndicatorField;
//        }
//        set
//        {
//            this.sbsAccountIndicatorField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool sbsAccountIndicatorSpecified
//    {
//        get
//        {
//            return this.sbsAccountIndicatorFieldSpecified;
//        }
//        set
//        {
//            this.sbsAccountIndicatorFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public AccountStatusInfo AccountStatus
//    {
//        get
//        {
//            return this.accountStatusField;
//        }
//        set
//        {
//            this.accountStatusField = value;
//        }
//    }

//    /// <remarks/>
//    public EffectiveDatesInfo AccountCreationDate
//    {
//        get
//        {
//            return this.accountCreationDateField;
//        }
//        set
//        {
//            this.accountCreationDateField = value;
//        }
//    }

//    /// <remarks/>
//    public AccountTypeInfo AccountType
//    {
//        get
//        {
//            return this.accountTypeField;
//        }
//        set
//        {
//            this.accountTypeField = value;
//        }
//    }

//    /// <remarks/>
//    public BmgIndicatorsInfo BmgIndicator
//    {
//        get
//        {
//            return this.bmgIndicatorField;
//        }
//        set
//        {
//            this.bmgIndicatorField = value;
//        }
//    }

//    /// <remarks/>
//    public AccountBillingInfo AccountBilling
//    {
//        get
//        {
//            return this.accountBillingField;
//        }
//        set
//        {
//            this.accountBillingField = value;
//        }
//    }

//    /// <remarks/>
//    public string PaymentMethod
//    {
//        get
//        {
//            return this.paymentMethodField;
//        }
//        set
//        {
//            this.paymentMethodField = value;
//        }
//    }

//    /// <remarks/>
//    [System.ComponentModel.DefaultValueAttribute(0)]
//    public int numberOfLinesAvailable
//    {
//        get
//        {
//            return this.numberOfLinesAvailableField;
//        }
//        set
//        {
//            this.numberOfLinesAvailableField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("SolicitationIndicators")]
//    public SolicitationIndicatorsInfo[] SolicitationIndicators
//    {
//        get
//        {
//            return this.solicitationIndicatorsField;
//        }
//        set
//        {
//            this.solicitationIndicatorsField = value;
//        }
//    }

//    /// <remarks/>
//    public BillingPreferencesInfo BillingPreferences
//    {
//        get
//        {
//            return this.billingPreferencesField;
//        }
//        set
//        {
//            this.billingPreferencesField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("Discounts")]
//    public DiscountInfo[] Discounts
//    {
//        get
//        {
//            return this.discountsField;
//        }
//        set
//        {
//            this.discountsField = value;
//        }
//    }

//    /// <remarks/>
//    public NBIMigrationInfo NBIMigrationData
//    {
//        get
//        {
//            return this.nBIMigrationDataField;
//        }
//        set
//        {
//            this.nBIMigrationDataField = value;
//        }
//    }

//    /// <remarks/>
//    public TaxExemptionInfo TaxExemption
//    {
//        get
//        {
//            return this.taxExemptionField;
//        }
//        set
//        {
//            this.taxExemptionField = value;
//        }
//    }

//    /// <remarks/>
//    public InquireAccountProfileResponseInfoAccountCustomer Customer
//    {
//        get
//        {
//            return this.customerField;
//        }
//        set
//        {
//            this.customerField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("Subscriber")]
//    public InquireSubscriberProfileResponseInfo[] Subscriber
//    {
//        get
//        {
//            return this.subscriberField;
//        }
//        set
//        {
//            this.subscriberField = value;
//        }
//    }

//    /// <remarks/>
//    public DealerCommissionInfo Commission
//    {
//        get
//        {
//            return this.commissionField;
//        }
//        set
//        {
//            this.commissionField = value;
//        }
//    }

//    /// <remarks/>
//    public bool coPayEnrolleesExistInd
//    {
//        get
//        {
//            return this.coPayEnrolleesExistIndField;
//        }
//        set
//        {
//            this.coPayEnrolleesExistIndField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool coPayEnrolleesExistIndSpecified
//    {
//        get
//        {
//            return this.coPayEnrolleesExistIndFieldSpecified;
//        }
//        set
//        {
//            this.coPayEnrolleesExistIndFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public bool coPayActiveEnrolleesExistInd
//    {
//        get
//        {
//            return this.coPayActiveEnrolleesExistIndField;
//        }
//        set
//        {
//            this.coPayActiveEnrolleesExistIndField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool coPayActiveEnrolleesExistIndSpecified
//    {
//        get
//        {
//            return this.coPayActiveEnrolleesExistIndFieldSpecified;
//        }
//        set
//        {
//            this.coPayActiveEnrolleesExistIndFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public string primaryAccountHolder
//    {
//        get
//        {
//            return this.primaryAccountHolderField;
//        }
//        set
//        {
//            this.primaryAccountHolderField = value;
//        }
//    }

//    /// <remarks/>
//    public AccountManagerInfo accountManager
//    {
//        get
//        {
//            return this.accountManagerField;
//        }
//        set
//        {
//            this.accountManagerField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool accountManagerSpecified
//    {
//        get
//        {
//            return this.accountManagerFieldSpecified;
//        }
//        set
//        {
//            this.accountManagerFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "integer")]
//    public string totalNumberOfSubscribers
//    {
//        get
//        {
//            return this.totalNumberOfSubscribersField;
//        }
//        set
//        {
//            this.totalNumberOfSubscribersField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "integer")]
//    public string sbsBundledComponentSubscribers
//    {
//        get
//        {
//            return this.sbsBundledComponentSubscribersField;
//        }
//        set
//        {
//            this.sbsBundledComponentSubscribersField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("TotalByStatus")]
//    public InquireAccountProfileResponseInfoAccountTotalByStatus[] TotalByStatus
//    {
//        get
//        {
//            return this.totalByStatusField;
//        }
//        set
//        {
//            this.totalByStatusField = value;
//        }
//    }

//    /// <remarks/>
//    public ElectronicBillStatusInfo electronicBillStatus
//    {
//        get
//        {
//            return this.electronicBillStatusField;
//        }
//        set
//        {
//            this.electronicBillStatusField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool electronicBillStatusSpecified
//    {
//        get
//        {
//            return this.electronicBillStatusFieldSpecified;
//        }
//        set
//        {
//            this.electronicBillStatusFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class BillingPreferencesInfo
//{

//    private string billingMediaField;

//    private DoNotMailBillIndicatorInfo doNotMailBillCodeField;

//    private bool doNotMailBillCodeFieldSpecified;

//    private int numberOfBillsToPrintField;

//    private bool numberOfBillsToPrintFieldSpecified;

//    private LanguagePreferenceInfo languageField;

//    private bool languageFieldSpecified;

//    /// <remarks/>
//    public string billingMedia
//    {
//        get
//        {
//            return this.billingMediaField;
//        }
//        set
//        {
//            this.billingMediaField = value;
//        }
//    }

//    /// <remarks/>
//    public DoNotMailBillIndicatorInfo doNotMailBillCode
//    {
//        get
//        {
//            return this.doNotMailBillCodeField;
//        }
//        set
//        {
//            this.doNotMailBillCodeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool doNotMailBillCodeSpecified
//    {
//        get
//        {
//            return this.doNotMailBillCodeFieldSpecified;
//        }
//        set
//        {
//            this.doNotMailBillCodeFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public int numberOfBillsToPrint
//    {
//        get
//        {
//            return this.numberOfBillsToPrintField;
//        }
//        set
//        {
//            this.numberOfBillsToPrintField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool numberOfBillsToPrintSpecified
//    {
//        get
//        {
//            return this.numberOfBillsToPrintFieldSpecified;
//        }
//        set
//        {
//            this.numberOfBillsToPrintFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public LanguagePreferenceInfo language
//    {
//        get
//        {
//            return this.languageField;
//        }
//        set
//        {
//            this.languageField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool languageSpecified
//    {
//        get
//        {
//            return this.languageFieldSpecified;
//        }
//        set
//        {
//            this.languageFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum DoNotMailBillIndicatorInfo
//{

//    /// <remarks/>
//    P,

//    /// <remarks/>
//    X,

//    /// <remarks/>
//    E,

//    /// <remarks/>
//    N,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireAccountProfileResp" +
//    "onse.xsd")]
//public partial class InquireAccountProfileResponseInfoAccountCustomer
//{

//    private object[] itemsField;

//    private AddressInfo addressField;

//    private PhoneInfo phoneField;

//    private EmailInfo emailField;

//    private InquireAccountProfileResponseInfoAccountCustomerIdentity identityField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("businessName", typeof(NameBusinessInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("doingBusinessAs", typeof(string))]
//    [System.Xml.Serialization.XmlElementAttribute("name", typeof(NameInfo))]
//    public object[] Items
//    {
//        get
//        {
//            return this.itemsField;
//        }
//        set
//        {
//            this.itemsField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressInfo Address
//    {
//        get
//        {
//            return this.addressField;
//        }
//        set
//        {
//            this.addressField = value;
//        }
//    }

//    /// <remarks/>
//    public PhoneInfo Phone
//    {
//        get
//        {
//            return this.phoneField;
//        }
//        set
//        {
//            this.phoneField = value;
//        }
//    }

//    /// <remarks/>
//    public EmailInfo Email
//    {
//        get
//        {
//            return this.emailField;
//        }
//        set
//        {
//            this.emailField = value;
//        }
//    }

//    /// <remarks/>
//    public InquireAccountProfileResponseInfoAccountCustomerIdentity Identity
//    {
//        get
//        {
//            return this.identityField;
//        }
//        set
//        {
//            this.identityField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireAccountProfileResp" +
//    "onse.xsd")]
//public partial class InquireAccountProfileResponseInfoAccountCustomerIdentity
//{

//    private IdentificationInfo identificationField;

//    private EmployerInfo employerField;

//    private object[] itemsField;

//    private ItemsChoiceType3[] itemsElementNameField;

//    /// <remarks/>
//    public IdentificationInfo Identification
//    {
//        get
//        {
//            return this.identificationField;
//        }
//        set
//        {
//            this.identificationField = value;
//        }
//    }

//    /// <remarks/>
//    public EmployerInfo Employer
//    {
//        get
//        {
//            return this.employerField;
//        }
//        set
//        {
//            this.employerField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("Birth", typeof(BirthInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("businessTaxId", typeof(string))]
//    [System.Xml.Serialization.XmlElementAttribute("socialSecurityNumber", typeof(string))]
//    [System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")]
//    public object[] Items
//    {
//        get
//        {
//            return this.itemsField;
//        }
//        set
//        {
//            this.itemsField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("ItemsElementName")]
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public ItemsChoiceType3[] ItemsElementName
//    {
//        get
//        {
//            return this.itemsElementNameField;
//        }
//        set
//        {
//            this.itemsElementNameField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class EmployerInfo
//{

//    private string employerNameField;

//    /// <remarks/>
//    public string employerName
//    {
//        get
//        {
//            return this.employerNameField;
//        }
//        set
//        {
//            this.employerNameField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class BirthInfo
//{

//    private System.DateTime dateOfBirthField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime dateOfBirth
//    {
//        get
//        {
//            return this.dateOfBirthField;
//        }
//        set
//        {
//            this.dateOfBirthField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireAccountProfileResp" +
//    "onse.xsd", IncludeInSchema = false)]
//public enum ItemsChoiceType3
//{

//    /// <remarks/>
//    Birth,

//    /// <remarks/>
//    businessTaxId,

//    /// <remarks/>
//    socialSecurityNumber,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum AccountManagerInfo
//{

//    /// <remarks/>
//    OLAM,

//    /// <remarks/>
//    POC,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireAccountProfileResp" +
//    "onse.xsd")]
//public partial class InquireAccountProfileResponseInfoAccountTotalByStatus
//{

//    private SubscriberStatusInfo subscriberStatusField;

//    private string totalNumberOfSubscribersByStatusField;

//    /// <remarks/>
//    public SubscriberStatusInfo subscriberStatus
//    {
//        get
//        {
//            return this.subscriberStatusField;
//        }
//        set
//        {
//            this.subscriberStatusField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "integer")]
//    public string totalNumberOfSubscribersByStatus
//    {
//        get
//        {
//            return this.totalNumberOfSubscribersByStatusField;
//        }
//        set
//        {
//            this.totalNumberOfSubscribersByStatusField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum ElectronicBillStatusInfo
//{

//    /// <remarks/>
//    E,

//    /// <remarks/>
//    D,

//    /// <remarks/>
//    PE,

//    /// <remarks/>
//    PD,

//    /// <remarks/>
//    I,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class AccountVerificationInfo
//{

//    private string billingZipCodeField;

//    private string last4SSNField;

//    /// <remarks/>
//    public string billingZipCode
//    {
//        get
//        {
//            return this.billingZipCodeField;
//        }
//        set
//        {
//            this.billingZipCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string last4SSN
//    {
//        get
//        {
//            return this.last4SSNField;
//        }
//        set
//        {
//            this.last4SSNField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireAccountProfileRequ" +
//    "est.xsd")]
//public partial class InquireAccountProfileRequestInfo
//{

//    private AccountSelectorInfo accountSelectorField;

//    private AccountVerificationInfo accountVerificationField;

//    private SecureUpgradeEligibilityInfo upgradeEligibilityCriteriaField;

//    private string maskField;

//    private DealerInfo[] dealerField;

//    /// <remarks/>
//    public AccountSelectorInfo AccountSelector
//    {
//        get
//        {
//            return this.accountSelectorField;
//        }
//        set
//        {
//            this.accountSelectorField = value;
//        }
//    }

//    /// <remarks/>
//    public AccountVerificationInfo AccountVerification
//    {
//        get
//        {
//            return this.accountVerificationField;
//        }
//        set
//        {
//            this.accountVerificationField = value;
//        }
//    }

//    /// <remarks/>
//    public SecureUpgradeEligibilityInfo UpgradeEligibilityCriteria
//    {
//        get
//        {
//            return this.upgradeEligibilityCriteriaField;
//        }
//        set
//        {
//            this.upgradeEligibilityCriteriaField = value;
//        }
//    }

//    /// <remarks/>
//    public string mask
//    {
//        get
//        {
//            return this.maskField;
//        }
//        set
//        {
//            this.maskField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("dealer")]
//    public DealerInfo[] dealer
//    {
//        get
//        {
//            return this.dealerField;
//        }
//        set
//        {
//            this.dealerField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class AccountSelectorInfo
//{

//    private object[] itemsField;

//    private ItemsChoiceType2[] itemsElementNameField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("MarketServiceInfo", typeof(MarketAndZipServiceInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("billingAccountNumber", typeof(string))]
//    [System.Xml.Serialization.XmlElementAttribute("subscriberNumber", typeof(string))]
//    [System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")]
//    public object[] Items
//    {
//        get
//        {
//            return this.itemsField;
//        }
//        set
//        {
//            this.itemsField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("ItemsElementName")]
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public ItemsChoiceType2[] ItemsElementName
//    {
//        get
//        {
//            return this.itemsElementNameField;
//        }
//        set
//        {
//            this.itemsElementNameField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd", IncludeInSchema = false)]
//public enum ItemsChoiceType2
//{

//    /// <remarks/>
//    MarketServiceInfo,

//    /// <remarks/>
//    billingAccountNumber,

//    /// <remarks/>
//    subscriberNumber,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ExecuteCreditCheckRespons" +
//    "e.xsd")]
//public partial class ExecuteCreditCheckResponseInfo
//{

//    private MarketInfo billingMarketField;

//    private string billingAccountNumberField;

//    private CreditDecisionInfo creditDecisionField;

//    private ResponseInfo responseField;

//    /// <remarks/>
//    public MarketInfo billingMarket
//    {
//        get
//        {
//            return this.billingMarketField;
//        }
//        set
//        {
//            this.billingMarketField = value;
//        }
//    }

//    /// <remarks/>
//    public string billingAccountNumber
//    {
//        get
//        {
//            return this.billingAccountNumberField;
//        }
//        set
//        {
//            this.billingAccountNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public CreditDecisionInfo CreditDecision
//    {
//        get
//        {
//            return this.creditDecisionField;
//        }
//        set
//        {
//            this.creditDecisionField = value;
//        }
//    }

//    /// <remarks/>
//    public ResponseInfo Response
//    {
//        get
//        {
//            return this.responseField;
//        }
//        set
//        {
//            this.responseField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ExecuteCreditCheckRequest" +
//    ".xsd")]
//public partial class ExecuteCreditCheckRequestInfo
//{

//    private AccountSelectorInfo accountSelectorField;

//    private string numberOfLinesRequestedField;

//    private DealerCommissionInfo commissionField;

//    private ExecuteCreditCheckRequestInfoSBPLCustomer sBPLCustomerField;

//    /// <remarks/>
//    public AccountSelectorInfo AccountSelector
//    {
//        get
//        {
//            return this.accountSelectorField;
//        }
//        set
//        {
//            this.accountSelectorField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "positiveInteger")]
//    public string numberOfLinesRequested
//    {
//        get
//        {
//            return this.numberOfLinesRequestedField;
//        }
//        set
//        {
//            this.numberOfLinesRequestedField = value;
//        }
//    }

//    /// <remarks/>
//    public DealerCommissionInfo Commission
//    {
//        get
//        {
//            return this.commissionField;
//        }
//        set
//        {
//            this.commissionField = value;
//        }
//    }

//    /// <remarks/>
//    public ExecuteCreditCheckRequestInfoSBPLCustomer SBPLCustomer
//    {
//        get
//        {
//            return this.sBPLCustomerField;
//        }
//        set
//        {
//            this.sBPLCustomerField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ExecuteCreditCheckRequest" +
//    ".xsd")]
//public partial class ExecuteCreditCheckRequestInfoSBPLCustomer
//{

//    private ExtendedNameInfo nameField;

//    private AddressInfo addressField;

//    private ExecuteCreditCheckRequestInfoSBPLCustomerIdentity identityField;

//    /// <remarks/>
//    public ExtendedNameInfo name
//    {
//        get
//        {
//            return this.nameField;
//        }
//        set
//        {
//            this.nameField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressInfo Address
//    {
//        get
//        {
//            return this.addressField;
//        }
//        set
//        {
//            this.addressField = value;
//        }
//    }

//    /// <remarks/>
//    public ExecuteCreditCheckRequestInfoSBPLCustomerIdentity Identity
//    {
//        get
//        {
//            return this.identityField;
//        }
//        set
//        {
//            this.identityField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class ExtendedNameInfo
//{

//    private string namePrefixField;

//    private string firstNameField;

//    private string middleNameField;

//    private string lastNameField;

//    private string previousLastNameField;

//    private string nameSuffixField;

//    private string additionalTitleField;

//    /// <remarks/>
//    public string namePrefix
//    {
//        get
//        {
//            return this.namePrefixField;
//        }
//        set
//        {
//            this.namePrefixField = value;
//        }
//    }

//    /// <remarks/>
//    public string firstName
//    {
//        get
//        {
//            return this.firstNameField;
//        }
//        set
//        {
//            this.firstNameField = value;
//        }
//    }

//    /// <remarks/>
//    public string middleName
//    {
//        get
//        {
//            return this.middleNameField;
//        }
//        set
//        {
//            this.middleNameField = value;
//        }
//    }

//    /// <remarks/>
//    public string lastName
//    {
//        get
//        {
//            return this.lastNameField;
//        }
//        set
//        {
//            this.lastNameField = value;
//        }
//    }

//    /// <remarks/>
//    public string previousLastName
//    {
//        get
//        {
//            return this.previousLastNameField;
//        }
//        set
//        {
//            this.previousLastNameField = value;
//        }
//    }

//    /// <remarks/>
//    public string nameSuffix
//    {
//        get
//        {
//            return this.nameSuffixField;
//        }
//        set
//        {
//            this.nameSuffixField = value;
//        }
//    }

//    /// <remarks/>
//    public string additionalTitle
//    {
//        get
//        {
//            return this.additionalTitleField;
//        }
//        set
//        {
//            this.additionalTitleField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ExecuteCreditCheckRequest" +
//    ".xsd")]
//public partial class ExecuteCreditCheckRequestInfoSBPLCustomerIdentity
//{

//    private RestrictedIdentificationInfo identificationField;

//    private BirthInfo birthField;

//    private string socialSecurityNumberField;

//    /// <remarks/>
//    public RestrictedIdentificationInfo Identification
//    {
//        get
//        {
//            return this.identificationField;
//        }
//        set
//        {
//            this.identificationField = value;
//        }
//    }

//    /// <remarks/>
//    public BirthInfo Birth
//    {
//        get
//        {
//            return this.birthField;
//        }
//        set
//        {
//            this.birthField = value;
//        }
//    }

//    /// <remarks/>
//    public string socialSecurityNumber
//    {
//        get
//        {
//            return this.socialSecurityNumberField;
//        }
//        set
//        {
//            this.socialSecurityNumberField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class RestrictedIdentificationInfo
//{

//    private IdentificationTypeInfo idTypeField;

//    private string idNumberField;

//    private string issuingAuthorityField;

//    private System.DateTime expirationDateField;

//    /// <remarks/>
//    public IdentificationTypeInfo idType
//    {
//        get
//        {
//            return this.idTypeField;
//        }
//        set
//        {
//            this.idTypeField = value;
//        }
//    }

//    /// <remarks/>
//    public string idNumber
//    {
//        get
//        {
//            return this.idNumberField;
//        }
//        set
//        {
//            this.idNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public string issuingAuthority
//    {
//        get
//        {
//            return this.issuingAuthorityField;
//        }
//        set
//        {
//            this.issuingAuthorityField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime expirationDate
//    {
//        get
//        {
//            return this.expirationDateField;
//        }
//        set
//        {
//            this.expirationDateField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/EchoResponse.xsd")]
//public partial class EchoResponseInfo
//{

//    private string serviceEntityField;

//    private string dataField;

//    private ResponseInfo responseField;

//    /// <remarks/>
//    public string serviceEntity
//    {
//        get
//        {
//            return this.serviceEntityField;
//        }
//        set
//        {
//            this.serviceEntityField = value;
//        }
//    }

//    /// <remarks/>
//    public string data
//    {
//        get
//        {
//            return this.dataField;
//        }
//        set
//        {
//            this.dataField = value;
//        }
//    }

//    /// <remarks/>
//    public ResponseInfo Response
//    {
//        get
//        {
//            return this.responseField;
//        }
//        set
//        {
//            this.responseField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/EchoRequest.xsd")]
//public partial class EchoRequestInfo
//{

//    private string serviceEntityField;

//    private string dataField;

//    /// <remarks/>
//    public string serviceEntity
//    {
//        get
//        {
//            return this.serviceEntityField;
//        }
//        set
//        {
//            this.serviceEntityField = value;
//        }
//    }

//    /// <remarks/>
//    public string data
//    {
//        get
//        {
//            return this.dataField;
//        }
//        set
//        {
//            this.dataField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class PortResponseInfo
//{

//    private string billingAccountNumberField;

//    private PortRequestStatusInfo portRequestStatusField;

//    /// <remarks/>
//    public string billingAccountNumber
//    {
//        get
//        {
//            return this.billingAccountNumberField;
//        }
//        set
//        {
//            this.billingAccountNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public PortRequestStatusInfo portRequestStatus
//    {
//        get
//        {
//            return this.portRequestStatusField;
//        }
//        set
//        {
//            this.portRequestStatusField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/AddPortResponse.xsd")]
//public partial class AddPortResponseInfo
//{

//    private PortingLocatorInfo portingLocatorField;

//    private PortResponseInfo portResponseField;

//    private ResponseInfo responseField;

//    /// <remarks/>
//    public PortingLocatorInfo PortingLocator
//    {
//        get
//        {
//            return this.portingLocatorField;
//        }
//        set
//        {
//            this.portingLocatorField = value;
//        }
//    }

//    /// <remarks/>
//    public PortResponseInfo PortResponse
//    {
//        get
//        {
//            return this.portResponseField;
//        }
//        set
//        {
//            this.portResponseField = value;
//        }
//    }

//    /// <remarks/>
//    public ResponseInfo Response
//    {
//        get
//        {
//            return this.responseField;
//        }
//        set
//        {
//            this.responseField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class PortRequestLineInfo
//{

//    private long portRequestLineIdField;

//    private string npaNxxField;

//    private string fromLineField;

//    private string toLineField;

//    private EquipmentTypeInfo equipmentTypeField;

//    private string fulfillmentOrderIdField;

//    private string serviceAreaField;

//    private PortRequestLineInfoContactInformation contactInformationField;

//    /// <remarks/>
//    public long portRequestLineId
//    {
//        get
//        {
//            return this.portRequestLineIdField;
//        }
//        set
//        {
//            this.portRequestLineIdField = value;
//        }
//    }

//    /// <remarks/>
//    public string npaNxx
//    {
//        get
//        {
//            return this.npaNxxField;
//        }
//        set
//        {
//            this.npaNxxField = value;
//        }
//    }

//    /// <remarks/>
//    public string fromLine
//    {
//        get
//        {
//            return this.fromLineField;
//        }
//        set
//        {
//            this.fromLineField = value;
//        }
//    }

//    /// <remarks/>
//    public string toLine
//    {
//        get
//        {
//            return this.toLineField;
//        }
//        set
//        {
//            this.toLineField = value;
//        }
//    }

//    /// <remarks/>
//    public EquipmentTypeInfo equipmentType
//    {
//        get
//        {
//            return this.equipmentTypeField;
//        }
//        set
//        {
//            this.equipmentTypeField = value;
//        }
//    }

//    /// <remarks/>
//    public string fulfillmentOrderId
//    {
//        get
//        {
//            return this.fulfillmentOrderIdField;
//        }
//        set
//        {
//            this.fulfillmentOrderIdField = value;
//        }
//    }

//    /// <remarks/>
//    public string serviceArea
//    {
//        get
//        {
//            return this.serviceAreaField;
//        }
//        set
//        {
//            this.serviceAreaField = value;
//        }
//    }

//    /// <remarks/>
//    public PortRequestLineInfoContactInformation ContactInformation
//    {
//        get
//        {
//            return this.contactInformationField;
//        }
//        set
//        {
//            this.contactInformationField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class PortRequestLineInfoContactInformation
//{

//    private object itemField;

//    private AddressInfo addressField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("BusinessName", typeof(NameBusinessInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("Name", typeof(NameInfo))]
//    public object Item
//    {
//        get
//        {
//            return this.itemField;
//        }
//        set
//        {
//            this.itemField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressInfo Address
//    {
//        get
//        {
//            return this.addressField;
//        }
//        set
//        {
//            this.addressField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/AddPortRequest.xsd")]
//public partial class AddPortRequestInfo
//{

//    private MarketAndZipServiceInfo marketServiceInfoField;

//    private DealerCommissionInfo commissionField;

//    private AddPortRequestInfoCustomer customerField;

//    private PortRequestInfo portRequestField;

//    private PortRequestLineInfo[] portRequestLineField;

//    /// <remarks/>
//    public MarketAndZipServiceInfo marketServiceInfo
//    {
//        get
//        {
//            return this.marketServiceInfoField;
//        }
//        set
//        {
//            this.marketServiceInfoField = value;
//        }
//    }

//    /// <remarks/>
//    public DealerCommissionInfo Commission
//    {
//        get
//        {
//            return this.commissionField;
//        }
//        set
//        {
//            this.commissionField = value;
//        }
//    }

//    /// <remarks/>
//    public AddPortRequestInfoCustomer Customer
//    {
//        get
//        {
//            return this.customerField;
//        }
//        set
//        {
//            this.customerField = value;
//        }
//    }

//    /// <remarks/>
//    public PortRequestInfo PortRequest
//    {
//        get
//        {
//            return this.portRequestField;
//        }
//        set
//        {
//            this.portRequestField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("PortRequestLine")]
//    public PortRequestLineInfo[] PortRequestLine
//    {
//        get
//        {
//            return this.portRequestLineField;
//        }
//        set
//        {
//            this.portRequestLineField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/AddPortRequest.xsd")]
//public partial class AddPortRequestInfoCustomer
//{

//    private string billingAccountNumberField;

//    private object itemField;

//    private AddressInfo addressField;

//    /// <remarks/>
//    public string billingAccountNumber
//    {
//        get
//        {
//            return this.billingAccountNumberField;
//        }
//        set
//        {
//            this.billingAccountNumberField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("BusinessName", typeof(NameBusinessInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("Name", typeof(NameInfo))]
//    public object Item
//    {
//        get
//        {
//            return this.itemField;
//        }
//        set
//        {
//            this.itemField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressInfo Address
//    {
//        get
//        {
//            return this.addressField;
//        }
//        set
//        {
//            this.addressField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/AddAccountResponse.xsd")]
//public partial class AddAccountResponseInfo
//{

//    private MarketInfo billingMarketField;

//    private string billingSystemIdField;

//    private string itemField;

//    private ItemChoiceType1 itemElementNameField;

//    private CreditDecisionInfo creditDecisionField;

//    private SubscriberNumberReservationInfo[] subscriberNumbersField;

//    private ResponseInfo responseField;

//    /// <remarks/>
//    public MarketInfo billingMarket
//    {
//        get
//        {
//            return this.billingMarketField;
//        }
//        set
//        {
//            this.billingMarketField = value;
//        }
//    }

//    /// <remarks/>
//    public string billingSystemId
//    {
//        get
//        {
//            return this.billingSystemIdField;
//        }
//        set
//        {
//            this.billingSystemIdField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("GUID", typeof(string))]
//    [System.Xml.Serialization.XmlElementAttribute("billingAccountNumber", typeof(string))]
//    [System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemElementName")]
//    public string Item
//    {
//        get
//        {
//            return this.itemField;
//        }
//        set
//        {
//            this.itemField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public ItemChoiceType1 ItemElementName
//    {
//        get
//        {
//            return this.itemElementNameField;
//        }
//        set
//        {
//            this.itemElementNameField = value;
//        }
//    }

//    /// <remarks/>
//    public CreditDecisionInfo CreditDecision
//    {
//        get
//        {
//            return this.creditDecisionField;
//        }
//        set
//        {
//            this.creditDecisionField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("SubscriberNumbers")]
//    public SubscriberNumberReservationInfo[] SubscriberNumbers
//    {
//        get
//        {
//            return this.subscriberNumbersField;
//        }
//        set
//        {
//            this.subscriberNumbersField = value;
//        }
//    }

//    /// <remarks/>
//    public ResponseInfo Response
//    {
//        get
//        {
//            return this.responseField;
//        }
//        set
//        {
//            this.responseField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/AddAccountResponse.xsd", IncludeInSchema = false)]
//public enum ItemChoiceType1
//{

//    /// <remarks/>
//    GUID,

//    /// <remarks/>
//    billingAccountNumber,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class NationalAccountBillingServiceInfo
//{

//    private string serviceBureauField;

//    private string consolidatorField;

//    private string batchTypeField;

//    private string countryField;

//    /// <remarks/>
//    public string serviceBureau
//    {
//        get
//        {
//            return this.serviceBureauField;
//        }
//        set
//        {
//            this.serviceBureauField = value;
//        }
//    }

//    /// <remarks/>
//    public string consolidator
//    {
//        get
//        {
//            return this.consolidatorField;
//        }
//        set
//        {
//            this.consolidatorField = value;
//        }
//    }

//    /// <remarks/>
//    public string batchType
//    {
//        get
//        {
//            return this.batchTypeField;
//        }
//        set
//        {
//            this.batchTypeField = value;
//        }
//    }

//    /// <remarks/>
//    public string country
//    {
//        get
//        {
//            return this.countryField;
//        }
//        set
//        {
//            this.countryField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class RestrictedAccountTypeInfo
//{

//    private string accountTypeField;

//    private string accountSubTypeField;

//    private BusinessTypeInfo businessTypeField;

//    private bool businessTypeFieldSpecified;

//    private OpenChannelInfo openChannelField;

//    /// <remarks/>
//    public string accountType
//    {
//        get
//        {
//            return this.accountTypeField;
//        }
//        set
//        {
//            this.accountTypeField = value;
//        }
//    }

//    /// <remarks/>
//    public string accountSubType
//    {
//        get
//        {
//            return this.accountSubTypeField;
//        }
//        set
//        {
//            this.accountSubTypeField = value;
//        }
//    }

//    /// <remarks/>
//    public BusinessTypeInfo businessType
//    {
//        get
//        {
//            return this.businessTypeField;
//        }
//        set
//        {
//            this.businessTypeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool businessTypeSpecified
//    {
//        get
//        {
//            return this.businessTypeFieldSpecified;
//        }
//        set
//        {
//            this.businessTypeFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public OpenChannelInfo openChannel
//    {
//        get
//        {
//            return this.openChannelField;
//        }
//        set
//        {
//            this.openChannelField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/AddAccountRequest.xsd")]
//public partial class AddAccountRequestInfo
//{

//    private MarketAndZipServiceInfo marketServiceInfoField;

//    private AddAccountRequestInfoAccount accountField;

//    private AddAccountRequestInfoCustomer customerField;

//    private DealerCommissionInfo commissionField;

//    private CreditApplicationTypeInfo creditApplicationTypeField;

//    private string desiredNumberOfLinesField;

//    private AddAccountRequestInfoReserveSubscriberNumber[] reserveSubscriberNumberField;

//    /// <remarks/>
//    public MarketAndZipServiceInfo marketServiceInfo
//    {
//        get
//        {
//            return this.marketServiceInfoField;
//        }
//        set
//        {
//            this.marketServiceInfoField = value;
//        }
//    }

//    /// <remarks/>
//    public AddAccountRequestInfoAccount Account
//    {
//        get
//        {
//            return this.accountField;
//        }
//        set
//        {
//            this.accountField = value;
//        }
//    }

//    /// <remarks/>
//    public AddAccountRequestInfoCustomer Customer
//    {
//        get
//        {
//            return this.customerField;
//        }
//        set
//        {
//            this.customerField = value;
//        }
//    }

//    /// <remarks/>
//    public DealerCommissionInfo Commission
//    {
//        get
//        {
//            return this.commissionField;
//        }
//        set
//        {
//            this.commissionField = value;
//        }
//    }

//    /// <remarks/>
//    public CreditApplicationTypeInfo creditApplicationType
//    {
//        get
//        {
//            return this.creditApplicationTypeField;
//        }
//        set
//        {
//            this.creditApplicationTypeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "positiveInteger")]
//    public string desiredNumberOfLines
//    {
//        get
//        {
//            return this.desiredNumberOfLinesField;
//        }
//        set
//        {
//            this.desiredNumberOfLinesField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("ReserveSubscriberNumber")]
//    public AddAccountRequestInfoReserveSubscriberNumber[] ReserveSubscriberNumber
//    {
//        get
//        {
//            return this.reserveSubscriberNumberField;
//        }
//        set
//        {
//            this.reserveSubscriberNumberField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/AddAccountRequest.xsd")]
//public partial class AddAccountRequestInfoAccount
//{

//    private string gUIDField;

//    private string billingAccountPasswordField;

//    private string fanField;

//    private RestrictedAccountTypeInfo accountTypeField;

//    private AddAccountRequestInfoAccountAffiliatePreScore affiliatePreScoreField;

//    private AddAccountRequestInfoAccountAccountBilling accountBillingField;

//    private BillingPreferencesInfo billingPreferencesField;

//    private AddAccountRequestInfoAccountNationalAccount nationalAccountField;

//    private bool taxExemptionRequestField;

//    /// <remarks/>
//    public string GUID
//    {
//        get
//        {
//            return this.gUIDField;
//        }
//        set
//        {
//            this.gUIDField = value;
//        }
//    }

//    /// <remarks/>
//    public string billingAccountPassword
//    {
//        get
//        {
//            return this.billingAccountPasswordField;
//        }
//        set
//        {
//            this.billingAccountPasswordField = value;
//        }
//    }

//    /// <remarks/>
//    public string fan
//    {
//        get
//        {
//            return this.fanField;
//        }
//        set
//        {
//            this.fanField = value;
//        }
//    }

//    /// <remarks/>
//    public RestrictedAccountTypeInfo AccountType
//    {
//        get
//        {
//            return this.accountTypeField;
//        }
//        set
//        {
//            this.accountTypeField = value;
//        }
//    }

//    /// <remarks/>
//    public AddAccountRequestInfoAccountAffiliatePreScore AffiliatePreScore
//    {
//        get
//        {
//            return this.affiliatePreScoreField;
//        }
//        set
//        {
//            this.affiliatePreScoreField = value;
//        }
//    }

//    /// <remarks/>
//    public AddAccountRequestInfoAccountAccountBilling AccountBilling
//    {
//        get
//        {
//            return this.accountBillingField;
//        }
//        set
//        {
//            this.accountBillingField = value;
//        }
//    }

//    /// <remarks/>
//    public BillingPreferencesInfo BillingPreferences
//    {
//        get
//        {
//            return this.billingPreferencesField;
//        }
//        set
//        {
//            this.billingPreferencesField = value;
//        }
//    }

//    /// <remarks/>
//    public AddAccountRequestInfoAccountNationalAccount NationalAccount
//    {
//        get
//        {
//            return this.nationalAccountField;
//        }
//        set
//        {
//            this.nationalAccountField = value;
//        }
//    }

//    /// <remarks/>
//    public bool taxExemptionRequest
//    {
//        get
//        {
//            return this.taxExemptionRequestField;
//        }
//        set
//        {
//            this.taxExemptionRequestField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/AddAccountRequest.xsd")]
//public partial class AddAccountRequestInfoAccountAffiliatePreScore
//{

//    private string creditClassField;

//    private string creditScoreField;

//    /// <remarks/>
//    public string creditClass
//    {
//        get
//        {
//            return this.creditClassField;
//        }
//        set
//        {
//            this.creditClassField = value;
//        }
//    }

//    /// <remarks/>
//    public string creditScore
//    {
//        get
//        {
//            return this.creditScoreField;
//        }
//        set
//        {
//            this.creditScoreField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/AddAccountRequest.xsd")]
//public partial class AddAccountRequestInfoAccountAccountBilling
//{

//    private short billingCycleField;

//    /// <remarks/>
//    public short billingCycle
//    {
//        get
//        {
//            return this.billingCycleField;
//        }
//        set
//        {
//            this.billingCycleField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/AddAccountRequest.xsd")]
//public partial class AddAccountRequestInfoAccountNationalAccount
//{

//    private string majorAccountNumberField;

//    private NationalAccountBillingServiceInfo nationalAccountBillingServiceField;

//    /// <remarks/>
//    public string majorAccountNumber
//    {
//        get
//        {
//            return this.majorAccountNumberField;
//        }
//        set
//        {
//            this.majorAccountNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public NationalAccountBillingServiceInfo nationalAccountBillingService
//    {
//        get
//        {
//            return this.nationalAccountBillingServiceField;
//        }
//        set
//        {
//            this.nationalAccountBillingServiceField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/AddAccountRequest.xsd")]
//public partial class AddAccountRequestInfoCustomer
//{

//    private object[] itemsField;

//    private AddressInfo addressField;

//    private PhoneInfo phoneField;

//    private EmailInfo emailField;

//    private AddAccountRequestInfoCustomerIdentity identityField;

//    private AddAccountRequestInfoCustomerCreditCheckName creditCheckNameField;

//    private AddressInfo creditCheckAddressField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("businessName", typeof(NameBusinessInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("doingBusinessAs", typeof(string))]
//    [System.Xml.Serialization.XmlElementAttribute("name", typeof(ExtendedNameInfo))]
//    public object[] Items
//    {
//        get
//        {
//            return this.itemsField;
//        }
//        set
//        {
//            this.itemsField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressInfo Address
//    {
//        get
//        {
//            return this.addressField;
//        }
//        set
//        {
//            this.addressField = value;
//        }
//    }

//    /// <remarks/>
//    public PhoneInfo Phone
//    {
//        get
//        {
//            return this.phoneField;
//        }
//        set
//        {
//            this.phoneField = value;
//        }
//    }

//    /// <remarks/>
//    public EmailInfo Email
//    {
//        get
//        {
//            return this.emailField;
//        }
//        set
//        {
//            this.emailField = value;
//        }
//    }

//    /// <remarks/>
//    public AddAccountRequestInfoCustomerIdentity Identity
//    {
//        get
//        {
//            return this.identityField;
//        }
//        set
//        {
//            this.identityField = value;
//        }
//    }

//    /// <remarks/>
//    public AddAccountRequestInfoCustomerCreditCheckName CreditCheckName
//    {
//        get
//        {
//            return this.creditCheckNameField;
//        }
//        set
//        {
//            this.creditCheckNameField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressInfo CreditCheckAddress
//    {
//        get
//        {
//            return this.creditCheckAddressField;
//        }
//        set
//        {
//            this.creditCheckAddressField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/AddAccountRequest.xsd")]
//public partial class AddAccountRequestInfoCustomerIdentity
//{

//    private RestrictedIdentificationInfo identificationField;

//    private EmployerInfo employerField;

//    private object[] itemsField;

//    private ItemsChoiceType1[] itemsElementNameField;

//    /// <remarks/>
//    public RestrictedIdentificationInfo Identification
//    {
//        get
//        {
//            return this.identificationField;
//        }
//        set
//        {
//            this.identificationField = value;
//        }
//    }

//    /// <remarks/>
//    public EmployerInfo Employer
//    {
//        get
//        {
//            return this.employerField;
//        }
//        set
//        {
//            this.employerField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("Birth", typeof(BirthInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("businessTaxId", typeof(string))]
//    [System.Xml.Serialization.XmlElementAttribute("socialSecurityNumber", typeof(string))]
//    [System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")]
//    public object[] Items
//    {
//        get
//        {
//            return this.itemsField;
//        }
//        set
//        {
//            this.itemsField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("ItemsElementName")]
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public ItemsChoiceType1[] ItemsElementName
//    {
//        get
//        {
//            return this.itemsElementNameField;
//        }
//        set
//        {
//            this.itemsElementNameField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/AddAccountRequest.xsd", IncludeInSchema = false)]
//public enum ItemsChoiceType1
//{

//    /// <remarks/>
//    Birth,

//    /// <remarks/>
//    businessTaxId,

//    /// <remarks/>
//    socialSecurityNumber,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/AddAccountRequest.xsd")]
//public partial class AddAccountRequestInfoCustomerCreditCheckName
//{

//    private object itemField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("Name", typeof(NameInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("companyName", typeof(string))]
//    public object Item
//    {
//        get
//        {
//            return this.itemField;
//        }
//        set
//        {
//            this.itemField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum CreditApplicationTypeInfo
//{

//    /// <remarks/>
//    CRR,

//    /// <remarks/>
//    GOV,

//    /// <remarks/>
//    MAJ,

//    /// <remarks/>
//    MAN,

//    /// <remarks/>
//    NAT,

//    /// <remarks/>
//    COCTN,

//    /// <remarks/>
//    PUTIL,

//    /// <remarks/>
//    SBMSE,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/AddAccountRequest.xsd")]
//public partial class AddAccountRequestInfoReserveSubscriberNumber
//{

//    private string serviceAreaField;

//    private object[] itemsField;

//    /// <remarks/>
//    public string serviceArea
//    {
//        get
//        {
//            return this.serviceAreaField;
//        }
//        set
//        {
//            this.serviceAreaField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("ContactInformation", typeof(AddAccountRequestInfoReserveSubscriberNumberContactInformation))]
//    [System.Xml.Serialization.XmlElementAttribute("equipmentType", typeof(EquipmentTypeInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("quantity", typeof(long))]
//    public object[] Items
//    {
//        get
//        {
//            return this.itemsField;
//        }
//        set
//        {
//            this.itemsField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/AddAccountRequest.xsd")]
//public partial class AddAccountRequestInfoReserveSubscriberNumberContactInformation
//{

//    private object itemField;

//    private AddressInfo addressField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("BusinessName", typeof(NameBusinessInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("Name", typeof(NameInfo))]
//    public object Item
//    {
//        get
//        {
//            return this.itemField;
//        }
//        set
//        {
//            this.itemField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressInfo Address
//    {
//        get
//        {
//            return this.addressField;
//        }
//        set
//        {
//            this.addressField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ActivateSubscriberRespons" +
//    "e.xsd")]
//public partial class ActivateSubscriberResponseInfo
//{

//    private string billingAccountNumberField;

//    private ActivateSubscriberResponseInfoSubscriber[] subscriberField;

//    private ResponseInfo responseField;

//    /// <remarks/>
//    public string billingAccountNumber
//    {
//        get
//        {
//            return this.billingAccountNumberField;
//        }
//        set
//        {
//            this.billingAccountNumberField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("Subscriber")]
//    public ActivateSubscriberResponseInfoSubscriber[] Subscriber
//    {
//        get
//        {
//            return this.subscriberField;
//        }
//        set
//        {
//            this.subscriberField = value;
//        }
//    }

//    /// <remarks/>
//    public ResponseInfo Response
//    {
//        get
//        {
//            return this.responseField;
//        }
//        set
//        {
//            this.responseField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ActivateSubscriberRespons" +
//    "e.xsd")]
//public partial class ActivateSubscriberResponseInfoSubscriber
//{

//    private string subscriberNumberField;

//    private SubscriberStatusInfo subscriberStatusField;

//    private int requiredDepositField;

//    private bool requiredDepositFieldSpecified;

//    private ResponseInfo responseField;

//    /// <remarks/>
//    public string subscriberNumber
//    {
//        get
//        {
//            return this.subscriberNumberField;
//        }
//        set
//        {
//            this.subscriberNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public SubscriberStatusInfo subscriberStatus
//    {
//        get
//        {
//            return this.subscriberStatusField;
//        }
//        set
//        {
//            this.subscriberStatusField = value;
//        }
//    }

//    /// <remarks/>
//    public int requiredDeposit
//    {
//        get
//        {
//            return this.requiredDepositField;
//        }
//        set
//        {
//            this.requiredDepositField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool requiredDepositSpecified
//    {
//        get
//        {
//            return this.requiredDepositFieldSpecified;
//        }
//        set
//        {
//            this.requiredDepositFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public ResponseInfo Response
//    {
//        get
//        {
//            return this.responseField;
//        }
//        set
//        {
//            this.responseField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/RequestAcknowledgement.xs" +
//    "d")]
//public partial class RequestAcknowledgementInfo
//{

//    private ResponseInfo responseField;

//    /// <remarks/>
//    public ResponseInfo Response
//    {
//        get
//        {
//            return this.responseField;
//        }
//        set
//        {
//            this.responseField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class AffiliateInfo
//{

//    private string billingTelephoneNumberField;

//    private string salesCodeField;

//    private string customerCodeField;

//    private string unitIdentificationCodeField;

//    /// <remarks/>
//    public string billingTelephoneNumber
//    {
//        get
//        {
//            return this.billingTelephoneNumberField;
//        }
//        set
//        {
//            this.billingTelephoneNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public string salesCode
//    {
//        get
//        {
//            return this.salesCodeField;
//        }
//        set
//        {
//            this.salesCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string customerCode
//    {
//        get
//        {
//            return this.customerCodeField;
//        }
//        set
//        {
//            this.customerCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public string unitIdentificationCode
//    {
//        get
//        {
//            return this.unitIdentificationCodeField;
//        }
//        set
//        {
//            this.unitIdentificationCodeField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class LongDistanceCarrierInfo
//{

//    private string longDistanceCarrierCodeField;

//    private System.DateTime effectiveDateField;

//    private bool effectiveDateFieldSpecified;

//    private DealerCommissionInfo commissionField;

//    /// <remarks/>
//    public string longDistanceCarrierCode
//    {
//        get
//        {
//            return this.longDistanceCarrierCodeField;
//        }
//        set
//        {
//            this.longDistanceCarrierCodeField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime effectiveDate
//    {
//        get
//        {
//            return this.effectiveDateField;
//        }
//        set
//        {
//            this.effectiveDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool effectiveDateSpecified
//    {
//        get
//        {
//            return this.effectiveDateFieldSpecified;
//        }
//        set
//        {
//            this.effectiveDateFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public DealerCommissionInfo Commission
//    {
//        get
//        {
//            return this.commissionField;
//        }
//        set
//        {
//            this.commissionField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class PrePaidInfo
//{

//    private string prePaidPinField;

//    /// <remarks/>
//    public string prePaidPin
//    {
//        get
//        {
//            return this.prePaidPinField;
//        }
//        set
//        {
//            this.prePaidPinField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ActivateSubscriberRequest" +
//    ".xsd")]
//public partial class ActivateSubscriberRequestInfo
//{

//    private MarketAndZipServiceInfo marketServiceInfoField;

//    private string billingAccountNumberField;

//    private ActivateSubscriberRequestInfoSubscriber[] subscriberField;

//    /// <remarks/>
//    public MarketAndZipServiceInfo MarketServiceInfo
//    {
//        get
//        {
//            return this.marketServiceInfoField;
//        }
//        set
//        {
//            this.marketServiceInfoField = value;
//        }
//    }

//    /// <remarks/>
//    public string billingAccountNumber
//    {
//        get
//        {
//            return this.billingAccountNumberField;
//        }
//        set
//        {
//            this.billingAccountNumberField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("Subscriber")]
//    public ActivateSubscriberRequestInfoSubscriber[] Subscriber
//    {
//        get
//        {
//            return this.subscriberField;
//        }
//        set
//        {
//            this.subscriberField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ActivateSubscriberRequest" +
//    ".xsd")]
//public partial class ActivateSubscriberRequestInfoSubscriber
//{

//    private string subscriberNumberField;

//    private string serviceAreaField;

//    private ActivateSubscriberRequestInfoSubscriberContract contractField;

//    private ActivateSubscriberRequestInfoSubscriberContactInformation contactInformationField;

//    private System.DateTime activationDateField;

//    private bool activationDateFieldSpecified;

//    private string waiveActivationFeeReasonCodeField;

//    private ActivateSubscriberRequestInfoSubscriberDeposit depositField;

//    private PricePlanInfo pricePlanField;

//    private OfferingsAdditionalInfo[] additionalOfferingsField;

//    private DiscountInfo[] discountsField;

//    private PrePaidInfo prePaidField;

//    private LongDistanceCarrierInfo longDistanceCarrierField;

//    private DeviceInfo deviceField;

//    private bool suspendImmediateField;

//    private PortingLocatorInfo portingLocatorField;

//    private UserDefinedValuesInfo userDefinedValuesField;

//    private string fulfillmentOrderIdField;

//    private ActivateSubscriberRequestInfoSubscriberCopayInfo copayInfoField;

//    private AffiliateInfo affiliateInfoField;

//    public ActivateSubscriberRequestInfoSubscriber()
//    {
//        this.suspendImmediateField = false;
//    }

//    /// <remarks/>
//    public string subscriberNumber
//    {
//        get
//        {
//            return this.subscriberNumberField;
//        }
//        set
//        {
//            this.subscriberNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public string serviceArea
//    {
//        get
//        {
//            return this.serviceAreaField;
//        }
//        set
//        {
//            this.serviceAreaField = value;
//        }
//    }

//    /// <remarks/>
//    public ActivateSubscriberRequestInfoSubscriberContract Contract
//    {
//        get
//        {
//            return this.contractField;
//        }
//        set
//        {
//            this.contractField = value;
//        }
//    }

//    /// <remarks/>
//    public ActivateSubscriberRequestInfoSubscriberContactInformation ContactInformation
//    {
//        get
//        {
//            return this.contactInformationField;
//        }
//        set
//        {
//            this.contactInformationField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
//    public System.DateTime activationDate
//    {
//        get
//        {
//            return this.activationDateField;
//        }
//        set
//        {
//            this.activationDateField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool activationDateSpecified
//    {
//        get
//        {
//            return this.activationDateFieldSpecified;
//        }
//        set
//        {
//            this.activationDateFieldSpecified = value;
//        }
//    }

//    /// <remarks/>
//    public string waiveActivationFeeReasonCode
//    {
//        get
//        {
//            return this.waiveActivationFeeReasonCodeField;
//        }
//        set
//        {
//            this.waiveActivationFeeReasonCodeField = value;
//        }
//    }

//    /// <remarks/>
//    public ActivateSubscriberRequestInfoSubscriberDeposit Deposit
//    {
//        get
//        {
//            return this.depositField;
//        }
//        set
//        {
//            this.depositField = value;
//        }
//    }

//    /// <remarks/>
//    public PricePlanInfo PricePlan
//    {
//        get
//        {
//            return this.pricePlanField;
//        }
//        set
//        {
//            this.pricePlanField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("AdditionalOfferings")]
//    public OfferingsAdditionalInfo[] AdditionalOfferings
//    {
//        get
//        {
//            return this.additionalOfferingsField;
//        }
//        set
//        {
//            this.additionalOfferingsField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("Discounts")]
//    public DiscountInfo[] Discounts
//    {
//        get
//        {
//            return this.discountsField;
//        }
//        set
//        {
//            this.discountsField = value;
//        }
//    }

//    /// <remarks/>
//    public PrePaidInfo PrePaid
//    {
//        get
//        {
//            return this.prePaidField;
//        }
//        set
//        {
//            this.prePaidField = value;
//        }
//    }

//    /// <remarks/>
//    public LongDistanceCarrierInfo LongDistanceCarrier
//    {
//        get
//        {
//            return this.longDistanceCarrierField;
//        }
//        set
//        {
//            this.longDistanceCarrierField = value;
//        }
//    }

//    /// <remarks/>
//    public DeviceInfo Device
//    {
//        get
//        {
//            return this.deviceField;
//        }
//        set
//        {
//            this.deviceField = value;
//        }
//    }

//    /// <remarks/>
//    public bool suspendImmediate
//    {
//        get
//        {
//            return this.suspendImmediateField;
//        }
//        set
//        {
//            this.suspendImmediateField = value;
//        }
//    }

//    /// <remarks/>
//    public PortingLocatorInfo PortingLocator
//    {
//        get
//        {
//            return this.portingLocatorField;
//        }
//        set
//        {
//            this.portingLocatorField = value;
//        }
//    }

//    /// <remarks/>
//    public UserDefinedValuesInfo UserDefinedValues
//    {
//        get
//        {
//            return this.userDefinedValuesField;
//        }
//        set
//        {
//            this.userDefinedValuesField = value;
//        }
//    }

//    /// <remarks/>
//    public string fulfillmentOrderId
//    {
//        get
//        {
//            return this.fulfillmentOrderIdField;
//        }
//        set
//        {
//            this.fulfillmentOrderIdField = value;
//        }
//    }

//    /// <remarks/>
//    public ActivateSubscriberRequestInfoSubscriberCopayInfo CopayInfo
//    {
//        get
//        {
//            return this.copayInfoField;
//        }
//        set
//        {
//            this.copayInfoField = value;
//        }
//    }

//    /// <remarks/>
//    public AffiliateInfo AffiliateInfo
//    {
//        get
//        {
//            return this.affiliateInfoField;
//        }
//        set
//        {
//            this.affiliateInfoField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ActivateSubscriberRequest" +
//    ".xsd")]
//public partial class ActivateSubscriberRequestInfoSubscriberContract
//{

//    private ContractTermInfo contractTermField;

//    private TermsConditionsStatusInfo termsConditionStatusField;

//    /// <remarks/>
//    public ContractTermInfo ContractTerm
//    {
//        get
//        {
//            return this.contractTermField;
//        }
//        set
//        {
//            this.contractTermField = value;
//        }
//    }

//    /// <remarks/>
//    public TermsConditionsStatusInfo termsConditionStatus
//    {
//        get
//        {
//            return this.termsConditionStatusField;
//        }
//        set
//        {
//            this.termsConditionStatusField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ActivateSubscriberRequest" +
//    ".xsd")]
//public partial class ActivateSubscriberRequestInfoSubscriberContactInformation
//{

//    private object itemField;

//    private AddressInfo addressField;

//    private PhoneInfo phoneField;

//    private EmailInfo emailField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("Name", typeof(NameInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("businessName", typeof(NameBusinessInfo))]
//    public object Item
//    {
//        get
//        {
//            return this.itemField;
//        }
//        set
//        {
//            this.itemField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressInfo Address
//    {
//        get
//        {
//            return this.addressField;
//        }
//        set
//        {
//            this.addressField = value;
//        }
//    }

//    /// <remarks/>
//    public PhoneInfo Phone
//    {
//        get
//        {
//            return this.phoneField;
//        }
//        set
//        {
//            this.phoneField = value;
//        }
//    }

//    /// <remarks/>
//    public EmailInfo Email
//    {
//        get
//        {
//            return this.emailField;
//        }
//        set
//        {
//            this.emailField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ActivateSubscriberRequest" +
//    ".xsd")]
//public partial class ActivateSubscriberRequestInfoSubscriberDeposit
//{

//    private int depositAmountField;

//    private DepositMethodInfo depositMethodField;

//    private bool depositMethodFieldSpecified;

//    /// <remarks/>
//    public int depositAmount
//    {
//        get
//        {
//            return this.depositAmountField;
//        }
//        set
//        {
//            this.depositAmountField = value;
//        }
//    }

//    /// <remarks/>
//    public DepositMethodInfo depositMethod
//    {
//        get
//        {
//            return this.depositMethodField;
//        }
//        set
//        {
//            this.depositMethodField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool depositMethodSpecified
//    {
//        get
//        {
//            return this.depositMethodFieldSpecified;
//        }
//        set
//        {
//            this.depositMethodFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public enum DepositMethodInfo
//{

//    /// <remarks/>
//    S,

//    /// <remarks/>
//    B,
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/ActivateSubscriberRequest" +
//    ".xsd")]
//public partial class ActivateSubscriberRequestInfoSubscriberCopayInfo
//{

//    private string receivingBanField;

//    private string allowanceIdField;

//    /// <remarks/>
//    public string receivingBan
//    {
//        get
//        {
//            return this.receivingBanField;
//        }
//        set
//        {
//            this.receivingBanField = value;
//        }
//    }

//    /// <remarks/>
//    public string allowanceId
//    {
//        get
//        {
//            return this.allowanceIdField;
//        }
//        set
//        {
//            this.allowanceIdField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class MessageHeaderSequence
//{

//    private string sequenceNumberField;

//    private string totalInSequenceField;

//    /// <remarks/>
//    public string sequenceNumber
//    {
//        get
//        {
//            return this.sequenceNumberField;
//        }
//        set
//        {
//            this.sequenceNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public string totalInSequence
//    {
//        get
//        {
//            return this.totalInSequenceField;
//        }
//        set
//        {
//            this.totalInSequenceField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd")]
//public partial class MessageHeaderSecurity
//{

//    private string userNameField;

//    private string userPasswordField;

//    /// <remarks/>
//    public string userName
//    {
//        get
//        {
//            return this.userNameField;
//        }
//        set
//        {
//            this.userNameField = value;
//        }
//    }

//    /// <remarks/>
//    public string userPassword
//    {
//        get
//        {
//            return this.userPasswordField;
//        }
//        set
//        {
//            this.userPasswordField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/UpdateSubscriberProfileRe" +
//    "quest.xsd")]
//public partial class UpdateSubscriberProfileRequestInfoSubscriber
//{

//    private string subscriberNumberField;

//    private UpdateSubscriberProfileRequestInfoSubscriberContract contractField;

//    private UpdateSubscriberProfileRequestInfoSubscriberContactInformation contactInformationField;

//    private RestrictedPricePlanInfo pricePlanField;

//    private OfferingsAdditionalInfo[] additionalOfferingsField;

//    private DiscountInfo[] discountsField;

//    private LongDistanceCarrierInfo longDistanceCarrierField;

//    private SolicitationIndicatorsInfo[] solicitationIndicatorsField;

//    private UserDefinedValuesInfo userDefinedLabelValuesField;

//    private string imeiForCommissionCodesSearchField;

//    /// <remarks/>
//    public string subscriberNumber
//    {
//        get
//        {
//            return this.subscriberNumberField;
//        }
//        set
//        {
//            this.subscriberNumberField = value;
//        }
//    }

//    /// <remarks/>
//    public UpdateSubscriberProfileRequestInfoSubscriberContract Contract
//    {
//        get
//        {
//            return this.contractField;
//        }
//        set
//        {
//            this.contractField = value;
//        }
//    }

//    /// <remarks/>
//    public UpdateSubscriberProfileRequestInfoSubscriberContactInformation ContactInformation
//    {
//        get
//        {
//            return this.contactInformationField;
//        }
//        set
//        {
//            this.contactInformationField = value;
//        }
//    }

//    /// <remarks/>
//    public RestrictedPricePlanInfo PricePlan
//    {
//        get
//        {
//            return this.pricePlanField;
//        }
//        set
//        {
//            this.pricePlanField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("AdditionalOfferings")]
//    public OfferingsAdditionalInfo[] AdditionalOfferings
//    {
//        get
//        {
//            return this.additionalOfferingsField;
//        }
//        set
//        {
//            this.additionalOfferingsField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("Discounts")]
//    public DiscountInfo[] Discounts
//    {
//        get
//        {
//            return this.discountsField;
//        }
//        set
//        {
//            this.discountsField = value;
//        }
//    }

//    /// <remarks/>
//    public LongDistanceCarrierInfo LongDistanceCarrier
//    {
//        get
//        {
//            return this.longDistanceCarrierField;
//        }
//        set
//        {
//            this.longDistanceCarrierField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("SolicitationIndicators")]
//    public SolicitationIndicatorsInfo[] SolicitationIndicators
//    {
//        get
//        {
//            return this.solicitationIndicatorsField;
//        }
//        set
//        {
//            this.solicitationIndicatorsField = value;
//        }
//    }

//    /// <remarks/>
//    public UserDefinedValuesInfo UserDefinedLabelValues
//    {
//        get
//        {
//            return this.userDefinedLabelValuesField;
//        }
//        set
//        {
//            this.userDefinedLabelValuesField = value;
//        }
//    }

//    /// <remarks/>
//    public string imeiForCommissionCodesSearch
//    {
//        get
//        {
//            return this.imeiForCommissionCodesSearchField;
//        }
//        set
//        {
//            this.imeiForCommissionCodesSearchField = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/UpdateSubscriberProfileRe" +
//    "quest.xsd")]
//public partial class UpdateSubscriberProfileRequestInfoSubscriberContract
//{

//    private ContractTermInfo contractTermField;

//    private TermsConditionsStatusInfo termsConditionStatusField;

//    private bool termsConditionStatusFieldSpecified;

//    /// <remarks/>
//    public ContractTermInfo ContractTerm
//    {
//        get
//        {
//            return this.contractTermField;
//        }
//        set
//        {
//            this.contractTermField = value;
//        }
//    }

//    /// <remarks/>
//    public TermsConditionsStatusInfo termsConditionStatus
//    {
//        get
//        {
//            return this.termsConditionStatusField;
//        }
//        set
//        {
//            this.termsConditionStatusField = value;
//        }
//    }

//    /// <remarks/>
//    [System.Xml.Serialization.XmlIgnoreAttribute()]
//    public bool termsConditionStatusSpecified
//    {
//        get
//        {
//            return this.termsConditionStatusFieldSpecified;
//        }
//        set
//        {
//            this.termsConditionStatusFieldSpecified = value;
//        }
//    }
//}

///// <remarks/>
//[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
//[System.SerializableAttribute()]
//[System.Diagnostics.DebuggerStepThroughAttribute()]
//[System.ComponentModel.DesignerCategoryAttribute("code")]
//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://csi.cingular.com/CSI/Namespaces/Container/Public/UpdateSubscriberProfileRe" +
//    "quest.xsd")]
//public partial class UpdateSubscriberProfileRequestInfoSubscriberContactInformation
//{

//    private object itemField;

//    private AddressInfo ppuAddressField;

//    private PhoneInfo phoneField;

//    private EmailInfo emailField;

//    private RestrictedIdentificationInfo identificationField;

//    /// <remarks/>
//    [System.Xml.Serialization.XmlElementAttribute("Name", typeof(NameInfo))]
//    [System.Xml.Serialization.XmlElementAttribute("businessName", typeof(NameBusinessInfo))]
//    public object Item
//    {
//        get
//        {
//            return this.itemField;
//        }
//        set
//        {
//            this.itemField = value;
//        }
//    }

//    /// <remarks/>
//    public AddressInfo PpuAddress
//    {
//        get
//        {
//            return this.ppuAddressField;
//        }
//        set
//        {
//            this.ppuAddressField = value;
//        }
//    }

//    /// <remarks/>
//    public PhoneInfo Phone
//    {
//        get
//        {
//            return this.phoneField;
//        }
//        set
//        {
//            this.phoneField = value;
//        }
//    }

//    /// <remarks/>
//    public EmailInfo Email
//    {
//        get
//        {
//            return this.emailField;
//        }
//        set
//        {
//            this.emailField = value;
//        }
//    }

//    /// <remarks/>
//    public RestrictedIdentificationInfo Identification
//    {
//        get
//        {
//            return this.identificationField;
//        }
//        set
//        {
//            this.identificationField = value;
//        }
//    }
//}
