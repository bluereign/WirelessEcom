<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.MtnInfo">
		<cfargument name="MultiLineSeqNumber" type="string" default="" required="false" />
		<cfargument name="MobileNumber" type="string" default="" required="false" />

		<cfscript>
			variables.instance = {};

			setMultiLineSeqNumber( arguments.MultiLineSeqNumber );
			setMobileNumber( arguments.MobileNumber );
		</cfscript>

		<cfreturn this />
	</cffunction>

	<cffunction name="setMultiLineSeqNumber" output="false" access="public" returntype="void">
		<cfargument name="MultiLineSeqNumber" type="string" default="0" required="false" />
		<cfset this.MultiLineSeqNumber = ' ' & arguments.MultiLineSeqNumber />
	</cffunction>
	<cffunction name="getMultiLineSeqNumber" output="false" access="public" returntype="string">
		<cfreturn this.MultiLineSeqNumber />
	</cffunction>
	
	<cffunction name="setMobileNumber" output="false" access="public" returntype="void">
		<cfargument name="MobileNumber" type="string" default="0" required="false" />
		<cfset this.MobileNumber = ' ' & arguments.MobileNumber />
	</cffunction>
	<cffunction name="getMobileNumber" output="false" access="public" returntype="string">
		<cfreturn this.MobileNumber />
	</cffunction>

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>