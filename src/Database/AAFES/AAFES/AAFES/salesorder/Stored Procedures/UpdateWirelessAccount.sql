

CREATE PROCEDURE [salesorder].[UpdateWirelessAccount]
(
			@WirelessAccountId AS int
		   ,@OrderId AS int
           ,@FamilyPlan AS smallint = NULL
           ,@CarrierOrderDate AS datetime = NULL
           ,@SSN AS varchar(11) = NULL
           ,@DOB AS datetime = NULL
           ,@DrvLicNumber AS varchar(20) = NULL
           ,@DrvLicState AS varchar(2) = NULL
           ,@DrvLicExpiry AS datetime = NULL
           ,@FirstName AS nvarchar(50) = NULL
           ,@Initial AS nvarchar(50) = NULL
           ,@LastName AS nvarchar(50) = NULL
           ,@CarrierOrderId AS varchar(30) = NULL
           ,@CurrentAcctNumber AS varchar(20) = NULL
           ,@CurrentAcctPIN AS varchar(10) = NULL
           ,@CurrentTotalLines AS int = NULL
           ,@CurrentPlanType AS varchar(10) = NULL
           ,@CreditCode AS varchar(10) = NULL
           ,@MaxLinesAllowed AS int = NULL
           ,@DepositReq AS bit = NULL
           ,@DepositAccept AS bit = NULL
           ,@DepositTypeId AS int = NULL
           ,@DepositId AS varchar(10) = NULL
           ,@DepositAmount AS money = NULL
           ,@ActivationAmount AS money = NULL
           ,@PrePayId AS varchar(10) = NULL
           ,@PrePayAmount AS money = NULL
           ,@NewAccountNo AS varchar(10) = NULL
           ,@NewAccountType AS varchar(50) = NULL
           ,@BillCycleDate AS datetime = NULL
           ,@CarrierStatus AS varchar(20) = NULL
           ,@CarrierStatusDate AS datetime = NULL
           ,@CarrierId AS int = NULL
           ,@ActivationStatus AS int = NULL
           ,@ActivationDate AS datetime = NULL
           ,@CarrierTermsTimeStamp AS datetime = NULL
           ,@AccountPassword AS varchar(15) = NULL
           ,@AccountZipCode AS varchar(10) = NULL
           ,@ActivatedById AS int = NULL
           ,@SelectedSecurityQuestionId AS int = NULL
           ,@SecurityQuestionAnswer AS varchar(30) = NULL
           ,@LastFourSsn AS varchar(4) = NULL
)
AS

DECLARE @EncryptedSSN AS varbinary(128)
DECLARE @EncryptedDrvLicNumber AS varbinary(128)

OPEN SYMMETRIC KEY WAKey DECRYPTION BY CERTIFICATE WACert;

IF (@SSN IS NOT NULL)
BEGIN
	SET @EncryptedSSN = EncryptByKey(Key_GUID('WAKey'), @SSN)		 
END

IF (@DrvLicNumber IS NOT NULL)
BEGIN
	SET @EncryptedDrvLicNumber = EncryptByKey(Key_GUID('WAKey'), @DrvLicNumber)		 
END


UPDATE [salesorder].[WirelessAccount]
   SET [OrderId] = @OrderId
      ,[FamilyPlan] = @FamilyPlan
      ,[CarrierOrderDate] = @CarrierOrderDate
      ,[DOB] = @DOB
      ,[DrvLicState] = @DrvLicState
      ,[DrvLicExpiry] = @DrvLicExpiry
      ,[FirstName] = @FirstName
      ,[Initial] = @Initial
      ,[LastName] = @LastName
      ,[CarrierOrderId] = @CarrierOrderId
      ,[CurrentAcctNumber] = @CurrentAcctNumber
      ,[CurrentAcctPIN] = @CurrentAcctPIN
      ,[CurrentTotalLines] = @CurrentTotalLines
      ,[CurrentPlanType] = @CurrentPlanType
      ,[CreditCode] = @CreditCode
      ,[MaxLinesAllowed] = @MaxLinesAllowed
      ,[DepositReq] = @DepositReq
      ,[DepositAccept] = @DepositAccept
      ,[DepositTypeId] = @DepositTypeId
      ,[DepositId] = @DepositId
      ,[DepositAmount] = @DepositAmount
      ,[ActivationAmount] = @ActivationAmount
      ,[PrePayId] = @PrePayId
      ,[PrePayAmount] = @PrePayAmount
      ,[NewAccountNo] = @NewAccountNo
      ,[NewAccountType] = @NewAccountType
      ,[BillCycleDate] = @BillCycleDate
      ,[CarrierStatus] = @CarrierStatus
      ,[CarrierStatusDate] = @CarrierStatusDate
      ,[CarrierId] = @CarrierId
      ,[ActivationStatus] = @ActivationStatus
      ,[ActivationDate] = @ActivationDate
      ,[CarrierTermsTimeStamp] = @CarrierTermsTimeStamp
      ,[AccountPassword] = @AccountPassword
      ,[AccountZipCode] = @AccountZipCode
      ,[ActivatedById] = @ActivatedById
      ,[SelectedSecurityQuestionId] = @SelectedSecurityQuestionId
      ,[SecurityQuestionAnswer] = @SecurityQuestionAnswer 
      ,[LastFourSsn] = @LastFourSsn
      ,[EncryptedSSN] = @EncryptedSSN
      ,[EncryptedDrvLicNumber] = @EncryptedDrvLicNumber
 WHERE [WirelessAccountId] = @WirelessAccountId
 
CLOSE SYMMETRIC KEY WAKey