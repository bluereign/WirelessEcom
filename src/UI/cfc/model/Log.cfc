<cfcomponent output="false" displayname="Log">

	<cffunction name="init" returntype="Log">
    	
    	<cfreturn this>	
    </cffunction>
    
    <cffunction name="logResponse" returntype="void" hint="Logs the results of a RESPONSE object passed.">
    	<cfargument name="response" type="Response" required="true">
        
		<!--- convert the response to error --->
		<cfset var local = structNew()>
        <cfset local.resultCode = arguments.response.getResultCode()>
		<cfset local.errorCode = arguments.response.getErrorCode()>
        <cfset local.errorMessage = arguments.response.getErrorMessage()>
        <cfset local.detail = arguments.response.getDetail()>
        <cfset local.severity = 1> <!--- default to high severity so that if the lookup fails, the error is logged and notification is sent. ---> 
        
		<!--- look up result in result code table --->
        <cfquery name="LogGetResultCode" datasource="CARTOYS_SQL">
        	select Severity from ResultCode where ErrorCode = '#local.resultCode#'
        </cfquery>
        <cfif LogGetResultCode.recordcount gt 0>
        	<cfset local.severity = LogGetResultCode.severity >
        </cfif>
        
        <!--- TODO: handle logging ---->
        <cfset logError(local.resultCode, local.errorCode, local.errorMessage, local.detail, local.severity)>
        
		<!--- TODO: handle notifications --->
        <cfset sendNotification(local.resultCode, local.errorCode, local.errorMessage, local.detail, local.severity)>
        
    </cffunction>
    
    
    <cffunction name="logError" returntype="void" access="private">
    	<cfargument name="resultCode" type="string" default="" required="false">
        <cfargument name="errorCode" type="string" default="" required="false">
        <cfargument name="errorMessage" type="string" default="" required="false">
        <cfargument name="detail" type="string" default="" required="false">
        <cfargument name="severity" type="numeric" required="true">
		
        <cfset var local = structNew()>
        <cfset local.writeErrorToLog = false>
        
        <!--- 
		TODO: check to see if logging is enabled for this error code, we will do this based on the result code prefix. 
		--->
        
        <!--- check to see if this is high severity. log everything level 3 --->
        <cfif arguments.severity eq 1>
        	<cfset local.writeErrorToLog = true>
        </cfif>
        
     	<!--- if writeErrorToLog, write the error to the log file --->
        <cfif local.writeErrorToLog eq true>
        	<!--- TODO: Write error to the log file --->
            
        </cfif>
        
    </cffunction>
    
    <cffunction name="sendNotification" returntype="void" access="private" hint="Sends a notification based on the severity and any other rules.">
    	<cfargument name="resultCode" type="string" default="" required="false">
        <cfargument name="errorCode" type="string" default="" required="false">
        <cfargument name="errorMessage" type="string" default="" required="false">
        <cfargument name="detail" type="string" default="" required="false">
        <cfargument name="severity" type="numeric" required="true">
        
        <cfset var local = structNew()>
        <cfset local.sendNotification = false>
                
        <!--- TODO: implement rules engine that will determine what errors get notifications --->
        
        
        <!--- check to see if this is a high severity, if it is, set it to send notification --->
        <cfif arguments.severity eq 1>
        	<cfset local.sendNotification = true>
        </cfif>
        
        
        <!--- if sendNotification, send the notification, create the ticket, ect. --->
        <cfif local.sendNotification eq true>
        	<!--- TODO: Send notification --->
            
            
        </cfif>
        
    </cffunction>


    <cffunction name="logInvalidCart" output="false" access="public" returntype="void">
    	<cfargument name="InvalidCartTypeId" type="numeric" default="0" required="false" />
		<cfargument name="ActivationType" type="string" default="" required="false" />
		<cfargument name="CarrierId" type="numeric" default="0" required="false" />
		<cfargument name="Message" type="string" default="" required="false" />
		<cfargument name="CampaignId" type="string" default="" required="false" />
		<cfargument name="DateTimeCreated" type="date" default="#Now()#" required="false" />
		
		<cfset var errorUtil = '' />
		
		<cftry>
			<cfquery datasource="#application.dsn.WirelessAdvocates#">
				INSERT INTO logging.InvalidCart
				(
					InvalidCartTypeId
					, ActivationType
					, CarrierId
					, Message
					, CampaignId
					, DateTimeCreated
				)
				VALUES
				(
					<cfqueryparam value="#arguments.InvalidCartTypeId#" cfsqltype="cf_sql_varchar" />
					, <cfqueryparam value="#arguments.ActivationType#" cfsqltype="cf_sql_varchar" null="#!len(trim( arguments.ActivationType ))#" /> 
					, <cfqueryparam value="#arguments.CarrierId#" cfsqltype="cf_sql_integer" null="#!YesNoFormat( arguments.CarrierId )#" /> 
					, <cfqueryparam value="#arguments.Message#" cfsqltype="cf_sql_varchar" null="#!len(trim( arguments.Message ))#"/>
					, <cfqueryparam value="#arguments.CampaignId#" cfsqltype="cf_sql_integer" null="#!len(trim( arguments.CampaignId ))#" /> 
					, <cfqueryparam value="#arguments.DateTimeCreated#" cfsqltype="cf_sql_timestamp" />
				)
			</cfquery>
			
			<cfcatch type="any">
				<cfset errorUtil = createObject('component', 'cfc.model.Error').init() />
				<cfset errorUtil.sendErrorEmail( cfcatch ) />
			</cfcatch>
		</cftry>

    </cffunction>


    <cffunction name="logPaymentGatewayResponse" output="false" access="public" returntype="void">
    	<cfargument name="OrderId" type="string" required="true" />
		<cfargument name="Type" type="string" required="true" />
		<cfargument name="RequestType" type="string" required="true" />
		<cfargument name="Data" type="string" required="true" />
		<cfargument name="LoggedDateTime" type="date" default="#Now()#" required="false" />
		
		<cfset var errorUtil = '' />
		
		<cftry>
			<cfquery datasource="#application.dsn.wirelessadvocates#">
				INSERT INTO service.PaymentGatewayLog
				(
					OrderId
					, Type
					, RequestType
					, Data
					, LoggedDateTime
				)
				VALUES
				(
					<cfqueryparam value="#arguments.OrderId#" cfsqltype="cf_sql_integer" null="#!len(trim( arguments.OrderId ))#" />
					, <cfqueryparam value="#arguments.Type#" cfsqltype="cf_sql_varchar" null="#!len(trim( arguments.Type ))#" />
					, <cfqueryparam value="#arguments.RequestType#" cfsqltype="cf_sql_varchar" null="#!len(trim( arguments.RequestType ))#" />
					, <cfqueryparam value="#arguments.Data#" cfsqltype="cf_sql_longvarchar" null="#!len(trim( arguments.Data ))#" />
					, <cfqueryparam value="#arguments.LoggedDateTime#" cfsqltype="cf_sql_timestamp" null="#!len(trim( arguments.LoggedDateTime ))#" />
				)
			</cfquery>
			
			<cfcatch type="any">
				<cfset errorUtil = createObject('component', 'cfc.model.Error').init() />
				<cfset errorUtil.sendErrorEmail( cfcatch ) />
			</cfcatch>
		</cftry>

    </cffunction>


    <cffunction name="logMilitaryAuthentication" output="false" access="public" returntype="void">
		<cfargument name="UrlPath" type="string" required="true" />
    	<cfargument name="IsAuthSuccessful" type="boolean" required="true" />
		<cfargument name="AuthData" type="string" required="true" />
		<cfargument name="LoggedDateTime" type="date" default="#Now()#" required="false" />
		
		<cfset var errorUtil = '' />
		
		<cftry>
			<cfquery datasource="#application.dsn.wirelessadvocates#">
				INSERT INTO logging.MilitaryAuthentication
				(
					UrlPath
					, IsAuthSuccessful
					, AuthData
					, TimeStamp
				)
				VALUES
				(
					<cfqueryparam value="#Left(arguments.UrlPath, 500)#" cfsqltype="cf_sql_varchar" null="#!len(trim( arguments.UrlPath ))#" />
					, <cfqueryparam value="#arguments.IsAuthSuccessful#" cfsqltype="cf_sql_integer" null="#!len(trim( arguments.IsAuthSuccessful ))#" />
					, <cfqueryparam value="#Left(arguments.AuthData, 500)#" cfsqltype="cf_sql_varchar" null="#!len(trim( arguments.AuthData ))#" />
					, <cfqueryparam value="#arguments.LoggedDateTime#" cfsqltype="cf_sql_timestamp" null="#!len(trim( arguments.LoggedDateTime ))#" />
				)
			</cfquery>

			<cfcatch type="any">
				<cfset errorUtil = createObject('component', 'cfc.model.Error').init() />
				<cfset errorUtil.sendErrorEmail( cfcatch ) />
			</cfcatch>
		</cftry>

    </cffunction>
</cfcomponent>