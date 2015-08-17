OPEN SYMMETRIC KEY CCN_Key1701
   DECRYPTION BY CERTIFICATE Starcard;

DECLARE @XMLType TABLE (LogId int, LogXml XML)
INSERT INTO @XMLType
SELECT LogId, CONVERT(XML,DecryptByKeyAutoCert(cert_ID('Starcard'), NULL, LogXmL,1, HashBytes('SHA1', CONVERT( varbinary, Logid)))) FROM service.AuthorizeLog


SELECT
      AuthCode.value('(AuthCode/text())[1]', 'varchar(10)') AS 'AuthCode'
      ,CcNumber.value('(CcNumber/text())[1]', 'varchar(50)') AS 'CcNumber'
      ,CcReply.value('(CcReply/text())[1]', 'varchar(4000)') AS 'CcReply'
         ,GatewayName.value('(GatewayName/text())[1]', 'varchar(250)') AS 'GatewayName'
         ,MscAddress2.value('(GatewayName/text())[1]', 'varchar(250)') AS 'MscAddress2'
         ,MscAmount.value('(MscAmount/text())[1]', 'money') AS 'MscAmount'
         ,MscAvsAddress.value('(MscAvsAddress/text())[1]', 'varchar(250)') AS 'MscAvsAddress'
         ,MscAvsZip.value('(MscAvsZip/text())[1]', 'varchar(250)') AS 'MscAvsZip'
         ,MscAvsZip.value('(MscAvsZip/text())[1]', 'varchar(250)') AS 'MscAvsZip'
         ,MscCity.value('(MscCity/text())[1]', 'varchar(250)') AS 'MscCity'
         ,MscCompany.value('(MscCompany/text())[1]', 'varchar(250)') AS 'MscCompany'
         ,MscEmail.value('(MscEmail/text())[1]', 'varchar(250)') AS 'MscEmail'
         ,MscFacilityID.value('(MscFacilityID/text())[1]', 'varchar(250)') AS 'MscFacilityID'
         ,MscFirstName.value('(MscFirstName/text())[1]', 'varchar(250)') AS 'MscFirstName'
         ,MscLastName.value('(MscLastName/text())[1]', 'varchar(250)') AS 'MscLastName'
         ,MscPhone.value('(MscPhone/text())[1]', 'varchar(250)') AS 'MscPhone'
         ,MscPin.value('(MscPin/text())[1]', 'varchar(250)') AS 'MscPin'
         ,MscReceiptLinkMethod.value('(MscReceiptLinkMethod/text())[1]', 'varchar(250)') AS 'MscReceiptLinkMethod'
         ,MscReceiptLinkUrl.value('(MscReceiptLinkUrl/text())[1]', 'varchar(250)') AS 'MscReceiptLinkUrl'
         ,MscState.value('(MscState/text())[1]', 'varchar(250)') AS 'MscState'
         ,MscUserID.value('(MscUserID/text())[1]', 'varchar(250)') AS 'MscUserID'
         ,ReturnCode.value('(ReturnCode/text())[1]', 'varchar(250)') AS 'ReturnCode'
         --,ReturnMessage.value('(ReturnMessage/text())[1]', 'varchar(250)') AS 'ReturnMessage'
         ,SalesOrderNumber.value('(SalesOrderNumber/text())[1]', 'varchar(250)') AS 'SalesOrderNumber'
         ,TestMode.value('(TestMode/text())[1]', 'varchar(250)') AS 'TestMode'
         ,TransactionType.value('(TransactionType/text())[1]', 'varchar(250)') AS 'TransactionType'
         ,TxnId.value('(TxnId/text())[1]', 'varchar(250)') AS 'TxnId'

FROM  @XMLType
CROSS APPLY LogXML.nodes('/ScinssOutput') AS LogEntry(AuthCode)
CROSS APPLY LogXML.nodes('/ScinssOutput') AS LogEntry2(CcNumber)
CROSS APPLY LogXML.nodes('/ScinssOutput') AS LogEntry3(CcReply)
CROSS APPLY LogXML.nodes('/ScinssOutput') AS LogEntry4(GatewayName)
CROSS APPLY LogXML.nodes('/ScinssOutput') AS LogEntry5(MscAddress2)
CROSS APPLY LogXML.nodes('/ScinssOutput') AS LogEntry6(MscAmount)
CROSS APPLY LogXML.nodes('/ScinssOutput') AS LogEntry7(MscAvsAddress)
CROSS APPLY LogXML.nodes('/ScinssOutput') AS LogEntry8(MscAvsZip)
CROSS APPLY LogXML.nodes('/ScinssOutput') AS LogEntry9(MscCity)
CROSS APPLY LogXML.nodes('/ScinssOutput') AS LogEntry10(MscCompany)
CROSS APPLY LogXML.nodes('/ScinssOutput') AS LogEntry11(MscEmail)
CROSS APPLY LogXML.nodes('/ScinssOutput') AS LogEntry12(MscFacilityID)
CROSS APPLY LogXML.nodes('/ScinssOutput') AS LogEntry13(MscFirstName)
CROSS APPLY LogXML.nodes('/ScinssOutput') AS LogEntry14(MscLastName)
CROSS APPLY LogXML.nodes('/ScinssOutput') AS LogEntry15(MscPhone)
CROSS APPLY LogXML.nodes('/ScinssOutput') AS LogEntry16(MscPin)
CROSS APPLY LogXML.nodes('/ScinssOutput') AS LogEntry17(MscReceiptLinkMethod)
CROSS APPLY LogXML.nodes('/ScinssOutput') AS LogEntry18(MscReceiptLinkUrl)
CROSS APPLY LogXML.nodes('/ScinssOutput') AS LogEntry19(MscState)
CROSS APPLY LogXML.nodes('/ScinssOutput') AS LogEntry20(MscUserID)
CROSS APPLY LogXML.nodes('/ScinssOutput') AS LogEntry21(ReturnCode)
--CROSS APPLY LogXML.nodes('/ScinssOutput') AS LogEntry22(ReturnMessage)
CROSS APPLY LogXML.nodes('/ScinssOutput') AS LogEntry23(SalesOrderNumber)
CROSS APPLY LogXML.nodes('/ScinssOutput') AS LogEntry24(TestMode)
CROSS APPLY LogXML.nodes('/ScinssOutput') AS LogEntry25(TransactionType)
CROSS APPLY LogXML.nodes('/ScinssOutput') AS LogEntry26(TxnId)

CLOSE SYMMETRIC KEY CCN_Key1701
