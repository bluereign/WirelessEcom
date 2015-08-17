<cfcomponent output="false" displayname="AdminPublish">

	<cffunction name="init" returntype="AdminPublish">
    	<cfreturn this />
    </cffunction>


	<cffunction name="getLastPub" access="public" returntype="query" output="false">
		
		<cftry>
			<cfquery name="local.lastPub" datasource="#application.dsn.wirelessadvocates#">
				SELECT MAX(Timestamp) as lastTS, datediff(minute, MAX(Timestamp), getdate()) as minutesSinceLastPub
				FROM logging.DataPush 
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>

		</cftry>	
		<cfreturn local.lastPub />	
	</cffunction>
	
	<cffunction name="getPubHistory" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#structNew()#" />
		<cfargument name="carrier" required="false" default="" type="string" />
		
		<cfset var local = { filter = arguments.filter } />

		<cftry>
			<cfquery name="local.pubHistory" datasource="#application.dsn.wirelessadvocates#">
				SELECT [Channel]
			      ,[ProductType]
			      ,[GersSKU]
			      ,[ProductName]
			      ,[Change Type] as ChangeType
			      ,[Attribute]
			      ,[Updated Value] as UpdatedValue
			      ,[Change Date] as ChangeDate
			  FROM logging.datapushHistory where [Change Date] >= dateadd(month, -3, getdate())
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>

		</cftry>
		
		<cfreturn local.pubHistory />
	</cffunction>
	
	<cffunction name="getPubSet" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#structNew()#" />
		<cfargument name="carrier" required="false" default="" type="string" />
		
		<cfset var local = { filter = arguments.filter } />

		<cftry>
			<cfquery name="local.pubSet" datasource="#application.dsn.wirelessadvocates#">
				SELECT [Channel]
			      ,[ProductType]
			      ,[GersSKU]
			      ,[ProductName]
			      ,[Change Type] as ChangeType
			      ,[Attribute]
			      ,[Updated Value] as UpdatedValue
			      ,[Change Date] as ChangeDate
			  FROM logging.datapushSet 
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>

		</cftry>
		
		<cfreturn local.pubSet />
	</cffunction>

</cfcomponent>
