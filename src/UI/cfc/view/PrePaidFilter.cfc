<cfcomponent output="false" displayname="PrePaidFilter">
	<cfset variables.filterType = "PrePaidFilter">
	<cfset variables.productClass = "PrePaid">
	<cfset variables.productTag = "prepaid">
	<cfset variables.label = "Prepaid Phone">
	<cfset variables.labelPlural = "Prepaid Phones">
	<cfset variables.filterSelections = "session.prePaidFilterSelections">
	<cfset variables.indexedViewName = "dn_PrePaids">
	<cfset variables.filter = application.wirebox.getInstance( variables.filterType ) />

	<cffunction name="init" returntype="PrePaidFilter">
		<cfreturn this />
	</cffunction>

	<cfinclude template="ProductFilter.cfm">

</cfcomponent>