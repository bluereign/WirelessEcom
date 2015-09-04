<cfparam name="request.hasWirelessItemBeenAdded" type="boolean" default="false">
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />

<cf_cartbody mode="edit" EnableCartReview="false">
	<cfoutput>
		<script language="javascript">
		<!--
			<!--- TRV: set a trigger to refresh the main window content when the cart dialog is closed after adding a wireless item that could affect the workflow controller --->
			<cfif request.hasWirelessItemBeenAdded>
				hasWirelessItemBeenAdded = true;
			</cfif>
		//-->
		</script>
		<div align="center">
			Your cart is currently empty.
			<br /><br /><br />
			<span class="actionButton">
				<cfif !channelConfig.getVfdEnabled()>
					<a href="/index.cfm">Continue Shopping</a>
				<cfelse>
					<a href="/mainVFD/homepageVFD">Continue Shopping</a>
				</cfif>
			</span>
		</div>
	</cfoutput>
</cf_cartbody>
