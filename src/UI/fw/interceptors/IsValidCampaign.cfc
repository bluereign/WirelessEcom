<cfcomponent displayname="IsValidCampaign" hint="I intercept invalid subdomains and redirect." extends="coldbox.system.interceptor" output="false" autowire="true">
	
	<cffunction name="preProcess" access="public" returntype="void" output="false">
		<cfargument name="event">

		<!--- check if we're already firing the invalid action --->
		<cfif NOT findNoCase( 'invalid', event.getCurrentAction() )>
			
			<!--- we're not, get the campaign service --->
			<cfset variables.CampaignService = createObject( 'component', 'cfc.model.campaign.CampaignService' ).init() />

			<!--- set the subdomain from the host header --->
			<cfset variables.subdomain = listFirst( CGI.HTTP_HOST, '.' ) />

			<!--- ensure the campaign exists --->
			<cfif variables.CampaignService.doesCurrentCampaignSubdomainExist()>
				
				<!--- we're a subdomain of pagemaster, get the campaign from this subdomain --->
				<cfset variables.campaign = variables.CampaignService.getCampaignBySubdomain( variables.subdomain ) />

				<!--- check if this campaign is active and within valid datetime --->
				<cfif ( isStruct( variables.campaign ) AND structIsEmpty( variables.campaign ) )
					OR NOT variables.campaign.getIsActive() 
					OR dateCompare( now(), variables.campaign.getStartDateTime() ) EQ -1 
					OR dateCompare( now(), variables.campaign.getEndDateTime() ) EQ 1
				>

					<!--- campaign not valid, redirect to invalid view --->
					<cfset setNextEvent( 'catalog.invalid' ) />
				
				<!--- end checking if this campaign is active and within valid datetime --->
				</cfif>

			<!--- otherwise --->
			<cfelse>

				<!--- campaign doesn't exist, redirect to invalid view --->
				<cfset setNextEvent( 'catalog.invalid' ) />

			<!--- end checking if we're a subdomain of pagemaster --->
			</cfif>

		<!--- end checking if we're already firing the invalid action --->
		</cfif>

	</cffunction>
	
</cfcomponent>