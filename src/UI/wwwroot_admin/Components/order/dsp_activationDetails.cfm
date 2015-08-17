<cfparam name="wirelessLineId" default="request.p.wirelessLineId" />

<cfif application.model.SecurityService.isFunctionalityAccessable( session.AdminUser.AdminUserId, '57796BE4-B2AC-4AD2-B87E-8E688CE47521' ) >
	<cfscript>
		wirelessLine = CreateObject( "component", "cfc.model.WirelessLine" ).init();
		wirelessLine.load( wirelessLineId );
	
		orderDetail = CreateObject( "component", "cfc.model.OrderDetail" ).init();
		orderDetail.load( wirelessLine.getOrderDetailId() );
	
		order = CreateObject( "component", "cfc.model.Order" ).init();
		order.load( orderDetail.getOrderId() );
		
		wirelessAccount = CreateObject( "component", "cfc.model.WirelessAccount" ).init();
		wirelessAccount.load( orderDetail.getOrderId() );
		
		user = CreateObject( "component", "cfc.model.User" ).init();
		user.getUserById( order.getUserId() );		
		
		args = {
			wirelessLine = wirelessLine
			, orderDetail = orderDetail
			, order = order
			, wirelessAccount = wirelessAccount
			, user = user
		};
	</cfscript>
	
	<cfoutput>#application.view.ActivationManager.getActivationDetailsView( argumentCollection = args )#</cfoutput>
<cfelse>
	<div class="accessDenied">
		<span class="form-error-inline">You do not have access to view this page</span>
	</div>
</cfif> 

