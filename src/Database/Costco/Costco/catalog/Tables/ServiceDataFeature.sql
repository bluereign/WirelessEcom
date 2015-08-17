CREATE TABLE [catalog].[ServiceDataFeature] (
    [ServiceDataFeatureId] INT              IDENTITY (1, 1) NOT NULL,
    [ServiceGuid]          UNIQUEIDENTIFIER NOT NULL,
    [ServiceDataGroupGuid] UNIQUEIDENTIFIER NOT NULL,
    [DeviceType]           VARCHAR (50)     NULL,
    CONSTRAINT [PK__ServiceD__DF4C9D5702192B98] PRIMARY KEY CLUSTERED ([ServiceDataFeatureId] ASC)
);

