
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		CFWebtools
-- Create date: 11/11/2013
-- Description:	adds a list of seats to a users basket
-- =============================================

CREATE PROCEDURE [catalog].[spSaveEditorsChoice]
(

	@ChannelId INT, -- selected by user in dropdown
	@Rank1 VARCHAR(10), -- 1. field inputted by user
	@Rank2 VARCHAR(10), -- 2. field inputted by user
	@Rank3 VARCHAR(10), -- 3. field inputted by user
	@Rank4 VARCHAR(10), -- 4. field inputted by user
	@Rank5 VARCHAR(10), -- 5. field inputted by user
	@Rank6 VARCHAR(10), -- 6. field inputted by user
	@Rank7 VARCHAR(10), -- 7. field inputted by user
	@Rank8 VARCHAR(10), -- 8. field inputted by user
	@Rank9 VARCHAR(10), -- 9. field inputted by user
	@Rank10 VARCHAR(10), -- 10. field inputted by user
	@Rank11 VARCHAR(10), -- 11. field inputted by user
	@Rank12 VARCHAR(10) -- 12. field inputted by user
	
)
AS


BEGIN
	SET NOCOUNT ON;

	BEGIN
		-- Delete old Editors Choice List	
		DELETE FROM catalog.Property
		WHERE Name = 'sort.EditorsChoice'
			AND ProductGuid IN (SELECT ProductGuid FROM catalog.Product WHERE ChannelID = @ChannelId)
		
		-- INSERT New Editors Choice List
		INSERT INTO catalog.Property (ProductGuid, Value, Name, LastModifiedDate, LastModifiedBy, IsCustom, Active)
		 
		VALUES
		 
			  ((SELECT ProductGuid FROM catalog.Product WHERE GersSku = @Rank1), 1, 'sort.EditorsChoice', GETDATE(), 'dynamic', 1, 1),
			  ((SELECT ProductGuid FROM catalog.Product WHERE GersSku = @Rank2), 2, 'sort.EditorsChoice', GETDATE(), 'dynamic', 1, 1),
			  ((SELECT ProductGuid FROM catalog.Product WHERE GersSku = @Rank3), 3, 'sort.EditorsChoice', GETDATE(), 'dynamic', 1, 1),     
			  ((SELECT ProductGuid FROM catalog.Product WHERE GersSku = @Rank4), 4, 'sort.EditorsChoice', GETDATE(), 'dynamic', 1, 1),
			  ((SELECT ProductGuid FROM catalog.Product WHERE GersSku = @Rank5), 5, 'sort.EditorsChoice', GETDATE(), 'dynamic', 1, 1),
			  ((SELECT ProductGuid FROM catalog.Product WHERE GersSku = @Rank6), 6, 'sort.EditorsChoice', GETDATE(), 'dynamic', 1, 1),
			  ((SELECT ProductGuid FROM catalog.Product WHERE GersSku = @Rank7), 7, 'sort.EditorsChoice', GETDATE(), 'dynamic', 1, 1),
			  ((SELECT ProductGuid FROM catalog.Product WHERE GersSku = @Rank8), 8, 'sort.EditorsChoice', GETDATE(), 'dynamic', 1, 1),
			  ((SELECT ProductGuid FROM catalog.Product WHERE GersSku = @Rank9), 9, 'sort.EditorsChoice', GETDATE(), 'dynamic', 1, 1),
			  ((SELECT ProductGuid FROM catalog.Product WHERE GersSku = @Rank10), 10, 'sort.EditorsChoice', GETDATE(), 'dynamic', 1, 1),
			  ((SELECT ProductGuid FROM catalog.Product WHERE GersSku = @Rank11), 11, 'sort.EditorsChoice', GETDATE(), 'dynamic', 1, 1),
			  ((SELECT ProductGuid FROM catalog.Product WHERE GersSku = @Rank12), 12, 'sort.EditorsChoice', GETDATE(), 'dynamic', 1, 1)
	
	END


		
	SET NOCOUNT OFF 
END



GO
GRANT EXECUTE ON  [catalog].[spSaveEditorsChoice] TO [managefilter]
GO
