<cfparam name="request.p.activeTab" type="string" default="features" />

<!---<cfif not structKeyExists(request, 'p') or (structKeyExists(request, 'p') and not structKeyExists(request.p, 'productId'))>
			<cflocation url="/index.cfm" addtoken="false" />
		</cfif>
--->



		

		<!--- Loop through request.p.productId, it can be a list of numeric values. If there is a non-numeric value in this list, 
			redirect them to the home page. --->
	<!---	<cfloop from="1" to="#listLen(request.p.productId)#" index="idx">
			<cfif not isNumeric(listGetAt(request.p.productId, idx))>
				<cflocation url="/index.cfm" addtoken="false" />
				<cfbreak />
			</cfif>
		</cfloop>
--->
		<cfif not structKeyExists(request.p, 'name')>
			<cfset request.p.name = '' />
		</cfif>


		

		<cfif not prc.productData.recordCount>
			<cfset productData = application.model.tablet.getByFilter(idList = request.p.productId) />
			<cfif prc.productData.recordCount>
				<cfset request.p.do = 'tabletDetails' />
				<cfinclude template="index.cfm" />
				<cfexit method="exittemplate" />
			</cfif>
		</cfif>
		<cfif not prc.productData.recordCount>
			<cfset productData = application.model.dataCardAndNetbook.getByFilter(idList = request.p.productId) />

			<cfif prc.productData.recordCount>
				<cfset request.p.do = 'dataCardAndNetbookDetails' />
				<cfinclude template="index.cfm" />
				<cfexit method="exittemplate" />
			</cfif>
		</cfif>

		<cfif not prc.productData.recordCount>
			<cfset productData = application.model.prePaid.getByFilter(idList = request.p.productId) />

			<cfif prc.productData.recordCount>
				<cfset request.p.do = 'prepaidDetails' />
				<cfinclude template="index.cfm" />
				<cfexit method="exittemplate" />
			</cfif>
		</cfif>








<!--- contents of /views/shop/dsp_productDetails.cfm" --->

<!---<cfparam name="productHTML" type="string" default="" />

<cfoutput>
	#trim(prc.workflowHTML)#

	#trim(prc.productHTML)#
</cfoutput>--->

	<!---<cfargument name="productData" type="query" required="true" />
	<cfargument name="featuresData" type="query" required="true" />
	<cfargument name="freeAccessories" type="query" required="true" />
	<cfargument name="qVideos" type="query" required="true" />
	<cfargument name="activeTab" type="string" required="false" default="features" />--->
<cfparam name="prc.activeTab" default="features" />

	<!---<cfset variable.filterSelections = evaluate(variables.filterSelections) />
	--->
	<!---<cfset variable.productClass = variables.productClass />
	---><cfset variable.planType = 'new' />

	<cfif session.cart.hasCart() AND session.cart.getHasFamilyPlan()>
		<cfif ListFind( "42,109,299", session.cart.getCarrierId() )>
			<cfif session.cart.getCurrentLine() GTE 2>
				<cfset variable.planType = 'addaline' />
			</cfif>
		<cfelseif session.cart.getCarrierId() EQ 128>
			<cfif session.cart.getCurrentLine() GTE 3>
				<cfset variable.planType = 'addaline' />
			</cfif>
		</cfif>
	<cfelse>
		<cfif listFind(prc.productFilter.getUserSelectedFilterValuesByFieldName(fieldName = 'filterOptions'), '32')>
			<cfset variable.planType = 'new' />
		<cfelseif listFind(prc.productFilter.getUserSelectedFilterValuesByFieldName(fieldName = 'filterOptions'), '33')>
			<cfset variable.planType = 'upgrade' />
		<cfelseif listFind(prc.productFilter.getUserSelectedFilterValuesByFieldName(fieldName = 'filterOptions'), '34')>
			<cfset variable.planType = 'addaline' />
		<cfelseif StructKeyExists(request.p, 'activationtype')>
			<cfif request.p.activationtype eq 'new'>
				<cfset prc.productFilter.setActivationPrice( 'new' ) />
			<cfelseif request.p.activationtype eq 'upgrade'>
				<cfset prc.productFilter.setActivationPrice( 'upgrade' ) />
			</cfif>
		</cfif>
	</cfif>

	<cfset variable.typeLabel = prc.label />

	<cfif prc.freeAccessories.recordCount>
		<cfset variable.stcFeeAccessoryPrimaryImages = application.model.imageManager.getPrimaryImagesForProducts(valueList(prc.freeAccessories.productGuid)) />
	</cfif>

		<cfoutput>			
			<link rel="stylesheet" href="#assetPaths.common#scripts/bxslider/bx_styles/bx_styles.css" type="text/css" media="screen" />
			<script type="text/javascript" language="javascript" src="#assetPaths.common#scripts/details.js"></script>
			<script type="text/javascript" language="javascript" src="#assetPaths.common#scripts/libs/jquery.bxSlider.min.js"></script>
			<script type="text/javascript" language="javascript">
				var priceTabClass = '#trim(variable.planType)#';

				ToggleActivationPrice = function()
				{
					switch( jQuery('##ActionPriceOptions').val() )
					{
						case 'New':
							jQuery('##new-activation-container').show();
							jQuery('##upgrade-activation-container').hide();
							jQuery('##addaline-activation-container').hide();
							jQuery('##nocontract-activation-container').hide();
							jQuery('##upgrade-checker-container').hide();
							break;
						case 'Upgrade':
							jQuery('##new-activation-container').hide();
							jQuery('##upgrade-activation-container').show();
							jQuery('##addaline-activation-container').hide();
							jQuery('##nocontract-activation-container').hide();
							jQuery('##upgrade-checker-container').show();
							break;
						case 'Addaline':
							jQuery('##new-activation-container').hide();
							jQuery('##upgrade-activation-container').hide();
							jQuery('##addaline-activation-container').show();
							jQuery('##nocontract-activation-container').hide();
							jQuery('##upgrade-checker-container').hide();
							break;
						case 'NoContract':
							jQuery('##new-activation-container').hide();
							jQuery('##upgrade-activation-container').hide();
							jQuery('##addaline-activation-container').hide();
							jQuery('##nocontract-activation-container').show();
							jQuery('##upgrade-checker-container').hide();
							break;
					}
				}

				jQuery(document).ready(function() {

					//Account for page refresh
					ToggleActivationPrice();

					jQuery(".fancy-box").fancybox({
						maxWidth	: 650,
						maxHeight	: 500,
						minWidth	: 650,
						minHeight	: 500,
						padding		: 0,
						margin		: 0,
						fitToView	: false,
						autoSize	: false,
						closeClick	: false,
						closeEffect	: 'none',
						hideOnOverlayClick : false
					});

					jQuery(".fancy-box-video").fancybox({
						maxWidth	: 700,
						maxHeight	: 400,
						minWidth	: 700,
						minHeight	: 400,
						padding		: 10,
						margin		: 0,
						fitToView	: false,
						autoSize	: false,
						closeClick	: false,
						closeEffect	: 'none',
						hideOnOverlayClick : false
					});

					jQuery('##spec-tab').click(function(){
						var productId = jQuery(this).attr('data-productId');
						jQuery('##spec-loader').show();
						jQuery('##spec-container').load('/catalog/deviceSpecification/pid/' + productId + '/', function(){
							jQuery('##spec-loader').hide();
						});
						jQuery(this).off('click'); //prevent double loading
					});
					
					jQuery('##accessory-tab').click(function(){
						var productId = jQuery(this).attr('data-productId');
						jQuery('##accessory-loader').show();
						jQuery('##accessory-container').load('/catalog/accessoryForDeviceList/pid/' + productId + '/', function(){
							jQuery('##accessory-loader').hide();
						});
						jQuery(this).off('click'); //prevent double loading
					});

				    var videoSlider = jQuery('##VideoSlider').bxSlider({
						infiniteLoop: false,
						hideControlOnEnd: true,
						pager: false,
						startingSlide: 0
				    });

					//IE8 not starting at position 0
					videoSlider.goToSlide(0);
				});
			</script>

			<!--- Overwriting layout for specs --->
			<style type="text/css">
				.prodSpecs table
				{
					width: 520px;
				}
			</style>
		</cfoutput>

		<cfset request.lstAvailableProductIds = valueList(prc.productData.productId) />

		<cfif session.cart.hasCart() and application.model.cartHelper.getLineRateplanProductId(line = session.cart.getCurrentLine())>
			<cfset request.lstAvailableProductIds = application.model[variables.productClass].getProductIdsByPlanId(planId = application.model.cartHelper.getLineRateplanProductId(line = session.cart.getCurrentLine())) />
		</cfif>

		<cfset variable.bProductCompatible = false />

		<cfif listFindNoCase(request.lstAvailableProductIds, prc.productData.productId[prc.productData.currentRow])>
			<cfset variable.bProductCompatible = true />
		</cfif>

		<cfscript>
			priceBlock = CreateObject( 'component', 'cfc.model.catalog.PriceBlock' ).init();
			priceBlock.setRetailPrice( prc.productData.price_retail[prc.productData.currentRow] );
        	priceBlock.setNewPrice( prc.productData.price_new[prc.productData.currentRow] );
        	priceBlock.setUpgradePrice( prc.productData.price_upgrade[prc.productData.currentRow] );
        	priceBlock.setAddALinePrice( prc.productData.price_addaline[prc.productData.currentRow] );
			priceBlock.setNewPriceAfterRebate( prc.productData.NewPriceAfterRebate[prc.productData.currentRow] );
			priceBlock.setUpgradePriceAfterRebate( prc.productData.UpgradePriceAfterRebate[prc.productData.currentRow] );
			priceBlock.setAddALinePriceAfterRebate( prc.productData.AddALinePriceAfterRebate[prc.productData.currentRow] );
			
			variable.priceArgs = {};
			variable.priceArgs.productID = prc.productData.productID[prc.productData.currentRow];
			variable.priceArgs.carrierID = prc.productData.carrierID[prc.productData.currentRow];
			variable.priceArgs.PriceBlock = priceBlock;
			variable.priceArgs.bProductCompatible = variable.bProductCompatible;
			variable.priceArgs.bPrePaid = prc.productData.prepaid[prc.productData.currentRow];
			variable.priceArgs.AvailableQty = prc.productData.qtyOnHand[prc.productData.currentRow];
			variable.priceArgs.IsNoContractRestricted = prc.productData.IsNoContractRestricted[prc.productData.currentRow];
			variable.priceArgs.IsNewActivationRestricted = prc.productData.IsNewActivationRestricted[prc.productData.currentRow];
			variable.priceArgs.IsUpgradeActivationRestricted = prc.productData.IsUpgradeActivationRestricted[prc.productData.currentRow];
			variable.priceArgs.IsAddALineActivationRestricted = prc.productData.IsAddALineActivationRestricted[prc.productData.currentRow];
			variable.priceArgs.IsDetailsPageView = true;
			variable.priceArgs.HasFreeKitBundle = prc.productData.bFreeAccessory[prc.productData.currentRow];
			variable.priceArgs.IsAvailableInWarehouse = prc.productData.IsAvailableInWarehouse[prc.productData.currentRow];
			
			variable.pricingHTML = application.view.phone.renderProductPrices( argumentCollection = variable.priceArgs );
		</cfscript>

		<cfoutput query="prc.productData">
			<cfsavecontent variable="variable.popupWindow">
				<link rel="stylesheet" href="#assetPaths.common#scripts/fancybox/source/jquery.fancybox.css?v=2.0.6" type="text/css" media="screen" />
				<script type="text/javascript" src="#assetPaths.common#scripts/fancybox/source/noconflict-jquery.fancybox.js?v=2.0.6"></script>
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
			</cfsavecontent>
			<cfhtmlhead text="#trim(variable.popupWindow)#" />

			<div class="details-sidebar">
				<cfset variable.imagesHTML = application.view.product.displayImages(prc.productData.deviceGuid, prc.productData.summaryTitle, prc.productData.BadgeType) />
				<div>#trim(variable.imagesHTML)#</div>
				<div style="clear:both;"></div>
				<!--- Commenting out until a decision is made on what to do long term with kit images
				<cfif channelConfig.getDisplayFreeKit() && arguments.productData.bFreeAccessory[arguments.productData.currentRow]>
					<div style="border-top: 1px dashed ##cfcfcf; margin-top: 20px; padding-top: 20px; text-align:center;">
						<a href="#assetPaths.common#images/onlinebenefit/costcoValue_version_4_1.jpg" rel="lightbox" title="#channelConfig.getDisplayName()# Online Value">
	         				<img src="#assetPaths.channel#images/memberValue.gif" border="0" alt="#prc.channelConfig.getDisplayName()# Online Value: Free Accessories, Shipping & Activation" title="#channelConfig.getDisplayName()# Online Value: Free Accessories, Shipping & Activation" />
						</a>
						<div style="font-size: 14px; margin-left: 35px; text-align:left;">
							<span style="color:red; font-weight:bold;">FREE</span> Shipping <br />
							<span style="color:red; font-weight:bold;">FREE</span> Accessory Bundle <br />
						</div>
					</div>
				</cfif>
				<div style="clear:both;"></div>
				<!--- Free Accessory Kit --->
				<cfif prc.channelConfig.getDisplayFreeKit() && prc.freeAccessories.recordCount>
					<div style="border-top: 0px dashed ##cfcfcf; margin-top: 10px; padding-top: 10px;">
						<cfset variable.stcFeeAccessoryPrimaryImages = application.model.imageManager.getPrimaryImagesForProducts(valueList(prc.freeAccessories.productGuid)) />
						<div class="prodDetail-banner-capsule" style="margin-left: auto; margin-right: auto; width:165px;">
							<span style="color:red; font-weight:bold;">FREE</span> Accessory Bundle <br />
						</div>
						<cfset imageThumbnailHTML = application.view.product.displayKitImages(valueList(prc.freeAccessories.productGuid), prc.freeAccessories.DetailTitle) />
						<div style="clear:both;"></div>
						<div>#trim(imageThumbnailHTML)#</div>
					</div>
				</cfif>
				--->
				<div style="clear:both;"></div>
				<!--- Videos--->
				<cfif prc.qVideos.RecordCount>
					<div style="border-top: 1px dashed ##cfcfcf; margin-top: 20px; padding-top: 20px; text-align:center; padding-left: 35px;">
						<ul id="VideoSlider">
							<cfloop query="prc.qVideos">
								<li>
									<div class="video-container">
										<a href="/index.cfm/go/content/do/displayvideo/videoId/#qVideos.VideoId#" title="#qVideos.Title#"  class="fancy-box-video" data-fancybox-type="iframe">
											<img src="/media/poster/#qVideos.ProductId#/thumb-#qVideos.PosterFileName#" width="190" alt="#qVideos.Title#" />
										</a>
										<a href="/index.cfm/go/content/do/displayvideo/videoId/#qVideos.VideoId#" title="#qVideos.Title#"  class="fancy-box-video video-title" data-fancybox-type="iframe">#qVideos.Title#</a>
									</div>
								</li>
							</cfloop>
						</li>
					</div>
				</cfif>

			</div><!--- End Left Side Bar--->
			<div class="main #trim(variable.planType)# phones" id="prodList">
				<div class="phones-prodDetail">
					<cfif request.config.debugInventoryData>
						<div id="inventoryDebugIcon_#prc.productData.productId[prc.productData.currentRow]#" class="inventoryDebugIcon" onmouseover="revealInventoryDebugInfo(#prc.productData.productId[prc.productData.currentRow]#,this);document.body.style.cursor='pointer';"></div>
						<div id="inventoryDebugInfo_#prc.productData.productId[prc.productData.currentRow]#" class="inventoryDebugInfo" onmouseout="hideInventoryDebugInfo(this);document.body.style.cursor='';">
							<div style="float:left;">GERS SKU:</div><div style="float:right;">#prc.productData.GersSku[prc.productData.currentRow]#</div><br/>
							<div style="float:left;">Qty On-Hand:</div><div style="float:right;">#prc.productData.QtyOnHand[prc.productData.currentRow]#</div><br/>
							<div style="float:left;">UPC Code:</div><div style="float:right;">#prc.productData.UPC[prc.productData.currentRow]#</div><br/>
							<div style="float:left;">Device Type:</div><div style="float:right;">#prc.productData.DeviceType[prc.productData.currentRow]#</div><br/>
						</div>
					</cfif>
					<h1>#trim(prc.productData.detailTitle[prc.productData.currentRow])#</h1>
					<cfif prc.allocation.loadBySku(#prc.productData.gersSku[prc.productData.currentRow]#)>
						<div class="allocationMsg">
							<cfswitch expression="#prc.allocation.getInventoryTypeDescription()#">
								<cfcase value="Pre-Sale">
									<!---Pre-Sale: expected release date #dateformat(allocation.getReleaseDate(),"mm/dd/yyyy")#--->
									#prc.allocation.getDetailMessage()#
								</cfcase>
								<cfcase value="Backorder">														
									#prc.allocation.getDetailMessage()#
								</cfcase>
							</cfswitch>
						</div>
					</cfif>

					<span style="font-size: 10pt; font-weight: bold; color: maroon">
						Available: 
						<cfif prc.productData.IsAvailableInWarehouse[prc.productData.currentRow] && prc.productData.IsAvailableOnline[prc.productData.currentRow]>
							Online + #textDisplayRenderer.getStoreAliasName()#
						<cfelseif prc.productData.IsAvailableOnline[prc.productData.currentRow]>
							Online Only
						<cfelseif prc.productData.IsAvailableInWarehouse[prc.productData.currentRow]>
							#textDisplayRenderer.getStoreAliasName()# Only
						</cfif>
					</span>
					<br /><br />

					<div class="prodDesc">
						<div class="details-price-container">
							#trim(variable.pricingHTML)#
						</div>

						<cfset variable.productsdetails = application.view.product.ReplaceRebate(#prc.productData.detailDescription[prc.productData.currentRow]#,prc.productData.carrierId[prc.productData.currentRow],prc.productData.gersSku[prc.productData.currentRow]) />
						#trim(variable.productsdetails)#

					</div>
				</div>
				<div id="prodSpecs" class="prodSpecs" style="width: 540px">
					<ul class="tabs">
						<li<cfif prc.activeTab is 'features'> class="active"</cfif>>
							<a href="##" onclick="return false;" class="tab" name="features"><span>Features</span></a>
							<div class="tabContent" style="overflow-x: hidden; overflow-y: auto; width: 560px;">
								<h2>Device features for the #trim(prc.productData.detailTitle[prc.productData.currentRow])#</h2>
								<cftry>
									<cfset variable.featurePropertiesDisplay = application.view.propertyManager.getPropertyTableTab(prc.featuresData) />
									#trim(variable.featurePropertiesDisplay)#
									<cfcatch type="any">

									</cfcatch>
								</cftry>
							</div>
						</li>
						<li<cfif prc.activeTab is 'specifications'> class="active"</cfif>>
							<a id="spec-tab" href="##" onclick="return false;" class="tab" data-productId="#prc.productData.productId#" name="specifications"><span>Specifications</span></a>
							<div class="tabContent" style="overflow-x: hidden; overflow-y: auto; width: 560px;">
								<h2>Product Specs for the #trim(prc.productData.detailTitle[prc.productData.currentRow])#</h2>
								<div id="spec-loader"><img src="/assets/common/images/upgradechecker/ajax-loader.gif" /></div>
								<div id="spec-container"></div>
							</div>
						</li>
						
						<li<cfif prc.activeTab is 'relatedAccessories'> class="active"</cfif>>
							<a id="accessory-tab" href="##" onclick="return false;" class="tab" data-productId="#prc.productData.productId#" name="relatedAccessories"><span>Related Accessories</span></a>
							<div class="tabContent" style="overflow-x: hidden; overflow-y: auto; width: 560px;">
								<h2>Compatible Accessories for the #trim(prc.productData.detailTitle[prc.productData.currentRow])#</h2>
								<div id="accessory-loader"><img src="/assets/common/images/upgradechecker/ajax-loader.gif" /></div>
								<div id="accessory-container"></div>
							</div>
						</li>
					</ul>
				</div>
			</cfoutput>
			<p align="right" style="text-align: right"><a href="#top">Return to Top</a></p>
		</div>


	<!--- Set up HTML Metadata --->
	<cfset request.title = HTMLEditFormat( reReplaceNoCase(trim(prc.productData.pageTitle[prc.productData.currentRow]), '<[^>]*>', '', 'ALL') ) & ' | ' & prc.channelConfig.getDisplayName() />
	<cfif Len(prc.productData.MetaDescription[prc.productData.currentRow])>
		<cfset request.MetaDescription = HTMLEditFormat( reReplaceNoCase(trim(prc.productData.MetaDescription[prc.productData.currentRow]), '<[^>]*>', '', 'ALL') ) />
	</cfif>
	<cfif Len(prc.productData.MetaKeywords[prc.productData.currentRow])>
		<cfset request.MetaKeywords = HTMLEditFormat( reReplaceNoCase(trim(prc.productData.MetaKeywords[prc.productData.currentRow]), '<[^>]*>', '', 'ALL') ) />
	</cfif>


