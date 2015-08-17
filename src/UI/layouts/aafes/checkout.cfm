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
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta charset="utf-8" />
		<title><cfif len(trim(request.title))>#trim(request.title)# : </cfif>Exchange Mobile Center</title>

		<meta http-equiv="X-UA-Compatible" content="IE=EDGE">
		<link rel="stylesheet" media="screen" type="text/css" href="#assetPaths.channel#styles/main.css?v=2.0.5" />
		<link rel="stylesheet" media="screen" type="text/css" href="#assetPaths.channel#styles/navigation.css?v=1.0.0" /> <!-- remove once merged with existing Main and dropdown CSS files -->
		<link rel="stylesheet" media="screen" type="text/css" href="#assetPaths.channel#styles/styles.css?v=1.0.0" /> <!-- remove once merged with existing Main and dropdown CSS files -->

		<link rel="stylesheet" media="screen" type="text/css" href="#assetPaths.common#styles/cartDialog.css?v=1.0.4" />
	    <link rel="stylesheet" media="screen" type="text/css" href="#assetPaths.common#styles/checkout.css?v=1.0.5" />

		<!--- Replaced this with the code below it from the costco version as aafes did not format correctly --->
		<!---<cfif cgi.path_info contains('processPaymentRedirect')>
			<link rel="stylesheet" media="screen" type="text/css" href="/assets/checkout-temp-orderreview.css" />
		</cfif>--->
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
		<div class="topBar">
			<div class="barLinks">
				<div class="linksRight">
					<cfif not session.userId>
						<a href="/index.cfm/go/myAccount/do/view/" id="CartlnkMyAccount">Sign into Your Account</a>
					<cfelse>
						<a href="/index.cfm/go/myAccount/do/view/" id="CartlnkMyAccount">Your Account</a>
					</cfif>
				</div>
			</div>
		</div>

		<div id="LoadingDiva" style="display: none">
			<div class="bg">
				<span id="progressLabel">Please wait, validating address</span>
				<img src="#assetPaths.common#images/ui/bar180.gif" alt="" />
			</div>
		</div>

		<div id="header">
			<div class="shim" style="text-align: center; top: -6px">
				<div id="header-content">
					<a href="/" id="WAlogo"><img src="#assetPaths.channel#images/X_mobile_center_logo.png" alt="Mobile Center" title="" /></a>
				</div>
				<cfinclude template="_topNavCheckout.cfm" />
			</div>
		</div>
		<div id="mainContent">
			<div class="shim">
				<div class="main left">
					#trim(request.bodyContent)#
				</div>
				<div class="sidebar left">
					<cfif request.p.do is not 'thanks'>
						<a href="/index.cfm/go/checkout/do/customer-service/" class="fancy-box" data-fancybox-type="iframe">
							<img src="/assets/aafes/images/skin/CustomerServiceContact.png" />
						</a>
						<br /><br />

						<h2>Checkout</h2>

						<ul class="checkoutSteps">
							<cfif application.model.checkoutHelper.isWirelessOrder()>
								<cfif application.model.checkoutHelper.getCheckoutType() is 'new'>
									<li class="<cfif application.model.checkoutHelper.isStepCompleted('lnp')>complete</cfif> <cfif application.model.checkoutHelper.getCurrentStep() is 'lnp'>active</cfif>">Keep Your Current Number?</li>
								<cfelseif application.model.checkoutHelper.getCheckoutType() is 'add'>
									<li class="<cfif application.model.checkoutHelper.isStepCompleted('wirelessAccount')>complete</cfif> <cfif application.model.checkoutHelper.getCurrentStep() is 'wirelessAccount'>active</cfif>">Existing Account Lookup</li>
									<li class="<cfif application.model.checkoutHelper.isStepCompleted('lnp')>complete</cfif> <cfif application.model.checkoutHelper.getCurrentStep() is 'lnp'>active</cfif>">Keep Your Current Number?</li>
								<cfelse>
									<li class="<cfif application.model.checkoutHelper.isStepCompleted('wirelessAccount')>complete</cfif> <cfif application.model.checkoutHelper.getCurrentStep() is 'wirelessAccount'>active</cfif>">Existing Account Lookup</li>
								</cfif>
							</cfif>
							<cfif application.model.checkoutHelper.isPrepaidOrder()>
								<li class="<cfif application.model.checkoutHelper.isStepCompleted('areaCode')>complete</cfif> <cfif application.model.checkoutHelper.getCurrentStep() is 'areaCode'>active</cfif>">Request Area Code</li>
							</cfif>
							<li class="<cfif application.model.checkoutHelper.isStepCompleted('billShip')>complete</cfif> <cfif application.model.checkoutHelper.getCurrentStep() is 'billShip'>active</cfif>">Billing and Shipping</li>
							<cfif application.model.checkoutHelper.isWirelessOrder()>
								<cfif application.model.checkoutHelper.getCheckoutType() is 'new'>
									<li class="<cfif application.model.checkoutHelper.isStepCompleted('credit')>complete</cfif> <cfif application.model.checkoutHelper.getCurrentStep() is 'credit'>active</cfif>">Carrier Application</li>
								</cfif>
							</cfif>
							<cfif application.model.checkoutHelper.isWirelessOrder() && application.model.checkoutHelper.getCheckoutType() is 'new' && application.model.checkoutHelper.getCarrier() eq 299>
								<li class="<cfif application.model.checkoutHelper.isStepCompleted('securityquestion')>complete</cfif> <cfif application.model.checkoutHelper.getCurrentStep() is 'securityquestion'>active</cfif>">Account Security</li>
							</cfif>
							<li class="<cfif application.model.checkoutHelper.isStepCompleted('review')>complete</cfif> <cfif application.model.checkoutHelper.getCurrentStep() is 'review'>active</cfif>">Review Order</li>
							<cfif application.model.checkoutHelper.isPrepaidOrder()>
								<li class="<cfif application.model.checkoutHelper.isStepCompleted('prepaidcustomerinfo')>complete</cfif> <cfif application.model.checkoutHelper.getCurrentStep() is 'prepaidcustomerinfo'>active</cfif>">Prepaid Customer Info</li>
							<cfelseif application.model.checkoutHelper.isWirelessOrder()>
								<!---<li class="<cfif application.model.checkoutHelper.isStepCompleted('coverage')>complete</cfif> <cfif application.model.checkoutHelper.getCurrentStep() is 'coverage'>active</cfif>">Coverage Check</li>
								<li class="<cfif application.model.checkoutHelper.isStepCompleted('carrierTC')>complete</cfif> <cfif application.model.checkoutHelper.getCurrentStep() is 'carrierTC'>active</cfif>">Carrier Terms</li>--->
								<li class="<cfif application.model.checkoutHelper.isStepCompleted('carrierTerms')>complete</cfif> <cfif application.model.checkoutHelper.getCurrentStep() is 'carrierTerms'>active</cfif>">Carrier Terms</li>
							</cfif>
							<!---<cfif application.model.checkoutHelper.isWirelessOrder()>
								<li class="<cfif application.model.checkoutHelper.isStepCompleted('CustLetter')>complete</cfif> <cfif application.model.checkoutHelper.getCurrentStep() is 'CustLetter'>active</cfif>">#channelConfig.getDisplayName()# Customer Letter</li>
							</cfif>--->
							<li class="<cfif application.model.checkoutHelper.isStepCompleted('Payment')>complete</cfif> <cfif application.model.checkoutHelper.getCurrentStep() is 'Payment'>active</cfif>">Payment</li>
						</ul>
					<cfelse>
						<cfoutput>
							<h2>Order Complete</h2>
							<ul class="orderComplete">
								<li class=""><a href="/index.cfm/go/myAccount/do/viewOrderHistoryDetails/orderId/#request.p.orderId#">View Order</a></li>
								<li class=""><a href="/index.cfm/go/myAccount/do/view/">View Your Account</a></li>
								<li class=""><a href="/">Return to Shopping</a></li>
								<li class=""><a href="/index.cfm/go/content/do/contact">Contact Customer Service</a></li>
							</ul>
						</cfoutput>
					</cfif>
				</div>
			</div>
		</div>

		<div id="footer">
			<div class="shim">
				<div id="poweredBy">
					<img alt="" src="/assets/aafes/images/trustwave_logo_IS.png" />
				</div>
				<div id="brand">
					<a href="/"><img title="Return to homepage" alt="Powered By Wireless Advocates" src="/assets/aafes/images/WA_logo_trans.png" /></a>
				</div>
				<div id="subFooter">
					<ul>
					    <li><a href="/index.cfm/go/content/do/FAQ">FAQ</a></li>
					    <li><a href="/index.cfm/go/content/do/terms">Site Terms and Conditions</a></li>
					    <li><a href="/index.cfm/go/content/do/shipping">Shipping Policy</a></li>
					    <li><a href="/index.cfm/go/content/do/returns">Return Policy</a></li>
					    <li><a href="/index.cfm/go/content/do/serviceAgreement">Carrier Terms and Conditions</a></li>
					    <li><a href="/index.cfm/go/content/do/FAQ">Customer Service</a></li>
					    <li><a href="/index.cfm/go/content/do/rebateCenter">Rebate Center</a></li>
					    <li><a href="/index.cfm/go/content/do/aboutus/">About Us</a></li>
					    <li><a href="/index.cfm/go/content/do/howShop">How to Shop</a></li>
					    <li><a href="/index.cfm/go/content/do/privacy/">Privacy Policy</a></li>
					    <li><a href="/index.cfm/go/content/do/sitemap">Site Map</a></li>
					</ul>
					&copy; Wireless Advocates, LLC 2004 - 2013. All Rights Reserved.
				</div>
			</div>
		</div>
		<script type="text/javascript" language="javascript" src="#assetPaths.common#scripts/footerContentWindows.js"></script>

		<cfset cartDialogHTML = application.view.cart.addToCartDialogWindow() />
		#trim(variables.cartDialogHTML)#

		<script type="text/javascript" language="javascript">
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
