<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.PricePlanInfo">
		<cfargument name="ContractId" type="string" default="" required="false" />
		<cfargument name="ContractDescription" type="string" default="" required="false" />		
		<cfargument name="PlanList" type="cfc.model.carrierservice.Verizon.common.Plan[]" default="#ArrayNew(1)#" required="false" />

		<cfscript>
			setContractId( arguments.ContractId );
			setContractDescription( arguments.ContractDescription );
			setPlanList( arguments.PlanList );
		</cfscript>

		<cfreturn this />
	</cffunction>

	<cffunction name="setContractId" output="false" access="public" returntype="void">
		<cfargument name="ContractId" type="string" required="true" />
		<cfset this.Contract.Id = ' ' & arguments.ContractId />
	</cffunction>
	<cffunction name="getContractId" output="false" access="public" returntype="string">
		<cfreturn this.Contract.Id />
	</cffunction>
	
	<cffunction name="setContractDescription" output="false" access="public" returntype="void">
		<cfargument name="ContractDescription" type="string" required="true" />
		<cfset this.Contract.Description = ' ' & arguments.ContractDescription />
	</cffunction>
	<cffunction name="getContractDescription" output="false" access="public" returntype="string">
		<cfreturn this.Contract.Description />
	</cffunction>
	
	<cffunction name="setPlanList" output="false" access="public" returntype="void">
		<cfargument name="PlanList" type="cfc.model.carrierservice.Verizon.common.Plan[]" required="true" />
		<cfset this.PlanList = arguments.PlanList />
	</cffunction>
	<cffunction name="getPlanList" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.Plan[]">
		<cfreturn this.PlanList />
	</cffunction>

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>