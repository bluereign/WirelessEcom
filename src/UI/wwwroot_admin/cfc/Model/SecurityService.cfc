<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="SecurityService">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isFunctionalityAccessable" output="false" access="public" returntype="boolean">
		<cfargument name="UserId" type="numeric" required="true" />
		<cfargument name="FunctionalityGuid" type="string" required="true" />
		<cfset var isAccessable = false />
		
		<cfquery name="qRole" datasource="#application.dsn.wirelessAdvocates#">
			SELECT 
				u.User_ID UserId
				, rf.FunctionalityGuid
			FROM Users u
			INNER JOIN account.UserRole ur ON ur.UserId = u.User_ID
			INNER JOIN account.RoleFunctionality rf ON rf.RoleGuid = ur.RoleGuid
			WHERE 
				u.User_ID = <cfqueryparam value="#arguments.UserId#" cfsqltype="cf_sql_integer" />
				AND FunctionalityGuid = <cfqueryparam value="#arguments.FunctionalityGuid#" cfsqltype="cf_sql_varchar" /> 
		</cfquery>

		<cfscript>
			if (qRole.RecordCount)
			{
				isAccessable = true;
			}
		</cfscript>
		
		<cfreturn isAccessable />
	</cffunction>	

</cfcomponent>