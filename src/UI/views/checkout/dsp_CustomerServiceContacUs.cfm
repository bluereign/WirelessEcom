<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />
<cfset googleAnalyticsTracker = application.wirebox.getInstance("GoogleAnalyticsTracker") />
<cfset mercentAnalyticsTracker = application.wirebox.getInstance("MercentAnalyticsTracker") />

<cfsavecontent variable="htmlhHeader">
	<style>
		body {
			margin: 0 auto;
			color: #333;
			font-family: Arial, Helvetica, sans-serif;
			font-size: 14px;
		}

		#contactus-container {
			background: #efefef;
			background-image: url('#getAssetPaths().common#images/upgradechecker/upgrade-checker-bg.png');
			background-repeat: repeat-x;
			margin: auto;
			height: 350px;
			border-radius: 5px 5px 5px 5px;
		}

		#contactus-title-bar {
			height: 60px;
			margin: auto;
			padding: 15px 5px 0 85px;
			background-image: url('#getAssetPaths().common#images/ui/customerservice-woman.png');
			background-repeat: no-repeat;
			background-position: 15px 5px;
		}
		
		#contactus-title-bar h1 {
			font-size: 22px;
			font-weight: 900;
			color: #0060a9;
		}
		
		#contactus-content {
			width: 450px;
			margin: 45px auto 0;
		}
		
		#contactus-container .header {
			font-size: 16px;
			display: block;
			margin: 25px auto 0;
			border-bottom: #ccc 1px solid;
			font-weight: bold;
		}
	</style>
</cfsavecontent>

<cfhtmlhead text="#htmlhHeader#" />

<cfoutput>
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
		<title>#request.title#</title>
		<meta name="Description" content="#request.MetaDescription#" />
		<meta name="Keywords" content="#request.MetaKeywords#" />
		<meta name="Title" content="#request.title#" />
		<cfif channelConfig.getTrackMercentAnalytics()>
			#mercentAnalyticsTracker.tagPage()#
		</cfif>	
		#googleAnalyticsTracker.tagPage()#
	</head>
	<body>

	<div id="contactus-container">
		<div id="contactus-title-bar">
			<h1>Have Questions? We can Help!</h1>
		</div>
		<div id="contactus-content">
			<p>
				<span class="header">Contact Us</span><br />
				Phone: #channelConfig.getCustomerCarePhone()# <br />
				<cfif Len(channelConfig.getCustomerCareEmail())>Email: #channelConfig.getCustomerCareEmail()# <br /></cfif>
			</p>
			<p>
				<span class="header">Hours</span> <br />
				Monday - Friday 6am - 6pm <br />
				Pacific Time <br />
			</p>
		</div>

	</div>
		
	</body>
</html>
</cfoutput>

<cfset request.bodyContent = '' />



