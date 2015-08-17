<cfset assetPaths = application.wirebox.getInstance("AssetPaths") />
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />
<cfset googleAnalyticsTracker = application.wirebox.getInstance("GoogleAnalyticsTracker") />
<cfset campaignService = application.wirebox.getInstance("CampaignService") />
<cfset campaign = campaignService.getCampaignBySubdomain( campaignService.getCurrentSubdomain() ) />

<cfparam name="request.currentTopNav" default="phones" type="string" />
<cfparam name="request.title" default="Wireless phone promotion - Big Savings on Cell Phones - Offering Plans from Verizon Wireless and Sprint." type="string" />
<cfparam name="request.MetaDescription" default="Big savings on phones from Verizon Wireless and Sprint. In additional to great prices, PageMaster offers Free New Activation, Free shipping, and Free Accessories with the phone purchase." type="string" />
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
		<meta http-equiv="X-UA-Compatible" content="IE=100" />
		<title>#request.title#</title>
		<meta name="Description" content="#request.MetaDescription#" />
		<meta name="Keywords" content="#request.MetaKeywords#" />
		<meta name="Title" content="#request.title#" />
		
		<cfinclude template="_cssAndJs.cfm" />

		<meta http-equiv="pragma" content="no-cache" />
		<meta name="y_key" content="3541dfb9b35b7d6c" />
		<link rel="sitemap" href="http://#cgi.server_name#/sitemap.xml" type="application/xml" />
		<meta name="robots" content="all" />
		<!--- Campaign CSS --->
		<link href="#assetPaths.channel#/styles/campaign-base.css?v=1" rel="stylesheet">
		<cfif IsDefined('campaign')>
			<link href="#assetPaths.channel#/styles/campaigns/#campaign.getSubdomain()#_v#campaign.getVersion()#.css" rel="stylesheet">
		</cfif>
		
		#googleAnalyticsTracker.tagPage()#
	</head>
	<body id="#request.currentBodyId#" class="Pagemaster">

		<div id="top-nav-bar">
			<div id="top-nav-bar-container">
				<ul id="top-nav-links-left">
					<li class="last"><a href="/index.cfm/go/content/do/FAQ">Customer Service</a></li>
				</ul>
				<ul id="top-nav-links-right">
					<li><a href="##" onClick="viewCart(); return false;">Your Cart<cfif isDefined('session.cart') and isStruct(session.cart) and application.model.cartHelper.zipCodeEntered()><cfset cartZipCode = session.cart.getZipCode()> ( #trim(variables.cartZipCode)# )</cfif></a></li>
					<li class="last">
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

		<div id="campaign-header">
			<cfif isDefined('campaign')>
				<a href="/"><img src="/assets/pagemaster/images/campaigns/#campaign.getSubdomain()#_header_v#campaign.getVersion()#.png" /></a>
			</cfif>
		</div>
		
		<div id="menu-nav-container">
			<ul id="pagemaster-menu-nav">
				<!--- check for existence/value of variables to set the active class for the appropriate page --->
				<li><a href="/catalog/list"<cfif ( structKeyExists( url, 'priceDisplayType' ) AND findNoCase( 'new', url.priceDisplayType ) ) OR ( structKeyExists( url, 'activationtype' ) AND findNoCase( 'new', url.activationtype ) )> class="pagemaster-menu-nav-active"</cfif>>Sign Up For A New Account</a></li>
				<li><a href="/catalog/list/activationtype/upgrade"<cfif ( structKeyExists( url, 'activationtype' ) AND findNoCase( 'upgrade', url.activationtype ) ) OR ( findNoCase( 'upgrade-checker', request.p.do ) )> class="pagemaster-menu-nav-active"</cfif>>Renew/Upgrade Existing Account</a></li>
				<!--- NOTE: request.p.do for layouts\pagemaster\main, event.getCurrentAction() for fw\layouts\pagemaster\main --->		
				<li><a href="/index.cfm/go/shop/do/browsePhones"<cfif findNoCase( 'browsePhones', request.p.do )> class="pagemaster-menu-nav-active"</cfif>>See Other Smartphone Deals</a></li>
			</ul>
		</div>

		<div id="mainContent" style="margin-top: 15px;">
			<div class="shim">
				<cfif StructKeyExists(request, 'sublayoutFile') && request.sublayoutfile eq 'customerservice'>
					<cfinclude template="customerservice.cfm" />
				<cfelseif findNoCase('myAccount', request.currentTopNav)>
					<div style="padding: 0 15px 0 15px;">
						#trim(request.bodyContent)#
					</div>
				<cfelse>
					#trim(request.bodyContent)#
				</cfif>
			</div>
		</div>
		
		<div id="footer-nav-bar">
			<div id="footer-nav-bar-container">
				<div class="footer-logo-container">
					<img class="footerTrustWaveLogo" src="/assets/aafes/images/trustwave_logo_IS.png" />
				</div>
				<div class="footer-link-container">
					<ul id="foot-links">
					    <li><a href="/index.cfm/go/content/do/FAQ">FAQxxxxxx</a></li>
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
		
		<script type="text/javascript" src="#assetPaths.common#scripts/footerContentWindows.js"></script>

		<cfset cartDialogHTML = application.view.cart.addToCartDialogWindow() />
		#trim(variables.cartDialogHTML)#

	</body>
</html>
</cfoutput>

<cfset request.bodyContent = '' />
