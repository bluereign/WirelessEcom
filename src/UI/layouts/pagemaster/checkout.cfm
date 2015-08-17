<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />
<cfset googleAnalyticsTracker = application.wirebox.getInstance("GoogleAnalyticsTracker") />
<cfset campaignService = application.wirebox.getInstance("CampaignService") />
<cfset campaign = campaignService.getCampaignBySubdomain( campaignService.getCurrentSubdomain() ) />

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
		<title><cfif len(trim(request.title))>#trim(request.title)# : Wireless phone promotion</cfif></title>

		<meta http-equiv="X-UA-Compatible" content="IE=100">
		<link rel="stylesheet" media="screen" type="text/css" href="#assetPaths.channel#styles/main.css?v=2.0.5" />
		<link rel="stylesheet" media="screen" type="text/css" href="#assetPaths.channel#styles/navigation.css?v=1.0.0" /> <!-- remove once merged with existing Main and dropdown CSS files -->
		<link rel="stylesheet" media="screen" type="text/css" href="#assetPaths.channel#styles/styles.css?v=1.0.0" /> <!-- remove once merged with existing Main and dropdown CSS files -->

		<link rel="stylesheet" media="screen" type="text/css" href="#assetPaths.common#styles/cartDialog.css?v=1.0.4" />
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
		<!--- Campaign CSS --->
		<link href="#assetPaths.channel#/styles/campaign-base.css?v=1" rel="stylesheet">
		<cfif IsDefined('campaign')>
			<link href="#assetPaths.channel#/styles/campaigns/#campaign.getSubdomain()#_v#campaign.getVersion()#.css" rel="stylesheet">
		</cfif>
		
		#googleAnalyticsTracker.tagPage()#
	</head>
	<body id="#request.currentBodyId#">
		<div id="top-nav-bar">
			<div id="top-nav-bar-container">
				<ul id="top-nav-links-right">
					<li>
						<cfif not session.userId>
							<a href="/index.cfm/go/myAccount/do/view/" id="lnkMyAccount">Sign into Your Account</a>
						<cfelse>
							<a href="/index.cfm/go/myAccount/do/view/" id="lnkMyAccount">Your Account</a>
						</cfif>	
					</li>
				</ul>
				<div class="clear"></div>				
			</div>
		</div>
		<!--- Loading modal --->
		<div id="LoadingDiva" style="display: none">
			<div class="bg">
				<span id="progressLabel">Please wait, validating address</span>
				<img src="#assetPaths.common#images/ui/bar180.gif" alt="" />
			</div>
		</div>		

		<div id="campaign-header">
		<cfif isDefined('campaign')>
			<a href="/"><img src="/assets/pagemaster/images/campaigns/#campaign.getSubdomain()#_logo_v#campaign.getVersion()#.png" /></a>
		</cfif>
		</div>
		
		<div id="mainContent" style="margin-top: 15px;">
			<div class="shim">
				<div class="main left">
					#trim(request.bodyContent)#
				</div>
				<div class="sidebar left">
					<cfif request.p.do is not 'thanks'>
						<a href="/index.cfm/go/checkout/do/customer-service/" class="fancy-box" data-fancybox-type="iframe">
							<img src="/assets/pagemaster/images/skin/CustomerServiceContact.png" />
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
								<li class="<cfif application.model.checkoutHelper.isStepCompleted('carrierTerms')>complete</cfif> <cfif application.model.checkoutHelper.getCurrentStep() is 'carrierTerms'>active</cfif>">Carrier Terms</li>
							</cfif>
							<cfif channelConfig.getDisplayPrePaymentGatewayPage()>
								<li class="<cfif application.model.checkoutHelper.isStepCompleted('PrePaymentGateway')>complete</cfif> <cfif application.model.checkoutHelper.getCurrentStep() is 'PrePaymentGateway'>active</cfif>">Indentity Verification</li>
							</cfif>
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

		<div id="footer-nav-bar">
			<div id="footer-nav-bar-container">
				<div class="footer-logo-container">
					<img class="footerTrustWaveLogo" src="/assets/aafes/images/trustwave_logo_IS.png" />
				</div>
				<div class="footer-link-container">
					<ul id="foot-links">
					    <li><a href="/index.cfm/go/content/do/FAQ">FAQ</a></li>
					    <li><a href="/index.cfm/go/content/do/terms">Site Terms and Conditions</a></li>
					    <li><a href="/index.cfm/go/content/do/serviceAgreement">Carrier Terms and Conditions</a></li>
					    <li><a href="/index.cfm/go/content/do/FAQ">Customer Service</a></li>
					    <li><a href="/index.cfm/go/content/do/privacy/">Privacy Policy</a></li>
					    <li><a href="/index.cfm/go/content/do/sitemap">Site Map</a></li>
					</ul>
					&copy; Wireless Advocates, LLC 2004 - #Year(Now())#. All Rights Reserved.
				</div>
				<div class="footer-logo-container">
					<img title="Wireless Advocates" alt="Powered By Wireless Advocates" src="/assets/aafes/images/WA_logo_trans.png" />
				</div>
				<div class="clear"></div>
			</div>
		</div>		
		
		<script type="text/javascript" language="javascript" src="#assetPaths.common#scripts/footerContentWindows.js"></script>

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
