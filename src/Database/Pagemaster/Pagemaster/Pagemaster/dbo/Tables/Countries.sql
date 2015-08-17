CREATE TABLE [dbo].[Countries] (
    [Country_ID]               INT            NOT NULL,
    [CountryName]              NVARCHAR (50)  NOT NULL,
    [Country_Alpha2]           NVARCHAR (2)   NULL,
    [CountryAbbr]              NVARCHAR (255) NULL,
    [PSAirParcelPostRateGroup] NVARCHAR (2)   NULL,
    [AddressFormat]            NVARCHAR (255) NULL
);

