<cfparam name="orderId" default="request.p.orderId" />

<cfif application.model.SecurityService.isFunctionalityAccessable( session.AdminUser.AdminUserId, 'A807180A-8EA2-4576-8A72-C6A2A4334646' ) >
	<cfscript>
	
		order = CreateObject( "component", "cfc.model.Order" ).init();
		order.load( orderId );		
		
		args = {
			order = order
		};
	</cfscript>
	
	<cfoutput>#application.view.OrderManager.getRmaTabView( argumentCollection = args )#</cfoutput>
<cfelse>
	<div class="accessDenied">
		<span class="form-error-inline">You do not have access to view this page</span>
	</div>
</cfif> 

