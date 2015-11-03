<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<cfsavecontent variable="js">
<cfoutput><link rel="stylesheet" type="text/css" href="#assetPaths.admin.common#styles/customerservice.css" /></cfoutput>
</cfsavecontent>

<cfhtmlhead text="#js#">

<cfset qCaptures = application.model.Order.getPendingCaptures() />

<div class="customer-service">
	<h3>Search Results</h3>
	<cfif qCaptures.RecordCount>
		<table id="orderList" class="table-long gridview-10">
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Date</th>
                    <th>Order Type</th>
					<th>Carrier</th>
					<th>Ship Method</th>
					<th>Items without<br />Real Stock</th>
					<th>Order<br />Assisted?</th>
					<th>Type</th>
                </tr>
            </thead>
            <tbody>
            	<cfoutput query="qCaptures">
                    <tr>
                        <td><a href="?c=8edd9b84-6a06-4cd0-b88a-2a27765f88ff&orderId=#OrderId#" target="_blank">#OrderId#</a></td>
                        <td>#DateFormat( OrderDate, "mm/dd/yyyy" )#</td>
                        <td>#ActivationType#</td>
						<td>#CompanyName#</td>
						<td>#ShippingMethod#</td>
						<td>#PhantomInventoryCount#</td>
						<td>#YesNoFormat( OrderAssistanceUsed )#</td>
						<td>#trim(application.model.order.getActivationTypeName(type = trim(activationType[qCaptures.currentRow])))#</td>
                    </tr>
				</cfoutput>
            </tbody>
        </table>
	<cfelse>
		<p>There were no pending Captures found with your search criteria.</p>
	</cfif>
</div>
<div class="clear"></div>