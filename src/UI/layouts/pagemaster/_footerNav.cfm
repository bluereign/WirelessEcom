<cfparam name="request.currentTopNav" default="home">

<cfoutput>
	<ul class="Nav" style="width: 970px; margin-left: auto; margin-right: auto">
		<li class="first">
			<a href="/index.cfm/go/content/do/phonesHome/" class="first">Phones</a>
			<ul>
				<li><a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0/">All Phones</a></li>
				<cfif application.model.Carrier.isEnabled(109)>
					<li><a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,1,32/">AT&amp;T</a></li>
				</cfif>
				<cfif application.model.Carrier.isEnabled(128)>
					<li><a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,2,35/">T-Mobile</a></li>
				</cfif>
				<cfif application.model.Carrier.isEnabled(42)>
					<li><a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,3,32/">Verizon Wireless</a></li>
				</cfif>
				<cfif application.model.Carrier.isEnabled(299)>
					<li><a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,230,32/">Sprint</a></li>
				</cfif>
				<li><a href="/index.cfm/go/shop/do/browsePrePaids/prePaidFilter.submit/1/filter.filterOptions/0/">Prepaid Phones</a></li>
			</ul>
		</li>
		<li>
			<a href="/index.cfm/go/content/do/plansHome/">Service Plans</a>
			<ul>
				<cfif application.model.Carrier.isEnabled(109)>
					<li><a href="/index.cfm/go/shop/do/browsePlans/planFilter.submit/1/filter.filterOptions/0,36,39,40/">AT&amp;T</a></li>
				</cfif>
				<cfif application.model.Carrier.isEnabled(128)>
					<li><a href="/index.cfm/go/content/do/T-Mobile-Plans">T-Mobile</a></li>
				</cfif>
				<cfif application.model.Carrier.isEnabled(42)>
					<li><a href="/index.cfm/go/shop/do/browsePlans/planFilter.submit/1/filter.filterOptions/0,38,39,40/">Verizon Wireless</a></li>
				</cfif>
				<cfif application.model.Carrier.isEnabled(299)>
					<li><a href="/index.cfm/go/shop/do/browsePlans/planFilter.submit/1/filter.filterOptions/0,231,39,40/">Sprint</a></li>
				</cfif>
				<li><a href="/index.cfm/go/shop/do/browsePlans/planFilter.submit/1/filter.filterOptions/0,39/">Individual Plans</a></li>
				<li><a href="/index.cfm/go/shop/do/browsePlans/planFilter.submit/1/filter.filterOptions/0,40/">Family Plans</a></li>
			</ul>
		</li>
		<li>
			<a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/0/">Accessories</a>
			<ul>
				<li><a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/58/" col="Accessories">Audio</a></li>
				<li><a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/56/" col="Accessories">Cases</a></li>
				<li><a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/57/" col="Accessories">Chargers</a></li>
				<li><a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/59/" col="Accessories">Screen Protectors</a></li>
				<li><a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/280/" col="Accessories">Vehicle Docks</a></li>
			</ul>
		</li>
		<li>
			<a href="/index.cfm/go/shop/do/browseDataCardsAndNetbooks/dataCardAndNetbookFilter.submit/1/filter.filterOptions/0/" style="width:145px;">Mobile Hotspots</a>
			<ul>
				<li><a href="/index.cfm/go/shop/do/browseDataCardsAndNetbooks/dataCardAndNetbookFilter.submit/1/filter.filterOptions/0,0,69/" style="width:145px;">Mobile Hotspots</a></li>
				<li><a href="/index.cfm/go/shop/do/browseDataCardsAndNetbooks/dataCardAndNetbookFilter.submit/1/filter.filterOptions/0,0,70/" style="width:145px;">Data Cards</a></li>
				<li><a href="/index.cfm/go/shop/do/browseDataCardsAndNetbooks/dataCardAndNetbookFilter.submit/1/filter.filterOptions/69,70/" style="width:145px;">Prepaid Devices</a></li>
			</ul>
		</li>
		<li>
			<a href="/index.cfm/go/content/do/summary/action/general">Policies</a>
			<ul>
				<li><a href="/index.cfm/go/content/do/FAQ">FAQ</a></li>
				<li><a href="/index.cfm/go/content/do/shipping">Shipping Policy</a></li>
				<li><a href="/index.cfm/go/content/do/returns">Return Policy</a></li>
				<li><span class='termscond'><a href="/index.cfm/go/content/do/serviceAgreement">Carrier Terms &amp; Conditions</a></span></li>
				<li><a href="/index.cfm/go/content/do/supplychain">Supply Chain Disclosure</a></li>
			</ul>
		</li>
	</ul>
</cfoutput>