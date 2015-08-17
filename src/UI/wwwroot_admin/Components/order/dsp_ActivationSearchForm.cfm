<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<cfsavecontent variable="js">
<cfoutput><link rel="stylesheet" type="text/css" href="#assetPaths.admin.common#styles/customerservice.css" /></cfoutput>
</cfsavecontent>

<cfhtmlhead text="#js#">

<cfset qActivations = application.model.Order.getPendingActivations() />
<cfset listView = application.view.OrderManager.getActivationListView( qActivations ) />
<cfoutput>#listView#</cfoutput>