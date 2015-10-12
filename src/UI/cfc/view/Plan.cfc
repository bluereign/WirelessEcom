<cfcomponent output="false" displayname="Plan">

	<cffunction name="init" access="public" returntype="Plan" output="false">
		<!--- Remove this when this component is added to CS --->        
        <cfset setAssetPaths( application.wirebox.getInstance("assetPaths") ) />
		<cfset variables.PlanFilter = application.wirebox.getInstance("PlanFilter") />
		<cfreturn this />
	</cffunction>

	<cffunction name="browsePlans" access="public" returntype="string" output="false">

		<cfset var local = structNew() />

		<cfset request.p.sort = variables.PlanFilter.getSort() />

		<cfsavecontent variable="local.planHTML">
			<cfoutput>
				<script type="text/javascript" language="javascript" src="#getAssetPaths().common#scripts/filter.js?v=1.0.2"></script>
				<script type="text/javascript" language="javascript" src="#getAssetPaths().common#scripts/compare.js"></script>
				<script type="text/javascript" language="javascript">
					function itemsLoaded()	{
						InitCompareCheckbox();
						EnableFilters();
						updateHiddenFilterOptions(); //Needed for sorting
					}
					
					function SortProductList()
					{
						UpdateFilter( jQuery('##SortBy').val(), this);
						try	{ _gaq.push(['_trackEvent', 'Sort', 'Plans Sort Click', jQuery('##SortBy option:selected').text()]); }
						catch (e) { }						
					}					
				</script>

				<div class="main left plans" style="width: 755px">
					<h1 class="product-list">Select a Service Plan</h1>

					<div class="sortBar">
						<div class="sortPriceOption">
							<span>Sort By</span>
							
							<!--- Updates session sort filter --->
							<cfajaxproxy bind="url:/shop/changeSort.cfm?productClass=plan&sort={SortBy.value}" />
	
							<select id="SortBy" name="SortBy" class="dropdownbox" onchange="SortProductList()">
								<option value="PriceAsc" <cfif request.p.Sort eq 'PriceAsc'>selected="selected"</cfif>>Price: Low to High</option>
								<option value="PriceDesc" <cfif request.p.Sort eq 'PriceDesc'>selected="selected"</cfif>>Price: High to Low</option>
								<option value="MinuteAsc" <cfif request.p.Sort eq 'MinuteAsc'>selected="selected"</cfif>>Minutes: Low to High</option>
								<option value="MinuteDesc" <cfif request.p.Sort eq 'MinuteDesc'>selected="selected"</cfif>>Minutes: High to Low</option>
								<option value="DataAsc" <cfif request.p.Sort eq 'DataAsc'>selected="selected"</cfif>>Included Data: Low to High</option>
								<option value="DataDesc" <cfif request.p.Sort eq 'DataDesc'>selected="selected"</cfif>>Included Data: High to Low</option>							
							</select>
						</div>
						<div style="clear:both;"></div>				
					</div>
					<cfdiv id="resultsDiv" bind="url:/index.cfm/go/shop/do/browsePlansResults?#cgi.query_string#" />
				</div>
			</cfoutput>
		</cfsavecontent>

		<cfreturn trim(local.planHTML) />
	</cffunction>
	

	<cffunction name="browsePlansResults" access="public" returntype="string" output="false">
		<cfargument name="planData" type="query" required="true" />
		<cfargument name="bindAjaxOnLoad" type="boolean" default="true" />

		<cfset var local = structNew() />

		<cfif variables.PlanFilter.getUserSelectedFilterValuesByFieldName( fieldName = 'filterOptions' ) eq 0 || listFind(variables.PlanFilter.getUserSelectedFilterValuesByFieldName(fieldName = 'filterOptions'), '347')>
			<cfset local.DisplayVotelDevices = true />
		</cfif>

		<cfsavecontent variable="local.planHTML">
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
				<ul id="prodList" class="prodList">
			</cfoutput>

			<cfif arguments.planData.recordCount>
				<cfset request.lstAvailablePlanIds = valueList(arguments.planData.productId) />
				

				<cfif session.cart.hasCart() and application.model.cartHelper.getLineDeviceProductId(line = session.cart.getCurrentLine())>
					<cfset request.lstAvailablePlanIds = application.model.plan.getPlanIdsByProductId(productId = application.model.cartHelper.getLineDeviceProductId(line = session.cart.getCurrentLine())) />
				</cfif>

				<cfoutput query="arguments.planData">
					
					<!--- filter out unavailable plans --->
					
					<cfset local.PlanArgs = {
								ProductId = arguments.planData.ProductId[arguments.planData.currentRow]
								, CarrierId = arguments.planData.CarrierId[arguments.planData.currentRow]
								, Price = arguments.planData.PlanPrice[arguments.planData.currentRow]
								, Minutes = arguments.planData.minutes_anytime[arguments.planData.currentRow]
								, DataLimitGb = arguments.planData.DataLimitGB[arguments.planData.currentRow]
								, DataLimitText = arguments.planData.data_limit[arguments.planData.currentRow]
								, Plantype = arguments.planData.PlanType[arguments.planData.currentRow]
								, HasPlanDeviceCap = arguments.planData.HasPlanDeviceCap[arguments.planData.currentRow]
								, IsShared = arguments.planData.IsShared[arguments.planData.currentRow]
								, PricePlanDiscount = application.model.Plan.getPlanDiscount( arguments.planData.CarrierId[arguments.planData.currentRow] )
								, CarrierBillCode = arguments.planData.carrierBillCode
							} />
							
					<cfset local.priceBlock = Trim(renderPriceBlock( argumentCollection = local.PlanArgs ))>
					
					<cfif NOT findNoCase("DisabledButton", local.priceBlock)>
					
					<cfif arguments.planData.planType is 'data'>
						<cfquery name="qry_getProductTags" datasource="#application.dsn.wirelessadvocates#">
							SELECT	ProductGuid
							FROM	catalog.ProductTag
							WHERE	(Tag = 'datadevice' OR Tag = 'tablet')
								AND	ProductGuid = (
									SELECT	ProductGuid
									FROM	catalog.Product
									WHERE	ProductId = <cfqueryparam value="#application.model.cartHelper.getLineDeviceProductId(line = session.cart.getCurrentLine())#" cfsqltype="cf_sql_integer" />
								)
						</cfquery>

						<cfset hideData = true />

						<cfif qry_getProductTags.recordCount>
							<cfset hideData = false />
						</cfif>
					</cfif>

					<li class="prodItem">
						<div class="prodImg" style="width: 150px">
							<a href="/index.cfm/go/shop/do/planDetails/planId/#arguments.planData.planId[arguments.planData.currentRow]#">
								<cfif arguments.planData.carrierID eq 109><!--- at&t --->
									<img src="#getAssetPaths().common#images/carrierLogos/att_175.gif" width="150" border="0" />
								<cfelseif arguments.planData.carrierID eq 128><!--- t-mobile --->
									<img src="#getAssetPaths().common#images/carrierLogos/tmobile_175.gif" width="150" border="0" />
								<cfelseif arguments.planData.carrierID eq 42><!--- verizon --->
									<img src="#getAssetPaths().common#images/carrierLogos/verizon_175.gif"  width="150" border="0" />
								<cfelseif arguments.planData.carrierID eq 299><!--- sprint --->
									<img src="#getAssetPaths().common#images/carrierLogos/sprint_175.gif"  width="150" border="0" />
								</cfif>
							</a>
							<div class="toolbar">
								<input class="compareCheck" type="checkbox" name="compareIDs" id="compareCheckbox#arguments.planData.planId[arguments.planData.currentRow]#" value="#arguments.planData.planId[arguments.planData.currentRow]#"<cfif listFind(variables.PlanFilter.getUserSelectedFilterValuesByFieldName('compareIDs'), arguments.planData.planId[arguments.planData.currentRow])> checked="checked"</cfif> />
								<label for="compareCheckbox#arguments.planData.currentRow#">Compare</label>
								<a href="##" onClick="if(validateCompareSelected()){document.compareForm.submit()}else{alert('Please select an item or two to compare.')}; return false;">compare now</a>
								<cfajaxproxy bind="url:/shop/changeCompareIds.cfm?productClass=plan&compareId={compareCheckbox#arguments.planData.planID[arguments.planData.currentRow]#@none}&compareChecked={compareCheckbox#arguments.planData.planID[arguments.planData.currentRow]#.checked}" />
							</div>
						</div>
						<div class="prodDetail">
							<cfif request.config.debugInventoryData>
								<div id="inventoryDebugIcon_#arguments.planData.productId[arguments.planData.currentRow]#" class="inventoryDebugIcon" onmouseover="revealInventoryDebugInfo(#arguments.planData.productId[arguments.planData.currentRow]#,this);document.body.style.cursor='pointer';"></div>
								<div id="inventoryDebugInfo_#arguments.planData.productId[arguments.planData.currentRow]#" class="inventoryDebugInfo" onmouseout="hideInventoryDebugInfo(this);document.body.style.cursor='';">
									<div style="float:left;">GERS SKU:</div><div style="float:right;">#arguments.planData.GersSku[arguments.planData.currentRow]#</div><br/>
									<div style="float:left;">Product ID:</div><div style="float:right;">#arguments.planData.ProductId[arguments.planData.currentRow]#</div><br/>
									<div style="float:left;">Carrier Bill Code:</div><div style="float:right;">#arguments.planData.CarrierBillCode[arguments.planData.currentRow]#</div><br/>
									<div style="float:left;">Plan Type:</div><div style="float:right;">#arguments.planData.PlanType[arguments.planData.currentRow]#</div><br/>
									<div style="float:left;">Is Shared:</div><div style="float:right;">#arguments.planData.IsShared[arguments.planData.currentRow]#</div><br/>
									<div style="float:left;">Monthly Fee:</div><div style="float:right;">#arguments.planData.MonthlyFee[arguments.planData.currentRow]#</div><br/>
									<div style="float:left;">Additional Line Fee:</div><div style="float:right;">#arguments.planData.AdditionalLineFee[arguments.planData.currentRow]#</div><br/>
									<div style="float:left;">Included Lines:</div><div style="float:right;">#arguments.planData.IncludedLines[arguments.planData.currentRow]#</div><br/>
									<div style="float:left;">Max Lines:</div><div style="float:right;">#arguments.planData.MaxLines[arguments.planData.currentRow]#</div><br/>
									<div style="float:left;">Minutes:</div><div style="float:right;">#arguments.planData.minutes_anytime[arguments.planData.currentRow]#</div><br/>
									<div style="float:left;">Data (display):</div><div style="float:right;">#arguments.planData.data_limit[arguments.planData.currentRow]#</div><br/>
									<div style="float:left;">Data (sort):</div><div style="float:right;">#arguments.planData.DataLimitGb[arguments.planData.currentRow]#</div><br/>
								</div>
							</cfif>
							<h2><a href="/index.cfm/go/shop/do/planDetails/planId/#arguments.planData.planId[arguments.planData.currentRow]#">#trim(arguments.planData.summaryTitle[arguments.planData.currentRow])#</a></h2>
							<div class="prodDesc">#trim(arguments.planData.summaryDescription[arguments.planData.currentRow])#</div>
						</div>
						<div class="prodPrice">	
							#local.priceBlock#
						</div>
					</li>
					
				</cfif>
					
				</cfoutput>
			<cfelse>
				<li class="prodItem">
					There are no Plans matching your current filter criteria.<br />
					Please modify your filters and try again.
				</li>
			</cfif>
			<cfoutput>
					<cfif arguments.planData.recordCount>
						<p>&nbsp;</p>
						<p align="right" style="text-align: right"><a href="##top">Return to Top</a></p>
					</cfif>
				</ul>
			</cfoutput>
		</cfsavecontent>

		<cfreturn trim(local.planHTML) />
	</cffunction>


	<cffunction name="browseSearchResults" access="public" output="false" returntype="string">
		<cfargument name="data" type="query" required="true">
		<cfargument name="bindAjaxOnLoad" type="boolean" default="true">
		<cfset var local = structNew()>
		<cfset local.c = "">
		<cfsavecontent variable="local.c">
			<cfoutput>#this.browsePlansResults(planData=arguments.data,bindAjaxOnLoad=arguments.bindAjaxOnLoad)#</cfoutput>
		</cfsavecontent>
		<cfreturn local.c>
	</cffunction>


	<cffunction name="planDetails" access="public" returntype="string" output="false">
		<cfargument name="planData" type="query" required="true" />
		<cfargument name="bSelectServices" type="boolean" required="false" default="false" />
		<cfargument name="activeTab" type="string" required="false" default="specifications" />

		<cfset var local = structNew() />

		<cfset local.cartTypeId = application.model.cart.getCartTypeId(session.cart.getActivationType()) />

		<cfif session.cart.hasCart() and application.model.cartHelper.getLineDeviceProductId(session.cart.getCurrentLine()) and arguments.bSelectServices>
			<cfset arguments.activeTab = 'optionalServices' />
		<cfelseif not session.cart.hasCart() or not application.model.cartHelper.getLineDeviceProductId(session.cart.getCurrentLine())>
			<cfset arguments.activeTab = 'specifications' />
		</cfif>

		<cfset local.linePhoneSelected = false />
		<cfset local.linePhoneID = 0 />

		<cfif isDefined('session.cart') and isStruct(session.cart)>
			<cfset local.cartLines = session.cart.getLines() />

			<cfif arrayLen(local.cartLines)>
				<cfset local.thisLine = local.cartLines[session.cart.getCurrentLine()] />
				<cfset local.linePhoneSelected = local.thisLine.getPhone().hasBeenSelected() />

				<cfif local.linePhoneSelected>
					<cfset local.linePhoneID = local.thisLine.getPhone().getProductID() />
				</cfif>
			</cfif>
		</cfif>

		<cfset local.servicesReadOnly = true />

		<cfif local.linePhoneSelected>
			<cfset local.servicesReadOnly = false />
		</cfif>

		<cfif session.cart.hasCart() and ((session.cart.getActivationType() CONTAINS 'upgrade' and session.cart.getUpgradeType() is 'equipment-only') or session.cart.getPrePaid())>
			<cfset local.servicesReadOnly = true />
		</cfif>

		<cfset local.thisLinePhoneId = 0 />
		<cfset local.thisLinePhoneGuid = '' />

		<cfif isDefined('session.cart') and isStruct(session.cart) and session.cart.getCurrentLine() and arrayLen(session.cart.getLines()) gte session.cart.getCurrentLine()>
			<cfset local.planDetails_cartLines = session.cart.getLines() />

			<cfif local.planDetails_cartLines[session.cart.getCurrentLine()].getPhone().hasBeenSelected()>
				<cfset local.thisLinePhoneId = local.planDetails_cartLines[session.cart.getCurrentLine()].getPhone().getProductID() />
				<cfset local.thisLinePhoneGuid = application.model.product.getProductGuidByProductId(local.thisLinePhoneId) />
			</cfif>
		</cfif>

		<cfset request.lstAvailablePlanIds = valueList(arguments.planData.productId) />

		<cfif session.cart.hasCart() and application.model.cartHelper.getLineDeviceProductId(line = session.cart.getCurrentLine())>
			<cfset request.lstAvailablePlanIds = application.model.plan.getPlanIdsByProductId(productId = application.model.cartHelper.getLineDeviceProductId(line = session.cart.getCurrentLine())) />
		</cfif>

		<cfsavecontent variable="local.planHTML">
			<cfoutput>
				<script type="text/javascript" language="javascript" src="#getAssetPaths().common#scripts/details.js"></script>

				<cfset local.thisLineSelectedFeatures = '' />

				<cfif isDefined('session.cart') and isStruct(session.cart) and session.cart.getCurrentLine()>
					<cfset local.cartLines = session.cart.getLines() />

					<cfif arrayLen(local.cartLines)>
						<cfset local.thisLineFeatures = local.cartLines[session.cart.getCurrentLine()].getFeatures() />

						<cfloop from="1" to="#arrayLen(local.thisLineFeatures)#" index="local.iFeature">
							<cfset local.thisLineSelectedFeatures = listAppend(local.thisLineSelectedFeatures, local.thisLineFeatures[local.iFeature].getProductID()) />
						</cfloop>
					</cfif>
				</cfif>

				<script language="javascript">
					var selectedFeatures = '#local.thisLineSelectedFeatures#';

					updateSelectedFeatures = function(o)	{
						selectedFeatures = '';
						var f = document.getElementById('form_planDetail');
						var e = f.elements;

						for(var i = 0; i < e.length; i++ )	{
							if(e[i].name.indexOf('chk_features', 0) > -1 && e[i].checked == true)
								selectedFeatures += e[i].value + ',';
						}
					}
				</script>
			</cfoutput>

			<cfoutput query="arguments.planData">
				<cfset request.title = trim(arguments.planData.companyName[arguments.planData.currentRow] & ' ' & arguments.planData.summaryTitle[arguments.planData.currentRow]) />

				<form name="form_planDetail" id="form_planDetail">
					<div class="sidebar plans-sidebar details-sidebar">
						<div id="prodImage" class="prodImage">
							<cfif arguments.planData.carrierID eq 109>
								<img src="#getAssetPaths().common#images/carrierLogos/att_175.gif" />
							<cfelseif arguments.planData.carrierID eq 128>
								<img src="#getAssetPaths().common#images/carrierLogos/tmobile_175.gif" />
							<cfelseif arguments.planData.carrierID eq 42>
								<img src="#getAssetPaths().common#images/carrierLogos/verizon_175.gif" />
							<cfelseif arguments.planData.carrierID eq 299>
								<img src="#getAssetPaths().common#images/carrierLogos/sprint_175.gif" />
							</cfif>
						</div>
						<div class="icons"> </div>
					</div>
					<div class="main plans">
						<div class="prodDetail">
							<cfif request.config.debugInventoryData>
								<div id="inventoryDebugIcon_#arguments.planData.productId[arguments.planData.currentRow]#" class="inventoryDebugIcon" onmouseover="revealInventoryDebugInfo(#arguments.planData.productId[arguments.planData.currentRow]#,this);document.body.style.cursor='pointer';"></div>
								<div id="inventoryDebugInfo_#arguments.planData.productId[arguments.planData.currentRow]#" class="inventoryDebugInfo" onmouseout="hideInventoryDebugInfo(this);document.body.style.cursor='';">
									<div style="float:left;">GERS SKU:</div><div style="float:right;">#arguments.planData.GersSku[arguments.planData.currentRow]#</div><br/>
									<div style="float:left;">Carrier Bill Code:</div><div style="float:right;">#arguments.planData.CarrierBillCode[arguments.planData.currentRow]#</div><br/>
									<div style="float:left;">Plan Type:</div><div style="float:right;">#arguments.planData.PlanType[arguments.planData.currentRow]#</div><br/>
									<div style="float:left;">Is Shared:</div><div style="float:right;">#arguments.planData.IsShared[arguments.planData.currentRow]#</div><br/>
									<div style="float:left;">Monthly Fee:</div><div style="float:right;">#arguments.planData.MonthlyFee[arguments.planData.currentRow]#</div><br/>
									<div style="float:left;">Additional Line Fee:</div><div style="float:right;">#arguments.planData.AdditionalLineFee[arguments.planData.currentRow]#</div><br/>
									<div style="float:left;">Included Lines:</div><div style="float:right;">#arguments.planData.IncludedLines[arguments.planData.currentRow]#</div><br/>
									<div style="float:left;">Max Lines:</div><div style="float:right;">#arguments.planData.MaxLines[arguments.planData.currentRow]#</div><br/>
								</div>
							</cfif>
							<h1>#trim(arguments.planData.detailTitle[arguments.planData.currentRow])#</h1>
							<div class="prodDesc">
								<div class="details-price-container">
									<cfset local.PlanArgs = {
										ProductId = arguments.planData.ProductId[arguments.planData.currentRow]
										, CarrierId = arguments.planData.CarrierId[arguments.planData.currentRow]
										, Price = arguments.planData.PlanPrice[arguments.planData.currentRow]
										, Minutes = arguments.planData.minutes_anytime[arguments.planData.currentRow]
										, DataLimitGb = arguments.planData.DataLimitGB[arguments.planData.currentRow]
										, DataLimitText = arguments.planData.data_limit[arguments.planData.currentRow]
										, Plantype = arguments.planData.PlanType[arguments.planData.currentRow]
										, HasPlanDeviceCap = arguments.planData.HasPlanDeviceCap[arguments.planData.currentRow]
										, IsShared = arguments.planData.IsShared[arguments.planData.currentRow]
										, HideAddToCartButton = arguments.bSelectServices
										, PricePlanDiscount = application.model.Plan.getPlanDiscount( arguments.planData.CarrierId[arguments.planData.currentRow] )
										, CarrierBillCode = arguments.planData.carrierBillCode
									} />
									
									#Trim(renderPriceBlock( argumentCollection = local.PlanArgs ))#
								</div>					
								
								#trim(arguments.planData.detailDescription[arguments.planData.currentRow])#
							</div>
						</div>
						
						
						<cfif arguments.bSelectServices>
							<div class="msg-box-informational" style="clear:both;">
								Please select Services for your Plan below.
							</div>
							<cfif (arguments.planData.carrierID eq 299) AND (session.cart.getActivationType() contains 'finance')>
							<!---<cfif (arguments.planData.carrierID eq 299) and (request.p.ActivationType contains 'financed')>--->
								<div class="msg-box-informational" style="clear:both;">
									*For data packages 8GB and higher, you may see a $10 discount<br/>
									 on your line access fee from Sprint.  In certain cases for your <br/>
									 higher data packages your line access fee may be waived.<br/>
									 Contact Sprint for more details.
								</div>
							</cfif>
						</cfif>
						<cfif listFindNoCase(request.lstAvailablePlanIds, arguments.planData.productId[arguments.planData.currentRow])>
							<div id="prodSpecs" class="prodSpecs">
								<ul class="tabs">
									<li<cfif arguments.activeTab is 'specifications'> class="active"</cfif>>
										<a href="##" onclick="return false;" class="tab"><span>Specifications</span></a>
										<div class="tabContent" style="overflow-x: hidden; overflow-y: auto;">
											<cfset local.specsData = application.model.plan.getSpecs(arguments.planData.planID) />
											<cfset local.specPropertiesDisplay = application.view.propertyManager.getPropertyTableTab(local.specsData) />
											#trim(local.specPropertiesDisplay)#
										</div>
									</li>
									<!--- Optional Services --->
									<cfif session.cart.hasCart() and application.model.cartHelper.getLineDeviceProductId(session.cart.getCurrentLine())>
										<li<cfif arguments.activeTab is 'optionalServices'> class="active"</cfif>>
											<a href="##" onclick="return false;" class="tab"><span>Select Services</span></a>
											<div class="tabContent" style="overflow-x: hidden; overflow-y: auto;">
												<cfset local.includedServicesForRatePlanHTML = application.view.serviceManager.getServicesByRatePlan(carrierId = arguments.planData.carrierGuid, rateplanId = arguments.planData.rateplanGuid, type = 'O', readOnly = local.servicesReadOnly, deviceId = local.thisLinePhoneGuid, alreadySelected = local.thisLineSelectedFeatures, showActiveOnly = true, cartTypeId = local.cartTypeId) />
												 #trim(local.includedServicesForRatePlanHTML)#
											</div>
										</li>
									</cfif>
									<cfset local.importantPlanInformation = application.model.plan.getImportantPlanInformation(arguments.planData.productId[arguments.planData.currentRow]) />
									<cfif len(trim(local.importantPlanInformation))>
										<li<cfif arguments.activeTab is 'importantPlanInformation'> class="active"</cfif>>
											<a href="##" onclick="return false;" class="tab"><span>Important Plan Information</span></a>
											<div class="tabContent" style="overflow-x: hidden; overflow-y: auto;">
												#trim(local.importantPlanInformation)#
											</div>
										</li>
									</cfif>
								</ul>
							</div>
						</cfif>
						<script type="text/javascript" language="javascript" src="#getAssetPaths().common#scripts/planFeatureWindow.js"></script>
					</div>
				</form>
			</cfoutput>
		</cfsavecontent>

		<cfsavecontent variable="local.productMetaData">
			<cfoutput><title>#reReplaceNoCase(trim(arguments.planData.detailTitle[arguments.planData.currentRow]), '<[^>]*>', '', 'ALL')# by #getCarrierName(carrierID = arguments.planData.carrierID)# - Mobile phone cellphone wireless phones</title></cfoutput>
		</cfsavecontent>
		<cfhtmlhead text="#trim(local.productMetaData)#" />

		<cfreturn trim(local.planHTML)>
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


	<cffunction name="comparePlans" access="public" returntype="string" output="false">
		<cfargument name="planData" type="query" required="true" />

		<cfset var local = structNew() />

		<cfif isQuery(arguments.planData) and arguments.planData.recordCount>
			<cfparam name="request.p.printFormat" type="boolean" default="false" />

			<cfset request.lstAvailablePlanIds = valueList(arguments.planData.productId) />

			<cfif session.cart.hasCart() and application.model.cartHelper.getLineDeviceProductId(line = session.cart.getCurrentLine())>
				<cfset request.lstAvailablePlanIds = application.model.plan.getPlanIdsByProductId(productId = application.model.cartHelper.getLineDeviceProductId(line = session.cart.getCurrentLine())) />
			</cfif>

			<cfsavecontent variable="local.planHTML">
				<cfoutput>
					<h1>Compare Service Plans</h1>
					<table cellpadding="0" cellspacing="0" class="compare">
						<thead>
							<cfif not request.p.printFormat>
								<tr>
									<td colspan="#(arguments.planData.recordCount + 1)#" align="right" style="border: 0px">
										<div align="right" class="noPrint">
											<img src="#getAssetPaths().common#images/ui/1295276066_print.png" align="texttop" />
											<a href="#cgi.script_name&cgi.path_info#/printFormat/true" target="_blank">Print this Page</a>
											<br /><br />
										</div>
									</td>
								</tr>
							</cfif>
							<tr>
								<th class="emptyCell">&nbsp;</th>
								<cfloop query="arguments.planData">
									<th style="color: ##000000; font-size: 8pt" width="220" valign="top">
										<div class="cellCarrierImage" style="height:90px;">
											<cfif arguments.planData.carrierID eq 109>
												<img src="#getAssetPaths().common#images/carrierLogos/att_175.gif" width="150" alt="AT&T" style="margin-top:10px;" />
											<cfelseif arguments.planData.carrierID eq 128>
												<img src="#getAssetPaths().common#images/carrierLogos/tmobile_175.gif" width="150" alt="T-Mobile" style="margin-top:10px;" />
											<cfelseif arguments.planData.carrierID eq 42>
												<img src="#getAssetPaths().common#images/carrierLogos/verizon_175.gif" width="150" alt="Verizon" />
											<cfelseif arguments.planData.carrierID eq 299>
												<img src="#getAssetPaths().common#images/carrierLogos/sprint_175.gif" width="150" alt="Sprint" />
											</cfif>
										</div>
										<div class="cellTitle" style="height:50px;">
											<h4><a href="/index.cfm/go/shop/do/planDetails/planId/#arguments.planData.planId[arguments.planData.currentRow]#" style="font-size: 8pt">#trim(arguments.planData.planName[arguments.planData.currentRow])#</a></h4>
										</div>
										<div class="cellControl" style="height:50px;">
											<cfif not request.p.printFormat>
												<cfset local.thisAddToCartButton = renderAddToCartButton(arguments.planData.productId[arguments.planData.currentRow], arguments.planData.carrierId[arguments.planData.currentRow], arguments.planData.planType[arguments.planData.currentRow]) />
												#trim(local.thisAddToCartButton)#
											</cfif>
										</div>
									</th>
								</cfloop>
							</tr>
						</thead>
						<tbody>
							<tr class="control">
								<td class="dataPoint" style="color: ##000000; font-weight: bold; text-align: left; background-color: ##8fafc6; font-size: 8pt">Plan Information</td>
								<cfloop query="arguments.planData">
									<cfif not request.p.printFormat>
										<td style="background-color: ##8fafc6">
											<img src="#getAssetPaths().common#images/ui/1295275580_delete.png" align="texttop" />&nbsp;<a href="/index.cfm/go/#request.p.go#/do/#request.p.do#/planFilter.submit/1/filter.compareIDs/#session.planFilterSelections.compareIDs#/removeID/#arguments.planData.planId[arguments.planData.currentRow]#" style="color: ##000000; font-size: 8pt; font-weight: bold">Remove</a>
										</td>
									<cfelse>
										<td style="background-color: ##8fafc6">&nbsp;</td>
									</cfif>
								</cfloop>
							</tr>
							<tr>
								<td class="dataPoint" style="color: ##000000; font-size: 8pt">Carrier</td>
								<cfloop query="arguments.planData">
									<td style="color: ##000000; font-size: 8pt">#trim(arguments.planData.companyName[arguments.planData.currentRow])#</td>
								</cfloop>
							</tr>
							<tr>
								<td class="dataPoint" style="color: ##000000; font-size: 8pt">Plan Type</td>
								<cfloop query="arguments.planData">
									<td style="color: ##000000; font-size: 8pt">#ucase(left(arguments.planData.planType[arguments.planData.currentRow], 1)) & lcase(right(arguments.planData.planType[arguments.planData.currentRow], len(arguments.planData.planType[arguments.planData.currentRow]) - 1))#</td>
								</cfloop>
							</tr>
							<tr>
								<td class="dataPoint" style="color: ##000000; font-size: 8pt">Price</td>
								<cfloop query="arguments.planData">
									<td style="color: ##000000; font-size: 8pt">#dollarFormat(arguments.planData.planPrice[arguments.planData.currentRow])#</td>
								</cfloop>
							</tr>
							<tr>
								<td colspan="#(arguments.planData.recordCount + 1)#">&nbsp;</td>
							</tr>
							<tr class="control">
								<td class="dataPoint" style="color: ##000000; font-weight: bold; text-align: left; font-size: 8pt; background-color: ##8fafc6">Minute Information</td>
								<cfloop query="arguments.planData">
									<cfif not request.p.printFormat>
										<td style="background-color: ##8fafc6">&nbsp;</td>
									<cfelse>
										<td style="background-color: ##8fafc6">&nbsp;</td>
									</cfif>
								</cfloop>
							</tr>
							<tr>
								<td class="dataPoint" style="color: ##000000; font-size: 8pt">Anytime Minutes</td>
								<cfloop query="arguments.planData">
									<cfset local.anyMins = arguments.planData.minutes_anytime[arguments.planData.currentRow] />

									<cfif isNumeric(local.anyMins) and local.anyMins gte 99999>
										<cfset local.anyMins = 'Unlimited' />
									<cfelseif isNumeric(local.anyMins)>
										<cfset local.anyMins = numberFormat(local.anyMins) />
									</cfif>

									<td style="color: ##000000; font-size: 8pt"><cfif len(trim(local.anyMins))>#local.anyMins#<cfelse>N/A</cfif></td>
								</cfloop>
							</tr>
							<tr>
								<td class="dataPoint" style="color: ##000000; font-size: 8pt">Friends &amp; Family Minutes</td>
								<cfloop query="arguments.planData">
									<cfset local.mins = arguments.planData.minutes_friendsAndFamily[arguments.planData.currentRow] />

									<cfif (isNumeric(local.mins) and local.mins gte 99999) or arguments.planData.unlimited_friendsAndFamily[arguments.planData.currentRow]>
										<cfset local.mins = 'Unlimited' />
									<cfelseif isNumeric(local.mins)>
										<cfset local.mins = numberFormat(local.mins) />
									</cfif>

									<td style="color: ##000000; font-size: 8pt"><cfif len(trim(local.mins))>#local.mins#<cfelse>N/A</cfif></td>
								</cfloop>
							</tr>
							<tr>
								<td class="dataPoint" style="color: ##000000; font-size: 8pt">Mobile-to-Mobile Minutes</td>
								<cfloop query="arguments.planData">
									<cfset local.mins = arguments.planData.minutes_mobtomob[arguments.planData.currentRow] />

									<cfif (isNumeric(local.mins) and local.mins gte 99999) or arguments.planData.unlimited_mobtomob[arguments.planData.currentRow]>
										<cfset local.mins = 'Unlimited' />
									<cfelseif isNumeric(local.mins)>
										<cfset local.mins = numberFormat(local.mins) />
									</cfif>

									<td style="color: ##000000; font-size: 8pt"><cfif len(trim(local.mins))>#local.mins#<cfelse>N/A</cfif></td>
								</cfloop>
							</tr>
							<tr>
								<td class="dataPoint" style="color: ##000000; font-size: 8pt">Off-Peak Minutes</td>
								<cfloop query="arguments.planData">
									<cfset local.mins = arguments.planData.minutes_offpeak[arguments.planData.currentRow] />

									<cfif (isNumeric(local.mins) and local.mins gte 99999) or arguments.planData.unlimited_offpeak[arguments.planData.currentRow]>
										<cfset local.mins = 'Unlimited' />
									<cfelseif isNumeric(local.mins)>
										<cfset local.mins = numberFormat(local.mins) />
									</cfif>

									<td style="color: ##000000; font-size: 8pt"><cfif len(trim(local.mins))>#local.mins#<cfelse>N/A</cfif></td>
								</cfloop>
							</tr>
							<tr>
								<td class="dataPoint" style="color: ##000000; font-size: 8pt">Free Long Distance</td>
								<cfloop query="arguments.planData">
									<td style="color: ##000000; font-size: 8pt"><cfif arguments.planData.free_longdistance[arguments.planData.currentRow]>Y<cfelse>N</cfif></td>
								</cfloop>
							</tr>
							<tr>
								<td class="dataPoint" style="color: ##000000; font-size: 8pt">Free Long Roaming</td>
								<cfloop query="arguments.planData">
									<td style="color: ##000000; font-size: 8pt"><cfif arguments.planData.free_roaming[arguments.planData.currentRow]>Y<cfelse>N</cfif></td>
								</cfloop>
							</tr>
							<tr>
								<td colspan="#(arguments.planData.recordCount + 1)#">&nbsp;</td>
							</tr>
							<tr class="control">
								<td class="dataPoint" style="color: ##000000; font-weight: bold; text-align: left; font-size: 8pt; background-color: ##8fafc6">Data Services</td>
								<cfloop query="arguments.planData">
									<cfif not request.p.printFormat>
										<td style="background-color: ##8fafc6">&nbsp;</td>
									<cfelse>
										<td style="background-color: ##8fafc6">&nbsp;</td>
									</cfif>
								</cfloop>
							</tr>
							<tr>
								<td class="dataPoint" style="color: ##000000; font-size: 8pt">Unlimited Text Messaging</td>
								<cfloop query="arguments.planData">
									<td style="color: ##000000; font-size: 8pt"><cfif arguments.planData.unlimited_textmessaging[arguments.planData.currentRow]>Y<cfelse>N</cfif></td>
								</cfloop>
							</tr>
							<tr>
								<td class="dataPoint" style="color: ##000000; font-size: 8pt">Unlimited Data</td>
								<cfloop query="arguments.planData">
									<td style="color: ##000000; font-size: 8pt"><cfif arguments.planData.unlimited_data[arguments.planData.currentRow]>Y<cfelse>N</cfif></td>
								</cfloop>
							</tr>
							<tr>
								<td class="dataPoint" style="color: ##000000; font-size: 8pt">Data Limit</td>
								<cfloop query="arguments.planData">
									<td style="color: ##000000; font-size: 8pt"><cfif len(trim(arguments.planData.data_limit[arguments.planData.currentRow])) and trim(arguments.planData.data_limit[arguments.planData.currentRow]) neq 0>#trim(arguments.planData.data_limit[arguments.planData.currentRow])#<cfelse>N/A</cfif></td>
								</cfloop>
							</tr>
							<tr>
								<td class="dataPoint" style="color: ##000000; font-size: 8pt">Additional Data Usage</td>
								<cfloop query="arguments.planData">
									<td style="color: ##000000; font-size: 8pt"><cfif len(trim(arguments.planData.additional_data_usage[arguments.planData.currentRow])) and trim(arguments.planData.additional_data_usage[arguments.planData.currentRow]) neq 0>#trim(arguments.planData.additional_data_usage[arguments.planData.currentRow])#<cfelse>N/A</cfif></td>
								</cfloop>
							</tr>
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

				</cfoutput>
			</cfsavecontent>
		<cfelse>
			<cfsavecontent variable="local.planHTML">
				<h1>Compare Service Plans</h1>

				<cfoutput>
					<div align="center" style="text-align: center">
						<div style="width:500px; margin-top: 25px; margin-right: 20px; border: 1px solid ##6B6B6B; background-color: ##fff799; padding: 10px; -moz-border-radius: 10px; -webkit-border-radius: 10px; -khtml-border-radius: 10px; font-size: 10pt;">
							<img src="#getAssetPaths().common#images/ui/info-icon.png" style="float:left; position:relative; margin-top:5px; margin-left:5px; margin-right:10px; margin-bottom:5px;"/>
							<p style="line-height:1.2em; font-size: 10pt; text-align: left">Please select at least 2 and up to 5 plans to compare.</p>
							<div style="clear:both;"></div>
						</div>
					</div>
				</cfoutput>
			</cfsavecontent>
		</cfif>

		<cfreturn trim(local.planHTML) />
	</cffunction>

	<cffunction name="renderPriceBlock" access="public" output="false" returntype="string">
		<cfargument name="ProductId" type="numeric" required="true" />
		<cfargument name="CarrierId" type="numeric" required="true" />
		<cfargument name="Price" type="numeric" required="true" />
		<cfargument name="Minutes" type="string" required="true" />
		<cfargument name="DataLimitGb" type="string" required="true" />
		<cfargument name="DataLimitText" type="string" required="true" />
		<cfargument name="Plantype" type="string" required="true" />
		<cfargument name="HasPlanDeviceCap" type="string" default="N" required="false" />
		<cfargument name="IsShared" type="boolean" default="false" required="false" />
		<cfargument name="HideAddToCartButton" type="boolean" default="false" required="false" />	
		<cfargument name="PricePlanDiscount" type="numeric" default="0" required="false" />
		<cfargument name="CarrierBillCode" type="string" required="true" />

		<cfset var local = {} />

		<cfsavecontent variable="local.html">
			<cfoutput>
				<div class="priceblock-container">
					<div class="logo-container <cfif arguments.CarrierId eq 109>logo-att<cfelseif arguments.CarrierId eq 128>logo-tmo<cfelseif arguments.CarrierId eq 42>logo-verizon<cfelseif arguments.CarrierId eq 299>logo-sprint</cfif>">
						
					</div>
					<div class="price-container">
						<table class="price-table">
							<cfif arguments.PricePlanDiscount>
								<tr>
									<td>Retail Price</td>
									<td class="price-col">#DollarFormat(arguments.Price)#</td>
								</tr>
								<tr>
									<td>Savings <span class="savings">(#arguments.PricePlanDiscount * 100#%)</span></td>
									<td class="price-col"><span class="savings">(#DollarFormat(arguments.Price * arguments.PricePlanDiscount)#)</span></td>
								</tr>
							</cfif>
							<cfif arguments.Minutes>
								<tr>
									<td>Minutes</td>
									<td class="price-col">
										<cfif IsNumeric(arguments.Minutes) && arguments.Minutes gte 99999>
											Unlimited
										<cfelse>
											#arguments.Minutes#
										</cfif>
									</td>
								</tr>
							</cfif>
							<cfif arguments.DataLimitGb>
								<tr>
									<td>Data</td>
									<td class="price-col">
										#arguments.DataLimitText#
									</td>
								</tr>
							</cfif>
						</table>
					</div>
					<div class="summary-container">
						<table class="price-table">
							<tr>
								<cfif arguments.carrierId eq 299 && arguments.carrierBillCode eq 'LTD1013'>
									<td colspan="2">
										<div style="color:##FF0000; text-align:center; font-weight:bold">See details for pricing.</div>
									</td>
								<cfelse>
									<td>Monthly Account Access</td>
									<td class="price-col">
									<div class="final-price-container">#DollarFormat(arguments.Price - (arguments.Price * arguments.PricePlanDiscount))#</div>
								</cfif>							
								</td>
							</tr>
						</table>
					</div>
					<cfif !arguments.HideAddToCartButton>
						<div class="button-container">
							#Trim( renderAddToCartButton(ProductId = arguments.ProductId, CarrierId = arguments.CarrierId, PlanType = arguments.PlanType, IsShared = arguments.IsShared) )#
						</div>
					</cfif>
				</div>
			</cfoutput>
		</cfsavecontent>
		<cfreturn local.html />
	</cffunction>

	<cffunction name="renderAddToCartButton" access="public" output="false" returntype="string">
		<cfargument name="productId" type="numeric" required="true" />
		<cfargument name="carrierId" type="numeric" required="true" />
		<cfargument name="planType" type="string" required="true" />
		<cfargument name="currentRow" type="numeric" default="1" required="false" />
		<cfargument name="HasPlanDeviceCap" type="string" default="N" required="false" />
		<cfargument name="IsShared" type="boolean" default="false" required="false" />

		<cfset var local = {} />
		<cfparam name="request.lstAvailablePlanIds" type="string" default="" />
		<cfset local.html = "" />
		
		<cfsavecontent variable="local.html">
			<cfoutput>
				<cfif session.cart.hasCart() and len(trim(session.cart.getActivationType())) and not application.model.Plan.getRateplanControlAvailability(arguments.carrierId, arguments.planType, session.cart.getActivationType(), arguments.IsShared)>
					<a class="DisabledButton" href="##" onclick="alert('This plan is not available based on your cart.');return false;"><span>Unavailable</span></a>
				<cfelseif (session.cart.getActivationType() CONTAINS 'upgrade' || session.cart.getActivationType() CONTAINS 'addaline') && ( arguments.planType eq 'data' && arguments.IsShared ) && !session.cart.getCurrentLineData().getPhone().getDeviceServiceType() eq 'MobileBroadband'>
					<a class="DisabledButton" href="##" onclick="alert('This plan is not available based on your cart.');return false;"><span>Unavailable</span></a>
				<cfelseif session.cart.hasCart() and session.cart.getActivationType() eq "prepaid">
					<a class="DisabledButton" href="##" onclick="alert('You may not add this service plan to your cart because your cart contains a prepaid phone.');return false;"><span>Disabled</span></a>
				<cfelseif session.cart.hasCart() and session.cart.getActivationType() CONTAINS "upgrade" and session.cart.getUpgradeType() eq "equipment-only">
					<a class="DisabledButton" href="##" onclick="alert('You may not add this service plan to your cart because your cart has an handset-only upgrade designation.');return false;"><span>Disabled</span></a>
              	<cfelseif session.cart.hasCart() and session.cart.getAddALineType() eq "Family">
					<a class="DisabledButton" href="##" onclick="alert('You may not add this service plan to your cart because you have family plan add a line selected.');return false;"><span>Disabled</span></a>
				<cfelseif session.cart.hasCart() and session.cart.getPrePaid()>
					<a class="DisabledButton" href="##" onclick="alert('You may not add this service plan to your cart because your cart contains a Prepaid Phone.');return false;"><span>Disabled</span></a>
				<cfelseif arguments.HasPlanDeviceCap eq 'Y' && session.cart.getDeviceTypeCount('SmartPhone') gte 2>
					<a class="DisabledButton"href="##" onclick="alert('The rate plan you have chosen is limited to 1 Smart Phone per plan');return false;"><span>Disabled</span></a>
				<cfelseif listFindNoCase(request.lstAvailablePlanIds,arguments.productId)>
					<a class="ActionButton" href="##" onclick="addToCart('plan','#arguments.productId#',1);return false;"><span>Add to Cart</span></a>
				<cfelse>
					<a class="DisabledButton" href="##" onclick="alert('This plan is not available for the device on this line.');return false;"><span>Unavailable</span></a>
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

</cfcomponent>
