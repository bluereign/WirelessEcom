/*-- =============================================
-- Author:		Ron Delzer
-- Create date: 3/26/2010
-- Description:	
-- =============================================
CREATE FUNCTION GetUpgradeGersSkuUsingXmlData 
(
	@referenceNumber varchar(30)
)
RETURNS nvarchar(9)
AS
BEGIN
-- Get Upgrade GERS SKU using Rateplan data from XML

DECLARE @requestXml AS XML ;
DECLARE @carrier VARCHAR(30);
DECLARE @CarrierId int;
DECLARE @RateplanType nvarchar(3);
DECLARE @LineType nvarchar(3);
DECLARE @MonthlyFee money;


SELECT TOP 1 @carrier = carrier 
FROM service.CarrierInterfaceLog 
WHERE referenceNumber = @referenceNumber ;

IF @carrier = 'Att'
BEGIN
	DECLARE @mdn varchar(10);
	DECLARE @IsFamily bit;
	DECLARE @IsPrimary bit;

	-- get the record containing the mdn and pin
	SELECT	TOP 1 @requestXML = [DATA] 
	FROM	service.CarrierInterfaceLog 
	WHERE	ReferenceNumber = @referenceNumber
	AND		RequestType = 'CustomerLookupByMdn'
	AND		Carrier = @carrier
	AND		[Type] = 'Request'
	ORDER BY  id DESC;
	
	-- query for the mdn
	SET @mdn = CONVERT(varchar(10),@requestXml.query('declare namespace att1="http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireAccountProfileRequest.xsd"; 
                                                      declare namespace att2="http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd";
                                                      (/InquireAccountProfileRequestInfo/att1:AccountSelector/att2:subscriberNumber/text())'));

	-- get the response record
	SELECT	TOP 1 @requestXML=[DATA]
	FROM	service.CarrierInterfaceLog 
	WHERE	ReferenceNumber = @referenceNumber
	AND		RequestType = 'CustomerLookupByMdn'
	AND		Carrier = @carrier
	AND		[Type] = 'Response'
	ORDER BY  id DESC;

	-- Check for family plan
	SET @IsFamily = @requestXml.exist('declare namespace att1="http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireAccountProfileResponse.xsd"; 
                                       declare namespace att2="http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireSubscriberProfileResponse.xsd";
                                       declare namespace att3="http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd";
                                       /InquireAccountProfileResponseInfo/att1:Account/att1:Subscriber/att2:Subscriber/att2:PricePlan/att3:groupPlanDetails');
	
	IF (@IsFamily=1)
		BEGIN
			SET @RateplanType='FAM';

			SET @IsPrimary = CONVERT(bit,CONVERT(varchar, @requestXml.query('declare namespace att1="http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireAccountProfileResponse.xsd"; 
                                                declare namespace att2="http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireSubscriberProfileResponse.xsd";
                                                declare namespace att3="http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd";
                                                data(/InquireAccountProfileResponseInfo/att1:Account/att1:Subscriber/att2:Subscriber[att2:subscriberNumber=sql:variable("@mdn")]/att2:PricePlan/att3:groupPlanDetails/att3:primarySubscriber/text())')));

			IF (@IsPrimary = 1)
				BEGIN
					SET @LineType='PRI'
					
					SET @MonthlyFee=CONVERT(money,CONVERT(varchar, @requestXml.query('declare namespace att1="http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireAccountProfileResponse.xsd"; 
                                                declare namespace att2="http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireSubscriberProfileResponse.xsd";
                                                declare namespace att3="http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd";
                                                data(/InquireAccountProfileResponseInfo/att1:Account/att1:Subscriber/att2:Subscriber[att2:subscriberNumber=sql:variable("@mdn")]/att2:PricePlan/att3:recurringCharge/text())')));
				END
			ELSE
				BEGIN
					SET @LineType='ADD'
					
					SET @MonthlyFee=CONVERT(money,CONVERT(varchar, @requestXml.query('declare namespace att1="http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireAccountProfileResponse.xsd"; 
                                                declare namespace att2="http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireSubscriberProfileResponse.xsd";
                                                declare namespace att3="http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd";
                                                data(/InquireAccountProfileResponseInfo/att1:Account/att1:Subscriber/att2:Subscriber[att2:subscriberNumber=sql:variable("@mdn")]/att2:PricePlan/att3:groupPlanDetails/att3:additionalLineCharge/text())')));
				END
		END
	ELSE
		BEGIN
			SET @RateplanType='IND'
			SET @LineType='PRI'

			SET @MonthlyFee=CONVERT(money,CONVERT(varchar, @requestXml.query('declare namespace att1="http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireAccountProfileResponse.xsd"; 
                                        declare namespace att2="http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireSubscriberProfileResponse.xsd";
                                        declare namespace att3="http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd";
                                        data(/InquireAccountProfileResponseInfo/att1:Account/att1:Subscriber/att2:Subscriber[att2:subscriberNumber=sql:variable("@mdn")]/att2:PricePlan/att3:recurringCharge/text())')));

		END
	
	SET @CarrierId=109;
	
END	

IF @carrier = 'TMobile'
BEGIN 
	DECLARE @TmoPlanType varchar(30)


	SELECT	TOP 1 @requestXML = [DATA] 
	FROM	service.CarrierInterfaceLog 
	WHERE	ReferenceNumber = @referenceNumber
	AND		RequestType = 'ServiceCustomerLookup'
	AND		Carrier = @carrier
	AND		[Type] = 'Response'
	ORDER BY id DESC
	
	-- query for the mdn
	SET @TmoPlanType = convert(varchar,@requestXml.query('declare namespace tmo="http://retail.tmobile.com/sdo";
	data(/CustomerLookupByMSISDNResponse/tmo:subscriberDetails/tmo:ratePlan/tmo:rateplanInfo/tmo:planType)'))
	
	SET @CarrierId=128;
	SET @LineType=''
	SET @MonthlyFee=0
	
	IF @TmoPlanType='NON_POOLING'
		SET @RateplanType='IND'
	ELSE IF @TmoPlanType='POOLING'
		SET @RateplanType='FAM'
END


	RETURN catalog.GetUpgradeCommissionSku(@CarrierId,@RateplanType,@LineType,@MonthlyFee)

END*/
