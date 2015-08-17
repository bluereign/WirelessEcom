<cfparam name="orderId" default="request.p.orderId" />

<cfif application.model.SecurityService.isFunctionalityAccessable( session.AdminUser.AdminUserId, '74ACA2EB-EBFC-4128-8FF3-20C32F5CA41E' ) >
	<cfscript>
	
		order = CreateObject( "component", "cfc.model.Order" ).init();
		order.load( orderId );		
		
		qCreditStatus = application.model.CatsFileManager.getCreditStatus( order );
		qOrderStatus = application.model.CatsFileManager.getOrderStatus( order );
	</cfscript>
	
	<h3>CATS Credit Status</h3>
	
	<cfif qCreditStatus.RecordCount>
		<table class="table-long gridview-10">
			<tr>
				<th>Report Date</th>
				<th>CATS</th>
				<th>Risk</th>
				<th>Credit Status</th>
			</tr>
			<cfoutput query="qCreditStatus">
				<tr>
					<td>#DateFormat(ReportDate, 'm/d/yyyy')#</td>
					<td>#CATS#</td>
					<td>#RiskAssmtRsn#</td>
					<td>#CreditStatus#</td>
				</tr>
			</cfoutput>
		</table>
	<cfelse>
		There are no CATS Status responses for this order.
	</cfif>
	
	<h3>CATS Order Status</h3>

	<cfif qOrderStatus.RecordCount>
		<table class="table-long gridview-10">
			<tr>
				<th>Report Date</th>
				<th>CATS</th>
				<th>System Message</th>
				<th>Message Detail</th>
			</tr>
			<cfoutput query="qOrderStatus">
				<tr>
					<td>#DateFormat(ReportDate, 'm/d/yyyy')#</td>
					<td>#CATS#</td>
					<td>#OASSystemMessage#</td>
					<td>#MessageDetail#</td>
				</tr>
			</cfoutput>
		</table>
	<cfelse>
		There are no CATS Status responses for this order.
	</cfif>

<cfelse>
	<div class="accessDenied">
		<span class="form-error-inline">You do not have access to view this page</span>
	</div>
</cfif> 

