﻿CREATE TABLE [salesorder].[WirelessAccount] (
    [WirelessAccountId]     INT             IDENTITY (1, 1) NOT NULL,
    [OrderId]               INT             NOT NULL,
    [FamilyPlan]            SMALLINT        NULL,
    [CarrierOrderDate]      DATETIME        NULL,
    [DOB]                   DATETIME        NULL,
    [DrvLicState]           VARCHAR (2)     NULL,
    [DrvLicExpiry]          DATETIME        NULL,
    [FirstName]             NVARCHAR (50)   NULL,
    [Initial]               NVARCHAR (50)   NULL,
    [LastName]              NVARCHAR (50)   NULL,
    [CarrierOrderId]        VARCHAR (30)    NULL,
    [CurrentAcctNumber]     VARCHAR (20)    NULL,
    [CurrentAcctPIN]        VARCHAR (10)    NULL,
    [CurrentTotalLines]     INT             NULL,
    [CurrentPlanType]       VARCHAR (10)    NULL,
    [CreditCode]            VARCHAR (10)    NULL,
    [MaxLinesAllowed]       INT             NULL,
    [DepositReq]            BIT             NULL,
    [DepositAccept]         BIT             NULL,
    [DepositTypeId]         INT             NULL,
    [DepositId]             VARCHAR (10)    NULL,
    [DepositAmount]         MONEY           NULL,
    [ActivationAmount]      MONEY           NULL,
    [PrePayId]              VARCHAR (10)    NULL,
    [PrePayAmount]          MONEY           NULL,
    [NewAccountNo]          VARCHAR (10)    NULL,
    [NewAccountType]        VARCHAR (50)    NULL,
    [BillCycleDate]         DATETIME        NULL,
    [CarrierStatus]         VARCHAR (20)    NULL,
    [CarrierStatusDate]     DATETIME        NULL,
    [CarrierId]             INT             NULL,
    [ActivationStatus]      INT             NULL,
    [CarrierTermsTimeStamp] DATETIME        NULL,
    [EncryptedSSN]          VARBINARY (128) NULL,
    [EncryptedDrvLicNumber] VARBINARY (128) NULL,
    [ActivationDate]        DATETIME        NULL,
    [AccountPassword]       VARCHAR (15)    NULL,
    [AccountZipCode]        VARCHAR (10)    NULL,
    [ActivatedById]         INT             NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0, Null = Ready, 1 = Requested, 2 = Success, 3 = Partial Success, 4 = Failure, 5 = Error, 6 = Manual, 7 = Canceled', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'WirelessAccount', @level2type = N'COLUMN', @level2name = N'ActivationStatus';

