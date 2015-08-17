
// HAND PULLED COMMON ELEMENTS FROM THE DIFFERENT WSDL GENERATED FILES 

namespace TMobileCarrierServiceInterface.Interfaces.Common
{
    using System.Diagnostics;
    using System.Web.Services;
    using System.ComponentModel;
    using System.Web.Services.Protocols;
    using System;
    using System.Xml.Serialization;


    /// <remarks/>
    [System.Xml.Serialization.XmlIncludeAttribute(typeof(RspResponse))]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public abstract partial class RspRequest
    {

        private Header headerField;

        /// <remarks/>
        public Header header
        {
            get
            {
                return this.headerField;
            }
            set
            {
                this.headerField = value;
            }
        }
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public partial class Header
    {

        private string partnerIdField;

        private string partnerTransactionIdField;

        private System.DateTime partnerTimestampField;

        private string applicationField;

        private string applicationUserIdField;

        private string channelField;

        private string targetSystemUserIdField;

        private string storeIdField;

        private string dealerCodeField;

        private string rspTransactionIdField;

        private string authenticatedIdField;

        private string rspServiceVersionField;

        public Header()
        {
            this.storeIdField = "9999";
            this.rspServiceVersionField = "1.13.1";
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "token")]
        public string partnerId
        {
            get
            {
                return this.partnerIdField;
            }
            set
            {
                this.partnerIdField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "normalizedString")]
        public string partnerTransactionId
        {
            get
            {
                return this.partnerTransactionIdField;
            }
            set
            {
                this.partnerTransactionIdField = value;
            }
        }

        /// <remarks/>
        public System.DateTime partnerTimestamp
        {
            get
            {
                return this.partnerTimestampField;
            }
            set
            {
                this.partnerTimestampField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "token")]
        public string application
        {
            get
            {
                return this.applicationField;
            }
            set
            {
                this.applicationField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "token")]
        public string applicationUserId
        {
            get
            {
                return this.applicationUserIdField;
            }
            set
            {
                this.applicationUserIdField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "token")]
        public string channel
        {
            get
            {
                return this.channelField;
            }
            set
            {
                this.channelField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "token")]
        public string targetSystemUserId
        {
            get
            {
                return this.targetSystemUserIdField;
            }
            set
            {
                this.targetSystemUserIdField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "token")]
        [System.ComponentModel.DefaultValueAttribute("9999")]
        public string storeId
        {
            get
            {
                return this.storeIdField;
            }
            set
            {
                this.storeIdField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "token")]
        public string dealerCode
        {
            get
            {
                return this.dealerCodeField;
            }
            set
            {
                this.dealerCodeField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "token")]
        public string rspTransactionId
        {
            get
            {
                return this.rspTransactionIdField;
            }
            set
            {
                this.rspTransactionIdField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "token")]
        public string authenticatedId
        {
            get
            {
                return this.authenticatedIdField;
            }
            set
            {
                this.authenticatedIdField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(DataType = "token")]
        [System.ComponentModel.DefaultValueAttribute("1.13.1")]
        public string rspServiceVersion
        {
            get
            {
                return this.rspServiceVersionField;
            }
            set
            {
                this.rspServiceVersionField = value;
            }
        }
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public partial class StatusItem
    {

        private string statusCodeField;

        private string statusDescriptionField;

        private string explanationField;

        private string referenceIdField;

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "token")]
        public string statusCode
        {
            get
            {
                return this.statusCodeField;
            }
            set
            {
                this.statusCodeField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "normalizedString")]
        public string statusDescription
        {
            get
            {
                return this.statusDescriptionField;
            }
            set
            {
                this.statusDescriptionField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "normalizedString")]
        public string explanation
        {
            get
            {
                return this.explanationField;
            }
            set
            {
                this.explanationField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "token")]
        public string referenceId
        {
            get
            {
                return this.referenceIdField;
            }
            set
            {
                this.referenceIdField = value;
            }
        }
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public partial class ServiceStatus
    {

        private ServiceStatusEnum serviceStatusCodeField;

        private StatusItem[] serviceStatusItemField;

        /// <remarks/>
        public ServiceStatusEnum serviceStatusCode
        {
            get
            {
                return this.serviceStatusCodeField;
            }
            set
            {
                this.serviceStatusCodeField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("serviceStatusItem")]
        public StatusItem[] serviceStatusItem
        {
            get
            {
                return this.serviceStatusItemField;
            }
            set
            {
                this.serviceStatusItemField = value;
            }
        }
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum ServiceStatusEnum
    {

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("100")]
        Item100,

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("101")]
        Item101,

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("102")]
        Item102,

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("103")]
        Item103,

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("104")]
        Item104,

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("1010")]
        Item1010,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public abstract partial class RspResponse : RspRequest
    {

        private ServiceStatus serviceStatusField;

        /// <remarks/>
        public ServiceStatus serviceStatus
        {
            get
            {
                return this.serviceStatusField;
            }
            set
            {
                this.serviceStatusField = value;
            }
        }
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum StateEnum
    {

        /// <remarks/>
        AA,

        /// <remarks/>
        AB,

        /// <remarks/>
        AE,

        /// <remarks/>
        AG,

        /// <remarks/>
        AK,

        /// <remarks/>
        AL,

        /// <remarks/>
        AP,

        /// <remarks/>
        AR,

        /// <remarks/>
        AS,

        /// <remarks/>
        AZ,

        /// <remarks/>
        BA,

        /// <remarks/>
        BC,

        /// <remarks/>
        BI,

        /// <remarks/>
        BN,

        /// <remarks/>
        BS,

        /// <remarks/>
        CA,

        /// <remarks/>
        CI,

        /// <remarks/>
        CN,

        /// <remarks/>
        CO,

        /// <remarks/>
        CP,

        /// <remarks/>
        CS,

        /// <remarks/>
        CT,

        /// <remarks/>
        DC,

        /// <remarks/>
        DE,

        /// <remarks/>
        DF,

        /// <remarks/>
        DR,

        /// <remarks/>
        DU,

        /// <remarks/>
        FL,

        /// <remarks/>
        GA,

        /// <remarks/>
        GJ,

        /// <remarks/>
        GR,

        /// <remarks/>
        GT,

        /// <remarks/>
        GU,

        /// <remarks/>
        HD,

        /// <remarks/>
        HI,

        /// <remarks/>
        IA,

        /// <remarks/>
        ID,

        /// <remarks/>
        IL,

        /// <remarks/>
        IN,

        /// <remarks/>
        JA,

        /// <remarks/>
        KS,

        /// <remarks/>
        KY,

        /// <remarks/>
        LA,

        /// <remarks/>
        MA,

        /// <remarks/>
        MB,

        /// <remarks/>
        MC,

        /// <remarks/>
        MD,

        /// <remarks/>
        ME,

        /// <remarks/>
        MI,

        /// <remarks/>
        MN,

        /// <remarks/>
        MO,

        /// <remarks/>
        MR,

        /// <remarks/>
        MS,

        /// <remarks/>
        MT,

        /// <remarks/>
        MX,

        /// <remarks/>
        NA,

        /// <remarks/>
        NB,

        /// <remarks/>
        NC,

        /// <remarks/>
        ND,

        /// <remarks/>
        NE,

        /// <remarks/>
        NF,

        /// <remarks/>
        NH,

        /// <remarks/>
        NJ,

        /// <remarks/>
        NL,

        /// <remarks/>
        NM,

        /// <remarks/>
        NS,

        /// <remarks/>
        NT,

        /// <remarks/>
        NV,

        /// <remarks/>
        NY,

        /// <remarks/>
        OH,

        /// <remarks/>
        OK,

        /// <remarks/>
        ON,

        /// <remarks/>
        OR,

        /// <remarks/>
        OX,

        /// <remarks/>
        PA,

        /// <remarks/>
        PB,

        /// <remarks/>
        PE,

        /// <remarks/>
        PQ,

        /// <remarks/>
        PR,

        /// <remarks/>
        PU,

        /// <remarks/>
        QR,

        /// <remarks/>
        QT,

        /// <remarks/>
        RI,

        /// <remarks/>
        SC,

        /// <remarks/>
        SD,

        /// <remarks/>
        SI,

        /// <remarks/>
        SK,

        /// <remarks/>
        SL,

        /// <remarks/>
        SN,

        /// <remarks/>
        SO,

        /// <remarks/>
        TA,

        /// <remarks/>
        TB,

        /// <remarks/>
        TL,

        /// <remarks/>
        TN,

        /// <remarks/>
        TX,

        /// <remarks/>
        UT,

        /// <remarks/>
        VA,

        /// <remarks/>
        VE,

        /// <remarks/>
        VI,

        /// <remarks/>
        VT,

        /// <remarks/>
        WA,

        /// <remarks/>
        WI,

        /// <remarks/>
        WV,

        /// <remarks/>
        WY,

        /// <remarks/>
        YA,

        /// <remarks/>
        YC,

        /// <remarks/>
        YT,

        /// <remarks/>
        ZA,
    }



    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum AccountTypeSubTypeEnum
    {

        /// <remarks/>
        INDIVIDUAL_ASSOCIATION,

        /// <remarks/>
        INDIVIDUAL_GSA,

        /// <remarks/>
        INDIVIDUAL_GOVERNMENT,

        /// <remarks/>
        INDIVIDUAL_PCS1,

        /// <remarks/>
        INDIVIDUAL_LIFELINE,

        /// <remarks/>
        INDIVIDUAL_MCSA,

        /// <remarks/>
        INDIVIDUAL_REGULAR,

        /// <remarks/>
        INDIVIDUAL_SOLE_PROPRIETORSHIP,

        /// <remarks/>
        INDIVIDUAL_FLEXPAY_ANNUAL_CONTRACT,

        /// <remarks/>
        INDIVIDUAL_PREPAID,

        /// <remarks/>
        INDIVIDUAL_FLEXPAY_MONTHLY_CONTRACT,

        /// <remarks/>
        INDIVIDUAL_SMARTACCESS,

        /// <remarks/>
        BUSINESS_CORPORATE,

        /// <remarks/>
        BUSINESS_PCS1,

        /// <remarks/>
        BUSINESS_RETAIL,

        /// <remarks/>
        BUSINESS_MCSA,

        /// <remarks/>
        BUSINESS_NATIONAL,

        /// <remarks/>
        BUSINESS_MCSAGE,

        /// <remarks/>
        BUSINESS_NON_PROFIT,

        /// <remarks/>
        EXCEPTIONCONTROL_ECA,

        /// <remarks/>
        GOVERNMENT_GSA,

        /// <remarks/>
        GOVERNMENT_REGULAR,

        /// <remarks/>
        WHOLESALE_MVNO1_TRACFONE,

        /// <remarks/>
        WHOLESALE_IDT,

        /// <remarks/>
        WHOLESALE_MVNO_SIMPLE,

        /// <remarks/>
        RESELLER_REGULAR,

        /// <remarks/>
        SPECIAL_CONTRACTOR,

        /// <remarks/>
        SPECIAL_DEALER,

        /// <remarks/>
        SPECIAL_VIP_ECR,

        /// <remarks/>
        SPECIAL_PCS1_EMPLOYEE,

        /// <remarks/>
        SPECIAL_VIP,

        /// <remarks/>
        SPECIAL_COMPANY_USE_PHONES,

        /// <remarks/>
        SPECIAL_TEST_PHONES,

        /// <remarks/>
        SPECIAL_EVENT,

        /// <remarks/>
        SPECIAL_EMPLOYEE,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum IdTypeEnum
    {

        /// <remarks/>
        DL,

        /// <remarks/>
        MILI,

        /// <remarks/>
        PASS,

        /// <remarks/>
        TRIB,

        /// <remarks/>
        ALIE,

        /// <remarks/>
        DISA,

        /// <remarks/>
        ID,

        /// <remarks/>
        OTHER,
    }


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public partial class PersonalIdentification
    {

        private string idNumberField;

        private IdTypeEnum idTypeField;

        private bool idTypeFieldSpecified;

        private StateEnum idIssuingStateField;

        private bool idIssuingStateFieldSpecified;

        private System.DateTime idExpirationDateField;

        private bool idExpirationDateFieldSpecified;

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "normalizedString")]
        public string idNumber
        {
            get
            {
                return this.idNumberField;
            }
            set
            {
                this.idNumberField = value;
            }
        }

        /// <remarks/>
        public IdTypeEnum idType
        {
            get
            {
                return this.idTypeField;
            }
            set
            {
                this.idTypeField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlIgnoreAttribute()]
        public bool idTypeSpecified
        {
            get
            {
                return this.idTypeFieldSpecified;
            }
            set
            {
                this.idTypeFieldSpecified = value;
            }
        }

        /// <remarks/>
        public StateEnum idIssuingState
        {
            get
            {
                return this.idIssuingStateField;
            }
            set
            {
                this.idIssuingStateField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlIgnoreAttribute()]
        public bool idIssuingStateSpecified
        {
            get
            {
                return this.idIssuingStateFieldSpecified;
            }
            set
            {
                this.idIssuingStateFieldSpecified = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "date")]
        public System.DateTime idExpirationDate
        {
            get
            {
                return this.idExpirationDateField;
            }
            set
            {
                this.idExpirationDateField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlIgnoreAttribute()]
        public bool idExpirationDateSpecified
        {
            get
            {
                return this.idExpirationDateFieldSpecified;
            }
            set
            {
                this.idExpirationDateFieldSpecified = value;
            }
        }
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum ContractLengthEnum
    {

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("0")]
        Item0,

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("12")]
        Item12,

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("24")]
        Item24,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum CreditApplicationStatusEnum
    {

        /// <remarks/>
        COMPLETE,

        /// <remarks/>
        FAILURE,

        /// <remarks/>
        PENDING,

        /// <remarks/>
        REVIEW,

        /// <remarks/>
        REJECTED,

        /// <remarks/>
        NO_ACK,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum AccountStatusCodeEnum
    {

        /// <remarks/>
        CLOSED,

        /// <remarks/>
        CANCELLED,

        /// <remarks/>
        OPERATIONAL,

        /// <remarks/>
        TENTATIVE,

        /// <remarks/>
        SUSPENDED,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public partial class CustomerQualificationResult
    {

        private AccountEligibilityEnum accountEligibilityField;

        private bool accountEligibilityFieldSpecified;

        private string banField;

        private AccountStatusCodeEnum accountStatusCodeField;

        private bool accountStatusCodeFieldSpecified;

        private string numberOfLinesApprovedField;

        private LineDeposit lineDepositsField;

        private bool easyPayRequiredField;

        private bool easyPayRequiredFieldSpecified;

        private BillingAccountTypeEnum billingAccountTypeField;

        private bool billingAccountTypeFieldSpecified;

        private decimal activationFeeField;

        private decimal controlSurChargeField;

        private bool controlSurChargeFieldSpecified;

        private decimal applicationFeeField;

        private bool applicationFeeFieldSpecified;

        private bool payUpFrontField;

        private bool payUpFrontFieldSpecified;

        private string creditApplicationRefNumberField;

        private bool contractRequiredField;

        private bool contractRequiredFieldSpecified;

        private ProductType productTypeField;

        private bool productTypeFieldSpecified;

        /// <remarks/>
        public AccountEligibilityEnum accountEligibility
        {
            get
            {
                return this.accountEligibilityField;
            }
            set
            {
                this.accountEligibilityField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlIgnoreAttribute()]
        public bool accountEligibilitySpecified
        {
            get
            {
                return this.accountEligibilityFieldSpecified;
            }
            set
            {
                this.accountEligibilityFieldSpecified = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "token")]
        public string ban
        {
            get
            {
                return this.banField;
            }
            set
            {
                this.banField = value;
            }
        }

        /// <remarks/>
        public AccountStatusCodeEnum accountStatusCode
        {
            get
            {
                return this.accountStatusCodeField;
            }
            set
            {
                this.accountStatusCodeField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlIgnoreAttribute()]
        public bool accountStatusCodeSpecified
        {
            get
            {
                return this.accountStatusCodeFieldSpecified;
            }
            set
            {
                this.accountStatusCodeFieldSpecified = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "nonNegativeInteger")]
        public string numberOfLinesApproved
        {
            get
            {
                return this.numberOfLinesApprovedField;
            }
            set
            {
                this.numberOfLinesApprovedField = value;
            }
        }

        /// <remarks/>
        public LineDeposit lineDeposits
        {
            get
            {
                return this.lineDepositsField;
            }
            set
            {
                this.lineDepositsField = value;
            }
        }

        /// <remarks/>
        public bool easyPayRequired
        {
            get
            {
                return this.easyPayRequiredField;
            }
            set
            {
                this.easyPayRequiredField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlIgnoreAttribute()]
        public bool easyPayRequiredSpecified
        {
            get
            {
                return this.easyPayRequiredFieldSpecified;
            }
            set
            {
                this.easyPayRequiredFieldSpecified = value;
            }
        }

        /// <remarks/>
        public BillingAccountTypeEnum billingAccountType
        {
            get
            {
                return this.billingAccountTypeField;
            }
            set
            {
                this.billingAccountTypeField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlIgnoreAttribute()]
        public bool billingAccountTypeSpecified
        {
            get
            {
                return this.billingAccountTypeFieldSpecified;
            }
            set
            {
                this.billingAccountTypeFieldSpecified = value;
            }
        }

        /// <remarks/>
        public decimal activationFee
        {
            get
            {
                return this.activationFeeField;
            }
            set
            {
                this.activationFeeField = value;
            }
        }

        /// <remarks/>
        public decimal controlSurCharge
        {
            get
            {
                return this.controlSurChargeField;
            }
            set
            {
                this.controlSurChargeField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlIgnoreAttribute()]
        public bool controlSurChargeSpecified
        {
            get
            {
                return this.controlSurChargeFieldSpecified;
            }
            set
            {
                this.controlSurChargeFieldSpecified = value;
            }
        }

        /// <remarks/>
        public decimal applicationFee
        {
            get
            {
                return this.applicationFeeField;
            }
            set
            {
                this.applicationFeeField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlIgnoreAttribute()]
        public bool applicationFeeSpecified
        {
            get
            {
                return this.applicationFeeFieldSpecified;
            }
            set
            {
                this.applicationFeeFieldSpecified = value;
            }
        }

        /// <remarks/>
        public bool payUpFront
        {
            get
            {
                return this.payUpFrontField;
            }
            set
            {
                this.payUpFrontField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlIgnoreAttribute()]
        public bool payUpFrontSpecified
        {
            get
            {
                return this.payUpFrontFieldSpecified;
            }
            set
            {
                this.payUpFrontFieldSpecified = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "token")]
        public string creditApplicationRefNumber
        {
            get
            {
                return this.creditApplicationRefNumberField;
            }
            set
            {
                this.creditApplicationRefNumberField = value;
            }
        }

        /// <remarks/>
        public bool contractRequired
        {
            get
            {
                return this.contractRequiredField;
            }
            set
            {
                this.contractRequiredField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlIgnoreAttribute()]
        public bool contractRequiredSpecified
        {
            get
            {
                return this.contractRequiredFieldSpecified;
            }
            set
            {
                this.contractRequiredFieldSpecified = value;
            }
        }

        /// <remarks/>
        public ProductType productType
        {
            get
            {
                return this.productTypeField;
            }
            set
            {
                this.productTypeField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlIgnoreAttribute()]
        public bool productTypeSpecified
        {
            get
            {
                return this.productTypeFieldSpecified;
            }
            set
            {
                this.productTypeFieldSpecified = value;
            }
        }
    }
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum ProductType
    {

        /// <remarks/>
        GSM,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public partial class LineDeposit
    {

        private string numberOfLinesWithoutDepositField;

        private string numberOfLinesWithDepositField;

        private decimal depositAmountField;

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "nonNegativeInteger")]
        public string numberOfLinesWithoutDeposit
        {
            get
            {
                return this.numberOfLinesWithoutDepositField;
            }
            set
            {
                this.numberOfLinesWithoutDepositField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType = "nonNegativeInteger")]
        public string numberOfLinesWithDeposit
        {
            get
            {
                return this.numberOfLinesWithDepositField;
            }
            set
            {
                this.numberOfLinesWithDepositField = value;
            }
        }

        /// <remarks/>
        public decimal depositAmount
        {
            get
            {
                return this.depositAmountField;
            }
            set
            {
                this.depositAmountField = value;
            }
        }
    }



    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum BillingAccountTypeEnum
    {

        /// <remarks/>
        POSTPAID,

        /// <remarks/>
        SMART_ACCESS,

        /// <remarks/>
        FLEXPAY_ANNUAL_CONTRACT,

        /// <remarks/>
        FLEXPAY_MONTHLY_CONTRACT,
    }
    

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum AccountEligibilityEnum
    {

        /// <remarks/>
        NEW,

        /// <remarks/>
        EXISTING,
    }


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum EligibilityLevel
    {

        /// <remarks/>
        NO,

        /// <remarks/>
        PARTIAL,

        /// <remarks/>
        YES,

        /// <remarks/>
        CUSTOMER_NOT_VESTED,

        /// <remarks/>
        NEVER,
    }


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum LanguageEnum
    {

        /// <remarks/>
        ENGLISH,

        /// <remarks/>
        SPANISH,
    }
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "2.0.50727.3038")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum AccountTypeEnum
    {

        /// <remarks/>
        INDIVIDUAL,

        /// <remarks/>
        BUSINESS,

        /// <remarks/>
        SPECIAL,

        /// <remarks/>
        GOVERNMENT,

        /// <remarks/>
        EXCEPTIONCONTROL,

        /// <remarks/>
        WHOLESALE,

        /// <remarks/>
        RESELLER,
    }


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum HandsetOrderTypeEnum
    {

        /// <remarks/>
        INVALID,

        /// <remarks/>
        REPAIR_ORDER,

        /// <remarks/>
        ADVANCED_EXCHANGE,

        /// <remarks/>
        ADVANCED_EXCHANGE_RETURN,

        /// <remarks/>
        ADVANCED_EXCHANGE_ROUTER,

        /// <remarks/>
        POST_EXCHANGE_ROUTER,

        /// <remarks/>
        ADVANCED_EXCHANGE_ROUTER_RETURN,

        /// <remarks/>
        POST_EXCHANGE_ROUTER_RETURN,

        /// <remarks/>
        POST_EXCHANGE,

        /// <remarks/>
        POST_EXCHANGE_RETURN,

        /// <remarks/>
        LOST_OR_STOLEN,

        /// <remarks/>
        CONTRACT_RENEWAL,

        /// <remarks/>
        CIHU_CUSTOMER_CARE,

        /// <remarks/>
        FAMILY_TIME_PROGRAM,

        /// <remarks/>
        PROACTIVE_UPGRADE,

        /// <remarks/>
        SAVE_UPGRADE,

        /// <remarks/>
        DATA_DEVICES_ADVANCE_EXCHANGE,

        /// <remarks/>
        DATA_DEVICES_ADVANCE_EXCHANGE_RETURN,

        /// <remarks/>
        CIHU_CAM_INSTORE_FULLFILLMENT,

        /// <remarks/>
        MULTIPLE_EXCHANGE,

        /// <remarks/>
        MULTIPLE_EXCHANGE_RETURN,

        /// <remarks/>
        CIHU_MY_TMOBILE,

        /// <remarks/>
        ICAM_INSTORE_FULFILLMENT,

        /// <remarks/>
        INORGANIC_CARE_INSTORE_FULFILLMENT,

        /// <remarks/>
        QUERY,

        /// <remarks/>
        REPORTING,

        /// <remarks/>
        MAINTENANCE,

        /// <remarks/>
        APPLICATION_SUPPORT,

        /// <remarks/>
        DEVICE_MODEL_WARRANTY_QUERY,

        /// <remarks/>
        HANDSET_ORDER_DASHBOARD,

        /// <remarks/>
        VOUCHER_LOOKUP,

        /// <remarks/>
        DASHBOARD_MAINTENANCE,

        /// <remarks/>
        DMW_ADMIN_TOOL,

        /// <remarks/>
        UPGRADE_RETURN_RESET_TOOL,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum HandsetOrderClassificationEnum
    {

        /// <remarks/>
        UPGRADE,

        /// <remarks/>
        EXCHANGE,
    }


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum SaveOrderContractLengthEnum
    {

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("12")]
        Item12,

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("24")]
        Item24,
    }


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum MsisdnStatusCodeEnum
    {

        /// <remarks/>
        ACTIVE,

        /// <remarks/>
        CANCELED,

        /// <remarks/>
        RESERVED,

        /// <remarks/>
        SUSPENDED,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum ClassificationTypeEnum
    {

        /// <remarks/>
        NEO,

        /// <remarks/>
        CLASSIC,

        /// <remarks/>
        LEGACY,

        /// <remarks/>
        ALL,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum BanStatusCodeEnum
    {

        /// <remarks/>
        CANCELED,

        /// <remarks/>
        CLOSED,

        /// <remarks/>
        OPENED,

        /// <remarks/>
        SUSPENDED,

        /// <remarks/>
        TENTATIVE,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://retail.tmobile.com/sdo")]
    public enum GetUsageSummaryRequestUsageType
    {

        /// <remarks/>
        FLEXPAY,

        /// <remarks/>
        POSTPAID,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo", IncludeInSchema = false)]
    public enum ItemChoiceType
    {

        /// <remarks/>
        billPeriod,

        /// <remarks/>
        billSequenceNumber,

        /// <remarks/>
        usageCycle,
    }


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum AddressClassificationEnum
    {

        /// <remarks/>
        STREET_ADDRESS,

        /// <remarks/>
        POBOX_ADDRESS,

        /// <remarks/>
        RURALROUTE_ADDRESS,

        /// <remarks/>
        MILITARY_ADDRESS,

        /// <remarks/>
        FOREIGN_ADDRESS,

        /// <remarks/>
        HWY_ADDRESS,

        /// <remarks/>
        UNKNOWN_ADDRESS,

        /// <remarks/>
        NEW,

        /// <remarks/>
        UNASSIGNED,
    }


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum AccountModeEnum
    {

        /// <remarks/>
        PREPAID,

        /// <remarks/>
        POSTPAID,

        /// <remarks/>
        WHOLESALE,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo", IncludeInSchema = false)]
    public enum ItemsChoiceType1
    {

        /// <remarks/>
        lastUpdate,

        /// <remarks/>
        postpaidAccount,

        /// <remarks/>
        prepaidAccount,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum BillFormatOptionsEnum
    {

        /// <remarks/>
        CDS,

        /// <remarks/>
        CD0,

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("CD$")]
        CD,

        /// <remarks/>
        PLB,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum CardTypeEnum
    {

        /// <remarks/>
        Master,

        /// <remarks/>
        Visa,

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("American Express")]
        AmericanExpress,

        /// <remarks/>
        Discovery,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum PaymentTypeEnum
    {

        /// <remarks/>
        creditcard,

        /// <remarks/>
        debitcard,

        /// <remarks/>
        checkingacct,

        /// <remarks/>
        savingsacct,
    }


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://retail.tmobile.com/sdo")]
    public enum ServiceLevel
    {

        /// <remarks/>
        ACCOUNT,

        /// <remarks/>
        SUBSCRIBER,

        /// <remarks/>
        PRODUCT,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum ServiceIdentificationEnum
    {

        /// <remarks/>
        ADD_A_LINE,

        /// <remarks/>
        FAMILY_ALLOWANCE,

        /// <remarks/>
        CALL_DETAILS_SUPPRESSION,

        /// <remarks/>
        PREMIUM_HANDSET_PROTECTION,

        /// <remarks/>
        VISUAL_VOICE_MAIL,

        /// <remarks/>
        OPEN_MOBILE_WEB,

        /// <remarks/>
        OPEN_MOBILE_WEB_CONTRACTED,

        /// <remarks/>
        DEVICE_CONTRACTED,

        /// <remarks/>
        WEB_BUNDLE,

        /// <remarks/>
        FLEXPAY_MONTHLY_CONTRACT,

        /// <remarks/>
        KID_CONNECT,

        /// <remarks/>
        HUDDLE_UP,

        /// <remarks/>
        TAKE_CONTROL_LEGACY,

        /// <remarks/>
        FLEXPAY_ANNUAL_CONTRACT,

        /// <remarks/>
        AT_HOME_RJ11,

        /// <remarks/>
        AT_HOME_MOBILE,

        /// <remarks/>
        DATA_STICK_PLAN,

        /// <remarks/>
        TFRAME,

        /// <remarks/>
        ENHANCED_MESSAGING,

        /// <remarks/>
        SPECIAL_OFFER_PLAN,

        /// <remarks/>
        UNLIMITED_VOICE,

        /// <remarks/>
        PR_WARRANTY_SOC,

        /// <remarks/>
        MESSAGE_BUNDLE_MMS,

        /// <remarks/>
        MESSAGE_BUNDLE_SMS,

        /// <remarks/>
        PAY_PER_MEGABYTE,

        /// <remarks/>
        DATA_BONUS_SOC,

        /// <remarks/>
        OMW_ADDED_SOC,

        /// <remarks/>
        FLEXPAY_NEO_NO_EZPAY_CHARGE,

        /// <remarks/>
        TETHERING,

        /// <remarks/>
        CALLER_NAME,

        /// <remarks/>
        NONE,

        /// <remarks/>
        PREMIUM_VOICEMAIL,

        /// <remarks/>
        MOBILE_SECURITY,

        /// <remarks/>
        FREE_WIFI_CALLING,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum FreeIndicatorEnum
    {

        /// <remarks/>
        FREE,

        /// <remarks/>
        PAID,

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("NOT APPLICABLE")]
        NOTAPPLICABLE,
    }


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum SubsidyEnum
    {

        /// <remarks/>
        DISCOUNTED,

        /// <remarks/>
        FULL_PRICE,

        /// <remarks/>
        NOT_APPLICABLE,
    }


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum SubsidyTypeEnum
    {

        /// <remarks/>
        REDUCED,

        /// <remarks/>
        FULL,

        /// <remarks/>
        EIP,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum CustomerDocumentTypeEnum
    {

        /// <remarks/>
        SA,

        /// <remarks/>
        STSG,

        /// <remarks/>
        RECEIPT,

        /// <remarks/>
        EPTC,
    }


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum ServiceProviderEnum
    {

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("AT$T")]
        ATT,

        /// <remarks/>
        Sprint,

        /// <remarks/>
        GTE,

        /// <remarks/>
        AIRTOUCH,

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("US West")]
        USWest,

        /// <remarks/>
        Nextel,

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("T-Mobile")]
        TMobile,

        /// <remarks/>
        Other,
    }



    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum ServiceAgreementActivityCodeEnum
    {

        /// <remarks/>
        NEW_ACTIVATION,

        /// <remarks/>
        ADD_A_LINE,

        /// <remarks/>
        RATE_PLAN_CHANGE,

        /// <remarks/>
        HANDSET_UPGRADE,
    }


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum AddressTypeEnum
    {

        /// <remarks/>
        E911,

        /// <remarks/>
        BILLING,

        /// <remarks/>
        PPU,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum ChargeEnum
    {

        /// <remarks/>
        onUsage,

        /// <remarks/>
        everyPeriod,

        /// <remarks/>
        onDemand,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum PortTypeEnum
    {

        /// <remarks/>
        REGULAR,

        /// <remarks/>
        PORT_OUT,

        /// <remarks/>
        PORT_IN,

        /// <remarks/>
        IN_OUT,

        /// <remarks/>
        SNAP_BACK,

        /// <remarks/>
        DISCONNECT,

        /// <remarks/>
        WINBACK,

        /// <remarks/>
        OTHER,
    }


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum CustomerStatusEnum
    {

        /// <remarks/>
        NEW,

        /// <remarks/>
        EXISTING,
    }


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum DataUnitEnum
    {

        /// <remarks/>
        KB,

        /// <remarks/>
        MB,

        /// <remarks/>
        GB,

        /// <remarks/>
        NA,
    }


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum DepositTypeEnum
    {

        /// <remarks/>
        FULL,

        /// <remarks/>
        REDUCED,

        /// <remarks/>
        EIP,
    }


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum PlanTypeEnum
    {

        /// <remarks/>
        POOLING,

        /// <remarks/>
        NON_POOLING,

        /// <remarks/>
        DATA_ONLY,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum PlanSubTypeEnum
    {

        /// <remarks/>
        REGULAR,

        /// <remarks/>
        MYFAVES,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum MinContractTermInMonths
    {

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("0")]
        Item0,

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("12")]
        Item12,

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("24")]
        Item24,

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("36")]
        Item36,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum RateplanIdentificationEnum
    {

        /// <remarks/>
        TRUTH_IN_WIRELESS,

        /// <remarks/>
        NEO_POST_PAID,

        /// <remarks/>
        NEO_FLEX_PAY,

        /// <remarks/>
        CLASSIC_POST_PAID,

        /// <remarks/>
        CLASSIC_FLEX_PAY,

        /// <remarks/>
        FLEXPAY_MONTHLY_CONTRACT,

        /// <remarks/>
        KID_CONNECT,

        /// <remarks/>
        HUDDLE_UP,

        /// <remarks/>
        TAKE_CONTROL_LEGACY,

        /// <remarks/>
        FLEXPAY_ANNUAL_CONTRACT,

        /// <remarks/>
        AT_HOME_RJ11,

        /// <remarks/>
        AT_HOME_MOBILE,

        /// <remarks/>
        DATA_STICK_PLAN,

        /// <remarks/>
        TFRAME,

        /// <remarks/>
        ENHANCED_MESSAGING,

        /// <remarks/>
        SPECIAL_OFFER_PLAN,

        /// <remarks/>
        UNLIMITED_VOICE,

        /// <remarks/>
        NONE,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum PlanClassificationEnum
    {

        /// <remarks/>
        TALK,

        /// <remarks/>
        TALK_TEXT,

        /// <remarks/>
        TALK_TEXT_WEB,

        /// <remarks/>
        RJE,

        /// <remarks/>
        DSP,

        /// <remarks/>
        TFM,
    }


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum SubscriberStatusCodeEnum
    {

        /// <remarks/>
        ACTIVE,

        /// <remarks/>
        CANCELLED,

        /// <remarks/>
        RESTRICTED,

        /// <remarks/>
        SUSPENDED,
    }


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum ScheduledReasonEnum
    {

        /// <remarks/>
        requiredBySystem,

        /// <remarks/>
        requestedBySubscriber,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://retail.tmobile.com/sdo")]
    public enum PrePaidAccountSearchInfoScheduledTransactionsStatus
    {

        /// <remarks/>
        New,

        /// <remarks/>
        Succeeded,

        /// <remarks/>
        Failed,

        /// <remarks/>
        Pending,

        /// <remarks/>
        Retry,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum UnitEnum
    {

        /// <remarks/>
        day,

        /// <remarks/>
        week,

        /// <remarks/>
        month,

        /// <remarks/>
        hour,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum CatalogFileTypeEnum
    {

        /// <remarks/>
        XML,

        /// <remarks/>
        TXT,
    }


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum PortInStatusCodeEnum
    {

        /// <remarks/>
        OPEN,

        /// <remarks/>
        ERROR,

        /// <remarks/>
        COMPLETE,

        /// <remarks/>
        CANCELLED,

        /// <remarks/>
        SAVE,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum ActionDateTypeEnum
    {

        /// <remarks/>
        IMMEDIATE,

        /// <remarks/>
        NEXT_RENEWAL,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum StatusEnum
    {

        /// <remarks/>
        New,

        /// <remarks/>
        Succeeded,

        /// <remarks/>
        Failed,

        /// <remarks/>
        Pending,

        /// <remarks/>
        Retry,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum ServiceTypeEnum
    {

        /// <remarks/>
        P,

        /// <remarks/>
        I,

        /// <remarks/>
        O,
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://retail.tmobile.com/sdo")]
    public enum RateplanConversionValidationResponseServiceConflictsTypeOfConflict
    {

        /// <remarks/>
        USER,

        /// <remarks/>
        SYSTEM,
    }


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum ActionTypeEnum
    {

        /// <remarks/>
        ADD,

        /// <remarks/>
        CHANGE,
    }


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum LineRankEnum
    {

        /// <remarks/>
        PRIMARY,

        /// <remarks/>
        ADD_A_LINE,

        /// <remarks/>
        NOT_APPLICABLE,
    }


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.0.30319.1")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://retail.tmobile.com/sdo")]
    public enum BillPeriodEnum
    {

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("0")]
        Item0,

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("1")]
        Item1,

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("2")]
        Item2,
    }
}