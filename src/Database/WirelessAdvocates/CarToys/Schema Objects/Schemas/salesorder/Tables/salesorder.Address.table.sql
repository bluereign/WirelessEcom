CREATE TABLE [salesorder].[Address] (
    [AddressGuid]  UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
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
    [EveningPhone] NVARCHAR (10)    NULL
);

