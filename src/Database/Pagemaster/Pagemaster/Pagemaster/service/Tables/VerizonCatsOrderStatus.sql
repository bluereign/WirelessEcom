﻿CREATE TABLE [service].[VerizonCatsOrderStatus] (
    [ReportDate]          DATETIME      NULL,
    [AgentID]             VARCHAR (25)  NULL,
    [OrderID]             VARCHAR (25)  NULL,
    [CorpName]            VARCHAR (50)  NULL,
    [OrderDate]           DATETIME      NULL,
    [StatusDate]          DATETIME      NULL,
    [Status]              VARCHAR (25)  NULL,
    [CATS]                VARCHAR (25)  NULL,
    [DepositAmt]          DECIMAL (18)  NULL,
    [ReferenceNum]        VARCHAR (25)  NULL,
    [SubReferenceNum]     VARCHAR (25)  NULL,
    [LineID]              INT           NULL,
    [Center]              VARCHAR (25)  NULL,
    [Area]                VARCHAR (25)  NULL,
    [AceLocation]         VARCHAR (25)  NULL,
    [OutletID]            VARCHAR (25)  NULL,
    [DealerCD]            VARCHAR (25)  NULL,
    [MajorAccountCD]      VARCHAR (25)  NULL,
    [LastName]            VARCHAR (25)  NULL,
    [FirstName]           VARCHAR (25)  NULL,
    [CBR]                 VARCHAR (25)  NULL,
    [BTN]                 VARCHAR (25)  NULL,
    [CustomerCode]        VARCHAR (25)  NULL,
    [MobileNumber]        VARCHAR (25)  NULL,
    [PlanName]            VARCHAR (100) NULL,
    [ContractTerm]        VARCHAR (25)  NULL,
    [ModelID]             VARCHAR (25)  NULL,
    [ServiceType]         VARCHAR (25)  NULL,
    [ACEOrderNumber]      VARCHAR (25)  NULL,
    [OASSystemMessage]    VARCHAR (150) NULL,
    [MessageDetail]       VARCHAR (250) NULL,
    [PaymentType]         VARCHAR (25)  NULL,
    [CorpID]              VARCHAR (25)  NULL,
    [Path]                VARCHAR (25)  NULL,
    [MarketCD]            VARCHAR (50)  NULL,
    [LNPOSPAcctNo]        VARCHAR (25)  NULL,
    [LNPAuthorizedSigner] VARCHAR (25)  NULL,
    [RatePlanBrochureCD]  VARCHAR (25)  NULL,
    [CustomerAgreementCD] VARCHAR (25)  NULL,
    [ReasonCD]            VARCHAR (25)  NULL,
    [ServiceArea]         VARCHAR (25)  NULL,
    [CarrierCD]           VARCHAR (25)  NULL,
    [ACCOUNTNO]           VARCHAR (25)  NULL
);

