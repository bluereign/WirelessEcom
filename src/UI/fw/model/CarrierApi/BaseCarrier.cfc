<cfcomponent displayname="Carrier" hint="generic carrier component" extends="fw.model.BaseService" output="false">

	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.BaseCarrier">
		<cfreturn this />
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