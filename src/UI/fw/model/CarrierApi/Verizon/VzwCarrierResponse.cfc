<cfcomponent displayname="VZW Carrier Response" hint="Contains response from carrier info" output="false" extends="fw.model.CarrierApi.CarrierResponse">

	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.Verizon.VzwCarrierResponse">
		
		<cfset super.init() />
		<cfset variables.instance.carrierId = 42 />
		<cfset variables.instance.carrierName = "Verizon" />
		<cfreturn this />
		
	</cffunction>
	
	<cffunction name="getAccountIdentifier" access="public" returnType="string">
		<cfset var resp = getResponse() />
		<cfif isdefined("resp.CustomerAccount.accountIdentifier")>
			<cfreturn resp.CustomerAccount.accountIdentifier />
		<cfelse>
			<cfreturn ""/>
		</cfif>
	</cffunction>
	
	<cffunction name="getActiveLines" access="public" returnType="numeric">
		<cfset var resp = getResponse() />
		<cfif isdefined("resp.CustomerAccount.activeLines") and isNumeric(resp.CustomerAccount.activeLines) >
			<cfreturn resp.CustomerAccount.activeLines />
		<cfelse>
			<cfreturn -1 />
		</cfif>
	</cffunction>
	
	<cffunction name="getCustomerEmail" access="public" returnType="string">
		<cfset var resp = getResponse() />
		<cfif isDefined("resp.CustomerAccount.email")>
			<cfreturn #resp.customeraccount.email#/>
		<cfelse>
			<cfreturn "n/a" />
		</cfif>
	</cffunction>
	
	<cffunction name="getCustomerFirstName" access="public" returnType="string">
		<cfset var resp = getResponse() />
		<cfif isDefined("resp.customerAccount.FirstName")>
			<cfreturn resp.customerAccount.FirstName />
		<cfelse>
			<cfreturn "n/a" />
		</cfif>
	</cffunction>

	<cffunction name="getCustomerLastName" access="public" returnType="string">
		<cfset var resp = getResponse() />
		<cfif isDefined("resp.customerAccount.LastName")>
			<cfreturn resp.customerAccount.LastName />
		<cfelse>
			<cfreturn "n/a" />
		</cfif>
	</cffunction>

	<cffunction name="getAddress" access="public" returnType="cfc.model.address">
		<cfargument name="rawAddress" type="struct" required="false" default="#getResponse().CustomerAccount.address#" />
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
		<cfloop array="#local.resp.customerAccount.subscribers#" index="local.s">
			<!---<cfset local.s.AccountStatus("not implemented") />--->
			<cfset local.subscriber = createObject('component','fw.model.carrierApi.Subscriber').init() />
				<cfset local.subscriber.setAccountStatus("not implemented") />
				<!---<cfset local.subscriber.setAddress(getAddress(local.s.address)) />--->	
				<!---<cfset local.subscriber.setEmail(local.s.contact.emailAddress) />--->
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