<cfcomponent hint="gets channels from database" output="false">

	<cffunction name="init" access="public" hint="Initalizes the Component">
		<cfreturn this>
	</cffunction>

	<cffunction name="getAllChannels" access="public" output="false" returntype="query" hint="">
		<cfset var qryChannels = '' />

		<cfquery name="qryChannels" datasource="#application.dsn.wirelessAdvocates#">
			select *
			from catalog.Channel
		</cfquery>

		<cfreturn qryChannels />
	</cffunction>

	<cffunction name="getChannelByID" access="public" output="false" returntype="query" hint="">
		<cfargument name="channelID" type="numeric" required="true"/>

		<cfset var qryChannel = '' />

		<cfquery name="qryChannel" datasource="#application.dsn.wirelessAdvocates#">
			select *
			from catalog.Channel
			where channelID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.channelID#">
		</cfquery>

		<cfreturn qryChannel />
	</cffunction>

	<cffunction name="getChannelByName" access="public" output="false" returntype="query" hint="">
		<cfargument name="channel" type="string" required="true"/>

		<cfset var qryChannel = '' />

		<cfquery name="qryChannel" datasource="#application.dsn.wirelessAdvocates#">
			select *
			from catalog.Channel
			where channel = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.channel#">
		</cfquery>

		<cfreturn qryChannel />
	</cffunction>

</cfcomponent>