<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />
<cfset googleAnalyticsTracker = application.wirebox.getInstance("GoogleAnalyticsTracker") />
<cfset mercentAnalyticsTracker = application.wirebox.getInstance("MercentAnalyticsTracker") />

<cfparam name="request.currentTopNav" default="phones" type="string" />
<cfparam name="request.title" default="Checkout" type="string" />
<!---<cfparam name="request.currentTopNav" default="phones" type="string" />
<cfparam name="request.includePricingCSS" type="boolean" default="false" />--->

<cfset request.currentBodyId = listFirst(request.currentTopNav, '.') />

<!--- New --->
<cfparam name="request.IsSidebarIncluded" default="true" type="boolean" />

<cfoutput>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
		<title><cfif len(trim(request.title))>#trim(request.title)# : </cfif>#ChannelConfig.getDisplayName()#</title>

		<meta http-equiv="X-UA-Compatible" content="IE=EDGE">
		<link rel="stylesheet" media="screen" type="text/css" href="#assetPaths.channel#styles/main.css?v=1.0.6" />
		<!--- Note: Controls in line menu inside nav bar --->
		<link rel="stylesheet" media="screen" type="text/css" href="#assetPaths.channel#styles/dropdown.css" />	
		<!--- Note: Controls padding on top of nav bar --->
	    <link rel="stylesheet" media="screen" type="text/css" href="#assetPaths.common#styles/checkout.css?v=1.0.4" />

		<link rel="stylesheet" media="screen" type="text/css" href="#assetPaths.common#scripts/bootstrap-3.0.2-dist/dist/css/bootstrap.css" />

		<script type="text/javascript" src="#assetPaths.common#scripts/libs/jquery-1.7.2.min.js"></script>
		<script type="text/javascript" src="#assetPaths.common#scripts/libs/jquery.validate.min.js"></script>
		
		<script type="text/javascript" src="#assetPaths.common#scripts/libs/jquery.maskedinput-1.3.min.js"></script>
		
		<script type="text/javascript" src="#assetPaths.common#scripts/bootstrap-3.0.2-dist/dist/js/bootstrap.min.js"></script>
		
		
	<!---	<script type="text/javascript" src="#assetPaths.common#scripts/checkoutmain.js?v=1.0.2"></script>
	--->	

		<cfif channelConfig.getTrackMercentAnalytics()>
			#mercentAnalyticsTracker.tagPage()#
		</cfif>
		#googleAnalyticsTracker.tagPage()#
	</head>
	<body id="#request.currentBodyId#">

		<div id="header">
			<div class="shim" style="text-align: center; top: -6px">
				<div id="header-checkout">
					<a id="WAlogo" href="http://www.costco.com/" style="padding-top: 10px; padding-left: 25px"><img src="#assetPaths.channel#images/costco_logosm.gif" alt="Costco.Com" title="Return to the Costco.com homepage" /></a>
					<img src="#assetPaths.common#images/onlinebenefit/banner_header_center_final.jpg" width="440" height="55" border="0" />
				</div>
				<cfinclude template="_topNavCheckout.cfm" />
			</div>
		</div>
		
<style>
	.checkout-breadcrumb {
		
	}
	
	.checkout-breadcrumb > li {
		border: 1px solid ##bbb;
		padding: 12px 5px;
		border-radius: 5px;
		margin-bottom: 5px;
		text-align: center;
		background-color: ##eee;
	}
	
	.form-section {
		border: 1px solid ##bbb;
		padding: 15px;
		border-radius: 5px;
		background-color: ##eee;
		margin-bottom: 20px;
	}

	/* Override max length*/
	.container {
		margin-right: auto;
		margin-left: auto;
		max-width: 960px;
	}
	
	
	.modal-header {
		background: ##eee;
		border-radius: 5px 5px 0 0;
	}	
	
	.whats-this {
		text-decoration: none;
		cursor: help;
		margin-left: 5px;
		font-size: .9em;
	}		
</style>
		
		<cfif request.IsSidebarIncluded>
			<div class="container">
				<div class="row">
					<div class="col-md-9">#trim(request.bodyContent)#</div>
					<div class="col-md-3">
						<ul class="checkout-breadcrumb">
							<li>Phone Number</li>
							<li>Billing and Shipping</li>
							<li>Carrier Application</li>
							<li>Order Review</li>
							<li>Payment</li>
						</ul>
					</div>
				</div>
			</div>
		<cfelse>
			<div class="container">
				<div class="row">
					<div class="col-md-12">#trim(request.bodyContent)#</div>
				</div>
			</div>
		</cfif>

		<div class="checkoutFooter">
			<div id="footer">
				<div class="shortBar">&nbsp;</div>
				<div class="shim">
					<div id="poweredBy">
						<img alt="" src="/assets/costco/images/Trustwave.gif" />
						<!---<img vspace="10" alt="" src="/assets/costco/images/Braintree.gif" />--->
					</div>
					<div id="brand">
						<a href="/"><img title="Return to homepage" alt="Powered By Wireless Advocates" src="/assets/costco/images/WirelessAdvocates_poweredBy_2.gif" /></a>
					</div>
					<div id="subFooter">
						<ul>
						    <li><a href="/index.cfm/go/content/do/FAQ">FAQ</a></li>
						    <li><a href="/index.cfm/go/content/do/terms">Site Terms and Conditions</a></li>
						    <li><a href="/index.cfm/go/content/do/shipping">Shipping Policy</a></li>
						    <li><a href="/index.cfm/go/content/do/returns">Return Policy</a></li>
						    <li><a href="/index.cfm/go/content/do/serviceAgreement">Carrier Terms and Conditions</a></li>
						    <li><a href="/index.cfm/go/content/do/customerService">Customer Service</a></li>
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
		</div>
	</body>
</html>
</cfoutput>

<cfset request.bodycontent = '' />
