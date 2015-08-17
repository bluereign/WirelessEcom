<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="CarrierAccount">		
		<cfargument name="AccountNumber" type="string" default="" required="false" />
		<cfargument name="AccountLines" type="CarrierAccountLine[]" default="#ArrayNew(1)#" required="false" />
		
		<cfscript>
			setAccountNumber( arguments.AccountNumber );
			setAccountLines( arguments.AccountLines );
		</cfscript>
	
		<cfreturn this />
	</cffunction>


	<cffunction name="getAccountLineByMdn" output="false" access="public" returntype="CarrierAccountLine">		
		<cfargument name="Mdn" type="string" default="" required="true" />
		
		<cfscript>
			var i = 1;
			var accountLine = '';
			
			for (i=1; i <= ArrayLen(variables.instance.AccountLines); i++)
			{
				if ( variables.instance.AccountLines[i].getMdn() eq arguments.Mdn )
				{
					accountLine = variables.instance.AccountLines[i];
					break;
				}
			}
		</cfscript>
	
		<cfreturn accountLine />
	</cffunction>

	<cffunction name="setAccountNumber" output="false" access="public" returntype="void">
		<cfargument name="AccountNumber" type="string" required="true" />
		<cfset variables.instance.AccountNumber = arguments.AccountNumber />
	</cffunction>
	<cffunction name="getAccountNumber" output="false" access="public" returntype="string">
		<cfreturn variables.instance.AccountNumber />
	</cffunction>

	<cffunction name="setAccountLines" output="false" access="public" returntype="void">
		<cfargument name="AccountLines" type="CarrierAccountLine[]" required="true" />
		<cfset variables.instance.AccountLines = arguments.AccountLines />
	</cffunction>
	<cffunction name="getAccountLines" output="false" access="public" returntype="CarrierAccountLine[]">
		<cfreturn variables.instance.AccountLines />
	</cffunction>
		
</cfcomponent>