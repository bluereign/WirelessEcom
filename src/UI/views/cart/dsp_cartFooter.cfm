<cfset listDeviceBuilderCarriers = "109" /> <!--- 109,42 = AT&T, VZW --->
<cfset cartValidationResponse = application.model.cartHelper.validateCartForCheckout() />
<cfparam name="session.vfd.access" default="0">
<cfoutput>
	<div class="cartToolbar formControl">
		<span class="actionButtonLow">
			<a href="##" onclick="if(confirm('Are you sure you want to clear your cart?')){ ColdFusion.navigate('/index.cfm/go/cart/do/clearCart/blnDialog/1/', 'dialog_addToCart'); };return false;">Clear Cart</a>
		</span>
		<span class="actionButtonLow">
			<a href="##" onclick="ColdFusion.Window.hide('dialog_addToCart');return false;">Close Cart</a>
		</span>
		<cfif attributes.EnableCartReview>
			<cfif cartValidationResponse.getIsCartValid()>
			<span class="actionButton" id="btnCartReview">
				<!--- VFD access check MES --->
				<cfif (structKeyExists(session, "vfd")) and (session.VFD.Access eq true)>
					<!---<a href="##" onclick="location.href='?event=CheckoutVFD.startCheckout';return false;">Next</a>--->
					<a href="##" onclick="location.href='/CheckoutVFD/startCheckout';return false;">Next</a>
				<cfelseif arrayLen(session.cart.getLines()) and listFindNoCase(listDeviceBuilderCarriers,session.cart.getCarrierId()) and session.cart.getActivationType() contains 'finance'>
					<a href="##" onclick="location.href='/devicebuilder/orderreview';return false;">Cart Review</a>
				<cfelse>
					<a href="##" onclick="location.href='/index.cfm/go/cart/do/view/';return false;">Cart Review</a>
				</cfif>
			</span>
			<cfelse>
			<span class="actionButton" id="btnCartReview">
					<cfset cartErrors = cartValidationResponse.getErrors() />
					<cfset alertMsg = "Please correct the following #arraylen(cartErrors)# issue(s): " />
					<cfset errorListCounter = 0 />
					<cfloop array="#cartErrors#" index="cartError">
						<cfset errorListCounter = errorListCounter + 1 />
						<cfset alertMsg = alertMsg & "\n" & "(#errorListCounter#) " & cartError />
					</cfloop>
					<cfset alertMsg = ReplaceNoCase(alertMsg,"'","\'","ALL") />
					<a href="##" onclick="alert('#alertMsg#');return false;""><cfif (structKeyExists(session, "vfd")) and (session.VFD.Access eq true)>Next<cfelse>Cart Review</cfif></a>
			</span>
			</cfif>
			
		</cfif>
	</div>
</cfoutput>
