<cfcomponent output="false" displayname="dBuilderCartFacade" extends="fw.model.BaseService">


	<cfproperty name="DBuilderCart" inject="id:DBuilderCart" />
	<cfproperty name="DBuilderCartHelper" inject="id:DBuilderCartHelper" />
	<cfproperty name="DBuilderCartItem" inject="id:DBuilderCartItem" />
	<cfproperty name="DBuilderCartPriceBlock" inject="id:DBuilderCartPriceBlock" />
	
	<cffunction name="init" returntype="fw.model.shopping.dBuilderCartFacade" >
		<cfargument name="cart" type="fw.model.shopping.dBuilderCart" required="true" />
		<cfset variables.instance = StructNew() />
		<cfset setCart(arguments.cart) />
		<cfreturn this>
	</cffunction>
	

	<cffunction name="addItem" access="public" returnType="void">
		<cfargument name="order_id" type="numeric" default="0" /> <!--- the order/cart id - 0 indicates we don't have one yet --->
		<cfargument name="line_id" type="numeric" default="0" /> <!--- this will be used to determine to which line an item is being added (this should be an OrdersWireless.ow_id value) - 0 indicates we don't have one yet --->
		<cfargument name="cartLineNumber" type="numeric" default="0" /> <!--- this will be used to determine to which line an item is being added (this relates to an array index in cart.lines[]) - 0 indicates we don't have one yet --->
		<cfargument name="cartLineAlias" type="string" default="" /> <!--- this will be used to alias the cart line if it has been supplied by the user --->
		<cfargument name="productType" type="string" /> <!--- indicates the type of product being added to the cart since we'll likely need different logic for various product types --->
		<cfargument name="product_id" type="string" /> <!--- this is a string because we might get integer or string data (e.g. plans) --->
		<cfargument name="qty" type="string" default="1" />
		<cfargument name="price" default="0" />
		<cfargument name="phoneType" default="" type="string" />

		<cfif arguments.qty eq ''>
			<cfset arguments.qty = 1 />
		</cfif>

		<cfset arguments.product_id = trim(arguments.product_id) />
		<cfset request.layoutFile = 'noLayout' />
		
		

		<!--- TODO: Pull out Activation type from the product type variable --->
		<cfif arguments.productType contains ':'>
			<cfset arguments.productType_orig = arguments.productType />
			<cfset arguments.productType = listFirst(arguments.productType_orig, ':') />

			<cfif listFindNoCase('phone,tablet,dataCardAndNetbook,prepaid', arguments.productType)>
				<cfset request.p.activationType = listGetAt(arguments.productType_orig, 2, ':') />
			<cfelse>
				<cfset request.p.activationType = 'new' />
			</cfif>
		</cfif>

		<!--- Use new activation options from Activation type prompt --->
		<cfif StructKeyExists(request.p, 'ActivationPriceOption')>
			<cfset request.p.activationType = request.p.ActivationPriceOption />
			<cfset request.p.phoneType = request.p.ActivationPriceOption />
		</cfif>

		<cfparam name="request.p.featureIDs" default="" type="string" />
		<cfset request.p.changingPlanFeatures = false />

		<cfif arguments.product_id contains ':' and listLen(arguments.product_id, ':') gte 2>
			<cfset request.p.changingPlanFeatures = true />
			<cfset request.p.featureIDs = listChangeDelims(listGetAt(arguments.product_id, 2, ':'), ',', ',') />
			<cfset arguments.product_id = listFirst(arguments.product_id, ':') />
		<cfelseif arguments.product_id contains ':'>
			<cfset arguments.product_id = listFirst(arguments.product_id, ':') />
		</cfif>

		<!--- Check availability --->
		<cfif listFindNoCase('phone,tablet,dataCardAndNetbook,prepaid', arguments.productType) && application.model[arguments.productType].getAvailableInventoryCount( arguments.product_id ) lte 0>
			<cfset request.p.CartMessage = '<p>The device you wish to purchase is no longer available.</p><p>Please select <a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0/">another device<a/>.</p>' />
			<cfinclude template="/views/cart/dsp_cartMessage.cfm" />
			 
			<cfexit method="exittag" />
		</cfif>

		<cfif listFindNoCase('phone,tablet,dataCardAndNetbook,prepaid', arguments.productType)>
			<cfset request.p.phoneType = request.p.activationType />
			<cfset arguments.product_id = listFirst(arguments.product_id, ':') />

		<cfif request.p.phoneType contains 'financed'>			
			<cfset request.p.price = application.model[arguments.productType].getPriceByPhoneIdAndMode(phoneID = arguments.product_id, mode = 'financed') />
		<cfelse>
			<cfset request.p.price = application.model[arguments.productType].getPriceByPhoneIdAndMode(phoneID = arguments.product_id, mode = request.p.phoneType) />
		</cfif>

		</cfif>

		<cfif listFindNoCase('phone,tablet,dataCardAndNetbook,prepaid', arguments.productType)>
			<cfset local_phone = application.model[arguments.productType].getByFilter(idList = arguments.product_id) />
		<cfelseif arguments.productType is 'plan'>
			<cfset local_plan = application.model.plan.getByFilter(idList = arguments.product_id) />
		</cfif>

		<cfset request.cartAddedFirstLine = false />

		<cfif not structKeyExists(session, 'cart') or (structKeyExists(session, 'cart') and not isStruct(session.cart))>
			<cfset session.cart = createObject('component', 'cfc.model.Cart').init() />
			 
		</cfif>

		<cfset local.arrErrors = application.model.cartHelper.validateAddItem(argumentCollection = request.p) />

		<cfif arrayLen(local.arrErrors)>
			<cfoutput>
				<cfinclude template="/views/cart/dsp_cartErrors.cfm" />
			</cfoutput>
			<cfexit method="exittag" />
		</cfif>

		<cfset cartLines = session.cart.getLines() />
		<!--- This forces activationTypes set to financed-XX-new-upgrade-addaline to go through dsp_dialogGetZipCode.
		This is wanted to have the selected request.p.activationType = request.p.ActivationPriceOption. This was needed to accomodate financing  --->
		<cfif IsDefined("Session.VFD.access") and Session.VFD.access>
			<cfif (isDefined('request.p.activationType') AND (request.p.activationType CONTAINS "-new-upgrade-addaline"))>
				<cfif isDefined('session.cart.ZipCode') and ('session.cart.ZipCode' neq '00000')>
					<cfset session.cart.cartZipCode = session.cart.getZipCode()/>
				</cfif>
				<cfset session.cart.setZipcode('00000')/>
			</cfif>
		</cfif>
		
		<cfif structKeyExists(request, 'p') and structKeyExists(request.p, 'zipcode')>
			<cfset request.p.zipcode = trim(request.p.zipcode) />
			<cfset local.blnValidZipcode = false />

			<cfif isValid('zipcode', listFirst(request.p.zipcode, '-')) and application.model.market.getByZipCode(listFirst(request.p.zipcode, '-')).recordCount>
				<cfset local.blnValidZipcode = true />
			</cfif>

			<cfif local.blnValidZipcode>
				<cfset session.cart.setZipcode(listFirst(request.p.zipcode, '-')) />
				 
			<cfelse>
				<cfset request.zipcodeError = 'Please enter a valid zip code.' />
			</cfif>
		</cfif>
		<!--- Prompt for zipcode and verify activation type --->
		<cfif (listFindNoCase('phone,tablet,dataCardAndNetBook,prepaid,service', arguments.productType))>
			<cfif not application.model.cartHelper.zipCodeEntered()>
				<cfset qDevice = application.model[arguments.productType].getByFilter( idList = arguments.product_id, allowHidden = true ) />				
				<cfinclude template="/views/cart/dsp_dialogGetZipCode.cfm" />
				<cfexit method="exittag" />
			</cfif>
		</cfif>

		<cfif structKeyExists(request, 'p') and structKeyExists(request.p, 'upgradeType')>
			<cfset session.cart.setActivationType('upgrade') />
			<cfset session.cart.setUpgradeType(request.p.upgradeType) />
			 
			<cfset request.p.isUpgradeTypeSet = true />
		</cfif>

		<cfif isDefined('request.p.activationType') and request.p.activationType contains 'upgrade'>
			<cfset local.cartLines = session.cart.getLines() />

			<cfif Len(Trim(session.cart.getUpgradeType()))>

				<cfif not isDefined('request.p.isUpgradeTypeSet')>
					<cfif session.cart.getCurrentLine() eq 0>
						<cfset currentLine = 1 />
					<cfelse>
						<cfset currentLine = session.cart.getCurrentLine() />
					</cfif>

					<cfset selectedServices = application.model.CartHelper.getLineSelectedFeatures( currentLine ) />
					<cfset requiredServices = application.model.ServiceManager.getDeviceMinimumRequiredServices(arguments.product_id) />

					<cfif session.cart.getUpgradeType() eq 'equipment-only' and requiredServices.RecordCount>

						<!--- TODO: Skip this is services have been chosen ? Need line number??? --->
						<cfinclude template="/views/cart/dsp_dialogUpgradeRequiredService.cfm" />
						<cfexit method="exittag" />
					</cfif>
				</cfif>
			<cfelse>
				<cfinclude template="/views/cart/dsp_dialogUpgradeType.cfm" />
				<cfexit method="exittag" />
			</cfif>

		</cfif>

		
		<cfif session.cart.getCarrierId() eq 0>
			<cfset carrierId = application.model.phone.getCarrierIDbyProductID(arguments.product_id) />
		<cfelse>
			<cfset carrierId = session.cart.getCarrierId() />
		</cfif>

		<!--- Add a Line --->
		<cfif isDefined('request.p.addALineType')>
			<cfset session.cart.setActivationType('addaline') />
			<cfset session.cart.setAddALineType(request.p.addALineType) />
			 

			<cfif variables.carrierId eq 128 and session.cart.getAddALineType() is 'FAMILY'>
				<cfset session.cart.setHasUnlimitedPlan(request.p.hasUnlimitedPlan) />
			</cfif>
		
			<cfif variables.carrierId eq 109 and session.cart.getAddALineType() is 'FAMILY'>
				<cfset session.cart.setHasSharedPlan(request.p.HasSharedPlan) />
			</cfif>
		</cfif>
		<!--- End Add a Line --->

		<cfif isDefined('request.p.activationType') and request.p.activationType contains 'addaline' and not len(trim(session.cart.getAddALineType()))>
			<cfif not application.model.cartHelper.zipCodeEntered()>
				<cfoutput>
					<cfinclude template="/views/cart/dsp_dialogGetZipCode.cfm" />
				</cfoutput>

				<cfexit method="exittag" />
			</cfif>

			<cfset local.cartLines = session.cart.getLines() />

			<cfif arraylen(local.cartLines) eq 0>
				<cfoutput>
					<cfinclude template="/views/cart/dsp_dialogAddALineType.cfm" />
				</cfoutput>

				<cfexit method="exittag" />
			</cfif>
		</cfif>

		<!--- If the user is adding a phone or a plan to a cart. --->
		<cfif listFindNoCase('phone,tablet,dataCardAndNetBook,prepaid,service', arguments.productType)>

			<!--- If there are no lines in the cart yet or the user is adding a qty greater than 1. --->
			<cfif arguments.qty gt 1>
				<cfif not arrayLen(session.cart.getLines())>
					<cfset request.cartAddedFirstLine = true />
				</cfif>

				<cfset local.freeAccessories = application.model[arguments.productType].getFreeAccessories(arguments.product_id) />

				<cfloop from="1" to="#arguments.qty#" index="iQty">
					<cfif arrayLen(session.cart.getLines()) lt request.config.maxLines>
						<cfset request.p.cartLineNumber = (arrayLen(session.cart.getLines()) + 1) />
						<cfset arrErrors = application.model.cartHelper.validateAddItem(argumentCollection = request.p) />

						<cfif arrayLen(variables.arrErrors)>
							<cfoutput>
								<cfinclude template="/views/cart/dsp_cartErrors.cfm" />
							</cfoutput>

							<cfexit method="exittag" />
						</cfif>

						<!--- Add a line to the cart. --->
						<cfset request.p.cartLineNumber = application.model.cartHelper.addLineToCart() />
						<cfset cartLines = session.cart.getLines() />
						<cfset thisLine = variables.cartLines[request.p.cartLineNumber] />

						<cfif listFindNoCase('phone,tablet,dataCardAndNetbook,prepaid', arguments.productType)>
							<cfset cartLines[request.p.cartLineNumber].getPhone().setProductID(arguments.product_id) />
							<cfset cartLines[request.p.cartLineNumber].getPhone().setGersSKU(application.model.OrderDetail.getGersSkuByProductId(arguments.product_id)) />
							<cfset cartLines[request.p.cartLineNumber].getPhone().getPrices().setDueToday(request.p.price) />
							<cfset cartLines[request.p.cartLineNumber].getPhone().getPrices().setCOGS(application.model.product.getCOGS(arguments.product_id)) />
							
							<cfif request.p.activationType contains 'financed'>
								<cfset cartLines[request.p.cartLineNumber].getPhone().getPrices().setRetailPrice(application.model[arguments.productType].getPriceByProductIDAndMode(productId = arguments.product_id, mode = 'financed')) />
							<cfelse>
								<cfset cartLines[request.p.cartLineNumber].getPhone().getPrices().setRetailPrice(application.model[arguments.productType].getPriceByProductIDAndMode(productId = arguments.product_id, mode = 'retail')) />
							</cfif>
							
							<cfset cartLines[request.p.cartLineNumber].getPhone().setType('device') />

							<cfset session.cart.setCarrierId(application.model[arguments.productType].getCarrierIdByProductId(arguments.product_id)) />
							<cfset cartLines[request.p.cartLineNumber].getPhone().setDeviceServiceType( application.model[arguments.productType].getDeviceServiceType( arguments.product_id, session.cart.getCarrierId() ) )/>

							<!--- Clear any other free accessories on this line. --->
							<cfset application.model.cartHelper.clearLineFreeAccessories(lineNumber = request.p.cartLineNumber) />

							<cfif local.freeAccessories.recordCount>
								<cfset local.thisLineAccessories = variables.cartLines[request.p.cartLineNumber].getAccessories() />

								<cfloop query="local.freeAccessories">
									<cfset local.thisFreeAccessory = createObject('component', 'cfc.model.CartItem').init() />
									<cfset local.thisFreeAccessory.setProductId(local.freeAccessories.productId[local.freeAccessories.currentRow]) />
									<cfset local.thisFreeAccessory.setType('bundled') />
									<cfset local.thisFreeAccessory.getPrices().setDueToday(0) />
									<cfset local.thisFreeAccessory.getPrices().setCOGS(application.model.product.getCOGS(local.freeAccessories.productId[local.freeAccessories.currentRow])) />
									<cfset local.thisFreeAccessory.getPrices().setRetailPrice(local.freeAccessories.price_retail[local.freeAccessories.currentRow]) />

									<cfset arrayAppend(local.thisLineAccessories, local.thisFreeAccessory) />
								</cfloop>

								<cfset cartLines[request.p.cartLineNumber].setAccessories(local.thisLineAccessories) />
							</cfif>

							<cfset session.cart.setLines(variables.cartLines) />
							<!--- Check for new family plans --->
							<cfif session.cart.getActivationType() is 'new' and session.cart.getHasFamilyPlan()>
								<cfset session.cart.setActivationType('new') />
							<cfelseif session.cart.getActivationType() is 'addaline' and session.cart.getHasFamilyPlan()>	
								<cfset session.cart.setActivationType('addaline') />
							<cfelse>
								<cfset session.cart.setActivationType(trim(request.p.activationType)) />
							</cfif>

							<cfif arguments.productType is 'prepaid'>
								<cfset session.cart.setPrepaid(true) />
							</cfif>

							<!--- Add default plan & services --->
							<cfif arguments.productType EQ 'phone'
								AND NOT cartLines[request.p.cartLineNumber].getPlan().getProductId() AND
								( ( session.cart.getActivationType() CONTAINS 'new' AND NOT session.cart.getHasFamilyPlan() )
								  OR ( session.cart.getActivationType() CONTAINS 'upgrade' AND session.cart.getUpgradeType() eq 'equipment+plan' )
								  OR ( session.cart.getActivationType() CONTAINS 'addaline' AND session.cart.getAddALineType() eq 'ind') )>

								<cfset application.model.CartHelper.addDefaultPlanAndServices( cartLines[request.p.cartLineNumber], arguments.product_id ) />
							</cfif>
							<cfif arguments.productType EQ 'tablet'
								AND NOT cartLines[request.p.cartLineNumber].getPlan().getProductId() AND
								( ( session.cart.getActivationType() CONTAINS 'new' AND NOT session.cart.getHasFamilyPlan() )
								  OR ( session.cart.getActivationType() CONTAINS 'upgrade' AND session.cart.getUpgradeType() eq 'equipment+plan' )
								  OR ( session.cart.getActivationType() CONTAINS 'addaline' AND session.cart.getAddALineType() eq 'ind') )>

								<cfset application.model.CartHelper.addDefaultPlanAndServices( cartLines[request.p.cartLineNumber], arguments.product_id ) />
							</cfif>

							<cfset session.phoneFilterSelections.filterOptions = 0 />
							<cfset session.phoneFilterSelections.filterOptions = listAppend(session.phoneFilterSelections.filterOptions, filterHelper.getFilterOptionId('phone', 'planType', request.p.activationType)) />
							<cfset session.phoneFilterSelections.filterOptions = listAppend(session.phoneFilterSelections.filterOptions, filterHelper.getFilterOptionId('phone', 'carrierId', local_phone.carrierID)) />
							<cfset session.tabletFilterSelections.filterOptions = 0 />
							<cfset session.tabletFilterSelections.filterOptions = listAppend(session.tabletFilterSelections.filterOptions, filterHelper.getFilterOptionId('tablet', 'planType', request.p.activationType)) />
							<cfset session.tabletFilterSelections.filterOptions = listAppend(session.tabletFilterSelections.filterOptions, filterHelper.getFilterOptionId('tablet', 'carrierID', local_phone.carrierID)) />
							<cfset session.dataCardAndNetbookFilterSelections.filterOptions = 0 />
							<cfset session.dataCardAndNetbookFilterSelections.filterOptions = listAppend(session.dataCardAndNetbookFilterSelections.filterOptions, filterHelper.getFilterOptionId('dataCardAndNetbook', 'planType', request.p.activationType)) />
							<cfset session.dataCardAndNetbookFilterSelections.filterOptions = listAppend(session.dataCardAndNetbookFilterSelections.filterOptions, filterHelper.getFilterOptionId('dataCardAndNetbook', 'carrierID', local_phone.carrierID)) />
							<cfset session.prePaidFilterSelections.filterOptions = 0 />
							<cfset session.prePaidFilterSelections.filterOptions = listAppend(session.prePaidFilterSelections.filterOptions, filterHelper.getFilterOptionId('prepaid', 'planType', request.p.activationType)) />
							<cfset session.prePaidFilterSelections.filterOptions = listAppend(session.prePaidFilterSelections.filterOptions, filterHelper.getFilterOptionId('prepaid', 'carrierID', local_phone.carrierID)) />
							<cfset session.planFilterSelections.filterOptions = 0 />
							<cfset session.planFilterSelections.filterOptions = listAppend(session.planFilterSelections.filterOptions, filterHelper.getFilterOptionId('plan', 'carrierID', local_phone.carrierID)) />

							<cfset thisProductClass = application.model[arguments.productType].getProductClassByProductID(arguments.product_id) />

							<cfif arguments.productType is not 'dataCardAndNetbook'>
								<cfset session.planFilterSelections.filterOptions = listAppend(session.planFilterSelections.filterOptions, filterHelper.getFilterOptionId('plan', 'planType', 'individual'), filterHelper.getFilterOptionId('plan', 'planType', 'family')) />
							<cfelseif arguments.productType is 'dataCardAndNetbook'>
								<cfset session.planFilterSelections.filterOptions = listAppend(session.planFilterSelections.filterOptions, filterHelper.getFilterOptionId('plan', 'planType', 'data')) />
							</cfif>
						<cfelseif arguments.productType is 'plan'>
							<cfif not isNumeric(arguments.product_id)>
								<cfset arguments.product_id = application.model.plan.getPlanIDByPlanStringIDAndZipcode(planStringID = arguments.product_id, zipCode = session.cart.getZipcode()) />
								<cfset thisPlan = application.model.plan.getByFilter(idList = arguments.product_id) />
							</cfif>

							<cfif len(trim(arguments.product_id)) and isNumeric(arguments.product_id)>
								<!---
								**
								* Add this plan to the indicated line.
								**
								--->
								<cfset cartLines[request.p.cartLineNumber].getPlan().setProductID(arguments.product_id) />
								<cfset cartLines[request.p.cartLineNumber].getPlan().setType('rateplan') />
								<cfset cartLines[request.p.cartLineNumber].setPlanType(application.model.plan.getPlanTypeByProductID(arguments.product_id)) />

								<cfset session.cart.setCarrierId(application.model.product.getCarrierIdByProductId(arguments.product_id)) />
								<cfset session.planFilterSelections.filterOptions = 0 />
								<cfset session.planFilterSelections.filterOptions = listAppend(session.planFilterSelections.filterOptions, filterHelper.getFilterOptionId('plan', 'carrierID', local_plan.carrierID)) />
								<cfset session.planFilterSelections.filterOptions = listAppend(session.planFilterSelections.filterOptions, filterHelper.getFilterOptionId('plan', 'planType', local_plan.planType)) />
								<cfset session.phoneFilterSelections.filterOptions = 0 />
								<cfset session.phoneFilterSelections.filterOptions = listAppend(session.phoneFilterSelections.filterOptions, filterHelper.getFilterOptionId('phone', 'carrierID', local_plan.carrierID)) />
								<cfset session.dataCardAndNetbookFilterSelections.filterOptions = 0 />
								<cfset session.dataCardAndNetbookFilterSelections.filterOptions = listAppend(session.dataCardAndNetbookFilterSelections.filterOptions, filterHelper.getFilterOptionId('dataCardAndNetbook', 'carrierID', local_plan.carrierID)) />
								<cfset session.prePaidFilterSelections.filterOptions = 0 />
								<cfset session.prePaidFilterSelections.filterOptions = listAppend(session.prePaidFilterSelections.filterOptions, filterHelper.getFilterOptionId('prepaid', 'carrierID', local_plan.carrierID)) />

								<cfif len(trim(request.p.featureIDs)) and variables.cartLines[request.p.cartLineNumber].getPhone().hasBeenSelected()>
									<cfset local.arrFeatures = arrayNew(1) />

									<cfloop list="#request.p.featureIDs#" index="local.iFeature">
										<cfif isNumeric(local.iFeature)>
											<cfset arrayAppend(local.arrFeatures, createObject('component', 'cfc.model.CartItem').init()) />

											<cfset local.arrFeatures[arrayLen(local.arrFeatures)].setProductID(local.iFeature) />
											<cfset local.arrFeatures[arrayLen(local.arrFeatures)].setType('service') />
										</cfif>
									</cfloop>

									<cfset cartLines[request.p.cartLineNumber].setFeatures(local.arrFeatures) />
								</cfif>

								<cfset session.cart.setLines(variables.cartLines) />

								<cfif variables.thisPlan.planType eq 'family' || (variables.thisPlan.planType eq 'data' && variables.thisPlan.IsShared)>
									<!--- Apply this plan selection to the entire cart, including any existing lines. --->
									<cfset application.model.cartHelper.setFamilyPlan(arguments.product_id) />
								<cfelse>
									<!--- Reset shared family plan --->
									<cfset session.cart.setFamilyPlan( CreateObject("component","cfc.model.CartItem").init() ) />
								</cfif>
							</cfif>
							
						</cfif>

						<cfif len(trim(request.p.featureIDs)) and variables.cartLines[request.p.cartLineNumber].getPhone().hasBeenSelected()>
							<cfset local.arrFeatures = arrayNew(1) />

							<cfloop list="#request.p.featureIDs#" index="local.iFeature">
								<cfif isNumeric(local.iFeature)>
									<cfset arrayAppend(local.arrFeatures, createObject('component', 'cfc.model.CartItem').init()) />

									<cfset local.arrFeatures[arrayLen(local.arrFeatures)].setProductID(local.iFeature) />
									<cfset local.arrFeatures[arrayLen(local.arrFeatures)].setType('service') />
								</cfif>
							</cfloop>

							<cfset cartLines[request.p.cartLineNumber].setFeatures(local.arrFeatures) />
						</cfif>

						<cfset session.cart.setLines(variables.cartLines) />

						<cfset local.getRebates = application.model.rebates.getProductInRebateFilter(productId = arguments.product_id, type = request.p.activationType) />
						<cfset local.rebateArray = session.cart.getRebates() />

						<cfif local.getRebates.recordCount>
							<cfset arrayAppend(local.rebateArray, local.getRebates) />

							<cfset session.cart.setRebates(local.rebateArray) />
						</cfif>
					<cfelse>
						<cfset request.cart.bAddedTooMany = true />
					</cfif>
				</cfloop>

				 
			</cfif>
		</cfif>

		<!---
		**
		* If it is not an accessory then add it to the current line.
		**
		--->
		<cfparam name="arguments.productType" type="string" default="" />
		<cfparam name="arguments.qty" type="numeric" default="1" />

		<cfif listFirst(arguments.productType, ':') is not 'accessory' and arguments.qty eq 1 and request.p.cartLineNumber lt 1>
			<cfset request.p.cartLineNumber = session.cart.getCurrentLine() />
		</cfif>

		<cfif (not request.p.cartLineNumber and application.model.cartHelper.getNumberOfLines()) or (not request.p.cartLineNumber and arguments.productType is 'accessory')>
			<cfoutput>
				<cfinclude template="/views/cart/dsp_dialogWhichLine.cfm" />
			</cfoutput>

			<cfexit method="exittag" />
		<cfelseif not request.p.cartLineNumber>
			<cfset request.p.cartLineNumber = 1 />
		</cfif>

		<!--- If we've been given a line number, but it appears to be a new line not yet in the cart. --->
		<cfif request.p.cartLineNumber and request.p.cartLineNumber gt arrayLen(variables.cartLines) and request.p.cartLineNumber neq request.config.otherItemsLineNumber>
			<!--- Add a new line to the cart. --->
			<cfset request.p.cartLineNumber = application.model.cartHelper.addLineToCart() />
			<cfset cartLines = session.cart.getLines() />
			 
		</cfif>

		<!---
		**
		* Handle the cart add differently based on the product type being added.
		**
		--->
		<cfswitch expression="#arguments.productType#">
			<cfcase value="phone,tablet,dataCardAndNetbook,prepaid">

				<!--- User may be changing device. Remove plans, services, etc for the previous device line. --->
				<cfset application.model.cartHelper.clearLineFreeAccessories(request.p.cartLineNumber) />
				<cfset application.model.cartHelper.removeLineBundledAccessories(request.p.cartLineNumber) />

				<!--- Device change on the current line --->
				<cfif application.model.cartHelper.getLineDeviceProductId( request.p.cartLineNumber ) neq 0>
					<cfif session.cart.getFamilyPlan().hasBeenSelected()>
						<cfset application.model.cartHelper.removeAllLineFeatures(request.p.cartLineNumber) />
					<cfelse>
						<cfset application.model.cartHelper.removePlan(request.p.cartLineNumber) />
					</cfif>
				</cfif>

				<!--- Add this phone to the indicated line. --->
				<cfset cartLines[request.p.cartLineNumber].getPhone().setProductID(arguments.product_id) />
				<cfset cartLines[request.p.cartLineNumber].getPhone().setGersSKU(application.model.OrderDetail.getGersSkuByProductId(arguments.product_id)) />
				<cfset cartLines[request.p.cartLineNumber].getPhone().setType('device') />
				<cfset cartLines[request.p.cartLineNumber].getPhone().getPrices().setDueToday(request.p.price) />
				<cfset cartLines[request.p.cartLineNumber].getPhone().getPrices().setCOGS(application.model.product.getCOGS(arguments.product_id)) />
				<cfset cartLines[request.p.cartLineNumber].setCartLineActivationType(request.p.activationType) />
				
				<cfif request.p.activationType contains 'financed'>
					<cfset cartLines[request.p.cartLineNumber].getPhone().getPrices().setRetailPrice(application.model[arguments.productType].getPriceByProductIDAndMode(productId = arguments.product_id, mode = 'financed')) />
				<cfelse>
					<cfset cartLines[request.p.cartLineNumber].getPhone().getPrices().setRetailPrice(application.model[arguments.productType].getPriceByProductIDAndMode(productId = arguments.product_id, mode = 'retail')) />			
				</cfif>

				<cfset session.cart.setCarrierId(application.model[arguments.productType].getCarrierIdByProductId(arguments.product_id)) />
				<cfset cartLines[request.p.cartLineNumber].getPhone().setDeviceServiceType( application.model[arguments.productType].getDeviceServiceType( arguments.product_id, session.cart.getCarrierId() ) )/>

				<!--- Clear any existing free accessories on this line. --->
				<cfset application.model.cartHelper.clearLineFreeAccessories(lineNumber = request.p.cartLineNumber) />

				<cfset local.freeAccessories = application.model[arguments.productType].getFreeAccessories(arguments.product_id) />
				<cfset local.thisLineAccessories = variables.cartLines[request.p.cartLineNumber].getAccessories() />

				<cfif local.freeAccessories.recordCount>
					<cfloop query="local.freeAccessories">
						<cfset local.thisFreeAccessory = createObject('component', 'cfc.model.CartItem').init() />
						<cfset local.thisFreeAccessory.setProductId(local.freeAccessories.productId[local.freeAccessories.currentRow]) />
						<cfset local.thisFreeAccessory.setType('bundled') />
						<cfset local.thisFreeAccessory.getPrices().setDueToday(0) />
						<cfset local.thisFreeAccessory.getPrices().setCOGS(application.model.product.getCOGS(local.freeAccessories.productId[local.freeAccessories.currentRow])) />
						<cfset local.thisFreeAccessory.getPrices().setRetailPrice(local.freeAccessories.price_retail[local.freeAccessories.currentRow]) />

						<cfset arrayAppend(local.thisLineAccessories, local.thisFreeAccessory) />
					</cfloop>

					<cfset cartLines[request.p.cartLineNumber].setAccessories(local.thisLineAccessories) />
				</cfif>

				<cfif len(trim(request.p.featureIDs)) and variables.cartLines[request.p.cartLineNumber].getPhone().hasBeenSelected()>
					<cfset local.arrFeatures = arrayNew(1) />

					<cfloop list="#request.p.featureIDs#" index="local.iFeature">
						<cfif isNumeric(local.iFeature)>
							<cfset arrayAppend(local.arrFeatures, createObject('component', 'cfc.model.CartItem').init()) />

							<cfset local.arrFeatures[arrayLen(local.arrFeatures)].setProductID(local.iFeature) />
							<cfset local.arrFeatures[arrayLen(local.arrFeatures)].setType('service') />
						</cfif>
					</cfloop>

					<cfset cartLines[request.p.cartLineNumber].setFeatures(local.arrFeatures) />
				</cfif>

				<cfset session.cart.setCurrentLine(request.p.cartLineNumber) />

				<!--- Check for new family plans --->
				<cfif session.cart.getActivationType() contains 'new' and session.cart.getHasFamilyPlan()>
					<!---<cfset session.cart.setActivationType('new') />--->
				<cfelseif session.cart.getActivationType() contains 'addaline' and session.cart.getHasFamilyPlan()>
					<!---<cfset session.cart.setActivationType('addaline') />--->
				<cfelse>
					<cfset session.cart.setActivationType(trim(request.p.activationType)) />
				</cfif>

				<cfif arguments.productType is 'prepaid'>
					<cfset session.cart.setPrepaid(true) />
				</cfif>

				<!--- Add default plan & services --->
				<cfif (arguments.productType EQ 'phone' or arguments.productType EQ 'tablet')
					AND NOT cartLines[request.p.cartLineNumber].getPlan().getProductId() AND
					( ( session.cart.getActivationType() contains 'new' AND NOT session.cart.getHasFamilyPlan() )
					  OR ( session.cart.getActivationType() contains 'upgrade' AND session.cart.getUpgradeType() eq 'equipment+plan' )
					  OR ( session.cart.getActivationType() contains 'addaline' AND session.cart.getAddALineType() eq 'ind') )>

					<cfset application.model.CartHelper.addDefaultPlanAndServices( cartLines[request.p.cartLineNumber], arguments.product_id ) />
				</cfif>

				<cfset session.phoneFilterSelections.filterOptions = 0 />
				<cfset session.phoneFilterSelections.filterOptions = listAppend(session.phoneFilterSelections.filterOptions, filterHelper.getFilterOptionId('phone', 'planType', request.p.activationType)) />
				<cfset session.phoneFilterSelections.filterOptions = listAppend(session.phoneFilterSelections.filterOptions, filterHelper.getFilterOptionId('phone', 'carrierID', local_phone.carrierID)) />
				
				<cfset session.tabletFilterSelections.filterOptions = 0 />
				<cfset session.tabletFilterSelections.filterOptions = listAppend(session.tabletFilterSelections.filterOptions, filterHelper.getFilterOptionId('tablet', 'planType', request.p.activationType)) />
				<cfset session.tabletFilterSelections.filterOptions = listAppend(session.tabletFilterSelections.filterOptions, filterHelper.getFilterOptionId('tablet', 'carrierID', local_phone.carrierID)) />
			
				<cfset session.dataCardAndNetbookFilterSelections.filterOptions = 0 />
				<cfset session.dataCardAndNetbookFilterSelections.filterOptions = listAppend(session.dataCardAndNetbookFilterSelections.filterOptions, filterHelper.getFilterOptionId('dataCardAndNetbook', 'planType', request.p.activationType)) />
				<cfset session.dataCardAndNetbookFilterSelections.filterOptions = listAppend(session.dataCardAndNetbookFilterSelections.filterOptions, filterHelper.getFilterOptionId('dataCardAndNetbook', 'carrierID', local_phone.carrierID)) />
				<cfset session.prePaidFilterSelections.filterOptions = 0 />
				<cfset session.prePaidFilterSelections.filterOptions = listAppend(session.prePaidFilterSelections.filterOptions, filterHelper.getFilterOptionId('prepaid', 'planType', request.p.activationType)) />
				<cfset session.prePaidFilterSelections.filterOptions = listAppend(session.prePaidFilterSelections.filterOptions, filterHelper.getFilterOptionId('prepaid', 'carrierID', local_phone.carrierID)) />
				<cfset session.planFilterSelections.filterOptions = 0 />
				<cfset session.planFilterSelections.filterOptions = listAppend(session.planFilterSelections.filterOptions, filterHelper.getFilterOptionId('plan', 'carrierID', local_phone.carrierID)) />

				<cfset thisProductClass = application.model[arguments.productType].getProductClassByProductID(arguments.product_id) />

				<cfif thisProductClass is 'dataCardAndNetbook' or thisProductClass is 'tablet'>
					<cfset session.planFilterSelections.filterOptions = listAppend(session.planFilterSelections.filterOptions, filterHelper.getFilterOptionId('plan', 'planType', 'data')) />
				<cfelse>
					<cfset session.planFilterSelections.filterOptions = listAppend(session.planFilterSelections.filterOptions, filterHelper.getFilterOptionId('plan', 'planType', 'individual'), filterHelper.getFilterOptionId('plan', 'planType', 'family')) />
				</cfif>
				
				<!--- rewrote this above because it uses assbackwards logic (Scott H) --->
				<!---<cfif variables.thisProductClass is not 'dataCardAndNetbook'>
					<cfset session.planFilterSelections.filterOptions = listAppend(session.planFilterSelections.filterOptions, filterHelper.getFilterOptionId('plan', 'planType', 'individual'), filterHelper.getFilterOptionId('plan', 'planType', 'family')) />
				<cfelseif thisProductClass is 'dataCardAndNetbook' or thisProductClass is 'tablet'>
					<cfset session.planFilterSelections.filterOptions = listAppend(session.planFilterSelections.filterOptions, filterHelper.getFilterOptionId('plan', 'planType', 'data')) />
				</cfif>	--->			 

				<cfset request.hasWirelessItemBeenAdded = true />
				<cfset arguments.productType = '' />

				<cfset local.getRebates = application.model.rebates.getProductInRebateFilter(productId = arguments.product_id, type = request.p.activationType) />
				<cfset local.rebateArray = session.cart.getRebates() />

				<cfif local.getRebates.recordCount>
					<cfset arrayAppend(local.rebateArray, local.getRebates) />

					<cfset session.cart.setRebates(local.rebateArray) />
				</cfif>
	</cffunction>




	
	
	
	
	
	<!--- Setters/Getters --->
		
	<cffunction name="setCart" returnType="void" access="public">
		<cfargument name="cartObj" type="fw.model.shopping.DBuilderCart" required="true"  > 	
		<cfset variables.instance.cart = arguments.cart />	
	</cffunction>	
	
	<cffunction name="getCart" returnType="fw.model.shopping.DBuilderCart" access="public">
		<cfif isdefined("variables.instance.cart")>
			<cfreturn variables.instance.cart />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>
	
</cfcomponent>



