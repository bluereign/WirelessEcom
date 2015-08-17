
-- =============================================
-- Author:		Ron Delzer
-- Create date: 4/1/2010
-- Description:	Cancels Order and Releases Inventory
--
-- Update: Ron Delzer, 4/20/2010 
--         Fail if already activated, add logging for "order not open" failure as well
-- =============================================
CREATE PROCEDURE [salesorder].[CancelOrder] 
	-- Add the parameters for the stored procedure here
	@OrderId int, 
	@Comment nvarchar(max) = N''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @OrderCount int
	
	-- Make sure we havent't activated any lines yet
	-- salesorder.WirelessLine.ActivationStatus values:
	--		1: Requested
	--		2: Success
	--		6: Manual
	IF EXISTS (	SELECT *
				FROM salesorder.OrderDetail OD
					INNER JOIN salesorder.WirelessLine WL
						ON OD.OrderDetailId = WL.OrderDetailId
				WHERE OD.OrderId = @OrderId AND WL.ActivationStatus IN (1,2,6))
		BEGIN
			INSERT INTO salesorder.Activity (OrderId, Name, Description)
			VALUES (@OrderId, 'Cancel Order Failed', 'ERROR: One or more lines already activated' + CHAR(13) + CHAR(10) + 'USER: ' + CURRENT_USER + '  COMMENT: "' + @Comment + '"');
			
			RAISERROR
				(N'Cancel Order Failed, one or more lines already activated.',
				16,
				0)
		END
		
	-- Attempt cancel
	BEGIN TRAN

	UPDATE O SET Status=4
	FROM salesorder.[Order] O
	WHERE (O.Status=1 OR O.Status=2)AND O.OrderId=@OrderId

	SET @OrderCount=@@ROWCOUNT

	IF (@OrderCount=1)
		BEGIN
			UPDATE GS SET OrderDetailId=NULL
			FROM salesorder.[Order] O INNER JOIN salesorder.OrderDetail OD ON O.OrderId=OD.OrderId INNER JOIN catalog.GersStock GS ON OD.OrderDetailId=GS.OrderDetailId
			WHERE O.Status = 4 AND O.OrderId=@OrderId
			
			INSERT INTO salesorder.Activity (OrderId, Name, Description)
			VALUES (@OrderId, 'Cancel Order', 'USER: ' + CURRENT_USER + '  COMMENT: "' + @Comment + '"')
			
			COMMIT
		END
	ELSE
		BEGIN
			ROLLBACK
			
			INSERT INTO salesorder.Activity (OrderId, Name, Description)
			VALUES (@OrderId, 'Cancel Order Failed', 'ERROR: order must be in Open status to be cancelled.' + CHAR(13) + CHAR(10) + 'USER: ' + CURRENT_USER + '  COMMENT: "' + @Comment + '"')
			
			RAISERROR
				(N'Cancel Order Failed, order must be in Open status to be cancelled.',
				16,
				0)
		END
END

