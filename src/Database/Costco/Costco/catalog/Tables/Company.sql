CREATE TABLE [catalog].[Company] (
    [CompanyGuid] UNIQUEIDENTIFIER CONSTRAINT [DF_Company_CompanyGuid] DEFAULT (newid()) NOT NULL,
    [CompanyName] NVARCHAR (30)    NOT NULL,
    [IsCarrier]   BIT              CONSTRAINT [DF_Company_IsCarrier] DEFAULT ((0)) NOT NULL,
    [CarrierId]   INT              NULL,
    CONSTRAINT [PK_Company] PRIMARY KEY CLUSTERED ([CompanyGuid] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Company]
    ON [catalog].[Company]([CompanyGuid] ASC);

