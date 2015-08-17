<cfcomponent output="false" displayname="CarrierServiceLog">

	<cffunction name="init" returntype="CarrierServiceLog">
    	<cfreturn this>
    </cffunction>
    
    <cffunction name="getRecent" returntype="query">
    	
        <cfset var local = structNew()>
        
		<cftry>
	        <cfquery name="local.list" datasource="#application.dsn.wirelessadvocates#">
	            SELECT TOP 100 cl.Id, 
						cl.ReferenceNumber, 
						cl.carrier,
						cl.RequestType, 
						cl.Type,
						(select top 1 LoggedDateTime from service.CarrierInterfaceLog where ReferenceNumber = cl.ReferenceNumber order by LoggedDateTime desc) as LoggedDateTime 
				FROM service.CarrierInterfaceLog cl
	            ORDER BY  
					(select top 1 LoggedDateTime from service.CarrierInterfaceLog where ReferenceNumber = cl.ReferenceNumber order by LoggedDateTime desc) desc
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
    
    	<cfreturn local.list>
    </cffunction>

    <cffunction name="getLogEntry" returntype="query">
    	<cfargument name="entryId" type="numeric" />
	
        <cfset var local = {
				entryId = arguments.entryId			
			}>
        
		<cftry>
	        <cfquery name="local.getLogEntry" datasource="#application.dsn.wirelessadvocates#">
	            SELECT cl.Id, 
						cl.ReferenceNumber, 
						cl.carrier,
						cl.RequestType, 
						cl.Type,
						cl.Data
				FROM service.CarrierInterfaceLog cl
				WHERE cl.Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.entryId#" />
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
    
    	<cfreturn local.getLogEntry />
    </cffunction>
    
</cfcomponent>