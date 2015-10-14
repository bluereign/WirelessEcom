<!---<cffunction name="view" access="public" returntype="string" output="false">
        <cfargument name="isEditable" required="false" type="boolean" default="true" />--->
<cfset setAssetPaths(application.wirebox.getInstance("assetPaths"))/>
<cfset setChannelConfig(application.wirebox.getInstance("ChannelConfig"))/>
<cfset setStringUtil(application.wirebox.getInstance("StringUtil"))/>
<cfset arguments.isEditable = false/>
<!---<cfset var local = {} />--->
<cfset local = structNew()/>

<cfif application.model.cartHelper.hasSelectedFeatures()>
	<cfset qRecommendedServices = application.model.ServiceManager.getRecommendedServices()/>
</cfif>

<cfset session.cart.updateAllPrices()/>
<cfset session.cart.updateAllDiscounts()/>
<cfset session.cart.updateAllTaxes()/>

<!---<cfsavecontent variable="local.html">--->
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
	    padding: 0px;
	}
	span.callout {
	    color: #FF0000;
	    font-weight: bold;
	}
	h2, h3{
		margin-bottom:3px; 
	}
	.progressBtn {
   		background: linear-gradient(to bottom, #8bcd68 0%, #65b43c 5%, #518f30 100%) repeat scroll 0 0 rgba(0, 0, 0, 0);
   		border-radius: 2px;
		display: inline-block;
    	height: 42px;
   		line-height: 42px;
   		margin: 0 auto;
    	text-align: center;
    	text-decoration: none;
    	width: 180px;
		margin-left: 10px;
	}
	.progressBtn span {
		font-size: 18px;
  		color: #ffffff;
  		text-shadow: #444444;
  		font-weight: bold;
	}
</style>
<script type="text/javascript">	
	var $j = jQuery.noConflict();
	$j(window).load(function(){
	shippingCostDisplay = document.getElementById("shippingCostDisplay" ).innerHTML;
	taxes = document.getElementById("todayTaxes" ).innerHTML;
	oldTotal = document.getElementById("todayTotal" ).innerHTML;
	
	shippingCostDisplay = shippingCostDisplay.replace('$','');
	taxes = taxes.replace('$','');
	oldTotal = oldTotal.replace('$','')
						.replace(',','');
	
	newShipTaxTotal = parseFloat(shippingCostDisplay) + parseFloat(taxes);
	newTotal = parseFloat(shippingCostDisplay) + parseFloat(taxes) + parseFloat(oldTotal);
	
	document.getElementById("shippingTaxCostDisplay").innerHTML = formatCurrency(newShipTaxTotal);
	document.getElementById("todayTotal").innerHTML = formatCurrency(newTotal);
	});  
	
	function adjustShippingCostsAllVFD(el){
	if (document.getElementById(el) != null){
		var elValue = $j("#" + el);
		var dropdownIndex = elValue.get(0).selectedIndex;
		var dropdownItem = elValue[dropdownIndex];
		var option = elValue.get(0)[dropdownIndex];
		
		var price = $j(option).attr("price");
		var displayPrice = $j(option).attr("displayPrice");
		//Taxes and Fees value
		var taxes = document.getElementById("todayTaxes" ).innerHTML;
		taxes = taxes.replace('$','')

		//update the shipping cost prices.
		document.getElementById("shippingCostDisplay").innerHTML = displayPrice;
		displayPrice = displayPrice.replace('$','');
		//update totals
		var totalDisplay = $j("#totalPrice");
		var totalAmount = totalDisplay.attr("total");
		var newTotal = (price * 1) + (totalAmount * 1);
		//display the new total.
		document.getElementById("todayTotal").innerHTML = formatCurrency(parseFloat(taxes) + parseFloat(displayPrice) + parseFloat(oldTotal));		
		//display Taxes and Shipping total
		document.getElementById("shippingTaxCostDisplay").innerHTML = formatCurrency(parseFloat(taxes) + parseFloat(displayPrice));		
		}
	}
	
	function formatCurrency(num) {
		num = num.toString().replace(/\$|\,/g,'');
		if(isNaN(num))
		num = "0";
		sign = (num == (num = Math.abs(num)));
		num = Math.floor(num*100+0.50000000001);
		cents = num%100;
		num = Math.floor(num/100).toString();
		if(cents<10)
		cents = "0" + cents;
		for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
		num = num.substring(0,num.length-(4*i+3))+','+
		num.substring(num.length-(4*i+3));
		return (((sign)?'':'-') + '$' + num + '.' + cents);
	}
</script>
<div>
	<h2>
		Review Your Order
	</h2>
</div>
<form id="reviewOrder" name="reviewOrder" action="/checkoutVFD/processOrderConfirmation" method="post">
	<input type="hidden" name="s" value="Submit Order" />
<div class="cartReview">
	<cfif structKeyExists(session, 'cart') and isStruct(session.cart)>
		<cfoutput>
			<cfparam name="request.bCartSaved" type="boolean" default="false"/>
			<cfparam name="request.bCartLoaded" type="boolean" default="false"/>
			<cfparam name="local.deviceGuidList" type="string" default=""/>
		
			<cfif structKeyExists(session, "PromoResult")>
				<div class="cartReviewMessage">
					#session.PromoResult.getMessage()#
				</div>
				<cfset structDelete(session, "PromoResult")>
			</cfif>
		
			<cfset local.cartLines = session.cart.getLines()/>
			
			<cfset local.monthlyFinanceTotal = 0/>
			<!---Getting financed monthly totals if they exist to add to Monthly total --->
			<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.iCartLine">
				<cfset local.cartLine = local.cartLines[local.iCartLine]/>
			
				<cfset local.productDetail = CreateObject('component', 'cfc.model.Product').init() /> 
				<cfset local.productDetail.getProduct(productId=local.cartLine.getPhone().getProductID()) />
							
				<cfif local.cartline.getCartLineActivationType() contains 'financed'><!---Add financed price to Monthly --->
					<cfif local.cartline.getCartLineActivationType() contains '12'>
						<cfset local.monthlyFinanceTotal = local.monthlyFinanceTotal + local.productDetail.getFinancedMonthlyPrice12() />
					<cfelseif local.cartline.getCartLineActivationType() contains '18'>
						<cfset local.monthlyFinanceTotal = local.monthlyFinanceTotal + local.productDetail.getFinancedMonthlyPrice18() />
					<cfelseif local.cartline.getCartLineActivationType() contains '24'>
						<cfset local.monthlyFinanceTotal = local.monthlyFinanceTotal + local.productDetail.getFinancedMonthlyPrice24() />
					</cfif>
				</cfif>
			</cfloop>
			
			<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.iCartLine">
				<cfset local.cartLine = local.cartLines[local.iCartLine]/>
				<cfset local.imageUrls = []/>
				<cfset local.showAddServiceButton = false/>
				
						<cfif local.cartLine.getPhone().hasBeenSelected()>
							<cfset local.selectedPhone = application.model.phone.getByFilter(idList=local.cartLine.getPhone().getProductID(), 
							                                                                 allowHidden=true)/>
						
							<cfif not local.selectedPhone.recordCount>
								<cfset local.selectedPhone = application.model.tablet.getByFilter(idList=local.cartLine.getPhone().getProductID())/>
							</cfif>
						
							<cfif not local.selectedPhone.recordCount>
								<cfset local.selectedPhone = application.model.dataCardAndNetbook.getByFilter(idList=local.cartLine.getPhone().getProductID())/>
							</cfif>
						
							<cfif not local.selectedPhone.recordCount>
								<cfset local.selectedPhone = application.model.prePaid.getByFilter(idList=local.cartLine.getPhone().getProductID())/>
							</cfif>
						
							<cfset local.deviceGuidList = listAppend(local.deviceGuidList, local.selectedPhone.deviceGuid)/>
							<cfset local.stcPrimaryImage = application.model.imageManager.getPrimaryImagesForProducts(local.selectedPhone.deviceGuid)/>
						
							<cfif structKeyExists(local.stcPrimaryImage, local.selectedPhone.deviceGuid)>
								<cfset imageDetail = {
								                              src=application.view.imageManager.displayImage(imageGuid=local.stcPrimaryImage[local.selectedPhone.deviceGuid], height=0, width=130),
								                              alt=htmlEditFormat(local.selectedPhone.summaryTitle),width=130}/>
							<cfelse>
								<cfset imageDetail = {src='#getAssetPaths().common#images/catalog/noimage.jpg', 
								                              alt=htmlEditFormat(local.selectedPhone.summaryTitle),width=130}/>
							</cfif>
							<cfset arrayAppend(local.imageUrls, imageDetail)/>
						</cfif>
			</cfloop>
		
			<cfset local.selectedAccessories = application.model.cartHelper.lineGetAccessoriesByType(line=request.config.otherItemsLineNumber, 
			                                                                                         type='accessory')/>
			<cfset local.thisPrepaids = application.model.cartHelper.lineGetAccessoriesByType(line=request.config.otherItemsLineNumber, 
			                                                                                  type='prepaid')/>
			<cfset local.deposits = application.model.cartHelper.lineGetAccessoriesByType(line=request.config.otherItemsLineNumber, 
			                                                                              type='deposit')/>
		
			<cfset hasAdditionalItems = arrayLen(local.selectedAccessories) || arrayLen(local.thisPrepaids) 
			                            || arrayLen(local.deposits)>
		
			<cfif hasAdditionalItems>
				<cfset local.imageUrls = []/>
				<cfset local.total_dueToday_other = 0/>
				<cfset local.total_firstBill_other = 0/>
				<cfset local.total_monthly_other = 0/>
								<!--- Prepaid --->
								<cfif arrayLen(local.thisPrepaids)>									
									<cfset local.selectedOtherItems = session.cart.getOtherItems()/>
								
									<cfloop from="1" to="#arrayLen(local.selectedOtherItems)#" index="local.iAccessory">
										<cfset local.thisAccessory = local.selectedOtherItems[local.iAccessory]/>
									
										<cfif local.thisAccessory.getType() is 'prepaid'>
											<cfset local.selectedAccessory = application.model.prepaid.getByFilter(idList=local.thisAccessory.getProductID())/>
										
											<cfif local.selectedAccessory.recordCount>
												<cfset local.stcPrimaryImage = application.model.imageManager.getPrimaryImagesForProducts(local.selectedAccessory.productGuid)/>
												<cfset local.deviceGuidList = listAppend(local.deviceGuidList, 
												                                         local.selectedAccessory.productGuid)/>													
													<cfset local.total_dueToday_other = (local.total_dueToday_other + local.selectedOtherItems[local.iAccessory].getPrices().getDueToday())/>
												
											</cfif>
										</cfif>
									</cfloop>
								</cfif>
							
								<!--- Accessories --->
								<cfif arrayLen(local.selectedAccessories) gt 0>
									<cfloop from="1" to="#arrayLen(local.selectedAccessories)#" index="local.iAccessory">
										<cfset local.thisAccessory = local.selectedAccessories[local.iAccessory]/>
										<cfif local.thisAccessory.getType() is 'accessory'>
											<cfset local.selectedAccessory = application.model.accessory.getByFilter(idList=local.thisAccessory.getProductID())/>
											<cfset local.deviceGuidList = listAppend(local.deviceGuidList, 
											                                         local.selectedAccessory.accessoryGuid)/>
											<cfif local.selectedAccessory.recordCount>
												<cfset local.stcPrimaryImage = application.model.imageManager.getPrimaryImagesForProducts(local.selectedAccessory.accessoryGuid)/>
													<cfset local.total_dueToday_other = (local.total_dueToday_other + local.thisAccessory.getPrices().getDueToday())/>
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
									<cfloop from="1" to="#arrayLen(local.deposits)#" index="local.iItem">
										<cfset local.thisItem = local.deposits[local.iItem]/>
										<cfset local.total_dueToday_other = (local.total_dueToday_other + local.thisItem.getPrices().getDueToday())/>
									</cfloop>
								</cfif>
			</cfif>
			<!--- Summary Table --->
			<div id="summaryDiv" name="summaryDiv" style="width:95%;">
				<div>
						<table class="pricing">
							<tr style="border-bottom:4px solid ##3c5cb2;">
								<td colspan="2">
									Check over the details of your order to confirm accuracy.
								</td>
								<td style="text-align:right">
									<strong>Monthly&nbsp;&nbsp;&nbsp</strong>
								</td>
								<td style="text-align:right;white-space:nowrap">
									<strong>Due Today</strong>
								</td>
							</tr>
							
							<!--- Adjust "due today" for instant rebate(s) --->
							<cfif session.cart.getInstantRebateAmountTotal() gt 0>
								<cfset session.cart.getPrices().setDueToday(session.cart.getPrices().getDueToday() - session.cart.getInstantRebateAmountTotal())/>
							</cfif>
							<!--- Totals for Purchase --->
							<tr style="border-bottom:1px dashed ##8C8B8B;">
								<td style="text-align:left" colspan="2">
									<h3>Totals for Purchase</h3>
								</td>
								<cfif session.cart.hasCart() and listFindNoCase('299, 128', session.cart.getCarrierId()) 
								      and (session.cart.getAddALineType() is 'Ind' or session.cart.getAddALineType() is 'Family')>
									<td>
										<div>
											TBD 
											<sup class="cartReview">
												<a href="##footnote5" style="font-size:8px">
													6
												</a>
											</sup>
										</div>
									</td>
								<cfelse>
									<td style="text-align:right">
										<span class="callout">#dollarFormat((session.cart.getPrices().getMonthly())+ local.monthlyFinanceTotal)#</span>
									</td>
								</cfif>
								<td id="todayGrandTotal" style="text-align:right">
									<span id="todayTotal" class="callout">#dollarFormat(session.cart.getPrices().getDueToday())#</span> 
								</td>
							</tr>
							<!--- Taxes and Shipping --->
							<cfscript>
								/*  shipping fix goes here */
								shipMethodArgs = {CarrierId=session.cart.getCarrierId(), 
								                          IsAfoApoAddress=application.model.CheckoutHelper.getShippingAddress().isApoFpoAddress(),
								                          IsCartEligibleForPromoShipping=false};
							
								if(getChannelConfig().getOfferShippingPromo())
								{
									//Check to see if the cart meets the promo criteria
									shipMethodArgs.IsCartEligibleForPromoShipping = application.model.CartHelper.isCartEligibleForPromoShipping();
								}
							
								local.qShipMethods = application.model.ShipMethod.getShipMethods(argumentCollection=shipMethodArgs);
								
							</cfscript>
							<tr>
								<td style="text-align:left" colspan="2">
									<h3>Taxes and Shipping</h3>
								</td>
								<td style="text-align:right">
									--
								</td>
								<!---<td style="text-align:right">--->
								<td  style="text-align:right">
									<span id="shippingTaxCostDisplay" class="callout"></span>
								</td>
							</tr>
							<tr>
								<td style="text-align:left" colspan="2">
									<div>
										Taxes and Fees 
										<sup class="cartReview">
											<a href="##footnote2" style="font-size:8px">
												2
											</a>
										</sup>
									</div>
								</td>
								<td style="text-align:right">
									--
								</td>
								<td id="todayTaxes" style="text-align:right">
									#dollarFormat(session.cart.getTaxes().getDueToday())#
								</td>
							</tr>
							<tr>
								<td style="text-align:left"> 
									Shipping 
								</td>
								<td style="text-align:left"> 
									<cfif local.qShipMethods.RecordCount eq 1>
										- 
										#local.qShipMethods.DisplayName#
										<input type="hidden" name="shipping" value="#local.qShipMethods.ShipMethodId#"/>
									<cfelse>
										<select name="shipping" id="shippingCostSelect" 
										        onchange="adjustShippingCostsAllVFD('shippingCostSelect');" style="font-size:10px">
											<cfloop query="local.qShipMethods">
												<option price="#DefaultFixedCost#" displayprice="#dollarFormat(DefaultFixedCost)#" 
												        value="#ShipMethodId#">
													#DisplayName# 
													(
													#dollarFormat(DefaultFixedCost)#
													)
												</option>
											</cfloop>
										</select>
									</cfif>
									(Processing can take up to 
									#getChannelConfig().getOrderProcessingTime()# 
									business days 
									<sup class="cartReview">
										<a href="##footnote1" style="font-size:8px">
											1
										</a>
									</sup>
									)
								</td>
								<td style="text-align:right">
									--
								</td>
								<td id="shippingCostDisplay" style="text-align:right">
									#dollarFormat(local.qShipMethods.DefaultFixedCost[1])#
								</td>
							</tr>
							
							<cfset local.total = session.cart.getPrices().getDueToday()/>
							<cfset local.total += session.cart.getTaxes().getDueToday()/>
							<cfset local.total += session.cart.getShipping().getDueToday()/>
						
							<cfset session.totalDueToday = local.total/>
							
							<cfset qry_getRebates = application.model.rebates.getRebates()/>
						
							<cfif qry_getRebates.recordCount>
								<cfparam name="local.newRebateTotal" default="0" type="numeric"/>
								<cfparam name="local.totalAppliedRebates" default="0" type="numeric"/>
								<cfparam name="local.orderRebateGuidList" default="" type="string"/>
							
								<cfloop query="qry_getRebates">
									<cfif application.model.rebates.isCartEligibleForRebate(qry_getRebates.rebateGuid[qry_getRebates.currentRow], 
									                                                        local.deviceGuidList,
									                                                        session.cart.getActivationType()) 
									      and qry_getRebates.type[qry_getRebates.currentRow] is session.cart.getActivationType()>
										<cfset local.orderRebateGuidList = listAppend(local.orderRebateGuidList, 
										                                              qry_getRebates.rebateGuid)/>
										<cfif qry_getRebates.displayType[qry_getRebates.currentRow] is not 'N'>
											<cfset local.newRebateTotal = (local.newRebateTotal + qry_getRebates.amount[qry_getRebates.currentRow])/>
										</cfif>
										<cfset local.totalAppliedRebates = (local.totalAppliedRebates + 1)/>
									
										<cfif trim(qry_getRebates.title[qry_getRebates.currentRow]) is not 'CLICK HERE FOR PRICE'>
											<tr>
												<td class="item-col" style="text-align: right">
													<cfif len(trim(qry_getRebates.url[qry_getRebates.currentRow]))>
														<a href="#trim(qry_getRebates.url[qry_getRebates.currentRow])#" target="_blank">
															Click to Download the 
															#trim(qry_getRebates.title[qry_getRebates.currentRow])# 
															Form
														</a>
													<cfelse>
														#trim(qry_getRebates.title[qry_getRebates.currentRow])#
													</cfif>
												</td>
												<td class="price-col">
												</td>
												<td class="price-col">
													<cfif qry_getRebates.displayType[qry_getRebates.currentRow] is 'N'>
														N/A
													<cfelse>
														<strong>
															- 
															#dollarFormat(qry_getRebates.amount[qry_getRebates.currentRow])#
														</strong>
													</cfif>
												</td>
											</tr>
										<cfelse>
											<cfset local.hideRebateTotal = true/>
										</cfif>
									</cfif>
								</cfloop>
								<cfif local.totalAppliedRebates gt 0 and not structKeyExists(local, 'hideRebateTotal')>
									<cfset session.cart.orderRebateGuidList = local.orderRebateGuidList/>
									<cfset local.totalAfterRebates = (local.total - session.cart.getShipping().getDueToday() 
									                                 - local.newRebateTotal)/>
									<tr>
										<td class="item-col" style="text-align: right">
											<strong>
												Total After Mail-In Rebate
												<cfif local.totalAppliedRebates gt 1>
													s
												</cfif>
											</strong>
										</td>
										<td class="price-col">
										</td>
										<td class="price-col">
											<strong>
												#dollarFormat(local.totalAfterRebates)#
											</strong>
										</td>
									</tr>
								</cfif>
							</cfif>
				</div>
			</div>
			<!--- Summary Table End --->
				
				
			<!--- Repeat wireless table ---->
				
			<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.iCartLine">
				<cfset local.cartLine = local.cartLines[local.iCartLine]/>
				<cfset local.imageUrls = []/>
				<cfset local.showAddServiceButton = false/>
			
				<cfset local.productDetail = CreateObject('component', 'cfc.model.Product').init() /> 
				<cfset local.productDetail.getProduct(productId=local.cartLine.getPhone().getProductID()) /> 
				<div>
					<div>
						<cfif local.cartLine.getPhone().hasBeenSelected()>
							<cfset local.selectedPhone = application.model.phone.getByFilter(idList=local.cartLine.getPhone().getProductID(), 
							                                                                 allowHidden=true)/>
						
							<cfif not local.selectedPhone.recordCount>
								<cfset local.selectedPhone = application.model.tablet.getByFilter(idList=local.cartLine.getPhone().getProductID())/>
							</cfif>
						
							<cfif not local.selectedPhone.recordCount>
								<cfset local.selectedPhone = application.model.dataCardAndNetbook.getByFilter(idList=local.cartLine.getPhone().getProductID())/>
							</cfif>
						
							<cfif not local.selectedPhone.recordCount>
								<cfset local.selectedPhone = application.model.prePaid.getByFilter(idList=local.cartLine.getPhone().getProductID())/>
							</cfif>
						
							<cfset local.deviceGuidList = listAppend(local.deviceGuidList, local.selectedPhone.deviceGuid)/>
							<cfset local.stcPrimaryImage = application.model.imageManager.getPrimaryImagesForProducts(local.selectedPhone.deviceGuid)/>
						
							<cfif structKeyExists(local.stcPrimaryImage, local.selectedPhone.deviceGuid)>
								<cfset imageDetail = {
								                              src=application.view.imageManager.displayImage(imageGuid=local.stcPrimaryImage[local.selectedPhone.deviceGuid], height=0, width=130),
								                              alt=htmlEditFormat(local.selectedPhone.summaryTitle),width=130}/>
							<cfelse>
								<cfset imageDetail = {src='#getAssetPaths().common#images/catalog/noimage.jpg', 
								                              alt=htmlEditFormat(local.selectedPhone.summaryTitle),width=130}/>
							</cfif>
							<cfset arrayAppend(local.imageUrls, imageDetail)/>
						</cfif>
						<div class="no-image">
								<tr style="border-top:1px dashed ##8C8B8B;">
									<td style="text-align:left">
										<h3>Device #local.iCartLine#:</h3>
									</td>
									<td>
										Regular Price: #dollarFormat(local.selectedPhone.financedFullRetailPrice)#
									</td> 								
									<cfif session.cart.hasCart() and listFindNoCase('299, 128', session.cart.getCarrierId()) 
									      and (session.cart.getAddALineType() is 'Ind' or session.cart.getAddALineType() is 'Family')>
										<td c style="text-align:right">
											<div>
												TBD 
												<sup class="cartReview">
													<a href="##footnote5" style="font-size:8px">
														6
													</a>
												</sup>
											</div>
										</td>
									<cfelse>
										<td style="text-align:right">	
											<cfif local.cartline.getCartLineActivationType() contains 'financed'><!---Add financed price to Monthly --->
												<cfif local.cartline.getCartLineActivationType() contains '12'>
													<span class="callout">#dollarFormat((local.cartline.getPrices().getMonthly())+local.productDetail.getFinancedMonthlyPrice12())#</span>
												<cfelseif local.cartline.getCartLineActivationType() contains '18'>
													<span class="callout">#dollarFormat((local.cartline.getPrices().getMonthly())+local.productDetail.getFinancedMonthlyPrice18())#</span>
												<cfelseif local.cartline.getCartLineActivationType() contains '24'>
													<span class="callout">#dollarFormat((local.cartline.getPrices().getMonthly())+local.productDetail.getFinancedMonthlyPrice24())#</span>
												</cfif>
											<cfelse>
												<span class="callout">#dollarFormat(local.cartline.getPrices().getMonthly())#</span>
											</cfif>
										</td>
									</cfif>
									<td style="text-align:right">
										<span class="callout">#dollarFormat(local.cartline.getPrices().getDueToday())#</span>
									</td>
								</tr>								
								<cfif local.cartLine.getPhone().hasBeenSelected()>
									<tr>
										<td style="text-align:left">
											Device:
										</td>
										<td> 
											#local.selectedPhone.summaryTitle# #local.cartline.getCartLineActivationType()#
										</td>
										<td style="text-align:right"><!---If financed display monthly price --->
											<cfif local.cartline.getCartLineActivationType() contains 'financed'>
												<cfif local.cartline.getCartLineActivationType() contains '12'>
													#dollarFormat(local.productDetail.getFinancedMonthlyPrice12())#
												<cfelseif local.cartline.getCartLineActivationType() contains '18'>
													#dollarFormat(local.productDetail.getFinancedMonthlyPrice18())#
												<cfelseif local.cartline.getCartLineActivationType() contains '24'>
													#dollarFormat(local.productDetail.getFinancedMonthlyPrice24())# 
												</cfif>
											<cfelse>
												--
											</cfif>
										</td>
										<td style="text-align:right">
										<cfif local.cartline.getCartLineActivationType() contains 'financed'>	
											--
										<cfelse>
											#dollarFormat(local.selectedPhone.price_retail)#
										</cfif>	
										</td>
									</tr>
								
								<cfif local.cartline.getCartLineActivationType() does not contain 'financed'>	
									<cfif (val(local.selectedPhone.price_retail) - val(local.cartLine.getPhone().getPrices().getDueToday())) gt 0>
									<tr>
										<td style="text-align:left">
											Discount:
										</td>
										<td> 
											Online
										</td>
										<td style="text-align:right">
											--
										</td>
										<td style="text-align:right">
											<span class="callout">
											-
											#dollarFormat(val(local.selectedPhone.price_retail) - val(local.cartLine.getPhone().getPrices().getDueToday()))#
										</td>
									</tr>
									</cfif>
								</cfif>	
								<cfelse>
									<cfset local.thisDo = 'browsePhones'/>
									<cfif session.cart.getPrepaid()>
										<cfset local.thisDo = 'browsePrePaids'/>
									</cfif>
									<cfset local.linkChange = getLink(lineNumber=local.iCartLine, do=local.thisDo)/>
									<tr>
										<td>
											Please select a device for this line.
											<br/>
											<a class="hideWhenPrinted" href="#local.linkChange#">
												Browse Phones
											</a>
										</td>
										<td>
										</td>
										<td>
										</td>
									</tr>
								</cfif>
							
								<cfset local.lineBundledAccessories = application.model.cartHelper.lineGetAccessoriesByType(line=local.iCartLine, 
								                                                                                                type='bundled')/>
							
								<cfif arrayLen(local.lineBundledAccessories)>
									<cfloop from="1" to="#arrayLen(local.lineBundledAccessories)#" index="local.iAccessory">
										<cfset local.thisAccessory = local.lineBundledAccessories[local.iAccessory]/>
										<cfset local.selectedAccessory = application.model.accessory.getByFilter(idList=local.thisAccessory.getProductID())/>
										<cfset local.stcPrimaryImage = application.model.imageManager.getPrimaryImagesForProducts(local.selectedAccessory.accessoryGuid)/>
										<cfset local.deviceGuidList = listAppend(local.deviceGuidList, 
										                                         local.selectedAccessory.accessoryGuid)/>
									
										<cfif structKeyExists(local.stcPrimaryImage, local.selectedAccessory.accessoryGuid)>
											<cfset imageDetail = {
											                                 src=application.view.imageManager.displayImage(imageGuid=local.stcPrimaryImage[local.selectedAccessory.accessoryGuid], height=0, width=75),
											                                 alt=htmlEditFormat(local.selectedAccessory.summaryTitle),
											                                 width=75}/>
										<cfelse>
											<cfset imageDetail = {src='#getAssetPaths().common#images/catalog/noimage.jpg', 
											                                 alt=htmlEditFormat(local.selectedAccessory.summaryTitle),
											                                 width=75}/>
										</cfif>
										<cfset arrayAppend(local.imageUrls, imageDetail)/>
									
										<tr>
											<td style="text-align:left">
												Membership Benefit: 
											</td>
											<td>
												#local.selectedAccessory.summaryTitle#
											</td>
											<td style="text-align:right">
												--
											</td>
											<td style="text-align:right">
												<cfif local.thisAccessory.getPrices().getDueToday() EQ 0>
														FREE
												</cfif>
											</td>
										</tr>
									</cfloop>
								</cfif>
							
								<cfif session.cart.getUpgradeType() neq 'equipment-only' && not session.cart.getPrePaid() 
								      && session.cart.getAddALineType() neq 'family' && session.cart.getActivationType() 
								      neq 'nocontract'>
								
									<tr>
										<cfif local.cartLine.getPlan().hasBeenSelected()>
											<cfset local.selectedPlan = application.model.plan.getByFilter(idList=local.cartLine.getPlan().getProductID())/>
											<cfset local.deviceGuidList = listAppend(local.deviceGuidList, 
											                                         local.selectedPlan.productGuid)/>
										
											<td style="text-align:left">
												Plan: 
											</td>
											<td>
												#local.selectedPlan.carrierName# 
												- 
												#local.selectedPlan.summaryTitle#
											</td>
											<cfif session.cart.hasCart() and listFindNoCase('299, 128', session.cart.getCarrierId()) 
											      and (session.cart.getAddALineType() is 'Ind' or session.cart.getAddALineType() is 'Family')>
												<td style="text-align:right">
													TBD 
													<sup class="cartReview">
													<a href="##footnote5" style="font-size:8px">
														6
													</a>
												</td>
											<cfelse>
												<cfif DecimalFormat(local.cartLine.getPlan().getPrices().getMonthly()) eq 0>
													<td style="text-align:right">
														--
													</td>
												<cfelse>
													<td style="text-align:right">
														#dollarFormat(local.cartLine.getPlan().getPrices().getMonthly())#
													</td>
												</cfif>
											</cfif>
											<cfif session.cart.hasCart() and listFindNoCase('299, 128', session.cart.getCarrierId()) 
											      and (session.cart.getAddALineType() is 'Ind' or session.cart.getAddALineType() is 'Family')>
												<td style="text-align:right">
													TBD 
													<sup class="cartReview">
														<a href="##footnote5" style="font-size:8px">
															6
														</a>
													</sup>
												</td>
											<cfelse>
												<td style="text-align:right">
													--
												</td>
											</cfif>
										<cfelse>
											<cfset local.linkChange = getLink(lineNumber=local.iCartLine, do='browsePlans')/>
										
											<td class="error-col">
												Please select a service plan for this line.
												<br/>
												<a class="hideWhenPrinted" href="#local.linkChange#">
													Browse Service Plans
												</a>
											</td>
											<td style="text-align:right">
											</td>
											<td style="text-align:right">
											</td>
										</cfif>
									</tr>
									
									<cfif local.iCartLine eq 1 && ArrayLen(session.cart.getSharedFeatures())>
										<cfloop array="#session.cart.getSharedFeatures()#" index="cartItem">
											<cfset qFeature = application.model.feature.getByProductID(cartItem.getProductId())/>
											<cfif NOT findNoCase("Family", qFeature.summaryTitle)>
												<tr>
													<td style="text-align:left" colspan="2">
														<span>
															#qFeature.summaryTitle#
														</span>
													</td>
													<td style="text-align:right">
														#dollarFormat(qFeature.Price)#
													</td>
													<td style="text-align:right">
													</td>
												</tr>
											</cfif>
										</cfloop>
									</cfif>
								
									<!--- moving hard-coded upgrade fees to carrier component and calling them from here  --->
									<cfset local.carrierObj = application.wirebox.getInstance("Carrier")/>
								
									<cfif local.cartLine.getPlan().hasBeenSelected()>
										<!---- Upgrades do not have the activation fee waived --->
										<cfif session.cart.getActivationType() CONTAINS 'upgrade'>
										
											<cfset local.upgradeFee = local.carrierObj.getUpgradeFee(session.cart.getCarrierID())>
										
											<tr>
												<td style="text-align:left">
													<span>
														Upgrade Fee of 
												</td>
												<td>
														<cfif local.upgradeFee>
															$
															#local.upgradeFee#
														<cfelse>
															$18.00
														</cfif>
														*
													</span>
												</td>
												<td>
												</td>
												<td>
												</td>
											</tr>
										<cfelse>
											<cfset local.activationFee = local.carrierObj.getActivationFee(session.cart.getCarrierID())>
											<cfif listFind(request.config.activationFeeWavedByCarrier, session.cart.getCarrierId())>
												<tr>
													<td style="text-align:left" colspan="2">
														<span>
															Activation Fee: 
															</td>
															<td>
																Free
															<span class="activationFeeDisclaimer">
																(
																<a href="##" class="activationFeeExplanation" 
																   onclick="viewActivationFeeInWindow('activationFeeWindow', 'Activation Fee Details', '/index.cfm/go/cart/do/explainActivationFee/carrierId/#session.cart.getCarrierId()#');return false;">
																	#dollarFormat(local.cartLine.getActivationFee().getPrices().getFirstBill())#
																</a>
																refunded by 
																<cfif isDefined('local.selectedPlan.carrierID') and local.selectedPlan.carrierID 
																      eq 42>
																	Wireless Advocates, LLC
																<cfelse>
																	your carrier
																</cfif>
																- see details below 
																<sup class="cartReview">
																	<a href="##footnote4" style="font-size:8px">
																		4
																	</a>
																</sup>
																)
															</span>
														</span>
													</td>
													<td style="text-align:right">
														--
													</td>
													<td style="text-align:right">
														--
													</td>
												</tr>
											<cfelse>
												<tr>
													<td style="text-align:left">
														<span>
															Activation Fee:
														</td>
														<td>
															<span class="activationFeeDisclaimer">
																(
																#dollarFormat(local.activationFee)# 
																- see details below 
																<sup class="cartReview">
																	<a href="##footnote4" style="font-size:8px">
																		4
																	</a>
																</sup>
																)
															</span>
														</span>
													</td>
													<td style="text-align:right">
														--
													</td>
													<td style="text-align:right">
														--
													</td>
												</tr>
											</cfif>
										</cfif>
									</cfif>
								
									<cfset local.lineFeatures = local.cartLine.getFeatures()/>
								
									<cfloop from="1" to="#arrayLen(local.lineFeatures)#" index="local.iFeature">
										<cfset local.thisFeatureID = local.lineFeatures[local.iFeature].getProductID()/>
										<cfset local.thisFeature = application.model.feature.getByProductID(local.thisFeatureID)/>
										<cfset local.deviceGuidList = listAppend(local.deviceGuidList, 
										                                         local.thisFeature.serviceGuid)/>
										<cfset local.thisServiceRecommended = false/>
									
										<!--- Check if service is recommended --->
										<cfif qRecommendedServices.RecordCount>
											<cfloop query="qRecommendedServices">
												<cfif qRecommendedServices.productId eq local.thisFeatureId>
													<cfset local.thisServiceRecommended = true/>
													<cfbreak/>
												</cfif>
											</cfloop>
										</cfif>
									
										<tr>
											<td style="text-align:left">
												Data: 
											</td>
											<td>
												#local.thisFeature.summaryTitle# 
													<cfif local.thisServiceRecommended AND NOT local.thisFeature.hidemessage>
														<span class="recommended">
															Best Value
														</span>
													</cfif>
											</td>
											<td style="text-align:right">
												<cfif (local.cartline.getCartLineActivationType() CONTAINS 'finance') and (len(local.thisFeature.financedPrice))><!---Is a financed phone with a Financed Price--->
													#dollarFormat(local.thisFeature.financedPrice)#
												<cfelse>
													#dollarFormat(local.lineFeatures[local.iFeature].getPrices().getMonthly())#
												</cfif>
												<cfif (local.cartline.getCartLineActivationType() CONTAINS 'finance') and (session.cart.getCarrierId() eq 299)>
													<sup class="cartReview">
														<a href="##footnote4" style="font-size:8px">
															7
														</a>
													</sup>
												</cfif>
											</td>
											<td style="text-align:right">
												--
											</td>
										</tr>
									</cfloop>
								
									<cfif local.cartLine.getPhone().hasBeenSelected() and local.cartLine.getPlan().hasBeenSelected()>
										<cfset local.requiredServices = application.model.serviceManager.getDevicePlanMinimumRequiredServices(local.cartLine.getPhone().getProductID(), 
										                                                                                                      local.cartLine.getPlan().getProductID(),
										                                                                                                      application.model.cart.getCartTypeId(session.cart.getActivationType()),
										                                                                                                      session.cart.getSharedFeatures())/>
										<cfset local.linkChange = getLink(lineNumber=local.iCartLine, do='planSelectServices')/>
										<cfset local.linkAddFeatures = getLink(lineNumber=local.iCartLine, do='planSelectServices')/>
										<cfset local.showAddServiceButton = true/>
									
										<cfif application.model.CartHelper.isLineMissingRequiredFeatures(local.requiredServices, 
										                                                                 local.cartLine.getFeatures())>
											<tr style="text-align:right">
												<td class="error-col" colspan="2">
													Missing required service
													<br/>
													<a class="hideWhenPrinted" href="#local.linkChange#">
														Select Services
													</a>
												</td>
												<td>
													&nbsp;
												</td>
												<td>
													&nbsp;
												</td>
											</tr>
										<cfelse>
										</cfif>
									</cfif>
								</cfif>
							
								<cfif session.cart.hasCart() and session.cart.getActivationType() CONTAINS 'upgrade' and session.cart.getUpgradeType() 
								      is 'equipment-only'>
									<cfset local.lineFeatures = local.cartLine.getFeatures()/>
									<cfif local.cartline.getCartLineActivationType() DOES NOT CONTAIN 'finance'>
										<tr>
											<td style="text-align:left">
												Required Services:
											</td>
											<td> (
												<em>
													2-Year Contract Renewal
												</em>
												)
											</td>
											<td>
											</td>
											<td>
											</td>
										</tr>
									</cfif>
									
									<cfloop from="1" to="#arrayLen(local.lineFeatures)#" index="local.iFeature">
										<cfset local.thisFeatureID = local.lineFeatures[local.iFeature].getProductID()/>
										<cfset local.thisServiceRecommended = false/>
									
										<cfset local.thisFeature = application.model.feature.getByProductID(local.thisFeatureID)/>
										<cfset local.featureTitle = local.thisFeature.summaryTitle/>
										<cfset local.deviceGuidList = listAppend(local.deviceGuidList, 
										                                         local.thisFeature.serviceGuid)/>
									
										<!--- Check if service is recommended --->
										<cfif qRecommendedServices.RecordCount>
											<cfloop query="qRecommendedServices">
												<cfif qRecommendedServices.productId eq local.thisFeatureId>
													<cfset local.thisServiceRecommended = true/>
													<cfbreak/>
												</cfif>
											</cfloop>
										</cfif>
									
										<tr>
											<td style="text-align:left" colspan="2">
												<span>
													#trim(local.featureTitle)#
													<cfif local.thisServiceRecommended AND NOT local.thisFeature.hidemessage>
														<span class="recommended">
															Best Value
														</span>
													</cfif>
												</span>
											</td>
											<td style="text-align:right">
												#dollarFormat(local.lineFeatures[local.iFeature].getPrices().getMonthly())#
											</td>
											<td style="text-align:right">
												&nbsp;
											</td>
										</tr>
									</cfloop>
								</cfif>
							
								<cfif session.cart.hasCart() and session.cart.getAddALineType() is 'family'>
								
									<cfset local.showAddServiceButton = true/>
									<cfset local.linkAddFeatures = getLink(lineNumber=local.iCartLine, do='services')/>
								
									<tr>
										<td style="text-align:left" colspan="2">
											Rateplan
										</td>
										<td>
										</td>
										<td>
										</td>
									</tr>
									<cfif listFind(request.config.activationFeeWavedByCarrier, session.cart.getCarrierId())>
										<tr>
											<td style="text-align:left" colspan="2">
												<span>
													Free Activation Fee
													<span class="activationFeeDisclaimer">
														(Refunded by 
														<cfif session.cart.getCarrierId() eq 42>
															Wireless Advocates, LLC
														<cfelse>
															your carrier
														</cfif>
														- see details below 
														<sup class="cartReview">
															<a href="##footnote4" style="font-size:8px">
																4
															</a>
														</sup>
														)
													</span>
												</span>
											</td>
											<td>
											</td>
											<td>
											</td>
										</tr>
									<cfelse>
										<tr>
											<td style="text-align:left" colspan="2">
												<span>
													Activation Fee
													<span class="activationFeeDisclaimer">
														(see details below 
														<sup class="cartReview">
															<a href="##footnote4" style="font-size:8px">
																4
															</a>
														</sup>
														)
													</span>
												</span>
											</td>
											<td>
											</td>
											<td>
											</td>
										</tr>
									</cfif>
									<tr>
										<td style="text-align:left" colspan="2">
											<span>
												Add a Line Fee
											</span>
										</td>
										<td>
											<div>
												TBD 
												<sup class="cartReview">
													<a href="##footnote5" style="font-size:8px">
														6
													</a>
												</sup>
											</div>
										</td>
										<td>
										</td>
									</tr>
									
									<cfset local.lineFeatures = local.cartLine.getFeatures()/>
								
									<tr>
										<td style="text-align:left" colspan="2">
											Services
										</td>
										<td>
										</td>
										<td>
										</td>
									</tr>
									
									<cfloop from="1" to="#arrayLen(local.lineFeatures)#" index="local.iFeature">
										<cfset local.thisFeatureID = local.lineFeatures[local.iFeature].getProductID()/>
										<cfset local.thisFeature = application.model.feature.getByProductID(local.thisFeatureID)/>
										<cfset local.deviceGuidList = listAppend(local.deviceGuidList, 
										                                         local.thisFeature.serviceGuid)/>
										<cfset local.thisServiceRecommended = false/>
									
										<!--- Check if service is recommended --->
										<cfif qRecommendedServices.RecordCount>
											<cfloop query="qRecommendedServices">
												<cfif qRecommendedServices.productId eq local.thisFeatureId>
													<cfset local.thisServiceRecommended = true/>
													<cfbreak/>
												</cfif>
											</cfloop>
										</cfif>
									
										<tr>
											<td style="text-align:left" colspan="2">
												<span>
													#trim(local.thisFeature.summaryTitle)#
													<cfif local.thisServiceRecommended AND NOT local.thisFeature.hidemessage>
														<span class="recommended">
															Best Value
														</span>
													</cfif>
												</span>
											</td>
											<td style="text-align:right">
												#dollarFormat(local.lineFeatures[local.iFeature].getPrices().getMonthly())#
											</td>
											<td>
											</td>
										</tr>
									</cfloop>
								
									<cfset local.requiredServices = application.model.serviceManager.getDeviceMinimumRequiredServices(ProductId=local.cartLine.getPhone().getProductID(), 
									                                                                                                  CartTypeId=application.model.cart.getCartTypeId(session.cart.getActivationType()),
									                                                                                                  HasSharedPlan=session.cart.getHasSharedPlan())/>
								
									<cfif application.model.CartHelper.isLineMissingRequiredFeatures(local.requiredServices, 
									                                                                 local.cartLine.getFeatures())>
										<tr>
											<td class="error-col" colspan="2">
												Missing required service
												<br/>
												<a class="hideWhenPrinted" 
												   href="/index.cfm/go/shop/do/services/cartCurrentLine/#local.iCartLine#">
													Select Services
												</a>
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
										</tr>
									<cfelse>
									</cfif>
								</cfif>
							
								<!--- Line Accessories --->
								<cfif arrayLen(local.cartLine.getAccessories())>
									<cfset local.selectedAccessories = application.model.cartHelper.lineGetAccessoriesByType(line=local.iCartLine, 
									                                                                                         type='accessory')/>
								
									<cfloop from="1" to="#arrayLen(local.selectedAccessories)#" index="local.iAccessory">
										<cfset local.thisAccessory = local.selectedAccessories[local.iAccessory]/>
										<cfset local.selectedAccessory = application.model.accessory.getByFilter(idList=local.thisAccessory.getProductID())/>
										<cfset local.stcPrimaryImage = application.model.imageManager.getPrimaryImagesForProducts(local.selectedAccessory.accessoryGuid)/>
										<cfset local.deviceGuidList = listAppend(local.deviceGuidList, 
										                                         local.selectedAccessory.accessoryGuid)/>
									
										<cfif structKeyExists(local.stcPrimaryImage, local.selectedAccessory.accessoryGuid)>
											<cfset imageDetail = {
											                                 src=application.view.imageManager.displayImage(imageGuid=local.stcPrimaryImage[local.selectedAccessory.accessoryGuid], height=0, width=75),
											                                 alt=htmlEditFormat(local.selectedAccessory.summaryTitle),
											                                 width=75}/>
										<cfelse>
											<cfset imageDetail = {src='#getAssetPaths().common#images/catalog/noimage.jpg', 
											                                 alt=htmlEditFormat(local.selectedAccessory.summaryTitle),
											                                 width=75}/>
										</cfif>
										<cfset arrayAppend(local.imageUrls, imageDetail)/>
									
										<tr>
											<td style="text-align:left">
												Accessory: 
											</td>
											<td>
												#local.selectedAccessory.summaryTitle#
											</td>
											<td style="text-align:right">
												--
											</td>
											<td style="text-align:right">
												#dollarFormat(local.selectedAccessories[local.iAccessory].getPrices().getDueToday())#
											</td>
										</tr>
									</cfloop>
								<cfelse>
									<tr>
										<cfset local.linkChange = getLink(lineNumber=local.iCartLine, do='browseAccessories')/>
									</tr>
								</cfif>
							
								<!--- Line warranty --->
								<cfif getChannelConfig().getOfferWarrantyPlan()>
									<cfif local.cartLine.getWarranty().hasBeenSelected()>
										<cfset local.selectedWarranty = application.model.Warranty.getById(local.cartLine.getWarranty().getProductId())/>
										<tr>
											<td style="text-align:left">
												Protection: 
											</td>
											<td>
												#local.cartLine.getWarranty().getTitle()#
											</td>
											<td style="text-align:right">
												--
											</td>
											<td style="text-align:right">
												#dollarFormat(local.cartLine.getWarranty().getPrices().getDueToday())#
											</td>
										</tr>
									<cfelse>
									</cfif>
								</cfif>
							
								<!--- Instant MIR --->
								<cfif local.cartLine.getInstantRebateAmount() gt 0>
									<cfset local.cartLine.getPrices().setDueToday(local.cartLine.getPrices().getDueToday() - local.cartLine.getInstantRebateAmount())>
									<tr>
										<td style="text-align:left" colspan="2">
											Instant Rebate: 
											<span class="callout">
												You qualified to convert the mail-in rebate to an instant online rebate!
											</span>
										</td>
										<td style="text-align:right">
											&nbsp;
										</td>
										<td style="text-align:right">
											<span class="callout">
												-
												#dollarFormat(local.cartLine.getInstantRebateAmount())#
											</span>
										</td>
									</tr>
								</cfif>
						</div>
					</div>
					
					<div style="clear:both;">
					</div>
				</div>
			</cfloop>	
			<!--- End Repeat Wireless --->
			<cfset local.selectedAccessories = application.model.cartHelper.lineGetAccessoriesByType(line=request.config.otherItemsLineNumber, 
			                                                                                         type='accessory')/>
			<cfset local.thisPrepaids = application.model.cartHelper.lineGetAccessoriesByType(line=request.config.otherItemsLineNumber, 
			                                                                                  type='prepaid')/>
			<cfset local.deposits = application.model.cartHelper.lineGetAccessoriesByType(line=request.config.otherItemsLineNumber, 
			                                                                              type='deposit')/>
		
			<cfset hasAdditionalItems = arrayLen(local.selectedAccessories) || arrayLen(local.thisPrepaids) 
			                            || arrayLen(local.deposits)>				
				
			<!--- Repeat Additional Items --->
			<cfif hasAdditionalItems>
				<cfset local.imageUrls = []/>
				<!---<cfset local.total_dueToday_other = 0/>--->
				<cfset local.total_firstBill_other = 0/>
				<cfset local.total_monthly_other = 0/>
				<div>														
								<!--- Accessories --->
								<cfif arrayLen(local.selectedAccessories) gt 0>
									<tr style="border-top:1px dashed ##8C8B8B;">
										<td style="text-align:left" colspan="2">
											<h3>Accessories </h3>
										</td>
										<td style="text-align:right">
											<span class="callout">NA</span>
										</td>
										<td style="text-align:right">
											<span class="callout">#dollarFormat(local.total_dueToday_other)#</span>
										</td>
									</tr>
									<cfloop from="1" to="#arrayLen(local.selectedAccessories)#" index="local.iAccessory">
										<cfset local.thisAccessory = local.selectedAccessories[local.iAccessory]/>
									
										<cfif local.thisAccessory.getType() is 'accessory'>
											<cfset local.selectedAccessory = application.model.accessory.getByFilter(idList=local.thisAccessory.getProductID())/>
											<cfset local.deviceGuidList = listAppend(local.deviceGuidList, 
											                                         local.selectedAccessory.accessoryGuid)/>
											<cfif local.selectedAccessory.recordCount>
												<cfset local.stcPrimaryImage = application.model.imageManager.getPrimaryImagesForProducts(local.selectedAccessory.accessoryGuid)/>
											
												<cfif structKeyExists(local.stcPrimaryImage, local.selectedAccessory.accessoryGuid)>
													<cfset imageDetail = {
													                                   src=application.view.imageManager.displayImage(imageGuid=local.stcPrimaryImage[local.selectedAccessory.accessoryGuid], height=0, width=130),
													                                   alt=htmlEditFormat(local.selectedAccessory.summaryTitle),
													                                   width=130}/>
												<cfelse>
													<cfset imageDetail = {src='#getAssetPaths().common#images/catalog/noimage.jpg', 
													                                   alt=htmlEditFormat(local.selectedAccessory.summaryTitle),
													                                   width=130}/>
												</cfif>
												<cfset arrayAppend(local.imageUrls, imageDetail)/>
											
												<tr>
													<td colspan="2">
														#local.selectedAccessory.summaryTitle#
													</td>
													<td style="text-align:right">
														&nbsp;
													</td>
													<td style="text-align:right">
														#dollarFormat(local.thisAccessory.getPrices().getDueToday())#
													</td>
													<!---<cfset local.total_dueToday_other = (local.total_dueToday_other + local.thisAccessory.getPrices().getDueToday())/>--->
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
							</table>
							<hr size="2" Color="##0a94d6">		
			<cfelse>
					</table>
					<hr size="2" Color="##0a94d6">
			</cfif>
			</div>
			<!--- End Repeat Additional Items --->
			
			
			
			
			
			<cfif session.cart.hasCart()>
				<cfset local.thisCarrier = application.model.carrier.getByCarrierId(session.cart.getCarrierId())/>
			
				<cfif session.cart.getActivationType() CONTAINS 'upgrade'>
				
					<!--- removing hard-coded upgrade fees and adding result from call to carrier component made 
					earlier in this method  --->
					<cfif NOT structKeyExists(local, 'upgradeFee')>
						<cfset local.carrierObj = application.wirebox.getInstance("Carrier")/>
						<cfset local.upgradeFee = local.carrierObj.getUpgradeFee(session.cart.getCarrierID())>
					</cfif>
				
					<span class="note">
						<sup class="cartReview">
							*
						</sup>
						An Upgrade Fee of $
						#local.upgradeFee# 
						applies to each Upgrade Line.
						<cfif session.cart.getCarrierId() neq 299>
							This fee will appear on your next billing statement
							<cfif session.cart.getCarrierId() eq 299>
								and will be refunded to your account within three billing cycles
							</cfif>
							.
						</cfif><!--- remove for Sprint --->
					</span>
					<br/>
				</cfif>
			
				<span class="note">
					<sup class="cartReview">
						<a name="footnote1" style="font-size:8px">
							1
						</a>
					</sup>
					Orders can take up to 
					#getChannelConfig().getOrderProcessingTime()# 
					business days to process before shipping. 
				</span>
				<br/>
				<cfset local.cartZipcode = ''/>
			
				<cfif application.model.cartHelper.zipCodeEntered()>
					<cfset local.cartZipCode = session.cart.getZipCode()/>
				</cfif>
			
				<span class="note">
					<sup class="cartReview">
						<a name="footnote2" style="font-size:8px">
							2
						</a>
					</sup>
					In accordance with the tax laws in certain
					states and jurisdictions, including but not limited to California, the tax charged may be based 
					on an
					amount higher than the retail price of the purchase. California sales tax is calculated in 
					accordance
					with Sales and Use Tax Regulation 1585. Taxes and fees estimated and based on zip code (
					#trim(local.cartZipcode)#
					)
					entered earlier and the service plan you selected. Actual fees will be determined by your 
					wireless carrier.
				</span>
				<br/>
			
				<cfif session.cart.getActivationType() DOES NOT CONTAIN 'upgrade'>
					<cfif listFind(request.config.activationFeeWavedByCarrier, session.cart.getCarrierId())>
						<span class="note">
							<sup class="cartReview">
								<a name="footnote4" style="font-size:8px">
									4
								</a>
							</sup>
							<cfif listFindNoCase('109, 128', session.cart.getCarrierId())>
								#local.thisCarrier.companyName# 
								activation fees will be refunded through a Bill Credit on all
								qualifying activations.
							<cfelseif listFindNoCase('299', session.cart.getCarrierId())>
								Activation fee credit will be applied in the first bill cycle and refunded to your account 
								within three billing cycles.
							<cfelseif session.cart.getCarrierId() eq 42>
								Customers will receive a mail-in rebate from Wireless Advocates to reimburse the activation 
								fee
								on a new single line and/or Family Share 2-year 
								#local.thisCarrier.companyName# 
								service agreement.
								Upgrades do not qualify for this credit.
							</cfif>
							Please 
							<a href="##" 
							   onclick="viewActivationFeeInWindow('activationFeeWindow', 'Activation Fee Details', '/index.cfm/go/cart/do/explainActivationFee/carrierId/#session.cart.getCarrierId()#');return false;">
								click here
							</a>
							for details.
						</span>
						<br/>
					<cfelse>
						<span class="note">
							<sup class="cartReview">
								<a name="footnote4" style="font-size:8px">
									4
								</a>
							</sup>
							Activation Fee will be applied to the first bill cycle.
						</span>
						<br/>
					</cfif>
				</cfif>
			
				<!---                    <span class="note">
				                            <sup class="cartReview"><a name="footnote5">5</a></sup>
				                            This is a summary of your monthly access charges. It does not 
				include taxes, surcharges, fees, usage
				                            charges, discounts or credits. The actual amounts billed by your 
				carrier will vary based upon your usage.
				                        </span>--->
				<cfif session.cart.hasCart() and (session.cart.getAddALineType() is 'Ind' or session.cart.getAddALineType() 
				      is 'Family')>
					<span class="note">
						<sup class="cartReview">
							<a name="footnote5" style="font-size:8px">
								6
							</a>
						</sup>
						Add-a-line charge varies based on current plan and service selections. New 2 year agreement 
						may be required on all lines.
					</span>
					<br/>
				</cfif>
				<cfif (session.cart.getCarrierId() eq 299) AND (local.cartline.getCartLineActivationType() CONTAINS 'finance')>
					<span class="note">
						<sup class="cartReview">
							<a name="footnote7" style="font-size:8px">
								7
							</a>
						</sup>
						For data packages 8GB and higher, you may see a $10 discount on your line access fee from Sprint.  
						In certain cases  for your higher data packages your line access fee may be waived.  Contact Sprint for more details.
					</span>
					<br/>
				</cfif>
				<script language="javascript" type="text/javascript" 
				        src="#getAssetPaths().common#scripts/cartReviewActivationFeeWindow.js">

				</script>
			</cfif>
			<script type="text/javascript" language="javascript" 
			        src="#getAssetPaths().common#scripts/planFeatureWindow.js">

			</script>
			
			</form>

			<div id="buttonDiv" name="buttonDiv" class="formControl">
				<a href="##" onclick="window.location.href = '#event.buildLink('checkoutVFD.billShip')#'">Back</a>
				<a class="progressBtn" href="##" onclick="javascript: {var ok=confirm('This is the last chance to make any changes to your order.  Once payment is collected the transaction is final.'); if(ok){showProgress('Updating order.'); $j('##reviewOrder').submit(); }}"><span>Continue</span></a>
			</div>
		</cfoutput>
	<cfelse>
		<cfoutput>
			<hr/>Your cart is currently empty.
			<hr/>
		</cfoutput>
	</cfif>
</div>
<!---</cfsavecontent>--->
<!---<cfreturn trim(local.html) />--->


<cffunction name="getLink" access="public" returntype="string" output="false">
	<cfargument name="lineNumber" type="numeric" required="true"/>
	<cfargument name="do" type="string" required="false" default="browsePhones"/>
	<cfargument name="productID" type="string" required="false" default="0"/>
	<cfargument name="cartLines" type="array" required="false" default="#arrayNew(1)#"/>

	<cfset var local = structNew()/>

	<cfset local.planType = session.cart.getActivationType()/>
	<cfset local.href = ''/>

	<cfif arguments.lineNumber neq request.config.otherItemsLineNumber>
		<cfif not arrayLen(arguments.cartLines)>
			<cfset local.cartLines = session.cart.getLines()/>
		<cfelse>
			<cfset local.cartLines = arguments.cartLines/>
		</cfif>
	
		<cfset local.thisLine = local.cartLines[arguments.lineNumber]/>
		<cfset local.href = '/cartCurrentLine/' & arguments.lineNumber/>
	
		<cfif arguments.do is 'browsePhones'>
			<cfif local.thisLine.getPlan().hasBeenSelected()>
				<!--- Select Filter ID by Device Carrier --->
				<cfquery name="qry_getCarrierId" datasource="#application.dsn.wirelessAdvocates#">
					SELECT	p.carrierId
					FROM	catalog.dn_plans AS p WITH (NOLOCK)
					WHERE	p.productId	=<cfqueryparam value="#local.thisLine.getPlan().getProductId()#" 
				              cfsqltype="cf_sql_integer"/>
				</cfquery>
			
				<cfif qry_getCarrierId.recordCount>
					<cfif qry_getCarrierId.carrierId eq 109>
						<cfset local.href = local.href & '/cID/1/which/' & arguments.do & '/'/>
					<cfelseif qry_getCarrierId.carrierId eq 128>
						<cfset local.href = local.href & '/cID/2/which/' & arguments.do & '/'/>
					<cfelseif qry_getCarrierId.carrierId eq 42>
						<cfset local.href = local.href & '/cID/3/which/' & arguments.do & '/'/>
					<cfelseif qry_getCarrierId.carrierId eq 299>
						<cfset local.href = local.href & '/cID/230/which/' & arguments.do & '/'/>
					</cfif>
				</cfif>
			</cfif>
		<cfelseif arguments.do is 'browseTablets'>
			<cfif local.thisLine.getPlan().hasBeenSelected()>
				<!--- Select Filter ID by Device Carrier --->
				<cfquery name="qry_getCarrierId" datasource="#application.dsn.wirelessAdvocates#">
					SELECT	p.carrierId
					FROM	catalog.dn_plans AS p WITH (NOLOCK)
					WHERE	p.productId	=<cfqueryparam value="#local.thisLine.getPlan().getProductId()#" 
				              cfsqltype="cf_sql_integer"/>
				</cfquery>
			
				<cfif qry_getCarrierId.recordCount>
					<cfif qry_getCarrierId.carrierId eq 109>
						<cfset local.href = local.href & '/cID/1/which/' & arguments.do & '/'/>
					<cfelseif qry_getCarrierId.carrierId eq 128>
						<cfset local.href = local.href & '/cID/2/which/' & arguments.do & '/'/>
					<cfelseif qry_getCarrierId.carrierId eq 42>
						<cfset local.href = local.href & '/cID/3/which/' & arguments.do & '/'/>
					<cfelseif qry_getCarrierId.carrierId eq 299>
						<cfset local.href = local.href & '/cID/230/which/' & arguments.do & '/'/>
					</cfif>
				</cfif>
			</cfif>
		<cfelseif arguments.do is 'phoneDetails'>
			<cfif local.thisLine.getPhone().hasBeenSelected()>
				<cfset local.href = local.href & '/phoneID/' & local.thisLine.getPhone().getProductID()/>
			</cfif>
		<cfelseif arguments.do is 'tabletDetails'>
			<cfif local.thisLine.getPhone().hasBeenSelected()>
				<cfset local.href = local.href & '/phoneID/' & local.thisLine.getPhone().getProductID()/>
			</cfif>
		<cfelseif arguments.do is 'dataCardDetails'>
			<cfif local.thisLine.getPhone().hasBeenSelected()>
				<cfset local.href = local.href & '/productID/' & local.thisLine.getPhone().getProductID()/>
			</cfif>
		<cfelseif arguments.do is 'prepaidDetails'>
			<cfif local.thisLine.getPhone().hasBeenSelected()>
				<cfset local.href = local.href & '/productID/' & local.thisLine.getPhone().getProductID()/>
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
					WHERE	p.productId	=<cfqueryparam value="#local.thisLine.getPhone().getProductId()#" 
				              cfsqltype="cf_sql_integer"/>
					UNION
					SELECT	p.carrierId
					FROM	catalog.dn_tablets AS p WITH (NOLOCK)
					WHERE	p.productId	=<cfqueryparam value="#local.thisLine.getPhone().getProductId()#" 
				              cfsqltype="cf_sql_integer"/>
				</cfquery>
			
				<cfif qry_getCarrierId.recordCount>
					<cfif qry_getCarrierId.carrierId eq 109>
						<cfset local.href = local.href & '/cID/36/which/' & arguments.do & '/'/>
					<cfelseif qry_getCarrierId.carrierId eq 128>
						<cfset local.href = local.href & '/cID/37/which/' & arguments.do & '/'/>
					<cfelseif qry_getCarrierId.carrierId eq 42>
						<cfset local.href = local.href & '/cID/38/which/' & arguments.do & '/'/>
					<cfelseif qry_getCarrierId.carrierId eq 299>
						<cfset local.href = local.href & '/cID/231/which/' & arguments.do & '/'/>
					</cfif>
				</cfif>
			</cfif>
		<cfelseif arguments.do is 'planDetails'>
			<cfif local.thisLine.getPlan().hasBeenSelected()>
				<cfset local.href = local.href & '/planID/' & local.thisLine.getPlan().getProductID()/>
			</cfif>
		<cfelseif arguments.do is 'planSelectServices'>
			<cfif local.thisLine.getPlan().hasBeenSelected()>
				<cfset local.href = local.href & '/planID/' & local.thisLine.getPlan().getProductID()/>
			</cfif>
		<cfelseif arguments.do is 'browseAccessories'>
			<cfset local.href = local.href & '/accessoryFilter.submit/1'/>
		
			<cfif local.thisLine.getPhone().hasBeenSelected()>
				<cfset local.href = local.href & '/filter.phoneID/' & local.thisLine.getPhone().getProductID()/>
			</cfif>
		<cfelseif arguments.do is 'accessoryDetails'>
			<cfset local.href = local.href & '/product_id/' & arguments.productID/>
		</cfif>
	<cfelse>
		<cfif arguments.do is 'browseAccessories'>
			<!--- Do Nothing --->
		<cfelseif arguments.do is 'accessoryDetails'>
			<cfset local.href = local.href & '/product_id/' & arguments.productID/>
		<cfelseif arguments.do is 'prepaidDetails'>
			<cfset local.href = local.href & '/productId/' & arguments.productID/>
		</cfif>
	</cfif>

	<cfset local.href = '/index.cfm/go/shop/do/' & arguments.do & local.href/>

	<cfreturn trim(local.href)/>
</cffunction>

<cffunction name="getAssetPaths" access="private" output="false" returntype="struct">
	<cfreturn variables.instance.assetPaths/>
</cffunction>

<cffunction name="setAssetPaths" access="private" output="false" returntype="void">
	<cfargument name="theVar" required="true"/>

	<cfset variables.instance.assetPaths = arguments.theVar/>
</cffunction>

<cffunction name="getChannelConfig" access="private" output="false" returntype="struct">
	<cfreturn variables.instance.ChannelConfig/>
</cffunction>

<cffunction name="setChannelConfig" access="private" output="false" returntype="void">
	<cfargument name="ChannelConfig" required="true"/>

	<cfset variables.instance.ChannelConfig = arguments.ChannelConfig/>
</cffunction>

<cffunction name="getStringUtil" access="private" output="false" returntype="struct">
	<cfreturn variables.instance.StringUtil/>
</cffunction>

<cffunction name="setStringUtil" access="private" output="false" returntype="void">
	<cfargument name="StringUtil" required="true"/>

	<cfset variables.instance.StringUtil = arguments.StringUtil/>
</cffunction>
