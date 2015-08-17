CREATE TABLE [catalog].[RateplanException] (
    [RateplanExceptionGuid] UNIQUEIDENTIFIER NOT NULL,
    [CarrierGuid]           UNIQUEIDENTIFIER NULL,
    [LOBType]               CHAR (3)         NULL,
    [PlanType]              CHAR (3)         NULL,
    [RateplanGuid]          UNIQUEIDENTIFIER NULL,
    [DeviceGuid]            UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_RateplanException] PRIMARY KEY CLUSTERED ([RateplanExceptionGuid] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'RateplanException', @level2type = N'COLUMN', @level2name = N'RateplanExceptionGuid';

