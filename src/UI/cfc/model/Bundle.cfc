<cfcomponent output="false" displayname="Bundle">

	<cffunction name="init" returntype="Bundle">
		<cfreturn this />
	</cffunction>

    <cffunction name="getBundles" access="public" returntype="query" output="false">
		<cfargument name="bundleId" required="false" type="numeric" />

		<cfset var getBundlesReturn = '' />
		<cfset var qry_getBundles = '' />

		<cfquery name="qry_getBundles" datasource="#application.dsn.wirelessAdvocates#">
			SELECT	b.id, b.[name], b.bundle, b.createdBy, b.createdOn, b.active
			FROM	catalog.bundle AS b WITH (NOLOCK)
			WHERE	1=1
			<cfif structKeyExists(arguments, 'bundleId')>
				AND	b.id	=	<cfqueryparam value="#arguments.bundleId#" cfsqltype="cf_sql_integer" />
			</cfif>
        </cfquery>

		<cfset getBundlesReturn = qry_getBundles />

        <cfreturn getBundlesReturn />
    </cffunction>

	<cffunction name="saveBundleAs" access="public" returntype="boolean" output="false">
    	<cfargument name="name" type="string" required="true" />
        <cfargument name="serializedBundle" type="string" required="true" />
        <cfargument name="createdBy" type="string" required="true" />
        <cfargument name="active" type="boolean" required="false" default="true" />

		<cfset var saveBundleAsReturn = false />
		<cfset var bundleExists = false />
		<cfset var qry_getBundle = '' />
		<cfset var qry_saveBundle = '' />

        <cfquery name="qry_getBundle" datasource="#application.dsn.wirelessAdvocates#">
			SELECT	c.id
			FROM	catalog.bundle AS c WITH (NOLOCK)
			WHERE	name	=	<cfqueryparam value="#trim(arguments.name)#" cfsqltype="cf_sql_varchar" />
		</cfquery>

		<cfif qry_getBundle.recordCount>
        	<cfset bundleExists = true />
        </cfif>

        <!--- save the bundle --->
        <cfquery name="qry_saveBundle" datasource="#application.dsn.wirelessAdvocates#">
        	<cfif bundleExists>
            	<!--- update the existing record --->
            	UPDATE		[catalog].[bundle]
				SET			[name]		=	<cfqueryparam value="#trim(arguments.name)#" cfsqltype="cf_sql_varchar" />
						,	[bundle]	=	<cfqueryparam value="#trim(arguments.serializedBundle)#" cfsqltype="cf_sql_varchar" />
						,	[createdBy]	=	<cfqueryparam value="#trim(arguments.createdBy)#" cfsqltype="cf_sql_varchar" />
						,	[createdOn]	=	GETDATE()
						,	[active]	=	<cfqueryparam value="#arguments.active#" cfsqltype="cf_sql_bit" />
				WHERE		name		=	<cfqueryparam value="#trim(arguments.name)#" cfsqltype="cf_sql_varchar" />
            <cfelse>
            	<!--- insert a new record --->
            	INSERT INTO	[catalog].[bundle]
				(
						[name]
					,	[bundle]
					,	[createdBy]
					,	[createdOn]
					,	[active]
				)
				VALUES
				(
						<cfqueryparam value="#trim(arguments.name)#" cfsqltype="cf_sql_varchar" />
					,	<cfqueryparam value="#trim(arguments.serializedBundle)#" cfsqltype="cf_sql_varchar" />
					,	<cfqueryparam value="#trim(arguments.createdBy)#" cfsqltype="cf_sql_varchar" />
					,	GETDATE()
					,	<cfqueryparam value="#arguments.active#" cfsqltype="cf_sql_bit" />
				)
			</cfif>
		</cfquery>

		<cfset saveBundelAsReturn = true />

		<cfreturn saveBundleAsReturn />
    </cffunction>

	<cffunction name="removeBundle" access="public" returntype="boolean" output="false">
		<cfargument name="id" required="false" type="numeric" />
		<cfargument name="name" required="false" type="string" />

		<cfset var removeBundleReturn = false />
		<cfset var qry_removeBundle = '' />

		<cfif structKeyExists(arguments, 'id') or structKeyExists(arguments, 'name') and len(trim(arguments.name))>
			<cfquery name="qry_removeBundle" datasource="#application.dsn.wirelessAdvocates#">
				DELETE
				FROM	catalog.bundle
				WHERE	1 = 1
					<cfif structKeyExists(arguments, 'id')>
						AND	id	=	<cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
					</cfif>
					<cfif structKeyExists(arguments, 'name')>
						AND	name	=	<cfqueryparam value="#trim(arguments.name)#" cfsqltype="cf_sql_varchar" />
					</cfif>
			</cfquery>

			<cfset removeBundleReturn = true />
		</cfif>

		<cfreturn removeBundleReturn />
	</cffunction>

    <cffunction name="deserializeBundle" access="public" returntype="any">
    	<cfargument name="name" type="string" required="true" />

		<cfset var deserializeBundleReturn = '' />
		<cfset var qry_getBundle = '' />
		<cfset var serializer = createObject('component', 'serialiser') />

        <cfquery name="qry_getBundle" datasource="#application.dsn.wirelessAdvocates#">
			SELECT	b.bundle
			FROM	catalog.bundle AS b WITH (NOLOCK)
			WHERE	name	=	<cfqueryparam value="#trim(arguments.name)#" cfsqltype="cf_sql_varchar" />
        </cfquery>

		<cfset deserializeBundleReturn = serializer.deserialize(qry_getBundle.bundle) />

        <cfreturn deserializeBundleReturn />
    </cffunction>

</cfcomponent>