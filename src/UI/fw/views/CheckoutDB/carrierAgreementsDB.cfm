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
form .form-inline label { width:auto;}
.error {
color:red;
padding-left:5px;
}
</style>
<script type="text/javascript">
	jQuery(document).ready( function($) {
		var $j = jQuery.noConflict();
		var actType = $('#cartActivationType').val();
		
		//Checkboxes not displayed are checked so that validation will pass
		if ((actType.search("new") >= 0) ||(actType.search("addaline") >= 0) || (actType.search("finance") < 0) ){
					//alert("Display agreeToContractDoc");
					$('input[type="checkbox"][name="agreeToContractExtension"]').attr('Checked','Checked');
					$('input[type="checkbox"][name="agreeToDevicePaymentPlan"]').attr('Checked','Checked');
					
				} else if (actType.search("finance") < 0){
					//alert("Display agreeToContractExtension");
					$('input[type="checkbox"][name="agreeToContractDoc"]').attr('Checked','Checked');
					$('input[type="checkbox"][name="agreeToDevicePaymentPlan"]').attr('Checked','Checked');
				}
		if (actType.search("finance") >= 0){
					//alert("Display agreeToDevicePaymentPlan");
					$('input[type="checkbox"][name="agreeToContractDoc"]').attr('Checked','Checked');
					$('input[type="checkbox"][name="agreeToContractExtension"]').attr('Checked','Checked');
				}
		
		$('#app').validate({
			rules : {
				agreeToContractDoc:		"required",
				agreeToContractExtension:	"required",
				agreeToDevicePaymentPlan:	"required",
				agreeToDevicePaymentPresented:	"required",
				agreeToCarrierTermsAndConditions : "required",
				agreeToCustomerLetter: "required"
			},
			messages : {
				agreeToContractDoc:		"You must agree to the contract documentation to proceed.",
				agreeToContractExtension:	"You must agree to the contract extension to proceed.",
				agreeToDevicePaymentPlan:	"You must agree to the device payment plan to proceed.",
				agreeToDevicePaymentPresented: "You must acknowledge reading and approval of the documents to proceed.",
				agreeToCarrierTermsAndConditions : "You must agree to the carrier terms and conditions to proceed.",
				agreeToCustomerLetter : "You must agree to the customer letter to proceed."
			},
			errorPlacement : function(error, element) {
				error.insertAfter(element);
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
			if ($('#carrierID').val()=='42'){
				$('#carrierDoc').attr('data', $('#verizonContractExtensionURL').val());
				$('#carrierDocEmbed').attr('src', $('#verizonContractExtensionURL').val());
				$('#confirmationPrint').attr('src', $('#verizonContractExtensionURL').val());
			}
			if ($('#carrierID').val()=='109'){
				$('#carrierDoc').attr('data', $('#attContractExtensionURL').val());
				$('#carrierDocEmbed').attr('src', $('#attContractExtensionURL').val());
				$('#confirmationPrint').attr('src', $('#attContractExtensionURL').val());
			}
		})
		
		$('#agreeToContractExtension').click( function() {
			$('#docClicked').val("agreeToContractExtension");
			if ($('#carrierID').val()=='42'){
				$('#carrierDoc').attr('data', $('#verizonContractExtensionURL').val());
				$('#carrierDocEmbed').attr('src', $('#verizonContractExtensionURL').val());
				$('#confirmationPrint').attr('src', $('#verizonContractExtensionURL').val());
			}
			if ($('#carrierID').val()=='109'){
				$('#carrierDoc').attr('data', $('#attContractExtensionURL').val());
				$('#carrierDocEmbed').attr('src', $('#attContractExtensionURL').val());
				$('#confirmationPrint').attr('src', $('#attContractExtensionURL').val());
			}
		})
		
		$('#agreeToDevicePaymentPlan').click( function() {
			$('#docClicked').val("agreeToDevicePaymentPlan");
			if ($('#carrierID').val()=='42'){
				
			}
			if ($('#carrierID').val()=='109'){
				$('#carrierDoc').attr('data', $('#pdfURL').val());
				$('#carrierDocEmbed').attr('src', $('#pdfURL').val());
				$('#confirmationPrint').attr('src', $('#pdfURL').val());
			}
		})
		
		$('#agreeToCarrierTermsAndConditions').click( function() {
			$('#docClicked').val("agreeToCarrierTermsAndConditions");
			if ($('#carrierID').val()=='42'){
				$('#carrierDoc').attr('data', $('#verizonTermsURL').val());
				$('#carrierDocEmbed').attr('src', $('#verizonTermsURL').val());
				$('#confirmationPrint').attr('src', $('#verizonTermsURL').val());
			}
			if ($('#carrierID').val()=='109'){
				$('#carrierDoc').attr('data', $('#attTermsURL').val());
				$('#carrierDocEmbed').attr('src', $('#attTermsURL').val());
				$('#confirmationPrint').attr('src', $('#attTermsURL').val());
			}
		})
		
		$('#agreeToCustomerLetter').click( function() {
			$('#docClicked').val("agreeToCustomerLetter");
			if ($('#carrierID').val()=='42'){
				$('#carrierDoc').attr('data', $('#costcoVerizonTermsURL').val());
				$('#carrierDocEmbed').attr('src', $('#costcoVerizonTermsURL').val());
				$('#confirmationPrint').attr('src', $('#costcoVerizonTermsURL').val());
			}
			if ($('#carrierID').val()=='109'){
				$('#carrierDoc').attr('data', $('#costcoAttTermsURL').val());
				$('#carrierDocEmbed').attr('src', $('#costcoAttTermsURL').val());
				$('#confirmationPrint').attr('src', $('#costcoAttTermsURL').val());
			}
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
	<div class="col-md-12">
      <section class="content">
	<input type="hidden" id="carrierID" value="#session.cart.getCarrierId()#">
	<input type="hidden" id="cartActivationType" value="#session.cart.getActivationType()#">
	<input type="hidden" id="docClicked" value="none">
	<input type="hidden" name="pdfEncoded" value="#session.FinanceAgreementResp.getResponse().FinanceAgreement#"/>
	<input type="hidden" id="pdfURL" value="#event.buildLink('/CheckoutDB/financeAgreement')#">
	<input type="hidden" id="verizonContractExtensionURL" value="#assetPaths.channel#docs/customerletters/verizon/Verizon_2yr_Customer_Letter_9_29_15_API.pdf">
	<input type="hidden" id="attContractExtensionURL" value="#assetPaths.channel#docs/customerletters/att/ATT_2Year_Customer_Letter_9_29_15_API_1.pdf">
	<input type="hidden" id="verizonTermsURL" value="#assetPaths.channel#docs/termsandconditions/verizon/Verizon_tc_07_24_2015.pdf">
	<input type="hidden" id="attTermsURL" value="#assetPaths.channel#docs/termsandconditions/att/att_tc_1_27_15.pdf">
	<input type="hidden" id="costcoVerizonTermsURL" value="#assetPaths.channel#docs/termsandconditions/verizon/Verizon_Customer_Letter_09_24_15.pdf">
	<input type="hidden" id="costcoAttTermsURL" value="#assetPaths.channel#docs/customerletters/att/ATT_Customer_Letter_09_24_15.pdf">



    <header class="main-header">
      <h1>#carrierName# Agreements</h1>
      <p>The primary Account Holder's information is used to verify status and line availability.</p>
    </header>
    <form id="app" name="carrierApplication" method="post" action="#event.buildLink('/CheckoutDB/processCarrierAgreements')#">
      <div class="right">
        <a href="##" class="backBtn" onclick="window.location.href='/CheckoutDB/billShip'">Back</a>
        <button type="submit" class="btn btn-primary continue">Continue</button>
      </div>
      
      <p>
			  <cfif session.cart.getCarrierId() eq 42>
				  After reviewing the following Terms & Conditions, check the corresponding boxes to agree to the #carrierName# and Costco Terms and Conditions. 
				  Once all the Terms & Conditions are accepted, you can then Continue checking out.
			  <cfelseif  session.cart.getCarrierId() eq 109>
				  After reviewing the following sections, check the corresponding box to agree and continue.			
			  </cfif>
		  </p>

      <h4>
        <a href="##" id="agreeToCustomerLetter" data-toggle="modal" data-target="##carrierDocModal">View Terms &amp; Conditions of the Costco Wireless Customer Letter</a>
      </h4>
      <div class="form-group form-inline">
        <label>
          <input type="checkbox" name="agreeToCustomerLetter" />
          <cfif session.cart.getCarrierId() eq 42>
            I HAVE READ AND AGREED TO THE TERMS AND CONDITIONS FOUND IN THE COSTCO WIRELESS CUSTOMER LETTER
            <cfelseif session.cart.getCarrierId() eq 109>	
				    I have read and understand the information in the Costco Wireless Customer Letter
			    </cfif>
        </label>
      </div>

      	<p>
			    <cfif session.cart.getActivationType() CONTAINS "New" or session.cart.getActivationType() CONTAINS "addaline" or session.cart.getActivationType() DOES NOT CONTAIN "finance">
				    <h4><a href="##" id="agreeToContractDoc" data-toggle="modal" data-target="##carrierDocModal">View Terms & Conditions of the #carrierName# Two Year Customer Agreement</a></h4>
				    <div class="form-group form-inline">
					    <label><input class="form-control" type="checkbox" name="agreeToContract" />
					    <cfif session.cart.getCarrierId() eq 42>
						    I HAVE READ AND AGREED TO THE #UCase(carrierName)# CUSTOMER AGREEMENT INCLUDING AN EARLY TERMINATION FEE UP TO $350 PER LINE, 
						    LIMITATIONS OF LIABILITY FOR SERVICE AND EQUIPMENT, SETTLEMENT OF DISPUTES BY ARBITRATION INSTEAD OF JURY TRIAL, AS WELL 
						    AS THE TERMS OF MY PLAN AND ANY OPTIONAL SERVICES I HAVE AGREED TO PURCHASE.
					    <cfelseif  session.cart.getCarrierId() eq 109>
						    I agree with the terms of the 2-Year Contract Agreement
					    </cfif>
					    </label>
				    </div>
			    <cfelse>
				    <cfif session.cart.getActivationType() DOES NOT CONTAIN "finance">		
					    <h4><a href="##" id="agreeToContractExtension" data-toggle="modal" data-target="##carrierDocModal">View Terms & Conditions of the #carrierName# Two Year Customer Extension</a></h4>
					    <div class="form-group form-inline">
						    <label><input type="checkbox" name="agreeToContractExtension" />
						    <cfif session.cart.getCarrierId() eq 42>
							    I HAVE READ AND AGREED TO THE #UCase(carrierName)# CUSTOMER AGREEMENT INCLUDING AN EARLY TERMINATION FEE UP TO $350 PER LINE, 
							    LIMITATIONS OF LIABILITY FOR SERVICE AND EQUIPMENT, SETTLEMENT OF DISPUTES BY ARBITRATION INSTEAD OF JURY TRIAL, AS WELL 
							    AS THE TERMS OF MY PLAN AND ANY OPTIONAL SERVICES I HAVE AGREED TO PURCHASE.
						    <cfelseif session.cart.getCarrierId() eq 109>
							    I agree with the terms of the 2-Year Contract Extension
						    </cfif>
						    </label>
					    </div>
				    </cfif>
			    </cfif>
		    </p>
		    <cfif session.cart.getActivationType() CONTAINS "finance">
			    <h4><a href="##" id="agreeToDevicePaymentPlan" data-toggle="modal" data-target="##carrierDocModal">View Terms & Conditions of the #carrierName# Device Payment Plan</a></h4>
			    <div class="form-group form-inline">		
				    <label><input type="checkbox" name="agreeToDevicePaymentPlan" />
				    <cfif session.cart.getCarrierId() eq 42>
					    I HAVE READ AND AGREED TO THE #UCase(carrierName)# CUSTOMER AGREEMENT INCLUDING LIMITATIONS OF LIABILITY FOR SERVICE AND EQUIPMENT, 
					    SETTLEMENT OF DISPUTES BY ARBITRATION INSTEAD OF JURY TRIAL, AS WELL AS THE TERMS OF MY PLAN AND ANY OPTIONAL SERVICES I HAVE AGREED TO PURCHASE.
				    <cfelseif session.cart.getCarrierId() eq 109>	
					    I agree with the terms and conditions specified in the Device Financing Agreement
				    </cfif>
				    </label>
			    </div>
		    </cfif>
		    <cfif session.cart.getCarrierId() eq 42>
			    <p>
				    NOTICE TO BUYER: This is a retail installment sale agreement, not a lease. Do not accept if it contains blank spaces. You have a right to a copy of 
				    this agreement; keep it to protect your rights. You may pay off the full amount at any time. Please review the entire agreement, including the 
				    additional Notice to Buyer provisions, before accepting.
			    </p>
		    
		    <h4>Electronic Acknowledgement</h4>
		    <div class="form-group form-inline">
			    <label><input type="checkbox" name="agreeToDevicePaymentPresented" />
			    <cfif session.cart.getCarrierId() eq 42>
				    I acknowledge that Wireless Advocates has on this date presented me with the above completed Retail Installment Sale Agreement/Notice to Buyer 
				    (the "Agreement") and I have read the Agreement. I agree to all terms and conditions and understand that if I do not accept these terms, my order 
				    will be cancelled and the device will not be shipped.
			    <cfelseif session.cart.getCarrierId() eq 109>	
				    Exact Text TBD
			    </cfif>
			    </label>
		    </div>
        </cfif>
		    <h4><a href="##" id="agreeToCarrierTermsAndConditions" data-toggle="modal" data-target="##carrierDocModal">View #carrierName# Terms &amp; Conditions</a></h4>
		    <div class="form-group form-inline">		
			    <label><input type="checkbox" name="agreeToCarrierTermsAndConditions" />
			    <cfif session.cart.getCarrierId() eq 42>
				    I HAVE READ AND AGREED TO THE #UCase(carrierName)# TERMS AND CONDITIONS FOR SERVICE AGREEMENT
			    <cfelseif session.cart.getCarrierId() eq 109>	
				    I have read and agree to the terms and conditions specified in the AT&T Terms & Conditions
			    </cfif>
			    </label>
		    </div>
      <div class="right">
        <a href="##" class="backBtn" onclick="window.location.href='/CheckoutDB/billShip'">Back</a>
        <button type="submit" class="btn btn-primary continue">Continue</button>
      </div>
    </form>
    </section>
	</div>
	<div class="col-md-4">
      <div class="row">
        <img src="#assetPaths.common#images/content/checkout/CustomerServiceContact.png" />
      </div>
  </div>
    
  
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
      	<button type="button" id="printButton" class="btn btn-default">Print Details</button>
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
