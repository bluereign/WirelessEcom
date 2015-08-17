<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />
<cfset googleAnalyticsTracker = application.wirebox.getInstance("GoogleAnalyticsTracker") />
<cfset mercentAnalyticsTracker = application.wirebox.getInstance("MercentAnalyticsTracker") />

<cfparam name="request.currentTopNav" default="phones" type="string" />
<cfparam name="request.title" default="Checkout" type="string" />
<cfparam name="request.currentTopNav" default="phones" type="string" />
<cfparam name="request.includePricingCSS" type="boolean" default="false" />

<cfset request.currentBodyId = listFirst(request.currentTopNav, '.') />

<cfoutput>
<cfinclude template="_cssAndJs.cfm" />
<link rel="stylesheet" href="/assets/common/scripts/bootstrap/3.2.0-custom/css/bootstrap.min.css" />
<script type="text/javascript" src="/assets/common/scripts/prototype-bootstrap-conflict.js?v=1.0.0"></script>
<script type="text/javascript" src="/assets/common/scripts/bootstrap/3.2.0-custom/js/bootstrap.min.js"></script>
<link rel="stylesheet" media="screen" type="text/css" href="#assetPaths.common#styles/checkout.css?v=1.0.5" />

<script type="text/javascript">
var $j = jQuery.noConflict();
	
$j(document).ready(function($j) {

	 
	 $j('.bootstrap-popover').popover();	
		 	 
});

function printConfirmation(){
	parent.document.getElementById('confirmationPrint').contentWindow.print();
};
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta charset="utf-8" />
		<title><cfif len(trim(request.title))>#trim(request.title)# : </cfif>#ChannelConfig.getDisplayName()#</title>

		<meta http-equiv="X-UA-Compatible" content="IE=EDGE">
		
		<cfif channelConfig.getTrackMercentAnalytics()>
			#mercentAnalyticsTracker.tagPage()#
		</cfif>
		#googleAnalyticsTracker.tagPage()#
	</head>
	<body id="#request.currentBodyId#">
		<div class="bootstrap">
		<div class="container">
		<div id="header">
			<div class="shim" style="text-align: center; top: -6px">
				<div id="header-checkout">
					<a id="WAlogo" href="http://www.costco.com/" style="padding-top: 10px; padding-left: 25px"><img src="#assetPaths.channel#images/costco_logosm.gif" alt="Costco.Com" title="Return to the Costco.com homepage" /></a>
				</div>
				<!---<cfinclude template="_topNavCheckoutVFD.cfm" />--->
			</div>
			<div id="nav-menu-container">
			</div>
		</div>
		<div id="mainContent">
			<cfoutput>#renderView()#</cfoutput>				
		</div>
	</body>
</html>
</cfoutput>

<cfset request.bodycontent = '' />
