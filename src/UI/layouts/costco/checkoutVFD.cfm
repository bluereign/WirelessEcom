<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />
<cfset googleAnalyticsTracker = application.wirebox.getInstance("GoogleAnalyticsTracker") />
<cfset mercentAnalyticsTracker = application.wirebox.getInstance("MercentAnalyticsTracker") />

<cfparam name="request.currentTopNav" default="phones" type="string" />
<cfparam name="request.title" default="Checkout" type="string" />
<cfparam name="request.currentTopNav" default="phones" type="string" />
<cfparam name="request.includePricingCSS" type="boolean" default="false" />

<cfset request.currentBodyId = listFirst(request.currentTopNav, '.') />

<cfoutput>
<cfinclude template="_cssAndJs.cfm" />
<link rel="stylesheet" href="/assets/common/scripts/bootstrap/3.2.0-custom/css/bootstrap.min.css" />
<script type="text/javascript" src="/assets/common/scripts/prototype-bootstrap-conflict.js?v=1.0.0"></script>
<script type="text/javascript" src="/assets/common/scripts/bootstrap/3.2.0-custom/js/bootstrap.min.js"></script>
<link rel="stylesheet" media="screen" type="text/css" href="#assetPaths.common#styles/checkout.css?v=1.0.5" />
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta charset="utf-8" />
		<title><cfif len(trim(request.title))>#trim(request.title)# : </cfif>#ChannelConfig.getDisplayName()#</title>

		<meta http-equiv="X-UA-Compatible" content="IE=EDGE">
		<link rel="stylesheet" media="screen" type="text/css" href="#assetPaths.channel#styles/main.css?v=1.0.6" />
		<link rel="stylesheet" media="screen" type="text/css" href="#assetPaths.channel#styles/dropdown.css" />
		<link rel="stylesheet" media="screen" type="text/css" href="#assetPaths.common#styles/cartDialog.css?v=1.0.3" />
	    <link rel="stylesheet" media="screen" type="text/css" href="#assetPaths.common#styles/checkout.css?v=1.0.5" />

		<cfif cgi.path_info contains('processPaymentRedirect')>
			<link rel="stylesheet" media="screen" type="text/css" href="#assetPaths.common#styles/checkout-temp-orderreview.css" />
		</cfif>
		<link rel="stylesheet" media="screen" type="text/css" href="#assetPaths.common#styles/checkoutSteps.css" />

		<script type="text/javascript" src="#assetPaths.common#scripts/libs/jquery-1.7.2.min.js"></script>
		<script type="text/javascript" src="#assetPaths.common#scripts/checkoutmain.js?v=1.0.2"></script>
		<script type="text/javascript" src="#assetPaths.common#scripts/libs/jquery.maskedinput-1.3.min.js"></script>
		<link rel="stylesheet" href="#assetPaths.common#scripts/fancybox/source/jquery.fancybox.css?v=2.0.6" type="text/css" media="screen" />
		<script type="text/javascript" src="#assetPaths.common#scripts/fancybox/source/noconflict-jquery.fancybox.js?v=2.0.6"></script>
		<cfif channelConfig.getTrackMercentAnalytics()>
			#mercentAnalyticsTracker.tagPage()#
		</cfif>
		#googleAnalyticsTracker.tagPage()#
	</head>
	<body id="#request.currentBodyId#">
		<div id="LoadingDiva" style="display: none">
			<div class="bg">
				<span id="progressLabel">Please wait, validating address</span>
				<img src="#assetPaths.common#images/ui/bar180.gif" alt="" />
			</div>
		</div>
		<div>
			<div class="shim" style="text-align: left; top: 6px">
				<div id="header-checkout">
					<a id="WAlogo" href="http://www.costco.com/" style="padding-top: 10px; padding-left: 5px"><img src="#assetPaths.channel#images/costco_logosm.gif" alt="Costco.Com" title="Return to the Costco.com homepage" /></a>
					<a href="/index.cfm/go/content/do/privacy"><img id="topbanner" src="#assetPaths.common#images/onlinebenefit/banner_header_center_privacy.gif" width="440" height="55" border="0" style="left: 200px" /></a>
					<!---<img src="#assetPaths.common#images/onlinebenefit/banner_header_center_v2.jpg" width="440" height="55" border="0" />--->
				</div>
				<br/>
				<div id="carrier" name="carrier" >
					<cfset local.carrierID = application.model.checkoutHelper.getCarrier()/>
					<cfif local.carrierId eq "109"> <!--- ATT --->
						<img src="#assetPaths.common#images/content/rebatecenter/att.jpg" width="117" height="51">
        			<cfelseif local.carrierId eq "128"> <!--- TMOBILE --->
						<img src="#assetPaths.common#images/content/rebatecenter/TM_authdealerlogo.jpg" width="150" height="25">
					<cfelseif local.carrierId eq "42"> <!--- VERIZON --->
						<img src="#assetPaths.common#images/carrierLogos/verizon_175.gif" />
					<cfelseif local.carrierId eq "299"> <!--- SPRINT --->
						<img src="#assetPaths.common#images/content/rebatecenter/sprint.jpg" width="117" height="51">
					</cfif>
				</div>
				<br/>
				<br/>
			</div>
		</div>
		<div id="mainContent" style="padding:10px;">
			<!---<div class="shim">
				<div class="main left">--->
					<cfoutput>#renderView()#</cfoutput>
				<!---</div>--->
				<!---<div class="sidebar left">
						<a href="/index.cfm/go/checkout/do/customer-service/" class="fancy-box" data-fancybox-type="iframe">
							<img src="#assetPaths.common#images/content/checkout/CustomerServiceContact.png" />
						</a>
						<br /><br />

						<h2>Checkout</h2>

						<ul class="checkoutSteps">
							<li class="<cfif application.model.checkoutHelper.isStepCompleted('billShip')>complete</cfif> <cfif application.model.checkoutHelper.getCurrentStep() is 'billShip'>active</cfif>">Billing and Shipping VFD</li>
							<li class="<cfif application.model.checkoutHelper.isStepCompleted('review')>complete</cfif> <cfif application.model.checkoutHelper.getCurrentStep() is 'review'>active</cfif>">Review Order</li>
							<li class="<cfif application.model.checkoutHelper.isStepCompleted('Payment')>complete</cfif> <cfif application.model.checkoutHelper.getCurrentStep() is 'Payment'>active</cfif>">Payment</li>
						</ul>
				</div>--->
			<!---</div>--->
		</div>
		<script type="text/javascript" src="#assetPaths.common#scripts/footerContentWindows.js"></script>

		<!---<cfset cartDialogHTML = application.view.cart.addToCartDialogWindow() />
		#trim(variables.cartDialogHTML)#--->

		<script type="text/javascript">
			function showProgress(message)	{
				var msg = 'Processing, please wait.';

				try	{
					if(message.length > 0)	{
						msg	= message;
					}
				}
				catch(e)	{	}

				var messageEl = document.getElementById('progressLabel');
					messageEl.innerHTML = msg;
				var ldiv = document.getElementById('LoadingDiva');
					ldiv.style.display = 'block';
			}

			function hideProgress()	{
				var ldiv = document.getElementById('LoadingDiva');
					ldiv.style.display = 'none';
			}
		</script>
	</body>
</html>
</cfoutput>

<cfset request.bodycontent = '' />
