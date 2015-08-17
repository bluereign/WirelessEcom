<cfset GatewayRegistry = application.wirebox.getInstance("PaymentProcessorRegistry")>
<cfset cardTypes = GatewayRegistry.listPaymentMethods() >

<cfset assetPaths = application.wirebox.getInstance("assetPaths")>

<cfoutput>
	<script type="text/javascript">
		var $j = jQuery.noConflict();
		$j(document).ready(function($j){
				var h = $j(window).height();
				var w = $j(window).width();
				window.open("/CheckoutVFD/carrierActivation", 'carrierActivation', 'width='+(w*.5)+', height='+h+', top=0, left=0,menubar=yes,toolbar=yes,resizable=1,scrollbars=1,personalbar=1');
				window.location.href = "http://wa2go-test.wirelessadvocates.llc/";
				//switch(carrierID){
				//	case 109: //ATT
				//		window.open(this.href, 'carrierActivation', 'width='+(w*.5)+', height='+h+', top=0, left=0,menubar=yes,toolbar=yes,resizable=1,scrollbars=1,personalbar=1');
				//		//window.location.href(this.href, 'carrierActivation');
				//		break;
				//	case 128: //TMobile
				//		window.open(this.href, 'carrierActivation', 'width='+(w*.5)+', height='+h+', top=0, left=0,menubar=yes,toolbar=yes,resizable=1,scrollbars=1,personalbar=1');
				//		break;
				//	case 42:  //Verizon
				//		window.open(this.href, 'carrierActivation', 'width='+(w*.5)+', height='+h+', top=0, left=0,menubar=yes,toolbar=yes,resizable=1,scrollbars=1,personalbar=1');
				//	case 299:  //Sprint
				//		window.open(this.href, 'carrierActivation', 'width='+(w*.5)+', height='+h+', top=0, left=0,menubar=yes,toolbar=yes,resizable=1,scrollbars=1,personalbar=1');
				//	break;
				//	default:
		});

	</script>
</cfoutput>