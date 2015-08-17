
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[orders].[dn_AllPlans]'))
DROP VIEW [orders].[dn_AllPlans]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[catalog].[dn_Plans]'))
DROP VIEW [catalog].[dn_Plans]
GO


ALTER FUNCTION [catalog].[GetRateplanMonthlyFee]
(

    -- Created by Tyson Vanek in March 2010
	-- Edited by Naomi in September 2013 for new Sprint plans
	
	@CarrierId int -- indicate which carrier it is so we know which special fees to apply
	,@CartPlanIdCount int -- count the number of times a specific rateplan is in a cart
	,@LineNumber int -- provide the actual line number
	,@ProductId int -- the productid from the catalog.product table
)
RETURNS money WITH SCHEMABINDING
AS
BEGIN
	DECLARE @PlanType nvarchar(3)
	DECLARE @IncludedLines int
	DECLARE @MaxLines int
	DECLARE @MonthlyFee money
	DECLARE @AdditionalLineFee money
	DECLARE @ReturnFee money
	DECLARE @IsShared bit
	DECLARE @BillCode nvarchar(12)
	
	SELECT
		@PlanType = R.Type
		, @BillCode = R.CarrierBillCode
		, @IncludedLines = R.IncludedLines
		, @MaxLines = R.MaxLines
		, @MonthlyFee = R.MonthlyFee
		, @AdditionalLineFee = R.AdditionalLineFee
		, @IsShared = R.IsShared
	FROM catalog.Product AS P
	INNER JOIN catalog.Rateplan AS R ON P.ProductGuid = R.RateplanGuid
	WHERE
		(P.ProductId = @ProductId);
	
	
	      IF @CarrierId = '299' AND @BillCode = 'LTD1013'
            BEGIN
                  SELECT @ReturnFee = MinAmount FROM catalog.CommissionSKU WHERE CarrierId = @CarrierId AND Lines = @CartPlanIdCount AND RateplanType = 'WAY'
            END
            
      ELSE IF @PlanType <> 'FAM' AND @IsShared <> 1
            BEGIN
                  SELECT @ReturnFee = @MonthlyFee;
            END
      
      ELSE
            BEGIN
                  IF @LineNumber = 1 AND @IncludedLines = 1
                        BEGIN
                              SELECT @ReturnFee = @MonthlyFee + @AdditionalLineFee;
                        END
                  ELSE IF @LineNumber = 1 AND @IncludedLines = 2
                        BEGIN
                              SELECT @ReturnFee = @MonthlyFee;
                        END
                  ELSE IF @LineNumber = 2
                        BEGIN
                              SELECT @ReturnFee = CAST(0 as money);
                        END
                  ELSE
                        BEGIN
                              SELECT @ReturnFee = @AdditionalLineFee;
                        END
            END



	RETURN @ReturnFee
END




GO


ALTER FUNCTION [catalog].[GetRateplanGersSku] 
(
    -- Created by Ron Delzer in March 2010
	-- Edited by Naomi in September 2013 for new Sprint plans
	
	
	@CarrierId int -- indicate which carrier it is so we know which special fees to apply
	,@DeviceType nvarchar(20) -- SmartPhone, FeaturePhone, MobileBroadband
	,@DeviceSku VARCHAR(9) -- the SKU of the device to help identify 3G versus 4G and determine manufacturer
	,@CartPlanIdCount int -- count the number of times a specific rateplan is in a cart
	,@LineNumber int -- provide the actual line number
	,@ProductId int -- the productid from the catalog.product table

)
RETURNS nvarchar(9)
AS
BEGIN


	DECLARE @Manufacturer uniqueidentifier
	DECLARE @CarrierName nvarchar(30)
	DECLARE @PlanType nvarchar(3)
	DECLARE @GersSku nvarchar(9)
	DECLARE @IncludedLines int
	DECLARE @MaxLines int
	DECLARE @MonthlyFee money
	DECLARE @AdditionalLineFee money
	DECLARE @ReturnGersSku nvarchar(9)
	DECLARE @BillCode nvarchar(12)
	DECLARE @Type nvarchar(10)
		
	SELECT
		@CarrierName = C.CompanyName
	,	@BillCode = R.CarrierBillCode
	,	@PlanType = R.Type
	,	@GersSku = P.GersSku
	,	@IncludedLines = R.IncludedLines
	,	@MaxLines = R.MaxLines
	,	@MonthlyFee = R.MonthlyFee
	,	@AdditionalLineFee = R.AdditionalLineFee
	FROM
		catalog.Product AS P
	INNER JOIN
		catalog.Rateplan AS R
			ON P.ProductGuid = R.RateplanGuid
	INNER JOIN
        catalog.Company AS C
			ON R.CarrierGuid = C.CompanyGuid
	WHERE
		(P.ProductId = @ProductId);
	
	SELECT @Manufacturer = d.ManufacturerGuid
		,@Type = (SELECT Value FROM catalog.Property WHERE Name = 'C9043E7D-784B-41CC-B47C-7A482FED1C34' AND productguid = d.DeviceGuid)
	FROM catalog.Device d
	INNER JOIN catalog.product pp ON pp.productguid = d.DeviceGuid
	WHERE (pp.GersSku = @DeviceSku)	
	
	
		IF (@CarrierId = '299' AND @BillCode = 'LTD1013')
		BEGIN 
			SELECT @ReturnGersSku = CommissionSKU
			FROM catalog.CommissionSku
			WHERE CarrierId = @CarrierId AND RateplanType = 'WAY' AND Lines = @CartPlanIdCount;
		END
		
		
	
	IF (@CarrierId = '299' AND @BillCode = 'ALLINPDS')
		BEGIN
			SELECT @ReturnGersSku = GersSKU FROM catalog.product WHERE ProductGuid IN (SELECT RateplanGuid FROM catalog.rateplan WHERE CarrierBillCode = 'ALLINPDS')
		END




	IF ( @CarrierId = '42')
		-- Handle Verizon SKUs based on device
		BEGIN
	SELECT @GersSku = CommissionSku FROM catalog.commissionsku
	WHERE CarrierId = @CarrierId AND ActivationType = 'N';

		END
	ELSE IF ( @PlanType <> N'FAM' AND @CarrierId <> '299')
		SET @ReturnGersSku = @GersSku;
	ELSE
		BEGIN
			IF ( @LineNumber = 1 )
				SET @ReturnGersSku = @GersSku;
				
			ELSE IF ( @LineNumber > 1 AND @LineNumber <= @IncludedLines )
				BEGIN
					IF ( @CarrierId = '109' )
						SET @ReturnGersSku = @GersSku;				
					ELSE IF ( @CarrierName = N'T-Mobile' )
						SET @ReturnGersSku = @GersSku;
						
				END
				
			ELSE IF ( @LineNumber > @IncludedLines AND @LineNumber <= @MaxLines)
				BEGIN
					IF ( @CarrierId = '109' )
						BEGIN
							SELECT @ReturnGersSku = CommissionSku
							FROM catalog.CommissionSKU WHERE CarrierId = @CarrierId AND @AdditionalLineFee BETWEEN MinAmount AND MaxAmount
							AND ActivationType = 'N' AND Lines = '2';

						END
					ELSE IF ( @CarrierId = '128')
						SELECT @ReturnGersSku = CommissionSku
						FROM catalog.CommissionSku WHERE CarrierId = @CarrierId AND Lines = '3';
				END
		END
	-- Return the result of the function
	RETURN @ReturnGersSku
END

GO

CREATE VIEW [catalog].[dn_Plans]
WITH SCHEMABINDING 
AS

SELECT     r.RateplanGuid, p.ProductGuid, p.ProductId AS planId, p.ProductId, p.GersSku, r.CarrierBillCode, ISNULL
                          ((SELECT     LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property
                              WHERE     (Name = 'Title') AND (Value <> '') AND (ProductGuid = r.RateplanGuid)), r.Title) AS PlanName, 
                      CASE WHEN r.[Type] = 'IND' THEN 'individual' WHEN r.[Type] = 'FAM' THEN 'family' WHEN r.[Type] = 'DAT' THEN 'data' ELSE NULL END AS PlanType,
                      r.IsShared, 
                      ISNULL
                          ((SELECT     LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property AS Property_16
                              WHERE     (Name = 'Title') AND (Value <> '') AND (ProductGuid = r.RateplanGuid)), r.Title) AS PageTitle, ISNULL
                          ((SELECT     LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property AS Property_15
                              WHERE     (Name = 'Title') AND (Value <> '') AND (ProductGuid = r.RateplanGuid)), r.Title) AS SummaryTitle, ISNULL
                          ((SELECT     LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property AS Property_14
                              WHERE     (Name = 'Title') AND (Value <> '') AND (ProductGuid = r.RateplanGuid)), r.Title) AS DetailTitle, 1 AS FamilyPlan, c.CompanyName, 
                      c.CompanyName AS CarrierName, c.CarrierId, c.CompanyGuid AS CarrierGuid, 'Do we need carrier small logo?' AS CarrierLogoSmall, 
                      'Do we need carrier medium logo?' AS CarrierLogoMedium, 'Do we need carrier large logo?' AS CarrierLogoLarge, ISNULL
                          ((SELECT     LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property AS Property_13
                              WHERE     (Name = 'ShortDescription') AND (ProductGuid = r.RateplanGuid)), r.Title) AS SummaryDescription, ISNULL
                          ((SELECT     LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property AS Property_12
                              WHERE     (Name = 'LongDescription') AND (ProductGuid = r.RateplanGuid)), r.Title) AS DetailDescription, r.MonthlyFee AS PlanPrice, r.MonthlyFee AS MonthlyFee, r.IncludedLines, r.MaxLines, r.AdditionalLineFee, ISNULL
                          ((SELECT     TOP (1) REPLACE(LTRIM(RTRIM(Value)),'FALSE','0') AS Expr1
                              FROM         catalog.Property AS Property_11
                              WHERE     (Name = 'ca0eebeb-a6cf-40b3-b9bc-b431e20fa356') AND (Value <> '') AND (ProductGuid = r.RateplanGuid)), 0) AS minutes_anytime, ISNULL
                          ((SELECT     TOP (1) LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property AS Property_10
                              WHERE     (Name = '4cd4d055-9503-4b4a-904c-fc6a5cf50956') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) AS minutes_offpeak, 
                      ISNULL
                          ((SELECT     TOP (1) REPLACE(LTRIM(RTRIM(Value)),'FALSE','0') AS Expr1
                              FROM         catalog.Property AS Property_9
                              WHERE     (Name = '20ee37a2-f82a-4fd6-9164-e993ae3912ba') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) AS minutes_mobtomob, 
                      ISNULL
                          ((SELECT     TOP (1) LTRIM(RTRIM(Value)) AS Expr1
                              FROM         catalog.Property AS Property_8
                              WHERE     (Name = 'c1bc81e0-242c-4d0a-a6de-7f7a82fccb79') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) 
                      AS minutes_friendsandfamily, CAST(ISNULL
                          ((SELECT     TOP (1) Value
                              FROM         catalog.Property AS Property_7
                              WHERE     (Name = 'f081eba4-b5c1-4ade-8a03-cd2a8aac8e3c') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) AS bit) 
                      AS unlimited_offpeak, CAST(ISNULL
                          ((SELECT     TOP (1) Value
                              FROM         catalog.Property AS Property_6
                              WHERE     (Name = '101f781e-7f66-4ef3-94ee-58759b526886') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) AS bit) 
                      AS unlimited_mobtomob, CAST(ISNULL
                          ((SELECT     TOP (1) Value
                              FROM         catalog.Property AS Property_5
                              WHERE     (Name = 'f84020d5-3dfd-4244-a125-4801a5b9c122') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) AS bit) 
                      AS unlimited_friendsandfamily, CAST(ISNULL
                          ((SELECT     TOP (1) Value
                              FROM         catalog.Property AS Property_4
                              WHERE     (Name = 'a56b0b8a-65b1-41e2-911f-145a5c1c720a') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) AS bit) AS unlimited_data, 
                      CAST(ISNULL
                          ((SELECT     TOP (1) Value
                              FROM         catalog.Property AS Property_3
                              WHERE     (Name = 'ce632bcb-adf0-4705-a229-4ede08e3c9bd') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) AS bit) 
                      AS unlimited_textmessaging, CAST(ISNULL
                          ((SELECT     TOP (1) Value
                              FROM         catalog.Property AS Property_2
                              WHERE     (Name = '1701ca57-852c-49bb-b8fd-a75d58e5dba0') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) AS bit) 
                      AS free_longdistance, CAST(ISNULL
                          ((SELECT     TOP (1) Value
                              FROM         catalog.Property AS Property_1
                              WHERE     (Name = '93345b9b-9866-4265-bce0-4a32d2ae165e') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) AS bit) AS free_roaming, 
                      CAST(ISNULL
                          ((SELECT     TOP (1) Value
                              FROM         catalog.Property AS Property_1
                              WHERE     (Name = '4497c077-da96-4ff7-b92f-dcffe2b0c464') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) AS VARCHAR(50)) 
                      AS data_limit, CAST(ISNULL
                          ((SELECT     TOP (1) Value
                              FROM         catalog.Property AS Property_1
                              WHERE     (Name = 'CE42C5DA-5473-4E82-AD76-DE4D1D0C47DC') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) AS VARCHAR(50)) 
                      AS additional_data_usage,
                      
                      
                       ISNULL((SELECT TOP 1 py.Value FROM catalog.Property py WHERE Name = 'MetaKeywords' AND py.ProductGuid = p.ProductGuid) + ', ' + STUFF(
             (SELECT ', ' + cptg.Tag
             FROM catalog.ProductTag cptg
             WHERE cptg.ProductGuid = p.ProductGuid
              FOR XML PATH (''))
             , 1, 1, ''),0) AS MetaKeywords,
                      
                       CAST(ISNULL
                          ((SELECT     TOP (1) Value
                              FROM         catalog.Property AS Property_1
                              WHERE     (Name = 'DataLimitGB') AND (Value <> '') AND (ProductGuid = r.RateplanGuid) AND (Active = 1)), 0) AS VARCHAR(50)) 
                      AS DataLimitGb
FROM         catalog.Rateplan AS r INNER JOIN
                      catalog.Company AS c ON r.CarrierGuid = c.CompanyGuid INNER JOIN
                      catalog.Product AS p ON r.RateplanGuid = p.ProductGuid
WHERE     (p.Active = 1)

GO



CREATE VIEW [orders].[dn_AllPlans]
WITH SCHEMABINDING 
AS
SELECT  DISTINCT    p.ProductId, p.GersSku, ISNULL
	((SELECT     LTRIM(RTRIM(Value)) AS Expr1
    FROM         catalog.Property
    WHERE     (Name = 'catalogProductName') AND (Value <> '') AND (ProductGuid = r.RateplanGuid)), r.Title) AS PlanName, c.CompanyName as CarrierName, 
                    r.MonthlyFee AS MonthlyFeex, 'Voice' as PlanType, CarrierBillCode, cast( p.ProductGUID as varchar(40)) as ProductGUID
FROM         catalog.Rateplan AS r INNER JOIN
                      catalog.Company AS c ON r.CarrierGuid = c.CompanyGuid LEFT JOIN
                      catalog.Product AS p ON r.RateplanGuid = p.ProductGuid
WHERE (p.Active = 1) and p.GersSku is not null                     
UNION
SELECT  DISTINCT    p.ProductId, p.GersSku, ISNULL
	((SELECT     LTRIM(RTRIM(Value)) AS Expr1
    FROM         catalog.Property
    WHERE     (Name = 'catalogProductName') AND (Value <> '') AND (ProductGuid = r.ServiceGuid)), r.Title) AS PlanName,
     c.CompanyName as CarrierName,  r.MonthlyFee AS MonthlyFeex, 'Data' as PlanType, CarrierBillCode, cast( p.ProductGUID as varchar(40)) as ProductGUID
FROM         catalog.Service AS r INNER JOIN
                      catalog.Company AS c ON r.CarrierGuid = c.CompanyGuid LEFT JOIN
                      catalog.Product AS p ON r.ServiceGuid = p.ProductGuid
WHERE (p.Active = 1) and p.GersSku is not null                     

GO




CREATE FUNCTION [catalog].[GetWirelessLineCarrierPlanId] 
(
	@DeviceType nvarchar(20) -- SmartPhone, FeaturePhone, MobileBroadband
	,@DeviceSku VARCHAR(9) -- the SKU of the device to help identify 3G versus 4G and determine manufacturer
	,@ProductId int -- the productid from the catalog.product table

)
RETURNS nvarchar(12)
AS
BEGIN



	DECLARE @CarrierId int
	DECLARE @Manufacturer uniqueidentifier
	DECLARE @Type varchar(20)
    DECLARE @BillCode nvarchar(12)
    DECLARE @ReturnCode nvarchar(12)
    
    
    SELECT @BillCode = R.CarrierBillCode
    ,@CarrierId = CC.CarrierId
    FROM catalog.Product AS P INNER JOIN catalog.Rateplan AS R ON P.ProductGuid = R.RateplanGuid
    INNER JOIN catalog.company cc ON cc.companyguid = r.carrierguid
    WHERE (P.ProductId = @ProductId);
	
	SELECT
		@Manufacturer = d.ManufacturerGuid
		,@Type = (SELECT Value FROM catalog.Property WHERE Name = 'C9043E7D-784B-41CC-B47C-7A482FED1C34' AND productguid = d.DeviceGuid)
	FROM catalog.Device d
	INNER JOIN catalog.product pp ON pp.productguid = d.DeviceGuid
	WHERE (pp.GersSku = @DeviceSku)	

		IF (@CarrierId <> '299')
		BEGIN
			SELECT @ReturnCode = @BillCode
		END
		ELSE IF (@CarrierId = '299')
		BEGIN
			IF (@BillCode = 'LTD1013')
				SELECT @ReturnCode = @BillCode
			ELSE IF (@BillCode = 'ALLINPDS')
				BEGIN

					IF (@DeviceType = 'FeaturePhone')
					SELECT @ReturnCode = CommissionSKU FROM catalog.CommissionSku WHERE CarrierId = @CarrierId AND RateplanType = 'IN' AND DeviceType = 'FeaturePhone';
					ELSE IF (@DeviceType = 'SmartPhone' AND @Type IN ('LTE','4G'))
					SELECT @ReturnCode = CommissionSKU FROM catalog.CommissionSKU WHERE CarrierId = @CarrierId AND RateplanType = 'IN' AND DeviceType = 'LTE'
					ELSE IF (@DeviceType = 'SmartPhone' AND @Type IN ('3G'))
					SELECT @ReturnCode = CommissionSKU FROM catalog.CommissionSKU WHERE CarrierId = @CarrierId AND RateplanType = 'IN' AND DeviceType = 'Wimax'
					ELSE IF (@DeviceType = 'SmartPhone' AND @Manufacturer = '067F1470-D20C-4B29-8738-66F5EA380254')
					SELECT @ReturnCode = CommissionSKU FROM catalog.CommissionSKU WHERE CarrierId = @CarrierId AND RateplanType = 'IN' AND DeviceType = 'Blackberry'
				END
		
		END
      RETURN @ReturnCode
END



GO


