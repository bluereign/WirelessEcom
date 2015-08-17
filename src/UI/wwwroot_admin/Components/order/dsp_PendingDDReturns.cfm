<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<cfsavecontent variable="js">
<cfoutput><link rel="stylesheet" type="text/css" href="#assetPaths.admin.common#styles/customerservice.css" /></cfoutput>
</cfsavecontent>

<cfhtmlhead text="#js#">

<cfset qDDReturns = application.model.Order.getPendingDDReturns() />

	<cfif variables.qDDReturns.recordCount eq 1>
		<cflocation url="?c=8edd9b84-6a06-4cd0-b88a-2a27765f88ff&orderId=#variables.qDDReturns.OrderId#" addtoken="false" />
	</cfif>

	<cfset listView = application.view.orderManager.getOrderListView(variables.qDDReturns) />
	<cfoutput>#trim(variables.listView)#</cfoutput>
	
<div class="clear"></div>