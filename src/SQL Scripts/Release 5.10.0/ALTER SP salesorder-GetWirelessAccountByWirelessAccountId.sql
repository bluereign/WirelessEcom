

/****** Object:  StoredProcedure [salesorder].[GetWirelessAccountByWirelessAccountId]    Script Date: 04/10/2014 16:42:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER Procedure [salesorder].[GetWirelessAccountByWirelessAccountId]
(
	@WirelessAccountId AS INT  
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
		  ,[ActivationDate]
		  ,[CarrierTermsTimeStamp]
		  ,[AccountPassword]
		  ,[AccountZipCode]
		  ,[ActivatedById]	  
          ,[SelectedSecurityQuestionId]
          ,[SecurityQuestionAnswer] 		  
          ,[LastFourSsn]
		  , CONVERT(varchar, DecryptByKey(EncryptedSSN)) SSN
		  , CONVERT(varchar, DecryptByKey(EncryptedDrvLicNumber)) DrvLicNumber		 	  
	  FROM salesorder.WirelessAccount
	  WHERE WirelessAccountId  = @WirelessAccountId


CLOSE SYMMETRIC KEY WAKey










GO


