<cfparam name="prc.tallyBoxHeader" default="Upgrading" />
<cfoutput>
  <div class="col-md-4">
    <div class="row totals">
      <div class="wrap head">
        <div class="col-xs-8">
          Due Now
        </div>
        <div class="col-xs-8">
          Monthly
        </div>
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
                  <td>#prc.tallyboxFinanceMonthlyDueTitle#</td>
                  <td class="price">#dollarFormat(prc.tallyboxFinanceMonthlyDueAmount)#/mo*</td>
                </tr>
                <tr>
                  <td>Regular Price</td>
                  <td class="price">                    
                    <cfif structKeyExists(prc,"selectedPhone")>
                      #dollarFormat(prc.selectedPhone.price_retail)#
                    <cfelse>
                      #dollarFormat(prc.productData.FinancedFullRetailPrice)#
                    </cfif>
                  </td>
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

                <tr>
                  <td>Due Today*</td>
                  <td class="price">#dollarFormat(prc.cartLines[rc.cartLineNumber].getPrices().getDueToday())#</td>
                  <!--- <td class="price">#dollarFormat(prc.tallyboxFinanceMonthlyDueToday)# <cfif prc.paymentoption is 'financed'>Down</cfif></td> <!--- hard code from detail_new.cfm ---> --->
                </tr>
                <!--- Note: it will be difficult to display the Line Access Fee here as it's part of the lineFeatures array --->
                <!--- <tr>
                  <td>Line Access Fee</td>
                  <td class="price">$xx.xx ?</td>
                </tr> --->
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
              <cfelse>
                No Plan Selected
              </cfif>
            </div>
            <div class="table-responsive">
              <table class="table">
                <tr>
                  <td>
                    Due Monthly
                  </td>
                  <td class="price">
                    <cfif isQuery(prc.cartPlan) and  prc.cartPlan.recordcount>
                      #dollarFormat(prc.cartPlan.MonthlyFee)#/mo
                    </cfif>
                  </td>
                </tr>
              </table>
            </div>
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
                    <tr>
                      <td>#local.thisFeature.summaryTitle#</td>
                      <td class="price">#dollarFormat(prc.lineFeatures[local.iFeature].getPrices().getMonthly())#/mo</td>
                    </tr>
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
                <!--- <cfif structKeyExists(prc,"cartLine") and prc.cartLine.getWarranty().hasBeenSelected()>
                  <tr>
                    <td>Warranty: #prc.cartLine.getWarranty().getTitle()#</td>
                    <td class="price">#dollarFormat(prc.cartLine.getWarranty().getPrices().getDueToday())#</td>
                  </tr>
                <cfelse>
                  <tr>
                    <td>No Protection Plan Selected</td>
                    <td class="price">$0.00</td>
                  </tr>
                </cfif> --->

              </table>
            </div>
          </div>
        </div>
        <h4>Accessories</h4>
        <div class="row">
          
          <div class="col-xs-16">
            <div class="table-responsive">
              <table class="table">

                <cfif structKeyExists(prc,"lineAccessories") and isArray(prc.lineAccessories)>

                  <cfloop from="1" to="#arrayLen(prc.lineAccessories)#" index="i">
                    <tr>
                      <td>
                        #prc.lineAccessories[i].detailTitle# <cfif prc.lineAccessories[i].qty gt 1>x #prc.lineAccessories[i].qty#</cfif>
                      </td>
                      <td class="price">
                        #dollarFormat(prc.lineAccessories[i].price_subTotal)#
                      </td>
                    </tr>                    
                  </cfloop>
                  
                <cfelse>

                  <tr>
                    <td>No Accessories Selected</td>
                    <td class="price"></td>
                  </tr>

                </cfif>

              </table>
            </div>
          </div>
        </div>
      </aside>
    </div>
  </div>
</cfoutput>
