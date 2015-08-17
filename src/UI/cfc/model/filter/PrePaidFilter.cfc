<cfcomponent output="false" displayname="PrePaidFilter">
	<cfset variables.filterType = "PrePaidFilter">
	<cfset variables.productClass = "PrePaid">
	<cfset variables.productTag = "prepaid">
	<cfset variables.label = "Prepaid Phone">
	<cfset variables.labelPlural = "Prepaid Phones">
	<cfset variables.filterSelections = "session.prePaidFilterSelections">
	<cfset variables.indexedViewName = "dn_PrePaids">

	<cffunction name="init" returntype="PrePaidFilter">
		<cfargument name="queryCacheSpan" default="#createTimeSpan(0,0,10,0)#" required="false" />
		<cfset variables.queryCacheSpan = arguments.queryCacheSpan />		
		<cfreturn this >
	</cffunction>

	<cfinclude template="ProductFilter.cfm">

</cfcomponent>