<cfcomponent output="false">

	<!--- TODO: Add default/required properties --->
	<cfproperty name="TransactionId" type="string" />
	<cfproperty name="TransactionDate" type="date" />
	<cfproperty name="CommitDate" type="date" />
	<cfproperty name="InvoiceNumber" type="string" />
	<cfproperty name="PriorTransactionId" type="string" />

	<cfset instance = {} />

	<!--- TODO: Lowercase arg names --->
	<cffunction name="init" output="false" returntype="any">
		<cfargument name="TransactionId" type="string" default="" required="false" />
		<cfargument name="TransactionDate" type="date" default="#DateFormat(Now(), "yyyy-mm-dd")#" required="false"  />
		<cfargument name="CommitDate" type="date" default="#DateFormat(Now(), "yyyy-mm-dd")#" required="false" />
		<cfargument name="InvoiceNumber" type="string"  default="" required="false" />
		<cfargument name="PriorTransactionId" type="string" default="" required="false" />

		<cfscript>
			setTransactionId( arguments.TransactionId );
			setTransactionDate( arguments.TransactionDate );
			setCommitDate( arguments.CommitDate );
			setInvoiceNumber( arguments.InvoiceNumber );
			setPriorTransactionId( arguments.PriorTransactionId );		
		</cfscript>
	
		<cfreturn this />
	</cffunction>


	<cffunction name="getTransactionId" output="false" returntype="string">
		<cfreturn variables.instance.TransactionId />
	</cffunction>
	<cffunction name="setTransactionId" output="false" returntype="void">
		<cfargument name="TransactionId" type="string" required="true" />
		<cfset variables.instance.TransactionId = arguments.TransactionId />
	</cffunction>

	<cffunction name="getTransactionDate" output="false" returntype="date">
		<cfreturn variables.instance.TransactionDate />
	</cffunction>
	<cffunction name="setTransactionDate" output="false" returntype="void">
		<cfargument name="TransactionDate" type="date" required="true" />
		<cfset variables.instance.TransactionDate = arguments.TransactionDate />
	</cffunction>

	<cffunction name="getCommitDate" output="false" returntype="date">
		<cfreturn variables.instance.CommitDate />
	</cffunction>
	<cffunction name="setCommitDate" output="false" returntype="void">
		<cfargument name="CommitDate" type="date" required="true" />
		<cfset variables.instance.CommitDate = arguments.CommitDate />
	</cffunction>

	<cffunction name="getInvoiceNumber" output="false" returntype="string">
		<cfreturn variables.instance.InvoiceNumber />
	</cffunction>
	<cffunction name="setInvoiceNumber" output="false" returntype="void">
		<cfargument name="InvoiceNumber" type="string" required="true" />
		<cfset variables.instance.InvoiceNumber = arguments.InvoiceNumber />
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