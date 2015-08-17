<cfcomponent output="false" displayname="SiteMap">

	<cfset variables.instance = {} />

	<cffunction name="init" output="false" access="public" returntype="cfc.model.system.utility.RobotFileWriter">
		<cfargument name="Domain" type="string" default="" required="false" />
		<cfargument name="DisallowBots" type="boolean" default="false" required="false" />

		<cfset variables.instance.Domain = arguments.Domain />
		<cfset variables.instance.DisallowBots = arguments.DisallowBots />
		<!--- Remove this when this component is added to CS --->
        <cfset setAssetPaths( application.wirebox.getInstance("assetPaths") ) />

		<cfreturn this />
	</cffunction>

	<cffunction name="loadRobotsFile" output="false" access="public" returntype="void">
		<cfargument name="PathToDirectory" type="string" required="true" />
		
		<cfset var robotsText = '' />

<!--- Avoid Indentation on FileWrite --->
<cfsavecontent variable="robotsText">
User-agent: *
<cfif Len(variables.instance.DisallowBots)>Disallow: /</cfif>
<cfif Len(variables.instance.Domain)>Sitemap: http://<cfoutput>#variables.instance.Domain#</cfoutput>/sitemap.xml</cfif>
</cfsavecontent>
		
		<cfset FileSetAttribute(arguments.PathToDirectory & 'robots.txt', 'normal') />
		<cfset fileWrite(arguments.PathToDirectory & 'robots.txt', trim(robotsText)) />
	</cffunction>
	
	<cffunction name="getAssetPaths" access="private" output="false" returntype="struct">    
    	<cfreturn variables.instance.assetPaths />    
    </cffunction>    
    <cffunction name="setAssetPaths" access="private" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance.assetPaths = arguments.theVar />    
    </cffunction>
    
</cfcomponent>