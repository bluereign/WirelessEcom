<cfparam name="cartHTML" type="string" default="" />

<cfoutput>
	<cfif Len(Trim(application.model.CheckoutHelper.getCheckoutMessageBox()))>
		
		<!---
		<div class="checkout-msg-box checkout-msg-box-informational">
			#application.model.CheckoutHelper.getCheckoutMessageBox()#
		</div>
		
		<div class="checkout-msg-box checkout-msg-box-success">
			#application.model.CheckoutHelper.getCheckoutMessageBox()#
		</div>

		<div class="checkout-msg-box checkout-msg-box-warning">
			#application.model.CheckoutHelper.getCheckoutMessageBox()#
		</div>
		

		
		--->
		
		<div class="checkout-msg-box checkout-msg-box-error">
			#application.model.CheckoutHelper.getCheckoutMessageBox()#
			#application.model.CheckoutHelper.setCheckoutMessageBox('')#
		</div>		
		
	</cfif>
	
	#trim(cartHTML)#
</cfoutput>