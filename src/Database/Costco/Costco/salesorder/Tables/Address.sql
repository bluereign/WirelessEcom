CREATE TABLE [salesorder].[Address] (
    [AddressGuid]  UNIQUEIDENTIFIER CONSTRAINT [DF_Address_AddressGuid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [FirstName]    NVARCHAR (50)    NULL,
    [LastName]     NVARCHAR (50)    NULL,
    [Company]      NVARCHAR (50)    NULL,
    [Address1]     NVARCHAR (50)    NULL,
    [Address2]     NVARCHAR (50)    NULL,
    [Address3]     NVARCHAR (50)    NULL,
    [City]         NVARCHAR (50)    NULL,
    [State]        NVARCHAR (2)     NULL,
    [Zip]          NVARCHAR (10)    NULL,
    [DaytimePhone] NVARCHAR (10)    NULL,
    [EveningPhone] NVARCHAR (10)    NULL,
    [MilitaryBase] NVARCHAR (100)   NULL,
    CONSTRAINT [PK_Address] PRIMARY KEY CLUSTERED ([AddressGuid] ASC) WITH (FILLFACTOR = 90),
    FOREIGN KEY ([MilitaryBase]) REFERENCES [ups].[MilitaryBase] ([BaseName]),
    CONSTRAINT [IX_Address] UNIQUE NONCLUSTERED ([AddressGuid] ASC) WITH (FILLFACTOR = 90)
);

