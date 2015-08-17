<cfset assetPaths = application.wirebox.getInstance("AssetPaths") />
<cfoutput>
	<div class="details-sidebar details-sidebar-warranty">
		<div id="prodImage" class="prodImage">
			<!--- TODO: Need a new product property added to the database for logos --->
			<cfif warrantyData.CompanyName eq 'SquareTrade'>
				<img src="#assetPaths.common#images/carrierLogos/squaretrade.png" alt="SquareTrade" title="SquareTrade" />
			<cfelseif warrantyData.CompanyName eq 'ServicePak'>
				<img src="#assetPaths.common#images/carrierLogos/servicepak.png" alt="ServicePak" title="ServicePak" />
			<cfelseif warrantyData.CompanyName eq 'Apple'>
				<img src="#assetPaths.common#images/carrierLogos/applecare.png" alt="AppleCare+" title="AppleCare+" height="180" />				
			</cfif>
		</div>
		<div class="icons"></div>
	</div>
	<div class="main">
		<div class="prodDetail warranty-prodDetail">
			<cfif request.config.debugInventoryData>
				<div id="inventoryDebugIcon_#warrantyData.productId[warrantyData.currentRow]#" class="inventoryDebugIcon" onmouseover="revealInventoryDebugInfo(#warrantyData.productId[warrantyData.currentRow]#,this);document.body.style.cursor='pointer';"></div>
				<div id="inventoryDebugInfo_#warrantyData.productId[warrantyData.currentRow]#" class="inventoryDebugInfo" onmouseout="hideInventoryDebugInfo(this);document.body.style.cursor='';">
					<div style="float:left;">GERS SKU:</div><div style="float:right;">#warrantyData.GersSku[warrantyData.currentRow]#</div><br/>
					<div style="float:left;">UPC Code:</div><div style="float:right;">#warrantyData.UPC[warrantyData.currentRow]#</div><br/>
					<div style="float:left;">Price:</div><div style="float:right;">#warrantyData.Price[warrantyData.currentRow]#</div><br/>
					<div style="float:left;">Deductible:</div><div style="float:right;">#warrantyData.Deductible[warrantyData.currentRow]#</div><br/>
					<div style="float:left;">Contract Term:</div><div style="float:right;">#warrantyData.ContractTerm[warrantyData.currentRow]#</div><br/>
				</div>
			</cfif>
			<h1>#trim(warrantyData.SummaryTitle[warrantyData.currentRow])# <cfif warrantyData.productId[warrantyData.currentRow] eq 26037> Air<cfelseif warrantyData.productId[warrantyData.currentRow] eq 26852> Mini</cfif></h1>
			<div class="prodDesc">
				<div class="details-price-container details-price-container-warranty">
					<div class="priceblock-container">
						<div class="summary-container">
							<table class="price-table">
								<tr>
									<td>Price</td>
									<td class="price-col">
										<div class="final-price-container">#DollarFormat(warrantyData.price[warrantyData.currentRow])#</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="button-container">
							<!--- Warranty ID matches default Warranty ID --->
							<cfif channelConfig.getDefaultWarrantyPlanId() neq '' && request.p.ProductId eq channelConfig.getDefaultWarrantyPlanId()>
								<a class="ActionButton" href="##" onclick="addToCart('warranty','#warrantyData.ProductId#', 1);return false;"><span>Add to Cart</span></a>
							<!--- Warranty ID is compatible with device on line --->
							<cfelseif application.model.Warranty.IsDeviceCompatible( WarrantyId = request.p.ProductId, DeviceId = application.model.CartHelper.getLineDeviceProductId( session.cart.getCurrentLine() ) )>
								<a class="ActionButton" href="##" onclick="addToCart('warranty','#warrantyData.ProductId#', 1);return false;"><span>Add to Cart</span></a>
							<cfelse>
								<!--- Do not display Add to cart button --->
							</cfif>
						</div>
					</div>
				</div>
					
				#trim(warrantyData.LongDescription[warrantyData.currentRow])#

			</div>
		</div>
	</div>
</cfoutput>