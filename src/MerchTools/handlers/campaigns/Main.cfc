<cfcomponent name="main" extends="coldbox.system.eventhandler" cache="true" cachetimeout="40" autowire="true">
	
	<!---  init --->
	<cffunction name="init" access="public" returntype="any" output="false">
	    <cfargument name="controller" type="any">
	    <cfset variables.CampaignService = CreateObject('component','model.CampaignService').init() />
	    <cfset variables.CssPropsService = CreateObject('component','model.CssPropsService').init() />
	    <cfset variables.utils = CreateObject('component','model.utils').init() />
		<cfset super.init(arguments.controller)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="preHandler" access="public" returntype="void" output="false">
	  <cfargument name="event" type="any">
	</cffunction>
	
	<cffunction name="postHandler" access="public" returntype="void" output="false">
	  <cfargument name="event" type="any">
	</cffunction>
		
	<cffunction name="index" access="public" returntype="void" output="false">
        <cfargument name="event" type="any">
            <cfset var rc = '' />
            <cfset event.paramValue( 'filter', 'current' ) />
            <cfset rc = event.getCollection() />
            <!--- check if the data is filtered by current campaigns --->
            <cfif rc.filter EQ 'current'>
            	<!--- it is, get only the data for current campaigns --->
            	<cfset rc.data = variables.CampaignService.filter( endStartDateTime = Now(), beginEndDateTime = Now() ) />
            <cfelse>
            	<!--- it isn't filtered, get all campaigns --->
            	<cfset rc.data = variables.CampaignService.getAllCampaigns() />
            </cfif>
			<cfset event.setView('campaigns/list') />
	</cffunction>

	<cffunction name="changeActive" access="public" returntype="void" output="false">
		<cfargument name="event" type="any">
			<cfset var rc = '' />
			<cfset event.paramValue( 'id', 0 ) />
			<cfset rc = event.getCollection() />
			<!--- check if the 'id' isn't zero (false) --->
			<cfif rc.id>
				<!--- get the bean for this campaign --->
				<cfset campaignObj = variables.CampaignService.getCampaignById( rc.id ) />
				<!--- check if the campaign is active or inactive --->
				<cfif campaignObj.getIsActive()>
					<!--- it is active, set it inactive --->
					<cfset campaignObj.setIsActive( false ) />
				<cfelse>
					<!--- it is inactive, set it active --->
					<cfset campaignObj.setIsActive( true ) />
				</cfif>
				<!--- save the campaign object --->
				<cfset variables.CampaignService.saveCampaign( campaignObj ) />
				<!--- set the data to be returned --->
				<cfset retData = { active = campaignObj.getIsActive() } />
	            <!--- render isActive status as JSON --->
				<cfset event.renderData( type = 'json', data = retData ) />
			</cfif>
	</cffunction>

	<cffunction name="edit" access="public" returntype="void" output="false">
		<cfargument name="event" type="any">
			<cfset var rc = '' />
			<cfset event.paramValue( 'id', 0 ) />
			<cfset rc = event.getCollection() />
			<cfset rc.mode = 'Add' />
			<cfif rc.id>
				<cfset rc.mode = 'Update' />
			</cfif>
			<!--- get the campaign bean for this campaign (or blank bean if 0) --->
			<cfset rc.campaignObj = variables.CampaignService.getCampaignById(rc.id) />
			<!--- render the edit view --->
			<cfset event.setView('campaigns/edit') />
	</cffunction>
	
	<cffunction name="save" access="public" returntype="void" output="false">
        <cfargument name="event" type="any">
            <cfset var rc = event.getCollection() />
            <cfset var iX = 0 />
            <cfset var logoUpload = '' />
            <cfset var bgUpload = '' />
            <cfset var adUpload = '' />
            <cfset var headerUpload = '' />
            <cfset var imagePath = ExpandPath('assets/img/logos/') />
            <cfset var reqCheck = '' />
            <cfset var logoField = { field = 'Logo Image', value = rc.logo, type='simple' } />
            <cfset var headerField = { field = 'Header Image', value = rc.headerImage, type='simple' } />
			<!--- process required fields --->
			<cfset var fields = 
				[
					{ field = 'Company Name', value = rc.companyName, type = 'simple' },
					{ field = 'Subdomain', value = rc.subdomain, type = 'simple' },
					{ field = 'Start Datetime', value = rc.startDateTime, type = 'date' },
					{ field = 'End Datetime', value = rc.endDateTime, type = 'date' },
					{ field = 'SMS Message', value = rc.smsMessage, type = 'simple' },
					{ field = 'Disclaimer', value = rc.disclaimer, type = 'simple' },
					{ field = 'Top Navigation Bar Background', value = rc.topNavBarBg, type='simple' },
					{ field = 'Top Navigation Bar Text', value = rc.topNavBarText, type='simple' },
					{ field = 'Top Navigation Bar Text (Active)', value = rc.topNavBarTextActive, type='simple' },
					{ field = 'Navigation Text', value = rc.menuNavText, type='simple' },
					{ field = 'Navigation Background', value = rc.menuNavBg, type='simple' },
					{ field = 'Grid Header Text', value = rc.gridHdrText, type='simple' },
					{ field = 'Grid Header Text (Active)', value = rc.gridHoverText, type='simple' },
					{ field = 'Grid Button Background', value = rc.gridBtnBg, type='simple' },
					{ field = 'Grid Button Text', value = rc.gridBtnText, type='simple' },
					{ field = 'Grid Button Background (Active)', value = rc.gridBtnBgActive, type='simple' },
					{ field = 'Grid Button Text (Active)', value = rc.gridBtnTextActive, type='simple' },
					{ field = 'Background Color', value = rc.bgClr, type='simple' },
					{ field = 'Footer Navigation Bar Background', value = rc.footerNavBarBg, type='simple' },
					{ field = 'Footer Navigation Bar Text', value = rc.footerNavBarText, type='simple' },
					{ field = 'Cart Background', value = rc.cartBg, type='simple' },
					{ field = 'Cartr Text', value = rc.cartText, type='simple' },
					{ field = 'Cart Text (Active)', value = rc.cartTextActive, type='simple' }

				] 
			/>
			<!-- parametize the 'filter' value (done here due to var scoping) --->
            <cfset event.paramValue( 'filter', 'current' ) />		
			<!--- get the campaign bean for this campaign (or blank bean if 0) --->
			<cfset rc.campaignObj = variables.CampaignService.getCampaignById( rc.campaignId ) />
			<!--- check if the campaign already has a logo image --->
			<cfif NOT isBinary( rc.campaignObj.getLogoImage() )>
				<!--- it doesn't, so ensure server-side validation for requierd logo --->
				<cfset arrayAppend( fields, logoField ) />
			</cfif>
			<!--- check if the campaign already has a header image --->
			<cfif NOT isBinary( rc.campaignObj.getLogoImage() )>
				<!--- it doesn't, so ensure server-side validation for requierd header --->
				<cfset arrayAppend( fields, headerField ) />
			</cfif>
			<!--- check the fields --->
			<cfset reqCheck = variables.utils.checkFields( fields ) />	
			<!--- check if the required fields were not valid --->
			<cfif NOT reqCheck.result>
				<!--- some fields not valid, set an error message to display --->
				<cfset rc.msg = '<p>We&apos;re sorry, but the following fields contain errors:</p><ul>' />
				<!--- loop through the missing fields --->
				<cfloop from="1" to="#ListLen(reqCheck.fields)#" index="iX">
					<!--- add this field as a list item --->
					<cfset rc.msg = rc.msg & '<li>#ListGetAt( reqCheck.fields, iX )#</li>' />
				</cfloop>
				<cfset rc.msg = rc.msg & '</ul>' />
				<!--- render the edit view and display errors --->
				<cfset event.setView('campaigns/edit') />
			<cfelse>
				<!--- all required fields provided, parse the subdomain for invalid characters --->
				<cfset rc.subdomain = LCase( reReplace( rc.subdomain, '[^a-zA-Z0-9\-]', '', 'all' ) ) />
				<!--- search for this subdomain in the database --->
				<cfset qCheckName = variables.CampaignService.filter( subdomain = rc.subdomain ) />
				<!--- check for the existence of this company name --->
				<cfif qCheckName.RecordCount AND findNoCase( 'add', rc.mode )>
					<!--- campaign already exists, set a message for the existence of the subdomain --->
					<cfset rc.msg = "<p>We&apos;re sorry, but the subdomain #rc.subdomain# already exists. Please choose a different subdomain.</p>" />
					<!--- render the edit view and display errors --->
					<cfset event.setView('campaigns/edit') />
				<cfelse>
					<cftry>
						<!--- check if subdomain directory exists --->
						<cfif NOT DirectoryExists("#imagePath##rc.subdomain#/")>
							<!--- it doesn't exist, create it --->
							<cfdirectory action="create" directory="#imagePath##rc.subdomain#/" /> 
						</cfif>

						<!--- check for the existence of the logo file field --->
						<cfif len( rc.logo )>
							<!--- get the logo upload --->
							<cffile action="upload" destination="#imagePath##rc.subdomain#/" filefield="logo" nameconflict="overwrite" accept="image/jpg, image/jpeg, image/png, image/gif" result="logoUpload" />	
							<!--- set the serverfile into the rc scope --->
							<cfset rc.logoFile = logoUpload.serverFile />
						<cfelse>
							<!--- same logo, just set null --->
							<cfset rc.logoFile = '' />						
						</cfif>		

						<!--- check for the existence of the background file field --->
						<cfif len( rc.bgImage )>
							<!--- get the background upload --->
							<cffile action="upload" destination="#imagePath##rc.subdomain#/" filefield="bgImage" nameconflict="overwrite" accept="image/jpg, image/jpeg, image/png, image/gif" result="bgUpload" />	
							<!--- set the serverfile into the rc scope --->
							<cfset rc.bgFile = bgUpload.serverFile />
						<cfelse>
							<!--- same (or no) background, just set null --->
							<cfset rc.bgFile = '' />						
						</cfif>

						<!--- check for the existence of the ad banner file field --->
						<cfif len( rc.adImage )>
							<!--- get the ad banner upload --->
							<cffile action="upload" destination="#imagePath##rc.subdomain#/" filefield="adImage" nameconflict="overwrite" accept="image/jpg, image/jpeg, image/png, image/gif" result="adUpload" />	
							<!--- set the serverfile into the rc scope --->
							<cfset rc.adFile = adUpload.serverFile />
						<cfelse>
							<!--- same (or no) ad banner, just set null --->
							<cfset rc.adFile = '' />						
						</cfif>	

						<!--- check for the existence of the header logo file field --->
						<cfif len( rc.headerImage )>
							<!--- get the header upload --->
							<cffile action="upload" destination="#imagePath##rc.subdomain#/" filefield="headerImage" nameconflict="overwrite" accept="image/jpg, image/jpeg, image/png, image/gif" result="headerUpload" />	
							<!--- set the serverfile into the rc scope --->
							<cfset rc.headerFile = headerUpload.serverFile />
						<cfelse>
							<!--- same (or no) ad banner, just set null --->
							<cfset rc.headerFile = '' />						
						</cfif>	

					<!--- catch any errors --->
					<cfcatch type="any">
						<!--- REFACTOR --->
						<cfdump var="#cfcatch#"><cfabort>
					</cfcatch>
					</cftry>	
		            <!--- process the form --->
		            <cfset variables.CampaignService.processForm( rc ) />
		            <!--- redirect to the list view --->
		            <cfset setNextEvent("campaigns/main")>
		        </cfif>
			</cfif>

	</cffunction>


</cfcomponent>
