<cfcomponent output="false">

	<!--- TODO: Add default/required properties --->
	<cfproperty name="TransactionId" type="string" />
	<cfproperty name="TransactionDate" type="string" />
	<cfproperty name="SaleDate" type="date" />
	<cfproperty name="CurrencyCode" type="string" />
	<cfproperty name="TaxClass" type="string" />
	<cfproperty name="GrossAmount" type="numeric" />
	<cfproperty name="TotalTaxAmount" type="numeric" />
	<cfproperty name="TaxObligation" type="string" />
	<cfproperty name="LineItem" type="LineItem[]" />

	<cfset instance = {} />
	
	<!--- TODO: Switch default and required --->
	<cffunction name="init" output="false" returntype="any">
		<cfargument name="transactionId" type="string" required="false" default="" />
		<cfargument name="transactionDate" type="string" required="false" default="" />
		<cfargument name="saleDate" type="date" required="false" default="#Now()#" />
		<cfargument name="currencyCode" type="string" required="false" default="" />
		<cfargument name="taxClass" type="string" required="false" default="" />
		<cfargument name="grossAmount" type="numeric" required="false" default="0" />
		<cfargument name="totalTaxAmount" type="numeric" required="false" default="0" />
		<cfargument name="taxObligation" type="string" required="false" default="" />
		<cfargument name="lineItem" type="LineItem[]" required="false" default="#ArrayNew( 1 )#" />

		<cfscript>
			setTransactionId( arguments.transactionId );
			setTransactionDate( arguments.transactionDate );
			setSaleDate( arguments.saleDate );
			setCurrencyCode( arguments.currencyCode );
			setTaxClass( arguments.taxClass );
			setGrossAmount( arguments.grossAmount );
			setTotalTaxAmount( arguments.totalTaxAmount );
			setTaxObligation( arguments.taxObligation );
			setLineItem( arguments.lineItem );
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

	<cffunction name="getSaleDate" output="false" returntype="date">
		<cfreturn variables.instance.saleDate />
	</cffunction>
	<cffunction name="setSaleDate" output="false" returntype="void">
		<cfargument name="saleDate" type="date" required="true" />
		<cfset variables.instance.saleDate = arguments.saleDate />
	</cffunction>

	<cffunction name="getCurrencyCode" output="false" returntype="string">
		<cfreturn variables.instance.currencyCode />
	</cffunction>
	<cffunction name="setCurrencyCode" output="false" returntype="void">
		<cfargument name="currencyCode" type="string" required="true" />
		<cfset variables.instance.currencyCode = arguments.currencyCode />
	</cffunction>
	
	<cffunction name="getTaxClass" output="false" returntype="string">
		<cfreturn variables.instance.TaxClass />
	</cffunction>
	<cffunction name="setTaxClass" output="false" returntype="void">
		<cfargument name="taxClass" type="string" required="true" />
		<cfset variables.instance.TaxClass = arguments.taxClass />
	</cffunction>
	
	<cffunction name="getGrossAmount" output="false" returntype="numeric">
		<cfreturn variables.instance.grossAmount />
	</cffunction>
	<cffunction name="setGrossAmount" output="false" returntype="void">
		<cfargument name="grossAmount" type="numeric" required="true" />
		<cfset variables.instance.GrossAmount = arguments.grossAmount />
	</cffunction>
	
	<cffunction name="getTotalTaxAmount" output="false" returntype="numeric">
		<cfreturn variables.instance.TotalTaxAmount />
	</cffunction>
	<cffunction name="setTotalTaxAmount" output="false" returntype="void">
		<cfargument name="totalTaxAmount" type="numeric" required="true" />
		<cfset variables.instance.TotalTaxAmount = arguments.totalTaxAmount />
	</cffunction>
	
	<cffunction name="getTaxObligation" output="false" returntype="string">
		<cfreturn variables.instance.TaxObligation />
	</cffunction>
	<cffunction name="setTaxObligation" output="false" returntype="void">
		<cfargument name="taxObligation" type="string" required="true" />
		<cfset variables.instance.TaxObligation = arguments.taxObligation />
	</cffunction>	
	
	<cffunction name="getLineItem" output="false" returntype="any">
		<cfreturn variables.instance.LineItem />
	</cffunction>
	<cffunction name="setLineItem" output="false" returntype="void">
		<cfargument name="lineItem" type="any" required="true" />
		<cfset variables.instance.LineItem = arguments.lineItem />
	</cffunction>
	
	<cffunction name="getMemento" output="false" returntype="any">
		<cfreturn variables.instance />
	</cffunction>	

</cfcomponent>