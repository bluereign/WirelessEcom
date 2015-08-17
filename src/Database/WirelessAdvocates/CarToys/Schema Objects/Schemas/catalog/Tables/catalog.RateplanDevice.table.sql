CREATE TABLE [catalog].[RateplanDevice] (
    [RateplanGuid]      UNIQUEIDENTIFIER NOT NULL,
    [DeviceGuid]        UNIQUEIDENTIFIER NOT NULL,
    [IsDefaultRateplan] BIT              DEFAULT ((0)) NOT NULL
);

