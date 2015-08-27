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

<div class="container">
  <header class="header">
    <div class="content row">
      <div class="col-md-4">
        <a href="http://www.costco.com" class="logo"><img src="#assetPaths.channel#images/costco_logosm.gif" alt="Costco.Com" title="Return to Costco.com"></a>
      </div>
      <div class="col-md-8">
        <p class="disclaimer">You are no longer on Costco's site and are subject to the privacy policy of the company hosting this site. To review the privacy policy, <a href="/index.cfm/go/content/do/privacy">click here</a>.</p>
      </div>
      <div class="col-md-4 account">
        <ul>
          <li><a href="/index.cfm/go/myAccount/do/view/" id="lnkMyAccount">Sign into Your Account</a></li>
          <li class="cart"><a href="##">Your Cart</a></li>
        </ul>
        <div class="form-group form-inline search">
          <label for="inputSearch">Search</label>
          <input type="text" class="form-control" id="inputSearch">
          <button type="submit" class="btn-search">Search</button>
        </div>
      </div>
    </div>
  </header>
</div>

<!--- <Blue Nav placeholder --->
<div class="container-fluid top-nav">
  <div class="container">
    <nav class="navbar navbar-static-top" role="navigation">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="##bs-example-navbar-collapse-1">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
        </div>
        <div class="collapse navbar-collapse fade" id="bs-example-navbar-collapse-1">
          <ul class="nav navbar-nav nav-tabs">
            <li role="presentation"><a href="##">Home</a></li>
            <li role="presentation"><a href="##">Hot Deals</a></li>
            <li role="presentation" class="active"><a href="##">Phones</a></li>
            <li role="presentation"><a href="##">Mobile Hotspot</a></li>
            <li role="presentation"><a href="##">Accessories</a></li>
            <li role="presentation"><a href="##">Check Upgrade Eligibility</a></li>
          </ul>
        </div>
      </div>
    </nav>
  </div>
</div> <!--- <end blue nav placeholder --->

<div class="container">
  <!--- <Navigation --->
  <div class="head">
    <ul class="nav nav-pills nav-justified">
      <cfloop index="i" from="1" to="#arrayLen(prc.navItemsAction)#">
        <cfset navUrl = event.buildLink('devicebuilder.#prc.navItemsAction[i]#') & '/pid/' & rc.pid & '/type/' & rc.type & '/'>
        <li role="presentation" 
          <cfif listGetAt(rc.event,2,'.') is prc.navItemsAction[i]>
            class="active"<cfelse>class="hidden-xs
            <cfif i lt listFindNoCase(arrayToList(prc.navItemsAction), listGetAt(rc.event,2,'.'))>complete</cfif>"
          </cfif>
          >
          <a href="#navUrl#"><span>#i#</span>#prc.navItemsText[i]#</a>
        </li>
      </cfloop>
    </ul>
  </div> <!--- <end navigation --->

  <!--- <Container And Views --->
  <div class="row main<cfif !prc.includeTallyBox> cart</cfif>">
    <!--- <p>You are now running <strong>#getSetting("codename",1)# #getSetting("version",1)# (#getsetting("suffix",1)#)</strong>.</p> --->
    #renderView()#
    <cfif prc.includeTallyBox>
      #renderView('devicebuilder/tallybox')#
    </cfif>
  </div>
</div> <!--- <end container --->

<!--- <Footer --->
<footer class="container-fluid footer">
  <div class="container">
    <div class="row">
      <div class="col-md-4">
        <img alt="" src="#assetPaths.channel#images/Trustwave.gif" alt="Trustwave" class="trustwave">
      </div>
      <div class="col-md-8">
        <div class="footer-links">
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
          <div class="copyright">
            &copy; Wireless Advocates, LLC 2004 - #Year(Now())#. All Rights Reserved.
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <a href="/index.cfm/go/content/do/aboutus/" class="wireless">
          <img title="About Wireless Advocates" alt="Powered By Wireless Advocates" src="#assetPaths.channel#images/WirelessAdvocates_poweredBy_2.gif">
        </a>
      </div>
    </div>
  </div>
</footer>
<!--- <end footer --->


<script type="text/javascript" src="#assetPaths.common#scripts/devicebuilder.min.js"></script>

<!--- <Activate Tooltips --->
<cfif prc.includeTooltip>
  <script type="text/javascript" src="#assetPaths.common#scripts/bootstrap/3.2.0-custom/js/bootstrap.min.js"></script>
  <script>
  $(function(){
      $('[data-toggle="tooltip"]').tooltip(); 
  });
  </script>
</cfif>
<!--- <end activate tooltips --->

</body>
</html>
</cfoutput>

<cfset request.bodyContent = '' />
