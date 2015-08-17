<cfcomponent>

	<cffunction name="init" output="false" access="public" returntype="cfc.controller.ContentController">
		<cfreturn this />
	</cffunction>	
	
	<cffunction name="DisplayVideo" output="false" access="public" returntype="any">
		<cfargument name="rc" type="struct" required="true" /> 		
		
		<cfscript>
			var results = '';
			var video = CreateObject('component', 'cfc.model.Video').init();
			
			if ( IsNumeric( rc.VideoId ) )
			{
				request.layoutFile = 'noLayout';
				request.Title = 'Video - ' & video.getTitle();
				request.MetaDescription = 'Video, Costco';
				request.MetaKeywords = 'Video, Costco';				
				video.load( rc.VideoId );
			}
			else
			{
				results = '<h1>Requested video unavailable</h1>';
			}
		</cfscript>
		
		<cfif results eq ''>
			<cfsavecontent variable="results" >
				<cfinclude template="/views/content/costco/dsp_multimedia.cfm" />
			</cfsavecontent>
		</cfif>
		
		<cfreturn results />
	</cffunction>

	<cffunction name="TMobilePlans" output="false" access="public" returntype="string">
		<cfargument name="rc" type="struct" required="true" />
		
		<cfset results = '' />
		
		<cfsavecontent variable="results">
			<cfinclude template="/views/content/common/dsp_tmobilePlans.cfm" />
		</cfsavecontent>
		
		<cfreturn results />
	</cffunction>

	<cffunction name="TMobileSimpleChoicePlans" output="false" access="public" returntype="string">
		<cfargument name="rc" type="struct" required="true" />
		
		<cfset results = '' />
		
		<cfsavecontent variable="results">
			<cfinclude template="/views/content/common/dsp_tmobileSimpleChoicePlan.cfm" />
		</cfsavecontent>
		
		<cfreturn results />
	</cffunction>

	<cffunction name="TMobileJump" output="false" access="public" returntype="string">
		<cfargument name="rc" type="struct" required="true" />
		
		<cfset results = '' />
		
		<cfsavecontent variable="results">
			<cfinclude template="/views/content/common/dsp_tmobileJump.cfm" />
		</cfsavecontent>
		
		<cfreturn results />
	</cffunction>

</cfcomponent>