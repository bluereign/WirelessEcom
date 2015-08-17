<cfcomponent output="false">

	<cfproperty name="Id" type="string" default="" required="false"/>
	<cfproperty name="Sku" type="string" default="" required="false"/>
	<cfproperty name="Description" type="string" default="" required="false" />
	<cfproperty name="Quantity" type="numeric" default="0" required="false"/>
	<cfproperty name="GrossAmount" type="numeric" default="0" required="false"/>
	<cfproperty name="TaxDirection" type="string" default="" required="false"/>
	<cfproperty name="TotalTaxAmount" type="numeric" default="0" required="false"/>

	<cfset instance = {} />

	<cffunction name="init" output="false" returntype="any">
		<cfargument name="id" type="string" required="false" default="" />
		<cfargument name="sku" type="string" required="false" default="" />
		<cfargument name="description" type="string" required="false" default="" />
		<cfargument name="quantity" type="numeric" required="false" default="0" />
		<cfargument name="grossAmount" type="numeric" required="false" default="0" />
		<cfargument name="taxDirection" type="string" required="false" default="" />
		<cfargument name="totalTaxAmount" type="numeric" required="false" default="0" />

		<cfscript>
			setId( arguments.id );
			setSku( arguments.sku );
			setDescription( arguments.description );
			setQuantity( arguments.quantity );
			setGrossAmount( arguments.grossAmount );
			setTaxDirection( arguments.taxDirection );
			setTotalTaxAmount( arguments.totalTaxAmount );
		</cfscript>
	
		<cfreturn this />
	</cffunction>

	<cffunction name="getId" output="false" returntype="string">
		<cfreturn variables.instance.Id />
	</cffunction>
	<cffunction name="setId" output="false" returntype="void">
		<cfargument name="id" type="string" required="true" />
		<cfset variables.instance.Id = arguments.id />
	</cffunction>

	<cffunction name="getSku" output="false" returntype="string">
		<cfreturn variables.instance.Sku />
	</cffunction>
	<cffunction name="setSku" output="false" returntype="void">
		<cfargument name="sku" type="string" required="true" />
		<cfset variables.instance.Sku = arguments.sku />
	</cffunction>

	<cffunction name="getDescription" output="false" returntype="string">
		<cfreturn variables.instance.Description />
	</cffunction>
	<cffunction name="setDescription" output="false" returntype="void">
		<cfargument name="description" type="string" required="true" />
		<cfset variables.instance.Description = arguments.description />
	</cffunction>
	
	<cffunction name="getQuantity" output="false" returntype="string">
		<cfreturn variables.instance.Quantity />
	</cffunction>
	<cffunction name="setQuantity" output="false" returntype="void">
		<cfargument name="quantity" type="numeric" required="true" />
		<cfset variables.instance.Quantity = arguments.quantity />
	</cffunction>
	
	<cffunction name="getGrossAmount" output="false" returntype="string">
		<cfreturn variables.instance.GrossAmount />
	</cffunction>
	<cffunction name="setGrossAmount" output="false" returntype="void">
		<cfargument name="grossAmount" type="numeric" required="true" />
		<cfset variables.instance.GrossAmount = arguments.grossAmount />
	</cffunction>
	
	<cffunction name="getTotalTaxAmount" output="false" returntype="string">
		<cfreturn variables.instance.TotalTaxAmount />
	</cffunction>
	<cffunction name="setTotalTaxAmount" output="false" returntype="void">
		<cfargument name="totalTaxAmount" type="numeric" required="true" />
		<cfset variables.instance.TotalTaxAmount = arguments.totalTaxAmount />
	</cffunction>	
	
	<cffunction name="getTaxDirection" output="false" returntype="string">
		<cfreturn variables.instance.TaxDirection />
	</cffunction>
	<cffunction name="setTaxDirection" output="false" returntype="void">
		<cfargument name="taxDirection" type="string" required="true" />
		<cfset variables.instance.TaxDirection = arguments.taxDirection />
	</cffunction>	
	
	<cffunction name="getMemento" output="false" returntype="any">
		<cfreturn variables.instance />
	</cffunction>	

</cfcomponent>