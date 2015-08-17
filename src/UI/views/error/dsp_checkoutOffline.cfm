<cfset channelConfig = application.wirebox.getInstance('ChannelConfig') />
<cfoutput>
	<h1>Checkout Temporarily Offline</h1>
	<p>
		We're sorry. Although checkout is temporarily unavailable, you can continue to browse and research as usual. 
	</p>
	<p>
		The checkout portion of our site is currently offline for scheduled maintenance.  We appreciate your patience.
	</p>
	<p>
		If you need further assistance, please contact us during our regular business hours.
	</p>
	<p>
		<blockquote style="font-size:1.2em;">
			Customer Service Email: <a href="mailto:#channelConfig.getCustomerCareEmail()#">#channelConfig.getCustomerCareEmail()#</a><br>
			Customer Service Phone: #channelConfig.getCustomerCarePhone()#<br>
			Monday through Friday: 6:00am - 6:00pm Pacific Standard Time.<br>
		</blockquote>
	</p>
</cfoutput>