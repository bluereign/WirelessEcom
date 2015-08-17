<!--- Temp for now --->
<cfset assetPaths = application.wirebox.getInstance("assetPaths") />

<cfsavecontent variable="request.bodycontent">
	<!--- import necessary AJAX/JS libraries for cfwindow and cfform --->
	<cfajaximport tags="cfform,cfwindow,cfdiv" scriptsrc="#assetPaths.common#scripts/cfajax/">
	<cfoutput>#renderView()#</cfoutput>
</cfsavecontent>

<cfinclude template="/layouts/aafes/main.cfm" />