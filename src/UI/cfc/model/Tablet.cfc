<cfcomponent output="false" displayname="Tablet">
	<cfset variables.filterType = "TabletFilter">
	<cfset variables.productClass = "Tablet">
	<cfset variables.productTag = "tablet">
	<cfset variables.label = "Tablet">
	<cfset variables.labelPlural = "Tablets">
	<cfset variables.filterSelections = "session.tabletFilterSelections">
	<cfset variables.filterSelections = ""/>
	<cfset variables.indexedViewName = "dn_Tablets">

	<cffunction name="init" returntype="Tablet">
		<cfreturn this />
	</cffunction>

	<cfinclude template="product.cfm">

</cfcomponent>