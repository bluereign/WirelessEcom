<!--- #event.isAjax()# --->
<cfparam name="prc.tallyBoxHeader" default="Upgrading" />
<cfparam name="prc.showClearCartLink" default="true" />
<cfoutput>
  <div class="col-md-4">
    <cfif prc.showClearCartLink>
      <div class="pull-right"><a href="#prc.clearCartAction#" class="clear">Clear Entire Cart</a><br><br></div>
    </cfif>
    <div class="row totals">
      <div class="wrap head">
        <div class="col-xs-8">Due Today*</div>
        <div class="col-xs-8">Monthly*</div>
      </div>
      <div class="wrap">
        <cfif arrayLen(prc.cartlines)>
          <div class="col-xs-8">#dollarFormat(session.cart.getPrices().getDueToday())#</div>
          <div class="col-xs-8">#dollarFormat(session.cart.getPrices().getMonthly())#</div>
          <!--- KEEP: These two commented out lines below would show the totals associated with This Device rather than the entire cart --->
          <!--- <div class="col-xs-8">#dollarFormat(prc.cartLines[rc.cartLineNumber].getPrices().getDueToday())#</div> --->
          <!--- <div class="col-xs-8">#dollarFormat(prc.cartLines[rc.cartLineNumber].getPrices().getMonthly())#</div> --->
        <cfelse>
          <div class="col-xs-8">#dollarFormat(prc.tallyboxDueNow)#</div>
          <div class="col-xs-8">#dollarFormat(prc.tallyboxDueMonthly)#</div>          
        </cfif>
      </div>
    </div>

    <div class="row">
      <aside class="details">
        <h3>#prc.tallyboxHeader#</h3>
        <div class="row">
          <div class="col-xs-4">
            <img class="img-responsive" id="prodDetailImg" src="#prc.productImages[1].imagesrc#" border="0" width="50" alt="#prc.productImages[1].imageAlt#"/>
          </div>
          <div class="col-xs-12">
            <div class="name">
              <cfif structKeyExists(prc,"selectedPhone")>
                #prc.selectedPhone.summaryTitle#
              <cfelse>
                #prc.productData.summaryTitle#
              </cfif>
            </div>
            <div class="table-responsive">
              <table class="table">
                <thead>
                  <th colspan="2">#prc.tallyboxFinanceTitle#</th>
                </thead>
                <tr>
                  <td>#prc.tallyboxFinanceMonthlyDueTitle#**</td>
                  <td class="price">#dollarFormat(prc.tallyboxFinanceMonthlyDueAmount)#/mo</td>
                </tr>

                <tr>
                  <td>Full Retail Price</td>
                  <td class="price">#dollarFormat(prc.productData.FinancedFullRetailPrice)#</td>
                </tr>

                <cfif structKeyExists(prc,"selectedPhone") and structKeyExists(prc,"cartLine") and session.cart.getActivationType() DOES NOT CONTAIN "financed">
                  <tr>
                    <td>Online Discount</td>
                    <td class="price">-#dollarFormat(val(prc.selectedPhone.price_retail) - val(prc.cartLine.getPhone().getPrices().getDueToday()))#</td>
                  </tr>
                </cfif>

                <cfif structKeyExists(prc,"cartLine") and prc.cartLine.getPlan().hasBeenSelected() and structKeyExists(prc,"lineBundledAccessories") and arrayLen(prc.lineBundledAccessories)>
                  <cfloop from="1" to="#arrayLen(prc.lineBundledAccessories)#" index="local.iAccessory">
                    <cfset local.thisAccessory = prc.lineBundledAccessories[local.iAccessory] />
                    <cfset local.selectedAccessory = application.model.accessory.getByFilter(idList = local.thisAccessory.getProductID()) />
                    <tr>
                      <td>Accessory: #prc.selectedPlan.carrierName# - #local.selectedAccessory.summaryTitle#</td>
                      <td class="price"><cfif local.thisAccessory.getPrices().getDueToday() EQ 0>FREE</cfif></td>
                    </tr>
                  </cfloop>
                </cfif>

                <cfif session.cart.getActivationType() CONTAINS 'upgrade'>
                  <tr>
                    <td>Upgrade Fee ***</td>
                    <td class="price"><cfif prc.upgradeFee>#dollarFormat(prc.upgradeFee)#<cfelse>$18.00</cfif></td>
                  </tr>
                <cfelse>                  
                  <tr>
                    <td>Activation Fee ***</td>
                    <td class="price"><cfif listFind(request.config.activationFeeWavedByCarrier,session.cart.getCarrierId())>Free<cfelse>#dollarFormat(prc.activationFee)#</cfif></td>
                  </tr>
                </cfif>

                <!--- prc.cartLines[rc.cartLineNumber].getOptionalDownPmtAmt() --->
                <cfif prc.cartLines[rc.cartLineNumber].getPhone().getPrices().getOptionalDownPmtAmt()>
                  <tr>
                    <td>Optional Down Payment</td>
                    <td class="price">#dollarFormat(prc.cartLines[rc.cartLineNumber].getPhone().getPrices().getOptionalDownPmtAmt())#</td>
                  </tr>
                </cfif>
                <!--- <tr>
                  <td colspan="2"><cfdump var="#prc.cartArgs#"></td>
                </tr> --->
                  


                <tr>
                  <td>Due Today*</td>
                  <td class="price">#dollarFormat(prc.cartLines[rc.cartLineNumber].getPrices().getDueToday())#</td>
                </tr>

              </table>
            </div>
          </div>
        </div>

        <h4>Carrier Plan</h4>

        <div class="row">
          <div class="col-xs-4">
            <cfif prc.productData.carrierId eq prc.carrierIdAtt>
              <img src="#prc.assetPaths.common#images/carrierLogos/att_logo_25.png" alt="#prc.productData.carrierName#" />
            <cfelseif prc.productData.carrierId eq prc.carrierIdVzw>
              <img src="#prc.assetPaths.common#images/carrierLogos/verizon_logo_25.png" alt="#prc.productData.carrierName#" />
            </cfif>
          </div>
          <div class="col-xs-12">
            <div class="name">
              <cfif isQuery(prc.cartPlan) and  prc.cartPlan.recordcount>
                #prc.cartPlan.carrierName# #prc.cartPlan.detailTitle#
              <cfelseif structKeyExists(session.cart,"HasExistingPlan") and session.cart.HasExistingPlan>
                Keeping Existing Plan
              <cfelse>
                No Plan Selected
              </cfif>
            </div>
            <cfif isQuery(prc.cartPlan) and  prc.cartPlan.recordcount>
              <div class="table-responsive">
                <table class="table">
                  <tr>
                    <td>
                      Due Monthly
                    </td>
                    <td class="price">
                      #dollarFormat(prc.cartPlan.MonthlyFee)#/mo
                    </td>
                  </tr>
                  <!--- Required Service --->
                  <cfif structKeyExists(prc,"lineFeatures")>
                    <cfloop from="1" to="#arrayLen(prc.lineFeatures)#" index="local.iFeature">
                      <cfset local.thisFeatureID = prc.lineFeatures[local.iFeature].getProductID() />
                      <cfset local.thisFeature = application.model.feature.getByProductID(local.thisFeatureID) />
                      <cfif listFindNoCase(session.listRequiredServices,local.thisFeature.productId)>
                        <tr>
                          <td>#local.thisFeature.summaryTitle#</td>
                          <td class="price">#dollarFormat(prc.lineFeatures[local.iFeature].getPrices().getMonthly())#/mo</td>
                        </tr>
                      </cfif>
                    </cfloop>
                  </cfif>

                </table>
              </div>
            </cfif>
          </div>
        </div>

        <h4>Protection &amp; Services</h4>
        
        <div class="row">
          <div class="col-xs-16">
            <div class="table-responsive">
              <table class="table">

                <!--- Line Features/Services --->
                <cfif structKeyExists(prc,"lineFeatures")>
                  <cfloop from="1" to="#arrayLen(prc.lineFeatures)#" index="local.iFeature">
                    <cfset local.thisFeatureID = prc.lineFeatures[local.iFeature].getProductID() />
                    <cfset local.thisFeature = application.model.feature.getByProductID(local.thisFeatureID) />
                    <cfset local.thisServiceRecommended = false />
                    <cfif !listFindNoCase(session.listRequiredServices,local.thisFeature.productId)>
                      <tr>
                        <td>#local.thisFeature.summaryTitle#</td>
                        <td class="price">#dollarFormat(prc.lineFeatures[local.iFeature].getPrices().getMonthly())#/mo</td>
                      </tr>
                    </cfif>
                  </cfloop>
                <cfelse>
                  <tr>
                    <td>No Services Selected</td>
                    <td class="price">#dollarFormat(0)#/mo</td>
                  </tr>
                </cfif>

                <!--- Line warranty --->
                <cfif prc.warranty.recordcount>
                  <tr>
                    <td>Warranty: #prc.warranty.summaryTitle#</td>
                    <td class="price">#dollarFormat(prc.warranty.price)#</td>
                  </tr>
                <cfelse>
                  <tr>
                    <td>No Protection Plan Selected</td>
                    <td class="price">$0.00</td>
                  </tr>
                </cfif>

              </table>
            </div>
          </div>
        </div>
        <h4>Accessories</h4>
        <div class="row">
          
          <div class="col-xs-16">
            <div class="table-responsive">
              <table class="table">

                <cfset local.accessoriesCount = 0 />
                <cfif structKeyExists(prc,"lineAccessories") and isArray(prc.lineAccessories)>
                  <cfloop from="1" to="#arrayLen(prc.lineAccessories)#" index="i">
                    <cfif prc.lineAccessories[i].price_subTotal>
                      <cfset local.accessoriesCount++ />
                      <tr>
                        <td>
                          #prc.lineAccessories[i].detailTitle# #prc.lineAccessories[i].productId# <cfif prc.lineAccessories[i].qty gt 1>x #prc.lineAccessories[i].qty#</cfif>
                        </td>
                        <td class="price">
                          #dollarFormat(prc.lineAccessories[i].price_subTotal)#
                        </td>
                      </tr>
                    </cfif>            
                  </cfloop>
                </cfif>

                <cfif !local.accessoriesCount>
                  <tr>
                    <td>No Accessories Selected</td>
                    <td class="price"></td>
                  </tr>
                </cfif>

              </table>
            </div>
          </div>
        </div>

        <div class="row">
          <div class="col-xs-16 legal">
            <div>* Total due monthly will appear on your recurring bill. Before taxes and fees. Total due today is before taxes and fees.</div>
            <div>** $0 down (for qualified customers).</div>
            <cfif session.cart.getActivationType() contains 'upgrade'>
              <div>*** An Upgrade Fee of $#prc.upgradeFee# applies to each Upgrade Line.<cfif session.cart.getCarrierId() neq 299> This fee will appear on your next billing statement<cfif session.cart.getCarrierId() eq 299> and will be refunded to your account within three billing cycles</cfif>.</cfif></div>
            <cfelse>
              <cfif listFind(request.config.activationFeeWavedByCarrier,session.cart.getCarrierId())>
                <cfif listFindNoCase('109, 128', session.cart.getCarrierId())>
                  <div>*** #prc.selectedPlan.carrierName# activation fees will be refunded through a Bill Credit on all qualifying activations.</div>
                <cfelseif listFindNoCase('299', session.cart.getCarrierId())>
                  <div>*** Activation fee credit will be applied in the first bill cycle and refunded to your account within three billing cycles.</div>
                <cfelseif session.cart.getCarrierId() eq 42>
                  <div>*** Customers will receive a mail-in rebate from Wireless Advocates to reimburse the activation fee on a new single line and/or Family Share 2-year #prc.selectedPlan.carrierName# service agreement. Upgrades do not qualify for this credit.</div>
                </cfif>
                <!--- Please <a href="##" onclick="viewActivationFeeInWindow('activationFeeWindow', 'Activation Fee Details', '/index.cfm/go/cart/do/explainActivationFee/carrierId/#session.cart.getCarrierId()#');return false;">click here</a> for details. --->
              <cfelse>
                <div>*** Activation Fee will be applied to the first bill cycle.</div>
              </cfif>
            </cfif>
          </div>
        </div>
      </div>
		
		
      </aside>
	  
  </div>
</cfoutput>
