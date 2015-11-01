<cfcomponent displayname="CarrierFacade" hint="Provides a simplified carrier api to UI" extends="fw.model.BaseService" output="false">
	
	<cfproperty name="AttCarrierHelper" inject="id:AttCarrierHelper" />
	<cfproperty name="VzwCarrierHelper" inject="id:VzwCarrierHelper" />
	<cfproperty name="MockCarrierHelper" inject="id:MockCarrierHelper" />
	<cfproperty name="ChannelConfig" 	inject="id:ChannelConfig" />
	
	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.CarrierHelper">
		<cfreturn this />
	</cffunction>
	
	<!--------------------------------------------------------------------------------------------------
		Helper Functions		
	 --------------------------------------------------------------------------------------------------->

	<cffunction name="getFinanceAgreementRequest" output="false" access="public" returntype="struct">
		<cfset var local = structNew() />
		<cfset local.args = passthruArgs(argumentCollection = arguments ) />
		<cfset local.FinanceAgreementRequest =  carrierObject(arguments.carrierId).getFinanceAgreementRequest(argumentCollection = local.args) />	
		<cfreturn local.FinanceAgreementRequest />
	</cffunction>
	
	<cffunction name="getSubmitOrderRequest" output="false" access="public" returntype="struct">
		<cfset var local = structNew() />
		<cfset local.args = passthruArgs(argumentCollection = arguments ) />
		<cfset local.SubmitOrderRequest =  carrierObject(arguments.carrierId).getSubmitOrderRequest(argumentCollection = local.args) />	
		<cfreturn local.SubmitOrderRequest />
	</cffunction>
	
	<cffunction name="getSubmitCompletedOrderRequest" output="false" access="public" returntype="struct">
		<cfset var local = structNew() />
		<cfset local.args = passthruArgs(argumentCollection = arguments ) />
		<cfset local.SubmitCompletedOrderRequest =  carrierObject(arguments.carrierId).getSubmitCompletedOrderRequest(argumentCollection = local.args) />	
		<cfreturn local.SubmitOrderRequest />
	</cffunction>
	
	<cffunction name="saveEConsent" output="false" access="public" returntype="boolean">
		<cfset var local = structNew() />
		<cfset local.saveEConsent =  carrierObject(arguments.carrierId).saveEConsent() />	
		<cfreturn local.saveEConsent />
	</cffunction>	
	
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
					return variables.MockCarrierHelper;
					break;
				case 109: // ATT
					return variables.AttCarrierHelper;
					break;
				case 42:  // Verizon
					return variables.VzwCarrierHelper;
					break;
				default: 
					return "";
					break;				
			}
		</cfscript>
		
	</cffunction>	
	
	<cffunction name="getChannelValue" returnType="Numeric">
		<cfswitch expression="#channelConfig.getDisplayName()#">
			<cfcase value="Costco">
				<cfreturn 0>
				<cfbreak/>
			</cfcase>
			<cfcase value="AAfes">
				<cfreturn 1>
				<cfbreak/>
			</cfcase>
			<cfdefaultcase>
				<cfreturn 0>
			</cfdefaultcase>
		</cfswitch>
	</cffunction>
	
	<cffunction name="createGUID" access="public" returntype="string">
		<cfset var local = structNew() />
		<cfset local.uuid = createUUID() />
		<cfreturn left(local.uuid,19) & mid(local.uuid,20,4) & '-' & right(local.uuid,12) />
	</cffunction>	

	<cffunction name="getAssetPaths" access="private" output="false" returntype="struct">    
    	<cfreturn variables.instance.assetPaths />    
    </cffunction>    
    <cffunction name="setAssetPaths" access="private" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance.assetPaths = arguments.theVar />    
    </cffunction>

	
	
</cfcomponent>