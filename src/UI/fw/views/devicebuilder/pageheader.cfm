<cfoutput>
  <div class="container">
    <header class="header">
      <div class="content row">
        <div class="col-md-4">
          <a href="http://www.costco.com" class="logo"><img src="#assetPaths.channel#images/costco_logosm.gif" alt="Costco.Com" title="Return to Costco.com"></a>
        </div>
        <div class="col-md-8">
          <p class="disclaimer"></p>
        </div>
        <div class="col-md-4 account">
          <ul>
            <li><a href="/index.cfm/go/myAccount/do/view/" id="lnkMyAccount">Sign into Your Account</a></li>
            <li class="cart"><a href="#event.buildLink('devicebuilder.orderreview')#">Your Cart</a></li>
          </ul>
          <div class="form-group form-inline search">
            <form id="searchForm" action="/index.cfm/go/search/do/search/" method="get">
              <label for="inputSearch">Search</label>
              <input type="text" name="q" class="form-control" id="inputSearch">
              <button type="submit" class="btn-search">Search</button>
            </form>
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
          <div class="collapse navbar-collapse oldHeader" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav nav-tabs">
              <cfif event.getCurrentAction() is not "orderreview">
                <li role="presentation">
                  <a href="##">Return to Shopping</a>
                </li>
                <cfelse>
                  <li role="presentation">
                    <a href="/" class="first header" onClick="_gaq.push(['_trackEvent','Navigation','Primary','Home',true]);">Home</a>
                  </li>
                  <li role="presentation">
                    <a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,238" class="first header" onClick="_gaq.push(['_trackEvent','Navigation','Primary','Hot_Deals',true]);" col="Hot Deals">Hot Deals</a>
                  </li>
                  <li role="presentation"  class="dropdown">
                    <a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0/" class="first header" onClick="_gaq.push(['_trackEvent','Navigation','Primary','Phones',true]);" col="Phones">Phones</a>
                    <ul class="dropdown-menu">
                      <li>
                        <a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','All_Phones',,true]);" col="Phones">All Phones</a>
                      </li>
                      <cfif application.model.Carrier.isEnabled(109)>
                        <li>
                          <a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,1,32/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','ATT_Phones',true]);" col="Phones">AT&amp;T</a>
                        </li>
                      </cfif>
                      <cfif application.model.Carrier.isEnabled(128)>
                        <li>
                          <a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,2,32/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','TMO_Phones',true]);" col="Phones">T-Mobile</a>
                        </li>
                      </cfif>
                      <cfif application.model.Carrier.isEnabled(42)>
                        <li>
                          <a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,3,32/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','VZW_Phones',true]);" col="Phones">Verizon Wireless</a>
                        </li>
                      </cfif>
                      <cfif application.model.Carrier.isEnabled(299)>
                        <li>
                          <a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,230,32/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','SPR_Phones',true]);" col="Phones">Sprint</a>
                        </li>
                      </cfif>
                      <li>
                        <a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,33/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Upgrade_My_Phone',true]);" col="Phones">Upgrade my Phone</a>
                      </li>
                      <li>
                        <a href="/index.cfm/go/shop/do/browsePrePaids/prePaidFilter.submit/1/filter.filterOptions/0/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Prepaid_Phones',true]);" col="Phones">Prepaid Phones</a>
                      </li>
                      <li>
                        <a href="/index.cfm/go/shop/do/browsePlans/planFilter.submit/1/filter.filterOptions/0/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Service_Plan',true]);" col="Phones">Service Plans</a>
                      </li>
                      <li>
                        <a href="#channelconfig.getCEXCHANGE()#/online/Home/CategorySelected.rails?pcat=2" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Trade_In_My_Phone',true]);" col="Phones">Trade in my Phone</a>
                      </li>
                    </ul>
                  </li>
                  <li role="presentation"  class="dropdown">
                    <a href="/index.cfm/go/shop/do/browseDataCardsAndNetBooks/dataCardAndNetBookFilter.submit/1/filter.filterOptions/0/" class="header" onClick="_gaq.push(['_trackEvent','Navigation','Primary','Mobile_Hotspots',true]);" col="Mobile Hotspots">Mobile Hotspots</a>
                    <ul class="dropdown-menu">
                      <li>
                        <a href="/index.cfm/go/shop/do/browseDataCardsAndNetbooks/dataCardAndNetbookFilter.submit/1/filter.filterOptions/0,0,69/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Mobile_Hotspots',true]);" col="Mobile Hotspots">Mobile Hotspots</a>
                      </li>
                      <li>
                        <a href="/index.cfm/go/shop/do/browseDataCardsAndNetbooks/dataCardAndNetbookFilter.submit/1/filter.filterOptions/0,0,70/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Data_Cards',true]);" col="Mobile Hotspots">Data Cards</a>
                      </li>
                      <li>
                        <a href="/index.cfm/go/shop/do/browsePrePaids/prePaidFilter.submit/1/filter.filterOptions/69,70/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Prepaid_Devices',true]);" col="Mobile Hotspots">Prepaid Devices</a>
                      </li>
                    </ul>
                  </li>
                  <li role="presentation"  class="dropdown">
                    <a href="/index.cfm/go/shop/do/accessories/" class="header" onClick="_gaq.push(['_trackEvent','Navigation','Primary','Accessories',true]);" col="Accessories">Accessories</a>
                    <ul class="dropdown-menu">
                      <li>
                        <a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/0/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','All_Accessories',true]);" col="Accessories">All Accessories</a>
                      </li>
                      <li>
                        <a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/377/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Batteries_Accessories',true]);" col="Accessories">Batteries</a>
                      </li>
                      <li>
                        <a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/376/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Bluetooth_Accessories',true]);" col="Accessories">Bluetooth</a>
                      </li>
                      <li>
                        <a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/56/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Cases_Accessories',true]);" col="Accessories">Cases</a>
                      </li>
                      <li>
                        <a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/57/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Chargers-Adapters_Accessories',true]);" col="Accessories">Chargers & Adapters</a>
                      </li>
                      <li>
                        <a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/280/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Docks-Mounts_Accessories',true]);" col="Accessories">Docks & Mounts</a>
                      </li>
                      <li>
                        <a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/58/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Headphones-Speakers_Accessories',true]);" col="Accessories">Headphones & Speakers</a>
                      </li>
                      <li>
                        <a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/59/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','ScreenProtectors_Accessories',true]);" col="Accessories">Screen Protectors</a>
                      </li>
                    </ul>
                  </li>
                  <li role="presentation">
                    <a href="##">Check Upgrade Eligibility</a>
                  </li>
                </cfif>
            </ul>
            <!--<cfinclude template="../../../layouts/costco/_topNav.cfm" /> --->
          </div>
        </div>
      </nav>
    </div>
  </div> <!--- <end blue nav placeholder --->
</cfoutput>
