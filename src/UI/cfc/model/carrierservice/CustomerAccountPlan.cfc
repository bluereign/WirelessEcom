<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.CustomerAccountPlan">
		<cfargument name="CustomerLookUpPlanId" type="numeric" default="0" required="false" />
		<cfargument name="ReferenceNumber" type="string" default="" required="false" />
		<cfargument name="CarrierId" type="numeric" default="0" required="false" />
		<cfargument name="Mdn" type="string" default="" required="false" />
		<cfargument name="IsPrimary" type="boolean" default="false" required="false" />
		<cfargument name="CarrierBillCode" type="string" default="" required="false" />
		<cfargument name="Title" type="string" default="" required="false" />
		<cfargument name="CustomerAccountServices" type="cfc.model.carrierservice.CustomerAccountService[]"  default="#ArrayNew(1)#" required="false" />
		
		<cfscript>
			variables.instance = {};
			
			setCustomerLookUpPlanId( arguments.CustomerLookUpPlanId );
			setReferenceNumber( arguments.ReferenceNumber );
			setCarrierId( arguments.CarrierId );
			setMdn( arguments.Mdn );
			setIsPrimary( arguments.IsPrimary );
			setCarrierBillCode( arguments.CarrierBillCode );
			setTitle( arguments.Title );
			setCustomerAccountServices( arguments.CustomerAccountServices );
		</cfscript>

		<cfreturn this />
	</cffunction>


	<cffunction name="setCustomerLookUpPlanId" output="false" access="public" returntype="void">
		<cfargument name="customerLookUpPlanId" type="numeric" default="0" required="false" />
		<cfset variables.instance.customerLookUpPlanId = arguments.customerLookUpPlanId />
	</cffunction>
	<cffunction name="getCustomerLookUpPlanId" output="false" access="public" returntype="numeric">
		<cfreturn variables.instance.customerLookUpPlanId />
	</cffunction>
	
	<cffunction name="setReferenceNumber" output="false" access="public" returntype="void">
		<cfargument name="ReferenceNumber" type="string" default="" required="false" />
		<cfset variables.instance.ReferenceNumber = arguments.ReferenceNumber />
	</cffunction>
	<cffunction name="getReferenceNumber" output="false" access="public" returntype="string">
		<cfreturn variables.instance.ReferenceNumber />
	</cffunction>
	
	<cffunction name="setCarrierId" output="false" access="public" returntype="void">
		<cfargument name="CarrierId" type="numeric" default="0" required="false" />
		<cfset variables.instance.CarrierId = arguments.CarrierId />
	</cffunction>
	<cffunction name="getCarrierId" output="false" access="public" returntype="numeric">
		<cfreturn variables.instance.CarrierId />
	</cffunction>		

	<cffunction name="setMdn" output="false" access="public" returntype="void">
		<cfargument name="Mdn" type="string" default="" required="false" />
		<cfset variables.instance.Mdn = arguments.Mdn />
	</cffunction>
	<cffunction name="getMdn" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Mdn />
	</cffunction>

	<cffunction name="setIsPrimary" output="false" access="public" returntype="void">
		<cfargument name="IsPrimary" type="boolean" default="false" required="false" />
		<cfset variables.instance.IsPrimary = arguments.IsPrimary />
	</cffunction>
	<cffunction name="getIsPrimary" output="false" access="public" returntype="boolean">
		<cfreturn variables.instance.IsPrimary />
	</cffunction>

	<cffunction name="setCarrierBillCode" output="false" access="public" returntype="void">
		<cfargument name="CarrierBillCode" type="string" default="false" required="false" />
		<cfset variables.instance.CarrierBillCode = arguments.CarrierBillCode />
	</cffunction>
	<cffunction name="getCarrierBillCode" output="false" access="public" returntype="string">
		<cfreturn variables.instance.CarrierBillCode />
	</cffunction>

	<cffunction name="setTitle" output="false" access="public" returntype="void">
		<cfargument name="Title" type="string" default="false" required="false" />
		<cfset variables.instance.Title = arguments.Title />
	</cffunction>
	<cffunction name="getTitle" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Title />
	</cffunction>

	<cffunction name="setCustomerAccountServices" output="false" access="public" returntype="void">
		<cfargument name="CustomerAccountServices" type="cfc.model.carrierservice.CustomerAccountFeature[]" default="false" required="false" />
		<cfset variables.instance.CustomerAccountServices = arguments.CustomerAccountServices />
	</cffunction>
	<cffunction name="getCustomerAccountServices" output="false" access="public" returntype="cfc.model.carrierservice.CustomerAccountFeature[]">
		<cfreturn variables.instance.CustomerAccountServices />
	</cffunction>

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn variables.instance />
	</cffunction>

</cfcomponent>