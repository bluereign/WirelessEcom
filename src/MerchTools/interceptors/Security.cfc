<cfcomponent displayname="Security" hint="I handle session management and rotation." extends="coldbox.system.interceptor" output="false" autowire="true">
	
	<cffunction name="preProcess" access="public" returntype="any" output="false">
		<cfargument name="event" type="coldbox.system.web.context.RequestContext" required="true">

		<cfset var userObj = '' />
		<cfset var sid = '' />
		<cfset var cSid = '' />
		<cfset variables.UserService = createObject('component','model.UserService').init() />

		<!--- expire old sessions (30 minutes) --->
		<cfset variables.UserService.expireOldSessions( 30 ) />


<!---
		<!--- make sure we're not logging in already --->
		<cfif NOT ReFindNoCase('(main\.index|login|genuser)', event.getCurrentEvent())>
			
			<!--- check for the existence of a session cookie --->
			<cfif NOT IsDefined('COOKIE.mtsessionid') OR NOT Len(COOKIE.mtsessionid)>
				<!--- no cookie present, display the login form --->
				<cfset setNextEvent( 'main ') />
			<!--- otherwise --->
			<cfelse>
				<!--- cookie present, verify session hasn't expired --->
				<cfif NOT variables.UserService.isValidSession(COOKIE.mtsessionid)>
					<!--- session has expired, display the login form --->
					<cfset setNextEvent( 'main ') />
				<!--- otherwise --->
				<cfelse>
					
					<!--- get the user object for this user --->
					<cfset userObj = variables.UserService.getUserById(variables.UserService.getUserIdFromSession(COOKIE.mtsessionid)) />
					<!--- do session rotation, expire the existing session --->
					<cfset variables.UserService.expireSession(COOKIE.mtsessionid) />
					<!--- expire the cookie --->
					<cfcookie name="#variables.cookieName#" value="" expires="now" />
					
					<!--- generate a session id --->
					<cfset sid = variables.utils.generateSessionId() />
					<!--- generate an encrypted version of the session id to store in the cookie --->
					<cfset cSid = variables.utils.dataEnc(sid, 'cookie') />
					<!--- send the new session cookie --->
					<cfcookie name="#variables.cookieName#" value="#cSid#" expires="never" />
					<!--- add the new session to the database --->
					<cfset variables.UserService.addSession(sessionId = sid, user = userObj) />
				
				<!--- end verifying session hasn't expired --->
				</cfif>

			<!--- end checking for the existence of a session cookie --->
			</cfif>		

		</cfif>		--->

	</cffunction>
	
</cfcomponent>