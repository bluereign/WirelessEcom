<!--- set a long timeout --->
<cfsetting requesttimeout="99999" />

<!--- give the task the ability to run any date, default to today --->
<cfparam name="URL.rundate" type="date" default="#DateFormat(Now(),'mm/dd/yyyy')#" />

<!--- give the task the ability to re-run for re-attemptable failed deliveries --->
<cfparam name="URL.rerun" type="boolean" default="false" />

<!--- create an API object with our data --->
<cfset apiObj = createObject('component','cfc.model.system.sms.SmsMessenger').init(
	username	= 'wireadv123',
	password 	= 'ff1aST4r',
	shortCode 	= 99222
) />

<!--- create a message service object to utilize --->
<cfset smsMessageService = createObject('component','cfc.model.system.sms.SmsMessageService').init() />

<!--- get all the message id's for delivery today --->
<cfset qGetMessageIds = smsMessageService.getDailyMessageIds( rundate = URL.rundate, rerun = URL.rerun ) />

<!--- loop through the message id's for today --->
<cfloop query="qGetMessageIds">
	<!--- get an smsMessage object for this message id --->
	<cfset smsMessageObj = smsMessageService.getSmsMessageByID( qGetMessageIds.messageId ) />
	<!--- send the sms message through the API and capture results --->
	<cfset smsResult = apiObj.sendSMS(
		phoneNumber		= smsMessageObj.getPhoneNumber(),
		carrierId		= smsMessageObj.getCarrierId(),
		message 		= smsMessageObj.getMessage(),
		messageId 		= smsMessageObj.getSmsMessageId()
	) />
	<!--- check if the result code is '7' (duplicate message id) --->
	<cfif NOT smsResult.resultCode EQ 7>
		<!--- message id is unique, set the message id in the object --->
		<cfset smsMessageObj.setSmsMessageId( smsResult.messageId ) />
	<cfelse>
		<!--- message id is a *duplicate*, set it blank for the next rerun --->
		<cfset smsMessageObj.setSmsMessageId( '' ) />
	</cfif>
	<!--- set the result code in the object --->
	<cfset smsMessageObj.setResultCode( smsResult.resultCode ) />
	<!--- set the result message in the object --->
	<cfset smsMessageObj.setResult( smsResult.result ) />
	<!--- save the message object with the message id and result added --->
	<cfset smsMessageObj.setSMSMessageId( smsResult.messageId ) />
	<cfset smsMessageService.saveSmsMessage( smsMessageObj ) />
	<!--- sleep for 1 second to mitigate throttling --->
	<cfset sleep(1000) />
	
</cfloop>

