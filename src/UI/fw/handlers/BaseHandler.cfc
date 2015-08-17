<cfcomponent output="false">
	
	<cffunction name="preHandler" access="public" returntype="void" output="false">
		<cfargument name="event" required="true" type="coldbox.system.web.context.RequestContext" />
		<cfargument name="action" required="true" type="string" />
		<cfargument name="eventArguments" required="true" type="struct" />
			
		<cfscript>
			var defaultMeta = {
				language = 'en',
				description = '',
				keywords = '',
				title = ''
			};
			event.setValue('HTMLmeta',defaultMeta,true);
		</cfscript>
		
	</cffunction>

	<cffunction name="dump">    
		<cfargument name="theVar">    
		<cfargument name="abort" default="False">    
		<cfdump var="#theVar#"><cfif abort><cfabort></cfif>    
	</cffunction>
	
</cfcomponent>