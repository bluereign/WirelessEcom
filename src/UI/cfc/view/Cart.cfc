<cfcomponent output="false" displayname="Cart">

	<cffunction name="init" access="public" returntype="Cart" output="false">
		<!--- Remove this when this component is added to CS --->
        <cfset setAssetPaths( application.wirebox.getInstance("assetPaths") ) />
		<cfset setChannelConfig( application.wirebox.getInstance("ChannelConfig") ) />
		<cfset setStringUtil( application.wirebox.getInstance("StringUtil") ) />
		<cfreturn this />
	</cffunction>


	<cffunction name="view" access="public" returntype="string" output="false">
		<cfargument name="isEditable" required="false" type="boolean" default="true" />

		<cfset var local = {} />
		
		<cfif application.model.cartHelper.hasSelectedFeatures()>
			<cfset qRecommendedServices = application.model.ServiceManager.getRecommendedServices() />
		</cfif>

		<cfset session.cart.updateAllPrices() />
		<cfset session.cart.updateAllDiscounts() />
		<cfset session.cart.updateAllTaxes() />

		<cfsavecontent variable="local.html">
			<style type="text/css">
				div.rounded-box {
					border: 2px solid #808080;
					padding-top: 10px;
					padding-bottom: 10px;
					margin-bottom: 15px;
					/* CSS3 For Various Browsers*/
				    border-radius: 5px;
				}

				div.title-band {
					height: 25px;
					border-width: 2px 0px 2px 0px;
					border-style: solid;
					border-color: grey; /*#0263AB;*/
					margin-top: 5px;
					font-size: 1.3em;
					font-weight: bold;
					background-color: #ccc;
					padding: 5px 25px 5px 10px;
				}

				div.image-container {
					float: left;
					width: 145px;
					padding: 10px;
					text-align: center;
				}

				div.image-container img {
					margin-bottom: 10px;
				}

				div.no-image {
					width: 100%;
				}

				div.with-image {
					float: right;
					width: 680px;
				}

				.pricing {
					width: 100%;
					border-collapse: collapse;
					border: 0 px;
					border-color: #ddd;
					border-style: none;
					text-align: left;
					font-size: 1.1em;
					margin-bottom: 10px;
				}

				td.item-col {
					text-align: left;
					font-size: 1.0em;
					background-color: #fff;
					border: 1px;
					border-color: #999;
					border-bottom-style: none;
					border-left-style: none;
					border-top-style: none;
					border-right-style: none;
					padding-left: 10px;
					list-style-type: disc;
				}

				td.price-col {
					width: 90px;
					text-align: center;
					font-size: 1.0em;
					border: 1px;
					border-color: #999;
					border-right-style: none;
					border-left-style: solid;
					border-top-style: none;
					border-bottom-style: none;
				}

				td.price-header-col {
					width: 90px;
					text-align: center;
					font-size: 1.0em;
					font-weight: bold;
					border: 1px;
					border-color: #999;
					border-top-style: none;
					border-bottom-style: solid;
					border-left-style: solid;
				}


				td.total-col {
					background-color: #C3D9FF;
					font-weight: bold;
					border: 1px;
					border-color: #999;
					border-top-style: solid;
					border-left-style: solid;
					border-bottom-style: solid;
					font-size: 1.1em;
				}

				td.error-col {
					background-color: #FFBABA;
					font-weight: bold;
					border: 2px;
					border-color: #D8000C;
					border-top-style: solid;
					border-left-style: solid;
					border-right-style: solid;
					border-bottom-style: solid;
					font-size: 1.1em;
				}

				span.item {
					font-size: 1.2em;
				}

				span.item-detail {
					padding-left: 30px;
				}

				sup.cartReview {
					font-size: 1.1em;
					padding:0px;
				}

				span.callout {
					color: #FF0000;
					font-weight: bold;
				}
			</style>

		<div class="cartReview">
			<cfif structKeyExists(session, 'cart') and isStruct(session.cart)>
				<cfoutput>
					<cfparam name="request.bCartSaved" type="boolean" default="false" />
					<cfparam name="request.bCartLoaded" type="boolean" default="false" />
					<cfparam name="local.deviceGuidList" type="string" default="" />

					<cfif arguments.isEditable>
						<script type="text/javascript" language="javascript" src="#getAssetPaths().common#scripts/planFeatureWindow.js"></script>

						<h1>Cart Review</h1>
					</cfif>

					<cfif request.bCartSaved>
						<div class="cartReviewMessage">Your cart data has been saved.<br /><br /></div>
					<cfelseif request.bCartLoaded>
						<div class="cartReviewMessage">Your cart data has been retrieved.<br /><br /></div>
					</cfif>
					
					<cfif structKeyExists( session, "PromoResult" )>
						<div class="cartReviewMessage">#session.PromoResult.getMessage()#</div>
						<cfset structDelete( session, "PromoResult" )>
					</cfif>
					
					<cfif arguments.isEditable>
						<div id="response"></div>
						<div id="reviewZip">
							<div class="zipHeader">
								<cfif application.model.cartHelper.zipCodeEntered()>
									<label>Your Zip Code:</label>
									<span class="readOnlyZip" style="font-weight: bold">#trim(session.cart.getZipCode())#&nbsp;</span>
								</cfif>
							</div>
						</div>

						<cfset local.saveButtonAction = "alert('You must create a user account or login in order to save your cart.');" />

						<cfif session.UserAuth.isLoggedIn()>
							<cfset local.saveButtonAction = "location.href='/index.cfm/go/cart/do/saveCart/';" />
						</cfif>

						<!---- Cart Control Buttons --->
						<cfsavecontent variable="local.cartButtons">
							<div class="cartControls" style="margin-bottom:10px; overflow:hidden;">
								<div class="controlsLeft" style="float:left;">
									<span class="actionButtonLow">
										<a href="##" onclick="var ok=confirm('Are you sure you want to clear your cart?'); if(ok){ location.href='/index.cfm/go/cart/do/clearCart/blnDialog/0/'; }">Clear your Cart</a>
									</span>
									<span class="actionButtonLow">
										<a href="/index.cfm">Continue Shopping</a>
									</span>
								</div>
								<div class="controlsRight" style="float:right;">
									<cfif session.cart.getActivationType() CONTAINS 'upgrade' && session.cart.getCarrierCode() neq '' && request.CheckoutRedesignControl.Upgrade.Carrier['#session.cart.getCarrierCode()#']>
										<!--- Checkout Redesign --->
										<a class="ActionButton" href="/checkout/doStartCheckout/"><span>Checkout</span></a>
									<cfelse>
										<a class="ActionButton" href="/index.cfm/go/checkout/do/startCheckout/"><span>Checkout</span></a>
									</cfif>
								</div>
							</div>
						</cfsavecontent>

						#trim(local.cartButtons)#
					</cfif>

					<cfset local.cartLines = session.cart.getLines() />

					<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.iCartLine">
						<cfset local.cartLine = local.cartLines[local.iCartLine] />
						<cfset local.imageUrls = [] />
						<cfset local.showAddServiceButton = false />

						<div class="rounded-box">
							<div class="title-band">
								Wireless Device ###local.iCartLine#

								<cfif arguments.isEditable>
									<span class="actionButtonLow">
										<a href="##" onclick="viewCart(); return false;">Change</a>
									</span>
								</cfif>
							</div>
							<div>
								<cfif local.cartLine.getPhone().hasBeenSelected()>
									<cfset local.selectedPhone = application.model.phone.getByFilter(idList = local.cartLine.getPhone().getProductID(), allowHidden = true) />

									<cfif not local.selectedPhone.recordCount>
										<cfset local.selectedPhone = application.model.tablet.getByFilter(idList = local.cartLine.getPhone().getProductID()) />
									</cfif>
									
									<cfif not local.selectedPhone.recordCount>
										<cfset local.selectedPhone = application.model.dataCardAndNetbook.getByFilter(idList = local.cartLine.getPhone().getProductID()) />
									</cfif>

									<cfif not local.selectedPhone.recordCount>
										<cfset local.selectedPhone = application.model.prePaid.getByFilter(idList = local.cartLine.getPhone().getProductID()) />
									</cfif>

									<cfset local.deviceGuidList = listAppend(local.deviceGuidList, local.selectedPhone.deviceGuid) />
									<cfset local.stcPrimaryImage = application.model.imageManager.getPrimaryImagesForProducts(local.selectedPhone.deviceGuid) />

									<cfif structKeyExists(local.stcPrimaryImage, local.selectedPhone.deviceGuid)>
										<cfset imageDetail = {
												src = application.view.imageManager.displayImage(imageGuid = local.stcPrimaryImage[local.selectedPhone.deviceGuid], height = 0, width = 130)
												, alt = htmlEditFormat(local.selectedPhone.summaryTitle)
												, width = 130
										} />
									<cfelse>
										<cfset imageDetail = {
											src = '#getAssetPaths().common#images/catalog/noimage.jpg'
											, alt = htmlEditFormat(local.selectedPhone.summaryTitle)
											, width = 130
										} />
									</cfif>
									<cfset arrayAppend(local.imageUrls, imageDetail) />
								</cfif>

								<div class="<cfif arguments.isEditable>with-image<cfelse>no-image</cfif>">
									<table class="pricing">
										<tr>
											<td style="border-top-style: none; border-left-style: none; background-color: ##fff"></td>
											<td class="price-header-col">Due Today</td>
											<td class="price-header-col">Monthly</td>
										</tr>

										<cfif local.cartLine.getPhone().hasBeenSelected()>
											<tr>
												<td class="item-col">
													<cfif arguments.isEditable>
														<cfset local.linkDetails = getLink(lineNumber = local.iCartLine, do = 'phoneDetails') />
														<cfif getChannelConfig().getDirectToRedesignDetailsPage()>
															<cfset local.linkDetails = "/" & listLast( local.linkDetails, '/' ) & '/' & getStringUtil().friendlyUrl( local.selectedPhone.summaryTitle) & '/cartCurrentLine/' & ListGetAt( local.linkDetails, listLen( local.linkDetails, '/' )-2, '/' ) />																
														</cfif>
														Device: <a href="#local.linkDetails#">#local.selectedPhone.summaryTitle#</a>
													<cfelse>
														Device: #local.selectedPhone.summaryTitle#
													</cfif>
													
												</td>
												<td class="price-col">
													<cfif session.cart.getActivationType() contains "financed">
														$0.00
													<cfelse>
														#dollarFormat(local.selectedPhone.price_retail)#													
													</cfif>	
													
													</td>
												<td class="price-col"></td>
											</tr>
											<cfif session.cart.getActivationType() DOES NOT CONTAIN "financed">
												<tr>
													<td class="item-col"><span class="item-detail">Online Discount</span></td>
													<td class="price-col"><span class="callout">-#dollarFormat(val(local.selectedPhone.price_retail) - val(local.cartLine.getPhone().getPrices().getDueToday()))#</td>
													<td class="price-col"></td>
												</tr>
											</cfif>
										<cfelse>
											<cfset local.thisDo = 'browsePhones' />
											<cfif session.cart.getPrepaid()>
												<cfset local.thisDo = 'browsePrePaids' />
											</cfif>
											<cfset local.linkChange = getLink(lineNumber = local.iCartLine, do = local.thisDo) />
											<tr>
												<td class="error-col">
													Please select a device for this line.<br /><a class="hideWhenPrinted" href="#local.linkChange#">Browse Phones</a>
												</td>
												<td class="price-col"></td>
												<td class="price-col"></td>
											</tr>
										</cfif>

										<cfset local.thisLineBundledAccessories = application.model.cartHelper.lineGetAccessoriesByType(line = local.iCartLine, type = 'bundled') />

										<cfif arrayLen(local.thisLineBundledAccessories)>
											<cfloop from="1" to="#arrayLen(local.thisLineBundledAccessories)#" index="local.iAccessory">
												<cfset local.thisAccessory = local.thisLineBundledAccessories[local.iAccessory] />
												<cfset local.selectedAccessory = application.model.accessory.getByFilter(idList = local.thisAccessory.getProductID()) />
												<cfset local.stcPrimaryImage = application.model.imageManager.getPrimaryImagesForProducts(local.selectedAccessory.accessoryGuid) />
												<cfset local.deviceGuidList = listAppend(local.deviceGuidList, local.selectedAccessory.accessoryGuid) />


												<cfif structKeyExists(local.stcPrimaryImage, local.selectedAccessory.accessoryGuid)>
													<cfset imageDetail = {
															src = application.view.imageManager.displayImage(imageGuid = local.stcPrimaryImage[local.selectedAccessory.accessoryGuid], height = 0, width = 75)
															, alt = htmlEditFormat(local.selectedAccessory.summaryTitle)
															, width = 75
													} />
												<cfelse>
													<cfset imageDetail = {
														src = '#getAssetPaths().common#images/catalog/noimage.jpg'
														, alt = htmlEditFormat(local.selectedAccessory.summaryTitle)
														, width = 75
													} />
												</cfif>
												<cfset arrayAppend(local.imageUrls, imageDetail) />


												<tr>
													<td  class="item-col">
														<cfif arguments.isEditable>
															<cfset local.linkDetails = getLink(lineNumber = local.iCartLine, productId = local.thisAccessory.getProductId(), do = 'accessoryDetails') />
															<span class="item-detail">Accessory: <a href="#local.linkDetails#">#local.selectedAccessory.summaryTitle#</a></span>
														<cfelse>
															<span class="item-detail">Accessory: #local.selectedAccessory.summaryTitle#</span>
														</cfif>
													</td>
													<td class="price-col"><cfif local.thisAccessory.getPrices().getDueToday() EQ 0><span class="callout">FREE</span></cfif></td>
													<td class="price-col"></td>
												</tr>
											</cfloop>
										</cfif>

										<cfif session.cart.getUpgradeType() neq 'equipment-only' && not session.cart.getPrePaid() && session.cart.getAddALineType() neq 'family' && session.cart.getActivationType() neq 'nocontract'>

											<tr>
												<cfif local.cartLine.getPlan().hasBeenSelected()>
													<cfset local.selectedPlan = application.model.plan.getByFilter(idList = local.cartLine.getPlan().getProductID()) />
													<cfset local.deviceGuidList = listAppend(local.deviceGuidList, local.selectedPlan.productGuid) />

													<td class="item-col">
														<cfif arguments.isEditable>
															<cfset local.linkDetails = getLink(lineNumber = local.iCartLine, do = 'planSelectServices') />
															Plan: <a href="#local.linkDetails#">#local.selectedPlan.carrierName# - #local.selectedPlan.summaryTitle#</a>
														<cfelse>
															Plan: #local.selectedPlan.carrierName# - #local.selectedPlan.summaryTitle#
														</cfif>
													</td>

													<cfif session.cart.hasCart() and listFindNoCase('299, 128', session.cart.getCarrierId()) and (session.cart.getAddALineType() is 'Ind' or session.cart.getAddALineType() is 'Family')>
														<td class="price-col">TBD <sup class="cartReview"><a href="##footnote5">6</a></sup></td>
													<cfelse>
														<td class="price-col"></td>
													</cfif>

													<cfif session.cart.hasCart() and listFindNoCase('299, 128', session.cart.getCarrierId()) and (session.cart.getAddALineType() is 'Ind' or session.cart.getAddALineType() is 'Family')>
														<td class="price-col">TBD <sup class="cartReview"><a href="##footnote5">6</a></td>
													<cfelse>
														<cfif DecimalFormat(local.cartLine.getPlan().getPrices().getMonthly()) eq 0>
															<td class="price-col"></td>
														<cfelse>
															<td class="price-col">#dollarFormat(local.cartLine.getPlan().getPrices().getMonthly())#</td>
														</cfif>
													</cfif>
												<cfelse>
													<cfset local.linkChange = getLink(lineNumber = local.iCartLine, do = 'browsePlans') />

													<td class="error-col">Please select a service plan for this line.<br /><a class="hideWhenPrinted" href="#local.linkChange#">Browse Service Plans</a></td>
													<td class="price-col"></td>
													<td class="price-col"></td>
												</cfif>
											</tr>


											<cfif local.iCartLine eq 1 && ArrayLen( session.cart.getSharedFeatures() )>
												<cfloop array="#session.cart.getSharedFeatures()#" index="cartItem" >
													<cfset qFeature = application.model.feature.getByProductID( cartItem.getProductId() ) />
													<cfif NOT findNoCase("Family",qFeature.summaryTitle)>
													<tr>
														<td class="item-col">
															<span class="item-detail">
																<cfif arguments.isEditable>
																	<a href="##" class="serviceDescription" onclick="viewServiceDescription(#cartItem.getProductId()#);return false;">#qFeature.summaryTitle#</a>
																<cfelse>
																	#qFeature.summaryTitle#
																</cfif>
															</span>
														</td>
														<td class="price-col"></td>
														<td class="price-col">#dollarFormat(qFeature.Price)#</td>
													</tr>
													</cfif>
												</cfloop>
											</cfif>

											<!--- moving hard-coded upgrade fees to carrier component and calling them from here  --->
											<cfset local.carrierObj = application.wirebox.getInstance("Carrier") />

											<cfif local.cartLine.getPlan().hasBeenSelected()>
												<!---- Upgrades do not have the activation fee waived --->
												<cfif session.cart.getActivationType() CONTAINS 'upgrade'>
													
													<cfset local.upgradeFee = local.carrierObj.getUpgradeFee( session.cart.getCarrierID() )>
													
													<tr>
														<td class="item-col">
															<span class="item-detail">
																Upgrade Fee of <cfif local.upgradeFee>$#local.upgradeFee#<cfelse>$18.00</cfif> *</a>
															</span>
														</td>
														<td class="price-col"></td>
														<td class="price-col"></td>
													</tr>
												<cfelse>
													<cfset local.activationFee = local.carrierObj.getActivationFee( session.cart.getCarrierID() )>
													<cfif listFind(request.config.activationFeeWavedByCarrier,session.cart.getCarrierId())>
														<tr>
															<td class="item-col">
																<span class="item-detail">
																	Free Activation Fee
																	<span class="activationFeeDisclaimer">(<a href="##" class="activationFeeExplanation" onclick="viewActivationFeeInWindow('activationFeeWindow', 'Activation Fee Details', '/index.cfm/go/cart/do/explainActivationFee/carrierId/#session.cart.getCarrierId()#');return false;">#dollarFormat(local.cartLine.getActivationFee().getPrices().getFirstBill())#</a> refunded by <cfif isDefined('local.selectedPlan.carrierID') and local.selectedPlan.carrierID eq 42>Wireless Advocates, LLC<cfelse>your carrier</cfif> - see details below <sup class="cartReview"><a href="##footnote4">4</a></sup>)</span>
																</span>
															</td>
															<td class="price-col"></td>
															<td class="price-col"></td>
														</tr>
													<cfelse>	
														<tr>
															<td class="item-col">
																<span class="item-detail">
																	Activation Fee
																	<!---<span class="activationFeeDisclaimer">(#dollarFormat(local.cartLine.getActivationFee().getPrices().getFirstBill())# - xxx see details below <sup class="cartReview"><a href="##footnote4">4</a></sup>)</span>--->
																	<span class="activationFeeDisclaimer">(#dollarFormat(local.activationFee)# - see details below <sup class="cartReview"><a href="##footnote4">4</a></sup>)</span>																		
																</span>
															</td>
															<td class="price-col"></td>
															<td class="price-col"></td>
														</tr>
													</cfif>
												</cfif>
											</cfif>

											<cfset local.lineFeatures = local.cartLine.getFeatures() />

											<cfloop from="1" to="#arrayLen(local.lineFeatures)#" index="local.iFeature">
												<cfset local.thisFeatureID = local.lineFeatures[local.iFeature].getProductID() />
												<cfset local.thisFeature = application.model.feature.getByProductID(local.thisFeatureID) />
												<cfset local.deviceGuidList = listAppend(local.deviceGuidList, local.thisFeature.serviceGuid) />
												<cfset local.thisServiceRecommended = false />

												<!--- Check if service is recommended --->
												<cfif qRecommendedServices.RecordCount>
													<cfloop query="qRecommendedServices">
														<cfif qRecommendedServices.productId eq local.thisFeatureId>
															<cfset local.thisServiceRecommended = true />
															<cfbreak />
														</cfif>
													</cfloop>
												</cfif>

												<tr>
													<td class="item-col">
														<span class="item-detail">
															<cfif arguments.isEditable>
																<a href="##" class="serviceDescription" onclick="viewServiceDescription(#local.thisFeatureID#);return false;">#local.thisFeature.summaryTitle#</a> 
															<cfelse>
																#local.thisFeature.summaryTitle# 
															</cfif>
															<cfif local.thisServiceRecommended AND NOT local.thisFeature.hidemessage>
																<span class="recommended">Best Value</span>
															</cfif>
														</span>
													</td>
													<td class="price-col"></td>
													<td class="price-col">#dollarFormat(local.lineFeatures[local.iFeature].getPrices().getMonthly())#</td>
												</tr>
											</cfloop>

											<cfif local.cartLine.getPhone().hasBeenSelected() and local.cartLine.getPlan().hasBeenSelected()>
												<cfset local.requiredServices = application.model.serviceManager.getDevicePlanMinimumRequiredServices( local.cartLine.getPhone().getProductID(), local.cartLine.getPlan().getProductID(), application.model.cart.getCartTypeId(session.cart.getActivationType()), session.cart.getSharedFeatures() ) />
												<cfset local.linkChange = getLink(lineNumber = local.iCartLine, do = 'planSelectServices') />
												<cfset local.linkAddFeatures = getLink(lineNumber = local.iCartLine, do = 'planSelectServices') />
												<cfset local.showAddServiceButton = true />

												<cfif application.model.CartHelper.isLineMissingRequiredFeatures( local.requiredServices, local.cartLine.getFeatures()  )>
													<tr>
														<td class="error-col">Missing required service<br /><a class="hideWhenPrinted" href="#local.linkChange#">Select Services</a></td>
														<td class="price-col">&nbsp;</td>
														<td class="price-col">&nbsp;</td>
													</tr>
												<cfelse>
													<cfif arguments.isEditable and arrayLen(local.lineFeatures) eq 0>
														<tr>
															<td class="item-col">No services selected for this line yet.<br /><a class="hideWhenPrinted" href="#local.linkChange#">Select Services</a></td>
															<td class="price-col"></td>
															<td class="price-col"></td>
														</tr>
													</cfif>
												</cfif>
											</cfif>

										</cfif>


										<cfif session.cart.hasCart() and session.cart.getActivationType() CONTAINS 'upgrade' and session.cart.getUpgradeType() is 'equipment-only'>
											<cfset local.lineFeatures = local.cartLine.getFeatures() />

											<tr>
												<td class="item-col">Required Services (<em>2-Year Contract Renewal</em>)</td>
												<td class="price-col"></td>
												<td class="price-col"></td>
											</tr>

											<cfloop from="1" to="#arrayLen(local.lineFeatures)#" index="local.iFeature">
												<cfset local.thisFeatureID = local.lineFeatures[local.iFeature].getProductID() />
												<cfset local.thisServiceRecommended = false />

												<cfset local.thisFeature = application.model.feature.getByProductID(local.thisFeatureID) />
												<cfset local.featureTitle = local.thisFeature.summaryTitle />
												<cfset local.deviceGuidList = listAppend(local.deviceGuidList, local.thisFeature.serviceGuid) />

												<!--- Check if service is recommended --->
												<cfif qRecommendedServices.RecordCount>
													<cfloop query="qRecommendedServices">
														<cfif qRecommendedServices.productId eq local.thisFeatureId>
															<cfset local.thisServiceRecommended = true />
															<cfbreak />
														</cfif>
													</cfloop>
												</cfif>
												

												<tr>
													<td class="item-col">
														<span class="item-detail">
															<cfif arguments.isEditable>
																<a href="##" class="serviceDescription" onclick="viewServiceDescription(#local.thisFeatureID#);return false;">#trim(local.featureTitle)#</a>
															<cfelse>
																#trim(local.featureTitle)#
															</cfif>
															<cfif local.thisServiceRecommended AND NOT local.thisFeature.hidemessage>
																<span class="recommended">Best Value</span>
															</cfif>
														</span>
													</td>
													<td class="price-col">&nbsp;</td>
													<td class="price-col">#dollarFormat(local.lineFeatures[local.iFeature].getPrices().getMonthly())#</td>
												</tr>
											</cfloop>
										</cfif>

										<cfif session.cart.hasCart() and session.cart.getAddALineType() is 'family'>

											<cfset local.showAddServiceButton = true />
											<cfset local.linkAddFeatures = getLink(lineNumber = local.iCartLine, do = 'services') />

											<tr>
												<td class="item-col">Rateplan</td>
												<td class="price-col"></td>
												<td class="price-col"></td>
											</tr>
											<cfif listFind(request.config.activationFeeWavedByCarrier,session.cart.getCarrierId())>
												<tr>
													<td class="item-col">
														<span class="item-detail">
															Free Activation Fee
															<span class="activationFeeDisclaimer">
																(Refunded by <cfif session.cart.getCarrierId() eq 42>Wireless Advocates, LLC<cfelse>your carrier</cfif> 
																- see details below <sup class="cartReview"><a href="##footnote4">4</a></sup>)</span>
														</span>
													</td>
													<td class="price-col"></td>
													<td class="price-col"></td>
												</tr>
											<cfelse>	
												<tr>
													<td class="item-col">
														<span class="item-detail">
															Activation Fee
															<span class="activationFeeDisclaimer">(see details below <sup class="cartReview"><a href="##footnote4">4</a></sup>)</span>
														</span>
													</td>
													<td class="price-col"></td>
													<td class="price-col"></td>
												</tr>
											</cfif>
											<tr>
												<td class="item-col">
													<span class="item-detail">Add a Line Fee</span>
												</td>
												<td class="price-col"></td>
												<td class="price-col">
													<div>
														TBD <sup class="cartReview"><a href="##footnote5">6</a></sup>
													</div>
												</td>
											</tr>

											<cfset local.lineFeatures = local.cartLine.getFeatures() />

											<tr>
												<td class="item-col">Services</td>
												<td class="price-col"></td>
												<td class="price-col"></td>
											</tr>

											<cfloop from="1" to="#arrayLen(local.lineFeatures)#" index="local.iFeature">
												<cfset local.thisFeatureID = local.lineFeatures[local.iFeature].getProductID() />
												<cfset local.thisFeature = application.model.feature.getByProductID(local.thisFeatureID) />
												<cfset local.deviceGuidList = listAppend(local.deviceGuidList, local.thisFeature.serviceGuid) />
												<cfset local.thisServiceRecommended = false />

												<!--- Check if service is recommended --->
												<cfif qRecommendedServices.RecordCount>
													<cfloop query="qRecommendedServices">
														<cfif qRecommendedServices.productId eq local.thisFeatureId>
															<cfset local.thisServiceRecommended = true />
															<cfbreak />
														</cfif>
													</cfloop>
												</cfif>

												<tr>
													<td class="item-col">
														<span class="item-detail">
															<cfif arguments.isEditable>
																<a href="##" class="serviceDescription" onclick="viewServiceDescription(#local.thisFeatureID#);return false;">#trim(local.thisFeature.summaryTitle)#</a>
															<cfelse>
																#trim(local.thisFeature.summaryTitle)#
															</cfif>	
															<cfif local.thisServiceRecommended AND NOT local.thisFeature.hidemessage>
																<span class="recommended">Best Value</span>
															</cfif>
														</span>
													</td>
													<td class="price-col"></td>
													<td class="price-col">#dollarFormat(local.lineFeatures[local.iFeature].getPrices().getMonthly())#</td>
												</tr>
											</cfloop>

											<cfset local.requiredServices = application.model.serviceManager.getDeviceMinimumRequiredServices( ProductId = local.cartLine.getPhone().getProductID(), CartTypeId = application.model.cart.getCartTypeId(session.cart.getActivationType()), HasSharedPlan = session.cart.getHasSharedPlan() ) />

											<cfif application.model.CartHelper.isLineMissingRequiredFeatures( local.requiredServices, local.cartLine.getFeatures()  )>
												<tr>
													<td class="error-col">Missing required service<br /><a class="hideWhenPrinted" href="/index.cfm/go/shop/do/services/cartCurrentLine/#local.iCartLine#">Select Services</a></td>
													<td class="price-col">&nbsp;</td>
													<td class="price-col">&nbsp;</td>
												</tr>
											<cfelse>
												<cfif arguments.isEditable and arrayLen(local.lineFeatures) eq 0>
													<tr>
														<td class="item-col">No services selected for this line yet.<br /><a class="hideWhenPrinted" href="/index.cfm/go/shop/do/services/cartCurrentLine/#local.iCartLine#">Select Services</a></td>
														<td class="price-col"></td>
														<td class="price-col"></td>
													</tr>
												</cfif>
											</cfif>
										</cfif>

										<!--- Line Accessories --->
										<cfif arrayLen(local.cartLine.getAccessories())>
											<cfset local.selectedAccessories = application.model.cartHelper.lineGetAccessoriesByType(line = local.iCartLine, type = 'accessory') />

											<cfloop from="1" to="#arrayLen(local.selectedAccessories)#" index="local.iAccessory">
												<cfset local.thisAccessory = local.selectedAccessories[local.iAccessory] />
												<cfset local.selectedAccessory = application.model.accessory.getByFilter(idList = local.thisAccessory.getProductID()) />
												<cfset local.stcPrimaryImage = application.model.imageManager.getPrimaryImagesForProducts(local.selectedAccessory.accessoryGuid) />
												<cfset local.deviceGuidList = listAppend(local.deviceGuidList, local.selectedAccessory.accessoryGuid) />

												<cfif structKeyExists(local.stcPrimaryImage, local.selectedAccessory.accessoryGuid)>
													<cfset imageDetail = {
															src = application.view.imageManager.displayImage(imageGuid = local.stcPrimaryImage[local.selectedAccessory.accessoryGuid], height = 0, width = 75)
															, alt = htmlEditFormat(local.selectedAccessory.summaryTitle)
															, width = 75
													} />
												<cfelse>
													<cfset imageDetail = {
														src = '#getAssetPaths().common#images/catalog/noimage.jpg'
														, alt = htmlEditFormat(local.selectedAccessory.summaryTitle)
														, width = 75
													} />
												</cfif>
												<cfset arrayAppend(local.imageUrls, imageDetail) />

												<tr>
													<td class="item-col">
														<cfif arguments.isEditable>
															<cfset local.linkDetails = getLink(lineNumber = local.iCartLine, productId = local.thisAccessory.getProductId(), do = 'accessoryDetails') />
															Accessory: <a href="#local.linkDetails#"> #local.selectedAccessory.summaryTitle#</a>
														<cfelse>
															Accessory: #local.selectedAccessory.summaryTitle#
														</cfif>
													</td>
													<td class="price-col">#dollarFormat(local.selectedAccessories[local.iAccessory].getPrices().getDueToday())#</td>
													<td class="price-col">&nbsp;</td>
												</tr>
											</cfloop>
										<cfelse>
											<tr>
												<cfset local.linkChange = getLink(lineNumber = local.iCartLine, do = 'browseAccessories') />

												<cfif arguments.isEditable>
													<td class="item-col">No accessories selected for this line yet.<br /><a class="hideWhenPrinted" href="#local.linkChange#">Browse Accessories</a></td>
													<td class="price-col"></td>
													<td class="price-col"></td>
												</cfif>
											</tr>
										</cfif>

										<!--- Line warranty --->
										<cfif getChannelConfig().getOfferWarrantyPlan()>
											<cfif local.cartLine.getWarranty().hasBeenSelected()>
												<cfset local.selectedWarranty = application.model.Warranty.getById( local.cartLine.getWarranty().getProductId() ) />
												<tr>
													<td class="item-col">
														<cfif arguments.isEditable>
															Warranty: <a href="/index.cfm/go/shop/do/warrantyDetails/productId/#local.cartLine.getWarranty().getProductId()#"> #local.cartLine.getWarranty().getTitle()#</a>
														<cfelse>
															Warranty: #local.cartLine.getWarranty().getTitle()#
														</cfif>
													</td>
													<td class="price-col">#dollarFormat(local.cartLine.getWarranty().getPrices().getDueToday())#</td>
													<td class="price-col">&nbsp;</td>
												</tr>
											<cfelse>
												<cfif arguments.isEditable>
													<cfset local.IsCompatibleWarrantyAvailable = false />																
													
													<cfif getChannelConfig().getDefaultWarrantyPlanId() neq ''>
														<cfset local.thisURL = '/index.cfm/go/shop/do/warrantyDetails/productId/#getChannelConfig().getDefaultWarrantyPlanId()#' />
														<cfset local.IsCompatibleWarrantyAvailable = true />
													<cfelse>
														<cfset qWarranty = application.model.Warranty.getByDeviceId( local.cartLine.getPhone().getProductId() ) />
														<cfif qWarranty.RecordCount>
															<cfset local.thisURL = '/index.cfm/go/shop/do/warrantyDetails/productId/#qWarranty.ProductId#' />
															<cfset local.IsCompatibleWarrantyAvailable = true />
														</cfif>
													</cfif>
													
													<td class="item-col">
														No protection plan selected for this line yet.<br />
														<cfif local.IsCompatibleWarrantyAvailable>
															<a class="hideWhenPrinted" href="#local.thisURL#">Browse Protection Plan</a></td>
														</cfif>
													<td class="price-col"></td>
													<td class="price-col"></td>
												</cfif>
											</cfif>
										</cfif>
										
										<!--- Instant MIR --->
										<cfif local.cartLine.getInstantRebateAmount() gt 0>
											<cfset local.cartLine.getPrices().setDueToday( local.cartLine.getPrices().getDueToday() - local.cartLine.getInstantRebateAmount() )>
											<tr>
												<td class="item-col">
													Instant Rebate: <span class="callout">You qualified to convert the mail-in rebate to an instant online rebate!</span>
												</td>
												<td class="price-col"><span class="callout">-#dollarFormat(local.cartLine.getInstantRebateAmount())#</span></td></td>
												<td class="price-col">&nbsp;</td>
											</tr>
										</cfif>
										
										<!--- Line Totals row --->
										<tr>
											<td class="item-col" style="text-align:right">Total:</td>
										<cfif session.cart.getActivationType() contains "financed">
											<td class="total-col">$0.00</td>
										<cfelse>
											<td class="total-col">#dollarFormat(local.cartline.getPrices().getDueToday())#</td>
										</cfif>
											<cfif session.cart.hasCart() and listFindNoCase('299, 128', session.cart.getCarrierId()) and (session.cart.getAddALineType() is 'Ind' or session.cart.getAddALineType() is 'Family')>
												<td class="total-col">
													<div>
														TBD <sup class="cartReview"><a href="##footnote5">6</a></sup>
													</div>
												</td>
											<cfelse>
												<td class="total-col">#dollarFormat(local.cartline.getPrices().getMonthly())#</td>
											</cfif>
										</tr>
									</table>

									<!--- Action Buttons --->
									<cfif arguments.isEditable>
										<div style="text-align:left; width:100%">
											<cfif local.showAddServiceButton>
												<span style="margin: 10px; font-weight: normal; font-size: 7pt;" class="actionButtonLow">
													<a class="hideWhenPrinted" href="#local.linkAddFeatures#">Add Services</a>
												</span>
											</cfif>
											<cfset local.linkChange = getLink(lineNumber = local.iCartLine, do = 'browseAccessories') />
											<span style="margin: 10px; font-weight: normal; font-size: 7pt;" class="actionButtonLow">
												<a class="hideWhenPrinted" href="#local.linkChange#">Add Accessories</a>
											</span>
										</div>
									</cfif>
								</div>
							</div>

							<cfif arguments.isEditable>
								<div class="image-container">
									<cfloop array="#local.imageUrls#" index="local.imageDetail">
										<img src="#local.imageDetail.src#" alt="#local.imageDetail.alt#" width="#local.imageDetail.width#" />
									</cfloop>
								</div>
							</cfif>
							<div style="clear:both;" ></div>
						</div>
					</cfloop>


					<cfset local.selectedAccessories = application.model.cartHelper.lineGetAccessoriesByType(line = request.config.otherItemsLineNumber, type = 'accessory') />
					<cfset local.thisPrepaids = application.model.cartHelper.lineGetAccessoriesByType(line = request.config.otherItemsLineNumber, type = 'prepaid') />
					<cfset local.deposits = application.model.cartHelper.lineGetAccessoriesByType(line = request.config.otherItemsLineNumber, type = 'deposit') />
					
					<cfset hasAdditionalItems = arrayLen(local.selectedAccessories) || arrayLen(local.thisPrepaids) || arrayLen(local.deposits)>
					
					<cfif hasAdditionalItems>
						<cfset local.imageUrls = [] />
						<cfset local.total_dueToday_other = 0 />
						<cfset local.total_firstBill_other = 0 />
						<cfset local.total_monthly_other = 0 />
						<div class="rounded-box">
							<div class="title-band">
								Additional Items
							</div>
							<div>
								<div class="<cfif arguments.isEditable>with-image<cfelse>no-image</cfif>">
									<table class="pricing">
										
										<!--- Prepaid --->
										<cfif arrayLen(local.thisPrepaids)>
											<tr style="border-top: 1px solid ##cccccc">
												<td class="item-col">Prepaid Phones</td>
												<td class="price-header-col">Due Today</td>
												<td class="price-header-col">Monthly</td>
											</tr>

											<cfset local.selectedOtherItems = session.cart.getOtherItems() />

											<cfloop from="1" to="#arrayLen(local.selectedOtherItems)#" index="local.iAccessory">
												<cfset local.thisAccessory = local.selectedOtherItems[local.iAccessory] />

												<cfif local.thisAccessory.getType() is 'prepaid'>
													<cfset local.selectedAccessory = application.model.prepaid.getByFilter(idList = local.thisAccessory.getProductID()) />

													<cfif local.selectedAccessory.recordCount>
														<cfset local.stcPrimaryImage = application.model.imageManager.getPrimaryImagesForProducts(local.selectedAccessory.productGuid) />
														<cfset local.deviceGuidList = listAppend(local.deviceGuidList, local.selectedAccessory.productGuid) />
														<tr>
															<td class="item-col">
																<span class="editLinks">
																	<cfset local.linkDetails = getLink(lineNumber = request.config.otherItemsLineNumber, do = 'prepaidDetails', productID = local.selectedAccessory.productId) />
																	<cfset local.linkChange = getLink(lineNumber = request.config.otherItemsLineNumber, do = 'browsePrepaids') />

																	<a href="#local.linkDetails#">Details</a>|<a href="/index.cfm/go/cart/do/removeAccessory/line/#request.config.otherItemsLineNumber#/productID/#local.selectedAccessory.product_id#/" onclick="return confirm('Are you sure you want to remove this prepaid phone from your cart?');">Remove</a>|<a href="#local.linkChange#">Change</a>
																</span>

																<cfif structKeyExists(local.stcPrimaryImage, local.selectedAccessory.productGuid)>
																	<img src="#application.view.imageManager.displayImage(imageGuid = local.stcPrimaryImage[local.selectedAccessory.productGuid], height = 0, width = 130)#" alt="#htmlEditFormat(local.selectedAccessory.summaryTitle)#" />
																<cfelse>
																	<img src="#getAssetPaths().common#images/catalog/noimage.jpg" alt="#htmlEditFormat(local.selectedAccessory.summaryTitle)#" />
																</cfif>

																<table cellpadding="0" cellspacing="0">
																	<tr>
																		<td class="label">Prepaid Phone</td>
																		<td>#local.selectedAccessory.summaryTitle#</td>
																	</tr>
																</table>
															</td>
															<td>#dollarFormat(local.selectedOtherItems[local.iAccessory].getPrices().getDueToday())#</td>

															<cfset local.total_dueToday_other = (local.total_dueToday_other + local.selectedOtherItems[local.iAccessory].getPrices().getDueToday()) />

															<td class="price-col">&nbsp;</td>
															<td class="price-col">&nbsp;</td>
														</tr>
													</cfif>
												</cfif>
											</cfloop>
											<tr>
												<td colspan="3">
													<cfset local.linkChange = getLink(lineNumber = request.config.otherItemsLineNumber, do = 'browsePrepaids') />

													<a href="#local.linkChange#">Add More Prepaid Phones</a>
												</td>
											</tr>
										</cfif>
										
										<!--- Accessories --->
										<cfif arrayLen(local.selectedAccessories) gt 0>
											<tr>
												<td class="item-col"></td>
												<td class="price-header-col">Due Today</td>
												<td class="price-header-col">Monthly</td>
											</tr>
											<cfloop from="1" to="#arrayLen(local.selectedAccessories)#" index="local.iAccessory">
												<cfset local.thisAccessory = local.selectedAccessories[local.iAccessory] />

												<cfif local.thisAccessory.getType() is 'accessory'>
													<cfset local.selectedAccessory = application.model.accessory.getByFilter(idList = local.thisAccessory.getProductID()) />
													<cfset local.deviceGuidList = listAppend(local.deviceGuidList, local.selectedAccessory.accessoryGuid) />
													<cfif local.selectedAccessory.recordCount>
														<cfset local.stcPrimaryImage = application.model.imageManager.getPrimaryImagesForProducts(local.selectedAccessory.accessoryGuid) />

														<cfif structKeyExists(local.stcPrimaryImage, local.selectedAccessory.accessoryGuid)>
															<cfset imageDetail = {
																	src = application.view.imageManager.displayImage(imageGuid = local.stcPrimaryImage[local.selectedAccessory.accessoryGuid], height = 0, width = 130)
																	, alt = htmlEditFormat(local.selectedAccessory.summaryTitle)
																	, width = 130
															} />
														<cfelse>
															<cfset imageDetail = {
																src = '#getAssetPaths().common#images/catalog/noimage.jpg'
																, alt = htmlEditFormat(local.selectedAccessory.summaryTitle)
																, width = 130
															} />
														</cfif>
														<cfset arrayAppend(local.imageUrls, imageDetail) />

														<tr>
															<td class="item-col">
																<cfif arguments.isEditable>
																	<cfset local.linkDetails = getLink(lineNumber = request.config.otherItemsLineNumber, do = 'accessoryDetails', productID = local.selectedAccessory.product_id) />
																	Accessory: <a href="#local.linkDetails#">#local.selectedAccessory.summaryTitle#</a>
																<cfelse>
																	Accessory: #local.selectedAccessory.summaryTitle#
																</cfif>
															</td>
															<td class="price-col">#dollarFormat(local.thisAccessory.getPrices().getDueToday())#</td>
															<cfset local.total_dueToday_other = (local.total_dueToday_other + local.thisAccessory.getPrices().getDueToday()) />
															<td class="price-col"></td>
														</tr>
													</cfif>
												</cfif>
											</cfloop>
										<cfelse>
											<!---
											**
											* Provide add more accessories option.
											**
											--->
										</cfif>

										<cfif arrayLen(local.deposits) gt 0>
											<tr style="border-top: 1px solid ##cccccc">
												<td class="item-col" style="text-align: left; background-color: ##ffffff">Deposit</td>
												<td class="price-header-col">Due Today</td>
												<td class="price-header-col">Monthly</td>
											</tr>
											<cfloop from="1" to="#arrayLen(local.deposits)#" index="local.iItem">
												<cfset local.thisItem = local.deposits[local.iItem] />
												<cfset local.total_dueToday_other = (local.total_dueToday_other + local.thisItem.getPrices().getDueToday()) />

												<tr>
													<td class="item-col">#local.thisItem.getTitle()#</td>
													<td class="price-col">#dollarFormat(local.thisItem.getPrices().getDueToday())#</td>
													<td class="price-col">&nbsp;</td>
												</tr>
											</cfloop>
										</cfif>
										
										<cfif arguments.isEditable>
										<tr>
											<td class="item-col">
												<cfset local.linkChange = getLink(lineNumber = request.config.otherItemsLineNumber, do = 'browseAccessories') />
												<a href="#local.linkChange#" class="hideWhenPrinted">Add More Accessories</a>
											</td>
											<td class="price-col"></td>
											<td class="price-col"></td>
										</tr>
										</cfif>
										<tr>
											<td class="item-col" style="text-align: right;">Total - Additional Items</td>
											<td class="total-col">#dollarFormat(local.total_dueToday_other)#</td>
											<td class="total-col">#dollarFormat(local.total_Monthly_other)#</td>
										</tr>
									</table>
								</div>
								<cfif arguments.isEditable>
									<div class="image-container">
										<cfloop array="#local.imageUrls#" index="local.imageDetail">
											<img src="#local.imageDetail.src#" alt="#local.imageDetail.alt#" width="#local.imageDetail.width#" />
										</cfloop>
									</div>
								</cfif>

								<div style="clear:both;"></div>
							</div>
						</div>
					</cfif>


						<!--- Add item capsules --->
						<cfif arguments.isEditable>
							<div class="rounded-box" style="border:2px solid grey;">
								<div style="padding: 5px 25px 5px 10px; font-size:1.3em; font-weight:bold">
									<a href="##" onclick="viewCart(); return false;" class="hideWhenPrinted">Add a Phone / Wireless Device</a>
								</div>
							</div>

							<div class="rounded-box" style="border:2px solid grey;">
								<div style="padding: 5px 25px 5px 10px; font-size:1.3em; font-weight:bold">
									<a href="/index.cfm/go/shop/do/browseAccessories/" class="hideWhenPrinted">Add an Accessory</a>
								</div>
							</div>
						</cfif>

						<!--- Summary Table --->
						<div class="rounded-box" style="border:2px solid grey;">
							<div class="title-band">
								Checkout Summary
							</div>
							<div>
								<cfif arguments.isEditable && getChannelConfig().isPromotionCodeAvailable()>
									<style type="text/css">
										##promotions {
											padding:10px;
											float:left;
										}
										##promotions h3 {
											color:##6b6b6b;
										}
										.applied-promos {
											color:##FF0000;
											margin:10px 0;
										}
									</style>
									
									<script type="text/javascript">
										jQuery(document).ready( function($) {
											$('##addPromotion').click( function() {
												var code = $('input[name="code"]').val();
												var returnURL = "#CGI.SCRIPT_NAME##CGI.PATH_INFO#";
												var href = $(this).attr("href") + '?code=' + code + '&returnURL=' + returnURL; 
												$(this).attr("href",href);
											});
										})
									</script>
									<div id="promotions">
										<h3>Promotional Codes</h3>
										<input name="code" type="text" value="" />
										<span class="actionButton">
											<cfif request.config.disableSSL>
												<cfset promoURL = "/index.cfm/go/checkout/do/addPromotionToCart">
											<cfelse>
												<cfset promoURL = "https://#cgi.server_name#/index.cfm/go/checkout/do/addPromotionToCart">
											</cfif>
											<a id="addPromotion" href="#promoURL#">Apply</a>
										</span> 
										<div class="applied-promos">
											<cfset promoCodes = session.cart.getPromotionCodes()>
											<cfloop collection="#promoCodes#" item="code">
												Promo Code: #code# - '#promoCodes[code].name#' <a href="/index.cfm/go/checkout/do/removePromotion?code=#code#&amp;returnURL=#CGI.SCRIPT_NAME##CGI.PATH_INFO#">Remove</a><br />
											</cfloop>
										</div>
									</div>
								</cfif>
								<div style="float:right">
									<table class="pricing">
										<tr>
											<td style="border-top-style: none; border-left-style: none; background-color: ##fff"></td>
											<td class="price-header-col">Due Today</td>
											<td class="price-header-col">Monthly</td>
										</tr>
										<cfif session.cart.getActivationType() contains "financed">
											<cfset session.cart.getPrices().setDueToday(0) />	
										</cfif>
										<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.iCartLine">
											<cfset local.cartLine = local.cartLines[local.iCartLine] />
										<cfif session.cart.getActivationType() contains "financed">
											<cfset local.cartLine.getPrices().setDueToday(0) />	
										</cfif>
									
											
											<tr>
												<td class="item-col" style="text-align:right">Total - Line #local.iCartLine#</td>
												<td class="price-col">#dollarFormat(local.cartLine.getPrices().getDueToday())#</td>
												<cfif session.cart.hasCart() and listFindNoCase('299, 128', session.cart.getCarrierId()) and (session.cart.getAddALineType() is 'Ind' or session.cart.getAddALineType() is 'Family')>
													<td class="price-col">
														<div>
															TBD <sup class="cartReview"><a href="##footnote5">6</a></sup>
														</div>
													</td>
												<cfelse>
													<td class="price-col">#dollarFormat(local.cartLine.getPrices().getMonthly())#</td>
												</cfif>
											</tr>
										</cfloop>

										<cfif hasAdditionalItems>
											<tr>
												<td class="item-col" style="text-align:right">Total - Additional Items</td>
												<td class="price-col">#dollarFormat(local.total_dueToday_other)#</td>
												<td class="price-col">#dollarFormat(local.total_monthly_other)#</td>
											</tr>
										</cfif>

										<cfif session.cart.getDiscountTotal() gt 0>
											<cfset session.cart.getPrices().setDueToday(session.cart.getPrices().getDueToday() - session.cart.getDiscountTotal()) />
										</cfif>

										<tr id="discountTotalRow">
											<td class="item-col" style="text-align:right">Discount Total</td>
											<td id="discountTotal" class="price-col"><cfif session.cart.getDiscountTotal()><span style="color:##FF0000">-#dollarFormat(session.cart.getDiscountTotal())#</span><cfelse>#dollarFormat(-0)#</cfif></td>
											<td class="price-col">&nbsp;</td>
										</tr>
										
										<!--- Adjust "due today" for instant rebate(s) --->
										<cfif session.cart.getInstantRebateAmountTotal() gt 0>
											<cfset session.cart.getPrices().setDueToday(session.cart.getPrices().getDueToday() - session.cart.getInstantRebateAmountTotal()) />
										</cfif>
										
										<tr>
											<td class="item-col" style="text-align:right">Total</td>
											<td class="price-col">#dollarFormat(session.cart.getPrices().getDueToday())#</td>
											<cfif session.cart.hasCart() and listFindNoCase('299, 128', session.cart.getCarrierId()) and (session.cart.getAddALineType() is 'Ind' or session.cart.getAddALineType() is 'Family')>
												<td class="price-col">
													<div>
														TBD <sup class="cartReview"><a href="##footnote5">6</a></sup>
													</div>
												</td>
											<cfelse>
												<td class="price-col">#dollarFormat(session.cart.getPrices().getMonthly())#</td>
											</cfif>
										</tr>

										<cfif arguments.isEditable>
											<tr>
												<td class="item-col" style="text-align:right">
													<div>
														Shipping <sup class="cartReview"><a href="##footnote1">1</a></sup>
													</div>
												</td>
												<td class="price-col">#request.config.CartReviewShippingDisplayName#</td>
												<td class="price-col">&nbsp;</td>
											</tr>
										<cfelse>
											<cfscript>
												/*  shipping fix goes here */
												
					
												shipMethodArgs = {
													CarrierId = session.cart.getCarrierId()
													, IsAfoApoAddress = application.model.CheckoutHelper.getShippingAddress().isApoFpoAddress()
													, IsCartEligibleForPromoShipping = false
												};

												if ( getChannelConfig().getOfferShippingPromo() )
												{
													//Check to see if the cart meets the promo criteria
													shipMethodArgs.IsCartEligibleForPromoShipping = application.model.CartHelper.isCartEligibleForPromoShipping();
												}

												local.qShipMethods = application.model.ShipMethod.getShipMethods( argumentCollection = shipMethodArgs );
											
											</cfscript>

											<tr>
												<td class="item-col" style="text-align:right">
													(Processing can take up to #getChannelConfig().getOrderProcessingTime()# business days <sup class="cartReview"><a href="##footnote1">1</a></sup>)
													<cfif local.qShipMethods.RecordCount eq 1>
														- #local.qShipMethods.DisplayName#
														<input type="hidden" name="shipping" value="#local.qShipMethods.ShipMethodId#" />
													<cfelse>
														<select name="shipping" id="shippingCostSelect" onchange="adjustShippingCosts('shippingCostSelect');">
															<cfloop query="local.qShipMethods">
																<option price="#DefaultFixedCost#" displayPrice="#dollarFormat(DefaultFixedCost)#" value="#ShipMethodId#">#DisplayName# (#dollarFormat(DefaultFixedCost)#)</option>
															</cfloop>
														</select>
													</cfif>
												</td>
												<td id="shippingCostDisplay" class="price-col">#dollarFormat(local.qShipMethods.DefaultFixedCost[1])#</td>
												<td class="price-col">&nbsp;</td>
											</tr>
										</cfif>

										<tr>
											<td class="item-col" style="text-align:right">
												<div>
													Taxes and Fees <sup class="cartReview"><a href="##footnote2">2</a></sup>
												</div>
											</td>
											
											<cfif arguments.isEditable>
												<td class="price-col">TBD</td>
												<td class="price-col">TBD</td>
											<cfelse>
												<td class="price-col">#dollarFormat(session.cart.getTaxes().getDueToday())#</td>
												<td class="price-col">&nbsp;</td>
											</cfif>
										</tr>

										<cfif arguments.isEditable>
											<cfset local.total = session.cart.getPrices().getDueToday() />
										<cfelse>
											<cfset local.total = session.cart.getPrices().getDueToday() />
											<cfset local.total += session.cart.getTaxes().getDueToday() />
											<cfset local.total += session.cart.getShipping().getDueToday() />

											<cfset session.totalDueToday = local.total />
										</cfif>

										<tr>
											<td class="item-col" style="text-align:right">Total Due Today</td>
											<td id="totalPrice" class="total-col" total="#(local.total - session.cart.getShipping().getDueToday())#"><strong id="totalPriceDisplay">#dollarFormat(local.total)#</strong></td>
											<td class="total-col">&nbsp;</td>
										</tr>

										<cfset qry_getRebates = application.model.rebates.getRebates() />

										<cfif qry_getRebates.recordCount>
											<cfparam name="local.newRebateTotal" default="0" type="numeric" />
											<cfparam name="local.totalAppliedRebates" default="0" type="numeric" />
											<cfparam name="local.orderRebateGuidList" default="" type="string" />

											<cfloop query="qry_getRebates">
												<cfif application.model.rebates.isCartEligibleForRebate(qry_getRebates.rebateGuid[qry_getRebates.currentRow], local.deviceGuidList, session.cart.getActivationType()) and qry_getRebates.type[qry_getRebates.currentRow] is session.cart.getActivationType()>
													<cfset local.orderRebateGuidList = listAppend(local.orderRebateGuidList, qry_getRebates.rebateGuid) />
													<cfif qry_getRebates.displayType[qry_getRebates.currentRow] is not 'N'>
														<cfset local.newRebateTotal = (local.newRebateTotal + qry_getRebates.amount[qry_getRebates.currentRow]) />
													</cfif>
													<cfset local.totalAppliedRebates = (local.totalAppliedRebates + 1) />

													<cfif trim(qry_getRebates.title[qry_getRebates.currentRow]) is not 'CLICK HERE FOR PRICE'>
														<tr>
															<td class="item-col" style="text-align: right">
																<cfif len(trim(qry_getRebates.url[qry_getRebates.currentRow]))>
																	<a href="#trim(qry_getRebates.url[qry_getRebates.currentRow])#" target="_blank">Click to Download the #trim(qry_getRebates.title[qry_getRebates.currentRow])# Form</a>
																<cfelse>
																	#trim(qry_getRebates.title[qry_getRebates.currentRow])#
																</cfif>
															</td>
															<td class="price-col">
																<cfif qry_getRebates.displayType[qry_getRebates.currentRow] is 'N'>
																	N/A
																<cfelse>
																	<strong>- #dollarFormat(qry_getRebates.amount[qry_getRebates.currentRow])#</strong>
																</cfif>
															</td>
															<td class="price-col"></td>
														</tr>
													<cfelse>
														<cfset local.hideRebateTotal = true />
													</cfif>
												</cfif>
											</cfloop>
											<cfif local.totalAppliedRebates gt 0 and not structKeyExists(local, 'hideRebateTotal')>
												<cfset session.cart.orderRebateGuidList = local.orderRebateGuidList />
												<cfset local.totalAfterRebates = (local.total - session.cart.getShipping().getDueToday() - local.newRebateTotal) />
												<tr>
													<td class="item-col" style="text-align: right"><strong>Total After Mail-In Rebate<cfif local.totalAppliedRebates gt 1>s</cfif></strong></td>
													<td class="price-col"><strong>#dollarFormat(local.totalAfterRebates)#</strong></td>
													<td class="price-col"></td>
												</tr>
											</cfif>
										</cfif>
									</table>
								</div>
							</div>
							<div style="clear:both;" ></div>
						</div>


					<cfif arguments.isEditable and isDefined('local.cartButtons') and len(trim(local.cartButtons))>
						<br />
						#trim(local.cartButtons)#
						<cfif structKeyExists(session, 'cart') and arrayLen(session.cart.getLines())>
							<cftry>
								<cfif len(trim(application.model.checkoutHelper.getCheckoutCouponCode())) and not session.cart.getDiscountTotal()>
									<script>verifyPromoCouponCode('#trim(application.model.checkoutHelper.getCheckoutCouponCode())#');</script>
								</cfif>
								<cfif len(trim(application.model.checkoutHelper.getCheckoutPromotionCode())) and not session.cart.getDiscountTotal()>
									<script>verifyPromoCouponCode2('#trim(application.model.checkoutHelper.getCheckoutPromotionCode())#');</script>
								</cfif>
								<cfcatch type="any">
									<!--- Do Nothing --->
								</cfcatch>
							</cftry>
						</cfif>
					</cfif>

					<cfif session.cart.hasCart()>
						<cfset local.thisCarrier = application.model.carrier.getByCarrierId(session.cart.getCarrierId()) />

						<cfif session.cart.getActivationType() is 'upgrade'>
							
							<!--- removing hard-coded upgrade fees and adding result from call to carrier component made earlier in this method  --->
							<cfif NOT structKeyExists(local, 'upgradeFee')>
								<cfset local.carrierObj = application.wirebox.getInstance("Carrier") />
								<cfset local.upgradeFee = local.carrierObj.getUpgradeFee( session.cart.getCarrierID() )>
							</cfif>
													
							<span class="note">
								<sup class="cartReview">*</sup> An Upgrade Fee of $#local.upgradeFee# applies to each Upgrade Line.
								<cfif session.cart.getCarrierId() neq 299>This fee will appear on your next billing statement<cfif session.cart.getCarrierId() eq 299> and will be refunded to your account within three billing cycles</cfif>.</cfif><!--- remove for Sprint --->
							</span><br />
						</cfif>

						<span class="note">
							<sup class="cartReview">
								<a name="footnote1">1</a>
							</sup> 
							Orders can take up to #getChannelConfig().getOrderProcessingTime()# business days to process before shipping. See our <a href="index.cfm/go/content/do/shipping" target="_blank">shipping policy</a> page for details.</span><br />
						<cfset local.cartZipcode = '' />

						<cfif application.model.cartHelper.zipCodeEntered()>
							<cfset local.cartZipCode = session.cart.getZipCode() />
						</cfif>

						<span class="note">
							<sup class="cartReview"><a name="footnote2">2</a></sup> In accordance with the tax laws in certain
							states and jurisdictions, including but not limited to California, the tax charged may be based on an
							amount higher than the retail price of the purchase. California sales tax is calculated in accordance
							with Sales and Use Tax Regulation 1585. Taxes and fees estimated and based on zip code (#trim(local.cartZipcode)#) 
							entered earlier and the service plan you selected. Actual fees will be determined by your wireless carrier.
						</span>
						<br />

						<cfif session.cart.getActivationType() neq 'upgrade'>
							<cfif listFind(request.config.activationFeeWavedByCarrier,session.cart.getCarrierId())>
								<span class="note">
									<sup class="cartReview"><a name="footnote4">4</a></sup>
									<cfif listFindNoCase('109, 128', session.cart.getCarrierId())>
										#local.thisCarrier.companyName# activation fees will be refunded through a Bill Credit on all
										qualifying activations.
									<cfelseif listFindNoCase('299', session.cart.getCarrierId())>
										Activation fee credit will be applied in the first bill cycle and refunded to your account within three billing cycles.
									<cfelseif session.cart.getCarrierId() eq 42>
										Customers will receive a mail-in rebate from Wireless Advocates to reimburse the activation fee
										on a new single line and/or Family Share 2-year #local.thisCarrier.companyName# service agreement.
										Upgrades do not qualify for this credit.
									</cfif>
									Please <a href="##" onclick="viewActivationFeeInWindow('activationFeeWindow', 'Activation Fee Details', '/index.cfm/go/cart/do/explainActivationFee/carrierId/#session.cart.getCarrierId()#');return false;">click here</a> for details.
								</span>
								<br />
							<cfelse>
								<span class="note">
									<sup class="cartReview"><a name="footnote4">4</a></sup>
									Activation Fee will be applied to the first bill cycle.
								</span>
								<br />
							</cfif>
						</cfif>

<!---					<span class="note">
							<sup class="cartReview"><a name="footnote5">5</a></sup>
							This is a summary of your monthly access charges. It does not include taxes, surcharges, fees, usage
							charges, discounts or credits. The actual amounts billed by your carrier will vary based upon your usage.
						</span>--->
						<br />
						<cfif session.cart.hasCart() and (session.cart.getAddALineType() is 'Ind' or session.cart.getAddALineType() is 'Family')>
							<span class="note">
                                <sup class="cartReview"><a name="footnote5">6</a></sup>
                                Add-a-line charge varies based on current plan and service selections. New 2 year agreement may be required on all lines.
							</span>
							<br />
						</cfif>
						<script language="javascript" type="text/javascript" src="#getAssetPaths().common#scripts/cartReviewActivationFeeWindow.js"></script>
					</cfif>
					<script type="text/javascript" language="javascript" src="#getAssetPaths().common#scripts/planFeatureWindow.js"></script>
				</cfoutput>
			<cfelse>
				<cfoutput>
					<hr />
					Your cart is currently empty.
					<hr />
				</cfoutput>
			</cfif>
		</div>
		</cfsavecontent>

		<cfreturn trim(local.html) />
	</cffunction>


	<cffunction name="viewInDialog" returntype="any">
		<cfargument name="hasWirelessItemBeenAdded" type="boolean" default="false">
		<cfset var local = structNew()>

		<cfparam name="request.cart" default="#structNew()#">
		<cfparam name="request.cart.bAddedTooMany" default="false">

<!--- <cflocation addtoken="false" url="/index.cfm/go/cart/do/viewInDialog/">
<cfexit method="exittag"> --->
<cfsavecontent variable="local.html"><cfoutput>
<cfinclude template="dsp_viewCartInDialog.cfm">
</cfoutput></cfsavecontent>
<cfreturn local.html>
<cfexit method="exittag">

		<cfsavecontent variable="local.html">
			<cfif isDefined("session.cart") and isStruct(session.cart)>
				<cfset cartLines = session.cart.getLines()>

				<!--- TRV: set a trigger to refresh the main window content when the cart dialog is closed after adding a wireless item that could affect the workflow controller --->
				<cfif arguments.hasWirelessItemBeenAdded>
					<cfoutput>
						<script language="javascript">
							hasWirelessItemBeenAdded = true;
						</script>
					</cfoutput>
				</cfif>

				<!--- if the cart appears to be empty --->
				<cfif application.model.CartHelper.isEmpty()>
					<cfoutput>
						<div class="zipHeader">
							<cfif application.model.CartHelper.zipcodeEntered()>
								<div class="zipcode">
									Zipcode: #session.cart.getZipcode()# <input type="button" id="btn_changeZipcode" value="change zipcode" onclick="toggleElement('div_newZipcode');document.getElementById('input_newZipcode').focus();">
									<font id="div_newZipcode" style="display:none;">
										<cfset cartZip = session.cart.getZipcode()>
										<cfset cartZip = trim(cartZip)>
										<input type="text" id="input_newZipcode" name="input_newZipcode" size="20" value="#cartZip#">
										<input type="button" name="btn_changeZipcode" value="save" onclick="if (confirm('All previously selected Service Plans and Services will be dropped from your cart if you change your zipcode.\n\nAre you SURE you want to change your zipcode?')){ColdFusion.navigate('/index.cfm/go/cart/do/changeZipcode/blnDialog/1/zipcode/'+document.getElementById('input_newZipcode').value,'dialog_addToCart');}">
									</font>
								</div>
							</cfif>
							<input type="button" name="btn_close" value="close window" onclick="ColdFusion.Window.hide('dialog_addToCart')">
						</div>

                        Your cart is presently empty.
					</cfoutput>
				<cfelse>
					<cfoutput>

						<div class="zipHeader">
							<cfif application.model.CartHelper.zipcodeEntered()>
								<div class="zipcode">
									Zipcode: #session.cart.getZipcode()# <input type="button" id="btn_changeZipcode" value="change zipcode" onclick="toggleElement('div_newZipcode');document.getElementById('input_newZipcode').focus();">
									<font id="div_newZipcode" style="display:none;">
										<cfset cartZip = session.cart.getZipcode()>
										<cfset cartZip = trim(cartZip)>
										<input type="text" id="input_newZipcode" name="input_newZipcode" size="20" value="#cartZip#">
										<input type="button" name="btn_changeZipcode" value="save" onclick="if (confirm('All previously selected Service Plans and Services will be dropped from your cart if you change your zipcode.\n\nAre you SURE you want to change your zipcode?')){ColdFusion.navigate('/index.cfm/go/cart/do/changeZipcode/blnDialog/1/zipcode/'+document.getElementById('input_newZipcode').value,'dialog_addToCart');}">
									</font>
								</div>
							</cfif>
							<input type="button" name="btn_clearMyCart" value="clear your cart" onclick="var ok=confirm('Are you sure you want to clear your cart?'); if(ok){ ColdFusion.navigate('/index.cfm/go/cart/do/clearCart/blnDialog/1/', 'dialog_addToCart'); }">
							<input type="button" name="btn_close" value="close window" onclick="ColdFusion.Window.hide('dialog_addToCart')">
						</div>


                        <!--- set a local var to track if a plan is defined in the cart. used below to define the "Add a New Line" button --->
                        <cfset local.lineWithPlan  = 1> <!--- starts off as the first line --->

						<cfloop from="1" to="#arrayLen(cartLines)#" index="iLine">
							<cfset thisLine = cartLines[iLine]>
							<cfset thisPhone = thisLine.getPhone()>
							<cfset selectedPhone = application.model.Phone.getByFilter(idList=thisPhone.getProductID())>
							<cfif not selectedPhone.recordCount>
								<cfset selectedPhone = application.model.Tablet.getByFilter(idList=thisPhone.getProductID())>
							</cfif>
							<cfif not selectedPhone.recordCount>
								<cfset selectedPhone = application.model.DataCarAndNetbook.getByFilter(idList=thisPhone.getProductID())>
							</cfif>
							<cfset thisPlan = thisLine.getPlan()>
							<cfset selectedPlan = application.model.Plan.getByFilter(idList=thisPlan.getProductID())>
							<cfset thisFeatures = thisLine.getFeatures()>
							<cfset thisAccessories = thisLine.getAccessories()>

							<cfform method="post" action="/index.cfm/go/cart/do/aliasLine/" name="form_line#iLine#">
								<div class="line">
									<input type="hidden" name="line" value="#iLine#">
									<input type="hidden" name="blnDialog" value="true">

									<span class="lineName">Line #iLine#</span>
									<input type="button" name="btn_deleteLine#iLine#" value="delete this line" style="float:right;" onclick="if (confirm('Are you sure you want to delete this line?')){ColdFusion.navigate('/index.cfm/go/cart/do/deleteLine/line/#iLine#/blnDialog/1/', 'dialog_addToCart')}">
									<cfif len(trim(thisLine.getAlias()))>
										<span id="div_currentLineAlias#iLine#">(#thisLine.getAlias()#)</span>
										<input type="button" id="btn_aliasLine#iLine#" value="change name" onclick="toggleElement('div_aliasLine#iLine#');toggleElement('div_currentLineAlias#iLine#');document.form_line#iLine#.alias.focus();">
									<cfelse>
										<input type="button" id="btn_aliasLine#iLine#" value="name this line" onclick="toggleElement('div_aliasLine#iLine#');toggleElement('btn_aliasLine#iLine#');document.form_line#iLine#.alias.focus();">
									</cfif>
									<span id="div_aliasLine#iLine#" style="display:none;">
										<input type="text" name="alias" size="20" maxlength="50" value="#htmlEditFormat(trim(thisLine.getAlias()))#">
										<input type="submit" name="btnSubmit" value="save">
									</span>

									<ul class="line">
										<li>
											<span>Phone:</span>
											<cfif not thisPhone.hasBeenSelected()>
												<cfset local.thisURL = getLink(lineNumber="#iLine#",do="browsePhones")>
												<a href="#local.thisURL#">Add a Phone</a>
											<cfelse>
												<cfset local.thisURL = getLink(lineNumber="#iLine#",do="phoneDetails")>
												<a href="#local.thisURL#">#selectedPhone.summaryTitle#</a><font style="float:right;">[<a href="##" onclick="if (confirm('Are you sure you want to remove this device from your cart?\n\nNOTE: Removing this item will also remove any Service Plan features you may have added to this line.')){ColdFusion.navigate('/index.cfm/go/cart/do/removePhone/line/#iLine#/blnDialog/1/', 'dialog_addToCart')};return false;">remove</a>]</font><br/>
											</cfif>
										</li>

										<li>
											<span>Service Plan:</span>
											<cfif thisPlan.hasBeenSelected()>
												<cfset local.lineWithPlan = iLine>  <!--- set has a plan to true. The add a new line will use this to filter --->
												<cfset local.thisURL = getLink(lineNumber="#iLine#",do="planDetails")>
												<a href="#local.thisURL#">#selectedPlan.summaryTitle#</a><font style="float:right;">[<a href="##" onclick="if (confirm('Are you sure you want to remove this service plan from your cart?\n\nNOTE: Removing this service plan will also remove any associated features you may have added to this line.')){ColdFusion.navigate('/index.cfm/go/cart/do/removePlan/line/#iLine#/blnDialog/1/', 'dialog_addToCart')};return false;">remove</a>]</font><br/>
											<cfelse>
		                                    	<cfset local.thisURL = getLink(lineNumber="#iLine#",do="browsePlans")>
												<a href="#local.thisURL#">Add a Service Plan</a>
											</cfif>
										</li>

										<li>
											<span>Services:</span>
											<cfif not arrayLen(thisFeatures) and thisPlan.hasBeenSelected() and thisPhone.hasBeenSelected()>
												<a href="/index.cfm/go/shop/do/planDetails/cartCurrentLine/#iLine#/planID/#thisPlan.getProductID()#">Add Services</a>
											<cfelseif not thisPhone.hasBeenSelected()>
												Select Phone First
											<cfelseif not thisPlan.hasBeenSelected()>
												Select Service Plan First
											<cfelse>
												<span>Selected Services</a></span><br/>
												<cfloop from="1" to="#arrayLen(thisFeatures)#" index="local.iFeatures">
													<cfset local.thisItem = application.model.Feature.getByProductID(thisFeatures[local.iFeatures].getProductID())>
													<cfset local.thisURL = getLink(lineNumber="#iLine#",do="planSelectServices")>
													<a href="#local.thisURL#">#local.thisItem.summaryTitle#</a><font style="float:right;">[<a href="##" onclick="if (confirm('Are you sure you want to remove this feature from this line?')){ColdFusion.navigate('/index.cfm/go/cart/do/removeFeature/line/#iLine#/productID/#local.thisItem.productID#/blnDialog/1/', 'dialog_addToCart')};return false;">remove</a>]</font><br/>
												</cfloop>
												<cfset local.thisURL = getLink(lineNumber="#iLine#",do="planSelectServices")>
												<a href="#local.thisURL#">Add More Services</a>
											</cfif>
										</li>
										<li>
											<span>Accessories:</span>
											<cfif not arrayLen(thisAccessories)>
												<cfset local.thisURL = getLink(lineNumber="#iLine#",do="browseAccessories")>
												<a href="#local.thisURL#">Add Accessories</a>
											<cfelse>
												<span>Selected Accessories</a></span><br/>
												<cfloop from="1" to="#arrayLen(thisAccessories)#" index="iAccessory">
													<cfset thisAccessory = application.model.Accessory.getByFilter(idList=thisAccessories[iAccessory].getProductID())>
													<cfset local.thisURL = getLink(lineNumber="#iLine#",do="accessoryDetails",productID="#thisAccessories[iAccessory].getProductID()#")>
													<a href="#local.thisURL#">#thisAccessory.summaryTitle#</a><font style="float:right;">[<a href="##" onclick="if (confirm('Are you sure you want to remove this accessory from this line?')){ColdFusion.navigate('/index.cfm/go/cart/do/removeAccessory/line/#iLine#/productID/#thisAccessory.product_id#/blnDialog/1/', 'dialog_addToCart')};return false;">remove</a>]</font><br/>
												</cfloop>
												<cfset local.thisURL = getLink(lineNumber="#iLine#",do="browseAccessories")>
												<a href="#local.thisURL#">Add More Accessories</a>
											</cfif>
										</li>
									</ul>
								</div>
							</cfform>
						</cfloop>

						<cfif arrayLen(session.cart.getOtherItems())>
							<div class="line">
								<span class="lineName">Additional Items</span>
								<ul class="line">
									<cfset cartAccessories = session.cart.getOtherItems()>
									<cfloop from="1" to="#arrayLen(cartAccessories)#" index="iAccessory">
										<cfset thisAccessory = application.model.Accessory.getByFilter(idList=cartAccessories[iAccessory].getProductID())>
										<cfset local.thisURL = getLink(lineNumber="999",do="accessoryDetails",productID=cartAccessories[iAccessory].getProductID())>
										<li>
											<a href="#local.thisURL#">#thisAccessory.summaryTitle#</a><font style="float:right;">[<a href="##" onclick="if (confirm('Are you sure you want to remove this item from your cart?')){ColdFusion.navigate('/index.cfm/go/cart/do/removeAccessory/line/#request.config.otherItemsLineNumber#/productID/#thisAccessory.product_id#/blnDialog/1/', 'dialog_addToCart')};return false;">remove</a>]</font><br/>
										</li>
									</cfloop>
								</ul>
							</div>
						</cfif>

						<!--- if there are already lines, show the Add another line button --->
                        <cfif arrayLen(cartLines) lt request.config.maxLines>
                            <div class="lineFooter">
								<cfset local.thisURL = "/index.cfm/go/cart/do/addLine/">
                                <input type="button" onclick="location.href='#local.thisURL#';" value="Add Another Line">
                            </div>
                        </cfif>

						<!--- if it appears that the user was trying to add more items to the car than we allow --->
						<cfif isDefined("request.cart.bAddedTooMany") and isBoolean(request.cart.bAddedTooMany) and request.cart.bAddedTooMany>
							<script language="javascript">
							<!--//
								alert('You attempted to add to many lines to your cart.\nWe have limited your cart to #request.config.maxLines# lines.');
							//-->
							</script>
						</cfif>
					</cfoutput>
				</cfif>
			<cfelse>
				<cfoutput>
					<hr>
					ummmm, wait a minute... you don't have a cart yet!  =(
					<hr>
				</cfoutput>
			</cfif>
		</cfsavecontent>

		<cfreturn local.html>
	</cffunction>


	<cffunction name="addToCartDialogWindow" returntype="string">
		<cfargument name="name" type="variablename" default="dialog_addToCart">
		<cfargument name="functionName" type="variablename" default="addToCart">
		<cfargument name="width" type="numeric" default="730">
		<cfargument name="height" type="numeric" default="570">
		<cfargument name="modal" type="boolean" default="true">
		<cfargument name="closable" type="boolean" default="true">
		<cfargument name="title" type="string" default="Your Cart">
		<cfargument name="center" type="boolean" default="true">
		<cfargument name="resizable" type="boolean" default="false">
		<cfargument name="draggable" type="boolean" default="true">
		<cfargument name="productType" type="string" default="productType">
		<cfset var local = structNew()>
		<cfparam name="session.cart" default="#createObject('component','cfc.model.Cart').init()#">
		<cfparam name="request.cart.numLines" default="#application.model.CartHelper.getNumberOfLines()#">

		<cfsavecontent variable="local.html">
			<cfoutput>
				<cfwindow
					width="#arguments.width#"
					height="#arguments.height#"
					modal="#arguments.modal#"
					closable="#arguments.closable#"
					initShow="false"
					title="#arguments.title#"
					center="#arguments.center#"
					resizable="#arguments.resizable#"
					draggable="#arguments.draggable#"
					name="#arguments.name#"
					bodyStyle="margin:0px;padding:0px;"
				/>

				<script language="javascript">
					var hasWirelessItemBeenAdded = false;

					function loadBundle(bundleName)
					{
						<cfif isDefined("session.cart") and isStruct(session.cart) and application.model.CartHelper.zipcodeEntered() >
							var ok = confirm("The " + bundleName + " packaged bundle will be loaded into your cart. Your current cart will automatically be cleared. Click 'OK' to continue.");
							if(!ok)
							{
								return false;
							}
						</cfif>
						// ColdFusion.navigate('/index.cfm/go/cart/do/loadBundle/bundleName/' + bundleName, 'dialog_addToCart');
						ColdFusion.Window.show("dialog_addToCart");
						ColdFusion.navigate('/index.cfm/go/cart/do/loadBundle/bundleName/' + bundleName, 'dialog_addToCart');
						ColdFusion.Window.onHide("dialog_addToCart",refreshParent);
					}

					function loadBundlePage(bundleName)
					{
						//ColdFusion.navigate('/index.cfm/go/cart/do/loadBundlePage/bundleName/' + bundleName, 'dialog_addToCart');
						ColdFusion.Window.show("dialog_addToCart");
						ColdFusion.navigate('/index.cfm/go/cart/do/loadBundlePage/bundleName/' + bundleName, 'dialog_addToCart');
						ColdFusion.Window.onHide("dialog_addToCart",refreshParent);
					}

					function isPositiveInteger(val)	{

						if(val==null)	{
							return false;
						}
						if (val.length==0)	{
							return false;
						}
						for (var i = 0; i < val.length; i++)	{
							var ch = val.charAt(i)
							if (ch < "1" || ch > "9")	{
								return false
							}
						}

						return true;
					}

					#arguments.functionName# = function (type,id,qty,qtyLimit,cartLineNumber) {
						var val = qty;
						

						// Remove spaces from quantity field.
						if(!isNaN(val) && document.getElementById('qty_' + id))	{
							document.getElementById('qty_' + id).value = document.getElementById('qty_' + id).value.replace(' ', '');

							val = document.getElementById('qty_' + id).value;
						}

						if (!isNaN(val) && isPositiveInteger(val))
						{
							<!--- quantity validation/limitation logic for phones, devices, and plans --->
							if (type.indexOf('phone') >= 0 || type.indexOf('tablet') >= 0 || type.indexOf('dataCardAndNetbook') >= 0 || type.indexOf('prepaid') >= 0 || type.indexOf('plan') >= 0)
							{
								if (val >= 1 && val <= #request.config.maxLines-request.cart.numLines#)
								{
									if (qtyLimit && val > qtyLimit)
									{
										alert('Current inventory count for this item is '+qtyLimit+' and you have tried to purchase '+val+'.\n\nPlease decrease your quantity accordingly and try again.');
										return false;
									}
								}
								else
								{
									if (val > 1 && val > #request.config.maxLines-request.cart.numLines#)
									{
										alert('Your cart is limited to containing #request.config.maxLines# lines.\nTherefore, we cannot allow you to add more than #request.config.maxLines# Phones, Mobile Hotspots, or Service Plans to your cart.');
										return false;
									}
									else if (val > 1)
									{
										alert('Please enter a numeric value in the range of 1 to #request.config.maxLines-request.cart.numLines#.');
										return false;
									}
								}
							}
							else
							{
								if (val >= 1)
								{
									if (qtyLimit && val > qtyLimit)
									{
										alert('Current inventory count for this item is '+qtyLimit+' and you have tried to purchase '+val+'.\n\nPlease decrease your quantity accordingly and try again.');
										return false;
									}
								}
								else
								{
									alert('Please enter a numeric value in the range of 1 to #request.config.maxLines-request.cart.numLines#.');
									return false;
								}
							}
						}
						else
						{
							alert('Please enter a numeric value in the range of 1 to #request.config.maxLines-request.cart.numLines#.');
							return false;
						}

						// ColdFusion.navigate("/index.cfm/go/cart/do/addItem/productType/"+type+"/product_id/"+id+"/qty/"+qty, "#arguments.name#");
						ColdFusion.Window.show("#arguments.name#");
						if (parseInt(cartLineNumber) > 0) {
							ColdFusion.navigate("/index.cfm/go/cart/do/addItem/productType/" + type + "/product_id/" + id + "/qty/" + qty + "/cartlinenumber/"+cartLineNumber, "#arguments.name#");
						}
						else {
							ColdFusion.navigate("/index.cfm/go/cart/do/addItem/productType/" + type + "/product_id/" + id + "/qty/" + qty, "#arguments.name#");
						}
						ColdFusion.Window.onHide("#arguments.name#",refreshParent);
					}

					viewCart = function () {
						// ColdFusion.navigate("/index.cfm/go/cart/do/viewInDialog/", "#arguments.name#");
						ColdFusion.Window.show("#arguments.name#");
						ColdFusion.navigate("/index.cfm/go/cart/do/viewInDialog/", "#arguments.name#");
//						centerWindow('#arguments.name#');
						ColdFusion.Window.onHide("#arguments.name#",refreshParent);

						//pageTracker._trackPageview("/viewCart");

					}

					refreshParent = function () {
						var parentLoc = window.location;

						if(hasWirelessItemBeenAdded)	{
							if(parentLoc.pathname.indexOf('browsePrePaids') == -1)	{
								window.location = parentLoc;
							} else {
								window.location = 'index.cfm/go/shop/do/browsePrePaids/prePaidFilter.submit/1/filter.filterOptions/0/';
							}
						}
					}

					toggleElement = function ( whichLayer ) {
						var elem, vis;
						if( document.getElementById ) // this is the way the standards work
							elem = document.getElementById( whichLayer );
						else if( document.all ) // this is the way old msie versions work
							elem = document.all[whichLayer];
						else if( document.layers ) // this is the way nn4 works
							elem = document.layers[whichLayer];
						vis = elem.style;
						// if the style.display value is blank we try to figure it out here
						if(vis.display==''&&elem.offsetWidth!=undefined&&elem.offsetHeight!=undefined)
							vis.display = (elem.offsetWidth!=0&&elem.offsetHeight!=0)?'inline':'none';
						vis.display = (vis.display==''||vis.display=='inline')?'none':'inline';
					}

					centerWindow = function (windowName) {
						// get window object
						var myWindow = ColdFusion.Window.getWindowObject(windowName);
						// use the center function to center the window.
						myWindow.moveTo(500,500);
						myWindow.center();
					}
				</script>
			</cfoutput>
		</cfsavecontent>

		<cfreturn local.html>
	</cffunction>

	<cffunction name="renderWorkflowController" returntype="string" output="false" access="public">
		<cfset var local = structNew() />
		<cfset local.html = "" />

		<cfif structKeyExists(session, 'cart') and isStruct(session.cart) and arrayLen(session.cart.getLines()) and session.cart.getCurrentLine()>
			<cfset local.cartLines = session.cart.getLines() />
			<cfset request.cart.numLines = arrayLen(local.cartLines) />
			<!--- TRV: catch if we wound up with "other items" as the current line from cart dialog since it will screw up the workflow taskbar rendering --->
			<cfif session.cart.getCurrentLine() eq request.config.otherItemsLineNumber>
				<cfset session.cart.setCurrentLine(arrayLen(session.cart.getLines())) />
			</cfif>

			<cfsavecontent variable="local.html">
				<cfoutput>
					<!--- this is the js library include that Ryan/Ion asked for --->
					<script type="text/javascript" language="javascript" src="#getAssetPaths().common#scripts/workflowController.js"></script>

					<div id="workflowControl" class="workflow">
						<div id="workflowItemDetailDialog" >
							<a href="##" onclick="return false;" id="itemDialogTab"></a>
							<div id="itemDialogHeader"></div>
							<div id="dialogShim">
								<div id="itemDialogContent"></div>
							</div>
							<div id="itemDialogFooter"></div>
						</div>
						<ul class="lines lineCount_#request.cart.numLines#">
							<!--- TRV: loop through and display the lines in the cart --->
							<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.iLine">
								<cfset local.cartLine = local.cartLines[local.iLine] />
								<cfset local.isActiveLine = false />
								<cfif session.cart.getCurrentLine() eq local.iLine>
									<cfset local.isActiveLine = true />
								</cfif>
								<li id="li_line_selector_#local.iLine#" <cfif local.isActiveLine>class="activeLine"</cfif>  ><a href="##" onclick="return false;" style="width:100%"><cfif len(trim(local.cartLine.getAlias()))>#local.cartLine.getAlias()#<cfelse>Line #local.iLine#</cfif></a></li>
							</cfloop>
						</ul>
						<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.iLine">
						<!--- get a reference to this line --->
							<cfset local.currentCartLine = local.cartLines[local.iLine] />
							<cfset local.hideThisLine = true />
							<cfif session.cart.getCurrentLine() eq local.iLine>
								<cfset local.hideThisLine = false />
							</cfif>
							<ul id="ul_line_#local.iLine#" class="steps" style="display:<cfif local.hideThisLine>none<cfelse>inline</cfif>;">
								<!--- this next if block is here because doing it inline in the LI tag was adding newline characters inside the classname, which was screwing up the javascript --->
								<cfif local.currentCartLine.getPhone().hasBeenSelected()>
									<cfset local.stepClassName = "complete" />
								<cfelse>
									<cfset local.stepClassName = "notComplete" />
								</cfif>
								<li class="step_1 #local.stepClassName#">
									<!--- if a phone/device has been selected --->
									<cfif local.currentCartLine.getPhone().hasBeenSelected()>
										<!--- get the phone details and display them --->
										<cfset local.thisItemID = local.currentCartLine.getPhone().getProductID() />
										<cfset local.thisItem = application.model.Phone.getByFilter(idList=local.thisItemID) />
										<cfif not local.thisItem.recordCount>
											<cfset local.thisItem = application.model.Tablet.getByFilter(idList=local.thisItemID) />
										</cfif>
										<cfif not local.thisItem.recordCount>
											<cfset local.thisItem = application.model.DataCardAndNetBook.getByFilter(idList=local.thisItemID) />
										</cfif>
										<cfif not local.thisItem.recordCount>
											<cfset local.thisItem = application.model.PrePaid.getByFilter(idList=local.thisItemID)>
										</cfif>
										<span>Selected Phone</span>
										<cfset local.thisURL = getLink(lineNumber="#local.iLine#",do="phoneDetails") />
										<a href="#local.thisURL#">#local.thisItem.summaryTitle#</a>
									<cfelse>
										<span>Select a Phone</span>
										<cfset local.thisURL = getLink(lineNumber="#local.iLine#",do="browsePhones") />
										<a href="#local.thisURL#">Not Selected</a>
									</cfif>
								</li>
								<!--- this next if block is here because doing it inline in the LI tag was adding newline characters inside the classname, which was screwing up the javascript --->
								<cfif local.currentCartLine.getPlan().hasBeenSelected()>
									<cfset local.stepClassName ="complete" />
								<cfelseif session.cart.getActivationType() eq "upgrade" and session.cart.getUpgradeType() eq "equipment-only">
									<cfset local.stepClassName ="disabled" />
                                <cfelseif session.cart.getAddALineType() eq "Family">
                                	<cfset local.stepClassName ="disabled" />
								<cfelseif session.cart.getPrePaid()>
									<cfset local.stepClassName ="disabled" />
								<cfelse>
									<cfset local.stepClassName ="notComplete" />
								</cfif>
								<li class="step_2 #local.stepClassName#">
									<!--- if a plan has been selected --->
									<cfif local.currentCartLine.getPlan().hasBeenSelected()>
										<!--- get the plan details and display them --->
										<cfset local.thisItemID = local.currentCartLine.getPlan().getProductID() />
										<cfset local.thisItem = application.model.Plan.getByFilter(idList=local.thisItemID) />
										<span>Selected Service Plan</span>
										<cfset local.thisURL = getLink(lineNumber="#local.iLine#",do="planDetails") />
										<a href="#local.thisURL#">#local.thisItem.summaryTitle#</a>
									<cfelseif session.cart.getActivationType() eq "nocontract" >	
										<span>Select a Service Plan</span>
										<a href="##" onclick="alert('You have a No Contract Phone in your cart, so you may not select a service plan.');return false;"><em>Disabled</em></a>
									<cfelseif session.cart.getActivationType() eq "upgrade" and session.cart.getUpgradeType() eq "equipment-only">
										<span>Select a Service Plan</span>
										<a href="##" onclick="alert('You have indicated an handset-only upgrade, so you may not select a service plan.');return false;"><em>Disabled</em></a>
                                	<cfelseif session.cart.getAddALineType() eq "Family">
										<span>Select a Service Plan</span>
										<a href="##" onclick="alert('You have indicated a family plan add a line, so you may not select a service plan.');return false;"><em>Disabled</em></a>
									<cfelseif session.cart.getPrePaid()>
										<span>Select a Service Plan</span>
										<a href="##" onclick="alert('You have a Prepaid Phone in your cart, so you may not select a service plan.');return false;"><em>Disabled</em></a>
									<cfelse>
										<span>Select a Service Plan</span>
										<cfset local.thisURL = getLink(lineNumber="#local.iLine#",do="browsePlans") />
										<a href="#local.thisURL#">Not Selected</a>
									</cfif>
								</li>
								<!--- this next if block is here because doing it inline in the LI tag was adding newline characters inside the classname, which was screwing up the javascript --->
								<cfif arrayLen(local.currentCartLine.getFeatures()) and not ( session.cart.getActivationType() eq "upgrade" and session.cart.getUpgradeType() eq "equipment-only" ) and session.cart.getAddALineType() neq "Family">
									<cfset local.stepClassName ="complete" />
								<cfelseif (session.cart.getActivationType() eq "upgrade" and session.cart.getUpgradeType() eq "equipment-only") or session.cart.getAddALineType() eq "Family">

                                    <cfif len(trim(local.currentCartLine.getPhone().getProductID())) eq 0>

										<cfif application.model.ServiceManager.getDeviceMinimumRequiredServices( ProductId = local.currentCartLine.getPhone().getProductID(), CartTypeId = application.model.cart.getCartTypeId(session.cart.getActivationType()) ).recordCount>
                                            <cfif application.model.ServiceManager.verifyRequiredServiceSelections(0,local.currentCartLine.getPhone().getProductID(),application.model.CartHelper.getLineSelectedFeatures(local.iLine))>
                                                <cfset local.stepClassName = "complete" />
                                            <cfelse>
                                                <cfset local.stepClassName = "notComplete" />
                                            </cfif>
                                        <cfelse>
                                            <cfset local.stepClassName = "disabled" />
                                        </cfif>

                                    </cfif>

								<cfelseif session.cart.getPrePaid()>
									<cfset local.stepClassName = "disabled" />
								<cfelse>
									<cfset local.stepClassName = "notComplete" />
								</cfif>
								<li class="step_3 #local.stepClassName#">
									<!--- if features have been selected --->
									<cfset local.currentCartLineFeatures = local.currentCartLine.getFeatures() />
									<cfif arrayLen(local.currentCartLineFeatures)>
										<span>Selected Services</span>
										<cfset local.thisURL = getLink(lineNumber="#local.iLine#",do="planSelectServices") / >
										<a href="#local.thisURL#">#arrayLen(local.currentCartLineFeatures)# Service<cfif arrayLen(local.currentCartLineFeatures) gt 1>s</cfif></a>
									<cfelseif session.cart.getActivationType() eq "nocontract" >	
										<span>Select Services</span>
										<a href="##" onclick="alert('You have a No Contract Phone in your cart, so you may not select services.');return false;"><em>Disabled</em></a>
									<cfelseif session.cart.getActivationType() eq "upgrade" and session.cart.getUpgradeType() eq "equipment-only" and local.currentCartLine.getPlan().hasBeenSelected()>
										<span>Select Services</span>
										<cfif application.model.ServiceManager.getDeviceMinimumRequiredServices( ProductId = local.currentCartLine.getPhone().getProductID(), CartTypeId = application.model.cart.getCartTypeId(session.cart.getActivationType()) ).recordCount>
											<cfif application.model.ServiceManager.verifyRequiredServiceSelections(0,local.currentCartLine.getPhone().getProductID(),application.model.CartHelper.getLineSelectedFeatures(local.iLine))>
												<a href="#local.thisURL#">#arrayLen(local.currentCartLineFeatures)# Service<cfif arrayLen(local.currentCartLineFeatures) gt 1>s</cfif></a>
											<cfelseif arrayLen(local.currentCartLineFeatures)>
												<a href="#local.thisURL#">#arrayLen(local.currentCartLineFeatures)# Service<cfif arrayLen(local.currentCartLineFeatures) gt 1>s</cfif></a>
											<cfelse>
												<a href="#local.thisURL#">Not Selected</a>
											</cfif>
										<cfelse>
											<a href="##" onclick="alert('You have indicated an handset-only upgrade, so you may not select services.');return false;"><em>Disabled</em></a>
										</cfif>
									<cfelseif session.cart.getPrePaid()>
										<span>Select Services</span>
										<a href="##" onclick="alert('You have a Prepaid Phone in your cart, so you may not select services.');return false;"><em>Disabled</em></a>

                                    <cfelseif session.cart.getAddALineType() eq "Family">
                                    	<span>Select Services</span>
										<cfif not local.currentCartLine.getPhone().hasBeenSelected()>
											<cfset local.thisURL = getLink(lineNumber="#local.iLine#",do="browsePhones") />
											<a href="#local.thisURL#">Select Phone First</a>
										<cfelse>
											<cfset local.thisURL = getLink(lineNumber="#local.iLine#",do="services") />
											<a href="#local.thisURL#">Select Services</a>
                                      	</cfif>
                                    <cfelse>
										<span>Select Services</span>
										<cfif not local.currentCartLine.getPhone().hasBeenSelected()>
											<cfset local.thisURL = getLink(lineNumber="#local.iLine#",do="browsePhones") />
											<a href="#local.thisURL#">Select Phone First</a>
										<cfelseif not local.currentCartLine.getPlan().hasBeenSelected()>
											<cfset local.thisURL = getLink(lineNumber="#local.iLine#",do="browsePlans") />
											<a href="#local.thisURL#">Select Service Plan First</a>
										<cfelse>
											<cfset local.thisURL = getLink(lineNumber="#local.iLine#",do="planSelectServices") />
											<a href="#local.thisURL#">Not Selected</a>
										</cfif>
									</cfif>
								</li>

								<!--- this next if block is here because doing it inline in the LI tag was adding newline characters inside the classname, which was screwing up the javascript --->
								<cfset local.thisLineAccessories = application.model.CartHelper.lineGetAccessoriesByType(line=local.iLine,type="accessory") />
								<cfif arrayLen(local.thisLineAccessories)>
									<cfset local.stepClassName = "complete" />
								<cfelse>
									<cfset local.stepClassName = "notComplete" />
								</cfif>
								<li class="step_4 #local.stepClassName#">
									<!--- if accessories have been selected --->
									<cfset local.currentCartLineAccessories = local.thisLineAccessories />
									<cfif arrayLen(local.currentCartLineAccessories)>
										<span>Accessories</span>
										<cfset local.thisURL = getLink(lineNumber="#local.iLine#",do="browseAccessories") />
										<a href="#local.thisURL#">#arrayLen(local.currentCartLineAccessories)# Accessor<cfif arrayLen(local.currentCartLineAccessories) gt 1>ies<cfelse>y</cfif></a>
									<cfelse>
										<span>Select Accessories</span>
										<cfset local.thisURL = getLink(lineNumber="#local.iLine#",do="browseAccessories") />
										<a href="#local.thisURL#">Not Selected</a>
									</cfif>
								</li>
								<li class="cart" style="cursor:pointer;cursor:hand;" onclick="location.href='/index.cfm/go/cart/do/view/';"><span>Cart</span></li>
							</ul>
						</cfloop>
					</div>
				</cfoutput>
			</cfsavecontent>
		</cfif>

		<cfreturn trim(local.html)>
	</cffunction>

	<cffunction name="getLink" access="public" returntype="string" output="false">
		<cfargument name="lineNumber" type="numeric" required="true" />
		<cfargument name="do" type="string" required="false" default="browsePhones" />
		<cfargument name="productID" type="string" required="false" default="0" />
		<cfargument name="cartLines" type="array" required="false" default="#arrayNew(1)#" />

		<cfset var local = structNew() />

		<cfset local.planType = session.cart.getActivationType() />
		<cfset local.href = '' />

		<cfif arguments.lineNumber neq request.config.otherItemsLineNumber>
			<cfif not arrayLen(arguments.cartLines)>
				<cfset local.cartLines = session.cart.getLines() />
			<cfelse>
				<cfset local.cartLines = arguments.cartLines />
			</cfif>

			<cfset local.thisLine = local.cartLines[arguments.lineNumber] />
			<cfset local.href = '/cartCurrentLine/' & arguments.lineNumber />

			<cfif arguments.do is 'browsePhones'>
				<cfif local.thisLine.getPlan().hasBeenSelected()>
					<!--- Select Filter ID by Device Carrier --->
					<cfquery name="qry_getCarrierId" datasource="#application.dsn.wirelessAdvocates#">
						SELECT	p.carrierId
						FROM	catalog.dn_plans AS p WITH (NOLOCK)
						WHERE	p.productId	=	<cfqueryparam value="#local.thisLine.getPlan().getProductId()#" cfsqltype="cf_sql_integer" />
					</cfquery>


					<cfif qry_getCarrierId.recordCount>
						<cfif qry_getCarrierId.carrierId eq 109>
							<cfset local.href = local.href & '/cID/1/which/' & arguments.do & '/' />
						<cfelseif qry_getCarrierId.carrierId eq 128>
							<cfset local.href = local.href & '/cID/2/which/' & arguments.do & '/' />
						<cfelseif qry_getCarrierId.carrierId eq 42>
							<cfset local.href = local.href & '/cID/3/which/' & arguments.do & '/' />
						<cfelseif qry_getCarrierId.carrierId eq 299>
							<cfset local.href = local.href & '/cID/230/which/' & arguments.do & '/' />
						</cfif>
					</cfif>
				</cfif>
			<cfelseif arguments.do is 'browseTablets'>
				<cfif local.thisLine.getPlan().hasBeenSelected()>
					<!--- Select Filter ID by Device Carrier --->
					<cfquery name="qry_getCarrierId" datasource="#application.dsn.wirelessAdvocates#">
						SELECT	p.carrierId
						FROM	catalog.dn_plans AS p WITH (NOLOCK)
						WHERE	p.productId	=	<cfqueryparam value="#local.thisLine.getPlan().getProductId()#" cfsqltype="cf_sql_integer" />
					</cfquery>


					<cfif qry_getCarrierId.recordCount>
						<cfif qry_getCarrierId.carrierId eq 109>
							<cfset local.href = local.href & '/cID/1/which/' & arguments.do & '/' />
						<cfelseif qry_getCarrierId.carrierId eq 128>
							<cfset local.href = local.href & '/cID/2/which/' & arguments.do & '/' />
						<cfelseif qry_getCarrierId.carrierId eq 42>
							<cfset local.href = local.href & '/cID/3/which/' & arguments.do & '/' />
						<cfelseif qry_getCarrierId.carrierId eq 299>
							<cfset local.href = local.href & '/cID/230/which/' & arguments.do & '/' />
						</cfif>
					</cfif>
				</cfif>
			<cfelseif arguments.do is 'phoneDetails'>
				<cfif local.thisLine.getPhone().hasBeenSelected()>
					<cfset local.href = local.href & '/phoneID/' & local.thisLine.getPhone().getProductID() />
				</cfif>
			<cfelseif arguments.do is 'tabletDetails'>
				<cfif local.thisLine.getPhone().hasBeenSelected()>
					<cfset local.href = local.href & '/phoneID/' & local.thisLine.getPhone().getProductID() />
				</cfif>
			<cfelseif arguments.do is 'dataCardDetails'>
				<cfif local.thisLine.getPhone().hasBeenSelected()>
					<cfset local.href = local.href & '/productID/' & local.thisLine.getPhone().getProductID() />
				</cfif>
			<cfelseif arguments.do is 'prepaidDetails'>
				<cfif local.thisLine.getPhone().hasBeenSelected()>
					<cfset local.href = local.href & '/productID/' & local.thisLine.getPhone().getProductID() />
				</cfif>
			<cfelseif arguments.do is 'browsePlans'>
				<cfif local.thisLine.getPhone().hasBeenSelected()>
					<!---
					**
					* Select Filter ID by Device Carrier.
					**
					--->
					<cfquery name="qry_getCarrierId" datasource="#application.dsn.wirelessAdvocates#">
						SELECT	p.carrierId
						FROM	catalog.dn_phones AS p WITH (NOLOCK)
						WHERE	p.productId	=	<cfqueryparam value="#local.thisLine.getPhone().getProductId()#" cfsqltype="cf_sql_integer" />
						UNION
						SELECT	p.carrierId
						FROM	catalog.dn_tablets AS p WITH (NOLOCK)
						WHERE	p.productId	=	<cfqueryparam value="#local.thisLine.getPhone().getProductId()#" cfsqltype="cf_sql_integer" />
					</cfquery>

					<cfif qry_getCarrierId.recordCount>
						<cfif qry_getCarrierId.carrierId eq 109>
							<cfset local.href = local.href & '/cID/36/which/' & arguments.do & '/' />
						<cfelseif qry_getCarrierId.carrierId eq 128>
							<cfset local.href = local.href & '/cID/37/which/' & arguments.do & '/' />
						<cfelseif qry_getCarrierId.carrierId eq 42>
							<cfset local.href = local.href & '/cID/38/which/' & arguments.do & '/' />
						<cfelseif qry_getCarrierId.carrierId eq 299>
							<cfset local.href = local.href & '/cID/231/which/' & arguments.do & '/' />
						</cfif>
					</cfif>
				</cfif>
			<cfelseif arguments.do is 'planDetails'>
				<cfif local.thisLine.getPlan().hasBeenSelected()>
					<cfset local.href = local.href & '/planID/' & local.thisLine.getPlan().getProductID() />
				</cfif>
			<cfelseif arguments.do is 'planSelectServices'>
				<cfif local.thisLine.getPlan().hasBeenSelected()>
					<cfset local.href = local.href & '/planID/' & local.thisLine.getPlan().getProductID() />
				</cfif>
			<cfelseif arguments.do is 'browseAccessories'>
				<cfset local.href = local.href & '/accessoryFilter.submit/1' />

				<cfif local.thisLine.getPhone().hasBeenSelected()>
					<cfset local.href = local.href & '/filter.phoneID/' & local.thisLine.getPhone().getProductID() />
				</cfif>
			<cfelseif arguments.do is 'accessoryDetails'>
				<cfset local.href = local.href & '/product_id/' & arguments.productID />
			</cfif>
		<cfelse>
			<cfif arguments.do is 'browseAccessories'>
				<!--- Do Nothing --->
			<cfelseif arguments.do is 'accessoryDetails'>
				<cfset local.href = local.href & '/product_id/' & arguments.productID />
			<cfelseif arguments.do is 'prepaidDetails'>
				<cfset local.href = local.href & '/productId/' & arguments.productID />
			</cfif>
		</cfif>

		<cfset local.href = '/index.cfm/go/shop/do/' & arguments.do & local.href />

		<cfreturn trim(local.href) />
	</cffunction>

	<cffunction name="getAssetPaths" access="private" output="false" returntype="struct">
    	<cfreturn variables.instance.assetPaths />
    </cffunction>
    <cffunction name="setAssetPaths" access="private" output="false" returntype="void">
    	<cfargument name="theVar" required="true" />
    	<cfset variables.instance.assetPaths = arguments.theVar />
    </cffunction>

	<cffunction name="getChannelConfig" access="private" output="false" returntype="struct">
    	<cfreturn variables.instance.ChannelConfig />
    </cffunction>
    <cffunction name="setChannelConfig" access="private" output="false" returntype="void">
    	<cfargument name="ChannelConfig" required="true" />
    	<cfset variables.instance.ChannelConfig = arguments.ChannelConfig />
    </cffunction>

	<cffunction name="getStringUtil" access="private" output="false" returntype="struct">
    	<cfreturn variables.instance.StringUtil />
    </cffunction>
    <cffunction name="setStringUtil" access="private" output="false" returntype="void">
    	<cfargument name="StringUtil" required="true" />
    	<cfset variables.instance.StringUtil = arguments.StringUtil />
    </cffunction>

</cfcomponent>
