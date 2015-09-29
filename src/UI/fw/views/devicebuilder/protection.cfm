<!--- <cfdump var="#rc#"> --->
<!--- <cfdump var="#prc.qWarranty#"> --->
<!--- <cfdump var="#prc.groupLabels#"> --->
<!--- <cfdump var="#prc.productData#"><cfabort> --->
<!--- <cfdump var="#prc.deviceMinimumRequiredServices#"> --->
<cfoutput>

  <!--- rc.count = #structCount(rc)#<br> --->
  <!--- structKeyExists(rc, "serviceCounter"): #structKeyExists(rc, "serviceCounter")#<br> --->
  <!--- <cfset prc.selectedServices = "" />
  <cfif structKeyExists(rc, "FieldNames") and findNoCase("chk_features_",rc.FieldNames)>
    <cfloop index="thisField" list="#rc.FieldNames#">
        <cfif findNoCase("chk_features_",thisField)>
          <br/>#thisField#=#XmlFormat(rc[thisField])# findNoCase("chk_features_",thisField): #findNoCase("chk_features_",thisField)# value: #rc[thisField]#
          <cfset prc.selectedServices = listAppend(prc.selectedServices,XmlFormat(rc[thisField]))>
        </cfif>
    </cfloop>
  </cfif> --->

  <!--- <cfif structKeyExists(prc,"selectedServices")>
    <div>
      <br><br>prc.selectedServices: <b>#prc.selectedServices#</b>
    </div>
  </cfif> --->
  
  <!--- <cfif structKeyExists(prc,"aSelectedServices")>
    <cfdump var="#prc.aSelectedServices#">
  </cfif> --->

  <div class="col-md-12">
    <section class="content">

      <header class="main-header">
        <h1>Payment, Protection &amp; Services Plans</h1>
        <p>The following services are available for your device based on your plan.</p>
      </header>

      <form action="#prc.nextStep#" name="protectionForm" id="protectionForm" method="post">
        <div class="right">
          <cfif structKeyExists(rc,"line")>
            <input type="hidden" name="line" value="#rc.line#">
          </cfif>
          <cfif structKeyExists(rc,"plan")>
            <input type="hidden" name="plan" value="#rc.plan#">
          </cfif>
          <a href="#prc.prevStep#">BACK</a>
          <button type="submit" class="btn btn-primary">Continue</button>
        </div>

        <section>

          <h4>#prc.productData.carrierName# Device Payment Options</h4>
          <div class="radio">
            <label>
              <input type="radio" name="paymentoption" value="financed" <cfif rc.paymentoption is 'financed'>checked</cfif> onchange="onChangeHandler(this.form,'financed')">
              <select name="finance" class="form-control" onchange="onChangeHandler(this.form,'financed')"><!--- temporary form post until ajax functionality built --->
                <cfif prc.productData.CarrierId eq 109>
                  <option value="financed-24" <cfif rc.finance is 'financed-24'>selected</cfif> >
                    #prc.financeproductname# 24: #dollarFormat(prc.productData.FinancedMonthlyPrice24)# Due Monthly for 30 Months
                  </option>
                  <option value="financed-18" <cfif rc.finance is 'financed-18'>selected</cfif> >
                    #prc.financeproductname# 18: #dollarFormat(prc.productData.FinancedMonthlyPrice18)# Due Monthly for 24 Months
                  </option>
                  <option value="financed-12" <cfif rc.finance is 'financed-12'>selected</cfif> >
                    #prc.financeproductname# 12: #dollarFormat(prc.productData.FinancedMonthlyPrice12)# Due Monthly for 20 Months
                  </option>
                <cfelseif prc.productData.CarrierId eq 42>
                  <option value="financed-24" <cfif rc.finance is 'financed-24'>selected</cfif> >
                    #prc.financeproductname#: #dollarFormat(prc.productData.FinancedMonthlyPrice24)# Due Monthly for 24 Months
                  </option>
                </cfif>
              </select>
              CARRIER is requiring a down payment
              <div class="checkbox">
                <label>
                  <input type="checkbox" value="1" checked disabled="1">
                  <a href="##">I Agree to the required CARRIER down payment of:</a> $0.00
                </label>
              </div>
            </label>
          </div>
          <div class="radio">
            <label>
              <input type="radio" name="paymentoption" value="fullretail" <cfif rc.paymentoption is 'fullretail'>checked</cfif> onchange="onChangeHandler(this.form,'fullretail')">
              Full Retail Price #dollarFormat(prc.productData.FinancedFullRetailPrice)#
            </label>
          </div>

        </section>
        
        <section class="seperator">

          <h4>Device Protection Options</h4>
          <!--- <a href="##">Help me choose a Protection Plan</a> --->
          <cfloop query="prc.qWarranty">
            <!--- prc.qWarranty: active, contractTerm (months), deductible, deviceid, gersSku, longDescription, metaDescription, metaKeywords, price, productId, shortDescription, summaryTitle, UPC,   --->
            <cfset prc.thisURL = '/index.cfm/go/shop/do/warrantyDetails/cartCurrentLine/1/productId/#prc.qWarranty.ProductId#' />
            <div class="radio">
              <label for="AddProtectionPlan_#prc.qWarranty.productId#">
                <input type="radio" name="wid" id="warrantyoption_#prc.qWarranty.productId#" value="#prc.qWarranty.productId#" onchange="onChangeHandler(this.form,this.form.paymentoption.value)"  <cfif rc.wid eq prc.qWarranty.productId>checked</cfif> >
                <a type="button" data-toggle="modal" data-target="##protectionModal" href="#event.buildLink('devicebuilder.protectionmodal')#/pid/#rc.pid#/type/#rc.type#/wid/#prc.qWarranty.productId#">
                  #prc.qWarranty.SummaryTitle# (#dollarformat(prc.qWarranty.price)#)
                </a>
                <cfif findNoCase("Apple",prc.qWarranty.SummaryTitle)><span class="actionLink" style="color:##009900;"> - Recommended</span></cfif>
              </label>
            </div>
          </cfloop>
          <div class="radio">
            <label>
              <input type="radio" name="wid" id="warrantyoption_0" value="0" onchange="onChangeHandler(this.form,this.form.paymentoption.value)" <cfif rc.wid eq 0>checked</cfif>  >
              No Equipment Protection Plan
            </label>
          </div>

        </section>

        <section class="seperator">

          <h4>Additional Service</h4>
          <!--- (for device: #prc.productData.productGuid#) --->

          <!--- <cfdump var="#prc.groupLabels#"> --->
          <cfset prc.serviceCounter = 0>
          <cfloop query="prc.groupLabels">
            
            <!--- <cfset serviceLabels = application.model.ServiceManager.getServiceMasterLabelsByGroup(groupGUID = prc.groupLabels.ServiceMasterGroupGuid, deviceId = prc.productData.productGuid, returnAllCartTypes=true)> --->
            <cfset serviceLabels = application.model.ServiceManager.getServiceMasterLabelsByGroup(groupGUID = prc.groupLabels.ServiceMasterGroupGuid, deviceId = prc.productData.productGuid, cartTypeId = prc.cartTypeId)>

            <!--- <cfdump var="#serviceLabels#"> --->

            <cfset prc.groupInputType = 'checkbox' />
            <cfset prc.hasNoneOption = false />
            <cfset prc.defaultIndex = 0 />
            
            <cfif prc.groupLabels.maxSelected eq 1>
              <cfset prc.groupInputType = 'radio' />
              <cfif prc.groupLabels.minSelected eq 0>
                <cfset prc.hasNoneOption = true />
              </cfif>
            </cfif>
            
            <cfif prc.groupLabels.minSelected eq 1 and prc.groupLabels.maxSelected eq 1>
              <cfset prc.defaultIndex = 1 />
            </cfif>
            
            <cfif serviceLabels.recordCount gt 0>
              <div>#trim(prc.groupLabels.label)#</div>
              <!--- <div><cfdump var="#prc.groupLabels#"></div> --->
              <!--- <div><cfdump var="#serviceLabels#"></div> --->
              <!--- <cfdump var="#prc.deviceMinimumRequiredServices#"> --->

              <cfset prc.i = 1 />
              <cfloop query="serviceLabels">
                <cfset prc.serviceCounter = prc.serviceCounter + 1 />
                <!--- request.config.debugInventoryData: #request.config.debugInventoryData# --->
                <!--- serviceLabels.HideMessage[serviceLabels.currentRow]: #serviceLabels.HideMessage[serviceLabels.currentRow]# --->
                <div class="checkbox">
                  <label>
                    <input type="#prc.groupInputType#"
                          name="chk_features_#prc.groupLabels.serviceMasterGroupGuid#"
                          value="#serviceLabels.productId[serviceLabels.currentRow]#"
                          <!--- id="chk_features_#serviceLabels.productId[serviceLabels.currentRow]#"
                          name="chk_features_#prc.groupLabels.serviceMasterGroupGuid#" 
                          name="chk_features_#prc.serviceCounter#"--->

                          <cfif listFindNoCase(prc.selectedServices,serviceLabels.productId[serviceLabels.currentRow])>
                            checked
                          <cfelseif len(serviceLabels.recommendationId[serviceLabels.currentRow]) or prc.i eq prc.defaultIndex>
                            checked
                          </cfif>

                          onchange="onChangeHandler(this.form,this.form.paymentoption.value)" />


                    <a href="##" type="button" data-toggle="modal" data-target="##roadsideModal">#trim(serviceLabels.label)# (#serviceLabels.productId#)</a> 
                    <cfif rc.paymentoption is 'financed' and (len(serviceLabels.FinancedPrice))><!---Is a financed phone with a Financed Price--->
                      #dollarFormat(serviceLabels.FinancedPrice)#/mo
                    <cfelse>
                      #dollarFormat(serviceLabels.monthlyFee)#/mo
                    </cfif>
                    <!--- - #prc.serviceCounter# --->
                  </label>
                </div>
                <cfset prc.i = (prc.i + 1) />
              </cfloop>

            </cfif>

          </cfloop>
          <input type="hidden" name="serviceCounter" value="#prc.serviceCounter#" />

          <br>
          
          <!-- Roadside Protection Modal -->
          <div class="modal fade" id="roadsideModal" tabindex="-1" role="dialog" aria-labelledby="roadsideModalLabel">
            <div class="modal-dialog" role="document">
              <div class="modal-content">
                <div class="modal-header">
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                  <h4 class="modal-title" id="roadsideModalLabel">Roadside Assistance</h4>
                  <p>Need help on the go? We have a solution for you.</p>
                </div>
                <div class="modal-body">
                  <p>Bacon ipsum dolor amet shankle turkey turducken ball tip. Ham turkey porchetta, ribeye venison filet mignon pork loin. Ball tip chicken tongue shank ham hock turducken biltong. Swine kielbasa strip steak salami, andouille flank corned beef beef ribs tongue pork.</p>
                </div>
                <div class="modal-footer">
                  <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                  <button type="button" class="btn btn-primary">Add to Cart</button>
                </div>
              </div>
            </div>
          </div>

        </section>

        <div class="right">
          <a href="#prc.prevStep#">BACK</a>
          <button type="submit" class="btn btn-primary">Continue</button>
        </div>

      </form>
    </section>

    

    <div class="legal">
      <p>Legal Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed diam eget risus varius blandit sit amet non magna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Cras mattis consectetur purus sit amet fermentum. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Aenean lacinia bibendum nulla sed consectetur.</p>
      <p>**Legal Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed diam eget risus varius blandit sit amet non magna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Cras mattis consectetur purus sit amet fermentum. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Aenean lacinia bibendum nulla sed consectetur.</p>
      <p>†Legal Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed diam eget risus varius blandit sit amet non magna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Cras mattis consectetur purus sit amet fermentum. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Aenean lacinia bibendum nulla sed consectetur.</p>
    </div>
  </div>
<script type="text/javascript">
  function onChangeHandler(form,paymentoption) {
    form.action='#event.buildLink('devicebuilder.protection')#/pid/#rc.pid#/type/#rc.type#/';
    form.paymentoption.value=paymentoption;
    form.submit();
  }
</script>

</cfoutput>
