CREATE TABLE [salesorder].[Address] (
    [AddressGuid]  UNIQUEIDENTIFIER CONSTRAINT [DF_Address_AddressGuid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [FirstName]    NVARCHAR (50)    NOT NULL,
    [LastName]     NVARCHAR (50)    NOT NULL,
    [Company]      NVARCHAR (50)    NULL,
    [Address1]     NVARCHAR (50)    NOT NULL,
    [Address2]     NVARCHAR (50)    NULL,
    [Address3]     NVARCHAR (50)    NULL,
    [City]         NVARCHAR (50)    NOT NULL,
    [State]        NVARCHAR (2)     NOT NULL,
    [Zip]          NVARCHAR (10)    NOT NULL,
    [DaytimePhone] NVARCHAR (10)    NOT NULL,
    [EveningPhone] NVARCHAR (10)    NULL,
    [MilitaryBase] NVARCHAR (100)   NULL,
    CONSTRAINT [PK_Address] PRIMARY KEY CLUSTERED ([AddressGuid] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [IX_Address] UNIQUE NONCLUSTERED ([AddressGuid] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Address', @level2type = N'COLUMN', @level2name = N'AddressGuid';

