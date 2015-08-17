SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE  logging.sp_datapushprod AS
EXEC [CATALOG.CONFIGURE].[logging].[sp_dp_prodstart]
WAITFOR DELAY '00:00:10'
EXEC [msdb].dbo.sp_start_job N'MASTER CATALOG: Load Properties from Sharepoint' ;
WAITFOR DELAY '00:01:00'
EXEC [msdb].dbo.sp_start_job N'MASTER CATALOG: Staging Data' ;
WAITFOR DELAY '00:01:30'
EXEC [msdb].dbo.sp_start_job N'DATA PUSH: Prod Environments' ;
WAITFOR DELAY '00:06:00'
EXEC [msdb].dbo.sp_start_job N'ROUTINE: Load Fake Inventory to T&S Environments' ;
WAITFOR DELAY '00:03:00'
EXEC [CATALOG.CONFIGURE].[logging].[sp_dp_prodconfirm]
WAITFOR DELAY '00:00:10'
GO
