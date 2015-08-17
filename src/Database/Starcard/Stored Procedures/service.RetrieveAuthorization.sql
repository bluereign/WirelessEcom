SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [service].[RetrieveAuthorization]
(
			@OrderId AS int
)

AS

OPEN SYMMETRIC KEY CCN_Key1701
   DECRYPTION BY CERTIFICATE Starcard;

SELECT
	AuthID
	,OrderId
	,CONVERT(varchar,
    DecryptByKey(SCN, 1 , 
    HashBytes('SHA1', CONVERT(varbinary, OrderId)))) AS 'Decrypted CCN'
	,Amount
	,ApprovedDate
	,SettledDate
	,CreditedDate
	,AuthCode
	,AuthTicket
	,IPAddress
	,ChannelId
	,[Transaction]
	FROM service.Authorize
	WHERE OrderId = @OrderId
         
CLOSE SYMMETRIC KEY CCN_Key1701




GO
