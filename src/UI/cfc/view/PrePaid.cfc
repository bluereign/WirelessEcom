<cfcomponent output="false" displayname="PrePaid">
	<cfset variables.filterType = "PrePaidFilter">
	<cfset variables.productClass = "PrePaid">
	<cfset variables.productTag = "prepaid">
	<cfset variables.label = "Prepaid Phone">
	<cfset variables.labelPlural = "Prepaid Phones">
	<cfset variables.filterSelections = "session.prePaidFilterSelections">
	<cfset variables.indexedViewName = "dn_PrePaids">

	<cffunction name="init" returntype="PrePaid">
		<cfreturn this />
	</cffunction>

	<cfinclude template="Product.cfm">

</cfcomponent>