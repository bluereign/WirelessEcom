<cfcomponent output="false" displayname="AdminNavMenu">

	<cffunction name="init" access="public" returntype="AdminNavMenu" output="false">

		<cfset var local = structNew() />
		<cfset variables.instance = structNew() />

		<cfset local.thisDirectory = trim(application.adminWebroot) & '\assets' />
		<cffile action="read" file="#trim(local.thisDirectory)#\menu.xml" variable="variables.instance.menuXml" />

		<cfset variables.instance.menuArray = arrayNew(1) />
		<cfset variables.instance.menuArray = buildArray(1, variables.instance.menuArray) />

		<cfreturn this />
	</cffunction>

	<cffunction name="getLevel" access="public" returntype="query" output="false">
		<cfargument name="parentId" type="string" default="0" required="false" />

		<cfset var local = structNew() />

		<cfquery name="local.getLevel" datasource="#application.dsn.wirelessadvocates#">
			SELECT		am.adminMenuId, am.label, am.displayFile, am.parentId,
						am.isActive, am.ordinal, ch.Channel
			FROM		dbo.adminMenu AS am WITH (NOLOCK)
				LEFT JOIN catalog.channel ch on am.channelId = ch.channelId
			WHERE		am.parentId	=	<cfqueryparam value="#arguments.parentId#" cfsqltype="cf_sql_varchar" />
			ORDER BY	am.ordinal
		</cfquery>

		<cfreturn local.getLevel />
	</cffunction>

	<cffunction name="buildArray" access="private" returntype="array" output="false">
		<cfargument name="depth" type="numeric" default="0" required="false" />
		<cfargument name="itemsArray" type="array" required="false" />
		<cfargument name="parentId" type="string" default="5b77c8cb-8ac5-4259-979d-72ef51422cd4" required="false" />

		<cfset var local = structNew() />
		<cfset local.depth = arguments.depth />
		<cfset local.itemsArray = arguments.itemsArray />
		<cfset local.parentId = arguments.parentId />

		<cfset local.itemsInLevel = getLevel(local.parentId) />

		<cfloop query="local.itemsInLevel">
			<cfset local.itemsArray[(arrayLen(local.itemsArray) + 1)] = structNew() />
			<cfset local.itemsArray[arrayLen(local.itemsArray)].nodeDepth = local.depth />
			<cfset local.itemsArray[arrayLen(local.itemsArray)].id = local.itemsInLevel.adminMenuId />
			<cfset local.itemsArray[arrayLen(local.itemsArray)].parentId = local.itemsInLevel.parentId />
			<cfset local.itemsArray[arrayLen(local.itemsArray)].isActive = local.itemsInLevel.isActive />
			<cfset local.itemsArray[arrayLen(local.itemsArray)].attributes = structNew() />
			<cfset local.itemsArray[arrayLen(local.itemsArray)].attributes.name = local.itemsInLevel.label />
			<cfset local.itemsArray[arrayLen(local.itemsArray)].attributes.Channel = local.itemsInLevel.Channel />
			<cfset local.childItemsInLevel = getLevel(local.itemsInLevel.adminMenuId) />

			<cfif local.childItemsInLevel.recordCount>
				<cfset local.itemsArray = buildArray((local.depth + 1), local.itemsArray, local.itemsInLevel.adminMenuId) />
			</cfif>
		</cfloop>

		<cfreturn local.itemsArray />
	</cffunction>

	<cffunction name="getParentAtDepth" access="public" returntype="string" output="false">
		<cfargument name="itemsArray" type="array" required="false" />
		<cfargument name="depth" type="numeric" default="0" required="false" />
		<cfargument name="id" type="string" default="" required="false" />

		<cfset var local = structNew() />
		<cfset local.itemsArray = arguments.itemsArray />
		<cfset local.depth = arguments.depth />
		<cfset local.id = arguments.id />

		<cfset local.parentId = '' />
		<cfset local.parentDepth = 1 />
		<cfset local.index = 1 />

		<cfloop condition="local.depth eq local.parentDepth and local.index lt 30">
			<cfset local.parent = getParent(local.itemsArray, local.id) />

			<cfloop index="local.idx" from="1" to="#arrayLen(local.itemsArray)#">
				<cfif local.itemsArray[local.idx].id eq local.parent.id>
					<cfif local.itemsArray[local.idx].nodeDepth eq local.depth>
						<cfreturn local.itemsArray[local.idx].id />
					<cfelse>
						<cfset local.id = local.itemsArray[local.idx].id />
					</cfif>

					<cfbreak />
				</cfif>
			</cfloop>

			<cfset local.index = (local.index + 1) />
		</cfloop>

		<cfreturn 'end A' />
	</cffunction>

	<cffunction name="getParent" access="private" returntype="struct" output="false">
		<cfargument name="itemsArray" type="array" required="false" />
		<cfargument name="id" type="string" default="" required="false" />

		<cfset var local = structNew() />
		<cfset local.itemsArray = arguments.itemsArray />
		<cfset local.id = arguments.id />
		<cfset local.result = structNew() />
		<cfset local.parentId = '' />

		<cfloop index="local.idx" from="1" to="#arrayLen(local.itemsArray)#">
			<cfif local.itemsArray[local.idx].id eq local.id>
				<cfset local.parentId = local.itemsArray[local.idx].parentId />
			</cfif>
		</cfloop>

		<cfloop index="local.idx" from="1" to="#arrayLen(local.itemsArray)#">
			<cfif local.itemsArray[local.idx].id eq local.parentId>
				<cfset local.result.id = local.itemsArray[local.idx].id />
				<cfset local.result.nodeDepth = local.itemsArray[local.idx].nodeDepth />

				<cfreturn local.result />
			</cfif>
		</cfloop>

		<cfif not isDefined('local.result.id')>
			<cfset local.result.id = local.id />
			<cfset local.result.nodeDepth = 1 />
		</cfif>

		<cfreturn local.result />
	</cffunction>

	<cffunction name="getParentFromDepth" access="public" returntype="string" output="false">
		<cfargument name="menuArray" type="array" required="true" />
		<cfargument name="depth" type="numeric" default="1" required="false" />

		<cfset var local = structNew() />
		<cfset local.menuArray = arguments.menuArray />
		<cfset local.depth = arguments.depth />
		<cfset local.parentId = '0' />

		<cfloop index="local.idx" from="1" to="#arrayLen(local.menuArray)#">
			<cfif local.menuArray[local.idx].nodeDepth eq local.depth>
				<cfset local.parentId = local.menuArray[local.idx].parentId />

				<cfreturn local.parentId />
			</cfif>
		</cfloop>

		<cfreturn local.parentId />
	</cffunction>

	<cffunction name="getMenuXml" access="public" returntype="string" output="false">
		<cfreturn trim(variables.instance.menuXml) />
	</cffunction>

	<cffunction name="getMenuAsArray" access="public" returntype="array" output="false">
		<cfreturn variables.instance.menuArray />
	</cffunction>

	<cffunction name="getDisplayComponentByMenuId" access="public" returntype="array" output="false">
		<cfargument name="menuId" type="string" required="true" />

		<cfset var local = {menuId = arguments.menuId, result = []} />

		<cftry>
			<cfquery name="local.getComponents" datasource="#application.dsn.wirelessadvocates#">
				SELECT		ac.component, ac.title
				FROM		dbo.adminComponent AS ac WITH (NOLOCK)
				WHERE		ac.adminMenuId	=	<cfqueryparam value="#trim(local.menuId)#" cfsqltype="cf_sql_varchar" />
				ORDER BY	ac.ordinal
			</cfquery>

			<cfloop query="local.getComponents">
				<cfset local.result[(arrayLen(local.result) + 1)] = structNew() />
				<cfset local.result[arrayLen(local.result)].component = local.getComponents.component />
				<cfset local.result[arrayLen(local.result)].title = local.getComponents.title />
			</cfloop>

			<cfcatch type="any">

			</cfcatch>
		</cftry>

		<cfreturn local.result />
	</cffunction>
</cfcomponent>