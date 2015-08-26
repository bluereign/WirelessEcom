<cfparam name="rc.deviceBuilderCssIncluded" default="false" />

<cfset assetPaths = application.wirebox.getInstance("assetPaths") />

<cfparam name="request.p.go" type="string" default="" />
<cfparam name="request.p.do" type="string" default="" />
<cfparam name="request.p.media" type="string" default="screen" /> 
<cfparam name="bJavascriptIncluded" type="boolean" default="false" />
<cfparam name="rc.bBootStrapIncluded" type="boolean" default="false" />
<cfparam name="rc.deviceBuilderCssIncluded" type="boolean" default="false" />

<cfoutput>
	<cfif rc.bBootStrapIncluded>
		<!-- Latest compiled and minified CSS -->
		<link rel="stylesheet" href="#assetPaths.common#scripts/bootstrap/3.2.0-custom/css/bootstrap.min.css" />
	</cfif>
	<cfif NOT rc.deviceBuilderCssIncluded>
		<link rel="stylesheet" media="#request.p.media#" type="text/css" href="#assetPaths.common#styles/wa-core.css?v=1.0.0" />
		<link rel="stylesheet" media="#request.p.media#" type="text/css" href="#assetPaths.channel#styles/main.css?v=2.0.5" />
		<link rel="stylesheet" media="#request.p.media#" type="text/css" href="#assetPaths.common#styles/cartDialog.css?v=1.0.6" />
		<link rel="stylesheet" media="#request.p.media#" type="text/css" href="#assetPaths.common#styles/verticalTabs.css?v=1.0.1" />
		<link rel="stylesheet" media="print" type="text/css" href="#assetPaths.common#styles/cartDialog_print.css" />
		<link rel="stylesheet" type="text/css" href="#assetPaths.common#scripts/prototip2.2.0.2/css/prototip.css" />		
	</cfif>
	<cfif rc.bBootStrapIncluded>
		<!-- Latest compiled and minified CSS -->
		<link rel="stylesheet" href="#assetPaths.common#scripts/bootstrap/override.css" />
	</cfif>
	<!-- Device Builder -->
	<cfif rc.deviceBuilderCssIncluded>
		<link rel="stylesheet" href="#assetPaths.channel#styles/devicebuilder.css" />
	</cfif>

	<cfif request.p.go is 'shop'>
		<script type="text/javascript" src="#assetPaths.common#scripts/tmobileCommisionJunction.js?v=1.0.0"></script>
		<cfif request.p.do contains 'browsePhones' or request.p.do contains 'browseDataCards' or request.p.do contains 'browsePrePaids'>
			<link rel="stylesheet" media="#request.p.media#" type="text/css" title="Costco" href="#assetPaths.common#styles/workflowController.css" />
		<cfelseif request.p.do contains 'browse'>
			<link rel="stylesheet" media="#request.p.media#" type="text/css" title="Costco" href="#assetPaths.common#styles/workflowController.css" />
		<cfelseif request.p.do contains 'compare'>
			<link rel="stylesheet" media="#request.p.media#" type="text/css" href="#assetPaths.common#styles/compare.css?v=1.0.1" />
			<link rel="stylesheet" media="print" type="text/css" href="#assetPaths.common#styles/compare_print.css" />
			<link rel="stylesheet" media="#request.p.media#" type="text/css" title="Costco" href="#assetPaths.common#styles/workflowController.css" />
		<cfelseif request.p.do contains 'details' or request.p.do contains 'services'>
			<link rel="stylesheet" media="#request.p.media#" type="text/css" title="Costco" href="#assetPaths.common#styles/workflowController.css" />
		</cfif>
	<cfelseif request.p.go is 'cart'>
		<link rel="stylesheet" media="#request.p.media#" type="text/css" href="#assetPaths.common#styles/checkout.css" />
		<link rel="stylesheet" media="print" type="text/css" href="#assetPaths.common#styles/checkout_print.css" />
	<cfelseif request.p.go is 'myAccount'>
		<link rel="stylesheet" media="#request.p.media#" type="text/css" href="#assetPaths.common#styles/myAccount.css" />
		<link rel="stylesheet" media="print" type="text/css" href="#assetPaths.common#styles/myAccount_print.css" />

		<cfif request.p.do is 'viewOrderHistoryDetails'>
			<link rel="stylesheet" media="#request.p.media#" type="text/css" href="#assetPaths.common#styles/orderHistoryDetails.css" />
			<link rel="stylesheet" media="print" type="text/css" href="#assetPaths.common#styles/orderHistoryDetails_print.css" />
		</cfif>
	<cfelseif request.p.go is 'checkout'>
		<link rel="stylesheet" media="#request.p.media#" type="text/css" href="#assetPaths.common#styles/checkout.css" />
	<cfelseif request.p.go is 'search'>
		<script type="text/javascript" src="#assetPaths.common#scripts/tmobileCommisionJunction.js?v=1.0.0"></script>	
	</cfif>

	<link rel="stylesheet" media="#request.p.media#" type="text/css" href="#assetPaths.common#styles/compat.css" />

	<cfif NOT bJavascriptIncluded>
		<script type="text/javascript" src="#assetPaths.common#scripts/libs/jquery-1.7.2.min.js"></script>
		<script type="text/javascript" src="#assetPaths.common#scripts/prototype.js" ></script>
		<script type="text/javascript" src="#assetPaths.common#scripts/prototip2.2.0.2/js/prototip/prototip.js"></script>
		<script type="text/javascript" src="#assetPaths.common#scripts/verticaltabs.js"></script>
		<script type="text/javascript" src="#assetPaths.common#scripts/cartDialog.js"></script>
		<script type="text/javascript" src="#assetPaths.common#scripts/analytics.js?v=1.0.2"></script>
		<script type="text/javascript" src="#assetPaths.common#scripts/prototype-bootstrap-conflict.js?v=1.0.0"></script>
		<link rel="stylesheet" media="screen" type="text/css" href="#assetPaths.common#scripts/lightbox/css/lightbox.css" />
		<link rel="stylesheet" media="screen" type="text/css" href="#assetPaths.channel#styles/dropdown.css" />
		
		<script src="http://code.jboxcdn.com/0.3.2/jBox.min.js"></script>
		<link href="http://code.jboxcdn.com/0.3.2/jBox.css" rel="stylesheet">

		<cfif request.config.debugInventoryData>
			<script type="text/javascript" src="#assetPaths.common#scripts/inventoryDebug.js"></script>
		</cfif>

		<cfset bJavascriptIncluded = true />
	</cfif>
	
	<cfif rc.bBootStrapIncluded>
		<!-- Latest compiled and minified JS -->
		<script type="text/javascript" src="#assetPaths.common#scripts/bootstrap/3.2.0-custom/js/bootstrap.min.js"></script>
	</cfif>

	<!-- Device Builder -->
	<cfif rc.deviceBuilderCssIncluded>
		<script type="text/javascript" src="#assetPaths.common#scripts/devicebuilder.min.js"></script>
	</cfif>
</cfoutput>
