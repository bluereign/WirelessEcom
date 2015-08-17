<cfcomponent output="false" displayname="DataCardAndNetBook">
	<cfset variables.filterType = "DataCardAndNetBookFilter">
	<cfset variables.productClass = "DataCardAndNetBook">
	<cfset variables.productTag = "datadevice">
	<cfset variables.label = "Mobile Hotspot">
	<cfset variables.labelPlural = "Mobile Hotspots">
	<cfset variables.filterSelections = "session.dataCardAndNetBookFilterSelections">
	<cfset variables.indexedViewName = "dn_Phones">

	<cffunction name="init" returntype="DataCardAndNetBook">
		<cfreturn this />
	</cffunction>

	<cfinclude template="Product.cfm">

</cfcomponent>