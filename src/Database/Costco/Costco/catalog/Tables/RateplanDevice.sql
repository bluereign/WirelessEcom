CREATE TABLE [catalog].[RateplanDevice] (
    [RateplanGuid]      UNIQUEIDENTIFIER NOT NULL,
    [DeviceGuid]        UNIQUEIDENTIFIER NOT NULL,
    [IsDefaultRateplan] BIT              DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_RateplanDevice] PRIMARY KEY CLUSTERED ([RateplanGuid] ASC, [DeviceGuid] ASC),
    CONSTRAINT [FK_RateplanDevice_Device] FOREIGN KEY ([DeviceGuid]) REFERENCES [catalog].[Device] ([DeviceGuid]),
    CONSTRAINT [FK_RateplanDevice_Rateplan] FOREIGN KEY ([RateplanGuid]) REFERENCES [catalog].[Rateplan] ([RateplanGuid])
);


GO
ALTER TABLE [catalog].[RateplanDevice] NOCHECK CONSTRAINT [FK_RateplanDevice_Device];

