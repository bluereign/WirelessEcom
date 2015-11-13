<cfparam name="orderId" default="request.p.orderId" />

<cfif application.model.SecurityService.isFunctionalityAccessable( session.AdminUser.AdminUserId, '74ACA2EB-EBFC-4128-8FF3-20C32F5CA41E' ) >
	<cfscript>
	
		order = CreateObject( "component", "cfc.model.Order" ).init();
		order.load( orderId );		
		
		args = {
			order = order
		};
	</cfscript>
	
	<cfoutput>#application.view.OrderManager.getDebugTabView( argumentCollection = args )#</cfoutput>
<cfelse>
	<div class="accessDenied">
		<span class="form-error-inline">You do not have access to view this page</span>
	</div>
</cfif> 

