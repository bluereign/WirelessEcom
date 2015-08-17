<cfcomponent output="false" displayname="PhoneFilter">
	<cfset variables.filterType = "PhoneFilter">
	<cfset variables.productClass = "Phone">
	<cfset variables.productTag = "phone">
	<cfset variables.label = "Phone">
	<cfset variables.labelPlural = "Phones">
	<cfset variables.filterSelections = "session.phoneFilterSelections">
	<cfset variables.indexedViewName = "dn_Phones">
	<cfset variables.filter = application.wirebox.getInstance( variables.filterType ) />

	<cffunction name="init" returntype="PhoneFilter">
		<cfreturn this />
	</cffunction>

	<cfinclude template="ProductFilter.cfm">

</cfcomponent>