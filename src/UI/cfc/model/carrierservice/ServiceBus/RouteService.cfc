<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.ServiceBus.RouteService">
		<cfargument name="EndPoint" type="string" required="true" />
		<cfargument name="AuthSecretKey" type="string" required="true" />
		<cfargument name="AuthPassword" type="string" required="true" />		
		<cfargument name="AuthUsername" type="string" required="true" />

		<cfscript>
			variables.instance = {};
			variables.instance.EndPoint = arguments.EndPoint;
			variables.instance.AuthSecretKey = arguments.AuthSecretKey;
			variables.instance.AuthPassword = arguments.AuthPassword;
			variables.instance.AuthUsername = arguments.AuthUsername;
		</cfscript>

		<cfreturn this />
	</cffunction>


	<cffunction name="Route" output="false" access="public" returntype="Struct">
		<cfargument name="ServiceBusRequest" type="cfc.model.carrierservice.ServiceBus.ServiceBusRequest" required="false" />
		<cfset var response = '' />

		<cfhttp url="#variables.instance.EndPoint#/Route" method="post" result="response" 
				username="#Trim(Decrypt(variables.instance.AuthUsername, variables.instance.AuthSecretKey, 'RC5', 'Base64'))#"
				password="#Trim(Decrypt(variables.instance.AuthPassword, variables.instance.AuthSecretKey, 'RC5', 'Base64'))#">
			<cfhttpparam type="header" name="Content-Type" value="application/json" />
			<cfhttpparam type="body" value="#arguments.ServiceBusRequest.toJson()#" />
		</cfhttp>
		
		<cfset response = deserializeJson( response.filecontent.toString() ) />
		
		<!---
		<cftry>
			<cfset response = deserializeJson( response.filecontent.toString() ) />

			<cfcatch>
				<cfdump var="#response#" />
				<cfdump var="#response.filecontent#" />
				<cfabort />
			</cfcatch>
		</cftry>
		--->
		

		<cfreturn response />
	</cffunction>


	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn variables.instance />
	</cffunction>

</cfcomponent>