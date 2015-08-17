<cfcomponent output="false" displayname="Utility">

	<cffunction name="init" returntype="Utility">
    	<cfreturn this>
    </cffunction>
    
   	<cffunction name="getProductId" returntype="string">
		<cfargument name="productGuid" required="true" />
		
		<cfset var local = { productGuid = arguments.productGuid } />
		
		<cfquery name="local.getProductId" datasource="#application.dsn.wirelessadvocates#">
			SELECT ProductId
			FROM Catalog.Product
			WHERE ProductGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.productGuid#" />
		</cfquery>
		
		<cfreturn local.getProductId.ProductId />
	</cffunction>
    
   	<cffunction name="getProductTypeId" returntype="string">
		<cfargument name="productType" required="true" />
		
		<cfset var local = { productType = arguments.productType } />
		
		<cfquery name="local.getProductTypeId" datasource="#application.dsn.wirelessadvocates#">
			SELECT ProductTypeId
			FROM Catalog.ProductType
			WHERE ProductType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.productType#" />
		</cfquery>
		
		<cfreturn local.getProductTypeId.ProductTypeId />
	</cffunction>

	<cffunction name="indentXml" output="false" returntype="string">
		<cfargument name="xml" type="string" required="true" />
		<cfargument name="indent" type="string" default="  " hint="The string to use for indenting (default is two spaces)." />
		
		<cfset var lines = "" />
		<cfset var depth = "" />
		<cfset var line = "" />
		<cfset var isCDATAStart = "" />
		<cfset var isCDATAEnd = "" />
		<cfset var isEndTag = "" />
		<cfset var hasEndTag = "" />
		<cfset var isSelfClose = "" />
		<!--- todo: clean up the code in this function to match the conventions for the rest of the site (using local) --->
		<cfset xml = trim(REReplace(arguments.xml, "(^|>)\s*(<|$)", "\1#chr(10)#\2", "all")) />
		<cfset lines = listToArray(xml, chr(10)) />
		<cfset depth = 0 />
		
		<cfloop from="1" to="#arrayLen(lines)#" index="i">
			<cfset line = trim(lines[i]) />
			<cfset isCDATAStart = left(line, 9) EQ "<![CDATA[" />
			<cfset isCDATAEnd = right(line, 3) EQ "]]>" />
			
			<cfif NOT isCDATAStart AND NOT isCDATAEnd AND left(line, 1) EQ "<" AND right(line, 1) EQ ">">
				<cfset hasEndTag = REFind("</", line) />
			    <cfset isEndTag = left(line, 2) EQ "</" />
			    <cfset isSelfClose = right(line, 2) EQ "/>" />
			    
			    <cfif isEndTag>
			        <!--- use max for safety against multi-line open tags --->
			        <cfset depth = max(0, depth - 1) />
			    </cfif>
			    <cfset lines[i] = repeatString(indent, depth) & line />
			    
			    <cfif NOT hasEndTag AND NOT isSelfClose>
			    	<cfset depth = depth + 1 />
			    </cfif>
			<cfelseif isCDATAStart>
			      <!---
			      we don't indent CDATA ends, because that would change the
			      content of the CDATA, which isn't desirable
			      --->
			      <cfset lines[i] = repeatString(indent, depth) & line />
			 </cfif>
		</cfloop>
		
		<cfreturn arrayToList(lines, chr(10)) />
	</cffunction>
	
	<cffunction name="checkGersSku" output="false" returntype="numeric">
		<cfargument name="gersSku" type="string" />
		
		<cfset var local = { gersSku = arguments.gersSku } />
		
		<cftry>
			<cfquery name="local.isGersSku" datasource="#application.dsn.wirelessadvocates#">
				SELECT COUNT(*) as GersCount
				FROM catalog.GersItm
				WHERE GersSku = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.gersSku#" />
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
		<cfreturn local.isGersSku.GersCount />
	</cffunction>

	<cffunction name="getMenuRoles" output="false" returntype="query">
		<cfargument name="menuGuid" type="string" />
		
		<cfset var local = {
			menuGuid = arguments.menuGuid		
		 } />	
		 
		 <cftry>
			<cfquery name="local.getMenuRoles" datasource="#application.dsn.wirelessadvocates#">
				SELECT RoleGuid,
					   MenuGuid
				FROM account.RoleMenu
				WHERE MenuGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.menuGuid#" />
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
		
		<cfreturn local.getMenuRoles />
	</cffunction>
</cfcomponent>