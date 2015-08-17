<cfparam name="request.currentTopNav" default="home">

<!--- See if there is a NoContract device in the cart and set flag --->
<cfset NoContractMode = false />
<cfif isdefined("session.cart") and session.cart.getActivationType() is "NoContract">
	<cfset NoContractMode = true />	
</cfif>	

<script>
	viewMilitaryWindow = function (showPage, windowTitle) {
		ColdFusion.Window.create(
				showPage,
				windowTitle,
				'//<cfoutput>#cgi.server_name#</cfoutput>/index.cfm/go/content/do/' + showPage,  
				{ x:50, y:50, height:650, width:535, modal:true, draggable:true, resizable:true, initshow:true, minheight:200, minwidth:200 }
			);
		ColdFusion.Window.show(showPage);
		ColdFusion.Window.onHide(showPage,refreshParent);
	}
</script>
<cfoutput>

<div id="nav-menu-container">
	
	<ul id="nav-menu" class="dropdown dropdown-horizontal">
		<cfif request.p.go eq "cart">
			<li class="dir">
				<a href="/?utm_source=AAFESMOBILE&utm_medium=P-NAV&utm_campaign=ReturnToShopping" col="< Return to Shopping">Return to Shopping</a>
			</li>
			<li class="dir">
				<a href="##?utm_source=AAFESMOBILE&utm_medium=P-NAV&utm_campaign=MilitaryDiscount" onClick="viewMilitaryWindow('MilitaryDiscount', 'Military Discount')" col="Military Discounts">Military Discounts</a>
			</li>
			<li class="dropdown-vertical-rtl dir">
				<a href="##?utm_source=AAFESMOBILE&utm_medium=P-NAV&utm_campaign=MilitaryDeployment" onClick="viewMilitaryWindow('MilitaryDeployment', 'Military Deployment')" col="Military Deployment">Military Deployment</a>
			</li>
		<cfelse>
		
			<li class="dir<cfif listGetAt(request.currentTopNav,1,".") EQ "Home"> active</cfif>">
				<a href="/?utm_source=AAFESMOBILE&utm_medium=P-NAV&utm_campaign=Home" onClick="_gaq.push(['_trackEvent','Navigation','Primary','Home',true]);" class="first header" col="Home">Home</a>
			</li>
			<li class="dir<cfif listGetAt(request.currentTopNav,1,".") EQ "Hot Deals"> active</cfif>">
				<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,238/?utm_source=AAFESMOBILE&utm_medium=P-NAV&utm_campaign=HotDeals" onClick="_gaq.push(['_trackEvent','Navigation','Primary','HotDeals',true]);" class="first header" col="Hot Deals">Hot Deals</a>
			</li>
		    <li class="dir<cfif listGetAt(request.currentTopNav,1,".") EQ "Phones"> active</cfif>">
				<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0/?utm_source=AAFESMOBILE&utm_medium=P-NAV&utm_campaign=Phones" onClick="_gaq.push(['_trackEvent','Navigation','Primary','Phones',true]);">Phones</a>
		        <ul>
		            <li><a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0/?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=ALL-Phones" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','AllPhones',true]);" col="Phones">All Phones</a></li>
		          	<li><a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,1,32/?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=ATT-Phones" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','ATT',true]);" col="Phones">AT&amp;T</a></li>
					<cfif application.model.Carrier.isEnabled(299)>
		            	<li><a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,230,32/?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=SPR-Phones" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Sprint',true]);" col="Phones">Sprint</a></li>
					</cfif>
		            <li><a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,2,32/?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=TMO-Phones" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','TMO',true]);" col="Phones">T-Mobile</a></li>
		            <li><a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,3,32/?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=VZW-Phones" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','VZW',true]);" col="Phones">Verizon Wireless</a></li>
					<!--- Hide the service plans option when a user has a No Contract device in their cart --->
					<cfif not NoContractMode>
		            	<li><a href="/index.cfm/go/shop/do/browsePlans/planFilter.submit/1/filter.filterOptions/0/?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=ServicePlans" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','ServicePlans',true]);" col="Phones">Service Plans</a></li>
					</cfif>
		        </ul>
		    </li>
			<!---<li class="dir<cfif listGetAt(request.currentTopNav,1,".") EQ "tablets"> active</cfif>"">
				<a href="/index.cfm/go/shop/do/browseTablets/tabletFilter.submit/1/filter.filterOptions/0/?utm_source=AAFESMOBILE&utm_medium=P-NAV&utm_campaign=Tablets" class="header" col="Tablets">Tablets</a>
				<ul>
					<li><a href="/index.cfm/go/shop/do/browseTablets/tabletFilter.submit/1/filter.filterOptions/0/?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=ALL_Tablets" col="Tablets">All Tablets</a></li>
					<cfif application.model.Carrier.isEnabled(299)>
						<li><a href="/index.cfm/go/shop/do/browseTablets/tabletFilter.submit/1/filter.filterOptions/0,440/?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=SPR_Tablets" col="Tablets">Sprint</a></li>
					</cfif>
					<cfif application.model.Carrier.isEnabled(42)>
						<li><a href="/index.cfm/go/shop/do/browseTablets/tabletFilter.submit/1/filter.filterOptions/0,439/?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=VZW_Tablets" col="Tablets">Verizon Wireless</a></li>
					</cfif>
				</ul>
			</li>--->
		    <li class="dir<cfif listGetAt(request.currentTopNav,1,".") EQ "dataCardsAndNetbooks"> active</cfif>">
				<a href="/index.cfm/go/shop/do/browseDataCardsAndNetBooks/dataCardAndNetBookFilter.submit/1/filter.filterOptions/0/?utm_source=AAFESMOBILE&utm_medium=P-NAV&utm_campaign=MobileHotspots" onClick="_gaq.push(['_trackEvent','Navigation','Primary','MobileHotspots',true]);" col="Mobile Hotspots">Mobile Hotspots</a>
		        <ul>
		            <li><a href="/index.cfm/go/shop/do/browseDataCardsAndNetbooks/dataCardAndNetbookFilter.submit/1/filter.filterOptions/0,0,69/?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=ALL_MobileHotspots" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','MobileHotspots',true]);" col="Mobile Hotspots">Mobile Hotspots</a></li>
		            <li><a href="/index.cfm/go/shop/do/browseDataCardsAndNetbooks/dataCardAndNetbookFilter.submit/1/filter.filterOptions/0,0,70/?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=ALL_DataCards" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','DataCards',true]);" col="Mobile Hotspots">Data Cards</a></li>
		            <!---<li><a href="/index.cfm/go/shop/do/browsePrePaids/prePaidFilter.submit/1/filter.filterOptions/69,70/?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=PrepaidDevices" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','PrepaidDevices',true]);" col="Mobile Hotspots">Prepaid Devices</a></li>--->  <!--- This link is the same as Prepaid at the Primary Nav level --->
		        </ul>
		    </li>
		    <li class="dir<cfif listGetAt(request.currentTopNav,1,".") EQ "Prepaid"> active</cfif>">
				<a href="/index.cfm/go/shop/do/browsePrePaids/prePaidFilter.submit/1/filter.filterOptions/0/?utm_source=AAFESMOBILE&utm_medium=P-NAV&utm_campaign=Prepaid" onClick="_gaq.push(['_trackEvent','Navigation','Primary','Prepaid',true]);">Prepaid</a>
		        <ul>
		            <li><a href="/index.cfm/go/shop/do/browsePrePaids/prePaidFilter.submit/1/filter.filterOptions/0/?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=ALL_Prepaid" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','AllPhones',true]);" col="Prepaid">All Phones</a></li>
		            <li><a href="/index.cfm/go/shop/do/browsePrePaids/prePaidFilter.submit/1/filter.filterOptions/0,71/?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=ATT_Prepaid" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','ATT',true]);" col="Prepaid">AT&amp;T</a></li>
		            <li><a href="/index.cfm/go/shop/do/browsePrePaids/prePaidFilter.submit/1/filter.filterOptions/0,375/?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=BM_Prepaid" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','BoostMobile',true]);" col="Prepaid">Boost Mobile</a></li>
		            <li><a href="/index.cfm/go/shop/do/browsePrePaids/prePaidFilter.submit/1/filter.filterOptions/0,72/?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=TMO_Prepaid" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','TMO',true]);" col="Prepaid">T-Mobile</a></li>
		            <li><a href="/index.cfm/go/shop/do/browsePrePaids/prePaidFilter.submit/1/filter.filterOptions/0,73/?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=VZW_Prepaid" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','VZW',true]);" col="Prepaid">Verizon Wireless</a></li>
		        </ul>
		    </li>
		    <li class="dir<cfif listGetAt(request.currentTopNav,1,".") EQ "Accessories"> active</cfif>">
				<a href="/index.cfm/go/shop/do/accessories/?utm_source=AAFESMOBILE&utm_medium=P-NAV&utm_campaign=ACCESSORIES" onClick="_gaq.push(['_trackEvent','Navigation','Primary','Accessories',true]);" col="Accessories">Accessories</a>
		        <ul>
		            <li><a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/0/?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=ALL_ACCESSORIES" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','AllAccessories',true]);" col="Accessories">All Accessories</a></li>
		            <li><a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/377/?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=Batteries" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Batteries',true]);" col="Accessories">Batteries</a></li>
		            <li><a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/376/?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=Bluetooth" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Bluetooth',true]);" col="Accessories">Bluetooth</a></li>
		            <li><a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/56/?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=Cases" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','Cases',true]);" col="Accessories">Cases</a></li>
		            <li><a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/57/?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=ChargersAndAdaptors" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','ChargersAndAdaptors',true]);" col="Accessories">Chargers & Adaptors</a></li>
		            <li><a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/280/?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=DocksAndMounts" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','DocksAndMounts',true]);" col="Accessories">Docks & Mounts</a></li>
		            <li><a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/58/?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=HeadphonesAndSpeakers" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','HeadphonesAndSpeakers',true]);" col="Accessories">Headphones & Speakers</a></li>
		            <li><a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/59/?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=ScreenProtectors" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','ScreenProtectors',true]);" col="Accessories">Screen Protectors</a></li>
		        </ul>
		    </li>
		    <li class="dir<cfif listGetAt(request.currentTopNav,1,".") EQ "tools"> active</cfif>">
				<a href="/index.cfm/go/content/do/toolshome?utm_source=AAFESMOBILE&utm_medium=P-NAV&utm_campaign=ToolsAndResources" onClick="_gaq.push(['_trackEvent','Navigation','Primary','ToolsAndResources',true]);" col="ToolsResources">Tools & Resources</a>
		        <ul>
		            <li><a href="http://exchangemobilecenter.cexchange.com/online/Home/CategorySelected.rails?pcat=2&utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=TradeUpAndSave" col="ToolsResources">Trade Up and Save</a></li>
		            <li><a href="/index.cfm/go/shop/do/upgrade-checker?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=CheckUpgradeEligibility" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','CheckUpgradeEligibility',true]);" col="ToolsResources">Check Upgrade Eligibility</a></li>
		            <li><a href="/index.cfm/go/content/do/militaryDiscountPage?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=MilitaryDiscount" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','MilitaryDiscount',true]);" col="ToolsResources">Military Discount</a></li>
		            <li><a href="/index.cfm/go/content/do/militaryDeploymentPage?utm_source=AAFESMOBILE&utm_medium=S-NAV&utm_campaign=MilitaryDeployment" onClick="_gaq.push(['_trackEvent','Navigation','Secondary','MilitaryDeployment',true]);" col="ToolsResources">Military Deployment</a></li>
		        </ul>
		    </li>
		</cfif>
	</ul>
</div>	
</cfoutput>