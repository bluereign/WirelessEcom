<cfparam name="request.p.do" default="view" type="string" />
<cfparam name="request.currentTopNav" default="cart.view" type="string" />

<cfset InstantRebateService = application.wirebox.getInstance("InstantRebateService")>
<cfset ChannelConfig = application.wirebox.getInstance("ChannelConfig") />
<cfset filterHelper = application.wirebox.getInstance("FilterHelper") /> 
<cfset PromotionService = application.wirebox.getInstance("PromotionService") />

<cfswitch expression="#request.p.do#">

	<cfcase value="view"> 
		<cfset request.currentTopNav = 'checkout.view' />
		<cfparam name="request.p.blnDialog" type="boolean" default="false" />

		<cfif request.p.blnDialog>
			<cfset request.layoutFile = 'noLayout' />

			<cfinclude template="/views/cart/dsp_viewCartInDialog.cfm" />

			<cfexit method="exittag" />
		</cfif>

		<!--- Remove empty cart lines --->
		<cfset application.model.CartHelper.removeEmptyCartLines() />
		
		<!--- Reset instant rebate total --->
		<cfset session.cart.setInstantRebateAmountTotal(0) />
		
		<!--- Find instant rebates --->
		<cfset cartLines = session.cart.getLines() />
		<cfloop array="#cartLines#" index="cartLine">
			<cfset instantRebateAmount = InstantRebateService.getQualifyingAmt( cartLine = cartLine )>
			<cfset cartLine.setInstantRebateAmount( instantRebateAmount )>			
			<cfset session.cart.setInstantRebateAmountTotal( session.cart.getInstantRebateAmountTotal() + cartline.getInstantRebateAmount() )>
		</cfloop>	
			
		<!---Get number of accessories that cost money (don't include free kits)---->
		<cfset numAccessories = 0>

		<cfloop array="#session.cart.getaccessories()#" index="cartline">
			<cfif cartline.getprices().getduetoday() GT 0>
				<cfset numAccessories ++>
			</cfif>
		</cfloop>

		<!---Get all promotions so we can remove them from the cart on cart review load in case they have added an accessory to cart that already 
		has an accessory (otherwise maybe 2 coupons would be applied)---->
		<cfset promotioncodeobject = createObject('component', 'cfc.model.promotioncodes').init() />
		<cfset local.promotions = promotioncodeobject.getPromotions()>
		

		<!---Remove all current Promotional codes---->
		<cfloop query="local.promotions">
			<cfset session.Cart.removePromotion(local.promotions.code )>
		</cfloop>

		<!---Get the coupon code for just the number of accessories in the cart--->
		<cfquery dbtype="query" name="local.promotion" >
			select code from [local].promotions
			where accessoryquantity <= <cfqueryparam cfsqltype="cf_sql_integer" value="#numAccessories#">	
			ORDER BY discount DESC
		</cfquery>

		<cfset request.p.code = local.promotion.code>
		<cfset request.p.returnul = '/index.cfm/go/checkout/do/addPromotionToCart'>				
		
		<!---apply the coupon---->
		<cfscript>					
			if( len( request.p.code ) &&  ChannelConfig.isPromotionCodeAvailable() ) {
				
				if( !session.cart.hasPromotion( request.p.code ) ) {
					
					Result = PromotionService.evaluatePromotion( 
								code = ucase(request.p.code), 
								userID = session.userID,
								cartPromotionCodeList = structKeyList(session.Cart.getPromotionCodes()),
								accessoryTotal = session.Cart.getAccessoriesAmtDueToday(),
								accessoryQuantity = arrayLen(session.Cart.getAccessories(includeFree=false)),
								orderTotal = session.Cart.getCartItemsAmtDueToday(),
								orderQuantity = arrayLen(session.Cart.getCartItems(includeFree=false)),
								orderSKUList = session.Cart.getCartSKUList()
							);
					
					PromotionService.addPromotionToCart( 
								cart = session.Cart, 
								result = Result, 
								shipMethod = application.model.checkoutHelper.getShippingMethod(),
								userID = session.userID,
								isNew = true
							);
							
					if( Result.passed() ) {
						session.cart.addPromotion( ucase(request.p.code), Result.getName(), Result.getPromotionID() );
					}
					
					application.model.CheckoutHelper.setCheckoutMessageBox( Result.getMessage() );
					
				} else {
					
					application.model.CheckoutHelper.setCheckoutMessageBox( "Promotion has already been applied." );
					
				}
				
			}
		</cfscript>	

		<cfset cartHTML = trim(application.view.cart.view()) />

		<cfinclude template="/views/cart/dsp_viewCart.cfm" />
	</cfcase>

	<cfcase value="viewInDialog">
		<cfparam name="request.p.blnDialog" type="boolean" default="false" />
		<!---
		**
		* Ensure that the cart exists and it isn't empty.
		**
		--->
		<cfset cartExists = session.cart.hasCart() />
		<cfset cartEmpty = application.model.cartHelper.isEmpty() />

		<cfset request.layoutFile = 'noLayout' />
		<cfset request.p.blnDialog = true />
		<cfset cartHTML = '' />

		<cfif variables.cartExists and not variables.cartEmpty>
			<!---
			**
			* Change the layout template to the dialog window.
			**
			--->
			<cfsavecontent variable="cartHTML">
				<cfinclude template="/views/cart/dsp_viewCartInDialog.cfm" />
			</cfsavecontent>
		<cfelseif variables.cartEmpty or not variables.cartExists>
			<cfsavecontent variable="cartHTML">
				<cfinclude template="/views/cart/dsp_cartIsEmpty.cfm" />
			</cfsavecontent>
		</cfif>

		<cfoutput>#trim(variables.cartHTML)#</cfoutput>
	</cfcase>


	<cfcase value="explainActivationFee">
		<cfparam name="request.p.carrierId" type="numeric" />
		<cfset request.layoutFile = 'activationFeeWindow' />
		<cfinclude template="/views/cart/dsp_activationFeeWindow.cfm" />
	</cfcase>


	<cfcase value="addItem">
		<cfparam name="request.p.order_id" type="numeric" default="0" /> <!--- the order/cart id - 0 indicates we don't have one yet --->
		<cfparam name="request.p.line_id" type="numeric" default="0" /> <!--- this will be used to determine to which line an item is being added (this should be an OrdersWireless.ow_id value) - 0 indicates we don't have one yet --->
		<cfparam name="request.p.cartLineNumber" type="numeric" default="0" /> <!--- this will be used to determine to which line an item is being added (this relates to an array index in cart.lines[]) - 0 indicates we don't have one yet --->
		<cfparam name="request.p.cartLineAlias" type="string" default="" /> <!--- this will be used to alias the cart line if it has been supplied by the user --->
		<cfparam name="request.p.productType" type="string" /> <!--- indicates the type of product being added to the cart since we'll likely need different logic for various product types --->
		<cfparam name="request.p.product_id" type="string" /> <!--- this is a string because we might get integer or string data (e.g. plans) --->
		<cfparam name="request.p.qty" type="string" default="1" />
		<cfparam name="request.p.price" default="0" />
		<cfparam name="request.p.phoneType" default="" type="string" />

		<cfif request.p.qty eq ''>
			<cfset request.p.qty = 1 />
		</cfif>

		<cfset request.p.product_id = trim(request.p.product_id) />
		<cfset request.layoutFile = 'noLayout' />
		
		

		<!--- TODO: Pull out Activation type from the product type variable --->
		<cfif request.p.productType contains ':'>
			<cfset request.p.productType_orig = request.p.productType />
			<cfset request.p.productType = listFirst(request.p.productType_orig, ':') />

			<cfif listFindNoCase('phone,tablet,dataCardAndNetbook,prepaid', request.p.productType)>
				<cfset request.p.activationType = listGetAt(request.p.productType_orig, 2, ':') />
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

		<cfif request.p.product_id contains ':' and listLen(request.p.product_id, ':') gte 2>
			<cfset request.p.changingPlanFeatures = true />
			<cfset request.p.featureIDs = listChangeDelims(listGetAt(request.p.product_id, 2, ':'), ',', ',') />
			<cfset request.p.product_id = listFirst(request.p.product_id, ':') />
		<cfelseif request.p.product_id contains ':'>
			<cfset request.p.product_id = listFirst(request.p.product_id, ':') />
		</cfif>

		<!--- Check availability --->
		<cfif listFindNoCase('phone,tablet,dataCardAndNetbook,prepaid', request.p.productType) && application.model[request.p.productType].getAvailableInventoryCount( request.p.product_id ) lte 0>
			<cfset request.p.CartMessage = '<p>The device you wish to purchase is no longer available.</p><p>Please select <a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0/">another device<a/>.</p>' />
			<cfinclude template="/views/cart/dsp_cartMessage.cfm" />
			 
			<cfexit method="exittag" />
		</cfif>

		<cfif listFindNoCase('phone,tablet,dataCardAndNetbook,prepaid', request.p.productType)>
			<cfset request.p.phoneType = request.p.activationType />
			<cfset request.p.product_id = listFirst(request.p.product_id, ':') />

		<cfif request.p.phoneType contains 'financed'>			
			<cfset request.p.price = application.model[request.p.productType].getPriceByPhoneIdAndMode(phoneID = request.p.product_id, mode = 'financed') />
		<cfelse>
			<cfset request.p.price = application.model[request.p.productType].getPriceByPhoneIdAndMode(phoneID = request.p.product_id, mode = request.p.phoneType) />
		</cfif>

		</cfif>

		<cfif listFindNoCase('phone,tablet,dataCardAndNetbook,prepaid', request.p.productType)>
			<cfset local_phone = application.model[request.p.productType].getByFilter(idList = request.p.product_id) />
		<cfelseif request.p.productType is 'plan'>
			<cfset local_plan = application.model.plan.getByFilter(idList = request.p.product_id) />
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
		<cfif (listFindNoCase('phone,tablet,dataCardAndNetBook,prepaid,service', request.p.productType))>
			<cfif not application.model.cartHelper.zipCodeEntered()>
				<cfset qDevice = application.model[request.p.productType].getByFilter( idList = request.p.product_id, allowHidden = true ) />				
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
					<cfset requiredServices = application.model.ServiceManager.getDeviceMinimumRequiredServices(request.p.product_id) />

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
			<cfset carrierId = application.model.phone.getCarrierIDbyProductID(request.p.product_id) />
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
		<cfif listFindNoCase('phone,tablet,dataCardAndNetBook,prepaid,service', request.p.productType)>

			<!--- If there are no lines in the cart yet or the user is adding a qty greater than 1. --->
			<cfif request.p.qty gt 1>
				<cfif not arrayLen(session.cart.getLines())>
					<cfset request.cartAddedFirstLine = true />
				</cfif>

				<cfset local.freeAccessories = application.model[request.p.productType].getFreeAccessories(request.p.product_id) />

				<cfloop from="1" to="#request.p.qty#" index="iQty">
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

						<cfif listFindNoCase('phone,tablet,dataCardAndNetbook,prepaid', request.p.productType)>
							<cfset cartLines[request.p.cartLineNumber].getPhone().setProductID(request.p.product_id) />
							<cfset cartLines[request.p.cartLineNumber].getPhone().setGersSKU(application.model.OrderDetail.getGersSkuByProductId(request.p.product_id)) />
							<cfset cartLines[request.p.cartLineNumber].getPhone().getPrices().setDueToday(request.p.price) />
							<cfset cartLines[request.p.cartLineNumber].getPhone().getPrices().setCOGS(application.model.product.getCOGS(request.p.product_id)) />
							
							<cfif request.p.activationType contains 'financed'>
								<cfset cartLines[request.p.cartLineNumber].getPhone().getPrices().setRetailPrice(application.model[request.p.productType].getPriceByProductIDAndMode(productId = request.p.product_id, mode = 'financed')) />
							<cfelse>
								<cfset cartLines[request.p.cartLineNumber].getPhone().getPrices().setRetailPrice(application.model[request.p.productType].getPriceByProductIDAndMode(productId = request.p.product_id, mode = 'retail')) />
							</cfif>
							
							<cfset cartLines[request.p.cartLineNumber].getPhone().setType('device') />

							<cfset session.cart.setCarrierId(application.model[request.p.productType].getCarrierIdByProductId(request.p.product_id)) />
							<cfset cartLines[request.p.cartLineNumber].getPhone().setDeviceServiceType( application.model[request.p.productType].getDeviceServiceType( request.p.product_id, session.cart.getCarrierId() ) )/>

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

							<cfif request.p.productType is 'prepaid'>
								<cfset session.cart.setPrepaid(true) />
							</cfif>

							<!--- Add default plan & services --->
							<cfif request.p.productType EQ 'phone'
								AND NOT cartLines[request.p.cartLineNumber].getPlan().getProductId() AND
								( ( session.cart.getActivationType() CONTAINS 'new' AND NOT session.cart.getHasFamilyPlan() )
								  OR ( session.cart.getActivationType() CONTAINS 'upgrade' AND session.cart.getUpgradeType() eq 'equipment+plan' )
								  OR ( session.cart.getActivationType() CONTAINS 'addaline' AND session.cart.getAddALineType() eq 'ind') )>

								<cfset application.model.CartHelper.addDefaultPlanAndServices( cartLines[request.p.cartLineNumber], request.p.product_id ) />
							</cfif>
							<cfif request.p.productType EQ 'tablet'
								AND NOT cartLines[request.p.cartLineNumber].getPlan().getProductId() AND
								( ( session.cart.getActivationType() CONTAINS 'new' AND NOT session.cart.getHasFamilyPlan() )
								  OR ( session.cart.getActivationType() CONTAINS 'upgrade' AND session.cart.getUpgradeType() eq 'equipment+plan' )
								  OR ( session.cart.getActivationType() CONTAINS 'addaline' AND session.cart.getAddALineType() eq 'ind') )>

								<cfset application.model.CartHelper.addDefaultPlanAndServices( cartLines[request.p.cartLineNumber], request.p.product_id ) />
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

							<cfset thisProductClass = application.model[request.p.productType].getProductClassByProductID(request.p.product_id) />

							<cfif request.p.productType is not 'dataCardAndNetbook'>
								<cfset session.planFilterSelections.filterOptions = listAppend(session.planFilterSelections.filterOptions, filterHelper.getFilterOptionId('plan', 'planType', 'individual'), filterHelper.getFilterOptionId('plan', 'planType', 'family')) />
							<cfelseif request.p.productType is 'dataCardAndNetbook'>
								<cfset session.planFilterSelections.filterOptions = listAppend(session.planFilterSelections.filterOptions, filterHelper.getFilterOptionId('plan', 'planType', 'data')) />
							</cfif>
						<cfelseif request.p.productType is 'plan'>
							<cfif not isNumeric(request.p.product_id)>
								<cfset request.p.product_id = application.model.plan.getPlanIDByPlanStringIDAndZipcode(planStringID = request.p.product_id, zipCode = session.cart.getZipcode()) />
								<cfset thisPlan = application.model.plan.getByFilter(idList = request.p.product_id) />
							</cfif>

							<cfif len(trim(request.p.product_id)) and isNumeric(request.p.product_id)>
								<!---
								**
								* Add this plan to the indicated line.
								**
								--->
								<cfset cartLines[request.p.cartLineNumber].getPlan().setProductID(request.p.product_id) />
								<cfset cartLines[request.p.cartLineNumber].getPlan().setType('rateplan') />
								<cfset cartLines[request.p.cartLineNumber].setPlanType(application.model.plan.getPlanTypeByProductID(request.p.product_id)) />

								<cfset session.cart.setCarrierId(application.model.product.getCarrierIdByProductId(request.p.product_id)) />
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
									<cfset application.model.cartHelper.setFamilyPlan(request.p.product_id) />
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

						<cfset local.getRebates = application.model.rebates.getProductInRebateFilter(productId = request.p.product_id, type = request.p.activationType) />
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
		<cfparam name="request.p.productType" type="string" default="" />
		<cfparam name="request.p.qty" type="numeric" default="1" />

		<cfif listFirst(request.p.productType, ':') is not 'accessory' and request.p.qty eq 1 and request.p.cartLineNumber lt 1>
			<cfset request.p.cartLineNumber = session.cart.getCurrentLine() />
		</cfif>

		<cfif (not request.p.cartLineNumber and application.model.cartHelper.getNumberOfLines()) or (not request.p.cartLineNumber and request.p.productType is 'accessory')>
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
		<cfswitch expression="#request.p.productType#">
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
				<cfset cartLines[request.p.cartLineNumber].getPhone().setProductID(request.p.product_id) />
				<cfset cartLines[request.p.cartLineNumber].getPhone().setGersSKU(application.model.OrderDetail.getGersSkuByProductId(request.p.product_id)) />
				<cfset cartLines[request.p.cartLineNumber].getPhone().setType('device') />
				<cfset cartLines[request.p.cartLineNumber].getPhone().getPrices().setDueToday(request.p.price) />
				<cfset cartLines[request.p.cartLineNumber].getPhone().getPrices().setCOGS(application.model.product.getCOGS(request.p.product_id)) />
				<cfset cartLines[request.p.cartLineNumber].setCartLineActivationType(request.p.activationType) />
				
				<cfif request.p.activationType contains 'financed'>
					<cfset cartLines[request.p.cartLineNumber].getPhone().getPrices().setRetailPrice(application.model[request.p.productType].getPriceByProductIDAndMode(productId = request.p.product_id, mode = 'financed')) />
				<cfelse>
					<cfset cartLines[request.p.cartLineNumber].getPhone().getPrices().setRetailPrice(application.model[request.p.productType].getPriceByProductIDAndMode(productId = request.p.product_id, mode = 'retail')) />			
				</cfif>

				<cfset session.cart.setCarrierId(application.model[request.p.productType].getCarrierIdByProductId(request.p.product_id)) />
				<cfset cartLines[request.p.cartLineNumber].getPhone().setDeviceServiceType( application.model[request.p.productType].getDeviceServiceType( request.p.product_id, session.cart.getCarrierId() ) )/>

				<!--- Clear any existing free accessories on this line. --->
				<cfset application.model.cartHelper.clearLineFreeAccessories(lineNumber = request.p.cartLineNumber) />

				<cfset local.freeAccessories = application.model[request.p.productType].getFreeAccessories(request.p.product_id) />
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

				<cfif request.p.productType is 'prepaid'>
					<cfset session.cart.setPrepaid(true) />
				</cfif>

				<!--- Add default plan & services --->
				<cfif (request.p.productType EQ 'phone' or request.p.productType EQ 'tablet')
					AND NOT cartLines[request.p.cartLineNumber].getPlan().getProductId() AND
					( ( session.cart.getActivationType() contains 'new' AND NOT session.cart.getHasFamilyPlan() )
					  OR ( session.cart.getActivationType() contains 'upgrade' AND session.cart.getUpgradeType() eq 'equipment+plan' )
					  OR ( session.cart.getActivationType() contains 'addaline' AND session.cart.getAddALineType() eq 'ind') )>

					<cfset application.model.CartHelper.addDefaultPlanAndServices( cartLines[request.p.cartLineNumber], request.p.product_id ) />
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

				<cfset thisProductClass = application.model[request.p.productType].getProductClassByProductID(request.p.product_id) />

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
				<cfset request.p.productType = '' />

				<cfset local.getRebates = application.model.rebates.getProductInRebateFilter(productId = request.p.product_id, type = request.p.activationType) />
				<cfset local.rebateArray = session.cart.getRebates() />

				<cfif local.getRebates.recordCount>
					<cfset arrayAppend(local.rebateArray, local.getRebates) />

					<cfset session.cart.setRebates(local.rebateArray) />
				</cfif>
				
				

				<cfinclude template="/views/cart/dsp_viewCartInDialog.cfm" />

				<cfexit method="exittag" />
			</cfcase>

			<cfcase value="service">
				<!---
				**
				* Add the selected service to the current line if we have feature
				* ids and a device selected on this line.
				**
				--->
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
				<cfset request.hasWirelessItemBeenAdded = true />
				<cfset request.p.productType = '' />
				 

				<cfinclude template="/views/cart/dsp_viewCartInDialog.cfm" />

				<cfexit method="exittag" />
			</cfcase>

			<cfcase value="plan">
				<cfif not isNumeric(request.p.product_id)>
					<cfset request.p.product_id = application.model.plan.getPlanIDByPlanStringIDAndZipcode(planStringID = request.p.product_id, zipCode = session.cart.getZipcode()) />
				</cfif>

				<cfif len(trim(request.p.product_id)) and isNumeric(request.p.product_id)>
					<!---
					**
					* Add this plan to the indicated line.
					**
					--->
					<cfset cartLines[request.p.cartLineNumber].getPlan().setProductID(request.p.product_id) />
					<cfset cartLines[request.p.cartLineNumber].getPlan().setType('rateplan') />
					<cfset cartLines[request.p.cartLineNumber].setPlanType(application.model.plan.getPlanTypeByProductID(request.p.product_id)) />

					<cfset session.cart.setCarrierId(application.model.product.getCarrierIdByProductId(request.p.product_id)) />
					<cfset session.planFilterSelections.filterOptions = 0 />
					<cfset session.planFilterSelections.filterOptions = listAppend(session.planFilterSelections.filterOptions, filterHelper.getFilterOptionId('plan', 'planType', 'local_plan.planType')) />
					<cfset session.planFilterSelections.filterOptions = listAppend(session.planFilterSelections.filterOptions, filterHelper.getFilterOptionId('plan', 'carrierID', 'local_plan.carrierID')) />
					<cfset session.phoneFilterSelections.filterOptions = 0 />
					<cfset session.phoneFilterSelections.filterOptions = listAppend(session.phoneFilterSelections.filterOptions, filterHelper.getFilterOptionId('phone', 'carrierID', 'local_plan.carrierID')) />
					<cfset session.dataCardAndNetbookFilterSelections.filterOptions = 0 />
					<cfset session.dataCardAndNetbookFilterSelections.filterOptions = listAppend(session.dataCardAndNetbookFilterSelections.filterOptions, filterHelper.getFilterOptionId('dataCardAndNetbook', 'carrierID', 'local_plan.carrierID')) />
					<cfset session.prePaidFilterSelections.filterOptions = 0 />
					<cfset session.prePaidFilterSelections.filterOptions = listAppend(session.prePaidFilterSelections.filterOptions, filterHelper.getFilterOptionId('prepaid', 'carrierID', 'local_plan.carrierID')) />

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

					<cfset thisPlan = application.model.plan.getByFilter(idList = request.p.product_id) />

					<cfif variables.thisPlan.planType is 'family' || (variables.thisPlan.planType eq 'data' && variables.thisPlan.IsShared)>
						<cfset application.model.cartHelper.setFamilyPlan(request.p.product_id) />
					<cfelse>
						<!--- Reset shared family plan --->
						<cfset session.cart.setFamilyPlan( CreateObject("component", "cfc.model.CartItem").init() ) />
						<cfset session.cart.setSharedFeatures( ArrayNew(1) ) />
					</cfif>

					<cfset session.cart.setCurrentLine(request.p.cartLineNumber) />
					 
					<cfset request.hasWirelessItemBeenAdded = true />
					<cfset request.p.productType = '' />

					<cfset local.getRebates = application.model.rebates.getProductInRebateFilter(productId = request.p.product_id, type = 'new') />
					<cfset local.rebateArray = session.cart.getRebates() />

					<cfif local.getRebates.recordCount>
						<cfset arrayAppend(local.rebateArray, local.getRebates) />

						<cfset session.cart.setRebates(local.rebateArray) />
					</cfif>

					<cfinclude template="/views/cart/dsp_viewCartInDialog.cfm" />

					<cfexit method="exittag" />
				<cfelse>
					<hr />
						The plan you've selected is not available in your zip code.
					<hr />

					<cfexit method="exittag" />
				</cfif>
			</cfcase>

			<cfcase value="datacard">
				<cfabort />
			</cfcase>

			<cfcase value="netbook">
				<cfabort />
			</cfcase>

			<cfcase value="accessory">
				<cfset newAccessory = createObject('component', 'cfc.model.CartItem').init() />
				<cfset newAccessory.setProductID(request.p.product_id) />
				<cfset thisAccessory = application.model.accessory.getByFilter(idList = request.p.product_id) />
				<cfset newAccessory.setGersSKU(thisAccessory.GersSKU) />
				<cfset newAccessory.getPrices().setDueToday(variables.thisAccessory.price) />
				<cfset newAccessory.getPrices().setCOGS(application.model.product.getCOGS(variables.newAccessory.getProductId())) />
				<cfset newAccessory.getPrices().setRetailPrice(variables.thisAccessory.price_retail) />
				<cfset newAccessory.setType('accessory') />
				<cfset addedAccessoryToWorkflow = false />

				<!--- If the user is adding to 'other items'. --->
				<cfif not request.p.cartLineNumber or request.p.cartLineNumber eq request.config.otherItemsLineNumber>
					<cfloop from="1" to="#request.p.qty#" index="iQty">
						<cfset arrayAppend(session.cart.getOtherItems(), variables.newAccessory) />
					</cfloop>

					<cfset session.cart.setCurrentLine(request.p.cartLineNumber) />
				<cfelse>
					<cfloop from="1" to="#request.p.qty#" index="iQty">
						<cfset arrayAppend(variables.cartLines[request.p.cartLineNumber].getAccessories(), variables.newAccessory) />
					</cfloop>

					<cfset addedAccessoryToWorkflow = true />
					<cfset session.cart.setCurrentLine(request.p.cartLineNumber) />
				</cfif>

				 
				<cfset request.hasWirelessItemBeenAdded = variables.addedAccessoryToWorkflow />
				<cfset request.p.productType = '' />

				<cfset local.getRebates = application.model.rebates.getProductInRebateFilter(productId = request.p.product_id, type = 'new') />
				<cfset local.rebateArray = session.cart.getRebates() />

				<cfif local.getRebates.recordCount>
					<cfset arrayAppend(local.rebateArray, local.getRebates) />

					<cfset session.cart.setRebates(local.rebateArray) />
				</cfif>

				<cfinclude template="/views/cart/dsp_viewCartInDialog.cfm" />

				<cfexit method="exittag" />
			</cfcase>

			<cfcase value="warranty">
				<cfscript>
					newWarranty = createObject('component', 'cfc.model.CartItem').init();
					newWarranty.setProductID(request.p.product_id);
					thisWarranty = application.model.Warranty.getByID(request.p.product_id);
					newWarranty.setGersSKU(thisWarranty.GersSKU);
					newWarranty.getPrices().setDueToday(variables.thisWarranty.price);
					newWarranty.getPrices().setRetailPrice(variables.thisWarranty.price);
					newWarranty.setTitle(variables.thisWarranty.SummaryTitle);
					newWarranty.setType('Warranty');
					
					cartLines[request.p.cartLineNumber].setWarranty( newWarranty );
					
					request.p.productType = '';
					
					 
				</cfscript>
				
				<cfinclude template="/views/cart/dsp_viewCartInDialog.cfm" />
				<cfexit method="exittag" />
			</cfcase>

			<cfdefaultcase>
				<!--- Do Nothing --->
			</cfdefaultcase>
		</cfswitch>

	</cfcase>

	<cfcase value="deleteLine">
		<cfparam name="request.p.line" type="string" default="0" />
		<cfparam name="request.p.blnDialog" type="boolean" default="false" />

		<cfif isNumeric(trim(request.p.line))>
			<cfset application.model.cartHelper.deleteLine(request.p.line) />
			<cfset cartLines = session.cart.getLines() />
			<cfset request.hasWirelessItemBeenAdded = true />
		</cfif>

		<cfif not arrayLen(variables.cartLines)>
			<!---
			**
			* Make sure we remove any cart-level family plan that might have been assigned.
			**
			--->
			<cfset session.cart.setFamilyPlan(createObject('component', 'cfc.model.CartItem').init()) />

			<cfset application.model.cartHelper.clearCart() />
		</cfif>

		 

		<cfif request.p.blnDialog>
			<cfset request.layoutFile = 'noLayout' />
			<cfset request.p.do = 'viewInDialog' />
		<cfelse>
			<cfset request.p.do = 'view' />
		</cfif>

		<cfinclude template="index.cfm" />

		<cfexit method="exittag" />
	</cfcase>

	<cfcase value="addLine">
		<cfparam name="request.p.blnDialog" type="boolean" default="false" />

		<cfset application.model.cartHelper.addLine() />
		<cfset cartLines = session.cart.getLines() />
		<cfset request.hasWirelessItemBeenAdded = true />
		 

		<cfif request.p.blnDialog>
			<cfset request.layoutFile = 'noLayout' />
			<cfset request.p.do = 'viewInDialog' />
		<cfelse>
			<cfset request.p.do = 'view' />
		</cfif>

		<cfinclude template="index.cfm" />

		<cfexit method="exittag" />
	</cfcase>

	<cfcase value="redirectToFilter">
		<cfif structKeyExists(url, 'carrierId') and structKeyExists(url, 'activationType')>

			<cfif url.carrierID eq 109>
				<cfset url.carrierId = 1 />
			<cfelseif url.carrierID eq 128>
				<cfset url.carrierId = 2 />
			<cfelseif url.carrierID eq 42>
				<cfset url.carrierId = 3 />
			<cfelseif url.carrierID eq 299>
				<cfset url.carrierId = 230 />
			</cfif>

			<cfif url.activationType is 'new'>
				<cfset theUrl = '/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,#url.carrierId#,32/' />
				<cflocation url="#variables.theUrl#" addtoken="false" />
			<cfelseif url.activationType is 'upgrade'>
				<cfset theUrl = '/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,#url.carrierId#,33/' />
				<cflocation url="#variables.theUrl#" addtoken="false" />
			<cfelseif url.activationType is 'addaline'>
				<cfset theUrl = '/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,#url.carrierId#,34/' />
				<cflocation url="#variables.theUrl#" addtoken="false" />
			<cfelse>
				<cflocation url="/index.cfm" addtoken="false" />
			</cfif>
		</cfif>
	</cfcase>

	<cfcase value="clearCart">
		<cfparam name="request.p.blnDialog" type="boolean" default="false" />

		<cfset application.model.cartHelper.clearCart() />

		<cfif request.p.blnDialog>
			<cfset request.layoutFile = 'noLayout' />
			<cfset request.p.do = 'viewInDialog' />
		<cfelse>
			<cfset request.p.do = 'view' />
		</cfif>

		<cfif structKeyExists(url, 'carrierId') and structKeyExists(url, 'activationType')>

			<cfif url.carrierID eq 109>
				<cfset url.carrierId = 1 />
			<cfelseif url.carrierID eq 128>
				<cfset url.carrierId = 2 />
			<cfelseif url.carrierID eq 42>
				<cfset url.carrierId = 3 />
			<cfelseif url.carrierID eq 299>
				<cfset url.carrierId = 230 />
			</cfif>

			<cfif url.activationType is 'new'>
				<cfset theUrl = '/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,#url.carrierId#,32/' />
				<cflocation url="#variables.theUrl#" addtoken="false" />
			<cfelseif url.activationType is 'upgrade'>
				<cfset theUrl = '/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,#url.carrierId#,33/' />
				<cflocation url="#variables.theUrl#" addtoken="false" />
			<cfelseif url.activationType is 'addaline'>
				<cfset theUrl = '/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,#url.carrierId#,34/' />
				<cflocation url="#variables.theUrl#" addtoken="false" />
			<cfelse>
				<cfinclude template="index.cfm" />
			</cfif>
		</cfif>

		<cfinclude template="index.cfm" />

		<cfexit method="exittag" />
	</cfcase>

	<cfcase value="showCartDialog">
		<cfparam name="request.p.line" type="string" default="0" />
		<cfparam name="request.p.blnDialog" type="boolean" default="false" />

		<cfif request.p.blnDialog>
			<cfset request.layoutFile = 'noLayout' />
			<cfset request.p.do = 'viewInDialog' />
		<cfelse>
			<cfset request.p.do = 'view' />
		</cfif>

		<cfinclude template="index.cfm" />

		<cfexit method="exittag" />
		
	</cfcase>

	<cfcase value="removePhone">
		<cfparam name="request.p.line" type="string" default="0" />
		<cfparam name="request.p.blnDialog" type="boolean" default="false" />

		<cfif isNumeric(trim(request.p.line)) and trim(request.p.line) gt 0>
			<cfset request.p.cartLineNumber = request.p.line />
			<cfset application.model.cartHelper.removePhone(line = request.p.line) />
			<cfset application.model.cartHelper.removeWarranty(line = request.p.line) />
		</cfif>

		<cfif request.p.blnDialog>
			<cfset request.layoutFile = 'noLayout' />
			<cfset request.p.do = 'viewInDialog' />
		<cfelse>
			<cfset request.p.do = 'view' />
		</cfif>

		<cfinclude template="index.cfm" />

		<cfexit method="exittag" />
	</cfcase>

	<cfcase value="removePlan">
		<cfparam name="request.p.line" type="string" default="0" />
		<cfparam name="request.p.blnDialog" type="boolean" default="false" />

		<cfif not isNumeric(trim(request.p.line))>
			<cfset request.p.line = 0 />
		<cfelse>
			<cfset request.p.line = trim(request.p.line) />
		</cfif>

		<cfset request.p.cartLineNumber = request.p.line />
		<cfset application.model.cartHelper.removePlan(line = request.p.line) />

		<cfif request.p.blnDialog>
			<cfset request.layoutFile = 'noLayout' />
			<cfset request.p.do = 'viewInDialog' />
		<cfelse>
			<cfset request.p.do = 'view' />
		</cfif>

		<cfinclude template="index.cfm" />

		<cfexit method="exittag" />
	</cfcase>

	<cfcase value="removeAccessory">
		<cfparam name="request.p.line" type="string" default="1" />
		<cfparam name="request.p.productID" type="string" default="0" />
		<cfparam name="request.p.blnDialog" type="boolean" default="false" />

		<cfif isNumeric(trim(request.p.line)) and isNumeric(trim(request.p.productId)) and trim(request.p.line) gt 0 and trim(request.p.productId) gt 0>
			<cfset request.p.line = trim(request.p.line) />
			<cfset request.p.productId = trim(request.p.productId) />

			<cfset request.p.cartLineNumber = request.p.line />
			<cfset application.model.cartHelper.removeAccessory(line = request.p.line, productId = request.p.productId) />
		</cfif>

		<cfif request.p.blnDialog>
			<cfset request.layoutFile = 'noLayout' />
			<cfset request.p.do = 'viewInDialog' />
		<cfelse>
			<cfset request.p.do = 'view' />
		</cfif>

		<cfinclude template="index.cfm" />

		<cfexit method="exittag" />
	</cfcase>

	<cfcase value="removeFeature">
		<cfparam name="request.p.line" type="string" default="1" />
		<cfparam name="request.p.productID" type="string" default="0" />
		<cfparam name="request.p.blnDialog" type="boolean" default="false" />

		<cfif isNumeric(trim(request.p.line)) and isNumeric(trim(request.p.productId)) and trim(request.p.line) gt 0 and trim(request.p.productId) gt 0>
			<cfset request.p.line = trim(request.p.line) />
			<cfset request.p.productId = trim(request.p.productId) />

			<cfset request.p.cartLineNumber = request.p.line />
			<cfset application.model.cartHelper.removeFeature(line = request.p.line, productId = request.p.productId) />
		</cfif>

		<cfif request.p.blnDialog>
			<cfset request.layoutFile = 'noLayout' />
			<cfset request.p.do = 'viewInDialog' />
		<cfelse>
			<cfset request.p.do = 'view' />
		</cfif>

		<cfinclude template="index.cfm" />

		<cfexit method="exittag" />
	</cfcase>

	<cfcase value="removeWarranty">
		<cfparam name="request.p.line" type="string" default="0" />
		<cfparam name="request.p.blnDialog" type="boolean" default="false" />

		<cfif isNumeric(trim(request.p.line)) and trim(request.p.line) gt 0>
			<cfset request.p.cartLineNumber = request.p.line />
			<cfset application.model.cartHelper.removeWarranty(line = request.p.line) />
		</cfif>

		<cfif request.p.blnDialog>
			<cfset request.layoutFile = 'noLayout' />
			<cfset request.p.do = 'viewInDialog' />
		<cfelse>
			<cfset request.p.do = 'view' />
		</cfif>

		<cfinclude template="index.cfm" />

		<cfexit method="exittag" />
	</cfcase>
	
	<cfcase value="removeanddeclineWarranty">
		<cfparam name="request.p.line" type="string" default="0" />
		<cfparam name="request.p.blnDialog" type="boolean" default="false" />
		
		<cfif isNumeric(trim(request.p.line)) and trim(request.p.line) gt 0>
			<cfset request.p.cartLineNumber = request.p.line />
			<cfset application.model.cartHelper.removeWarranty(line = request.p.line) />
		</cfif>
		<cfif request.p.line>
			<cfset application.model.cartHelper.declineWarranty(request.p.line) />
		</cfif>		

		<cfif request.p.blnDialog>
			<cfset request.layoutFile = 'noLayout' />
			<cfset request.p.do = 'viewInDialog' />
		<cfelse>
			<cfset request.p.do = 'view' />
		</cfif>

		<cfinclude template="index.cfm" />

		<cfexit method="exittag" />
				
	</cfcase>	

	<cfcase value="changeZipcode">
		<cfparam name="request.p.zipCode" type="string" />
		<cfparam name="request.p.blnDialog" type="boolean" default="false" />

		<cfset request.p.zipCode = trim(request.p.zipCode) />
		<cfset blnValidZipcode = false />

		<cfif isValid('zipcode', request.p.zipCode) and application.model.market.getByZipCode(request.p.zipCode).recordCount>
			<cfset blnValidZipcode = true />
		</cfif>

		<cfif variables.blnValidZipcode>
			<cfset application.model.cartHelper.changeZipCode(zipCode=request.p.zipCode) />
		<cfelse>
			<cfset arrErrors = arrayNew(1) />
			<cfset arrayAppend(variables.arrErrors, 'Please enter a valid 5 digit zip code.') />

			<cfoutput>
				<cfset request.layoutFile = 'noLayout' />
				<cfinclude template="/views/cart/dsp_cartErrors.cfm" />
			</cfoutput>

			<cfexit method="exittag" />
		</cfif>

		<cfif request.p.blnDialog>
			<cfset request.layoutFile = 'noLayout' />
			<cfset request.p.do = 'viewInDialog' />
		<cfelse>
			<cfset request.p.do = 'view' />
		</cfif>

		<cfinclude template="index.cfm" />

		<cfexit method="exittag" />
	</cfcase>

	<cfcase value="loadCart">
		<cfset request.p.do = 'view' />

		<cfinclude template="index.cfm" />

		<cfexit method="exittag" />
	</cfcase>

	<cfcase value="declineFeatures">
		<cfparam name="request.p.line" type="integer" default="0" />

		<cfif request.p.line>
			<cfset application.model.cartHelper.declineFeatures(request.p.line) />
		</cfif>

		<cfif request.p.blnDialog>
			<cfset request.layoutFile = 'noLayout' />
			<cfset request.p.do = 'viewInDialog' />
		<cfelse>
			<cfset request.p.do = 'view' />
		</cfif>

		<cfinclude template="index.cfm" />

		<cfexit method="exittag" />
	</cfcase>

	<cfcase value="declineAccessories">
		<cfparam name="request.p.line" type="integer" default="0" />

		<cfif request.p.line>
			<cfset application.model.cartHelper.declineAccessories(request.p.line) />
		</cfif>

		<cfif request.p.blnDialog>
			<cfset request.layoutFile = 'noLayout' />
			<cfset request.p.do = 'viewInDialog' />
		<cfelse>
			<cfset request.p.do = 'view' />
		</cfif>

		<cfinclude template="index.cfm" />

		<cfexit method="exittag" />
	</cfcase>

	<cfcase value="declineWarranty">
		<cfparam name="request.p.line" type="integer" default="0" />

		<cfif request.p.line>
			<cfset application.model.cartHelper.declineWarranty(request.p.line) />
		</cfif>

		<cfif request.p.blnDialog>
			<cfset request.layoutFile = 'noLayout' />
			<cfset request.p.do = 'viewInDialog' />
		<cfelse>
			<cfset request.p.do = 'view' />
		</cfif>

		<cfinclude template="index.cfm" />

		<cfexit method="exittag" />
	</cfcase>

	<cfdefaultcase>
		<cflocation url="/index.cfm/go/cart/do/view/" addtoken="false" />
	</cfdefaultcase>
</cfswitch>
