<cfcomponent output="false" displayname="Response">

	<cffunction name="init" returntype="Response">
        <cfset variables.instance = structNew()>

        <cfset setResultCode("")>
        <cfset setMessage("")>
        <cfset setErrorCode("")>
        <cfset setErrorMessage("")>
        <cfset setDetail("")>
		<cfset setServiceResponseSubcode('') />

        <cfset  variables.instance.result = structNew()> <!--- define an empty result placeholder --->

        <cfreturn this >
	</cffunction>

    <!--- getters --->
    <cffunction name="getResult" returntype="any">
		<cfreturn variables.instance.result>
	</cffunction>

    <cffunction name="getResultCode" returntype="string">
		<cfreturn variables.instance.resultCode>
	</cffunction>

    <cffunction name="getMessage" returntype="string">
		<cfreturn variables.instance.message>
	</cffunction>

    <cffunction name="getErrorCode" returntype="string">
		<cfreturn variables.instance.carrierErrorCode>
	</cffunction>

    <cffunction name="getErrorMessage" returntype="string">
		<cfreturn variables.instance.carrierErrorMessage>
	</cffunction>

    <cffunction name="getDetail" returntype="string">
		<cfreturn variables.instance.carrierResponse>
	</cffunction>

	<cffunction name="getServiceResponseSubcode" access="public" returntype="string" output="false">
		<cfreturn variables.instance.serviceResponseSubcode />
	</cffunction>

	<cffunction name="setServiceResponseSubcode" access="public" returntype="void" output="false">
		<cfargument name="serviceResponseSubcode" type="string" output="false" />

		<cfset variables.instance.serviceResponseSubcode = arguments.serviceResponseSubcode />
	</cffunction>

	<!--- setters --->
 	<cffunction name="setResult" returntype="void">
		<cfargument name="result" type="any" required="true">
		<cfset variables.instance.result = arguments.result>
	</cffunction>

    <cffunction name="setResultCode" returntype="void">
		<cfargument name="resultCode" type="string" required="true">
		<cfset variables.instance.resultCode = arguments.resultCode>
	</cffunction>

    <cffunction name="setMessage" returntype="void">
		<cfargument name="message" type="string" required="true">
		<cfset variables.instance.message = arguments.message>
	</cffunction>

    <cffunction name="setErrorCode" returntype="void">
		<cfargument name="carrierErrorCode" type="string" required="true">
		<cfset variables.instance.carrierErrorCode = arguments.carrierErrorCode>
	</cffunction>

    <cffunction name="setErrorMessage" returntype="void">
		<cfargument name="carrierErrorMessage" type="string" required="true">
		<cfset variables.instance.carrierErrorMessage = arguments.carrierErrorMessage>
	</cffunction>

    <cffunction name="setDetail" returntype="void">
		<cfargument name="carrierResponse" type="string" required="true">
		<cfset variables.instance.carrierResponse = arguments.carrierResponse>
	</cffunction>
	
	<!--- DUMP --->

	<cffunction name="dump" access="public" output="true" return="void">
		<cfargument name="abort" type="boolean" default="FALSE" />
		<cfdump var="#variables.instance#" />
		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>

	<!--- GETINSTANCE --->

	<cffunction name="getInstanceData" access="public" output="false" return="struct">
		<cfargument name="recursive" type="boolean" required="false" default="false">
		<cfset var local = structNew()>
		<cfset local.instance = duplicate(variables.instance)>

		<cfif arguments.recursive>
			<cfloop collection="#local.instance#" item="local.key">
				<cfif not isSimpleValue(local.instance[local.key])>
					<cfif isArray(local.instance[local.key])>
						<cfloop from="#1#" to="#arrayLen(local.instance[local.key])#" index="local.ii">
							<cfset local.instance[local.key][local.ii] = local.instance[local.key][local.ii].getInstanceData(arguments.recursive)>
						</cfloop>
					<cfelseif structKeyExists(local.instance[local.key],"getInstanceData")>
						<cfset local.instance[local.key] = local.instance[local.key].getInstanceData(arguments.recursive)>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>

		<cfreturn local.instance>
	</cffunction>

</cfcomponent>