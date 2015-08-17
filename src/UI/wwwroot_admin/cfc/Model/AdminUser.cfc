<cfcomponent output="false" displayname="AdminUser">

	<cffunction name="init" returntype="AdminUser">
        
        <cfset variables.instance = structNew()>
        
        <cfreturn this>
    </cffunction>

	<cffunction name="initUser" returntype="void">    	
    	<cfif not isDefined("session.adminUser")>
        	<cfset variables.instance.adminUser = structNew()>
			
			<!--- interface --->
			<cfset variables.instance.adminUser.interface = structNew()>
            <cfset variables.instance.adminUser.interface.propertyGroupPropertyType = "">
            
            <cfset session.adminUser = variables.instance.adminUser>
        </cfif>
		
		
    </cffunction>

	<cffunction name="getInterface" returntype="struct">
    	<!--- returns the interface of the current signed in user --->
    	<cfset initUser()>
		<cfset variables.instance.interface = session.adminUser.interface>
        <cfreturn variables.instance.interface>
    </cffunction>
    
    <cffunction name="setInterfaceKey" returntype="void">
    	<cfargument name="keyVariable" type="string">
        <cfargument name="keyValue" type="any">
		
		<!--- sets the interface value --->
    	<cfset initUser()>
		<cfset dd = Evaluate("variables.instance.interface." & arguments.keyVariable & "=" & "arguments.keyValue")>
        <cfset session.adminUser.interface = variables.instance.interface>
    </cffunction>

</cfcomponent>