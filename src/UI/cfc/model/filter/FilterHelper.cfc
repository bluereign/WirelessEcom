<cfcomponent output="false" displayname="FilterHelper">

	<cffunction name="init" returntype="FilterHelper">
		<cfscript>
			variables.instance.filterOptions = structNew();

			variables.instance.filterOptions.phone = structNew();
			variables.instance.filterOptions.plan = structNew();
			variables.instance.filterOptions.dataCardAndNetbook = structNew();
			variables.instance.filterOptions.prepaid = structNew();
			variables.instance.filterOptions.accessory = structNew();
			
			variables.instance.filterOptions.phone.planType = structNew();
			variables.instance.filterOptions.phone.planType['new'] = "32";
			variables.instance.filterOptions.phone.planType['upgrade'] = "33";
			variables.instance.filterOptions.phone.planType['addaline'] = "34";

			variables.instance.filterOptions.phone.carrierid = structNew();
			variables.instance.filterOptions.phone.carrierid['109'] = "1";
			variables.instance.filterOptions.phone.carrierid['128'] = "2";
			variables.instance.filterOptions.phone.carrierid['42'] = "3";

			variables.instance.filterOptions.plan.planType = structNew();
			variables.instance.filterOptions.plan.planType['individual'] = "39";
			variables.instance.filterOptions.plan.planType['family'] = "40";
			variables.instance.filterOptions.plan.planType['data'] = "41";

			variables.instance.filterOptions.plan.carrierid = structNew();
			variables.instance.filterOptions.plan.carrierid['109'] = "36";
			variables.instance.filterOptions.plan.carrierid['128'] = "37";
			variables.instance.filterOptions.plan.carrierid['42'] = "38";

			variables.instance.filterOptions.dataCardAndNetbook.carrierid = structNew();
			variables.instance.filterOptions.dataCardAndNetbook.carrierid['109'] = "67";
			variables.instance.filterOptions.dataCardAndNetbook.carrierid['128'] = "68";
			variables.instance.filterOptions.dataCardAndNetbook.carrierid['42'] = "69";

			variables.instance.filterOptions.prepaid.carrierid = structNew();
			variables.instance.filterOptions.prepaid.carrierid['109'] = "71";
			variables.instance.filterOptions.prepaid.carrierid['128'] = "72";
			variables.instance.filterOptions.prepaid.carrierid['42'] = "73";
		</cfscript>

		<cfreturn this >
	</cffunction>

	<cffunction name="getFilterOptionId" access="public" output="false" returntype="string">
		<cfargument name="productType" type="string" required="true">
		<cfargument name="property" type="string" required="true">
		<cfargument name="value" type="string" required="true">
		<cfset var local = structNew()>

		<cftry>
			<cfset local.return = variables.instance.filterOptions[arguments.productType][arguments.property][arguments.value]>
			<cfcatch type="any">
				<cfset local.return = "0">
			</cfcatch>
		</cftry>

		<cfreturn local.return>
	</cffunction>

</cfcomponent>