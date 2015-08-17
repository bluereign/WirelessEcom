<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.UpgradeCustomerInfo">
		<cfargument name="AccountNumber" type="string" default="" required="false" />
		<cfargument name="Mtn" type="string" default="" required="false" />

		<cfscript>
			setAccountNumber( arguments.AccountNumber );
			setMtn( arguments.Mtn );
		</cfscript>

		<cfreturn this />
	</cffunction>

	<cffunction name="setAccountNumber" output="false" access="public" returntype="void">
		<cfargument name="AccountNumber" type="string" required="true" />
		<cfset this.AccountInfo.AccountNumber = ' ' & arguments.AccountNumber />
	</cffunction>
	<cffunction name="getAccountNumber" output="false" access="public" returntype="string">
		<cfreturn this.AccountInfo.AccountNumber />
	</cffunction>
	
	<cffunction name="setMtn" output="false" access="public" returntype="void">
		<cfargument name="Mtn" type="string" required="true" />
		<cfset this.AccountInfo.Mtn = ' ' & arguments.Mtn />
	</cffunction>
	<cffunction name="getMtn" output="false" access="public" returntype="string">
		<cfreturn this.AccountInfo.Mtn />
	</cffunction>

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>