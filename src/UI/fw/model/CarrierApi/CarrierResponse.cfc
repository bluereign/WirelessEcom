<cfcomponent displayname="Carrier Response" hint="Contains response from carrier info" output="false" extends="fw.model.BaseService">

	<cfset variables.instance = StructNew() />
	
	
	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.CarrierResponse">
		
		<cfset variables.instance.response = {} />
		<cfset variables.instance.status = "" />
		
		<cfreturn this />
		
	</cffunction>
	
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
	
	<cffunction name="setStatus" access="public" returnType="void">
		<cfargument name="status" type="string" required="true" />		
		<cfset variables.instance.status = arguments.status />
	</cffunction>
	
	<cffunction name="getStatus" access="public" returnType="string">
		<cfif isDefined("variables.instance.status")>
			<cfreturn variables.instance.status />
		<cfelse>
			<cfreturn "Undefined" />
		</cfif>
	</cffunction>
	
	<cffunction name="setHttpStatus" access="public" returnType="void">
		<cfargument name="httpStatus" type="string" required="true" />		
		<cfset variables.instance.httpStatus = arguments.httpStatus />
	</cffunction>
	
	<cffunction name="getHttpStatus" access="public" returnType="string">
		<cfif isDefined("variables.instance.httpStatus")>
			<cfreturn variables.instance.httpStatus />
		<cfelse>
			<cfreturn "Undefined" />
		</cfif>
	</cffunction>
	
	
	<!--- Methods that should be implemented in the derived object --->
	<!---<cffunction name="getAccountIdentifier" access="public" returnType="string">
		<cfreturn "getAccountIdentier not implemented" />
	</cffunction>--->
	
	<cffunction name="OnMissingMethod" access="public" returntype="any" output="false" hint="Handles missing method exceptions.">
	    <cfargument name="MissingMethodName" type="string" required="true" hint="The name of the missing method." />
    	<cfargument name="MissingMethodArguments" type="struct" required="true" hint="The arguments that were passed to the missing method. This might be a named argument set or a numerically indexed set." />		
	    <cfreturn "#missingMethodName#: method not found" />
	</cffunction>

		
		


</cfcomponent>