<cfoutput>
  <div class="col-md-12">

    <section class="content">

      <header class="main-header">
        <h1>Payment, Protection &amp; Services Plans</h1>
        <p>The following services are available for your device based on your plan.</p>
      </header>

      <form action="#prc.nextStep#" name="protectionForm" id="protectionForm" method="post">
        <div class="right">
          <input type="hidden" name="cartLineNumber" value="#rc.cartLineNumber#" />
          <a href="#prc.prevStep#">BACK</a>
          <button type="submit" class="btn btn-primary btnContinue" id="btnContinue" 
            <cfif isDefined("prc.subscriber.downPayment") and prc.subscriber.downPayment gt 0 and rc.isDownPaymentApproved eq 0>
              disabled
            </cfif>
            >
            Continue
          </button>
        </div>

        <section>

          <h4>#prc.productData.carrierName# Device Payment Options</h4>
          <div class="radio">
            <label>
              <input type="radio" name="paymentoption" value="financed" <cfif prc.paymentoption is 'financed'>checked</cfif> onchange="onChangeHandler(this.form,'financed')">
              <select name="financed" class="form-control" onchange="onChangeHandler(this.form,'financed')"><!--- temporary form post until ajax functionality built --->
                <cfif prc.productData.CarrierId eq 109>
                  <option value="financed-24" <cfif prc.financed is 'financed-24'>selected</cfif> >
                    #prc.financeproductname# 24: #dollarFormat(prc.productData.FinancedMonthlyPrice24)# Due Monthly for 30 Months
                  </option>
                  <option value="financed-18" <cfif prc.financed is 'financed-18'>selected</cfif> >
                    #prc.financeproductname# 18: #dollarFormat(prc.productData.FinancedMonthlyPrice18)# Due Monthly for 24 Months
                  </option>
                  <option value="financed-12" <cfif prc.financed is 'financed-12'>selected</cfif> >
                    #prc.financeproductname# 12: #dollarFormat(prc.productData.FinancedMonthlyPrice12)# Due Monthly for 20 Months
                  </option>
                <cfelseif prc.productData.CarrierId eq 42>
                  <option value="financed-24" <cfif prc.financed is 'financed-24'>selected</cfif> >
                    #prc.financeproductname#: #dollarFormat(prc.productData.FinancedMonthlyPrice24)# Due Monthly for 24 Months
                  </option>
                </cfif>
              </select>
              <cfif isDefined("prc.subscriber.downPayment") and prc.subscriber.downPayment gt 0>
                CARRIER is requiring a down payment
                <div class="checkbox">
                  <label>
                    <input type="checkbox" value="1" name="isDownPaymentApproved" id="isDownPaymentApproved" <cfif rc.isDownPaymentApproved>checked</cfif> >
                    <!--- <a href="##"> --->I Agree to the required CARRIER down payment of:<!--- </a> ---> #dollarFormat(prc.subscriber.downPayment)#
                  </label>
                </div>
              </cfif>                
            </label>
          </div>
          
          <div class="radio">
            <label>
              <input type="radio" name="paymentoption" value="fullretail" <cfif prc.paymentoption is 'fullretail'>checked</cfif> onchange="onChangeHandler(this.form,'fullretail')">
              <!--- Full Retail Price #dollarFormat(prc.productData.FinancedFullRetailPrice)# --->
              Upgrade Price #dollarFormat(prc.productData.price_upgrade)#
            </label>
          </div>

        </section>
        
        <section class="seperator">

          <hr />
          <h4>Device Protection Options</h4>
          <!--- <a href="##">Help me choose a Protection Plan</a> --->
          <cfloop query="prc.qWarranty">
            <!--- prc.qWarranty: active, contractTerm (months), deductible, deviceid, gersSku, longDescription, metaDescription, metaKeywords, price, productId, shortDescription, summaryTitle, UPC,   --->
            <cfset prc.thisURL = '/index.cfm/go/shop/do/warrantyDetails/cartCurrentLine/1/productId/#prc.qWarranty.ProductId#' />
            <div class="radio">
              <label for="warrantyoption_#prc.qWarranty.productId#">
                <input type="radio" name="warrantyid" id="warrantyoption_#prc.qWarranty.productId#" value="#prc.qWarranty.productId#" onchange="onChangeHandler(this.form,this.form.paymentoption.value)"  <cfif prc.warrantyId eq prc.qWarranty.productId>checked</cfif> >
                <a type="button" data-toggle="modal" data-target="##protectionModal" href="#event.buildLink('devicebuilder.protectionmodal')#/cartLineNumber/#rc.cartLineNumber#/wid/#prc.qWarranty.productId#">
                  #prc.qWarranty.SummaryTitle#
                </a> 
                #dollarformat(prc.qWarranty.price)#
                <cfif findNoCase("Apple",prc.qWarranty.SummaryTitle)><span class="actionLink" style="color:##009900;"> - Recommended</span></cfif>
              </label>
            </div>
          </cfloop>
          <div class="radio">
            <label>
              <input type="radio" name="warrantyid" id="warrantyoption_0" value="0" onchange="onChangeHandler(this.form,this.form.paymentoption.value)" <cfif prc.warrantyId eq 0>checked</cfif>  >
              No Equipment Protection Plan
            </label>
          </div>

        </section>

        <section class="seperator">

          <hr />
          <h4 id="h4AdditionalServices" style="display: none;">Additional Service</h4>


          <cfset prc.serviceCounter = 0>
          <cfloop query="prc.groupLabels">

            <cfset local.servicesArgs = {
              groupGUID = prc.groupLabels.ServiceMasterGroupGuid,
              deviceId = prc.productData.productGuid,
              showActiveOnly = true,
              cartTypeId = prc.cartTypeId
              } />
            
            <cfif len(prc.cartPlan)>
              <cfset local.serviceArgs.rateplanId = prc.cartPlan.productGuid />
            </cfif>
            
            <cfset serviceLabels = application.model.serviceManager.getServiceMasterLabelsByGroup( argumentCollection = local.servicesArgs ) />
            
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
              <cfset prc.i = 1 />
              <cfset prc.nothanks = 1 />
              <cfloop query="serviceLabels">
                <cfset prc.serviceCounter = prc.serviceCounter + 1 />

                <div class="checkbox">
                  <label>
                    <input type="#prc.groupInputType#"
                          name="chk_features_#prc.groupLabels.serviceMasterGroupGuid#"
                          id="chk_features_#serviceLabels.productId[serviceLabels.currentRow]#"
                          value="#serviceLabels.productId[serviceLabels.currentRow]#"

                          <cfif listFindNoCase(prc.selectedServices, serviceLabels.productId[serviceLabels.currentRow])>
                            <cfset prc.nothanks = 0 />
                            checked
                          <cfelseif len(serviceLabels.recommendationId[serviceLabels.currentRow]) or prc.i eq prc.defaultIndex>
                            <cfset prc.nothanks = 0 />
                            checked
                          </cfif>

                          onchange="onChangeHandler(this.form,this.form.paymentoption.value)" />

                    <a type="button" data-toggle="modal" data-target="##featureModal" href="#event.buildLink('devicebuilder.featuremodal')#/cartLineNumber/#rc.cartLineNumber#/fid/#serviceLabels.productId#">
                      #trim(serviceLabels.label)#
                      <!--- (#serviceLabels.productId#) --->
                    </a>
                    #dollarFormat(serviceLabels.monthlyFee)#/mo
                    <!--- <cfif rc.paymentoption is 'financed' and (len(serviceLabels.FinancedPrice))>
                      #dollarFormat(serviceLabels.FinancedPrice)#/mo
                    <cfelse>
                      #dollarFormat(serviceLabels.monthlyFee)#/mo
                    </cfif> --->
                  </label>
                </div>
                <cfset prc.i = (prc.i + 1) />
              </cfloop>

              <cfif prc.hasNoneOption>
                <cfparam name="prc.nothanks" default="1" />
                <div class="checkbox">
                  <label>
                    <input type="#prc.groupInputType#"
                          name="chk_features_#prc.groupLabels.serviceMasterGroupGuid#" 
                          <cfif prc.nothanks eq 1>
                            checked
                          </cfif>

                          onchange="onChangeHandler(this.form,this.form.paymentoption.value)" />

                    <!--- No thanks --->
                    No #trim(prc.groupLabels.label)# Option
                    
                  </label>
                </div>
              </cfif>

            </cfif>

          </cfloop>
          
          <input type="hidden" name="serviceCounter" value="#prc.serviceCounter#" />

        </section>

        <div class="right">
          <a href="#prc.prevStep#">BACK</a>
          <button type="submit" class="btn btn-primary btnContinue" id="btnContinue" 
            <cfif isDefined("prc.subscriber.downPayment") and prc.subscriber.downPayment gt 0 and rc.isDownPaymentApproved eq 0>
              disabled
            </cfif>
            >
            Continue
          </button>
        </div>

      </form>
    </section>

    

    <div class="legal">
      <p>Legal Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed diam eget risus varius blandit sit amet non magna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Cras mattis consectetur purus sit amet fermentum. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Aenean lacinia bibendum nulla sed consectetur.</p>
      <p>**Legal Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed diam eget risus varius blandit sit amet non magna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Cras mattis consectetur purus sit amet fermentum. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Aenean lacinia bibendum nulla sed consectetur.</p>
      <p>†Legal Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed diam eget risus varius blandit sit amet non magna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Cras mattis consectetur purus sit amet fermentum. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Aenean lacinia bibendum nulla sed consectetur.</p>
    </div>

  </div>

  <div class="modal fade" id="protectionModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="true">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
      </div>
    </div>
  </div>
  <div class="modal fade" id="featureModal" tabindex="-2" role="dialog" aria-hidden="true" data-backdrop="static" data-keyboard="true">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
      </div>
    </div>
  </div>

  <script type="text/javascript">
    function onChangeHandler(form,paymentoption) {
      form.action='#event.buildLink('devicebuilder.protection')#';
      form.paymentoption.value=paymentoption;
      form.submit();
    }    
  </script>

  <cfif isDefined("prc.subscriber.downPayment") and prc.subscriber.downPayment gt 0>
    <script>
      $('##isDownPaymentApproved').click(function() {
          var $this = $(this);
          // $this will contain a reference to the checkbox   
          if ($this.is(':checked')) {
              // the checkbox was checked 
              $('.btnContinue').prop('disabled', false);
          } else {
              // the checkbox was unchecked
              $('.btnContinue').prop('disabled', true);
          }
      });
    </script>
  </cfif>

  <cfif prc.serviceCounter gt 0>
    <script>
      $(function() {
        $('##h4AdditionalServices').show();
      });
    </script>
  </cfif>

</cfoutput>
