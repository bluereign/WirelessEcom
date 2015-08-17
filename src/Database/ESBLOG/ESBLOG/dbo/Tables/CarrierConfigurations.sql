CREATE TABLE [dbo].[CarrierConfigurations] (
    [ConfigurationID] BIGINT         IDENTITY (1, 1) NOT NULL,
    [Active]          BIT            CONSTRAINT [DF_CarrierConfigurations_Active] DEFAULT ((0)) NOT NULL,
    [Channel]         VARCHAR (50)   NOT NULL,
    [ServiceName]     VARCHAR (50)   NOT NULL,
    [Username]        VARCHAR (50)   NULL,
    [Password]        VARCHAR (50)   NULL,
    [SalesChannel]    VARCHAR (20)   NULL,
    [DealerCode]      VARCHAR (50)   NULL,
    [apiVersion]      VARCHAR (50)   NULL,
    [EndpointUrl]     VARCHAR (1024) NOT NULL,
    CONSTRAINT [PK_CarrierConfigurations] PRIMARY KEY CLUSTERED ([ConfigurationID] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_CarrierConfigurations]
    ON [dbo].[CarrierConfigurations]([ServiceName] ASC, [Channel] ASC);

