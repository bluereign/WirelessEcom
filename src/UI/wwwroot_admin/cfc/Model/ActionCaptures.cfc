<cfcomponent name="ActionCaptures">

	<cffunction name="init" access="public" returntype="ActionCaptures" output="false">

		<cfreturn this />
	</cffunction>

	<cffunction name="insertActionCapture" access="public" returntype="boolean" output="false">
		<cfargument name="adminUserId" required="true" type="numeric" />
		<cfargument name="actionId" required="true" type="numeric" />
		<cfargument name="orderId" required="false" type="numeric" />
		<cfargument name="emailAddress" required="false" type="string" />
		<cfargument name="message" required="false" type="string" default="" />

		<cfset var insertActionCaptureReturn = false />
		<cfset var qry_insertActionCapture = '' />

		<cfquery name="qry_insertActionCapture" datasource="#application.dsn.wirelessadvocates#">
			INSERT INTO	admin.ActionCaptures
			(
				captureDate,
				adminUserId,
				actionId,
				orderId,
				emailAddress,
				message
			)
			VALUES
			(
				GETDATE(),
				<cfqueryparam value="#arguments.adminUserId#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#arguments.actionId#" cfsqltype="cf_sql_integer" />,
				<cfif structKeyExists(arguments, 'orderId')>
					<cfqueryparam value="#arguments.orderId#" cfsqltype="cf_sql_integer" />,
				<cfelse>
					NULL,
				</cfif>
				<cfif structKeyExists(arguments, 'emailAddress') and len(trim(arguments.emailAddress))>
					<cfqueryparam value="#trim(arguments.emailAddress)#" cfsqltype="cf_sql_varchar" maxlength="255" />,
				<cfelse>
					NULL,
				</cfif>
				<cfif len(trim(arguments.message))>
					<cfqueryparam value="#trim(arguments.message)#" cfsqltype="cf_sql_varchar" />
				<cfelse>
					null
				</cfif>
			)
		</cfquery>

		<cfset insertActionCaptureReturn = true />

		<cfreturn insertActionCaptureReturn />
	</cffunction>

</cfcomponent>