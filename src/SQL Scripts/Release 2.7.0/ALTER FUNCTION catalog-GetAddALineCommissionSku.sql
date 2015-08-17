USE [TEST.WIRELESSADVOCATES.COM]
GO

/****** Object:  UserDefinedFunction [catalog].[GetAddALineCommissionSku]    Script Date: 02/07/2012 15:50:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		Ron Delzer
-- Create date: 3/12/2010
-- Description:	
-- =============================================
ALTER FUNCTION [catalog].[GetAddALineCommissionSku] 
(
	-- Add the parameters for the function here
	@CarrierId		int,
	@RateplanType	nvarchar(3), --FAM, IND, DAT
	@MonthlyFee		money
)
RETURNS nvarchar(9)
AS
BEGIN
	DECLARE @CarrierName nvarchar(30)
	DECLARE @GersSku nvarchar(9)
	
	SELECT @CarrierName=CompanyName FROM catalog.Company WHERE CarrierId=@CarrierId;

	IF (@CarrierName = 'AT&T')
		BEGIN
			IF (@MonthlyFee < 49.99) SET @GersSku='CWSATT2AD'; -- Currently on limited minute plan
			ELSE SET @GersSku='CWSATT2AU'; -- Currently on unlimited plan
		END
	ELSE IF (@CarrierName='T-Mobile')
		BEGIN
			SET @GersSku='CWS2YTMAD';
		END
	ELSE IF (@CarrierName='Verizon Wireless')
		BEGIN
			SET @GersSku='CWSVZAB1'; -- Cannot currently distinguish between limited and unlimited ALB lines
		END
	ELSE IF (@CarrierName='Sprint')
		BEGIN
			SET @GersSku='CWS2YSPAD';
		END
	
	
	RETURN @GersSku;
END












GO


