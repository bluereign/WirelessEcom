<cfcomponent output="false">
	
	<cffunction name="dump">    
		<cfargument name="theVar">    
		<cfargument name="abort" default="False">    
		<cfdump var="#theVar#"><cfif abort><cfabort></cfif>    
	</cffunction>
	
	<cffunction name="savecontent" access="public" output="false" returntype="any" hint="CFScript facade for cfsavecontent">    
    	<cfargument name="content" type="any" required="true" />
		<cfargument name="dump" type="boolean" required="false" default="true" />
		<cfset var rtn = "">
		<cfsavecontent variable="rtn">
			<cfif arguments.dump>
				<cfdump var="#arguments.content#">
			<cfelse>
				<cfoutput>#arguments.content#</cfoutput>
			</cfif>
		</cfsavecontent>
		<cfreturn rtn>
	</cffunction>

	<cffunction name="throw" access="public" hint="Facade for cfthrow" output="false">
		<cfargument name="message" 	type="string" 	required="yes">
		<cfargument name="detail" 	type="string" 	required="no" default="">
		<cfargument name="type"  	type="string" 	required="no" default="Framework">
		<cfthrow type="#arguments.type#" message="#arguments.message#"  detail="#arguments.detail#">
	</cffunction>

	<cffunction name="rethrow" access="public" returntype="void" hint="Rethrow facade" output="false" >
		<cfargument name="throwObject" required="true" type="any" hint="The cfcatch object">
		<cfthrow object="#arguments.throwObject#">
	</cffunction>

</cfcomponent>