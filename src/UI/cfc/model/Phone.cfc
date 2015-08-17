<cfcomponent output="false" displayname="Phone">
	<cfset variables.filterType = "PhoneFilter">
	<cfset variables.productClass = "Phone">
	<cfset variables.productTag = "phone">
	<cfset variables.label = "Phone">
	<cfset variables.labelPlural = "Phones">
	<cfset variables.filterSelections = "session.phoneFilterSelections">
	<cfset variables.indexedViewName = "dn_Phones">

	<cffunction name="init" returntype="Phone">
		<cfreturn this />
	</cffunction>

	<cfinclude template="Product.cfm">

</cfcomponent>