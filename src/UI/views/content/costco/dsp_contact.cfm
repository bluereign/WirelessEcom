<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />

<h1><a href="#local.contentURL#/contact">Contact Us</a></h1>

<p>
	<b>Customer Service Email:</b> <br />
	<a href="mailto:<cfoutput>#channelConfig.getCustomerCareEmail()#</cfoutput>"><cfoutput>#channelConfig.getCustomerCareEmail()#</cfoutput></a>
</p>
<p>
	<b>Customer Service Phone:</b><br />
	<cfoutput>#channelConfig.getCustomerCarePhone()#</cfoutput> </br>
	Monday - Friday 6am - 6pm Pacific Standard Time
</p>
