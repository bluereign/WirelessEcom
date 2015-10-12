<cfscript>
	assetPaths = application.wirebox.getInstance("AssetPaths");
	channelConfig = application.wirebox.getInstance("ChannelConfig");
	textDisplayRenderer = application.wirebox.getInstance("TextDisplayRenderer");
	allocation = createObject('component', 'cfc.model.Allocation').init();
	productFilter = application.wirebox.getInstance( variables.filterType );
	stringUtil = application.wirebox.getInstance( "StringUtil" );
	rebateSkus = "";
</cfscript>

<cffunction name="browseProducts" access="public" returntype="string" output="false">

	<cfset var local = {} />
	
	<!--- load into memory all currently active rebates. These are cached for performance reasons. --->
	<cfset rebateSkus = application.model.rebates.getActiveRebateSkus() />


	<!--- get the current sort order for later use --->
	<cfset request.p.sort = productFilter.getSort() />

	<cfscript>
		if (session.cart.getActivationType() eq '')
		{
			//Need to account for filters from Menu options
			if ( ListFind( productFilter.getUserSelectedFilterValuesByFieldName(fieldName = 'filterOptions'), '33') )
			{
				productFilter.setActivationPrice('upgrade');
				request.p.ActivationPrice = 'upgrade';
			}
			else if ( ListFind( productFilter.getUserSelectedFilterValuesByFieldName(fieldName = 'filterOptions'), '34') )
			{
				productFilter.setActivationPrice('addaline');
				request.p.ActivationPrice = 'addaline';
			}
			else if ( ListFind( productFilter.getUserSelectedFilterValuesByFieldName(fieldName = 'filterOptions'), '35') )
			{
				productFilter.setActivationPrice('nocontract');
				request.p.ActivationPrice = 'nocontract';
			}
			else
			{
				request.p.ActivationPrice = productFilter.getActivationPrice();
			}
		}
		else
		{
			request.p.ActivationPrice = session.cart.getActivationType();
		}
	</cfscript>


	<cfsavecontent variable="local.html">
		<cfoutput>
			<script type="text/javascript" language="javascript" src="#assetPaths.common#scripts/filter.js?v=1.0.2"></script>
			<script type="text/javascript" language="javascript" src="#assetPaths.common#scripts/compare.js"></script>
			<script type="text/javascript" language="javascript" src="#assetPaths.common#scripts/tooltip.js"></script>
			<script type="text/javascript" language="javascript" src="#assetPaths.common#scripts/listing.js"></script>
			<link rel="stylesheet" href="#assetPaths.common#scripts/fancybox/source/jquery.fancybox.css?v=2.0.6" type="text/css" media="screen" />
			<script type="text/javascript" src="#assetPaths.common#scripts/fancybox/source/noconflict-jquery.fancybox.js?v=2.0.6"></script>
			
			<script type="text/javascript" language="javascript">
				function itemsLoaded()
				{
					InitCompareCheckbox();
					InitTooltips();
					EnableFilters();
					updateHiddenFilterOptions(); //Needed for sorting
				}

				jQuery(document).ready(function() {
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
				});

				function trackLinkClick( ProductTitle )
				{
					try	{ _gaq.push(['_trackEvent', 'Product List', 'Product Details Click', ProductTitle]); }
					catch (e) { }

					try { ga('send', 'event', 'Product List', 'Product Details Click', ProductTitle); } 
					catch (e) {}

					return true;
				}

				function SortProductList()
				{
					UpdateFilter( jQuery('##SortBy').val(), this, jQuery('##PriceTypeBy').val() );
					
					try	{ _gaq.push(['_trackEvent', 'Sort', 'Phones Sort Click', jQuery('##SortBy option:selected').text()]); }
					catch (e) { }
					
					try { ga('send', 'event', 'Sort', 'Phones Sort Click', jQuery('##SortBy option:selected').text()); } 
					catch (e) { }
				}
				
				
					    
			</script>

			<div class="main left phones">
				<div id="banner-container" style="display:none;"></div>
				<div>
					<div class="left">
						<div>
							<div class="left">
								<h1 class="product-list">Select a #trim(variables.label)#</h1>
							</div>
							<cfif listContainsNoCase('Phone,Tablet', variables.productClass)>
								<div id="upgrade-eligibility-btn-container">
									<a href="/index.cfm/go/shop/do/upgrade-checker-widget/" class="UpgradeCheckerButton fancy-box" data-fancybox-type="iframe">
										<span>Check Upgrade Eligibility</span>
									</a>
								</div>
							</cfif>
							<div style="clear:both"></div>
						</div>

					<cfif listContainsNoCase('Phone', variables.productClass)>
						<div class="sortBar">
							<div class="sortPriceOption">
								
								<button class="compareBtn" onClick="if(validateCompareSelected()){document.compareForm.submit()}else{alert('Please select an item or two to compare.')};return false;">Compare Devices</button>
								
								
								<!--- Updates session sort filter --->
								<cfif NOT listContainsNoCase('Phone,Prepaid', variables.productClass)>
									<cfajaxproxy bind="url:/shop/changeSort.cfm?productClass=#variables.productClass#&sort={SortBy.value}&activationPrice={PriceTypeBy.value}" />
								<cfelse>
									<cfajaxproxy bind="url:/shop/changeSort.cfm?productClass=#variables.productClass#&sort={SortBy.value}&activationPrice=new" />
								</cfif>

								<select id="SortBy" name="SortBy" class="dropdownbox" onchange="SortProductList()">
									<option>Sort Devices By...</option>
									<option value="Popular" <cfif request.p.Sort eq 'Popular'>selected="selected"</cfif>>Popular</option>
									<option value="PriceAsc" <cfif request.p.Sort eq 'PriceAsc'>selected="selected"</cfif>>Price: Low to High</option>
									<option value="PriceDesc" <cfif request.p.Sort eq 'PriceDesc'>selected="selected"</cfif>>Price: High to Low</option>
									<option value="NameAsc" <cfif request.p.Sort eq 'NameAsc'>selected="selected"</cfif>>Name: A-Z</option>
									<option value="NameDesc" <cfif request.p.Sort eq 'NameDesc'>selected="selected"</cfif>>Name: Z-A</option>
									<option value="BrandAsc" <cfif request.p.Sort eq 'BrandAsc'>selected="selected"</cfif>>Manufacturer: A-Z</option>
									<option value="BrandDesc" <cfif request.p.Sort eq 'BrandDesc'>selected="selected"</cfif>>Manufacturer: Z-A</option>
								</select>
							</div>
							
							<div style="clear:both"></div>
						</div>
					
					<cfelse>
						<div class="sortBar">
							<div class="sortPriceOption">
								<span>Sort by:</span>
								<!--- Updates session sort filter --->
								<cfif NOT listContainsNoCase('Phone,Prepaid', variables.productClass)>
									<cfajaxproxy bind="url:/shop/changeSort.cfm?productClass=#variables.productClass#&sort={SortBy.value}&activationPrice={PriceTypeBy.value}" />
								<cfelse>
									<cfajaxproxy bind="url:/shop/changeSort.cfm?productClass=#variables.productClass#&sort={SortBy.value}&activationPrice=new" />
								</cfif>

								<select id="SortBy" name="SortBy" class="dropdownbox" onchange="SortProductList()">
									<option value="Popular" <cfif request.p.Sort eq 'Popular'>selected="selected"</cfif>>Popular</option>
									<option value="PriceAsc" <cfif request.p.Sort eq 'PriceAsc'>selected="selected"</cfif>>Price: Low to High</option>
									<option value="PriceDesc" <cfif request.p.Sort eq 'PriceDesc'>selected="selected"</cfif>>Price: High to Low</option>
									<option value="NameAsc" <cfif request.p.Sort eq 'NameAsc'>selected="selected"</cfif>>Name: A-Z</option>
									<option value="NameDesc" <cfif request.p.Sort eq 'NameDesc'>selected="selected"</cfif>>Name: Z-A</option>
									<option value="BrandAsc" <cfif request.p.Sort eq 'BrandAsc'>selected="selected"</cfif>>Manufacturer: A-Z</option>
									<option value="BrandDesc" <cfif request.p.Sort eq 'BrandDesc'>selected="selected"</cfif>>Manufacturer: Z-A</option>
								</select>
							</div>
							<cfif NOT listContainsNoCase('Phone,Prepaid', variables.productClass)>
								<div class="activationPriceOption">
									<span>Show price for:</span>
									<select id="PriceTypeBy" name="PriceTypeBy" class="dropdownbox" onchange="SortProductList()" <cfif session.cart.getActivationType() neq ''>disabled="disabled"</cfif>>
										<option value="New" <cfif request.p.ActivationPrice eq 'New'>selected="selected"</cfif>>New account *</option>
										<option value="Upgrade" <cfif request.p.ActivationPrice eq 'Upgrade'>selected="selected"</cfif>>Upgrade my device *</option>
										<option value="Addaline" <cfif request.p.ActivationPrice eq 'Addaline'>selected="selected"</cfif>>Add a line *</option>
										<cfif channelConfig.getOfferNoContractDevices() and ListContainsNoCase(channelConfig.getNoContractDevices(),variables.productTag)>
											<option value="NoContract" <cfif request.p.ActivationPrice eq 'NoContract'>selected="selected"</cfif>>No Contract *</option>
										</cfif>
									</select>
								</div>
							</cfif>
							<div style="clear:both"></div>
						</div>
						
						</cfif>
						
					</div>
				</div>
				<div style="clear:both;"></div>

				<cfdiv id="resultsDiv" bind="url:/index.cfm/go/shop/do/browse#variables.productClass#Results?#cgi.query_string#" />
			</div>
		</cfoutput>
	</cfsavecontent>

	<cfreturn trim(local.html) />
</cffunction>


<cffunction name="browseProductsResults" access="public" returntype="string" output="false">
	<cfargument name="ProductData" type="query" required="true" />
	<cfargument name="BindAjaxOnLoad" type="boolean" default="true" />
	<cfargument name="ProductClass" type="string" default="" required="false" />

	<cfset var local = structNew() />	
	<cfset var allocatedSkus = allocation.getAllocatedSkusList() />
	<cfset local.planType = 'new' />
	<cfset local.tmoFooterExists = false />
	<cfset request.lstAvailableCarrierIds = "" />
	<cfparam name="request.cart.numLines" default="#application.model.cartHelper.getNumberOfLines()#" />


	<cfscript>
		if (session.cart.getActivationType() eq '')
		{
			//Need to account for filters from Menu options
			if ( ListFind( productFilter.getUserSelectedFilterValuesByFieldName(fieldName = 'filterOptions'), '33') )
			{
				productFilter.setActivationPrice('upgrade');
				request.p.ActivationPrice = 'upgrade';
			}
			else if ( ListFind( productFilter.getUserSelectedFilterValuesByFieldName(fieldName = 'filterOptions'), '34') )
			{
				productFilter.setActivationPrice('addaline');
				request.p.ActivationPrice = 'addaline';
			}
			else if ( ListFind( productFilter.getUserSelectedFilterValuesByFieldName(fieldName = 'filterOptions'), '35') )
			{
				productFilter.setActivationPrice('nocontract');
				request.p.ActivationPrice = 'nocontract';
			}
			else
			{
				request.p.ActivationPrice = productFilter.getActivationPrice();
			}
		}
		else
		{
			request.p.ActivationPrice = session.cart.getActivationType();
		}
	</cfscript>
	


	<cfsavecontent variable="local.html">
		<cfoutput>
			<cfif arguments.bindAjaxOnLoad>
				<cfset AjaxOnLoad('itemsLoaded') />
			</cfif>

			<script language="javascript" type="text/javascript">
				validateCompareSelected = function()	{
					var anythingSelected = false;
					var f = $$('.compareCheck');

					for(var i = 0; i < f.length; i++)	{
						if(f[i].checked)	{
							anythingSelected = true;
							break;
						}
					}
					return anythingSelected;
				}
				
			</script>
			<ul id="prodList" class="prodList #local.planType#">
		</cfoutput>

		<cfif arguments.productData.recordCount>
			<cfset request.lstAvailableProductIds = valueList(arguments.productData.productId) />
			<cfset request.lstAvailableCarrierIds = valueList(arguments.productData.CarrierId) />

			<cfif session.cart.hasCart() and application.model.cartHelper.getLineRateplanProductId(line = session.cart.getCurrentLine())>
				<cfset request.lstAvailableProductIds = application.model[variables.productClass].getProductIdsByPlanId(planId = application.model.cartHelper.getLineRateplanProductId(line = session.cart.getCurrentLine())) />
			</cfif>

			<cfoutput query="arguments.productData">
				
				
				<cfset variables.financePriceList = "">
				
				<cfif(arguments.productData.FinancedMonthlyPrice12 GT 0)>
					<cfset variables.financePriceList= variables.financePriceList & '#arguments.productData.FinancedMonthlyPrice12#,'>
				</cfif>	
						
				<cfif(arguments.productData.FinancedMonthlyPrice18 GT 0)>
					<cfset variables.financePriceList = variables.financePriceList & '#arguments.productData.FinancedMonthlyPrice18#,'>
				</cfif>	
				<cfif(arguments.productData.FinancedMonthlyPrice24 GT 0)>
					<cfset variables.financePriceList = variables.financePriceList & '#arguments.productData.FinancedMonthlyPrice24#,'>
				</cfif>											
						
				<cfset 	local.financedPrices = ListToArray(variables.financePriceList)>
				<cfset local.minFinancedPrice = ArrayMin(local.financedPrices)>

				<cfset local.bProductCompatible = false />
				
				<!--- TMO Phones are sold by TMO based on a special Buy URL that we use to link to TMO --->
				<cfset local.isTMORedirect = channelConfig.getTmoRedirectEnabled() and 
											arguments.productData.carrierId[arguments.productData.currentRow] is 128 and 
											arguments.productData.Prepaid[arguments.productData.currentRow] is 0 and
											arguments.productData.isAvailableOnline[arguments.productData.currentRow] is 1 />
											
				<cfif listFindNoCase(request.lstAvailableProductIds, arguments.productData.productId[arguments.productData.currentRow])>
					<cfset local.bProductCompatible = true />
				</cfif>

				<cfif val(arguments.productData.qtyOnHand[arguments.productData.currentRow]) gt 0 || channelConfig.getDisplayNoInventoryItems()>
				<cfif variables.productClass EQ 'phone' and channelConfig.getOfferFinancedDevices()>
					
					<li class="prodItem" style="cursor:pointer" >
						<div onclick="window.location.href ='/#arguments.productData.productId[arguments.productData.currentRow]#/#stringUtil.friendlyUrl(arguments.productData.DetailTitle[arguments.productData.currentRow])#'"  class="logoContainer <cfif arguments.productData.CarrierId eq 109>logo-att-25<cfelseif arguments.productData.CarrierId eq 128>logo-tmo-25<cfelseif arguments.productData.CarrierId eq 42>logo-verizon-25<cfelseif arguments.productData.CarrierId eq 299>logo-sprint-25</cfif>"></div>
						<div class="compareContainer">
							<!--- check that this is *not* a TMO device --->
							<cfif NOT local.isTMORedirect>			
								<!--- it isn't, display the compare checkbox and link --->					
									<input class="compareCheck" type="checkbox" name="compareIDs" id="compareCheckbox#arguments.productData.productId[arguments.productData.currentRow]#" value="#arguments.productData.productId[arguments.productData.currentRow]#"<cfif listFind(productFilter.getUserSelectedFilterValuesByFieldName('compareIDs'), arguments.productData.productId[arguments.productData.currentRow])> checked="checked"</cfif> />
									<label for="compareCheckbox#arguments.productData.productId[arguments.productData.currentRow]#">Compare</label>
							<cfelse>
							&nbsp;
							</cfif>
						</div>

							<cfif local.isTMORedirect and len(arguments.productData.imageurl[arguments.productData.currentRow])>
								<!--- If TMO and has image URL stored --->		
								<cfset local.imgURL = arguments.productData.imageurl[arguments.productData.currentRow]>
							<cfelseif local.isTMORedirect>
								<!--- If TMO but has no image URL stored --->
								<cfset local.imgURL = "#assetPaths.common#images/Catalog/NoImage.jpg">
							<cfelseif !channelConfig.getDirectToRedesignDetailsPage() && Len(arguments.productData.ImageGuid[arguments.productData.currentRow])>
								<cfset local.imgURL = application.view.imageManager.displayImage(imageGuid = arguments.productData.ImageGuid[arguments.productData.currentRow], height=160, width=0, BadgeType=arguments.productData.BadgeType[arguments.productData.currentRow])>
							
								<!---<a href="/index.cfm/go/shop/do/#variables.productClass#Details/productId/#arguments.productData.productId[arguments.productData.currentRow]#">--->	
								<!---</a>--->
							<cfelseif Len(arguments.productData.ImageGuid[arguments.productData.currentRow])>	
								<!---<a href="/#arguments.productData.productId[arguments.productData.currentRow]#/#stringUtil.friendlyUrl(arguments.productData.DetailTitle[arguments.productData.currentRow])#/activationtype/#request.p.ActivationPrice#">--->
								<cfset local.imgURL = application.view.imageManager.displayImage(imageGuid = arguments.productData.ImageGuid[arguments.productData.currentRow], height=160, width=0, BadgeType=arguments.productData.BadgeType[arguments.productData.currentRow])>

								<!---</a>--->
							<cfelse>
								<a href="/index.cfm/go/shop/do/#variables.productClass#Details/productId/#arguments.productData.productId[arguments.productData.currentRow]#"><img src="#assetPaths.common#images/Catalog/NoImage.jpg" height="160" alt="#htmlEditFormat(arguments.productData.summaryTitle[arguments.productData.currentRow])#" border="0" /></a>
							</cfif>
						<div onclick="window.location.href ='/#arguments.productData.productId[arguments.productData.currentRow]#/#stringUtil.friendlyUrl(arguments.productData.DetailTitle[arguments.productData.currentRow])#'"  class="prodImg" style="text-align: center;background-image:url('#local.imgURL#');">
						<cfif NOT arguments.productData.qtyOnHand[arguments.productData.currentRow]>
							<img src="#assetPaths.common#images/ui/OutOfStock.png">
						</cfif>	
							<cfif ListFindNoCase(allocatedSkus,#arguments.productData.gersSku[arguments.productData.currentRow]#) gt 0 and allocation.loadBySku(#arguments.productData.gersSku[arguments.productData.currentRow]#)>
									<cfswitch expression="#allocation.getInventoryTypeDescription()#">
										<cfcase value="Pre-Sale">
											<!---Pre-Sale: expected release date #dateformat(allocation.getReleaseDate(),"mm/dd/yyyy")#--->
											<div class="imagePromotion">PRESALE</div>
										</cfcase>
										<cfcase value="Backorder">								
											<!---<div class="imagePromotion"><!---BACKORDERED---></div>--->
										</cfcase>
									</cfswitch>
							</cfif>									
							<!---<cfif trim(application.view.product.ReplaceRebate( '%CarrierRebate1% %CarrierRebate2% %CarrierSkuRebate1% %CarrierSkuRebate2%', arguments.productData.carrierid[arguments.productData.currentRow], arguments.productData.gersSku[arguments.productData.currentRow])) is not "" >--->
							<cfif listFindNoCase(rebateSkus,arguments.productData.gersSku[arguments.productData.currentRow])>				
							<div class="imagePromotion">REBATE</div>
							</cfif>
						
						</div>
						<br style="clear:both">
<div class="bottomContainer">		
						<div onclick="window.location.href ='/#arguments.productData.productId[arguments.productData.currentRow]#/#stringUtil.friendlyUrl(arguments.productData.DetailTitle[arguments.productData.currentRow])#/activationtype/#request.p.ActivationPrice#'"  class="prodTitle">
							<cfif !channelConfig.getDirectToRedesignDetailsPage()>
								<!--- Temp for 6.5 release to point to legacy details page ---->
								<h2><a href="/index.cfm/go/shop/do/#variables.productClass#Details/productId/#arguments.productData.productId[arguments.productData.currentRow]#">#trim(arguments.productData.summaryTitle[arguments.productData.currentRow])#</a></h2>						
							<cfelse>
								<h2><a href="/#arguments.productData.productId[arguments.productData.currentRow]#/#stringUtil.friendlyUrl(arguments.productData.DetailTitle[arguments.productData.currentRow])#/activationtype/#request.p.ActivationPrice#">#trim(arguments.productData.summaryTitle[arguments.productData.currentRow])#</a></h2>
							</cfif>
						</div>
						
						<cfif arguments.productData.IsNewPriceMap[arguments.productData.currentRow]>
							<div onclick="window.location.href ='/#arguments.productData.productId[arguments.productData.currentRow]#/#stringUtil.friendlyUrl(arguments.productData.DetailTitle[arguments.productData.currentRow])#/activationtype/#request.p.ActivationPrice#'"  class="prodPrice">
								<a href="/#arguments.productData.productId[arguments.productData.currentRow]#/#stringUtil.friendlyUrl(arguments.productData.DetailTitle[arguments.productData.currentRow])#"> Click to show pricing</a>
							</div>	
						<cfelse>
						
							<!--- FB 885 Treat TMO like other carriers, it is only showing financed --->
							<!---<cfif (arguments.productData.carrierId[arguments.productData.currentRow] eq 128>
							<div onclick="window.location.href ='/#arguments.productData.productId[arguments.productData.currentRow]#/#stringUtil.friendlyUrl(arguments.productData.DetailTitle[arguments.productData.currentRow])#/activationtype/#request.p.ActivationPrice#'"  class="prodPrice">
								
								<div style="text-align:center;">
									<cfif arguments.productData.monthlyPayment gt 0.00>
										<span class="bold red">#dollarFormat(arguments.productData.downpayment)#</span> down</div>
									<cfelse>
										Full Retail Price:<span class="bold red"> #dollarFormat(arguments.productData.price_new)#</span></div>
									</cfif>
								<div style="text-align:center;font-size:9px;padding-top:5px">
									If you cancel service, bal. on phone due.
								</div>
							</div>
							
							<cfelse>--->	
							<div onclick="window.location.href ='/#arguments.productData.productId[arguments.productData.currentRow]#/#stringUtil.friendlyUrl(arguments.productData.DetailTitle[arguments.productData.currentRow])#/activationtype/#request.p.ActivationPrice#'"  class="prodPrice">
								
								<cfif arguments.productData.price_new[arguments.productData.currentRow] NEQ "9999" AND arguments.productData.newPriceAfterRebate[arguments.productData.currentRow] NEQ "9999">							
									<div class="leftCol<cfif arguments.productData.carrierID EQ 42 and val(local.minFinancedPrice)>vzw</cfif>">2-year:</div>
									<div class="rightCol<cfif arguments.productData.carrierID EQ 42 and val(local.minFinancedPrice)>vzw</cfif>"><span class="bold red">
									
									<cfif val(arguments.productData.newPriceAfterRebate[arguments.productData.currentRow])>			
										#DollarFormat(arguments.productData.newPriceAfterRebate[arguments.productData.currentRow])#
									<cfelse>
										#DollarFormat(arguments.productData.price_new[arguments.productData.currentRow])#
									</cfif>	
										</span> 
									
								</div>
								</cfif>
								 <br style="clear:both" />
								<cfif val(local.minFinancedPrice)>
								<div class="leftCol<cfif arguments.productData.carrierID EQ 42>vzw</cfif>">#getFinanceProductName( arguments.productData.CarrierId )#:</div>
								<div class="rightCol<cfif arguments.productData.carrierID EQ 42>vzw</cfif>"> 
									<cfif arguments.productData.carrierID EQ 42>
										<span class="bold red">#DollarFormat(local.minFinancedPrice)#</span><span style="font-size:9px;">/mo for 24 mos*</span>
									<cfelseif arguments.productData.carrierID EQ 109 >
										
										<span class="bold red">#DollarFormat(local.minFinancedPrice)#</span>#getFinanceProductTerm( arguments.productData.CarrierId )#
									<cfelseif arguments.productData.carrierID EQ 299>
										<span class="bold red">$0.00</span>#getFinanceProductTerm( arguments.productData.CarrierId )#
									<cfelseif arguments.productData.carrierID EQ 128>
										<span class="bold red">#DollarFormat(local.minFinancedPrice)#</span><span style="font-size:9px;">/mo</span>
									<cfelse>
										#getFinanceProductTerm( arguments.productData.CarrierId )#
									</cfif>
								</div>
																
									<cfif arguments.productData.carrierId[arguments.productData.currentRow] eq 42>
										<br style="clear:both">
										<div style="text-align:center;font-size:9px;margin-top:2px">
											*0% APR, Full Price: #DollarFormat(arguments.productData.FinancedFullRetailPrice[arguments.productData.currentRow])#<br>
											<cfif findNoCase( 'costco', channelConfig.getDisplayName() )>
												Monthly available in Warehouse only.
											<cfelse>
												Monthly available In-Store only.
											</cfif>
										</div>
									<cfelseif arguments.productData.carrierId[arguments.productData.currentRow] eq 299>
									<br style="clear:both">
										<div style="text-align:center;font-size:9px;margin-top:2px">
											#DollarFormat(arguments.productData.FinancedMonthlyPrice24[arguments.productData.currentRow])#/mo for 24 months&dagger;
										</div>
									</cfif>
								</cfif>		
							
							
	
							</div>
							
							<!---</cfif>--->
						</cfif>
						<br style="clear:both">
					</div><!-- /bottomContainer-->
					<div class="bottomContainerOverlay">
					<div class="blockCTA">
	                	<div class="ctaButton">
	                    	<a href="/#arguments.productData.productId[arguments.productData.currentRow]#/#stringUtil.friendlyUrl(arguments.productData.DetailTitle[arguments.productData.currentRow])#/activationtype/#request.p.ActivationPrice#"><span class="buttonText">View Details</span></a>
	                    </div>
	                </div>  
                </div>
					</li>
				<cfelse><!--- THIS NEXT SECION IS FOR DEVICES THAT DO NOT SUPPORT FINANCING --->	
					<li class="prodItem">
						<div class="prodImg" style="text-align: center">
							<cfif local.isTMORedirect and len(arguments.productData.imageurl[arguments.productData.currentRow])>
								<!--- If TMO and has image URL stored --->		
								<img src="#arguments.productData.imageurl[arguments.productData.currentRow]#" height="190" border="0" />
							<cfelseif local.isTMORedirect>
								<!--- If TMO but has no image URL stored --->
								<img src="#assetPaths.common#images/Catalog/NoImage.jpg" height="190" alt="#htmlEditFormat(arguments.productData.summaryTitle[arguments.productData.currentRow])#" border="0" />
							<cfelseif Len(arguments.productData.ImageGuid[arguments.productData.currentRow])>
								<!--- Temp for 6.5 release to point to legacy details page ---->
								<a href="/index.cfm/go/shop/do/#variables.productClass#Details/productId/#arguments.productData.productId[arguments.productData.currentRow]#">
									<img src="#application.view.imageManager.displayImage(imageGuid = '#arguments.productData.ImageGuid[arguments.productData.currentRow]#', height=190, width=0, BadgeType="#arguments.productData.BadgeType[arguments.productData.currentRow]#")#" alt="#htmlEditFormat(arguments.productData.summaryTitle[arguments.productData.currentRow])#" title="#htmlEditFormat(arguments.productData.summaryTitle[arguments.productData.currentRow])#" height="190" border="0" />
								</a>
							<cfelseif Len(arguments.productData.ImageGuid[arguments.productData.currentRow])>	
								<a href="/#arguments.productData.productId[arguments.productData.currentRow]#/#stringUtil.friendlyUrl(arguments.productData.DetailTitle[arguments.productData.currentRow])#">
									<img src="#application.view.imageManager.displayImage(imageGuid = '#arguments.productData.ImageGuid[arguments.productData.currentRow]#', height=190, width=0, BadgeType="#arguments.productData.BadgeType[arguments.productData.currentRow]#")#" alt="#htmlEditFormat(arguments.productData.summaryTitle[arguments.productData.currentRow])#" title="#htmlEditFormat(arguments.productData.summaryTitle[arguments.productData.currentRow])#" height="190" border="0" />
								</a>
							<cfelse>
								<a href="/index.cfm/go/shop/do/#variables.productClass#Details/productId/#arguments.productData.productId[arguments.productData.currentRow]#"><img src="#assetPaths.common#images/Catalog/NoImage.jpg" height="190" alt="#htmlEditFormat(arguments.productData.summaryTitle[arguments.productData.currentRow])#" border="0" /></a>
							</cfif>
							<!--- Modified on 10/31/2014 by Denard Springle (denard.springle@cfwebtools.com) --->
							<!--- Track #: 6960 - TMO Affiliate - AAFES: Users can add phone to cart from Compare [ Suppress compare checkbox and link for TMO ] --->

							<!--- check that this is *not* a TMO device --->
							<cfif NOT arguments.productData.carrierId[arguments.productData.currentRow] eq 128>			
								<!--- it isn't, display the compare checkbox and link --->					
								<div class="toolbar">
									<input class="compareCheck" type="checkbox" name="compareIDs" id="compareCheckbox#arguments.productData.productId[arguments.productData.currentRow]#" value="#arguments.productData.productId[arguments.productData.currentRow]#"<cfif listFind(productFilter.getUserSelectedFilterValuesByFieldName('compareIDs'), arguments.productData.productId[arguments.productData.currentRow])> checked="checked"</cfif> />
									<label for="compareCheckbox#arguments.productData.productId[arguments.productData.currentRow]#">Compare</label>
									<a href="##" onClick="if(validateCompareSelected()){document.compareForm.submit()}else{alert('Please select an item or two to compare.')};return false;">compare now</a>
									<cfajaxproxy bind="url:/shop/changeCompareIds.cfm?productClass=#variables.productClass#&compareId={compareCheckbox#arguments.productData.productId[arguments.productData.currentRow]#@none}&compareChecked={compareCheckbox#arguments.productData.productId[arguments.productData.currentRow]#.checked}">
								</div>
							</cfif>
							<!--- END EDITS on 10/31/2014 by Denard Springle --->
						</div>
						<div class="prodDetail<cfif local.isTMORedirect> tmoProdDetail</cfif>">
							<cfif request.config.debugInventoryData>
								<div id="inventoryDebugIcon_#arguments.productData.productId[arguments.productData.currentRow]#" class="inventoryDebugIcon" onmouseover="revealInventoryDebugInfo(#arguments.productData.productId[arguments.productData.currentRow]#,this);document.body.style.cursor='pointer';"></div>
								<div id="inventoryDebugInfo_#arguments.productData.productId[arguments.productData.currentRow]#" class="inventoryDebugInfo" onmouseout="hideInventoryDebugInfo(this);document.body.style.cursor='';">
									<div style="float: left">GERS SKU:</div><div style="float: right">#arguments.productData.gersSku[arguments.productData.currentRow]#</div><br clear="all" />
									<div style="float: left">Qty On-Hand:</div><div style="float: right">#arguments.productData.qtyOnHand[arguments.productData.currentRow]#</div><br clear="all" />
									<div style="float: left">UPC Code:</div><div style="float: right">#arguments.productData.upc[arguments.productData.currentRow]#</div><br clear="all" />
									<div style="float: left">Release Date:</div><div style="float: right">#arguments.productData.ReleaseDate[arguments.productData.currentRow]#</div><br clear="all" />
									<div style="float: left;">Device Type:</div><div style="float:right;">#arguments.productData.DeviceType[arguments.productData.currentRow]#</div><br/>
									<div style="float: left;">Manufacturer:</div><div style="float:right;">#arguments.productData.ManufacturerName[arguments.productData.currentRow]#</div><br/>
									<div style="float: left;">Activation Pricing:</div><div style="float:right;">#arguments.productData.ActivationPrice[arguments.productData.currentRow]#</div><br/>
									<div style="float: left;">Retail Price:</div><div style="float:right;">#arguments.productData.price_retail[arguments.productData.currentRow]#</div><br/>
									<div style="float: left;">New Price:</div><div style="float:right;">#arguments.productData.price_new[arguments.productData.currentRow]#</div><br/>
									<div style="float: left;">Upgrade Price:</div><div style="float:right;">#arguments.productData.price_upgrade[arguments.productData.currentRow]#</div><br/>
									<div style="float: left;">Add-a-Line Price:</div><div style="float:right;">#arguments.productData.price_addaline[arguments.productData.currentRow]#</div><br/>
									<div style="float: left;">No Contract Price:</div><div style="float:right;">#arguments.productData.price_nocontract[arguments.productData.currentRow]#</div><br/>
									<div style="float: left;">Financed Price 12:</div><div style="float:right;">#arguments.productData.FinancedMonthlyPrice12[arguments.productData.currentRow]#</div><br/>
									<div style="float: left;">Financed Price 18:</div><div style="float:right;">#arguments.productData.FinancedMonthlyPrice18[arguments.productData.currentRow]#</div><br/>
									<div style="float: left;">Financed Price 24:</div><div style="float:right;">#arguments.productData.FinancedMonthlyPrice24[arguments.productData.currentRow]#</div><br/>
									<div style="float: left;">No-Contract Restriction:</div><div style="float:right;">#arguments.productData.IsNoContractRestricted[arguments.productData.currentRow]#</div><br/>
									<div style="float: left;">New Restriction:</div><div style="float:right;">#arguments.productData.IsNewActivationRestricted[arguments.productData.currentRow]#</div><br/>
									<div style="float: left;">Upgrade Restriction:</div><div style="float:right;">#arguments.productData.IsUpgradeActivationRestricted[arguments.productData.currentRow]#</div><br/>
									<div style="float: left;">Add-a-Line Restriction:</div><div style="float:right;">#arguments.productData.IsAddALineActivationRestricted[arguments.productData.currentRow]#</div><br/>
									<div style="float: left;">Available in Warehouse:</div><div style="float:right;">#arguments.productData.IsAvailableInWarehouse[arguments.productData.currentRow]#</div><br/>
									<div style="float: left;">Available Online:</div><div style="float:right;">#arguments.productData.IsAvailableOnline[arguments.productData.currentRow]#</div><br/>
								</div>
							</cfif>
							<!--- device title --->
							<cfif local.isTMORedirect>
								<h2>#trim(arguments.productData.summaryTitle[arguments.productData.currentRow])#</h2>
							<cfelse>
								<h2><a href="/index.cfm/go/shop/do/#variables.productClass#Details/productId/#arguments.productData.productId[arguments.productData.currentRow]#">#trim(arguments.productData.summaryTitle[arguments.productData.currentRow])#</a></h2>						
							</cfif>
							<!--- See if this is in the allocateSkus list and allocation information is available: if Yes, display allocation message --->
							<cfif ListFindNoCase(allocatedSkus,#arguments.productData.gersSku[arguments.productData.currentRow]#) gt 0 and allocation.loadBySku(#arguments.productData.gersSku[arguments.productData.currentRow]#)>
								<div class="allocationMsg">
									<cfswitch expression="#allocation.getInventoryTypeDescription()#">
										<cfcase value="Pre-Sale">
											<!---Pre-Sale: expected release date #dateformat(allocation.getReleaseDate(),"mm/dd/yyyy")#--->
											#allocation.getBrowseMessage()#
										</cfcase>
										<cfcase value="Backorder">								
											#allocation.getBrowseMessage()#
										</cfcase>
									</cfswitch>
								</div>
							</cfif>

							<!--- Modified on 11/04/2014 by Denard Springle (denard.springle@cfwebtools.com) --->
							<!--- Track #: N/A - Modify product view for TMO devices in COSTCO channel [ Modified how summaryDescription and rebates are presented with TMO devices ] --->

							<div class="prodDesc">
								<!--- display summaryDescription with rebates --->
								#application.view.product.ReplaceRebate( '<span class="rebate-callout">%CarrierRebate1% %CarrierRebate2% %CarrierSkuRebate1% %CarrierSkuRebate2%</span>', arguments.productData.carrierId[arguments.productData.currentRow], arguments.productData.gersSku[arguments.productData.currentRow])#
								
								<!--- Modified on 11/25/2014 by Denard Springle (denard.springle@cfwebtools.com) --->
								<!--- Track #: 7039 - Display Product Summary for T-Mobile Devices [ Removed product summary suppression for TMO devices ] --->

								<!--- show summary information for all devices --->
								#arguments.productData.summaryDescription[arguments.productData.currentRow]#

								<!--- END EDITS on 11/25/2014 by Denard Springle --->

								<!--- check if this is a TMO device and has a monthly payment --->
								<cfif local.isTMORedirect AND arguments.productData.MonthlyPayment[arguments.productData.currentRow] GT 0>
									<!--- it does, show disclaimer --->
									<div class="tmoFinance">IF YOU FINANCE YOUR DEVICE AND CANCEL WIRELESS SERVICE, REMAINING BALANCE ON PHONE BECOMES DUE</div>
								</cfif>
							</div>

							<!--- END EDITS on 11/04/2014 by Denard Springle --->

							<!--- Modified on 11/05/2014 by Denard Springle (denard.springle@cfwebtools.com) --->
							<!--- Track #: N/A - Modify product view for TMO devices in COSTCO channel [ Modify Online Value link to TMO image ] --->

							<div class="toolbar">
								<span>
									<span class="toolbarAvailability">
										<table rowspacing="0" colspacing="0">
											<tr>
											<!--- check if this channel should display the online value and the device has free accessories --->
											<cfif channelConfig.getDisplayOnlineValue() && arguments.productData.bFreeAccessory[arguments.productData.currentRow]>
												<td>
													<!--- it should and does, check if this is a TMO device --->
													<cfif local.isTMORedirect>			
														<!--- it is, show the TMO benefits --->							
														<a href="#assetPaths.common#images/onlinebenefit/costcoValue_Tmo_version_1_0.jpg" rel="lightbox" title="#channelConfig.getDisplayName()# Online Value">
									         				<img src="#assetPaths.common#images/ui/member_value_logo.png" align="right" border="0" alt="#channelConfig.getDisplayName()# Online Value" title="#channelConfig.getDisplayName()# Online Value" width="120" height="27" style="display: block; float: right; cursor: pointer;" />
														</a>
													<cfelse>			
														<!--- it isn't, show standard benefits --->							
														<a href="#assetPaths.common#images/onlinebenefit/costcoValue_version_5.jpg" rel="lightbox" title="#channelConfig.getDisplayName()# Online Value">
									         				<img src="#assetPaths.common#images/ui/member_value_logo.png" align="right" border="0" alt="#channelConfig.getDisplayName()# Online Value" title="#channelConfig.getDisplayName()# Online Value" width="120" height="27" style="display: block; margin-right:10px; float: right; cursor: pointer;" />
														</a>
													</cfif>
												</td>
											</cfif>
												<td style="width:100px;">Available: <br />
													<span class="toolbarAvailabilityValue">
														<cfif arguments.productData.IsAvailableInWarehouse[arguments.productData.currentRow] && arguments.productData.IsAvailableOnline[arguments.productData.currentRow]>
															Online + #textDisplayRenderer.getStoreAliasName()#
														<cfelseif arguments.productData.IsAvailableOnline[arguments.productData.currentRow]>
															Online Only
														<cfelseif arguments.productData.IsAvailableInWarehouse[arguments.productData.currentRow]>
															#textDisplayRenderer.getStoreAliasName()# Only
														</cfif>
													</span>
												</td>
												<td valign="top">
													<!--- check if this is a TMO device --->
													<cfif arguments.productData.carrierId[arguments.productData.currentRow] eq 128 AND Len(arguments.productData.summaryDescription[arguments.productData.currentRow])>	
														<!--- it is, add TMO disclaimer --->
														<div style="margin-left:10px;">*Accessories &amp; Costco Cash Card ship separately from device.</div>
													</cfif>
												</td>
											</tr>
										</table>
									</span>
								</span>
							</div>

							<!--- END EDITS on 11/05/2014 by Denard Springle --->
						</div>

						<cfscript>
							local.priceBlock = CreateObject( 'component', 'cfc.model.catalog.PriceBlock' ).init();
							local.priceBlock.setRetailPrice( arguments.productData.price_retail[arguments.productData.currentRow] );
				        	local.priceBlock.setNewPrice( arguments.productData.price_new[arguments.productData.currentRow] );
				        	local.priceBlock.setUpgradePrice( arguments.productData.price_upgrade[arguments.productData.currentRow] );
				        	local.priceBlock.setAddALinePrice( arguments.productData.price_addaline[arguments.productData.currentRow] );
				        	local.priceBlock.setNewPriceAfterRebate( arguments.productData.NewPriceAfterRebate[arguments.productData.currentRow] );
				        	local.priceBlock.setUpgradePriceAfterRebate( arguments.productData.UpgradePriceAfterRebate[arguments.productData.currentRow] );
				        	local.priceBlock.setAddALinePriceAfterRebate( arguments.productData.AddALinePriceAfterRebate[arguments.productData.currentRow] );
				        	local.priceBlock.setMonthlyPayment( arguments.productData.MonthlyPayment[arguments.productData.currentRow] );
				        	local.priceBlock.setDownPayment( arguments.productData.DownPayment[arguments.productData.currentRow] );

							local.priceArgs = {};
							local.priceArgs.ProductId = arguments.productData.productId[arguments.productData.currentRow];
							local.priceArgs.CarrierId = arguments.productData.carrierId[arguments.productData.currentRow];
							local.priceArgs.PriceBlock = local.priceBlock;
							local.priceArgs.bProductCompatible = local.bProductCompatible;
							local.priceArgs.bPrePaid = arguments.productData.prepaid[arguments.productData.currentRow];
							local.priceArgs.AvailableQty = arguments.productData.qtyOnHand[arguments.productData.currentRow];
							local.priceArgs.IsNewPriceMap = arguments.productData.IsNewPriceMap[arguments.productData.currentRow];
							local.priceArgs.IsUpgradePriceMap = arguments.productData.IsUpgradePriceMap[arguments.productData.currentRow];
							local.priceArgs.IsAddalinePriceMap = arguments.productData.IsAddalinePriceMap[arguments.productData.currentRow];
							local.priceArgs.planType = local.planType;
							local.priceArgs.IsSmartPhone = arguments.productData.IsSmartPhone[arguments.productData.currentRow];
							local.priceArgs.IsNoContractRestricted = arguments.productData.IsNoContractRestricted[arguments.productData.currentRow];
							local.priceArgs.IsNewActivationRestricted = arguments.productData.IsNewActivationRestricted[arguments.productData.currentRow];
							local.priceArgs.IsUpgradeActivationRestricted = arguments.productData.IsUpgradeActivationRestricted[arguments.productData.currentRow];
							local.priceArgs.IsAddALineActivationRestricted = arguments.productData.IsAddALineActivationRestricted[arguments.productData.currentRow];							
							local.priceArgs.IsDetailsPageView = false;
							local.priceArgs.HasFreeKitBundle = arguments.productData.bFreeAccessory[arguments.productData.currentRow];
							local.priceArgs.isTMORedirect = local.isTMORedirect;
							local.priceArgs.TMOBuyURL =  arguments.productData.buyurl[arguments.productData.currentRow];
							local.priceArgs.metakeywords =  arguments.productData.metakeywords[arguments.productData.currentRow];
							local.priceArgs.IsProductCompatibleWithPlan = local.bProductCompatible;
							local.pricingHTML = renderProductPrices(argumentCollection = local.priceArgs);
						</cfscript>

						#trim(local.pricingHTML)#
					</li>
				</cfif>
				
				
				</cfif>
				
				
			</cfoutput>
		<cfelse>
		<cfoutput>
			<li class="prodItem">
				
				<div style="width:150px;margin:0 auto; text-align:center">				
					<p>There are no Devices matching your current filter criteria.</p>
					<p>Please modify your filters and try again. </p>
				</div>
				</li>
		</cfoutput>	
		</cfif>
		<cfoutput>
			</ul>
			<br clear="all" />
		</cfoutput>
		
		<!--- Add disclaimer footer if this is a t-mobile affiliate phone --->
<!---		<cfif arguments.productData.recordCount AND local.isTMORedirect AND NOT local.tmoFooterExists>
			<div style="margin-top: 15px; width: 675px">
				Limited time offers; subject to change. Taxes and fees additional. <strong>General Terms:</strong> Credit approval, deposit, qualifying service, 
				and $15 SIM  starter kit may be required. <strong>Equipment Installment Plan:</strong> Availability and amount of EIP financing <strong>subject to credit 
				approval</strong>. Down payment &  unfinanced portion required at purchase. Balance paid in monthly installments. Must remain on qualifying 
				service in good standing for duration  of EIP agreement. Taxes and late/non-payment fees may apply. Participating locations only. 
				Examples shown reflects the down payment & monthly  payments of our most crditworthy customers; amounts for others will vary. 
				Pricing applicable to single device purchase. Device and screen  images simulated. <strong>Coverage</strong> not available in some areas. See 
				brochures and <strong>Terms and Conditions (including arbitration provision)</strong> at <a href="http://www.T-Mobile.com">www.T-Mobile.com</a> for additional information. T-Mobile and 
				the magenta color are registered trademarks of Deutsche Telekom AG.
			</div>
			<cfset local.tmoFooterExists = true />
		</cfif>--->
		
		
		<!--- Add disclaimer if Droid product is displayed --->
		<cfif listFind(valueList(arguments.productData.productId ), 3770) or listFind(valueList(arguments.productData.productId), 3793)>
			<div style="margin-top: 25px; width: 675px">
				DROID is a trademark of Lucasfilm Ltd. and its related companies.  Used under license. Google, the Google logo and Android
				Market are trademarks of Google, Inc.&copy; 2011 Verizon Wireless. Activation fee/line: $35.  IMPORTANT VERIZON WIRELESS
				CUSTOMER INFORMATION:  Subject to Cust. Agmt, Calling Plan & credit approval.  Up to $350 early termination fee & add'l
				charges apply to device capabilities.  Offers & coverage, varying by svc, not available everywhere; see vzw.com.
				&copy; 2011 Verizon Wireless
			</div>
		</cfif>
		<!--- Add disclaimer for Costco Ad --->
		<cfif StructKeyExists(variables, 'filterOptionId') and variables.filterOptionId is '0,189'>
			<div style="margin-top: 25px; width: 675px">
				IMPORTANT COSTCO CONSUMER INFORMATION: All cell phone sales require a new service agreement or qualified upgrade. Cell phones must be activated
				at time of purchase. Visit your local Costco kiosk or http://membershipwireless.com for complete details. Wireless Advocates, an Authorized Retailer,
				operates the wireless kiosks. Phone Selection Varies by Warehouse.

				<ol>
					<li style="list-style: decimal outside;">T-Mobile's 4G HSPA+ network not available everywhere.</li>
					<li style="list-style: decimal outside;">DROID is a trademark of Lucasfilm Ltd. and its related companies.  Used under license.  Google, the Google logo and Android Market are trademarks of Google, Inc. &copy; 2011 Verizon Wireless. <a href="http://vzwmap.verizonwireless.com/dotcom/coveragelocator/default.aspx?requestfrom=webagent" target="_blank">Click Here for Details</a></li>
					<li style="list-style: decimal outside;">4G speeds available in limited areas and may not be available in your area.  Other restrictions apply.</li>
				<ol>
			</div>
		</cfif>
		<!--- Add disclaimer for Costco Weekly Ad Special --->
		<cfif StructKeyExists(variables, 'filterOptionId') and variables.filterOptionId is '0,132'>
			<div style="margin-top: 25px; width: 675px">
				<ul>
					<li style="list-style:none outside;">* 2011 T-Mobile's HSPA+ 4G network, including increased speeds, not available everywhere. Limited time offer; subject to change. Taxes and fees additional. Not all plans or features available on all devices. At participating locations. Domestic only. Credit approval, $35 per line activation fee or $18 per line upgrade fee, deposit and new two-year agreement on a qualifying plan (with up to $200/line early cancellation fee) may be required. Device and screen images simulated. T-Mobile and the magenta color are registered trademarks of Deutsche Telekom AG. &copy; 2010 Samsung Telecommunications America, LLC (""Samsung"). Samsung, Vibrant and Galaxy S are all trademarks of Samsung Electronics America, Inc. and/or its related entities.</li>
					<li style="list-style:none outside;">VZW: &para; Activation fee/line: $35. IMPORTANT VERIZON WIRELESS CUSTOMER INFORMATION: Subject to Customer Agreement, Calling Plan and credit approval. Up to $350 early termination fee and additional charges apply to device capabilities. New 2 year activation and data package required. Offers and coverage, varying by service, not available everywhere. Click here for details.  LTE is a trademark of ETSI. 4G LTE is available in 194 cities.</li>
					<li style="list-style:none outside;">TMO: &Dagger; May require up to a $36 activation fee/line, credit approval & deposit. Up to $350 early termination fee/line applies. Coverage not available everywhere. Sprint 4G network reaches over 70 markets and counting.  Sprint 3G network reaches over 274 million people.  Offers not available in all markets/retail locations or for all phones/networks. Other restrictions apply. Android is a trademark of Google, Inc. The Android robot is based on work created and shared by Google and used in accordance to the Creative Commons 3.0 License.
					<li style="list-style:none outside;">AT&T: &sect; Limited 4G LTE availability in select markets. Deployment ongoing. 4G LTE device and data plan required. Claim compares 4G LTE download speeds to industry average 3G download speeds. LTE is a trademark of ETSI. Requires 4G device and compatible data plan.</li>
				</ul>
			</div>
		</cfif>
		<!--- Add disclaimer for Verizon landing page link --->
		<cfif StructKeyExists(variables, 'filterOptionId') and variables.filterOptionId is '0,3'>
			<div style="margin-top: 10px; width: 675px">
				Xperia&#153; is a trademark or registered trademark of Sony Ericsson Mobile Communications AB. All other trademarks are property of their respective owners.<br /><br />
				DROID is a trademark of Lucasfilm Ltd. and its related companies.  Used under license.Google, the Google logo and Android Market are trademarks of Google, Inc.&copy; 2011 Verizon Wireless.
			</div>
		</cfif>
		<!--- Add disclaimer for Verizon landing page link --->
		<cfif StructKeyExists(variables, 'filterOptionId') and variables.filterOptionId is '0,229'>
			<div style="margin-top: 10px; width: 675px">
				**Activation fee/line: $35. IMPORTANT VERIZON WIRELESS CUSTOMER INFORMATION: Subject to Customer Agreement,
				Calling Plan and credit approval. Up to $350 early termination fee and additional charges apply to device capabilities.
				New 2 year activation and data package required. Offers and coverage, varying by service, not available everywhere.
				Click here for details.  LTE is a trademark of ETSI. 4G LTE is available in 194 cities in the U.S.
			</div>
		</cfif>
		<!--- Add disclaimer for MVM --->
		<cfif StructKeyExists(variables, 'filterOptionId') and variables.filterOptionId is '0,265'>
			<div style="margin-top: 25px; width: 675px">
				All phone purchases require a new 2-year activation on qualifying plan or qualified upgrade contract extension. Phones must be activated at the time or purchase on Membershipwireless.com. 
				Wireless carrier requirements may include activation/upgrade fee/line, customer agrmt, calling plan, credit approval, deposit & early termination fees. Other add'l charges/fees may apply. 
				Offers &amp coverage will vary by location. See wireless carrier's website for coverage details. <br />
				&copy 2013 Samsung Telecommunications America, LLC. Samsung and Galaxy S are both registered trademarks of Samsung Electronics Co., Ltd. <br />
				&copy 2013 HTC Corporation. All rights reserved. HTC and HTC names herein are the trademarks of HTC Corporation.
			</div>
		</cfif>
		<!--- Add disclaimer for AT&T Banner --->
		<cfif StructKeyExists(variables, 'filterOptionId') and variables.filterOptionId is '0,297'>
			<div style="margin-top: 25px; width: 675px">
				<ul>
					<li style="list-style:none outside;">&para;: AT&T - Limited 4G LTE availability in select markets. Deployment ongoing. 4G LTE device and data plan required. Claim compares 4G LTE download speeds to industry average 3G download speeds. LTE is a trademark of ETSI. Requires 4G device and compatible data plan. &copy; 2011 Samsung Telecommunications America, LLC ("Samsung"). Samsung, Galaxy S and Skyrocket are all trademarks of Samsung Electronics Co., Ltd. </li>
				</ul>
			</div>
		</cfif>
		<!--- Add disclaimer for Samsung --->
		<cfif StructKeyExists(variables, 'filterOptionId') and variables.filterOptionId is '0,373'>
			<div style="margin-top: 25px; width: 675px">
				<ul>
					<li style="list-style:none outside;">
						2013 Samsung Telecommunications America, LLC. <br />
						Samsung and Galaxy S are both registered trademarks of Samsung Electronics Co., Ltd. <br />
						&copy; 2013 Samsung Telecommunications America, LLC. Samsung and Galaxy S are both registered trademarks of Samsung Electronics Co., Ltd. <br />
					</li>
				</ul>
			</div>
		</cfif>
		<!--- Add disclaimer for iPhone --->
		<cfif StructKeyExists(variables, 'filterOptionId') && ( ListFindNoCase(variables.filterOptionId, 384) || ListFindNoCase(variables.filterOptionId, 381) ) >
			<div style="margin-top: 25px; width: 675px">
				<ul>
					<li style="list-style:none outside;">
						Apple, the Apple logo, iPhone, iSight, and Retina are trademarks of Apple Inc., registered in the U.S. and other 
						countries. Multi-Touch is a trademark of Apple Inc. iCloud is a service mark of Apple Inc., registered in the U.S. 
						and other countries.
					</li>
				</ul>
			</div>
		</cfif>	
		
		
			<!--- Add disclaimer for iPhone --->
		<cfif StructKeyExists(variables, 'filterOptionId') && ( ListFindNoCase(variables.filterOptionId, 384) || ListFindNoCase(variables.filterOptionId, 381) ) >
			<div style="margin-top: 25px; width: 675px">
				<ul>
					<li style="list-style:none outside;">
						Apple, the Apple logo, iPhone, iSight, and Retina are trademarks of Apple Inc., registered in the U.S. and other 
						countries. Multi-Touch is a trademark of Apple Inc. iCloud is a service mark of Apple Inc., registered in the U.S. 
						and other countries.
					</li>
				</ul>
			</div>
		</cfif>		
		
		<!---ATT legal--->
	<cfif listFindNoCase(request.lstAvailableCarrierIds, 109)>
		<div style="margin-top: 25px; width: 675px">
				<ul>
					<li style="list-style:none outside;">
					
					<p><strong>AT&amp;T Next&#8480;:</strong> Requires 30-month, 24- month, or 20-month 0% APR installment agreement and qualifying credit. Tax due at sale. Wireless service (voice and data) required and is additional. Equipment price may vary by location. Available at select locations. Service subject to Wireless Customer Agreement or qualified Business Agreement. Limit 4 devices for consumers or Individual Responsibility Users (or 10 Corporate Responsibility User devices for eligible business customers) on a AT&amp;T Next&#8480; or tablet installment agreement may apply per account. Agreement balance for device due if wireless svc cancelled. Select locations. Restocking fee: up to $35. Upgrade options: Requires payment of 24, 18, or 12 installments based on AT&amp;T Next&#8480; option, account in good standing, trade-in of your financed device in good physical and fully functional condition, and purchase of new eligible device with qualifying wireless service. After upgrade, unbilled installments are waived. Coverage and services not available everywhere. Other Monthly Charges: Apply per line and may include taxes, federal/state universal service charges, a Regulatory Cost Recovery Charge (up to $1.25), a gross receipts surcharge, an Administrative Fee, and other government assessments which are not government-required charges, including without limitation a Property Tax Allotment surcharge of $0.20-$0.45 per CRU's assigned number. Coverage and service not available everywhere. Other restrictions apply and may result in service termination. Terms and options subject to change, and may be discontinued or terminated at any time without notice. </p>

					</li>
				</ul>
			</div>
	</cfif>
	<!---VZW Legal---> <!--- Don't display for Pagemaster --->
	<cfif listFindNoCase(request.lstAvailableCarrierIds, 42) and not findNoCase( 'PG', textDisplayRenderer.getGersCustomerIdPreFix()) >
		<div style="margin-top: 25px; width: 675px">
				<ul>
					<li style="list-style:none outside;">
						<p><b>Device Payment Agreement:</b> 24 interest-free installments with 100% pay off to upgrade - customers can pay off their 
						installment plan at any time and upgrade at any time! Copyright &copy;2015 Verizon Wireless. All rights reserved. 
						All Verizon logos and names are trademarks and property of Verizon Wireless. For more information on coverage, 
						<a href="http://verizonwireless.com/4GLTE" target="_blank">verizonwireless.com/4GLTE</a>. LTE is a trademark of ETSI.</p>
					</li>
				</ul>
			</div>
	</cfif>
	<!---T-MOBILE Legal--->
	<cfif listFindNoCase(request.lstAvailableCarrierIds, 128)>
		<div style="margin-top: 25px; width: 675px">
				<ul>
					<li style="list-style:none outside;">
						<p>	IF YOU CANCEL WIRELESS SERVICE, REMAINING BALANCE ON PHONE BECOMES DUE. T-Mobile Devices: Down + 24 monthly payments on qualified devices. 0% APR O.A.C. for well-qualified buyers. Qualifying service required. Tax and fees additional.</p>
	
					</li>
				</ul>
			</div>
	</cfif>

	
	<cfif listFindNoCase(request.lstAvailableCarrierIds, 299) and not findNoCase( 'PG', textDisplayRenderer.getGersCustomerIdPreFix()) >
		<div style="margin-top: 25px; width: 675px">
				<ul>
					<li style="list-style:none outside;">
						<p>
							
							&dagger;Pricing for well-qualified buyer. Req. Installment agmt, 0% APR &amp; qualifying service plan. Credit check req. Other customers may qualify for different down payment &amp; monthly payment terms.
							</p>
	
					</li>
				</ul>
			</div>
	</cfif>

		

		<p align="right" style="text-align: right"><a href="#top">Return to Top</a></p>
	</cfsavecontent>

	<cfreturn trim(local.html) />
</cffunction>


<cffunction name="browseSearchResults" access="public" output="false" returntype="string">
	<cfargument name="data" type="query" required="true" />
	<cfargument name="bindAjaxOnLoad" type="boolean" default="true" />

	<cfset var local = structNew() />
	<cfset local.c = '' />

	<cfsavecontent variable="local.c">
		<cfoutput>#this.browseProductsResults(productData = arguments.data, bindAjaxOnLoad = arguments.bindAjaxOnLoad, DisplayNoInventoryItems = true)#</cfoutput>
	</cfsavecontent>

	<cfreturn trim(local.c) />
</cffunction>


<cffunction name="renderProductPrices" access="public" returntype="string" output="false">
	<cfargument name="ProductId" type="numeric" required="true" />
	<cfargument name="CarrierId" type="numeric" required="true" />
	<cfargument name="PriceBlock" type="cfc.model.catalog.PriceBlock" required="true" />
	<cfargument name="IsNewPriceMap" type="boolean" default="false" required="false" />
	<cfargument name="IsUpgradePriceMap" type="boolean" default="false" required="false" />
	<cfargument name="IsAddalinePriceMap" type="boolean" default="false" required="true" />
	<cfargument name="AvailableQty" type="numeric" required="true" />
	<cfargument name="bProductCompatible" type="boolean" required="false" default="true" />
	<cfargument name="bPrePaid" type="boolean" required="false" default="false" />
	<cfargument name="planType" type="string" required="false" default="" />
	<cfargument name="IsSmartPhone" type="boolean" default="false" required="false" />
	<cfargument name="IsNoContractRestricted" type="boolean" default="false" required="false" />
	<cfargument name="IsNewActivationRestricted" type="boolean" default="false" required="false" />
	<cfargument name="IsUpgradeActivationRestricted" type="boolean" default="false" required="false" />
	<cfargument name="IsAddALineActivationRestricted" type="boolean" default="false" required="false" />
	<cfargument name="IsDetailsPageView" type="boolean" default="false" required="false" />
	<cfargument name="HasFreeKitBundle" type="boolean" default="false" required="false" />
	<cfargument name="IsTMORedirect" type="boolean" default="false" required="false" />
	<cfargument name="TMOBuyURL" type="string" default="" required="false" />
	<cfargument name="metakeywords" type="string" required="false" />
	<cfargument name="IsAvailableInWarehouse" type="boolean" default="false" required="false" />
	<cfargument name="IsProductCompatibleWithPlan" type="boolean" required="true" />
	<cfargument name="sesTitle" type="string" required="false" default="" />

	<cfset var local = {} />
	<cfset var ActivePriceView = 'new' />
	<cfset local.runningTotal = 0 />

	<cfparam name="request.cart.numLines" default="#application.model.cartHelper.getNumberOfLines()#" />

	<cfscript>
		//Logic for which Activation price to display
		if( session.cart.getActivationType() neq '' )
		{
			//Add-a-Line pricing
			if ( session.cart.hasCart() && session.cart.getHasFamilyPlan() && session.cart.getActivationType() neq 'upgrade' )
			{
				if ( ListFind( "42,299", session.cart.getCarrierId() ) )
				{
					if (session.cart.getCurrentLine() GTE 2)
					{
						ActivePriceView = 'addaline';
					}
				}
				else if ( ListFind( "109,128", session.cart.getCarrierId() ) )
				{
					if (session.cart.getCurrentLine() GTE 3)
					{
						ActivePriceView = 'addaline';
					}
				}
			}
			else
			{
				ActivePriceView = session.cart.getActivationType();
			}
		}
		else
		{
			ActivePriceView = productFilter.getActivationPrice();
		}
		
		local.renderAddToCartArgs = {
			ProductClass = variables.ProductClass
			, CarrierId = arguments.CarrierId
			, ProductId = arguments.ProductId
			, AvailableQty = arguments.AvailableQty
			, IsSmartPhone = arguments.IsSmartPhone
			, IsNoContractRestricted = arguments.IsNoContractRestricted
			, IsNewActivationRestricted = arguments.IsNewActivationRestricted
			, IsUpgradeActivationRestricted = arguments.IsUpgradeActivationRestricted
			, IsAddALineActivationRestricted = arguments.IsAddALineActivationRestricted
			, IsTMORedirect = arguments.IsTMORedirect
			, TMOBuyURL = arguments.TMOBuyURL
			, IsAvailableInWarehouse = arguments.IsAvailableInWarehouse
			, IsProductCompatibleWithPlan = arguments.IsProductCompatibleWithPlan
		};
	</cfscript>

	<!--- Modified on 10/30/2014 by Denard Springle (denard.springle@cfwebtools.com) --->
	<!--- Track #: 6800 - Tmo - Show pricing for Upgrade my device shows bad pricing. [ Refactored code to use common variables for distinct activation types ] --->

	<!--- Struct to hold common variables --->
	<cfset local.pB = {} />

	<!--- check if this is a 'new' price being displayed --->
	<cfif ActivePriceView eq 'new'>
		<cfset local.pB.priceModifier = arguments.PriceBlock.getNewPrice() />
		<cfset local.pB.hasRebate = arguments.PriceBlock.hasNewPriceRebate() />
		<cfset local.pB.rebateAmount = arguments.PriceBlock.getNewRebateAmount() />
		<cfset local.pB.savingsTotal = arguments.PriceBlock.getSavingsTotal('New') />
		<cfset local.pB.disclaimer = '*With 2-year contract' />
		<cfset local.renderAddToCartArgs.PriceType = 'new' />

	<!--- otherwise, check if this in an 'upgrade' price being displayed --->
	<cfelseif ActivePriceView eq 'upgrade'>
		<cfset local.pB.priceModifier = arguments.PriceBlock.getUpgradePrice() />
		<cfset local.pB.hasRebate = arguments.PriceBlock.hasUpgradePriceRebate() />
		<cfset local.pB.rebateAmount = arguments.PriceBlock.getUpgradeRebateAmount() />
		<cfset local.pB.savingsTotal = arguments.PriceBlock.getSavingsTotal('Upgrade') />
		<cfset local.pB.disclaimer = '*With 2-year contract extension' />
		<cfset local.renderAddToCartArgs.PriceType = 'upgrade' />

	<!--- otherwise, check if this in an 'addaline' price being displayed --->
	<cfelseif ActivePriceView eq 'addaline'>
		<cfset local.pB.priceModifier = arguments.PriceBlock.getAddALinePrice() />
		<cfset local.pB.hasRebate = arguments.PriceBlock.hasAddalinePriceRebate() />
		<cfset local.pB.rebateAmount = arguments.PriceBlock.getAddALineRebateAmount() />
		<cfset local.pB.savingsTotal = arguments.PriceBlock.getSavingsTotal('Addaline') />
		<cfset local.pB.disclaimer = '*With 2-year contract' />
		<cfset local.renderAddToCartArgs.PriceType = 'addaline' />

	<!--- otherwise, check if this in an 'nocontract' price being displayed --->
	<cfelseif ActivePriceView eq 'nocontract'>
		<cfset local.pB.priceModifier = 0 />
		<cfset local.pB.hasRebate = 0 />
		<cfset local.pB.rebateAmount = 0 />
		<cfset local.pB.savingsTotal = arguments.PriceBlock.getRetailPrice() />
		<cfset local.pB.disclaimer = '*No contract required' />
		<cfset local.renderAddToCartArgs.PriceType = 'nocontract' />

	<!--- otherwise, this must be a prepaid --->
	<cfelse>
		<cfset local.pB.priceModifier = arguments.PriceBlock.getNewPrice() />
		<cfset local.pB.hasRebate = 0 />
		<cfset local.pB.rebateAmount = 0 />
		<cfset local.pB.savingsTotal = arguments.PriceBlock.getSavingsTotal('New') />
		<cfset local.pB.disclaimer = '' />
		<cfset local.renderAddToCartArgs.PriceType = 'new' />
	</cfif>

	<!--- Modified on 11/05/2014 by Denard Springle (denard.springle@cfwebtools.com) --->
	<!--- Track #: N/A - Modify product view for TMO devices in COSTCO channel [ Display 'Price' vs. 'Retail Price' for TMO devices ] --->

	<!--- check if TMO information is beind displayed and this is a TMO device --->
	<cfif arguments.isTMORedirect>
		<!--- it is and this is a TMO device, display 'Price' --->
		<cfset local.priceTitle = 'Price' />
	<!--- otherwise --->
	<cfelse>
		<!--- this is not a TMO device, display 'Retail Price' --->
		<cfset local.priceTitle = application.wirebox.getInstance("TextDisplayRenderer").getPriceLabelText() />
	</cfif>

	<!--- END EDITS on 11/05/2014 by Denard Springle --->

	<cfsavecontent variable="local.returnHTML">
		<cfoutput>

		<div class="prodPrice #lcase(variables.productClass)#">

			<div class="priceblock-container">
				<div class="logo-container <cfif CarrierId eq 109>logo-att<cfelseif CarrierId eq 128>logo-tmo<cfelseif CarrierId eq 42>logo-verizon<cfelseif CarrierId eq 299>logo-sprint<cfelseif CarrierId eq 81>logo-boost</cfif>">

<!--- TEMPORARY DISABLE 
					<!--- check that this is not prepaid, is the details view and an activation type has not been chosen --->
					<cfif variables.productClass neq 'prepaid' && IsDetailsPageView && session.cart.getActivationType() eq ''>
						<div class="activation-container">
							<select id="ActionPriceOptions" name="ActionPriceOptions" onchange="ToggleActivationPrice();">
								<option value="New" <cfif ActivePriceView eq 'new'>selected="selected"</cfif>>New account *</option>
								<option value="Upgrade" <cfif ActivePriceView eq 'upgrade'>selected="selected"</cfif>>Upgrade my device *</option>
								<option value="Addaline" <cfif ActivePriceView eq 'addaline'>selected="selected"</cfif>>Add a line *</option>
								<cfif channelConfig.getOfferNoContractDevices() and ListContainsNoCase(channelConfig.getNoContractDevices(),variables.productTag)>
									<option value="NoContract" <cfif ActivePriceView eq 'NoContract'>selected="selected"</cfif>>No Contract *</option>
								</cfif>
							</select>
						</div>
						<!--- Temporarily Hide from TMobile. Bug 6279. Scott Hamilton 12/18/13 --->
						<cfif arguments.CarrierId neq 128>
							<div id="upgrade-checker-container" style="display: none;">
								<a href="/index.cfm/go/shop/do/upgrade-checker-widget/carrierId/#arguments.CarrierId#" class="fancy-box" data-fancybox-type="iframe">Check Upgrade Eligibility</a>
							</div>
						</cfif>
					</cfif>
TEMPORARY DISABLE --->
				</div>				

				<!--- display price block container --->
				<div id="#local.renderAddToCartArgs.PriceType#-activation-container" <!---<cfif IsDetailsPageView>style="display: none;"</cfif>--->>
					<!--- check if using the new price map layout --->
					<cfif arguments.IsNewPriceMap>
						<!--- we are, use new price map layout --->
						<div class="price-container">
							<table class="price-table">
								<tr>
									<td>#local.priceTitle#</td>
									<td class="price-col"><span class="strike">#DollarFormat(arguments.PriceBlock.getRetailPrice())#</span></td>
								</tr>
							</table>
						</div>
						<div class="summary-container">
							<div class="map-price-container">
								<!--- temp for 6.5 release --->
								<cfif channelConfig.getDirectToRedesignDetailsPage()>
									<a href="/#arguments.ProductId#/#arguments.sesTitle#">Click to show price</a>
								<cfelse>
									<a href="/index.cfm/go/shop/do/PhoneDetails/productId/#arguments.ProductId#">Click to show price</a>
								</cfif>
							</div>
							#local.pB.disclaimer# 
						</div>

					<!--- otherwise --->
					<cfelse>								
						<!--- we're not, use standard price layout --->
						<div class="price-container">						
							<table class="price-table">									
								<tr>
									<td>#local.priceTitle#</td>
									<td class="price-col">#DollarFormat(arguments.PriceBlock.getRetailPrice())#</td>
								</tr>

						<!--- check we're not showing t-mobile affiliate  *or no contract*  devices --->
						<cfif NOT arguments.IsTMORedirect>	
							<!--- we aren't, use standard layout --->
							<!--- check if we have savings to present --->
							<cfif local.pb.priceModifier && ( arguments.PriceBlock.getRetailPrice() - local.pb.priceModifier )>
								<!--- we do, display the savings --->
								<tr>
									<td>
										Savings
										<cfif arguments.PriceBlock.getRetailPrice()>
											<span class="savings">(#Fix( ((arguments.PriceBlock.getRetailPrice() - local.pb.priceModifier)/arguments.PriceBlock.getRetailPrice()) * 100 )#%)</span>
										</cfif>
									</td>
									<td class="price-col"><span class="savings">(#DollarFormat(arguments.PriceBlock.getRetailPrice() - local.pb.priceModifier)#)</span></td>
								</tr>											
							</cfif>
						
							<!--- check if we have a rebate to present --->
							<cfif local.pB.hasRebate && local.pB.rebateAmount gt 0>
								<!--- we do, display the rebate --->
								<tr>
									<td>Mail-in Rebate</td>
									<td class="price-col"><span class="savings">(#DollarFormat(local.pB.rebateAmount)#)</span></td>
								</tr>
							</cfif>

							<!--- check if this is the details page view --->
							<cfif IsDetailsPageView>
								<!--- it is, show additional details --->
								<cfif arguments.HasFreeKitBundle && channelConfig.getDisplayFreeKit()>
									<tr>
										<td>Accessory Bundle</td>
										<td class="price-col">Free</td>
									</tr>
								</cfif>
								<cfif listFind(channelconfig.getActivationFeeWavedByCarrier(),arguments.CarrierId)>
									<tr>
										<td>New Activation</td>
										<td class="price-col">Free</td>
									</tr>
								</cfif>
								<tr>
									<td>Shipping</td>
									<td class="price-col">Free</td>
								</tr>
							</cfif>

							</table>
						</div>

						<!--- show summary container --->
						<div class="summary-container">
							<div class="final-price-container"><cfif local.pB.savingsTotal lt .01>FREE<cfelse>#DollarFormat(local.pB.savingsTotal)#<cfif request.config.debugInventoryData>N</cfif></cfif></div><br />
							#local.pB.disclaimer#
						</div>

						<!--- otherwise (isTMORedirect = true) --->
						<cfelse>
							<!--- we are showing t-mobile affiliate phones, use layout for t-mobile affiliate phones  --->
							</table>
						</div>
						<div class="summary-container">
						<div align="center">
							<!--- check if this phone has monthly payment options --->
							<cfif arguments.PriceBlock.getMonthlyPayment() gt 0>
								<!--- it does, display monthly payments --->
								<span class="tmo-price-container">#DollarFormat(arguments.PriceBlock.getDownPayment())#</span> up front<br>+ #DollarFormat(arguments.PriceBlock.getMonthlyPayment())#/mo x 24 mos</div><br>
						
								0% APR On Approved Credit for well-qualified buyer.
							<!--- otherwise --->
							<cfelse>
								<!--- it doesn't, display full retail price --->
								<span class="tmo-price-container">#DollarFormat(arguments.PriceBlock.getRetailPrice())#</span></div>
							</cfif>
						</div>
						<!--- end checking we're not showing t-mobile affiliate devices --->
						</cfif>
					<!--- end checking if using the new price map layout --->
					</cfif>

					<!--- Modified on 10/31/2014 by Denard Springle (denard.springle@cfwebtools.com) --->
					<!--- Track #: 6960 - TMO Affiliate - AAFES: Users can add phone to cart from Compare [ Suppress add to cart button in details view for TMO ] --->

					<!--- check if we're *not* in the details view OR we *are* in the detail view and *not* showing a TMO device --->
					<cfif NOT IsDetailsPageView OR ( IsDetailsPageView AND arguments.CarrierId neq 128 )>
						<!--- render button --->
						<div class="button-container">
							<cfset local.thisAddToCartButton = renderAddToCartButton( argumentCollection = local.renderAddToCartArgs ) />
							#trim(local.thisAddToCartButton)#
						</div>						
					</cfif> 
					<!--- END EDITS on 10/31/2014 by Denard Springle --->
					</div>

				</div>
		
			</div>

		</cfoutput>
	</cfsavecontent>
	<!--- END EDITS on 10/30/2014 by Denard Springle --->

	<cfreturn trim(local.returnHTML) />
</cffunction>


<cffunction name="productDetails" access="public" returntype="string" output="false">
	<cfargument name="productData" type="query" required="true" />
	<cfargument name="featuresData" type="query" required="true" />
	<cfargument name="freeAccessories" type="query" required="true" />
	<cfargument name="qVideos" type="query" required="true" />
	<cfargument name="activeTab" type="string" required="false" default="features" />

	<cfset var local = {} />

	<cfset local.filterSelections = evaluate(variables.filterSelections) />
	<cfset local.productClass = variables.productClass />
	<cfset local.planType = 'new' />

	<cfif session.cart.hasCart() AND session.cart.getHasFamilyPlan()>
		<cfif ListFind( "42,109,299", session.cart.getCarrierId() )>
			<cfif session.cart.getCurrentLine() GTE 2>
				<cfset local.planType = 'addaline' />
			</cfif>
		<cfelseif session.cart.getCarrierId() EQ 128>
			<cfif session.cart.getCurrentLine() GTE 3>
				<cfset local.planType = 'addaline' />
			</cfif>
		</cfif>
	<cfelse>
		<cfif listFind(productFilter.getUserSelectedFilterValuesByFieldName(fieldName = 'filterOptions'), '32')>
			<cfset local.planType = 'new' />
		<cfelseif listFind(productFilter.getUserSelectedFilterValuesByFieldName(fieldName = 'filterOptions'), '33')>
			<cfset local.planType = 'upgrade' />
		<cfelseif listFind(productFilter.getUserSelectedFilterValuesByFieldName(fieldName = 'filterOptions'), '34')>
			<cfset local.planType = 'addaline' />
		<cfelseif StructKeyExists(request.p, 'activationtype')>
			<cfif request.p.activationtype eq 'new'>
				<cfset productFilter.setActivationPrice( 'new' ) />
			<cfelseif request.p.activationtype eq 'upgrade'>
				<cfset productFilter.setActivationPrice( 'upgrade' ) />
			</cfif>
		</cfif>
	</cfif>

	<cfset local.typeLabel = variables.label />

	<cfif arguments.freeAccessories.recordCount>
		<cfset local.stcFeeAccessoryPrimaryImages = application.model.imageManager.getPrimaryImagesForProducts(valueList(arguments.freeAccessories.productGuid)) />
	</cfif>

	<cfsavecontent variable="local.productHTML">
		<cfoutput>			
			<link rel="stylesheet" href="#assetPaths.common#scripts/bxslider/bx_styles/bx_styles.css" type="text/css" media="screen" />
			<script type="text/javascript" language="javascript" src="#assetPaths.common#scripts/details.js"></script>
			<script type="text/javascript" language="javascript" src="#assetPaths.common#scripts/libs/jquery.bxSlider.min.js"></script>
			<script type="text/javascript" language="javascript">
				var priceTabClass = '#trim(local.planType)#';

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

		<cfset request.lstAvailableProductIds = valueList(arguments.productData.productId) />

		<cfif session.cart.hasCart() and application.model.cartHelper.getLineRateplanProductId(line = session.cart.getCurrentLine())>
			<cfset request.lstAvailableProductIds = application.model[variables.productClass].getProductIdsByPlanId(planId = application.model.cartHelper.getLineRateplanProductId(line = session.cart.getCurrentLine())) />
		</cfif>

		<cfset local.bProductCompatible = false />

		<cfif listFindNoCase(request.lstAvailableProductIds, arguments.productData.productId[arguments.productData.currentRow])>
			<cfset local.bProductCompatible = true />
		</cfif>

		<cfscript>
			local.priceBlock = CreateObject( 'component', 'cfc.model.catalog.PriceBlock' ).init();
			local.priceBlock.setRetailPrice( arguments.productData.price_retail[arguments.productData.currentRow] );
        	local.priceBlock.setNewPrice( arguments.productData.price_new[arguments.productData.currentRow] );
        	local.priceBlock.setUpgradePrice( arguments.productData.price_upgrade[arguments.productData.currentRow] );
        	local.priceBlock.setAddALinePrice( arguments.productData.price_addaline[arguments.productData.currentRow] );
			local.priceBlock.setNewPriceAfterRebate( arguments.productData.NewPriceAfterRebate[arguments.productData.currentRow] );
			local.priceBlock.setUpgradePriceAfterRebate( arguments.productData.UpgradePriceAfterRebate[arguments.productData.currentRow] );
			local.priceBlock.setAddALinePriceAfterRebate( arguments.productData.AddALinePriceAfterRebate[arguments.productData.currentRow] );
			
			local.priceArgs = {};
			local.priceArgs.productID = arguments.productData.productID[arguments.productData.currentRow];
			local.priceArgs.carrierID = arguments.productData.carrierID[arguments.productData.currentRow];
			local.priceArgs.PriceBlock = local.priceBlock;
			local.priceArgs.bProductCompatible = local.bProductCompatible;
			local.priceArgs.bPrePaid = arguments.productData.prepaid[arguments.productData.currentRow];
			local.priceArgs.AvailableQty = arguments.productData.qtyOnHand[arguments.productData.currentRow];
			local.priceArgs.IsNoContractRestricted = arguments.productData.IsNoContractRestricted[arguments.productData.currentRow];
			local.priceArgs.IsNewActivationRestricted = arguments.productData.IsNewActivationRestricted[arguments.productData.currentRow];
			local.priceArgs.IsUpgradeActivationRestricted = arguments.productData.IsUpgradeActivationRestricted[arguments.productData.currentRow];
			local.priceArgs.IsAddALineActivationRestricted = arguments.productData.IsAddALineActivationRestricted[arguments.productData.currentRow];
			local.priceArgs.IsDetailsPageView = true;
			local.priceArgs.HasFreeKitBundle = arguments.productData.bFreeAccessory[arguments.productData.currentRow];
			local.priceArgs.IsAvailableInWarehouse = arguments.productData.IsAvailableInWarehouse[arguments.productData.currentRow];
			local.priceArgs.IsProductCompatibleWithPlan = local.bProductCompatible;
			local.priceArgs.sesTitle = stringUtil.friendlyUrl(arguments.productData.DetailTitle[arguments.productData.currentRow]);
			local.pricingHTML = renderProductPrices( argumentCollection = local.priceArgs );
		</cfscript>

		<cfoutput query="arguments.productData">
			<cfsavecontent variable="local.popupWindow">
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
			<cfhtmlhead text="#trim(local.popupWindow)#" />

			<div class="details-sidebar">
				<cfset local.imagesHTML = application.view.product.displayImages(arguments.productData.deviceGuid, arguments.productData.summaryTitle, arguments.productData.BadgeType) />
				<div>#trim(local.imagesHTML)#</div>
				<div style="clear:both;"></div>
				<!--- Commenting out until a decision is made on what to do long term with kit images
				<cfif channelConfig.getDisplayFreeKit() && arguments.productData.bFreeAccessory[arguments.productData.currentRow]>
					<div style="border-top: 1px dashed ##cfcfcf; margin-top: 20px; padding-top: 20px; text-align:center;">
						<a href="#assetPaths.common#images/onlinebenefit/costcoValue_version_4_1.jpg" rel="lightbox" title="#channelConfig.getDisplayName()# Online Value">
	         				<img src="#assetPaths.channel#images/memberValue.gif" border="0" alt="#channelConfig.getDisplayName()# Online Value: Free Accessories, Shipping & Activation" title="#channelConfig.getDisplayName()# Online Value: Free Accessories, Shipping & Activation" />
						</a>
						<div style="font-size: 14px; margin-left: 35px; text-align:left;">
							<span style="color:red; font-weight:bold;">FREE</span> Shipping <br />
							<span style="color:red; font-weight:bold;">FREE</span> Accessory Bundle <br />
						</div>
					</div>
				</cfif>
				<div style="clear:both;"></div>
				<!--- Free Accessory Kit --->
				<cfif channelConfig.getDisplayFreeKit() && arguments.freeAccessories.recordCount>
					<div style="border-top: 0px dashed ##cfcfcf; margin-top: 10px; padding-top: 10px;">
						<cfset local.stcFeeAccessoryPrimaryImages = application.model.imageManager.getPrimaryImagesForProducts(valueList(arguments.freeAccessories.productGuid)) />
						<div class="prodDetail-banner-capsule" style="margin-left: auto; margin-right: auto; width:165px;">
							<span style="color:red; font-weight:bold;">FREE</span> Accessory Bundle <br />
						</div>
						<cfset imageThumbnailHTML = application.view.product.displayKitImages(valueList(arguments.freeAccessories.productGuid), arguments.freeAccessories.DetailTitle) />
						<div style="clear:both;"></div>
						<div>#trim(imageThumbnailHTML)#</div>
					</div>
				</cfif>
				--->
				<div style="clear:both;"></div>
				<!--- Videos--->
				<cfif arguments.qVideos.RecordCount>
					<div style="border-top: 1px dashed ##cfcfcf; margin-top: 20px; padding-top: 20px; text-align:center; padding-left: 35px;">
						<ul id="VideoSlider">
							<cfloop query="arguments.qVideos">
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
			<div class="main #trim(local.planType)# phones" id="prodList">
				<div class="phones-prodDetail">
					<cfif request.config.debugInventoryData>
						<div id="inventoryDebugIcon_#arguments.productData.productId[arguments.productData.currentRow]#" class="inventoryDebugIcon" onmouseover="revealInventoryDebugInfo(#arguments.productData.productId[arguments.productData.currentRow]#,this);document.body.style.cursor='pointer';"></div>
						<div id="inventoryDebugInfo_#arguments.productData.productId[arguments.productData.currentRow]#" class="inventoryDebugInfo" onmouseout="hideInventoryDebugInfo(this);document.body.style.cursor='';">
							<div style="float:left;">GERS SKU:</div><div style="float:right;">#arguments.productData.GersSku[arguments.productData.currentRow]#</div><br/>
							<div style="float:left;">Qty On-Hand:</div><div style="float:right;">#arguments.productData.QtyOnHand[arguments.productData.currentRow]#</div><br/>
							<div style="float:left;">UPC Code:</div><div style="float:right;">#arguments.productData.UPC[arguments.productData.currentRow]#</div><br/>
							<div style="float:left;">Device Type:</div><div style="float:right;">#arguments.productData.DeviceType[arguments.productData.currentRow]#</div><br/>
						</div>
					</cfif>
					<h1>#trim(arguments.productData.detailTitle[arguments.productData.currentRow])#</h1>
					<cfif allocation.loadBySku(#arguments.productData.gersSku[arguments.productData.currentRow]#)>
						<div class="allocationMsg">
							<cfswitch expression="#allocation.getInventoryTypeDescription()#">
								<cfcase value="Pre-Sale">
									<!---Pre-Sale: expected release date #dateformat(allocation.getReleaseDate(),"mm/dd/yyyy")#--->
									#allocation.getDetailMessage()#
								</cfcase>
								<cfcase value="Backorder">														
									#allocation.getDetailMessage()#
								</cfcase>
							</cfswitch>
						</div>
					</cfif>

					<span style="font-size: 10pt; font-weight: bold; color: maroon">
						Available: 
						<cfif arguments.productData.IsAvailableInWarehouse[arguments.productData.currentRow] && arguments.productData.IsAvailableOnline[arguments.productData.currentRow]>
							Online + #textDisplayRenderer.getStoreAliasName()#
						<cfelseif arguments.productData.IsAvailableOnline[arguments.productData.currentRow]>
							Online Only
						<cfelseif arguments.productData.IsAvailableInWarehouse[arguments.productData.currentRow]>
							#textDisplayRenderer.getStoreAliasName()# Only
						</cfif>
					</span>
					<br /><br />

					<div class="prodDesc">
						<div class="details-price-container">
							#trim(local.pricingHTML)#
						</div>

						#application.view.product.ReplaceRebate( '<span class="rebate-callout">%CarrierRebate1% %CarrierRebate2% %CarrierSkuRebate1% %CarrierSkuRebate2%</span>', arguments.productData.carrierId[arguments.productData.currentRow], arguments.productData.gersSku[arguments.productData.currentRow] )#
						#arguments.productData.detailDescription[arguments.productData.currentRow]#
					</div>
				</div>
				<div id="prodSpecs" class="prodSpecs" style="width: 540px">
					<ul class="tabs">
						<li<cfif arguments.activeTab is 'features'> class="active"</cfif>>
							<a href="##" onclick="return false;" class="tab" name="features"><span>Features</span></a>
							<div class="tabContent" style="overflow-x: hidden; overflow-y: auto; width: 560px;">
								<h2>Device features for the #trim(arguments.productData.detailTitle[arguments.productData.currentRow])#</h2>
								<cftry>
									<cfset local.featurePropertiesDisplay = application.view.propertyManager.getPropertyTableTab(arguments.featuresData) />
									#trim(local.featurePropertiesDisplay)#
									<cfcatch type="any">

									</cfcatch>
								</cftry>
							</div>
						</li>
						<li<cfif arguments.activeTab is 'specifications'> class="active"</cfif>>
							<a id="spec-tab" href="##" onclick="return false;" class="tab" data-productId="#arguments.productData.productId#" name="specifications"><span>Specifications</span></a>
							<div class="tabContent" style="overflow-x: hidden; overflow-y: auto; width: 560px;">
								<h2>Product Specs for the #trim(arguments.productData.detailTitle[arguments.productData.currentRow])#</h2>
								<div id="spec-loader"><img src="/assets/common/images/upgradechecker/ajax-loader.gif" /></div>
								<div id="spec-container"></div>
							</div>
						</li>
						
						<li<cfif arguments.activeTab is 'relatedAccessories'> class="active"</cfif>>
							<a id="accessory-tab" href="##" onclick="return false;" class="tab" data-productId="#arguments.productData.productId#" name="relatedAccessories"><span>Related Accessories</span></a>
							<div class="tabContent" style="overflow-x: hidden; overflow-y: auto; width: 560px;">
								<h2>Compatible Accessories for the #trim(arguments.productData.detailTitle[arguments.productData.currentRow])#</h2>
								<div id="accessory-loader"><img src="/assets/common/images/upgradechecker/ajax-loader.gif" /></div>
								<div id="accessory-container"></div>
							</div>
						</li>
					</ul>
				</div>
			</cfoutput>
			<p align="right" style="text-align: right"><a href="#top">Return to Top</a></p>
		</div>
	</cfsavecontent>

	<!--- Set up HTML Metadata --->
	<cfset request.title = HTMLEditFormat( reReplaceNoCase(trim(arguments.productData.pageTitle[arguments.productData.currentRow]), '<[^>]*>', '', 'ALL') ) & ' | ' & channelConfig.getDisplayName() />
	<cfif Len(arguments.productData.MetaDescription[arguments.productData.currentRow])>
		<cfset request.MetaDescription = HTMLEditFormat( reReplaceNoCase(trim(arguments.productData.MetaDescription[arguments.productData.currentRow]), '<[^>]*>', '', 'ALL') ) />
	</cfif>
	<cfif Len(arguments.productData.MetaKeywords[arguments.productData.currentRow])>
		<cfset request.MetaKeywords = HTMLEditFormat( reReplaceNoCase(trim(arguments.productData.MetaKeywords[arguments.productData.currentRow]), '<[^>]*>', '', 'ALL') ) />
	</cfif>

	<cfreturn trim(local.productHTML) />
</cffunction>


<cffunction name="compareProducts" access="public" returntype="string" output="false">
	<cfargument name="productData" type="query" required="true" />
	<cfargument name="productCompareData" type="query" required="true" />

	<cfset var local = structNew() />

	<cfset local.filterSelections = evaluate(variables.filterSelections) />
	<cfset local.compareLabel = variables.labelPlural />
	<cfset local.detailMethod = variables.productClass & 'Details' />

	<cfparam name="request.p.printFormat" type="boolean" default="false" />

	<cfset local.stcPrimaryImages = application.model.imageManager.getPrimaryImagesForProducts(valueList(arguments.productData.deviceGuid)) />
	<cfset request.lstAvailableProductIds = valueList(arguments.productData.productId) />

	<cfif session.cart.hasCart() and application.model.cartHelper.getLineRateplanProductId(line = session.cart.getCurrentLine())>
		<cfset request.lstAvailableProductIds = application.model[variables.productClass].getProductIdsByPlanId(planId = application.model.cartHelper.getLineRateplanProductId(line = session.cart.getCurrentLine())) />
	</cfif>

	<cfsavecontent variable="local.productHTML">

		<cfsavecontent variable="jsHead">
			<script>
				function expandIt(which)	{
					var panel = document.getElementById(which);
					var txt = document.getElementById('expandText_' + which);
					var theImg = document.getElementById('expandImage_' + which);

					if(panel.style.display == 'none')	{
						panel.style.display = '';
						txt.innerHTML = 'Collapse';
						theImg.src = '<cfoutput>#assetPaths.common#</cfoutput>images/ui/collapse.png';
					} else {
						panel.style.display = 'none';
						txt.innerHTML = 'Expand';
						theImg.src = '<cfoutput>#assetPaths.common#</cfoutput>images/ui/expand.png';
					}
				}
				window.onerror = hide;

				function hide()	{
					return true;
				}
			</script>
		</cfsavecontent>
		<cfhtmlhead text="#trim(variables.jsHead)#" />

		<cfoutput>
			<h1>Compare #trim(local.compareLabel)#</h1>

			<table cellpadding="0" cellspacing="0" class="compare">
				<thead>
					<cfif not request.p.printFormat>
						<tr>
							<td colspan="#(arguments.productData.recordCount + 1)#" align="right" style="border: 0px">
								<div align="right" class="noPrint">
									<img src="#assetPaths.common#images/ui/1295276066_print.png" align="texttop" />
									<a href="#cgi.script_name&cgi.path_info#/printFormat/true" target="_blank">Print this Page</a>
									<br /><br />
								</div>
							</td>
						</tr>
					</cfif>
					<tr>
						<th class="emptyCell" style="border-bottom: 0px">&nbsp;</th>
						<cfloop query="arguments.productData">
							<th style="color: ##000000; font-size: 8pt" width="220" valign="top">
								<cfif arguments.productData.carrierID eq 109>
									<img src="#assetPaths.common#images/carrierLogos/att_175.gif" height="30" alt="AT&T" /><br />
								<cfelseif arguments.productData.carrierID eq 128>
									<img src="#assetPaths.common#images/carrierLogos/tmobile_175.gif" height="30" alt="T-Mobile" /><br />
								<cfelseif arguments.productData.carrierID eq 42>
									<img src="#assetPaths.common#images/carrierLogos/verizon_175.gif" height="30" alt="Verizon" /><br />
								<cfelseif arguments.productData.carrierID eq 299>
									<img src="#assetPaths.common#images/carrierLogos/sprint_175.gif" height="30" alt="Sprint" /><br />
								<cfelseif arguments.productData.carrierID eq 81>
									<img src="#assetPaths.common#images/carrierLogos/boost_logo_175.png" height="30" alt="Boost" /><br />									
								</cfif>

								<cfif structKeyExists(local.stcPrimaryImages, arguments.productData.deviceGuid[arguments.productData.currentRow])>
									<img src="#application.view.imageManager.displayImage(imageGuid = local.stcPrimaryImages[arguments.productData.deviceGuid[arguments.productData.currentRow]], height=150, width=0)#" height="150" alt="#htmlEditFormat(arguments.productData.summaryTitle[arguments.productData.currentRow])#" />
								<cfelse>
									<img src="#assetPaths.common#images/Catalog/NoImage.jpg" height="150" alt="#htmlEditFormat(arguments.productData.summaryTitle[arguments.productData.currentRow])#" />
								</cfif>

								<div class="compareDeviceTitle">
									<h4><a href="/index.cfm/go/shop/do/#local.detailMethod#/productId/#arguments.productData.productId[arguments.productData.currentRow]#" style="font-size: 8pt">#trim(arguments.productData.summaryTitle[arguments.productData.currentRow])#</a></h4>
								</div>
							</th>
						</cfloop>
					</tr>
				</thead>
				<tbody>
					<tr class="spacer">
						<td class="emptyCell">&nbsp;</td>
						<cfloop query="arguments.productData">
							<td>&nbsp;</td>
						</cfloop>
					</tr>
					<tr class="control">
						<td class="dataPoint" style="color: ##000000; font-weight: bold; text-align: left; font-size: 8pt; background-color: ##8fafc6">Purchase Info</td>
						<cfloop query="arguments.productData">
							<cfif not request.p.printFormat and structKeyExists(local, 'filterSelections') and structKeyExists(local.filterSelections, 'compareIDs')>
								<td style="background-color: ##8fafc6">
									<img src="#assetPaths.common#images/ui/1295275580_delete.png" align="texttop" />&nbsp;<a href="/index.cfm/go/#request.p.go#/do/#request.p.do#/?formHidden_activationType=#request.p.formHidden_activationType#&#variables.filterType#.submit=1&filter.compareIDs=#local.filterSelections.compareIDs#&removeID=#arguments.productData.productID[arguments.productData.currentRow]#" style="color: ##000000; font-size: 8pt; font-weight: bold">Remove</a>
								</td>
							<cfelse>
								<td>&nbsp;</td>
							</cfif>
						</cfloop>
					</tr>
					<tr>
						<td class="dataPoint" style="color: ##000000; font-size: 8pt">Available</td>
						<cfloop query="arguments.productData">
							<td style="color: ##000000; font-size: 8pt; text-align: left">								
								<cfif arguments.productData.IsAvailableInWarehouse[arguments.productData.currentRow] && arguments.productData.IsAvailableOnline[arguments.productData.currentRow]>
									Online + #textDisplayRenderer.getStoreAliasName()#
								<cfelseif arguments.productData.IsAvailableOnline[arguments.productData.currentRow]>
									Online Only
								<cfelseif arguments.productData.IsAvailableInWarehouse[arguments.productData.currentRow]>
									#textDisplayRenderer.getStoreAliasName()# Only
								</cfif>
							</td>
						</cfloop>
					</tr>
					<tr valign="top">
						<td class="dataPoint" style="color: ##000000; font-size: 8pt" valign="top">Free Accessory</td>
						<cfloop query="arguments.productData">
							<td style="color: ##000000; text-align: left; font-size: 8pt" valign="top">
								<cfif arguments.productData.bFreeAccessory[arguments.productData.currentRow]>
									<cfset qry_getAccessories = application.model.phone.getFreeAccessories(productId = arguments.productData.productID[arguments.productData.currentRow]) />

									<cfif qry_getAccessories.recordCount>
										<cfloop query="qry_getAccessories">
											<table width="100%" cellpadding="0" cellspacing="0" border="0" style="border: 0px">
												<tr valign="top">
													<td width="1" style="border: 0px"><img src="#assetPaths.common#images/ui/1295272039_sign_free_red.png" width="32" height="32" /></td>
													<td style="text-align: left; border: 0px"><a href="/index.cfm/go/shop/do/accessoryDetails/product_id/#qry_getAccessories.product_id[qry_getAccessories.currentRow]#/" style="font-size: 8pt">#trim(qry_getAccessories.summaryTitle[qry_getAccessories.currentRow])#</a></td>
												</tr>
											</table>
											<cfif qry_getAccessories.currentRow neq qry_getAccessories.recordCount>
												<br />
											</cfif>
										</cfloop>
									<cfelse>
										<span style="color: gray">Not Available</span>
									</cfif>
								<cfelse>
									<span style="color: gray">Not Available</span>
								</cfif>
							</td>
						</cfloop>
					</tr>
				</tbody>
			</cfoutput>
			<cfoutput query="arguments.productCompareData" group="PropertyType">
				<tr>
					<td colspan="#(arguments.productData.recordCount + 1)#" style="border-right: 0px">&nbsp;</td>
				</tr>
				<tr class="control">
					<td class="dataPoint" colspan="#(arguments.productData.recordCount + 1)#" style="color: ##000000; font-weight: bold; text-align: left; font-size: 8pt; background-color: ##8fafc6" id="panel_#currentRow#">
						<table width="100%" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td style="border: 0px; font-size: 8pt; text-align: left; color: ##000000; background-color: ##8fafc6"><cfif len(trim(propertyType))>#propertyType#<cfelse>Attributes</cfif></td>
								<td style="border: 0px; font-size: 8pt; text-align: left; color: ##000000; background-color: ##8fafc6" width="80"><img id="expandImage_groupRows-#iif(len(trim(propertyType)), de('#propertyType#'), de('Attributes'))#" src="#assetPaths.common#images/ui/collapse.png" align="texttop" border="0" alt="Expand / Collapse" title="Expand / Collapse" width="14" height="15" />&nbsp;<a href="javascript:void()" id="expandText_groupRows-#iif(len(trim(propertyType)), de('#propertyType#'), de('Attributes'))#" onclick="expandIt('groupRows-#iif(len(trim(propertyType)), de('#propertyType#'), de('Attributes'))#')" style="color: ##000000">Collapse</a></td>
							</tr>
						</table>
					</td>
				</tr>
				<tbody id="groupRows-#iif(len(trim(propertyType)), de('#propertyType#'), de('Attributes'))#">
					<cfoutput group="GroupLabel">
						<tr>
							<td class="groupLabel" colspan="#(arguments.productData.recordCount + 1)#" style="color: ##000000; font-size: 8pt">
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cfif len(trim(groupLabel))>- #groupLabel#</cfif>
							</td>
						</tr>
						<cfoutput>
							<tr valign="top">
								<td class="dataPoint" style="color: ##000000; font-size: 8pt; font-weight: bold">#propertyLabel#</td>
								<cfloop query="arguments.productData">
									<cfset local.thisValue = evaluate('arguments.productCompareData.value_#arguments.productData.productID[arguments.productData.currentRow]#[arguments.productCompareData.currentRow]') />

									<cfif local.thisValue is 'True' or local.thisValue is 'False'>
										<cfset local.thisValue = yesNoFormat(local.thisValue) />
									<cfelseif not len(trim(local.thisValue))>
										<cfset local.thisValue = '<span style="color: gray">Not Available</span>' />
									</cfif>

									<td style="color: ##000000; font-size: 8pt; text-align: left">#trim(local.thisValue)#</td>
								</cfloop>
							</tr>
						</cfoutput>
					</cfoutput>
				</tbody>
			</cfoutput>
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

		<cfif not request.p.printFormat>
			<p align="right"><a href="#top">Return to Top</a></p>
		</cfif>
	</cfsavecontent>

	<cfreturn trim(local.productHTML) />
</cffunction>


<cffunction name="renderAddToCartButton" access="public" output="false" returntype="string">
	<cfargument name="ProductClass" type="string" required="true" hint="phone,prepaid" />
	<cfargument name="CarrierId" type="numeric" required="true" />
	<cfargument name="ProductId" type="numeric" required="true" />
	<cfargument name="PriceType" type="string" required="true" />
	<cfargument name="AvailableQty" type="numeric" required="true" />
	<cfargument name="IsSmartPhone" type="boolean" required="false" default="false" />
	<cfargument name="IsNoContractRestricted" type="boolean" required="false" default="false" />
	<cfargument name="IsNewActivationRestricted" type="boolean" required="false" default="false" />
	<cfargument name="IsUpgradeActivationRestricted" type="boolean" required="false" default="false" />
	<cfargument name="IsAddALineActivationRestricted" type="boolean" required="false" default="false" />
	<cfargument name="IsTMORedirect" type="boolean" default="false" required="false" />
	<cfargument name="TMOBuyURL" type="string" default="" required="false" />
	<cfargument name="IsAvailableInWarehouse" type="boolean" default="false" required="false" />
	<cfargument name="IsProductCompatibleWithPlan" type="boolean" required="true" />

	<cfset var local = {} />
	<cfset local.html = '' />

	<cfif findNoCase( 'costco', channelConfig.getDisplayName() )>
		<cfset local.channel = 'COSTCO' />
	<cfelse>
		<cfset local.channel = 'NULL' />
	</cfif>

	<cfsavecontent variable="local.html">
		<cfoutput>
			<!--- Modified on 10/31/2014 by Denard Springle (denard.springle@cfwebtools.com) --->
			<!--- Track #: 6800 - Tmo - Show pricing for Upgrade my device shows bad pricing. [ Extra credit - have restricted phones show in-store availability when warehouse flag set ] --->
			<!--- added argument and check for IsAvailableInWarehouse --->

			<cfif session.cart.getPrepaid() and arguments.productClass eq 'prepaid' and session.cart.getCarrierId() neq arguments.carrierid >
				<a class="DisabledButton" href="##" onclick="alert('Only prepaid phones from the same carrier may be purchased together.');return false;"><span>Disabled</span></a>
			<cfelseif session.cart.hasCart() && session.cart.getCurrentLine() eq request.config.otherItemsLineNumber>
				<a class="DisabledButton" href="##" onclick="alert('This cannot be added to the current accessory-only line. Please select another line to add the device to.');return false;"><span>Unavailable</span></a>
			<cfelseif arguments.PriceType eq 'nocontract' && arguments.IsNoContractRestricted && !arguments.IsAvailableInWarehouse>
				<a class="DisabledButton" href="##" onclick="alert('This device is not available for purchase without a contract.');return false;"><span>Unavailable</span></a>
			<cfelseif arguments.PriceType eq 'new' && arguments.IsNewActivationRestricted && !arguments.IsAvailableInWarehouse>
				<a class="DisabledButton" href="##" onclick="alert('This device is not available for purchase for new activations.');return false;"><span>Unavailable</span></a>
			<cfelseif arguments.PriceType eq 'upgrade' && arguments.IsUpgradeActivationRestricted && !arguments.IsAvailableInWarehouse>
				<a class="DisabledButton" href="##" onclick="alert('This device is not available for purchase for upgrade activations.');return false;"><span>Unavailable</span></a>
			<cfelseif arguments.PriceType eq 'addaline' && arguments.IsAddALineActivationRestricted && !arguments.IsAvailableInWarehouse>
				<a class="DisabledButton" href="##" onclick="alert('This device is not available for purchase for Add-a-Line activations.');return false;"><span>Unavailable</span></a>		

			<cfelseif arguments.PriceType eq 'nocontract' && arguments.IsNoContractRestricted && arguments.IsAvailableInWarehouse>
				<a class="DisabledButton" href="##" onclick="alert('This device is not available for purchase without a contract.');return false;"><span>In-Store Only</span></a>
			<cfelseif arguments.PriceType eq 'new' && arguments.IsNewActivationRestricted && arguments.IsAvailableInWarehouse>
				<a class="DisabledButton" href="##" onclick="alert('This device is not available for purchase for new activations.');return false;"><span>In-Store Only</span></a>
			<cfelseif arguments.PriceType eq 'upgrade' && arguments.IsUpgradeActivationRestricted && arguments.IsAvailableInWarehouse>
				<a class="DisabledButton" href="##" onclick="alert('This device is not available for purchase for upgrade activations.');return false;"><span>In-Store Only</span></a>
			<cfelseif arguments.PriceType eq 'addaline' && arguments.IsAddALineActivationRestricted && arguments.IsAvailableInWarehouse>
				<a class="DisabledButton" href="##" onclick="alert('This device is not available for purchase for Add-a-Line activations.');return false;"><span>In-Store Only</span></a>	

			<!--- END EDITS on 10/31/2014 by Denard Springle --->

			<cfelseif session.cart.hasCart() and session.cart.getCurrentLine() and not application.model.plan.getRateplanControlAvailability(session.cart.getCarrierId(), session.cart.getCurrentLineData().getPlanType(), arguments.priceType) and not session.cart.getHasFamilyPlan()>
				<a class="DisabledButton" href="##" onclick="alert('This cannot be selected based on your cart.');return false;"><span>Unavailable</span></a>
			<cfelseif arguments.AvailableQty lte 0>
				<a class="DisabledButton" href="##" onclick="alert('#application.wirebox.getInstance("TextDisplayRenderer").getOutOfStockAlertText()#');return false;"><span>#application.wirebox.getInstance("TextDisplayRenderer").getOutOfStockButtonText()#</span></a>
			<cfelseif arguments.productClass eq 'prepaid' and session.cart.hasCart() and arrayLen(session.cart.getLines()) and not session.cart.getPrepaid()>
				<a class="DisabledButton" href="##" onclick="alert('You may not add this to your cart because your cart currently contains wireless devices/service plans.');return false;"><span>Disabled</span></a>
			<cfelseif session.cart.getPrepaid() and variables.productClass is not 'prepaid'>
				<a class="DisabledButton" href="##" onclick="alert('You may not add this to your cart because your cart currently contains a prepaid phone.');return false;"><span>Disabled</span></a>
			<cfelseif arguments.IsSmartPhone && session.cart.getHasPlanDeviceCap() && session.cart.getDeviceTypeCount('SmartPhone')>
				<a class="DisabledButton" href="##" onclick="alert('The rate plan you have chosen is limited to 1 Smart Phone per plan');return false;"><span>Disabled</span></a>
			<cfelseif session.cart.getHasFamilyPlan()>
				<cfswitch expression="#getFamilyPlanButtonState( arguments.priceType, session.cart.getActivationType(), session.cart.getHasFamilyPlan(), session.cart.getCarrierId(), session.cart.getCurrentLine() )#">
					<cfcase value="unavailable">
						<cfset thisWindowName = 'windowNotCompatible1' & createUUID() />
						<!--- <span class="actionButtonDisabled"><a href="javascript:void(0)" class="priceTab" onclick="viewFooterContentInWindow('#variables.thisWindowName#', 'Wireless Advocates - Incompatible Type', '/index.cfm/go/shop/do/incompatibleType/planType/new/cartType/#arguments.priceType#/carrierId/#session.cart.getCarrierId()#/thisWindowName/#variables.thisWindowName#/'); return false;">1More Info</a></span> --->
					</cfcase>
					<cfcase value="addToCart">
						<!--- Account for when a product is not available --->
						<cfif arguments.IsProductCompatibleWithPlan>
							<!--- If TMO Redirect use the buyURL else do regular logic --->
							<cfif arguments.isTMORedirect>
								<cfif Len(arguments.TMOBuyURL)>
									<a class="ActionButton learnMoreBtn" href="javascript: showTmobileRedirectDisclaimer('#arguments.TMOBuyURL#','#local.channel#');return false;"><span>Learn More</span></a>
								<cfelse>
									<a class="DisabledButton" href="##" onclick="alert('#application.wirebox.getInstance("TextDisplayRenderer").getOutOfStockAlertText()#');return false;"><span>#application.wirebox.getInstance("TextDisplayRenderer").getOutOfStockButtonText()#</span></a>		
								</cfif>
							<cfelse>
								<a class="ActionButton learnMoreBtn" href="##" onclick="addToCart('#lcase(arguments.productClass)#:#arguments.priceType#','#arguments.productID#',1 <cfif request.config.enforceInventoryRestrictions>,#arguments.AvailableQty#</cfif>);return false;"><span>Add to Cart</span></a>
							</cfif>
						<cfelse>
							<cfset thisWindowName = 'windowNotCompatible1' & createUUID() />
							<!--- <span class="actionButtonDisabled"><a href="javascript:void(0)" class="priceTab" onclick="viewFooterContentInWindow('#variables.thisWindowName#', 'Wireless Advocates - Incompatible Type', '/index.cfm/go/shop/do/incompatibleType/planType/new/cartType/#arguments.priceType#/carrierId/#session.cart.getCarrierId()#/thisWindowName/#variables.thisWindowName#/'); return false;">2More Info</a></span> --->
						</cfif>
					</cfcase>
					<cfcase value="disabled">
						<a class="DisabledButton" href="##" onclick="alert('This device option is not available for this line.');return false;"><span>Disabled</span></a>
					</cfcase>
					<cfdefaultcase>
						<a class="DisabledButton" href="##" onclick="alert('An error occured. Please contact customer service.');return false;"><span>Error</span></a>
					</cfdefaultcase>
				</cfswitch>
			<cfelseif session.cart.hasCart() and len(trim(session.cart.getActivationType())) and session.cart.getActivationType() neq arguments.priceType>
				<!--- <span class="actionButtonDisabled"><a href="##" onclick="alert('You may not add this to your cart because your cart currently has a<cfif session.cart.getActivationType() is 'new'> 2-year<cfelseif session.cart.getActivationType() is 'upgrade'>n upgrade<cfelseif session.cart.getActivationType() is 'addaline'>n add-a-line</cfif> designation.');return false;">Disabled</a></span> --->
			<cfelseif arguments.IsProductCompatibleWithPlan>
				<cfif arguments.IsTMORedirect>
					<cfif Len(arguments.TMOBuyURL)>
						<a class="ActionButton learnMoreBtn" href="javascript: showTmobileRedirectDisclaimer('#arguments.TMOBuyURL#','#local.channel#');"><span>Learn More</span></a>
					<cfelse>
						<a class="DisabledButton" href="##" onclick="alert('#application.wirebox.getInstance("TextDisplayRenderer").getOutOfStockAlertText()#');return false;"><span>#application.wirebox.getInstance("TextDisplayRenderer").getOutOfStockButtonText()#</span></a>				
					</cfif>
				<cfelse>
					<a class="ActionButton learnMoreBtn" href="##" onclick="addToCart('#lcase(arguments.productClass)#:#arguments.priceType#','#arguments.productID#',1 <cfif request.config.enforceInventoryRestrictions>,#arguments.AvailableQty#</cfif>);return false;"><span>Add to Cart</span></a>
				</cfif>
			<cfelse>
				<cfset thisWindowName = 'windowNotCompatible1' & createUUID() />
				<!--- <span class="actionButtonDisabled"><a href="javascript:void(0)" class="priceTab" onclick="viewFooterContentInWindow('#variables.thisWindowName#', 'Wireless Advocates - Incompatible Type', '/index.cfm/go/shop/do/incompatibleType/planType/new/cartType/#arguments.priceType#/carrierId/#session.cart.getCarrierId()#/thisWindowName/#variables.thisWindowName#/'); return false;">3More Info</a></span> --->
			</cfif>
		</cfoutput>
	</cfsavecontent>

	<cfreturn trim(local.html) />
</cffunction>


<!---
  -
  -
  - @param priceType - Pricing Column (new, upgrade, addaline)
  - @param cartActivationType - Current activation type in cart
  - @param cartHasFamilyPlan - Whether or not a family plan is in cart
  - @param cartCarrierId - ID of Carrier (42,109,128,299)
  -
  - @return buttonState - State of displayed button (unavailable, addToCart, disabled)
  --->
<cffunction name="getFamilyPlanButtonState" access="public" output="false" returntype="string">
	<cfargument name="priceType" type="string" required="true" />
	<cfargument name="cartActivationType" type="string" required="true" />
	<cfargument name="cartHasFamilyPlan" type="boolean" required="true" />
	<cfargument name="cartCarrierId" type="numeric" required="true" />
	<cfargument name="cartCurrentLine" type="numeric" required="true" />

	<cfscript>
		var buttonState = 'unavailable'; //States are unavailable, addToCart, disabled
		var maxLinesForFamilyPlan = 0;
		
		if ( arguments.cartHasFamilyPlan )
		{
			maxLinesForFamilyPlan = application.model.plan.getFamilyPlanMaxLines(session.cart.getFamilyPlan().getProductId());
			switch(arguments.priceType)
			{
				case 'new':
				{
					if (listFind('42,299', arguments.cartCarrierId))	{
						if (arguments.cartCurrentLine lt maxLinesForFamilyPlan)	{
							buttonState = 'addToCart';
						} else {
							buttonState = 'disabled';
						}
					} else if(listFind('109,128', arguments.cartCarrierId))	{
						if (arguments.cartCurrentLine lt maxLinesForFamilyPlan)	{
							buttonState = 'addToCart';
						} else {
							buttonState = 'disabled';
						}
					}

					break;
				}
				case 'upgrade':
				{
					if (listFind('42,109', arguments.cartCarrierId))
					{
						buttonState = 'addToCart';
					}
					else
					{
						buttonState = 'disabled';
					}
					break;
				}
				case 'addaline':
				{
					if (cartActivationType eq 'upgrade')
					{
						buttonState = 'disabled';
					}
					else
					{
						if (listFind('42,299', arguments.cartCarrierId))
						{
							if (arguments.cartCurrentLine gte maxLinesForFamilyPlan)	{
								buttonState = 'addToCart';
							} else {
								buttonState = 'disabled';
							}
						}
						else if (listFind('109,128', arguments.cartCarrierId))
						{
							if (arguments.cartCurrentLine gte maxLinesForFamilyPlan)	{
								buttonState = 'addToCart';
							} else {
								buttonState = 'disabled';
							}
						}
					}

					break;
				}
				default:
				{
					buttonState = 'error';
					break;
				}
			}
		}
	</cfscript>

	<cfreturn buttonState />
</cffunction>



	<cffunction name="getFinanceProductName" access="private" returntype="string" output="false">
		<cfargument name="carrierId" type="numeric" required="true" />

		<cfscript>
			var productName = '';
			
			switch( arguments.carrierId )
			{
				case 109:
					productName = 'Next';
					break;
				case 42:
					productName = 'Monthly';
					break;
				case 128:
					productName = 'Monthly';
					break;
				case 299:
					productName = 'Easy Pay';
					break;
			}
		</cfscript>
		
		<cfreturn productName />
	</cffunction>



	<cffunction name="getFinanceProductTerm" access="private" returntype="string" output="false">
		<cfargument name="carrierId" type="numeric" required="true" />

		<cfscript>
			var productName = '';
			
			switch( arguments.carrierId )
			{
				case 109:
					productName = '/mo';
					break;
				case 42:
					productName = '/mo';
					break;
				case 128:
					productName = '/mo';
					break;
				case 299:
					productName = ' down';
					break;
			}
		</cfscript>
		
		<cfreturn productName />
	</cffunction>
	





