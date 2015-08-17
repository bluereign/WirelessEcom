<cfset assetPaths = application.wirebox.getInstance("assetPaths") />

<html>
	<head>
		<title></title>
	</head>
	<body style="padding: 0px; margin: 0px">

		<cfif url.planType is 'addaline'>
			<cfset planType = 'Add-a-Line' />
		<cfelseif url.planType is 'upgrade'>
			<cfset planType = 'Upgrade' />
		<cfelseif url.planType is 'new'>
			<cfset planType = 'New 2-Year Activation' />
		<cfelse>
			<cfset planType = url.planType />
		</cfif>

		<cfif url.cartType is 'new'>
			<cfset cartType = 'New 2-Year Activation' />
		<cfelseif url.cartType is 'upgrade'>
			<cfset cartType = 'Upgrade' />
		<cfelseif url.cartType is 'addaline'>
			<cfset cartType = 'Add-a-Line' />
		<cfelse>
			<cfset cartType = url.cartType />
		</cfif>

		<cfset promptMessage = 'Our site <strong>does not support #variables.cartType#s and #variables.planType#s</strong> at the same time. Finish your current #variables.cartType# transaction and then perform the #variables.planType# as a new transaction. If you do not wish to do a #variables.cartType# clear your cart before proceeding with your #variables.planType#.' />

		<cfoutput>
			<table width="100%" cellpadding="3" cellspacing="0" border="0">
				<tr valign="middle">
					<td width="1">
						<cfif url.carrierID eq 109>
							<img src="#assetPaths.common#images/carrierLogos/att_175.gif" alt="AT&T" />
						<cfelseif url.carrierID eq 128>
							<img src="#assetPaths.common#images/carrierLogos/tmobile_175.gif" alt="T-Mobile" />
						<cfelseif url.carrierID eq 42>
							<img src="#assetPaths.common#images/carrierLogos/verizon_175.gif" alt="Verizon" />
						</cfif>
					</td>
					<td style="text-align: center"><h3 style="color: maroon">Incompatible Activation Type</h3></td>
				</tr>
			</table>
			<table width="100%" cellpadding="3" cellspacing="0" border="0">
				<tr valign="top">
					<td style="font-size: 12pt">#trim(variables.promptMessage)#</td>
					<td width="200" align="center" style="text-align: center"><img src="#assetPaths.common#images/ui/1286310257_preferences-desktop-notification.png" width="75" /></td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2" align="center" style="text-align: center">
						<span class="actionButton"><a href="##" onclick="ColdFusion.navigate('/index.cfm/go/cart/do/redirectToFilter/carrierId/#url.carrierId#/activationType/#url.cartType#/');">Continue Shopping</a></span>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<span class="actionButton"><a href="##" onclick="if(confirm('Are you sure you want to clear your cart?')){ ColdFusion.navigate('/index.cfm/go/cart/do/clearCart/blnDialog/1/carrierId/#url.carrierId#/activationType/#url.cartType#/'); };return false;">Clear Cart</a></span>
					</td>
				</tr>
			</table>
		</cfoutput>
	</body>
</html>