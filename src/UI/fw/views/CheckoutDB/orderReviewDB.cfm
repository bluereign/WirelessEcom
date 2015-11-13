<cfset setChannelConfig(application.wirebox.getInstance("ChannelConfig"))/>
<!--- Adding style here and jQuery at the bottom as the javascript file provided by front-end developer is minified. --->
<style>
.cart .device-details {
  font-size: 12px;
  font-size: 0.75rem;
  text-transform: uppercase;
}
.cart .device-details:after {
  width: 0;
  height: 0;
  border-left: 5px solid transparent;
  border-right: 5px solid transparent;
  border-bottom: 8px solid #00aeef;
  content: ' ';
  display: inline-block;
  margin: 10px 0 0 10px;
}
.cart .device-details.collapsed:after {
  border-bottom: none;
  border-top: 8px solid #00aeef;
  content: ' ';
  margin-top: 0;
}
.cart .right {
width:260px;}
</style>

<cfparam name="local.deviceGuidList" type="string" default="" />
<cfparam name="local.financeLegalStar" type="string" default="" />
<cfif session.cart.getActivationType() contains 'new'>
	<cfset local.financeLegalStar = "**" />
</cfif>

<cfif application.model.cartHelper.hasSelectedFeatures()>
  <cfset qRecommendedServices = application.model.ServiceManager.getRecommendedServices() />
</cfif>

<cfoutput>
<div class="row main">
    <div class="col-md-12">
      <section class="content">
		<header class="main-header">
            <h1>Order Review</h1>
			<p>&nbsp;</p>
        </header>
		<form id="formCheckoutReview" action="#event.buildLink('/CheckoutDB/processOrderReview')#" method="post">
		<div class="right">
            <a href="##" onclick="window.location.href='/CheckoutDB/carrierAgreements'">BACK</a>
            <button type="submit" onclick="$('##formCheckoutReview').submit()" class="btn btn-primary">Process Payment Now</button>
        </div>
        <cfif structKeyExists(prc,"warningMessage")>
          <p class="bg-warning" style="padding:10px">#prc.warningMessage#</p>
        </cfif>

        
          
          <input type="hidden" name="cartLineNumber" value="#request.config.otherItemsLineNumber#" />

          <div class="content">
            
            <div class="row hidden-xs">
              <div class="head">
                <div class="col-md-2">Item</div>
                <div class="col-md-8">&nbsp;</div>
                <div class="col-md-2">Quantity</div>
                <div class="col-md-2">Monthly*</div>
                <div class="col-md-2">Due Today*</div>
              </div>
            </div>

            <cfif !isQuery(prc.cartPlan) and !arrayLen(prc.cartLines) and !arrayLen(prc.additionalAccessories)>
              <div class="row">
                <div class="col-md-16 col-xs-16 item">
                  Your cart is empty.<!---   <a href="#prc.browseDevicesUrl#">Click here to go to Browse Devices.</a> --->
                </div>
              </div>
            </cfif>
            <!--- plan --->
            <cfif isQuery(prc.cartPlan) and prc.cartPlan.recordcount>
              <div class="row">
                <div class="col-md-2 col-xs-6 item">
                  <img src="#session.carrierObj.carrierLogo#" alt="" /><br />
                  <!---<a href="#event.buildLink('devicebuilder.plans')#/cartLineNumber/1">Edit Plan</a><br /><br />--->
				  <div style="height:50px;"></div>
                </div>
                <div class="col-md-8 col-xs-10 data">
                  <h3>#prc.cartPlan.companyName# #prc.cartPlan.planName#</h3>
                    <p><!--- Includes:  --->#reReplaceNoCase(prc.cartPlan.summaryDescription, "<.*?>","","all")#</p>
                </div>
                <div class="col-md-2 col-xs-16 quantity">1</div>
                <div class="col-md-2 col-xs-16 monthly">#dollarFormat(prc.cartPlan.monthlyFee)# <span class="visible-xs-inline">Monthly*</span></div>
                <div class="col-md-2 col-xs-16 due"> <span class="visible-xs-inline">Due Today*</span></div>

                <div class="col-md-2 col-xs-16"></div>
                <div class="col-md-14 col-xs-16">

                   <div class="row">
                    <div class="collapse" id="plan-details">
					<div class="row">
                      <div class="col-md-10">#prc.cartPlan.companyName# #prc.cartPlan.planName#</div>
                      <div class="col-md-3">#dollarFormat(prc.cartPlan.monthlyFee)#/mo</div>
					  <div class="col-md-3"></div>
					</div>
					<div class="row">
                      <div class="col-md-10">Data Limit:</div>
                      <div class="col-md-3">#prc.cartPlan.DataLimitGB# GB</div>
					  <div class="col-md-3"></div>
					</div>
					<div class="row">
                      <div class="col-md-10">Maximum Lines:</div>
                      <div class="col-md-3">#prc.cartPlan.maxLines#</div>
					  <div class="col-md-3"></div>
					</div>
                      <!--- <div class="col-md-12 col-xs-11">Additional Data Usage:</div>
                      <div class="col-md-4 col-xs-5">#prc.cartPlan.additional_data_usage#</div>
                      <div class="col-md-16 col-xs-16">#prc.cartPlan.companyName# #prc.cartPlan.planName#</div>
                      <div class="col-md-16 col-xs-16">Data Limit: #prc.cartPlan.data_limit#</div>
                      <div class="col-md-16 col-xs-16">Additional Data Usage: #prc.cartPlan.additional_data_usage#</div>
                      <div class="col-md-16 col-xs-16">Maximum Lines: #prc.cartPlan.maxLines#</div> --->

                    </div>
                  </div>
                  <a role="button"
                    class="plan-details collapsed"
                    data-toggle="collapse"
                    href="##plan-details"
                    aria-expanded="false"
                    aria-controls="plan-details">Show Plan Details</a>
                </div>
              </div>
            </cfif>



            <cfif arrayLen(prc.cartLines)>
              <!--- Following logic refactored from cfc/view/Cart.cfc Line 233 through 1419 --->
              <cfloop from="1" to="#arrayLen(prc.cartLines)#" index="local.iCartLine">
                <cfset local.cartLine = prc.cartLines[local.iCartLine] />
                <cfset local.showAddServiceButton = false />

                <cfset local.selectedPhone = application.model.phone.getByFilter(idList = local.cartLine.getPhone().getProductID(), allowHidden = true) />
                
                <cfset local.lineBundledAccessories = application.model.cartHelper.lineGetAccessoriesByType(line = local.iCartLine, type = 'bundled') />

                <cfset local.lineFeatures = local.cartLine.getFeatures() />

                <cfset local.lineAccessories = application.model.dBuilderCartFacade.getAccessories(local.iCartLine) />

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
                    src = '#prc.assetPaths.common#images/catalog/noimage.jpg',
                    alt = htmlEditFormat(local.selectedPhone.summaryTitle),
                    width = 130
                  } />
                </cfif>


                <!--- Get Device Summary Description --->
                <cfset local.deviceDescription = "" />

                <cfloop from="1" to="#arrayLen(local.lineFeatures)#" index="local.iFeature">
                  <cfset local.thisFeatureID = local.lineFeatures[local.iFeature].getProductID() />
                  <cfset local.thisFeature = application.model.feature.getByProductID(local.thisFeatureID) />
                  <cfset local.deviceDescription = listAppend(local.deviceDescription,local.thisFeature.summaryTitle) />
                </cfloop>
                <cfif isArray(local.lineAccessories) and arrayLen(local.lineAccessories)>
                  <cfloop from="1" to="#arrayLen(local.lineAccessories)#" index="i">
                    <cfif local.lineAccessories[i].qty eq 1>
                      <cfset local.deviceDescription = listAppend(local.deviceDescription,local.lineAccessories[i].detailTitle) />
                    <cfelse>
                     <cfset local.deviceDescription = listAppend(local.deviceDescription,local.lineAccessories[i].detailTitle & ' (' & local.lineAccessories[i].qty & ')') />
                    </cfif>
                  </cfloop>
                </cfif>
                <cfif local.cartLine.getWarranty().hasBeenSelected()>
                  <cfset local.deviceDescription = listAppend(local.deviceDescription,local.cartLine.getWarranty().getTitle()) />
                </cfif>


                <!--- Display --->
                <div class="row">
                  <div class="col-md-2 col-xs-6 item">
                    <img src="#imageDetail.src#" alt="#imageDetail.alt#" /><br />
                    <!---<a href="#event.buildLink('devicebuilder.protection')#/cartLineNumber/#local.iCartLine#">Edit Options</a><br />--->
                  </div>
                  <div class="col-md-8 col-xs-10 data">
                    <h3>#local.selectedPhone.summaryTitle#</h3>
                    <p>
                      <cfif prc.customerType is 'upgrade' and structKeyExists(prc,"subscribers") and local.cartLine.getSubscriberIndex() gt 0>
                        #prc.stringUtil.formatPhoneNumber(trim(prc.subscribers[local.cartLine.getSubscriberIndex()].getNumber()))#
                      </cfif>
                      <br />
                      Includes: #listChangeDelims(local.deviceDescription,", ")#
                    </p>
                  </div>
                  <input type="hidden" id="removephone" name="removephone" value="" />
                  <div class="col-md-2 col-xs-16 quantity">1
                    <!---<a href="##" data-removephone="#local.iCartLine#" class="removephone">Remove</a>--->
                  </div>

                  <div class="col-md-2 col-xs-16 monthly">
                  	<!--- Services --->
                        <cfloop from="1" to="#arrayLen(local.lineFeatures)#" index="local.iFeature">
            				<cfset lineAccessFee = local.lineFeatures[local.iFeature].getPrices().getMonthly() />
                        </cfloop>
                        <cfif !isDefined('lineAccessFee')>
                        	<cfset lineAccessFee = 0 />
                        </cfif>
                    <cfif local.iCartLine eq 1 AND isQuery(prc.cartPlan) and prc.cartPlan.recordcount>
						#dollarFormat(local.cartline.getPhone().getPrices().getMonthly() + lineAccessFee)# <!---MES--->
					<cfelse>
						#dollarFormat(local.cartline.getPhone().getPrices().getMonthly() + lineAccessFee)# <!---MES--->
					</cfif>
                    <span class="visible-xs-inline">Monthly*</span>
                  </div>
                  <div class="col-md-2 col-xs-16 due">
                    #dollarFormat(local.cartline.getPrices().getDueToday())#
                    <span class="visible-xs-inline">Due Today*</span>
                  </div>

                  <cfif session.cart.getUpgradeType() neq 'equipment-only' && not session.cart.getPrePaid() && session.cart.getAddALineType() neq 'family' && session.cart.getActivationType() neq 'nocontract'>  
                    <cfif local.cartLine.getPlan().hasBeenSelected()>
                      <cfset local.selectedPlan = application.model.plan.getByFilter(idList = local.cartLine.getPlan().getProductID()) />
                      <cfset local.deviceGuidList = listAppend(local.deviceGuidList, local.selectedPlan.productGuid) />
                    </cfif>
                  </cfif>

                  <div class="col-md-2 col-xs-16"></div>
                  <div class="col-md-14 col-xs-16">

                    <!--- <PLAN DETAILS --->
                    <div class="row">
                      <div class="collapse" id="devicedetails#local.iCartLine#">
                        <div class="row">
            							<!--- Device or line item --->
            							<div class="col-md-10">#local.selectedPhone.summaryTitle# #local.cartline.getCartLineActivationType()#</div>
            							<div class="col-md-3">
              							<cfif local.cartline.getCartLineActivationType() contains "financed">
              								<cfset local.months = listGetAt(local.cartline.getCartLineActivationType(),2,'-') />
                              <cfset local.productData = application.model.phone.getByFilter(idList = local.cartLine.getPhone().getProductID(), allowHidden = true) />
                              <cfswitch expression="#local.months#">
                                <cfcase value="24">
                                  #dollarFormat(local.productData.FinancedMonthlyPrice24)#/mo#local.financeLegalStar#
                                </cfcase>
                                <cfcase value="18">
                                  #dollarFormat(local.productData.FinancedMonthlyPrice18)#/mo#local.financeLegalStar#
                                </cfcase>
                                <cfcase value="12">
                                  #dollarFormat(local.productData.FinancedMonthlyPrice12)#/mo#local.financeLegalStar#
                                </cfcase>
                              </cfswitch>
              						  <cfelse>
              								&nbsp;
              						  </cfif>
            							</div>
            							<div class="col-md-3">
            							  <cfif local.cartline.getCartLineActivationType() contains "financed" and local.cartLine.getSubscriberIndex() gt 0>
                              <!--- Down Payment: --->
                              <cfset local.subscriber = prc.subscribers[local.cartLine.getSubscriberIndex()] />
                              <cfset local.subscriber.offerCategory = IIF(local.productData.carrierId eq prc.carrierIdAtt, DE(prc.offerCategoryAtt), DE(prc.offerCategoryVzw)) />
                              <cfset local.subscriber.downPaymentPercent = local.subscriber.getUpgradeDownPaymentPercent(local.subscriber.offerCategory,local.months) />
                              <cfif local.subscriber.downPaymentPercent gt 0>
                                <cfset local.subscriber.downPayment = local.subscriber.downPaymentPercent * local.productData.FinancedFullRetailPrice / 100 />
                                #dollarFormat(local.subscriber.downPayment)#
                              </cfif>
            							  <cfelse>
            								  #dollarFormat(local.selectedPhone.price_retail)#
            							  </cfif>
            							</div>
            						</div>
            						<div class="row">
            							<cfif session.cart.getActivationType() DOES NOT CONTAIN "financed">
            							  <div class="col-md-10">Online Discount</div>
            							  <div class="col-md-3">&nbsp;</div>
            							  <div class="col-md-3">
            								  -#dollarFormat(val(local.selectedPhone.price_retail) - val(local.cartLine.getPhone().getPrices().getDueToday()))#
            							  </div>
            							</cfif>
            						</div>
                        <!--- Bundled Accessories
                        <cfif arrayLen(local.lineBundledAccessories)> <!--- from cfc/view/Cart.cfc line 339 --->
                          <cfloop from="1" to="#arrayLen(local.lineBundledAccessories)#" index="local.iAccessory">
                            <cfset local.thisAccessory = local.lineBundledAccessories[local.iAccessory] />
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
              							<div class="row">
              								<div class="col-md-10">Accessory: #local.selectedPhone.carriername# - #local.selectedAccessory.summaryTitle#</div>
              								<div class="col-md-3">&nbsp;</div>
              								<div class="col-md-3"><cfif local.thisAccessory.getPrices().getDueToday() EQ 0>INCLUDED</cfif></div>
              							</div>
                          </cfloop>
                        </cfif> --->

                        <!--- Plan --->
                        <cfif local.cartLine.getPlan().hasBeenSelected()>
                          <cfset local.carrierObj = application.wirebox.getInstance("Carrier") />  <!--- from cfc/view/Cart.cfc line 441 --->
                          <!---- Upgrades do not have the activation fee waived --->
                        </cfif>

                        <!--- Services --->
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

            							<div class="row">
            							  <div class="col-md-10">#local.thisFeature.summaryTitle#<cfif local.thisServiceRecommended AND NOT local.thisFeature.hidemessage> - Best Value</cfif></div>
            							  <div class="col-md-3">#dollarFormat(local.lineFeatures[local.iFeature].getPrices().getMonthly())#/mo</div>
            							  <div class="col-md-3">&nbsp;</div>
            							</div>
                        </cfloop>


                        <!--- Line Accessories --->
                        <cfif isArray(local.lineAccessories) and arrayLen(local.lineAccessories)>
                          <cfloop from="1" to="#arrayLen(local.lineAccessories)#" index="i">
              							<div class="row">
              								<div class="col-md-9">Accessory: #local.lineAccessories[i].detailTitle#</div>
              								<div class="col-md-1">#local.lineAccessories[i].qty#</div>
											<div class="col-md-3">&nbsp;</div>
              								<div class="col-md-3">#dollarFormat(local.lineAccessories[i].price_subTotal)#</div>
              							</div>
                          </cfloop>
                        <cfelse>
            							<div class="row">
            							  <div class="col-md-10">No accessories selected for this device</div>
            							  <div class="col-md-3">&nbsp;</div>
            							  <div class="col-md-3">&nbsp;</div>
            							</div>
                        </cfif>


                        <!--- Line warranty --->
                        <cfif local.cartLine.getWarranty().hasBeenSelected()>
                          <div class="row">
                            <div class="col-md-10">Warranty: #local.cartLine.getWarranty().getTitle()#</div>
                            <div class="col-md-3">&nbsp;</div>
                            <div class="col-md-3">#dollarFormat(local.cartLine.getWarranty().getPrices().getDueToday())#</div>
                          </div>
                        <cfelse>
                          <div class="row">
                            <div class="col-md-10">No protection plan selected</div>
                            <div class="col-md-3">&nbsp;</div>
                            <div class="col-md-3">$0.00</div>
                          </div>
                        </cfif>


                        <!--- Activation/Upgrade Fee --->
                        <!---<cfif session.cart.getActivationType() CONTAINS 'upgrade'>
                          <div class="row">
                            <div class="col-md-10">Upgrade Fee of <cfif prc.upgradeFee>#dollarFormat(prc.upgradeFee)#<cfelse>$18.00</cfif> ***</div>
                            <div class="col-md-3">&nbsp;</div>
                            <div class="col-md-3">$0.00</div>
                          </div>
                        <cfelse>
                          <div class="row">
                            <div class="col-md-10">Activation Fee ***</div>
                            <div class="col-md-3">&nbsp;</div>
                            <div class="col-md-3"><cfif listFind(request.config.activationFeeWavedByCarrier,session.cart.getCarrierId())>Free<cfelse>#dollarFormat(prc.activationFee)#</cfif></div>
                          </div>
                        </cfif>--->

                        <!---<cfif local.cartLine.getWarranty().hasBeenSelected()>
                          <div class="row">
                            <div class="col-md-10">Warranty: #local.cartLine.getWarranty().getTitle()#</div>
                            <div class="col-md-3">&nbsp;</div>
                            <div class="col-md-3">#dollarFormat(local.cartLine.getWarranty().getPrices().getDueToday())#</div>
                          </div>
                        <cfelse>
                          <div class="row">
                            <div class="col-md-10">No protection plan selected</div>
                            <div class="col-md-3">&nbsp;</div>
                            <div class="col-md-3">$0.00</div>
                          </div>
                        </cfif>--->


                        <!--- Instant MIR --->
                        <cfif local.cartLine.getInstantRebateAmount() gt 0>
                          <cfset local.cartLine.getPrices().setDueToday( local.cartLine.getPrices().getDueToday() - local.cartLine.getInstantRebateAmount() )>
            						  <div class="row">
            							  <div class="col-md-10">Instant Rebate: <span class="callout">You qualified to convert the mail-in rebate to an instant online rebate!</span></div>
            							  <div class="col-md-3">&nbsp;</div>
            							  <div class="col-md-3">-#dollarFormat(local.cartLine.getInstantRebateAmount())#</div>
            						  </div>
                        </cfif>

                      </div>
                    </div>

                    <!--- <end device details --->
                    <a role="button"
                      class="device-details collapsed"
                      data-toggle="collapse"
                      href="##devicedetails#local.iCartLine#"
                      aria-expanded="false"
                      aria-controls="devicedetails#local.iCartLine#">Show Device Details</a>
                  </div>
                </div>

              </cfloop>
            </cfif>
            


            <!--- <ADDITIONAL ITEMS --->
            <cfset local.selectedAccessories = application.model.cartHelper.lineGetAccessoriesByType(line = request.config.otherItemsLineNumber, type = 'accessory') />
            <cfset local.thisPrepaids = application.model.cartHelper.lineGetAccessoriesByType(line = request.config.otherItemsLineNumber, type = 'prepaid') />
            <cfset local.deposits = application.model.cartHelper.lineGetAccessoriesByType(line = request.config.otherItemsLineNumber, type = 'deposit') />

            <cfset hasAdditionalItems = arrayLen(local.selectedAccessories) || arrayLen(local.thisPrepaids) || arrayLen(local.deposits)>
            
            <cfif hasAdditionalItems>
              <cfset local.imageUrls = [] />
              <cfset local.total_dueToday_other = 0 />
              <cfset local.total_firstBill_other = 0 />
              <cfset local.total_monthly_other = 0 />

              <!--- Accessories --->
              <input type="hidden" id="addaccessory" name="addaccessory" value="" />
              <input type="hidden" id="removeaccessory" name="removeaccessory" value="" />
              <input type="hidden" id="accessoryqty" name="accessoryqty" value="" />

              <cfif arrayLen(prc.additionalAccessories)>
                <cfloop from="1" to="#arrayLen(prc.additionalAccessories)#" index="i">
                  <cfset local.stcPrimaryImage = application.model.imageManager.getPrimaryImagesForProducts(prc.additionalAccessories[i].accessoryGuid) />
                  <cfset local.imageDetail = {
                        src = application.view.imageManager.displayImage(imageGuid = local.stcPrimaryImage[prc.additionalAccessories[i].accessoryGuid], height = 0, width = 130),
                        alt = htmlEditFormat(prc.additionalAccessories[i].detailTitle),
                        width = 130
                    } />
                  <div class="row">
                    <div class="col-md-2 col-xs-6 item">
                      <img src="#local.imageDetail.src#" alt="#local.imageDetail.alt#" />
                    </div>
                    <div class="col-md-8 col-xs-10 data">
                      <h3>#prc.additionalAccessories[i].detailTitle#</h3>
                    </div>
                    <div class="col-md-2 col-xs-16 quantity">
                      <select name="accessoryqty#prc.additionalAccessories[i].productId#" id="#prc.additionalAccessories[i].productId#" class="form-control accessoryqty">
                        <cfloop from="1" to="#prc.additionalAccessories[i].qtyOnHand#" index="iqty">
                          <option value="#iqty#" <cfif prc.additionalAccessories[i].qty eq iqty>selected</cfif> >#iqty#</option>
                        </cfloop>
                      </select>
                      <!---<a href="##" data-removeaccessory="#prc.additionalAccessories[i].productid#" class="removeaccessory">Remove</a>--->
                    </div>
                    <div class="col-md-2 col-xs-16 monthly"> <span class="visible-xs-inline">Monthly*</span></div>
                    <div class="col-md-2 col-xs-16 due">#dollarFormat(prc.additionalAccessories[i].price_subTotal)# <span class="visible-xs-inline">Due Today*</span></div>
                  </div>
                </cfloop>
              </cfif>
          </cfif>
          </div>
        </form>
      </section>
    </div>


    <div class="col-md-4">
      <div class="row">
        <img src="#assetPaths.common#images/content/checkout/CustomerServiceContact.png" />
      </div>
  </div>
  <div class="row summary">
    <div class="col-md-12">

      <!--- PROMO CODE --->
      <!--- Don't delete.  Will be implemented sometime in the future --->
      <!--- <div class="col-md-16 promo">
        <div class="form-inline">
          <div class="form-group">
            <label for="promoInputName">Promotional Code</label>
            <input type="text" class="form-control input-sm" id="promoInputName">
          </div>
          <button type="submit" class="btn btn-default btn-sm">Apply</button>
        </div>
      </div> --->


      <div class="row">
      <div class="col-md-10 col-md-offset-6">
        <div class="table-wrap">
        <table class="table table-responsive">
          <thead>
          <tr class="head">
            <th colspan="3">Order Summary</th>
          </tr>
          <tr>
            <th></th>
            <th>Due Monthly*</th>
            <th>Due Today*</th>
          </tr>
          </thead>
          <tbody>
          <tr>
            <td>Sub-Total</td>
            <td>#dollarFormat(session.cart.getPrices().getMonthly())#</td>
            <td>#dollarFormat(session.cart.getPrices().getDueToday())#</td>
          </tr>
          <tr>
            <td>Shipping<sup class="cartReview"><a href="##footnote1" style="font-size:8px">1</a></sup></td>
            <td></td>
            <td>#dollarFormat(session.checkout.shippingMethod.getDefaultFixedCost())#</td>
          </tr>
          <tr>
            <td>Tax<sup class="cartReview"><a href="##footnote2" style="font-size:8px">2</a></sup></td>
            <td></td>
            <td>#dollarFormat(session.cart.getTaxes().getDueToday())#</td>
          </tr>

          <!--- <REBATES (have not been tested yet) --->
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
                    <td>
                      <cfif len(trim(qry_getRebates.url[qry_getRebates.currentRow]))>
                        <a href="#trim(qry_getRebates.url[qry_getRebates.currentRow])#" target="_blank">Click to Download the #trim(qry_getRebates.title[qry_getRebates.currentRow])# Form</a>
                      <cfelse>
                        #trim(qry_getRebates.title[qry_getRebates.currentRow])#
                      </cfif>
                    </td>
                    <td></td>
                    <td>
                      <cfif qry_getRebates.displayType[qry_getRebates.currentRow] is 'N'>
                        N/A
                      <cfelse>
                        <strong>- #dollarFormat(qry_getRebates.amount[qry_getRebates.currentRow])#</strong>
                      </cfif>
                    </td>
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
                <td>Total After Mail-In Rebate<cfif local.totalAppliedRebates gt 1>s</cfif></td>
                <td></td>
                <td>#dollarFormat(local.totalAfterRebates)#</td>
              </tr>
            </cfif>
          </cfif>
          <!--- <end rebates --->

          <!--- PROMO CODE (will get added at some point in the future) --->
          <!--- <tr>
            <td>Discount Code: XXXXX</td>
            <td></td>
            <td>$XX.XX</td>
          </tr> --->
          </tbody>
          <tfoot>
          <tr>
            <td>Total Due Today*</td>
            <cfset local.total = session.cart.getPrices().getDueToday() />
            <cfset local.total += session.cart.getTaxes().getDueToday() />
            <cfset local.total += session.cart.getShipping().getDueToday() />
            <cfset session.totalDueToday = local.total />
            <td colspan="2">#dollarFormaT(local.total)#</td>
          </tr>
          <tr>
            <td>Total Due Monthly*
            	<cfif session.cart.getCarrierID() eq '42'>
            		<sup class="cartReview"><a href="##footnote3" style="font-size:8px">3</a></sup>
            	</cfif>
            </td>
            <td colspan="2">#dollarFormat(session.cart.getPrices().getMonthly())#</td>
          </tr>
          </tfoot>
        </table>
        </div>
      </div>
      </div>
      
      
      <cfif session.cart.getActivationType() CONTAINS 'upgrade' and arrayLen(prc.cartLines)>
        <div class="row">
          <div class="col-md-10 col-md-offset-6">
            <div class="table-wrap">
              <table class="table table-responsive">
                <tr>
                  <td>One time Activation Fee of <cfif prc.upgradeFee>#dollarFormat(prc.upgradeFee)#<cfelse>$18.00</cfif> will be added to your next billing statement</td>
                  <td></td>
                  <td><cfif prc.upgradeFee>#dollarFormat(arrayLen(prc.cartLines)*prc.upgradeFee)#<cfelse>$18.00</cfif></div></td>
                </tr>
              </table> 
            </div>
          </div>
        </div>
      </cfif>
      
    </div>
    <div class="col-md-12">
	<div class="formControl" style="float:right">
	<a href="##" onclick="window.location.href='/CheckoutDB/carrierAgreements'">BACK</a>&nbsp;
		<span class="btn btn-primary"><a href="##" onclick="$('##formCheckoutReview').submit()" style="color:##fff">Process Payment Now</a></span>
		<br/>
		<br/>
	</div>
	</div>
	<!--- Legal section --->
    <div class="col-md-12">
      <p class="legal">
        * Total due monthly will appear on your recurring bill. Before taxes and fees. Total due today is before taxes and fees.<br />
		** $0 down (for qualified customers).<br />
		
        <cfif session.cart.getActivationType() contains 'upgrade'>  <!--- from cfc/view/Cart.cfc line 1331 --->
          <!--- removing hard-coded upgrade fees and adding result from call to carrier component made earlier in this method  --->
          <cfif NOT structKeyExists(local, 'upgradeFee')>
            <cfset local.carrierObj = application.wirebox.getInstance("Carrier") />
            <cfset local.upgradeFee = local.carrierObj.getUpgradeFee( session.cart.getCarrierID() )>
          </cfif>            
          ***  An Upgrade Fee of $#prc.upgradeFee# applies to each Upgrade Line.
            <cfif session.cart.getCarrierId() neq 299>This fee will appear on your next billing statement<cfif session.cart.getCarrierId() eq 299> and will be refunded to your account within three billing cycles</cfif>.</cfif><!--- remove for Sprint --->
          <br />
        </cfif>
		<span class="note">
			<sup class="cartReview">
				<a name="footnote1" style="font-size:8px">
					1
				</a>
			</sup>			
			Orders can take up to #getChannelConfig().getOrderProcessingTime()# business days to process before shipping. Once the order is shipped you will receive an email with the tracking number. 
		</span>
		<br/>
		<span class="note">
			<sup class="cartReview">
				<a name="footnote2" style="font-size:8px">
					2
				</a>
			</sup>
			In accordance with the tax laws in certain states and jurisdictions, including but not limited to California, the tax charged may be based 
			on an amount higher than the retail price of the purchase. California sales tax is calculated in accordance
			with Sales and Use Tax Regulation 1585. Taxes and fees estimated and based on zip code (
			#session.cart.getZipcode()#
			)
			entered earlier and the service plan you selected. Actual fees will be determined by your 
			wireless carrier.
		</span>
		<br/>
	<cfif session.cart.getCarrierID() eq '42'>
		<span class="note">
			<sup class="cartReview">
				<a name="footnote3" style="font-size:8px">
					3
				</a>
			</sup>
			These amounts will be billed by #rc.carrierName# and do not include other line or account charges, fees, taxes, and surcharges which can add between 6% and 44% to your bill.
		</span>
		<br/>
	</cfif>
	
	
    </div>
  </div>
</div>
</div>
</cfoutput>

<cffunction name="getChannelConfig" access="private" output="false" returntype="struct">
	<cfreturn variables.instance.ChannelConfig/>
</cffunction>

<cffunction name="setChannelConfig" access="private" output="false" returntype="void">
	<cfargument name="ChannelConfig" required="true"/>

	<cfset variables.instance.ChannelConfig = arguments.ChannelConfig/>
</cffunction>
