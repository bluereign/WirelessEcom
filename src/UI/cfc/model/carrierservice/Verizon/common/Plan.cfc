<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.Plan">
		<cfargument name="PlanType" type="string" default="" required="false" />
		<cfargument name="PricePlanId" type="string" default="" required="false" />
		<cfargument name="ParentPlanCode" type="string" default="" required="false" />
		<cfargument name="NafCode" type="string" default="" required="false" />
		<cfargument name="OldPricePlanCode" type="string" default="" required="false" />
		<cfargument name="IsFamilySharedPlan" type="string" default="" required="false" />

		<cfscript>
			setPlanType( arguments.PlanType );
			setPricePlanId( arguments.PricePlanId );
			setParentPlanCode( arguments.ParentPlanCode );
			setNafCode( arguments.NafCode );
			setOldPricePlanCode( arguments.OldPricePlanCode );
			setIsFamilySharedPlan( arguments.IsFamilySharedPlan );
		</cfscript>

		<cfreturn this />
	</cffunction>

	<cffunction name="setPlanType" output="false" access="public" returntype="void">
		<cfargument name="PlanType" type="string" default="0" required="false" />
		<cfset this.PlanType = ' ' & arguments.PlanType />
	</cffunction>
	<cffunction name="getPlanType" output="false" access="public" returntype="string">
		<cfreturn this.PlanType />
	</cffunction>
	
	<cffunction name="setPricePlanId" output="false" access="public" returntype="void">
		<cfargument name="PricePlanId" type="string" default="0" required="false" />
		<cfset this.PricePlanId = ' ' & arguments.PricePlanId />
	</cffunction>
	<cffunction name="getPricePlanId" output="false" access="public" returntype="string">
		<cfreturn this.PricePlanId />
	</cffunction>
	
	<cffunction name="setParentPlanCode" output="false" access="public" returntype="void">
		<cfargument name="ParentPlanCode" type="string" default="0" required="false" />
		<cfset this.ParentPlanCode = ' ' & arguments.ParentPlanCode />
	</cffunction>
	<cffunction name="getParentPlanCode" output="false" access="public" returntype="string">
		<cfreturn this.ParentPlanCode />
	</cffunction>
	
	<cffunction name="setOldPricePlanCode" output="false" access="public" returntype="void">
		<cfargument name="OldPricePlanCode" type="string" default="0" required="false" />
		<cfset this.OldPricePlanCode = ' ' & arguments.OldPricePlanCode />
	</cffunction>
	<cffunction name="getOldPricePlanCode" output="false" access="public" returntype="string">
		<cfreturn this.OldPricePlanCode />
	</cffunction>

	<cffunction name="setNafCode" output="false" access="public" returntype="void">
		<cfargument name="NafCode" type="string" default="0" required="false" />
		<cfset this.NafCode = ' ' & arguments.NafCode />
	</cffunction>
	<cffunction name="getNafCode" output="false" access="public" returntype="string">
		<cfreturn this.NafCode />
	</cffunction>
	
	<cffunction name="setIsFamilySharedPlan" output="false" access="public" returntype="void">
		<cfargument name="IsFamilySharedPlan" type="string" default="0" required="false" />
		<cfset this.IsFamilySharedPlan = ' ' & arguments.IsFamilySharedPlan />
	</cffunction>
	<cffunction name="getIsFamilySharedPlan" output="false" access="public" returntype="string">
		<cfreturn this.IsFamilySharedPlan />
	</cffunction>

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>