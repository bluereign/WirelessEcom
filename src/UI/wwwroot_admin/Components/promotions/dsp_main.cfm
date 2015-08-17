<cfparam name="request.p.go" default="home" type="string" />

<cfset PromotionService = application.wirebox.getInstance("PromotionService") />
<cfset view = application.view.promotionCodes.init() />

<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td>
			<cfswitch expression="#request.p.go#">
				<cfcase value="delete">
					<cftransaction>
						<cfset PromotionService.deletePromotion( promotionId = request.p.promotionID ) />
					</cftransaction>
					<cflocation url="index.cfm?c=#url.c#&go=home&remove=true" addtoken="false" />
				</cfcase>
				<cfcase value="save">
					<cftransaction>
						<cfscript>
							
							//****************** Promotion ****************//
							promo = {
								doUpdate = structKeyExists( request.p, "promotionID" ),
								name = request.p.promoName,
								startDate = request.p.startDate,
								discountType = request.p.discountType,
								appliesTo = request.p.appliesTo
							};
							
							// Parse codes textarea
							codeList = reReplace(trim(form.promoCode), '\n', ',', 'all');
							promo.codes = listToArray(codeList);
							
							// Optional
							if( promo.doUpdate )
								promo.promotionID = request.p.promotionID;
							if( len(form.promoCode) )
								promo.promoCode = form.promoCode;
							if( len(form.qty) )
								promo.qty = form.qty;
							/*if( len(form.qtyPerUser) )
								promo.qtyPerUser = form.qtyPerUser;*/
							if( len(form.endDate) )
								promo.endDate = form.endDate;
							if( len(form.amountOff) )
								promo.amountOff = form.amountOff;
							if( len(form.percentOff) )
								promo.percentOff = form.percentOff;
							if( len(form.shippingMethodId) )
								promo.shippingMethodId = form.shippingMethodId;
							if( structKeyExists(form, "items") )
								promo.items = form.items;
												
							promotionID = PromotionService.savePromotion( argumentCollection = promo );
							
							//****************** Conditions ****************//
							conditionArgs = {
								doUpdate = promo.doUpdate,
								promotionID = promotionID
							};
							
							// Optional
							if( conditionArgs.doUpdate )
								conditionArgs.conditionID = form.conditionID;
							
							if( len(form.cartOrderTotal) ) {
								conditionArgs.cartOrderTotal = form.cartOrderTotal;
								if( len(form.isCartOrderTotalOptional) )
									conditionArgs.isCartOrderTotalOptional = form.isCartOrderTotalOptional;
							}
							
							if( len(form.cartAccessoryTotal) ) {
								conditionArgs.cartAccessoryTotal = form.cartAccessoryTotal;
								if( len(form.isCartAccessoryTotalOptional) )
									conditionArgs.isCartAccessoryTotalOptional = form.isCartAccessoryTotalOptional;
							}
							
							if( len(form.cartQuantity) ) {
								conditionArgs.cartQuantity = form.cartQuantity;
								if( len(form.isCartQuantityOptional) )
									conditionArgs.isCartQuantityOptional = form.isCartQuantityOptional;
							}
							
							if( len(form.cartAccessoryQuantity) ) {
								conditionArgs.cartAccessoryQuantity = form.cartAccessoryQuantity;
								if( len(form.isCartAccessoryQuantityOptional) )
									conditionArgs.isCartAccessoryQuantityOptional = form.isCartAccessoryQuantityOptional;
							}
							
							if( structKeyExists(form, "cartSKUs") ) {
								conditionArgs.cartSKUs = form.cartSKUs;
								if( len(form.isCartSKUsOptional) )
									conditionArgs.isCartSKUsOptional = form.isCartSKUsOptional;
							}
							
							PromotionService.saveConditions( argumentCollection = conditionArgs );
						</cfscript>
					</cftransaction>

					<cfif promo.doUpdate>
						<cflocation url="index.cfm?c=#url.c#&go=home&edit=true" addtoken="false" />
					<cfelse>
						<cflocation url="index.cfm?c=#url.c#&go=home&add=true" addtoken="false" />
					</cfif>
				</cfcase>

				<cfcase value="add,edit">
					<cfoutput>#variables.view.displayPromotionCodeForm()#</cfoutput>
				</cfcase>

				<cfdefaultcase>
					<cfoutput>#variables.view.displayPromotionCodes()#</cfoutput>
				</cfdefaultcase>
			</cfswitch>
		</td>
	</tr>
</table>