-- =============================================
-- Author:		Ron Delzer
-- Create date: 
-- Description:	
-- =============================================
CREATE Procedure [catalog].[IsEligibleForRebate] 
(
	-- Add the parameters for the function here
	@RebateGuid uniqueidentifier,
	@ProductList varchar(max),
	@ActivationType varchar(50),
	@Result int OUTPUT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	/* Result defaults to 0 */
	SET @Result = 0;
	
	DECLARE @FilterGuidList GuidList;
	DECLARE @ProductGuidList GuidList;
	INSERT INTO @ProductGuidList SELECT * FROM dbo.udf_List2GuidList(@ProductList, ',');
	
	DECLARE @FilterQuery varchar(max);

	DECLARE FilterOptionCursor CURSOR LOCAL STATIC FOR
		SELECT     FO.DynamicTag
		FROM         catalog.RebateToFilter AS RF INNER JOIN
							  catalog.FilterOption AS FO ON RF.FilterOptionId = FO.FilterOptionId
		INNER JOIN catalog.rebate AS r ON r.RebateGuid = rf.RebateGuid AND r.active = 1 AND r.[type]=@ActivationType AND r.StartDate <= GETDATE() AND r.EndDate >= GETDATE()
		WHERE     (RF.RebateGuid = @RebateGuid);
		
	OPEN FilterOptionCursor;
	
	FETCH NEXT FROM FilterOptionCursor INTO @FilterQuery;
	
	/* If the rebate exists and has at least one filter then set Result to 1 */
	IF @@CURSOR_ROWS > 0 SET @Result = 1;
	
	WHILE @@FETCH_STATUS = 0
		BEGIN			
			INSERT INTO @FilterGuidList EXEC(@FilterQuery);
			
			IF NOT EXISTS(SELECT * FROM @ProductGuidList P INNER JOIN @FilterGuidList F ON P.item = F.item)
				BEGIN
					/* Failed filter check, set Result to 0 and exit */
					SET @Result = 0;
					BREAK;
				END
			
			DELETE FROM @FilterGuidList;
			FETCH NEXT FROM FilterOptionCursor INTO @FilterQuery;
		END
		
	CLOSE FilterOptionCursor;
	DEALLOCATE FilterOptionCursor;
	
	RETURN @Result;
END