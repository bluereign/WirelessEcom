<cfcomponent displayname="Carrier" hint="generic carrier component" extends="fw.model.BaseService" output="false">

	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.BaseCarrier">
		<cfreturn this />
	</cffunction>

	<cffunction name="serializeJSonAddReferenceNumber" access="public" returnType="string">
		<cfargument name="args" type="struct" required="true" />
	
		<cfif isdefined("session.sessionid")>
			<cfset arguments.args.ReferenceNumber = session.sessionid />
		</cfif>
		
		<cfreturn serializeJSON(arguments.args) />
	
	</cffunction>
	
	<!--- Helper methods --->
	<cffunction name="processResponse" returnType="Any" access="public">
		<cfargument name="carrierResponse"	type="any" required="true" />
		
		<cfset var local = structNew() />
		<cfset local.resp = arguments.carrierResponse.getResponse() />
		<cfif structKeyExists(local.resp,"ResponseStatusMessage") and len(local.resp.ResponseStatusMessage) and local.resp.ResponseStatusMessage is not "null">
			<cfset arguments.carrierResponse.setResult(false) />
			<cfset arguments.carrierResponse.setResultDetail(local.resp.ResponseStatusMessage) />
		<cfelse>			
			<cfset arguments.carrierResponse.setResult(true) />
			<cfset arguments.carrierResponse.setResultDetail("Success") />
		</cfif>
		<cfreturn arguments.carrierResponse />		
	</cffunction>	
	
	
	<!---
		For get calls converts args into a query string	
	--->
	<cffunction name="argsList" access="private" returnType="string">

		<cfset var arglist = "" />
		
		<cfloop collection="#arguments#" item="theArg">
			<cfif len(arglist)>
				<cfset arglist = arglist & "&" />
			</cfif>
			<cfset arglist = arglist & #theArg# & "=" & arguments[theArg] />
		</cfloop>		
		
		<cfreturn arglist />
		
	</cffunction>
</cfcomponent>