CREATE TABLE [service].[CarrierInterfaceLog] (
    [Id]              BIGINT         IDENTITY (1, 1) NOT NULL,
    [LoggedDateTime]  DATETIME       NULL,
    [ReferenceNumber] VARCHAR (50)   NULL,
    [Carrier]         VARCHAR (50)   NULL,
    [Type]            VARCHAR (50)   NULL,
    [RequestType]     VARCHAR (50)   NULL,
    [Data]            NVARCHAR (MAX) NOT NULL,
    [Compiled]        BIT            CONSTRAINT [DF__CarrierIn__Compi__17D42DE4] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_service.CarrierInterfaceLog] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'service', @level1type = N'TABLE', @level1name = N'CarrierInterfaceLog', @level2type = N'COLUMN', @level2name = N'Id';

