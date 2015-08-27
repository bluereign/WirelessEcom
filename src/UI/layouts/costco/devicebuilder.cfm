<cfparam name="prc.includeTallyBox" default="true" />
<cfparam name="prc.includeTooltip" default="false" />
<cfparam name="rc.type" default="upgrade" /> <!--- upgrade, addaline, new --->
<cfparam name="rc.pid" default="00000" />

<cfset assetPaths = application.wirebox.getInstance("AssetPaths") />
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />
<cfset googleAnalyticsTracker = application.wirebox.getInstance("GoogleAnalyticsTracker") />
<cfset mercentAnalyticsTracker = application.wirebox.getInstance("MercentAnalyticsTracker") />

<cfparam name="request.currentTopNav" default="carrierlogin" type="string" />
<cfparam name="request.title" default="Costco Wireless - Big Savings on Cell Phones - Offering Plans from Verizon Wireless, AT&T, T-Mobile, and Sprint." type="string" />
<cfparam name="request.MetaDescription" default="Costco Wireless offers big savings on phones from Verizon, AT&amp;T, T-Mobile, and Sprint. In additional to great prices, Costco Wireless offers Free New Activation, Free shipping, and Free Accessories with the phone purchase." type="string" />
<cfparam name="request.MetaKeywords" default="mobile phone,wireless phone,cellular phones,cell phone,cell phone plans,cellular phone service,service plan,cellular phone plans,prepaid plans,wireless phone service,cell phone plans,cell phone accessories,wireless phones,mobile phones,purchase cell phone,buy cell phone,research cell phones,compare cell phone prices,compare cell phones, cell phone comparison,cell service comparison,best cell phone deal,free cell phones,free cellular phones,buy,sold,online,best price,great deals,discount,discounts,specials" type="string" />
<cfparam name="request.referringLink" default="#cgi.http_referer#" type="string" />
<cfparam name="request.referringDomain" default="" type="string" />

<cfif len(trim(request.referringLink)) and listLen(request.referringLink, '/') gte 2>
  <cfset request.referringDomain = listGetAt(request.referringLink, 2, '/') />
</cfif>
<cfset request.currentBodyId = listFirst(request.currentTopNav, '.') />

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
  <link rel="stylesheet" href="#assetPaths.channel#styles/devicebuilder.css" />
</head>
<body id="#request.currentBodyId#">
  #renderView('devicebuilder/pageheader')#
<div class="container">
  #renderView('devicebuilder/pagenav')#
  <div class="row main<cfif !prc.includeTallyBox> cart</cfif>">
    #renderView()#
    <cfif prc.includeTallyBox>
      #renderView('devicebuilder/tallybox')#
    </cfif>
  </div>
</div>

#renderView('devicebuilder/pagefooter')#

<script type="text/javascript" src="#assetPaths.common#scripts/devicebuilder.min.js"></script>

<cfif prc.includeTooltip>
  <script type="text/javascript" src="#assetPaths.common#scripts/bootstrap/3.2.0-custom/js/bootstrap.min.js"></script>
  <script type="text/javascript" src="#assetPaths.common#scripts/libs/jquery.validate.min.js"></script>
  <script>
  $(function(){
      $('[data-toggle="tooltip"]').tooltip(); 
  });
  </script>
</cfif>

<cfif listFindNoCase("devicebuilder.carrierlogin", event.getCurrentEvent())>
  #renderView('devicebuilder/upgradeValidate')#
</cfif>

</body>
</html>
</cfoutput>

<cfset request.bodyContent = '' />
