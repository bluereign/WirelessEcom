<cfcomponent extends="fw.model.BaseGateway" output="false">
	
	<!----------------- Constructor ---------------------->
		
	<cffunction name="init" access="public" output="false" returntype="GeoGateway">
		<cfreturn this>
	</cffunction>
	
	<!-------------------- Public ------------------------>
		
	<cffunction name="getStateByAbbreviation" access="public" output="false" returntype="query" hint="Returns full state name.">
		<cfargument name="abbreviation" type="string" required="true">
		
		<cfset var theState = "">
		
		<cfquery name="theState" datasource="#variables.dsn#">
			SELECT state
			FROM dbo.states
			WHERE state_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.abbreviation)#">
		</cfquery>
		
		<cfreturn theState>
    </cffunction>
    
    <cffunction name="getAllStates" access="public" returntype="query" output="false">
		<cfset var qStates = "">
	
		<cfif not structKeyExists(application, 'getStates')>
			<cfquery name="qStates" datasource="#variables.dsn#">
				SELECT		state, state_2 AS stateCode
				FROM		dbo.states AS s WITH (NOLOCK)
				WHERE		state_2	NOT IN ('UST','UL','APO','AP','AE','AA')
				ORDER BY	state
			</cfquery>

			<cfset application.getStates = qStates />
		<cfelse>
			<cfset qStates = application.getStates />
		</cfif>

		<cfreturn qStates />
	</cffunction>
	
	<cffunction name="getAllStatesAPO" access="public" output="false" returntype="query">    
    	<cfset var qStates = "" />

		<cfquery name="qStates" datasource="#variables.dsn#">
			SELECT		state, state_2 AS stateCode
			FROM		dbo.states AS s WITH (NOLOCK)
			WHERE		state_2	NOT IN ('UST','UL','APO')
			ORDER BY	state_id
		</cfquery>

		<cfreturn qStates />
    </cffunction>
	
</cfcomponent>