<!---
**
* Include payment gateway form. This will post to the payment
* gateway when the javascript at the bottom of this page is submittted.
**
--->
<cfinclude template="paymentGatewayInclude.cfm" />

<script language="javascript" type="text/javascript">
	$(document).ready(
		function()	{
			showProgress('Proceeding to secure payment gateway.');
			$('#paymentForm').submit();
	});
</script>

<p>If you are not automatically directed to our secure payment gateway within 5 seconds, please click the link below.</p>
<p><a href="##" onclick="$('#paymentForm').submit()">Continue to Payment</a></p>