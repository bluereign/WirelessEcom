<cfcomponent displayname="CarrierFacade" hint="Provides a simplified carrier api to UI" extends="fw.model.BaseService" output="false">
	
	<cfproperty name="AttCarrier" inject="id:AttCarrier" />
	<cfproperty name="VzwCarrier" inject="id:VzwCarrier" />
	<cfproperty name="MockCarrier" inject="id:MockCarrier" />
	<cfproperty name="ChannelConfig" inject="id:ChannelConfig" />
	
	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.CarrierFacade">
		<cfreturn this />
	</cffunction>
	
	<!----------------------------------------------------------------------------------------------------
		Carrier API Entry Points (alphabetical order)
	----------------------------------------------------------------------------------------------------->

	<cffunction name="account" output="false" access="public" returntype="any">
		<cfset var local = structNew() />
		<cfset saveToSession(arguments,"AccountRequest") />		
		<cfset local.args = passthruArgs(argumentCollection = arguments ) />
		<cfset local.beginTicks = getTickCount() />
		<cfset local.accountResp =  carrierObject(arguments.carrierId).account(argumentCollection = local.args) />	
		<cfset local.endTicks = getTickCount() />
		<cfset local.accountResp.setTicks( local.endTicks - local.beginTicks) />
		<cfset saveToSession(local.accountResp,"AccountResp") />
		<cfreturn local.accountResp />	
	</cffunction>		

	<cffunction name="areaCode" output="false" access="public" returntype="any">
		<cfset var local = structNew() />		
		<cfset saveToSession(arguments,"AreaCodeRequest") />		
		<cfset local.args = passthruArgs(argumentCollection = arguments ) />
		<cfset local.beginTicks = getTickCount() />
		<cfset local.AreaCodeResp =  carrierObject(arguments.carrierId).areaCode(argumentCollection = local.args) />	
		<cfset local.endTicks = getTickCount() />
		<cfset local.areaCodeResp.setTicks( local.endTicks - local.beginTicks) />
		<cfset saveToSession(local.areaCodeResp,"AreaCodeResp") />
		<cfreturn local.areaCodeResp />
	</cffunction>	
	
	<cffunction name="financeAgreement" output="false" access="public" returntype="any">
		<cfset var local = structNew() />		
		<cfset saveToSession(arguments,"FinanceAgreementRequest") />		
		<cfset local.args = passthruArgs(argumentCollection = arguments ) />
		<cfset local.beginTicks = getTickCount() />
		<cfset local.FinanceAgreementResp =  carrierObject(arguments.carrierId).FinanceAgreement(argumentCollection = local.args) />	
		<cfset local.endTicks = getTickCount() />
		<cfset local.FinanceAgreementResp.setTicks( local.endTicks - local.beginTicks) />
		<cfset saveToSession(local.FinanceAgreementResp,"FinanceAgreementResp") />
		<cfreturn local.FinanceAgreementResp />
	</cffunction>
	
	<cffunction name="IncompatibleOffer" output="false" access="public" returntype="any">
		<cfset var local = structNew() />		
		<cfset saveToSession(arguments,"IncompatibleOfferRequest") />		
		<cfset local.args = passthruArgs(argumentCollection = arguments ) />
		<cfset local.beginTicks = getTickCount() />
		<cfset local.IncompatibleOfferResp =  carrierObject(arguments.carrierId).IncompatibleOffer(argumentCollection = local.args) />	
		<cfset local.endTicks = getTickCount() />
		<cfset local.IncompatibleOfferResp.setTicks( local.endTicks - local.beginTicks) />
		<cfset saveToSession(local.IncompatibleOfferResp,"IncompatibleOfferResp") />
		<cfreturn local.IncompatibleOfferResp />
	</cffunction>
	
	<cffunction name="saveFinanceAgreement" output="false" access="public" returntype="any">
		<cfset var local = structNew() />		
		<cfset local.args = passthruArgs(argumentCollection = arguments ) />
		<cfset local.result =  carrierObject(arguments.carrierId).SaveFinanceAgreement(argumentCollection = local.args) />	
		<cfreturn local.result />
	</cffunction>

	<cffunction name="validateAddress" output="false" access="public" returntype="any">
		<cfset var local = structNew() />		
		<cfset saveToSession(arguments,"AddressValidationRequest") />		
		<cfset local.args = passthruArgs(argumentCollection = arguments ) />
		<cfset local.beginTicks = getTickCount() />
		<cfset local.AddressValidationResp =  carrierObject(arguments.carrierId).ValidateAddress(argumentCollection = local.args) />	
		<cfset local.endTicks = getTickCount() />
		<cfset local.AddressValidationResp.setTicks( local.endTicks - local.beginTicks) />
		<cfset saveToSession(local.AddressValidationResp,"AddressValidationResp") />
		<cfreturn local.AddressValidationResp />
	</cffunction>
	
	<cffunction name="submitOrder" output="false" access="public" returntype="any">
		<cfset var local = structNew() />		
		<cfset saveToSession(arguments,"SubmitOrderRequest") />		
		<cfset local.args = passthruArgs(argumentCollection = arguments ) />
		<cfset local.beginTicks = getTickCount() />
		<cfset local.SubmitOrderResp =  carrierObject(arguments.carrierId).submitOrder(argumentCollection = local.args) />	
		<cfset local.endTicks = getTickCount() />
		<cfset local.SubmitOrderResp.setTicks( local.endTicks - local.beginTicks) />
		<cfset saveToSession(local.SubmitOrderResp,"SubmitOrderResp") />
		<cfreturn local.SubmitOrderResp />
	</cffunction>
	
	<cffunction name="submitCompletedOrder" output="false" access="public" returntype="any">
		<cfset var local = structNew() />		
		<cfset saveToSession(arguments,"SubmitCompletedOrderRequest") />		
		<cfset local.args = passthruArgs(argumentCollection = arguments ) />
		<cfset local.beginTicks = getTickCount() />
		<cfset local.SubmitCompletedOrderResp =  carrierObject(arguments.carrierId).submitCompletedOrder(argumentCollection = local.args) />	
		<cfset local.endTicks = getTickCount() />
		<cfset local.SubmitCompletedOrderResp.setTicks( local.endTicks - local.beginTicks) />
		<cfset saveToSession(local.SubmitCompletedOrderResp,"SubmitCompletedOrderResp") />
		<cfreturn local.SubmitCompletedOrderResp />
	</cffunction>


	<!---<cffunction name="upgradeEligibility" output="false" access="public" returntype="any">		
		<cfset var args = passthruArgs(argumentCollection = arguments ) />
		<cfreturn carrierObject(arguments.carrierId).upgradeEligibility(argumentCollection = args) />		
	</cffunction>		
	
	<cffunction name="areaCode" output="false" access="public" returntype="any">		
		<cfset var args = passthruArgs(argumentCollection = arguments ) />
		<cfreturn carrierObject(arguments.carrierId).areaCode(argumentCollection = args) />		
	</cffunction>--->		
	
	<!--------------------------------------------------------------------------------------------------
		Helper Functions		
	 --------------------------------------------------------------------------------------------------->

	<!---
		Receives an argument collection and returns collection minus args on the excludedArgsList		
	 --->
	<cffunction name="passthruArgs" output="false" returnType="any">
		<cfargument name="excludedArgsList" type="string" required="false" default="carrierId,excludedArgsList" />
			
		<cfset var args = {} />
		
		<cfloop collection="#arguments#" item="theArg">
			<cfif not listFindNocase(arguments.excludedArgsList,theArg) >
				<cfset args["#theArg#"] = arguments[theArg] />
			</cfif>
		</cfloop>
		
		<cfreturn args />
		
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

	<!---
		return the carrier interface object based on carrierId
	 --->
	<cffunction name="carrierObject" output="false" access="private" returntype="Any">
		<cfargument name="carrierId" type="numeric" required="true" />
		<cfscript>
			switch (arguments.carrierid) {
				case 0:   // Mock
					return variables.MockCarrier;
					break;
				case 109: // ATT
					return variables.AttCarrier;
					break;
				case 42:  // Verizon
					return variables.VzwCarrier;
					break;
				default: 
					return "";
					break;				
			}
		</cfscript>
		
	</cffunction>	
	
	<cffunction name="saveToSession" returnType="void" access="public">
		<cfargument name="objToStore" type="any" required="true" />
		<cfargument name="objName" type="string" required="true" />

		<!--- create the session storage structure if it does not already exist --->		
		<cfif not structKeyExists(session,"carrierFacade")>
			<cfset session.carrierFacade = structNew() />
		</cfif>
		
		<cfif isObject(objToStore) >
			<cfset structInsert(session.carrierFacade, arguments.objName, arguments.objToStore.getResponse(),true) />		
		<cfelse>
			<cfset structInsert(session.carrierFacade, arguments.objName, arguments.objToStore,true) />		
		</cfif>
		
	</cffunction>
	
	
</cfcomponent>