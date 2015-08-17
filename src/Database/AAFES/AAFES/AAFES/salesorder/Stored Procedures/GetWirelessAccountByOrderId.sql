﻿




CREATE Procedure [salesorder].[GetWirelessAccountByOrderId]
(
	@OrderId AS INT  
)
AS

	OPEN SYMMETRIC KEY WAKey DECRYPTION BY CERTIFICATE WACert

	SELECT [WirelessAccountId]
		  ,[OrderId]
		  ,[FamilyPlan]
		  ,[CarrierOrderDate]
		  ,[DOB]
		  ,[DrvLicState]
		  ,[DrvLicExpiry]
		  ,[FirstName]
		  ,[Initial]
		  ,[LastName]
		  ,[CarrierOrderId]
		  ,[CurrentAcctNumber]
		  ,[CurrentAcctPIN]
		  ,[CurrentTotalLines]
		  ,[CurrentPlanType]
		  ,[CreditCode]
		  ,[MaxLinesAllowed]
		  ,[DepositReq]
		  ,[DepositAccept]
		  ,[DepositTypeId]
		  ,[DepositId]
		  ,[DepositAmount]
		  ,[ActivationAmount]
		  ,[PrePayId]
		  ,[PrePayAmount]
		  ,[NewAccountNo]
		  ,[NewAccountType]
		  ,[BillCycleDate]
		  ,[CarrierStatus]
		  ,[CarrierStatusDate]
		  ,[CarrierId]
		  ,[ActivationStatus]
		  ,[CarrierTermsTimeStamp]
		  ,[CarrierTermsTimeStamp]
		  ,[AccountPassword]
		  ,[AccountZipCode]
		  , CONVERT(varchar, DecryptByKey(EncryptedSSN)) SSN
		  , CONVERT(varchar, DecryptByKey(EncryptedDrvLicNumber)) DrvLicNumber
	FROM salesorder.WirelessAccount
	WHERE OrderId  = @OrderId
	CLOSE SYMMETRIC KEY WAKey