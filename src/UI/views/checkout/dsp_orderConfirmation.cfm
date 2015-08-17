<cfoutput>
	<h1>Review Your Order</h1>

	<cfif application.model.checkoutHelper.isWirelessOrder()>
		<!---<div class="notify">
			<cfif application.model.checkoutHelper.getCheckoutType() is 'add'>
				Congratulations, you have been approved for the lines requested.
			<cfelseif application.model.checkoutHelper.getCheckoutType() is 'upgrade'>
				Congratulations, your upgrade has been approved.
			<cfelseif application.model.checkoutHelper.getCheckoutType() is 'new'>
				Congratulations, you have been approved for the number of wireless lines requested.
			</cfif>

			<strong>Please review your order and shipping selection below, then click continue.</strong>
		</div>--->
	<cfelse>
		<p><strong>Please review your order and shipping selection below, then click continue.</strong></p>
	</cfif>

	<form id="reviewOrder" action="/index.cfm/go/checkout/do/processOrderConfirmation/" method="post">
		<cfoutput>#trim(application.view.cart.view(false))#</cfoutput>
		<input type="hidden" name="s" value="Submit Order" />
	</form>

	<form id="cancelOrder" action="/index.cfm/go/checkout/do/processOrderCancel/" method="post">
		<input type="hidden" name="s" value="Cancel Order" />
	</form>

	<div class="formControl">
		<span class="actionButtonLow">
			<cfif application.model.checkoutHelper.getCheckoutType() is 'new'>
				<cfif application.model.checkoutHelper.getCarrier() eq 299>
					<a href="##" onclick="window.location.href = '/index.cfm/go/checkout/do/securityQuestion/'">Back</a>
				<cfelse>
					<a href="##" onclick="window.location.href = '/index.cfm/go/checkout/do/creditCheck/'">Back</a>
				</cfif>
			<cfelse>
				<a href="##" onclick="window.location.href = '/index.cfm/go/checkout/do/billShip/'">Back</a>
			</cfif>
		</span>
		<span class="actionButtonLow">
			<a href="##" onclick="var ok=confirm('Are you sure you want to exit the checkout process without completing your order?'); if(ok){ location.href='/index.cfm/go/cart/do/view'; }">Return to Shopping</a>
		</span>
		<span class="actionButton">
			<cfif application.model.checkoutHelper.isPrepaidOrder()>
				<a href="##" onclick="showProgress('Updating order, proceeding to prepaid customer information.'); $('##reviewOrder').submit()">Continue</a>
			<cfelseif application.model.checkoutHelper.isWirelessOrder()>
				<a href="##" onclick="showProgress('Updating order, proceeding to terms & conditions.'); $('##reviewOrder').submit()">Continue</a>
			<cfelse>
				<a href="##" onclick="showProgress('Updating order.'); $('##reviewOrder').submit()">Proceed to Payment</a>
			</cfif>
		</span>
	</div>
</cfoutput>