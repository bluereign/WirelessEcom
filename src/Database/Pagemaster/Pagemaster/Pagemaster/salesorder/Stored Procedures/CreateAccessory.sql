


CREATE  Procedure [salesorder].[CreateAccessory] (  
    @GersSku varchar(9),  
    @UPC varchar(12)='',  
    @Name varchar(67)='',  
    @Company varchar(50)='',  
    @ShortDescription varchar(4000)='',  
    @LongDescription varchar(max)='',  
    @LaunchDate varchar(12)='',  
    @Tag varchar(100)='')  
  
  
  
as  
  
-- =============================================  
-- Author: Greg Montague  
-- Create date: 12/14/2010  
-- Description: Will Add or update Accessories  
-- =============================================  
DECLARE @Guid varchar(50)  
DECLARE @MfgGuid varchar(50)  
SET @Guid=NEWID();  
   
IF NOT EXISTS (SELECT * FROM catalog.Company c WHERE c.CompanyName=@Company)   
 BEGIN  
  PRINT 'COMPANY DOES NOT EXIST!'  
  RETURN  
 END   
ELSE   
 BEGIN  
  SELECT @MfgGuid=c.CompanyGuid FROM catalog.Company c WHERE c.CompanyName=@Company  
  
 END;  
  
IF NOT EXISTS (SELECT * FROM catalog.Product p WHERE p.GersSku=@GersSku)  
 BEGIN  
  INSERT CATALOG.ProductGuid ( ProductGuid, ProductTypeId) VALUES ( @GUID,4)  --New line Added
  INSERT INTO catalog.Product (ProductGuid, GersSku, Active) VALUES(@GUID, @GersSku, 1);  
  --print 'Successfull catalog.Product'
 END   
ELSE  
 BEGIN  
  SELECT @Guid=p.ProductGuid FROM catalog.Product p WHERE p.GersSku = @GersSku  
 END;  
 
  
--IF NOT EXISTS (SELECT * FROM catalog.ProductGuid pg WHERE pg.ProductGuid=@Guid and pg.ProductTypeId=4)  
-- BEGIN  
--  INSERT INTO catalog.ProductGuid VALUES(@GUID, 4);  
--   print 'Successfull catalog.ProductGuid '
-- END  
  
MERGE INTO catalog.Accessory as trg  
USING (SELECT @GUID PrdGuid, @MfgGuid MfgGuid, @UPC Upc, @Name PrdName) as src  
ON trg.AccessoryGuid=src.PrdGuid  
 WHEN NOT MATCHED BY TARGET THEN INSERT (  
  AccessoryGuid,  
  ManufacturerGuid,  
  UPC,  
  Name)  
 VALUES  (@GUID,@MfgGuid,@UPC,@Name)  
 WHEN MATCHED AND (trg.ManufacturerGuid !=src.MfgGuid OR trg.UPC !=src.UPC OR trg.Name !=src.PrdName)   
 THEN UPDATE SET   
  trg.ManufacturerGuid=src.MfgGuid,  
  trg.UPC=src.UPC,  
  trg.Name= src.PrdName;  
  
IF @ShortDescription !=''  
BEGIN   
MERGE INTO catalog.Property as trg  
USING (SELECT @GUID PrdGuid, @ShortDescription SDesc) as src  
ON trg.ProductGuid=src.PrdGuid and trg.Name='shortDescription'  
 WHEN NOT MATCHED BY TARGET THEN INSERT (  
  ProductGuid,  
  IsCustom,  
  LastModifiedDate,  
  LastModifiedBy,  
  Name,  
  Value,  
  Active)  
 VALUES  (src.PrdGuid,  
   1,  
   getdate(),  
   suser_sname(),  
   'shortDescription',  
   src.SDesc,  
   1)  
 WHEN MATCHED AND trg.value !=src.SDesc  
 THEN UPDATE SET   
  trg.LastModifiedDate=getdate(),  
  trg.LastModifiedBy=suser_sname(),  
  trg.Value=src.SDesc,  
  trg.Active=1;  
END   
   
IF @LongDescription !=''  
BEGIN    
MERGE INTO catalog.Property as trg  
USING (SELECT @GUID PrdGuid, @LongDescription LDesc) as src  
ON trg.ProductGuid=src.PrdGuid and trg.Name='longDescription'  
 WHEN NOT MATCHED BY TARGET THEN INSERT (  
  ProductGuid,  
  IsCustom,  
  LastModifiedDate,  
  LastModifiedBy,  
  Name,  
  Value,  
  Active)  
 VALUES  (src.PrdGuid,  
   1,  
   getdate(),  
   suser_sname(),  
   'longDescription',  
   src.LDesc,  
   1)  
 WHEN MATCHED AND trg.value !=src.LDesc  
 THEN UPDATE SET   
  trg.LastModifiedDate=getdate(),  
  trg.LastModifiedBy=suser_sname(),  
  trg.Value=src.LDesc,  
  trg.Active=1;    
END    
  
IF @LaunchDate !=''  
BEGIN  
  
MERGE INTO catalog.Property as trg  
USING (SELECT @GUID PrdGuid, @LaunchDate LaunchDate) as src  
ON trg.ProductGuid=src.PrdGuid and trg.Name='LaunchDate'  
 WHEN NOT MATCHED BY TARGET THEN INSERT (  
  ProductGuid,  
  IsCustom,  
  LastModifiedDate,  
  LastModifiedBy,  
  Name,  
  Value,  
  Active)  
 VALUES  (src.PrdGuid,  
   1,  
   getdate(),  
   suser_sname(),  
   'LaunchDate',  
   src.LaunchDate,  
   1)  
 WHEN MATCHED AND trg.value !=src.LaunchDate  
 THEN UPDATE SET   
  trg.LastModifiedDate=getdate(),  
  trg.LastModifiedBy=suser_sname(),  
  trg.Value=src.LaunchDate,  
  trg.Active=1;   
  
END    
  
  
IF NOT EXISTS (SELECT * FROM catalog.ProductTag pt WHERE pt.ProductGuid=@Guid and pt.Tag=@Tag)  
 BEGIN  
 INSERT INTO catalog.ProductTag VALUES (@GUID, @Tag);  
 END