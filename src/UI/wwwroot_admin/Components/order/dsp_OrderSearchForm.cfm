<cfparam name="request.p.orderId" default="" type="string" />
<cfparam name="request.p.username" default="" type="string" />
<cfparam name="request.p.firstName" default="" type="string" />
<cfparam name="request.p.lastName" default="" type="string" />
<cfparam name="request.p.email" default="" type="string" />
<cfparam name="request.p.mdn" default="" type="string" />
<cfparam name="request.p.orderStatus" default="" type="string" />
<cfparam name="request.p.activationStatus" default="" type="string" />
<cfparam name="request.p.carrierId" default="0" type="numeric" />
<cfparam name="request.p.activationType" default="" type="string" />

<cfset assetPaths = application.wirebox.getInstance("assetPaths") />

<cfsavecontent variable="js">
<cfoutput>
	<link rel="stylesheet" type="text/css" href="#assetPaths.admin.common#styles/customerservice.css" />
	<script type="text/javascript" src="#assetPaths.admin.common#scripts/libs/jquery.metadata.js"></script>
	<script type="text/javascript" src="#assetPaths.admin.common#scripts/libs/jquery.validate.min.js"></script>
</cfoutput>

	<script>
		$(document).ready(function()	{
			$('#submit').click(function()	{
				$("#searchForm").validate();

				if($("#searchForm").valid())	{
					$('#searchForm').submit();
				}
			});
			$.validator.setDefaults({
				meta: "validate",
				errorElement: "em"
			});
		});
	</script>
</cfsavecontent>
<cfhtmlhead text="#trim(variables.js)#" />

<cfset searchForm = application.view.orderManager.getOrderSearchFormView() />
<cfoutput>#searchForm#</cfoutput>

<cfif structKeyExists(form, 'submitForm')>
	<cfscript>
		searchArgs = {
			orderId = request.p.orderId,
			firstName = trim(request.p.firstName),
			lastName = trim(request.p.lastName),
			email = trim(request.p.email),
			mdn = trim(request.p.mdn),
			orderStatus = trim(request.p.orderStatus),
			activationStatus = trim(request.p.activationStatus),
			carrierId = request.p.carrierId,
			activationType = request.p.activationType
		};

		qOrders = application.model.order.getOrdersBySearchCriteria(variables.searchArgs);
	</cfscript>

	<cfif len(request.p.orderId) and variables.qOrders.recordCount eq 1>
		<cflocation url="?c=8edd9b84-6a06-4cd0-b88a-2a27765f88ff&orderId=#variables.qOrders.OrderId#" addtoken="false" />
	</cfif>

	<cfset listView = application.view.orderManager.getOrderListView(variables.qOrders) />
	<cfoutput>#trim(variables.listView)#</cfoutput>
</cfif>