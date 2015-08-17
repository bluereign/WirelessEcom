<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />
<cfset googleAnalyticsTracker = application.wirebox.getInstance("GoogleAnalyticsTracker") />
<cfset mercentAnalyticsTracker = application.wirebox.getInstance("MercentAnalyticsTracker") />

<cfsavecontent variable="js">
	<cfoutput>	
		<link href="#assetPaths.common#scripts/videojs/video-js.css" rel="stylesheet" type="text/css">
		<script src="#assetPaths.common#scripts/videojs/video.js"></script>
		<script src="#assetPaths.common#scripts/libs/jquery-1.7.2.min.js"></script>
		
		<!-- Unless using the CDN hosted version, update the URL to the Flash SWF -->
		<script>
			_V_.options.flash.swf = "#assetPaths.common#scripts/videojs/video-js.swf";
		</script>
		
		<style type="text/css">
			video {
				max-width: 100%;
			}
		</style>
	</cfoutput>
</cfsavecontent>

<cfhtmlhead text="#js#" />

<cfoutput>
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
		<title>#request.Title#</title>
		<meta name="Description" content="#request.MetaDescription#" />
		<meta name="Keywords" content="#request.MetaKeywords#" />
		<meta name="Title" content="#request.Title#" />
		<cfif channelConfig.getTrackMercentAnalytics()>
			#mercentAnalyticsTracker.tagPage()#
		</cfif>	
		#googleAnalyticsTracker.tagPage()#
	</head>
	<body>	
		<div id="video-container">	
			<video id="video-player" class="video-js vjs-default-skin" controls preload="none" data-setup="{}"
				   <cfif Len(video.getPosterFileName())> poster="/media/poster/#video.getProductId()#/#video.getPosterFileName()#"</cfif>
				   width="680" height="380">
				<source src="/media/products/#video.getProductId()#/#video.getFileName()#.mp4" type='video/mp4' />
				<source src="/media/products/#video.getProductId()#/#video.getFileName()#.webm" type='video/webm' />
				<source src="/media/products/#video.getProductId()#/#video.getFileName()#.ogv" type='video/ogg' />
				<track kind="captions" src="captions.vtt" srclang="en" label="English" />
			</video>
		</div>
	</body>
</html>		
</cfoutput>

<cfsetting showDebugOutput="false" />	
	