<cfcomponent displayname="ATT Submit Completed Order Carrier Response" hint="ATT Submit Completed Order Carrier Response" extends="fw.model.carrierapi.att.attcarrierResponse">

	<cfset AttCarrierHelper = application.wirebox.getInstance("AttCarrierHelper") />
	<cfset BaseCarrier = application.wirebox.getInstance("BaseCarrier") />
	
	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.att.AttSubmitCompletedOrderCarrierResponse">		
		<cfset super.init() />
		<cfreturn this />		
	</cffunction>	

	<cffunction name="isActivationSuccessful" returnType="boolean" access="public" > 
		<cfset var local = structNew() />
		
		<cfset local.isSuccessful = false />
		<cfset local.resp = getResponse() />
		
		<cfif isDefined("local.resp.WasSuccessful") and local.resp.wasSuccessful is "yes">
			<cfset local.isSuccessful = true />
		</cfif>
		
		<cfreturn local.isSuccessful />
	</cffunction>	
	
	<cffunction name="isLineActivationSuccessful" returnType="boolean" access="public" > 
		<cfargument name="LineNo" type="numeric" required="true" /> 
		<cfset var local = structNew() />
		
		<cfset local.isSuccessful = false />
		<cfset local.resp = getResponse() />
		
		<cfif arguments.lineNo LE arraylen(local.resp.OrderResults)>
			<cfset local.result = local.resp.OrderResults[arguments.LineNo] />
			<cfif isdefined("local.result.stepName") and isdefined("local.result.processingComplete") and isdefined("local.result.ExceptionInformation") >
				<cfif local.result.StepName is 3 and ProcessingComplete is "Yes">
					<cfset local.isSuccessful = true />
				</cfif>
			</cfif>
		</cfif>
		
		<cfreturn local.isSuccessful />
	</cffunction>	
	
	<cffunction name="getActivationDetail" returnType="array" access="public" > 
		<cfargument name="orderid" type="numeric" required="true" />
		
		<cfset var local = structNew() />
		
		<cfset local.resp = getResponse() />
		<cfset local.return = structNew() />
		
		<cfif isActivationSuccessful() >
			<cfset local.return.wasSuccessful = true />
			<cfset local.return.message = "All activation(s) were successful" />
			<cfset local.return.step = 3 />
		<cfelse>
			<cfset local.return.wasSuccessful = false />
			<cfset local.qSubmitCompletedOrder = AttCarrierHelper.getSubmitCompletedOrderEntry(arguments.orderid) />
			<cfset local.orderEntry = deserializeJSON(local.qSubmitCompletedOrder.OrderEntry) />
			<cfset local.return.messages = arrayNew(1) />
			<!--- loop thru the orderResult.orderResults --->
			<cfif isDefined("local.resp.orderResults")>
				<cfloop array="#local.resp.orderResults#" index="local.or">
					<cfif isDefined("local.or.StepName")>
						<cfset local.stepName = local.or.stepName />
					<cfelse>
						<cfset local.stepName = "N/A" />
					</cfif>	
					<cfset local.message = structNew() />
					<cfset local.message.stepName = local.stepName />
					<cfset local.message.stepNameDescription = getStepNameDescription(local.StepName) />
					<cfset local.message.processingComplete = local.or.processingComplete />
					<cfif isdefined("local.or.exceptionInformation") >
						<cfset local.message.subscriberNumber = getFormattedSubscriberNumber(local.or.identifier, deserializeJson(local.qSubmitCompletedOrder.orderEntry)) />
						<cfset local.message.exceptionInformation = local.or.exceptionInformation />
					</cfif>
					<cfset arrayAppend(local.return.messages,local.message) />
				</cfloop>
			<cfelse>
				<cfset local.message = structNew() />
				<cfset local.message.stepName = "Unknown" />
				<cfset local.message.ProcessingComplete = "Unknown" />
				<cfset local.message.SubscriberNumber = "Unknown" />
				<cfset local.message.exceptionInformation = "Order Results not present in Submit Order Results - something is wrong. Activation Failed." />
				<cfset arrayAppend(local.return.Messages,local.message) />
			</cfif>
			<cfreturn local.return.messages />
		</cfif>
		
	</cffunction>
	
	<cffunction name="getStepNameDescription" returnType="string" access="private" > 
		<cfargument name="stepName" type="any" required="true" />
		
		<cfswitch expression="#arguments.stepName#">
			<cfcase value="0">
				<cfreturn "FinanceUpgradeParkAgreement" />
			</cfcase>
			<cfcase value="1">
				<cfreturn "LegacyPortNumber" />
			</cfcase>
			<cfcase value="2">
				<cfreturn "LegacyReserveNumber" />
			</cfcase>
			<cfcase value="3">
				<cfreturn "FinanceUpgradeParkDevice" />
			</cfcase>
			<cfcase value="4">
				<cfreturn "FinanceActivateSubscriber" />
			</cfcase>
			<cfcase value="5">
				<cfreturn "LegacyUpgradeDevice" />
			</cfcase>
			<cfcase value="6">
				<cfreturn "LegacyActivateSubscriber" />
			</cfcase>
			<cfdefaultcase>
				<cfreturn "Unknown step name '" & arguments.stepName & "'" />
			</cfdefaultcase>
		</cfswitch>
	</cffunction>	
		
	<cffunction name="getFormattedSubscriberNumber" returnType="string" access="private" > 
		<cfset var local = structNew() />
		<cfset local.unformatted = getSubscriberNumber(argumentCollection=arguments) />
		<cfset local.formatted = left(local.unformatted,3) & '-' & mid(local.unformatted,4,3) & '-' & right(local.unformatted,4) />
		<cfreturn local.formatted />
	</cffunction>
	
	<cffunction name="getSubscriberNumber" returnType="string" access="private" > 
		<cfargument name="identifier" type="string" required="yes" />
		<cfargument name="orderEntry" type="struct" required="yes" />
		
		<cfset var local = structNew() />
		
		<cfloop array="#arguments.orderEntry.OrderItems#" index="local.oi" >
			<cfif isdefined("local.oi.Identifier") and isdefined("local.oi.FinanceAgreementItem")>
				<cfif local.oi.identifier is arguments.identifier>
					<cfreturn local.oi.FinanceAgreementItem.attDeviceOrderItem.subscriber.Number />
				</cfif>
			</cfif>
		</cfloop>
		
		<cfreturn "" />
		
	</cffunction>
	
	<cffunction name="OnMissingMethod" access="public" returntype="any" output="false" hint="Handles missing method exceptions.">
	    <cfargument name="MissingMethodName" type="string" required="true" hint="The name of the missing method." />
    	<cfargument name="MissingMethodArguments" type="struct" required="true" hint="The arguments that were passed to the missing method. This might be a named argument set or a numerically indexed set." />		
	    <cfreturn "AttSubmitCompletedOrderCarrierResponse - #missingMethodName#: method not found" />
	</cffunction>	
	
</cfcomponent>