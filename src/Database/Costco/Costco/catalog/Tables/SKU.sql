CREATE TABLE [catalog].[SKU] (
    [Instance]       INT             IDENTITY (1, 1) NOT NULL,
    [Channel]        INT             DEFAULT ((0)) NOT NULL,
    [Description]    NVARCHAR (500)  NOT NULL,
    [Carrier]        INT             NOT NULL,
    [DeviceType]     NVARCHAR (255)  NOT NULL,
    [ActivationType] NVARCHAR (255)  NOT NULL,
    [RateplanName]   NVARCHAR (255)  NOT NULL,
    [SOCCode]        NVARCHAR (4000) NOT NULL,
    [Lines]          NVARCHAR (25)   NOT NULL,
    [Apple]          BIT             DEFAULT ((0)) NOT NULL,
    [RateplanSKU]    NVARCHAR (9)    NOT NULL,
    [ModifiedBy]     NVARCHAR (255)  NOT NULL,
    [Modified]       DATETIME        NOT NULL,
    PRIMARY KEY CLUSTERED ([Instance] ASC)
);

