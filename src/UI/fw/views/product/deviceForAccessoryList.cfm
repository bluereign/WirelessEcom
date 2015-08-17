<cfoutput>
<cfif prc.qDevice.RecordCount>
	<table cellpadding="3" cellspacing="0" border="0" style="width: 520px; margin-left: auto; margin-right: auto">
		<cfloop query="prc.qDevice">
			<cfset sesTitle = prc.stringUtil.friendlyUrl( prc.qDevice.summaryTitle[prc.qDevice.currentRow] ) />
			<tr valign="top">
				<td width="100" align="center" style="text-align: center">
					<cfif Len(prc.qDevice.ImageGuid[prc.qDevice.currentRow])>
						<a href="/#prc.qDevice.productId[prc.qDevice.currentRow]#/#sesTitle#"><img src="#application.view.imageManager.displayImage(imageGuid = prc.qDevice.ImageGuid[prc.qDevice.currentRow], height=100, width=0)#" alt="#htmlEditFormat(prc.qDevice.summaryTitle[prc.qDevice.currentRow])#" height="100" border="0" title="#htmlEditFormat(prc.qDevice.summaryTitle[prc.qDevice.currentRow])#" /></a>
					<cfelse>
						<a href="/#prc.qDevice.productId[prc.qDevice.currentRow]#/#sesTitle#"><img src="#prc.AssetPaths.common#images/catalog/noimage.jpg" height="100" border="0" alt="#htmlEditFormat(prc.qDevice.summaryTitle[prc.qDevice.currentRow])#" title="#htmlEditFormat(prc.qDevice.summaryTitle[prc.qDevice.currentRow])#" /></a>
					</cfif>
					<cfif prc.qDevice.carrierID[prc.qDevice.currentRow] eq 109>
						<br /><img src="#prc.AssetPaths.common#images/carrierLogos/att_175.gif" height="28" title="AT&T" alt="AT&T" style="horizontal-align: middle" />
					<cfelseif prc.qDevice.carrierID[prc.qDevice.currentRow] eq 128>
						<br /><img src="#prc.AssetPaths.common#images/carrierLogos/tmobile_175.gif" height="28" title="T-Mobile" alt="T-Mobile" style="horizontal-align: middle" />
					<cfelseif prc.qDevice.carrierID[prc.qDevice.currentRow] eq 42>
						<br /><img src="#prc.AssetPaths.common#images/carrierLogos/verizon_175.gif" height="28" title="Verizon" alt="Verizon" style="horizontal-align: middle" />
					<cfelseif prc.qDevice.carrierID[prc.qDevice.currentRow] eq 299>
						<br /><img src="#prc.AssetPaths.common#images/carrierLogos/sprint_175.gif" height="28" title="Sprint" alt="Sprint" style="horizontal-align: middle" />															
					</cfif>
				</td>
				<td>
					<a href="/#prc.qDevice.productId[prc.qDevice.currentRow]#/#sesTitle#">#prc.qDevice.summaryTitle[prc.qDevice.currentRow]#</a>
					<span style="font-size: 8pt">#trim( application.view.product.ReplaceRebate( prc.qDevice.summaryDescription[prc.qDevice.currentRow], prc.qDevice.CarrierId[prc.qDevice.currentRow], prc.qDevice.GersSku[prc.qDevice.currentRow] ))#</span>
				</td>
			</tr>
		</cfloop>
	</table>
<cfelse>	
	<p>No records found.</p>
</cfif>
</cfoutput>

