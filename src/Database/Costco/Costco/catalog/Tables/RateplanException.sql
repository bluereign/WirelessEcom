CREATE TABLE [catalog].[RateplanException] (
    [RateplanExceptionGuid] UNIQUEIDENTIFIER NOT NULL,
    [CarrierGuid]           UNIQUEIDENTIFIER NULL,
    [LOBType]               CHAR (3)         NULL,
    [PlanType]              CHAR (3)         NULL,
    [RateplanGuid]          UNIQUEIDENTIFIER NULL,
    [DeviceGuid]            UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_RateplanException] PRIMARY KEY CLUSTERED ([RateplanExceptionGuid] ASC)
);

