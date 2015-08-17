<cfcomponent displayname="SmsMessenger" hint="I am the API wrapper for Genesys SMS Aggregation HTTP API.">
	
	<!--- initialize component --->
	<cffunction name="init" returntype="any" output="false" hint="I am the API constructor">
		<cfargument name="username" type="string" required="false" default="<your username>" hint="I am the username provided by Genesys." />
		<cfargument name="password" type="string" required="false" default="<your password>" hint="I am the password provided by Genesys." />
		<cfargument name="shortcode" type="numeric" required="false" default="<your shortcode>" hint="I am the shortcode provided by Genesys." />
		<cfargument name="apiUrl" type="string" required="false" default="https://smsc-api.soundbite.com/httpapi/receiver" hint="I am the API URL to use to send the API request." />

		<cfset variables.username = ARGUMENTS.username />
		<cfset variables.password = ARGUMENTS.password />
		<cfset variables.shortcode = ARGUMENTS.shortcode />
		<cfset variables.apiUrl = ARGUMENTS.apiUrl />

		<cfreturn this />
	</cffunction>

	<!--- send an SMS (MT) message --->
	<cffunction name="sendSMS" access="public" returtype="struct" output="false" hint="I send a Mobile Terminated (MT/SMS) message through the API.">
		<cfargument name="phoneNumber" type="string" required="true" hint="I am the phone number to send this message to." />
		<cfargument name="carrierId" type="string" required="true" hint="I need to be translated from the WA to the value on the Reach List (see Reach List.pdf)." />
		<cfargument name="message" type="string" required="true" hint="I am the text of the message to send." />
		<cfargument name="messageId" type="string" required="false" default="" hint="I am a unique ID for this message." />
		<cfargument name="wapPushURL" type="string" required="false" default="" hint="If this is a WAP push, provide the URL here. The message parameter will be used as the title for the WAP push." />
		<cfargument name="receipt" type="string" required="false" default="No" hint="Yes if a receipt is desired. See Receiving A Receipt for details." />
		<cfargument name="mmsMimeTypes" type="array" required="false" default="#ArrayNew(1)#" hint="MMS message attachment mime type array." />
		<cfargument name="mmsAttachments" type="array" required="false" default="#ArrayNew(1)#" hint="MMS message attachment array. Base64-encoded binary content." />
		<cfargument name="priority" type="string" required="false" default="BULK" hint="Valid values are BULK_LOW, BULK, INTERACTIVE_LOW, and INTERACTIVE." />

		<!--- var scope --->
		<cfset var httpResult = '' />
		<cfset var iX = 0 />

		<!--- check if the message id is defined --->
		<cfif NOT Len(ARGUMENTS.messageId)>
			<!--- it isn't, generate a unique message id (random hash of random length) --->
			<cfset ARGUMENTS.messageId = Left( LCase( Hash( CreateUUID() & ARGUMENTS.phoneNumber & ARGUMENTS.carrierId & ARGUMENTS.message, 'SHA-512' ) ), RandRange(128,255) ) />
		</cfif>

		<!--- call the API --->
		<cfhttp url="#variables.apiUrl#" method="post" result="httpResult" timeout="9999">
			<cfhttpparam type="formfield" name="login" value="#variables.username#"></cfhttpparam>
			<cfhttpparam type="formfield" name="password" value="#variables.password#"></cfhttpparam>
			<cfhttpparam type="formfield" name="message_id" value="#ARGUMENTS.messageId#"></cfhttpparam>
			<cfhttpparam type="formfield" name="shortcode" value="#variables.shortcode#"></cfhttpparam>
			<cfhttpparam type="formfield" name="phone_number" value="#ARGUMENTS.phoneNumber#"></cfhttpparam>
			<cfhttpparam type="formfield" name="carrier" value="#WA_to_Reach_CarrierId_Translate(ARGUMENTS.carrierId)#"></cfhttpparam>
			<cfhttpparam type="formfield" name="message" value="#ARGUMENTS.message#"></cfhttpparam>
			<!--- check if this is a wap push --->
			<cfif IsDefined( 'ARGUMENTS.wapPushURL' ) and Len( ARGUMENTS.wapPushURL )>
				<!--- it is, include the wap push URL --->
				<cfhttpparam type="formfield" name="wap_push_url" value="#ARGUMENTS.wapPushURL#"></cfhttpparam>				
			</cfif>
			<cfhttpparam type="formfield" name="receipt" value="#ARGUMENTS.receipt#"></cfhttpparam>
			<!--- check if there are mms attachments --->
			<cfif IsArray( ARGUMENTS.mmsMimeTypes ) AND ArrayLen( ARGUMENTS.mmsMimeTypes ) AND IsArray( ARGUMENTS.mmsAttachments ) AND ArrayLen( ARGUMENTS.mmsAttachments )>
				<!--- there are, loop through the attachments --->
				<cfloop from="1" to="#ArrayLen( ARGUMENTS.mmsMimeTypes )#" index="iX">
					<!--- include the attachment mime type and Base64 encoded attachment --->
					<cfhttpparam type="formfield" name="mms_attachment#iX-1#.content_type" value="#ARGUMENTS.mmsMimeTypes[iX]#"></cfhttpparam>
					<cfhttpparam type="formfield" name="mms_attachment#iX-1#.content" value="#ARGUMENTS.mmsAttachments[iX]#"></cfhttpparam>
				</cfloop>
			</cfif>
			<cfhttpparam type="formfield" name="priority" value="#ARGUMENTS.priority#"></cfhttpparam>
		</cfhttp> 

		<!--- return the result of the API call, with descriptions --->
		<cfreturn processResult( returnCode = ListLast(httpResult.fileContent, '=' ), messageId = ARGUMENTS.messageId ) />

	</cffunction>

	<!--- PRIVATE UTILITY FUNCTIONS --->	

	<!--- This little function simply translates the WA carrierID value to the Reach value used for SMS Sending --->
	<cffunction name="WA_to_Reach_CarrierId_Translate" returntype="string">
		<cfargument name="carrierId" type="numeric" required="true">
		
		<cfswitch expression="#arguments.carrierId#">
			<cfcase value="42">
				<cfreturn "84012"/>
			</cfcase>	
			<cfcase value="109">
				<cfreturn "84001"/>
			</cfcase>	
			<cfcase value="128">
				<cfreturn "84010"/>
			</cfcase>	
			<cfcase value="299">
				<cfreturn "84008"/>
			</cfcase>
			<cfdefaultcase>
				<cfreturn "UNKNOWN" />
			</cfdefaultcase>	
		</cfswitch>
	</cffunction>	
	

	<!--- process the result code into code and message to return --->
	<cffunction name="processResult" access="private" returntype="struct" output="false" hint="I process the result of sending a MT/SMS.">
		<cfargument name="returnCode" type="numeric" required="true" hint="I am the return code from the MT request." />
		<cfargument name="messageId" type="string" required="true" hint="I am the message if of this MT request." />

		<!--- create a structure to return --->
		<cfset var returnStruct = StructNew() />
		
		<!--- add the result code to the structure --->
		<cfset returnStruct.resultCode = ARGUMENTS.returnCode />
		<!--- add the message id to the structure --->
		<cfset returnStruct.messageId = ARGUMENTS.messageId />

		<!--- switch on the return code and add appropriate description --->
		<cfswitch expression="#ARGUMENTS.returnCode#">
			
			<cfcase value="0">
				
				<cfset returnStruct.result = 'Message has been accepted for processing.' />

			</cfcase>
			
			<cfcase value="1">
				
				<cfset returnStruct.result = 'One or more request parameters missing or invalid.' />

			</cfcase>
			
			<cfcase value="2">
				
				<cfset returnStruct.result = 'Authentication failed.' />

			</cfcase>
			
			<cfcase value="3">
				
				<cfset returnStruct.result = 'Unrecognized carrier ID.' />

			</cfcase>
			
			<cfcase value="4">
				
				<cfset returnStruct.result = 'Invalid shortcode. Shortcodes must be purely numeric.' />

			</cfcase>
			
			<cfcase value="5">
				
				<cfset returnStruct.result = 'Shortcode not approved.' />

			</cfcase>
			
			<cfcase value="6">
				
				<cfset returnStruct.result = 'Throttled.' />

			</cfcase>
			
			<cfcase value="7">
				
				<cfset returnStruct.result = 'Duplicate message ID.' />

			</cfcase>
			
			<cfcase value="98">
				
				<cfset returnStruct.result = 'Internal Genesys server error.' />

			</cfcase>

			<cfdefaultcase>
				
				<cfset returnStruct.result = 'Other/Unknown error.' />

			</cfdefaultcase>

		</cfswitch>

		<!--- return the structure --->
		<cfreturn returnStruct />

	</cffunction> 


</cfcomponent>