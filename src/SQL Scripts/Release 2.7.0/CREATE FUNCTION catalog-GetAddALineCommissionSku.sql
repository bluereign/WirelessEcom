/****** Object:  UserDefinedFunction [catalog].[GetAddALineCommissionSku]    Script Date: 02/01/2012 14:14:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		Ron Delzer
-- Create date: 3/12/2010
-- Description:	
-- =============================================
CREATE FUNCTION [catalog].[GetAddALineCommissionSku] 
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
			IF (@MonthlyFee < 49.99) SET @GersSku='CW2VZADD'; -- Currently on limited minute plan
			ELSE SET @GersSku='CW2VZADU'; -- Currently on unlimited plan
		END
	ELSE IF (@CarrierName='Sprint')
		BEGIN
			SET @GersSku='CWS2YSPAD';
		END
	
	
	RETURN @GersSku;
END












GO


