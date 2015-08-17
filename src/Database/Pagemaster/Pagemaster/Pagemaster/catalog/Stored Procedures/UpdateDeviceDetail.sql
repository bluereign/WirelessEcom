




CREATE PROC [catalog].[UpdateDeviceDetail]( @priceHourOffset INT = 0 )
AS
/******************************************************************************************
*
*  Object: [UpdateDeviceDetail]
*  Schema: catalog
*
*  Example Call:

		-- Run the SPROC
		EXEC [catalog].[UpdateDeviceDetail]
		
		SELECT * FROM [catalog].[DeviceDetail]


*  Purpose: Updates the [catalog].[DeviceDetail] lookup table. This should be pushed into a
*           web cache.
*
*  Date             User          Detail
*  09/15/2010       scampbell    Initial coding
*  09/18/2014		scampbell	 Added @priceHourOffset
*  10/06/2014		wallc/116773 Commented out last MERGE statement as it prevented new phones from being displayed
*  10/13/2014		wallc/116773 The retailprice was missing in the MERGE statement when updating. Added it.
*  10/13/2014		wallc/116773 Ran into duplicate inactive issue so filtered on only active devices when updating devicedetail table.
*
*****************************************************************************************/
BEGIN
   SET NOCOUNT ON;
   
   -- This will hold the price 'pivot' for the devices.
   CREATE TABLE #priceList( ProductGuid					UNIQUEIDENTIFIER  PRIMARY KEY,
                            GersSku						NVARCHAR(9), 
	                        RetailPrice					MONEY, 
				         	NewPrice					MONEY, 
							UpgradePrice				MONEY,
							AddALinePrice				MONEY,
							NoContractPrice				MONEY, 
							NewPriceAfterRebate			MONEY, 
							UpgradePriceAfterRebate		MONEY, 
							AddALinePriceAfterRebate	MONEY
						  )
						  
	-- This will hold the property 'pivot' for the devices						  
    CREATE TABLE #propertyList( ProductGUID		UNIQUEIDENTIFIER PRIMARY KEY, 
	                            PageTitle		VARCHAR(150), 
								SummaryTitle	VARCHAR(150), 
								DetailTitle		VARCHAR(150), 
								SD				VARCHAR(4000), 
								LD				VARCHAR(MAX), 
								MK				VARCHAR(4000), 
								MD				VARCHAR(4000), 
								BuyURL			VARCHAR(300), 
								ImageUrl		VARCHAR(300),
								BFree			INT )
								
   -- This mostly exists to make debugging changes a little easier.
    CREATE TABLE #deviceDetail( DeviceGuid			UNIQUEIDENTIFIER PRIMARY KEY,
                           ProductId			INT,
						   GersSku				NVARCHAR(9),
						   PageTitle			VARCHAR(1000),
						   SummaryTitle			VARCHAR(150),
						   DetailTitle			VARCHAR(150),
						   CarrierId			INT,
						   CarrierName			VARCHAR(100),
						   ManufacturerGuid		UNIQUEIDENTIFIER,
						   ManufacturerName		VARCHAR(100),
						   BFreeAccessory		INT,
						   SummaryDescription	VARCHAR(MAX),
						   DetailDescription	VARCHAR(MAX),
						   MetaKeywords			VARCHAR(MAX),
						   MetaDescription		VARCHAR(MAX),
						   ReleaseDate			VARCHAR(1000),
						   TypeId				INT,
						   UPC					VARCHAR(50),
						   BuyUrl				VARCHAR(3000),
						   ImageUrl				VARCHAR(3000),
						   RetailPrice			MONEY DEFAULT(0.0),
						   NewPrice				MONEY DEFAULT(0.0),
		                   UpgradePrice			MONEY DEFAULT(0.0),
						   AddALinePrice		MONEY DEFAULT(0.0),
						   NoContractPrice		MONEY DEFAULT(0.0),
						   NewPriceAfterRebate		MONEY DEFAULT(0.0),
						   UpgradePriceAfterRebate	MONEY DEFAULT(0.0),
						   AddALinePriceAfterRebate	MONEY DEFAULT(0.0),
						   Active					BIT NOT NULL DEFAULT(0),
						   Prepaid					BIT NOT NULL DEFAULT(0),
						   DefaultSortRank			INT
		  )
   
   -----------------------------------------------------------------------------------------------
   --
   -- Pivot the Price data for each sku
   --
   -----------------------------------------------------------------------------------------------
   ;WITH retailPrice( GersSku, Price )
    AS
	(
      SELECT GersSku,
             MAX(gp.Price)
        FROM [catalog].[GersPrice] gp WITH (NOLOCK)
       WHERE gp.PriceGroupCode = 'ECP' 
         AND gp.StartDate <= GETDATE() 
         AND CONVERT(date, DATEADD(hour, @priceHourOffset, GETDATE())) BETWEEN gp.StartDate AND gp.EndDate
       GROUP BY gp.GersSku
	),
	newPrice( GersSku, Price )
	AS
	(
      SELECT GersSku,
             MAX(gp.Price)
        FROM [catalog].GersPrice gp WITH (NOLOCK)
       WHERE gp.PriceGroupCode = 'ECN' 
         AND gp.StartDate <= GETDATE() 
         AND CONVERT(date, DATEADD(hour, @priceHourOffset, GETDATE())) BETWEEN gp.StartDate AND gp.EndDate
       GROUP BY GersSku
     ),
     upgradePrice( GersSku, Price )
     AS
     (
       SELECT GersSku,
               MAX(gp.Price)
          FROM [catalog].[GersPrice] gp WITH (NOLOCK)
         WHERE gp.PriceGroupCode = 'ECU' 
           AND gp.StartDate <= GETDATE() 
           AND CONVERT(date, DATEADD(hour, @priceHourOffset, GETDATE())) BETWEEN gp.StartDate AND gp.EndDate
         GROUP BY GersSku
     ),
     addALinePrice( GersSku, Price )
     AS
     (
        SELECT GersSku,
               MAX(gp.Price)
          FROM [catalog].[GersPrice] gp WITH (NOLOCK)
         WHERE gp.PriceGroupCode = 'ECA' 
           AND gp.StartDate <= GETDATE() 
           AND CONVERT(date, DATEADD(hour, @priceHourOffset, GETDATE())) BETWEEN gp.StartDate AND gp.EndDate
         GROUP BY GersSku
     ),
     noContractPrice( GersSku, Price )
     AS
     (
        SELECT GersSku,
               MAX(gp.Price)
          FROM [catalog].[GersPrice] gp WITH (NOLOCK)
         WHERE gp.PriceGroupCode = 'ECP' 
           AND gp.StartDate <= GETDATE() 
           AND CONVERT(date, DATEADD(hour, @priceHourOffset, GETDATE())) BETWEEN gp.StartDate AND gp.EndDate
         GROUP BY GersSku
      ),
      newPriceAfterRebate( GersSku, Price )
      AS
      (
        SELECT GersSku,
                MAX(gp.Price)
          FROM [catalog].[GersPrice] gp WITH (NOLOCK)
         WHERE gp.PriceGroupCode = 'ERN' 
           AND gp.StartDate <= GETDATE() 
           AND CONVERT(date, DATEADD(hour, @priceHourOffset, GETDATE())) BETWEEN gp.StartDate AND gp.EndDate
         GROUP BY GersSku
      ),
      upgradePriceAfterRebate( GersSKu, Price )
      AS
      (
        SELECT GersSku,
               MAX(gp.Price)
          FROM [catalog].[GersPrice] gp WITH (NOLOCK)
         WHERE gp.PriceGroupCode = 'ERU' 
           AND gp.StartDate <= GETDATE() 
           AND CONVERT(date, DATEADD(hour, @priceHourOffset, GETDATE())) BETWEEN gp.StartDate AND gp.EndDate
         GROUP BY GersSku
       ),
       addALinePriceAfterRebate( GersSKu, Price )
       AS
       (
         SELECT GersSku,
                MAX(gp.Price)
           FROM [catalog].[GersPrice] gp WITH (NOLOCK)
          WHERE gp.PriceGroupCode = 'ERA' 
            AND CONVERT(date, DATEADD(hour, @priceHourOffset, GETDATE())) BETWEEN gp.StartDate AND gp.EndDate
          GROUP BY GersSku
       )
	   INSERT  #priceList( ProductGuid, GersSku, RetailPrice, NewPrice, UpgradePrice, AddALinePrice, NoContractPrice, NewPriceAfterRebate, UpgradePriceAfterRebate, AddALinePriceAfterRebate )
	     SELECT DISTINCT product.ProductGuid
		         ,product.GersSku
		        ,retailPrice.Price
				,newPrice.Price
				,upgradePrice.Price
				,addALinePrice.Price
				,noContractPrice.Price
				,newPriceAfterRebate.Price
				,upgradePriceAfterRebate.Price
				,addALinePriceAfterRebate.Price
		   FROM [catalog].[Product] AS product
		        LEFT JOIN [catalog].[GersPrice] AS gp
				  ON product.GersSku = gp.GersSku
		        LEFT JOIN retailPrice
				  ON gp.GersSku = retailPrice.GersSku
				LEFT JOIN newPrice
				  ON gp.GersSku = newPrice.GersSku
				LEFT JOIN upgradePrice
				  ON gp.GersSku = upgradePrice.GersSku
				LEFT JOIN addALinePrice
				  ON gp.GersSku = addALinePrice.GersSku
				LEFT JOIN noContractPrice
				  ON gp.GersSku = noContractPrice.GersSku
				LEFT JOIN newPriceAfterRebate
				  ON gp.GersSKu = newPriceAfterRebate.GersSku
				LEFT JOIN upgradePriceAfterRebate
				  ON gp.GersSku = upgradePriceAfterRebate.GersSku
				LEFT JOIN addALinePriceAfterRebate
				  ON gp.GersSku = addALinePriceAfterRebate.GersSKu
   
   -----------------------------------------------------------------------------------------------
   --
   -- Pivot the required properties.
   --
   -----------------------------------------------------------------------------------------------
   ;WITH deviceFreeAcc( DeviceGuid, Cnt )
   AS
   (
     SELECT DeviceGuid,
	        COUNT(1)
       FROM [catalog].DeviceFreeAccessory dfa WITH (NOLOCK) 
	  WHERE (GETDATE() >= StartDate) 
		AND (GETDATE() <= EndDate)
      GROUP BY DeviceGuid
   ),
   Props( ProductGUID, pageTitle, summaryTitle, detailTitle, sd, ld, mk, md, buyurl, imageurl, bfree )
   AS
   (
     SELECT prop.ProductGUID
          , LTRIM(RTRIM(prop.Value)) AS Expr1
          , LTRIM(RTRIM(prop.Value)) AS Expr2
          , LTRIM(RTRIM(prop.Value)) AS Expr3
          , LTRIM(RTRIM(prop2.Value)) AS sd
          , LTRIM(RTRIM(prop3.Value)) AS ld
          , LTRIM(RTRIM(prop4.Value)) AS mk
          , LTRIM(RTRIM(prop5.Value)) AS md
		  , CAST(LTRIM(RTRIM(prop007.Value)) AS VARCHAR(300)) AS buyurl
		  , CAST(LTRIM(RTRIM(prop008.Value)) AS VARCHAR(300)) AS imageurl
		  , deviceFreeAcc.Cnt AS bfree
      FROM [catalog].[ProductGuid] AS prodGuid
	       JOIN [catalog].[Property] AS prop WITH (nolock) 
		     ON prodGuid.ProductGuid = prop.ProductGuid
	       LEFT JOIN [catalog].[Property] AS prop2 WITH (nolock) 
		     ON prop.ProductGUID = prop2.ProductGUID
		    AND prop2.Name = 'ShortDescription'
		  LEFT JOIN [catalog].[Property] AS prop3 WITH (nolock) 
		    ON prop.ProductGUID = prop3.ProductGUID
		   AND prop3.Name = 'LongDescription'
		  LEFT JOIN [catalog].[Property] AS prop4 WITH (nolock) 
		    ON prop.ProductGUID = prop4.ProductGUID
		   AND prop4.Name = 'MetaKeywords'
		  LEFT JOIN [catalog].[Property] AS prop5 WITH (nolock) 
		    ON prop.ProductGUID = prop5.ProductGUID
		   AND prop5.Name = 'MetaDescription'
		  LEFT JOIN [catalog].[Property] AS prop007 WITH (nolock) 
		    ON prop.ProductGUID = prop007.ProductGUID
		   AND prop007.Name = 'CJ-BuyURL'
		  LEFT JOIN [catalog].[Property] AS prop008 WITH (nolock)
		    ON prop.ProductGUID = prop008.ProductGUID
		   AND prop008.Name = 'CJ-ImageURL'      
		  LEFT JOIN deviceFreeAcc
		    ON prop.ProductGuid = deviceFreeAcc.DeviceGuid
     WHERE prop.Name = 'Title'
   )
   INSERT #propertyList( ProductGUID, PageTitle, SummaryTitle, DetailTitle, SD, LD, MK, MD, BuyURl, ImageUrl, bfree )
    SELECT DISTINCT props.ProductGUID, props.PageTitle, props.SummaryTitle, props.DetailTitle, props.SD, 
	                props.LD, props.MK, props.MD, props.BuyURl, props.ImageUrl, props.bfree
	  FROM Props
	       JOIN [catalog].[ProductGuid] AS prodGuid
		     ON props.ProductGuid = prodGuid.ProductGuid
	WHERE prodGuid.ProductTypeId IN ( 1, 6 )

	   ;WITH deviceList( DeviceGuid, Name, CarrierGuid, UPC, ManufacturerGuid, ManufacturerName, Active, Prepaid )
    AS
	(
	   SELECT DISTINCT TabletGuid, Name, CarrierGuid, UPC, CAST(ManufacturerGuid AS uniqueidentifier), m.CompanyName, p.Active, 0
	     FROM [catalog].[Tablet] as t WITH(nolock)
			  LEFT JOIN [catalog].[Company] AS m 
			    ON t.ManufacturerGuid = m.CompanyGuid
			  LEFT JOIN [catalog].[Product] AS p
			    ON t.TabletGuid = p.ProductGuid
				WHERE p.Active = '1'
	   UNION ALL
	   SELECT DISTINCT DeviceGuid, Name, CarrierGuid, UPC, CAST(ManufacturerGuid AS uniqueidentifier), m.CompanyName, p.Active, CASE WHEN pt.ProductGuid IS NOT NULL THEN 1 ELSE 0 END
	     FROM [catalog].[Device] AS d WITH(nolock)
		 	   LEFT JOIN [catalog].[Company] AS m 
			    ON d.ManufacturerGuid = m.CompanyGuid
			  LEFT JOIN [catalog].[Product] AS p
			    ON d.DeviceGuid = p.ProductGuid
			  LEFT JOIN [catalog].ProductTag AS pt WITH (NOLOCK) 
			    ON p.ProductGuid = pt.ProductGuid
			   AND pt.Tag = 'prepaidphone'
			   WHERE p.Active = '1'
	)
   INSERT #deviceDetail( DeviceGuid, ProductId, GersSku, PageTitle, SummaryTitle, DetailTitle, CarrierId, CarrierName, ManufacturerGuid, ManufacturerName,
                         BFreeAccessory, SummaryDescription, DetailDescription, MetaKeywords, MetaDescription, ReleaseDate, TypeId, UPC,BuyUrl, ImageUrl, 
			             RetailPrice, NewPrice, UpgradePrice, AddALinePrice, NoContractPrice, NewPriceAfterRebate, UpgradePriceAfterRebate, AddALinePriceAfterRebate, 
				         Active, Prepaid, DefaultSortRank )

   SELECT DISTINCT deviceList.DeviceGuid
          , [product].ProductId
		  , #priceList.GersSku
          , ISNULL(Props.PageTitle, deviceList.Name) + ' (' + company.CompanyName + ')' AS PageTitle
		  , ISNULL(props.SummaryTitle, deviceList.Name) AS SummaryTitle
		  , ISNULL(props.DetailTitle, deviceList.Name) AS DetailTitle
		  , company.CarrierId
		  , company.CompanyName
		  , deviceList.ManufacturerGuid
		  , deviceList.ManufacturerName
		  , ISNULL( props.bfree, 0)
		  , props.SD AS SummaryDescription
		  , props.LD AS DetailDescription
		  , props.MK  + ', ' + STUFF(
             (SELECT ', ' + cptg.Tag
                FROM [catalog].ProductTag cptg WITH (NOLOCK)
               WHERE cptg.ProductGuid = deviceList.DeviceGuid
              FOR XML PATH (''))
             , 1, 1, '') AS MetaKeywords
		  , props.MD AS MetaDescription
		  , (SELECT TOP 1 p.Value FROM catalog.Property p WITH (NOLOCK) WHERE Name = 'ReleaseDate' AND p.ProductGuid = deviceList.DeviceGuid) AS ReleaseDate
	      , prodGuid.ProductTypeId AS typeID
	      , deviceList.UPC
		  , props.BuyUrl
 		  , props.ImageUrl
		  , ISNULL(#priceList.RetailPrice,#priceList.NoContractPrice) AS price_retail
		  , #priceList.NewPrice AS price_new
		  , #priceList.UpgradePrice AS price_upgrade
		  , #priceList.AddALinePrice AS price_addaline
          , #priceList.NoContractPrice AS price_nocontract
          , #priceList.NewPriceAfterRebate
		  , #priceList.UpgradePriceAfterRebate
		  , #priceList.AddALinePriceAfterRebate
		  , deviceList.Active
		  , deviceList.Prepaid
		  , ROW_NUMBER() OVER ( ORDER BY sortRanks.EditorsChoiceRank, sortRanks.Sales2WeeksRank, sortRanks.LaunchDateRank) AS DefaultSortRank
     FROM deviceList
	      JOIN [catalog].[SortRanks] AS sortRanks
		    ON deviceList.DeviceGuid = sortRanks.ProductGuid
	      JOIN [catalog].[ProductGuid] AS prodGuid
		   ON deviceList.DeviceGuid = prodGuid.ProductGuid
	      JOIN [catalog].[Product] AS product
		    On deviceList.DeviceGuid = product.ProductGuid
	      LEFT JOIN #propertyList AS props
		    ON deviceList.DeviceGuid = props.ProductGUID
		  LEFT JOIN [catalog].[Company] AS company WITH(nolock)
		    ON deviceList.CarrierGuid = company.CompanyGuid
		   AND company.IsCarrier = 1
		  LEFT JOIN [catalog].[Company] AS manufacturer
		    ON deviceList.ManufacturerGuid =  manufacturer.CompanyGuid
		  LEFT JOIN [catalog].Inventory AS inventory  WITH(nolock)
		    ON product.ProductId = inventory.ProductId
		  LEFT JOIN #priceList
		    ON product.ProductGuid = #priceList.ProductGuid


MERGE [catalog].[DeviceDetail] AS [target]
  USING #deviceDetail AS [source]
    ON [target].[DeviceGuid] = [source].[DeviceGuid]
 WHEN MATCHED THEN
   UPDATE SET [DeviceGuid] = [source].[DeviceGuid]
        , [ProductId] = [source].[ProductId]
		, [GersSku] =  [source].[GersSku]
		, [PageTitle] = [source].[PageTitle]
		, [SummaryTitle] = [source].[SummaryTitle]
		, [DetailTitle] = [source].[DetailTitle]
		, [CarrierId] = [source].[CarrierId]
		, [CarrierName]	= [source].[CarrierName]
		, [ManufacturerGUID] = [source].[ManufacturerGUID]
		, [ManufacturerName] = [source].[ManufacturerName]
		, [BFreeAccessory] = [source].[BFreeAccessory]
		, [SummaryDescription] = [source].[SummaryDescription]
        , [DetailDescription] = [source].[DetailDescription]
		, [MetaKeywords] = [source].[MetaKeywords]
		, [MetaDescription] = [source].[MetaDescription]
		, [ReleaseDate] =[source].[ReleaseDate]
        , [TypeId] =[source].[TypeId]
        , [UPC] =[source].[UPC]
        , [BuyURL] = [source].[BuyURL]
        , [ImageURL] = [source].[ImageURL]
        , [RetailPrice] =[source].[RetailPrice]
        , [NewPrice] =[source].[NewPrice]
        , [UpgradePrice] = [source].[UpgradePrice]
        , [AddALinePrice] = [source].[AddALinePrice]
        , [NoContractPrice]	=[source].[NoContractPrice]
        , [NewPriceAfterRebate] = [source].[NewPriceAfterRebate]
        , [UpgradePriceAfterRebate] = [source].[UpgradePriceAfterRebate]
        , [AddALinePriceAfterRebate] =[source].[AddALinePriceAfterRebate]
        , [DefaultSortRank]	= [source].[DefaultSortRank]
		, [Active] = [source].Active
		, [Prepaid] = [source].[Prepaid]
  WHEN NOT MATCHED THEN
    INSERT ( [DeviceGuid], [ProductId], [GersSku], [PageTitle], [SummaryTitle], [DetailTitle], [CarrierId], [CarrierName], [ManufacturerGUID], [ManufacturerName]
		   , [BFreeAccessory], [SummaryDescription], [DetailDescription], [MetaKeywords], [MetaDescription], [ReleaseDate], [TypeId], [UPC], [BuyURL]
           , [ImageURL], [RetailPrice], [NewPrice], [UpgradePrice], [AddALinePrice], [NoContractPrice], [NewPriceAfterRebate], [UpgradePriceAfterRebate]
		   , [AddALinePriceAfterRebate], [Active], [Prepaid], [DefaultSortRank] )
     VALUES( [DeviceGuid], [ProductId], [GersSku], [PageTitle], [SummaryTitle], [DetailTitle], [CarrierId], [CarrierName], [ManufacturerGUID], [ManufacturerName]
		   , [BFreeAccessory], [SummaryDescription], [DetailDescription], [MetaKeywords], [MetaDescription], [ReleaseDate], [TypeId], [UPC], [BuyURL]
           , [ImageURL], [RetailPrice], [NewPrice], [UpgradePrice], [AddALinePrice], [NoContractPrice], [NewPriceAfterRebate], [UpgradePriceAfterRebate]
		   , [AddALinePriceAfterRebate], [Active], [Prepaid], [DefaultSortRank] );
   --WHEN NOT MATCHED BY SOURCE THEN
     --UPDATE SET [Active] = 0;


END