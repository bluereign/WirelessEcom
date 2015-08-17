<cfcomponent output="false">

	<!--- TODO: Add default/required properties --->
	<cfproperty name="TransactionId" type="string" />
	<cfproperty name="TransactionDate" type="string" />
	<cfproperty name="RefundDate" type="date" />
	<cfproperty name="PriorTransactionId" type="string" />

	<cfset instance = {} />

	<!--- TODO: Switch default and required --->
	<!--- TODO: Lowercase arg names --->
	<cffunction name="init" output="false" returntype="any">
		<cfargument name="transactionId" type="string" required="false" default="" />
		<cfargument name="transactionDate" type="string" required="false" default="" />	
		<cfargument name="RefundDate" required="false" default="#DateFormat(Now(), "yyyy-mm-dd")#" />
		<cfargument name="PriorTransactionId" required="false" default="" />

		<cfscript>
			setTransactionId( arguments.transactionId );
			setTransactionDate( arguments.transactionDate );		
			setRefundDate( arguments.RefundDate );
			setPriorTransactionId( arguments.PriorTransactionId );		
		</cfscript>
	
		<cfreturn this />
	</cffunction>

	<cffunction name="getTransactionId" output="false" returntype="string">
		<cfreturn variables.instance.TransactionId />
	</cffunction>
	<cffunction name="setTransactionId" output="false" returntype="void">
		<cfargument name="transactionId" type="string" required="true" />
		<cfset variables.instance.TransactionId = arguments.transactionId />
	</cffunction>
	
	<cffunction name="getTransactionDate" output="false" returntype="string">
		<cfreturn variables.instance.TransactionDate />
	</cffunction>
	<cffunction name="setTransactionDate" output="false" returntype="void">
		<cfargument name="transactionDate" type="string" required="true" />
		<cfset variables.instance.TransactionDate = arguments.transactionDate />
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