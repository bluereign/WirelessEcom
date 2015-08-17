CREATE TABLE [salesorder].[WirelessLine] (
    [WirelessLineId]                    INT           IDENTITY (1, 1) NOT NULL,
    [OrderDetailId]                     INT           NOT NULL,
    [PlanId]                            INT           NULL,
    [CarrierPlanId]                     NVARCHAR (15) NULL,
    [PlanType]                          NVARCHAR (10) NULL,
    [CarrierPlanType]                   NVARCHAR (15) NULL,
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
    [NPARequested]                      VARCHAR (6)   NULL,
    [SIM]                               NVARCHAR (50) NULL,
    [ActivationStatus]                  INT           CONSTRAINT [DF_WirelessLine_ActivationStatus] DEFAULT ((0)) NULL,
    [ActivationFee]                     MONEY         NULL,
    [PortInCurrentCarrier]              VARCHAR (25)  NULL,
    [PortInCurrentCarrierPin]           VARCHAR (10)  NULL,
    [PortInCurrentCarrierAccountNumber] VARCHAR (30)  NULL,
    [PrepaidAccountNumber]              VARCHAR (30)  NULL,
    [IsPrepaid]                         BIT           DEFAULT ((0)) NOT NULL,
    [CurrentIMEI]                       NVARCHAR (50) NULL,
    [CurrentSIM]                        NVARCHAR (50) NULL,
    CONSTRAINT [PK_WirelessLine] PRIMARY KEY CLUSTERED ([WirelessLineId] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_WirelessLine_OrderDetail] FOREIGN KEY ([OrderDetailId]) REFERENCES [salesorder].[OrderDetail] ([OrderDetailId])
);


GO
CREATE NONCLUSTERED INDEX [IX_OrderDetailId_WirelessLineId]
    ON [salesorder].[WirelessLine]([OrderDetailId] ASC, [WirelessLineId] ASC) WITH (FILLFACTOR = 80);


GO
CREATE TRIGGER [salesorder].NoRowDelete ON [salesorder].[wirelessline]
INSTEAD OF DELETE
AS
BEGIN
IF @@rowcount > 0
BEGIN
RAISERROR( 'Rows in WirelessLine cannot be deleted or you create extra work for the gnomes!', 16, 2 )
ROLLBACK
END
END
GO
EXECUTE sp_addextendedproperty @name = N'Release', @value = N'3.6.3', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'WirelessLine', @level2type = N'COLUMN', @level2name = N'IsPrepaid';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'eCommerce', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'WirelessLine', @level2type = N'COLUMN', @level2name = N'IsPrepaid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Determines if device is prepaid or not', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'WirelessLine', @level2type = N'COLUMN', @level2name = N'IsPrepaid';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'14-SEP-2012', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'WirelessLine', @level2type = N'COLUMN', @level2name = N'IsPrepaid';


GO
EXECUTE sp_addextendedproperty @name = N'Bug', @value = N'3966: http://tfserver:8080/tfs/web/wi.aspx?pguid=9af0ae7b-6890-4e1a-81aa-368b430d7527&id=3966', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'WirelessLine', @level2type = N'COLUMN', @level2name = N'IsPrepaid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0, Null = Ready, 1 = Requested, 2 = Success, 3 = Partial Success (never used), 4 = Failure, 5 = Error, 6 = Manual ,7 = Canceled', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'WirelessLine', @level2type = N'COLUMN', @level2name = N'ActivationStatus';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'SIM used by TMobile. Required for activation. SIM is filled from the GIRS Stock table.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'WirelessLine', @level2type = N'COLUMN', @level2name = N'SIM';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Carrier billcode', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'WirelessLine', @level2type = N'COLUMN', @level2name = N'CarrierPlanId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Reference to the ProductId for the Plan', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'WirelessLine', @level2type = N'COLUMN', @level2name = N'PlanId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Link to OrderDetail table', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'WirelessLine', @level2type = N'COLUMN', @level2name = N'OrderDetailId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'WirelessLine', @level2type = N'COLUMN', @level2name = N'WirelessLineId';

