<cfoutput>
	
<cfif prc.qAccessory.RecordCount>
	<table id="accessoryTable" cellpadding="3" cellspacing="0" border="0" style="margin-left: auto; margin-right: auto">
		<cfloop query="prc.qAccessory">
			<cfset local.stcFeeAccessoryPrimaryImages = application.model.imageManager.getPrimaryImagesForProducts(valueList(prc.qAccessory.accessoryGuid)) />
			<tr valign="top">
				<td width="100" align="center" style="text-align: center">
					<cfif structKeyExists(local.stcFeeAccessoryPrimaryImages, prc.qAccessory.accessoryGuid[prc.qAccessory.currentRow])>
						<a href="/index.cfm/go/shop/do/accessoryDetails/product_id/#prc.qAccessory.productId[prc.qAccessory.currentRow]#/pId/#rc.pid#"><img src="#application.view.imageManager.displayImage(imageGuid = local.stcFeeAccessoryPrimaryImages[prc.qAccessory.accessoryGuid[prc.qAccessory.currentRow]], height=100, width=0)#" alt="#htmlEditFormat(prc.qAccessory.summaryTitle[prc.qAccessory.currentRow])#" height="100" border="0" /></a>
					<cfelse>
						<a href="/index.cfm/go/shop/do/accessoryDetails/product_id/#prc.qAccessory.productId[prc.qAccessory.currentRow]#/pId/#rc.pid#"><img src="#prc.assetPaths.common#images/catalog/noimage.jpg" height="100" border="0" alt="#htmlEditFormat(prc.qAccessory.summaryTitle[prc.qAccessory.currentRow])#" /></a>
					</cfif>
				</td>
				<td>
					<a href="/index.cfm/go/shop/do/accessoryDetails/product_id/#prc.qAccessory.productId[prc.qAccessory.currentRow]#/pId/#rc.pid#">#prc.qAccessory.summaryTitle[prc.qAccessory.currentRow]#</a>
					<span style="font-size: 8pt">#trim(prc.qAccessory.summaryDescription[prc.qAccessory.currentRow])#</span>
				</td>
				<td width="50" align="right" style="text-align: right; white-space: nowrap; font-weight: normal">
					<span style="font-size: 10pt; font-weight: bold; color: maroon">#dollarFormat(prc.qAccessory.price_retail[prc.qAccessory.currentRow])#</span>&nbsp;&nbsp;
					<br /><br />
					<span class="actionButton" style="font-weight: normal">
						<a onclick="addToCart('accessory', '#prc.qAccessory.productId[prc.qAccessory.currentRow]#', 1);return false;" href="##">Add to Cart</a>
					</span>
				</td>
			</tr>
		</cfloop>
	</table>
<cfelse>	
	<p>No records found.</p>
</cfif>

</cfoutput>