<cfcomponent output="false" displayname="AdminProductGuid">

	<cffunction name="init" returntype="AdminProductGuid">
    	<cfreturn this>
    </cffunction>
	
    <cffunction name="deleteProductGuid" returntype="string">
    	<cfargument name="productGuid" required="true" type="string" />
	
        <cfset var local = {
				productGuid = arguments.productGuid
			} />
		
		<cftry>
	        <cfquery name="local.deleteProductGuid" datasource="#application.dsn.wirelessadvocates#">
	        	DELETE FROM Catalog.ProductGuid 
				WHERE ProductGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.productGuid#" />
	        </cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>	
        
        <cfreturn "" />
    </cffunction>
    
    <cffunction name="insertProductGuid" returntype="string">
    	<cfargument name="productGuid" required="true" type="string" />
    	<cfargument name="productTypeId" required="true" type="Numeric" />
	
        <cfset var local = {
				productGuid = arguments.productGuid,
				productTypeId = arguments.productTypeId
			} />
			
        <cfquery name="local.insertProductGuid" datasource="#application.dsn.wirelessadvocates#">
        	INSERT INTO Catalog.ProductGuid (
				ProductGuid,
				ProductTypeId
			) VALUES (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.productGuid#" />,
				<cfqueryparam cfsqltype="cf_sql_tinyint" value="#local.productTypeId#" />
			)
        </cfquery>
        
        <cfreturn "" />
    </cffunction>
	
</cfcomponent>