<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<cfsavecontent variable="js">
<cfoutput><link rel="stylesheet" type="text/css" href="#assetPaths.admin.common#styles/customerservice.css" /></cfoutput>
</cfsavecontent>

<cfhtmlhead text="#js#" />

<cfscript>
	qCreditChecks = application.model.Order.getPendingCreditChecks();
</cfscript>

<div class="customer-service">
	<h3>Pending Credit Checks</h3>
	<cfif qCreditChecks.RecordCount>
		<table id="orderList" class="table-long gridview-10" >
            <thead>
				<tr>
					<th>Order ID</th>
					<th>Date</th>
					<th>Status</th>
					<th>Status Code</th>
					<th>Application #</th>
				</tr>
            </thead>
            <tbody>
				<cfoutput query="qCreditChecks">
					<tr>
						<td><a href="?c=8edd9b84-6a06-4cd0-b88a-2a27765f88ff&orderId=#OrderId#" target="_blank">#OrderId#</a></td>
						<td>#DateFormat( OrderDate, "mm/dd/yyyy" )#</td>
						<td>#StatusName#</td>
						<td>#CreditCheckStatusCode#</td>
						<td>#CreditApplicationNumber#</td>
					</tr>
				</cfoutput>
            </tbody>
        </table>
	<cfelse>
		<p>There were no pending Activations found with your search criteria.</p>
	</cfif>
</div>
<div class="clear"></div>