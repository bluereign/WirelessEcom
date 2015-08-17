<cfset variables.assetPaths = application.wirebox.getInstance("AssetPaths") />
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />
<cfset accessoryConfig = application.wirebox.getInstance("AccessoryConfig") />
<cfset phoneFilter = application.wirebox.getInstance("PhoneFilter") />
<cfset prepaidFilter = application.wirebox.getInstance("PrepaidFilter") />
<cfset tabletFilter = application.wirebox.getInstance("TabletFilter") />
<cfset dataCardAndNetBookFilter = application.wirebox.getInstance("DataCardAndNetBookFilter") />
<cfset planFilter = application.wirebox.getInstance("PlanFilter") />
<cfset accessoryFilter = application.wirebox.getInstance("AccessoryFilter") />
<cfset filterOption = application.wirebox.getInstance("FilterOption") />
<cfset stringUtil = application.wirebox.getInstance("StringUtil") />

<cfparam name="request.p.do" default="home" type="string" />
<cfparam name="request.currentTopNav" default="phones.browse" type="string" />
		
<cfif IsDefined("URL.utm_source")>
	<cfset SESSION.utm_source = URL.utm_source>

    <cfif URL.utm_source CONTAINS "costco">
    	<cfset SESSION.showLegal = true>
    <cfelse>
    	<cfset SESSION.showLegal = false>
    </cfif>
</cfif>

<cfparam name="request.config.disableSSL" default="false" />

<!--- TODO: Revisit where to put the Upgrade Checker controller --->
<cfif cgi.server_port eq 443 && request.p.do neq 'upgrade-checker-widget' && request.p.do neq 'upgrade-checker'>
	<cflocation url="http://#cgi.server_name#/index.cfm/go/shop/do/#request.p.do#" addtoken="false" />
</cfif>

<cfif structKeyExists(request.p, 'redirect') && request.p.redirect eq 'upgrade-checker'>
	<cflocation url="/index.cfm/go/shop/do/upgrade-checker" addtoken="false" />
</cfif>

<cfif isDefined('request.p.phone_id')>
	<cfset request.p.productId = request.p.phone_id />
</cfif>

<cfif isDefined('request.p.phoneId')>
	<cfset request.p.productId = request.p.phoneId />
</cfif>

<cfif isDefined('request.p.product_id')>
	<cfset request.p.productId = request.p.product_id />
</cfif>

<cfswitch expression="#request.p.do#">

	<cfcase value="incompatibleType">
		<cfset request.layoutFile = 'noLayout' />

		<cfinclude template="/views/shop/dsp_incompatibleType.cfm" />
	</cfcase>

	<cfcase value="incompatibleActivationType">
		<cfset request.layoutFile = 'noLayout' />

		<cfinclude template="/views/shop/dsp_incompatibleActivationType.cfm" />
	</cfcase>

	<cfcase value="rebatesPopup">
		<cfset request.layoutFile = 'nolayout' />

		<cfinclude template="/views/shop/dsp_rebatesPopup.cfm" />
	</cfcase>

	<cfcase value="services">
		<cfset request.currentTopNav = 'home.home' />

		<cfinclude template="/views/shop/dsp_services.cfm" />
	</cfcase>

	<cfcase value="addbundle">
		<cfset request.currentTopNav = 'home.home' />

		<cfinclude template="/views/shop/dsp_landing.cfm" />
	</cfcase>

	<!--- Moved permanently to Content controller --->
	<cfcase value="home,phonesHome,plansHome,accessoriesHome">
		<cflocation url="/index.cfm/go/content/do/#request.p.do#" addtoken="false" statuscode="301">
	</cfcase>

	<cfcase value="dataCardsHome,dataCardsAndNetbooksHome">
		<cfset request.currentTopNav = 'dataCardsAndNetbooks.home' />
		<cfset request.p.do = 'dataCardsHome' />

		<cfinclude template="/views/shop/dsp_landing.cfm" />
	</cfcase>

	<cfcase value="browsePhones">
		<cfparam name="session.phonefilterselections.sort" default="#channelConfig.getDefaultProductSort()#" type="string" />

		<!--- If there is at least one line in the cart, filter phones by the line one carrier. --->
		<cfif application.model.cartHelper.getNumberOfLines() gte 1 and structKeyExists(request.p, 'cartCurrentLine')>
			<cfset url.cId = session.cart.getCarrierId() />

			<cfif url.cId eq 109><!--- ATT --->
				<cfset url.cId = 1 />
			<cfelseif url.cId eq 128><!--- TMO --->
				<cfset url.cId = 2 />
			<cfelseif url.cId eq 42><!--- Verizon --->
				<cfset url.cId = 3 />
			<cfelseif url.cId eq 299><!--- Sprint --->
				<cfset url.cId = 230 />
			</cfif>

			<cfset url.which = 'browsePhones' />
		</cfif>

		<cfif structKeyExists(url, 'cID') and structKeyExists(url, 'which') and len(trim(url.which))>

			<cfif trim(url.which) is 'browsePhones'>
				<cfif session.cart.getActivationType() is 'new'>
					<cfset fOption = 32 />
				<cfelseif session.cart.getActivationType() is 'upgrade'>
					<cfset fOption = 33 />
				<cfelseif session.cart.getActivationType() is 'addaline'>
					<cfset fOption = 34 />
				<cfelseif session.cart.getActivationType() is 'nocontract'>
					<cfset fOption = 35 />
				<cfelse>
					<cfset fOption = 32 />
				</cfif>

				<cflocation url="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,#url.cID#,#variables.fOption#/" />

			</cfif>
		</cfif>

		<cfset request.currentTopNav = 'phones.browse' />
	
		<cfif isDefined('request.p.phoneFilter.submit')>
			<cfset phoneFilter.saveFilterSelections(formFields = request.p) />

			<cfscript>
				gaString = '';
				gaUrlVars = [];
				
				if (structKeyExists(url, "utm_campaign")) { ArrayAppend(gaUrlVars, 'utm_campaign=' & url.utm_campaign); };
				if (structKeyExists(url, "utm_source")) { ArrayAppend(gaUrlVars, 'utm_source=' & url.utm_source); };
				if (structKeyExists(url, "utm_medium")) { ArrayAppend(gaUrlVars, 'utm_medium=' & url.utm_medium); };
				
				for (i=1; i <=ArrayLen(gaUrlVars); i++)
				{
					if (i eq 1)
						gaString &= '?' & gaUrlVars[i];
					else
						gaString &= '&' & gaUrlVars[i];
				}
			</cfscript>

			<cflocation url="/index.cfm/go/#request.p.go#/do/#request.p.do##gaString#" addtoken="false" />
		</cfif>

		<cfset workflowHTML = trim(application.view.cart.renderWorkflowController()) />
		<cfset filterData = phoneFilter.getFilterData() />
		<cfset filterHTML = trim(application.view.phoneFilter.renderFilterInterface(variables.filterData)) />
		<cfset productHTML = trim(application.view.phone.browseProducts()) />

		<cfset local_compareMethod = 'comparePhones' />
		<cfset local_filterSelections = session.phoneFilterSelections />
		<cfset local_filterName = 'phoneFilter' />

		<cfinclude template="/views/shop/dsp_browseProducts.cfm" />
	</cfcase>

	<cfcase value="browsePhonesResults,browsePhoneResults">
		<cfset request.layoutFile = 'noLayout' />

		<cfif isDefined('request.p.phoneFilter.submit')>
			<cfset phoneFilter.saveFilterSelections(formFields = request.p) />
		</cfif>

		<cfscript>
			request.p.sort = phoneFilter.getSort();

			if ( StructKeyExists( request.p, "ActivationPrice") )
				phoneFilter.setActivationPrice( request.p.ActivationPrice );
			else
				request.p.ActivationPrice = phoneFilter.getActivationPrice();

			//Determine the device price based on activation type when user has device already in cart
			if (listFind(phoneFilter.getUserSelectedFilterValuesByFieldName(fieldName = 'planType'), '32'))
				request.p.ActivationPrice = 'new';
			else if (listFind(phoneFilter.getUserSelectedFilterValuesByFieldName(fieldName = 'planType'), '33'))
				request.p.ActivationPrice = 'upgrade';
			else if (listFind(phoneFilter.getUserSelectedFilterValuesByFieldName(fieldName = 'planType'), '34'))
				request.p.ActivationPrice = 'addaline';

			filterOptions = phoneFilter.getDynamicTagFilters();
			productData = application.model.phone.getByFilter(sort = request.p.sort, ActivationPrice = request.p.activationPrice, filter = filterOptions);
			productHTML = trim(application.view.phone.browseProductsResults(productData = variables.productData, displayNoInventoryItems = ChannelConfig.getDisplayNoInventoryItems()));
		</cfscript>

		<cfinclude template="/views/shop/dsp_browseProductsResults.cfm" />
	</cfcase>

	<cfcase value="phoneDetails">
		<cfparam name="request.p.activeTab" type="string" default="features" />

		<cfif not structKeyExists(request, 'p') or (structKeyExists(request, 'p') and not structKeyExists(request.p, 'productId'))>
			<cflocation url="/index.cfm" addtoken="false" />
		</cfif>

		<!--- Loop through request.p.productId, it can be a list of numeric values. If there is a non-numeric value in this list, 
			redirect them to the home page. --->
		<cfloop from="1" to="#listLen(request.p.productId)#" index="idx">
			<cfif not isNumeric(listGetAt(request.p.productId, idx))>
				<cflocation url="/index.cfm" addtoken="false" />
				<cfbreak />
			</cfif>
		</cfloop>

		<cfif not structKeyExists(request.p, 'name')>
			<cfset request.p.name = '' />
		</cfif>

		<cfset request.currentTopNav = 'phones.detail' />

		<cfset workflowHTML = application.view.cart.renderWorkflowController() />

		<cfset productData = application.model.phone.getByFilter(idList = request.p.productId, allowHidden = true) />

		<cfif not variables.productData.recordCount>
			<cfset productData = application.model.tablet.getByFilter(idList = request.p.productId) />
			<cfif variables.productData.recordCount>
				<cfset request.p.do = 'tabletDetails' />
				<cfinclude template="index.cfm" />
				<cfexit method="exittemplate" />
			</cfif>
		</cfif>
		<cfif not variables.productData.recordCount>
			<cfset productData = application.model.dataCardAndNetbook.getByFilter(idList = request.p.productId) />

			<cfif variables.productData.recordCount>
				<cfset request.p.do = 'dataCardAndNetbookDetails' />
				<cfinclude template="index.cfm" />
				<cfexit method="exittemplate" />
			</cfif>
		</cfif>

		<cfif not variables.productData.recordCount>
			<cfset productData = application.model.prePaid.getByFilter(idList = request.p.productId) />

			<cfif variables.productData.recordCount>
				<cfset request.p.do = 'prepaidDetails' />
				<cfinclude template="index.cfm" />
				<cfexit method="exittemplate" />
			</cfif>
		</cfif>

		<!--- If product could no longer be found, do a redirect. --->
		<cfif not variables.productData.recordCount>
			<cfheader statuscode="301" statustext="Moved permanently" />
			<cfheader name="Location" value="/index.cfm" />

			<cfabort />
		</cfif>

		<!--- Modified on 01/16/2015 by Denard Springle (denard.springle@cfwebtools.com) --->
		<!--- Track #: 7143 - Add Automatic Redirection from Legacy Product Details Page to new Redesign Page [ Add 301 redirect ] --->

		<cfif channelConfig.getDirectToRedesignDetailsPage()>

			<!-- generate SES friendly title for the URL --->
			<cfset variables.thisTitle = stringUtil.friendlyURL( variables.productData.DetailTitle ) />

			<!--- do a perm redirect to the new location --->
			<cfheader statuscode="301" statustext="Moved permanently" />
			<cfheader name="Location" value="/#variables.productData.productId#/#variables.thisTitle#" />

			<cfabort>
			
		</cfif>
		<!--- END EDITS on 01/16/2014 by Denard Springle --->

		<cfset featuresData = application.model.phone.getFeatures( variables.productData.productId ) />
		<cfset freeAccessories = application.model.phone.getFreeAccessories( variables.productData.productId ) />
		<cfset qMedia = application.model.product.getProductVideos( variables.productData.productId ) />
		<cfset productHTML = application.view.phone.productDetails( productData = variables.productData, featuresData = variables.featuresData, freeAccessories = variables.freeAccessories, qVideos = variables.qMedia, activeTab = request.p.activeTab, name = request.p.name ) />

		<cfinclude template="/views/shop/dsp_productDetails.cfm" />
	</cfcase>


	<cfcase value="warrantydetails">
		<cfif !channelConfig.getOfferWarrantyPlan() || !IsDefined('request.p.productId') or not len(trim(request.p.productId)) or not isNumeric(request.p.productId)>
			<cflocation url="/index.cfm" addtoken="false" />
		</cfif>

		<cfset request.currentTopNav = 'plans.details' />
		<cfset warrantyData = application.model.Warranty.getById( request.p.productId ) />
		
		<!--- If planData could no longer be found, do a redirect. --->
		<cfif !warrantyData.recordCount>
			<cfheader name="Location" value="/index.cfm" />
			<cfabort />
		</cfif>

		<cfinclude template="/views/shop/dsp_WarrantyDetails.cfm" />
	</cfcase>

	<cfcase value="comparePhones">
		<cfparam name="request.p.formHidden_activationType" default="new" type="string" />

		<!--- SBH: Hack code to determine why phone compares are no longer working (put the request compareids into the session filter to make rest of code happy) --->
		<cfif not (structKeyExists(session, 'phoneFilterSelections') and structKeyExists(session.phoneFilterSelections, 'compareIds') and len(trim(session.phoneFilterSelections.compareIds)))>	
			<cfif structkeyExists(request,'p') and structKeyExists(request.p,'compareIds')>
				<cfset session.phoneFilterSelections.compareIds = request.p.compareIds/>
			</cfif>
		</cfif>
		<!--- end of SBH hack --->
			
		<cfif structKeyExists(request, 'p') and structKeyExists(request.p, 'phoneFilter.submit')>
			<cfif structKeyExists(request.p, 'removeId')>
				<cfset phoneFilter.removeCompareId(request.p.removeId) />
				<cfif len(trim(session.phoneFilterSelections.compareIds))>
					<cfset session.phoneFilterSelections.compareIds = listDeleteAt(url.filter.compareIDs, listFind(filter.compareIDs, request.p.removeId)) />
				</cfif>
			</cfif>

			<cfif structKeyExists(session, 'phoneFilterSelections') and structKeyExists(session.phoneFilterSelections, 'compareIds') and len(trim(session.phoneFilterSelections.compareIds))>
				<cflocation addtoken="false" url="/index.cfm/go/#request.p.go#/do/#request.p.do#/formHidden_activationType/#request.p.formHidden_activationType#" />
			<cfelse>
				<cflocation addtoken="false" url="/index.cfm/go/#request.p.go#/do/browsePhones" />
			</cfif>
		</cfif>

		<cfset request.p.activationType = request.p.formHidden_activationType />
		<cfset request.currentTopNav = 'phones.compare' />

		<cfset workflowHTML = trim(application.view.cart.renderWorkflowController()) />
		<cfset productData = application.model.phone.getByFilter(idList = phoneFilter.getUserSelectedFilterValuesByFieldName('compareIDs')) />
		<cfset productCompareData = application.model.phone.getCompareData(phoneFilter.getUserSelectedFilterValuesByFieldName('compareIDs')) />
		<cfset productHTML = trim(application.view.phone.compareProducts(productData = variables.productData, productCompareData = variables.productCompareData)) />

		<cfinclude template="/views/shop/dsp_compareProducts.cfm" />
	</cfcase>
	
	<cfcase value="compareTablets">
		<cfparam name="request.p.formHidden_activationType" default="new" type="string" />

		<cfif structKeyExists(request, 'p') and structKeyExists(request.p, 'tabletFilter.submit')>
			<cfif structKeyExists(request.p, 'removeId')>
				<cfset phoneFilter.removeCompareId(request.p.removeId) />
				<cfif len(trim(session.tabletFilterSelections.compareIds))>
					<cfset session.tabletFilterSelections.compareIds = listDeleteAt(url.filter.compareIDs, listFind(filter.compareIDs, request.p.removeId)) />
				</cfif>
			</cfif>

			<cfif structKeyExists(session, 'tabletFilterSelections') and structKeyExists(session.tabletFilterSelections, 'compareIds') and len(trim(session.tabletFilterSelections.compareIds))>
				<cflocation addtoken="false" url="/index.cfm/go/#request.p.go#/do/#request.p.do#/formHidden_activationType/#request.p.formHidden_activationType#" />
			<cfelse>
				<cflocation addtoken="false" url="/index.cfm/go/#request.p.go#/do/browseTablets" />
			</cfif>
		</cfif>

		<cfset request.p.activationType = request.p.formHidden_activationType />
		<cfset request.currentTopNav = 'tablets.compare' />

		<cfset workflowHTML = trim(application.view.cart.renderWorkflowController()) />
		<cfset productData = application.model.tablet.getByFilter(idList = tabletFilter.getUserSelectedFilterValuesByFieldName('compareIDs')) />
		<cfset productCompareData = application.model.tablet.getCompareData(tabletFilter.getUserSelectedFilterValuesByFieldName('compareIDs')) />
		<cfset productHTML = trim(application.view.tablet.compareProducts(productData = variables.productData, productCompareData = variables.productCompareData)) />

		<cfinclude template="/views/shop/dsp_compareProducts.cfm" />
	</cfcase>


	<cfcase value="browsePlans">

		<cfset local.cL = session.cart.getLines() />

		<cfset local.fopt = '39,40' />

		<cftry>
			<cfquery name="local.getFOpt" datasource="#application.dsn.wirelessAdvocates#">
				SELECT		pt.Tag
				FROM		catalog.ProductTag AS pt WITH (NOLOCK)
				INNER JOIN	catalog.Product AS p ON p.ProductGuid = pt.ProductGuid
				WHERE		(pt.tag = 'datadevice' OR pt.tag = 'tablet' OR pt.tag = 'tablets')
					AND		p.ProductId	=	<cfqueryparam value="#local.cL[session.cart.getCurrentLine()].getPhone().getProductId()#" cfsqltype="cf_sql_integer" />
			</cfquery>

			<cfif local.getFOpt.recordCount>
				<cfif session.cart.getCarrierId() eq 42>
					<cfset local.fopt = '40,41' />
				<cfelse>
					<cfset local.fopt = '41' />
				</cfif>
			</cfif>

			<cfcatch type="any">

			</cfcatch>
		</cftry>


		<cfif structKeyExists(url, 'cID') and structKeyExists(url, 'which') and len(trim(url.which))>
			<cfif trim(url.which) is 'browsePlans'>

				<cflocation url="/index.cfm/go/shop/do/browsePlans/planFilter.submit/1/filter.filterOptions/0,#url.cID#,#local.fopt#/" />
			</cfif>
		</cfif>


		<cfset request.currentTopNav = 'plans.browse' />

		<cfif isDefined('request.p.planFilter.submit')>
			<cfset planFilter.saveFilterSelections(formFields = request.p) />
			
			<cfscript>
				gaString = '';
				gaUrlVars = [];
				
				if (structKeyExists(url, "utm_campaign")) { ArrayAppend(gaUrlVars, 'utm_campaign=' & url.utm_campaign); };
				if (structKeyExists(url, "utm_source")) { ArrayAppend(gaUrlVars, 'utm_source=' & url.utm_source); };
				if (structKeyExists(url, "utm_medium")) { ArrayAppend(gaUrlVars, 'utm_medium=' & url.utm_medium); };
				
				for (i=1; i <=ArrayLen(gaUrlVars); i++)
				{
					if (i eq 1)
						gaString &= '?' & gaUrlVars[i];
					else
						gaString &= '&' & gaUrlVars[i];
				}
			</cfscript>
			
			<cflocation url="/index.cfm/go/#request.p.go#/do/#request.p.do##gaString#" addtoken="false" />
	
		</cfif>

		<cfset workflowHTML = trim(application.view.cart.renderWorkflowController()) />
		<cfset filterData = planFilter.getFilterData() />
		<cfset filterHTML = trim(application.view.planFilter.renderFilterInterface(variables.filterData)) />
		<cfset planHTML = trim(application.view.plan.browsePlans()) />

		<cfinclude template="/views/shop/dsp_browsePlans.cfm" />
	</cfcase>

	<cfcase value="browsePlansResults">
		<cfset request.layoutFile = 'noLayout' />

		<cfif isDefined('request.p.planFilter.submit')>
			<cfset planFilter.saveFilterSelections(formFields = request.p) />
		</cfif>

		<cfset request.p.sort = planFilter.getSort() />

		<cfset planData = application.model.plan.getByFilter(sort = request.p.sort) />
		<cfset planHTML = trim(application.view.plan.browsePlansResults(planData = variables.planData)) />

		<cfinclude template="/views/shop/dsp_browsePlansResults.cfm" />
	</cfcase>

	<cfcase value="planDetails">
		<cfif not isDefined('request.p.planId') or not len(trim(request.p.planId)) or not isNumeric(request.p.planId)>
			<cflocation url="/index.cfm/go/shop/do/browsePlans/" addtoken="false" />
		</cfif>

		<cfparam name="request.p.bSelectServices" type="boolean" default="false" />
		<cfparam name="request.p.activeTab" type="string" default="specifications" />

		<cfset request.currentTopNav = 'plans.details' />
		<cfset workflowHTML = trim(application.view.cart.renderWorkflowController()) />
		<cfset planData = application.model.plan.getByFilter(idList = request.p.planId) />


		<!---
		**
		* If planData could no longer be found, do a redirect.
		**
		--->
		<cfif not variables.planData.recordCount>
			<cfheader statuscode="301" statustext="Moved permanently" />
			<cfheader name="Location" value="/index.cfm" />

			<cfabort />
		</cfif>

		<cfset planHTML = trim(application.view.plan.planDetails(planData = variables.planData, bSelectServices = request.p.bSelectServices, activeTab = request.p.activeTab)) />

		<cfinclude template="/views/shop/dsp_planDetails.cfm" />
	</cfcase>

	<cfcase value="comparePlans">
		<cfset request.currentTopNav = 'plans.compare' />

		<cfset workflowHTML = trim(application.view.cart.renderWorkflowController()) />

		<cfif isDefined('request.p.planFilter.submit')>
			<cfif isDefined('request.p.removeID')>
				<cfset planFilter.removeCompareId(request.p.removeID, 'plan') />
			</cfif>

			<cfif structKeyExists(session, 'planFilterSelections') and structKeyExists(session.planFilterSelections, 'compareIds') and len(trim(session.planFilterSelections.compareIds))>
				<cflocation addtoken="false" url="/index.cfm/go/#request.p.go#/do/#request.p.do#/" />
			<cfelse>
				<cflocation addtoken="false" url="/index.cfm/go/#request.p.go#/do/browsePlans/" />
			</cfif>
		</cfif>

		<cfset planData = application.model.plan.getCompare(planIds = planFilter.getUserSelectedFilterValuesByFieldName('compareIDs')) />
		<cfset planHTML = trim(application.view.plan.comparePlans(planData = variables.planData)) />

		<cfinclude template="/views/shop/dsp_comparePlans.cfm" />
	</cfcase>

	<cfcase value="planSelectServices">
		<cfset request.p.bSelectServices = true />
		<cfset request.p.do = 'planDetails' />

		<cfinclude template="index.cfm" />

		<cfexit method="exittemplate" />
	</cfcase>

	<cfcase value="accessories">
		<cfset request.currentTopNav = 'accessories.browse' />
		<cfset phoneSort = "SummaryTitle, CarrierName" />
		<cfset filterGroupId = 2 /> <!--- groupId for Device Brand == 2 --->
		<cfset brandfilterData = accessoryFilter.getFilterGroupData(filterGroupId) />
		<cfset productsInBrand = application.model.Phone.getAll(bActiveOnly = true, 
									   							bHasAccessories = true,
									   							bSortBy = variables.phoneSort) />
	
		<cfinclude template="/views/shop/dsp_accessories.cfm" />
	</cfcase>

	<cfcase value="brandDeviceAccessories">
		<cfset request.layoutFile = 'basic' />
		
		<cfif request.p.brandId EQ 'all'>
			<cfset filterGroupId = 2 /> <!--- groupId for Device Brand == 2 --->
			<cfset phoneSort = "SummaryTitle, CarrierName" />
			<cfset productsInBrand = application.model.Phone.getAll(bActiveOnly = true, 
																   	bHasAccessories = true,
																   	bSortBy = variables.phoneSort) />
		<cfelse>
			<cfset phoneSort = "SummaryTitle, CarrierName" />
			<cfset accessoriesInBrand = application.model.Phone.getByBrand(brandId = request.p.brandId,
																			bActiveOnly = true, 
																   			bHasAccessories = true,
																   			bSortBy = variables.phoneSort) />
		</cfif>
		
		<cfoutput> 
			<div id="accessoriesJson">#Trim(SerializeJSON(accessoriesInBrand))#</div>
		</cfoutput>
	</cfcase>

	<cfcase value="processAccessories">
		<cfset request.currentTopNav = 'accessories.browse' />
		<cfset brandFilter = "" />
		
		<cfif request.p.brandSelect NEQ 'all' AND request.p.modelSelect EQ 'all'>
			<cfset brandFilter = ","& request.p.brandSelect />
		<cfelseif request.p.modelSelect NEQ 'all'>
			<cflocation addtoken="false" url="/index.cfm/go/shop/do/browseAccessories/filter.phoneID/#request.p.modelSelect#" />		
		</cfif>

		<cflocation addtoken="false" url="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/0#brandFilter#/" />
	</cfcase>
	
	<cfcase value="browseAccessories">
		<cfset request.currentTopNav = 'accessories.browse' />
		
		<cfif isDefined('request.p.accessoryFilter.submit')>
			<cfset accessoryFilter.saveFilterSelections(formFields = request.p) />

			<cfif IsDefined('request.p.filter.phoneId')>
				<cflocation url="/index.cfm/go/#request.p.go#/do/#request.p.do#/filter.phoneID/#request.p.filter.phoneId#" addtoken="false" />
			<cfelse>
			
			<cfscript>
				gaString = '';
				gaUrlVars = [];
				
				if (structKeyExists(url, "utm_campaign")) { ArrayAppend(gaUrlVars, 'utm_campaign=' & url.utm_campaign); };
				if (structKeyExists(url, "utm_source")) { ArrayAppend(gaUrlVars, 'utm_source=' & url.utm_source); };
				if (structKeyExists(url, "utm_medium")) { ArrayAppend(gaUrlVars, 'utm_medium=' & url.utm_medium); };
				
				for (i=1; i <=ArrayLen(gaUrlVars); i++)
				{
					if (i eq 1)
						gaString &= '?' & gaUrlVars[i];
					else
						gaString &= '&' & gaUrlVars[i];
				}
			</cfscript>
			
				<cflocation url="/index.cfm/go/#request.p.go#/do/#request.p.do##gaString#" addtoken="false" />

			</cfif>
		</cfif>

		<cfset workflowHTML = trim(application.view.cart.renderWorkflowController()) />

		<!--- get device filter data --->
		<cfset phoneSort = "SummaryTitle, CarrierName" />
		<cfset deviceFilterData = application.model.Phone.getAll(bActiveOnly = true, 
																 bHasAccessories = true,
																 bSortBy = variables.phoneSort) />
																 
		<cfset filterData = accessoryFilter.getFilterData() />
		
		
		<cfset filterHTML = trim(application.view.accessoryFilter.renderFilterInterface(filterData = variables.filterData,
																						deviceFilterData = variables.deviceFilterData)) />
		<cfset accessoryHTML = trim(application.view.accessory.browseAccessories()) />
		
		<!---this is not always defined because sometimes the phone is not ---->
		<cfparam name="request.p.filter.phoneid" default="" />
		
		<cfset featuredAccessoriesHTML = trim(application.view.accessory.browseFeaturedAccessories(phoneid = request.p.filter.phoneid)) />

		<cfinclude template="/views/shop/dsp_browseAccessories.cfm" />
	</cfcase>

	<cfcase value="browseAccessoriesResults">
		<cfset request.layoutFile = 'noLayout' />
		<cfset deviceIdFilter = '' />

		<cfif isDefined('request.p.accessoryFilter.submit')>
			<cfset accessoryFilter.saveFilterSelections(formFields = request.p) />
		</cfif>
		
		<cfif isDefined('request.p.deviceIdFilter')>
			<cfset deviceIdFilter = request.p.deviceIdFilter />
		</cfif>

		<cfif StructKeyExists(request.p, "isForDevice")>
			<cfset madeForDevice = true />
		<cfelse>
			<cfset madeForDevice = false />
		</cfif>

		<cfset request.p.sort = accessoryFilter.getSort() />
		
		<cfset accessoryData = application.model.accessory.getByFilter(sort = request.p.sort, 
																	   associatedDeviceIdFilter = variables.deviceIdFilter,
																	   notUniversal = madeForDevice  ) />
		<cfif request.p.sort eq "Category">
			<cfset tempCatSorted = QueryNew(accessoryData.ColumnList) />
			<cfset sortedColumns = ListToArray( tempCatSorted.ColumnList ) />
			
			<!--- Loop over the categories list from channel bean. ---> 
			<cfloop list="#accessoryConfig.categoryOrder#" index="category">
				<!--- get dynamic tag for category --->
				<cfset catFilter = filterOption.getFilterOptionById(category) />

				<cfif catFilter.RecordCount>
					<!--- run dynamic tag query to get accesories in category --->
					<cfset catAccessGuids = filterOption.runDynamicTag(catFilter.dynamicTag) />
				
					<!--- loop dynamic tag results accesoryData to compare guids with dynamicTag data --->
					<cfloop query="catAccessGuids">
						<cfloop query="accessoryData">
							<cfif catAccessGuids.productGuid eq accessoryData.productGuid>
								<cfset addGuid = true />
								<cfloop query="tempCatSorted">
									<!--- if match found check to make sure not already in tempCatSorted --->
									<cfif accessoryData.productGuid eq tempCatSorted.productGuid>
										<cfset addGuid = false />
										<cfbreak />
									</cfif>
								</cfloop>
								
								<!--- if not already in tempCatSorted, add to query --->
								<cfif addGuid>
									<cfset QueryAddRow( tempCatSorted ) />
	
									<!--- Loop over the columns. --->
									<cfloop index="theColumn" from="1" to="#ArrayLen( sortedColumns )#" step="1">										
										<!--- Get the column name for easy access. --->
										<cfset theColumnName = sortedColumns[ theColumn ] />
										
										<!--- Set the column value in the newly created row. --->
										<cfset tempCatSorted[ theColumnName ][ tempCatSorted.RecordCount ] = accessoryData[ theColumnName ][ accessoryData.CurrentRow ] />
									</cfloop>								
								</cfif>
							</cfif>
						</cfloop>
					</cfloop>
				</cfif>
			</cfloop>
			<!--- replace accesoryData with sorted category data for passing to browseAccessoriesResults --->
			<cfset accessoryData = tempCatSorted />
		</cfif>
																	   
		<cfset accessoryHTML = trim(application.view.accessory.browseAccessoriesResults(accessoryData = variables.accessoryData, 
																						displayNoInventoryItems = ChannelConfig.getDisplayNoInventoryItems()) ) />
		
		<cfinclude template="/views/shop/dsp_browseAccessoriesResults.cfm" />
	</cfcase>

	<cfcase value="accessoryDetails">
		<cfparam name="request.p.activeTab" type="string" default="features" />

		<cfif not isDefined('request.p.product_id') or not len(trim(request.p.product_id)) or not isNumeric(request.p.product_id)>
			<cflocation url="/index.cfm/go/shop/do/browseAccessories/" addtoken="false" />
		</cfif>

		<cfparam name="request.p.product_id" type="integer" />

		<cfset request.currentTopNav = 'accessories.details' />

		<cfset workflowHTML = trim(application.view.cart.renderWorkflowController()) />

		<cfset accessoryData = application.model.accessory.getByFilter(idList = request.p.product_id) />

		<cfif variables.accessoryData.recordCount>
			<cfset qMedia = application.model.product.getProductVideos(productId = request.p.product_id) />
			<cfset accessoryHTML = trim(application.view.accessory.accessoryDetails(accessoryData = variables.accessoryData, qVideos = variables.qMedia)) />
		<cfelse>
			<cflocation url="/index.cfm/go/shop/do/browseAccessories/" addtoken="false" />
		</cfif>

		<cfinclude template="/views/shop/dsp_accessoryDetails.cfm" />
	</cfcase>

	<cfcase value="compareAccessories">
		<cfif isDefined('request.p.accessoryFilter.submit')>
			<cfif isDefined('request.p.removeID')>
				<cfset planFilter.removeCompareId(request.p.removeID, 'accessory') />
			</cfif>

			<cfif len(trim(session.accessoryFilterSelections.compareIds))>
				<cflocation url="/index.cfm/go/#request.p.go#/do/#request.p.do#/" addtoken="false" />
			<cfelse>
				<cflocation url="/index.cfm/go/#request.p.go#/do/browseAccessories/" addtoken="false" />
			</cfif>
		</cfif>

		<cfset request.currentTopNav = 'accessories.compare' />

		<cfset workflowHTML = trim(application.view.cart.renderWorkflowController()) />

		<cfset accessoryData = application.model.accessory.getByFilter(idList = accessoryFilter.getUserSelectedFilterValuesByFieldName('compareIDs')) />
		<cfset accessoryCompareData = application.model.accessory.getCompareData(accessoryFilter.getUserSelectedFilterValuesByFieldName('compareIDs')) />

		<cfset accessoryHTML = trim(application.view.accessory.compareAccessories(accessoryData = variables.accessoryData, accessoryCompareData = variables.accessoryCompareData)) />

		<cfinclude template="/views/shop/dsp_compareAccessories.cfm" />
	</cfcase>

	<cfcase value="browseTablets">
		<cfset request.currentTopNav = 'tablets.browse' />

		<cfif isDefined('request.p.tabletFilter.submit')>
			<cfset tabletFilter.saveFilterSelections(formFields = request.p) />
			
			<cfscript>
				gaString = '';
				gaUrlVars = [];
				
				if (structKeyExists(url, "utm_campaign")) { ArrayAppend(gaUrlVars, 'utm_campaign=' & url.utm_campaign); };
				if (structKeyExists(url, "utm_source")) { ArrayAppend(gaUrlVars, 'utm_source=' & url.utm_source); };
				if (structKeyExists(url, "utm_medium")) { ArrayAppend(gaUrlVars, 'utm_medium=' & url.utm_medium); };
				
				for (i=1; i <=ArrayLen(gaUrlVars); i++)
				{
					if (i eq 1)
						gaString &= '?' & gaUrlVars[i];
					else
						gaString &= '&' & gaUrlVars[i];
				}
			</cfscript>
			
			<cflocation url="/index.cfm/go/#request.p.go#/do/#request.p.do##gaString#" addtoken="false" />

		</cfif>

		<cfset workflowHTML = trim(application.view.cart.renderWorkflowController()) />

		<cfset filterData = tabletFilter.getFilterData() />
		<cfset filterHTML = trim(application.view.tabletFilter.renderFilterInterface(variables.filterData)) />
		<cfset productHTML = trim(application.view.tablet.browseProducts()) />

		<cfset local_compareMethod = 'compareTablets' />
		<cfset local_filterSelections = session.tabletFilterSelections />
		<cfset local_filterName = 'tabletFilter' />

		<cfinclude template="/views/shop/dsp_browseProducts.cfm" />
	</cfcase>	
	
	<cfcase value="browseTabletsResults,browseTabletResults">
		<cfset request.layoutfile = "noLayout">

		<!--- if form (filter) data was submitted --->
		<cfif isDefined("request.p.tabletFilter.submit")>
			<cfset tabletFilter.saveFilterSelections(formFields=request.p)>
		</cfif>

		<cfscript>
			request.p.sort = tabletFilter.getSort();

			if ( StructKeyExists( request.p, "ActivationPrice") )
				tabletFilter.setActivationPrice( request.p.ActivationPrice );
			else
				request.p.ActivationPrice = tabletFilter.getActivationPrice();
				
			//Determine the device price based on activation type when user has device already in cart
			if (listFind(tabletFilter.getUserSelectedFilterValuesByFieldName(fieldName = 'planType'), '32'))
				request.p.ActivationPrice = 'new';
			else if (listFind(tabletFilter.getUserSelectedFilterValuesByFieldName(fieldName = 'planType'), '33'))
				request.p.ActivationPrice = 'upgrade';
			else if (listFind(tabletFilter.getUserSelectedFilterValuesByFieldName(fieldName = 'planType'), '34'))
				request.p.ActivationPrice = 'addaline';

			filterOptions = tabletFilter.getDynamicTagFilters();				
			productData = application.model.Tablet.getByFilter(sort = request.p.sort, ActivationPrice = request.p.activationPrice, filter = filterOptions);
			productHTML = trim(application.view.Tablet.browseProductsResults(productData = variables.productData));
		</cfscript>

		<cfinclude template="/views/shop/dsp_browseProductsResults.cfm" />
	</cfcase>


	<cfcase value="tabletDetails">
		<cfparam name="request.p.activeTab" type="string" default="features">
		<!--- TRV: adding validation on request.p.productId and redirecting if it doesn't appear to be a valid value --->
		<cfif not isDefined("request.p.productID") or not len(trim(request.p.productID)) or not isNumeric(request.p.productID)>
			<cflocation addtoken="false" url="/index.cfm/go/shop/do/browsetablets/">
		</cfif>

		<cfset request.currentTopNav = "tablets.detail">

		<cfset workflowHTML = application.view.Cart.renderWorkflowController() />
		<cfset productData = application.model.Tablet.getByFilter(idList=request.p.productID) />

		<cfif !variables.productData.recordCount>
			<cflocation url="/index.cfm/go/shop/do/browseTablets/" addtoken="false" />
		</cfif>

		<cfset featuresData = application.model.Tablet.getFeatures(productData.productID) />
		<cfset specsData = application.model.Tablet.getSpecs(productData.productID) />
		<cfset freeAccessories = application.model.Tablet.getFreeAccessories(productData.productID) />
		<cfset qMedia = application.model.product.getProductVideos( productData.productId ) />
		<cfset productHTML = application.view.Tablet.productDetails( productData=productData, featuresData=featuresData, specsData=specsData, freeAccessories=freeAccessories, qVideos = variables.qMedia, activeTab=request.p.activeTab ) />

		<cfinclude template="/views/shop/dsp_productDetails.cfm" />
	</cfcase>



	<cfcase value="browseDataCardsAndNetbooks">
		<cfset request.currentTopNav = 'dataCardsAndNetbooks.browse' />

		<cfif isDefined('request.p.dataCardAndNetbookFilter.submit')>
			<cfset dataCardAndNetBookFilter.saveFilterSelections(formFields = request.p) />

			<cfscript>
				gaString = '';
				gaUrlVars = [];
				
				if (structKeyExists(url, "utm_campaign")) { ArrayAppend(gaUrlVars, 'utm_campaign=' & url.utm_campaign); };
				if (structKeyExists(url, "utm_source")) { ArrayAppend(gaUrlVars, 'utm_source=' & url.utm_source); };
				if (structKeyExists(url, "utm_medium")) { ArrayAppend(gaUrlVars, 'utm_medium=' & url.utm_medium); };
				
				for (i=1; i <=ArrayLen(gaUrlVars); i++)
				{
					if (i eq 1)
						gaString &= '?' & gaUrlVars[i];
					else
						gaString &= '&' & gaUrlVars[i];
				}
			</cfscript>
			
			<cflocation url="/index.cfm/go/#request.p.go#/do/#request.p.do##gaString#" addtoken="false" />

		</cfif>

		<cfset workflowHTML = trim(application.view.cart.renderWorkflowController()) />

		<cfset filterData = dataCardAndNetBookFilter.getFilterData() />
		<cfset filterHTML = trim(application.view.dataCardAndNetBookFilter.renderFilterInterface(variables.filterData)) />
		<cfset productHTML = trim(application.view.dataCardAndNetBook.browseProducts()) />

		<cfset local_compareMethod = 'compareDataCardsAndNetbooks' />
		<cfset local_filterSelections = session.dataCardAndNetbookFilterSelections />
		<cfset local_filterName = 'dataCardAndNetbookFilter' />

		<cfinclude template="/views/shop/dsp_browseProducts.cfm" />
	</cfcase>

	<cfcase value="browseDataCardsAndNetbooksResults,browseDataCardAndNetbookResults">
		<cfset request.layoutfile = "noLayout">

		<!--- if form (filter) data was submitted --->
		<cfif isDefined("request.p.dataCardAndNetbookFilter.submit")>
			<cfset dataCardAndNetBookFilter.saveFilterSelections(formFields=request.p)>
		</cfif>

		<cfscript>
			request.p.sort = dataCardAndNetBookFilter.getSort();

			if ( StructKeyExists( request.p, "ActivationPrice") )
				dataCardAndNetBookFilter.setActivationPrice( request.p.ActivationPrice );
			else
				request.p.ActivationPrice = dataCardAndNetBookFilter.getActivationPrice();
				
			//Determine the device price based on activation type when user has device already in cart
			if (listFind(dataCardAndNetBookFilter.getUserSelectedFilterValuesByFieldName(fieldName = 'planType'), '32'))
				request.p.ActivationPrice = 'new';
			else if (listFind(dataCardAndNetBookFilter.getUserSelectedFilterValuesByFieldName(fieldName = 'planType'), '33'))
				request.p.ActivationPrice = 'upgrade';
			else if (listFind(dataCardAndNetBookFilter.getUserSelectedFilterValuesByFieldName(fieldName = 'planType'), '34'))
				request.p.ActivationPrice = 'addaline';				

			filterOptions = dataCardAndNetBookFilter.getDynamicTagFilters();	
			productData = application.model.DataCardAndNetBook.getByFilter(sort = request.p.sort, ActivationPrice = request.p.activationPrice, filter = filterOptions);
			productHTML = trim(application.view.DataCardAndNetBook.browseProductsResults(productData = variables.productData));
		</cfscript>

		<cfinclude template="/views/shop/dsp_browseProductsResults.cfm" />
	</cfcase>
	
	<cfcase value="dataCardAndNetbookDetails">
		<cfparam name="request.p.activeTab" type="string" default="features">
		<!--- TRV: adding validation on request.p.productId and redirecting if it doesn't appear to be a valid value --->
		<cfif not isDefined("request.p.productID") or not len(trim(request.p.productID)) or not isNumeric(request.p.productID)>
			<cflocation addtoken="false" url="/index.cfm/go/shop/do/browseDataCardsAndNetbooks/">
		</cfif>

		<cfset request.currentTopNav = "dataCardsAndNetbooks.detail">

		<cfset workflowHTML = application.view.Cart.renderWorkflowController() />
		<cfset productData = application.model.DataCardAndNetBook.getByFilter(idList=request.p.productID) />

		<cfif !variables.productData.recordCount>
			<cflocation url="/index.cfm/go/shop/do/browseDataCardsAndNetBooks/" addtoken="false" />
		</cfif>

		<cfset featuresData = application.model.DataCardAndNetBook.getFeatures(productData.productID) />
		<cfset specsData = application.model.DataCardAndNetBook.getSpecs(productData.productID) />
		<cfset freeAccessories = application.model.DataCardAndNetBook.getFreeAccessories(productData.productID) />
		<cfset qMedia = application.model.product.getProductVideos( productData.productId ) />
		<cfset productHTML = application.view.DataCardAndNetBook.productDetails( productData=productData, featuresData=featuresData, specsData=specsData, freeAccessories=freeAccessories, qVideos = variables.qMedia, activeTab=request.p.activeTab ) />

		<cfinclude template="/views/shop/dsp_productDetails.cfm" />
	</cfcase>

	<cfcase value="compareDataCardsAndNetbooks">
		<cfparam name="request.p.formHidden_activationType" default="new">

		<!--- if form (filter) data was submitted --->
		<cfif isDefined("request.p.dataCardAndNetBookFilter.submit")>
			<cfif isDefined("request.p.removeID")>
				<!--- if the user clicked remove, take the ID out --->
				<cfset dataCardAndNetBookFilter.removeCompareId(request.p.removeID)>
			</cfif>

			<cfif len(trim(session.dataCardAndNetbookFilterSelections.compareIds))>
				<cflocation addtoken="false" url="/index.cfm/go/#request.p.go#/do/#request.p.do#/formHidden_activationType/#request.p.formHidden_activationType#">
			<cfelse>
				<cflocation addtoken="false" url="/index.cfm/go/#request.p.go#/do/browseDataCardsAndNetbooks">
			</cfif>
		</cfif>

		<cfset request.p.activationType = request.p.formHidden_activationType>
		<cfset request.currentTopNav = "dataCardsAndNetbooks.compare">

		<cfset workflowHTML = application.view.Cart.renderWorkflowController()>
		<cfset productData = application.model.DataCardAndNetBook.getByFilter(idList=dataCardAndNetBookFilter.getUserSelectedFilterValuesByFieldName("compareIDs"))>
		<cfset productCompareData = application.model.DataCardAndNetbook.getCompareData(dataCardAndNetBookFilter.getUserSelectedFilterValuesByFieldName("compareIDs"))>
		<cfset productHTML = application.view.DataCardAndNetbook.compareProducts(productData=productData,productCompareData=productCompareData)>

		<cfinclude template="/views/shop/dsp_compareProducts.cfm">
	</cfcase>

	<cfcase value="serviceDescription">

		<cfif not structKeyExists(request.p, 'productId')>
			<cflocation url="/index.cfm" addtoken="false" />
		</cfif>

		<cfset request.layoutfile = "serviceDescriptionWindow">

		<cfset request.p.service = application.model.Feature.getByProductId(request.p.productId)>
		<cfset local.stcService = application.model.Util.queryRowToStruct(request.p.service,1)>
		<cfset request.p.serviceTitle = request.p.service.summaryTitle>

		<cfif len(trim(request.p.service.summaryDescription))>
			<cfset request.p.serviceDescription = request.p.service.summaryDescription>
		<cfelseif len(trim(request.p.service.detailDescription))>
			<cfset request.p.serviceDescription = request.p.service.detailDescription>
		<cfelseif len(trim(request.p.service.carrierDescription))>
			<cfset request.p.serviceDescription = request.p.service.carrierDescription>
		</cfif>

		<cfinclude template="/views/shop/dsp_serviceDescription.cfm">
	</cfcase>

	<cfcase value="searchResults">
		<cfset request.currentTopNav = "shop.searchResults">
		<!--- 1.) model calls --->
		<!--- 2.) view calls --->
		<!--- 3.) dsp include(s) --->
		<cfinclude template="/views/shop/dsp_temp.cfm">
	</cfcase>

	<cfcase value="browsePrePaids">
		<cfset request.currentTopNav = 'prepaid.browse' />

		<cfif isDefined('request.p.prePaidFilter.submit')>
			<cfset prepaidFilter.saveFilterSelections(formFields = request.p) />
			<cflocation addtoken="false" url="/index.cfm/go/#request.p.go#/do/#request.p.do#/" />
		</cfif>

		<cfset workflowHTML = trim(application.view.cart.renderWorkflowController()) />
		<cfset filterData = prepaidFilter.getFilterData() />
		<cfset filterHTML = trim(application.view.prePaidFilter.renderFilterInterface(variables.filterData)) />
		<cfset productHTML = trim(application.view.prePaid.browseProducts()) />
		<cfset local_compareMethod = 'comparePrePaids' />
		<cfset local_filterSelections = session.prePaidFilterSelections />
		<cfset local_filterName = 'prePaidFilter' />

		<cfinclude template="/views/shop/dsp_browseProducts.cfm" />
	</cfcase>

	<cfcase value="browsePrePaidsResults,browsePrePaidResults">
		<cfset request.layoutfile = "noLayout">
		<cfset productClass = '' />

		<!--- if form (filter) data was submitted --->
		<cfif isDefined("request.p.prePaidFilter.submit")>
			<cfset prepaidFilter.saveFilterSelections(formFields=request.p)>
		</cfif>
		<cfset request.p.sort = prepaidFilter.getSort()>

		<cfif request.p.do eq 'browsePrePaidResults'>
			<cfset productClass = 'Prepaid' />
		</cfif>

		<cfset productData = application.model.PrePaid.getByFilter(sort=request.p.sort)>
		<cfset productHTML = application.view.PrePaid.browseProductsResults(productData=productData, ProductClass = productClass)>

		<cfinclude template="/views/shop/dsp_browseProductsResults.cfm">
	</cfcase>

	<cfcase value="prePaidDetails">
		<cfparam name="request.p.activeTab" type="string" default="features">
		<!--- TRV: adding validation on request.p.productId and redirecting if it doesn't appear to be a valid value --->
		<cfif not isDefined("request.p.productID") or not len(trim(request.p.productID)) or not isNumeric(request.p.productID)>
			<cflocation addtoken="false" url="/index.cfm/go/shop/do/browsePrepaids/">
		</cfif>

		<cfset request.currentTopNav = "phones.detail">

		<cfset workflowHTML = application.view.Cart.renderWorkflowController()>

		<cfset productData = application.model.PrePaid.getByFilter(idList=request.p.productid)>
		<!--- TRV: logic to handle in the event that the user would up here on a datacardnetbook product --->

		<!--- If product could no longer be found, do a redirect. --->
		<cfif not productData.recordCount>
			<cfheader statuscode="301" statustext="Moved permanently" />
			<cfheader name="Location" value="/index.cfm" />

			<cfabort />
		</cfif>

		<cfif not productData.recordCount>
			<cfset productData = application.model.DataCardAndNetbook.getByFilter(idList=request.p.productid)>
			<cfif productData.recordCount>
				<cfset request.p.do = "dataCardAndNetbookDetails">
				<cfinclude template="index.cfm">
				<cfexit method="exittemplate">
			</cfif>
		</cfif>
		<cfset featuresData = application.model.PrePaid.getFeatures(productData.productID) />
		<cfset specsData = application.model.PrePaid.getSpecs(productData.productID) />
		<cfset freeAccessories = application.model.PrePaid.getFreeAccessories(productData.productID) />
		<cfset qMedia = application.model.product.getProductVideos( productData.productId ) />
		<cfset productHTML = application.view.PrePaid.productDetails( productData=productData, featuresData=featuresData,specsData=specsData, freeAccessories=freeAccessories, qVideos = variables.qMedia, activeTab=request.p.activeTab ) />

		<cfinclude template="/views/shop/dsp_productDetails.cfm" />
	</cfcase>

	<cfcase value="comparePrePaids">
		<cfparam name="request.p.formHidden_activationType" default="new">

		<!--- if form (filter) data was submitted --->
		<cfif isDefined("request.p.prePaidFilter.submit")>
			<cfif isDefined("request.p.removeID")>
				<!--- if the user clicked remove, take the ID out --->
				<cfset prepaidFilter.removeCompareId(request.p.removeID)>
			</cfif>

			<cfif structKeyExists(session, 'prePaidFilterSelections') and structKeyExists(session.prePaidFilterSelections, 'compareIds') and len(trim(session.prePaidFilterSelections.compareIds))>
				<cflocation addtoken="false" url="/index.cfm/go/#request.p.go#/do/#request.p.do#/formHidden_activationType/#request.p.formHidden_activationType#">
			<cfelse>
				<cflocation addtoken="false" url="/index.cfm/go/#request.p.go#/do/browsePrePaids">
			</cfif>
		</cfif>

		<cfset request.p.activationType = request.p.formHidden_activationType>
		<cfset request.currentTopNav = "phones.compare">

		<cfset workflowHTML = application.view.Cart.renderWorkflowController()>
		<cfset productData = application.model.PrePaid.getByFilter(idList=prepaidFilter.getUserSelectedFilterValuesByFieldName("compareIDs"))>
		<cfset productCompareData = application.model.PrePaid.getCompareData(prepaidFilter.getUserSelectedFilterValuesByFieldName("compareIDs"))>
		<cfset productHTML = application.view.PrePaid.compareProducts(productData=productData,productCompareData=productCompareData)>

		<cfinclude template="/views/shop/dsp_compareProducts.cfm">
	</cfcase>

	<cfcase value="tmoonedaysale">
		<cfinclude template="/views/shop/dspTmoOneDaySale.cfm" />
	</cfcase>

	<cfcase value="tmobile-htc-one-s-presale">
		<!--- Presale is over so redirecting to product details page to keep URL active --->
		<cflocation url="/index.cfm/go/shop/do/PhoneDetails/productId/5237" addtoken="false" />

		<cfset request.Title = 'T-Mobile HTC One S Presale' />
		<cfset request.MetaDescription = 'T-Mobile HTC One S Presale' />
		<cfset request.MetaKeywords = 'HTC One S, One S, T-Mobile, Presale, ' & channelConfig.getDisplayName() />
		<cfinclude template="/views/shop/dspTmoHtcOnePresale.cfm" />
	</cfcase>

	<cfcase value="sprint-htc-evo-pre-order">
		<!--- Presale is over so redirecting to product details page to keep URL active --->
		<cflocation url="/index.cfm/go/shop/do/PhoneDetails/productId/5256/" addtoken="false" />

		<cfset request.Title = 'Sprint HTC EVO 4G LTE Pre-order' />
		<cfset request.MetaDescription = 'Sprint HTC EVO 4G LTE Pre-order' />
		<cfset request.MetaKeywords = 'Sprint HTC Evo 4G LTE, HTC Evo, Sprint, Presale, Preorder, ' & channelConfig.getDisplayName() />
		<cfinclude template="/views/shop/dspSprintHtcEvoPresale.cfm" />
	</cfcase>

	<cfcase value="windows-8">
		<cfset request.Title = 'Windows 8' />
		<cfset request.MetaDescription = 'Windows 8' />
		<cfset request.MetaKeywords = 'Windows 8, Cell Phone, ' & channelConfig.getDisplayName() />
		<cfinclude template="/views/shop/dspWindows8.cfm" />
	</cfcase>

	<cfcase value="free-shipping-promo">
		<cfset request.Title = 'Free Holiday Shipping' />
		<cfset request.MetaDescription = 'Free Holiday Shipping' />
		<cfset request.MetaKeywords = 'Free Holiday Shipping, Cell Phone, ' & channelConfig.getDisplayName() />
		 <cfinclude template="/views/shop/dsp_freeShippingPromo.cfm" />
	</cfcase>


	<cfcase value="blackberry-10">
		<cfset request.Title = 'BlackBerry 10' />
		<cfset request.MetaDescription = 'BlackBerry 10' />
		<cfset request.MetaKeywords = 'BlackBerry 10, Cell Phone, ' & channelConfig.getDisplayName() />
		 <cfinclude template="/views/shop/dsp_BlackBerry10.cfm" />
	</cfcase>

	<cfcase value="apple-iphone">
		<cfset request.title = "Apple iPhone Comparison" />
		<cfset request.metaDescription = "Apple iPhone 5, 4s and 4." />
		<cfset request.metaKeywords = "Apple iPhone, Cell Phone, " & channelConfig.getDisplayName() />
		<cfinclude template="/views/shop/dsp_AppleiPhoneComparison.cfm" />
	</cfcase>

	
	<cfcase value="upgrade-checker,upgrade-checker-widget">

		<cfif cgi.server_port neq 443 and not request.config.disableSSL>
			<cflocation url="https://#cgi.server_name#/index.cfm#cgi.path_info#" addtoken="false" />
		</cfif>

		<cfset request.Title = 'Upgrade Eligibility Checker' />
		<cfset request.MetaDescription = 'Check your Upgrade Eligibility for AT&T, Verizon, T-Mobile and Sprint' />
		<cfset request.MetaKeywords = 'Upgrade Eligibility Checker, ' & channelConfig.getDisplayName() & ', AT&T, Verizon, T-Mobile, Sprint' />
		<cfset validator = CreateObject('component', 'cfc.model.FormValidation').init() />
		<cfset local.message = '' />
		<cfset local.isAccountLookupSuccessful = false />
		<cfset local.isUpgradeEligible = false />
		<cfset local.phoneListUrl = '' />

		<cfscript>
			if ( structKeyExists(form, 'upgradeFormSubmit') )
			{
				request.p.mdn = REReplace(request.p.mdn, "[^0-9A-Za-z ]", "", "all");

				validatorView = createobject('component', 'cfc.view.FormValidation').init();
				validator.addRequiredFieldValidator('mdn', request.p.mdn, 'Please enter the phone number you wish to check');

				if ( request.p.CarrierId neq 299)
				{
					validator.addRequiredFieldValidator('ssn', trim(request.p['ssn']), 'Please enter a valid SSN for account access.');
				}

				if ( request.p.CarrierId eq 299 && Len( Trim(request.p['accountpassword'])) )
				{
					validator.AddIsNumericValidator('accountpassword', trim(request.p['accountpassword']), 'Pin must contain only digits.');
					validator.AddFieldLengthValidator('accountpassword', trim(request.p['accountpassword']), 'Pin must be between six and ten digits in length.', 6, 10);
				}

				validator.addRequiredFieldValidator('zipcode', request.p.zipcode, 'Please enter the account''s billing zip code.');
				validator.addZipCodeValidator('zipcode', request.p.zipcode, 'Enter a valid Zip Code.');
			}


			if ( structKeyExists(form, 'emailNotificationSubmit') )
			{
				validatorView = createobject('component', 'cfc.view.FormValidation').init();
				validator.addRequiredFieldValidator('EmailNotification', request.p.EmailNotification, 'A valid email is required to receive an email notification.');

				if ( !validator.hasMessages() )
				{
					local.mdn = REReplace(request.p.mdn, "[^0-9A-Za-z ]", "", "all");

					notification = CreateObject('component', 'cfc.model.Notification').init();
					notification.setEmail( request.p.EmailNotification );
					notification.setSignUpDateTime( Now() );
					notification.setEligibleMdn( local.mdn );
					notification.setEligibilityDate( request.p.EligibilityDate );
					notification.setCarrierId( request.p.CarrierId );

					notification.save();

					local.message = 'Thanks!  We''ve received your request to be notified when ' & request.p.mdn & ' is eligible for upgrade.';
					request.p.mdn = ''; //clear mdn
				}
			}

			if ( !validator.hasMessages() && structKeyExists(form, 'upgradeFormSubmit') )
			{
				//application.model.Util.cfdump( form );
				//application.model.Util.cfabort();

				if ( request.p.carrierId eq 42 )
				{
					local.referenceNumber = 'WAC' & GetTickCount();
				}
				else
				{
					local.referenceNumber = GetTickCount();
				}

				local.lookupArgs = {
					Carrier = request.p.carrierId
					, Mdn = request.p.mdn
					, ZipCode = request.p.zipcode
					, ReferenceNumber = local.referenceNumber
					, ServiceZipCode = request.p.zipcode
				};

				if (request.p.CarrierId eq 109 || request.p.CarrierId eq 299)
				{
					local.lookupArgs.ActivationType = 'Upgrade';
				}

				if (request.p.CarrierId eq 299)
				{
					local.lookupArgs.Pin = request.p.accountpassword;
				}
				else
				{
					local.lookupArgs.Pin = request.p.ssn;
				}

				if (structKeyExists(request.p, 'accountpassword'))
				{
					local.lookupArgs.AccountPassword = request.p.accountpassword;
				}

				local.lookupResult = application.model.customerLookup.lookup( argumentCollection = local.lookupArgs );

				switch( local.lookupResult.getResultCode() )
				{
					case 'CL001':
					{
						local.isAccountLookupSuccessful = true;
						local.formattedMdn = Left(request.p.mdn, 3) & '-' & Mid(request.p.mdn, 4,3) & '-' & Right(request.p.mdn, 4);

						if ( local.lookupResult.getResult().canUpgradeEquipment )
						{
							local.isUpgradeEligible = true;
							local.message = 'Congratulations! You are currently eligible to upgrade your phone!';

							//Add http to redirect URL due to switch from https ignoring filters
							switch(request.p.carrierId)
							{
								case 42:
									local.phoneListUrl = 'http://#cgi.SERVER_NAME#:80/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,3,33/';
									break;
								case 109:
									local.phoneListUrl = 'http://#cgi.SERVER_NAME#:80/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,1,33/';
									break;
								case 128:
									local.phoneListUrl = 'http://#cgi.SERVER_NAME#:80/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,2,33/';
									break;
								case 299:
									local.phoneListUrl = 'http://#cgi.SERVER_NAME#:80/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,230,33/';
									break;
								default:
									local.phoneListUrl = 'http://#cgi.SERVER_NAME#:80/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,33/';
									break;
							}
						}
						else
						{
							if ( IsDate(local.lookupResult.getResult().EquipmentUpgradeEligibilityDate) )
								local.EligibilityDate = DateFormat( local.lookupResult.getResult().EquipmentUpgradeEligibilityDate, 'm/d/yyyy');
							else
								local.EligibilityDate = Trim(local.lookupResult.getResult().EquipmentUpgradeEligibilityDate);

							if ( Len(local.EligibilityDate) )
								local.message = 'You will be eligible for upgrade on ' & local.EligibilityDate;
							else
								local.message = 'You are not eligible for an upgrade at this time';
						}

						//Clear all form elements except the chosen carrier
						request.p.mdn = '';
						request.p.zipcode = '';
						request.p.ssn = '';
						request.p.accountpassword = '';

						break;
					}
					case 'CL002':
					{
						local.message = 'We are unable to locate your account with the information you have provided.  Please review your information and try again.';
						break;
					}
					default:
					{
						local.message = 'We are currently experiencing technical difficulties. Please try again later.';
						break;
					}
				}
			}
		</cfscript>

		<cfif request.p.do eq 'upgrade-checker-widget'>
			<cfset request.layoutFile = 'basic' />
		</cfif>

		<cfinclude template="/views/shop/dsp_UpgradeCheckerWidget.cfm" />
	</cfcase>


	<cfcase value="throwerror">
		<cfinclude template="/views/shop/dsp_throwerror.cfm" />
	</cfcase>

	<cfdefaultcase>
		<cflocation url="/index.cfm/go/content/do/home/" addtoken="false" />
	</cfdefaultcase>
</cfswitch>
