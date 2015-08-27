<cfcomponent displayname="VzwCarrier" hint="Interface to Vzw Carrier API" extends="fw.model.BaseService" output="false">

	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.Verizon.VzwCarrier">
		<cfargument name="ServiceURL" type="string" required="true" />
		
		<cfset variables.CarrierServiceURL = arguments.serviceURL />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="account" output="false" access="public" returntype="any">
		<cfset var returnobj = {} />
		
		<cfhttp url="#variables.CarrierServiceURL#?#argslist(arguments)#" method="GET">
		</cfhttp>
		
		<cfif isJson(cfhttp.filecontent)>
			<cfset returnObj =  deserializeJson(cfhttp.filecontent,true) />
			<cfset returnObj.status = 0 />
		<cfelse>
			<cfset returnObj.status = 404 />
		</cfif>
		
	</cffunction>
	
	
	<cffunction name="argsList" access="private" returnType="string">
		<cfset var arglist = "" />
		
		<cfloop collection="#arguments#" item="theArg">
			<cfif not listFindNocase(arguments.excludedArgsList,theArg) >
				<cfif len(arglist)>
					<cfset arglist = arglist & "&" />
				</cfif>
				<cfset arglist = arglist & theArg & "=" & arguments[theArg] />
			</cfif>
		</cfloop>		
		
	</cffunction>

</cfcomponent>