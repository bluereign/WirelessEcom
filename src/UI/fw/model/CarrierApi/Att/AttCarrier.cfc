<cfcomponent displayname="AttCarrier" hint="Interface to ATT Carrier API" extends="fw.model.CarrierApi.BaseCarrier" output="false">
	
	<cfproperty name="AttCarrierHelper" inject="id:AttCarrierHelper" />

	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.Att.AttCarrier">
		<cfargument name="ServiceURL" type="string" required="true" />
		
		<cfset variables.CarrierServiceURL = arguments.serviceURL />
		
		<cfreturn this />
	</cffunction>
	
	<!----------------------------------------------------------------------------------------------------
		Carrier API Entry Points (alphabetical order)
	----------------------------------------------------------------------------------------------------->
	
	<!--- Perform an Account Lookup and retrieve account information for the customer --->
	<cffunction name="account" output="false" access="public" returntype="fw.model.CarrierApi.Att.AttAccountCarrierResponse">
		<cfargument name="requestType" type="numeric" required="false" default="1" /><!--- default to upgrade for now --->
			<cfset var local = structNew() />	
		

		<!--- if productid is passed then load the product and get the imeiType --->
		<cfif structKeyExists(arguments,"productid") >
			<cfset local.qphone = application.model.Phone.getByFilter(idList = arguments.productid) />
			<cfif local.qphone.recordcount and local.qphone.ImeiType is not "">
					<cfset arguments.deviceInfo = {
						Category = local.qphone.ImeiType 
					} />
					<!--- re-save modified request to session --->
					<cfset saveToSession(arguments,"AccountRequest") />
			</cfif>
		</cfif>
		
		<cfhttp url="#variables.CarrierServiceURL#/account/login" method="POST" result="local.cfhttp">
			<cfhttpparam type="header" name="Content-Type" value="application/json" />
    		<cfhttpparam type="body" value="#serializeJSonAddReferenceNumber(arguments)#">
		</cfhttp>
		
		<!--- create the carrier response --->
		<cfset local.carrierResponse =  CreateObject('component', 'fw.model.CarrierApi.Att.AttAccountCarrierResponse').init() />
		<cfset local.carrierResponse = processResults(local.cfhttp,local.carrierResponse) />
		<cfset local.carrierResponse = validateLogin(local.carrierResponse, arguments.passcode ) />
		
		
		<cfreturn processResponse(local.carrierResponse) />	
		
	</cffunction>
	
	<!--- Check to see if a password is returned from ATT. If yes, then does the customer entered passcode match it --->
	<cffunction name="validateLogin" returnType="fw.model.CarrierApi.Att.AttAccountCarrierResponse" access="private">
		<cfargument name="carrierResponse" type="fw.model.CarrierApi.Att.AttAccountCarrierResponse"	required="true" /> 
		<cfargument name="passcode" type="string" required="true" /> 
		<cfset var local = structnew() />
		<cfset local.resp = arguments.carrierResponse.getResponse() />
		<cfif isdefined("local.resp.account.credential.password") and local.resp.account.credential.password is not "">	
			<cfif local.resp.account.credential.password is not arguments.passcode>
				<cfset arguments.carrierResponse.getResponse().responseStatusMessage = "Failed" />
			</cfif>
		</cfif>	
		<cfreturn arguments.carrierResponse />
	</cffunction>
	
	<!------------------------------------------------------------------------------------------------------- 
		Based on Zip Code check to see the supported area codes for the carrier  
	-------------------------------------------------------------------------------------------------------->
	<cffunction name="areaCode" output="false" access="public" returntype="fw.model.CarrierApi.Att.AttAreaCodeCarrierResponse">
		<cfset var local = structNew() />	
		<cfhttp url="#variables.CarrierServiceURL#/areaCode?#argslist(argumentCollection=arguments)#" method="Get" result="local.cfhttp">
		</cfhttp>
		
		<!--- create the carrier response --->
		<cfset local.carrierResponse =  CreateObject('component', 'fw.model.CarrierApi.Att.AttAreaCodeCarrierResponse').init() />
		<cfset local.carrierResponse = processResults(local.cfhttp,local.carrierResponse) />
		<cfreturn processResponse(local.carrierResponse) />	
	</cffunction>
	
	<!------------------------------------------------------------------------------------------------------- 
		Request the Finance Agreement PDf  
	-------------------------------------------------------------------------------------------------------->
	<cffunction name="FinanceAgreement" output="false" access="public" returntype="fw.model.CarrierApi.Att.AttFinanceAgreementCarrierResponse">
		<cfset var local = structNew() />
		<cfset local.body = serializeJSonAddReferenceNumber(arguments) />	
		<cfhttp url="#variables.CarrierServiceURL#/FinanceAgreement" method="Post" result="local.cfhttp">
			<cfhttpparam type="header" name="Content-Type" value="application/json" />
    		<cfhttpparam type="body" value="#local.body#">
		</cfhttp>
		
		<!--- create the carrier response --->
		<cfset local.carrierResponse =  CreateObject('component', 'fw.model.CarrierApi.Att.AttFinanceAgreementCarrierResponse').init() />
		<cfset local.carrierResponse = processResults(local.cfhttp,local.carrierResponse) />
		<cfreturn processResponse(local.carrierResponse) />	
		
	</cffunction>
	
	<!------------------------------------------------------------------------------------------------------- 
		Request Incompatible Offers for a subscriber  
	-------------------------------------------------------------------------------------------------------->
	<cffunction name="IncompatibleOffer" output="false" access="public" returntype="fw.model.CarrierApi.Att.AttIncompatibleOfferCarrierResponse">
		<cfset var local = structNew() />
		<cfset local.carrierResponse =  CreateObject('component', 'fw.model.CarrierApi.Att.AttIncompatibleOfferCarrierResponse').init() />

		<cfif structKeyExists(session.carrierfacade,"accountRequest") is false>
			<cfset local.carrierResponse.errorMessage = "Error: session.cartfacade.accountRequest is missing. Preform account login first." />
		</cfif>
		<cfif structKeyExists(session.carrierfacade,"accountResp") is false>
			<cfset local.carrierResponse.errorMessage = "Error: session.cartfacade.accountresp is missing. Perform account login first." />
		</cfif>
		<cfif structKeyExists(session.carrierfacade.accountResp,"account") is false>
			<cfset local.carrierResponse.errorMessage = "Error: session.cartfacade.accountresp.account is missing." />
		</cfif>
		<cfif structKeyExists(session.carrierfacade.accountResp.account,"subscribers") is false>
			<cfset local.carrierResponse.errorMessage = "Error: session.cartfacade.accountresp.account.subscribers is missing." />
		</cfif>
		<cfif structKeyExists(arguments,"subscriberNumber") is false>
			<cfset local.carrierResponse.errorMessage = "Error: arguments.SubscriberNumber is missing" />
		</cfif>
		<cfif structKeyExists(arguments,"productid") is false AND structKeyExists(arguments,"imeiType") is false>
			<cfset local.carrierResponse.errorMessage = "Error: arguments.productid is missing" />
		</cfif>

		<!--- If the imcompatible offers array does not exist in the accountResp then add it as an empty array --->
		<cfif not structKeyExists(session.carrierFacade.accountResp,"IncompatibleOffers")>
			<cfset session.carrierFacade.accountResp.IncompatibleOffers = arrayNew(1) />
		</cfif>
		
		<!--- Used passed productid to retrieve the IMEI type --->
		<cfif structKeyExists(arguments,"imeiType") >
			<cfset local.imeiType = arguments.ImeiType />
		<cfelseif structKeyExists(arguments,"productid") >
			<cfset local.qphone = application.model.Phone.getByFilter(idList = arguments.productid) />
			<cfif local.qphone.recordcount is 1 and local.qphone.ImeiType is not "">
					<cfset local.imeiType = local.qphone.ImeiType />
			</cfif>
		</cfif>
		
		<!--- If the changeplan and planId arguments are passed then check to see if the current plan is SDDVRP  --->
		<cfif structKeyExists(arguments,"ChangePlan") and structKeyExists(arguments,"planId")> 
			<cfset local.qPlan = application.model.plan.getByFilter(idList = arguments.planid) />
			<cfset local.subscriber = AttCarrierHelper.FindSubscriber(arguments.subscriberNumber) />
			<cfif not structIsEmpty(local.subscriber) >
				<cfset session.carrierFacade.accountResp.Account.Subscribers[local.subscriber.subscriberIndex].WAFlag_PlanHasChanged = true />
				<cfif local.subscriber.PlanInfo.Identifier is "SDDVRP">
					<cfset local.carrierResponse.errorMessage = "Subscriber already using SDDVRP Plan" />
				<cfelse>
					<cfset local.newPlanInfo = structNew() />
					<cfset local.newPlanInfo.PlanInfo = structNew() />
					<cfset local.newPlanInfo.PlanInfo.Identifier = "SDDVRP" />	
					<cfset local.newPlanInfo.PlanInfo.ActionCode = "A" />	
					<cfset local.newPlanInfo.PlanInfo.isGroupPlan = false />	
					<cfif isdefined("local.subscriber.additionalOfferings")	>
						<cfset local.newPlanInfo.AdditionalOffers = local.subscriber.additionalOfferings />
						<cfset local.AttPlanItem = structNew() />
						<cfset local.AttPlanItem.Action = "A" />
						<cfset local.AttPlanItem.Code = local.qplan.carrierBillCode />
						<!---<cfset local.AttPlanItem.Code = "MMSDG50GB" />---><!--- override for testing only --->
						<cfset local..AttPlanItem.TypeCode = "G" />
						<cfset arrayAppend(local.newPlanInfo.AdditionalOffers, local.AttPlanItem) />
					</cfif>
				</cfif>
			</cfif>
		</cfif>		
		
		<!--- See if we already have the ImeiType cached. If yes, just return --->
		<!---<cfset local.subscriberNumbers = getEligibleSubscriberList() />--->
		<cfset local.ImeiTypes = getIncompatibleOffersImeiTypes() />
		<cfif arguments.changePlan is false and listfind(local.ImeiTypes,local.imeiType)>
			<cfset local.carrierResponse.errorMessage = "Subscriber Number/ImeiType already in cache" />
		</cfif> 
		
		<!--- if the Plan Identifier is the same as  --->
	
		<cfif not structKeyExists(local.carrierResponse,"errorMessage") >
			<cfset local.eligibleCount = 0 />
			<cfloop list="#local.ImeiTypes#" index="local.i">
				<cfloop array="#session.carrierfacade.accountResp.Account.subscribers#" index="local.s">	
					<cfif local.s.upgradeInfo.isEligible>	
						<cfset local.eligibleCount = local.eligibleCount+1 />
						<cfset local.incompatibleOffer_args = {
							subscriberNumber = #local.s.number#,
							BillingMarketCode = #session.carrierfacade.accountresp.account.billingMarketCode#,
							ImeiType = #local.imeiType#,
							Channel = #AttCarrierHelper.getChannelValue()#
						} />
						<!--- add in the appropriate planInfo and additional offers --->
						<cfif structKeyExists(local,"newPlanInfo")>
							<cfset local.incompatibleOffer_args.planInfo = local.newPlanInfo.planInfo />
							<cfif structKeyExists(local.newPlanInfo,"additionalOffers") >
								<cfset local.incompatibleOffer_args.additionalOffers = local.newPlanInfo.AdditionalOffers />
							</cfif>
						<cfelse>
							<cfset local.incompatibleOffer_args.planInfo = local.s.planInfo />
						</cfif>
				
						<cfset local.body = serializeJSonAddReferenceNumber(local.incompatibleOffer_args) />	
						<!--- save the request to the session --->
						<cfset saveToSession(local.incompatibleOffer_args,"IncompatibleOfferRequest") />	
						<cfset saveToSession(local.body,"IncompatibleOfferRequest_JSON") />
					
						<cfhttp url="#variables.CarrierServiceURL#/IncompatibleOffer" method="Post" result="local.cfhttp">
							<cfhttpparam type="header" name="Content-Type" value="application/json" />
				    		<cfhttpparam type="body" value="#local.body#">
						</cfhttp>
						
						<!--- create the carrier response --->
						<cfset local.carrierResponse =  CreateObject('component', 'fw.model.CarrierApi.Att.AttIncompatibleOfferCarrierResponse').init() />
						<cfset local.carrierResponse = processResults(local.cfhttp,local.carrierResponse) />
					
						<!--- remove the current incompatible offers for this subscriberNumber --->
						<cfif isdefined("local.subscriber")>
							<cfloop from="#arrayLen(session.carrierFacade.accountResp.IncompatibleOffers)#" to="1" step="-1" index="local.i">
								<cfif session.carrierFacade.accountResp.IncompatibleOffers[local.i].SubscriberNumber is arguments.subscriberNumber 
									  and session.carrierFacade.accountResp.IncompatibleOffers[local.i].ImeiType is local.imeiType>
									<cfset arrayDeleteAt(session.carrierFacade.accountResp.IncompatibleOffers,local.i) />
								</cfif>
							</cfloop>
						</cfif>
						
						<!--- store the retrieved incompatible offers in the accountResp structure --->
						<cfset arrayAppend(session.carrierfacade.accountResp.IncompatibleOffers,local.carrierResponse.getResponse())	/>			
							
					</cfif>
				</cfloop>
			</cfloop>
		</cfif>
		
		<cfif not structKeyExists(local,"carrierResponse") >
			<cfset local.carrierResponse = structNew() />
			<cfset local.carrierResponse.errorMessage = "No eligible subscribers" />
		</cfif>
		<cfreturn local.carrierResponse />
	</cffunction>
	
	<!------------------------------------------------------------------------------------------------------- 
		Return a list of eligible subscribers
	-------------------------------------------------------------------------------------------------------->
	<cffunction name="getEligibleSubscriberList" output="false" access="public" returntype="string">
		
		<cfset var local = structNew() />
		
		<!--- make sure we have a list of subscribers to search --->
		<cfif isDefined("session.carrierfacade.accountresp.subscribers") is false or arrayIsEmpty(session.carrierfacade.accountresp.subscribers) >
			<cfreturn ""/>
		</cfif>
		
		<!--- search the list of subscribers for those that are upgrade eligible --->
		<cfset local.eligibleSubscribers = "" />
		<cfloop array="#session.carrierfacade.accountresp.subscribers#" index="local.s">
			<cfif local.s.upgradeInfo.IsEligible>
				<cfset local.eligibleSubscribers = listappend(local.eligibleSubscribers,local.s.number) />
			</cfif>
		</cfloop>
		
		<cfreturn local.eligibleSubscribers />
		
	</cffunction>
	
	<!------------------------------------------------------------------------------------------------------- 
		Return a list of current ImeiTypes in IncompatibleOffers
	-------------------------------------------------------------------------------------------------------->
	<cffunction name="getIncompatibleOffersImeiTypes" output="false" access="public" returntype="string">
		
		<cfset var local = structNew() />
		
		<!--- make sure we have a list of subscribers to search --->
		<cfif isDefined("session.carrierfacade.accountresp.IncompatibleOffers") is false or arrayIsEmpty(session.carrierfacade.accountresp.incompatibleOffers) >
			<cfreturn ""/>
		</cfif>
		
		<!---  search thru and find a list of unique IMEITypes --->
		<cfset local.imeiTypes = "" />
		<cfloop array="#session.carrierfacade.accountresp.incompatibleOffers#" index="local.i">
			<cfif not listfind(local.imeiTypes,local.i.imeiType)>
				<cfset local.imeiTypes = listappend(local.imeiTypes,local.i.imeiType) />
			</cfif>
		</cfloop>
		
		<cfreturn local.imeiTypes />
		
	</cffunction>
	
	<!------------------------------------------------------------------------------------------------------- 
		Store the Finance Agreement PDf  in the database
	-------------------------------------------------------------------------------------------------------->
	<cffunction name="SaveFinanceAgreement" output="false" access="public" returntype="string">
		<cfset var local = structNew() />
		
		<cfif structKeyExists(arguments,"orderid") is false or isNumeric(arguments.orderid) is false>
			<cfreturn "Argument 'orderid' is missing or non-numeric" />
		</cfif>
		<cfif structKeyExists(arguments,"InstallmentPlanId") is false or isNumeric(arguments.installmentPlanId) is false>
			<cfreturn "Argument 'installmentPlanId' is missing or non-numeric" />
		</cfif>
		<cfif structKeyExists(arguments,"subscriberNumber") is false or isNumeric(arguments.subscriberNumber) is false>
			<cfreturn "Argument 'subscriberNumber' is missing or non-numeric" />
		</cfif>
		<cfif structKeyExists(arguments,"accountNumber") is false or isNumeric(arguments.accountNumber) is false>
			<cfreturn "Argument 'accountNumber' is missing or non-numeric" />
		</cfif>
		<cfif structKeyExists(arguments,"nameOnAccount") is false>
			<cfreturn "Argument 'nameOnAccount' is missing" />
		</cfif>
		<cfif structKeyExists(arguments,"acceptanceDate") is false or isDate(arguments.acceptanceDate) is false>
			<cfreturn "Argument 'acceptanceDate' is missing or non-date" />
		</cfif>
		<cfif structKeyExists(arguments,"Channel") is false or isNumeric(arguments.Channel) is false>
			<cfreturn "Argument 'channel' is missing or non-numeric" />
		</cfif>
		<cfif structKeyExists(arguments,"agreementTypeId") is false or isNumeric(arguments.agreementTypeId) is false>
			<cfreturn "Argument 'agreementTypeId' is missing or non-numeric" />
		</cfif>
		<cfif structKeyExists(arguments,"agreementEntry") is false>
			<cfreturn "Argument 'agreementEntry' is missing" />
		</cfif>
		
		<cfstoredproc datasource="wirelessadvocates" procedure="service.AttFinanceAgreementSave" result="local.result">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#arguments.orderid#" > 
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="109" > 
			<cfprocparam cfsqltype="CF_SQL_BIGINT" value="#arguments.installmentPlanId#" > 
			<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.subscriberNumber#" > 
			<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#trim(arguments.accountNumber)#" > 
			<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#trim(arguments.nameOnAccount)#" > 
			<cfprocparam cfsqltype="CF_SQL_DATE" value="#arguments.acceptanceDate#" > 
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#arguments.channel#" > 
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#arguments.agreementTypeId#" > 
			<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#trim(arguments.agreementEntry)#" > 
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="1" > <!--- Processing Status, Always 1 --->
		</cfstoredproc>
		
		<cfreturn "success" />
	</cffunction>
	
	<!------------------------------------------------------------------------------------------------------- 
		Request the Finance Agreement PDf  
	-------------------------------------------------------------------------------------------------------->
	<cffunction name="validateAddress" output="false" access="public" returntype="fw.model.CarrierApi.Att.AttAddressValidationCarrierResponse">
		<cfset var local = structNew() />

		<!--- convert WA address object to a address request object --->
		<cfif structKeyexists(arguments,"address") and getMetaData(arguments.address).fullname is 'cfc.model.address'>
			<cfset local.validateAddressRequest = structNew() />
			<cfset local.validateAddressRequest.Address = structNew() />
			<cfset local.validateAddressRequest.Address.addressLine1 = arguments.address.getAddressLine1() />
			<cfset local.validateAddressRequest.Address.addressLine2 = arguments.address.getAddressLine2() />
			<cfset local.validateAddressRequest.Address.city = arguments.address.getCity() />
			<cfset local.validateAddressRequest.Address.state = arguments.address.getState() />
			<cfset local.validateAddressRequest.Address.zip = structNew() />
			<cfset local.validateAddressRequest.Address.zip.zip = arguments.address.getZipcode() />
			<cfset local.validateAddressRequest.Address.zip.zipExtension = arguments.address.getZipCodeExtension() />
			<cfset local.validateAddressRequest.Address.country = arguments.address.getCountry() />			
			<cfset local.validateAddressRequest.channel = arguments.channel />
			
			<cfset local.body = serializeJSonAddReferenceNumber(local.validateAddressRequest) />	
			<cfhttp url="#variables.CarrierServiceURL#/address" method="Post" result="local.cfhttp">
				<cfhttpparam type="header" name="Content-Type" value="application/json" />
	    		<cfhttpparam type="body" value="#local.body#">
			</cfhttp>
			
			<!--- create the carrier response --->
			<cfset local.carrierResponse =  CreateObject('component', 'fw.model.CarrierApi.Att.AttAddressValidationCarrierResponse').init() />
			<cfset local.carrierResponse = processResults(local.cfhttp,local.carrierResponse) />
			<cfreturn processResponse(local.carrierResponse) />	
		</cfif>		
	</cffunction>
	
	<!------------------------------------------------------------------------------------------------------- 
		Submit the Order to the Carrier 
	-------------------------------------------------------------------------------------------------------->
	<cffunction name="submitOrder" output="false" access="public" returntype="fw.model.CarrierApi.Att.AttSubmitOrderCarrierResponse">
		<cfset var local = structNew() />
		
		<cfset local.body = serializeJSonAddReferenceNumber(arguments) />
		
		<cfset local.saveSubmitOrderArgs = {
			carrierId = 109,
			orderId = session.order.getOrderId(),
			orderType = "SubmitOrder",
			orderEntry = "#local.body#",
			orderResult = ""
		} />
		
		<!--- Save the submitOrder request before we call carrier just in case we have a non-retryable failure --->
		<cfset saveSubmitOrder(argumentCollection = local.saveSubmitOrderArgs) />	
		<cfhttp url="#variables.CarrierServiceURL#/Order" method="Post" result="local.cfhttp">
			<cfhttpparam type="header" name="Content-Type" value="application/json" />
    		<cfhttpparam type="body" value="#local.body#">
		</cfhttp>
		
		<!--- create the carrier response --->
		<cfset local.carrierResponse =  CreateObject('component', 'fw.model.CarrierApi.Att.AttSubmitOrderCarrierResponse').init() />
		<cfset local.carrierResponse = processResults(local.cfhttp,local.carrierResponse) />
		
		<!--- Update the save submitOrder with the carrier response --->
		<cfset local.saveSubmitOrderArgs.orderResult = serializeJSonAddReferenceNumber(local.carrierResponse.getResponse()) />
		<cfset saveSubmitOrder(argumentCollection = local.saveSubmitOrderArgs) />	
		
		<cfreturn processResponse(local.carrierResponse) />			
	</cffunction>	
	
	<cffunction name="submitCompletedOrder" output="false" access="public" returntype="fw.model.CarrierApi.Att.AttSubmitOrderCarrierResponse">
		<cfset var local = structNew() />
		
		<cfset local.body = serializeJSonAddReferenceNumber(arguments) />
		
		<cfset local.saveSubmitOrderArgs = {
			carrierId = 109,
			orderId = session.order.getOrderId(),
			orderType = "SubmitCompletedOrder",
			orderEntry = "#local.body#",
			orderResult = ""
		} />
		
		<!--- Save the submitOrder request before we call carrier just in case we have a non-retryable failure --->
		<cfset saveSubmitOrder(argumentCollection = local.saveSubmitOrderArgs) />	
		<cfhttp url="#variables.CarrierServiceURL#/Order/Complete" method="POST" result="local.cfhttp">
			<cfhttpparam type="header" name="Content-Type" value="application/json" />
    		<cfhttpparam type="body" value="#local.body#">
		</cfhttp>
		
		<!--- create the carrier response --->
		<cfset local.carrierResponse =  CreateObject('component', 'fw.model.CarrierApi.Att.AttSubmitOrderCarrierResponse').init() />
		<cfset local.carrierResponse = processResults(local.cfhttp,local.carrierResponse) />
		
		<!--- Update the save submitOrder with the carrier response --->
		<cfset local.saveSubmitOrderArgs.orderResult = serializeJSonAddReferenceNumber(local.carrierResponse.getResponse()) />
		<cfset saveSubmitOrder(argumentCollection = local.saveSubmitOrderArgs) />	
		
		<cfreturn processResponse(local.carrierResponse) />			
	</cffunction>	
	
	<cffunction name="saveSubmitOrder" output="false" access="public" returntype="boolean">
		
		<cftry>
			<cfstoredproc procedure="service.OrderSubmissionSave" datasource="wirelessadvocates">
				<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.orderid#" />
				<cfprocparam cfsqltype="cf_sql_integer" value="109" />
				<cfprocparam cfsqltype="cf_sql_varchar" value="Ready" />
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.OrderType#" />
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.OrderEntry#" />
				<cfif arguments.orderResult is not "">
					<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.OrderResult#" />
				</cfif>
			</cfstoredproc>
			<cfcatch type="any">
				<cfreturn false />
			</cfcatch>
		</cftry>
		<cfreturn true />
	</cffunction>
	
	
	<!-------------------------------------------------------------------------------------------------------- 
		Look at the results of the call and set appropriate fields in the carrier response	
	--------------------------------------------------------------------------------------------------------->
	
	<cffunction name="processResults" returnType="Any" access="private">
		<cfargument type="struct" name="cfhttpResult" required="true" /> 
		<cfargument type="any" name="carrierResponse" required="true" /> 
		<cfset var emptyObj = {} />
		
		<!--- create the carrier response --->
		<cfset carrierResponse.setHttpStatus(arguments.cfhttpResult.statusCode) />
		<cfif isdefined("arguments.cfhttpResult.responseHeader.status_code") and isNumeric(arguments.cfhttpResult.responseHeader.status_code) >
			<cfset carrierResponse.setHttpStatusCode(arguments.cfhttpResult.responseHeader.status_code) />
		</cfif>
		
		<!--- Copy the response or an empty object into the carrierResponse --->
		<cfif isJson(arguments.cfhttpResult.fileContent)>			
			<cfset carrierResponse.setResponse(deserializeResponse(arguments.cfhttpResult.fileContent)) />
				<!---<cfset carrierResponse.setResponse(deserializeJSON(arguments.cfhttpResult.fileContent,true)) />--->
		<cfelse>
			<cfset carrierResponse.setResponse(emptyObj) />
		</cfif>
		
		<cfif arguments.cfhttpResult.responseHeader.status_code is 200>			
			<cfset carrierResponse.setResult(true) />
			<cfset carrierResponse.setResultDetail("OK") />
		<cfelse>
			<cfset carrierResponse.setResult(false) />
			<cfset carrierResponse.setResultDetail("Processing Error") />
		</cfif>
		
		<cfreturn carrierResponse />
	
	</cffunction>

	<!---
		Get the Service URL
	 --->
	<cffunction name="getServiceURL" returnType="string" access="public">
		<cfreturn variables.CarrierServiceURL />
	</cffunction>

</cfcomponent>