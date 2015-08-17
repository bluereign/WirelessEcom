CREATE TABLE [salesorder].[LineService] (
    [LineServiceId]    INT        IDENTITY (1, 1) NOT NULL,
    [OrderDetailId]    INT        NOT NULL,
    [ServiceType]      NCHAR (10) NULL,
    [ServiceId]        INT        NULL,
    [CarrierServiceId] NCHAR (10) NULL,
    [MonthlyFee]       MONEY      NULL,
    [Mandatory]        NCHAR (10) NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Unique Id for this record.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'LineService', @level2type = N'COLUMN', @level2name = N'LineServiceId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Related OrderDetail record. OrderDetail records with OrderDetail.Type of ''S'' should have a coresponding LineService record.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'LineService', @level2type = N'COLUMN', @level2name = N'OrderDetailId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'TODO: What is this for?', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'LineService', @level2type = N'COLUMN', @level2name = N'ServiceType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This is the Product.ProductId for this service.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'LineService', @level2type = N'COLUMN', @level2name = N'ServiceId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Billcode provided by the Carrier.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'LineService', @level2type = N'COLUMN', @level2name = N'CarrierServiceId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Monthly charge for this service, provided by the carrier catalog.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'LineService', @level2type = N'COLUMN', @level2name = N'MonthlyFee';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'When true, the service is a required service vs. optional.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'LineService', @level2type = N'COLUMN', @level2name = N'Mandatory';

