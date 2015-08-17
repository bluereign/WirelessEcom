<cfcomponent output="false">

	<!--- TODO: Add default/required properties --->
	<cfproperty name="MerchantId" type="string" />
	<cfproperty name="UserId" type="string" />
	<cfproperty name="InvoiceRequest" type="InvoiceRequest" />
	<cfproperty name="CommitRequest" type="CommitRequest" />

	<cfset instance = {} />

	<!--- TODO: Lowercase arg names --->
	<cffunction name="init" output="false" returntype="TaxRequest">
		<cfargument name="MerchantId" required="false" default="" />
		<cfargument name="UserId" required="false" default="" />
		<cfargument name="InvoiceRequest" required="false" default="" />
		<cfargument name="CommitRequest" required="false" default="" />
		<cfargument name="RefundRequest" required="false" default="" />

		<cfscript>
			setMerchantId( arguments.MerchantId );
			setUserId( arguments.UserId );
			setInvoiceRequest( arguments.InvoiceRequest );
			setCommitRequest( arguments.CommitRequest );
			setRefundRequest( arguments.RefundRequest );
		</cfscript>
	
		<cfreturn this />
	</cffunction>

	<cffunction name="getMerchantId" output="false" returntype="string">
		<cfreturn variables.instance.MerchantId />
	</cffunction>
	<cffunction name="setMerchantId" output="false" returntype="void">
		<cfargument name="MerchantId" type="string" required="true" />
		<cfset variables.instance.MerchantId = arguments.MerchantId />
	</cffunction>

	<cffunction name="getUserId" output="false" returntype="string">
		<cfreturn variables.instance.UserId />
	</cffunction>
	<cffunction name="setUserId" output="false" returntype="void">
		<cfargument name="UserId" type="string" required="true" />
		<cfset variables.instance.UserId = arguments.UserId />
	</cffunction>
	
	<cffunction name="getInvoiceRequest" output="false" returntype="InvoiceRequest">
		<cfreturn variables.instance.InvoiceRequest />
	</cffunction>
	<cffunction name="setInvoiceRequest" output="false" returntype="void">
		<cfargument name="InvoiceRequest" type="any" required="true" />
		<cfset variables.instance.InvoiceRequest = arguments.InvoiceRequest />
	</cffunction>
	
	<cffunction name="getCommitRequest" output="false" returntype="CommitRequest">
		<cfreturn variables.instance.CommitRequest />
	</cffunction>
	<cffunction name="setCommitRequest" output="false" returntype="void">
		<cfargument name="CommitRequest" type="any" required="true" />
		<cfset variables.instance.CommitRequest = arguments.CommitRequest />
	</cffunction>
	
	<cffunction name="getRefundRequest" output="false" returntype="RefundRequest">
		<cfreturn variables.instance.RefundRequest />
	</cffunction>
	<cffunction name="setRefundRequest" output="false" returntype="void">
		<cfargument name="RefundRequest" type="any" required="true" />
		<cfset variables.instance.RefundRequest = arguments.RefundRequest />
	</cffunction>	
	
	<cffunction name="getMemento" output="false" returntype="any">
		<cfreturn variables.instance />
	</cffunction>

</cfcomponent>