<!--- COMPONENT --->
<cfcomponent displayname="CampaignService" output="false" hint="I am the CampaignService class.">
	
	<!--- INIT --->
	<cffunction name="init" access="public" output="false" returntype="any" hint="I am the constructor method of the CampaignService class.">
		<cfset variables.datasource = application.dsn.wirelessadvocates />
		<cfreturn this />
	</cffunction>
	
	<!--- RETRIEVE - BY SUBDOMAIN --->
	<cffunction name="getCampaignBySubdomain" access="public" output="false" returntype="any" hint="I return a Campaign bean populated with the details of a specific campaign record.">
		<cfargument name="subdomain" type="string" required="true" hint="I am the string subdomain of the campaign to search for." />
		<cfset var qGetCampaign = '' />
		<cfset var qGetCssProps = '' />
		<cfset var campaignObject = '' />
		<cfset var propStruct = {} />
		<cfset var formFields = '' />
		<cfset var iX = 0 />
	
		<cftry>	
			<!--- get the campaign by campaignId --->
			<cfquery name="qGetCampaign" datasource="#variables.datasource#">
				SELECT campaignId, companyName, startDateTime, endDateTime, smsMessage, disclaimer, subdomain, logoImage, bgImage, adImage, headerImage, adUrl, version, isActive
				FROM campaign.Campaign
				WHERE subdomain = <cfqueryparam value="#ARGUMENTS.subdomain#" cfsqltype="cf_sql_varchar" />
			</cfquery>
			
			<cfif qGetCampaign.RecordCount eq 0>
				<!--- no campaign found, return void --->
				<!--- the IsValidCampign interceptor should prevent a zero record count ever being returned --->
				<cfreturn />
			</cfif>
			
			<!--- get css properties by campaignId --->
			<cfquery name="qGetCssProps" datasource="#variables.datasource#">
				SELECT CssPropertyId, formField, value
				FROM campaign.CssProperty
				WHERE campaignId = <cfqueryparam value="#qGetCampaign.campaignId#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<!--- loop through the css properties for this campaign --->
			<cfloop query="qGetCssProps">
				<!--- add a css property bean for each css property --->
				<!--- to a named stuct based on the formField value --->
				<cfset propStruct[qGetCssProps.formField] = createObject('component','cfc.model.campaign.CssProps').init(
					cssPropId   = qGetCssProps.CssPropertyId,
					formField   = qGetCssProps.formField,
					value       = qGetCssProps.value
				) />
			</cfloop>
			
			<!--- catch any errors --->
			<cfcatch type="any">
				<cfdump var="#cfcatch#">
				<cfabort>
			</cfcatch>
		</cftry>
		
		<!--- check if a campaign was found --->
		<cfif qGetCampaign.RecordCount>
			<!--- it was, return a campaign bean --->
			<cfreturn createObject('component','cfc.model.campaign.Campaign').init(
				campaignId    = qGetCampaign.campaignId,
				companyName  = qGetCampaign.companyName,
				startDateTime = qGetCampaign.startDateTime,
				endDateTime	  = qGetCampaign.endDateTime,
			  	smsMessage    = qGetCampaign.smsMessage,
			  	disclaimer    = qGetCampaign.disclaimer,
			  	logoImage     = qGetCampaign.logoImage,
			    bgImage       = qGetCampaign.bgImage,
			    adImage       = qGetCampaign.adImage,
			    headerImage   = qGetCampaign.headerImage,
			    adUrl 		  = qGetCampaign.adUrl,
			  	subdomain     = qGetCampaign.subdomain,
			  	version 	  = qGetCampaign.version,
				isActive      = qGetCampaign.isActive,
			 	cssProps      = propStruct
			) />
		<cfelse>
			<!--- no campaign found, return void --->
			<!--- the IsValidCampign interceptor should prevent a zero record count ever being returned --->
			<cfreturn />
		</cfif>
	</cffunction>
	
	<!--- RETRIEVE - BY Campaign Id --->
	<cffunction name="getCampaignById" access="public" output="false" returntype="any" hint="I return a Campaign bean populated with the details of a specific campaign record.">
		<cfargument name="campaignId" type="string" required="true" hint="I am the string subdomain of the campaign to search for." />
		<cfset var qGetCampaign = '' />
		<cfset var qGetCssProps = '' />
		<cfset var campaignObject = '' />
		<cfset var propStruct = {} />
		<cfset var formFields = '' />
		<cfset var iX = 0 />
	
		<cftry>	
			<!--- get the campaign by campaignId --->
			<cfquery name="qGetCampaign" datasource="#variables.datasource#">
				SELECT campaignId, companyName, startDateTime, endDateTime, smsMessage, disclaimer, subdomain, logoImage, bgImage, adImage, headerImage, adUrl, version, isActive
				FROM campaign.Campaign
				WHERE campaignId = <cfqueryparam value="#ARGUMENTS.campaignId#" cfsqltype="cf_sql_integer" />
			</cfquery>
			<!--- catch any errors --->
			<cfcatch type="any">
				<cfdump var="#cfcatch#">
				<cfabort>
			</cfcatch>
		</cftry>
			
		<cfif qGetCampaign.RecordCount eq 0>
			<!--- no campaign found, return void --->
			<!--- the IsValidCampign interceptor should prevent a zero record count ever being returned --->
			<cfreturn />
		<cfelse>
			<!--- We'll just leverage off of the get by subdomain function --->
			<cfreturn getCampaignBySubdomain(qGetCampaign.subdomain) />
		</cfif>
			
	</cffunction>
	
	<cffunction name="generateCss" access="public" output="false" returntype="void" hint="I generate the CSS override file for the supplied campaign.">
		<cfargument name="subdomain" type="string" required="true" hint="I am the campaign subdomain to generate CSS from." />
		<cfset var campaignObj = getCampaignBySubdomain( ARGUMENTS.subdomain ) />
		<cfset var assetPaths = application.wirebox.getInstance("AssetPaths") />
		<cfset var cssFile = '' />
		<cfset var logoImage = '' />
		<cfset var bgImage = '' />
		<cfset var adImage = '' />
		<cfset var headerImage = '' />

		  <!--- generate the css for the provided campaign --->
		  <cfsavecontent variable="cssFile">
		    <cfoutput>
		    @charset "utf-8";
		    /* #campaignObj.getCompanyName()# CSS Override v#campaignObj.getVersion()# */

		    html { 
		      <cfif isBinary( campaignObj.getBgImage() )>
		        background: url('#assetPaths.channel#/images/campaigns/#campaignObj.getSubdomain()#_background_v#campaignObj.getVersion()#.png') no-repeat center center fixed; 
		        -webkit-background-size: cover;
		        -moz-background-size: cover;
		        -o-background-size: cover;
		        background-size: cover;
		      </cfif>
		      	background-color: #campaignObj.getCssProps().bgClr.getValue()#;
		    }

		    /*******************/
		    /* Campaign Layout */
		    /*******************/

		    ##top-nav-bar {
		      	background-color: #campaignObj.getCssProps().topNavBarBg.getValue()#;
		      	color: #campaignObj.getCssProps().topNavBarText.getValue()#;
		    }

		    ##top-nav-bar a, ##top-nav-bar a:active, ##top-nav-bar a:hover, ##top-nav-bar a:focus{
		      	color: #campaignObj.getCssProps().topNavBarTextActive.getValue()#;
		    }

			##pagemaster-menu-nav li {
		      	color: #campaignObj.getCssProps().menuNavText.getValue()#;
		      	background-color: #campaignObj.getCssProps().menuNavBg.getValue()#;
			}

			##pagemaster-menu-nav li > a {
		      	color: #campaignObj.getCssProps().menuNavText.getValue()#;
			}

		    ##pagemaster-menu-nav li > a:hover, ##pagemaster-menu-nav li > a.pagemaster-menu-nav-active {
		      	color: #campaignObj.getCssProps().menuNavTextActive.getValue()#;
		      	background-color: #campaignObj.getCssProps().menuNavBgActive.getValue()#;
		    }

		    /************************/
		    /* Product listing grid */
		    /************************/

		    ##product-listing-grid li .product-title-container h1 {
		      	color: #campaignObj.getCssProps().gridHdrText.getValue()#; 
		    }

		    ##product-listing-grid li .product-title-container a:hover {
		      	color: #campaignObj.getCssProps().gridHoverText.getValue()#; 
		    }   

		    ##product-listing-grid .btn-select {
		      	background-color: #campaignObj.getCssProps().gridBtnBg.getValue()#;
		      	color: #campaignObj.getCssProps().gridBtnText.getValue()#;
		    }

		    ##product-listing-grid .btn-select:hover, ##product-listing-grid .btn-select:focus {
		      	background-color: #campaignObj.getCssProps().gridBtnBgActive.getValue()#;
		     	color: #campaignObj.getCssProps().gridBtnTextActive.getValue()#;
		    }

		    /**********/
		    /* Footer */
		    /**********/

		    ##footer-nav-bar {
		      	background-color: #campaignObj.getCssProps().footerNavBarBg.getValue()#;
		      	color: #campaignObj.getCssProps().footerNavBarText.getValue()#;
		    } 

		    ##foot-links a, ##foot-links a:link, ##foot-links a:visited, ##foot-links a:hover, ##foot-links a:active {
				color: #campaignObj.getCssProps().footerNavBarText.getValue()#;
			}

		    /************************/
		    /* General overrides    */
		    /************************/

		    ##dialog_addToCart_body .cartHeader {
		        background: url('#assetPaths.channel#/images/campaigns/#campaignObj.getSubdomain()#_cartlogo_v#campaignObj.getVersion()#.png') no-repeat scroll 15px 5px !important;
		    }

			##dialog_addToCart_body {
				background-color: #campaignObj.getCssProps().cartBg.getValue()#;	
			}
		    </cfoutput>
		  </cfsavecontent>
		  
		<!--- check if subdomain directory exists --->
		<cfif NOT DirectoryExists( ExpandPath( assetPaths.channel & '/styles/campaigns/' ) )>
			<!--- it doesn't exist, create it --->
			<cfdirectory action="create" directory="#ExpandPath( assetPaths.channel & '/styles/campaigns/')#" /> 
		</cfif>

		<!--- check if subdomain directory exists --->
		<cfif NOT DirectoryExists( ExpandPath( assetPaths.channel & '/images/campaigns/' ) )>
			<!--- it doesn't exist, create it --->
			<cfdirectory action="create" directory="#ExpandPath( assetPaths.channel & '/images/campaigns/' )#" /> 
		</cfif>

		<!--- save the css file --->
		<cffile action="write" file="#ExpandPath( assetPaths.channel & '/styles/campaigns/' )##ARGUMENTS.subdomain#_v#campaignObj.getVersion()#.css" output="#cssFile#" nameconflict="overwrite" />

		<!--- check if the logo data exists (is a binary object), and the logo and cartlogo files exist --->
		<cfif isBinary( campaignObj.getLogoImage() ) AND 
			  ( NOT fileExists("#ExpandPath( assetPaths.channel & '/images/campaigns/' )##campaignObj.getSubdomain()#_logo_v#campaignObj.getVersion()#.png")
			  	OR NOT fileExists("#ExpandPath( assetPaths.channel & '/images/campaigns/' )##campaignObj.getSubdomain()#_cartlogo_v#campaignObj.getVersion()#.png")
			  )
		>
			<!--- data exists, but one or more files do not, generate a new image from the binary data in the database --->
			<cfset logoImage = imageNew( campaignObj.getLogoImage() )>
			<!--- write the image to the local file system for later use by CSS, etc. --->
			<cfimage action="write" source="#logoImage#" destination="#ExpandPath( assetPaths.channel & '/images/campaigns/' )##campaignObj.getSubdomain()#_logo_v#campaignObj.getVersion()#.png" overwrite="true" />
			<!--- scale the logo to 35px high for the shopping cart header --->
			<cfset imageScaleToFit( logoImage, '', 35 ) />
			<!--- write the scaled image to the local file system for later use by CSS --->
			<cfimage action="write" source="#logoImage#" destination="#ExpandPath( assetPaths.channel & '/images/campaigns/' )##campaignObj.getSubdomain()#_cartlogo_v#campaignObj.getVersion()#.png" overwrite="true" />
		</cfif>		

		<!--- check if the background data exists (is a binary object) --->
		<cfif isBinary( campaignObj.getBgImage() ) AND NOT fileExists("#ExpandPath( assetPaths.channel & '/images/campaigns/' )##campaignObj.getSubdomain()#_background_v#campaignObj.getVersion()#.png")>
			<!--- data exists, but file does not, generate a new image from the binary data in the database --->
			<cfset bgImage = imageNew( campaignObj.getBgImage() )>
			<!--- write the image to the local file system for later use by CSS, etc. --->
			<cfimage action="write" source="#bgImage#" destination="#ExpandPath( assetPaths.channel & '/images/campaigns/' )##campaignObj.getSubdomain()#_background_v#campaignObj.getVersion()#.png" overwrite="true" />
		</cfif>

		<!--- check if the banner data exists (is a binary object) --->
		<cfif isBinary( campaignObj.getAdImage() ) AND NOT fileExists("#ExpandPath( assetPaths.channel & '/images/campaigns/' )##campaignObj.getSubdomain()#_banner_v#campaignObj.getVersion()#.png")>
			<!--- data exists, but file does not, generate a new image from the binary data in the database --->
			<cfset adImage = imageNew( campaignObj.getAdImage() )>
			<!--- write the image to the local file system for later use by CSS, etc. --->
			<cfimage action="write" source="#adImage#" destination="#ExpandPath( assetPaths.channel & '/images/campaigns/' )##campaignObj.getSubdomain()#_banner_v#campaignObj.getVersion()#.png" overwrite="true" />
		</cfif>

		<!--- check if the header data exists (is a binary object) --->
		<cfif isBinary( campaignObj.getHeaderImage() ) AND NOT fileExists("#ExpandPath( assetPaths.channel & '/images/campaigns/' )##campaignObj.getSubdomain()#_header_v#campaignObj.getVersion()#.png")>
			<!--- data exists, but file does not, generate a new image from the binary data in the database --->
			<cfset headerImage = imageNew( campaignObj.getHeaderImage() )>
			<!--- write the image to the local file system for later use by CSS, etc. --->
			<cfimage action="write" source="#headerImage#" destination="#ExpandPath( assetPaths.channel & '/images/campaigns/' )##campaignObj.getSubdomain()#_header_v#campaignObj.getVersion()#.png" overwrite="true" />
		</cfif>

	</cffunction>
	
	<cffunction name="doesCurrentCampaignSubdomainExist" access="public" output="false" returntype="boolean">
		<cfset var qCampaign = '' />
		<cfset var subdomain = getCurrentSubdomain() />
	
	    <!--- get the campaign by campaignId --->
	    <cfquery name="qCampaign" datasource="#variables.datasource#">
	    	SELECT CampaignId
	    	FROM campaign.Campaign
	    	WHERE subdomain = <cfqueryparam value="#subdomain#" cfsqltype="cf_sql_varchar" />
	    </cfquery>
	    
	    <cfif qCampaign.RecordCount>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	    
	</cffunction>

	<cffunction name="getCurrentSubdomain" access="public" output="false" returntype="string">
		<cfset var subdomain = ListFirst(CGI.HTTP_HOST,'.') />
	    <cfreturn subdomain />
	</cffunction>

</cfcomponent>