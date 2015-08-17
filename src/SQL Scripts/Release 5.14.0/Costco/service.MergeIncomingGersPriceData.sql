/****** Object:  StoredProcedure [service].[MergeIncomingGersPriceData]    Script Date: 9/18/2014 2:49:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Create sProc to merge GersPriceGroup and GersPrice from incoming staging tables
-- Originally added by Ron, edited by Naomi Hall on 8/11 to allow for Pagemaster pricing groups
-- RD 2014/08/14 modified to work for all channels
-- RD 2014/09/10 leave price entries with comment like 'CJ%' alone for TMO affiliate work

ALTER PROCEDURE [service].[MergeIncomingGersPriceData]
AS
BEGIN
	SET NOCOUNT ON;

	/*
		Map PriceGroupCode values to the Costco equivalents since the Costco PriceGroupCode
		values are hard-coded in some locations
		
		Create a table variable for the price group mapping since it gets used twice, once
		for the GersPriceGroup table and once for the GersPrice table which has a FK to GersPriceGroup
	*/
 
	DECLARE @PriceGroupMap
		TABLE (
			 ChannelPriceGroup nvarchar(3)
			,GenericPriceGroup nvarchar(3)
		);

	INSERT INTO @PriceGroupMap
	VALUES
		 ('MMN','ECN')
		,('MMA','ECA')
		,('MMU','ECU')
		,('MMP','ECP')
		,('MRN','ERN')
		,('MRU','ERU')
		,('MRA','ERA')
		,('PGN','ECN')
		,('PGA','ECA')
		,('PGU','ECU')
		,('PGP','ECP')
	;

	MERGE INTO [catalog].[GersPriceGroup] AS T
	USING (
		SELECT ISNULL(M.GenericPriceGroup, I.PriceGroupCode) AS PriceGroupCode, I.PriceGroupDescription
		FROM [service].IncomingGersPriceGroup I
			LEFT OUTER JOIN @PriceGroupMap M ON I.PriceGroupCode = M.ChannelPriceGroup
	) AS S
	ON T.PriceGroupCode = S.PriceGroupCode
	WHEN MATCHED THEN
		UPDATE SET PriceGroupDescription = S.PriceGroupDescription
	WHEN NOT MATCHED BY TARGET THEN
		INSERT (PriceGroupCode, PriceGroupDescription)
		VALUES (S.PriceGroupCode, S.PriceGroupDescription)
	;

	MERGE INTO [catalog].[GersPrice] AS T
	USING (SELECT I.GersSku
				,ISNULL(M.GenericPriceGroup,I.PriceGroupCode) AS PriceGroupCode
				,I.Price
				,I.StartDate
				,I.EndDate
				,I.Comment
			FROM [service].[IncomingGersPrice] I
				LEFT OUTER JOIN @PriceGroupMap M
					ON I.PriceGroupCode = M.ChannelPriceGroup
			) AS S
	ON T.GersSku = S.GersSku
		AND T.PriceGroupCode = S.PriceGroupCode
		AND T.StartDate = S.StartDate
		AND T.Comment NOT LIKE 'CJ%'
	WHEN MATCHED THEN
		UPDATE SET Price = S.Price, EndDate = S.EndDate, Comment = S.Comment
	WHEN NOT MATCHED BY TARGET THEN
		INSERT (GersSku, PriceGroupCode, Price, StartDate, EndDate, Comment)
		VALUES (S.GersSku, S.PriceGroupCode, S.Price, S.StartDate, S.EndDate, S.Comment)
	WHEN NOT MATCHED BY SOURCE
		AND T.PriceGroupCode != 'COG'
		AND T.Comment NOT LIKE 'CJ%'
			THEN DELETE
	;
END

GO
