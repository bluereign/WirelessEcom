<cfcomponent output="false" displayname="Offer">

	<cffunction name="init" returntype="Offer">
		<cfreturn this />
	</cffunction>

	<cffunction name="getByProductID" returntype="query">
		<cfargument name="product_id" type="numeric" required="true">
		<cfargument name="sePricing" type="boolean" default="#session.sePricing#"> <!--- this is set in the site config --->
		<cfset var local = structNew()>
		<cfquery name="local.qProductOffers" datasource="#application.dsn.ACBMasterDS#">
			SELECT
				POT.name,
				POT.link,
				PO.offervalue,
				p.price,
				p.ProductTitle
			FROM
				Products p 
				LEFT OUTER JOIN PhoneOffers_NW po ON
					p.Product_ID = po.Product_ID
				LEFT OUTER JOIN PhoneOffersTitle_NW pot ON
					po.POTID = pot.POTID
			WHERE
				p.product_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
			AND	POT.Active = 1
			AND	nonSearchEngineCust = <cfif not arguments.sePricing>1<cfelse>0</cfif>
		</cfquery>
		<cfreturn local.qProductOffers>
	</cffunction>

</cfcomponent>