﻿<cfcomponent displayname="CarrierFacade" hint="Provides a simplified carrier api to UI" extends="fw.model.BaseService" output="false">
	
	<cfproperty name="AttCarrier" inject="id:AttCarrier" />
	<cfproperty name="VzwCarrier" inject="id:VzwCarrier" />
	<cfproperty name="MockCarrier" inject="id:MockCarrier" />
	
	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.CarrierFacade">
		<cfreturn this />
	</cffunction>
	
	<!----------------------------------------------------------------------------------------------------
		Carrier API Entry Points (alphabetical order)
	----------------------------------------------------------------------------------------------------->

	<cffunction name="account" output="false" access="public" returntype="any">
		<cfset var local = structNew() />		
		<cfset local.args = passthruArgs(argumentCollection = arguments ) />
		<cfset local.beginTicks = getTickCount() />
		<cfset local.accountResp =  carrierObject(arguments.carrierId).account(argumentCollection = local.args) />	
		<cfset local.endTicks = getTickCount() />
		<cfset local.accountResp.setTicks( local.endTicks - local.beginTicks) />
		<cfreturn local.accountResp />	
	</cffunction>		

	<cffunction name="areaCode" output="false" access="public" returntype="any">
		<cfset var local = structNew() />		
		<cfset local.args = passthruArgs(argumentCollection = arguments ) />
		<cfset local.beginTicks = getTickCount() />
		<cfset local.AreaCodeResp =  carrierObject(arguments.carrierId).areaCode(argumentCollection = local.args) />	
		<cfset local.endTicks = getTickCount() />
		<cfreturn local.areaCodeResp />
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
	

	
	
</cfcomponent>