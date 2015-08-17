-- Stored Procedure

CREATE Proc   [dbo].[ScriptforSprintLoadProcess_ups]
as
begin

--*************************MARKET **********************************  
DECLARE @TOT INT
SELECT @TOT=COUNT(*) FROM   [TEST.WIRELESSADVOCATES.COM].CataLog.Market
IF  @tot=0
	BEGIN
		INSERT [TEST.WIRELESSADVOCATES.COM].CataLog.Market		SELECT
		'B4088A36-6793-426B-86A4-778B50DE9537' MarketGuid
		,'C9791E1E-ABDA-4088-AEB5-FC5B943BBF5D'  CarrierGuid
		,'ALL' CarrierMarketCode
		,'ALL' CarrierMarketName
END
--*************************** ZipCodeMarket ***************************  
INSERT  [TEST.WIRELESSADVOCATES.COM].catalog.ZipCodeMarket							
SELECT DISTINCT  RIGHT('00000'+ CONVERT(VARCHAR,zip_code),5) AS ZipCode 
		,'B4088A36-6793-426B-86A4-778B50DE9537' MarketGuid FROM load_Coverage LC	
		WHERE Zip_Code NOT IN  ( SELECT ZipCode FROM [TEST.WIRELESSADVOCATES.COM].Catalog.ZipCodeMarket) 
--************************** Rateplan *********************************  


--Insert process	
INSERT  [Rateplan_InsertProcess]
SELECT 
NEWID()[RateplanGuid]
	  , 'C9791E1E-ABDA-4088-AEB5-FC5B943BBF5D'  [CarrierGuid]
	  ,Plan_ID [CarrierBillCode]  
      ,Plan_name [Title]
      ,null [Description]      
      ,	Type=
		case share 
		when 'no' then 'IND'
		when 'YES' then 'FAM'
		end 
      ,service_agreement [ContractTerm]
      ,null includedlines
      ,5 [MaxLines]  
      ,plan_price  [MonthlyFee]
      ,Plan_ID [AdditionalLineBillCode] 
      ,(select otc_price from dbo.Load_One_time_Charges where  
        otc_name='SubsequentActivationFee') AdditionalLineFee 
	  ,(select otc_price from dbo.Load_One_time_Charges where  
		otc_name='InitialActivationFee' ) PrimaryActivationFee
      ,(select otc_price from dbo.Load_One_time_Charges where  
        otc_name='SubsequentActivationFee') SecondaryActivationFee 
       , '0' AS 'IsShared'   
  FROM  load_plans  where load_plans.Plan_Category not like '%business%' and load_plans.plan_network not like '%IDEN%'


---Update Process for the RatePlan

insert [TEST.WIRELESSADVOCATES.COM].catalog.Rateplan
select * from [Rateplan_InsertProcess] where CarrierBillCode not in (select CarrierBillCode from catalog.Rateplan where
CarrierGuid ='C9791E1E-ABDA-4088-AEB5-FC5B943BBF5D')



 UPDATE  [TEST.WIRELESSADVOCATES.COM].catalog.Rateplan
	 SET Title=Rt.Title
	,Type =Rt.Type
	,ContractTerm=Rt.ContractTerm
	,MonthlyFee=Rt.MonthlyFee
	,AdditionalLineBillCode=Rt.AdditionalLineBillCode
	,PrimaryActivationFee=Rt.PrimaryActivationFee
	,SecondaryActivationFee=Rt.SecondaryActivationFee
 FROM [TEST.WIRELESSADVOCATES.COM].catalog.Rateplan ru join [Rateplan_InsertProcess] Rt
 on  Ru.carrierbillcode= Rt.carrierbillcode

----********************* RatePlanMarket *******************************  
--INSERT PROCESS
INSERT [TEST.WIRELESSADVOCATES.COM].catalog.RateplanMarket
SELECT  RateplanGuid,
'B4088A36-6793-426B-86A4-778B50DE9537' MarketGuid
,NULL CarrierPlanReference
FROM [TEST.WIRELESSADVOCATES.COM].catalog.Rateplan  WHERE  CarrierGuid='C9791E1E-ABDA-4088-AEB5-FC5B943BBF5D' 
AND RateplanGuid NOT IN ( SELECT RateplanGuid from [TEST.WIRELESSADVOCATES.COM].catalog.RateplanMarket)

--****************************** Service *******************************  
--INSERT PROCESS
INSERT [SERVICE]
SELECT
 NEWID() ServiceGuid
,'C9791E1E-ABDA-4088-AEB5-FC5B943BBF5D'  CarrierGuid
,null CarrierServiceID 
,Attachable_ID   CarrierBillCode
,attachable_name Title
,attachable_price MonthlyFee
,null CartTypeID 
FROM  load_Attachables LA  WHERE Attachable_ID  NOT IN  (  SELECT CarrierBillCode FROM  [SERVICE]  S
WHERE  S.CarrierBillCode= LA.Attachable_ID )  

insert catalog.ProductGuid
select ServiceGuid,3 productTypeID  from  service where ServiceGuid not in ( select productguid from catalog.productguid)

--Update Process for Service

UPDATE  Service
SET title=la.attachable_name
,MonthlyFee =LA.Attachable_price
FROM  load_Attachables  LA  INNER JOIN Service  s ON  s.CarrierBillCode=LA.Attachable_ID
AND s.CarrierGuid='C9791E1E-ABDA-4088-AEB5-FC5B943BBF5D'

INSERT [TEST.WIRELESSADVOCATES.COM].catalog.Service 
SELECT ServiceGuid,CarrierGuid, CarrierServiceID, CarrierBillCode,Title,MonthlyFee,CartTypeId
FROM Service   WHERE 
CarrierBillCode NOT  in (
SELECT CarrierBillCode from [TEST.WIRELESSADVOCATES.COM].catalog.Service  WHERE  CarrierBillCode= service.CarrierBillCode )


--UPDATE PROCESS FOR SERVICE
UPDATE  [TEST.WIRELESSADVOCATES.COM].catalog.[SERVICE]
set title=la.title
,MonthlyFee=la.MonthlyFee 
FROM  [SERVICE] LA INNER JOIN [TEST.WIRELESSADVOCATES.COM].catalog.[SERVICE] SU on  su.carrierbillcode=LA.carrierbillcode
WHERE su.CarrierGuid='C9791E1E-ABDA-4088-AEB5-FC5B943BBF5D' 



--************** ********** Device ***************************************
--INSERT DEVICE
INSERT  Device 
SELECT NEWID() DeviceGuid
, 'C9791E1E-ABDA-4088-AEB5-FC5B943BBF5D' CarrierGuid 
,NEWID() ManuFacturerGuid
,phone_UPC UPC
,Phone_name [Name]
,Phone_id
FROM Load_Phones  LP 
WHERE  LP.phone_UPC NOT IN ( SELECT   d.UPC FROM Device  D)

insert catalog.ProductGuid
select DeviceGuid,1 productTypeID  from  Device where DeviceGuid not in ( select productguid from catalog.productguid)

--UPDATE DEVICE
UPDATE  Device
SET UPC=LP.phone_upc
,Name =LP.Phone_name
FROM  Load_Phones  LP  INNER JOIN Device  D ON LP.phone_UPC=D.UPC
WHERE  LP.phone_UPC  IN ( SELECT   d.UPC FROM Device  D )
AND d.CarrierGuid='C9791E1E-ABDA-4088-AEB5-FC5B943BBF5D'

INSERT [TEST.WIRELESSADVOCATES.COM].catalog.Device
SELECT DeviceGuid,CarrierGuid, ManuFacturerGuid, UPC,[Name]
FROM Device   WHERE 
UPC NOT  in (
SELECT UPC from [TEST.WIRELESSADVOCATES.COM].catalog.Device  WHERE  carrierguid= Device.carrierguid 
AND name=Device.name)

UPDATE  [TEST.WIRELESSADVOCATES.COM].catalog.Device 
SET UPC=D.UPC
,Name =D.Name
FROM  Device  D  INNER JOIN [TEST.WIRELESSADVOCATES.COM].catalog.Device  DD ON d.UPC=DD.UPC
WHERE  d.UPC  IN ( SELECT   DD.UPC FROM [TEST.WIRELESSADVOCATES.COM].catalog.Device  DD )
AND d.CarrierGuid='C9791E1E-ABDA-4088-AEB5-FC5B943BBF5D'

--******************** DeviceService*************************************  
---DELETE PROCESS
DELETE FROM [TEST.WIRELESSADVOCATES.COM].catalog.DeviceService
WHERE DeviceGuid IN (    
SELECT  d.DeviceGuid  from [TEST.WIRELESSADVOCATES.COM].catalog.Device d join  [TEST.WIRELESSADVOCATES.COM].catalog.Service s
on d.CarrierGuid= s.CarrierGuid  
where  d.DeviceGuid   in ( select DeviceGuid from [TEST.WIRELESSADVOCATES.COM].catalog.DeviceService)
and   s.ServiceGuid   in ( select ServiceGuid from [TEST.WIRELESSADVOCATES.COM].catalog.DeviceService)
and d.CarrierGuid='C9791E1E-ABDA-4088-AEB5-FC5B943BBF5D'
and s.CarrierGuid='C9791E1E-ABDA-4088-AEB5-FC5B943BBF5D')

---- INSERT [TEST.WIRELESSADVOCATES.COM].catalog.DeviceService
INSERT [TEST.WIRELESSADVOCATES.COM].catalog.DeviceService
SELECT DISTINCT d.DeviceGuid, s.ServiceGuid,0 IsDefault 
FROM Load_Phones p
INNER JOIN  Load_Phone_Attachable  ps ON ps.phone_id = p.phone_id
INNER JOIN load_Attachables a ON a.attachable_id = ps.attachable_id
INNER JOIN [TEST.WIRELESSADVOCATES.COM].catalog.Device d ON d.upc = p.phone_upc
INNER JOIN [TEST.WIRELESSADVOCATES.COM].catalog.Service s ON s.CarrierBillCode = a.attachable_id

---*******************RatePlanService************************************  
DELETE FROM  [TEST.WIRELESSADVOCATES.COM].catalog.RateplanService  
where RateplanGuid in(  SELECT P.RateplanGuid from [TEST.WIRELESSADVOCATES.COM].catalog.Service S join [TEST.WIRELESSADVOCATES.COM].catalog.Rateplan  P
on S.CarrierGuid= P.CarrierGuid 
where   S.CarrierGuid='C9791E1E-ABDA-4088-AEB5-FC5B943BBF5D'
and P.CarrierGuid='C9791E1E-ABDA-4088-AEB5-FC5B943BBF5D')  

INSERT [TEST.WIRELESSADVOCATES.COM].catalog.RatePlanService
SELECT rp.RateplanGuid, s.ServiceGuid,0 IsIncluded, 0 IsRequired, 0 IsDefault 
FROM Load_Plans p
INNER JOIN Load_Plan_Attachable ps ON ps.Plan_id = p.plan_id
INNER JOIN Load_Attachables a ON a.attachable_id = ps.attachable_id
INNER JOIN [TEST.WIRELESSADVOCATES.COM].catalog.Rateplan rp ON rp.CarrierBillCode = p.plan_id
INNER JOIN [TEST.WIRELESSADVOCATES.COM].catalog.Service s ON s.CarrierBillCode = a.attachable_id

---******************RatePlanDevice*********************************
DELETE  FROM [TEST.WIRELESSADVOCATES.COM].catalog.RateplanDevice    
where RateplanGuid in(  SELECT  P.RateplanGuid   from [TEST.WIRELESSADVOCATES.COM].catalog.Device d 
INNER JOIN [TEST.WIRELESSADVOCATES.COM].catalog.Rateplan  P
on d.CarrierGuid= P.CarrierGuid
where  
d.CarrierGuid='C9791E1E-ABDA-4088-AEB5-FC5B943BBF5D'
and P.CarrierGuid='C9791E1E-ABDA-4088-AEB5-FC5B943BBF5D')

--INSERT RatePlanDevice

INSERT [TEST.WIRELESSADVOCATES.COM].catalog.RatePlanDevice
SELECT DISTINCT r.RatePlanGuid, d.DeviceGuid,0 IsDefaultRateplan  from Load_Phones  p 
INNER JOIN Load_Phone_plan  LPP on  LPP.phone_id=p.phone_id
INNER JOIN  Load_plans LP  on  LP.plan_id=LPP.plan_id
INNER JOIN CATALOG.Rateplan r on r.CarrierBillCode=lp.plan_id
INNER JOIN Device d on d.Phone_ID=LPP.phone_id

end