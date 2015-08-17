<cfcomponent output="false">

	<cffunction name="init" returntype="Warranty">
		<!--- Remove this when this component is added to CS --->        
        <cfset setAssetPaths( application.wirebox.getInstance("assetPaths") ) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="browseSearchResults" access="public" output="false" returntype="string">
		<cfargument name="data" type="query" required="true">
		<cfargument name="bindAjaxOnLoad" type="boolean" default="true">
		<cfset var local = structNew()>
		<cfset local.c = "">

		<cfsavecontent variable="local.c">
			<ul id="prodList" class="prodList">
				<cfoutput query="arguments.data">
					<li class="prodItem">
						<div class="prodImg" style="width: 150px">
							<cfif arguments.data.CompanyName[arguments.data.currentRow] eq 'SquareTrade'>
								<img src="#getAssetPaths().common#images/carrierLogos/squaretrade.png" alt="SquareTrade" title="SquareTrade" width="130" />
							<cfelseif arguments.data.CompanyName[arguments.data.currentRow] eq 'ServicePak'>
								<img src="#getAssetPaths().common#images/carrierLogos/servicePak.png" alt="ServicePak" title="ServicePak" width="110" />
							<cfelseif arguments.data.CompanyName[arguments.data.currentRow] eq 'Apple'>
								<img src="#getAssetPaths().common#images/carrierLogos/applecare.png" alt="AppleCare" title="AppleCare" width="130" />
							</cfif>
							
							<div class="toolbar"></div>
						</div>
						<div class="prodDetail">
							<cfif request.config.debugInventoryData>
								<div id="inventoryDebugIcon_#arguments.data.productId[arguments.data.currentRow]#" class="inventoryDebugIcon" onmouseover="revealInventoryDebugInfo(#arguments.data.productId[arguments.data.currentRow]#,this);document.body.style.cursor='pointer';"></div>
								<div id="inventoryDebugInfo_#arguments.data.productId[arguments.data.currentRow]#" class="inventoryDebugInfo" onmouseout="hideInventoryDebugInfo(this);document.body.style.cursor='';">
									<div style="float:left;">GERS SKU:</div><div style="float:right;">#arguments.data.GersSku[arguments.data.currentRow]#</div><br/>
									<div style="float:left;">Product ID:</div><div style="float:right;">#arguments.data.ProductId[arguments.data.currentRow]#</div><br/>
								</div>
							</cfif>
							<h2><a href="/index.cfm/go/shop/do/warrantyDetails/productId/#arguments.data.ProductId[arguments.data.currentRow]#">#trim(arguments.data.summaryTitle[arguments.data.currentRow])#</a></h2>
							<div class="prodDesc">#trim(arguments.data.ShortDescription[arguments.data.currentRow])#</div>
						</div>
						<div class="prodPrice">
							<div class="details-price-container">
								<div class="priceblock-container">
									<div class="summary-container">
										<table class="price-table">
											<tr>
												<td>Price</td>
												<td class="price-col">
													<div class="final-price-container">#DollarFormat(data.price[data.currentRow])#</div>
												</td>
											</tr>
										</table>
									</div>
								</div>
							</div>
						</div>
					</li>
				</cfoutput>
			</ul>
		</cfsavecontent>
		
		<cfreturn local.c />
	</cffunction>
	
	<cffunction name="getAssetPaths" access="private" output="false" returntype="struct">    
    	<cfreturn variables.instance.assetPaths />    
    </cffunction>    
    <cffunction name="setAssetPaths" access="private" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance.assetPaths = arguments.theVar />    
    </cffunction>
    
</cfcomponent>	