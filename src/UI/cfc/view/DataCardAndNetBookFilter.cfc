<cfcomponent output="false" displayname="DataCardAndNetBookFilter">
	<cfset variables.filterType = "DataCardAndNetBookFilter">
	<cfset variables.productClass = "DataCardAndNetBook">
	<cfset variables.productTag = "datadevice">
	<cfset variables.label = "Mobile Hotspot">
	<cfset variables.labelPlural = "Mobile Hotspots">
	<cfset variables.filterSelections = "session.dataCardAndNetBookFilterSelections">
	<cfset variables.indexedViewName = "dn_Phones">
	<cfset variables.filter = application.wirebox.getInstance( variables.filterType ) />

	<cffunction name="init" returntype="DataCardAndNetBookFilter">
		<cfreturn this />
	</cffunction>

	<cfinclude template="ProductFilter.cfm">

</cfcomponent>