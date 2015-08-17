CREATE TABLE [catalog].[SessionStockReservation] (
    [SessionId]    VARCHAR (36) NOT NULL,
    [GroupNumber]  INT          NOT NULL,
    [ProductId]    INT          NOT NULL,
    [Qty]          INT          NOT NULL,
    [ReservedTime] DATETIME     CONSTRAINT [DF_SessionStockReservation_ReservedTime] DEFAULT (getdate()) NOT NULL,
    [CampaignId]   INT          NULL,
    CONSTRAINT [PK_SessionStockReservation_1] PRIMARY KEY CLUSTERED ([SessionId] ASC, [GroupNumber] ASC, [ProductId] ASC) WITH (FILLFACTOR = 80)
);


GO


---------------------------------------------------------------------------- 
-- Object Type : Trigger
-- Object Name : msdb.tr_logreservedstock
-- Description : Monitor all devices and accessories added to the catalog.SessionStockReservation table
-- Author : Naomi Hall
-- Date : March 7, 2013
---------------------------------------------------------------------------- 

--The Trigger
CREATE TRIGGER [catalog].[tr_logreservedstock] ON [catalog].[SessionStockReservation] FOR INSERT

AS

-- Action
	IF EXISTS (SELECT * FROM inserted)
	BEGIN
-- Get list of columns changed
	SELECT * INTO #ins FROM inserted
	
-- Get primary key columns for full outer join
INSERT INTO logging.ReservedStock
SELECT * FROM #ins
END
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'SessionStockReservation', @level2type = N'COLUMN', @level2name = N'ProductId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'SessionStockReservation', @level2type = N'COLUMN', @level2name = N'GroupNumber';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'SessionStockReservation', @level2type = N'COLUMN', @level2name = N'SessionId';

