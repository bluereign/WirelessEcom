<cfif structkeyexists(url, "productguid")>
	<cfset serviceListHTML = application.view.AdminPhone.getPhoneServiceList(url.productguid)>
	<cfoutput>
		#serviceListHTML#
	</cfoutput>
	
	<p>&nbsp;</p><p>&nbsp;</p>
	<p>&nbsp;</p><p>&nbsp;</p>
</cfif>