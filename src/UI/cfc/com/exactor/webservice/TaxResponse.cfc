<cfcomponent output="false">

	<!--- TODO: Add default/required properties --->
	<cfproperty name="MerchantId" type="string" />
	<cfproperty name="UserId" type="string" />
	<cfproperty name="InvoiceResponse" type="InvoiceResponse" />
	<cfproperty name="CommitResponse" type="CommitResponse" />

	<cfset instance = {} />

	<!--- TODO: Lowercase arg names --->
	<cffunction name="init" output="false" returntype="any">
		<cfargument name="MerchantId" required="false" default="" />
		<cfargument name="UserId" required="false" default="" />
		<cfargument name="InvoiceResponse" required="false"  default="" />
		<cfargument name="CommitResponse" required="false" default="" />
		<cfargument name="RefundResponse" required="false" default="" />

		<cfscript>
			setMerchantId( arguments.MerchantId );
			setUserId( arguments.UserId );
			setInvoiceResponse( arguments.InvoiceResponse );
			setCommitResponse( arguments.CommitResponse );
			setRefundResponse( arguments.RefundResponse );
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
	
	<cffunction name="getInvoiceResponse" output="false" returntype="InvoiceResponse">
		<cfreturn variables.instance.InvoiceResponse />
	</cffunction>
	<cffunction name="setInvoiceResponse" output="false" returntype="void">
		<cfargument name="InvoiceResponse" type="any" required="true" />
		<cfset variables.instance.InvoiceResponse = arguments.InvoiceResponse />
	</cffunction>
	
	<cffunction name="getCommitResponse" output="false" returntype="CommitResponse">
		<cfreturn variables.instance.CommitResponse />
	</cffunction>
	<cffunction name="setCommitResponse" output="false" returntype="void">
		<cfargument name="CommitResponse" type="any" required="true" />
		<cfset variables.instance.CommitResponse = arguments.CommitResponse />
	</cffunction>
	
	<cffunction name="getRefundResponse" output="false" returntype="RefundResponse">
		<cfreturn variables.instance.RefundResponse />
	</cffunction>
	<cffunction name="setRefundResponse" output="false" returntype="void">
		<cfargument name="RefundResponse" type="any" required="true" />
		<cfset variables.instance.RefundResponse = arguments.RefundResponse />
	</cffunction>
	
	<cffunction name="getMemento" output="false" returntype="any">
		<cfreturn variables.instance />
	</cffunction>

</cfcomponent>