<cfset GatewayRegistry = application.wirebox.getInstance("PaymentProcessorRegistry")>
<cfset cardTypes = GatewayRegistry.listPaymentMethods() >

<cfset assetPaths = application.wirebox.getInstance("assetPaths")>

<h1>Payment Options</h1>
<p>Please select your preferred method of payment.</p>
<cfoutput>
	<form id="paymentOptions" method="post" class="cmxform" action="/index.cfm/go/checkout/do/processPaymentOptions">

		<cfif ListFindNocase(cardTypes,"default")>
			<input type="radio" id="defaultPaymentMethod" name="paymentMethod" value="default" checked="checked"/>
			<label for="defaultPaymentMethod" class="long">Pay with a credit card</label>
			<img src="#assetPaths.common#images/payment/visa-small.gif" alt="Visa" />
			<img src="#assetPaths.common#images/payment/mastercard-small.gif" alt="Mastercard" />
			<img src="#assetPaths.common#images/payment/amex-small.gif" alt="American Express" />
			<img src="#assetPaths.common#images/payment/discover-small.gif" alt="Discover" />
			<img src="#assetPaths.channel#images/payment/military_star_visa.png" alt="Military Star Visa" />
		</cfif>
		<!---<cfif ListFindNocase(cardTypes,"MilitaryStar")>
			<br />
			<input type="radio" id="starCardPaymentMethod" name="paymentMethod" value="MilitaryStar" />
			<label for="starCardPaymentMethod" class="long">Pay with Military Star card</label>
			<img src="#assetPaths.channel#images/payment/military_star_card.png" alt="Military Star" />
		</cfif>--->

		<div class="formControl">
			<span class="actionButtonLow">
				<a href="##" onclick="window.location.href='/index.cfm/go/checkout/do/customerLetter/'">Back</a>
			</span>
			<span class="actionButton">
				<a href="##" onclick="$('##paymentOptions').submit()">Continue</a>
			</span>
		</div>
	</form>
</cfoutput>