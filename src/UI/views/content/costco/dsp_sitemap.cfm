

<cfscript>
	qPhones = application.model.phone.getAll( bActiveOnly = true );
	qPrepaid = application.model.prepaid.getAll( bActiveOnly = true );
	qPlan = application.model.plan.getAll( bActiveOnly = true );
	qAccessories = application.model.accessory.getAll( bActiveOnly = true, bIncludeBundled = false );
	qDataCards = application.model.DataCardAndNetBook.getAll( bActiveOnly = true );
	stringUtil = application.wirebox.getInstance( "StringUtil" );
</cfscript>

<style>
	.sitemap li {
		font-size:10pt;
		padding-left: 25px;
	}
	
	.sitemap ul {
		font-size:10pt;
		padding-left: 25px;
	}
</style>

<h2>Site Map</h2>

<ul class="sitemap">
	<li><a href="http://membershipwireless.com/index.cfm/go/content/do/phonesHome/">Phones</a></li>
	<ul>
		<li><a href="http://membershipwireless.com/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0/">All Phones</a></li>
		<ul>
			<cfoutput query="qPhones">
				<cfset sesTitle = stringUtil.friendlyUrl( qPhones.detailTitle ) />
				<li><a href="/#qPhones.ProductId#/#sesTitle#">#qPhones.DetailTitle#</a></li>
			</cfoutput>
		</ul>
		<cfoutput query="qPhones" group="CarrierId">
				<cfswitch expression="#CarrierId#">
					<cfcase value="109">
						<li><a href="http://membershipwireless.com/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,1,32/">AT&T</a></li>
					</cfcase>
					<cfcase value="128">
						<li><a href="http://membershipwireless.com/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,2,32/">T-Mobile</a></li>
					</cfcase>
					<cfcase value="42">
						<li><a href="http://membershipwireless.com/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,3,32/">Verizon Wireless</a></li>
					</cfcase>
					<cfcase value="299">
						<li><a href="http://membershipwireless.com/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,230,32/">Sprint</a></li>
					</cfcase>						
				</cfswitch>
			<ul>
				<cfoutput>
					<cfset sesTitle = stringUtil.friendlyUrl( qPhones.detailTitle ) />
					<li><a href="/#qPhones.ProductId#/#sesTitle#">#qPhones.DetailTitle#</a></li>
				</cfoutput>
			</ul>
		</cfoutput>
		<li><a href="http://membershipwireless.com/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,33/">Upgrade your phone</a></li>
		<li><a href="http://membershipwireless.com/index.cfm/go/shop/do/browsePrePaids/prePaidFilter.submit/1/filter.filterOptions/0/">Prepaid Phones</a></li>
		<cfoutput query="qPrepaid">
			<ul>
				<li><a href="http://membershipwireless.com/index.cfm/go/shop/do/PrePaidDetails/productid/#ProductId#">#DetailTitle#</a></li>
			</ul>
		</cfoutput>		
	</ul>
	<li><a href="http://membershipwireless.com/index.cfm/go/content/do/plansHome/">Service Plans</a></li>
	<ul>
		<li><a href="http://membershipwireless.com/index.cfm/go/shop/do/browsePlans/planFilter.submit/1/filter.filterOptions/0/">All Plans</a></li>
		<cfoutput query="qPlan" group="CarrierId">
			<cfswitch expression="#CarrierId#">
				<cfcase value="109">
					<li><a href="http://membershipwireless.com/index.cfm/go/shop/do/browsePlans/planFilter.submit/1/filter.filterOptions/0,36,39,40/">AT&T</a></li>
				</cfcase>
				<cfcase value="128">
					<li><a href="http://membershipwireless.com/index.cfm/go/shop/do/browsePlans/planFilter.submit/1/filter.filterOptions/0,37,39,40/">T-Mobile</a></li>
				</cfcase>
				<cfcase value="42">
					<li><a href="http://membershipwireless.com/index.cfm/go/shop/do/browsePlans/planFilter.submit/1/filter.filterOptions/0,38,39,40/">Verizon Wireless</a></li>
				</cfcase>
				<cfcase value="299">
					<li><a href="http://membershipwireless.com/index.cfm/go/shop/do/browsePlans/planFilter.submit/1/filter.filterOptions/0,231,39,40/">Sprint</a></li>
				</cfcase>								
			</cfswitch>
			<ul>
				<cfoutput>
					<li><a href="http://membershipwireless.com/index.cfm/go/shop/do/planDetails/planId/#ProductId#">#DetailTitle#</a></li>
				</cfoutput>
			</ul>
		</cfoutput>
	</ul>
	<li><a href="http://membershipwireless.com/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,33/">Upgrades</a></li>
	<ul>
		<li><a href="http://membershipwireless.com/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,1,33/">AT&T</a></li>
		<li><a href="http://membershipwireless.com/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,2,33/">T-Mobile</a></li>
		<li><a href="http://membershipwireless.com/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,3,33/">Verizon Wireless</a></li>
	</ul>
	<li><a href="http://membershipwireless.com/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,34/">Add a Line</a></li>
	<ul>
		<li><a href="http://membershipwireless.com/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,1,34/">AT&T</a></li>
		<li><a href="http://membershipwireless.com/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,2,34/">T-Mobile</a></li>
		<li><a href="http://membershipwireless.com/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,3,34/">Verizon Wireless</a></li>
	</ul>
		
	<li><a href="http://membershipwireless.com/index.cfm/go/shop/do/accessories/">Accessories</a></li>
	<ul>
		<cfoutput query="qAccessories">
			<li><a href="http://membershipwireless.com/index.cfm/go/shop/do/accessoryDetails/product_id/#ProductId#">#DetailTitle#</a></li>
		</cfoutput>						
	</ul>
	<li><a href="http://membershipwireless.com/index.cfm/go/shop/do/dataCardsHome/">Mobile Hotspots</a></li>
	<ul>
		<cfoutput query="qDatacards">
			<li><a href="http://membershipwireless.com/index.cfm/go/shop/do/DataCardAndNetBookDetails/productid/#ProductId#">#DetailTitle#</a></li>
		</cfoutput>						
	</ul>
		
	<li><a href="http://membershipwireless.com/index.cfm/go/content/do/FAQ">FAQ</a></li>
	<li><a href="http://membershipwireless.com/index.cfm/go/content/do/shipping">Shipping Policy</a></li>
	<li><a href="http://membershipwireless.com/index.cfm/go/content/do/returns">Return Policy</a></li>
	<li><a href="http://membershipwireless.com/index.cfm/go/content/do/serviceAgreement">Carrier Terms and Conditions</a></li>
	<li><a href="http://membershipwireless.com/index.cfm/go/content/do/customerService">Customer Service</a></li>
	<li><a href="http://membershipwireless.com/index.cfm/go/content/do/rebateCenter">Rebate Center</a></li>
	<li><a href="http://membershipwireless.com/index.cfm/go/content/do/howShop">How to Shop</a></li>
	<li><a href="http://membershipwireless.com/index.cfm/go/content/do/sitemap">Site Map</a></li>
	<li><a href="http://membershipwireless.com/">Home</a></li>	
</ul>
