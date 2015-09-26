<cfcomponent output="false" displayname="dBuilderCartFacade" extends="fw.model.BaseService">

	<cfproperty name="DBuilderCart" inject="id:DBuilderCart" />
	<cfproperty name="DBuilderCartHelper" inject="id:DBuilderCartHelper" />
	<cfproperty name="DBuilderCartItem" inject="id:DBuilderCartItem" />
	<cfproperty name="DBuilderCartPriceBlock" inject="id:DBuilderCartPriceBlock" />

	<cfset variables.InstantRebateService = application.wirebox.getInstance("InstantRebateService")>
	<cfset variables.ChannelConfig = application.wirebox.getInstance("ChannelConfig") />
	<cfset variables.filterHelper = application.wirebox.getInstance("FilterHelper") /> 
	<cfset variables.PromotionService = application.wirebox.getInstance("PromotionService") />	
	
	<cfset variables.cartcfc = "cfc.model.cart" />
	<cfset variables.cartItemcfc = "cfc.model.cartItem" />
	<cfset variables.carthelper = "carthelper" />
	
	<cffunction name="init" returntype="fw.model.shopping.dbuilderCartFacade" >
		<!---<cfargument name="cart" type="cfc.model.cart" required="false" default="#session.cart#" />--->
		<cfset variables.instance = StructNew() />
		<!---<cfset setCart(arguments.cart) />--->
		<cfreturn this>
	</cffunction>
	

	<cffunction name="addItem" access="public" returntype="string">
		<cfargument name="order_id" type="numeric" default="0" /> <!--- the order/cart id - 0 indicates we don't have one yet --->
		<cfargument name="line_id" type="numeric" default="0" /> <!--- this will be used to determine to which line an item is being added (this should be an OrdersWireless.ow_id value) - 0 indicates we don't have one yet --->
		<cfargument name="cartLineNumber" type="numeric" default="0" /> <!--- this will be used to determine to which line an item is being added (this relates to an array index in cart.lines[]) - 0 indicates we don't have one yet --->
		<cfargument name="cartLineAlias" type="string" default="" /> <!--- this will be used to alias the cart line if it has been supplied by the user --->
		<cfargument name="productType" type="string" /> <!--- indicates the type of product being added to the cart since we'll likely need different logic for various product types --->
		<cfargument name="product_id" type="string" /> <!--- this is a string because we might get integer or string data (e.g. plans) --->
		<cfargument name="qty" type="string" default="1" />
		<cfargument name="price" default="0" />
		<cfargument name="phoneType" default="" type="string" />

		<cfset var local = structNew() />
		<cfset local.p =  structNew() />
		
		<cfif arguments.qty eq ''>
			<cfset arguments.qty = 1 />
		</cfif>

		<cfset arguments.product_id = trim(arguments.product_id) />
		<!---<cfset request.layoutFile = 'noLayout' />--->
		
		

		<!--- TODO: Pull out Activation type from the product type variable --->
		<cfif arguments.productType contains ':'>
			<cfset arguments.productType_orig = arguments.productType />
			<cfset arguments.productType = listFirst(arguments.productType_orig, ':') />

			<cfif listFindNoCase('phone,tablet,dataCardAndNetbook,prepaid', arguments.productType)>
				<cfset local.p.activationType = listGetAt(arguments.productType_orig, 2, ':') />
			<cfelse>
				<cfset local.p.activationType = 'new' />
			</cfif>
		</cfif>

		<!--- Use new activation options from Activation type prompt --->
		<cfif StructKeyExists(local.p, 'ActivationPriceOption')>
			<cfset local.p.activationType = local.p.ActivationPriceOption />
			<cfset local.p.phoneType = local.p.ActivationPriceOption />
		</cfif>

		<cfparam name="variables.p.featureIDs" default="" type="string" />
		<cfset variables.p.changingPlanFeatures = false />

		<cfif arguments.product_id contains ':' and listLen(arguments.product_id, ':') gte 2>
			<cfset variables.p.changingPlanFeatures = true />
			<cfset variables.p.featureIDs = listChangeDelims(listGetAt(arguments.product_id, 2, ':'), ',', ',') />
			<cfset arguments.product_id = listFirst(arguments.product_id, ':') />
		<cfelseif arguments.product_id contains ':'>
			<cfset arguments.product_id = listFirst(arguments.product_id, ':') />
		</cfif>

		<!--- Check availability --->
		<cfif listFindNoCase('phone,tablet,dataCardAndNetbook,prepaid', arguments.productType) && application.model[arguments.productType].getAvailableInventoryCount( arguments.product_id ) lte 0>
			<!---<cfset local.p.CartMessage = '<p>The device you wish to purchase is no longer available.</p><p>Please select <a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0/">another device<a/>.</p>' />
			<cfinclude template="/views/cart/dsp_cartMessage.cfm" />
			 
			<cfexit method="exittag" />--->
			<cfreturn "not available" />
		</cfif>

		<cfif listFindNoCase('phone,tablet,dataCardAndNetbook,prepaid', arguments.productType)>
			<cfset local.p.phoneType = local.p.activationType />
			<cfset arguments.product_id = listFirst(arguments.product_id, ':') />

			<cfif local.p.phoneType contains 'financed'>			
				<cfset local.p.price = application.model[arguments.productType].getPriceByPhoneIdAndMode(phoneID = arguments.product_id, mode = 'financed') />
			<cfelse>
				<cfset local.p.price = application.model[arguments.productType].getPriceByPhoneIdAndMode(phoneID = arguments.product_id, mode = local.p.phoneType) />
			</cfif>

		</cfif>

		<cfif listFindNoCase('phone,tablet,dataCardAndNetbook,prepaid', arguments.productType)>
			<cfset local.local_phone = application.model[arguments.productType].getByFilter(idList = arguments.product_id) />
		<cfelseif arguments.productType is 'plan'>
			<cfset local.local_plan = application.model.plan.getByFilter(idList = arguments.product_id) />
		</cfif>

		<cfset local.cartAddedFirstLine = false />

		<cfif not structKeyExists(session, 'cart') or (structKeyExists(session, 'cart') and not isStruct(session.cart))>
			<cfset session.cart = createObject('component', '#variables.cartcfc#').init() />			 
		</cfif>


		<!---<cfif arrayLen(local.arrErrors)>
			<cfoutput>
				<cfinclude template="/views/cart/dsp_cartErrors.cfm" />
			</cfoutput>
			<cfexit method="exittag" />
		</cfif>--->

		<cfset local.cartLines = session.cart.getLines() />
		<!--- This forces activationTypes set to financed-XX-new-upgrade-addaline to go through dsp_dialogGetZipCode.
		This is wanted to have the selected local.p.activationType = local.p.ActivationPriceOption. This was needed to accomodate financing  --->
		<cfif IsDefined("Session.VFD.access") and Session.VFD.access>
			<cfif (isDefined('local.p.activationType') AND (local.p.activationType CONTAINS "-new-upgrade-addaline"))>
				<cfif isDefined('session.cart.ZipCode') and ('session.cart.ZipCode' neq '00000')>
					<cfset session.cart.cartZipCode = session.cart.getZipCode()/>
				</cfif>
				<cfset session.cart.setZipcode('00000')/>
			</cfif>
		</cfif>
		
		<cfif structKeyExists(local.p, 'zipcode')>
			<cfset local.p.zipcode = trim(local.p.zipcode) />
			<cfset local.blnValidZipcode = false />

			<cfif isValid('zipcode', listFirst(local.p.zipcode, '-')) and application.model.market.getByZipCode(listFirst(local.p.zipcode, '-')).recordCount>
				<cfset local.blnValidZipcode = true />
			</cfif>

			<cfif local.blnValidZipcode>
				<cfset session.cart.setZipcode(listFirst(local.p.zipcode, '-')) />
				 
			<cfelse>
				<cfreturn 'Invalid zip code' />
			</cfif>
		</cfif>
		
		<!--- Prompt for zipcode and verify activation type --->
		<!---<cfif (listFindNoCase('phone,tablet,dataCardAndNetBook,prepaid,service', arguments.productType))>
			<cfif not application.model.carthelper.zipCodeEntered()>
				<cfset qDevice = application.model[arguments.productType].getByFilter( idList = arguments.product_id, allowHidden = true ) />				
				<cfinclude template="/views/cart/dsp_dialogGetZipCode.cfm" />
				<cfexit method="exittag" />
			</cfif>
		</cfif>--->

		<cfif  structKeyExists(local.p, 'upgradeType')>
			<cfset session.cart.setActivationType('upgrade') />
			<cfset session.cart.setUpgradeType(local.p.upgradeType) />			 
			<cfset local.p.isUpgradeTypeSet = true />
		</cfif>

		<cfif isDefined('local.p.activationType') and local.p.activationType contains 'upgrade'>
			<cfset local.cartLines = session.cart.getLines() />

			<cfif Len(Trim(session.cart.getUpgradeType()))>

				<cfif not isDefined('local.p.isUpgradeTypeSet')>
					<cfif session.cart.getCurrentLine() eq 0>
						<cfset local.currentLine = 1 />
					<cfelse>
						<cfset local.currentLine = session.cart.getCurrentLine() />
					</cfif>

					<cfset local.selectedServices = application.model.carthelper.getLineSelectedFeatures( local.currentLine ) />
					<cfset local.requiredServices = application.model.ServiceManager.getDeviceMinimumRequiredServices(arguments.product_id) />

					<!---<cfif session.cart.getUpgradeType() eq 'equipment-only' and local.requiredServices.RecordCount>

						<!--- TODO: Skip this is services have been chosen ? Need line number??? --->
						<cfinclude template="/views/cart/dsp_dialogUpgradeRequiredService.cfm" />
						<cfexit method="exittag" />
					</cfif>--->
				</cfif>
			<cfelse>
				<!---<cfinclude template="/views/cart/dsp_dialogUpgradeType.cfm" />
				<cfexit method="exittag" />--->
			</cfif>

		</cfif>


		<cfif session.cart.getCarrierId() eq 0>
			<cfset local.carrierId = application.model.phone.getCarrierIDbyProductID(arguments.product_id) />
		<cfelse>
			<cfset local.carrierId = session.cart.getCarrierId() />
		</cfif>

		<!--- Add a Line --->
		<cfif isDefined('local.p.addALineType')>
			<cfset session.cart.setActivationType('addaline') />
			<cfset session.cart.setAddALineType(local.p.addALineType) />
			 

			<cfif variables.carrierId eq 128 and session.cart.getAddALineType() is 'FAMILY'>
				<cfset session.cart.setHasUnlimitedPlan(local.p.hasUnlimitedPlan) />
			</cfif>
		
			<cfif variables.carrierId eq 109 and session.cart.getAddALineType() is 'FAMILY'>
				<cfset session.cart.setHasSharedPlan(local.p.HasSharedPlan) />
			</cfif>
		</cfif>
		<!--- End Add a Line --->

		<cfif isDefined('local.p.activationType') and local.p.activationType contains 'addaline' and not len(trim(session.cart.getAddALineType()))>
			<cfif not application.model.carthelper.zipCodeEntered()>
				<!---<cfoutput>
					<cfinclude template="/views/cart/dsp_dialogGetZipCode.cfm" />
				</cfoutput>

				<cfexit method="exittag" />--->
				<cfreturn "zip code required" />
			</cfif>

			<cfset local.cartLines = session.cart.getLines() />

			<!---<cfif arraylen(local.cartLines) eq 0>
				<cfoutput>
					<cfinclude template="/views/cart/dsp_dialogAddALineType.cfm" />
				</cfoutput>

				<cfexit method="exittag" />
			</cfif>--->
		</cfif>




		<!--- If the user is adding a phone or a plan to a cart. --->
		<cfif listFindNoCase('phone,tablet,dataCardAndNetBook,prepaid,service', arguments.productType)>

			<!--- If there are no lines in the cart yet or the user is adding a qty greater than 1. --->
			<cfif arguments.qty gt 1>
				<cfif not arrayLen(session.cart.getLines())>
					<cfset local.cartAddedFirstLine = true />
				</cfif>

				<cfset local.freeAccessories = application.model[arguments.productType].getFreeAccessories(arguments.product_id) />

				<cfloop from="1" to="#arguments.qty#" index="iQty">
					<cfif arrayLen(session.cart.getLines()) lt request.config.maxLines>
						<cfset arguments.cartLineNumber = (arrayLen(session.cart.getLines()) + 1) />
						<cfset local.arrErrors = application.model.carthelper.validateAddItem(argumentCollection = local.p) />

						<cfif arrayLen(local.arrErrors)>
							<!---<cfoutput>
								<cfinclude template="/views/cart/dsp_cartErrors.cfm" />
							</cfoutput>

							<cfexit method="exittag" /> --->
							<cfreturn "arrErrors" />
						</cfif>

						<!--- Add a line to the cart. --->
						<cfset arguments.cartLineNumber = application.model.carthelper.addLineToCart() />
						<cfset local.cartLines = session.cart.getLines() />
						<cfset local.thisLine = local.cartLines[arguments.cartLineNumber] />

						<cfif listFindNoCase('phone,tablet,dataCardAndNetbook,prepaid', arguments.productType)>
							<cfset local.cartLines[arguments.cartLineNumber].getPhone().setProductID(arguments.product_id) />
							<cfset local.cartLines[arguments.cartLineNumber].getPhone().setGersSKU(application.model.OrderDetail.getGersSkuByProductId(arguments.product_id)) />
							<cfset local.cartLines[arguments.cartLineNumber].getPhone().getPrices().setDueToday(local.p.price) />
							<cfset local.cartLines[arguments.cartLineNumber].getPhone().getPrices().setCOGS(application.model.product.getCOGS(arguments.product_id)) />
							
							<cfif local.p.activationType contains 'financed'>
								<cfset local.cartLines[arguments.cartLineNumber].getPhone().getPrices().setRetailPrice(application.model[arguments.productType].getPriceByProductIDAndMode(productId = arguments.product_id, mode = 'financed')) />
							<cfelse>
								<cfset local.cartLines[arguments.cartLineNumber].getPhone().getPrices().setRetailPrice(application.model[arguments.productType].getPriceByProductIDAndMode(productId = arguments.product_id, mode = 'retail')) />
							</cfif>
							
							<cfset cartLines[arguments.cartLineNumber].getPhone().setType('device') />

							<cfset session.cart.setCarrierId(application.model[arguments.productType].getCarrierIdByProductId(arguments.product_id)) />
							<cfset cartLines[arguments.cartLineNumber].getPhone().setDeviceServiceType( application.model[arguments.productType].getDeviceServiceType( arguments.product_id, session.cart.getCarrierId() ) )/>

							<!--- Clear any other free accessories on this line. --->
							<cfset apapplication.model.carthelper.clearLineFreeAccessories(lineNumber = arguments.cartLineNumber) />

							<cfif local.freeAccessories.recordCount>
								<cfset local.thisLineAccessories = local.cartlines[arguments.cartLineNumber].getAccessories() />

								<cfloop query="local.freeAccessories">
									<cfset local.thisFreeAccessory = createObject('component', '#variables.cartItemcfc#').init() />
									<cfset local.thisFreeAccessory.setProductId(local.freeAccessories.productId[local.freeAccessories.currentRow]) />
									<cfset local.thisFreeAccessory.setType('bundled') />
									<cfset local.thisFreeAccessory.getPrices().setDueToday(0) />
									<cfset local.thisFreeAccessory.getPrices().setCOGS(application.model.product.getCOGS(local.freeAccessories.productId[local.freeAccessories.currentRow])) />
									<cfset local.thisFreeAccessory.getPrices().setRetailPrice(local.freeAccessories.price_retail[local.freeAccessories.currentRow]) />

									<cfset arrayAppend(local.thisLineAccessories, local.thisFreeAccessory) />
								</cfloop>

								<cfset cartLines[arguments.cartLineNumber].setAccessories(local.thisLineAccessories) />
							</cfif>

							<cfset session.cart.setLines(local.cartlines) />
							<!--- Check for new family plans --->
							<cfif session.cart.getActivationType() is 'new' and session.cart.getHasFamilyPlan()>
								<cfset session.cart.setActivationType('new') />
							<cfelseif session.cart.getActivationType() is 'addaline' and session.cart.getHasFamilyPlan()>	
								<cfset session.cart.setActivationType('addaline') />
							<cfelse>
								<cfset session.cart.setActivationType(trim(local.p.activationType)) />
							</cfif>

							<cfif arguments.productType is 'prepaid'>
								<cfset session.cart.setPrepaid(true) />
							</cfif>

							<!--- Add default plan & services --->
							<cfif arguments.productType EQ 'phone'
								AND NOT cartLines[arguments.cartLineNumber].getPlan().getProductId() AND
								( ( session.cart.getActivationType() CONTAINS 'new' AND NOT session.cart.getHasFamilyPlan() )
								  OR ( session.cart.getActivationType() CONTAINS 'upgrade' AND session.cart.getUpgradeType() eq 'equipment+plan' )
								  OR ( session.cart.getActivationType() CONTAINS 'addaline' AND session.cart.getAddALineType() eq 'ind') )>

								<cfset application.model.carthelper.addDefaultPlanAndServices( cartLines[arguments.cartLineNumber], arguments.product_id ) />
							</cfif>
							<cfif arguments.productType EQ 'tablet'
								AND NOT cartLines[arguments.cartLineNumber].getPlan().getProductId() AND
								( ( session.cart.getActivationType() CONTAINS 'new' AND NOT session.cart.getHasFamilyPlan() )
								  OR ( session.cart.getActivationType() CONTAINS 'upgrade' AND session.cart.getUpgradeType() eq 'equipment+plan' )
								  OR ( session.cart.getActivationType() CONTAINS 'addaline' AND session.cart.getAddALineType() eq 'ind') )>

								<cfset application.model.carthelper.addDefaultPlanAndServices( cartLines[arguments.cartLineNumber], arguments.product_id ) />
							</cfif>

							<cfset session.phoneFilterSelections.filterOptions = 0 />
							<cfset session.phoneFilterSelections.filterOptions = listAppend(session.phoneFilterSelections.filterOptions, filterHelper.getFilterOptionId('phone', 'planType', local.p.activationType)) />
							<cfset session.phoneFilterSelections.filterOptions = listAppend(session.phoneFilterSelections.filterOptions, filterHelper.getFilterOptionId('phone', 'carrierId', local_phone.carrierID)) />
							<cfset session.tabletFilterSelections.filterOptions = 0 />
							<cfset session.tabletFilterSelections.filterOptions = listAppend(session.tabletFilterSelections.filterOptions, filterHelper.getFilterOptionId('tablet', 'planType', local.p.activationType)) />
							<cfset session.tabletFilterSelections.filterOptions = listAppend(session.tabletFilterSelections.filterOptions, filterHelper.getFilterOptionId('tablet', 'carrierID', local_phone.carrierID)) />
							<cfset session.dataCardAndNetbookFilterSelections.filterOptions = 0 />
							<cfset session.dataCardAndNetbookFilterSelections.filterOptions = listAppend(session.dataCardAndNetbookFilterSelections.filterOptions, filterHelper.getFilterOptionId('dataCardAndNetbook', 'planType', local.p.activationType)) />
							<cfset session.dataCardAndNetbookFilterSelections.filterOptions = listAppend(session.dataCardAndNetbookFilterSelections.filterOptions, filterHelper.getFilterOptionId('dataCardAndNetbook', 'carrierID', local_phone.carrierID)) />
							<cfset session.prePaidFilterSelections.filterOptions = 0 />
							<cfset session.prePaidFilterSelections.filterOptions = listAppend(session.prePaidFilterSelections.filterOptions, filterHelper.getFilterOptionId('prepaid', 'planType', local.p.activationType)) />
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
								<cfset cartLines[arguments.cartLineNumber].getPlan().setProductID(arguments.product_id) />
								<cfset cartLines[arguments.cartLineNumber].getPlan().setType('rateplan') />
								<cfset cartLines[arguments.cartLineNumber].setPlanType(application.model.plan.getPlanTypeByProductID(arguments.product_id)) />

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

								<cfif len(trim(variables.p.featureIDs)) and local.cartlines[arguments.cartLineNumber].getPhone().hasBeenSelected()>
									<cfset local.arrFeatures = arrayNew(1) />

									<cfloop list="#variables.p.featureIDs#" index="local.iFeature">
										<cfif isNumeric(local.iFeature)>
											<cfset arrayAppend(local.arrFeatures, createObject('component', '#variables.cartItemcfc#').init()) />

											<cfset local.arrFeatures[arrayLen(local.arrFeatures)].setProductID(local.iFeature) />
											<cfset local.arrFeatures[arrayLen(local.arrFeatures)].setType('service') />
										</cfif>
									</cfloop>

									<cfset cartLines[arguments.cartLineNumber].setFeatures(local.arrFeatures) />
								</cfif>

								<cfset session.cart.setLines(local.cartlines) />

								<cfif variables.thisPlan.planType eq 'family' || (variables.thisPlan.planType eq 'data' && variables.thisPlan.IsShared)>
									<!--- Apply this plan selection to the entire cart, including any existing lines. --->
									<cfset application.model.carthelper.setFamilyPlan(arguments.product_id) />
								<cfelse>
									<!--- Reset shared family plan --->
									<cfset session.cart.setFamilyPlan( CreateObject("component",'#variables.cartItemcfc#').init() ) />
								</cfif>
							</cfif>
							
						</cfif>

						<cfif len(trim(variables.p.featureIDs)) and local.cartlines[arguments.cartLineNumber].getPhone().hasBeenSelected()>
							<cfset local.arrFeatures = arrayNew(1) />

							<cfloop list="#variables.p.featureIDs#" index="local.iFeature">
								<cfif isNumeric(local.iFeature)>
									<cfset arrayAppend(local.arrFeatures, createObject('component', '#variables.cartItemcfc#').init()) />

									<cfset local.arrFeatures[arrayLen(local.arrFeatures)].setProductID(local.iFeature) />
									<cfset local.arrFeatures[arrayLen(local.arrFeatures)].setType('service') />
								</cfif>
							</cfloop>

							<cfset cartLines[arguments.cartLineNumber].setFeatures(local.arrFeatures) />
						</cfif>

						<cfset session.cart.setLines(local.cartlines) />

						<cfset local.getRebates = application.model.rebates.getProductInRebateFilter(productId = arguments.product_id, type = local.p.activationType) />
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
		<!---<cfparam name="arguments.productType" type="string" default="" />
		<cfparam name="arguments.qty" type="numeric" default="1" />--->

		<cfif listFirst(arguments.productType, ':') is not 'accessory' and arguments.qty eq 1 and arguments.cartLineNumber lt 1>
			<cfset arguments.cartLineNumber = session.cart.getCurrentLine() />
		</cfif>

		<cfif (not arguments.cartLineNumber and application.model.carthelper.getNumberOfLines()) or (not arguments.cartLineNumber and arguments.productType is 'accessory')>
			<!---<cfoutput>
				<cfinclude template="/views/cart/dsp_dialogWhichLine.cfm" />
			</cfoutput>

			<cfexit method="exittag" />--->
			<cfreturn "specify line number" />
		<cfelseif not arguments.cartLineNumber>
			<cfset arguments.cartLineNumber = 1 />
		</cfif>

		<!--- If we've been given a line number, but it appears to be a new line not yet in the cart. --->
		<cfif arguments.cartLineNumber and arguments.cartLineNumber gt arrayLen(local.cartLines) and arguments.cartLineNumber neq request.config.otherItemsLineNumber>
			<!--- Add a new line to the cart. --->
			<cfset argumentscartLineNumber = application.model.carthelper.addLineToCart() />
			<cfset local.cartLines = session.cart.getLines() />
			 
		</cfif>

		<!---
		**
		* Handle the cart add differently based on the product type being added.
		**
		--->
		<cfswitch expression="#arguments.productType#">
			<cfcase value="phone,tablet,dataCardAndNetbook,prepaid">

				<!--- User may be changing device. Remove plans, services, etc for the previous device line. --->
				<cfset application.model.carthelper.clearLineFreeAccessories(arguments.cartLineNumber) />
				<cfset application.model.carthelper.removeLineBundledAccessories(arguments.cartLineNumber) />

				<!--- Device change on the current line --->
				<cfif application.model.carthelper.getLineDeviceProductId(arguments.cartLineNumber ) neq 0>
					<cfif session.cart.getFamilyPlan().hasBeenSelected()>
						<cfset application.model.carthelper.removeAllLineFeatures(arguments.cartLineNumber) />
					<cfelse>
						<cfset application.model.carthelper.removePlan(arguments.cartLineNumber) />
					</cfif>
				</cfif>

				<!--- Add this phone to the indicated line. --->
				<cfset local.cartLines[arguments.cartLineNumber].getPhone().setProductID(arguments.product_id) />
				<cfset local.cartLines[arguments.cartLineNumber].getPhone().setGersSKU(application.model.OrderDetail.getGersSkuByProductId(arguments.product_id)) />
				<cfset local.cartLines[arguments.cartLineNumber].getPhone().setType('device') />
				<cfset local.cartLines[arguments.cartLineNumber].getPhone().getPrices().setDueToday(arguments.price) />
				<cfset local.cartLines[arguments.cartLineNumber].getPhone().getPrices().setCOGS(application.model.product.getCOGS(arguments.product_id)) />
				<cfset local.cartLines[arguments.cartLineNumber].setCartLineActivationType(local.p.activationType) />
				
				<cfif local.p.activationType contains 'financed'>
					<cfset local.cartLines[arguments.cartLineNumber].getPhone().getPrices().setRetailPrice(application.model[arguments.productType].getPriceByProductIDAndMode(productId = arguments.product_id, mode = 'financed')) />
				<cfelse>
					<cfset local.cartLines[arguments.cartLineNumber].getPhone().getPrices().setRetailPrice(application.model[arguments.productType].getPriceByProductIDAndMode(productId = arguments.product_id, mode = 'retail')) />			
				</cfif>

				<cfset session.cart.setCarrierId(application.model[arguments.productType].getCarrierIdByProductId(arguments.product_id)) />
				<cfset local.cartLines[arguments.cartLineNumber].getPhone().setDeviceServiceType( application.model[arguments.productType].getDeviceServiceType( arguments.product_id, session.cart.getCarrierId() ) )/>

				<!--- Clear any existing free accessories on this line. --->
				<cfset application.model.carthelper.clearLineFreeAccessories(lineNumber = arguments.cartLineNumber) />

				<cfset local.freeAccessories = application.model[arguments.productType].getFreeAccessories(arguments.product_id) />
				<cfset local.thisLineAccessories = local.cartLines[arguments.cartLineNumber].getAccessories() />

				<cfif local.freeAccessories.recordCount>
					<cfloop query="local.freeAccessories">
						<cfset local.thisFreeAccessory = createObject('component', '#variables.cartItemcfc#').init() />
						<cfset local.thisFreeAccessory.setProductId(local.freeAccessories.productId[local.freeAccessories.currentRow]) />
						<cfset local.thisFreeAccessory.setType('bundled') />
						<cfset local.thisFreeAccessory.getPrices().setDueToday(0) />
						<cfset local.thisFreeAccessory.getPrices().setCOGS(application.model.product.getCOGS(local.freeAccessories.productId[local.freeAccessories.currentRow])) />
						<cfset local.thisFreeAccessory.getPrices().setRetailPrice(local.freeAccessories.price_retail[local.freeAccessories.currentRow]) />

						<cfset arrayAppend(local.thisLineAccessories, local.thisFreeAccessory) />
					</cfloop>

					<cfset local.cartLines[arguments.cartLineNumber].setAccessories(local.thisLineAccessories) />
				</cfif>

				<cfif len(trim(variables.p.featureIDs)) and local.cartlines[arguments.cartLineNumber].getPhone().hasBeenSelected()>
					<cfset local.arrFeatures = arrayNew(1) />

					<cfloop list="#variables.p.featureIDs#" index="local.iFeature">
						<cfif isNumeric(local.iFeature)>
							<cfset arrayAppend(local.arrFeatures, createObject('component', '#variables.cartItemcfc#').init()) />

							<cfset local.arrFeatures[arrayLen(local.arrFeatures)].setProductID(local.iFeature) />
							<cfset local.arrFeatures[arrayLen(local.arrFeatures)].setType('service') />
						</cfif>
					</cfloop>

					<cfset local.cartLines[arguments.cartLineNumber].setFeatures(local.arrFeatures) />
				</cfif>

				<cfset session.cart.setCurrentLine(arguments.cartLineNumber) />

				<!--- Check for new family plans --->
				<cfif session.cart.getActivationType() contains 'new' and session.cart.getHasFamilyPlan()>
					<!---<cfset session.cart.setActivationType('new') />--->
				<cfelseif session.cart.getActivationType() contains 'addaline' and session.cart.getHasFamilyPlan()>
					<!---<cfset session.cart.setActivationType('addaline') />--->
				<cfelse>
					<cfset session.cart.setActivationType(trim(local.p.activationType)) />
				</cfif>

				<cfif arguments.productType is 'prepaid'>
					<cfset session.cart.setPrepaid(true) />
				</cfif>

				<!--- Add default plan & services --->
				<cfif (arguments.productType EQ 'phone' or arguments.productType EQ 'tablet')
					AND NOT local.cartLines[arguments.cartLineNumber].getPlan().getProductId() AND
					( ( session.cart.getActivationType() contains 'new' AND NOT session.cart.getHasFamilyPlan() )
					  OR ( session.cart.getActivationType() contains 'upgrade' AND session.cart.getUpgradeType() eq 'equipment+plan' )
					  OR ( session.cart.getActivationType() contains 'addaline' AND session.cart.getAddALineType() eq 'ind') )>

					<cfset application.model.carthelper.addDefaultPlanAndServices( local.cartLines[arguments.cartLineNumber], arguments.product_id ) />
				</cfif>

				<cfset session.phoneFilterSelections.filterOptions = 0 />
				<cfset session.phoneFilterSelections.filterOptions = listAppend(session.phoneFilterSelections.filterOptions, filterHelper.getFilterOptionId('phone', 'planType', local.p.activationType)) />
				<cfset session.phoneFilterSelections.filterOptions = listAppend(session.phoneFilterSelections.filterOptions, filterHelper.getFilterOptionId('phone', 'carrierID', local.local_phone.carrierID)) />
				
				<cfset session.tabletFilterSelections.filterOptions = 0 />
				<cfset session.tabletFilterSelections.filterOptions = listAppend(session.tabletFilterSelections.filterOptions, filterHelper.getFilterOptionId('tablet', 'planType', local.p.activationType)) />
				<cfset session.tabletFilterSelections.filterOptions = listAppend(session.tabletFilterSelections.filterOptions, filterHelper.getFilterOptionId('tablet', 'carrierID', local.local_phone.carrierID)) />
			
				<cfset session.dataCardAndNetbookFilterSelections.filterOptions = 0 />
				<cfset session.dataCardAndNetbookFilterSelections.filterOptions = listAppend(session.dataCardAndNetbookFilterSelections.filterOptions, filterHelper.getFilterOptionId('dataCardAndNetbook', 'planType', local.p.activationType)) />
				<cfset session.dataCardAndNetbookFilterSelections.filterOptions = listAppend(session.dataCardAndNetbookFilterSelections.filterOptions, filterHelper.getFilterOptionId('dataCardAndNetbook', 'carrierID', local.local_phone.carrierID)) />
				<cfset session.prePaidFilterSelections.filterOptions = 0 />
				<cfset session.prePaidFilterSelections.filterOptions = listAppend(session.prePaidFilterSelections.filterOptions, filterHelper.getFilterOptionId('prepaid', 'planType', local.p.activationType)) />
				<cfset session.prePaidFilterSelections.filterOptions = listAppend(session.prePaidFilterSelections.filterOptions, filterHelper.getFilterOptionId('prepaid', 'carrierID', local.local_phone.carrierID)) />
				<cfset session.planFilterSelections.filterOptions = 0 />
				<cfset session.planFilterSelections.filterOptions = listAppend(session.planFilterSelections.filterOptions, filterHelper.getFilterOptionId('plan', 'carrierID', local.local_phone.carrierID)) />

				<cfset local.thisProductClass = application.model[arguments.productType].getProductClassByProductID(arguments.product_id) />

				<cfif local.thisProductClass is 'dataCardAndNetbook' or local.thisProductClass is 'tablet'>
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

				<cfset local.hasWirelessItemBeenAdded = true />
				<cfset arguments.productType = '' />

				<cfset local.getRebates = application.model.rebates.getProductInRebateFilter(productId = arguments.product_id, type = local.p.activationType) />
				<cfset local.rebateArray = session.cart.getRebates() />

				<cfif local.getRebates.recordCount>
					<cfset arrayAppend(local.rebateArray, local.getRebates) />

					<cfset session.cart.setRebates(local.rebateArray) />
				</cfif>

				<!---<cfinclude template="/views/cart/dsp_viewCartInDialog.cfm" />

				<cfexit method="exittag" />--->
				
				<cfreturn "success" />
			</cfcase>

			<cfcase value="service">
				<!---
				**
				* Add the selected service to the current line if we have feature
				* ids and a device selected on this line.
				**
				--->
				<cfif len(trim(variables.p.featureIDs)) and local.cartlines[arguments.cartLineNumber].getPhone().hasBeenSelected()>
					<cfset local.arrFeatures = arrayNew(1) />

					<cfloop list="#variables.p.featureIDs#" index="local.iFeature">
						<cfif isNumeric(local.iFeature)>
							<cfset arrayAppend(local.arrFeatures, createObject('component', '#variables.cartItemcfc#').init()) />

							<cfset local.arrFeatures[arrayLen(local.arrFeatures)].setProductID(local.iFeature) />
							<cfset local.arrFeatures[arrayLen(local.arrFeatures)].setType('service') />
						</cfif>
					</cfloop>

					<cfset local.cartLines[arguments.cartLineNumber].setFeatures(local.arrFeatures) />
				</cfif>

				<cfset session.cart.setCurrentLine(arguments.cartLineNumber) />
				<cfset request.hasWirelessItemBeenAdded = true />
				<cfset arguments.productType = '' />
				 

<!---				<cfinclude template="/views/cart/dsp_viewCartInDialog.cfm" />

				<cfexit method="exittag" />--->
				<cfreturn "success" />
			</cfcase>

			<cfcase value="plan">
				<cfif not isNumeric(arguments.product_id)>
					<cfset local.p.product_id = application.model.plan.getPlanIDByPlanStringIDAndZipcode(planStringID = arguments.product_id, zipCode = session.cart.getZipcode()) />
				<cfelse>
					<cfset local.p.product_id = arguments.product_id />
				</cfif>

				<cfif len(trim(local.p.product_id)) and isNumeric(local.p.product_id)>
					<!---
					**
					* Add this plan to the indicated line.
					**
					--->
					<cfset local.cartLines[arguments.cartLineNumber].getPlan().setProductID(local.p.product_id) />
					<cfset local.cartLines[arguments.cartLineNumber].getPlan().setType('rateplan') />
					<cfset local.cartLines[arguments.cartLineNumber].setPlanType(application.model.plan.getPlanTypeByProductID(local.p.product_id)) />

					<cfset session.cart.setCarrierId(application.model.product.getCarrierIdByProductId(local.p.product_id)) />
					<cfset session.planFilterSelections.filterOptions = 0 />
					<cfset session.planFilterSelections.filterOptions = listAppend(session.planFilterSelections.filterOptions, filterHelper.getFilterOptionId('plan', 'planType', 'local_plan.planType')) />
					<cfset session.planFilterSelections.filterOptions = listAppend(session.planFilterSelections.filterOptions, filterHelper.getFilterOptionId('plan', 'carrierID', 'local_plan.carrierID')) />
					<cfset session.phoneFilterSelections.filterOptions = 0 />
					<cfset session.phoneFilterSelections.filterOptions = listAppend(session.phoneFilterSelections.filterOptions, filterHelper.getFilterOptionId('phone', 'carrierID', 'local_plan.carrierID')) />
					<cfset session.dataCardAndNetbookFilterSelections.filterOptions = 0 />
					<cfset session.dataCardAndNetbookFilterSelections.filterOptions = listAppend(session.dataCardAndNetbookFilterSelections.filterOptions, filterHelper.getFilterOptionId('dataCardAndNetbook', 'carrierID', 'local_plan.carrierID')) />
					<cfset session.prePaidFilterSelections.filterOptions = 0 />
					<cfset session.prePaidFilterSelections.filterOptions = listAppend(session.prePaidFilterSelections.filterOptions, filterHelper.getFilterOptionId('prepaid', 'carrierID', 'local_plan.carrierID')) />

					<cfif len(trim(variables.p.featureIDs)) and local.cartlines[arguments.cartLineNumber].getPhone().hasBeenSelected()>
						<cfset local.arrFeatures = arrayNew(1) />

						<cfloop list="#variables.p.featureIDs#" index="local.iFeature">
							<cfif isNumeric(local.iFeature)>
								<cfset arrayAppend(local.arrFeatures, createObject('component', '#variables.cartItemcfc#').init()) />

								<cfset local.arrFeatures[arrayLen(local.arrFeatures)].setProductID(local.iFeature) />
								<cfset local.arrFeatures[arrayLen(local.arrFeatures)].setType('service') />
							</cfif>
						</cfloop>

						<cfset local.cartLines[arguments.cartLineNumber].setFeatures(local.arrFeatures) />
					</cfif>

					<cfset thisPlan = application.model.plan.getByFilter(idList = local.p.product_id) />

					<cfif variables.thisPlan.planType is 'family' || (variables.thisPlan.planType eq 'data' && variables.thisPlan.IsShared)>
						<cfset application.model.carthelper.setFamilyPlan(local.p.product_id) />
					<cfelse>
						<!--- Reset shared family plan --->
						<cfset session.cart.setFamilyPlan( CreateObject("component", '#variables.cartItemcfc#').init() ) />
						<cfset session.cart.setSharedFeatures( ArrayNew(1) ) />
					</cfif>

					<cfset session.cart.setCurrentLine(arguments.cartLineNumber) />
					 
					<cfset request.hasWirelessItemBeenAdded = true />
					<cfset arguments.productType = '' />

					<cfset local.getRebates = application.model.rebates.getProductInRebateFilter(productId = local.p.product_id, type = 'new') />
					<cfset local.rebateArray = session.cart.getRebates() />

					<cfif local.getRebates.recordCount>
						<cfset arrayAppend(local.rebateArray, local.getRebates) />

						<cfset session.cart.setRebates(local.rebateArray) />
					</cfif>

					<!---<cfinclude template="/views/cart/dsp_viewCartInDialog.cfm" />

					<cfexit method="exittag" />--->
					
					<cfreturn "success" />
				<cfelse>
					<!---<hr />
						The plan you've selected is not available in your zip code.
					<hr />

					<cfexit method="exittag" />--->
					<cfreturn "The plan you've selected is not available in your zip code." />
				</cfif>
			</cfcase>

			<cfcase value="datacard">
				<cfabort />
			</cfcase>

			<cfcase value="netbook">
				<cfabort />
			</cfcase>

			<cfcase value="accessory">
				<cfset local.newAccessory = createObject('component', '#variables.cartItemcfc#').init() />
				<cfset local.newAccessory.setProductID(arguments.product_id) />
				<cfset local.thisAccessory = application.model.accessory.getByFilter(idList = arguments.product_id) />
				<cfif local.thisAccessory.recordcount is 0>
					<cfreturn "accessory not found" />
				</cfif>
				<cfset local.newAccessory.setGersSKU(local.thisAccessory.GersSKU) />
				<cfset local.newAccessory.getPrices().setDueToday(local.thisAccessory.price) />
				<cfset local.newAccessory.getPrices().setCOGS(application.model.product.getCOGS(local.newAccessory.getProductId())) />
				<cfset local.newAccessory.getPrices().setRetailPrice(local.thisAccessory.price_retail) />
				<cfset local.newAccessory.setType('accessory') />
				<cfset local.addedAccessoryToWorkflow = false />

				<!--- If the user is adding to 'other items'. --->
				<cfif not arguments.cartLineNumber or arguments.cartLineNumber eq request.config.otherItemsLineNumber>
					<cfloop from="1" to="#arguments.qty#" index="iQty">
						<cfset arrayAppend(session.cart.getOtherItems(), local.newAccessory) />
					</cfloop>

					<cfset session.cart.setCurrentLine(arguments.cartLineNumber) />
				<cfelse>
					<cfloop from="1" to="#arguments.qty#" index="iQty">
						<cfset arrayAppend(local.cartlines[arguments.cartLineNumber].getAccessories(), local.newAccessory) />
					</cfloop>

					<cfset local.addedAccessoryToWorkflow = true />
					<cfset session.cart.setCurrentLine(arguments.cartLineNumber) />
				</cfif>

				 
				<cfset local.hasWirelessItemBeenAdded = local.addedAccessoryToWorkflow />
				<cfset arguments.productType = '' />

				<cfset local.getRebates = application.model.rebates.getProductInRebateFilter(productId = arguments.product_id, type = 'new') />
				<cfset local.rebateArray = session.cart.getRebates() />

				<cfif local.getRebates.recordCount>
					<cfset arrayAppend(local.rebateArray, local.getRebates) />

					<cfset session.cart.setRebates(local.rebateArray) />
				</cfif>

				<!---<cfinclude template="/views/cart/dsp_viewCartInDialog.cfm" />

				<cfexit method="exittag" />--->
				<cfreturn "success" />
			</cfcase>

			<cfcase value="warranty">
				<cfscript>
					local.newWarranty = createObject('component', '#variables.cartItemcfc#').init();
					local.newWarranty.setProductID(arguments.product_id);
					local.thisWarranty = application.model.Warranty.getByID(arguments.product_id);
					local.newWarranty.setGersSKU(local.thisWarranty.GersSKU);
					local.newWarranty.getPrices().setDueToday(local.thisWarranty.price);
					local.newWarranty.getPrices().setRetailPrice(local.thisWarranty.price);
					local.newWarranty.setTitle(local.thisWarranty.SummaryTitle);
					local.newWarranty.setType('Warranty');
					
					local.cartLines[arguments.cartLineNumber].setWarranty( local.newWarranty );
					
					arguments.productType = '';

				</cfscript>
				
				<!---<cfinclude template="/views/cart/dsp_viewCartInDialog.cfm" />
				<cfexit method="exittag" />--->
				<cfreturn "success" />
			</cfcase>

			<cfdefaultcase>
				<!--- Do Nothing --->
			</cfdefaultcase>
		</cfswitch>
				
				<cfreturn "success" />	
	</cffunction>


	<!--- Setters/Getters --->
		
	<cffunction name="setCart" returnType="void" access="public">
		<cfargument name="cartObj" type="cfc.model.cart" required="true"  > 	
		<cfset variables.instance.cart = arguments.cart />	
	</cffunction>	
	
	<cffunction name="getCart" returnType="cfc.model.cart" access="public">
		<cfif isdefined("variables.instance.cart")>
			<cfreturn variables.instance.cart />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>
	
</cfcomponent>



