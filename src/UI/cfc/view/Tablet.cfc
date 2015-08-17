<cfcomponent displayname="Tablet" output="false" access="public">
	<cfset variables.filterType = "TabletFilter" />
	<cfset variables.productClass = "Tablet" />
	<cfset variables.productTag = "tablet" />
	<cfset variables.label = "Tablet" />
	<cfset variables.labelPlural = "Tablets" />
	<cfset variables.filterSelections = "session.tabletFilterSelections" />
	<cfset variables.indexedViewName = "dn_Tablets" />

	<cffunction name="init" returntype="Tablet">
		<cfreturn this />
	</cffunction>

	<cfinclude template="Product.cfm" />

</cfcomponent>