<cfset assetPaths = application.wirebox.getInstance("assetPaths") />

<cfif application.model.CheckoutHelper.getCarrier() eq 128>
	<cfset request.p.file = "#assetPaths.common#docs/prepaidcustomerinfo/tmobile_prepaid.pdf" />
<cfelseif application.model.CheckoutHelper.getCarrier() eq 42>
	<cfset request.p.file = "#assetPaths.common#docs/prepaidcustomerinfo/Verizon_Prepaid_Customer_Letter.pdf" />
<cfelseif application.model.CheckoutHelper.getCarrier() eq 81>
	<cfset request.p.file = application.model.checkoutHelper.getCarrierTermsFile() />
<cfelse>
	<cfset request.p.file = '' />
</cfif>

<!--- include payment gateway form. this will post to the payment gateay when the javascript at the bottom of this page is submittted --->
<cfinclude template="paymentGatewayInclude.cfm">

<cfoutput>
<h1>Prepaid Customer Information</h1>
</cfoutput>
	
<!--- show any errors --->
<cfoutput>
	<cfif isDefined("request.validator") and  request.validator.HasMessages()>
		<div class="form-errorsummary">
			#request.validatorView.ValidationSummary(request.validator.getMessages())#
		</div>
	</cfif>
</cfoutput>
<!--- end show any errors --->


<cfoutput>
<p>
	<a href="#request.p.file#" target="_blank">Open the Prepaid Customer Information in a new window</a> (optional)
</p>

<embed class="pdfletter" src="#request.p.file#" width="600" height="330"></embed>
</cfoutput>

<cfoutput>
<form id="terms" class="cmxform" action="/index.cfm/go/checkout/do/processCustomerInfo/" method="post">

    <fieldset>
        <ol>
            
            <li class="full">
            	<input type="radio" name="terms" id="noAgree" value="decline"/><label for="noAgree" class="check">No, I do not agree to the above Prepaid Customer Information</label>
            </li>
            <li class="full">
            	<input type="radio" name="terms" id="agree" value="agree"/><label for="agree" class="check bold">Yes, I agree to the above Prepaid Customer Information</label>
            </li>
        </ol>	
    </fieldset>
    
	<div class="formControl">
    	
        <span class="actionButtonLow">
			<a href="##" onclick="window.location.href='/index.cfm/go/checkout/do/orderConfirmation/'">Back</a>
		</span>
		<span class="actionButton">
			<a href="##" onclick="submitWATerms();">Proceed to Payment</a>
		</span>
	</div>
</form>
</cfoutput>	

<script language="javascript" type="text/javascript">
	function submitWATerms()
	{
		//handle the submit form, if not accept, then use the regular post. If accept, then go to the payement gateway.
		if( $('#agree').attr("checked") )
		{
			<!--- uses the paymentGatewayForm.cfm that is included at the top of this page --->
			$("#paymentForm").attr("action","<cfif !GatewayRegistry.hasMultipleRegistered()><cfoutput>#formAction#</cfoutput><cfelse>/index.cfm/go/checkout/do/PaymentOptions/</cfif>");
			$("#paymentForm").get(0).submit();
		}
		else
		{
			$('#terms').get(0).submit();
		}
	}
</script>