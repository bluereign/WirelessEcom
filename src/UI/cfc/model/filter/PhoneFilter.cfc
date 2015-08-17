<cfcomponent output="false" displayname="PhoneFilter">
	<cfset variables.filterType = "PhoneFilter">
	<cfset variables.productClass = "Phone">
	<cfset variables.productTag = "phone">
	<cfset variables.label = "Phone">
	<cfset variables.labelPlural = "Phones">
	<cfset variables.filterSelections = "session.phoneFilterSelections">
	<cfset variables.indexedViewName = "dn_Phones">
	<!---<cfset variables.filter = application.wirebox.getInstance( variables.filterType ) />--->

	<cffunction name="init" returntype="PhoneFilter">
		<cfargument name="queryCacheSpan" default="#createTimeSpan(0,0,10,0)#" required="false" />
		<cfset variables.queryCacheSpan = arguments.queryCacheSpan />
		
		<cfscript>
			// TRV: build an array that indicates which private methods should be invoked in order to build the filter data set for this class
			THIS.arrActiveFilterMethods = arrayNew(1);
			arrayAppend(THIS.arrActiveFilterMethods,"getProductCarriers");
			arrayAppend(THIS.arrActiveFilterMethods,"getProductPricing");
			arrayAppend(THIS.arrActiveFilterMethods,"getProductBrands");
			arrayAppend(THIS.arrActiveFilterMethods,"getProductPlanTypes");
		</cfscript>
		<cfreturn this >
	</cffunction>

	<cfinclude template="ProductFilter.cfm">

</cfcomponent>