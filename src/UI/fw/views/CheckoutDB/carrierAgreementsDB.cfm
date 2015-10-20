<cfset formAction = '/index.cfm/go/checkout/do/processCarrierTerms'> <!--- This can be overridden by the cfinclude of paymentGatewayInclude.cfm --->
<cfset carrierName = application.model.checkoutHelper.getCarrierName()>
<cfset GatewayRegistry = application.wirebox.getInstance("PaymentProcessorRegistry") />
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />
<cfif application.wirebox.containsInstance("CampaignService")>
	<cfset campaignService = application.wirebox.getInstance("CampaignService") />
	<cfset campaign = campaignService.getCampaignBySubdomain( campaignService.getCurrentSubdomain() ) />
</cfif>

<cfoutput><script type="text/javascript" src="#assetpaths.common#scripts/libs/jquery.validate.min.js"></script></cfoutput> 
<style>
	.modal-body {
    height:650px;
    width:100%; 
}
.bootstrap .modal-custom{
    overflow-y: auto;
}
</style>
<script type="text/javascript">
	jQuery(document).ready( function($) {
		var $j = jQuery.noConflict();
		$('#app').validate({
			rules : {
				agreeToContract : "required",
				agreeToContractExtension : "required",
				agreeToDevicePaymentPlan : "required",
				agreeToDevicePaymentPresented: "required",
				agreeToCarrierTermsAndConditions : "required",
				agreeToCustomerLetter: "required"
			},
			messages : {
				agreeToContract : "You must agree to the contract to proceed.",
				agreeToContractExtension : "You must agree to the contract extension to proceed.",
				agreeToDevicePaymentPlan : "You must agree to the device payment plan to proceed.",
				agreeToDevicePaymentPresented: "You must acknowledge presentation of documents to proceed.",
				agreeToCarrierTermsAndConditions : "You must agree to the carrier terms and conditions to proceed.",
				agreeToCustomerLetter : "You must agree to the customer letter to proceed."
			},
			errorPlacement : function(error, element) {
				error.insertAfter(element.next('a'));
			}
		})
		$('.continue').click( function() {
			if ($('#app').valid()) {
				showProgress('Processing Terms & Conditions.');
							
				$('#app').submit();
			}
		})
		
		$('#agreeToContractDoc').click( function() {
			$('#docClicked').val("agreeToContract");
			$('#carrierDoc').attr('data', 'http://local.fullapi.wa/assets/costco/docs/customerletters/verizon/Verizon_Customer_Letter_09_02_14.pdf');
			$('#carrierDocEmbed').attr('src', 'http://local.fullapi.wa/assets/costco/docs/customerletters/verizon/Verizon_Customer_Letter_09_02_14.pdf');
			$('#confirmationPrint').attr('src', 'http://local.fullapi.wa/assets/costco/docs/customerletters/verizon/Verizon_Customer_Letter_09_02_14.pdf');
		})
		
		$('#agreeToContractExtension').click( function() {
			$('#docClicked').val("agreeToContractExtension");
			$('#carrierDoc').attr('data', 'http://local.fullapi.wa/assets/costco/docs/customerletters/att/ATT_Customer_Letter_05_19_14.pdf');
			$('#carrierDocEmbed').attr('src', 'http://local.fullapi.wa/assets/costco/docs/customerletters/att/ATT_Customer_Letter_05_19_14.pdf');
			$('#confirmationPrint').attr('src', 'http://local.fullapi.wa/assets/costco/docs/customerletters/att/ATT_Customer_Letter_05_19_14.pdf');
		})
		
		$('#agreeToDevicePaymentPlan').click( function() {
			$('#docClicked').val("agreeToDevicePaymentPlan");
			$('#carrierDoc').attr('data', 'http://local.fullapi.wa/assets/costco/docs/customerletters/verizon/Verizon_Customer_Letter_09_02_14.pdf');
			$('#carrierDocEmbed').attr('src', 'http://local.fullapi.wa/assets/costco/docs/customerletters/verizon/Verizon_Customer_Letter_09_02_14.pdf');
			$('#confirmationPrint').attr('src', 'http://local.fullapi.wa/assets/costco/docs/customerletters/verizon/Verizon_Customer_Letter_09_02_14.pdf');
		})
		
		$('#agreeToCarrierTermsAndConditions').click( function() {
			$('#docClicked').val("agreeToCarrierTermsAndConditions");
			$('#carrierDoc').attr('data', 'http://local.fullapi.wa/assets/costco/docs/customerletters/att/ATT_Customer_Letter_09_24_15.pdf');
			$('#carrierDocEmbed').attr('src', 'http://local.fullapi.wa/assets/costco/docs/customerletters/att/ATT_Customer_Letter_09_24_15.pdf');
			$('#confirmationPrint').attr('src', 'http://local.fullapi.wa/assets/costco/docs/customerletters/att/ATT_Customer_Letter_09_24_15.pdf');
		})
		
		$('#agreeToCustomerLetter').click( function() {
			$('#docClicked').val("agreeToCustomerLetter");
			$('#carrierDoc').attr('data', 'http://local.fullapi.wa/assets/costco/docs/customerletters/verizon/Verizon_Customer_Letter_09_02_14.pdf');
			$('#carrierDocEmbed').attr('src', 'http://local.fullapi.wa/assets/costco/docs/customerletters/verizon/Verizon_Customer_Letter_09_02_14.pdf');
			$('#confirmationPrint').attr('src', 'http://local.fullapi.wa/assets/costco/docs/customerletters/verizon/Verizon_Customer_Letter_09_02_14.pdf');
		})
		
		$('#agreeButton').click( function() {
			var checkName = $('#docClicked').val();
			if($('input[type="checkbox"][name="'+ checkName +'"]').attr('Checked','false')){
				$('input[type="checkbox"][name="'+ checkName +'"]').attr('Checked','Checked');
			}
		})
		
		$('#printButton').click( function() {
			var ms_ie = false;
   			var ua = window.navigator.userAgent;
    		var old_ie = ua.indexOf('MSIE ');
    		var new_ie = ua.indexOf('Trident/');

    		if ((old_ie > -1) || (new_ie > -1)) {
        		ms_ie = true;
   			 }
    		if ( ms_ie ) {
    			var iframe = document.getElementById('confirmationPrint');
        		iframe.contentWindow.document.execCommand('print', false, null);
    		}
    		else {
    			parent.document.getElementById('confirmationPrint').contentWindow.print();
    		}
		})

	});
	
</script>
<cfoutput>
	<input type="hidden" id="carrierID" value="#session.cart.getCarrierId()#">
	<input type="hidden" id="docClicked" value="none">
	<div class="bootstrap">
	<h1>#carrierName# Agreements</h1>
	<p>Click the links below to review the #carrierName# Terms &amp; Agreements</p>
	<div class="formControl">
			<a class="backBtn" href="##">Previous</a>
		<span class="btn btn-primary">
			<a class="continue" href="##">Continue</a>
		</span>
	</div>
	
	<hr class="blueline" />
	
		<p>
			After reviewing the following Terms & Conditions, check the corresponding boxes to agree to the #carrierName# and Costco Terms and Conditions. 
			Once all the Terms & Conditions are accepted, you can then Continue checking out.
		</p>
	<form id="app" name="carrierApplication" method="post" action="#formAction#">
		<p>
			<cfif session.cart.getActivationType() CONTAINS "New" or session.cart.getActivationType() CONTAINS "addaline" >
				<a href="##" id="agreeToContractDoc" data-toggle="modal" data-target="##carrierDocModal">Terms & Conditions of the #carrierName# Two Year Customer Agreement</a><br/>
				<p>
					<input type="checkbox" name="agreeToContract" /><a></a>
					I HAVE READ AND AGREED TO THE #UCase(carrierName)# CUSTOMER AGREEMENT INCLUDING AN EARLY TERMINATION FEE UP TO $350 PER LINE, 
					LIMITATIONS OF LIABILITY FOR SERVICE AND EQUIPMENT, SETTLEMENT OF DISPUTES BY ARBITRATION INSTEAD OF JURY TRIAL, AS WELL 
					AS THE TERMS OF MY PLAN AND ANY OPTIONAL SERVICES I HAVE AGREED TO PURCHASE.
				</p>
			<cfelse>
				<a href="##" id="agreeToContractExtension" data-toggle="modal" data-target="##carrierDocModal">Terms & Conditions of the #carrierName# Two Year Customer Extension</a><br/>
				<p>
					<input type="checkbox" name="agreeToContractExtension" /><a></a> 
					I HAVE READ AND AGREED TO THE #UCase(carrierName)# CUSTOMER AGREEMENT INCLUDING AN EARLY TERMINATION FEE UP TO $350 PER LINE, 
					LIMITATIONS OF LIABILITY FOR SERVICE AND EQUIPMENT, SETTLEMENT OF DISPUTES BY ARBITRATION INSTEAD OF JURY TRIAL, AS WELL 
					AS THE TERMS OF MY PLAN AND ANY OPTIONAL SERVICES I HAVE AGREED TO PURCHASE.
				</p>
			</cfif>
		</p>
		<p>
			<a href="##" id="agreeToDevicePaymentPlan" data-toggle="modal" data-target="##carrierDocModal">Terms & Conditions of the #carrierName# Device Payment Plan</a>
			<p>
				<input type="checkbox" name="agreeToDevicePaymentPlan" /><a></a>
				I HAVE READ AND AGREED TO THE #UCase(carrierName)# CUSTOMER AGREEMENT INCLUDING LIMITATIONS OF LIABILITY FOR SERVICE AND EQUIPMENT, 
				SETTLEMENT OF DISPUTES BY ARBITRATION INSTEAD OF JURY TRIAL, AS WELL AS THE TERMS OF MY PLAN AND ANY OPTIONAL SERVICES I HAVE AGREED TO PURCHASE.
			</p>
		</p>
		<p>
			NOTICE TO BUYER: This is a retail installment sale agreement, not a lease. Do not accept if it contains blank spaces. You have a right to a copy of 
			this agreement; keep it to protect your rights. You may pay off the full amount at any time. Please review the entire agreement, including the 
			additional Notice to Buyer provisions, before accepting.
		</p>
		<p>
			<input type="checkbox" name="agreeToDevicePaymentPresented" /><a></a>
			I acknowledge that Wireless Advocates has on this date presented me with the above completed Retail Installment Sale Agreement/Notice to Buyer 
			(the "Agreement") and I have read the Agreement. I agree to all terms and conditions and understand that if I do not accept these terms, my order 
			will be cancelled and the device will not be shipped.
		</p>
		<p>
			<a href="##" id="agreeToCarrierTermsAndConditions" data-toggle="modal" data-target="##carrierDocModal">#carrierName# Terms &amp; Conditions</a><br/>
			<input type="checkbox" name="agreeToCarrierTermsAndConditions" /><a></a> 
			I HAVE READ AND AGREED TO THE #UCase(carrierName)# TERMS AND CONDITIONS FOR SERVICE AGREEMENT
		</p>
		<p>
			<a href="##" id="agreeToCustomerLetter" data-toggle="modal" data-target="##carrierDocModal">Terms &amp; Conditions of the Costco Wireless Customer Letter</a><br/>
			<input type="checkbox" name="agreeToCustomerLetter" /><a></a>
			I HAVE READ AND AGREED TO THE TERMS AND CONDITIONS FOUND IN THE COSTCO WIRELESS CUSTOMER LETTER
		</p>
		<br />
		
		<hr class="bottom-break" />
		
		<div class="formControl">
				<a class="backBtn" href="##">Previous</a>
			<span class="btn btn-primary">
				<a class="continue" href="##">Continue</a>
			</span>
		</div>
		<!---<button type="button" class="btn btn-info btn-lg" data-toggle="modal" data-target="##myModal">Open Modal</button>
		<a data-toggle="modal" data-target="##carrierDocModal">Open Modal</a>--->
	<!-- Modal -->
<div id="carrierDocModal" class="modal fade" role="dialog">
  <div class="modal-dialog">

    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">#carrierName# Header</h4>
      </div>
      <div class="modal-body">
		<object id="carrierDoc" name="carrierDoc"  data="http://local.fullapi.wa/assets/costco/docs/customerletters/verizon/Verizon_Customer_Letter_09_24_15.pdf" type="application/pdf" style="width:100%;height:100%">
        	<embed id="carrierDocEmbed" name="carrierDocEmbed" src="http://local.fullapi.wa/assets/costco/docs/customerletters/verizon/Verizon_Customer_Letter_09_24_15.pdf" type="application/pdf" />
    	</object>
      </div>
      <div class="modal-footer">
      	<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      	<button type="button" id="printButton" class="btn btn-default" data-dismiss="modal">Print Terms & Conditions</button>
        <button type="button" id="agreeButton" class="btn btn-default" data-dismiss="modal">Agree</button>
      </div>
    </div>

  </div>
</div>
</form>
	<!---<cfset rebateText = application.view.product.ReplaceRebate( '%CarrierRebate1% %CarrierRebate2% %CarrierSkuRebate1% %CarrierSkuRebate2%', prc.productData.carrierId, prc.productData.gersSku) />--->
	<!---<cfif trim(rebateText) is not "">
		<br />
		<br />
		<h5>Rebates and Specials</h5>
		<hr class="blueline">
		<span class="rebate-callout">#rebateText#</span><br />
	</cfif>--->
</div>
<iframe src="http://local.fullapi.wa/assets/costco/docs/customerletters/verizon/Verizon_Customer_Letter_09_24_15.pdf" style="display: none" 
	        id="confirmationPrint">
</iframe>
</cfoutput>
