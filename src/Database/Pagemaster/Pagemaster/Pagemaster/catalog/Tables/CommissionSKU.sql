CREATE TABLE [catalog].[CommissionSKU] (
    [Instance]       INT            NOT NULL,
    [CommissionSKU]  VARCHAR (9)    NOT NULL,
    [Name]           VARCHAR (500)  NOT NULL,
    [CarrierId]      INT            NOT NULL,
    [ActivationType] VARCHAR (10)   NULL,
    [RateplanType]   VARCHAR (3)    NULL,
    [DeviceType]     NVARCHAR (MAX) NULL,
    [Lines]          INT            NULL,
    [MinAmount]      MONEY          NULL,
    [MaxAmount]      MONEY          NULL,
    [IsApple]        BIT            DEFAULT ((0)) NOT NULL
);

