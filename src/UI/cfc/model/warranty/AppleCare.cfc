<cfcomponent>

	<cffunction name="init" returntype="AppleCare">
		<cfset setApiEnabled() />
		<cfset setApiURL() />		
		<cfset setApiUserName() />
		<cfset setApiPassword() />
		<!---<cfset login() />--->

		<cfreturn this />
	</cffunction>
	

	<cffunction name="isAppleCareOrder" access="public" returnType="boolean" hint="returns true if order contains an applecare warranty" >
		<cfargument name="orderid" type="numeric" required="true" />
		<cfset var thisOrder = "" />
		<cfset var wirelessLines = ""/>
		<cfset var acCount = 0 />
				
		<cfset thisOrder = createObject('component', 'cfc.model.order').init() />
		<cfset thisOrder.load(arguments.orderid) />
 		<cfset wirelessLines = thisOrder.getWirelessLines() />
		 
		<cfloop from="1" to="#arraylen(wirelessLines)#" index="i">
			<cfset local.warrantyId = wirelessLines[i].getLineWarranty().getProductId() />
			<cfset local.qWarranty = application.model.Warranty.getById( local.warrantyId ) />
			<cfif local.qWarranty.companyname is "Apple">
				<cfreturn true /><!--- it only takes one! --->
			</cfif>
		</cfloop>
		<cfreturn false /> <!--- nada --->
	</cffunction>	
	
	<cffunction name="getMessages" access="public" returnType="array" hint="array of message fields from each orderdetail record" >
		<cfargument name="orderid" type="numeric" required="true" />
		
		<cfset var local = {} />				
		<cfset local.thisOrder = createObject('component', 'cfc.model.order').init() />
		<cfset local.thisOrder.load(arguments.orderid) />
 		<cfset local.wirelessLines = local.thisOrder.getWirelessLines() />
		<cfset local.messages = arrayNew(1) />
		<cfset emptyObj = {} />
		 
		<cfloop from="1" to="#arraylen(local.wirelessLines)#" index="local.i">
			<cfset local.warrantyId = local.wirelessLines[local.i].getLineWarranty().getProductId() />
			<cfset local.qWarranty = application.model.Warranty.getById( local.warrantyId ) />
			<cfif local.qWarranty.companyname is "Apple">
				<cfset local.wOrderDetail = local.wirelessLines[local.i].getLineWarranty() />
				<!---<cfset local.dOrderDetail = local.wirelessLines[local.i].getLineDevice() />--->
				<cfif isJson(local.wOrderDetail.getMessage()) is false>	
					<cftry>						
						<cfset local.acMessage = deserializeJson(local.wOrderDetail.getMessage()) />
					<cfcatch type="any">
						<cfset local.acMessage = {} />
						<cfif local.wirelessLines[local.i].getIMEI() is not "">
							<cfset local.acMessage.op = "Needs Verify" />
						<cfelse>
							<cfset local.acMessage.op = "Not Ready" />
							<cfset local.acMessage.op_status = "Needs IMEI before Verification is allowed" />
						</cfif>	
						<cfset local.acMessage.po = application.wirebox.getInstance("ChannelConfig").getAppleCarePrefix() & "-" & arguments.orderid & "-" & local.i />
					</cfcatch>
					</cftry>
				<cfelse>
					<cfset local.acMessage = deserializeJson(local.wOrderDetail.getMessage()) />
					<cfif (isdefined("local.acMessage.op") and isdefined("local.acMessage.op_status"))
						and 
						(local.acMessage.op_status is "Verified" or local.acMessage.op_status is "Created" or local.acMessage.op_status is "Cancelled")>
						<!--- do nothing --->
					<cfelse>
					<cfset local.acMessage = {} />
					<cfif local.wirelessLines[local.i].getIMEI() is not "">
						<cfset local.acMessage.op = "Needs Verify" />
					<cfelse>
						<cfset local.acMessage.op = "Not Ready" />
						<cfset local.acMessage.op_status = "Needs IMEI before Verification is allowed" />
					</cfif>	
					<cfset local.acMessage.po = application.wirebox.getInstance("ChannelConfig").getAppleCarePrefix() & "-" & arguments.orderid & "-" & local.i />
					</cfif>
				</cfif>
				<cfset arrayAppend( local.messages, local.acMessage) />
			<cfelse>
				<cfset local.acMessage = {} />
				<cfset local.acMessage.op = "Not AppleCare" />
				<cfset local.acMessage.po = application.wirebox.getInstance("ChannelConfig").getAppleCarePrefix() & "-" & arguments.orderid & "-" & local.i />
				<cfset arrayAppend( local.messages, local.acMessage) />
			</cfif>
		</cfloop>
		<cfreturn local.messages /> 
	</cffunction>	


	<!--- create an applecare verify json. If lineno is passed, then just do that line and append "-<lineno>" to the orderid--->
	<cffunction name="createVerifyOrderJSON" access="public" returnType="string" hint="Implements the verifyOrder call to the wa-applecare api" >
		<cfargument name="orderid" type="numeric" required="true" />
		<cfargument name="lineNo" type="numeric" required="false" default="0" /> <!--- send just this line, or all if 0 --->
		<cfargument name="forceIMEI" type="string" required="false" default="" />

		<cfset var thisOrder = "" />
		<cfset var wirelessLines = ""/>
		<cfset var local = {} />
		<cfset var numericDelimeter = "XYZNUMSTRING" />
		
		
		<cfset thisOrder = createObject('component', 'cfc.model.order').init() />
		<cfset thisOrder.load(arguments.orderid) />
 		<cfset wirelessLines = thisOrder.getWirelessLines() />
		
		<!--- Create the request object --->
		<cfset local.requestOrderId = thisOrder.getOrderid() />	
		<cfif arguments.lineno gt 0>
			<cfset local.requestOrderId = application.wirebox.getInstance("ChannelConfig").getAppleCarePrefix() & "-" & local.requestOrderId & "-" & arguments.lineNo />
		</cfif>
		<cfset local.verifyRequest = {
			appleCareSalesDate = #dateformat(now(),'mm@@@dd@@@yy')#,
			purchaseOrderNumber = #local.requestOrderId#,
			pocLanguage = "ENG",
			customerRequest = {
				CustomerFirstName = #left(thisOrder.getBillAddress().getFirstName(),30)#
				, CustomerLastName = #left(thisOrder.getBillAddress().getLastName(),30)#
				, CustomerEmailId = #thisOrder.getEmailAddress()#
				, AddressLine1 = ""
				, AddressLine2 = ""
				, City = ""
				, StateCode = ""
				, CountryCode = ""
				, ZipCode = ""
				<!--- not passing street address info for now
				, AddressLine1 = #thisOrder.getShipAddress().getAddressLine1()#
				, AddressLine2 = #thisOrder.getShipAddress().getAddressLine2()#
				, City = #thisOrder.getShipAddress().getCity()#
				, StateCode = #thisOrder.getShipAddress().getState()#
				, CountryCode = ""
				, ZipCode =  numericDelimeter & #thisOrder.getShipAddress().getZipCode()# & numericDelimeter --->
				, PrimaryPhoneNumber = numericDelimeter & #thisOrder.getShipAddress().getDaytimePhone()# & numericDelimeter
				
			},
			DeviceRequest = [],
			ReferenceId = "#createUUID()#",
			ClientId = application.wirebox.getInstance("ChannelConfig").getAppleCarePrefix() & "-" & ucase(cgi.SERVER_NAME)
		} />
		
		<!--- Add the devices to the request object --->
		<!---<cfloop from="1" to="#arraylen(wirelessLines)#" index="i">---> <!--- For now we are only going to send one line at a time --->
			<cfset local.i = arguments.lineNo />
			<cfset local.warrantyId = wirelessLines[local.i].getLineWarranty().getProductId() />
			<cfset local.qWarranty = application.model.Warranty.getById( local.warrantyId ) />
			<cfif local.qWarranty.companyname is "Apple">
				<cfset local.IMEI = wirelessLines[local.i].getIMEI() />
				<!---<cfset local.IMEI = "DNPL1637DTTA" />---> <!--- just for testing --->
				<cfif arguments.forceIMEI is not ""><!--- Change last char to 'R' or 'A' --->
					<cfset local.IMEI = left(local.IMEI, len(local.IMEI)-1) & arguments.forceIMEI />
				</cfif>
				<cfset local.d = {
					deviceId = numericDelimeter & local.IMEI & numericDelimeter,
					<!---deviceId = "DNPL#i#637DTTA",--->  <!--- just for testing --->
					SecondarySerialNumber = "", 
					HardwareDateOfPurchase = #dateformat(now(),'mm@@@dd@@@yy')#					
				} />
				<cfset arrayAppend(local.verifyRequest.DeviceRequest,local.d) />
			</cfif>
			
		<!---</cfloop>---><!--- commented out until multi-line support is added on the service layer --->
		
		<!--- generate the serialized object in JSON format --->
		<cfset local.jsonRequest = serializeJSON(local.verifyRequest) />
		<!--- remove the special bookends that prevent numeric conversion --->
		<cfset local.jsonRequest = replaceNoCase(local.jsonRequest, numericDelimeter, "", "ALL"  ) />
		<cfset local.jsonRequest = replaceNoCase(local.jsonRequest, "@@@", "/", "ALL"  ) />
		
		<cfreturn local.jsonRequest />
		
	</cffunction>
	
	<cffunction name="sendVerifyOrderRequest" access="public" returnType="string" hint="sends a request and returns the response" >
		<cfargument name="orderid" type="numeric" required="true" />
		<cfargument name="lineNo" type="numeric" required="false" default="1" />
		<cfargument name="forceIMEI" type="string" required="false" default="" />
		
		<cfset var local = {} />
		
		<cfset local.notDone = true />
		<cfset local.returnCt = 0 />
		<cfloop condition="local.notDone">
			<cfset local.apiUrl = getApiUrl() & "/api/AppleCare/VerifyOrder" />
			<cfset local.requestJson = createVerifyOrderJSON(arguments.orderid,arguments.lineNo, arguments.forceIMEI) />
			<cfset local.response = sendRequest(local.requestJson, local.apiUrl) />	
	
			<!--- Do some post processing on the response --->
			<!--- did we get an auth error, if so relogin --->	
			<cfif  isdefined("local.response.message") and local.retryCt lt 10 >
				<cfset setApiToken("") />
				<cfset local.retryCt = local.retryCt +1 /> 
			<cfelse>
				<cfset local.notDone = false />
			</cfif>

		</cfloop>
		
		<cfreturn local.response />
	</cffunction>
	
	<cffunction name="sendCreateOrderRequest" access="public" returnType="string" hint="sends a request and returns the response" >
		<cfargument name="orderid" type="numeric" required="true" />
		<cfargument name="lineNo" type="numeric" required="false" default="1" />
		<cfargument name="forceIMEI" type="string" required="false" default="" />
		
		<cfset var local = {} />
		
		<cfset local.notDone = true />
		<cfset local.returnCt = 0 />
		<cfloop condition="local.notDone">
			<cfset local.apiUrl = getApiUrl() & "/api/AppleCare/CreateOrder" />
			<cfset local.requestJson = createVerifyOrderJSON(arguments.orderid,arguments.lineNo, arguments.forceIMEI) />
			<cfset local.response = sendRequest(local.requestJson, local.apiUrl) />	
	
			<!--- Do some post processing on the response --->
			<!--- did we get an auth error, if so relogin --->	
			<cfif  isdefined("local.response.message") and local.retryCt lt 10 >
				<cfset setApiToken("") />
				<cfset local.retryCt = local.retryCt +1 /> 
			<cfelse>
				<cfset local.notDone = false />
			</cfif>

		</cfloop>
		
		<cfreturn local.response />
	</cffunction>
	
		<!--- create an applecare verify json. If lineno is passed, then just do that line and append "-<lineno>" to the orderid--->
	<cffunction name="createCancelOrderJSON" access="public" returnType="string" hint="Implements the verifyOrder call to the wa-applecare api" >
		<cfargument name="orderid" type="numeric" required="true" />
		<cfargument name="lineNo" type="numeric" required="false" default="0" /> <!--- send just this line, or all if 0 --->

		<cfset var thisOrder = "" />
		<cfset var wirelessLines = ""/>
		<cfset var local = {} />
		<cfset var numericDelimeter = "XYZNUMSTRING" />
		
		
		<cfset thisOrder = createObject('component', 'cfc.model.order').init() />
		<cfset thisOrder.load(arguments.orderid) />
 		<cfset wirelessLines = thisOrder.getWirelessLines() />
		 
		<!--- Create the request object --->
		<cfset local.requestOrderId = thisOrder.getOrderid() />	
		<cfif arguments.lineno gt 0>
			<cfset local.requestOrderId = application.wirebox.getInstance("ChannelConfig").getAppleCarePrefix() & "-" & local.requestOrderId & "-" & arguments.lineNo />
		</cfif>
		<cfset local.cancelRequest = {
			deviceId =  #numericDelimeter# & #wirelessLines[arguments.lineNo].getIMEI()# & #numericDelimeter#,
			cancellationDate = #dateformat(now(),'mm@@@dd@@@yy')#,
			purchaseOrderNumber = #local.requestOrderId#

		} />
		 
		<!--- generate the serialized object in JSON format --->
		<cfset local.jsonRequest = serializeJSON(local.cancelRequest) />
		<!--- remove the special bookends that prevent numeric conversion --->
		<cfset local.jsonRequest = replaceNoCase(local.jsonRequest, numericDelimeter, "", "ALL"  ) />
		<cfset local.jsonRequest = replaceNoCase(local.jsonRequest, "@@@", "/", "ALL"  ) />
		 
		<cfreturn local.jsonRequest />
		
	</cffunction>

	<cffunction name="sendCancelOrderRequest" access="public" returnType="string" hint="sends a request and returns the response" >
		<cfargument name="orderid" type="numeric" required="true" />
		<cfargument name="lineNo" type="numeric" required="false" default="1" />
		
		<cfset var local = {} />
		
		<cfset local.notDone = true />
		<cfset local.returnCt = 0 />
		<cfloop condition="local.notDone">
			<cfset local.apiUrl = getApiUrl() & "/api/AppleCare/CancelOrder" />
			<cfset local.requestJson = createCancelOrderJSON(arguments.orderid,arguments.lineNo) />
			<cfset local.response = sendRequest(local.requestJson, local.apiUrl) />	
	
			<!--- Do some post processing on the response --->
			<!--- did we get an auth error, if so relogin --->	
			<cfif  isdefined("local.response.message") and local.retryCt lt 10 >
				<cfset setApiToken("") />
				<cfset local.retryCt = local.retryCt +1 /> 
			<cfelse>
				<cfset local.notDone = false />
			</cfif>

		</cfloop>
		
		<cfreturn local.response />
	</cffunction>	

	<cffunction name="login" access="private" returnType="boolean" hint="sends a login request and stores the resultant token" >
		<cfset var local = {} />
		<!--- If API is disabled just return --->
		<cfif !getApiEnabled() > <cfreturn '{ "apiEnabled": "false" }' /></cfif>		
		
		<cfset local.loginUrl = getApiUrl() & "/Token"/>
		<!---<cfset local.loginJson = '{"grant_type": "password","userName":"#getApiUsername()#","password":"#getApiPassword()#"}' />--->
		<cfhttp url="#local.loginUrl#"  method="post" result="local.rawResponse">
			<cfhttpparam type="FORMFIELD" name="grant_type" value="password" />
			<cfhttpparam type="FORMFIELD" name="userName" value="#getApiUserName()#">
			<cfhttpparam type="FORMFIELD" name="password" value="#getApiPassword()#">
		</cfhttp>
		<cfif isJson(local.rawResponse.filecontent)>
			<cfset setApiToken(deSerializeJson(local.rawResponse.filecontent)) />
			<cfif getApiAccessToken() is not "">
				<cfreturn true/>
			<cfelse>
				<cfreturn false />
			</cfif>
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>
	
	<cffunction name="logoff" access="private" returnType="void" hint="resets the apitoken to null" >
		<cfset dummy = {} />
		<cfset setApiToken(dummy) />
	</cffunction>
	
	<cffunction name="sendRequest" access="private" returnType="string" hint="sends a request and returns the response" >
		<cfargument name="requestJson" type="string" required="true" />
		<cfargument name="apiUrl" type="string" required="true" />
		<cfargument name="retries" type="numeric" required="false" default="0" />
		
		<cfset var local = {} />
		
		<!--- If API is disabled just return --->
		<cfif !getApiEnabled() > <cfreturn '{ "apiEnabled": "false" }' /></cfif>		
		
		<!--- See if we need to log in --->
		<cfif getApiAccessToken() is "">
			<cfif !login()>
				<cfreturn '{"errormessage":"login failed"}' />
			</cfif>
		</cfif>
		
		<cfhttp url="#arguments.apiURL#"  method="post" result="local.response">
			<cfhttpparam type="header" name="Authorization" value="#getApiAccessToken()#" />
			<cfhttpparam type="header" name="Content-Type" value="application/json" />
			<cfhttpparam type="body" value="#arguments.requestJson#">
		</cfhttp>
		
		<!---Convert response back to an object and add the original request info to it --->
		<cfset local.responseObj = deserializeJson(local.response.filecontent) />
		<cfset local.responseObj.originalRequest = deserializeJson(arguments.requestJson) />
		<cfset local.responseJson = serializeJson(local.responseObj) />

		<cfif isdefined("local.responseObj.Message") and local.responseObj.Message is "Authorization has been denied for this request.">
			<cfset logoff() />
			<!--- we will retry only once so as not to loop infinitely --->	
			<cfif arguments.retries is 0>
				<cfreturn sendRequest(arguments.requestJson, arguments.apiUrl,1) />
			</cfif>
		</cfif>	
			
		
		<!--- check the local.response to determine if it succeeded or failed --->
		<cfif local.response.errorDetail is not "">
			<cfreturn local.responseJson />
		<cfelse>		
			<cfreturn local.responseJson />
		</cfif>
		
	</cffunction>	
	
	<cffunction name="getApiEnabled" access="private" returnType="boolean" hint="returns whether or not the api is enabled (T|F)" >
		<cfreturn variables.instance.apiEnabled />
	</cffunction>
	
	<cffunction name="setApiEnabled" access="private" returnType="void" hint="sets the applie care api url" >
		<!---find and store the channel specific url for the api--->
		<cfset variables.instance.apiEnabled = application.wirebox.getInstance("ChannelConfig").getAppleCareApiEnabled() />
	</cffunction>
	
	<cffunction name="getApiUrl" access="private" returnType="string" hint="returns a string containing the apple care api url" >
		<cfreturn variables.instance.apiUrl />
	</cffunction>
	
	<cffunction name="setApiUrl" access="private" returnType="void" hint="sets the applie care api url" >
		// find and store the channel specific url for the api
		<cfset variables.instance.apiUrl = application.wirebox.getInstance("ChannelConfig").getAppleCareApiUrl() />
	</cffunction>
	
	<cffunction name="getApiUserName" access="private" returnType="string" hint="returns a string containing the apple care api username" >
		<cfreturn variables.instance.apiUsername />
	</cffunction>
	
	<cffunction name="setApiUsername" access="private" returnType="void" hint="sets the applie care api username" >
		<cfset variables.instance.apiUsername = application.wirebox.getInstance("ChannelConfig").getAppleCareApiUsername() />
	</cffunction>
	
	<cffunction name="getApiPassword" access="private" returnType="string" hint="returns a string containing the apple care api password" >
		<cfreturn variables.instance.apiPassword />
	</cffunction>
	
	<cffunction name="setApiPassword" access="private" returnType="void" hint="sets the applie care api password" >
		<cfset variables.instance.apiPassword = application.wirebox.getInstance("ChannelConfig").getAppleCareApiPassword() />
	</cffunction>

	<cffunction name="getApiToken" access="private" returnType="struct" hint="returns a string containing the current apple care api token" >
		<cfset dummy = {} />
		<cfif structKeyExists(variables.instance,"apiToken")>
		<cfreturn variables.instance.apiToken />
		<cfelse>
			<cfreturn dummy />
		</cfif>
	</cffunction>
	
	<cffunction name="setApiToken" access="private" returnType="void" hint="sets the applie care api token" >
		<cfargument name="token" type="struct" required="false" default="{}" />
		<!--- token defaults to  blank to indicate we have not yet logged in --->
		<cfset variables.instance.apiToken = arguments.token />
	</cffunction>
	
	<cffunction name="getApiAccessToken" access="private" returnType="string" hint="returns a string containing the current access_token or blank" >
			<cfif structKeyexists(getApiToken(),"access_token") and len(getApiToken().access_token) gt 0>
			<cfreturn getApiToken().token_type & " " & getApiToken().access_token />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>
	
	

</cfcomponent>