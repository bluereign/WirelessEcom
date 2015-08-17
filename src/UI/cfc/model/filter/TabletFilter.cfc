<cfcomponent output="false" displayname="TabletFilter">
	<cfset variables.filterType = "TabletFilter">
	<cfset variables.productClass = "Tablet">
	<cfset variables.productTag = "tablet">
	<cfset variables.label = "Tablet">
	<cfset variables.labelPlural = "Tablets">
	<cfset variables.filterSelections = "session.tabletFilterSelections">
	<cfset variables.indexedViewName = "dn_Tablets">

	<cffunction name="init" returntype="TabletFilter">
		<cfargument name="queryCacheSpan" default="#createTimeSpan(0,0,10,0)#" required="false" />
		<cfset variables.queryCacheSpan = arguments.queryCacheSpan />		
		<cfreturn this >
	</cffunction>

	<cfinclude template="ProductFilter.cfm">

</cfcomponent>