CREATE TABLE [salesorder].[LineService] (
    [LineServiceId]    INT        IDENTITY (1, 1) NOT NULL,
    [OrderDetailId]    INT        NOT NULL,
    [ServiceType]      NCHAR (10) NULL,
    [ServiceId]        INT        NULL,
    [CarrierServiceId] NCHAR (10) NULL,
    [MonthlyFee]       MONEY      NULL,
    [Mandatory]        NCHAR (10) NULL,
    CONSTRAINT [PK_LineService] PRIMARY KEY CLUSTERED ([LineServiceId] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_LineService_OrderDetail] FOREIGN KEY ([OrderDetailId]) REFERENCES [salesorder].[OrderDetail] ([OrderDetailId])
);


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'UNKNOWN DBA.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'LineService', @level2type = N'COLUMN', @level2name = N'Mandatory';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'When true, the service is a required service vs. optional.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'LineService', @level2type = N'COLUMN', @level2name = N'Mandatory';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'UNKNOWN DBA.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'LineService', @level2type = N'COLUMN', @level2name = N'MonthlyFee';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Monthly charge for this service, provided by the carrier catalog.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'LineService', @level2type = N'COLUMN', @level2name = N'MonthlyFee';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'UNKNOWN DBA.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'LineService', @level2type = N'COLUMN', @level2name = N'CarrierServiceId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Billcode provided by the Carrier.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'LineService', @level2type = N'COLUMN', @level2name = N'CarrierServiceId';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'UNKNOWN DBA.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'LineService', @level2type = N'COLUMN', @level2name = N'ServiceId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This is the Product.ProductId for this service.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'LineService', @level2type = N'COLUMN', @level2name = N'ServiceId';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'UNKNOWN DBA.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'LineService', @level2type = N'COLUMN', @level2name = N'ServiceType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'TODO: What is this for?', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'LineService', @level2type = N'COLUMN', @level2name = N'ServiceType';


GO
EXECUTE sp_addextendedproperty @name = N'Bug', @value = N'TODO: What is this for?', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'LineService', @level2type = N'COLUMN', @level2name = N'ServiceType';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'UNKNOWN DBA.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'LineService', @level2type = N'COLUMN', @level2name = N'OrderDetailId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Link to OrderDetail table', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'LineService', @level2type = N'COLUMN', @level2name = N'OrderDetailId';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'UNKNOWN DBA.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'LineService', @level2type = N'COLUMN', @level2name = N'LineServiceId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'LineService', @level2type = N'COLUMN', @level2name = N'LineServiceId';

