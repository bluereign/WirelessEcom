<cfcomponent displayname="ATT Carrier Response" hint="Contains response from carrier info" output="false" extends="fw.model.CarrierApi.Att.AttCarrierResponse">


	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.att.AttCarrierResponse">		
		<cfset super.init() />
		<cfset variables.instance.subscribers = arraynew(1) />
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
			<cfreturn resp.account.activeLines />
		<cfelse>
			<cfreturn -1 />
		</cfif>
	</cffunction>
	
	<cffunction name="getAddress" access="public" returnType="cfc.model.address">
		<cfargument name="rawAddress" type="any" required="false" default="structNew()" />
		<cfset var local = structNew() />	
			
		<cfif not isStruct(arguments.rawAddress)>
			<cfset arguments.rawAddress = structNew() />
		</cfif>
		<cfif structIsEmpty(arguments.rawAddress)>
			<cfset local.resp = getResponse() />
			<cfif isdefined('resp.account.address')>
				<cfset arguments.rawAddress = resp.account.address />
			</cfif>
		</cfif>
		<cfset local.address = createObject('component','cfc.model.Address').init() />
		<cfif isdefined("rawAddress.addressLine1")>
			<cfset local.address.setAddressLine1(rawAddress.addressLine1) />
		</cfif>
		<cfif isdefined("rawAddress.addressLine2")>
			<cfset local.address.setAddressLine2(rawAddress.addressLine2) />
		</cfif>
		<cfif isdefined("rawAddress.city")>
			<cfset local.address.setCity(rawAddress.city) />
		</cfif>
		<cfif isdefined("rawAddress.country")>
			<cfset local.address.setCountry(rawAddress.Country) />
		</cfif>
		<cfif isdefined("rawAddress.state")>
			<cfset local.address.setState(rawAddress.state) />
		</cfif>
		<cfif isdefined("rawAddress.zip.zip")>
			<cfset local.address.setZipCode(rawAddress.zip.zip) />
		</cfif>
		<cfif isdefined("rawAddress.zip.zipExtension")>
			<cfset local.address.setZipCodeExtension(rawAddress.zip.zipExtension) />
		</cfif>
		<cfreturn local.address />
	</cffunction>	
	
	<cffunction name="getCustomerEmail" access="public" returnType="string">
		<cfset var resp = getResponse() />
		<cfif isDefined("resp.account.customer.emailAddress")>
			<cfreturn resp.account.customer.emailAddress />
		<cfelse>
			<cfreturn "n/a" />
		</cfif>
	</cffunction>
	
	<cffunction name="getCustomerFirstName" access="public" returnType="string">
		<cfset var resp = getResponse() />
		<cfif isDefined("resp.account.customer.contact.FirstName")>
			<cfreturn resp.account.customer.contact.FirstName />
		<cfelse>
			<cfreturn "n/a" />
		</cfif>
	</cffunction>

	<cffunction name="getCustomerLastName" access="public" returnType="string">
		<cfset var resp = getResponse() />
		<cfif isDefined("resp.account.customer.contact.LastName")>
			<cfreturn resp.account.customer.contact.LastName />
		<cfelse>
			<cfreturn "n/a" />
		</cfif>
	</cffunction>
	
	<cffunction name="getSubscribers" access="public" returnType="array">
		<cfset var local = {} />
		<cfset local.resp = getResponse() />
		<cfset local.subscribers = arrayNew(1) />
		<cfif isdefined("local.resp.account.subscribers") and arrayLen(local.resp.account.subscribers)>
			<cfloop array="#local.resp.account.subscribers#" index="local.s">
				<cfset local.subscriber = createObject('component','fw.model.carrierApi.Att.AttSubscriber').init() />
					<cfset local.subscriber.setResponse(local.s) />
					<cfif structKeyexists(local.s,"AccountStatus") >
						<cfset local.subscriber.setAccountStatus(local.s.AccountStatus) />
					</cfif>
					<cfset local.subscriber.setAddress(getAddress(local.s.address)) />	
					<cfset local.subscriber.setEmail(local.s.contact.emailAddress) />
					<cfset local.subscriber.setNumber(local.s.number) />
					<cfset local.subscriber.setEligibilityDate(ParseDateTime(listgetat(local.s.upgradeInfo.eligibilityDate,1,"T"))) />
					<cfset local.subscriber.setEligibilityStatus(local.s.upgradeInfo.EligibilityStatus) />
					<cfset local.subscriber.setIsEligible(local.s.upgradeInfo.IsEligible) />
					<cfset local.subscriber.setRatePlan(local.s.planInfo.Identifier) />
					
					<cfset arrayAppend(local.subscribers,local.subscriber) />
			</cfloop>
		</cfif>
		<cfreturn local.subscribers />
	</cffunction>
	
	
	
	<cffunction name="OnMissingMethod" access="public" returntype="any" output="false" hint="Handles missing method exceptions.">
	    <cfargument name="MissingMethodName" type="string" required="true" hint="The name of the missing method." />
    	<cfargument name="MissingMethodArguments" type="struct" required="true" hint="The arguments that were passed to the missing method. This might be a named argument set or a numerically indexed set." />		
	    <cfreturn "AttAccountCarrierResponse - #missingMethodName#: method not found" />
	</cffunction>

</cfcomponent>