<cfcomponent output="false">
	
	<cffunction name="init" access="public" output="false" returntype="InstantRebateGateway">
		<cfargument name="dsn" required="true" type="string">
		<cfset setDSN( arguments.dsn )>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getInstantRebateAmt" access="public" output="false" returntype="query" hint="Retrieves value of instant rebate. If no rebate is available, returns 0.00." >
		<cfargument name="sku" required="true" type="string">
		<cfargument name="regularPriceGroup" required="true" type="string">
		<cfargument name="rebatePriceGroup" required="true" type="string">
		
		<cfset var qRebateAmt = "">
		
		<cfquery name="qRebateAmt" datasource="#getDSN()#">
			DECLARE @regularPrice money, 
					@rebatePrice money

			SELECT 		TOP 1 --Should only ever be one
						@regularPrice = Price
			FROM 		catalog.GersPrice qp
			WHERE 		qp.GersSku = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sku#">
							AND qp.PriceGroupCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.regularPriceGroup#">
							AND qp.StartDate <= GETDATE()
							AND qp.EndDate >= GETDATE()
			ORDER BY	qp.StartDate DESC
				
			SELECT 		TOP 1 --Should only ever be one
						@rebatePrice = Price
			FROM 		catalog.GersPrice qp
			WHERE 		qp.GersSku = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sku#">
							AND qp.PriceGroupCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.rebatePriceGroup#">
							AND qp.StartDate <= GETDATE()
							AND qp.EndDate >= GETDATE()
			ORDER BY	qp.StartDate DESC

			SELECT	@regularPrice AS regularPrice, 
					@rebatePrice as rebatePrice,
					@regularPrice - @rebatePrice AS rebateAmount
		</cfquery>
		
		<cfreturn qRebateAmt>	
	</cffunction>
	
	<!---------------------- GETTERS/SETTERS ----------------------->
		
	<cffunction name="getDSN" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["DSN"]/>    
    </cffunction>    
    <cffunction name="setDSN" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["DSN"] = arguments.theVar />    
    </cffunction>

</cfcomponent>