<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="CarrierAccountLine">
		<cfargument name="Mdn" type="string" default="" required="false" />
		<cfargument name="IsUpgradeEligible" type="boolean" default="false" required="false" />
			
		<cfscript>
			setMdn( arguments.Mdn );
			setIsUpgradeEligible( arguments.IsUpgradeEligible );
		</cfscript>
		
		<cfreturn this />
	</cffunction>

	<cffunction name="setMdn" output="false" access="public" returntype="void">
		<cfargument name="Mdn" type="string" required="true" />
		<cfset variables.instance.Mdn = arguments.Mdn />
	</cffunction>
	<cffunction name="getMdn" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Mdn />
	</cffunction>

	<cffunction name="setIsUpgradeEligible" output="false" access="public" returntype="void">
		<cfargument name="IsUpgradeEligible" type="boolean" required="true" />
		<cfset variables.instance.IsUpgradeEligible = arguments.IsUpgradeEligible />
	</cffunction>
	<cffunction name="getIsUpgradeEligible" output="false" access="public" returntype="boolean">
		<cfreturn variables.instance.IsUpgradeEligible />
	</cffunction>
		
</cfcomponent>