<cfparam name="request.p.do" default="error" />

<!--- MAC: make the SSL switch --->
<cfparam name="request.config.disableSSL" default="false">
<cfif cgi.server_port EQ 443 >
	<cflocation addtoken="false" url="http://#cgi.SERVER_NAME#/index.cfm/go/#request.p.go#/do/#request.p.do#" /> 
</cfif>

<cfswitch expression="#request.p.do#">

	<cfcase value="error">
		<cfinclude template="/views/error/dsp_error.cfm" />
	</cfcase>

	<cfcase value="404">
		<cfinclude template="/views/error/dsp_404.cfm" />
	</cfcase>

	<cfcase value="checkoutOffline">
		<cfinclude template="/views/error/dsp_checkoutOffline.cfm" />
	</cfcase>

	<cfdefaultcase>
		<cflocation addtoken="false" url="/index.cfm/go/#request.p.go#/do/error/" />
	</cfdefaultcase>

</cfswitch>