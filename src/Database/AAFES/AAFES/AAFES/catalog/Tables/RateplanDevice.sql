CREATE TABLE [catalog].[RateplanDevice] (
    [RateplanGuid]      UNIQUEIDENTIFIER NOT NULL,
    [DeviceGuid]        UNIQUEIDENTIFIER NOT NULL,
    [IsDefaultRateplan] BIT              DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_RateplanDevice] PRIMARY KEY CLUSTERED ([RateplanGuid] ASC, [DeviceGuid] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_RateplanDevice_Device] FOREIGN KEY ([DeviceGuid]) REFERENCES [catalog].[Device] ([DeviceGuid]),
    CONSTRAINT [FK_RateplanDevice_Rateplan] FOREIGN KEY ([RateplanGuid]) REFERENCES [catalog].[Rateplan] ([RateplanGuid])
);


GO
ALTER TABLE [catalog].[RateplanDevice] NOCHECK CONSTRAINT [FK_RateplanDevice_Device];


GO
CREATE NONCLUSTERED INDEX [ix_RateplanDevice_DeviceGuid]
    ON [catalog].[RateplanDevice]([DeviceGuid] ASC)
    INCLUDE([RateplanGuid]);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Link to Device table', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'RateplanDevice', @level2type = N'COLUMN', @level2name = N'DeviceGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Link to Rateplan table', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'RateplanDevice', @level2type = N'COLUMN', @level2name = N'RateplanGuid';

