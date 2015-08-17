
-- =============================================
-- Author:		Tyson Vanek
-- Create date: 02/09/2010
-- Description:	AssignIMEIToWirelessLine
-- =============================================
CREATE PROCEDURE [salesorder].[AssignIMEIToWirelessLine] 
	@OrderDetailId int -- expected to be the OrderDetailId of a Device with a corresponding Rateplan and WirelessLine
AS
BEGIN
	DECLARE @ReturnValue int;
	DECLARE @OrderId int;
	DECLARE @GroupNumber int;
	DECLARE @RateplanOrderDetailId int;
	DECLARE @WirelessLineId int;
	DECLARE @IMEI varchar(20);
	DECLARE @SIM varchar(20);
	DECLARE @RowsAffected int;

	-- get the OrderId and GroupNumber for this device
	SELECT
		@OrderId = OrderId
	,	@GroupNumber = GroupNumber
	FROM
		salesorder.OrderDetail
	WHERE
		OrderDetailId = @OrderDetailId;

	IF @OrderId IS NULL
	BEGIN
		PRINT 'ERROR: Could not determine the parent OrderId for the supplied OrderDetailId.';
		RETURN 1;
	END

	IF @GroupNumber IS NULL
	BEGIN
		PRINT 'ERROR: Could not determine the GroupNumber for the supplied OrderDetailId.';
		RETURN 1;
	END

	-- get the IMEI assigned to the GersStock item that has been associatedto this device
	SELECT
		@IMEI = IMEI,
		@SIM = SIM
	FROM
		catalog.GersStock
	WHERE
		OrderDetailId = @OrderDetailId;

	IF @IMEI IS NULL
	BEGIN
		PRINT 'ERROR: Could not determine the IMEI for the reserved GersStock item.';
		RETURN 1;
	END

	-- get the rateplan orderdetail record for this line
	SELECT
		@RateplanOrderDetailId = od.OrderDetailId
	,	@WirelessLineId = wl.WirelessLineId
	FROM
		salesorder.OrderDetail od
		INNER JOIN salesorder.WirelessLine wl
			ON od.OrderDetailId = wl.OrderDetailId
	WHERE
		od.OrderId = @OrderId
	AND	od.GroupNumber = @GroupNumber
	AND	od.OrderDetailType = 'd';

	IF @RateplanOrderDetailId IS NULL
	BEGIN
		PRINT 'ERROR: Could not determine the OrderDetailId for the Rateplan on this line of the Order.';
		RETURN 1;
	END

	IF @WirelessLineId IS NULL
	BEGIN
		PRINT 'ERROR: Could not determine the WirelessLineId for the Rateplan on this line of the Order.';
		RETURN 1;
	END

	-- if we made it this far, we've gathered all the data we need - now we just need to tag the wirelessline with the IMEI
	
	UPDATE
		salesorder.WirelessLine
	SET
		IMEI = @IMEI,
		SIM = @SIM
	WHERE
		OrderDetailId = @RateplanOrderDetailId;

	SET @RowsAffected = @@ROWCOUNT;

	IF @RowsAffected = 0
	BEGIN
		PRINT 'ERROR: 0 records were updated in catalog.WirelessLine.';
		RETURN 1;
	END
	ELSE
	BEGIN
		RETURN 0;	
	END
END


