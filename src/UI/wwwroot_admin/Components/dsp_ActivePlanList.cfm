<cfset filter = { active = true } />
<cfset planListHTML = application.view.AdminPlan.getPlanList(filter)>
<cfoutput>
	#planListHTML#
</cfoutput>

<p>&nbsp;</p><p>&nbsp;</p>
<p>&nbsp;</p><p>&nbsp;</p>