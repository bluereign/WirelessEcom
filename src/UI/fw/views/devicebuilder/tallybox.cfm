<cfoutput>
  <!--- <Tally Box --->
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
          <div class="col-xs-8">#dollarFormat(prc.cartLines[rc.cartLineNumber].getPrices().getDueToday())#</div>
          <div class="col-xs-8">#dollarFormat(prc.cartLines[rc.cartLineNumber].getPrices().getMonthly())#</div>
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
            <div class="name">#prc.productData.summaryTitle#</div>
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
                  <td class="price">#dollarFormat(prc.productData.FinancedFullRetailPrice)#</td>
                </tr>
                <tr>
                  <td>Due Today*</td>
                  <td class="price">#dollarFormat(prc.tallyboxFinanceMonthlyDueToday)# <cfif rc.paymentoption is 'financed'>Down</cfif></td> <!--- hard code from detail_new.cfm --->
                </tr>
               <!---  <tr>
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
              <!--- MORE Everything<br> Talk, Text, and Data --->
              <cfif structKeyExists(prc,"planInfo")>
                #prc.planInfo.DetailTitle#
                <cfif isDefined("prc.planDataExisting.productId") and prc.planDataExisting.productId eq prc.planInfo.productId>
                  - Existing
                </cfif>
              <cfelse>
                No plan selected
              </cfif>
            </div>
            <div class="table-responsive">
              <table class="table">
                <tr>
                  <td>
                    <!--- Due Monthly for 24 Months Regular Price Due Today*<br>Line Access Free --->

                  </td>
                  <td class="price">
                    <cfif structKeyExists(prc,"planInfo")>
                      #dollarFormat(prc.planInfo.MonthlyFee)#/mo
                    <cfelse>

                    </cfif>
                  </td>
                </tr>
              </table>
            </div>
          </div>
        </div>
        <h4>Protection &amp; Services</h4>
        <div class="row">
          <!--- <div class="col-xs-4">
            <img src="images/ex-sidebar-protection.jpg" alt="protection picture" />
          </div> --->
          <div class="col-xs-16">
            <div class="table-responsive">
              <table class="table">
                <cfif arrayLen(prc.aSelectedServices)>
                  <cfloop index="i" from="1" to="#arrayLen(prc.aSelectedServices)#">
                    <tr>
                      <td>#prc.aSelectedServices[i].Title# <!--- (#prc.aSelectedServices[i].productId#) ---></td>
                      <td class="price">#dollarFormat(prc.aSelectedServices[i].price)#/mo</td>
                    </tr>                  
                  </cfloop>
                <cfelse>
                  <tr>
                    <td>No Services Selected</td>
                    <td class="price">#dollarFormat(0)#/mo</td>
                  </tr>
                </cfif>
                <tr>
                  <td>#prc.warrantyInfo.SummaryTitle#</td>
                  <td class="price">#dollarFormat(prc.warrantyInfo.Price)#</td>
                </tr>
              </table>
            </div>
          </div>
        </div>
        <h4>Accessories</h4>
        <div class="row">
          <!--- <div class="col-xs-4">
            <img src="images/ex-sidebar-accessories.jpg" alt="accessories picture" />
          </div> --->
          <!--- <cfdump var="#session.cartHelper.lineGetAccessoriesByType(rc.cartLineNumber,"accessory")#"> --->
          
          <div class="col-xs-16">
            <div class="table-responsive">
              <table class="table">

                <cfif structKeyExists(prc,"aAccessories") and arrayLen(prc.aAccessories)>
                  <cfloop from="1" to="#arrayLen(prc.aAccessories)#" index="prc.iAccessory">
                    <cfset prc.thisAccessory = prc.aAccessories[prc.iAccessory] />
                    <cfset prc.selectedAccessory = application.model.accessory.getByFilter(idList = prc.thisAccessory.getProductID()) />
                    <cfset prc.stcPrimaryImages = application.model.imageManager.getPrimaryImagesForProducts(prc.selectedAccessory.accessoryGuid) />
                    <cfset prc.primaryImageSrc = application.view.imageManager.displayImage(imageGuid = prc.stcPrimaryImages[prc.selectedAccessory.accessoryGuid], height = 60, width = 60) />
                    

                    <!--- <cfdump var="#prc.selectedAccessory.summaryTitle#"> --->
                    <tr>
                      <td><img src="#trim(prc.primaryImageSrc)#"  width="60" border="0" /></td>
                      <td>#prc.selectedAccessory.summaryTitle#</td>
                      <td class="price">#dollarFormat(prc.selectedAccessory.price)#</td>
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
        <!--- <div class="row">
          <div class="col-xs-4">
            <img src="images/ex-sidebar-accessories.jpg" alt="accessories picture" />
          </div>
          <div class="col-xs-12">
            <div class="table-responsive">
              <table class="table">
                <tr>
                  <td>Costco Membership Benefits</td>
                  <td class="price">FREE</td>
                </tr>
              </table>
            </div>
          </div>
        </div> --->
      </aside>
    </div>
  </div> <!--- <end tally box --->
</cfoutput>
