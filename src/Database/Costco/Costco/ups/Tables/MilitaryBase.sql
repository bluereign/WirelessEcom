CREATE TABLE [ups].[MilitaryBase] (
    [BaseId]     INT            IDENTITY (1, 1) NOT NULL,
    [BranchId]   INT            NOT NULL,
    [BaseName]   NVARCHAR (100) NOT NULL,
    [Kiosk]      BIT            DEFAULT ((0)) NOT NULL,
    [Address1]   NVARCHAR (50)  NULL,
    [Address2]   NVARCHAR (50)  NULL,
    [City]       NVARCHAR (50)  NULL,
    [State]      NVARCHAR (2)   NULL,
    [Zip]        NVARCHAR (10)  NULL,
    [MainNumber] NVARCHAR (20)  NULL,
    [StoreHours] NVARCHAR (100) NULL,
    [KioskCode]  INT            NULL,
    [StoreCode]  VARCHAR (2)    NULL,
    PRIMARY KEY CLUSTERED ([BaseId] ASC),
    CONSTRAINT [CK_KioskBaseYes] CHECK ([Kiosk]='1' AND ([Address1] IS NOT NULL AND [City] IS NOT NULL AND [State] IS NOT NULL AND [Zip] IS NOT NULL AND [MainNumber] IS NOT NULL AND [StoreHours] IS NOT NULL) OR [Kiosk]='0' AND ([Address1] IS NULL AND [City] IS NULL AND [State] IS NULL AND [Zip] IS NULL AND [MainNumber] IS NULL AND [StoreHours] IS NULL)),
    FOREIGN KEY ([BranchId]) REFERENCES [ups].[MilitaryBranch] ([BranchId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MilitaryBaseAddress_index]
    ON [ups].[MilitaryBase]([BaseName] ASC, [Address1] ASC, [City] ASC, [State] ASC, [Zip] ASC, [MainNumber] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MilitaryBaseKiosk_index]
    ON [ups].[MilitaryBase]([BranchId] ASC, [BaseName] ASC, [Kiosk] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MilitaryBaseName_index]
    ON [ups].[MilitaryBase]([BaseName] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MilitaryBase_index]
    ON [ups].[MilitaryBase]([BranchId] ASC, [BaseName] ASC);

