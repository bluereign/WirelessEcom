<cfset filter = { active = true } />
<cfset phoneListHTML = application.view.AdminPhone.getPhoneList(filter)>
<cfoutput>
	#phoneListHTML#
</cfoutput>

<p>&nbsp;</p><p>&nbsp;</p>
<p>&nbsp;</p><p>&nbsp;</p>