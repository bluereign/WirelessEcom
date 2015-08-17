SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [report].[new_devices]
AS
SELECT * FROM catalogthisweek.device cdt WHERE NOT EXISTS (SELECT * FROM cataloglastweek.device cdl WHERE cdt.UPC = cdl.UPC)
GO
