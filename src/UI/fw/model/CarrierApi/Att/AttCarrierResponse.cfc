<cfcomponent displayname="ATT Carrier Response" hint="Contains response from carrier info" output="false" extends="fw.model.CarrierApi.CarrierResponse">

	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.att.AttCarrierResponse">
		
		<cfset super.init() />
		
		<cfreturn this />
		
	</cffunction>
	
	<cffunction name="getAccountIdentifier" access="public" returnType="string">
		<cfset var resp = getResponse() />
		<cfif isdefined("resp.account.accountIdentifier")>
			<cfreturn resp.account.accountIdentifier />
		<cfelse>
			<cfreturn ""/>
		</cfif>
	</cffunction>
	
	<cffunction name="getActiveLines" access="public" returnType="numeric">
		<cfset var resp = getResponse() />
		<cfif isdefined("resp.account.activeLines") and isNumeric(resp.account.activeLines) >
			<cfreturn getResponse().account.activeLines />
		<cfelse>
			<cfreturn 0 />
		</cfif>
	</cffunction>
	
	<cffunction name="getAddress" access="public" returnType="cfc.model.address">
		<cfset var resp = getResponse() />
		<cfset var address = createObject('component','cfc.model.Address').init() />
		<cfset address.setAddressLine1(resp.account.address.addressLine1) />
		<cfset address.setAddressLine2(resp.account.address.addressLine2) />
		<cfset address.setCity(resp.account.address.city) />
		<cfset address.setCountry(resp.account.address.Country) />
		<cfset address.setState(resp.account.address.state) />
		<cfset address.setZipCode(resp.account.address.zip.zip) />
		<cfset address.setZipCodeExtension(resp.account.address.zip.zipExtension) />
		<cfreturn address />
	</cffunction>	
	
	<cffunction name="OnMissingMethod" access="public" returntype="any" output="false" hint="Handles missing method exceptions.">
	    <cfargument name="MissingMethodName" type="string" required="true" hint="The name of the missing method." />
    	<cfargument name="MissingMethodArguments" type="struct" required="true" hint="The arguments that were passed to the missing method. This might be a named argument set or a numerically indexed set." />		
	    <cfreturn "#missingMethodName#: method not found" />
	</cffunction>

</cfcomponent>