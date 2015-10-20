<cfcomponent displayname="MockCarrierHelper" hint="Interface to Mock Carrier Helper" extends="fw.model.CarrierApi.CarrierHelper" output="false">
	
	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.Mock.MockCarrierHelper">
		<cfargument name="ServiceURL" type="string" required="true" />
		
		<cfset variables.CarrierServiceURL = arguments.serviceURL />
		
		<cfreturn this />
	</cffunction>
		
	<!--------------------------------------------------------------------------------------------------
		Helper Functions		
	 --------------------------------------------------------------------------------------------------->
	
	<cffunction name="getFinanceAgreementRequest" output="false" access="public" returntype="struct">
		<cfset var local = structNew() />
		<cfset local.financeAgreementRequest = structNew() />
		<cfreturn local.financeAgreementRequest />		
	</cffunction>

</cfcomponent>	