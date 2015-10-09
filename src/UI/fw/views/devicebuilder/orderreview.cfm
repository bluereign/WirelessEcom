<cfparam name="local.deviceGuidList" type="string" default="" />

<cfif application.model.cartHelper.hasSelectedFeatures()>
  <cfset qRecommendedServices = application.model.ServiceManager.getRecommendedServices() />
</cfif>

<cfoutput>
    <div class="col-md-12">
      <section class="content">
        <cfif structKeyExists(prc,"warningMessage")>
          <p class="bg-warning" style="padding:10px">#prc.warningMessage#</p>
        </cfif>
        <header class="main-header">
          <h1>Cart</h1>
        </header>
        <form>
          <div class="right">
            <cfif prc.showAddAnotherDeviceButton>
              <a href="#prc.addxStep#">ADD ANOTHER DEVICE</a>
            </cfif>
            <cfif prc.showCheckoutnowButton>
              <button type="submit" class="btn btn-primary">Checkout Now</button>
            </cfif>
          </div>
          <div class="content">
            <div class="row hidden-xs">
              <div class="head">
                <div class="col-md-2">Item</div>
                <div class="col-md-8"></div>
                <div class="col-md-2">Quantity</div>
                <div class="col-md-2">Monthly</div>
                <div class="col-md-2">Due Today</div>
              </div>
            </div>



            <!--- Following logic refactored from cfc/view/Cart.cfc Line 233 through 1419 --->
            <cfloop from="1" to="#arrayLen(prc.cartLines)#" index="local.iCartLine">
              <cfset local.cartLine = prc.cartLines[local.iCartLine] />
              <cfset local.showAddServiceButton = false />

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

              <div class="row">
                <div class="col-md-2 col-xs-6 item">
                  <img src="#imageDetail.src#" alt="#imageDetail.alt#" />
                </div>
                <div class="col-md-8 col-xs-10 data">
                  <h3>#local.selectedPhone.summaryTitle#</h3>
                  <p>
                  <cfif rc.type is 'upgrade'>
                    #prc.stringUtil.formatPhoneNumber(trim(prc.subscribers[local.cartLine.getSubscriberIndex()].getNumber()))#
                  </cfif>
                  <br>
                    Includes: something, something, something</p>
                </div>
                <div class="col-md-2 col-xs-16 quantity">1
                  <!--- //TODO: Add logic to allow for qty change for Accessories only --->
                  <!--- <select class="form-control">
                    <option>1</option>
                    <option>2</option>
                  </select> --->
                  <a href="##">Remove</a>
                </div>

                <div class="col-md-2 col-xs-16 monthly">
                  #dollarFormat(local.cartline.getPrices().getMonthly())#
                  <span class="visible-xs-inline">Monthly</span>
                </div>
                <div class="col-md-2 col-xs-16 due">
                  #dollarFormat(local.cartline.getPrices().getDueToday())#
                  <span class="visible-xs-inline">Due Today</span>
                </div>

                <cfif session.cart.getUpgradeType() neq 'equipment-only' && not session.cart.getPrePaid() && session.cart.getAddALineType() neq 'family' && session.cart.getActivationType() neq 'nocontract'>  
                  <cfif local.cartLine.getPlan().hasBeenSelected()>
                    <cfset local.selectedPlan = application.model.plan.getByFilter(idList = local.cartLine.getPlan().getProductID()) />
                    <cfset local.deviceGuidList = listAppend(local.deviceGuidList, local.selectedPlan.productGuid) />
                  </cfif>
                </cfif>

                <div class="col-md-2 col-xs-16"></div>
                <div class="col-md-14 col-xs-16">

                  <div class="row">
                    <div class="collapse" id="plandetails#local.iCartLine#">
                      
                      <div class="col-md-12 col-xs-11">#local.selectedPhone.summaryTitle#</div>
                      <div class="col-md-4 col-xs-5">
                        <cfif session.cart.getActivationType() contains "financed">
                          $0.00
                        <cfelse>
                          #dollarFormat(local.selectedPhone.price_retail)#                 
                        </cfif>
                      </div>
                      <cfif session.cart.getActivationType() DOES NOT CONTAIN "financed">
                        <div class="col-md-12 col-xs-11">Online Discount</div>
                        <div class="col-md-4 col-xs-5">
                          -#dollarFormat(val(local.selectedPhone.price_retail) - val(local.cartLine.getPhone().getPrices().getDueToday()))#
                        </div>
                      </cfif>

                      <!--- Bundled Accessories --->
                      <cfset local.thisLineBundledAccessories = application.model.cartHelper.lineGetAccessoriesByType(line = local.iCartLine, type = 'bundled') />
                      
                      <cfif arrayLen(local.thisLineBundledAccessories)> <!--- from cfc/view/Cart.cfc line 339 --->
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

                          <div class="col-md-12 col-xs-11">Accessory: #local.selectedPlan.carrierName# - #local.selectedAccessory.summaryTitle#</div>
                          <div class="col-md-4 col-xs-5"><cfif local.thisAccessory.getPrices().getDueToday() EQ 0>FREE</cfif></div>
                        </cfloop>
                      </cfif>

                      <!--- Plan --->
                      <cfif local.cartLine.getPlan().hasBeenSelected()>
                        
                        <cfset local.carrierObj = application.wirebox.getInstance("Carrier") />  <!--- from cfc/view/Cart.cfc line 441 --->
                        <!---- Upgrades do not have the activation fee waived --->
                        
                        <cfif session.cart.getActivationType() CONTAINS 'upgrade'>
                          <cfset local.upgradeFee = local.carrierObj.getUpgradeFee( session.cart.getCarrierID() )>
                          <div class="col-md-12 col-xs-11">
                            Plan: #local.selectedPlan.carrierName# - #local.selectedPlan.summaryTitle#
                            <br/><em>Upgrade Fee of <cfif local.upgradeFee>$#local.upgradeFee#<cfelse>$18.00</cfif> * </em>
                          </div>
                          <div class="col-md-4 col-xs-5">
                            #dollarFormat(local.selectedPlan.planPrice)#/mo
                            <br/>&nbsp;*
                          </div>

                        <cfelse>

                          <cfset local.activationFee = local.carrierObj.getActivationFee( session.cart.getCarrierID() )>
                          <cfif listFind(request.config.activationFeeWavedByCarrier,session.cart.getCarrierId())>
                            <div class="col-md-12 col-xs-11">
                              Plan: #local.selectedPlan.carrierName# - #local.selectedPlan.summaryTitle#
                              <br/><em>Free Activation Fee
                              <span class="activationFeeDisclaimer">(<a href="##" class="activationFeeExplanation" onclick="viewActivationFeeInWindow('activationFeeWindow', 'Activation Fee Details', '/index.cfm/go/cart/do/explainActivationFee/carrierId/#session.cart.getCarrierId()#');return false;">#dollarFormat(local.cartLine.getActivationFee().getPrices().getFirstBill())#</a> refunded by <cfif isDefined('local.selectedPlan.carrierID') and local.selectedPlan.carrierID eq 42>Wireless Advocates, LLC<cfelse>your carrier</cfif> - see details below <sup class="cartReview"><a href="##footnote4">4</a></sup>)</span></em>
                            </div>
                            <div class="col-md-4 col-xs-5">
                              #dollarFormat(local.selectedPlan.planPrice)#/mo
                            <br/>$0.00</div>
                          <cfelse>
                            <div class="col-md-12 col-xs-11">
                              Plan: #local.selectedPlan.carrierName# - #local.selectedPlan.summaryTitle#
                              <br/>Activation Fee
                            </div>
                            <div class="col-md-4 col-xs-5">(#dollarFormat(local.activationFee)# - see details below <sup class="cartReview"><a href="##footnote4">4</a></sup>)</div>  <!--- from cfc/view/Cart.cfc line 477 --->
                          </cfif>

                        </cfif> <!--- end CONTAINS 'upgrade' --->
                        
                      </cfif> <!--- end local.cartLine.getPlan().hasBeenSelected() --->

                      <!--- Services --->
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

                        <div class="col-md-12 col-xs-11">#local.thisFeature.summaryTitle# <cfif local.thisServiceRecommended AND NOT local.thisFeature.hidemessage> - Best Value</cfif></div>
                        <div class="col-md-4 col-xs-5">#dollarFormat(local.lineFeatures[local.iFeature].getPrices().getMonthly())#/mo</div>
                      </cfloop>


                      <!--- Line Accessories --->
                      <cfif arrayLen(local.cartLine.getAccessories())>  <!--- from cfc/view/Cart.cfc line 705 --->
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

                          <div class="col-md-12 col-xs-11">Accessory: #local.selectedAccessory.summaryTitle#</div>
                          <div class="col-md-4 col-xs-5">#dollarFormat(local.selectedAccessories[local.iAccessory].getPrices().getDueToday())#</div>
                        </cfloop>
                      <cfelse>
                        <div class="col-md-12 col-xs-11">No accessories selected for this device</div>
                        <div class="col-md-4 col-xs-5">&nbsp;</div>
                      </cfif>


                      <!--- Line warranty --->
                      <cfif local.cartLine.getWarranty().hasBeenSelected()>
                        <cfset local.selectedWarranty = application.model.Warranty.getById( local.cartLine.getWarranty().getProductId() ) />
                        <div class="col-md-12 col-xs-11">Warranty: #local.cartLine.getWarranty().getTitle()#</div>
                        <div class="col-md-4 col-xs-5">#dollarFormat(local.cartLine.getWarranty().getPrices().getDueToday())#</div>
                      <cfelse>
                        <div class="col-md-12 col-xs-11">No protection plan selected for this line yet.</div>
                        <div class="col-md-4 col-xs-5">$0.00</div>
                      </cfif>


                      <!--- Instant MIR --->
                      <cfif local.cartLine.getInstantRebateAmount() gt 0>
                        <cfset local.cartLine.getPrices().setDueToday( local.cartLine.getPrices().getDueToday() - local.cartLine.getInstantRebateAmount() )>
                        <div class="col-md-12 col-xs-11">Instant Rebate: <span class="callout">You qualified to convert the mail-in rebate to an instant online rebate!</span></div>
                        <div class="col-md-4 col-xs-5">-#dollarFormat(local.cartLine.getInstantRebateAmount())#</div>
                      </cfif>



                      
                    </div>
                  </div>
                  <a role="button"
                    class="plan-details collapsed"
                    data-toggle="collapse"
                    href="##plandetails#local.iCartLine#"
                    aria-expanded="false"
                    aria-controls="plandetails#local.iCartLine#">Show Plan Details</a>
                </div>
              </div>

            </cfloop>


          </div>
        </form>
      </section>
    </div>


    <div class="col-md-4">
      <cfif prc.showClearCartLink>
        <a href="#prc.clearCartAction#" class="clear">Clear Entire Cart</a>
      <cfelse>
        <a href="#prc.browseDevicesUrl#" class="clear">Browse Devices</a>
      </cfif>
      
      <!--- 
      //TODO:
        The link "Clear Entire Cart" needs to 
          - drop carrierObj (but not ZipCode) from the session
          - clear any devices, plans, accessories, etc. that the user has added to their cart view the devicebuilder.
       --->
      <div class="sidebar">
        <h4>Have Questions?</h4>
        <ul>
          <li><a href="##">Call us at 1-800-555-1212</a></li>
          <li><a href="##">Chat with one of our representatives</a></li>
          <li><a href="##">E-mail one of our experts</a></li>
          <li><a href="##">Frequently Asked Questions</a></li>
        </ul>
        <h4>Our Signature Promise</h4>
        <ul>
          <li><a href="##">Free UPS ground shipping</a></li>
          <li><a href="##">90 day return policy</a></li>
          <li><a href="##">Return in store</a></li>
        </ul>
      </div>
    </div>
  </div>
  <div class="row summary">
    <div class="col-md-12">

      <div class="col-md-16 promo">
        <div class="form-inline">
          <div class="form-group">
            <label for="promoInputName">Promotional Code</label>
            <input type="text" class="form-control input-sm" id="promoInputName">
          </div>
          <button type="submit" class="btn btn-default btn-sm">Apply</button>
        </div>
      </div>
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
            <th>Monthly Price</th>
            <th>Due Now</th>
          </tr>
          </thead>
          <tbody>
          <tr>
            <td>Sub-Total</td>
            <td>#dollarFormat(session.cart.getPrices().getMonthly())#</td>
            <td>#dollarFormat(session.cart.getPrices().getDueToday())#</td>
          </tr>
          <tr>
            <td>Shipping</td>
            <td></td>
            <td>#request.config.CartReviewShippingDisplayName#</td>
          </tr>
          <tr>
            <td>Est. Tax</td>
            <td></td>
            <td>TBD</td>
          </tr>
          <!--- <tr>
            <td>
              <div class="form-inline">
                <div class="form-group">
                  <label for="taxInputName">Est. Tax</label>
                  <input type="text" class="form-control input-sm" id="taxInputName">
                </div>
                <button type="submit" class="btn btn-default btn-sm">Apply</button>
              </div>
            </td>
            <td></td>
            <td>TBD</td>
          </tr> --->

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

          <tr>
            <td>Discount Code: XXXXX</td>
            <td></td>
            <td>$XX.XX</td>
          </tr>
          </tbody>
          <tfoot>
          <tr>
            <td>Total Due Today</td>
            <cfset local.total = session.cart.getPrices().getDueToday() />
            <cfset local.total += session.cart.getTaxes().getDueToday() />
            <cfset local.total += session.cart.getShipping().getDueToday() />
            <cfset session.totalDueToday = local.total />
            <td colspan="2">#dollarFormaT(local.total)#</td>
          </tr>
          <tr>
            <td>Total Due Monthly</td>
            <td colspan="2">#dollarFormat(session.cart.getPrices().getMonthly())#</td>
          </tr>
          </tfoot>
        </table>
        </div>
      </div>
      </div>
      <div class="right">
        <a href="##">ADD ANOTHER DEVICE</a>
        <button type="submit" class="btn btn-primary">Checkout Now</button>
      </div>
    </div>

    <div class="col-md-12">
      <p class="legal">
        
        <cfif session.cart.getActivationType() is 'upgrade'>  <!--- from cfc/view/Cart.cfc line 1331 --->
          <!--- removing hard-coded upgrade fees and adding result from call to carrier component made earlier in this method  --->
          <cfif NOT structKeyExists(local, 'upgradeFee')>
            <cfset local.carrierObj = application.wirebox.getInstance("Carrier") />
            <cfset local.upgradeFee = local.carrierObj.getUpgradeFee( session.cart.getCarrierID() )>
          </cfif>            
          *  An Upgrade Fee of $#local.upgradeFee# applies to each Upgrade Line.
            <cfif session.cart.getCarrierId() neq 299>This fee will appear on your next billing statement<cfif session.cart.getCarrierId() eq 299> and will be refunded to your account within three billing cycles</cfif>.</cfif><!--- remove for Sprint --->
          <br />
        </cfif>

         Legal Goes Here: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed diam eget risus varius blandit sit amet non magna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Cras mattis consectetur purus sit amet fermentum.</p>
    </div>
  </div>
</div>

</cfoutput>
