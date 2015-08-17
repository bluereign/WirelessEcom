SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [report].[old_devices]
AS
SELECT * FROM cataloglastweek.device cdl WHERE NOT EXISTS (SELECT * FROM catalogthisweek.device cdt WHERE cdl.UPC = cdt.UPC)
GO
