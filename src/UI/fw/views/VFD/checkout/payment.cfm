<cfset GatewayRegistry = application.wirebox.getInstance("PaymentProcessorRegistry")>
<cfset cardTypes = GatewayRegistry.listPaymentMethods() >

<!---<cfset assetPaths = application.wirebox.getInstance("assetPaths")>
<cfinclude template="/views/checkout/paymentGatewayInclude.cfm" />
<cfset GatewayRegistry = application.wirebox.getInstance("PaymentProcessorRegistry")>
<cfset cardTypes = GatewayRegistry.listPaymentMethods() >--->

<cfset assetPaths = application.wirebox.getInstance("assetPaths")>
<cfinclude template="/views/checkout/paymentGatewayInclude.cfm" />
<script language="javascript" type="text/javascript">
	$(document).ready(
		function()	{
			showProgress('Proceeding to secure payment gateway.');
			$('#paymentForm').submit();
	});
</script>

<p>If you are not automatically directed to our secure payment gateway within 5 seconds, please click the link below.</p>
<p><a href="##" onclick="$('#paymentForm').submit()">Continue to Payment</a></p>



