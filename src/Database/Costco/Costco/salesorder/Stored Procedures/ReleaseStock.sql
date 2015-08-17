-- =============================================
-- Author:		Ron Delzer
-- Create date: 1/31/2010
-- Description:	
-- =============================================
CREATE PROCEDURE [salesorder].[ReleaseStock] 
	@SessionId varchar(36), 
	@GroupNumber int = NULL,
	@ProductId int = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @SqlCommand nvarchar(max)
	DECLARE @WhereClause nvarchar(max);
	DECLARE @ParamList nvarchar(max);
	DECLARE @QtySum int;
	
	SET @WhereClause = 'WHERE SessionId = @xSessionId';
	
	IF @GroupNumber IS NOT NULL
		SET @WhereClause = @WhereClause + ' AND GroupNumber = @xGroupNumber';
	IF @ProductId IS NOT NULL
		SET @WhereClause = @WhereClause + ' AND ProductId = @xProductId';
	
	SET @ParamList = '@xSessionId nvarchar(25), @xGroupNumber int, @xProductId int, @xQtySum int OUTPUT'


	SET @SqlCommand = 'SELECT @xQtySum=SUM(Qty) FROM catalog.SessionStockReservation ' + @WhereClause + ' AND OrderDetailId IS NOT NULL'
	
	EXECUTE sp_executesql
		@SqlCommand
		,@ParamList
		,@xSessionId = @SessionId
		,@xGroupNumber = @GroupNumber
		,@xProductId = @ProductId
		,@xQtySum = @QtySum OUTPUT;
		
	IF @QtySum != 0
	BEGIN
		PRINT 'Can''t release reservations, order was partially allocated.'
		RETURN 1
	END


	SET @SqlCommand = 'DELETE FROM catalog.SessionStockReservation ' + @WhereClause

	EXECUTE sp_executesql
		@SqlCommand
		,@ParamList
		,@xSessionId = @SessionId
		,@xGroupNumber = @GroupNumber
		,@xProductId = @ProductId
		,@xQtySum = @QtySum OUTPUT;
	
END