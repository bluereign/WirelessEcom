<cfset assetPaths = application.wirebox.getInstance("AssetPaths") />
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />
<cfset textDisplayRenderer = application.wirebox.getInstance("TextDisplayRenderer") />
<cfset stringUtil = application.wirebox.getInstance( "StringUtil" ) />

<cfset cartLines = session.cart.getLines() />
<cfparam name="cartHTML" type="string" default="" />
<cfparam name="activeLine" type="numeric" default="#session.cart.getCurrentLine()#" />
<cfparam name="request.p.productType" type="string" default="" />
<cfparam name="request.hasWirelessItemBeenAdded" type="boolean" default="false" />
<cfparam name="request.p.changingPlanFeatures" type="boolean" default="false" />

<cfset cartBodyMode = 'edit' />

<cfif listFindNoCase('phone,tablet,dataCardAndNetBook,prepaid', listFirst(request.p.productType, ':'))>
	<cfset cartBodyMode = 'addDevice' />
<cfelseif listFirst(request.p.productType, ':') is 'plan'>
	<cfset cartBodyMode = 'addPlan' />
<cfelseif listFirst(request.p.productType, ':') is 'accessory'>
	<cfset cartBodyMode = 'addAccessory' />
</cfif>

<script type="text/javascript">
				/*  This was done to fix a bug where a small percent of the time the popup would
					show up as blank in Chrome.  It needs the smallest of timeouts to process the changes*/
				jQuery( document ).ready(function() {
	    			setTimeout(function(){jQuery('#accessoryBox').css({"position": "relative"});},30);
	    			setTimeout(function(){jQuery('#accessoryBox').css({"position": "absolute"});},50);
				});
</script>	




<!---
**
* Logic to determine which lines have devices and features selected so that we can
* alert/confirm to the user if they choose to change a device on a line with selected
* features.
**

<cfset local_cartDevices = application.model.cartHelper.getSelectedDevices() />
<cfset local_linesWithDifferentDevice = '' />

<cfif isDefined('request.p.product_id') and len(trim(request.p.product_id))>
	<cfloop collection="#local_cartDevices#" item="local_line">
		<cfif local_cartDevices[local_line] neq request.p.product_id>
			<cfset local_linesWithDifferentDevice = listAppend(local_linesWithDifferentDevice, local_line) />
		</cfif>
	</cfloop>
</cfif>

<cfset local_cartFeatures = application.model.cartHelper.getSelectedFeatures() />
<cfset local_linesWithFeatures = structKeyList(local_cartFeatures) />--->

<cf_cartbody mode="#variables.cartBodyMode#">
	
	<cfif isDefined( 'rc.bBootStrapIncluded' ) AND rc.bBootStrapIncluded>
		<style>
			.x-dlg-dlg-body, .x-dlg-bd {
				box-sizing: content-box;
			}

			.x-dlg .x-dlg-dlg-body {
				background-color: #eee;
			}

			.cartToolbar, .x-dlg {
				width: 724px;
			}
		</style>		
	</cfif>

	<cfif application.model.cartHelper.hasSelectedFeatures()>
		<cfset qRecommendedServices = application.model.ServiceManager.getRecommendedServices() />
	</cfif>

	<cfoutput>
		<cfif request.hasWirelessItemBeenAdded>
			<script language="javascript">hasWirelessItemBeenAdded = true;</script>
		</cfif>

		<cfif len(trim(request.p.productType))>
			<div class="messages-modal"></div>
			<div id="accessoryBox" class="messages-box" style="position:absolute;">
				<div class="solid">
					<cfif listFindNoCase('phone,tablet,dataCardAndNetBook,prepaid', listFirst(trim(request.p.productType), ':'))>
						<span class="addDevice strong">Add Device to <span id="whichLineText">which line</span>?</span>
					<cfelseif listFirst(trim(request.p.productType), ':') is 'plan'>
						<cfif not request.p.changingPlanFeatures>
							<span class="addPlan strong">Add Service Plan to <span id="whichLineText">which line</span>?</span>
						<cfelse>
							<span class="addPlan strong">Add services to this line <span id="whichLineText"></span>?</span>
						</cfif>
					<cfelseif listFirst(trim(request.p.productType), ':') is 'feature'>
						<span class="addFeature strong">Add Feature to <span id="whichLineText">which line</span>?</span>
					<cfelseif listFirst(trim(request.p.productType), ':') is 'accessory'>
						<span class="addAccessory strong">Add Accessory to <span id="whichLineText">which line</span>?</span>
					</cfif>
					<div class="modal-lineinputs">
						<ul>
							<cfif request.p.changingPlanFeatures>
								<input type="radio" name="targetLine" onclick="setTargetLine(#variables.activeLine#);" id="add_to_#variables.activeLine#" value="#variables.activeLine#" checked /> Line #variables.activeLine#
							<cfelse>
								<cfloop from="1" to="#arrayLen(variables.cartLines)#" index="iLine">
									<li><input type="radio" name="targetLine" onclick="setTargetLine(#variables.iLine#);" id="add_to_#variables.iLine#" value="#variables.iLine#" <cfif variables.activeLine eq variables.iLine> checked</cfif> /> Line #variables.iLine#</li>
								</cfloop>

								<cfif session.cart.getActivationType() is not 'upgrade' and arrayLen(variables.cartLines) lt 5>
									<input type="hidden" name="lineID" value="#variables.iLine#" />
									<li><input type="radio" name="targetLine" id="add_to_#variables.iLine#" onclick="setTargetLine(#variables.iLine#);" value="#variables.iLine#" <cfif variables.activeLine eq variables.iLine> checked</cfif> /> A new line</li>
								</cfif>

								<cfif listFirst(trim(request.p.productType), ':') is 'accessory'>
									<cfset iLine = request.config.otherItemsLineNumber />
									<input type="hidden" name="lineID" value="#variables.iLine#" />
									<li><input type="radio" name="targetLine" onclick="setTargetLine(#variables.iLine#);" id="add_to_#variables.iLine#" value="#variables.iLine#" <cfif variables.activeLine eq variables.iLine> checked</cfif> /> Add as additional accessories in the cart.</li>
								</cfif>
							</cfif>
						</ul>

					</div>
					<div class="control-line">
						<div class="formControl-modal">
							<span class="actionButtonLow">
								<a onclick="cancelAccessoryClick();">Cancel</a>
							</span>
							<span class="actionButton">
								<a onclick="ColdFusion.Ajax.checkForm($('formAddToCart'), _CF_checkformAddToCart, 'dialog_addToCart_body')">OK</a>
							</span>
						</div>
					</div>
					<div class="clear"></div>
				</div>
			</div>
		</cfif>

		<cfform method="post" action="/index.cfm/go/cart/do/aliasLine/" id="formAliasLine" name="formAliasLine">
			<input type="hidden" id="formAlias_line" name="formAlias_line" value="" />
			<input type="hidden" id="formAlias_alias" name="formAlias_alias" value="" />
			<input type="hidden" name="blnDialog" value="1" />
		</cfform>

		<cfform method="post" action="#cgi.script_name#" id="formAddToCart" name="formAddToCart">
			<cfloop collection="#request.p#" item="thisVar">
				<cfif variables.thisVar is not 'cartLineNumber' and variables.thisVar is not 'cartLineAlias' and left(variables.thisVar, 1) is not '_'>
					<input type="hidden" name="#variables.thisVar#" value="#htmlEditFormat(request.p[variables.thisVar])#" />
				</cfif>
			</cfloop>
			<input type="hidden" id="cartLineNumber" name="cartLineNumber" value="#variables.activeLine#" />
			<input type="hidden" name="blnDialog" value="1" />
			
			<div id="dialogContent">
				<div id="container">
					<cfoutput>
						<div id="tabs">
							<!--- LINES --->
							<cfloop from="1" to="#arrayLen(variables.cartLines)#" index="iLine">
								<cfset thisLine = variables.cartLines[variables.iLine] />
								<cfset thisLineName = application.model.cartHelper.getLineName(variables.iLine) />
								<cfset thisPhone = variables.thisLine.getPhone() />
								<cfset isDataCard = false />

								<cfif thisPhone.hasBeenSelected()>
									<cfset selectedPhone = application.model.Phone.getByFilter(idList = variables.thisPhone.getProductID()) />

									<cfif not selectedPhone.recordCount>
										<cfset selectedPhone = application.model.Tablet.getByFilter(idList = variables.thisPhone.getProductID()) />
									</cfif>
									<cfif not selectedPhone.recordCount>
										<cfset selectedPhone = application.model.dataCardAndNetbook.getByFilter(idList = variables.thisPhone.getProductID()) />

										<cfif selectedPhone.RecordCount>
											<cfset isDataCard = true />
										</cfif>
									</cfif>

									<cfif not selectedPhone.recordCount>
										<cfset selectedPhone = application.model.prePaid.getByFilter(idList = variables.thisPhone.getProductID()) />
									</cfif>
								</cfif>

								<cfset thisPlan = variables.thisLine.getPlan() />
								<cfset selectedPlan = application.model.plan.getByFilter(idList = variables.thisPlan.getProductID()) />
								<cfset thisFeatures = variables.thisLine.getFeatures() />
								<cfset thisAccessories = application.model.cartHelper.lineGetAccessoriesByType(line = variables.iLine, type = 'accessory') />
								<cfset thisWarranty = variables.thisLine.getWarranty() />
								<cfset thisLineName = application.model.cartHelper.getLineName(variables.iLine) />
								<cfset active = 'false' />

								<cfif variables.activeLine eq variables.iLine>
									<cfset active = 'true' />
								</cfif>

								<cfset secondaryImageSrc = '#assetPaths.common#images/ui/cartdialog/2/unknown.gif' />

								<input type="hidden" name="lineID" value="#variables.iLine#" />

								<div id="tab#variables.iLine#" class="my_tab tabline" active="#variables.active#">
									<div class="content-bg">
										<div class="content">
											<div class="scrollarea">
												<div class="linedetails">
													<div class="clear"></div>
													<cfset lineStatus = application.model.cartHelper.getLineToolTip(variables.iLine) />
													<cfset lineActionDevice = '' />
													<cfset lineActionPlan = '' />
													<cfset lineActionService = '' />
													<cfset lineActionAccessory = '' />
													<cfset lineActionWarranty = '' />

													<cfswitch expression="#variables.lineStatus.nextAction#">
														<cfcase value="device">
															<cfset lineActionDevice = 'next' />
														</cfcase>
														<cfcase value="plan">
															<cfset lineActionPlan = 'next' />
														</cfcase>
														<cfcase value="service">
															<cfset lineActionService = 'next' />
														</cfcase>
														<cfcase value="warranty">
															<cfset lineActionWarranty = 'next' />
														</cfcase>
														<cfcase value="accessory">
															<cfset lineActionAccessory = 'next' />
														</cfcase>
													</cfswitch>

													<div class="device #variables.lineStatus.deviceStatus# #variables.lineActionDevice#">
														<!--- Build device link and title. --->
														<cfif session.cart.getPrepaid()>
															<cfset local.thisBrowseURL = application.view.cart.getLink(lineNumber = variables.iLine, do = 'browsePrePaids') />
														<cfelseif isDataCard>
															<cfset local.thisBrowseURL = application.view.cart.getLink(lineNumber = variables.iLine, do = 'browseDataCardsAndNetbooks') />
														<cfelse>
															<cfset local.thisBrowseURL = application.view.cart.getLink(lineNumber = variables.iLine) />
														</cfif>

														<cfif not variables.thisPhone.hasBeenSelected()>
															<cfset local.thisDo = 'browsePhones' />

															<cfif session.cart.getPrepaid()>
																<cfset local.thisDo = 'browsePrePaids' />
															</cfif>
															
															<cfif variables.thisPlan.hasBeenSelected() && application.model.Plan.getPlanTypeByProductID( variables.thisPlan.getProductId() ) eq 'data'>
																<cfset local.thisDo = 'browseDataCardsAndNetbooks' />
															</cfif>

															<cfset local.thisURL = application.view.cart.getLink(lineNumber = variables.iLine, do = local.thisDo) />

															<cfif variables.lineActionDevice is not 'next'>
																<span class="devicetitle">Device not Selected</span>
															</cfif>

															<a class="actionlink requiredlink" href="#local.thisURL#">Select a Device</a>
														<cfelse>
															<cfset lines = session.cart.getLines() />
															<cfset thisLine = variables.lines[variables.iLine] />
															<cfset thisDevice = variables.thisLine.getPhone() />
															<cfset thisDeviceProductId = variables.thisLine.getPhone().getProductId() />
															<cfset local.images = application.model.imageManager.getImagesForProduct(application.model.product.getProductGuidByProductId(variables.thisDeviceProductId), true) />
															<cfset prodImages = local.images />

															<cfquery name="local.primaryImage" dbtype="query">
																SELECT	*
																FROM	variables.prodImages
																WHERE	IsPrimaryImage = 1
															</cfquery>

															<cfset primaryImageSrc = application.view.imageManager.displayImage(imageGuid = local.primaryImage.imageGuid, height = 0, width = 95) />
															<cfset secondaryImageSrc = application.view.imageManager.displayImage(imageGuid = local.primaryImage.imageGuid, height = 0, width = 45) />
															<cfset local.thisURL = application.view.cart.getLink(lineNumber = variables.iLine, do = 'phoneDetails') />

															<cfif channelConfig.getDirectToRedesignDetailsPage()>
																<cfset local.thisUrl = '/' & listLast( local.thisUrl, '/' ) & '/' & stringUtil.friendlyUrl( variables.selectedPhone.summaryTitle) & '/cartCurrentLine/' & ListGetAt( local.thisUrl, listLen( local.thisUrl, '/' )-2, '/' ) />																
															</cfif>

															<div class="deviceimage">
																<cfif not listLast(trim(variables.primaryImageSrc), '/') is '.jpg'>
																	<a href="#local.thisURL#"><img src="#trim(variables.primaryImageSrc)#" border="0" width="95" /></a>
																</cfif>
															</div>

															<div class="device-area">
																<div>
																	<span class="devicetitle">#trim(variables.selectedPhone.summaryTitle)#</span>
																	<span><a href="#local.thisURL#" class="actionlink">View Device</a></span>
																	&nbsp;
																	<span><a href="#local.thisBrowseURL#" onclick="if(confirm('Are you sure you want to change this device?\n\nNOTE: Changing this device will also remove any service plans and features you may have added to this line.')){ return true; }else{ return false; }" class="actionlink">Change Device</a></span>
																	&nbsp;
																	<span><a href="##" onclick="if(confirm('Are you sure you want to remove this device from your cart?\n\nNOTE: Removing this item will also remove any service plans and features you may have added to this line.')){ColdFusion.navigate('/index.cfm/go/cart/do/removePhone/line/#variables.iLine#/blnDialog/1/', 'dialog_addToCart')};return false;" class="actionlink">Remove Device</a></span>
																</div>

																<cfset local.thisLineBundledAccessories = application.model.cartHelper.lineGetAccessoriesByType(line = variables.iLine, type = 'bundled') />

																<div class="bundledaccesories" #iif(not arrayLen(local.thisLineBundledAccessories), de('style="display: none"'), de(''))#>
																	<span class="title">Bundled Accessories</span>
																	<ul>
																		<cfloop from="1" to="#arrayLen(local.thisLineBundledAccessories)#" index="iAccessory">
																			<cfset thisAccessory = application.model.accessory.getByFilter(idList = local.thisLineBundledAccessories[variables.iAccessory].getProductID()) />
																			<cfset local.thisURL = application.view.cart.getLink(lineNumber = variables.iLine, do = 'accessoryDetails', productID = local.thisLineBundledAccessories[variables.iAccessory].getProductID()) />
																			<li>#trim(variables.thisAccessory.summaryTitle)#</li>
																		</cfloop>
																	</ul>
																</div>
															</div>
														</cfif>
													</div>
													<!--- end device --->

													<div class="clear"></div>

													<cfif (session.cart.getUpgradeType() is 'equipment-only' and arrayLen(variables.thisFeatures) gt 0)>
														<div class="plan">
															<span class="servicestitle">Device Services</span>
															<cfloop from="1" to="#arrayLen(variables.thisFeatures)#" index="local.iFeatures">
																<cfset local.thisItem = application.model.feature.getByProductID(variables.thisFeatures[local.iFeatures].getProductID()) />
																<cfset local.thisItemTitle = trim(local.thisItem.summaryTitle) />
																<ul>
																	<li>#trim(local.thisItemTitle)#</li>
																</ul>
															</cfloop>
														</div>
													<cfelseif (session.cart.getUpgradeType() eq 'equipment-only' and not arrayLen(variables.thisFeatures)) || session.cart.getActivationType() eq 'nocontract' || session.cart.getPrePaid()>
														<!--- non plan line --->
													<cfelseif session.cart.getAddALineType() is 'Family'>
														<cfset lineStatus.planStatus = 'done' />
														<cfset lineActionPlan = '' />
														<cfset lineActionService = 'next' />

														<cfif variables.lineActionDevice is 'next'>
															<cfset lineActionService = '' />
														</cfif>

														<cfif variables.thisPhone.hasBeenSelected()>
															<cfset local.requiredServices = application.model.serviceManager.getDeviceMinimumRequiredServices(ProductId = variables.thisDeviceProductId, CartTypeId = application.model.cart.getCartTypeId(session.cart.getActivationType()), HasSharedPlan = session.cart.getHasSharedPlan() ) />

															<!--- Over ride the next action if services are missing --->
															<cfif application.model.CartHelper.isLineMissingRequiredFeatures( local.requiredServices, variables.thisFeatures  )>
																<cfset variables.lineActionService = 'next' />
																<cfset lineActionWarranty = '' />
															<cfelse>
																<cfset variables.lineActionService = '' />
															</cfif>
														</cfif>


														<!--- get any required services --->
														<cfif variables.thisPhone.hasBeenSelected()>
															<cfscript>
																cartTypeFilters = [];

																// Add exclusive group options if rate plan is unknown for family Add-a-Line.
																if(session.cart.getCarrierId() eq 128 and session.cart.getActivationType() is 'addaline' and session.cart.getAddALineType() is 'FAMILY')	{
																	if(session.cart.getHasUnlimitedPlan() is 'Yes')	{
																		arrayAppend(variables.cartTypeFilters, 7); //Add Unlimited options
																	} else if(session.cart.getHasUnlimitedPlan() is 'No')	{
																		arrayAppend(variables.cartTypeFilters, 8); //Add Non-Unlimited options
																	}
																}
															</cfscript>

															<cfset local.requiredServices = application.model.serviceManager.getDeviceMinimumRequiredServices(variables.thisDeviceProductId, true, variables.cartTypeFilters, application.model.cart.getCartTypeId(session.cart.getActivationType()), iLine, session.cart.getHasSharedPlan() ) />
														</cfif>

														<cfif variables.lineStatus.serviceStatus is 'done' and arrayLen(variables.thisFeatures) eq 0>
															<cfset lineActionService = 'decline' />
														</cfif>

														<div class="services #variables.lineStatus.serviceStatus# #variables.lineActionService#">
															<div>
																<span class="plantitle">Services</span>
															</div>
															<ul>
																<cfif arrayLen(variables.thisFeatures) eq 0>
																	<!--- no services --->
																	<cfset local.thisURL = application.view.cart.getLink(lineNumber = variables.iLine, do = 'services') />
																	<li>
																		<a href="#local.thisURL#" class="actionlink">Select Services for this Line</a>
																		<cfif variables.lineStatus.serviceStatus is not 'done'>
																			|
																			<cfif isDefined('local.requiredServices.recordCount') and local.requiredServices.recordCount gt 0>
																				(Required)
																			<cfelse>
																				<a href="javascript:ColdFusion.navigate('/index.cfm/go/cart/do/declineFeatures/line/#variables.iLine#/blnDialog/true', 'dialog_addToCart');" class="actionlink">No Thanks</a>
																			</cfif>
																		</cfif>
																		<br /><br />
																	</li>
																<cfelse>
																	<cfset local.thisURL = application.view.cart.getLink(lineNumber = variables.iLine, do = 'services') />

																	<cfloop from="1" to="#arrayLen(variables.thisFeatures)#" index="local.iFeatures">
																		<cfset local.serviceProductId = variables.thisFeatures[local.iFeatures].getProductID() />
																		<cfset local.thisItem = application.model.feature.getByProductID(local.serviceProductId) />
																		<cfset local.thisURL = application.view.cart.getLink(lineNumber = variables.iLine, do = 'services') />
																		<li>
																			<cfif not session.cart.getUpgradeType() is 'equipment-only'>
																				<a href="#local.thisURL#">#trim(local.thisItem.summaryTitle)#</a>
																			<cfelse>
																				#trim(local.thisItem.summaryTitle)#
																			</cfif>
																			<cfif session.cart.getUpgradeType() is not 'equipment-only'>

																				<cfset local.thisServiceRequired = false />
																				<cfset local.thisServiceRecommended = false />

																				<cfif session.cart.getUpgradeType() is 'equipment-only'>
																					<cfset local.thisServiceRequired = false />
																				<cfelse>
																					<!--- Check if service is required --->
																					<cfloop query="local.requiredServices">
																						<cfif local.requiredServices.productId eq local.serviceProductId>
																							<cfset local.thisServiceRequired = true />
																							<cfbreak />
																						</cfif>
																					</cfloop>
																					<!--- Check if service is recommended --->
																					<cfif qRecommendedServices.RecordCount>
																						<cfloop query="qRecommendedServices">
																							<cfif qRecommendedServices.productId eq local.serviceProductId>
																								<cfset local.thisServiceRecommended = true />
																								<cfbreak />
																							</cfif>
																						</cfloop>
																					</cfif>
																				</cfif>

																				<cfif local.thisServiceRequired eq true>
																					&nbsp;&nbsp;(Required)
																					<cfif local.thisServiceRecommended AND NOT local.thisitem.hidemessage>
																						&nbsp;&nbsp;
																						<span class="recommended">BEST VALUE</span>
																					</cfif>
																				<cfelse>
																					<a href="##" class="actionlink" onclick="if(confirm('Are you sure you want to remove this feature from this line?')){ColdFusion.navigate('/index.cfm/go/cart/do/removeFeature/line/#variables.iLine#/productID/#local.thisItem.productID#/blnDialog/1/', 'dialog_addToCart')};return false;">Remove this Service</a>
																				</cfif>
																			</cfif>
																		</li>
																	</cfloop>

																	<!--- Check if any required services are missing --->
																	<cfif application.model.CartHelper.isLineMissingRequiredFeatures( local.requiredServices, variables.thisFeatures  )>
																		<li><a href="#local.thisURL#" class="actionlink">Select Services for this Plan</a> (Required)<li>
																	<cfelse>
																		<cfif variables.thisPhone.hasBeenSelected()>
																			<li><a href="#local.thisURL#" class="actionlink">Add more Services</a></li>
																		</cfif>
																	</cfif>
																</cfif>
															</ul>
														</div>
													<cfelse>
														<!--- plan line --->
														<cfif variables.thisPlan.hasBeenSelected()>

															<cfif variables.thisPhone.hasBeenSelected()>
																<cfset selectedServices = application.model.Util.ArrayMerge( variables.thisFeatures, session.cart.getSharedFeatures() ) />
																<cfset local.requiredServices = application.model.serviceManager.getDevicePlanMinimumRequiredServices( DeviceId = variables.thisDeviceProductId, PlanId = variables.thisPlan.getProductId(), CartTypeId = application.model.cart.getCartTypeId(session.cart.getActivationType()), SharedFeatures = session.cart.getSharedFeatures() ) />

																<!--- Over ride the next action if services are missing --->
																<cfif application.model.CartHelper.isLineMissingRequiredFeatures( local.requiredServices, selectedServices  )>
																	<cfset variables.lineActionService = 'next' />
																	<cfset lineActionWarranty = '' />
																</cfif>
															</cfif>

															<cfset local.lineWithPlan = variables.iLine />
															<cfset local.thisURL = application.view.cart.getLink(lineNumber = variables.iLine, do = 'browsePlans') />

															<div class="plan #variables.lineStatus.planStatus# #variables.lineActionPlan#">
																<div>
																	<span class="plantitle">#trim(variables.selectedPlan.summaryTitle)#</span>
																	
																	<cfif ArrayLen(session.cart.getSharedFeatures())>
																		<cfset local.sharedFeatures = session.cart.getSharedFeatures() />
																		#local.sharedFeatures[1].getTitle()# <br />
																	</cfif>
																	
																	<span>
																		<a href="#local.thisURL#" class="actionlink">Change Service Plan</a>
																		&nbsp;
																		<a class="actionlink" href="##" onclick="if(confirm('Are you sure you want to remove this service plan from your cart?\n\nNOTE: Removing this service plan will also remove any associated features you may have added to this line.')){ColdFusion.navigate('/index.cfm/go/cart/do/removePlan/line/#variables.iLine#/blnDialog/1/', 'dialog_addToCart')};return false;"><span>Remove Service Plan</span></a>
																	</span>
																</div>
															</div>

															<cfif variables.lineStatus.serviceStatus is 'done' and arrayLen(variables.thisFeatures) eq 0>
																<cfset lineActionService = 'decline' />
															</cfif>

															<div class="services #variables.lineStatus.serviceStatus# #variables.lineActionService#">
																<cfif variables.lineActionService is not 'next'>
																	<span class="servicestitle">Plan Services</span>
																</cfif>

																<cfif variables.thisPlan.hasBeenSelected() and variables.thisPhone.hasBeenSelected()>
																	<ul>
																		<cfif arrayLen(variables.thisFeatures) eq 0>
																			<!--- no services --->
																			<cfset local.thisURL = application.view.cart.getLink(lineNumber = variables.iLine, do = 'planSelectServices') />

																			<li>
																				<a href="#local.thisURL#" class="actionlink">Select Services for this Plan</a>

																				<cfif variables.lineStatus.serviceStatus is not 'done'>
																					|
																					<cfif local.requiredServices.recordCount gt 0>
																						(Required)
																					<cfelse>
																						<a href="javascript:ColdFusion.navigate('/index.cfm/go/cart/do/declineFeatures/line/#variables.iLine#/blnDialog/true', 'dialog_addToCart');" class="actionlink">No Thanks</a>
																					</cfif>
																				</cfif>
																			</li>
																		<cfelse>
																			<cfset local.thisURL = application.view.cart.getLink(lineNumber = variables.iLine, do = 'planSelectServices') />

																			<cfloop from="1" to="#arrayLen(variables.thisFeatures)#" index="local.iFeatures">
																				<cfset local.serviceProductId = variables.thisFeatures[local.iFeatures].getProductID() />
																				<cfset local.thisItem = application.model.feature.getByProductID(local.serviceProductId) />
																				<cfset local.thisURL = application.view.cart.getLink(lineNumber = variables.iLine, do = 'planSelectServices') />

																				<li>
																					<cfif not session.cart.getUpgradeType() is 'equipment-only'>
																						<a href="#local.thisURL#">#trim(local.thisItem.summaryTitle)#</a>
																					<cfelse>
																						#trim(local.thisItem.summaryTitle)#
																					</cfif>

																					<cfset local.thisServiceRequired = false />
																					<cfset local.thisServiceRecommended = false />
																					<cfif session.cart.getUpgradeType() is 'equipment-only'>
																						<cfset local.thisServiceRequired = false />
																					<cfelse>
																						<!--- Check if service is required --->
																						<cfloop query="local.requiredServices">
																							<cfif local.requiredServices.productId eq local.serviceProductId>
																								<cfset local.thisServiceRequired = true />
																								<cfbreak />
																							</cfif>
																						</cfloop>
																						<!--- Check if service is recommended --->
																						<cfif qRecommendedServices.RecordCount>
																							<cfloop query="qRecommendedServices">
																								<cfif qRecommendedServices.productId eq local.serviceProductId>
																									<cfset local.thisServiceRecommended = true />
																									<cfbreak />
																								</cfif>
																							</cfloop>
																						</cfif>
																					</cfif>

																					<cfif local.thisServiceRequired eq true>
																						&nbsp;&nbsp;(Required)
																						<cfif local.thisServiceRecommended AND NOT local.thisitem.hidemessage>
																							&nbsp;&nbsp;
																							<span class="recommended">BEST VALUE</span>
																						</cfif>
																					<cfelse>
																						&nbsp;&nbsp;<a href="##" class="actionlink" onclick="if(confirm('Are you sure you want to remove this feature from this line?')){ColdFusion.navigate('/index.cfm/go/cart/do/removeFeature/line/#variables.iLine#/productID/#local.thisItem.productID#/blnDialog/1/', 'dialog_addToCart')};return false;">Remove this Service</a>
																						<cfif local.thisServiceRecommended AND NOT local.thisitem.hidemessage>
																							&nbsp;&nbsp;
																							<span class="recommended">BEST VALUE</span>
																						</cfif>
																					</cfif>
																				</li>
																			</cfloop>

																			<!--- Check if any required services are missing --->
																			<cfif application.model.CartHelper.isLineMissingRequiredFeatures( local.requiredServices, selectedServices )>
																				<li><a href="#local.thisURL#" class="actionlink">Select Services for this Plan</a> (Required)<li>
																			<cfelse>
																				<cfif variables.thisPlan.hasBeenSelected() and variables.thisPhone.hasBeenSelected()>
																					<li><a href="#local.thisURL#" class="actionlink">Add more Services</a></li>
																				</cfif>
																			</cfif>
																		</cfif>
																	</ul>
																<cfelse>
																	<ul>
																		<cfif not variables.thisPhone.hasBeenSelected()>
																			<cfset local.thisURL = application.view.cart.getLink(lineNumber = variables.iLine, do = local.thisDo) />
																			Please <a href="#local.thisURL#">select a device</a> before choosing services.
																		</cfif>
																	</ul>
																</cfif>
															</div>
														<cfelse>
															<cfset local.thisURL = application.view.cart.getLink(lineNumber = variables.iLine, do = 'browsePlans') />

															<div class="plan #variables.lineStatus.planStatus# #variables.lineActionPlan#">
																<cfif variables.lineActionPlan is not 'next'>
																	<span class="plantitle">Service Plan not Selected</span>
																</cfif>
																<a class="planName actionlink requiredlink" href="#local.thisURL#">Choose a Service Plan</a>
															</div>
														</cfif>
													</cfif>
													<!--- end plan --->

													<!--- Start of warranties --->	
													<cfif thisLine.getDeclineWarranty()>
														<cfset variables.lineStatus.warrantyStatus = 'done' />
														<cfset lineActionWarranty = 'decline' />
														<cfset lineActionWarranty = '' />
													</cfif>
													<cfif variables.lineStatus.warrantyStatus eq 'done' and !variables.thisWarranty.hasBeenSelected()>
														<cfset lineActionWarranty = 'decline' />
														
													<cfelse>
														<cfif variables.lineStatus.warrantyStatus eq 'done'>
															<cfset lineActionWarranty = '' />
														</cfif>
													</cfif>

													<cfif channelConfig.getOfferWarrantyPlan() 
														&& variables.thisPhone.hasBeenSelected() 
														&& variables.thisPhone.getDeviceServiceType() neq 'MobileBroadband'
														&& (session.cart.getPrepaid() IMP channelConfig.getOfferPrepaidDeviceWarrantyPlan()) >
														
		
														<div class="warranty #variables.lineStatus.warrantyStatus# #variables.lineActionWarranty#">
															<span class="warrantytitle">#textDisplayRenderer.getCartDialogWarrantyTitle()#</span>
															
															<ul class="list">
																<!---<cfif not variables.thisWarranty.hasBeenSelected()>--->
																	<cfset local.IsCompatibleWarrantyAvailable = false />
																	
																	<cfif channelConfig.getDefaultWarrantyPlanId() neq ''>
																		<cfset local.thisURL = '/index.cfm/go/shop/do/warrantyDetails/cartCurrentLine/#variables.iLine#/productId/#channelConfig.getDefaultWarrantyPlanId()#' />
																		<cfset local.IsCompatibleWarrantyAvailable = true />
																	<cfelse>
																		<cfset qWarranty = application.model.Warranty.getByDeviceId( variables.thisPhone.getProductId() ) />
																		<cfif qWarranty.RecordCount>
																			<cfset local.thisURL = '/index.cfm/go/shop/do/warrantyDetails/cartCurrentLine/#variables.iLine#/productId/#qWarranty.ProductId#' />
																			<cfset local.IsCompatibleWarrantyAvailable = true />
																		</cfif>
																	</cfif>
																	<li>
																		<cfif local.IsCompatibleWarrantyAvailable>
																			<cfif channelConfig.getDisplayWarrantyDetailInCart()>
																				<cfloop query="qWarranty">
																					<cfset local.thisURL = '/index.cfm/go/shop/do/warrantyDetails/cartCurrentLine/#variables.iLine#/productId/#qWarranty.ProductId#' />
																					<cfset local.warrantySelected = "" />
																					<cfif thisWarranty.getProductId() is qwarranty.productid>
																						<cfset local.warrantySelected = 'checked="checked"' />
																					</cfif>
																					<cfset local.onClickAction = "addToCart('warranty','#qwarranty.productId#',1,1,#variables.iLine#);return false;" />	
																					<!---<cfset local.onClickAction = "javascript:ColdFusion.navigate('/index.cfm/go/cart/do/addItem/line/#variables.iLine#/productType/warranty/product_id/#variables.thisWarranty.getProductId()#/blnDialog/true/', 'dialog_addToCart')" />--->																				
																					<label for="AddProtectionPlan_#qwarranty.productId#"><input type="radio" id="AddProtectionPlan_#qwarranty.productId#" name="AddProtectionPlan_Line_#variables.iLine#" value="#qwarranty.productId#" class="actionLink" onclick="#local.onClickAction#" #local.warrantySelected#><a href="#local.thisURL#" class="actionlink">#qWarranty.SummaryTitle#</a> (#dollarformat(qWarranty.price)#)</label><cfif findNoCase("Apple",qWarranty.SummaryTitle)><span class="actionLink" style="color:##009900;"> - Recommended</span></cfif><br/>																						
																				</cfloop>
																				<cfif variables.lineStatus.warrantyStatus eq 'done' >	
																					<cfif thisWarranty.getProductId()>
																						<cfset local.NoThanksSelected = "" />
																						<cfset local.NoThanksClickAction =	"javascript:ColdFusion.navigate('/index.cfm/go/cart/do/removeAndDeclineWarranty/line/#variables.iLine#/productID/#variables.thisWarranty.getProductId()#/blnDialog/true/', 'dialog_addToCart')" />
																					<cfelse>
																						<cfset local.NoThanksSelected = "checked='checked'" />
																						<cfset local.NoThanksClickAction =	"javascript:ColdFusion.navigate('/index.cfm/go/cart/do/removeWarranty/line/#variables.iLine#/productID/#variables.thisWarranty.getProductId()#/blnDialog/true/', 'dialog_addToCart')" />
																					</cfif>										
																				<cfelse>
																					<cfset local.NoThanksSelected = "" />
																					<cfset local.NoThanksClickAction =	"javascript:ColdFusion.navigate('/index.cfm/go/cart/do/declineWarranty/line/#variables.iLine#/blnDialog/true', 'dialog_addToCart');" />
																				</cfif>
																				<input type="radio" name="AddProtectionPlan" value="0" class="actionLink" onclick="#local.NoThanksClickAction#"#local.NoThanksSelected#><span class="radioText">No Thanks</span><br/>
																			<cfelse>
																				<a href="#local.thisURL#" class="actionlink">Add Protection Plan</a>
																			</cfif>
																		<cfelse>
																			<cfset application.model.cartHelper.declineWarranty(variables.iLine) />
																			Not Available
																		</cfif>
																		
																		<cfif variables.lineStatus.warrantyStatus neq 'done' and channelConfig.getDisplayWarrantyDetailInCart() is false>																			|
																			<a href="javascript:ColdFusion.navigate('/index.cfm/go/cart/do/declineWarranty/line/#variables.iLine#/blnDialog/true', 'dialog_addToCart');" class="actionlink">No Thanks</a>
																		</cfif>
																	</li>
																	
																	<cfif not variables.thisWarranty.hasBeenSelected() and not channelConfig.getDisplayWarrantyDetailInCart()>
																		<li>#trim(variables.thisWarranty.getTitle())#<br /><a class="actionlink" href="##" onclick="if(confirm('Are you sure you want to remove the Device Protection Service from this line?')){ColdFusion.navigate('/index.cfm/go/cart/do/removeWarranty/line/#variables.iLine#/productID/#variables.thisWarranty.getProductId()#/blnDialog/1/', 'dialog_addToCart')};return false;"><span>Remove from Cart</span></a></li>
																	</cfif>
																	
																<!---<cfelse>
																	<li>#trim(variables.thisWarranty.getTitle())#<br /><a class="actionlink" href="##" onclick="if(confirm('Are you sure you want to remove the Device Protection Service from this line?')){ColdFusion.navigate('/index.cfm/go/cart/do/removeWarranty/line/#variables.iLine#/productID/#variables.thisWarranty.getProductId()#/blnDialog/1/', 'dialog_addToCart')};return false;"><span>Remove from Cart</span></a></li>
																</cfif>--->
															</ul>
														</div>
														</cfif>
														<!--- End of Warranties --->
															
													<!--- Start of Accessories --->
													<cfif variables.lineStatus.accessoryStatus is 'done' and arrayLen(variables.thisAccessories) eq 0>
														<cfset lineActionAccessory = 'decline' />
													<cfelse>
														<cfif variables.lineStatus.accessoryStatus is 'done'>
															<cfset lineActionAccessory = '' />
														</cfif>
													</cfif>

													<div class="accessories #variables.lineStatus.accessoryStatus# #variables.lineActionAccessory#">
														<span class="accessorytitle">Device Accessories</span>
														<cfset local.thisURL = application.view.cart.getLink(lineNumber = variables.iLine, do = 'browseAccessories') />
														<ul class="list">
															<cfif not arrayLen(variables.thisAccessories)>
																<cfset local.thisURL = application.view.cart.getLink(lineNumber = variables.iLine, do = 'browseAccessories') />
																<li>
																	<a href="#local.thisURL#" class="actionlink">Add Accessories</a>
																	<cfif variables.lineStatus.accessoryStatus is not 'done'>
																		|
																		<a href="javascript:ColdFusion.navigate('/index.cfm/go/cart/do/declineAccessories/line/#variables.iLine#/blnDialog/true', 'dialog_addToCart');" class="actionlink">No Thanks</a>
																	</cfif>
																</li>
															<cfelse>
																<cfloop from="1" to="#arrayLen(variables.thisAccessories)#" index="iAccessory">
																	<cfset thisAccessory = application.model.accessory.getByFilter(idList = variables.thisAccessories[variables.iAccessory].getProductID()) />
																	<li>#trim(variables.thisAccessory.summaryTitle)#<br /><a class="actionlink" href="##" onclick="if(confirm('Are you sure you want to remove this accessory from this line?')){ColdFusion.navigate('/index.cfm/go/cart/do/removeAccessory/line/#variables.iLine#/productID/#variables.thisAccessory.product_id#/blnDialog/1/', 'dialog_addToCart')};return false;"><span>Remove from Cart</span></a></li>
																</cfloop>

																<cfset local.thisURL = application.view.cart.getLink(lineNumber = variables.iLine, do = 'browseAccessories') />
																<li><a href="#local.thisURL#" class="actionlink">Add more Accessories</a></li>
															</cfif>
														</ul>
													</div>
													<!--- end device accessories --->
														
															
															
															
													
													
													<div id="secondaryImage#variables.iLine#" class="hidden">
														<cfif not listLast(trim(variables.secondaryImageSrc), '/') is '.jpg'>
															<img src="#trim(variables.secondaryImageSrc)#" border="0" />
															<span class="tabLabel">Line #variables.iLine#</span>
															<img class="progressbar" src="#assetPaths.common#images/ui/cartdialog/2/progress#variables.lineStatus.percent#.gif" border="0" />
														<cfelse>
															<span class="tabLabel" style="padding-left: 28px">Line #variables.iLine#</span>
															<span style="padding-left: 28px"><img class="progressbar" src="#assetPaths.common#images/ui/cartdialog/2/progress#variables.lineStatus.percent#.gif" border="0" /></span>
														</cfif>
													</div>
												</div>
											</div>
											<div class="linefooter">
												<span><a href="##"onclick="if(confirm('Are you sure you want to delete this line?')){ColdFusion.navigate('/index.cfm/go/cart/do/deleteLine/line/#variables.iLine#/blnDialog/1/', 'dialog_addToCart')};return false;" class="actionlink">Remove this Line</a></span>
											</div>
										</div>
									</div>
								</div>
							</cfloop>
							<!--- end line --->

							<cfif arrayLen(session.cart.getLines()) lt request.config.maxLines>
								<div id="tAdd" class="my_tab">
									<div>Add a line</div>
								</div>
							</cfif>

							<div id="secondaryImageAddLine" class="hidden">
								<img src="#assetPaths.common#images/ui/cartdialog/2/adddevice.gif" border="0" />
								<span class="tabLabel">Add a Line</span>
							</div>

							<!--- Detect if the accessory tab is active. --->
							<cfif session.cart.getCurrentLine() eq 999>
								<cfset active = 'true' />
							<cfelse>
								<cfset active = '' />
							</cfif>

							<div id="tab999" class="my_tab" active="#variables.active#">
								<div class="content-bg">
									<div class="content">
										<div class="scrollarea">
											<cfset iLine = request.config.otherItemsLineNumber />
											<cfset thisAccessories = session.cart.getOtherItems() />

											<div class="content-bg">
												<div class="content">
													<cfset thisPrepaids = application.model.cartHelper.lineGetAccessoriesByType(line = request.config.otherItemsLineNumber, type = 'prepaid') />

													<cfif arrayLen(variables.thisPrepaids)>
														<ul class="accessoryNames">
															<cfif not arrayLen(variables.thisPrepaids)>
																<cfset local.thisURL = '/index.cfm/go/shop/do/browsePrePaids/prePaidFilter.submit/1/filter.planType/new/' />
																<li><a href="#local.thisURL#" class="actionlink">Add a Prepaid Phone</a></li>
															<cfelse>
																<cfloop from="1" to="#arrayLen(variables.thisPrepaids)#" index="iPrepaid">
																	<cfset thisPrepaid = application.model.prePaid.getByFilter(idList = variables.thisPrepaids[variables.iPrepaid].getProductID()) />
																	<cfset local.images = application.model.imageManager.getImagesForProduct(application.model.product.getProductGuidByProductId(variables.thisPrepaids[variables.iPrepaid].getProductID()), true) />
																	<cfset prodImages = local.images />

																	<cfquery name="local.primaryImage" dbtype="query">
																		SELECT	*
																		FROM	variables.prodImages
																		WHERE	IsPrimaryImage = 1
																	</cfquery>

																	<cfset primaryImageSrc = application.view.imageManager.displayImage(imageGuid = local.primaryImage.imageGuid, height = 0, width = 95) />
																	<cfset local.thisURL = '/index.cfm/go/shop/do/prepaidDetails/productId/#variables.thisPrepaids[variables.iPrepaid].getProductID()#' />
																	<li>#trim(variables.thisPrepaid.summaryTitle)#<br /><a class="removeItem" href="##" onclick="if(confirm('Are you sure you want to remove this prepaid phone from this line?')){ColdFusion.navigate('/index.cfm/go/cart/do/removeAccessory/line/#variables.iLine#/productID/#variables.thisPrepaid.product_id#/blnDialog/1/', 'dialog_addToCart')};return false;"><span>Remove from Cart</span></a></li>
																</cfloop>

																<cfset local.thisURL = '/index.cfm/go/shop/do/browsePrePaids/prePaidFilter.submit/1/filter.planType/new/' />
																	<li><a href="#local.thisURL#" class="actionlink">Add more Prepaid Phones</a></li>
																</cfif>
															</cfif>
														</ul>

														<!--- other accessories --->
														<cfset thisAccessories = application.model.cartHelper.lineGetAccessoriesByType(line = request.config.otherItemsLineNumber, type = 'accessory') />
														<cfset local.thisURL = application.view.cart.getLink(lineNumber = variables.iLine, do = 'browseAccessories')>
														<ul id="otherAccessories">
															<cfif not arrayLen(variables.thisAccessories)>
																<cfset local.thisURL = application.view.cart.getLink(lineNumber = variables.iLine, do = 'browseAccessories') />
																<li><a href="#local.thisURL#/cartCurrentLine/999" class="actionlink">Add Accessories</a></li>
															<cfelse>
																<cfloop from="1" to="#arrayLen(variables.thisAccessories)#" index="iAccessory">
																	<cfset thisAccessory = application.model.accessory.getByFilter(idList = variables.thisAccessories[variables.iAccessory].getProductID()) />
																	<cfset local.images = application.model.imageManager.getImagesForProduct(application.model.product.getProductGuidByProductId(variables.thisAccessories[variables.iAccessory].getProductID()), true) />
																	<cfset prodImages = local.images />

																	<cfquery name="local.primaryImage" dbtype="query">
																		SELECT	*
																		FROM	variables.prodImages
																	</cfquery>

																	<cfset primaryImageSrc = application.view.imageManager.displayImage(imageGuid = local.primaryImage.imageGuid, height = 0, width = 60) />
																	<cfset local.thisURL = application.view.cart.getLink(lineNumber = variables.iLine, do = 'accessoryDetails', productID = variables.thisAccessories[variables.iAccessory].getProductID()) />
																	<li>
																		<table>
																			<tr>
																				<td valign="top"><img src="#trim(variables.primaryImageSrc)#" /></td>
																				<td valign="top" style="margin-top: 5px">
																					#trim(variables.thisAccessory.summaryTitle)#
																					<br />
																					<a class="actionlink" href="##" onclick="if(confirm('Are you sure you want to remove this accessory from this line?')){ColdFusion.navigate('/index.cfm/go/cart/do/removeAccessory/line/#variables.iLine#/productID/#variables.thisAccessory.product_id#/blnDialog/1/', 'dialog_addToCart')};return false;"><span>Remove from Cart</span></a>
																				</td>
																			</tr>
																		</table>
																	</li>
																</cfloop>

																<cfset local.thisURL = application.view.cart.getLink(lineNumber = variables.iLine, do = 'browseAccessories') />
																<li><a href="#local.thisURL#/cartCurrentLine/999" class="actionlink">Add more Accessories</a></li>
															</cfif>
														</ul>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
								<div id="secondaryAccessories" class="hidden" active="#variables.active#">
									<span class="tabLabelAccessories">Accessories</span>
									<span class="tabAccessoriesCount">( #arrayLen(session.cart.getOtherItems())# )</span>
								</div>
							</cfoutput>
						</div>
					</div>
				</div>
			</cfform>
		</cfoutput>
	</cf_cartbody>
