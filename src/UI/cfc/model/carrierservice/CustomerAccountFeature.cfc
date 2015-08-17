<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.CustomerAccountFeature">
		<cfargument name="CustomerLookUpServiceId" type="numeric" default="0" required="false" />
		<cfargument name="CustomerLookUpPlanId" type="numeric" default="0" required="false" />
		<cfargument name="ReferenceNumber" type="string" default="" required="false" />
		<cfargument name="CarrierId" type="numeric" default="0" required="false" />
		<cfargument name="CarrierBillCode" type="string" default="" required="false" />
		<cfargument name="Title" type="string" default="" required="false" />
		
		<cfscript>
			variables.instance = {};

			setCustomerLookUpServiceId( arguments.CustomerLookUpServiceId );
			setCustomerLookUpPlanId( arguments.CustomerLookUpPlanId );
			setReferenceNumber( arguments.ReferenceNumber );
			setCarrierId( arguments.CarrierId );
			setCarrierBillCode( arguments.CarrierBillCode );
			setTitle( arguments.Title );
		</cfscript>
	
		<cfreturn this />
	</cffunction>

	<cffunction name="setCustomerLookUpServiceId" output="false" access="public" returntype="void">
		<cfargument name="CustomerLookUpServiceId" type="numeric" default="0" required="false" />
		<cfset variables.instance.CustomerLookUpServiceId = arguments.CustomerLookUpServiceId />
	</cffunction>
	<cffunction name="getCustomerLookUpServiceId" output="false" access="public" returntype="numeric">
		<cfreturn variables.instance.CustomerLookUpServiceId />
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

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn variables.instance />
	</cffunction>
</cfcomponent>