SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [service].[InsertAuthorization]
(
            @OrderId AS int
           ,@SCN AS varchar(16)
           ,@Amount AS money
           ,@ApprovedDate AS datetime
		   ,@SettledDate AS datetime
		   ,@CreditedDate AS datetime
           ,@Transaction AS varchar(36)
           ,@IPAddress AS varchar(39)
           ,@ChannelId AS int 
           ,@AuthCode varchar(6)
           ,@AuthTicket varchar(14)
		   ,@Inserted int OUTPUT
)

AS

DECLARE @EncryptedSCN AS varbinary(128)

OPEN SYMMETRIC KEY CCN_Key1701
   DECRYPTION BY CERTIFICATE Starcard;

IF (@SCN IS NOT NULL AND @OrderId NOT IN (SELECT OrderId FROM [service].[Authorize]))
BEGIN
       SET @EncryptedSCN = EncryptByKey(Key_GUID('CCN_Key1701')
    , @SCN, 1, HashBytes('SHA1', CONVERT( varbinary
    , @OrderId)));
                
INSERT INTO [service].[Authorize]
           ([OrderId]
           ,[SCN]
           ,[Amount]
           ,[ApprovedDate]
		   ,[Transaction]
           ,[IPAddress]
           ,[ChannelID]
           ,[AuthCode]
           ,[AuthTicket])
     VALUES
           (@OrderId
           ,@EncryptedSCN
           ,@Amount
           ,@ApprovedDate
		   ,@Transaction
           ,@IPAddress
           ,@ChannelID
            ,@AuthCode
            ,@AuthTicket
           )

SET @Inserted = 0

END
ELSE IF (@OrderId IN (SELECT OrderId FROM [service].[Authorize]))
BEGIN
      SET @EncryptedSCN = EncryptByKey(Key_GUID('CCN_Key1701')
    , @SCN, 1, HashBytes('SHA1', CONVERT( varbinary
    , @OrderId)));       
UPDATE [service].[Authorize]
SET 

[SCN] =  @EncryptedSCN
,[Amount] = @Amount
,[ApprovedDate] = @ApprovedDate
,[SettledDate] = @SettledDate
,[CreditedDate] = @CreditedDate
,[IPAddress] = @IPAddress
,[Transaction] = @Transaction
,[ChannelId] = @ChannelID
,[AuthCode] = @AuthCode
,[AuthTicket] = @AuthTicket

WHERE [OrderId] = @OrderId

SET @Inserted = 1

END

CLOSE SYMMETRIC KEY CCN_Key1701


GO
