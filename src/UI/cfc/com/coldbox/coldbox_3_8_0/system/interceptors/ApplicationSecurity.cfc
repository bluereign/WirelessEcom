<!-----------------------------------------------------------------------
Security Interceptor
----------------------------------------------------------------------->
<cfcomponent output="false" extends="coldbox.system.Interceptor">	
	<!---<cffunction name="onRequestCapture" access="public" returntype="void" output="false" eventPattern="^checkoutVFD">
		<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") >
		
		<cfif channelConfig.getVfdEnabled()>
			<cfif !isDefined("session.VFD")>
				<cfset setNextEvent('MainVFD.testVFD') />
			</cfif>
		</cfif>
	</cffunction>--->
	
	<cffunction name="onRequestCapture" access="public" returntype="void" output="false">
		<cfargument name="event" 		 required="true" hint="The event object.">
		<cfargument name="interceptData" required="true" hint="interceptData of intercepted info.">
		
		<cfset ignoredEvents = "mainVFD.testVFD,mainVFD.loginVFD,mainVFD.errorPageVFD" >
		<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") >
		<cfif channelConfig.getVfdEnabled()>
			<cfset currEvent = event.getCurrentEvent()>
			<cfif len(currEvent) AND ((listContainsNoCase(currEvent,"mainVFD.testVFD")) OR (listContainsNoCase(currEvent,"mainVFD.loginVFD")) OR (listContainsNoCase(currEvent,"mainVFD.errorPageVFD")))>
			<cfelse>
				<cfif !isDefined("session.VFD")>
					<cfset setNextEvent('MainVFD.errorPageVFD') />
				</cfif>
			</cfif>
		</cfif>
	</cffunction>
	
	
</cfcomponent>