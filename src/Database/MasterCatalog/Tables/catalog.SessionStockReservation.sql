CREATE TABLE [catalog].[SessionStockReservation]
(
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GroupNumber] [int] NOT NULL,
[ProductId] [int] NOT NULL,
[Qty] [int] NOT NULL,
[ReservedTime] [datetime] NOT NULL CONSTRAINT [DF_SessionStockReservation_ReservedTime] DEFAULT (getdate())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
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
ALTER TABLE [catalog].[SessionStockReservation] ADD CONSTRAINT [PK_SessionStockReservation_1] PRIMARY KEY CLUSTERED  ([SessionId], [GroupNumber], [ProductId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'catalog', 'TABLE', N'SessionStockReservation', 'COLUMN', N'GroupNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'catalog', 'TABLE', N'SessionStockReservation', 'COLUMN', N'ProductId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'catalog', 'TABLE', N'SessionStockReservation', 'COLUMN', N'SessionId'
GO
