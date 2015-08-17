<cfparam name="request.p.do" default="home" type="string" />
<cfparam name="request.currentTopNav" default="home.home" type="string" />
<cfparam name="request.config.disableSSL" default="false" type="boolean" />
<cfif cgi.server_port eq 443>
	<cflocation url="http://#cgi.server_name#/index.cfm/go/content/do/#request.p.do#" addtoken="false" />
</cfif>

<cfset DynamicViewRenderer = application.wirebox.getInstance("DynamicViewRenderer")>
<cfset eventAction = REReplace(request.p.do, '-', '', 'all') />
<cfset event = "#request.p.go#.#eventAction#" />

<cfset request.template.showall = true>

<cfset request.template.showheader = true>

<cfswitch expression="#request.p.do#">

	<cfcase value="DisplayVideo">
		<cfset args.rc = request.p />

		<cfinvoke
		    component = "cfc.controller.ContentController"
		    method = "#request.p.do#"
		    returnvariable = "results"
		    argumentCollection = "#args#" />

		<cfoutput>#results#</cfoutput>
	</cfcase>

	<cfcase value="Samsung-Galaxy-S-4">
		<cfset DynamicViewRenderer.render(event)>
	</cfcase>

	<cfcase value="T-Mobile-Plans">
		<cfset args.rc = request.p />
		<cfset actionMethod = REReplace(request.p.do, '-', '', 'all') />

		<cfinvoke
		    component = "cfc.controller.ContentController"
		    method = "#actionMethod#"
		    returnvariable = "results"
		    argumentCollection = "#args#" />

		<cfoutput>#results#</cfoutput>
	</cfcase>

	<cfcase value="T-Mobile-Simple-Choice-Plans">
		<cfset args.rc = request.p />
		<cfset actionMethod = REReplace(request.p.do, '-', '', 'all') />

		<cfinvoke
		    component = "cfc.controller.ContentController"
		    method = "#actionMethod#"
		    returnvariable = "results"
		    argumentCollection = "#args#" />

		<cfoutput>#results#</cfoutput>
	</cfcase>

	<cfcase value="T-Mobile-Jump">
		<cfset args.rc = request.p />
		<cfset actionMethod = REReplace(request.p.do, '-', '', 'all') />

		<cfinvoke
		    component = "cfc.controller.ContentController"
		    method = "#actionMethod#"
		    returnvariable = "results"
		    argumentCollection = "#args#" />

		<cfoutput>#results#</cfoutput>
	</cfcase>

	<!--- Non-controller actions ---->

	<cfcase value="home">
		<cfset request.currentTopNav = 'home.home' />
		<cfset DynamicViewRenderer.render(event)>
	</cfcase>
	
	<cfcase value="phonesHome">
		<cfset request.currentTopNav = 'phones.home' />
		<cfset DynamicViewRenderer.render(event)>
	</cfcase>
	
	<cfcase value="plansHome">
		<cfset request.currentTopNav = "plans.home" />
		<cfset DynamicViewRenderer.render(event)>
	</cfcase>
		
	<cfcase value="accessoriesHome">
		<cfset request.currentTopNav = 'accessories.home' />
		<cfset DynamicViewRenderer.render(event)>
	</cfcase>
	
	<cfcase value="toolsHome">
		<cfset request.currentTopNav = "tools.home" />
		<cfset DynamicViewRenderer.render(event) />
	</cfcase>

	<cfcase value="FAQ">
		<cfset request.sublayoutfile = 'customerservice' />
		<cfset DynamicViewRenderer.render(event)>
	</cfcase>

	<cfcase value="terms">
		<cfset request.sublayoutfile = 'customerservice' />
		
		<cfset DynamicViewRenderer.render(event) />
	</cfcase>

	<cfcase value="privacy">
		<cfset request.sublayoutfile = 'customerservice' />
		<cfset DynamicViewRenderer.render(event) />
	</cfcase>

	<cfcase value="shipping">
		<cfset request.sublayoutfile = 'customerservice' />
		<cfset DynamicViewRenderer.render(event) />
	</cfcase>

	<cfcase value="returns">
		<cfset request.sublayoutfile = 'customerservice' />
		<cfset DynamicViewRenderer.render(event) />
	</cfcase>

	<cfcase value="serviceAgreement">
		<cfset request.sublayoutfile = 'customerservice' />
		<cfset DynamicViewRenderer.render(event) />
	</cfcase>

	<cfcase value="customerService">
		<cfset request.sublayoutfile = 'customerservice' />
		<cfset DynamicViewRenderer.render(event) />
	</cfcase>

	<cfcase value="customerServiceDetails">
		<cfset url.details = true />
		<cfset request.sublayoutfile = 'customerservice' />
		<cfset DynamicViewRenderer.render(event) />
	</cfcase>

	<cfcase value="contact">
		<cfset request.sublayoutfile = 'customerservice' />
		<cfset DynamicViewRenderer.render(event) />
	</cfcase>

	<cfcase value="howShop">
		<cfset request.sublayoutfile = 'customerservice' />
		<cfset DynamicViewRenderer.render(event) />
	</cfcase>

	<cfcase value="rebateCenter">
		<cfset request.sublayoutfile = 'customerservice' />
		<cfset DynamicViewRenderer.render(event) />
	</cfcase>

	<cfcase value="displayDocument">
		<cfset request.sublayoutfile = 'customerservice' />
		<cfset DynamicViewRenderer.render(event) />
	</cfcase>

	<cfcase value="refunds">
		<cfset request.sublayoutfile = 'customerservice' />
		<cfset DynamicViewRenderer.render(event) />
	</cfcase>

	<cfcase value="aboutUs">
		<cfset request.template.showheader = false / >
		<cfset request.sublayoutfile = 'customerservice' />
		<cfset DynamicViewRenderer.render(event) />
	</cfcase>

	<cfcase value="sitemap">
		<cfset request.sublayoutfile = 'customerservice' />
		<cfset DynamicViewRenderer.render(event) />
	</cfcase>

	<cfcase value="viewVideo">
		<cfset qMedia = application.model.Product.getProductMultimedia( request.p.productId ) />
		<cfset DynamicViewRenderer.render(event) />
	</cfcase>

	<cfcase value="activatingPhone">
		<cfset request.sublayoutfile = 'customerservice' />
		<cfset DynamicViewRenderer.render(event) />
	</cfcase>

	<cfcase value="summary">
		<cfset request.layout = 'support' />
		<cfset request.sublayoutfile = 'customerservice' />
		<cfset DynamicViewRenderer.render(event) />
	</cfcase>

	<cfcase value="earlyTermination">
		<cfset request.sublayoutfile = 'customerservice' />
		<cfset DynamicViewRenderer.render(event) />
	</cfcase>	

	<cfcase value="serviceTypeOverview">
		<cfset request.sublayoutfile = 'customerservice' />
		<cfset DynamicViewRenderer.render(event) />
	</cfcase>

	<cfcase value="supplychain">
		<cfset request.sublayoutfile = 'customerservice' />
		<cfset DynamicViewRenderer.render(event) />
	</cfcase>

	<cfcase value="militaryDeployment">
		<cfset request.layoutFile = 'noLayout' />
		<cfset DynamicViewRenderer.render(event) />
	</cfcase>

	<cfcase value="militaryDiscount">
		<cfset request.layoutFile = 'noLayout' />
		<cfset DynamicViewRenderer.render(event) />
	</cfcase>

	<cfcase value="militaryDeploymentPage">
		<cfif request.config.serviceBusRequest.channelName eq "AAFESDOTCOM">
			<cfset request.sublayoutFile = 'customerservice' />
			<cfset event = "content.militaryDeployment">
			<cfset DynamicViewRenderer.render(event) />
		<cfelse>
			<cflocation url="/" addtoken="false" />
		</cfif>
	</cfcase>

	<cfcase value="militaryDiscountPage">
		<cfif request.config.serviceBusRequest.channelName eq "AAFESDOTCOM">
			<cfset request.sublayoutFile = 'customerservice' />
			<cfset event = "content.militaryDiscount">
			<cfset DynamicViewRenderer.render(event) />
		<cfelse>
			<cflocation url="/" addtoken="false" />
		</cfif>
	</cfcase>

	<cfcase value="storeLocator">
		<cfset request.sublayoutfile = 'customerservice' />
		<cfset DynamicViewRenderer.render(event) />
	</cfcase>

	<cfcase value="apple-iphone-Comparison">
		<cfset event = "content.iphoneComparison" />
		<cfset DynamicViewRenderer.render(event) />
	</cfcase>

	<cfcase value="Device-Protection">
		<cfset event = "content.DeviceProtection" />
		<cfset DynamicViewRenderer.render(event) />
	</cfcase>

	<cfcase value="T-Mobile-In-Store-Offers">
		<cfset event = "content.TMobileInStoreOffers" />
		<cfset DynamicViewRenderer.render(event) />
	</cfcase>
	
</cfswitch>

