<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.Sprint.CustomerLookupRequest">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setMdn" output="false" access="public" returntype="void">
		<cfargument name="Mdn" type="string" default="0" required="false" />
		<cfset variables.instance.Mdn = arguments.Mdn />
	</cffunction>
	<cffunction name="getMdn" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Mdn />
	</cffunction>

	<cffunction name="setSecretKey" output="false" access="public" returntype="void">
		<cfargument name="SecretKey" type="string" default="0" required="false" />
		<cfset variables.instance.SecretKey = arguments.SecretKey />
	</cffunction>
	<cffunction name="getSecretKey" output="false" access="public" returntype="string">
		<cfreturn variables.instance.SecretKey />
	</cffunction>
	
	<cffunction name="setSSN" output="false" access="public" returntype="void">
		<cfargument name="SSN" type="string" default="0" required="false" />
		<cfset variables.instance.SSN = arguments.SSN />
	</cffunction>
	<cffunction name="getSSN" output="false" access="public" returntype="string">
		<cfreturn variables.instance.SSN />
	</cffunction>

	<cffunction name="setAnswerToSecurityQuestion" output="false" access="public" returntype="void">
		<cfargument name="AnswerToSecurityQuestion" type="string" default="0" required="false" />
		<cfset variables.instance.AnswerToSecurityQuestion = arguments.AnswerToSecurityQuestion />
	</cffunction>
	<cffunction name="getAnswerToSecurityQuestion" output="false" access="public" returntype="string">
		<cfreturn variables.instance.AnswerToSecurityQuestion />
	</cffunction>

	<cffunction name="setReferenceNumber" output="false" access="public" returntype="void">
		<cfargument name="ReferenceNumber" type="string" default="0" required="false" />
		<cfset variables.instance.ReferenceNumber = arguments.ReferenceNumber />
	</cffunction>
	<cffunction name="getReferenceNumber" output="false" access="public" returntype="string">
		<cfreturn variables.instance.ReferenceNumber />
	</cffunction>

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn variables.instance />
	</cffunction>

</cfcomponent>