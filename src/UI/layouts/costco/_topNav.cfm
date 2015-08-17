<cfparam name="request.currentTopNav" default="home">

<cfoutput>
<div id="nav-menu-container">
	<ul id="nav-menu" class="dropdown dropdown-horizontal">
		<li class="first header<cfif listGetAt(request.currentTopNav,1,".") EQ "home"> active</cfif>" style="width: 70px">
			<a href="/" class="first header" onClick="_gaq.push(['_trackEvent','Navigation','Primary','Home',true]);">Home</a>
		</li>
		<li class="header">
			<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,238" class="first header" onClick="_gaq.push(['_trackEvent','Navigation','Primary','Hot_Deals',true]);" col="Hot Deals">Hot Deals</a>
		</li>		
		<li class="header<cfif listGetAt(request.currentTopNav,1,".") EQ "phones"> active</cfif>">
			<!---<a href="/index.cfm/go/content/do/phonesHome/" class="first header" onClick="_gaq.push(['_trackEvent','Navigation','Primary','Phones',true]);" col="Phones">Phones</a>--->
			<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0/" class="first header" onClick="_gaq.push(['_trackEvent','Navigation','Primary','Phones',true]);" col="Phones">Phones</a>
			<ul class="nav-submenu">
				<li><a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','All_Phones',,true]);" col="Phones">All Phones</a></li>
				<cfif application.model.Carrier.isEnabled(109)>
					<li><a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,1,32/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','ATT_Phones',true]);" col="Phones">AT&amp;T</a></li>
				</cfif>
				<cfif application.model.Carrier.isEnabled(128)>
					<li><a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,2,32/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','TMO_Phones',true]);" col="Phones">T-Mobile</a></li>
				</cfif>
				<cfif application.model.Carrier.isEnabled(42)>
					<li><a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,3,32/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','VZW_Phones',true]);" col="Phones">Verizon Wireless</a></li>
				</cfif>
				<cfif application.model.Carrier.isEnabled(299)>
					<li><a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,230,32/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','SPR_Phones',true]);" col="Phones">Sprint</a></li>
				</cfif>
				<li><a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,33/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Upgrade_My_Phone',true]);" col="Phones">Upgrade my Phone</a></li>
				<li><a href="/index.cfm/go/shop/do/browsePrePaids/prePaidFilter.submit/1/filter.filterOptions/0/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Prepaid_Phones',true]);" col="Phones">Prepaid Phones</a></li>
	            <li><a href="/index.cfm/go/shop/do/browsePlans/planFilter.submit/1/filter.filterOptions/0/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Service_Plan',true]);" col="Phones">Service Plans</a></li>
				<li><a href="#channelconfig.getCEXCHANGE()#/online/Home/CategorySelected.rails?pcat=2" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Trade_In_My_Phone',true]);" col="Phones">Trade in my Phone</a></li>
			</ul>
		</li>
		
		<!---<li class="header<cfif listGetAt(request.currentTopNav,1,".") EQ "tablets"> active</cfif>">
			<a href="/index.cfm/go/shop/do/browseTablets/tabletFilter.submit/1/filter.filterOptions/0/" class="header" onClick="_gaq.push(['_trackEvent','Navigation','Primary','Tablets',true]);" col="Tablets">Tablets</a>
			<ul class="nav-submenu">
				<li><a href="/index.cfm/go/shop/do/browseTablets/tabletFilter.submit/1/filter.filterOptions/0/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','All_Tablets',true]);" col="Tablets">All Tablets</a></li>
				<cfif application.model.Carrier.isEnabled(42)>
					<li><a href="/index.cfm/go/shop/do/browseTablets/tabletFilter.submit/1/filter.filterOptions/0,439/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','VZW_Tablets',true]);" col="Tablets">Verizon Wireless</a></li>
				</cfif>
				<cfif application.model.Carrier.isEnabled(299)>
					<li><a href="/index.cfm/go/shop/do/browseTablets/tabletFilter.submit/1/filter.filterOptions/0,440/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','SPR_Tablets',true]);" col="Tablets">Sprint</a></li>
				</cfif>
				<li><a href="#channelconfig.getCEXCHANGE()#/online/Home/CategorySelected.rails?pcat=30" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Trade_In_My_Tablet',true]);" col="Tablets">Trade in my Tablet</a></li>
			</ul>
		</li>--->
		
		<li class="header<cfif listGetAt(request.currentTopNav,1,".") EQ "dataCardsAndNetbooks"> active</cfif>">
			<a href="/index.cfm/go/shop/do/browseDataCardsAndNetBooks/dataCardAndNetBookFilter.submit/1/filter.filterOptions/0/" class="header" onClick="_gaq.push(['_trackEvent','Navigation','Primary','Mobile_Hotspots',true]);" col="Mobile Hotspots">Mobile Hotspots</a>
			<ul>
				<li><a href="/index.cfm/go/shop/do/browseDataCardsAndNetbooks/dataCardAndNetbookFilter.submit/1/filter.filterOptions/0,0,69/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Mobile_Hotspots',true]);" col="Mobile Hotspots">Mobile Hotspots</a></li>
				<li><a href="/index.cfm/go/shop/do/browseDataCardsAndNetbooks/dataCardAndNetbookFilter.submit/1/filter.filterOptions/0,0,70/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Data_Cards',true]);" col="Mobile Hotspots">Data Cards</a></li>
				<li><a href="/index.cfm/go/shop/do/browsePrePaids/prePaidFilter.submit/1/filter.filterOptions/69,70/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Prepaid_Devices',true]);" col="Mobile Hotspots">Prepaid Devices</a></li>
			</ul>
		</li>

		<li class="header<cfif listGetAt(request.currentTopNav,1,".") EQ "accessories"> active</cfif>">
			<!---<a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/0/" class="header" onClick="_gaq.push(['_trackEvent','Navigation','Primary','Accessories',true]);" col="Accessories">Accessories</a>--->
			<a href="/index.cfm/go/shop/do/accessories/" class="header" onClick="_gaq.push(['_trackEvent','Navigation','Primary','Accessories',true]);" col="Accessories">Accessories</a>
			<ul class="nav-submenu">
				<li><a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/0/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','All_Accessories',true]);" col="Accessories">All Accessories</a></li>
				<li><a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/377/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Batteries_Accessories',true]);" col="Accessories">Batteries</a></li>
				<li><a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/376/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Bluetooth_Accessories',true]);" col="Accessories">Bluetooth</a></li>
				<li><a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/56/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Cases_Accessories',true]);" col="Accessories">Cases</a></li>
				<li><a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/57/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Chargers-Adapters_Accessories',true]);" col="Accessories">Chargers & Adapters</a></li>
				<li><a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/280/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Docks-Mounts_Accessories',true]);" col="Accessories">Docks & Mounts</a></li>
				<li><a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/58/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Headphones-Speakers_Accessories',true]);" col="Accessories">Headphones & Speakers</a></li>
				<li><a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/59/" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','ScreenProtectors_Accessories',true]);" col="Accessories">Screen Protectors</a></li>
			</ul>
		</li>

		<li class="header<cfif listGetAt(request.currentTopNav,1,".") EQ "upgrades"> active</cfif>">
			<a href="/index.cfm/go/shop/do/upgrade-checker" class="header" onClick="_gaq.push(['_trackEvent','Navigation','Primary','CheckUpgradeEligibility',true]);" col="Upgrades">Check Upgrade Eligibility</a>
		</li>
	</ul>
</div>	
</cfoutput>

