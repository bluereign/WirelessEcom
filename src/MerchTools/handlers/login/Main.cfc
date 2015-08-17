<cfcomponent name="main" extends="coldbox.system.eventhandler" cache="true" cachetimeout="40" autowire="true">
	
	<!---  init --->
	<cffunction name="init" access="public" returntype="any" output="false">
	    <cfargument name="controller" type="any">
	    <cfset variables.UserService = CreateObject('component','model.UserService').init() />
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
            <!---<cfset var rc = '' />--->
            <cfset var passHash = '' />
            <cfset var userObj = '' />
            <cfset var fields = '' />
            <cfset var reqCheck = '' />
            <cfset var sid = 0 />
            <cfset var cSid = 0 />
            <cfset var iX = 0 />

            <cfset event.paramValue( 'email', '' ) />
            <cfset event.paramValue( 'password', '') />
            <cfset event.paramValue( 'ff' & LCase(Hash('seedId','SHA-256')), '') />
            <cfset rc = event.getCollection() />
            
			<!--- process required fields --->
			<cfset fields = 
				[
					{ field = 'Email', value = rc.username, type = 'simple' },
					{ field  = 'Password', value = rc.password, type = 'simple' }
				] 
			/>
			<cfset reqCheck = variables.utils.checkFields( fields ) />	
			<!--- check if the required fields were not provided --->
			<cfif NOT reqCheck.result>
				<!--- some fields not provided, set an error message to display --->
				<cfset rc.msg = '<p>We&apos;re sorry, but the following fields are required but were not provided:</p><ul>' />
				<!--- loop through the missing fields --->
				<cfloop from="1" to="#ListLen(reqCheck.fields)#" index="iX">
					<!--- add this field as a list item --->
					<cfset rc.msg = rc.msg & '<li>#ListGetAt(reqCheck.fields,iX)#</li>' />
				</cfloop>
				<cfset rc.msg = rc.msg & '</ul>' />
			</cfif>

			<!--- required fields provided, check if this user exists in the database --->
			<cfif NOT variables.UserService.checkIfUserExists( rc.username )>
				<!--- user doesn't exist, set error msg --->
				<cfset rc.msg = '<p>We&apos;re sorry but we could not validate your login based on the user information you provided. Please try again.</p>' />
			</cfif>

			<!--- user exists, get user information from database --->
			<cfset userObj = variables.UserService.getUserByUsername( rc.username ) />

			<!--- hash the passed in password 1k times for comparison --->
			<cfloop from="1" to="1000" index="iX">
				<cfset rc.password = LCase( Hash( rc.password, 'SHA-384' ) ) />
			</cfloop>

			<!--- check if the stored password matches the password submitted --->
			<cfif NOT FindNoCase( userObj.getPassword(), rc.password )>			
				<!--- password mismatch, set an error message to be displayed --->
				<cfset rc.msg = '<p>We&apos;re sorry but we could not validate your login based on the information you provided. Please try again.</p>' />
			</cfif>

			<!--- check if an error message is set --->
			<cfif NOT IsDefined('rc.msg')>

				<!--- password matches, generate a session id --->
				<cfset sid = variables.utils.generateSessionId() />
				<!--- generate an encrypted version of the session id to store in the cookie --->
				<cfset cSid = variables.utils.dataEnc(sid, 'cookie') />
				<!--- send the session cookie --->
				<cfcookie name="mtsessionid" value="#cSid#" expires="never" />
				<!--- add the session to the database --->
				<cfset variables.UserService.addSession(sessionId = sid, user = userObj) />

				<!--- render the campaign list view --->
	            <cfset setNextEvent('campaigns.main') />

	        <cfelse>
	        	
				<!--- render the login view and display errors --->
				<cfset event.setView( view = 'main/index', layout = 'Login') />

			</cfif>
	</cffunction>


</cfcomponent>
