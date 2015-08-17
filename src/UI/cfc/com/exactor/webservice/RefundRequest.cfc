<cfcomponent output="false">

	<!--- TODO: Add default/required properties --->
	<cfproperty name="RefundDate" type="date" />
	<cfproperty name="PriorTransactionId" type="string" />

	<cfset instance = {} />

	<!--- TODO: Switch default and required --->
	<!--- TODO: Lowercase arg names --->
	<cffunction name="init" output="false" returntype="any">
		<cfargument name="RefundDate" required="false" default="#DateFormat(Now(), "yyyy-mm-dd")#" />
		<cfargument name="PriorTransactionId" required="false" default="" />

		<cfscript>
			setRefundDate( arguments.RefundDate );
			setPriorTransactionId( arguments.PriorTransactionId );		
		</cfscript>
	
		<cfreturn this />
	</cffunction>


	<cffunction name="getRefundDate" output="false" returntype="string">
		<cfreturn variables.instance.RefundDate />
	</cffunction>
	<cffunction name="setRefundDate" output="false" returntype="void">
		<cfargument name="RefundDate" type="date" required="true" />
		<cfset variables.instance.RefundDate = arguments.RefundDate />
	</cffunction>

	<cffunction name="getPriorTransactionId" output="false" returntype="string">
		<cfreturn variables.instance.PriorTransactionId />
	</cffunction>
	<cffunction name="setPriorTransactionId" output="false" returntype="void">
		<cfargument name="PriorTransactionId" type="string" required="true" />
		<cfset variables.instance.PriorTransactionId = arguments.PriorTransactionId />
	</cffunction>
	
	<cffunction name="getMemento" output="false" returntype="any">
		<cfreturn variables.instance />
	</cffunction>	

</cfcomponent>