CREATE TABLE [salesorder].[WirelessLine] (
    [WirelessLineId]                    INT           IDENTITY (1, 1) NOT NULL,
    [OrderDetailId]                     INT           NOT NULL,
    [PlanId]                            INT           NULL,
    [CarrierPlanId]                     NVARCHAR (10) NULL,
    [PlanType]                          NVARCHAR (10) NULL,
    [NewMDN]                            NCHAR (10)    NULL,
    [ESN]                               NVARCHAR (50) NULL,
    [IMEI]                              NVARCHAR (50) NULL,
    [CurrentMDN]                        NVARCHAR (10) NULL,
    [CurrentCarrier]                    INT           NULL,
    [IsMDNPort]                         BIT           NULL,
    [PortRequestId]                     NVARCHAR (10) NULL,
    [PortResponse]                      NVARCHAR (10) NULL,
    [PortStatus]                        NVARCHAR (10) NULL,
    [IsNPArequested]                    BIT           NULL,
    [UpgradeEligible]                   BIT           NULL,
    [RequestedActivationDate]           DATETIME      NULL,
    [CarrierReferenceId1]               NVARCHAR (50) NULL,
    [CarrierReferenceId2]               NVARCHAR (50) NULL,
    [CarrierReferenceId3]               NVARCHAR (50) NULL,
    [PortInDueDate]                     DATETIME      NULL,
    [ContractLength]                    INT           NULL,
    [MonthlyFee]                        MONEY         NULL,
    [MarketCode]                        NVARCHAR (30) NULL,
    [NPARequested]                      VARCHAR (3)   NULL,
    [SIM]                               NVARCHAR (50) NULL,
    [ActivationStatus]                  INT           NULL,
    [ActivationFee]                     MONEY         NULL,
    [PortInCurrentCarrier]              VARCHAR (25)  NULL,
    [PortInCurrentCarrierPin]           VARCHAR (10)  NULL,
    [PortInCurrentCarrierAccountNumber] VARCHAR (30)  NULL,
    [PrepaidAccountNumber]              VARCHAR (30)  NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Unique ID for this WirelessLine record', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'WirelessLine', @level2type = N'COLUMN', @level2name = N'WirelessLineId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Matching OrderDetail Id for this WirelessLine record.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'WirelessLine', @level2type = N'COLUMN', @level2name = N'OrderDetailId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Reference to the ProductId for the Plan', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'WirelessLine', @level2type = N'COLUMN', @level2name = N'PlanId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Carrier billcode', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'WirelessLine', @level2type = N'COLUMN', @level2name = N'CarrierPlanId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'SIM used by TMobile. Required for activation. SIM is filled from the GIRS Stock table.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'WirelessLine', @level2type = N'COLUMN', @level2name = N'SIM';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0, Null = Ready, 1 = Requested, 2 = Success, 3 = Partial Success (never used), 4 = Failure, 5 = Error, 6 = Manual ,7 = Canceled', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'WirelessLine', @level2type = N'COLUMN', @level2name = N'ActivationStatus';

