

CREATE PROC [catalog].[UpdateDevicePrice]( @priceHourOffset INT = 0 )
AS
/******************************************************************************************
*
*  Object: [UpdateDeviceDetail]
*  Schema: catalog
*
*  Example Call:

		-- Run the SPROC
		EXEC [catalog].[UpdateDevicePrice]
		
		SELECT * FROM [catalog].[DevicePrice]


*  Purpose: Updates the [catalog].[DeviceDetail] lookup table. This should be pushed into a
*           web cache.
*
*  Date             User          Detail
*  11/12/2014       rdelzer      Create new sproc, split out price functionality from [catalog].[UpdateDeviceDetail]
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
	;					  
   
   -----------------------------------------------------------------------------------------------
   --
   -- Pivot the Price data for each sku
   --
   -----------------------------------------------------------------------------------------------
   WITH retailPrice( GersSku, Price )
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
	;
	   
MERGE [catalog].[DevicePrice] AS [target]
  USING #priceList AS [source]
    ON [target].[DeviceGuid] = [source].[ProductGuid]
 WHEN MATCHED THEN
   UPDATE SET [DeviceGuid] = [source].[ProductGuid]
        , [RetailPrice] = COALESCE([source].[RetailPrice], [source].[NoContractPrice])
        , [NewPrice] =[source].[NewPrice]
        , [UpgradePrice] = [source].[UpgradePrice]
        , [AddALinePrice] = [source].[AddALinePrice]
        , [NoContractPrice]	=[source].[NoContractPrice]
        , [NewPriceAfterRebate] = [source].[NewPriceAfterRebate]
        , [UpgradePriceAfterRebate] = [source].[UpgradePriceAfterRebate]
        , [AddALinePriceAfterRebate] =[source].[AddALinePriceAfterRebate]
  WHEN NOT MATCHED THEN
    INSERT ( [DeviceGuid], [RetailPrice], [NewPrice], [UpgradePrice], [AddALinePrice], [NoContractPrice], [NewPriceAfterRebate], [UpgradePriceAfterRebate]
		   , [AddALinePriceAfterRebate] )
     VALUES( [ProductGuid], [RetailPrice], [NewPrice], [UpgradePrice], [AddALinePrice], [NoContractPrice], [NewPriceAfterRebate], [UpgradePriceAfterRebate]
		   , [AddALinePriceAfterRebate] )
   WHEN NOT MATCHED BY SOURCE THEN
     DELETE
;


END