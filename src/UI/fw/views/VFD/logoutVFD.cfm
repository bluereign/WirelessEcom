<cfset channelConfig = application.wirebox.getInstance("ChannelConfig")/>

<cfoutput >
<div>
	<span style="font-size:x-large;font-weight:bold">
		Please log back in to <a href="#channelConfig.getWA2GOurl()#">WA2GO</a> to perform another Direct Delivery transaction.
	</span>
</div>
</cfoutput>