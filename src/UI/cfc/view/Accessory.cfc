<cfcomponent output="false" displayname="Accessory">

	<cffunction name="init" access="public" returntype="Accessory" output="false">
		<!--- Remove this when this component is added to CS --->        
        <cfset setAssetPaths( application.wirebox.getInstance("assetPaths") ) />
        <!---<cfset variables.StringUtil = application.wirebox.getInstance("StringUtil")  />--->
		<cfset variables.accessoryFilter = application.wirebox.getInstance("AccessoryFilter") />
		
		<cfreturn this />
	</cffunction>

	<cffunction name="browseFeaturedAccessories" access="public" returntype="string" output="false">
		<cfset var local = structNew() />
		
		<cfset local.featuredAccessoriesHTML = "">
		
		<cfif request.p.filter.phoneid NEQ "">
			
			<cfsavecontent variable="local.featuredAccessoriesHTML">
				<style>
			
					.prodList li.prodItemFeatured {
					  clear: none;
					  float: left;
					  width: 230px !important;
					  margin-left: 20px;
					  margin-bottom: 20px;
					  border: 1px solid #cfcfcf;
					  padding: 0px;
					  display: block;
					  
					}
					
					.accessoryPriceContainer {
						text-align:center;	
					}
					
					.accessoryPriceTitle {
						font-size:11px;	
					}
					
					.accessoryPrice {
					  color: #E1393D;
					  font-size: 25px;
					  font-weight: bold;
					  width: 100%;
					  margin-bottom: 2px;		
					  margin-left: 10px;
					}
					
					li.prodItemFeatured div.bottomContainer {
						width:230px;
						padding:10px 10px 0px 10px;
						min-height:140px;
					}
					
					
					li.prodItemFeatured:hover div.bottomContainer {
					}
					
					li.prodItemFeatured:hover {
						border-color:rgba(10,148,214,1);	
					}
					
					
					li.prodItemFeatured div.bottomContainerOverlay {
						display:block;
						height:60px;
						margin-top:0px;
					}
					
					li.prodItemFeatured:hover div.bottomContainerOverlay {	
						display:block;
						width:230px;
						height:60px;
						background-color:rgba(10,148,214,1);
						-webkit-transition: background-color 200ms, bottom 100ms,-webkit-transform 200ms;
						-moz-transition: background-color 200ms, bottom 100ms,-moz-transform 200ms;
						-o-transition: background-color 200ms, bottom 100ms,-o-transform 200ms;
						transition: background-color 200ms, bottom 100ms, transform 200ms;	
					}
					
					.prodList div.bottomContainerOverlay .blockCTA {
						padding-bottom:10px;
						text-align:center;
						display:block;
					}
					
					div.accessorySummary {
						padding:0px 5px;
						min-height:80px;
						width:200px;
						
					}			
								
					div.accessorySummary a {
						font-size:20px;	
						text-decoration:none;
						color:grey;
					}
					
					div.accessorySummary a:hover {
						color: #0060A9;
					}			
								
					.prodList div.bottomContainerOverlay .ctaButton {	
						display: inline-block;
						width:80px;
						margin-left:10px;
						margin-top:20px;
						
					}
					
					
					.prodList div.bottomContainerOverlay .ctaButton .ActionButtonFeatured .buttonText {	
						border: 1px solid green;
						color: white;
						background: green;
					}
					
					.prodList div.bottomContainerOverlay .ctaButton .ActionButtonFeatured .buttonText:hover {	
						color: green ;
						background: white;
						border: 1px solid black;
					}
					
								
					.prodList div.bottomContainerOverlay .ctaButton .ActionButtonFeaturedNotPrimary .buttonText {
						background: grey;	
						border: 1px solid grey;
					}			
					
					.prodList div.bottomContainerOverlay .ctaButton .ActionButtonFeaturedNotPrimary .buttonText:hover {
						color: grey;
						background: white;	
						border: 1px solid black;
					}	
									
					.prodList div.bottomContainerOverlay .ctaButton a {
						text-decoration:none;
					}
					
									
					.prodList div.bottomContainerOverlay .ctaButton .buttonText {
						background: linear-gradient(to bottom, #8bcd68 0%, #65b43c 5%, #518f30 100%) repeat scroll 0 0 rgba(0, 0, 0, 0);
						border:1px solid #0F0;
						border-radius:2px;
						color:#fff;
						font-weight:bold;
						text-align:center;
						font-size:16px;
						padding:8px 15px !important;
						margin:5px 0px;
						width:80px;
						
					}
					
					.main.left.accessories {
						padding: 0px !important;
						
					}
				  
			</style>
			<script>
				function AddAccessoryToCart(productid) {
					addToCart('accessory',productid,1);
					return false;
				}
			</script>		
			<cfset local.productGuid = application.model.phone.getDeviceGuidByProductID(request.p.filter.phoneid) />
			<cfset qry_getAccessories = application.model.catalog.getFeaturedDeviceAccessories(DeviceGuid = local.productGuid) />
			
			<cfif qry_getAccessories.recordcount GT 0>		
				<cfoutput>
					
				<h1 class="product-list">Featured Accessories</h1>
	
				<ul class="prodList">
					<cfloop query="qry_getAccessories">
						<cfset local.stcPrimaryImages = application.model.imageManager.getPrimaryImagesForProducts(valueList(qry_getAccessories.accessoryGuid)) />
						<li class="prodItemFeatured">
							<a href="/index.cfm/go/shop/do/accessoryDetails/product_id/#productid#">
							<img src="#application.view.imageManager.displayImage(imageGuid = local.stcPrimaryImages[qry_getAccessories.accessoryGuid], height = 230, width = 230)#" width="230"  border="0" /></a>
							
							<div class="bottomContainer">
								<div class="accessorySummary">
									<a href="/index.cfm/go/shop/do/accessoryDetails/product_id/#productid#">#summarytitle#</a>
								</div>
								<div class="accessoryPriceContainer">
									<span class="accessoryPriceTitle">Price</span> <span class="accessoryPrice">#dollarformat(price_retail)#</span>
								</div>
							</div>
			
							
							<div class="bottomContainerOverlay">
								<div class="blockCTA">
					            	<div class="ctaButton">
					                	<a class="ActionButtonFeaturedNotPrimary" href="/index.cfm/go/shop/do/accessoryDetails/product_id/#productid#"><span class="buttonText">Details</span></a>                	
					                </div>
					                <div class="ctaButton">
					                	<a class="ActionButtonFeatured" href="##" onclick="return AddAccessoryToCart(#productid#);"><span class="buttonText">Add</span></a>
					                </div>
					            </div>  
					        </div>
						</li>

					</cfloop>
				</ul>
				
				
				</cfoutput>
			</cfif>
			
			</cfsavecontent>
		</cfif>
		<cfreturn trim(local.featuredAccessoriesHTML) />
	</cffunction>


	<cffunction name="browseAccessories" access="public" returntype="string" output="false">
		<cfset var local = structNew() />

		<cfset request.p.sort = variables.accessoryFilter.getSort() />
		
		<cfsavecontent variable="local.accessoryHTML">
			<cfoutput>
				<script type="text/javascript" language="javascript" src="#getAssetPaths().common#scripts/filter.js?v=1.0.3"></script>
				<script type="text/javascript" language="javascript" src="#getAssetPaths().common#scripts/compare.js"></script>
				<script type="text/javascript" language="javascript" src="#getAssetPaths().common#scripts/tooltip.js"></script>

				<script type="text/javascript" language="javascript">
					function itemsLoaded()	{
						InitCompareCheckbox();
						InitTooltips();
						EnableFilters();
						updateHiddenFilterOptions(); //Needed for sorting
					}
					
					function SortProductList()
					{
						UpdateFilter( jQuery('##SortBy').val(), this);
						try	{ _gaq.push(['_trackEvent', 'Sort', 'Accessories Sort Click', jQuery('##SortBy option:selected').text()]); }
						catch (e) { }
					}
				</script>

				<div class="main left accessories">
					<h1 class="product-list">Select an Accessory</h1>
					<div class="sortBar">
						<div class="sortPriceOption">
							<span>Sort By</span/>
							
							<!--- Updates session sort filter --->
							<cfajaxproxy bind="url:/shop/changeSort.cfm?productClass=accessory&sort={SortBy.value}" />
	
							<select id="SortBy" name="SortBy" class="dropdownbox" onchange="SortProductList()">
								<option value="Popular" <cfif request.p.Sort eq 'Popular'>selected="selected"</cfif>>Popular</option>
								<option value="PriceAsc" <cfif request.p.Sort eq 'PriceAsc'>selected="selected"</cfif>>Price: Low to High</option>
								<option value="PriceDesc" <cfif request.p.Sort eq 'PriceDesc'>selected="selected"</cfif>>Price: High to Low</option>
								<option value="NameAsc" <cfif request.p.Sort eq 'NameAsc'>selected="selected"</cfif>>Name: A-Z</option>
								<option value="NameDesc" <cfif request.p.Sort eq 'NameDesc'>selected="selected"</cfif>>Name: Z-A</option>
								<option value="Category" <cfif request.p.Sort eq 'Category'>selected="selected"</cfif>>Category</option>
							</select>
						</div>
						<div style="clear:both;"></div>	
					</div>
					
					<cfif IsDefined('request.p.filter.phoneId')>
						<cfdiv id="resultsDiv" bind="url:/index.cfm/go/shop/do/browseAccessoriesResults/deviceIdFilter/#request.p.filter.phoneId#/?#cgi.query_string#" />
					<cfelse>
						<cfdiv id="resultsDiv" bind="url:/index.cfm/go/shop/do/browseAccessoriesResults?#cgi.query_string#" />
					</cfif>
					
				</div>
			</cfoutput>
		</cfsavecontent>

		<cfreturn trim(local.accessoryHTML) />
	</cffunction>

	<cffunction name="browseAccessoriesResults" access="public" returntype="string" output="false">
		<cfargument name="accessoryData" type="query" required="true" />
		<cfargument name="bindAjaxOnLoad" type="boolean" default="true" />
		<cfargument name="DisplayNoInventoryItems" type="boolean" default="application.wirebox.getInstance('ChannelConfig').getDisplayNoInventoryItems()" required="false" />

		<cfset var local = {} />
		<cfset local.stcPrimaryImages = application.model.imageManager.getPrimaryImagesForProducts(valueList(arguments.accessoryData.accessoryGuid)) />

		<cfsavecontent variable="local.accessoryHTML">
			<cfoutput>
				<cfif arguments.bindAjaxOnLoad>
					<cfset AjaxOnLoad('itemsLoaded') />
				</cfif>

				<script language="javascript">
					validateCompareSelected = function()	{
						var anythingSelected = false;

						f = $$('.compareCheck');

						for(var i = 0; i < f.length; i++)	{
							if(f[i].checked)	{
								anythingSelected = true;

								break;
							}
						}

						return anythingSelected;
					}
				</script>

				<ul id="prodList" class="prodList #session.phonefilterSelections.planType# accessory">
			</cfoutput>
			<cfoutput query="arguments.accessoryData">
				<cfif (val(arguments.accessoryData.qtyOnHand[arguments.accessoryData.currentRow]) gt 0 || DisplayNoInventoryItems) && isNumeric(arguments.accessoryData.price) && arguments.accessoryData.price gt 0>
					<li class="prodItem">
						<div class="prodImg">
							<cfif structKeyExists(local.stcPrimaryImages, arguments.accessoryData.accessoryGuid[arguments.accessoryData.currentRow])>
								<a href="/index.cfm/go/shop/do/accessoryDetails/product_id/#arguments.accessoryData.product_id[arguments.accessoryData.currentRow]#"><img src="#application.view.imageManager.displayImage(imageGuid = local.stcPrimaryImages[arguments.accessoryData.accessoryGuid[arguments.accessoryData.currentRow]], height = 100, width = 0)#" height="100" alt="#htmlEditFormat(arguments.accessoryData.summaryTitle[arguments.accessoryData.currentRow])#" border="0" /></a>
							<cfelse>
								<a href="/index.cfm/go/shop/do/accessoryDetails/product_id/#arguments.accessoryData.product_id[arguments.accessoryData.currentRow]#"><img src="#getAssetPaths().common#images/Catalog/NoImage.jpg" height="100" alt="#htmlEditFormat(arguments.accessoryData.summaryTitle[arguments.accessoryData.currentRow])#" border="0" /></a>
							</cfif>
							<div class="toolbar">
								<input class="compareCheck" type="checkbox" name="compareIDs" id="compareCheckbox#arguments.accessoryData.productId[arguments.accessoryData.currentRow]#" value="#arguments.accessoryData.product_id[arguments.accessoryData.currentRow]#"<cfif listFind(variables.accessoryFilter.getUserSelectedFilterValuesByFieldName('compareIDs'), arguments.accessoryData.product_id[arguments.accessoryData.currentRow])> checked="checked"</cfif> />
								<label for="compareCheckbox#arguments.accessoryData.product_id[arguments.accessoryData.currentRow]#">Compare</label>
								<a href="##" onClick="if(validateCompareSelected()){document.compareForm.submit()}else{alert('Please select an item or two to compare.')};return false;">compare now</a>
								<cfajaxproxy bind="url:/shop/changeCompareIds.cfm?productClass=accessory&compareId={compareCheckbox#arguments.accessoryData.productId[arguments.accessoryData.currentRow]#@none}&compareChecked={compareCheckbox#arguments.accessoryData.productId[arguments.accessoryData.currentRow]#.checked}" />
							</div>
						</div>
						<div class="prodDetail">
							<cfif request.config.debugInventoryData>
								<div id="inventoryDebugIcon_#arguments.accessoryData.productId[arguments.accessoryData.currentRow]#" class="inventoryDebugIcon" onmouseover="revealInventoryDebugInfo(#arguments.accessoryData.productId[arguments.accessoryData.currentRow]#,this);document.body.style.cursor='pointer';"></div>
								<div id="inventoryDebugInfo_#arguments.accessoryData.productId[arguments.accessoryData.currentRow]#" class="inventoryDebugInfo" onmouseout="hideInventoryDebugInfo(this);document.body.style.cursor='';">
									<div style="float:left;">GERS SKU:</div><div style="float:right;">#arguments.accessoryData.GersSku[arguments.accessoryData.currentRow]#</div><br/>
									<div style="float:left;">Qty On-Hand:</div><div style="float:right;">#arguments.accessoryData.QtyOnHand[arguments.accessoryData.currentRow]#</div><br/>
									<div style="float:left;">UPC Code:</div><div style="float:right;">#arguments.accessoryData.UPC[arguments.accessoryData.currentRow]#</div><br/>
								</div>
							</cfif>
							<h2><a href="/index.cfm/go/shop/do/accessoryDetails/product_id/#arguments.accessoryData.product_id[arguments.accessoryData.currentRow]#">#trim(arguments.accessoryData.summaryTitle[arguments.accessoryData.currentRow])#</a></h2>
							<div class="prodDesc">#trim(arguments.accessoryData.summaryDescription[arguments.accessoryData.currentRow])#</div>
						</div>
						<div class="prodPrice">
							<div class="priceblock-container">
								<div class="summary-container">
									<table class="price-table">
										<tr>
											<td>Price</td>
											<td class="price-col">
												<div class="final-price-container">#DollarFormat(arguments.accessoryData.price[arguments.accessoryData.currentRow])#</div>
											</td>
										</tr>
									</table>								
								</div>
								<cfif arguments.accessoryData.qtyOnHand[arguments.accessoryData.currentRow]>
									<div class="quantity-container">
										<label for="txtQuantity">QUANTITY</label>												
										<select id="qty_#arguments.accessoryData.productID#" name="qty_#arguments.accessoryData.productID#" class="dropdownbox">
											<cfloop from="1" to="#arguments.accessoryData.qtyOnHand[arguments.accessoryData.currentRow]#" index="i">
												<option value="#i#">#i# </option>
											</cfloop>
										</select>
									</div>
								</cfif>
								<div class="button-container">
									#Trim( renderAddToCartButton(arguments.accessoryData.productId[arguments.accessoryData.currentRow], arguments.accessoryData.qtyOnHand[arguments.accessoryData.currentRow]) )#
								</div>
							</div>
						</div>
					</li>
				</cfif>
			</cfoutput>
		
			<cfif arguments.accessoryData.RecordCount eq 0>
				<li class="prodItem">
					There are no accessories matching your current filter criteria.
					<br>
					Please modify your filters and try again.		
				</li>
			</cfif>	
			</ul>

		</cfsavecontent>

		<cfreturn trim(local.accessoryHTML) />
	</cffunction>

	<cffunction name="browseSearchResults" access="public" output="false" returntype="string">
		<cfargument name="data" type="query" required="true">
		<cfargument name="bindAjaxOnLoad" type="boolean" default="true">
		<cfset var local = {}>
		<cfset local.c = "">
		<cfsavecontent variable="local.c">
			<cfoutput>#this.browseAccessoriesResults(accessoryData=arguments.data,bindAjaxOnLoad=arguments.bindAjaxOnLoad, DisplayNoInventoryItems = application.wirebox.getInstance("ChannelConfig").getDisplayNoInventoryItems())#</cfoutput>
		</cfsavecontent>
		
		<cfreturn local.c />
	</cffunction>

	<cffunction name="accessoryDetails" access="public" returntype="string" output="false">
		<cfargument name="accessoryData" type="query" required="true" />
		<cfargument name="activeTab" type="string" required="false" default="relatedAccessories" />
		<cfargument name="multimedia" type="query" required="false" default="#queryNew('undefined')#" />

		<cfset var local = structNew() />

		<cfset local.bIsBundled = application.model.accessory.isBundledAccessory(accessoryData.productId) />
		
		<cfsavecontent variable="local.popupWindow">
			<cfoutput>
			<link rel="stylesheet" href="#getAssetPaths().common#scripts/fancybox/source/jquery.fancybox.css?v=2.0.6" type="text/css" media="screen" />
			<script type="text/javascript" src="#getAssetPaths().common#scripts/fancybox/source/noconflict-jquery.fancybox.js?v=2.0.6"></script>
			<script language="javascript" type="text/javascript">
				zoomImage = function (imageGuid, alt, targetImageId, targetImageHref)
				{
					var targetImg = $(targetImageId);
					var targetHref = $(targetImageHref);
					var imageSrc = '#trim(request.config.imageCachePath)#' + imageGuid + '_600_0.jpg';
					var imageHref = '#trim(request.config.imageCachePath)#' + imageGuid + '_600_0.jpg';

					targetImg.src = imageSrc;
					targetHref.writeAttribute('href', imageHref);
					targetHref.writeAttribute('title', alt);
				}
			</script>
			</cfoutput>
		</cfsavecontent>
		<cfhtmlhead text="#trim(local.popupWindow)#" />		
		<cfsavecontent variable="local.accessoryHTML">
			<script type="text/javascript" language="javascript" src="<cfoutput>#getAssetPaths().common#</cfoutput>scripts/details.js"></script>
			<script>
				jQuery(document).ready(function() {
					jQuery('#device-container').load('/catalog/deviceForAccessoryList/pid/<cfoutput>#arguments.accessoryData.ProductId#</cfoutput>/', function(){
						jQuery('#device-loader').hide();
					});
				});
			</script>



			<cfoutput query="arguments.accessoryData">
				

				<div class="details-sidebar">
					<cfset local.imagesHTML = application.view.product.displayImages(arguments.accessoryData.accessoryGuid, arguments.accessoryData.summaryTitle) />
					#trim(local.imagesHTML)#
				</div>

				<div class="main" id="prodList">
					<div class="prodDetail accessory-prodDetail">
						<cfif request.config.debugInventoryData>
							<div id="inventoryDebugIcon_#arguments.accessoryData.productId[arguments.accessoryData.currentRow]#" class="inventoryDebugIcon" onmouseover="revealInventoryDebugInfo(#arguments.accessoryData.productId[arguments.accessoryData.currentRow]#,this);document.body.style.cursor='pointer';"></div>
							<div id="inventoryDebugInfo_#arguments.accessoryData.productId[arguments.accessoryData.currentRow]#" class="inventoryDebugInfo" onmouseout="hideInventoryDebugInfo(this);document.body.style.cursor='';">
								<div style="float:left;">GERS SKU:</div><div style="float:right;">#arguments.accessoryData.GersSku[arguments.accessoryData.currentRow]#</div><br/>
								<div style="float:left;">Qty On-Hand:</div><div style="float:right;">#arguments.accessoryData.QtyOnHand[arguments.accessoryData.currentRow]#</div><br/>
								<div style="float:left;">UPC Code:</div><div style="float:right;">#arguments.accessoryData.UPC[arguments.accessoryData.currentRow]#</div><br/>
							</div>
						</cfif>						
						<h1>
							<cfif structKeyExists(url, 'pId') and isNumeric(url.pId)>
								<cfset productData = application.model.phone.getByFilter(idList = url.pId, allowHidden = true) />
								<cfset sesTitle =  application.wirebox.getInstance("StringUtil").friendlyURL( productData.detailTitle ) />
								<div align="right" style="width: 540px; text-align: right; font-size: 8pt; font-weight: bold"><a href="/#url.pId#/#sesTitle#" style="text-decoration: underline">Return to Device Details</a></div>
								<br />
							</cfif>
							#trim(arguments.accessoryData.summaryTitle[arguments.accessoryData.currentRow])#
						</h1>

						<cfif application.model.company.hasLogo(arguments.accessoryData.companyGuid)>
							<p><img src="#application.view.imageManager.displayCompanyLogo(arguments.accessoryData.companyGuid, 0, 0)#"></p>
						</cfif>

						<div class="prodDesc">
							<cfif not local.bIsBundled>
								<div class="details-price-container">
									<div class="priceblock-container">
										<div class="summary-container">
											<table class="price-table">
												<tr>
													<td>Price</td>
													<td class="price-col">
														<div class="final-price-container">#DollarFormat(arguments.accessoryData.price[arguments.accessoryData.currentRow])#</div>
													</td>
												</tr>
											</table>
										</div>
										<cfif arguments.accessoryData.qtyOnHand[arguments.accessoryData.currentRow]>
											<div class="quantity-container">
												<label for="txtQuantity">QUANTITY</label>												
												<select id="qty_#arguments.accessoryData.productID#" name="qty_#arguments.accessoryData.productID#" class="dropdownbox">
													<cfloop from="1" to="#arguments.accessoryData.qtyOnHand[arguments.accessoryData.currentRow]#" index="i">
														<option value="#i#">#i# </option>
													</cfloop>
												</select>
											</div>
										</cfif>
										<div class="button-container">
											#Trim( renderAddToCartButton(arguments.accessoryData.productId[arguments.accessoryData.currentRow], arguments.accessoryData.qtyOnHand[arguments.accessoryData.currentRow]) )#
										</div>
									</div>
								</div>
							</cfif>

							#trim(arguments.accessoryData.detailDescription[arguments.accessoryData.currentRow])#						
						</div>
					</div>

					<div id="prodSpecs" class="prodSpecs" style="width: 540px">
						<ul class="tabs">
							<li class="active">
								<a href="##" onclick="return false;" class="tab" name="relatedAccessories"><span>Related Devices</span></a>
								<div class="tabContent" style="overflow-x: hidden; overflow-y: auto; width: 540px">
									<div id="device-loader"><img src="/assets/common/images/upgradechecker/ajax-loader.gif" /></div>
									<div id="device-container"></div>
								</div>
							</li>
						</ul>
					</div>
					<p align="right" style="text-align: right"><a href="##top">Return to Top</a></p>
				</div>
			</cfoutput>
		</cfsavecontent>

		<cfsavecontent variable="local.productMetaData">
			<cfoutput><title>#reReplaceNoCase(trim(arguments.accessoryData.summaryTitle[arguments.accessoryData.currentRow]), '<[^>]*>', '', 'ALL')# - Mobile phone cellphone wireless phones</title></cfoutput>
		</cfsavecontent>
		<cfhtmlhead text="#trim(local.productMetaData)#" />

		<cfreturn trim(local.accessoryHTML) />
	</cffunction>


	<cffunction name="getCarrierName" access="public" returntype="string" output="false">
		<cfargument name="carrierId" required="true" type="numeric" />

		<cfset var getCarrierNameReturn = '' />
		<cfset var qry_getCarrier = '' />

		<cfquery name="qry_getCarrier" datasource="#application.dsn.wirelessAdvocates#">
			SELECT	c.companyName
			FROM	catalog.company AS c WITH (NOLOCK)
			WHERE	c.carrierId = <cfqueryparam value="#arguments.carrierId#" cfsqltype="cf_sql_integer" />
		</cfquery>

		<cfif qry_getCarrier.recordCount>
			<cfset getCarrierNameReturn = trim(qry_getCarrier.companyName) />
		</cfif>

		<cfreturn getCarrierNameReturn />
	</cffunction>


	<cffunction name="compareAccessories" access="public" returntype="string" output="false">
		<cfargument name="accessoryData" required="true" type="query" />
		<cfargument name="accessoryCompareData" required="true" type="query" />

		<cfset var local = structNew() />

		<cfparam name="request.p.printFormat" type="boolean" default="false" />

		<cfset local.stcPrimaryImages = application.model.imageManager.getPrimaryImagesForProducts(valueList(arguments.accessoryData.accessoryGuid)) />

		<cfsavecontent variable="local.accessoryHTML">
			<h1>Compare Accessories</h1>

			<cfif structKeyExists(session, 'accessoryFilterSelections') and structKeyExists(session.accessoryFilterSelections, 'compareIds')>
				<table cellpadding="0" cellspacing="0" class="compare">
					<cfoutput>
						<thead>
							<cfif not request.p.printFormat>
								<tr>
									<td colspan="#(arguments.accessoryData.recordCount + 1)#" align="right" style="border: 0px">
										<div align="right" class="noPrint">
											<img src="#getAssetPaths().common#images/ui/1295276066_print.png" align="texttop" />
											<a href="#cgi.script_name&cgi.path_info#/printFormat/true" target="_blank">Print this Page</a>
											<br /><br />
										</div>
									</td>
								</tr>
							</cfif>
							<tr>
								<th class="emptyCell" style="border-bottom: 0px">&nbsp;</th>
								<cfloop query="arguments.accessoryData">
									<th style="color: ##000000; font-size: 8pt" width="220" valign="top">
										<div style="height:150px;">
											<cfif structKeyExists(local.stcPrimaryImages, arguments.accessoryData.accessoryGuid[arguments.accessoryData.currentRow])>
												<img src="#application.view.imageManager.displayImage(imageGuid = local.stcPrimaryImages[arguments.accessoryData.accessoryGuid[arguments.accessoryData.currentRow]], height = 150, width = 0)#" height="150" alt="#htmlEditFormat(trim(arguments.accessoryData.summaryTitle[arguments.accessoryData.currentRow]))#" />
											<cfelse>
												<img src="#getAssetPaths().common#images/catalog/noimage.jpg" height="150" alt="#htmlEditFormat(trim(arguments.accessoryData.summaryTitle[arguments.accessoryData.currentRow]))#" />
											</cfif>
										</div>

										<div style="height:50px;">
											<h4><a href="/index.cfm/go/shop/do/accessoryDetails/product_id/#arguments.accessoryData.product_id[arguments.accessoryData.currentRow]#" style="font-size: 8pt">#trim(arguments.accessoryData.summaryTitle[arguments.accessoryData.currentRow])#</a></h4>
										</div>

										<div style="height:50px;">
											<cfif not request.p.printFormat>
												<cfset local.thisAddToCartButton = renderAddToCartButton(arguments.accessoryData.productId[arguments.accessoryData.currentRow], arguments.accessoryData.qtyOnHand[arguments.accessoryData.currentRow], true) />
												#trim(local.thisAddToCartButton)#
											</cfif>
										</div>
									</th>
								</cfloop>
							</tr>
						</thead>
					</cfoutput>
					<tbody>
						<cfoutput>
							<tr class="spacer">
								<td class="emptyCell">&nbsp;</td>
								<cfloop query="arguments.accessoryData">
									<td>&nbsp;</td>
								</cfloop>
							</tr>
							<tr class="control">
								<td class="dataPoint" style="color: ##000000; font-weight: bold; text-align: left; font-size: 8pt; background-color: ##8fafc6"><span style="white-space: nowrap">Purchase Info</span></td>
								<cfloop query="arguments.accessoryData">
									<cfif not request.p.printFormat and structKeyExists(session, 'accessoryFilterSelections') and structKeyExists(session.accessoryFilterSelections, 'compareIds')>
										<td style="background-color: ##8fafc6">
											<img src="#getAssetPaths().common#images/ui/1295275580_delete.png" align="texttop" />&nbsp;<a href="/index.cfm/go/#request.p.go#/do/#request.p.do#/accessoryFilter.submit/1/filter.compareIDs/#session.accessoryFilterSelections.compareIDs#/removeID/#arguments.accessoryData.product_id[arguments.accessoryData.currentRow]#" style="color: ##000000; font-size: 8pt; font-weight: bold">Remove</a>
										</td>
									<cfelse>
										<td>&nbsp;</td>
									</cfif>
								</cfloop>
							</tr>
							<tr>
								<td class="dataPoint" style="color: ##000000; font-size: 8pt; font-weight: bold">Price</td>
								<cfloop query="arguments.accessoryData">
									<td style="color: ##000000; font-size: 8pt">#dollarFormat(arguments.accessoryData.price[arguments.accessoryData.currentRow])#</td>
								</cfloop>
							</tr>
						</cfoutput>
						<cfoutput query="arguments.accessoryCompareData" group="PropertyType">
							<tr>
								<td colspan="#(arguments.accessoryData.recordCount + 1)#">&nbsp;</td>
							</tr>
							<tr class="control">
								<td class="dataPoint" style="color: ##ffffff; font-weight: bold; text-align: left">#trim(propertyType)#</td>
								<cfloop query="arguments.accessoryData">
									<td>&nbsp;</td>
								</cfloop>
							</tr>
							<cfoutput group="GroupLabel">
								<cfoutput>
									<tr>
										<td class="dataPoint">#trim(propertyLabel)#</td>
										<cfloop query="arguments.accessoryData">
											<cfset local.thisValue = evaluate('arguments.accessoryCompareData.value_#arguments.accessoryData.productId[arguments.accessoryData.currentRow]#[arguments.accessoryCompareData.currentRow]') />

											<cfset local.thisValue = trim(local.thisValue) />

											<cfif local.thisValue is 'True' or local.thisValue is 'False'>
												<cfset local.thisValue = yesNoFormat(local.thisValue) />
											<cfelseif not len(trim(local.thisValue))>
												<cfset local.thisValue = 'Not Available' />
											</cfif>

											<td>#local.thisValue#</td>
										</cfloop>
									</tr>
								</cfoutput>
								<tr class="spacer">
									<td class="emptyCell">&nbsp;</td>
									<cfloop query="arguments.accessoryData">
										<td>&nbsp;</td>
									</cfloop>
								</tr>
							</cfoutput>
						</cfoutput>
					</tbody>
				</table>

				<cftry>
					<cfset structDelete(session.accessoryFilterSelections, 'compareIds') />
					<cfset structDelete(session.dataCardAndNetbookFilterSelections, 'compareIds') />
					<cfset structDelete(session.phoneFilterSelections, 'compareIds') />
					<cfset structDelete(session.planFilterSelections, 'compareIds') />
					<cfset structDelete(session.prepaidFilterSelections, 'compareIds') />

					<cfcatch type="any">
						<!--- Do Nothing --->
					</cfcatch>
				</cftry>
			<cfelse>
				<cfoutput>
					<div align="center" style="text-align: center">
						<div style="width:500px; margin-top: 25px; margin-right: 20px; border: 1px solid ##6B6B6B; background-color: ##fff799; padding: 10px; -moz-border-radius: 10px; -webkit-border-radius: 10px; -khtml-border-radius: 10px; font-size: 10pt;">
							<img src="#getAssetPaths().common#images/ui/info-icon.png" style="float:left; position:relative; margin-top:5px; margin-left:5px; margin-right:10px; margin-bottom:5px;"/>
							<p style="line-height:1.2em; font-size: 10pt; text-align: left">Please select at least 2 and up to 5 accessories to compare.</p>
							<div style="clear:both;"></div>
						</div>
					</div>
				</cfoutput>
			</cfif>
		</cfsavecontent>

		<cfreturn trim(local.accessoryHTML) />
	</cffunction>


	<cffunction name="renderAddToCartButton" access="public" output="false" returntype="string">
		<cfargument name="productId" type="numeric" required="true">
		<cfargument name="availableQty" type="numeric" required="true">
		<cfargument name="fixedQty" type="boolean" required="false" default="false">
		
		<cfset var local = {}>
		<cfparam name="request.lstAvailableProductIds" type="string" default="">
		<cfset local.html = "">
		<cfsavecontent variable="local.html">
			<cfoutput>
				<cfif arguments.availableQty lte 0>
					<a class="DisabledButton" href="##" onclick="alert('#application.wirebox.getInstance("TextDisplayRenderer").getOutOfStockAlertText()#');return false;"><span>#application.wirebox.getInstance("TextDisplayRenderer").getOutOfStockButtonText()#</span></a>
				<cfelse>
					<a class="ActionButton" href="##" onclick="addToCart('accessory','#arguments.productId#',<cfif not arguments.fixedQty>document.getElementById('qty_#arguments.productID#').value<cfelse>1</cfif><cfif request.config.enforceInventoryRestrictions>,#arguments.availableQty#</cfif>);return false;"><span>Add to Cart</span></a>
				</cfif>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn local.html>
	</cffunction>
	
	<cffunction name="getAssetPaths" access="private" output="false" returntype="struct">    
    	<cfreturn variables.instance.assetPaths />    
    </cffunction>    
    <cffunction name="setAssetPaths" access="private" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance.assetPaths = arguments.theVar />    
    </cffunction>
	
<!---	<cffunction name="getStringUtil" access="private" output="false" returntype="any">    
    	<cfreturn variables.instance.stringUtil />    
    </cffunction>    
    <cffunction name="setStringutil" access="private" output="false" returntype="void">    
    	<cfargument name="stringUtil" required="true" />    
    	<cfset variables.instance.stringutil = arguments.stringUtil />    
    </cffunction>
--->
</cfcomponent>