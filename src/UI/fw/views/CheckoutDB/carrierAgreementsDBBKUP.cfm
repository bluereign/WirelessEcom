<cfset formAction = '/index.cfm/go/checkout/do/processCarrierTerms'> <!--- This can be overridden by the cfinclude of paymentGatewayInclude.cfm --->
<cfset carrierName = application.model.checkoutHelper.getCarrierName()>
<cfset GatewayRegistry = application.wirebox.getInstance("PaymentProcessorRegistry") />
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />
<cfif application.wirebox.containsInstance("CampaignService")>
	<cfset campaignService = application.wirebox.getInstance("CampaignService") />
	<cfset campaign = campaignService.getCampaignBySubdomain( campaignService.getCurrentSubdomain() ) />
</cfif>

<!--- If there is only one payment gateway for this channel, submit this form to the gateway with the necessary fields --->
<!---<cfif !GatewayRegistry.hasMultipleRegistered()>
	<cfinclude template="/views/checkout/paymentGatewayInclude.cfm" />
</cfif>--->

<!--- Display Pre-Payment Gateway Messaging --->
<!---<cfif ChannelConfig.getDisplayPrePaymentGatewayPage()>
	<cfset formAction = '/index.cfm/go/checkout/do/processCarrierTerms'>
</cfif>--->

<cfoutput><script type="text/javascript" src="#assetpaths.common#scripts/libs/jquery.validate.min.js"></script></cfoutput> 
<script type="text/javascript">
	jQuery(document).ready( function($) {
		$('#app').validate({
			rules : {
				agreeToContract : "required",
				agreeToContractExtension : "required",
				agreeToCarrierTermsAndConditions : "required",
				agreeToCustomerLetter: "required",
				agreeToUpgradeDiscount: "required"
			},
			messages : {
				agreeToContract : "You must agree to the contract to proceed.",
				agreeToContractExtension : "You must agree to the contract extension to proceed.",
				agreeToCarrierTermsAndConditions : "You must agree to the carrier terms and conditions to proceed.",
				agreeToCustomerLetter : "You must agree to the customer letter to proceed.",
				agreeToUpgradeDiscount: "You must agree to the upgrade discount notification."
			},
			errorPlacement : function(error, element) {
				error.insertAfter(element.next('a'));
			},
			errorElement : "div"
		})
		$('.continue').click( function() {
			
			if ($('#app').valid()) {
				showProgress('Processing Terms & Conditions.');
							
				if ($('#agreeToSmsOptIn').attr('checked'))
				{
					$.ajax({
						url: "/ajax/CheckoutHelper.cfc?method=optInForSmsMessage",
						type: "POST",
						async: false,
						success: function(result){
							//console.log(result);
						},
						error: function(jqXHR, textStatus, errorThrown) {
							//console.log(textStatus, errorThrown);
						}
					});
				}
				
				$('#app').submit();
			}
		})
	})
</script>

<cfoutput>
	
	<h1>#carrierName# Agreements</h1>
	<p>Click the links below to review the #carrierName# Terms &amp; Agreements</p>
	<div class="formControl">
			<a class="backBtn" href="##">Previous</a>
		<span class="btn btn-primary">
			<a class="continue" href="##">Continue</a>
		</span>
	</div>
	<hr class="blueline" />
	<p>After reviewing the following sections, check the corresponding box to agree and continue.</p>
	<form id="app" name="carrierApplication" method="post" action="#formAction#">

		<p>
			<cfif session.cart.getActivationType() CONTAINS "New" or session.cart.getActivationType() CONTAINS "addaline" >
			<input type="checkbox" name="agreeToContract" /> <a href="##" onclick="ColdFusion.Window.show('ContractAgreement')">2-Year Contract Agreement</a>
			<cfelse>
			<input type="checkbox" name="agreeToContractExtension" /> <a href="##" onclick="ColdFusion.Window.show('ContractExtension')">2-Year Contract Extension</a>
			</cfif>
		</p>
		
		<!--- AT&T Upgrade Disclaimer --->
		<cfif application.model.checkoutHelper.getCarrier() eq 109 && session.cart.getActivationType() CONTAINS "Upgrade">
			<p>
				<input type="checkbox" name="agreeToUpgradeDiscount" /> <a href="##" onclick="ColdFusion.Window.show('UpgradeDiscountAgreement')">Upgrade Discount Notification</a>
			</p>
		</cfif>
		
		<p>
			<input type="checkbox" name="agreeToCarrierTermsAndConditions" /> <a href="#application.model.checkoutHelper.getCarrierTermsFile()#" target="_blank" onclick="window.open('CarrierTerms'); return false;">Carrier Terms &amp; Conditions</a>
		</p>
		
		<cfif channelConfig.getDisplayCarrierCustomerLetter()>
			<p>
				<input type="checkbox" name="agreeToCustomerLetter" /> <a href="#application.model.CheckoutHelper.getCarrierCustomerLetterFile()#" target="_blank" onclick="ColdFusion.Window.show('CustomerLetter'); return false;">#channelConfig.getDisplayName()# Customer Letter</a>
			</p>
		</cfif>
		
		<cfif channelConfig.getDisplaySmsOptIn() && IsDefined('campaign')>
			<p>
				<input id="agreeToSmsOptIn" type="checkbox" name="agreeToSmsOptIn" /> <a href="##" target="_blank" onclick="ColdFusion.Window.show('SmsOptIn'); return false;"> Yes, please send me the #campaign.getCompanyName()# mobile app for free via SMS. Message and data rates may apply.</a>
			</p>
		</cfif>		
		
		<!---<cfif !GatewayRegistry.hasMultipleRegistered() >
		    <!--- form fields that are passed to payment gateway --->
		    <cfoutput>#formFields#</cfoutput>
		</cfif>--->
		<br />
		<hr class="bottom-break" />
		<div class="formControl">
				<a class="backBtn" href="##">Previous</a>
			<span class="btn btn-primary">
				<a class="continue" href="##">Continue</a>
			</span>
		</div>
	</form>
	
	<div style="display:none">
		<cfwindow name="ContractAgreement" modal="true" center="true" resizable="false">
			<h1>2-Year Contract Agreement</h1>
			<p>Content - By clicking the checkbox, you are agreeing to a contract for 24 months from the date of purchase on completion of this order process.</p>
		</cfwindow>
	</div>
	
	<div style="display:none">
		<cfwindow name="UpgradeDiscountAgreement" modal="true" center="true" resizable="false">
			<h1>Upgrade Discount Notification</h1>		
			<!--- Modified on 10/02/2014 by Denard Springle (denard.springle@cfwebtools.com) --->
			<!--- Track #: 6804 - Costco.com: remove a sentence from a pop up - Online Compliance required by AT&T [ Commented out the line requested by legal ] --->
			<!---<p>Some customers have a monthly discount which was applied to their Mobile Share Value account by AT&T in February 2014.</p>--->
			<!--- END EDITS on 10/02/2014 by Denard Springle --->
			<p>By upgrading to a 2 year wireless contract you will no longer be eligible for the Mobile Share Value monthly discounts of $15 on plans lower than 10GB, or $25 on 10GB or higher plans.</p>
		</cfwindow>
	</div>	
	
	<div style="display:none">
		<cfwindow name="ContractExtension" modal="true" center="true" resizable="false">
			<h1>2-Year Contract Extension</h1>
			<p>By clicking the checkbox, you are agreeing to extend your contract for 24 months from the date of purchase on completion of this order process.</p>
		</cfwindow>
	</div>
	
	<div style="display:none">
		<cfwindow name="CarrierTerms" title="#carrierName# Terms and Conditions" modal="true" center="true" resizable="true" width="900" height="650">
			<iframe src="#application.model.checkoutHelper.getCarrierTermsFile()#" width="870" height="595"></iframe>
		</cfwindow>
	</div>
	
	<cfif channelConfig.getDisplayCarrierCustomerLetter()>
		<div style="display:none">
			<cfwindow name="CustomerLetter" title="#channelConfig.getDisplayName()# Customer Letter" center="true" resizable="true" width="900" height="650">
				<iframe src="#application.model.checkoutHelper.getCarrierCustomerLetterFile()#" width="870" height="595"></iframe>
			</cfwindow>
		</div>
	</cfif>
	
	<cfif channelConfig.getDisplaySmsOptIn() && IsDefined('campaign')>
		<div style="display:none">
			<cfwindow name="SmsOptIn" modal="true" center="true" resizable="false">
				<h1>#campaign.getCompanyName()# Mobile App</h1>
				<p>By providing your mobile phone number, you are agreeing to receive 1 text message providing you with information regarding this promotion.  The message will come from Wireless Advocates on short code 99222 and may be sent via automatic telephone dialing system. Message and data rates may apply.  You are not required to sign the agreement as a condition of purchasing any property, goods or services. You may opt out at any time by texting STOP to 99222. By sending STOP to 99222, you agree to one additional confirmation message stating that you've opted out and will no longer receive messages from Wireless Advocates. To get help, text HELP to 99222.</p> 
				<p>Get additional support or help by calling #channelConfig.getCustomerCarePhone()#.  You must be the mobile phone account holder or have permission from the account holder to use this service. You must be 18 years or older or have permission from a parent/guardian. For complete Terms and Conditions, go <a href="/index.cfm/go/content/do/terms" target="_blank">here</a>. To view our Privacy Policy go <a href="/index.cfm/go/content/do/privacy/" target="_blank">here</a>. </p>
			</cfwindow>
		</div>
	</cfif>
	
	<!---<cfset rebateText = application.view.product.ReplaceRebate( '%CarrierRebate1% %CarrierRebate2% %CarrierSkuRebate1% %CarrierSkuRebate2%', prc.productData.carrierId, prc.productData.gersSku) />--->
	<!---<cfif trim(rebateText) is not "">
		<br />
		<br />
		<h5>Rebates and Specials</h5>
		<hr class="blueline">
		<span class="rebate-callout">#rebateText#</span><br />
	</cfif>--->

</cfoutput>