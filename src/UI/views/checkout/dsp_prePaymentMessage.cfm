<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />

<!--- If there is only one payment gateway for this channel, submit this form to the gateway with the necessary fields --->
<cfif !GatewayRegistry.hasMultipleRegistered()>
	<cfinclude template="paymentGatewayInclude.cfm" />
</cfif>

<script type="text/javascript">
	jQuery(document).ready( function($) {
		$('.continue').click( function() {
			showProgress('Processing ...');
			$('#app').submit();
		})
	})
</script>

<cfoutput>
	<h1>Identity Verification</h1>
	<p>For identity verification, a credit card is required. <b>YOUR CARD WILL NOT BE CHARGED</b>, unless your total is greater 
	than $0 for the items in your cart.</p>
	
	<form id="app" name="carrierApplication" method="post" action="#formAction#">		
		<cfif !GatewayRegistry.hasMultipleRegistered() >
		    <!--- form fields that are passed to payment gateway --->
		    <cfoutput>#formFields#</cfoutput>
		</cfif>
		<br />
		<div class="formControl">
	        <span class="actionButtonLow">
				<a class="backBtn" href="/index.cfm/go/checkout/do/carrierTerms/">Back</a>
			</span>
			<span class="actionButton">
				<a class="continue" href="##">Continue</a>
			</span>
		</div>
	</form>	
</cfoutput>