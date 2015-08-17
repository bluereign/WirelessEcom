<cfcomponent output="false" displayname="Session">

	<cffunction name="init" returntype="Session">
		<cfset this.datasource = application.dsn.wirelessadvocates />
		<cfset this.databaseTable = 'Session' / >

		<cfreturn this />
	</cffunction>

	<cffunction name="loadSession" returntype="struct">
<!---
		<cfargument name="cfid" type="string" default="#cookie.cfid#">
		<cfargument name="cftoken" type="string" default="#cookie.cftoken#">
		<cfargument name="createIfDoesNotExist" type="boolean" default="true">
		<cfset var local = structNew()>
 --->
		<cfreturn session>

<!--- TRV: disabling all of this for now since I think we'll launch with session-persistent load balancing
		<!--- get the sql server current date/time --->
		<cfquery name="local.qGetDatabaseDateTime" datasource="#this.datasource#">
			SELECT getdate() as now
		</cfquery>
		<cfparam name="session.lastUpdated" default="#local.qGetDatabaseDateTime.now#">

		<!--- check to see if there's a more recent database session than the one we have in memory --->
		<cfquery name="local.qCheckSessionExpired" datasource="#this.datasource#">
			SELECT
				cfid
			,	cftoken
			,	sessionCurrent =
				CASE
					WHEN lastUpdated = <cfqueryparam cfsqltype="cf_sql_string" value="#session.lastUpdated#"> THEN 1
					ELSE 0
				END
			FROM
				#this.databaseTable#
			WHERE
				cfid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cfid#">
			and	cftoken = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cftoken#">
		</cfquery>

		<!--- if the session appears to be current, then we're done --->
		<cfif local.qCheckSessionExpired.recordCount and local.qCheckSessionExpired.sessionCurrent>
			<cfreturn session>
		<!--- if the session exists but is out of synch --->
		<cfelseif local.qCheckSessionExpired.recordCount and not local.qCheckSessionExpired.sessionCurrent>
			<!--- get the database stored session --->
			<cfquery name="local.qGetSession" datasource="#this.datasource#">
				SELECT
					data
				,	lastUpdated
				FROM
					#this.databaseTable#
				WHERE
					cfid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cfid#">
				and	cftoken = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cftoken#">
			</cfquery>
			<!--- de-serialize the session data --->
			<cfwddx action="wddx2cfml" input="#local.qGetSession.data#" output="session">
			<!--- synch our lastUpdated value in the session --->
			<cfset session.lastUpdated = local.qGetSession.lastUpdated>
			<cfreturn session>
		<!--- if the session does not yet exist in the database and we've been asked to create one --->
		<cfelseif arguments.createIfDoesNotExist>
			<cfreturn createSession(cfid=arguments.cfid,cftoken=arguments.cftoken)>
		</cfif>
 --->
	</cffunction>

	<cffunction name="createSession" returntype="struct">
		<cfargument name="cfid" type="string" default="#cookie.cfid#">
		<cfargument name="cftoken" type="string" default="#cookie.cftoken#">
		<cfset var local = structNew()>

		<!--- get the current database date/time --->
		<cfquery name="local.qGetDatabaseDateTime" datasource="#this.datasource#">
			SELECT getdate() as now
		</cfquery>

		<!--- build an empty struct --->
		<cfset session = structNew()>
		<cfset session.lastUpdated = local.qGetDatabaseDateTime.now>

		<!--- serialize it --->
		<cfwddx action="cfml2wddx" input="#session#" output="local.data">

		<!--- create the session --->
		<cfquery name="local.qCreateSession" datasource="#this.datasource#">
			INSERT INTO #this.databaseTable# (
				cfid
			,	cftoken
			,	lastUpdated
			,	data
			) VALUES (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cfid#">
			,	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cftoken#">
			,	'#local.qGetDatabaseDateTime.now#'
			,	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#local.data#">
			)
		</cfquery>

		<!--- return the final session structure --->
		<cfreturn session>
	</cffunction>

	<cffunction name="flagChanged" returntype="void">
		<cfset request.session.changed = true>
	</cffunction>

	<cffunction name="saveSession" returntype="struct">
<!---
		<cfargument name="cfid" type="string" default="#cookie.cfid#">
		<cfargument name="cftoken" type="string" default="#cookie.cftoken#">
		<cfset var local = structNew()>
		<cfparam name="request.session.changed" type="boolean" default="false">
		<cfparam name="request.config.sessionDatabaseSynchEnabled" type="boolean" default="false">

		<!--- only commit an update if we've been flagged to do so --->
		<cfif request.session.changed and request.config.sessionDatabaseSynchEnabled>
			<!--- get the current database date/time --->
			<cfquery name="local.qGetDatabaseDateTime" datasource="#this.datasource#">
				SELECT getdate() as now
			</cfquery>

			<!--- stamp the session with the database date/time --->
			<cfset session.lastUpdated = local.qGetDatabaseDateTime.now>

			<!--- serialize it --->
			<cfwddx action="cfml2wddx" input="#session#" output="local.data">

			<!--- update the session --->
			<cfquery name="local.qSaveSession" datasource="#this.datasource#">
				UPDATE #this.databaseTable# SET
					lastUpdated = '#local.qGetDatabaseDateTime.now#'
				,	data = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#local.data#">
			</cfquery>
		</cfif>
 --->
		<!--- return the final session structure --->
		<cfreturn session>
	</cffunction>

	<cffunction name="isLoggedIn" access="public" returntype="boolean" output="false">
		<cfset var local = structNew() />
		<cfset local.result = false />

		<cfparam name="session.userId" default="0" type="numeric" />

		<cfif structKeyExists(session, 'userId') and len(trim(session.userId)) and isNumeric(session.userId) and session.userId>
			<cfset local.result = true />
		</cfif>

		<cfreturn local.result />
	</cffunction>

	<cffunction name="hasCart" returntype="boolean">
		<cfset var local = structNew()>
		<cfset local.return = false>
		<cfif isDefined("session.cart") and isStruct(session.cart)>
			<cfset local.return = true>
		</cfif>
		<cfreturn local.return>
	</cffunction>

</cfcomponent>