<cfcomponent displayname="VZW Carrier Response" hint="Contains response from carrier info" output="false" extends="fw.model.carrierapi.Verizon.VzwCarrierResponse">

	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.Verizon.VzwAccountCarrierResponse">
		<cfset super.init() />
		<cfset variables.instance.subscribers = arraynew(1) />
		<cfreturn this />		
	</cffunction>
	
	<cffunction name="getAccountIdentifier" access="public" returnType="string">
		<cfset var local = structNew() />

		<cfset local.resp = getResponse() />
		<cfif isdefined("local.resp.CustomerAccount.accountIdentifier")>
			<cfreturn local.resp.CustomerAccount.accountIdentifier />
		<cfelse>
			<cfreturn ""/>
		</cfif>
	</cffunction>
	
	<cffunction name="getActiveLines" access="public" returnType="numeric">
		<cfset var local = structNew() />
		
		<cfset local.resp = getResponse() />
		<cfif isdefined("local.resp.CustomerAccount.activeLines") and isNumeric(local.resp.CustomerAccount.activeLines) >
			<cfreturn local.resp.CustomerAccount.activeLines />
		<cfelse>
			<cfreturn -1 />
		</cfif>
	</cffunction>
	
	<cffunction name="getCustomerEmail" access="public" returnType="string">
		<cfset var local = structNew() />
		
		<cfset local.resp = getResponse() />
		<cfif isDefined("local.resp.CustomerAccount.email")>
			<cfreturn #local.resp.customeraccount.email#/>
		<cfelse>
			<cfreturn "n/a" />
		</cfif>
	</cffunction>
	
	<cffunction name="getCustomerFirstName" access="public" returnType="string">
		<cfset var local = structNew() />
		<cfset local.resp = getResponse() />
		<cfif isDefined("local.resp.customerAccount.FirstName")>
			<cfreturn local.resp.customerAccount.FirstName />
		<cfelse>
			<cfreturn "n/a" />
		</cfif>
	</cffunction>

	<cffunction name="getCustomerLastName" access="public" returnType="string">
		<cfset var local = structNew() />
		<cfset local.resp = getResponse() />
		<cfif isDefined("local.resp.customerAccount.LastName")>
			<cfreturn local.resp.customerAccount.LastName />
		<cfelse>
			<cfreturn "n/a" />
		</cfif>
	</cffunction>

	<cffunction name="getAddress" access="public" returnType="cfc.model.address">
		<cfargument name="rawAddress" type="any" required="false" default="#structNew()#" />
		<cfset var local = structNew() />	
			
		<cfif not isStruct(arguments.rawAddress)>
			<cfset arguments.rawAddress = structNew() />
		</cfif>
		<cfif structIsEmpty(arguments.rawAddress)>
			<cfset local.resp = getResponse() />
			<cfif isdefined('local.resp.CustomerAccount.address')>
				<cfset arguments.rawAddress = local.resp.CustomerAccount.address />
			</cfif>
		</cfif>


		<cfset local.address = createObject('component','cfc.model.Address').init() />
		<cfif structKeyExists(rawaddress,"AddressLine1")>
			<cfset local.address.setAddressLine1(rawAddress.addressLine1) />
		</cfif>	
		<cfif structKeyExists(rawaddress,"AddressLine2")>
			<cfset local.address.setAddressLine2(rawAddress.addressLine2) />
		</cfif>
		<cfif structKeyExists(rawaddress,"city")>
			<cfset local.address.setCity(rawAddress.city) />
		</cfif>
		<cfif structKeyExists(rawaddress,"country")>
			<cfset local.address.setCountry(rawAddress.Country) />
		</cfif>
		<cfif structKeyExists(rawaddress,"state")>
			<cfset local.address.setState(rawAddress.state) />
		</cfif>
		<cfif structKeyExists(rawaddress,"zip.zip")>
			<cfset local.address.setZipCode(rawAddress.zip.zip) />
		</cfif>
		<cfif structKeyExists(rawaddress,"zip.zipExtension")>
			<cfset local.address.setZipCodeExtension(rawAddress.zip.zipExtension) />
		</cfif>
		<cfreturn local.address />
	</cffunction>	
	
	<cffunction name="getSubscribers" access="public" returnType="array">
		<cfset var local = structNew() />
		<cfset local.resp = getResponse() />
		<cfset local.subscribers = arrayNew(1) />
		<cfloop array="#local.resp.customerAccount.subscribers#" index="local.s">
			<!---<cfset local.s.AccountStatus("not implemented") />--->
			<cfset local.subscriber = createObject('component','fw.model.carrierApi.Verizon.VzwSubscriber').init() />
				<cfset local.subscriber.setAccountStatus("not implemented") />
				<cfset local.subscriber.setResponse(local.s) />
				
				<!---<cfset local.subscriber.setAddress(getAddress(local.s.address)) />--->	
				<!---<cfset local.subscriber.setEmail(local.s.contact.emailAddress) />--->
				<cfset local.subscriber.setEmail("not available") />
					
				<!---<cfset local.subscriber.setEligibilityDate(ParseDateTime(listgetat(local.s.upgradeInfo.eligibilityDate,1,"T"))) />
				<cfset local.subscriber.setEligibilityStatus(local.s.upgradeInfo.EligibilityStatus) />--->
				<cfset local.subscriber.setIsEligible(local.s.upgradeInfo.IsEligible) />
					
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