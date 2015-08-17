﻿<cfcomponent output="false" singleton>	<!--- Default Action --->	<cffunction name="index" returntype="void" output="false" hint="My main event">		<cfargument name="event">		<cfargument name="rc">		<cfargument name="prc">		<cfset event.setView( view = "main/index", layout = "Login" )>	</cffunction>		<cffunction name="onSessionEnd" returntype="void" output="false">		<cfargument name="event">		<cfargument name="rc">		<cfargument name="prc">				<cfset var sessionScope = event.getValue("sessionReference")>		<cfset var applicationScope = event.getValue("applicationReference")>			</cffunction>	<cffunction name="onException" returntype="void" output="false">		<cfargument name="event">		<cfargument name="rc">		<cfargument name="prc">				<cfscript>			//Grab Exception From request collection, placed by ColdBox			var exceptionBean = event.getValue("ExceptionBean");			//Place exception handler below:		</cfscript>	</cffunction>		<cffunction name="onMissingTemplate" returntype="void" output="false">		<cfargument name="event">		<cfargument name="rc">		<cfargument name="prc">		<cfscript>			//Grab missingTemplate From request collection, placed by ColdBox			var missingTemplate = event.getValue("missingTemplate");					</cfscript>	</cffunction></cfcomponent>