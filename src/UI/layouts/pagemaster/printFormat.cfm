<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />
<cfset googleAnalyticsTracker = application.wirebox.getInstance("GoogleAnalyticsTracker") />
<cfset mercentAnalyticsTracker = application.wirebox.getInstance("MercentAnalyticsTracker") />

<cfparam name="request.currentTopNav" default="phones">
<cfparam name="request.title" default="">
<cfparam name="request.includePricingCSS" type="boolean" default="false">
<cfset request.currentBodyId = listFirst(request.currentTopNav,".")>

<cfdocument format="PDF" fontembed="true" scale="98">
<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=100"><!-- IE8 mode -->
    <title><cfif len(request.title)>#request.title# : </cfif>Exchange Mobile Center - Wireless Advocates</title>
	<cfset request.p.media = "print">
	<cfinclude template="_cssAndJs.cfm">
	<cfif channelConfig.getTrackMercentAnalytics()>
		#mercentAnalyticsTracker.tagPage()#
	</cfif>	
	#googleAnalyticsTracker.tagPage()#
</head>
<body id="#request.currentBodyId#">
	<div id="mainContent">
		<div class="shim">
			#request.bodycontent#
		</div>
	</div>
</body>
</html>
</cfoutput>
</cfdocument>
<cfsetting showdebugoutput="false">