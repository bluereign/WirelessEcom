CREATE TABLE [ups].[ServiceType] (
    [Abbreviation] NVARCHAR (4)  NOT NULL,
    [Name]         NVARCHAR (50) NOT NULL,
    [Title]        NVARCHAR (50) NOT NULL,
    [GersZoneCode] INT           NULL,
    [Ordinal]      INT           NULL,
    [IsAir]        BIT           NOT NULL
);

