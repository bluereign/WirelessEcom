<cfcomponent output="false" displayname="Feature">

	<cffunction name="init" returntype="Feature">
		<cfreturn this />
	</cffunction>

	<cffunction name="getByProductID" returntype="query">
		<cfargument name="productID" type="string" required="true"> <!--- type is string to support IDs being passed in a list format --->
		<cfset var local = structNew()>

		<cfquery name="local.qFeature" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				s.*
			,	s.MonthlyFee as price
			,	ISNULL((SELECT TOP 1 LTRIM(RTRIM(Label)) FROM catalog.ServiceMaster where ServiceGuid = s.ServiceGuid), ISNULL((SELECT LTRIM(RTRIM(Value)) FROM catalog.Property where Name = 'Title' and ProductGuid = s.ServiceGuid),s.Title)) as summaryTitle
			,	ISNULL((SELECT TOP 1 LTRIM(RTRIM(Label)) FROM catalog.ServiceMaster where ServiceGuid = s.ServiceGuid), ISNULL((SELECT LTRIM(RTRIM(Value)) FROM catalog.Property where Name = 'Title' and ProductGuid = s.ServiceGuid),s.Title)) as detailTitle
			,	ISNULL((SELECT LTRIM(RTRIM(Value)) FROM catalog.Property where Name = 'ShortDescription' and ProductGuid = s.ServiceGuid),NULL) as summaryDescription
			,	ISNULL((SELECT LTRIM(RTRIM(Value)) FROM catalog.Property where Name = 'LongDescription' and ProductGuid = s.ServiceGuid),NULL) as detailDescription
			,	ISNULL((SELECT LTRIM(RTRIM(Value)) FROM catalog.Property where Name = 'feature_description' and ProductGuid = s.ServiceGuid),NULL) as carrierDescription
			,	c.CarrierId
			,	p.ProductGuid
			,	p.ProductId
			,	p.GersSku
			,	p.Active
			,	r.RecommendationId
			,	r.Description RecommendationDescription
            ,   IsNull(r.hideMessage, 0) as hideMessage
			FROM catalog.Service s
			INNER JOIN catalog.Product p on s.ServiceGuid = p.ProductGuid
			INNER JOIN catalog.Company c on s.CarrierGuid = c.CompanyGuid
			LEFT JOIN cart.Recommendation r ON r.ProductId = p.ProductId
			WHERE
			<cfif arguments.productID does not contain ",">
				p.productid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Trim(arguments.productID)#">
			<cfelse>
				p.productid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.productID#" list="true"> )
			</cfif>
		</cfquery>

		<cfreturn local.qFeature />
	</cffunction>

</cfcomponent>