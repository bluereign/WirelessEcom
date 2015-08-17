



CREATE PROCEDURE [cjtmo].[ImportFullCatalog]
AS

BEGIN
    SET NOCOUNT ON;
    DECLARE @trancount int;
    SET @trancount = @@trancount;
    BEGIN TRY
        IF @trancount = 0
            BEGIN TRANSACTION
              else
            save transaction savetest;





MERGE catalog.GersItm AS TARGET
USING (SELECT DISTINCT
			p.GersSku
			,'CJTM' AS 'VendorCode'
			,'128' AS 'MajorCode'
			,'TM' AS 'MinorCode'
			,'TMO' AS 'ItemTypeCode'
			,d.UPC AS 'VendorStockNumber'
			,MAX(gp.Comment) AS 'Description'
		FROM cjtmo.Product p
		INNER JOIN cjtmo.Device d ON d.deviceguid = p.productguid
		INNER JOIN cjtmo.GersPrice gp ON gp.GersSku = p.GersSku
		GROUP BY p.GersSku,d.UPC) AS SOURCE
ON TARGET.GersSku = SOURCE.GersSku
WHEN MATCHED THEN
UPDATE SET
	TARGET.Description = SOURCE.Description
WHEN NOT MATCHED BY TARGET THEN
INSERT (GersSku,VendorCode,MajorCode,MinorCode,ItemTypeCode,VendorStockNumber,Description)
VALUES (SOURCE.GersSku,SOURCE.VendorCode,SOURCE.MajorCode,SOURCE.MinorCode,SOURCE.ItemTypeCode,SOURCE.VendorStockNumber,SOURCE.Description);



MERGE catalog.ProductGuid AS TARGET
USING (SELECT
			ProductGuid
			,ProductTypeId
		FROM cjtmo.ProductGuid) AS SOURCE
ON TARGET.ProductGuid = SOURCE.ProductGuid
WHEN MATCHED THEN
UPDATE SET
	TARGET.ProductTypeId = SOURCE.ProductTypeId
WHEN NOT MATCHED BY TARGET THEN
INSERT (ProductGuid,ProductTypeId)
VALUES (SOURCE.ProductGuid, SOURCE.ProductTypeId);

SET IDENTITY_INSERT [catalog].[Product] ON;


DELETE FROM catalog.Product where productguid in (
select productguid from catalog.product where gerssku LIKE 'T%' AND Active ='1'
)

DELETE FROM catalog.Product where productid in (
select productid from cjtmo.Product
)

INSERT INTO catalog.Product (ProductId, ProductGuid, GersSku, Active)
	SELECT DISTINCT
			ProductId
			,ProductGuid
			,GersSku
			,Active
		FROM cjtmo.Product

SET IDENTITY_INSERT catalog.Product OFF;

MERGE catalog.ProductTag AS TARGET
USING (SELECT
			ProductGuid
			,Tag
		FROM cjtmo.ProductTag) AS SOURCE
ON TARGET.ProductGuid = SOURCE.ProductGuid AND TARGET.Tag = SOURCE.Tag
WHEN MATCHED THEN
UPDATE SET
	TARGET.Tag = SOURCE.Tag
WHEN NOT MATCHED BY TARGET THEN
INSERT (ProductGuid,Tag)
VALUES (SOURCE.ProductGuid, SOURCE.Tag);

DELETE FROM catalog.Device WHERE UPC IN (SELECT UPC FROM cjtmo.Device)

MERGE catalog.Device AS TARGET
USING (SELECT DISTINCT
			DeviceGuid
			,CarrierGuid
			,ManufacturerGuid
			,UPC
			,Name
		FROM cjtmo.Device
		) AS SOURCE
ON TARGET.DeviceGuid = SOURCE.DeviceGuid
WHEN MATCHED THEN
UPDATE SET
	TARGET.UPC = SOURCE.UPC
	,TARGET.ManufacturerGuid = SOURCE.ManufacturerGuid
	,TARGET.Name = SOURCE.Name
WHEN NOT MATCHED BY TARGET THEN
INSERT (DeviceGuid,CarrierGuid,ManufacturerGuid,UPC,Name)
VALUES (SOURCE.DeviceGuid, SOURCE.CarrierGuid, SOURCE.ManufacturerGuid, SOURCE.UPC, SOURCE.Name);

DELETE FROM catalog.property WHERE ProductGuid IN (SELECT DeviceGuid FROM catalog.Device WHERE CarrierGuid = '84C15B47-C976-4403-A7C4-80ABA6EEC189')

INSERT INTO catalog.property (ProductGuid, Name, Value, LastModifiedBy,LastModifiedDate,IsCustom,Active)
SELECT ProductGuid, Name, MAX(Value), MAX(LastModifiedBy),MAX(LastModifiedDate),IsCustom,Active FROM cjtmo.Property GROUP BY ProductGuid, Name,IsCustom,Active

MERGE catalog.GersPrice AS TARGET
USING (SELECT
			GersSku
			,PriceGroupCode
			,Price
			,StartDate
			,EndDate
			,Comment
		FROM cjtmo.GersPrice
		) AS SOURCE
ON TARGET.GersSku = SOURCE.GersSku AND TARGET.PriceGroupCode = SOURCE.PriceGroupCode 
WHEN MATCHED THEN
UPDATE SET
	TARGET.Price = SOURCE.Price
	,TARGET.Comment = SOURCE.Comment
WHEN NOT MATCHED BY TARGET THEN
INSERT (GersSku, PriceGroupCode, Price, StartDate, EndDate, Comment)
VALUES (SOURCE.GersSku, SOURCE.PriceGroupCode, SOURCE.Price, SOURCE.StartDate, SOURCE.EndDate, SOURCE.Comment);

UPDATE catalog.property
SET Value = ''
WHERE Name = 'ShortDescription' AND ProductGuid IN (SELECT ProductGuid FROM cjtmo.ProductGuid)

        IF @trancount = 0   
            COMMIT;


DECLARE @Messaging nvarchar(1000)
SELECT @Messaging = 'Errors encountered: ' + CONVERT(NVARCHAR,@trancount)


DECLARE @table AS TABLE(Emp_Email NVARCHAR(100), ID int IDENTITY(1,1))

--populate the above table
INSERT @table (Emp_Email) VALUES('nhall@wirelessadvocates.com')
INSERT @table (Emp_Email) VALUES('smorrow@wirelessadvocates.com')
INSERT @table (Emp_Email) VALUES('naomirocks@gmail.com')

DECLARE @count AS int
SET @count =1 --initialize the count parameter
DECLARE @Recepient_Email AS VARCHAR(100)
WHILE (@count <=(SELECT COUNT(*) FROM @table))
        BEGIN
        SET @Recepient_Email =(SELECT TOP(1) Emp_Email FROM @table WHERE ID=@count)
        EXEC msdb.dbo.sp_send_dbmail
            @recipients=@Recepient_Email,            
			@body= @Messaging,
			@body_format = 'HTML',
			@subject ='T-Mobile: CJ Catalog AAFES Test DB Import Status',
			@profile_name ='Default'
            SET @count = @count + 1
            END 



    END TRY
    BEGIN CATCH
        DECLARE @error int, @message varchar(4000), @xstate int;
        SELECT @error = ERROR_NUMBER(), @message = ERROR_MESSAGE(), @xstate = XACT_STATE();
        IF @xstate = -1
            rollback;
        IF @xstate = 1 and @trancount = 0
            rollback
        IF @xstate = 1 and @trancount > 0
            rollback transaction usp_my_procedure_name;



        RAISERROR ('IMPORTINGCATALOG: %d: %s', 16, 1, @error, @message) ;

DECLARE @Messaging2 nvarchar(1000)
SELECT @Messaging2 = 'RAISERROR (''IMPORTINGCATALOG: %d: %s'', 16, 1, ' + convert(nvarchar,@error) +', ' + @message +') ;'


DECLARE @table2 AS TABLE(Emp_Email NVARCHAR(100), ID int IDENTITY(1,1))

--populate the above table
INSERT @table (Emp_Email) VALUES('nhall@wirelessadvocates.com')
INSERT @table (Emp_Email) VALUES('smorrow@wirelessadvocates.com')
INSERT @table (Emp_Email) VALUES('naomirocks@gmail.com')

DECLARE @count2 AS int
SET @count2 =1 --initialize the count parameter
DECLARE @Recepient_Email2 AS VARCHAR(100)
WHILE (@count2 <=(SELECT COUNT(*) FROM @table2))
        BEGIN
        SET @Recepient_Email =(SELECT TOP(1) Emp_Email FROM @table2 WHERE ID=@count2)
        EXEC msdb.dbo.sp_send_dbmail
            @recipients=@Recepient_Email2,            
			@body= @Messaging2,
			@body_format = 'HTML',
			@subject ='T-Mobile: CJ Catalog AAFES Test DB Import Status',
			@profile_name ='Default'
            SET @count2 = @count2 + 1
            END 




    END CATCH
END