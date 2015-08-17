<cfcomponent output="false" displayname="AdminNavMenu">

	<cffunction name="init" returntype="AdminNavMenu">
		<cfreturn this />
	</cffunction>

	<cffunction name="buildMenu" access="public" returntype="array" output="false">
		<cfargument name="menu_xml" type="string" required="true" />

		<cfset var local = structNew() />
		<cfset local.menu = xmlParse(trim(arguments.menu_xml)) />

		<cfset local.xmlArray = application.model.xmlUtil.recurseXMLObject(application.model.xmlUtil.getRootElement(local.menu), '0', 'item') />

		<cfreturn local.xmlArray />
	</cffunction>

	<cffunction name="buildMenuAtLevel" access="public" returntype="string" output="false">
		<cfargument name="menuArray" type="array" required="true" />
		<cfargument name="currentId" type="string" default="" required="false" />
		<cfargument name="level" type="numeric" default="1" required="false" />
		<cfargument name="parentId" type="string" default="0" required="false" />
		<cfargument name="depth" type="numeric" default="1000" required="false" />

		<cfset var local = structNew() />

		<cfset local.html = '' />
		<cfset local.level = arguments.level />
		<cfset local.currentId = arguments.currentId />
		<cfset local.depth = arguments.depth />
		<cfset local.parentId = arguments.parentId />
		<cfset local.menuArray = arguments.menuArray />

		<cfif local.depth gte local.level>
			<cfset local.html = trim(local.html) & '<ul>' />

			<cfloop index="local.idx" from="1" to="#arrayLen(local.menuArray)#">
				<cfif local.menuArray[local.idx].parentId eq local.parentId>
					<cfset local.parentAtLevel = application.model.adminNavMenu.getParentAtDepth(local.menuArray, local.menuArray[local.idx].nodeDepth, local.currentId) />

					<cfset local.selected = '' />

					<cfif local.parentAtLevel eq local.menuArray[local.idx].id>
						<cfset local.selected = ' class="selected" ' />
					</cfif>

					<cfset local.linkClass = '' />

					<cfif local.level eq 1>
						<cfset linkClass = 'top-level'>
					</cfif>

					<cfif local.menuArray[local.idx].isActive>

						<!---Top level menu should never have a href link--->
						<cfif local.level eq 0>
							<cfset local.html = trim(local.html) & '<li ' & local.selected & '><a href="?c=' & local.menuArray[local.idx].id & '" class="' & local.linkClass & '">' & local.menuArray[local.idx].attributes.name & '</a>' />
						<cfelse>
							<cfif len(trim(local.menuArray[local.idx].attributes.Channel))>
								<cfset local.html = trim(local.html) & '<li ' & local.selected & '><a href="?c=' & local.menuArray[local.idx].id & '&channel=' & local.menuArray[local.idx].attributes.Channel & '" class="' & local.linkClass & '">' & local.menuArray[local.idx].attributes.name & '</a>' />
							<cfelse>
								<cfset local.html = trim(local.html) & '<li ' & local.selected & '><a href="?c=' & local.menuArray[local.idx].id & '" class="' & local.linkClass & '">' & local.menuArray[local.idx].attributes.name & '</a>' />
							</cfif>
						</cfif>

						<cfset local.html = trim(local.html) & buildMenuAtLevel(local.menuArray, local.currentId, (local.level + 1), local.menuArray[local.idx].id, local.depth) />
						<cfset local.html = trim(local.html) & '</li>' />

					</cfif>
				</cfif>
			</cfloop>

			<cfset local.html = trim(local.html) & '</ul>' />
		</cfif>

		<cfreturn trim(local.html) />
	</cffunction>

	<cffunction name="getPageTitle" access="public" returntype="string" output="false">
		<cfargument name="menuArray" type="array" required="true" />
		<cfargument name="currentId" type="string" default="" required="false" />

		<cfset var local = structNew() />
		<cfset local.getPageTitleReturn = '' />
		<cfset local.currentId = arguments.currentId />
		<cfset local.menuArray = arguments.menuArray />

		<cfloop index="local.idx" from="1" to="#arrayLen(local.menuArray)#">
			<cfif local.menuArray[local.idx].id eq local.currentId>
				<cfset local.getPageTitleReturn = trim(local.menuArray[local.idx].attributes.name) />
			</cfif>
		</cfloop>

		<cfreturn trim(local.getPageTitleReturn) />
	</cffunction>
</cfcomponent>