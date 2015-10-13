﻿<cfcomponent displayname="FullAPI Subscriber" hint="Generic Subscriber model" output="false">

	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.Subscriber">
		
		<cfset variables.instance = structNew() />
		<cfset setAccountStatus("undefined") />	
		<cfset setEmail("") />	
		<cfset setNumber("") />	
		
		<cfreturn this />
	</cffunction>
	
	<!---
		Setters / Getters	
	 --->
	
	<cffunction name="setResponse" access="public" returnType="boolean">
		<cfargument name="response" type="any" required="true" hint="obj of response from carrier" > 
		
		<cfif isStruct(arguments.response)>
			<cfset variables.instance.response = arguments.response />
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
		
	</cffunction>	
	
	<cffunction name="getResponse" access="public" returnType="struct">
		<cfreturn variables.instance.response />
	</cffunction>	
	
	
	<cffunction name="setAccountStatus" returnType="void" access="public">
		<cfargument name="accountStatus" type="string" required="true">
		<cfset variables.instance.accountStatus = arguments.accountStatus />
	</cffunction>

	<cffunction name="getAccountStatus" returnType="string" access="public">
		<cfif isDefined("variables.instance.accountStatus")>
			<cfreturn variables.instance.accountStatus />
		<cfelse>
			<cfreturn "undefined" />
		</cfif>
	</cffunction>	
	
	<cffunction name="setAddress" returnType="void" access="public">
		<cfargument name="address" type="cfc.model.address" required="true" />
		<cfset variables.instance.address = arguments.address />
	</cffunction>
	
	<cffunction name="getAddress" returnType="cfc.model.address" access="public">
		<cfif isDefined("variables.instance.address") >
			<cfreturn variables.instance.address />
		<cfelse>
			<cfreturn CreateObject( "component", "cfc.model.Address" ).init(  ) />
		</cfif>
	</cffunction>	
	
	<cffunction name="setEmail" returnType="void" access="public">
		<cfargument name="email" type="string" required="true" />
		<cfset variables.instance.email = arguments.email />
	</cffunction>
	
	<cffunction name="getEmail" returnType="string" access="public">
		<cfreturn variables.instance.email />
	</cffunction>

	<cffunction name="setNumber" returnType="void" access="public">
		<cfargument name="number" type="string" required="true" />
		<cfset variables.instance.number = arguments.number />
	</cffunction>
	
	<cffunction name="getNumber" returnType="string" access="public">
		<cfreturn variables.instance.number />
	</cffunction>
	
	<cffunction name="setEligibilityDate" returnType="void" access="public">
		<cfargument name="dateString" type="date" required="true" />
		<cfset variables.instance.eligibilityDate = arguments.dateString />
	</cffunction>
	
	<cffunction name="getEligibilityDate" returnType="any" access="public">
		<cfif isdefined("variables.instance.eligibilityDate") >
			<cfreturn variables.instance.eligibilityDate />
		<cfelse>
			<cfreturn "" />
		</cfif>		
	</cffunction>
	
	<cffunction name="setEligibilityStatus" returnType="void" access="public">
		<cfargument name="eligibilityStatus" type="string" required="true" />
		<cfset variables.instance.eligibilityStatus = arguments.eligibilityStatus />
	</cffunction>
	
	<cffunction name="getEligibilityStatus" returnType="string" access="public">
		<cfif isdefined("variables.instance.eligibilityStatus") >
			<cfreturn variables.instance.eligibilityStatus />
		<cfelse>
			<cfreturn "unknown" />
		</cfif>		
	</cffunction>
	
	<cffunction name="setIsEligible" returnType="void" access="public">
		<cfargument name="IsEligible" type="string" required="true" />
		<cfset variables.instance.isEligible = arguments.isEligible />
	</cffunction>
	
	<cffunction name="getIsEligible" returnType="string" access="public">
		<cfif isdefined("variables.instance.isEligible") >
			<cfreturn variables.instance.isEligible />
		<cfelse>
			<cfreturn "unknown" />
		</cfif>		
	</cffunction>

	<cffunction name="setRatePlan" returnType="void" access="public">
		<cfargument name="carrierbillcode" type="string" required="true" />
		<cfset var local = structNew() />
		<cfset local.ratePlan = createObject('component', 'cfc.model.plan').init() />
		<cfset variables.instance.ratePlan = local.ratePlan.getDetailByBillCode(arguments.carrierBillcode) />
	</cffunction>
	
	<cffunction name="getRatePlan" returnType="query" access="public">
		<cfif isdefined("variables.instance.ratePlan") and isQuery(variables.instance.ratePlan) >
			<cfreturn variables.instance.ratePlan />
		<cfelse>
			<cfreturn QueryNew("") />
		</cfif>
	</cffunction>
	
	<cffunction name="OnMissingMethod" access="public" returntype="any" output="false" hint="Handles missing method exceptions.">
	    <cfargument name="MissingMethodName" type="string" required="true" hint="The name of the missing method." />
    	<cfargument name="MissingMethodArguments" type="struct" required="true" hint="The arguments that were passed to the missing method. This might be a named argument set or a numerically indexed set." />		
	    <cfreturn "#missingMethodName#: method not found" />
	</cffunction>
	
</cfcomponent>