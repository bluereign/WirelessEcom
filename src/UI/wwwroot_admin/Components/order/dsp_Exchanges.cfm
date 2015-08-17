<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<cfsavecontent variable="js">
<cfoutput><link rel="stylesheet" type="text/css" href="#assetPaths.admin.common#styles/customerservice.css" /></cfoutput>
</cfsavecontent>

<cfhtmlhead text="#js#">

<cfscript>
	searchArgs = {
		activationType = 'E'
	};

	qOrders = application.model.order.getOrdersBySearchCriteria(variables.searchArgs);
</cfscript>

<div class="customer-service">
	<h3>Search Results</h3>
	<cfif qOrders.RecordCount>
		<table id="orderList" class="table-long gridview-10">
			<thead>
				<tr>
					<th>Order ID</th>
					<th>Date</th>
					<th>Status</th>
					<th>Activation Status</th>
					<th>Type</th>
					<th>Account Name</th>
					<th>Order Name</th>
					<th>Carrier</th>
				</tr>
			</thead>
			<tbody>
				<cfoutput query="qOrders">
					<tr>
						<td><a href="?c=8edd9b84-6a06-4cd0-b88a-2a27765f88ff&orderId=#orderId#">#trim(orderId)#</a></td>
						<td>#dateFormat(orderDate, 'mm/dd/yyyy')#</td>
						<td>#trim(statusName)#</td>
						<td>#trim(activationStatusName)#</td>
						<td>#trim(application.model.order.getActivationTypeName(type = trim(activationType)))#</td>
						<td>#trim(accountFirstName)# #trim(accountLastName)#</td>
						<td>#trim(billingFirstName)# #trim(billingLastName)#</td>
						<td>#trim(companyName)#</td>
					</tr>
				</cfoutput>
			</tbody>
        </table>
	<cfelse>
		<p>There were no Exchange orders found with your search criteria.</p>
	</cfif>
</div>
<div class="clear"></div>