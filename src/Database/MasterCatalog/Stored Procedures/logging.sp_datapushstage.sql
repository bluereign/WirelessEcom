
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE  [logging].[sp_datapushstage] 
(
	@ChannelId int
	,@Target nvarchar(100)
)
AS

IF (@ChannelId = '2' AND @Target IN ('Test','Stage'))
	BEGIN
	EXEC [CATALOG.CONFIGURE].[logging].[sp_dp_stagestart]
	WAITFOR DELAY '00:00:10'
	EXEC [msdb].dbo.sp_start_job N'MASTER CATALOG: Load Properties from Sharepoint' ;
	WAITFOR DELAY '00:01:00'
	EXEC [msdb].dbo.sp_start_job N'MASTER CATALOG: Staging Data' ;
	WAITFOR DELAY '00:01:30'
	EXEC [msdb].dbo.sp_start_job N'DATA PUSH: COSTCO STAGE' ;
	WAITFOR DELAY '00:06:00'
	EXEC [msdb].dbo.sp_start_job N'ROUTINE: Load Fake Inventory to T&S Environments' ;
	WAITFOR DELAY '00:03:00'
	EXEC [CATALOG.CONFIGURE].[logging].[sp_dp_stageconfirm]
	WAITFOR DELAY '00:00:10'
	END

IF (@ChannelId = '3' AND @Target IN ('Test','Stage'))
	BEGIN
	EXEC [CATALOG.CONFIGURE].[logging].[sp_dp_stagestart]
	WAITFOR DELAY '00:00:10'
	EXEC [msdb].dbo.sp_start_job N'MASTER CATALOG: Load Properties from Sharepoint' ;
	WAITFOR DELAY '00:01:00'
	EXEC [msdb].dbo.sp_start_job N'MASTER CATALOG: Staging Data' ;
	WAITFOR DELAY '00:01:30'
	EXEC [msdb].dbo.sp_start_job N'DATA PUSH: AAFES STAGE' ;
	WAITFOR DELAY '00:06:00'
	EXEC [msdb].dbo.sp_start_job N'ROUTINE: Load Fake Inventory to T&S Environments' ;
	WAITFOR DELAY '00:03:00'
	EXEC [CATALOG.CONFIGURE].[logging].[sp_dp_stageconfirm]
	WAITFOR DELAY '00:00:10'
	END

IF (@ChannelId = '4' AND @Target IN ('Test','Stage'))
	BEGIN
	EXEC [CATALOG.CONFIGURE].[logging].[sp_dp_stagestart]
	WAITFOR DELAY '00:00:10'
	EXEC [msdb].dbo.sp_start_job N'MASTER CATALOG: Load Properties from Sharepoint' ;
	WAITFOR DELAY '00:01:00'
	EXEC [msdb].dbo.sp_start_job N'MASTER CATALOG: Staging Data' ;
	WAITFOR DELAY '00:01:30'
	--EXEC [msdb].dbo.sp_start_job N'DATA PUSH: AAFES STAGE' ;
	--WAITFOR DELAY '00:06:00'
	EXEC [msdb].dbo.sp_start_job N'ROUTINE: Load Fake Inventory to T&S Environments' ;
	WAITFOR DELAY '00:03:00'
	EXEC [CATALOG.CONFIGURE].[logging].[sp_dp_stageconfirm]
	WAITFOR DELAY '00:00:10'
	END

GO
