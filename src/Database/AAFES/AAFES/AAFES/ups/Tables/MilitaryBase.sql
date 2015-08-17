CREATE TABLE [ups].[MilitaryBase] (
    [BaseId]     INT            IDENTITY (1, 1) NOT NULL,
    [BranchId]   INT            NOT NULL,
    [BaseName]   NVARCHAR (100) NOT NULL,
    [Kiosk]      BIT            CONSTRAINT [DF__MilitaryB__Kiosk__559C5633] DEFAULT ((0)) NOT NULL,
    [Address1]   NVARCHAR (50)  NULL,
    [Address2]   NVARCHAR (50)  NULL,
    [City]       NVARCHAR (50)  NULL,
    [State]      NVARCHAR (2)   NULL,
    [Zip]        NVARCHAR (10)  NULL,
    [MainNumber] NVARCHAR (20)  NULL,
    [StoreHours] NVARCHAR (100) NULL,
    [KioskCode]  INT            NULL,
    [StoreCode]  VARCHAR (2)    NULL,
    CONSTRAINT [PK__Military__E797087653B40DC1] PRIMARY KEY CLUSTERED ([BaseId] ASC),
    CONSTRAINT [FK__MilitaryB__Branc__56907A6C] FOREIGN KEY ([BranchId]) REFERENCES [ups].[MilitaryBranch] ([BranchId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MilitaryBaseAddress_index]
    ON [ups].[MilitaryBase]([BaseName] ASC, [Address1] ASC, [City] ASC, [State] ASC, [Zip] ASC, [MainNumber] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MilitaryBaseKiosk_index]
    ON [ups].[MilitaryBase]([BranchId] ASC, [BaseName] ASC, [Kiosk] ASC);

