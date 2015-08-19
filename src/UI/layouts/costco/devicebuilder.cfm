<cfset assetPaths = application.wirebox.getInstance("AssetPaths") />
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />
<cfset googleAnalyticsTracker = application.wirebox.getInstance("GoogleAnalyticsTracker") />
<cfset mercentAnalyticsTracker = application.wirebox.getInstance("MercentAnalyticsTracker") />

<cfparam name="rc.includeTallyBox" default="true" />

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

<!DOCTYPE html>
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
  <cfinclude template="_cssAndJs.cfm" />
</head>
<body id="#request.currentBodyId#">

<div class="container">
  <header class="header">
    <div class="content row">
      <div class="col-md-3">
        <a href="http://www.costco.com" id="WAlogo"><img src="#assetPaths.channel#images/costco_logosm.gif" alt="Costco.Com" title="Return to Costco.com" /></a>
      </div>
      <div class="col-md-6">
        <p class="disclaimer">You are no longer on Costco's site and are subject to the privacy policy of the company hosting this site. To review the privacy policy, <a href="/index.cfm/go/content/do/privacy">Click here</a>.</p>
      </div>
      <div class="col-md-3 account">
        <a href="/index.cfm/go/myAccount/do/view/" id="lnkMyAccount">Sign into Your Account</a>
      </div>
    </div>
    <ul class="nav nav-pills nav-justified">
      <li role="presentation" <cfif rc.event is "devicebuilder.carrierlogin">class="active" </cfif>><a href="/default.cfm/devicebuilder/carrierlogin/">Carrier Login</a></li>
      <li role="presentation" <cfif rc.event is "devicebuilder.upgrade">class="active" </cfif>><a href="/default.cfm/devicebuilder/upgrade/">Upgrade/Add a Line</a></li>
      <li role="presentation" <cfif rc.event is "devicebuilder.plans">class="active" </cfif>><a href="/default.cfm/devicebuilder/plans">Plans and Data</a></li>
      <li role="presentation" <cfif rc.event is "devicebuilder.payment">class="active" </cfif>><a href="/default.cfm/devicebuilder/payment">Payment, Protection, and Services</a></li>
      <li role="presentation" <cfif rc.event is "devicebuilder.accessories">class="active" </cfif>><a href="/default.cfm/devicebuilder/accessories">Accessories</a></li>
      <li role="presentation" <cfif rc.event is "devicebuilder.orderreview">class="active" </cfif>><a href="/default.cfm/devicebuilder/orderreview">Order Review</a></li>
    </ul>
  </header>
  <div class="row main">
    <div class="col-md-9">
      #trim(request.bodyContent)#
    </div>
    <cfif rc.includeTallyBox>
    <!--- Tally Box --->
      <div class="col-md-3">
        <div class="row totals">
          <div class="col-xs-6">
            Due Now <br> $0.00
          </div>
          <div class="col-xs-6">
            Monthly <br> $66.67
          </div>
        </div>
        <div class="row">
          <aside class="details">
            <h3>Upgrading Line 1</h3>
            <div class="row">
              <div class="col-xs-3">
                <img src="https://placeholdit.imgix.net/~text?txtsize=12&txt=50px&w=50&h=50" alt="device picture" />
              </div>
              <div class="col-xs-9">
                <div class="name">Manufacturer Name, Device Name &amp; Model, Memory, Color, etc.</div>
                <div class="table-responsive">
                  <table class="table">
                    <thead>
                      <th colspan="2">Carrier Financing Name</th>
                    </thead>
                    <tr>
                      <td>Due Monthly for XX Months</td>
                      <td class="price">$21.67/mo*</td>
                    </tr>
                    <tr>
                      <td>Regular Price</td>
                      <td class="price">$999.99</td>
                    </tr>
                    <tr>
                      <td>Due Today*</td>
                      <td class="price">$0.00 Down</td>
                    </tr>
                    <tr>
                      <td>Line Access Fee</td>
                      <td class="price">$45.00</td>
                    </tr>
                  </table>
                </div>
              </div>
            </div>

            <h4>Carrier Plan</h4>
            <div class="row">
              <div class="col-xs-3">
                <img src="https://placeholdit.imgix.net/~text?txtsize=12&txt=50px&w=50&h=50" alt="carrier plan picture" />
              </div>
              <div class="col-xs-9">
                <div class="table-responsive">
                  <table class="table">
                    <tr>
                      <td>Not selected</td>
                      <td class="price">$0.00</td>
                    </tr>
                  </table>
                </div>
              </div>
            </div>
            <h4>Protection &amp; Services</h4>
            <div class="row">
              <div class="col-xs-3">
              </div>
              <div class="col-xs-9">
                <div class="table-responsive">
                  <table class="table">
                    <tr>
                      <td>Not selected</td>
                      <td class="price">$0.00</td>
                    </tr>
                  </table>
                </div>
              </div>
            </div>
            <h4>Accessories</h4>
            <div class="row">
              <div class="col-xs-3">
                <img src="https://placeholdit.imgix.net/~text?txtsize=12&txt=50px&w=50&h=50" alt="accessories picture" />
              </div>
              <div class="col-xs-9">
                <div class="table-responsive">
                  <table class="table">
                    <tr>
                      <td>Costco Membership Benefits</td>
                      <td class="price">FREE</td>
                    </tr>
                  </table>
                </div>
              </div>
            </div>
          </aside>
        </div>
      </div>
    <!--- /Tally Box --->
    </cfif>


  </div>

  <footer class="footer row">
    <div class="col-md-3">
      <img alt="" src="/assets/costco/images/Trustwave.gif" alt="Trustwave" class="trustwave">
    </div>
    <div class="footer-links col-md-6">
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
        &copy; Wireless Advocates, LLC 2004 - 2015. All Rights Reserved.
      </div>
    </div>
    <div class="col-md-3">
      <a href="/index.cfm/go/content/do/aboutus/"><img title="About Wireless Advocates" alt="Powered By Wireless Advocates" src="/assets/costco/images/WirelessAdvocates_poweredBy_2.gif" /></a>
    </div>
  </footer>
</div>


</body>
</html>

</cfoutput>

<cfset request.bodyContent = '' />
