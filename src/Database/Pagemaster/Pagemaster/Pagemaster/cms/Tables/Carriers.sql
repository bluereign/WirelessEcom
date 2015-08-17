CREATE TABLE [cms].[Carriers] (
    [CarrierID]  BIGINT       IDENTITY (1, 1) NOT NULL,
    [Name]       VARCHAR (50) NOT NULL,
    [CarrierKey] VARCHAR (20) NOT NULL,
    CONSTRAINT [PK_Carriers] PRIMARY KEY CLUSTERED ([CarrierID] ASC)
);

