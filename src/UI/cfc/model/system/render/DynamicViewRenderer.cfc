<cfcomponent output="false" hint="Looks up configured path for view based upon event (go.do).">
	
	<!--------------------- CONSTRUCTOR ------------------------>
	
	<cffunction name="init" access="public" output="false" returntype="DynamicViewRenderer">
		<cfargument name="viewPaths" type="struct" required="true">
		<cfset setViewPaths(arguments.viewPaths)>
		<cfreturn this>		
	</cffunction>
	
	<!------------------------ PUBLIC -------------------------->
		
	<cffunction name="render" access="public" output="true" returntype="void" hint="Renders view based upon supplied event.">
		<cfargument name="event" required="true" type="string" hint="Event expressed as go.do">
		<cfargument name="rc" required="false">
		<cfargument name="prc" required="false">
		
		<cfset var viewMap = getViewPaths()>
		<cfif hasView( arguments.event )>
			<cfinclude template="#viewMap[arguments.event]#">
		<cfelse>
			<cfthrow type="ViewRenderer.render.ViewNotFound" message="Unable to locate view for #arguments.event#">
		</cfif>
	</cffunction>
 		
	<cffunction name="getViewPath" access="public" output="false" returntype="string" hint="Returns string representing the path registered in ViewPaths bean. Useful for when the variables scope of the controller is required for the view.">
		<cfargument name="event" required="true" type="string" hint="Expressed as go.do">
		<cfset var viewMap = getViewPaths()>
		<cfif hasView( arguments.event )>
			<cfreturn viewMap[arguments.event]>
		<cfelse>
			<cfthrow type="ViewRenderer.getViewPath.ViewNotFound" message="Unable to locate path for #arguments.event#">
		</cfif>	
	</cffunction>

	<!----------------------- PRIVATE -------------------------->
			
	<cffunction name="hasView" access="private" output="false" returntype="boolean" hint="Checks for existence of event in view configuration.">
		<cfargument name="event" required="true" type="string" hint="Event expressed as go.do">
		<cfreturn structKeyExists( getViewPaths(), arguments.event)>
	</cffunction>
		
	<!------------------- GETTERS/SETTERS ---------------------->
		
	<cffunction name="getViewPaths" access="private" output="false" returntype="struct" hint="Accessor.">    
    	<cfreturn variables.instance['viewPaths']>    
    </cffunction>
    
    <cffunction name="setViewPaths" access="public" output="false" returntype="void" hint="Mutator.">    
    	<cfargument name="theVar" required="true">    
    	<cfset variables.instance['viewPaths'] = arguments.theVar>    
    </cffunction>

</cfcomponent>
