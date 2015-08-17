<cfcomponent output="false" displayname="DataCardAndNetbookFilter">
	<cfset variables.filterType = "DataCardAndNetBookFilter">
	<cfset variables.productClass = "DataCardAndNetBook">
	<cfset variables.productTag = "datadevice">
	<cfset variables.label = "Mobile Hotspot">
	<cfset variables.labelPlural = "Mobile Hotspots">
	<cfset variables.filterSelections = "session.dataCardAndNetBookFilterSelections">
	<cfset variables.indexedViewName = "dn_Phones">

	<cffunction name="init" returntype="DataCardAndNetbookFilter">
		<cfargument name="queryCacheSpan" default="#createTimeSpan(0,0,10,0)#" required="false" />
		<cfset variables.queryCacheSpan = arguments.queryCacheSpan />
		<cfreturn this >
	</cffunction>

	<cfinclude template="ProductFilter.cfm">

</cfcomponent>