<cfcomponent output="false" displayname="dBuilderCartHelper" extends="fw.model.BaseService">

	<cfproperty name="DBuilderCart" inject="id:DBuilderCart" />
	<cfproperty name="DBuilderCartHelper" inject="id:DBuilderCartHelper" />
	<cfproperty name="DBuilderCartItem" inject="id:DBuilderCartItem" />
	<cfproperty name="DBuilderCartPriceBlock" inject="id:DBuilderCartPriceBlock" />
	
	<cffunction name="init" returntype="fw.model.shopping.dBuilderCartHelper">
		<cfparam name="session.dBuilderCart" type="any" default="#createObject("Component","fw.model.shopping.dBuilderCart").init()#">
		<!--- Remove this when this component is added to CS --->        
        <cfset setAssetPaths( application.wirebox.getInstance("assetPaths") ) />
		<cfreturn this>
	</cffunction>

	<cffunction name="zipcodeEntered" returntype="boolean">
		<cfset var local = structNew()>
		<cfset local.bEntered = true>
		<cfif session.dbuildercart.getZipcode() eq "00000">
			<cfset local.bEntered = false>
		</cfif>
		<cfreturn local.bEntered>
	</cffunction>

	<cffunction name="clearCart" access="public" returntype="void" output="false">
		<cfset var local = {} />
		<cfset session.dbuildercart = createObject("Component","fw.model.shopping.dBuilderCart").init() />
		<cfif application.wirebox.containsInstance("CampaignService")>
			<cfset local.campaignService = application.wirebox.getInstance("CampaignService") />
			<cfset local.campaign = local.campaignService.getCampaignBySubdomain( local.campaignService.getCurrentSubdomain() ) />
			<cfif IsDefined( 'local.campaign' ) AND local.campaign.getCampaignId()>
				<cfset session.phoneFilterSelections.filterOptions = 0 />
				<cfset session.planFilterSelections.filterOptions = 0 />
				<cfset session.prepaidFilterSelections.filterOptions = 0 />
				<cfset session.tabletFilterSelections.filterOptions = 0 />			
			</cfif>
		</cfif>

		<cfset application.model.checkoutHelper.setCheckoutCouponCode('') />
		<cfset application.model.checkoutHelper.setCheckoutPromotionCode('') />
		<cfset request.hasWirelessItemBeenAdded = true />
	</cffunction>

	<cffunction name="addLineToCart" returntype="numeric">
		<cfset var local = structNew()>

		<cfset arrayAppend(session.dbuildercart.getLines(),createObject("Component","fw.model.shopping.dBuilderCartlineLine").init())>
		<!--- if there's a family plan in the cart --->
		<cfif session.dbuildercart.getFamilyPlan().hasBeenSelected()>
			<!--- pre-assign the selected family plan to the new line --->
			<cfset local.cartLines = session.dbuildercart.getLines()>
			<cfset local.cartLines[arrayLen(local.cartLines)].getPlan().setProductID(session.dbuildercart.getFamilyPlan().getProductID())>
			<cfset local.cartLines[arrayLen(local.cartLines)].getPlan().setType("rateplan")>
			<cfset session.dbuildercart.setLines(local.cartLines)>
		</cfif>

		 

		<cfreturn arrayLen(session.dbuildercart.getLines())>
	</cffunction>

	<cffunction name="deleteLine" access="public" returntype="void" output="false">
		<cfargument name="lineNumber" type="numeric" required="true" />

		<cfif arguments.lineNumber lte arrayLen(session.dbuildercart.getLines())>
			<cftry>
				<cfset arrayDeleteAt(session.dbuildercart.getLines(), arguments.lineNumber) />
				<cfset session.dbuildercart.setCurrentLine(arrayLen(session.dbuildercart.getLines())) />

				<cfif not session.dbuildercart.getCurrentLine()>
					<cfset removeFamilyPlan() />
				</cfif>

				<!--- Update line device pricing if this is a family plan order--->
				<cfif session.dbuildercart.getHasFamilyPlan()>
					<cfset updateFamilyPlanDevicePrices( session.dbuildercart ) />
				</cfif>

				 

				<cfcatch type="any">
					<!--- Do Nothing --->
				</cfcatch>
			</cftry>
		</cfif>
	</cffunction>

	<cffunction name="addLine" returntype="void">
		<cfset var local = structNew()>
		<cfif arrayLen(session.dbuildercart.getLines()) lt request.config.maxLines>
			<cfset arrayAppend(session.dbuildercart.getLines(),createObject("Component","fw.model.shopping.dBuilderCartlineLine").init())>
			<cfset session.dbuildercart.setCurrentLine(arrayLen(session.dbuildercart.getLines()))>
			<cfif session.dbuildercart.getFamilyPlan().hasBeenSelected()>
				<cfset setFamilyPlan(session.dbuildercart.getFamilyPlan().getProductID())>
			</cfif>
			 
		</cfif>
	</cffunction>

	<cffunction name="isEmpty" returntype="boolean">
		<cfset var local = structNew()>
		<cfset local.bEmpty = true>
		<cfif arrayLen(session.dbuildercart.getOtherItems())>
			<cfset local.bEmpty = false>
		<cfelseif arrayLen(session.dbuildercart.getLines())>
			<cfset local.cartLines = session.dbuildercart.getLines()>
			<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.iLine">
				<cfset local.thisLine = local.cartLines[local.iLine]>
				<cfif local.thisLine.getPhone().hasBeenSelected() or local.thisLine.getPlan().hasBeenSelected() or arrayLen(local.thisLine.getFeatures()) or arrayLen(local.thisLine.getAccessories())>
					<cfset local.bEmpty = false>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfreturn local.bEmpty>
	</cffunction>

	<cffunction name="getNumberOfLines" returntype="numeric">
		<cfset var local = structNew()>
		<cfset local.numLines = 0>
		<cfif not isEmpty()>
			<cfset local.numLines = arrayLen(session.dbuildercart.getLines())>
		</cfif>
		<cfreturn local.numLines>
	</cffunction>

	<cffunction name="getLineName" returntype="string">
		<cfargument name="lineNumber" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfset local.return = "Line #arguments.lineNumber#">
		<cfset local.cartLines = session.dbuildercart.getLines()>
		<cfset local.thisLine = local.cartLines[arguments.lineNumber]>
		<cfset local.lineAlias = local.thisLine.getAlias()>
		<cfif len(trim(local.lineAlias))>
			<cfset local.return = trim(local.lineAlias)>
		</cfif>
		<cfreturn local.return>
	</cffunction>

	<cffunction name="getLineDeviceProductId" access="public" output="false" returntype="numeric">
		<cfargument name="line" type="numeric" required="true">
		<cfset var local = arguments>
		<cfset local.id = 0>
		<cfset local.cartLines = session.dbuildercart.getLines()>
		<cfif arrayLen(local.cartLines) gte local.line and local.line>
			<cfset local.thisLine = local.cartLines[local.line]>
			<cfif local.thisLine.getPhone().hasBeenSelected()>
				<cfset local.id = local.thisLine.getPhone().getProductId()>
			</cfif>
		</cfif>
		<cfreturn local.id>
	</cffunction>

	<cffunction name="getLineRateplanProductId" access="public" output="false" returntype="numeric">
		<cfargument name="line" type="numeric" required="true">
		<cfset var local = arguments>
		<cfset local.id = 0>
		<cfset local.cartLines = session.dbuildercart.getLines()>
		<cfif arrayLen(local.cartLines) gte local.line and local.line>
			<cfset local.thisLine = local.cartLines[local.line]>
			<cfif local.thisLine.getPlan().hasBeenSelected()>
				<cfset local.id = local.thisLine.getPlan().getProductId()>
			</cfif>
		</cfif>
		<cfreturn local.id>
	</cffunction>

	<cffunction name="getLineWarrantyProductId" access="public" output="false" returntype="numeric">
		<cfargument name="line" type="numeric" required="true">
		<cfset var local = arguments>
		<cfset local.id = 0>
		<cfset local.cartLines = session.dbuildercart.getLines()>
		<cfif arrayLen(local.cartLines) gte local.line and local.line>
			<cfset local.thisLine = local.cartLines[local.line]>
			<cfif local.thisLine.getWarranty().hasBeenSelected()>
				<cfset local.id = local.thisLine.getWarranty().getProductId()>
			</cfif>
		</cfif>
		<cfreturn local.id>
	</cffunction>

	<cffunction name="validateAddItem" returntype="array">
		<cfset var local = structNew()>
		<cfset local.errors = arrayNew(1)>

		<!--- if the user doesn't even have a cart yet --->
		<cfif not isDefined("session.dbuildercart") or not isStruct(session.dbuildercart)>
			<!--- create one and send the user on his way --->
			<cfset session.dbuildercart = createObject("Component","fw.model.shopping.dBuilderCartline").init()>
			 
			<cfreturn local.errors>
		</cfif>

		<!---
			conditions to check for:
				1.	selected plan available in zipcode
				2.	no cross-carrier phones in the same cart
				3.	no cross-carrier plans in the same cart
				4.	no family & individual plans
				5.	no phone/plan cross-carrier combinations
		--->

		<cfset local.cartLines = session.dbuildercart.getLines()>


		<!--- selected plan available in zipcode --->
		<cfif arguments.productType eq "plan" and zipcodeEntered()>
			<cfset local.planAvailableInZipcode = false>
			<cfif application.model.Plan.isPlanAvailableInZipcode(planId=arguments.product_id,zipcode=session.dbuildercart.getZipcode())>
				<cfset local.planAvailableInZipcode = true>
			</cfif>
			<cfif not local.planAvailableInZipcode>
				<cfset arrayAppend(local.errors,"The Plan you've selected is not available in your zip code.<br>Please select a different plan or zip code.")>
			</cfif>
		</cfif>

		<!--- cross-carrier phones --->
		<cfif listFindNoCase("phone,tablet,dataCardAndNetbook",arguments.productType) and arrayLen(local.cartLines)>
			<!--- get the carrierID of the phone being added --->
			<cfset local.newPhoneCarrierID = application.model.Product.getCarrierIDbyProductID(arguments.product_id)>
			<!--- loop through the lines in the cart --->
			<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.iThisLine">
				<!--- validate against the carrierID of other phones in the cart --->
				<cfif local.iThisLine neq arguments.cartLineNumber and local.cartLines[local.iThisLine].getPhone().hasBeenSelected()>
					<!--- get the carrierID of this phone --->
					<cfset local.thisPhoneCarrierID = application.model.Product.getCarrierIDbyProductID(local.cartLines[local.iThisLine].getPhone().getProductID())>
					<cfif local.thisPhoneCarrierID neq local.newPhoneCarrierID>
						<cfset arrayAppend(local.errors,"You may not add phones from different carriers to different lines in the same cart.")>
						<cfbreak>
					</cfif>
				</cfif>
				<!--- validate against the carrierID of plans in the cart --->
				<cfif local.cartLines[local.iThisLine].getPlan().hasBeenSelected()>
					<!--- get the carrierID of this plan --->
					<cfset local.thisPlanCarrierID = application.model.Plan.getCarrierIDbyPlanID(local.cartLines[local.iThisLine].getPlan().getProductID())>
					<cfif local.thisPlanCarrierID neq local.newPhoneCarrierID>
						<cfset arrayAppend(local.errors,"You may not add phones to a cart containing plans from another carrier.")>
						<cfbreak>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>

		<!--- cross-plan types --->
		<cfif request.p.productType eq "plan" and not isNumeric(request.p.product_id)>
			<!--- cross plan type check --->
			<cfset local.newPlanType = application.model.Plan.getPlanTypeByPlanStringID(planStringID="#request.p.product_id#")>
			<cfif local.newPlanType eq "individual" and session.dbuildercart.getFamilyPlan().hasBeenSelected()>
				<cfset arrayAppend(local.errors,"You may not add an Individual plan to a cart containing a Family plan.<br>Please remove the Family Plan(s) from your cart before attempting to add an Individial Plan.")>
			<cfelseif local.newPlanType eq "family">
				<cfset local.selectedIndividualPlan = false>
				<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.iThisLine">
					<cfif local.cartLines[local.iThisLine].getPlan().hasBeenSelected()>
						<cfset local.thisPlanType = application.model.Plan.getPlanTypeByProductID(local.cartLines[local.iThisLine].getPlan().getProductID())>
						<cfif local.thisPlanType neq "family">
							<cfset arrayAppend(local.errors,"You may not add a Family plan to a cart containing an Individual or Data plan.<br>Please remove the Individual and/or Data Plan(s) from your cart before attempting to add a Family Plan.")>
							<cfbreak>
						</cfif>
					</cfif>
				</cfloop>
			</cfif>

			<!--- cross carrier check --->
			<cfset local.newPlanCarrierID = application.model.Plan.getCarrierIDbyPlanStringID(planStringID="#request.p.product_id#")>

			<!--- loop through the lines in the cart --->
			<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.iThisLine">
				<!--- validate against the carrierID of other plans in the cart --->
				<cfif local.iThisLine neq arguments.cartLineNumber and local.cartLines[local.iThisLine].getPlan().hasBeenSelected()>
					<!--- get the carrierID of this plan --->
					<cfset local.thisPlanCarrierID = application.model.Plan.getCarrierIDbyPlanID(local.cartLines[local.iThisLine].getPlan().getProductID())>
					<cfif local.thisPlanCarrierID neq local.newPlanCarrierID>
						<cfset arrayAppend(local.errors,"You may not add plans from different carriers to different lines in the same cart.")>
						<cfbreak>
					</cfif>
				</cfif>
				<!--- validate against the carrierID of phones in the cart --->
				<cfif local.cartLines[local.iThisLine].getPhone().hasBeenSelected()>
					<!--- get the carrierID of this phone --->
					<cfset local.thisPhoneCarrierID = application.model.Product.getCarrierIDbyProductID(local.cartLines[local.iThisLine].getPhone().getProductID())>
					<cfif local.thisPhoneCarrierID neq local.newPlanCarrierID>
						<cfset arrayAppend(local.errors,"You may not add plans to a cart containing phones from another carrier.")>
						<cfbreak>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>

		<!--- restrict the user from cross-activationType adds to the cart (except New Family Plans)--->
		<cfif request.p.productType eq "phone" and len(trim(session.dbuildercart.getActivationType())) and arrayLen(local.cartLines)>
			<!--- determine the selected devices and features in the cart --->
			<cfset local.stcSelectedDevices = getSelectedDevices()>
			<cfset local.stcSelectedFeatures = getSelectedFeatures()>
			<!--- if there are devices and features in the cart --->
			<cfif structCount(local.stcSelectedDevices)>
				<!--- verify that the activationType of the item being added matches the activationType assigned in the cart with the exception of New Family Plans --->
				<cfif (request.p.activationType DOES NOT CONTAIN "finance")>
					<cfif (session.dbuildercart.getActivationType() DOES NOT CONTAIN "finance")>
						<cfif request.p.activationType neq session.dbuildercart.getActivationType() AND !(request.p.activationType DOES NOT CONTAIN 'upgrade' AND session.dbuildercart.getHasFamilyPlan())>
							<cfset arrayAppend(local.errors, "You may not add devices of different activation types to your cart.")>
						</cfif>
					</cfif>
				</cfif>
				<!--- determine if the user is changing a previously selected device on a line with features selected --->
				<cfif structCount(local.stcSelectedFeatures)>
					<cfif structKeyExists(local.stcSelectedDevices,arguments.cartLineNumber) and structKeyExists(local.stcSelectedFeatures,arguments.cartLineNumber) and arguments.product_id neq local.stcSelectedDevices[arguments.cartLineNumber]>
						<!--- don't error here - just remove the features on the indicated cart line since a new device is being selected --->
						<cfset local.cartLines[arguments.cartLineNumber].setFeatures(arrayNew(1))>
						<cfset session.dbuildercart.setLines(local.cartLines)>
						 
					</cfif>
				</cfif>
			<!--- if there aren't any devices in the cart --->
			<cfelse>
				<!--- clean up any orphaned cart activationType indicator --->
				<cfset resetActivationType()>
				 
			</cfif>
		</cfif>

		<cfreturn local.errors>
	</cffunction>

	<cffunction name="getWorkflowContent" access="public" returntype="string" output="false">
		<cfargument name="line" type="numeric" required="true" />
		<cfargument name="step" type="numeric" required="true" />

		<cfset var local = structNew() />
		<cfset local.html = '' />

		<cfset local.userSession = session />
		<cfset local.cart = local.usersession.dbuildercart />
		<cfset local.cartLines = local.cart.getLines() />

		<cfif arguments.line lte arrayLen(local.cartLines)>
			<cfset local.cartLine = local.cartLines[arguments.line] />

			<cfscript>
				// build the mini struct we'll use to pattern the item data passed to the UI renderer
				local.thisDataModel = structNew();
				local.thisDataModel.title = "";
				local.thisDataModel.description = "";
				local.thisDataModel.imageURL = "";
				local.thisDataModel.price = "";
				local.thisDataModel.detailURL = "";
				local.thisDataModel.changeURL = "";
			</cfscript>




			<!--- step 1 (phone/device details) --->
			<cfif arguments.step eq 1>
				<!--- if phone has been selected for this line --->
				<cfif local.cartLine.getPhone().hasBeenSelected()>
					<!--- get the phone data --->
					<cfset local.thisItemID = local.cartLine.getPhone().getProductID()>
					<cfset local.thisItem = application.model.Phone.getByFilter(idList=local.thisItemID)>
					<cfif not local.thisItem.recordCount>
						<cfset local.thisItem = application.model.Tablet.getByFilter(idList=local.thisItemID)>
					</cfif>
					<cfif not local.thisItem.recordCount>
						<cfset local.thisItem = application.model.DataCardAndNetbook.getByFilter(idList=local.thisItemID)>
					</cfif>
					<cfif not local.thisItem.recordCount>
						<cfset local.thisItem = application.model.Prepaid.getByFilter(idList=local.thisItemID)>
					</cfif>
					<cfset local.thisItemPrices = local.cartLine.getPhone().getPrices()>
					<cfset local.thisData = duplicate(local.thisDataModel)>
					<cfset local.thisData.title = local.thisItem.summaryTitle>

					<cfset local.thisPhoneCarrierID = application.model.Product.getCarrierIDbyProductID(local.cartLine.getPhone().getProductID())>
					<cfset local.thisPhoneSKU = application.model.OrderDetail.getGersSkuByProductId(local.cartLine.getPhone().getProductID())>

					<cfset local.productsummary = application.view.product.ReplaceRebate(#local.thisItem.summaryDescription#,#local.thisPhoneCarrierID#,#local.thisPhoneSKU#) />

					<cfset local.thisData.description = local.productsummary>

					<cfset local.stcPrimaryImage = application.model.ImageManager.getPrimaryImagesForProducts(local.thisItem.deviceGuid)>
					<cfif structKeyExists(local.stcPrimaryImage,local.thisItem.deviceGuid)>
						<cfset local.thisData.imageURL = application.view.ImageManager.displayImage(imageGuid=local.stcPrimaryImage[local.thisItem.deviceGuid],height=0,width=60)>
					<cfelse>
						<cfset local.thisData.imageURL = "#getAssetPaths().common#images/Catalog/NoImage.jpg">
					</cfif>

					<cfset local.thisData.price = local.thisItemPrices.getDueToday()>
					<cfset local.thisData.detailURL = application.view.Cart.getLink(cartLines=local.cartLines,lineNumber=arguments.line,do="phoneDetails",productID=local.thisItem.phoneID)>
					<cfset local.thisData.changeURL = application.view.Cart.getLink(cartLines=local.cartLines,lineNumber=arguments.line,do="browsePhones",productID=local.thisItem.phoneID)>
					<!--- include the file that will render the item data and capture the generated HTML for return to the caller--->
					<cfsavecontent variable="local.html">
						<cfoutput>
							<cfinclude template="/views/cart/dsp_workflowPopup_phone.cfm">
						</cfoutput>
					</cfsavecontent>
				<!--- if no phone has been selected --->
				<cfelse>
					<cfsavecontent variable="local.html">
						<cfoutput>
							<cfinclude template="/views/cart/dsp_workflowPopup_noSelection.cfm">
						</cfoutput>
					</cfsavecontent>
				</cfif>
			<!--- step 2 (plan details) --->
			<cfelseif arguments.step eq 2>
				<!--- if plan has been selected for this line --->
				<cfif local.cartLine.getPlan().hasBeenSelected()>
					<!--- get the plan data --->
					<cfset local.thisItemID = local.cartLine.getPlan().getProductID()>
					<cfset local.thisItem = application.model.Plan.getByFilter(idList=local.thisItemID)>
					<cfset local.thisItemPrices = local.cartLine.getPlan().getPrices()>
					<cfset local.thisData = duplicate(local.thisDataModel)>
					<cfset local.thisData.title = local.thisItem.summaryTitle>
					<cfset local.thisData.description = local.thisItem.summaryDescription>
					<cfif local.thisItem.carrierID eq 109> <!--- at&t --->
						<cfset local.thisData.imageURL = "#getAssetPaths().common#images/carrierLogos/att_175.gif" />
					<cfelseif local.thisItem.carrierID eq 128> <!--- t-mobile --->
						<cfset local.thisData.imageURL = "#getAssetPaths().common#images/carrierLogos/tmobile_175.gif" />
					<cfelseif local.thisItem.carrierID eq 42> <!--- verizon --->
						<cfset local.thisData.imageURL = "#getAssetPaths().common#images/carrierLogos/verizon_175.gif" />
					</cfif>
					<cfset local.thisData.price = local.thisItem.planPrice>
					<cfset local.thisData.detailURL = application.view.Cart.getLink(cartLines=local.cartLines,lineNumber=arguments.line,do="planDetails",productID=local.thisItem.planId)>
					<cfset local.thisData.changeURL = application.view.Cart.getLink(cartLines=local.cartLines,lineNumber=arguments.line,do="browsePlans",productID=local.thisItem.planID)>
					<!--- include the file that will render the item data and capture the generated HTML for return to the caller--->
					<cfsavecontent variable="local.html">
						<cfoutput>
							<cfinclude template="/views/cart/dsp_workflowPopup_plan.cfm">
						</cfoutput>
					</cfsavecontent>
				<!--- if no phone has been selected --->
				<cfelse>
					<cfsavecontent variable="local.html">
						<cfoutput>
							<cfinclude template="/views/cart/dsp_workflowPopup_noSelection.cfm">
						</cfoutput>
					</cfsavecontent>
				</cfif>
			<!--- step 3 (feature deatils) --->
			<cfelseif arguments.step eq 3>
				<!--- if features have been selected for this line --->
				<cfif arrayLen(local.cartLine.getFeatures())>
					<cfset local.items = local.cartLine.getFeatures()>
					<cfset local.lstItems = "">
					<!--- get the feature ids --->
					<cfloop from="1" to="#arrayLen(local.items)#" index="local.iItem">
						<cfset local.lstItems = listAppend(local.lstItems,local.items[local.iItem].getProductID())>
					</cfloop>
					<!--- get the feature data --->
					<cfset local.thisItems = application.model.Feature.getByProductID(local.lstItems)>
					<cfset local.arrData = arrayNew(1)>
					<cfloop query="local.thisItems">
						<cfset local.thisData = duplicate(local.thisDataModel)>
						<cfset local.thisData.title = summaryTitle>
						<cfset local.thisData.description = summaryDescription>

						<cfif carrierID eq 109> <!--- at&t --->
							<cfset local.thisData.imageURL = "#getAssetPaths().common#images/carrierLogos/att_175.gif" />
						<cfelseif carrierID eq 128> <!--- t-mobile --->
							<cfset local.thisData.imageURL = "#getAssetPaths().common#images/carrierLogos/tmobile_175.gif" />
						<cfelseif carrierID eq 42> <!--- verizon --->
							<cfset local.thisData.imageURL = "#getAssetPaths().common#images/carrierLogos/verizon_175.gif" />
						</cfif>
						<cfset local.thisData.price = price>
						<cfset local.thisData.detailURL = application.view.Cart.getLink(cartLines=local.cartLines,lineNumber=arguments.line,do="planDetails",productID=productID)>
						<cfset local.thisData.changeURL = application.view.Cart.getLink(cartLines=local.cartLines,lineNumber=arguments.line,do="planDetails",productID=productID)>
						<cfset arrayAppend(local.arrData,duplicate(local.thisData))>
					</cfloop>
					<!--- include the file that will render the item data and capture the generated HTML for return to the caller--->
					<cfsavecontent variable="local.html">
						<cfoutput>
							<cfinclude template="/views/cart/dsp_workflowPopup_feature.cfm">
						</cfoutput>
					</cfsavecontent>
				<!--- if no features have been selected --->
				<cfelse>
					<cfsavecontent variable="local.html">
						<cfoutput>
							<cfinclude template="/views/cart/dsp_workflowPopup_noSelection.cfm">
						</cfoutput>
					</cfsavecontent>
				</cfif>
			<!--- step 4 (accessory details) --->
			<cfelseif arguments.step eq 4>
				<cfset local.thisLineAccessories = lineGetAccessoriesByType(line=arguments.line,type="accessory")>
				<!--- if accessories have been selected for this line --->
				<cfif arrayLen(local.thisLineAccessories)>
					<cfset local.items = local.thisLineAccessories>
					<cfset local.lstItems = "">
					<!--- get the accessory ids --->
					<cfloop from="1" to="#arrayLen(local.items)#" index="local.iItem">
						<cfset local.lstItems = listAppend(local.lstItems,local.items[local.iItem].getProductID())>
					</cfloop>
					<!--- get the accessory data --->
					<cfset local.thisItems = application.model.Accessory.getByFilter(idList=local.lstItems)>
					<cfset local.arrData = arrayNew(1)>
					<cfset local.stcPrimaryImages = application.model.ImageManager.getPrimaryImagesForProducts(valueList(local.thisItems.accessoryGuid))>
					<cfloop query="local.thisItems">
						<cfset local.thisData = duplicate(local.thisDataModel)>
						<cfset local.thisData.title = summaryTitle>
						<cfset local.thisData.description = summaryDescription>
						<cfif structKeyExists(local.stcPrimaryImages,accessoryGuid)>
							<cfset local.thisData.imageURL = application.view.ImageManager.displayImage(imageGuid=local.stcPrimaryImages[accessoryGuid],height=0,width=60)>
						<cfelse>
							<cfset local.thisData.imageURL = "#getAssetPaths().common#images/Catalog/NoImage.jpg">
						</cfif>
						<cfset local.thisData.price = price>
						<cfset local.thisData.detailURL = application.view.Cart.getLink(cartLines=local.cartLines,lineNumber=arguments.line,do="accessoryDetails",productID=product_id)>
						<cfset local.thisData.changeURL = application.view.Cart.getLink(cartLines=local.cartLines,lineNumber=arguments.line,do="browseAccessories",productID=product_id)>
						<cfset arrayAppend(local.arrData,duplicate(local.thisData))>
					</cfloop>
					<!--- include the file that will render the item data and capture the generated HTML for return to the caller--->
					<cfsavecontent variable="local.html">
						<cfoutput>
							<cfinclude template="/views/cart/dsp_workflowPopup_accessory.cfm">
						</cfoutput>
					</cfsavecontent>
				<!--- if no features have been selected --->
				<cfelse>
					<cfsavecontent variable="local.html">
						<cfoutput>
							<cfinclude template="/views/cart/dsp_workflowPopup_noSelection.cfm">
						</cfoutput>
					</cfsavecontent>
				</cfif>
			</cfif>
		</cfif>

		<cfreturn trim(local.html) />
	</cffunction>

	<cffunction name="getSelectedDevices" returntype="struct">
		<cfset var local = structNew()>
		<cfset local.cartLines = session.dbuildercart.getLines()>
		<!--- determine if there are any devices selected in the cart lines --->
		<cfset local.stc = structNew()>
		<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.iThisLine">
			<cfif local.cartLines[local.iThisLine].getPhone().hasBeenSelected()>
				<cfset local.stc[local.iThisLine] = local.cartLines[local.iThisLine].getPhone().getProductID()>
			</cfif>
		</cfloop>
		<cfreturn local.stc>
	</cffunction>

	<cffunction name="getSelectedPlans" returntype="struct">
		<cfset var local = structNew()>
		<cfset local.cartLines = session.dbuildercart.getLines()>
		<!--- determine if there are any plans selected in the cart lines --->
		<cfset local.stc = structNew()>
		<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.iThisLine">
			<cfif local.cartLines[local.iThisLine].getPlan().hasBeenSelected()>
				<cfset local.stc[local.iThisLine] = local.cartLines[local.iThisLine].getPlan().getProductID()>
			</cfif>
		</cfloop>
		<cfreturn local.stc>
	</cffunction>

	<cffunction name="getSelectedFeatures" returntype="struct">
		<cfset var local = structNew()>
		<cfset local.cartLines = session.dbuildercart.getLines()>
		<!--- determine if there are any features selected in the cart lines --->
		<cfset local.stc = structNew()>
		<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.iThisLine">
			<cfif arrayLen(local.cartLines[local.iThisLine].getFeatures())>
				<cfset local.stc[local.iThisLine] = local.cartLines[local.iThisLine].getFeatures()>
			</cfif>
		</cfloop>
		<cfreturn local.stc>
	</cffunction>

	<cffunction name="hasSelectedFeatures" output="false" returntype="boolean">
		<cfset var local = structNew()>
		<cfset local.hasSelectedFeatures = false />
		<cfset local.cartLines = session.dbuildercart.getLines()>
		<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.iThisLine">
			<cfif arrayLen(local.cartLines[local.iThisLine].getFeatures())>
				<cfset local.hasSelectedFeatures = true />
				<cfbreak />
			</cfif>
		</cfloop>
		<cfreturn local.hasSelectedFeatures />
	</cffunction>

	<cffunction name="getSelectedAccessories" returntype="struct">
		<cfset var local = structNew()>
		<cfset local.cartLines = session.dbuildercart.getLines()>
		<!--- determine if there are any features selected in the cart lines --->
		<cfset local.stc = structNew()>
		<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.iThisLine">
			<cfif arrayLen(local.cartLines[local.iThisLine].getAccessories())>
				<cfset local.stc[local.iThisLine] = local.cartLines[local.iThisLine].getAccessories()>
			</cfif>
		</cfloop>
		<cfreturn local.stc>
	</cffunction>

	<cffunction name="setFamilyPlan" returntype="void">
		<cfargument name="planID" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfset local.cartLines = session.dbuildercart.getLines()>
		<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.iLine">
			<cfset local.thisLine = local.cartLines[local.iLine]>
			<cfset local.thisLine.getPlan().setProductID(arguments.planID)>
			<cfset local.thisLine.getPlan().setType("rateplan")>
		</cfloop>
		
		<cfset session.dbuildercart.getFamilyPlan().setProductID(arguments.planID) />
		<cfset session.dbuildercart.getFamilyPlan().setType("rateplan") />
		<cfset session.dbuildercart.getFamilyPlan().setHasPlanDeviceCap( application.model.Plan.getHasPlanDeviceCap( arguments.planID ) ) />
		<cfset session.dbuildercart.getFamilyPlan().setIsShared( application.model.Plan.getIsShared( arguments.planID ) ) />
		
		<cfset updateFamilyPlanDevicePrices( session.dbuildercart ) />
		 
	</cffunction>


	<cffunction name="removeFamilyPlan" returntype="void">
		<cfset var local = structNew()>
		<cfset local.cartLines = session.dbuildercart.getLines()>
		<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.iLine">
			<cfset local.thisLine = local.cartLines[local.iLine]>
			<cfset local.thisLine.setPlan(createObject("Component","fw.model.shopping.dBuilderCartlineItem").init())>
		</cfloop>
		<cfset session.dbuildercart.setFamilyPlan(createObject("Component","fw.model.shopping.dBuilderCartlineItem").init())>
		 
		<cfset updateFamilyPlanDevicePrices( session.dbuildercart ) />
	</cffunction>


	<!--- TODO: eventually replace this with tax service --->
	<cffunction name="stubHardGoodTaxes" access="public" output="false" returntype="void">
		<cfset var local = structNew()>

		<!--- only add taxes if the billing address is not OR (Oregon) --->
		<cfif application.model.CheckoutHelper.getBillingAddress().getState() neq "OR">
			<cfset local.cartLines = session.dbuildercart.getLines()>
			<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.iLine">
				<cfset local.thisLine = local.cartLines[local.iLine]>
				<cfif local.thisLine.getPhone().hasBeenSelected()>
					<cfset local.thisLine.getPhone().getTaxes().setDueToday(1.00)>
				</cfif>
				<cfset local.thisLineAccessories = local.thisLine.getAccessories()>
				<cfloop from="1" to="#arrayLen(local.thisLineAccessories)#" index="local.iAccessory">
					<cfset local.thisAccessory = local.thisLineAccessories[local.iAccessory]>
					<cfset local.thisAccessory.getTaxes().setDueToday(1.00)>
				</cfloop>
			</cfloop>
			<cfset local.otherItems = session.dbuildercart.getOtherItems()>
			<cfloop from="1" to="#arrayLen(local.otherItems)#" index="local.iItem">
				<cfset local.thisItem = local.otherItems[local.iItem]>
				<cfset local.thisItem.getTaxes().setDueToday(1.00)>
			</cfloop>
		</cfif>

		<cfset session.dbuildercart.updateAllTaxes()>
	</cffunction>

	<cffunction name="clearLineFreeAccessories" access="public" output="false" returntype="void">
		<cfargument name="lineNumber" type="numeric" required="true">
		<cfset var local = structNew()>

		<cfset local.cartLines = session.dbuildercart.getLines()>
		<cfset local.cartLine = local.cartLines[arguments.lineNumber]>
		<cfset local.lineAccessories = local.cartLine.getAccessories()>
		<cfloop from="#arrayLen(local.lineAccessories)#" to="1" index="local.iAccessory" step="-1">
			<cfset local.thisAccessory = local.lineAccessories[local.iAccessory]>
			<cfif local.thisAccessory.getType() eq "bundled">
				<cfset arrayDeleteAt(local.lineAccessories,local.iAccessory)>
			</cfif>
		</cfloop>
		<cfset local.cartLine.setAccessories(local.lineAccessories)>
		<cfset local.cartLines[arguments.lineNumber] = local.cartLine>
		<cfset session.dbuildercart.setLines(local.cartLines)>
	</cffunction>

	<cffunction name="lineGetAccessoriesByType" access="public" output="false" returntype="array">
		<cfargument name="line" type="numeric" required="true">
		<cfargument name="type" type="string" required="true">
		<cfset var local = arguments>
		<cfset local.return = arrayNew(1)>

		<cfif arguments.line neq request.config.otherItemsLineNumber>
			<cfset local.cartLines = session.dbuildercart.getLines()>
			<cfset local.cartLine = local.cartLines[local.line]>
			<cfset local.lineAccessories = local.cartLine.getAccessories()>
		<cfelse>
			<cfset local.lineAccessories = session.dbuildercart.getOtherItems()>
		</cfif>
		<cfloop from="1" to="#arrayLen(local.lineAccessories)#" index="local.iAccessory">
			<cfset local.thisAccessory = local.lineAccessories[local.iAccessory]>
			<cfif local.thisAccessory.getType() eq arguments.type>
				<cfset arrayAppend(local.return,local.thisAccessory)>
			</cfif>
		</cfloop>

		<cfreturn local.return>
	</cffunction>

	<cffunction name="removePhone" access="public" output="false" returntype="void">
		<cfargument name="line" type="numeric" required="true" />

		<cfset var local = structNew() />

		<cfset local.cartLines = session.dbuildercart.getLines() />

		<cfif arguments.line lte arrayLen(local.cartLines)>
			<cfset local.cartLine = local.cartLines[arguments.line] />
			<cfset local.cartLine.setPhone(createObject("Component","fw.model.shopping.dBuilderCartlineItem").init()) />
			<cfset local.cartLine.setFeatures(arrayNew(1)) />
			<cfset removeLineBundledAccessories(arguments.line) />

			<cfif not cartContainsActivationItems()>
				<cfset resetActivationType() />
			</cfif>

			<cfset request.hasWirelessItemBeenAdded = true />
			 
		</cfif>

	</cffunction>

	<cffunction name="removeLineBundledAccessories" access="public" output="false" returntype="void">
		<cfargument name="lineNumber" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfset local.cartLines = session.dbuildercart.getLines()>
		<cfset local.cartLine = local.cartLines[arguments.lineNumber]>
		<cfset local.lineAccessories = local.cartLine.getAccessories()>
		<cfloop from="#arrayLen(local.lineAccessories)#" to="1" step="-1" index="local.i">
			<cfif local.lineAccessories[local.i].getType() eq "bundled">
				<cfset arrayDeleteAt(local.lineAccessories,local.i)>
			</cfif>
		</cfloop>
		<cfset local.cartLine.setAccessories(local.lineAccessories)>
		 
	</cffunction>

	<cffunction name="removePlan" access="public" output="false" returntype="void">
		<cfargument name="line" type="numeric" required="true" />

		<cfset var local = structNew() />

		<cfset local.bFamilyPlan = false />

		<cfif session.dbuildercart.getFamilyPlan().hasBeenSelected()>
			<cfset local.bFamilyPlan = true />
		</cfif>

		<cfif local.bFamilyPlan>
			<cfset removeFamilyPlan() />
		<cfelse>
			<cfset local.cartLines = session.dbuildercart.getLines() />

			<cfif arguments.line lte arrayLen(local.cartLines)>
				<cfset local.cartLine = local.cartLines[arguments.line] />
				<cfset local.cartLine.setPlan(createObject("Component","fw.model.shopping.dBuilderCartlineItem").init()) />
				<cfset local.cartLine.setFeatures(arrayNew(1)) />
			</cfif>
		</cfif>

		<cfif not cartContainsActivationItems()>
			<cfset resetActivationType() />
		</cfif>

		<cfset request.hasWirelessItemBeenAdded = true />
		 
	</cffunction>

	<cffunction name="removeAccessory" access="public" output="false" returntype="void">
		<cfargument name="line" type="numeric" required="true" />
		<cfargument name="productId" type="numeric" required="true" />

		<cfset var local = structNew() />
		<cfset local.cartLines = session.dbuildercart.getLines() />

		<cfif arguments.line lte arrayLen(local.cartLines) OR arguments.line eq request.config.otherItemsLineNumber>
			<cfif arguments.line and arguments.line neq request.config.otherItemsLineNumber>
				<cfset local.cartLine = local.cartLines[arguments.line] />
				<cfset local.accessories = local.cartLine.getAccessories() />
			<cfelse>
				<cfset local.accessories = session.dbuildercart.getOtherItems() />
			</cfif>

			<cfloop from="1" to="#arrayLen(local.accessories)#" index="local.iAccessory">
				<cfset local.thisAccessoryId = local.accessories[local.iAccessory].getProductID() />

				<cfif local.thisAccessoryId eq arguments.productID>
					<cfset arrayDeleteAt(local.accessories, local.iAccessory) />
					<cfset request.hasWirelessItemBeenAdded = true />

					<cfbreak />
				</cfif>
			</cfloop>

			<cfif arguments.line and arguments.line neq request.config.otherItemsLineNumber>
				<cfset local.cartLine.setAccessories(local.accessories) />
			<cfelse>
				<cfset session.dbuildercart.setOtherItems(local.accessories) />
			</cfif>

			<cfif not cartContainsActivationItems()>
				<cfset resetActivationType() />
			</cfif>

			 
		</cfif>
	</cffunction>

	<cffunction name="removeWarranty" access="public" output="false" returntype="void">
		<cfargument name="line" type="numeric" required="true" />

		<cfset var local = {} />
		<cfset local.cartLines = session.dbuildercart.getLines() />

		<cfif arguments.line lte arrayLen(local.cartLines)>
			<cfset local.cartLine = local.cartLines[arguments.line] />
			<cfset local.cartLine.setWarranty(createObject("Component","fw.model.shopping.dBuilderCartlineItem").init()) />
			<cfset request.hasWirelessItemBeenAdded = true />
			 
		</cfif>
	</cffunction>

	<cffunction name="removeFeature" access="public" output="false" returntype="void">
		<cfargument name="line" type="numeric" required="true" />
		<cfargument name="productId" type="numeric" required="true" />

		<cfset var local = structNew() />
		<cfset local.cartLines = session.dbuildercart.getLines() />

		<cfif arguments.line lte arrayLen(local.cartLines)>
			<cfset local.cartLine = local.cartLines[arguments.line] />
			<cfset local.features = local.cartLine.getFeatures() />

			<cfloop from="1" to="#arrayLen(local.features)#" index="local.iFeature">
				<cfset local.thisFeatureId = local.features[local.iFeature].getProductID() />

				<cfif local.thisFeatureId eq arguments.productID>
					<cfset arrayDeleteAt(local.features, local.iFeature) />
					<cfset request.hasWirelessItemBeenAdded = true />

					<cfbreak />
				</cfif>
			</cfloop>

			<cfset local.cartLine.setFeatures(local.features) />

			 
		</cfif>
	</cffunction>

	<cffunction name="removeAllLineFeatures" access="public" output="false" returntype="void">
		<cfargument name="line" type="numeric" required="true" />

		<cfset var local = structNew() />
		<cfset local.cartLines = session.dbuildercart.getLines() />

		<cfif arguments.line lte arrayLen(local.cartLines)>
			<cfset local.cartLine = local.cartLines[arguments.line] />
			<cfset local.cartLine.setFeatures(arrayNew(1)) />
		</cfif>

		<cfif not cartContainsActivationItems()>
			<cfset resetActivationType() />
		</cfif>

		<cfset request.hasWirelessItemBeenAdded = true />
		 
	</cffunction>

	<cffunction name="changeZipcode" access="public" output="false" returntype="void">
		<cfargument name="zipcode" type="string" required="true">
		<cfset var local = structNew()>
		<cfset session.dbuildercart = createObject("Component","fw.model.shopping.dBuilderCartline").init()>
		<cfset session.dbuildercart.setZipcode(arguments.zipcode)>
		<cfset request.hasWirelessItemBeenAdded = true>
		 
	</cffunction>

	<cffunction name="cartContainsActivationItems" access="public" output="false" returntype="boolean">
		<cfset var local = structNew()>
		<cfset local.return = false>
		<cfset local.cartLines = session.dbuildercart.getLines()>
		<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.i">
			<cfif local.cartLines[local.i].getPhone().hasBeenSelected() or local.cartLines[local.i].getPlan().hasBeenSelected()>
				<cfset local.return = true>
				<cfbreak>
			</cfif>
		</cfloop>

		<cfreturn local.return>
	</cffunction>

	<cffunction name="resetActivationType" access="public" output="false" returntype="void">
		<cfset session.dbuildercart.setActivationType("")>
		<cfset session.dbuildercart.setUpgradeType("")>
		<cfset session.dbuildercart.setPrePaid(false)>
	</cffunction>

	<cffunction name="validateCartForCheckout" access="public" output="false" returntype="fw.model.shopping.dBuilderCartlineValidationResponse">
		<cfset var local = structNew()>
		<cfset local.cartValidationResponse = createObject("Component","fw.model.shopping.dBuilderCartlineVaidationResponse").init()>

		<cfset local.cart = session.dbuildercart>
		<cfset local.cartLines = local.cart.getLines()>

		<!--- error if the cart appears to be empty --->
		<cfif isEmpty()>
			<cfset local.cartValidationResponse.addError( "Your cart appears to be empty.", 2 )>
		</cfif>

		<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.iLine">
			<cfset local.thisLine = local.cartLines[local.iLine]>
			<cfif not local.cart.getUpgradeType() eq "equipment-only" and not local.cart.getPrePaid() and local.cart.getAddALineType() neq "Family" && local.cart.getActivationType() neq 'nocontract'>
				<!--- verify that each line has a device/plan pairing --->
				<cfif not local.thisLine.getPhone().hasBeenSelected() or not local.thisLine.getPlan().hasBeenSelected()>
					<cfset local.cartValidationResponse.addError( "Line #local.iLine# does not contain a valid Device/Service Plan pairing." , 3 )>
				<!--- verify that each rateplan has a valid service selected for any required service groups --->
				<cfelseif not application.model.ServiceManager.verifyRequiredServiceSelections( local.thisLine.getPlan().getProductId(), local.thisLine.getPhone().getProductId(), getLineSelectedFeatures(local.iLine), false, ArrayNew(1), application.model.cart.getCartTypeId( session.dbuildercart.getActivationType() ) )>
					<cfset local.cartValidationResponse.addError( "Line #local.iLine# is missing required Service selections.", 1 )>
				</cfif>		
			<!--- verify that equipment-only upgrades have all required service selections --->
			<cfelseif local.cart.getActivationType() CONTAINS "upgrade" and local.cart.getUpgradeType() eq "equipment-only">
				<cfif len(trim(local.thisLine.getPlan().getProductId())) and local.thisLine.getPlan().getProductId() gt 0 and len(trim(local.thisLine.getPhone().getProductId())) and local.thisLine.getPhone().getProductId() gt 0>
					<cfif not application.model.ServiceManager.verifyRequiredServiceSelections(local.thisLine.getPlan().getProductId(),local.thisLine.getPhone().getProductId(),getLineSelectedFeatures(local.iLine))>
						<cfset local.cartValidationResponse.addError( "The handset you've selected has additional required services that you have not selected.", 5 )>
					</cfif>
				</cfif>
			<!--- verify that Add-a-Line activations have all required service selections --->
			<cfelseif local.cart.getActivationType() CONTAINS "addaline">
				<cfif len(trim(local.thisLine.getPlan().getProductId())) and local.thisLine.getPlan().getProductId() gt 0 and len(trim(local.thisLine.getPhone().getProductId())) and local.thisLine.getPhone().getProductId() gt 0>
					<cfif not application.model.ServiceManager.verifyRequiredServiceSelections(local.thisLine.getPlan().getProductId(),local.thisLine.getPhone().getProductId(),getLineSelectedFeatures(local.iLine))>
						<cfset local.cartValidationResponse.addError( "The handset you've selected has additional required services that you have not selected.", 5 )>
					</cfif>
				</cfif>		
			</cfif>
		</cfloop>

		<!--- error if the cart contains a family plan but appears to have fewer than 2 lines on non-shared plans --->
		<cfif local.cart.getFamilyPlan().hasBeenSelected() && !local.cart.getFamilyPlan().getIsShared() && arrayLen(local.cartLines) lt 2>
			<cfset local.cartValidationResponse.addError( "Family Plans require a minimum of 2 lines.", 7 )>
		</cfif>

		<!--- error if the cart contains a family plan but devices is over the max lines --->
		<cfif local.cart.getFamilyPlan().hasBeenSelected() and arrayLen(local.cartLines) GT application.model.Plan.getFamilyPlanMaxLines(local.cart.getFamilyPlan().getProductId())>
			<cfset local.cartValidationResponse.addError( "The family Plan you have chosen has a max of #application.model.Plan.getFamilyPlanMaxLines(local.cart.getFamilyPlan().getProductId())# lines.", 8 )>
		</cfif>

		<!--- error on Verizon PLAID plans that has a max of 1 Smart phone --->
		<cfif local.cart.getCarrierId() eq 42 && local.cart.getFamilyPlan().hasBeenSelected() && local.cart.getFamilyPlan().getProductId() eq 5301>
			<cfset local.SmartPhoneCount = 0 />
		
			<cfloop array="#local.cartLines#" index="local.CartLine">
				<cfif local.CartLine.getPhone().hasBeenSelected() && local.CartLine.getPhone().getDeviceServiceType() eq 'SmartPhone'>
					<cfset local.SmartPhoneCount++ />
				</cfif>
			</cfloop>
		
			<cfif local.SmartPhoneCount GT 1>
				<cfset local.cartValidationResponse.addError( "The Rate Plan you have chosen has a max of 1 Smartphone per plan.", 9 ) />
			</cfif>
		</cfif>

		<!--- Validate that a Warranty as selected or "No Thanks" for every phone --->
		<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.iLine">
			<cfset local.thisLine = local.cartLines[local.iLine]>
			<cfif not local.thisLine.getWarranty().hasBeenSelected() 
				&& not local.thisLine.getDeclineWarranty() 
				&& local.thisLine.getPhone().getDeviceServiceType() neq 'MobileBroadband' 
				&& not (session.dbuildercart.getPrePaid() && not application.wirebox.getInstance("ChannelConfig").getOfferPrepaidDeviceWarrantyPlan())	>
				<cfset local.cartValidationResponse.addError( "You must either select a warranty or select 'No Thanks' on line #local.iline#", 11 )>
			</cfif>
		</cfloop>

		<!--- Validate that Warranty is only added to Phone devices --->
		<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.iLine">
			<cfset local.thisLine = local.cartLines[local.iLine]>
			<cfif local.thisLine.getWarranty().hasBeenSelected() 
				&& local.thisLine.getPhone().hasBeenSelected() 
				&& local.thisLine.getPhone().getDeviceServiceType() eq 'MobileBroadband'>	
				<cfset local.cartValidationResponse.addError( "Warranty is valid only for phone devices. Please remove warranty plan or change the device that corresponds to it.", 11 )>
			</cfif>
		</cfloop>

		<!--- Validate accessories are in cart or no thanks except for prepaid phones --->
		<cfif not session.dbuildercart.getPrepaid() >
			<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.iLine">
				<cfset local.thisLine = local.cartLines[local.iLine]>
				<cfif (not arrayLen(local.thisLine.getAccessories()) and not local.thisLine.getDeclineAccessories())>
					<cfset local.cartValidationResponse.addError( "You must either select an accessory or select 'No Thanks' on line #local.iline#", 12 )>
				</cfif>
			</cfloop>
		</cfif>
		<!--- VFD access check MES --->
		<!--- For VFD softreservation is done at end of cart sequence --->
		<cfif IsDefined("Session.VFD.access") and Session.VFD.access>
			<cfset softReservationSuccess = application.model.CheckoutHelper.softReserveCartHardGoods() />
			<cfset request.p.bSoftReservationSuccess = variables.softReservationSuccess />

			<cfif not variables.softReservationSuccess>
			<!--- TODO: prevent the user from proceeding with the order at this point if the hard goods could not all be reserved --->
				<cfset local.cartValidationResponse.addError( "This item is currently out of stock.", 13 )>
			</cfif>
			
		</cfif>
		
		<cfreturn local.cartValidationResponse />
	</cffunction>


	<!--- Returns a list of Product IDs --->
	<cffunction name="getLineSelectedFeatures" access="public" output="false" returntype="string">
		<cfargument name="line" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfset local.return = "">
		<cfset local.cartLines = session.dbuildercart.getLines()>
		<cfif arrayLen(local.cartLines) gte arguments.line>
			<cfset local.thisLine = local.cartLines[arguments.line]>
			<cfset local.thisLineFeatures = local.thisLine.getFeatures()>
			<cfloop from="1" to="#arrayLen(local.thisLineFeatures)#" index="local.i">
				<cfset local.return = listAppend(local.return,local.thisLineFeatures[local.i].getProductId())>
			</cfloop>
		</cfif>
		<cfreturn local.return>
	</cffunction>


	<cffunction name="isLineMissingRequiredFeatures" access="public" output="false" returntype="boolean" >
		<cfargument name="requiredServices" type="query" required="true" />
		<cfargument name="selectedServices" type="array" required="true"/>

		<cfset var local = {} />
		<cfset local.isMissingRequiredService = true />
		<cfset local.selectedServiceList = '' />

		<cfif requiredServices.RecordCount eq 0>
			<cfset local.isMissingRequiredService = false />
		<cfelse>
			<!--- Create list of selected Feature IDs --->
			<cfloop from="1" to="#arrayLen( arguments.selectedServices )#" index="local.iFeatures">
				<cfset local.serviceProductId = arguments.selectedServices[local.iFeatures].getProductID() />
				<cfset local.selectedServiceList = ListAppend( local.selectedServiceList, local.serviceProductId ) />
			</cfloop>

			<cfoutput query="arguments.requiredServices" group="groupLabel">
				<cfset local.isMissingRequiredService = true />

				<cfoutput>
					<cfif ListFind( local.selectedServiceList, ProductId )>
						<cfset local.isMissingRequiredService = false />
					</cfif>
				</cfoutput>

				<cfif local.isMissingRequiredService>
					<cfreturn local.isMissingRequiredService  />
				</cfif>
			</cfoutput>
		</cfif>

		<cfreturn local.isMissingRequiredService  />
	</cffunction>

	<cffunction name="declineFeatures" access="public" output="false" returntype="void">
		<cfargument name="line" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfset local.cartLines = session.dbuildercart.getLines()>
		<cfif arrayLen(local.cartLines) gte arguments.line>
			<cfset local.line = local.cartLines[arguments.line]>
			<cfset local.line.setDeclineFeatures(true)>
		</cfif>
	</cffunction>

	<cffunction name="declineAccessories" access="public" output="false" returntype="void">
		<cfargument name="line" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfset local.cartLines = session.dbuildercart.getLines()>
		<cfif arrayLen(local.cartLines) gte arguments.line>
			<cfset local.line = local.cartLines[arguments.line]>
			<cfset local.line.setDeclineAccessories(true)>
		</cfif>
	</cffunction>

	<cffunction name="declineWarranty" access="public" output="false" returntype="void">
		<cfargument name="line" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfset local.cartLines = session.dbuildercart.getLines()>
		<cfif arrayLen(local.cartLines) gte arguments.line>
			<cfset local.line = local.cartLines[arguments.line]>
			<cfset local.line.setDeclineWarranty(true)>
		</cfif>
	</cffunction>

	<cffunction name="parseAddItemArguments" access="public" output="false" returntype="void">
		<cfparam name="request.p.featureIDs" default="">
		<cfparam name="request.p.price" default="0">
		<cfparam name="request.p.phoneType" default="">

		<cfscript>
			// parse potential tokens in the productType
			if (request.p.productType contains ":")
			{
				request.p.productType_orig = request.p.productType;
				request.p.productType = listFirst(request.p.productType_orig,":");
				if (listFindNoCase("phone,dataCardAndNetbook,prepaid",request.p.productType))
					request.p.activationType = listGetAt(request.p.productType_orig,2,":");
			}

			// parse selected feature ids from the product_id if they appear to be there
			request.p.changingPlanFeatures = false;
			if (request.p.productType eq "plan" and request.p.product_id contains ":" and listLen(request.p.product_id,":") gte 2)
			{
				request.p.changingPlanFeatures = true;
				request.p.featureIDs = listChangeDelims(listGetAt(request.p.product_id,2,":"),",",",");
				request.p.product_id = listFirst(request.p.product_id,":");
			}
			else if (request.p.productType eq "plan" and request.p.product_id contains ":")
			{
				request.p.product_id = listFirst(request.p.product_id,":");
			}

			// determine the pricing for devices
			if (listFindNoCase("phone,dataCardAndNetbook,prepaid",request.p.productType) and request.p.product_id contains ":")
			{
				request.p.phoneType = request.p.activationType;
				request.p.product_id = listFirst(request.p.product_id,":");
				request.p.price = application.model[request.p.productType].getPriceByPhoneIdAndMode(phoneID=request.p.product_id,mode=request.p.phoneType);
			}
		</cfscript>
	</cffunction>


	<cffunction name="addCartLineDevice" access="public" output="false" returntype="void">
		<cfargument name="line" type="numeric" required="false" default="#request.p.cartLineNumber#">
		<cfargument name="productId" type="numeric" required="false" default="#request.p.product_id#">
		<cfargument name="productType" type="numeric" required="false" default="#request.p.productType#">
		<cfargument name="activationType" type="numeric" required="false" default="#request.p.activationType#">
		<cfargument name="price" type="numeric" required="false" default="#request.p.price#">

		<cfscript>
			var local = structNew();
			local.cart = session.dbuildercart;
			local.cartLines = local.cart.getLines();

			local.cartLines[arguments.line].getPhone().setProductID(arguments.productId);
			local.cartLines[arguments.line].getPhone().setType("device");
			local.cartLines[arguments.line].getPhone().getPrices().setDueToday(arguments.price);
			local.cartLines[arguments.line].getPhone().getPrices().setCOGS(application.model.Product.getCOGS(arguments.productId));
			local.cartLines[arguments.line].getPhone().getPrices().setRetailPrice(application.model[arguments.productType].getPriceByProductIDAndMode(ProductId=arguments.productId,mode="retail"));
			session.dbuildercart.setCarrierId(application.model[arguments.productType].getCarrierIdByProductId(arguments.productId));
			
			// clear any other free accessories on this line
			application.model.CartHelper.clearLineFreeAccessories(lineNumber=arguments.line);
			
			// if there are any free accessories included with this device
			local.freeAccessories = application.model.CartHelper.clearLineFreeAccessories(lineNumber=arguments.line);
			if (local.freeAccessories.recordCount)
			{
				local.thisLineAccessories = local.cartLines[arguments.line].getAccessories();
				for (local.i=1;local.i lte local.freeAccessories.recordCount;local.i=local.i+1)
				{
					local.thisFreeAccessory = createObject("Component","fw.model.shopping.dBuilderCartlineItem").init();
					local.thisFreeAccessory.setProductId(local.freeAccessories.productId[local.i]);
					local.thisFreeAccessory.setType("bundled");
					local.thisFreeAccessory.getPrices().setDueToday(0);
					local.thisFreeAccessory.getPrices().setCOGS(application.model.Product.getCOGS(local.freeAccessories.productId[local.i]));
					local.thisFreeAccessory.getPrices().setRetailPrice(local.freeAccessories.price_retail[local.i]);
					arrayAppend(local.thisLineAccessories,local.thisFreeAccessory);
				}
				local.cartLines[arguments.line].setAccessories(local.thisLineAccessories);
			}
			session.dbuildercart.setLines(local.cartLines);
			session.dbuildercart.setCurrentLine(arguments.line);
			session.dbuildercart.setActivationType(arguments.activationType);
			// if we just added a prepaid
			if (arguments.productType eq "prepaid")
			{
				session.dbuildercart.setPrepaid(true);
			}
//			session.phoneFilterSelections.planType = arguments.activationType;
			session.phoneFilterSelections.filterOptions = 0;
			session.phoneFilterSelections.filterOptions = listAppend(session.phoneFilterSelections.filterOptions,application.model.FilterHelper.getFilterOptionId('phone','planType',arguments.activationType));
//			session.phoneFilterSelections.carrierID = local_phone.carrierID;
			session.phoneFilterSelections.filterOptions = listAppend(session.phoneFilterSelections.filterOptions,application.model.FilterHelper.getFilterOptionId('phone','carrierID',local_phone.carrierID));
//			session.dataCardAndNetbookFilterSelections.planType = arguments.activationType;
			
			session.tabletFilterSelections.filterOptions = 0;
			session.tabletFilterSelections.filterOptions = listAppend(session.tabletFilterSelections.filterOptions,application.model.FilterHelper.getFilterOptionId('tablet','planType',arguments.activationType));
			session.tabletFilterSelections.filterOptions = listAppend(session.tabletFilterSelections.filterOptions,application.model.FilterHelper.getFilterOptionId('tablet','carrierID',local_phone.carrierID));
			
			session.dataCardAndNetbookFilterSelections.filterOptions = 0;
			session.dataCardAndNetbookFilterSelections.filterOptions = listAppend(session.dataCardAndNetbookFilterSelections.filterOptions,application.model.FilterHelper.getFilterOptionId('dataCardAndNetbook','planType',arguments.activationType));
//			session.dataCardAndNetbookFilterSelections.carrierID = local_phone.carrierID;
			session.dataCardAndNetbookFilterSelections.filterOptions = listAppend(session.dataCardAndNetbookFilterSelections.filterOptions,application.model.FilterHelper.getFilterOptionId('dataCardAndNetbook','carrierID',local_phone.carrierID));
//			session.prePaidFilterSelections.planType = arguments.activationType;
			session.prePaidFilterSelections.filterOptions = 0;
			session.prePaidFilterSelections.filterOptions = listAppend(session.prePaidFilterSelections.filterOptions,application.model.FilterHelper.getFilterOptionId('prepaid','planType',arguments.activationType));
//			session.prePaidFilterSelections.carrierID = local_phone.carrierID;
			session.prePaidFilterSelections.filterOptions = listAppend(session.prePaidFilterSelections.filterOptions,application.model.FilterHelper.getFilterOptionId('prepaid','carrierID',local_phone.carrierID));
//			session.planFilterSelections.carrierID = local_phone.carrierID;
			session.planFilterSelections.filterOptions = 0;
			session.planFilterSelections.filterOptions = listAppend(session.planFilterSelections.filterOptions,application.model.FilterHelper.getFilterOptionId('plan','carrierID',local_phone.carrierID));
//			session.planFilterSelections.planType = "individual,family";


			if (arguments.productType eq "dataCardAndNetbook" or arguments.productType eq "tablet") {
				session.planFilterSelections.filterOptions = listAppend(session.planFilterSelections.filterOptions,application.model.FilterHelper.getFilterOptionId('plan','planType','data'));
			}
			else {
				session.planFilterSelections.filterOptions = listAppend(session.planFilterSelections.filterOptions,"#application.model.FilterHelper.getFilterOptionId('plan','planType','individual')#,#application.model.FilterHelper.getFilterOptionId('plan','planType','family')#");
			}

			/* above replaces assbackwards logic */
			/*if (arguments.productType neq "dataCardAndNetbook")
			{
//				session.planFilterSelections.planType = "individual,family";
				session.planFilterSelections.filterOptions = listAppend(session.planFilterSelections.filterOptions,"#application.model.FilterHelper.getFilterOptionId('plan','planType','individual')#,#application.model.FilterHelper.getFilterOptionId('plan','planType','family')#");
			}
			else if (arguments.productType eq "dataCardAndNetbook")
			{
//				session.planFilterSelections.planType = "data";
				session.planFilterSelections.filterOptions = listAppend(session.planFilterSelections.filterOptions,application.model.FilterHelper.getFilterOptionId('plan','planType','data'));
			}*/

			 
			request.hasWirelessItemBeenAdded = true;
			request.p.productType = "";
		</cfscript>
	</cffunction>

	<cffunction name="addCartLinePlan" access="public" output="false" returntype="void">
		<cfargument name="line" type="numeric" required="false" default="#request.p.cartLineNumber#">
		<cfargument name="productId" type="numeric" required="false" default="#request.p.product_id#">
		<cfargument name="featureIds" type="string" required="false" default="#request.p.featureIDs#">

		<cfscript>
			var local = structNew();
			local.cart = session.dbuildercart;
			local.cartLines = local.cart.getLines();
			local.thisPlan = application.model.Plan.getByFilter(idList=arguments.productId)>

			// add this plan to the indicated line
			local.cartLines[arguments.line].getPlan().setProductID(arguments.productId);
			local.cartLines[arguments.line].getPlan().setType("rateplan");
			local.cartLines[arguments.line].setPlanType(application.model.Plan.getPlanTypeByProductID(arguments.productId));
			session.dbuildercart.setCarrierId(application.model.Product.getCarrierIdByProductId(arguments.productId));
//			session.planFilterSelections.planType = local.thisPlan.planType;
			session.planFilterSelections.filterOptions = 0;
			session.planFilterSelections.filterOptions = listAppend(session.planFilterSelections.filterOptions,application.model.FilterHelper.getFilterOptionId('plan','planType',local.thisPlan.planType));
//			session.planFilterSelections.carrierID = local.thisPlan.carrierID;
			session.planFilterSelections.filterOptions = listAppend(session.planFilterSelections.filterOptions,application.model.FilterHelper.getFilterOptionId('plan','carrierID',local.thisPlan.carrierID));
//			session.phoneFilterSelections.carrierID = local.thisPlan.carrierID;
			session.phoneFilterSelections.filterOptions = 0;
			session.phoneFilterSelections.filterOptions = listAppend(session.phoneFilterSelections.filterOptions,application.model.FilterHelper.getFilterOptionId('phone','carrierID',local.thisPlan.carrierID));
//			session.dataCardAndNetbookFilterSelections.carrierID = local.thisPlan.carrierID;
			session.tabletFilterSelections.filterOptions = 0;
			session.tabletFilterSelections.filterOptions = listAppend(session.tabletFilterSelections.filterOptions,application.model.FilterHelper.getFilterOptionId('tablet','planType',local.thisPlan.planType));
			session.tabletFilterSelections.filterOptions = listAppend(session.tabletFilterSelections.filterOptions,application.model.FilterHelper.getFilterOptionId('tablet','carrierID',local.thisPlan.carrierID));
			session.dataCardAndNetbookFilterSelections.filterOptions = 0;
			session.dataCardAndNetbookFilterSelections.filterOptions = listAppend(session.dataCardAndNetbookFilterSelections.filterOptions,application.model.FilterHelper.getFilterOptionId('dataCardAndNetbook','carrierID',local.thisPlan.carrierID));
//			session.prePaidFilterSelections.carrierID = local.thisPlan.carrierID;
			session.prePaidFilterSelections.filterOptions = 0;
			session.prePaidFilterSelections.filterOptions = listAppend(session.prePaidFilterSelections.filterOptions,application.model.FilterHelper.getFilterOptionId('prepaid','carrierID',local.thisPlan.carrierID));
			// if we have feature ids and a device selected on this line
			if (len(trim(arguments.featureIds)) and local.cartLines[arguments.line].getPhone().hasBeenSelected())
			{
				local.arrFeatures = arrayNew(1);
				for (local.i=1;local.i lte listLen(arguments.featureIds);local.i=local.i+1)
				{
					local.iFeature = listGetAt(arguments.featureIds,local.i);
					if (isNumeric(local.iFeature))
					{
						arrayAppend(local.arrFeatures,createObject("Component","fw.model.shopping.dBuilderCartlineItem").init());
						local.arrFeatures[arrayLen(local.arrFeatures)].setProductID(local.iFeature);
						local.arrFeatures[arrayLen(local.arrFeatures)].setType("service");
					}
				}
				local.cartLines[arguments.line].setFeatures(local.arrFeatures);
			}

			// if the plan appears to be a family plan
			if (local.thisPlan.planType eq "family")
			{
				// apply this plan selection to the entire cart, including any existing lines
				application.model.CartHelper.setFamilyPlan(arguments.productId);
			}

			session.dbuildercart.setCurrentLine(arguments.line);
			 

			request.hasWirelessItemBeenAdded = true;
			request.p.productType = "";
		</cfscript>
	</cffunction>

	<cffunction name="addCartLineAccessory" access="public" output="false" returntype="void">
		<cfargument name="line" type="numeric" required="false" default="#request.p.cartLineNumber#">
		<cfargument name="productId" type="numeric" required="false" default="#request.p.product_id#">
		<cfargument name="qty" type="numeric" required="false" default="#request.p.qty#">

		<cfscript>
			var local = structNew();
			local.cart = session.dbuildercart;
			local.cartLines = local.cart.getLines();
			local.thisAccessory = application.model.Accessory.getByFilter(idList=arguments.productId);

			local.newAccessory = createObject("Component","fw.model.shopping.dBuilderCartlineItem").init();
			local.newAccessory.setProductID(arguments.productId);
			local.newAccessory.getPrices().setDueToday(local.thisAccessory.price);
			local.newAccessory.getPrices().setCOGS(application.model.Product.getCOGS(local.newAccessory.getProductId()));
			local.newAccessory.getPrices().setRetailPrice(local.thisAccessory.price_retail);
			local.newAccessory.setType("accessory");
			local.addedAccessoryToWorkflow = false;
			// if the user appears to be adding to 'other items'
			if (not arguments.line or arguments.line eq request.config.otherItemsLineNumber)
			{
				for (local.i=1;local.i lte arguments.qty;local.i=local.i+1)
				{
					// add this accessory to the general cart
					arrayAppend(session.dbuildercart.getOtherItems(),local.newAccessory);
				}
				session.dbuildercart.setCurrentLine(arguments.line);
			}
			else
			{
				for (local.i=1;local.i lte arguments.qty;local.i=local.i+1)
				{
					// add this accessory to the specific line in the cart
					arrayAppend(cartLines[arguments.line].getAccessories(),local.newAccessory);
				}
				local.addedAccessoryToWorkflow = true;
				session.dbuildercart.setCurrentLine(arguments.line);
			}
			 

			request.hasWirelessItemBeenAdded = local.addedAccessoryToWorkflow;
			request.p.productType = "";
		</cfscript>
	</cffunction>

	<cffunction name="getLineToolTip" access="public" output="false" returntype="struct">
		<cfargument name="line" type="numeric" required="true" />
		<cfset var local = {} />

		<cfscript>
			local.toolTip = {
				tipAvailable = "false",
				priority = "0",
				lineLabel = "",
				actionLabel = "",
				actionURL = "",
				nextAction = "",
				deviceStatus = "empty",
				planStatus = "empty",
				serviceStatus = "empty",
				accessoryStatus = "empty",
				warrantyStatus = "empty",
				percent = 0
			};

			// line tooltip
			if (arrayLen(session.dbuildercart.getLines()) gte arguments.line)
			{
				local.cartLines = session.dbuildercart.getLines();
				local.cartLine = local.cartLines[arguments.line];
				local.lineAlias = "Line #arguments.line#";
				if (len(trim(local.cartLine.getAlias())))
					local.lineAlias = local.cartLine.getAlias();
				local.toolTip.lineLabel = local.lineAlias;



				//regluar, eq-only+plan
				if ( (session.dbuildercart.getUpgradeType() neq "equipment-only" and not session.dbuildercart.getPrePaid() ) or (session.dbuildercart.getUpgradeType() eq "equipment+plan"))
				{
					//set status
					if(local.cartLine.getPhone().hasBeenSelected())
					{
						local.toolTip.deviceStatus = "done";
						local.toolTip.percent  = local.toolTip.percent + 25;
					}
					if(local.cartLine.getPlan().hasBeenSelected())
					{
						local.toolTip.planStatus = "done";
						local.toolTip.percent  = local.toolTip.percent + 25;
					}
					if (arrayLen(local.cartLine.getFeatures()) or local.cartLine.getDeclineFeatures())
					{
						local.toolTip.serviceStatus = "done";
						local.toolTip.percent = local.toolTip.percent + 25;
					}
					if (arrayLen(lineGetAccessoriesByType(arguments.line,"accessory")) or local.cartLine.getDeclineAccessories())
					{
						local.toolTip.accessoryStatus = "done";
						local.toolTip.percent = local.toolTip.percent + 25;
					}
					if (local.cartLine.getWarranty().hasBeenSelected() or local.cartLine.getDeclineWarranty())
					{
						local.toolTip.warrantyStatus = "done";
						//local.toolTip.percent = local.toolTip.percent + 25;
					}

					if(session.dbuildercart.getAddALineType() eq "Family")
					{
						local.toolTip.percent = local.toolTip.percent + 25;
					}

					// if there's no device selected
					if (not local.cartLine.getPhone().hasBeenSelected())
					{
						local.toolTip.actionLabel = "Select a Device for this line.";
						local.toolTip.actionURL = application.view.Cart.getLink(arguments.line,"browsePhones");
						local.toolTip.priority = 1;
						local.toolTip.tipAvailable = true;
						local.toolTip.nextAction = "device";
					}
					// if there's no plan selected
					else if (not local.cartLine.getPlan().hasBeenSelected()  and  session.dbuildercart.getAddALineType() neq "Family" )
					{
						local.toolTip.actionLabel = "Select a Service Plan for this line.";
						local.toolTip.actionURL = application.view.Cart.getLink(arguments.line,"browsePlans");
						local.toolTip.priority = 2;
						local.toolTip.tipAvailable = true;
						local.toolTip.nextAction = "plan";
					}
					// if there are no services selected and the user hasn't declined features/services
					else if (not arrayLen(local.cartLine.getFeatures()) and not local.cartLine.getDeclineFeatures())
					{
						local.toolTip.actionLabel = "Select a Services for this line.";
						local.toolTip.actionURL = application.view.Cart.getLink(arguments.line,"planSelectServices");
						local.toolTip.priority = 3;
						local.toolTip.tipAvailable = true;
						local.toolTip.nextAction = "service";
					}
					// if there is no warranty selected
					else if (!local.cartLine.getWarranty().hasBeenSelected() && !local.cartLine.getDeclineWarranty())
					{
						local.toolTip.actionLabel = "Select a Warranty for this line.";
						local.toolTip.actionURL = application.view.Cart.getLink(arguments.line, "browseWarranties");
						local.toolTip.priority = 4;
						local.toolTip.tipAvailable = true;
						local.toolTip.nextAction = "warranty";
					}
					// if there are no non-bundled accessories selected and the user hasn't declined accessories
					else if (not arrayLen(lineGetAccessoriesByType(arguments.line,"accessory")) and not local.cartLine.getDeclineAccessories())
					{
						local.toolTip.actionLabel = "Select Accessories for this line.";
						local.toolTip.actionURL = application.view.Cart.getLink(arguments.line,"browseAccessories");
						local.toolTip.priority = 5;
						local.toolTip.tipAvailable = true;
						local.toolTip.nextAction = "accessory";
					}
				}

				// if we're handling an equipment-only (no features) upgrade or a prepaid
				else
				{
					if (local.cartLine.getPhone().hasBeenSelected())
					{
						local.toolTip.percent = local.toolTip.percent + 50;
						local.toolTip.deviceStatus = "done";

						//mark services selected for eq only upgrades
						local.toolTip.serviceStatus = "done";
						local.toolTip.actionLabel = "Select a Warranty for this line.";
						local.toolTip.actionURL = application.view.Cart.getLink(arguments.line,"browseWarranties");
						local.toolTip.priority = 4;
						local.toolTip.tipAvailable = true;
						local.toolTip.nextAction = "warranty";

					}

					if (arrayLen(lineGetAccessoriesByType(arguments.line,"accessory")) or local.cartLine.getDeclineAccessories())
					{
						local.toolTip.accessoryStatus = "done";
						local.toolTip.percent = local.toolTip.percent + 50;
					}

					// if there's no device selected
					if (not local.cartLine.getPhone().hasBeenSelected())
					{
						local.toolTip.actionLabel = "Select a Device for this line.";
						local.toolTip.actionURL = application.view.Cart.getLink(arguments.line,"browsePhones");
						local.toolTip.priority = 1;
						local.toolTip.tipAvailable = true;
						local.toolTip.nextAction = "device";
					}
					// if there are no accessories selected and the user hasn't declined accessories
					else if (not local.cartLine.getWarranty().hasBeenSelected() and not local.cartLine.getDeclineWarranty())
					{
						local.toolTip.actionLabel = "Select a Warranty for this line.";
						local.toolTip.actionURL = application.view.Cart.getLink(arguments.line,"browseWarranties");
						local.toolTip.priority = 4;
						local.toolTip.tipAvailable = true;
						local.toolTip.nextAction = "warranty";
					}
					// if there are no accessories selected and the user hasn't declined accessories
					else if (not arrayLen(local.cartLine.getAccessories()) and not local.cartLine.getDeclineAccessories())
					{
						local.toolTip.actionLabel = "Select a Accessories for this line.";
						local.toolTip.actionURL = application.view.Cart.getLink(arguments.line,"browseAccessories");
						local.toolTip.priority = 5;
						local.toolTip.tipAvailable = true;
						local.toolTip.nextAction = "accessory";
					}
				}
			// "additional items" tooltip
			}
			else if (arguments.line eq request.config.otherItemsLineNumber)
			{
				local.toolTip.lineLabel = "Additional Items";
				local.toolTip.actionLabel = "Add Accessories to Additional Items.";
				local.toolTip.actionURL = application.view.Cart.getLink(arguments.line,"browseAccessories");
				local.toolTip.priority = 5;
				local.toolTip.tipAvailable = true;
			}
		</cfscript>

		<cfreturn local.toolTip>
	</cffunction>


	<cffunction name="updateFamilyPlanDevicePrices" access="public" output="false" returntype="void">
		<cfargument name="cart" type="fw.model.shopping.dBuilderCartline" required="true" />



		<cfscript>
			var cartLines = arguments.cart.getLines();
			var i = 0;
			var productId = 0;
			var mode = "new";

			for (i=1; i <= ArrayLen(cartLines); i++)
			{
				productId = cartLines[i].getPhone().getProductId();
				mode = "new";

				//Set the activation type mode to addaline if conditions are met
				if ( arguments.cart.getHasFamilyPlan() )
				{
					if ( ListFind( '42,109,299', arguments.cart.getCarrierId() ) )
					{
						if (i GTE 2)
						{
							mode = "addaline";
						}
					}
					else if ( arguments.cart.getCarrierId() EQ 128)
					{
						if (i GTE 3)
						{
							mode = "addaline";
						}
					}
				}
				if (cartLines[i].getPhone().getDeviceServiceType() EQ 'Tablet') {
					cartLines[i].getPhone().getPrices().setDueToday( application.model.Tablet.getPriceByProductIDAndMode( productId, mode ) );
				} else {
					cartLines[i].getPhone().getPrices().setDueToday( application.model.Phone.getPriceByProductIDAndMode( productId, mode ) );
				}
			}
		</cfscript>

	</cffunction>

	<cffunction name="addDefaultPlanAndServices" access="public" output="false" returntype="void">
		<cfargument name="cartLine" type="fw.model.shopping.dBuilderCartlineLine" required="true" />
		<cfargument name="deviceProductId" type="string" required="true" />

		<cfscript>
			var qPlan = application.model.Plan.getDefaultPlan( arguments.deviceProductId );
			var deviceGuid = '';
			var qDefaultServices = '';
			var featureItems = [];
			var i = 0;

			if ( qPlan.RecordCount )
			{
				arguments.cartLine.getPlan().setProductID( qPlan.RateplanProductId );
				arguments.cartLine.getPlan().setType('rateplan');
				arguments.cartLine.setPlanType(application.model.plan.getPlanTypeByProductID( qPlan.RateplanProductId ));

				deviceGuid = application.model.Product.getProductGuidByProductId( arguments.deviceProductId );
				qDefaultServices = application.model.ServiceManager.getDefaultServices( qPlan.RateplanGuid, deviceGuid );

				if ( qDefaultServices.RecordCount )
				{
					for (i=1; i <= qDefaultServices.RecordCount; i++)
					{
						featureItem = createObject("Component","fw.model.shopping.dBuilderCartlineItem").init();
						featureItem.setProductID( qDefaultServices['ProductId'][i] );
						featureItem.setType( 'service' );
						arrayAppend( featureItems, featureItem );
					}

					arguments.cartLine.setFeatures( featureItems );
				}
			}
		</cfscript>

	</cffunction>


	<cffunction name="removeEmptyCartLines" output="false" access="public" returntype="void">

		<cfscript>
			var cartLines = session.dbuildercart.getLines();
			var cartLine = 0;
			var i = 0;

			for ( i = ArrayLen(cartLines); i >= 1; i-- )
			{
				cartLine = cartLines[i];
				if (
						cartLine.getPhone().getProductId() eq 0
						&& ArrayLen( cartLine.getAccessories() ) eq 0
						&& ( //No plans are required for equipment only upgrades and family add-a-line
							cartLine.getPlan().getProductId() eq 0
 							&& ( (session.dbuildercart.getActivationType() DOES NOT CONTAIN 'upgrade' and session.dbuildercart.getUpgradeType() neq 'equipment-only')
								or (session.dbuildercart.getActivationType() DOES NOT CONTAIN 'addaline' and session.dbuildercart.getAddAlineType() neq 'family') )
						   )
				   )
				{
					ArrayDeleteAt(cartLines, i);
				}

			}

			session.dbuildercart.setLines( cartLines );
			session.dbuildercart.setCurrentLine(arrayLen(session.dbuildercart.getLines()));
		</cfscript>

	</cffunction>

	<!--- Cart is eligible for free shipping if it contains a contract phone or has $50 or more worth of accessories --->
	<cffunction name="isCartEligibleForPromoShipping" output="false" access="public" returntype="boolean">

		<cfscript>
			var isEligible = false;
			
			//Postpaid orders
			if ( application.model.CheckoutHelper.isWirelessOrder() )
			{
				isEligible = true;
			}

			if ( getAccessoryPriceTotals() gte 50 )
			{
				isEligible = true;
			}
		</cfscript>

		<cfreturn isEligible />
	</cffunction>


	<cffunction name="getAccessoryPriceTotals" output="false" access="public" returntype="numeric">

		<cfscript>
			var cartLines = session.dbuildercart.getLines();
			var lineAccessories = [];
			var otherItems = session.dbuildercart.getOtherItems();
			var totalPrice = 0;
			var i = 0;
			var j = 0;
			var itemPrice = 0;

			for ( i=1; i <= ArrayLen(cartLines); i++ )
			{
				lineAccessories = cartLines[i].getAccessories();
				
				for ( j=1; j <= ArrayLen(lineAccessories); j++ )
				{
					itemPrice = lineAccessories[j].getPrices().getDueToday();
					totalPrice = totalPrice + itemPrice;
				}
			}
			
			for ( i=1; i <= ArrayLen(otherItems); i++ )
			{
				if ( otherItems[i].getType() is 'accessory' )
				{
					itemPrice = otherItems[i].getPrices().getDueToday();
					totalPrice = totalPrice + itemPrice;
				}
			}			
		</cfscript>

		<cfreturn totalPrice />
	</cffunction>


	<cffunction name="getActivationTypeAcronym" returntype="string" output="false">
		
		<cfscript>
			var activationTypeAcronym = '';
			
			switch ( session.dbuildercart.getActivationType() )
			{
				case 'new':
					activationTypeAcronym = 'N';
					break;
				case 'upgrade':
					activationTypeAcronym = 'U';
					break;
				case 'addaline':
					activationTypeAcronym = 'A';
					break;
				case 'nocontract':
					activationTypeAcronym = 'R'; //Full Retail
					break;
				
				case 'financed-12-new':
					activationTypeAcronym = 'N';
					break;
				case 'financed-12-upgrade':
					activationTypeAcronym = 'U';
					break;
				case 'financed-12-addaline':
					activationTypeAcronym = 'A';
					break;				
				case 'financed-18-new':
					activationTypeAcronym = 'N';
					break;				
				case 'financed-18-upgrade':
					activationTypeAcronym = 'U';
					break;				
				case 'financed-18-addaline':
					activationTypeAcronym = 'A';
					break;				
				case 'financed-24-new':
					activationTypeAcronym = 'N';
					break;				
				case 'financed-24-upgrade':
					activationTypeAcronym = 'U';
					break;				
				case 'financed-24-addaline':
					activationTypeAcronym = 'A';
					break;	
			}
		</cfscript>
		
		<cfreturn activationTypeAcronym />
	</cffunction>
	

	<cffunction name="getAssetPaths" access="private" output="false" returntype="struct">    
    	<cfreturn variables.instance.assetPaths />    
    </cffunction>    
    <cffunction name="setAssetPaths" access="private" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance.assetPaths = arguments.theVar />    
    </cffunction>

</cfcomponent>
