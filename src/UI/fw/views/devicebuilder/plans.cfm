<cfparam name="prc.activetab" default="individual" />
<cfparam name="prc.existingPlanEligible" default="false" />

<cfoutput>
  <div class="col-md-12">
    <form action="#prc.nextStep#" method="post">
      <input type="hidden" name="finance" value="#rc.finance#" />
      <input type="hidden" name="type" value="#rc.type#" />
      <input type="hidden" name="pid" value="#rc.pid#" />
      <input type="hidden" name="cartLineNumber" value="#rc.cartLineNumber#" />
      <cfif structKeyExists(rc,"paymentoption")>
        <input type="hidden" name="paymentoption" value="#rc.paymentoption#" />
      </cfif>
      <cfif structKeyExists(rc,"line")>
        <input type="hidden" name="line" value="#rc.line#" />
      </cfif>
      <section class="content">
        <header class="main-header">
          <h1>Pick Your Plan and Data</h1>
          <p>Pick a Plan and the amount of Data you will use per month. <!--- ( ZIP: #session.cart.getZipcode()# ) --->
          <!--- DEBUG: --->
          <!--- Launch Zip Modal button for testing --->
          <!--- <cfif rc.type is 'new'>
            <a data-toggle="modal" href="##zipModal" class="btn btn-primary btn-sm">Zip modal</a></p>
          </cfif> --->
          <!--- <a data-toggle="modal" href="##planModal" class="btn btn-primary btn-sm">Plan modal</a></p> --->
        </header>
        <ul class="nav nav-tabs">
          
          <!--- EXISTING --->
          <cfif structKeyExists(session,"carrierObj") and structKeyExists(prc,"planDataExisting") >
            <li role="presentation" <cfif prc.activetab is 'existing'>class="active"</cfif> >
              <a href="##existing" aria-controls="shared" role="tab" data-toggle="tab">Existing Plans</a>
            </li>
          </cfif>
          
          <!--- INDIVIDUAL --->
          <li role="presentation" <cfif prc.activetab is 'individual'>class="active"</cfif> >
            <a href="##individual" aria-controls="individual" role="tab" data-toggle="tab">Individual Plans</a>
          </li>
          
          <!--- SHARED --->
          <cfif prc.planDataShared.recordcount>
            <li role="presentation">
              <a href="##shared" aria-controls="shared" role="tab" data-toggle="tab">Shared Plans</a>
            </li>
          </cfif>

        </ul>

        <div class="tab-content plans">
          
          <!--- EXISTING --->
          <cfif structKeyExists(session,"carrierObj") and structKeyExists(prc,"planDataExisting") >
            <div role="tabpanel" class="tab-pane <cfif prc.activetab is 'existing'>active</cfif>" id="existing">
              <div class="carousel" id="existingCarousel">
              <cfif prc.planDataExisting.recordcount>
                <cfloop query="prc.planDataExisting">
                  <div class="info">
                    <a href="##">
                      <h3 style="height:40px"><span>#prc.planDataExisting.DetailTitle# - Existing</span></h3>
                      <ul>
                        <li class="large"><span>#prc.planDataExisting.DataLimitGB# GB</span></li>
                      </ul>
                      <div style="align:center;padding:20px;">#prc.planDataExisting.SummaryDescription#</div>
                      <div class="price">#dollarFormat(prc.planDataExisting.MonthlyFee)#</div>
                      <cfif prc.existingPlanEligible>
                        <button class="btn btn-dark-gray btn-block" name="plan" value="#prc.planDataExisting.productid#">Select Package</button>
                        <div class="details-link" data-toggle="modal" data-target="##planModal" 
                          href="#event.buildLink('devicebuilder.planmodal')#/pid/#rc.pid#/type/#rc.type#/plan/#prc.planDataExisting.productid#/finance/#rc.finance#/line/#rc.line#/cartLineNumber/#rc.cartLineNumber#" >Plan Details</div>
                      <cfelse>
                        <button class="btn btn-secondary btn-block" disabled="disabled">Unavailable for this device</button>
                      </cfif>
                    </a>
                  </div>
                </cfloop>
              <cfelse>
                <div class="info">
                  <a href="##">
                  <h3 style="height:40px"><span>Your Existing Plan - Existing</span></h3>
                    <ul>
                      <li class="large"><span>Unknown GB</span></li>
                      <!--- <div style="align:center;padding:20px;">Description - unavailable</div> --->
                      <div class="price">Price - unavailable</div>
                      <button class="btn btn-secondary btn-block" disabled="disabled">Unavailable for this device</button>
                    </ul>
                  </a>
                </div>
              </cfif>


              </div>
            </div> <!--- tab-pane --->
          </cfif>
          
          <!--- INDIVIDUAL --->
          <div role="tabpanel" class="tab-pane <cfif prc.activetab is 'individual'>active</cfif>" id="individual">
            <div class="carousel" id="individualCarousel">
              
              <cfloop query="prc.planData">
                <div class="info">
                  <!--- <a data-toggle="modal" data-target="##planModal"  href="#event.buildLink('devicebuilder.planmodal')#/plan/#prc.planData.productid#" >
                  Launch Modal</a> --->
                  <a href="##">
                    <h3 style="height:40px"><span>#prc.planData.DetailTitle#</span></h3>
                    <ul>
                      <li class="large"><span>#prc.planData.DataLimitGB#GB</span></li>
                    </ul>
                    <div style="align:center;padding:20px;">#prc.planData.SummaryDescription#</div>
                    <div class="price">$#int(prc.planData.MonthlyFee)#<!--- #dollarFormat(prc.planData.MonthlyFee)# ---></div>
                    <button class="btn btn-secondary btn-block" name="plan" value="#prc.planData.productid#">Select Package</button>
                    <div class="details-link" data-toggle="modal" data-target="##planModal" 
                      href="#event.buildLink('devicebuilder.planmodal')#/pid/#rc.pid#/type/#rc.type#/plan/#prc.planData.productid#/finance/#rc.finance#<cfif structKeyExists(rc,"line")>/line/#rc.line#</cfif>/cartLineNumber/#rc.cartLineNumber#" >Plan Details</div>
                  </a>
                </div>
              </cfloop>
              
            </div>
          </div> <!--- tab-pane --->
          
          <!--- SHARED --->
          <cfif prc.planDataShared.recordcount>
            <div role="tabpanel" class="tab-pane" id="shared">
              <div class="carousel" id="sharedCarousel">
                
                <cfloop query="prc.planDataShared">
                  <div class="info">
                    <a href="##">
                      <h3 style="height:40px"><span>#prc.planDataShared.DetailTitle#</span></h3>
                      <ul>
                        <li class="large"><span>#prc.planDataShared.DataLimitGB#GB</span></li>
                      </ul>
                      <div style="align:center;padding:20px;">#prc.planDataShared.SummaryDescription#</div>
                      <div class="price">$#int(prc.planDataShared.MonthlyFee)#<!--- #dollarFormat(prc.planDataShared.MonthlyFee)# ---></div>
                      <button class="btn btn-secondary btn-block" name="plan" value="#prc.planDataShared.productid#">Select Package</button>
                      <div class="details-link" data-toggle="modal" data-target="##planModal" 
                        href="#event.buildLink('devicebuilder.planmodal')#/pid/#rc.pid#/type/#rc.type#/plan/#prc.planDataShared.productid#/finance/#rc.finance#<cfif structKeyExists(rc,"line")>/line/#rc.line#</cfif>/cartLineNumber/#rc.cartLineNumber#" >Plan Details</div>
                    </a>
                  </div>
                </cfloop>

              </div>
            </div> <!--- tab-pane --->
          </cfif>

        </div> <!--- tab-content plans --->
        <div class="legal">
          <p>Legal Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed diam eget risus varius blandit sit amet non magna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Cras mattis consectetur purus sit amet fermentum. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Aenean lacinia bibendum nulla sed consectetur.</p>
          <p>**Legal Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed diam eget risus varius blandit sit amet non magna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Cras mattis consectetur purus sit amet fermentum. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Aenean lacinia bibendum nulla sed consectetur.</p>
          <p>†Legal Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed diam eget risus varius blandit sit amet non magna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Cras mattis consectetur purus sit amet fermentum. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Aenean lacinia bibendum nulla sed consectetur.</p>
        </div>
      </section>
    </form>
  </div>




</cfoutput>


<!--- <DEBUG --->
                  <!--- <cfif structKeyExists(session,"carrierObj")>
                    <cfdump var="#session.carrierObj#">
                  </cfif>
                  <!--- <cfdump var="#prc.planData#"> --->
                  <cfdump var="#session.cart.getCurrentLineData#">

                  <b>DEBUG INFO:</b> 
                  <br>
                  application.model.CartHelper.zipcodeEntered(): #application.model.CartHelper.zipcodeEntered()#
                  <br>
                  isStruct(session.cart): #isStruct(session.cart)#
                  <br>
                  <b>end debug info...</b>
                  <hr> --->
<!--- <cfdump var="#prc.subscriber.getRatePlan()#">
<br>
<cfdump var="#prc.planData#"> --->
<!--- <cfdump var="#prc.subscriber.getNumber()#"> --->
<!--- <end debug --->
