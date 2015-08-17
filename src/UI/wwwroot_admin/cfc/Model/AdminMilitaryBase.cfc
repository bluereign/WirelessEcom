<cfcomponent displayname="AdminMilitaryBase" output="false">
	
	<cffunction name="init" access="public" returntype="AdminMilitaryBase" output="false">

		<cfreturn this />
	</cffunction>
	
	<cffunction name="getMilitaryBases" access="public" returntype="query" output="false">
		<cfargument name="kiosk" required="false" type="any" default="0" />

		<cfquery name="local.getMilitaryBases" datasource="#application.dsn.wirelessadvocates#" >
			SELECT		*
			FROM		ups.NearbyBase
			WHERE		active = '1'
			<!---<cfif isNumeric(arguments.kiosk)>
				and kiosk = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.kiosk#" />
			</cfif>--->
			ORDER BY completeName
		</cfquery>

		<cfreturn local.getMilitaryBases />
	</cffunction>
	
	<cffunction name="getNearbyBase" access="public" returntype="string" output="false">
		<cfargument name="oldBase" required="true" type="string" />

		<cfquery name="local.newBase" datasource="#application.dsn.wirelessadvocates#" >
			SELECT		ups.udf_GetNearbyBase (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.oldBase#" />			
			) as newBaseName
		</cfquery>
		
		<cfif local.newBase.RecordCount is 0>
			<cfreturn "" />
		<cfelse>	
			<cfreturn local.newBase.newBaseName />
		</cfif>
	</cffunction>
	
</cfcomponent>