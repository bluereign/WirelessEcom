<cfcomponent output="false">

	<!--- TODO: Add default/required properties --->
	<cfproperty name="SaleDate" type="date" />
	<cfproperty name="CurrencyCode" type="string" />
	<cfproperty name="BillTo" type="Address" />
	<cfproperty name="ShipTo" type="Address" />
	<cfproperty name="ShipFrom" type="Address" />
	<cfproperty name="LineItem" type="LineItem[]" />

	<cfset instance = {} />

	<!--- TODO: Switch default and required --->
	<!--- TODO: Lowercase arg names --->
	<cffunction name="init" output="false" returntype="any">
		<cfargument name="SaleDate" required="false" default="#DateFormat(Now(), "yyyy-mm-dd")#" />
		<cfargument name="CurrencyCode" required="false" default="" />
		<cfargument name="BillTo" required="false"  default="#CreateObject( 'component', 'Address' )#" />
		<cfargument name="ShipTo" required="false"  default="#CreateObject( 'component', 'Address' )#" />
		<cfargument name="ShipFrom" required="false"  default="#CreateObject( 'component', 'Address' )#" />
		<cfargument name="LineItem" required="false"  default="#ArrayNew( 1 )#" />

		<cfscript>
			setSaleDate( arguments.SaleDate );
			setCurrencyCode( arguments.CurrencyCode );
			setBillTo( arguments.BillTo );
			setShipTo( arguments.ShipTo );
			setShipFrom( arguments.ShipFrom );
			setLineItem( arguments.LineItem );			
		</cfscript>
	
		<cfreturn this />
	</cffunction>


	<!--- TODO: Capitalize instance properties --->
	<cffunction name="getSaleDate" output="false" returntype="string">
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
	
	<cffunction name="getBillTo" output="false" returntype="Address">
		<cfreturn variables.instance.billTo />
	</cffunction>
	<cffunction name="setBillTo" output="false" returntype="void">
		<cfargument name="billTo" type="Address" required="true" />
		<cfset variables.instance.billTo = arguments.billTo />
	</cffunction>
	
	<cffunction name="getShipTo" output="false" returntype="Address">
		<cfreturn variables.instance.ShipTo />
	</cffunction>
	<cffunction name="setShipTo" output="false" returntype="void">
		<cfargument name="ShipTo" type="Address" required="true" />
		<cfset variables.instance.ShipTo = arguments.ShipTo />
	</cffunction>
	
	<cffunction name="getShipFrom" output="false" returntype="Address">
		<cfreturn variables.instance.ShipFrom />
	</cffunction>
	<cffunction name="setShipFrom" output="false" returntype="void">
		<cfargument name="ShipFrom" type="Address" required="true" />
		<cfset variables.instance.ShipFrom = arguments.ShipFrom />
	</cffunction>
	
	<cffunction name="getLineItem" output="false" returntype="any">
		<cfreturn variables.instance.lineItem />
	</cffunction>
	<cffunction name="setLineItem" output="false" returntype="void">
		<cfargument name="lineItem" type="any" required="true" />
		<cfset variables.instance.lineItem = arguments.lineItem />
	</cffunction>
	
	<cffunction name="getMemento" output="false" returntype="any">
		<cfreturn variables.instance />
	</cffunction>	

</cfcomponent>