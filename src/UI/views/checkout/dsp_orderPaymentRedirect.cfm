<!---
**
* Used to redirect order to payment gateway. Mainly used for eq only exchanges or orders initiated through OMT.
**
--->

<cfif not application.model.checkoutHelper.isLoggedIn()>
	<cfset session.loginCallback = '/index.cfm/#cgi.path_info#' />

	<cflocation url="/index.cfm/go/myAccount/do/login/" addtoken="false" />
</cfif>

<cfset request.p.orderId = url.orderId />

<cfscript>
	request.p.order = createObject('component', 'cfc.model.Order').init();
	request.p.order.load(request.p.orderId);

	// Prepare the order for the payment gateway.
	application.model.checkoutHelper.setOrderId(request.p.order.getOrderId());
	application.model.checkoutHelper.setOrderTotal(request.p.order.getOrderTotal());
	session.checkout.billShipForm.billDayPhone = request.p.order.getBillAddress().getDaytimePhone();
	session.checkout.billingAddress = request.p.order.convertOrderAddressToAddress(request.p.order.getBillAddress());
	session.checkout.shippingAddress = request.p.order.convertOrderAddressToAddress(request.p.order.getShipAddress());
</cfscript>

<cfset request.p.user = createobject('component', 'cfc.model.User').init() />
<cfset request.p.user.getUserById(session.userId) />

<cfif request.p.order.getUserId() neq request.p.user.getUserId() and not request.p.user.isAdmin()>
	<cflocation url="/index.cfm/go/checkout/do/error/?code=51" addtoken="false" />
</cfif>

<cfset ForceMultipleGateways = true />
<cfinclude template="paymentGatewayInclude.cfm" />

<h1>Review Order</h1>

<cfset orderAsHtml = application.view.order.getOrderFullView(request.p.order) />

<div class="orderDetailArea">
	<cfoutput>#trim(variables.orderAsHtml)#</cfoutput>
</div>

<div class="formControl">
	<span class="actionButtonLow">
		<a href="##" onclick="#'">Cancel</a>
	</span>
	<span class="actionButton">
		<a href="##" onclick="proceedToPayment();">Proceed to Payment</a>
	</span>
</div>

<script language="javascript" type="text/javascript">
	function proceedToPayment()	{
		$("#paymentForm").get(0).submit();
	}
</script>
