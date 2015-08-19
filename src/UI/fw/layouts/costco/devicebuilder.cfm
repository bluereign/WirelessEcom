<!--- Temp for now --->
<cfset assetPaths = application.wirebox.getInstance("assetPaths") />

<cfsavecontent variable="request.bodycontent">
  <cfoutput>#renderView()#</cfoutput>
</cfsavecontent>

<cfinclude template="/layouts/costco/devicebuilder.cfm" />
