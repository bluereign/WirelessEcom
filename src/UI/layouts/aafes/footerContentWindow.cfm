<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />
<cfset googleAnalyticsTracker = application.wirebox.getInstance("GoogleAnalyticsTracker") />
<cfset mercentAnalyticsTracker = application.wirebox.getInstance("MercentAnalyticsTracker") />

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=EDGE"><!-- IE8 mode -->
    <title>Exchange Mobile Center - Wireless Advocates</title>
	<cfinclude template="_cssAndJs.cfm">
	<cfif channelConfig.getTrackMercentAnalytics()>
		#mercentAnalyticsTracker.tagPage()#
	</cfif>	
	#googleAnalyticsTracker.tagPage()#
</head>
<body>
	<div>
		#request.bodycontent#
	</div>
</body>
</html>
</cfoutput>
<cfset request.bodycontent = ""> <!--- TRV: adding this to prevent all the generated inner HTML from showing up in the debug output dump of request variables --->
