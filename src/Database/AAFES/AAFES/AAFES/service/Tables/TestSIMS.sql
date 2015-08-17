CREATE TABLE [service].[TestSIMS] (
    [SIM]       VARCHAR (50)  NULL,
    [IMEI]      VARCHAR (50)  NULL,
    [Used]      BIT           CONSTRAINT [DF_TestSIMS_Used] DEFAULT ((0)) NULL,
    [CarrierID] INT           NULL,
    [SKUs]      VARCHAR (255) NULL
);

