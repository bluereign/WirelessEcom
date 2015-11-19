<cfcomponent output="false" displayname="Cart">

	<cffunction name="init" returntype="cfc.model.Cart">
		<cfargument name="orderID" type="numeric" required="false" default="0" />
		<cfargument name="zipCode" type="string" required="false" default="00000" /> <!--- Service Zip Code --->
		<cfargument name="lines" type="array" required="false" default="#arrayNew(1)#" />
		<cfargument name="currentLine" type="numeric" required="false" default="0" />
		<cfargument name="otherItems" type="array" required="false" default="#arrayNew(1)#" />
		<cfargument name="familyPlan" type="any" required="false" default="#createObject('component','cfc.model.cartItem').init()#" />
		<cfargument name="additionalCharges" type="struct" required="false" default="#structNew()#" />
		<cfargument name="prices" type="any" required="false" default="#createObject('component','cfc.model.cartPriceBlock').init()#" />
		<cfargument name="taxes" type="any" required="false" default="#createObject('component','cfc.model.cartPriceBlock').init()#" />
		<cfargument name="shipping" type="any" required="false" default="#createObject('component','cfc.model.cartPriceBlock').init()#" />
		<cfargument name="activationType" type="string" required="false" default="" /> <!--- new, upgrade, addaline --->
		<cfargument name="upgradeType" type="string" required="false" default="" /> <!--- 'equipment-only', 'equipment+plan'--->
        <cfargument name="addALineType" type="string" required="false" default="" /> <!--- 'ind', 'Family' --->
		<cfargument name="prepaid" type="boolean" required="false" default="false" />
		<cfargument name="carrierId" type="numeric" required="false" default="0" />
		<cfargument name="salesTaxTransactionId" type="string" required="false" default="" />
		<cfargument name="HasUnlimitedPlan" type="string" required="false" default="Unknown" /> <!--- Unknown, Yes, No --->
		<cfargument name="HasSharedPlan" type="string" required="false" default="Unknown" /> <!--- Unknown, Yes, No --->
		<cfargument name="Rebates" type="array" required="false" default="#ArrayNew(1)#" />
		<cfargument name="KioskEmployeeNumber" required="false" type="string" default="" />
		<cfargument name="SharedFeatures" required="false" type="array" default="#ArrayNew(1)#" />
		<cfargument name="instantRebateAmountTotal" required="false" type="numeric" default="0" />
		<cfargument name="promotionCodes" required="false" type="struct" default="#structNew()#" />

		<cfset variables.instance = structNew() />

		<cfset setOrderID(arguments.orderID) />
		<cfset setZipcode(arguments.zipCode) />
		<cfset setLines(arguments.lines) />
		<cfset setCurrentLine(arguments.currentLine) />
		<cfset setOtherItems(arguments.otherItems) />
		<cfset setFamilyPlan(arguments.familyPlan) />
		<cfset setAdditionalCharges(arguments.additionalCharges) />
		<cfset setPrices(arguments.prices) />
		<cfset setTaxes(arguments.taxes) />
		<cfset setShipping(arguments.shipping) />
		<cfset setActivationType(arguments.activationType) />
		<cfset setUpgradeType(arguments.upgradeType) />
        <cfset setAddALineType(arguments.addALineType) />
		<cfset setPrePaid(arguments.prePaid) />
		<cfset setCarrierId(arguments.carrierId) />
		<cfset setSalesTaxTransactionId(arguments.salesTaxTransactionId) />
		<cfset setHasUnlimitedPlan(arguments.hasUnlimitedPlan) />
		<cfset setHasSharedPlan(arguments.HasSharedPlan) />
		<cfset setRebates(arguments.rebates) />
		<cfset setKioskEmployeeNumber(arguments.kioskEmployeeNumber) />
		<cfset setSharedFeatures(arguments.SharedFeatures) />
		<cfset setInstantRebateAmountTotal(arguments.instantRebateAmountTotal) />
		<cfset setPromotionCodes(arguments.promotionCodes) />

		<cfreturn this />
	</cffunction>

	<cffunction name="updateAllPrices" access="public" output="false" returntype="void">

		<cfset var local = {} />
		
		<cfset application.model.dbuilderCartfacade.updateAllPrices(this) />

		<cfset local.cartPrices = createObject('component', 'cfc.model.cartPriceBlock').init() />
		<cfset local.carrierID = session.cart.getCarrierID() />
		<cfset local.planCounts = {}> 

		<cfset local.aLines = session.cart.getLines() />

		<cfloop from="1" to="#arrayLen(local.aLines)#" index="local.i">
			<cfset local.phone = local.aLines[local.i].getPhone()> 
			<cfset local.plan = local.aLines[local.i].getPlan()>
			
			<!--- Keys are productIDs (with underscore prepended) and value is number of occurrances. Used to determine plan pricing. --->
			<cfif !structKeyExists( local.planCounts, "_" & local.plan.getProductID() )>
				<cfset local.planCounts[ "_" & local.plan.getProductID() ] = 1>
			<cfelse>
				<cfset local.planCounts[ "_" & local.plan.getProductID() ]++>
			</cfif>
			
			<cfset local.linePrices = createObject('component', 'cfc.model.cartPriceBlock').init() />
			<cfset cartLineActivationType = local.aLines[local.i].getCartLineActivationType() />
			<cfif local.phone.hasBeenSelected() and cartLineActivationType contains 'legacy_financed'> 	<!--- renamed for full api testing --->			
				
				<cfset local.linePrices.setDueToday(0) />
				<cfset local.linePrices.setFirstBill(0) />
				<cfset local.linePrices.setMonthly(0) />
				<cfset local.linePrices.setMonthly(local.linePrices.getMonthly() + local.phone.getPrices().getMonthly()) />
				<cfset local.linePrices.setCOGS(0) />		
				<cfset local.linePrices.setRetailPrice(0) />
				<cfset local.linePrices.setDiscountTotal(0) />
				
			<cfelseif local.phone.hasBeenSelected() and cartLineActivationType contains 'financed'> 				
				
				<cfset local.linePrices.setDueToday(local.phone.getPrices().getDownPaymentAmount()) />
				<cfset local.linePrices.setFirstBill(local.linePrices.getFirstBill() + local.phone.getPrices().getFirstBill()) />
				<!---<cfset local.linePrices.setMonthly(local.linePrices.getMonthly() + local.phone.getPrices().getMonthly()) />--->
				<cfset local.linePrices.setMonthly(local.phone.getPrices().getMonthly()) />
				<cfset local.linePrices.setCOGS(local.linePrices.getCOGS() + local.phone.getPrices().getCOGS()) />
				<cfset local.linePrices.setRetailPrice(local.linePrices.getRetailPrice() + local.phone.getPrices().getRetailPrice()) />
				<cfset local.linePrices.setDiscountTotal(0) />
			
			<cfelseif local.phone.hasBeenSelected()>
			
				<cfset local.linePrices.setDueToday(local.linePrices.getDueToday() + local.phone.getPrices().getDueToday()) />
				<cfset local.linePrices.setFirstBill(local.linePrices.getFirstBill() + local.phone.getPrices().getFirstBill()) />
				<cfset local.linePrices.setMonthly(local.linePrices.getMonthly() + local.phone.getPrices().getMonthly()) />
				<cfset local.linePrices.setCOGS(local.linePrices.getCOGS() + local.phone.getPrices().getCOGS()) />
				<cfset local.linePrices.setRetailPrice(local.linePrices.getRetailPrice() + local.phone.getPrices().getRetailPrice()) />
				<cfset local.linePrices.setDiscountTotal(0) />
			</cfif>

			<cfif local.plan.hasBeenSelected()>
				
				<!--- Sprint Unlimited, My Way pricing offers a multiple-line discount. Store the running count per line for MRC calculations. --->
				<cfset local.aLines[local.i].setPlanIDCount( local.planCounts[ "_" & local.plan.getProductId() ] )>
				
				<cfset local.p = application.model.plan.getByFilter(idList = local.plan.getProductID()) />
				
				<cfset local.mrcArgs = {
						productId = local.plan.getProductID(), 
						lineNumber = local.i,
						carrierId = local.carrierID,
						deviceSKU = local.phone.getGERSSKU(),
						deviceServiceType = local.phone.getDeviceServiceType(),
						cartPlanIDCount = local.aLines[local.i].getPlanIDCount() 
					}>
					
				<cfset local.pPrice = application.model.plan.getMonthlyFee( argumentCollection = local.mrcArgs )/>
				<cfset local.plan.getPrices().setDueToday(0) />
				<cfset local.plan.getPrices().setFirstBill(local.pPrice) />

				<cfif local.carrierID eq 42>
					<cfset local.plan.getPrices().setFirstBill(0) />
				</cfif>

				<cfset local.plan.getPrices().setMonthly(local.pPrice) />
				<cfset local.linePrices.setDueToday(local.linePrices.getDueToday() + local.plan.getPrices().getDueToday()) />
				<cfset local.linePrices.setFirstBill(local.linePrices.getFirstBill() + local.plan.getPrices().getFirstBill()) />
				<cfset local.linePrices.setMonthly(local.linePrices.getMonthly() + local.plan.getPrices().getMonthly()) />
			</cfif>

			<cfif local.plan.hasBeenSelected()>
				<cfset local.aLines[local.i].getActivationFee().setProductId(1) />
				<cfset local.pPrice = application.model.plan.getActivationFeeByProductIdAndLineNumber(local.p.productId, local.i) />
				<cfset local.aLines[local.i].getActivationFee().getPrices().setDueToday(0) />
				<cfset local.aLines[local.i].getActivationFee().getPrices().setFirstBill(local.pPrice) />
				<cfset local.aLines[local.i].getActivationFee().getPrices().setMonthly(0) />
				<cfset local.linePrices.setDueToday(local.linePrices.getDueToday() + 0) />
				<cfset local.linePrices.setFirstBill(local.linePrices.getFirstBill() + local.pPrice) />
				<cfset local.linePrices.setMonthly(local.linePrices.getMonthly() + 0) />
			</cfif>

			<!--- Add shared features only to line 1 --->
			<cfif local.i eq 1>
				<cfset local.aSharedFeatures = session.cart.getSharedFeatures() />

				<cfif arrayLen(local.aSharedFeatures)>
					<cfloop from="1" to="#arrayLen(local.aSharedFeatures)#" index="local.ii">
						<cfset local.f = application.model.feature.getByProductId(local.aSharedFeatures[local.ii].getProductId()) />
						<cfset local.fPrice = local.f.price />
						<cfset local.aSharedFeatures[local.ii].getPrices().setDueToday(0) />
						<cfset local.aSharedFeatures[local.ii].getPrices().setFirstBill(local.fPrice) />

						<cfif local.carrierId eq 42>
							<cfset local.aSharedFeatures[local.ii].getPrices().setFirstBill(0) />
						</cfif>

						<cfset local.aSharedFeatures[local.ii].getPrices().setMonthly(local.fPrice) />
						<cfset local.linePrices.setDueToday(local.linePrices.getDueToday() + local.aSharedFeatures[local.ii].getPrices().getDueToday()) />
						<cfset local.linePrices.setFirstBill(local.linePrices.getFirstBill() + local.aSharedFeatures[local.ii].getPrices().getFirstBill()) />
						<cfset local.linePrices.setMonthly(local.linePrices.getMonthly() + local.aSharedFeatures[local.ii].getPrices().getMonthly()) />
					</cfloop>
				</cfif>
			</cfif>

			<cfset local.aFeatures = local.aLines[local.i].getFeatures() />

			<cfif arrayLen(local.aFeatures)>
				<cfloop from="1" to="#arrayLen(local.aFeatures)#" index="local.ii">
					<cfset local.f = application.model.feature.getByProductId(local.aFeatures[local.ii].getProductId()) />
					<cfset local.fPrice = local.f.price />
					<cfset local.aFeatures[local.ii].getPrices().setDueToday(0) />
					<cfset local.aFeatures[local.ii].getPrices().setFirstBill(local.fPrice) />

					<cfif local.carrierId eq 42>
						<cfset local.aFeatures[local.ii].getPrices().setFirstBill(0) />
					</cfif>

					<cfset local.aFeatures[local.ii].getPrices().setMonthly(local.fPrice) />
					<cfset local.linePrices.setDueToday(local.linePrices.getDueToday() + local.aFeatures[local.ii].getPrices().getDueToday()) />
					<cfset local.linePrices.setFirstBill(local.linePrices.getFirstBill() + local.aFeatures[local.ii].getPrices().getFirstBill()) />
					<cfset local.linePrices.setMonthly(local.linePrices.getMonthly() + local.aFeatures[local.ii].getPrices().getMonthly()) />
				</cfloop>
			</cfif>

			<cfset local.aAccessories = application.model.cartHelper.lineGetAccessoriesByType(line = local.i, type = 'accessory') />

			<cfif arrayLen(local.aAccessories)>
				<cfloop from="1" to="#arrayLen(local.aAccessories)#" index="local.ii">
					<cfset local.a = application.model.accessory.getByFilter(idList = local.aAccessories[local.ii].getProductId()) />
					<cfset local.aPrice = local.a.price />
					<cfset local.aAccessories[local.ii].getPrices().setDueToday(local.aPrice) />
					<cfset local.aAccessories[local.ii].getPrices().setFirstBill(0) />
					<cfset local.aAccessories[local.ii].getPrices().setMonthly(0) />
					<cfset local.linePrices.setDueToday(local.linePrices.getDueToday() + local.aPrice) />
					<cfset local.linePrices.setFirstBill(local.linePrices.getFirstBill() + 0) />
					<cfset local.linePrices.setMonthly(local.linePrices.getMonthly() + 0) />
					<cfset local.linePrices.setCOGS(local.linePrices.getCOGS() + local.aAccessories[local.ii].getPrices().getCOGS()) />
					<cfset local.linePrices.setRetailPrice(local.linePrices.getRetailPrice() + local.aAccessories[local.ii].getPrices().getRetailPrice()) />
				</cfloop>
			</cfif>

			<cfset local.aAccessories = application.model.cartHelper.lineGetAccessoriesByType(line = local.i, type = 'bundled') />

			<cfif arrayLen(local.aAccessories)>
				<cfloop from="1" to="#arrayLen(local.aAccessories)#" index="local.ii">
					<cfset local.a = application.model.accessory.getByFilter(idList = local.aAccessories[local.ii].getProductId()) />
					<cfset local.aPrice = local.a.price />
					<cfset local.aAccessories[local.ii].getPrices().setDueToday(0) />
					<cfset local.aAccessories[local.ii].getPrices().setFirstBill(0) />
					<cfset local.aAccessories[local.ii].getPrices().setMonthly(0) />
					<cfset local.linePrices.setDueToday(local.linePrices.getDueToday() + 0) />
					<cfset local.linePrices.setFirstBill(local.linePrices.getFirstBill() + 0) />
					<cfset local.linePrices.setMonthly(local.linePrices.getMonthly() + 0) />
				</cfloop>
			</cfif>

			<!--- Line warranty --->
			<cfif local.aLines[local.i].getWarranty().hasBeenSelected()>
				<cfset local.linePrices.setDueToday(local.linePrices.getDueToday() + local.aLines[local.i].getWarranty().getPrices().getDueToday()) />
			</cfif>

			<cfset local.aLines[local.i].setPrices(local.linePrices) />
			<cfset local.cartPrices.setDueToday(local.cartPrices.getDueToday() + local.aLines[local.i].getPrices().getDueToday()) />
			<cfset local.cartPrices.setFirstBill(local.cartPrices.getFirstBill() + local.aLines[local.i].getPrices().getFirstBill()) />
			<cfset local.cartPrices.setMonthly(local.cartPrices.getMonthly() + local.aLines[local.i].getPrices().getMonthly()) />
			<cfset local.cartPrices.setCOGS(local.cartPrices.getCOGS() + local.aLines[local.i].getPrices().getCOGS()) />
			<cfset local.cartPrices.setRetailPrice(local.cartPrices.getRetailPrice() + local.aLines[local.i].getPrices().getRetailPrice()) />
		</cfloop>

		<cfset local.aAccessories = session.cart.getOtherItems() />

		<cfif arrayLen(local.aAccessories)>
			<cfset local.linePrices = createObject('component', 'cfc.model.cartPriceBlock').init() />

			<cfloop from="1" to="#arrayLen(local.aAccessories)#" index="local.ii">
				<cfif local.aAccessories[local.ii].getType() is 'accessory'>
					<cfset local.a = application.model.accessory.getByFilter(idList = local.aAccessories[local.ii].getProductId()) />
					<cfset local.aPrice = local.a.price />
				<cfelseif local.aAccessories[local.ii].getType() is 'prepaid'>
					<cfset local.a = application.model.prePaid.getByFilter(idList = local.aAccessories[local.ii].getProductId()) />
					<cfset local.aPrice = local.a.price_new />
				<cfelseif local.aAccessories[local.ii].getType() is 'deposit'>
					<cfset local.aPrice = local.aAccessories[local.ii].getPrices().getDueToday() />
				<cfelse>
					<cfset local.aPrice = 0 />
				</cfif>

				<cfset local.aAccessories[local.ii].getPrices().setDueToday(local.aPrice) />
				<cfset local.aAccessories[local.ii].getPrices().setFirstBill(0) />
				<cfset local.aAccessories[local.ii].getPrices().setMonthly(0) />
				<cfset local.linePrices.setDueToday(local.linePrices.getDueToday() + local.aPrice) />
				<cfset local.linePrices.setCOGS(local.linePrices.getCOGS() + local.aAccessories[local.ii].getPrices().getCOGS()) />
				<cfset local.linePrices.setRetailPrice(local.linePrices.getRetailPrice() + local.aAccessories[local.ii].getPrices().getRetailPrice()) />
				<cfset local.cartPrices.setDueToday((local.cartPrices.getDueToday() + local.aPrice) - local.cartPrices.getDiscountTotal()) />
				<cfset local.cartPrices.setFirstBill(local.cartPrices.getFirstBill() + 0) />
				<cfset local.cartPrices.setMonthly(local.cartPrices.getMonthly() + 0) />
				<cfset local.cartPrices.setCOGS(local.cartPrices.getCOGS() + local.aAccessories[local.ii].getPrices().getCOGS()) />
				<cfset local.cartPrices.setRetailPrice(local.cartPrices.getRetailPrice() + local.aAccessories[local.ii].getPrices().getRetailPrice()) />
			</cfloop>
		</cfif>
		
		<cfset session.cart.setLines(local.aLines) />
		<cfset session.cart.setPrices(local.cartPrices) />
	</cffunction>

	<cffunction name="updateAllTaxes" access="public" output="false" returntype="void">

		<cfset var local = structNew() />

		<cfset local.cartTaxes = createObject('component', 'cfc.model.cartPriceBlock').init() />
		<cfset local.aLines = session.cart.getLines() />

		<cfloop from="1" to="#arrayLen(local.aLines)#" index="local.i">
			<cfset local.lineTaxes = createObject('component', 'cfc.model.cartPriceBlock').init() />

			<cfif local.aLines[local.i].getPhone().hasBeenSelected()>
				
				<cfset local.lineTaxes.setDueToday(local.lineTaxes.getDueToday() + local.aLines[local.i].getPhone().getTaxes().getDueToday()) />
				
				<!---<cfset local.lineTaxes.setDueToday(local.lineTaxes.getDueToday() + local.aLines[local.i].getPhone().getTaxes().getDueToday()) />--->
				
				<cfset local.lineTaxes.setFirstBill(local.lineTaxes.getFirstBill() + local.aLines[local.i].getPhone().getTaxes().getFirstBill()) />
				<cfset local.lineTaxes.setMonthly(val(local.lineTaxes.getMonthly()) + val(local.aLines[local.i].getPhone().getTaxes().getMonthly())) />
			</cfif>

			<cfif local.aLines[local.i].getPlan().hasBeenSelected()>
				<cfset local.lineTaxes.setDueToday(local.lineTaxes.getDueToday() + local.aLines[local.i].getPlan().getTaxes().getDueToday()) />
				<cfset local.lineTaxes.setFirstBill(local.lineTaxes.getFirstBill() + local.aLines[local.i].getPlan().getTaxes().getFirstBill()) />
				<cfset local.lineTaxes.setMonthly(local.lineTaxes.getMonthly() + local.aLines[local.i].getPlan().getTaxes().getMonthly()) />
			</cfif>

			<cfif local.aLines[local.i].getActivationFee().hasBeenSelected()>
				<cfset local.lineTaxes.setDueToday(local.lineTaxes.getDueToday() + local.aLines[local.i].getActivationFee().getTaxes().getDueToday()) />
				<cfset local.lineTaxes.setFirstBill(local.lineTaxes.getFirstBill() + local.aLines[local.i].getActivationFee().getTaxes().getFirstBill()) />
				<cfset local.lineTaxes.setMonthly(local.lineTaxes.getMonthly() + local.aLines[local.i].getActivationFee().getTaxes().getMonthly()) />
			</cfif>

			<cfset local.aFeatures = local.aLines[local.i].getFeatures() />

			<cfif arrayLen(local.aFeatures)>
				<cfloop from="1" to="#arrayLen(local.aFeatures)#" index="local.ii">
					<cfset local.lineTaxes.setDueToday(local.lineTaxes.getDueToday() + local.aFeatures[local.ii].getTaxes().getDueToday()) />
					<cfset local.lineTaxes.setFirstBill(local.lineTaxes.getFirstBill() + local.aFeatures[local.ii].getTaxes().getFirstBill()) />
					<cfset local.lineTaxes.setMonthly(local.lineTaxes.getMonthly() + local.aFeatures[local.ii].getTaxes().getMonthly()) />
				</cfloop>
			</cfif>

			<cfset local.aAccessories = local.aLines[local.i].getAccessories() />

			<cfif arrayLen(local.aAccessories)>
				<cfloop from="1" to="#arrayLen(local.aAccessories)#" index="local.ii">
					<cfset local.lineTaxes.setDueToday(local.lineTaxes.getDueToday() + local.aAccessories[local.ii].getTaxes().getDueToday()) />
					<cfset local.lineTaxes.setFirstBill(local.lineTaxes.getFirstBill() + local.aAccessories[local.ii].getTaxes().getFirstBill()) />
					<cfset local.lineTaxes.setMonthly(local.lineTaxes.getMonthly() + local.aAccessories[local.ii].getTaxes().getMonthly()) />
				</cfloop>
			</cfif>

			<cfif local.aLines[local.i].getWarranty().hasBeenSelected()>
				<cfset local.lineTaxes.setDueToday(local.lineTaxes.getDueToday() + local.aLines[local.i].getWarranty().getTaxes().getDueToday()) />
				<cfset local.lineTaxes.setFirstBill(local.lineTaxes.getFirstBill() + local.aLines[local.i].getWarranty().getTaxes().getFirstBill()) />
				<cfset local.lineTaxes.setMonthly(local.lineTaxes.getMonthly() + local.aLines[local.i].getWarranty().getTaxes().getMonthly()) />
			</cfif>

			<cfset local.aLines[local.i].setTaxes(local.lineTaxes) />
			<cfset local.cartTaxes.setDueToday(local.cartTaxes.getDueToday() + local.aLines[local.i].getTaxes().getDueToday()) />
			<cfset local.cartTaxes.setFirstBill(local.cartTaxes.getFirstBill() + local.aLines[local.i].getTaxes().getFirstBill()) />
			<cfset local.cartTaxes.setMonthly(local.cartTaxes.getMonthly() + local.aLines[local.i].getTaxes().getMonthly()) />
		</cfloop>

		<cfset local.aAccessories = session.cart.getOtherItems() />

		<cfif arrayLen(local.aAccessories)>
			<cfloop from="1" to="#arrayLen(local.aAccessories)#" index="local.ii">
				<cfset local.cartTaxes.setDueToday(local.cartTaxes.getDueToday() + local.aAccessories[local.ii].getTaxes().getDueToday()) />
				<cfset local.cartTaxes.setFirstBill(local.cartTaxes.getFirstBill() + local.aAccessories[local.ii].getTaxes().getFirstBill()) />
				<cfset local.cartTaxes.setMonthly(local.cartTaxes.getMonthly() + local.aAccessories[local.ii].getTaxes().getMonthly()) />
			</cfloop>
		</cfif>

		<cfset session.cart.setLines(local.aLines) />
		<cfset session.cart.setTaxes(local.cartTaxes) />
	</cffunction>
	
	<cffunction name="updateAllDiscounts">
		
		<cfscript>
			var i = 1;
			var code = "";
			var promoCodes = "";
			var codes = "";
			var cartItems = "";
			var Result = "";
			
			if( getChannelConfig().isPromotionCodeAvailable() ) {
			
				promoCodes = session.cart.getPromotionCodes();
				codes = listToArray(structKeyList(promoCodes));
				cartItems = session.cart.getCartItems();
				
				// Discounts are currently a running total.. so we have to reset them before re-applying discounts
				for( i=1; i <= arrayLen(cartItems); i++ ) {
					cartItems[i].getPrices().setDiscountTotal(0);
					cartItems[i].getPrices().setPromotionCodes(structNew());
				}
				
				// Evaluate and apply promotions	
				for( i=1; i <= arrayLen(codes); i++ ) {
	
					code = codes[i];
					
					Result = getPromotionService().evaluatePromotion( 
							code = code, 
							userID = session.userID,
							accessoryTotal = session.Cart.getAccessoriesAmtDueToday(),
							accessoryQuantity = arrayLen(session.Cart.getAccessories(includeFree=false)),
							orderTotal = session.Cart.getCartItemsAmtDueToday(),
							orderQuantity = arrayLen(session.Cart.getCartItems(includeFree=false)),
							orderSKUList = session.Cart.getCartSKUList()
						);
						
					getPromotionService().addPromotiontoCart( 
							cart = session.Cart, 
							result = Result, 
							shipMethod = application.model.checkoutHelper.getShippingMethod(),
							userID = session.userID
						);
	
				}
				
			}
		</cfscript>
		
	</cffunction>

	<!---
	  - Calculates sales tax on cart items and updates tax cart price block
	  --->
	<cffunction name="updateCartItemTaxes" output="true" access="public" returntype="any">

		<cfscript>
			var taxCalculator = application.wirebox.getInstance("TaxCalculator");
			var cartLines = session.cart.getLines();
			var otherItems = session.cart.getOtherItems();
			var accessories = 0;
			var cartItems = [];
			var args = {};
			var instantRebateAmt = 0;
			var rebate = "";
			var cartItemsWithPromotions = [];
			var discount = "";
			var details = []; //Array used to contain lineActivationType
			
			//Get taxable cart items from cart line
			for ( i=1; i <= ArrayLen( cartLines ); i++ )
			{
				
				ArrayAppend(details , cartLines[i].getPhone());
				ArrayAppend(details , cartLines[i].getCartLineActivationType());
				ArrayAppend( cartItems, details ); //Phone
				ArrayClear(details); //Clear out array in case there is another phone
				
				//If phone/line qualifies for instant rebate, create a temporary cart item so Exactor is aware of it
				instantRebateAmt = getInstantRebateService().getQualifyingAmt( cartLines[i] ) * -1; 
				if( instantRebateAmt < 0 ) 
				{
					rebate = createObject("component","cfc.model.CartItem").init();
					rebate.setProductID(-1337);
					rebate.setGERSSKU('INSTANTREBATESAVINGS');
					rebate.getPrices().setDueToday(instantRebateAmt);
					rebate.getPrices().setRetailPrice(instantRebateAmt);
					rebate.getPrices().setCogs(instantRebateAmt);
					ArrayAppend( cartItems, rebate ); //Instant rebate
				}
				
				if ( cartLines[i].getWarranty().getProductId() )
				{
					ArrayAppend( cartItems, cartLines[i].getWarranty() ); //Warranty
				}

				accessories = cartLines[i].getAccessories();
				for (j=1; j <= ArrayLen( accessories ); j++)
				{
					ArrayAppend( cartItems, accessories[j] ); //Accessories
				}
				
	
				
			}

			//Get taxable cart items from other items
			for ( i=1; i <= ArrayLen( otherItems ); i++ )
			{
				ArrayAppend( cartItems, otherItems[i] );
			}
			
			//Create promotional code tax items
			for( i=1; i <= arrayLen( cartItems ); i++ ) 
			{
				arrayAppend(cartItemsWithPromotions, cartItems[i]);
				//Handling where item is a phone and lineactivationtype is second value of a cartItem struct, pos 1 is phone, pos 2 is lineactivationtype
				if(isArray(cartItems[i])){	//When there is an array in the array it means that it is a phone with an activationLineType
					if( cartItems[i][1].getPrices().getDiscountTotal() > 0 ){
						discount = buildTaxDiscountLineItem( cartItems[i].getPrices(), 'ITEMCOUPONAMOUNT' );
						arrayAppend(cartItemsWithPromotions,discount);
					}
				}
				else if( cartItems[i].getPrices().getDiscountTotal() > 0 ) 
				{
					discount = buildTaxDiscountLineItem( cartItems[i].getPrices(), 'ITEMCOUPONAMOUNT' );
					arrayAppend(cartItemsWithPromotions,discount);
				}
			}
			
			if( session.cart.getPrices().getDiscountTotal() > 0 ) 
			{
				discount = buildTaxDiscountLineItem( session.cart.getPrices(), 'ORDERCOUPONAMOUNT' );
				arrayAppend(cartItemsWithPromotions, discount);
			} 
			else 
			{
				for(i=1; i<=arrayLen(cartItemsWithPromotions); i++) {
					if(isArray(cartItems[i])){
						if( cartItemsWithPromotions[i][1].getGersSKU() eq 'ORDERCOUPONAMOUNT' )
						arrayDeleteAt( cartItemsWithPromotions, i );
					}
					else
					{
						if( cartItemsWithPromotions[i].getGersSKU() eq 'ORDERCOUPONAMOUNT' )
						arrayDeleteAt( cartItemsWithPromotions, i );
					}
					
				}
			}
			
			//convert the cartItems[] to a taxableItem[]
			taxableItems = ArrayNew(1);
			for ( i=1; i <= ArrayLen( cartItemsWithPromotions ); i++ )
			{
				items[i] = structNew();
				//This loop is for specifically checking lineActivationType
				if(isArray(cartItemsWithPromotions[i])){
					if (cartItemsWithPromotions[i][2] contains 'finance' and cartItemsWithPromotions[i][1].getType() is 'device'){
						items[i].Net = cartItemsWithPromotions[i][1].getPrices().getRetailPrice() ;	
						items[i].Retail = cartItemsWithPromotions[i][1].getPrices().getRetailPrice();
						items[i].COGS = cartItemsWithPromotions[i][1].getPrices().getCogs();
						items[i].ProductId = cartItemsWithPromotions[i][1].getProductID();
						items[i].SKU = cartItemsWithPromotions[i][1].getGersSKU();
						
						ArrayAppend( taxableItems, items[i] );
						details = cartItemsWithPromotions[i][1];
						ArrayInsertAt(cartItemsWithPromotions,i,details);  //Add the single element into the cartItemsWithPromotions array		
						ArrayDeleteAt(cartItemsWithPromotions,(i+1));	//cartItemsWithPromotions needs to have the array for phone lineActivationType removed
						
					}else{
						items[i].Net = cartItemsWithPromotions[i][1].getPrices().getDueToday();
						items[i].Retail = cartItemsWithPromotions[i][1].getPrices().getRetailPrice();
						items[i].COGS = cartItemsWithPromotions[i][1].getPrices().getCogs();
						items[i].ProductId = cartItemsWithPromotions[i][1].getProductID();
						items[i].SKU = cartItemsWithPromotions[i][1].getGersSKU();
						
						ArrayAppend( taxableItems, items[i] );
						details = cartItemsWithPromotions[i][1];
						ArrayInsertAt(cartItemsWithPromotions,i,details); //inserting the 'new' details record back into cartItems
						ArrayDeleteAt(cartItemsWithPromotions,(i+1)); //Deleting the old details record
										
					}	
				}else{	//This handles all non device cartItemsWIthPromotions elements
					items[i].Net = cartItemsWithPromotions[i].getPrices().getDueToday();				
					items[i].Retail = cartItemsWithPromotions[i].getPrices().getRetailPrice();
					items[i].COGS = cartItemsWithPromotions[i].getPrices().getCogs();
					items[i].ProductId = cartItemsWithPromotions[i].getProductID();
					items[i].SKU = cartItemsWithPromotions[i].getGersSKU();
		
					ArrayAppend( taxableItems, items[i] );	
				}
				
				
			}

			args = {
				billToAddress = session.checkout.billingAddress
		        , shipToAddress = session.checkout.shippingAddress
				, items = taxableItems
				, cartItems = cartItemsWithPromotions
		        , saleDate = DateFormat(Now(), "yyyy-mm-dd")
		        , currencyCode = "USD"
			};

			result = taxCalculator.calculateTax( argumentCollection = args );
		</cfscript>

    	<cfreturn result />
	</cffunction>

    <cffunction name="AddOtherItem" returntype="cfc.model.CartItem" output="no" hint="Adds the provided cfc.model.CartItem to the other items list.">
    	<cfargument name="Item" type="cfc.model.CartItem" required="yes">
        <cfset ArrayAppend(variables.instance.otherItems, arguments.Item)>
        <cfreturn arguments.Item>
    </cffunction>

	<cffunction name="getCurrentLineData" access="public" output="false" returntype="any">
		<cfset var local = structNew()>
		<cfif this.getCurrentLine() and this.getCurrentLine() neq request.config.otherItemsLineNumber and arrayLen(session.cart.getLines()) gte session.cart.getCurrentLine()>
			<cfset local.cartLines = session.cart.getLines()>
			<cfreturn local.cartLines[this.getCurrentLine()]>
		<cfelseif this.getCurrentLine() and this.getCurrentLine() eq request.config.otherItemsLineNumber>
			<cfreturn session.cart.getOtherItems()>
		<cfelse>
			<cfset local.cartLine = createObject("component","cfc.model.CartLine").init()>
			<cfreturn local.cartLine>
		</cfif>
	</cffunction>

	<!--- getters --->

	<cffunction name="getOrderID" returntype="numeric" output="false">
		<cfreturn variables.instance.orderID>
	</cffunction>

	<cffunction name="getZipcode" returntype="string" output="false">
		<cfreturn variables.instance.zipcode>
	</cffunction>

	<cffunction name="getLines" returntype="array" output="false">
		<cfreturn variables.instance.lines>
	</cffunction>

	<cffunction name="getCurrentLine" returntype="numeric" output="false">
		<cfreturn variables.instance.currentLine>
	</cffunction>

	<cffunction name="getOtherItems" returntype="array" output="false">
		<cfreturn variables.instance.otherItems>
	</cffunction>


	<cffunction name="getFamilyPlan" returntype="any" output="false">
		<cfreturn variables.instance.familyPlan>
	</cffunction>

	<cffunction name="getAdditionalCharges" returntype="struct" output="false">
		<cfreturn variables.instance.additionalCharges>
	</cffunction>

	<cffunction name="getPrices" returntype="any" output="false">
		<cfreturn variables.instance.prices>
	</cffunction>

	<cffunction name="getTaxes" returntype="any" output="false">
		<cfreturn variables.instance.taxes>
	</cffunction>

	<cffunction name="getShipping" returntype="any" output="false">
		<cfreturn variables.instance.shipping>
	</cffunction>

	<cffunction name="getActivationType" returntype="string" output="false">
		<cfreturn variables.instance.activationType>
	</cffunction>

	<cffunction name="getUpgradeType" returntype="string" output="false">
		<cfreturn variables.instance.upgradeType>
	</cffunction>

    <cffunction name="getAddALineType" returntype="string" output="false">
		<cfreturn variables.instance.addALineType>
	</cffunction>

	<cffunction name="getPrePaid" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.prepaid />
	</cffunction>

	<cffunction name="getCarrierId" returntype="numeric" output="false">
		<cfreturn variables.instance.carrierId>
	</cffunction>

	<cffunction name="getSalesTaxTransactionId" access="public" returntype="string" output="false">
		<cfreturn variables.instance.SalesTaxTransactionId />
	</cffunction>

	<cffunction name="getHasUnlimitedPlan" access="public" returntype="string" output="false">
		<cfreturn variables.instance.hasUnlimitedPlan />
	</cffunction>

	<cffunction name="getHasSharedPlan" access="public" returntype="string" output="false">
		<cfreturn variables.instance.HasSharedPlan />
	</cffunction>

	<cffunction name="getSharedFeatures" returntype="array" output="false">
		<cfreturn variables.instance.SharedFeatures />
	</cffunction>

	<!--- setters --->

	<cffunction name="setOrderID" returntype="void">
		<cfargument name="orderID" type="numeric" required="true">
		<cfset variables.instance.orderID = arguments.orderID>
	</cffunction>

	<cffunction name="setZipcode" returntype="void">
		<cfargument name="zipcode" type="string" required="true">
		<cfset variables.instance.zipcode = arguments.zipcode>
	</cffunction>

	<cffunction name="setLines" returntype="void">
		<cfargument name="lines" type="array" required="true">
		<cfset variables.instance.lines = arguments.lines>
	</cffunction>

	<cffunction name="setCurrentLine" returntype="void">
		<cfargument name="currentLine" type="numeric" required="true">
		<cfset variables.instance.currentLine = arguments.currentLine>
	</cffunction>

	<cffunction name="setOtherItems" returntype="void">
		<cfargument name="otherItems" type="array" required="true">
		<cfset variables.instance.otherItems = arguments.otherItems>
	</cffunction>

	<cffunction name="setFamilyPlan" returntype="void">
		<cfargument name="familyPlan" type="any" required="true">
		<cfset variables.instance.familyPlan = arguments.familyPlan>
	</cffunction>

	<cffunction name="setAdditionalCharges" returntype="void">
		<cfargument name="additionalCharges" type="struct" required="true">
		<cfset variables.instance.additionalCharges = arguments.additionalCharges>
	</cffunction>

	<cffunction name="setPrices" returntype="void">
		<cfargument name="prices" type="any" required="true">
		<cfset variables.instance.prices = arguments.prices>
	</cffunction>

	<cffunction name="setTaxes" returntype="void">
		<cfargument name="taxes" type="any" required="true">
		<cfset variables.instance.taxes = arguments.taxes>
	</cffunction>

	<cffunction name="setShipping" returntype="void">
		<cfargument name="shipping" type="any" required="true">
		<cfset variables.instance.shipping = arguments.shipping>
	</cffunction>

	<cffunction name="setActivationType" returntype="void">
		<cfargument name="activationType" type="string" required="true">
		<cfset variables.instance.activationType = arguments.activationType>
	</cffunction>

	<cffunction name="setUpgradeType" returntype="void">
		<cfargument name="upgradeType" type="string" required="true">
		<cfset variables.instance.upgradeType = arguments.upgradeType>
	</cffunction>

    <cffunction name="setAddALineType" returntype="void">
		<cfargument name="addALineType" type="string" required="true">
		<cfset variables.instance.addALineType = arguments.addALineType>
	</cffunction>

	<cffunction name="setPrePaid" returntype="void">
		<cfargument name="prePaid" type="boolean" required="true">
		<cfset variables.instance.prePaid = arguments.prePaid>
	</cffunction>

	<cffunction name="setCarrierId" returntype="void">
		<cfargument name="carrierId" type="numeric" required="true">
		<cfset variables.instance.carrierId = arguments.carrierId>
	</cffunction>

	<cffunction name="setSalesTaxTransactionId" access="public" returntype="void" output="false">
		<cfargument name="SalesTaxTransactionId" type="string" required="true" />
		<cfset variables.instance.SalesTaxTransactionId = arguments.SalesTaxTransactionId />
	</cffunction>

	<cffunction name="setHasUnlimitedPlan" access="public" returntype="void" output="false">
		<cfargument name="hasUnlimitedPlan" type="string" required="true" />
		<cfset variables.instance.hasUnlimitedPlan = arguments.hasUnlimitedPlan />
	</cffunction>

	<cffunction name="setHasSharedPlan" access="public" returntype="void" output="false">
		<cfargument name="HasSharedPlan" type="string" required="true" />
		<cfset variables.instance.HasSharedPlan = arguments.HasSharedPlan />
	</cffunction>

	<cffunction name="setSharedFeatures" returntype="void">
		<cfargument name="SharedFeatures" type="array" required="true">
		<cfset variables.instance.SharedFeatures = arguments.SharedFeatures>
	</cffunction>

	<!--- DUMP --->

	<cffunction name="dump" access="public" output="true" return="void">
		<cfargument name="abort" type="boolean" default="FALSE" />
		<cfdump var="#variables.instance#" />
		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>

	<!--- GETINSTANCE --->

	<cffunction name="getInstanceData" access="public" output="false" return="struct">
		<cfargument name="recursive" type="boolean" required="false" default="false">
		<cfset var local = structNew()>
		<cfset local.instance = duplicate(variables.instance)>

		<cfif arguments.recursive>
			<cfloop collection="#local.instance#" item="local.key">
				<cfif not isSimpleValue(local.instance[local.key])>
					<cfif isArray(local.instance[local.key])>
						<cfloop from="#1#" to="#arrayLen(local.instance[local.key])#" index="local.ii">
							<cfset local.instance[local.key][local.ii] = local.instance[local.key][local.ii].getInstanceData(arguments.recursive)>
						</cfloop>
					<cfelseif structKeyExists(local.instance[local.key],"getInstanceData")>
						<cfset local.instance[local.key] = local.instance[local.key].getInstanceData(arguments.recursive)>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>

		<cfreturn local.instance>
	</cffunction>
	
	<cffunction name="getDiscountTotal" access="public" returntype="numeric" output="false">
		<cfscript>
			var total = getPrices().getDiscountTotal();
			var items = getCartItems();
			var i = 1;
			
			for( i=1; i <= arrayLen(items); i++ ) {
				if( isNumeric( items[i].getPrices().getDiscountTotal() ) )
					total += items[i].getPrices().getDiscountTotal();
			}
			return total;
		</cfscript>
	</cffunction>

	<cffunction name="setRebates" access="public" returntype="void" output="false">
		<cfargument name="rebateArray" required="true" type="array" />
		<cfif not structKeyExists(variables.instance, 'rebates')>
			<cfset variables.instance.rebates = arrayNew(1) />
		</cfif>
		<cfset variables.instance.rebates = arguments.rebateArray />
	</cffunction>

	<cffunction name="getRebates" access="public" returntype="array" output="false">
		<cfif not structKeyExists(variables.instance, 'rebates')>
			<cfset variables.instance.rebates = arrayNew(1) />
		</cfif>
		<cfif not structKeyExists(variables.instance, 'rebates')>
			<cfset variables.instance.rebates = arrayNew(1) />
		</cfif>

		<cfreturn variables.instance.rebates />
	</cffunction>
	
	<cffunction name="getInstantRebateAmountTotal" access="public" output="false" returntype="numeric">    
    	<cfreturn variables.instance["instantRebateAmountTotal"]/>    
    </cffunction>
  
    <cffunction name="setInstantRebateAmountTotal" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["instantRebateAmountTotal"] = arguments.theVar />    
    </cffunction>

	<cffunction name="getHasFamilyPlan" access="public" returntype="boolean" output="false">
		<cfscript>
			var hasFamilyPlan = false;

			if ( getFamilyPlan().getProductId() NEQ 0 )
			{
				hasFamilyPlan = true;
			}
		</cfscript>

		<cfreturn hasFamilyPlan />
	</cffunction>

	<cffunction name="getHasPlanDeviceCap" access="public" returntype="boolean" output="false">
		<cfscript>
			var hasFamilyPlan = false;

			if ( getFamilyPlan().getHasPlanDeviceCap() )
			{
				hasFamilyPlan = true;
			}
		</cfscript>

		<cfreturn hasFamilyPlan />
	</cffunction>

	<cffunction name="getDeviceTypeCount" access="public" returntype="boolean" output="false">
		<cfargument name="DeviceType" type="string" required="true" /> <!--- SmartPhone, FeaturePhone, MobileBroadband --->

		<cfscript>
			var deviceCount = 0;
			var cartlines = getLines();
			var i = 0;

			for ( i=1; i <= ArrayLen(cartlines); i++ )
			{
				if ( cartlines[i].getPhone().getDeviceServiceType() eq Trim(arguments.DeviceType) )
				{
					deviceCount++;
				}
			}
		</cfscript>

		<cfreturn deviceCount />
	</cffunction>

	<cffunction name="setKioskEmployeeNumber" access="public" returntype="void" output="false">
		<cfargument name="employeeNumber" required="true" type="string" />
		<cfset variables.instance.kioskEmployeeNumber = arguments.employeeNumber />
	</cffunction>

	<cffunction name="getKioskEmployeeNumber" access="public" returntype="string" output="false">
		<cfreturn variables.instance.kioskEmployeeNumber />
	</cffunction>
	
	<!----------- Promotions ----------->
	
    <cffunction name="getPromotionCodes" access="public" output="false" returntype="struct">    
    	<cfreturn variables.instance["promotionCodes"]/>    
    </cffunction>    

    <cffunction name="setPromotionCodes" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["promotionCodes"] = arguments.theVar />    
    </cffunction> 
        
    <cffunction name="addPromotion" access="public" output="false" returntype="void">
		<cfargument name="code" type="string" required="true">
		<cfargument name="name" type="String" required="true">
		<cfargument name="promotionID" type="numeric" required="true">
		<cfset variables.instance.promotionCodes[arguments.code] = { name = arguments.name, promotionID = arguments.promotionID }>
	</cffunction>
	
	<cffunction name="removePromotion" access="public" output="false" returntype="void">
		<cfargument name="code" type="string" required="true">
		<cfset structDelete( getPromotionCodes(), arguments.code )>
	</cffunction>
	
	<cffunction name="hasPromotion" access="public" output="false" returntype="boolean">
		<cfargument name="code" type="string" required="true">
		<cfreturn structKeyExists( getPromotionCodes(), arguments.code )>
	</cffunction>
	
	<cffunction name="hasPromotions" access="public" output="false" returntype="boolean">
		<cfreturn structCount( getPromotionCodes() )>
	</cffunction>
	
	<cffunction name="buildTaxDiscountLineItem" access="private" output="false" returntype="cfc.model.CartItem" hint="">    
    	<cfargument name="CartPriceBlock" type="cfc.model.CartPriceBlock" required="true" />
		<cfargument name="gersSKU" type="string" required="true" />
		
		<cfscript>
			var DiscountItem = createObject("component","cfc.model.CartItem").init();
			var promotions = arguments.CartPriceBlock.getPromotionCodes();
			var promoCodes = structKeyList(promotions);
			var discountAmt = 0;
			var code = "";
			var i = 1;
			
			for( i=1; i <= listLen(promoCodes); i++ ) {
				code = listGetAt(promoCodes,i);
				discountAmt += promotions[code].value;
			}
			
			discountAmt = discountAmt * -1;
			
			DiscountItem.setProductID(-1338);
			DiscountItem.setGersSKU(arguments.gersSKU);
			DiscountItem.getPrices().setDueToday(discountAmt);
			DiscountItem.getPrices().setRetailPrice(discountAmt);
			DiscountItem.getPrices().setCogs(discountAmt);
			
			return DiscountItem;		
		</cfscript> 
    </cffunction>
	
	<!----------------------------------->
		
	<cffunction name="getCartTypeId" access="public" returntype="numeric" output="false">
		<cfargument name="activationType" required="true" type="string" />

		<cfset var getCartTypeIdReturn = 0 />

		<cfif arguments.activationType is 'new'>
			<cfset getCartTypeIdReturn = 1 />
		<cfelseif arguments.activationType is 'upgrade'>
			<cfset getCartTypeIdReturn = 2 />
		<cfelseif arguments.activationType is 'addaline'>
			<cfset getCartTypeIdReturn = 3 />
		<cfelseif arguments.activationType is 'financed-12-new'>
			<cfset getCartTypeIdReturn = 1 />
		<cfelseif arguments.activationType is 'financed-12-upgrade'>
			<cfset getCartTypeIdReturn = 2 />
		<cfelseif arguments.activationType is 'financed-12-addaline'>
			<cfset getCartTypeIdReturn = 3 />
		<cfelseif arguments.activationType is 'financed-18-new'>
			<cfset getCartTypeIdReturn = 1 />
		<cfelseif arguments.activationType is 'financed-18-upgrade'>
			<cfset getCartTypeIdReturn = 2 />
		<cfelseif arguments.activationType is 'financed-18-addaline'>
			<cfset getCartTypeIdReturn = 3 />
		<cfelseif arguments.activationType is 'financed-24-new'>
			<cfset getCartTypeIdReturn = 1 />
		<cfelseif arguments.activationType is 'financed-24-upgrade'>
			<cfset getCartTypeIdReturn = 2 />
		<cfelseif arguments.activationType is 'financed-24-addaline'>
			<cfset getCartTypeIdReturn = 3 />

		</cfif>

		<cfreturn getCartTypeIdReturn />
	</cffunction>

	<cffunction name="hasCart" returntype="boolean">
		<cfset var local = structNew()>
		<cfset local.return = false>
		<cfif isDefined("session.cart") and isStruct(session.cart)>
			<cfset local.return = true>
		</cfif>
		<cfreturn local.return>
	</cffunction>
	
	<cffunction name="getAccessories" access="public" returntype="array" output="false">
		<cfargument name="includeFree" required="false" default="true">
		<cfscript>
			var lines = getLines();
			var otherItems = getOtherItems();
			var accessories = [];
			var lineAccessories = [];
			var i = 1;
			var o = 1;
			
			for( i=1; i <= arrayLen(lines); i++ ) {
				lineAccessories = lines[i].getAccessories();
				for( a=1; a <= arrayLen(lineAccessories); a++ ) {
					if( lineAccessories[a].getPrices().getDueToday() > 0 || arguments.includeFree )
						arrayAppend( accessories, lineAccessories[a] );
				}
			}
			
			for( o=1; o <= arrayLen(otherItems); o++ ) {
				if( otherItems[o].getType() == "accessory" ) {
					if( otherItems[o].getPrices().getDueToday() > 0 || arguments.includeFree )
					arrayAppend( accessories, otherItems[o] );
				}
			}
			
			return accessories;
		</cfscript>
	</cffunction>
	
	<cffunction name="getAccessoriesAmtDueToday" access="public" returntype="numeric" output="false">
		<cfscript>
			var accessories = getAccessories();
			var total = 0;
			var i = 1;
			
			for( i=1; i <= arrayLen(accessories); i++ ) {
				total += accessories[i].getPrices().getDueToday();
			}
			
			return total;
		</cfscript>
	</cffunction>
	
	<cffunction name="getCartItems" access="public" returntype="array" output="false">
		<cfargument name="includeFree" required="false" default="true">
		<cfscript>
			var lines = getLines();
			var otherItems = getOtherItems();
			var items = [];
			var i = 1;
			
			for( i=1; i <= arrayLen(lines); i++ ) {
				lineItems = lines[i].getCartItems();
				for( j=1; j <= arrayLen(lineItems); j++ ) {
					if( lineItems[j].getPrices().getDueToday() || arguments.includeFree )
						arrayAppend( items, lineItems[j] );
				}
			}
			
			for( i=1; i <= arrayLen(otherItems); i++ ) {
				if( otherItems[i].getPrices().getDueToday() || arguments.includeFree )
					arrayAppend( items, otherItems[i] );
			}
			
			return items;
		</cfscript>
	</cffunction>
	
	<cffunction name="getCartItemsAmtDueToday" access="public" returntype="numeric" output="false">
		<cfscript>
			var items = getCartItems();
			var total = 0;
			var i = 1;
			
			for( i=1; i <= arrayLen(items); i++ ) {
				total += items[i].getPrices().getDueToday();
			}
			
			return total;
		</cfscript>
	</cffunction>
	
	<cffunction name="getCartSKUList" access="public" returntype="string" output="false">
		<cfscript>
			var items = getCartItems();
			var otherItems = getOtherItems();
			var list = "";
			var i = 1;
			var o = 1;
			
			for( i=1; i <= arrayLen(items); i++ ) {
				list = listAppend( list, items[i].getGersSKU() );
			}
			
			for( o=1; o <= arrayLen(otherItems); o++ ) {
				if( otherItems[o].getType() == "accessory" ) {
					list = listAppend( list, otherItems[o].getGersSKU() );
				}
			}
			
			return list;
		</cfscript>
	</cffunction>
	
	<cffunction name="getInstantRebateService" output="false" access="private" returntype="any">
		<cfreturn application.wirebox.getInstance("InstantRebateService") />
	</cffunction>
	
	<cffunction name="getPromotionService" output="false" access="private" returntype="any">
		<cfreturn application.wirebox.getInstance("PromotionService") />
	</cffunction>
	
	<cffunction name="getChannelConfig" output="false" access="private" returntype="any">
		<cfreturn application.wirebox.getInstance("ChannelConfig") />
	</cffunction>

	<cffunction name="getCarrierCode" output="false" access="public" returntype="string">
		
		<cfscript>
			var code = '';
		
			switch( variables.instance.carrierId )
			{
				case '42':
					code = 'VZN';
					break;
				case '109':
					code = 'ATT';
					break;
				case '128':
					code = 'TMO';
					break;
				case '299':
					code = 'SPT';
					break;	
			}
		</cfscript>

		<cfreturn code />
	</cffunction>

</cfcomponent>