<cfcomponent output="false" displayname="Address">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.SecurityQuestion">
		<cfreturn this />
	</cffunction>
    
	<cffunction name="getSecurityQuestions" output="false" access="public" returntype="query">
		<cfset var qQuestions = '' />
		
		<cfquery name="qQuestions" datasource="#application.dsn.wirelessadvocates#">
			SELECT
				SecurityQuestionId
				, QuestionText
				, IsActive
			FROM service.SecurityQuestion
			WHERE IsActive = 1
		</cfquery>
		
		<cfreturn qQuestions />
	</cffunction>
	
	<cffunction name="getSecurityQuestionById" output="false" access="public" returntype="query">
		<cfargument name="SecurityQuestionId" type="numeric" required="true" />
		<cfset var qQuestions = '' />
		
		<cfquery name="qQuestions" datasource="#application.dsn.wirelessadvocates#">
			SELECT
				SecurityQuestionId
				, QuestionText
			FROM service.SecurityQuestion
			WHERE SecurityQuestionId = <cfqueryparam value="#arguments.SecurityQuestionId#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn qQuestions />
	</cffunction>	

</cfcomponent>