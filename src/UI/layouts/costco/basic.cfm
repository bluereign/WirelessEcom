<cfset assetPaths = application.wirebox.getInstance("AssetPaths") />
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />
<cfset googleAnalyticsTracker = application.wirebox.getInstance("GoogleAnalyticsTracker") />
<cfset mercentAnalyticsTracker = application.wirebox.getInstance("MercentAnalyticsTracker") />
<cfparam name="request.title" default="Costco Wireless - Big Savings on Cell Phones - Offering Plans from Verizon Wireless, AT&T, T-Mobile, and Sprint." type="string" />
<cfparam name="request.MetaDescription" default="Costco Wireless offers big savings on phones from Verizon, AT&T, T-Mobile, and Sprint. In additional to great prices, Costco Wireless offers Free New Activation, Free shipping, and Free Accessories with the phone purchase." type="string" />
<cfparam name="request.MetaKeywords" default="mobile phone,wireless phone,cellular phones,cell phone,cell phone plans,cellular phone service,service plan,cellular phone plans,prepaid plans,wireless phone service,cell phone plans,cell phone accessories,wireless phones,mobile phones,purchase cell phone,buy cell phone,research cell phones,compare cell phone prices,compare cell phones, cell phone comparison,cell service comparison,best cell phone deal,free cell phones,free cellular phones,buy,sold,online,best price,great deals,discount,discounts,specials" type="string" />

<cfoutput>
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
			<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
			<title>#request.title#</title>
			<meta name="Description" content="#request.MetaDescription#" />
			<meta name="Keywords" content="#request.MetaKeywords#" />
			<meta name="Title" content="#request.title#" />
			<link rel="stylesheet" type="text/css" href="#assetPaths.channel#styles/main.css?v=1.0.7" />
			<cfif channelConfig.getTrackMercentAnalytics()>
				#mercentAnalyticsTracker.tagPage()#
			</cfif>	
			#googleAnalyticsTracker.tagPage()#
		</head>
		<body>
			#trim(request.bodyContent)#
		</body>
	</html>
</cfoutput>

<cfset request.bodyContent = '' />