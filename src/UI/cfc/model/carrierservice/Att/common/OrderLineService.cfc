<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.Att.common.OrderLineService">
		<cfargument name="OfferingAction" type="string" default="" required="false" />
		<cfargument name="OfferingCode" type="string" default="" required="false" />

		<cfscript>
			setOfferingAction( arguments.OfferingAction );
			setOfferingCode( arguments.OfferingCode );
		</cfscript>

		<cfreturn this />
	</cffunction>

	<cffunction name="setOfferingAction" output="false" access="public" returntype="void">
		<cfargument name="OfferingAction" type="string" required="true" />
		<cfset this.OfferingAction = ' ' & arguments.OfferingAction />
	</cffunction>
	<cffunction name="getOfferingAction" output="false" access="public" returntype="string">
		<cfreturn this.OfferingAction />
	</cffunction>
	
	<cffunction name="setOfferingCode" output="false" access="public" returntype="void">
		<cfargument name="OfferingCode" type="string" required="true" />
		<cfset this.OfferingCode = ' ' & arguments.OfferingCode />
	</cffunction>
	<cffunction name="getOfferingCode" output="false" access="public" returntype="string">
		<cfreturn this.OfferingCode />
	</cffunction>


	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>