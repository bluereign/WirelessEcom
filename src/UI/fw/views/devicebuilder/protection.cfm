<cfparam name="rc.planIdentifier" default="" />

<!--- <cfdump var="#prc.arrayPaymentPlans#"> --->
<!--- <cfdump var="#prc.cartLine.getCartLineActivationType()#"> --->
<!--- <cfdump var="#prc.cartLine.getPaymentPlanDetail()#"> --->
<cfsilent>
  <cfset local.financedMonthCount24 = application.model.dBuilderCartFacade.ActivationTypeMonths(activationType="financed-24-upgrade") />
  <cfset local.financedMonthCount18 = application.model.dBuilderCartFacade.ActivationTypeMonths(activationType="financed-18-upgrade") />
  <cfset local.financedMonthCount12 = application.model.dBuilderCartFacade.ActivationTypeMonths(activationType="financed-12-upgrade") />
</cfsilent>

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
          <input type="hidden" name="hasDeclinedDeviceProtection" id="hasDeclinedDeviceProtection" value="0" />
          <a href="#prc.prevStep#">BACK</a>
          <button type="button" class="btn btn-primary btnContinue" id="btnContinue" data-toggle="modal" data-target=""
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
              <input type="radio" name="paymentoption" id="paymentoption" value="financed" <cfif prc.paymentoption is 'financed'>checked</cfif> onchange="onChangeHandler(this.form,'financed')">
              
              <cfif prc.productData.CarrierId eq prc.carrierIdAtt>
                <select name="planIdentifier" id="planIdentifier" class="form-control">
                  <cfloop index="i" from="1" to="#arrayLen(prc.arrayPaymentPlans)#">
                    <option 
                      value="#prc.arrayPaymentPlans[i].planIdentifier#" 
                      data-months="#prc.arrayPaymentPlans[i].minimumCommitment#" 
                      data-downPaymentPercent="#prc.arrayPaymentPlans[i].downPaymentPercent#"
                      data-downPaymentAmount="#decimalFormat((prc.arrayPaymentPlans[i].downPaymentPercent/100) * prc.productData.FinancedFullRetailPrice)#"
                      <cfif rc.planIdentifier is prc.arrayPaymentPlans[i].planIdentifier>
                        selected
                      </cfif>>
                      #prc.financeproductname# #mid(prc.arrayPaymentPlans[i].planIdentifier,4,2)#: #dollarFormat(prc.arrayPaymentPlans[i].monthlyPayment)# Due Monthly for #prc.arrayPaymentPlans[i].minimumCommitment# Months
                      <cfif prc.arrayPaymentPlans[i].downPaymentPercent> 
                        with Down Payment of #prc.arrayPaymentPlans[i].downPaymentPercent#% (#dollarFormat((prc.arrayPaymentPlans[i].downPaymentPercent/100) * prc.productData.FinancedFullRetailPrice)#)
                      </cfif>
                    </option>
                  </cfloop>
                  <!--- <option id="option-financed-24" value="financed-24" data-months="#local.financedMonthCount24#" <cfif prc.financed is 'financed-24'>selected</cfif> >
                  </option>
                  <option id="option-financed-18" value="financed-18" data-months="#local.financedMonthCount18#" <cfif prc.financed is 'financed-18'>selected</cfif> >
                  </option>
                  <option id="option-financed-12" value="financed-12" data-months="#local.financedMonthCount12#" <cfif prc.financed is 'financed-12'>selected</cfif> >
                  </option> --->
                </select>

              <cfelseif prc.productData.CarrierId eq prc.carrierIdVzw>
                <input type="hidden" name="financed" value="financed-24">
                #prc.financeproductname#: #dollarFormat(prc.productData.FinancedMonthlyPrice24)# Due Monthly for 24 Months
              </cfif>

            </label>
            <div style="padding-left:20px;">
              <cfif prc.productData.carrierId eq prc.carrierIdAtt and prc.customerType is "upgrade">
                <div id="isOptionalDownPaymentAddedDiv" class="checkbox" <cfif prc.cartLine.getPhone().getPrices().getOptionalDownPmtAmt() eq 0>style="display:none;"</cfif>>
                  <label for="isOptionalDownPaymentAdded">
                    <input 
                      type="checkbox" 
                      value="1" 
                      name="isOptionalDownPaymentAdded" 
                      id="isOptionalDownPaymentAdded" 
                      data-downPaymentPercent="#prc.cartLine.getPhone().getPrices().getOptionalDownPmtPct()#"
                      data-downPaymentAmount="#decimalFormat(prc.cartLine.getPhone().getPrices().getOptionalDownPmtAmt())#"
                      dollar-amount="#decimalFormat(prc.cartLine.getPhone().getPrices().getOptionalDownPmtAmt())#" 
                      <!--- <cfif prc.cartLine.getPhone().getPrices().getOptionalDownPmtAmt()>checked</cfif>  --->
                      >
                    <div id="isOptionalDownPaymentAddedLabel">I Agree to the down payment of: #dollarFormat(prc.cartLine.getPhone().getPrices().getOptionalDownPmtAmt())#<div></label>
                </div>
              <cfelseif isDefined("prc.subscriber.downPayment") and prc.subscriber.downPayment gt 0>
                CARRIER is requiring a down payment
                <div class="checkbox">
                  <label>
                    <input type="checkbox" value="1" name="isDownPaymentApproved" id="isDownPaymentApproved" dollar-amount="#decimalFormat(prc.subscriber.downPayment)#" <cfif rc.isDownPaymentApproved>checked</cfif> >
                    I Agree to the required CARRIER down payment of: #dollarFormat(prc.subscriber.downPayment)#
                  </label>
                </div>
              <!--- <cfelseif prc.productData.carrierId eq prc.carrierIdAtt and prc.customerType is "upgrade" and prc.downPayment>
                <div class="checkbox">
                  <label style="width:350px;">
                    <input type="checkbox" value="1" name="isOptionalDownPaymentAdded" id="isOptionalDownPaymentAdded"  dollar-amount="#decimalFormat(prc.downPayment)#" <cfif prc.cartLine.getPhone().getPrices().getOptionalDownPmtAmt()>checked</cfif> >
                    Add an additional 30% down payment of #dollarFormat(prc.downPayment)# today
                  </label>
                </div> --->
              </cfif>
            </div>
          
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
                <cfif findNoCase("Apple",prc.qWarranty.SummaryTitle) && request.config.channelname neq "costco"><span class="actionLink" style="color:##009900;"> - Recommended</span></cfif>
              </label>
            </div>
          </cfloop>
          <div class="radio">
            <label>
              <input type="radio" name="warrantyid" id="warrantyoption_0" value="0" onchange="onChangeHandler(this.form,this.form.paymentoption.value)" <cfif prc.warrantyId eq 0>checked</cfif>  >
              No, I choose not to protect my #dollarFormat(prc.productData.FinancedFullRetailPrice)# device.
            </label>
          </div>

        </section>

        <cfif isQuery(prc.cartPlan) and prc.cartPlan.recordcount>
          <cfset prc.serviceCounter = 0>

          <section class="seperator">

            <hr />
            <h4 id="h4RequiredServices">Required Service</h4>

            
            <cfloop query="prc.groupLabels">

              <cfif prc.groupLabels.minSelected eq 1>
                
                <cfset local.servicesArgs = {
                  groupGUID = prc.groupLabels.ServiceMasterGroupGuid,
                  deviceId = prc.productData.productGuid,
                  showActiveOnly = true,
                  cartTypeId = prc.cartTypeId,
                  rateplanId = prc.cartPlan.productGuid
                  } />
                
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
                    <!--- <cfset prc.serviceCounter = prc.serviceCounter + 1 /> --->

                    <!--- Add this service productId to a list of required services for display in the Tallybox --->
                    <cfif !listFindNoCase(session.listRequiredServices,serviceLabels.productId)>
                      <cfset session.listRequiredServices = listAppend(session.listRequiredServices,serviceLabels.productId) />
                    </cfif>


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
                        </a>
                        #dollarFormat(serviceLabels.monthlyFee)#/mo
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

              </cfif> <!--- prc.groupLabels.minSelected eq 1 --->


            </cfloop>

          </section>





          <section class="seperator">

            <hr />
            <h4 id="h4AdditionalServices" style="display: none;">Additional Service</h4>

            <cfloop query="prc.groupLabels">

              <!--- Required services have a minSelected of 1 --->
              <cfif prc.groupLabels.minSelected neq 1>

                <cfset local.servicesArgs = {
                  groupGUID = prc.groupLabels.ServiceMasterGroupGuid,
                  deviceId = prc.productData.productGuid,
                  showActiveOnly = true,
                  cartTypeId = prc.cartTypeId,
                  rateplanId = prc.cartPlan.productGuid
                  } />
                
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
                    <!--- update serviceCounter --->
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
                        </a>
                        #dollarFormat(serviceLabels.monthlyFee)#/mo
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

              </cfif> <!--- prc.groupLabels.minSelected neq 1 --->

            </cfloop>
            
            <!--- <input type="hidden" name="serviceCounter" value="#prc.serviceCounter#" /> --->

          </section>


        <cfelse>
          <cfset prc.serviceCounter = 0 />
        </cfif>

        <div class="right">
          <a href="#prc.prevStep#">BACK</a>
          <button type="button" class="btn btn-primary btnContinue" id="btnContinue" data-toggle="modal" data-target=""
            <cfif isDefined("prc.subscriber.downPayment") and prc.subscriber.downPayment gt 0 and rc.isDownPaymentApproved eq 0>
              disabled
            </cfif>
            >
            Continue
          </button>
        </div>

      </form>
    </section>

  </div>

  <script type="text/javascript">
    
    function setFinancedOptions() {
      var financeproductname = '#replace(prc.financeproductname,"&amp;", "&")#';
      var monthCountFinanced24 = #local.financedMonthCount24#;
      var monthCountFinanced18 = #local.financedMonthCount18#;
      var monthCountFinanced12 = #local.financedMonthCount12#;

      var dueMonthlyFinanced24 = #prc.productData.FinancedMonthlyPrice24#;
      var dueMonthlyFinanced18 = #prc.productData.FinancedMonthlyPrice18#;
      var dueMonthlyFinanced12 = #prc.productData.FinancedMonthlyPrice12#;

      if($("##isOptionalDownPaymentAdded").is(':checked')) {
        dueMonthlyFinanced24 = #prc.dueMonthlyFinanced24AfterDownPayment#;
        dueMonthlyFinanced18 = #prc.dueMonthlyFinanced18AfterDownPayment#;
        dueMonthlyFinanced12 = #prc.dueMonthlyFinanced12AfterDownPayment#;
      }

      $('##option-financed-24').text(financeproductname + ' 24: $' + dueMonthlyFinanced24.toFixed(2) + ' Due Monthly for ' + monthCountFinanced24 + ' Months');
      $('##option-financed-18').text(financeproductname + ' 18: $' + dueMonthlyFinanced18.toFixed(2) + ' Due Monthly for ' + monthCountFinanced18 + ' Months');
      $('##option-financed-12').text(financeproductname + ' 12: $' + dueMonthlyFinanced12.toFixed(2) + ' Due Monthly for ' + monthCountFinanced12 + ' Months');
    }


    function onChangeHandler(form,paymentoption) {
      setFinancedOptions();
      form.paymentoption.value=paymentoption;
      $.post('#event.buildLink('devicebuilder.tallybox')#', $('##protectionForm').serialize(), function(data){
        $('##myTallybox').html( data )
      });
    }

    $(function() {
      
      // setFinancedOptions();


      $('.btnContinue').click(function(){
        <cfif listFindNoCase(session.hasDeclinedDeviceProtection,rc.cartLineNumber)>
          $('.btnContinue').attr('data-target', '');
          $('##protectionForm').submit();
        <cfelse>
          if ( $('input[name=warrantyid]:checked').val() == 0 ) {
            $('.btnContinue').attr('data-target', '##confirmNoProtectionModal');
          } else {
            $('.btnContinue').attr('data-target', '');
            $('##protectionForm').submit();
          }
        </cfif>
      });

      $('##isOptionalDownPaymentAdded').on('change', function() {
        var protectionvalue = $('input[name=paymentoption]:checked').val();
        onChangeHandler(protectionForm,protectionvalue);
      });

      <cfif prc.productData.carrierId eq prc.carrierIdAtt and prc.customerType is "upgrade">
        $('##planIdentifier').on('change', function() {
          var protectionvalue = 'financed';
          var selectedOption = $('##planIdentifier option:selected');
          var planIdentifier = selectedOption.val();
          var downPaymentPercent = selectedOption.attr('data-downPaymentPercent');
          var downPaymentAmount = selectedOption.attr('data-downPaymentAmount');
          if (downPaymentPercent > 0) {
            $('##isOptionalDownPaymentAdded').prop('checked', false);
            $('.btnContinue').prop('disabled', true);
            $('##isOptionalDownPaymentAddedDiv').show();
            $('##isOptionalDownPaymentAddedLabel').text('I Agree to the required CARRIER down payment of: $' + downPaymentAmount);
          } else {
            $('##isOptionalDownPaymentAdded').prop('checked', true);
            $('.btnContinue').prop('disabled', false);
            $('##isOptionalDownPaymentAddedDiv').hide();
          }

          onChangeHandler(protectionForm,protectionvalue);
        });

        $('##isOptionalDownPaymentAdded').click(function() {
          $('.btnContinue').attr('disabled', !this.checked);
        });
      </cfif>

    });

  </script>

  <cfif isDefined("prc.subscriber.downPayment") and prc.subscriber.downPayment gt 0>
    <script>
      $(function() {
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

 <!--- Submit the AJAX/Tallybox form post upon load to update tally box with the pre-selected required service --->
  <script>
    $(function() {
      
      <cfif prc.productData.carrierId eq prc.carrierIdAtt and prc.customerType is "upgrade">
        $('##planIdentifier').trigger('change');
      <cfelse>
        var protectionvalue = $('input[name=paymentoption]:checked').val();
        onChangeHandler(protectionForm,protectionvalue);
      </cfif>

    });
  </script>

</cfoutput>
