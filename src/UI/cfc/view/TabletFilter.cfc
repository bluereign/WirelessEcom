<cfcomponent output="false" displayname="TabletFilter">
	<cfset variables.filterType = "TabletFilter">
	<cfset variables.productClass = "Tablet">
	<cfset variables.productTag = "tablet">
	<cfset variables.label = "tablet">
	<cfset variables.labelPlural = "Tablets">
	<cfset variables.filterSelections = "session.tabletFilterSelections">
	<cfset variables.indexedViewName = "dn_Tablets">
	<cfset variables.filter = application.wirebox.getInstance( variables.filterType ) />

	<cffunction name="init" returntype="TabletFilter">
		<cfreturn this />
	</cffunction>

	<cfinclude template="ProductFilter.cfm">

</cfcomponent>