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
		<cfargument name="rawAddress" type="struct" required="false" default="#getResponse().account.address#" />
		<cfset var address = createObject('component','cfc.model.Address').init() />
		<cfset address.setAddressLine1(rawAddress.addressLine1) />
		<cfset address.setAddressLine2(rawAddress.addressLine2) />
		<cfset address.setCity(rawAddress.city) />
		<cfset address.setCountry(rawAddress.Country) />
		<cfset address.setState(rawAddress.state) />
		<cfset address.setZipCode(rawAddress.zip.zip) />
		<cfset address.setZipCodeExtension(rawAddress.zip.zipExtension) />
		<cfreturn address />
	</cffunction>	
	
	<cffunction name="getSubscribers" access="public" returnType="array">
		<cfset var local = {} />
		<cfset local.resp = getResponse() />
		<cfset local.subscribers = arrayNew(1) />
		<cfloop array="#local.resp.account.subscribers#" index="local.s">
			<cfset local.s.AccountStatus = local.s.accountStatus />
			<cfset local.subscriber = createObject('component','fw.model.carrierApi.Subscriber').init() />
				<cfset local.subscriber.setAccountStatus(local.s.AccountStatus) />
				<cfset local.subscriber.setAddress(getAddress(local.s.address)) />	
				<cfset local.subscriber.setEmail(local.s.contact.emailAddress) />
				<cfset local.subscriber.setNumber(local.s.number) />
			<cfset arrayAppend(local.subscribers,local.subscriber) />		
		</cfloop>
		<cfreturn local.subscribers />
	</cffunction>
	
	
	<cffunction name="OnMissingMethod" access="public" returntype="any" output="false" hint="Handles missing method exceptions.">
	    <cfargument name="MissingMethodName" type="string" required="true" hint="The name of the missing method." />
    	<cfargument name="MissingMethodArguments" type="struct" required="true" hint="The arguments that were passed to the missing method. This might be a named argument set or a numerically indexed set." />		
	    <cfreturn "#missingMethodName#: method not found" />
	</cffunction>

</cfcomponent>