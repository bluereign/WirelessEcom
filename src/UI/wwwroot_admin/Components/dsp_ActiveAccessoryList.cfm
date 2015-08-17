<cfif IsDefined("form.action")>
	<cfif form.action eq "deleteAccessory">
		<cfset result = application.model.AdminAccessory.deleteAccessory(form.accessoryId) />	
        <cfset message = "Accessory removed." />
	</cfif>
</cfif>

<cfset filter = { active = true } />

<cfset accessoryListHTML = application.view.AdminAccessory.getAccessoryList(filter) />
<cfoutput>
	#accessoryListHTML#
</cfoutput>

<p>&nbsp;</p><p>&nbsp;</p>
<p>&nbsp;</p><p>&nbsp;</p>