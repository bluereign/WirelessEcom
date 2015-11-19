<cfset assetPaths = application.wirebox.getInstance("AssetPaths") />
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />
<cfset googleAnalyticsTracker = application.wirebox.getInstance("GoogleAnalyticsTracker") />
<cfset mercentAnalyticsTracker = application.wirebox.getInstance("MercentAnalyticsTracker") />

<cfparam name="request.currentTopNav" default="phones" type="string" />
<cfparam name="request.title" default="Costco Wireless - Big Savings on Cell Phones - Offering Plans from Verizon Wireless, AT&T, T-Mobile, and Sprint." type="string" />
<cfparam name="request.MetaDescription" default="Costco Wireless offers big savings on phones from Verizon, AT&amp;T, T-Mobile, and Sprint. In additional to great prices, Costco Wireless offers Free New Activation, Free shipping, and Free Accessories with the phone purchase." type="string" />
<cfparam name="request.MetaKeywords" default="mobile phone,wireless phone,cellular phones,cell phone,cell phone plans,cellular phone service,service plan,cellular phone plans,prepaid plans,wireless phone service,cell phone plans,cell phone accessories,wireless phones,mobile phones,purchase cell phone,buy cell phone,research cell phones,compare cell phone prices,compare cell phones, cell phone comparison,cell service comparison,best cell phone deal,free cell phones,free cellular phones,buy,sold,online,best price,great deals,discount,discounts,specials" type="string" />
<cfparam name="request.includePricingCSS" type="boolean" default="false" />
<cfparam name="request.referringLink" default="#cgi.http_referer#" type="string" />
<cfparam name="request.referringDomain" default="" type="string" />


<cfif len(trim(request.referringLink)) and listLen(request.referringLink, '/') gte 2>
	<cfset request.referringDomain = listGetAt(request.referringLink, 2, '/') />
</cfif>

<cfset request.currentBodyId = listFirst(request.currentTopNav, '.') />

<cfif structKeyExists(url, 'productId') and not isNumeric(trim(url.productId))>
	<cflocation url="/index.cfm" addtoken="false" />
</cfif>

<cfoutput>
	<!DOCTYPE html>
	<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta charset="utf-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
		<title>#request.title#</title>
		<meta name="Description" content="#request.MetaDescription#" />
		<meta name="Keywords" content="#request.MetaKeywords#" />
		<meta name="Title" content="#request.title#" />
		
		<cfinclude template="_cssAndJs.cfm" />

		<meta name="y_key" content="3541dfb9b35b7d6c" />
		<link rel="sitemap" href="http://#cgi.server_name#/sitemap.xml" type="application/xml" />
		<meta name="robots" content="all" />
		<cfif channelConfig.getTrackMercentAnalytics()>
			#mercentAnalyticsTracker.tagPage()#
		</cfif>	
		#googleAnalyticsTracker.tagPage()#
	</head>
	<body id="#request.currentBodyId#" class="membershipWireless">

		<div id="header">
			<div class="shim">
				<div id="header-content">
					<a href="http://www.costco.com" id="WAlogo"><img src="#assetPaths.channel#images/costco_logosm.gif" alt="Costco.Com" title="Return to Costco.com" /></a>
					<a href="/index.cfm/go/content/do/privacy"><img id="topbanner" src="#assetPaths.common#images/onlinebenefit/banner_header_center_privacy.gif" width="440" height="55" border="0" style="left: 200px" /></a>
	
					<form action="/index.cfm/go/search/do/search/" method="get">
						<div id="search">
							<div>
								<cfif isDefined("session.scenario.scenarioType") and session.scenario.scenarioType is "VFD">
									<a href="/mainVFD/homepageVFD" id="homePageLink">Home</a>
								<cfelse>
									<cfif not session.userId>
										<a href="/index.cfm/go/myAccount/do/view/" id="lnkMyAccount">Sign into Your Account</a>
									<cfelse>
										<a href="/index.cfm/go/myAccount/do/view/" id="lnkMyAccount">Your Account</a>
									</cfif>									
								</cfif>
								<cfif arrayLen(session.cart.getLines()) and listFindNoCase(request.config.DeviceBuilder.carriersAllowFullAPIAddToCart,session.cart.getCarrierId(),"|") and session.cart.getActivationType() contains 'finance'>
									<a href="/devicebuilder/orderreview" id="lnkMyCart">Your Cart<cfif isDefined('session.cart') and isStruct(session.cart) and application.model.cartHelper.zipCodeEntered()><cfset cartZipCode = session.cart.getZipCode()> ( #trim(variables.cartZipCode)# )</cfif></a>
								<cfelse>
									<a href="##" onClick="viewCart(); return false;" id="lnkMyCart">Your Cart<cfif isDefined('session.cart') and isStruct(session.cart) and application.model.cartHelper.zipCodeEntered()><cfset cartZipCode = session.cart.getZipCode()> ( #trim(variables.cartZipCode)# )</cfif></a>
								</cfif>
							</div>
							<div id="search-form-container">
								<label for="q">Search</label>
								<cfparam name="request.p.q" default="" type="string" />
								<input type="text" id="q" name="q" value="#htmlEditFormat(request.p.q)#" />
								<input type="submit" value="&##187;" class="searchGo" />
							</div>
						</div>
					</form>
				</div>
				<cfif isDefined("session.scenario.scenarioType") and session.scenario.scenarioType is "VFD">
					
				<cfelse>
					<cfinclude template="_topNav.cfm" />
				</cfif>
			</div>
		</div>
		<div id="mainContent">
			<div class="shim">
				<cfif StructKeyExists(request, 'sublayoutFile') && request.sublayoutfile eq 'customerservice'>
					<cfinclude template="customerservice.cfm" />
				<cfelse>
					#trim(request.bodyContent)#
				</cfif>
			</div>
		</div>
		<div id="footer">
			<div class="shim">
				<!---<cfinclude template="_footerNav.cfm" />--->
				<div id="poweredBy">
					<img alt="" src="/assets/costco/images/Trustwave.gif" />
					<!---<img vspace="10" alt="" src="/assets/costco/images/Braintree.gif" />--->
				</div>
				<div id="brand">
					<a href="/index.cfm/go/content/do/aboutus/"><img title="About Wireless Advocates" alt="Powered By Wireless Advocates" src="/assets/costco/images/WirelessAdvocates_poweredBy_2.gif" /></a>
				</div>
				<!---Output our build version---->
				<cftry>
					#application.buildversion#
					<cfcatch>
						<!--Error outputing build version-->
					</cfcatch>
				</cftry>
						
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
						<li><a href="/index.cfm/go/content/do/supplychain">Supply Chain Disclosure</a></li>
					    <li><a href="/index.cfm/go/content/do/sitemap">Site Map</a></li>
					</ul>
					&copy; Wireless Advocates, LLC 2004 - #Year(Now())#. All Rights Reserved.</div> 
				</div>
			</div>
		</div>
		
		
		<script type="text/javascript" src="#assetPaths.common#scripts/footerContentWindows.js"></script>

		<cfset cartDialogHTML = application.view.cart.addToCartDialogWindow() />
		#trim(variables.cartDialogHTML)#
		

		<!---
		**
		* If promotion code has been passed into URL and it is
		* valid, direct them to the associated bundle.
		**
		--->
		<cfif structKeyExists(request.p, 'promo') and len(trim(request.p.promo))>
			<cfset local.promoResponse = application.view.promotionCodes.checkPromotionCode(promotionCode = trim(request.p.promo)) />

			<cfif listFirst(trim(local.promoResponse), '|') is 'false'>
				<cfset application.model.checkoutHelper.setCheckoutPromotionCode('') />
				<script>alert('#listLast(listLast(trim(local.promoResponse), '|'), '|')#');</script>
				<cfabort />
			</cfif>

			<!--- <script>alert('#listLast(local.couponResponse, '|')#');</script> --->
			<cflocation url="/index.cfm/go/content/do/home/?bundleName=#trim(listGetAt(local.promoResponse, 2, '|'))#" addtoken="false" />
		<cfelseif structKeyExists(request.p, 'coupon') and len(trim(request.p.coupon))>
			<cfset local.couponResponse = application.view.coupon.checkCouponCode(couponCode = trim(request.p.coupon)) />

			<cfif listFirst(trim(local.couponResponse), '|') is 'false'>
				<cfset application.model.checkoutHelper.setCheckoutCouponCode('') />
			</cfif>

			<script>alert('#listLast(local.couponResponse, '|')#');</script>
		</cfif>
	</body>
</html>
</cfoutput>

<cfset request.bodyContent = '' />
