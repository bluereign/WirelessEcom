<cfcomponent output="false">

	<!--- Needs this init for application start up --->
	<cffunction name="init" output="false" access="public" returntype="ReportService">
		<cfreturn this />
	</cffunction>

	<cffunction name="getSSN" output="false" access="remote" returnformat="JSON" returntype="string">
		<cfargument name="wirelessAccountId" type="numeric" required="true" />
		
		<!--- TODO: Add security around this --->
		<!--- TODO: Add logger --->
		
		<cfscript>
			var account = {};
			var ssn = "";
			var wirelessAccount = CreateObject( "component", "cfc.model.WirelessAccount" ).init();
			wirelessAccount.load( arguments.wirelessAccountId );
			
			ssn = wirelessAccount.getSSN();
			
			//FIXME: Work around for ColdFusion serialization bug
			// Prefix numeric string with a space
			account.ssn = ' ' & ssn; 
			
			if ( NOT Len( Trim(ssn) ) )
			{
				account.ssn = "No data found";
			}
		</cfscript>
	
		<cfreturn SerializeJSON( account ) />
	</cffunction>

</cfcomponent>