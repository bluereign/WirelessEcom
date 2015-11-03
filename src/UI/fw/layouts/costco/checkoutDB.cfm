<cfparam name="prc.includeTallyBox" default="false" />
<cfparam name="prc.includeTooltip" default="false" />
<cfparam name="rc.type" default="upgrade" /> <!--- upgrade, addaline, new --->
<cfparam name="rc.pid" default="00000" />
<cfparam name="prc.showNav" default="true" />
<cfparam name="prc.showHeader" default="true" />

<cfset assetPaths = application.wirebox.getInstance("AssetPaths") />
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />
<cfset googleAnalyticsTracker = application.wirebox.getInstance("GoogleAnalyticsTracker") />
<cfset mercentAnalyticsTracker = application.wirebox.getInstance("MercentAnalyticsTracker") />

<cfparam name="request.title" default="Costco Wireless - Big Savings on Cell Phones - Offering Plans from Verizon Wireless, AT&T, T-Mobile, and Sprint." type="string" />
<cfparam name="request.MetaDescription" default="Costco Wireless offers big savings on phones from Verizon, AT&amp;T, T-Mobile, and Sprint. In additional to great prices, Costco Wireless offers Free New Activation, Free shipping, and Free Accessories with the phone purchase." type="string" />
<cfparam name="request.MetaKeywords" default="mobile phone,wireless phone,cellular phones,cell phone,cell phone plans,cellular phone service,service plan,cellular phone plans,prepaid plans,wireless phone service,cell phone plans,cell phone accessories,wireless phones,mobile phones,purchase cell phone,buy cell phone,research cell phones,compare cell phone prices,compare cell phones, cell phone comparison,cell service comparison,best cell phone deal,free cell phones,free cellular phones,buy,sold,online,best price,great deals,discount,discounts,specials" type="string" />

<cfoutput>
#html.doctype()#
<html lang="en">
<head>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
<title>#request.title#</title>
<meta name="Description" content="#request.MetaDescription#" />
<meta name="Keywords" content="#request.MetaKeywords#" />
<meta name="Title" content="#request.title#" />
<meta name="y_key" content="3541dfb9b35b7d6c" />
<link rel="sitemap" href="http://#cgi.server_name#/sitemap.xml" type="application/xml" />
<meta name="robots" content="all" />
<cfif channelConfig.getTrackMercentAnalytics()>
	#mercentAnalyticsTracker.tagPage()#
</cfif> 
	#googleAnalyticsTracker.tagPage()#


<!--<cfinclude template="_cssAndJs.cfm" />-->
<!--<link rel="stylesheet" href="/assets/common/scripts/bootstrap/3.2.0-custom/css/bootstrap.min.css" />-->
<!--<script type="text/javascript" src="/assets/common/scripts/bootstrap/3.2.0-custom/js/bootstrap.min.js"></script>-->
<!--<link rel="stylesheet" media="screen" type="text/css" href="#assetPaths.common#styles/checkout.css?v=1.0.5" />-->

  <link rel="stylesheet" href="#assetPaths.channel#styles/devicebuilder.css" />
  <script type="text/javascript" src="#assetPaths.common#scripts/libs/jquery-1.7.2.min.js"></script>
</head>

<body>
	<cfajaximport tags="cfform,cfwindow,cfdiv" scriptsrc="#assetPaths.common#scripts/cfajax/">
	#renderView('CheckoutDB/checkoutHeaderDB')#
	<div id="LoadingDiva" style="display: none">
		<div class="bg">
			<span id="progressLabel">Please wait, validating address</span>
			<img src="#assetPaths.common#images/ui/bar180.gif" alt="" />
		</div>
	</div>
	

	<div class="container nonmodal-container">
		<cfif prc.showNav>
			#renderView('CheckoutDB/checkoutNavDB')#  
		<cfelse>
			<br /><br /><br /><br />
		</cfif>
		<cfoutput>#renderView()#</cfoutput>
	</div>
	#renderView('devicebuilder/pagefooter')#
<script type="text/javascript" src="#assetPaths.common#scripts/devicebuilder.min.js"></script>
  

<cfif listFindNoCase("devicebuilder.protection", event.getCurrentEvent())>

</cfif>

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
