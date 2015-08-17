<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />

<cfoutput>		
		
<h1><a href="/index.cfm/go/content/contact">Contact Us</a></h1>

<p>
	<b>Customer Service Phone:</b><br />
	#channelConfig.getCustomerCarePhone()# </br>
	Monday - Friday 6am - 6pm Pacific Time
</p>

</cfoutput>