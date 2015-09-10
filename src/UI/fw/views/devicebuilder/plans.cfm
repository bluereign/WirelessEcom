<cfoutput>
<!--- <DEBUG --->
                  <cfif structKeyExists(session,"carrierObj")>
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
                  <hr>
<!--- <end debug --->

  <div class="col-md-12">
    <form action="#prc.nextStep#">
      <section class="content">
        <header class="main-header">
          <h1>Pick Your Plan and Data</h1>
          <p>Pick a Plan and the amount of Data you will use per month. <!--- ( ZIP: #session.cart.getZipcode()# ) --->
          <!--- Launch Zip Modal button for testing
          <cfif rc.type is 'new'>
            <a data-toggle="modal" href="##zipModal" class="btn btn-primary btn-sm">Zip modal</a></p>
          </cfif> --->
        </header>
        <ul class="nav nav-tabs">
          
          <li role="presentation" class="active">
            <a href="##individual" aria-controls="individual" role="tab" data-toggle="tab">Individual Plans</a>
          </li>
          
          <cfif prc.planDataShared.recordcount>
            <li role="presentation">
              <a href="##shared" aria-controls="shared" role="tab" data-toggle="tab">Shared Plans</a>
            </li>
          </cfif>

          <cfif structKeyExists(session,"carrierObj")>
            <li role="presentation">
              <a href="##existing" aria-controls="shared" role="tab" data-toggle="tab">Existing Plans</a>
            </li>
          </cfif>

        </ul>

        <div class="tab-content plans">
          
          <div role="tabpanel" class="tab-pane active" id="individual">
            <div class="carousel" id="individualCarousel">
              
              <cfloop query="prc.planData">
                <div class="info">
                  <a href="##">
                    <h3 style="height:40px"><span>#prc.planData.DetailTitle#</span></h3>
                    <ul>
                      <li class="large"><span>#prc.planData.DataLimitGB#GB</span></li>
                    </ul>
                    <div style="align:center;padding:20px;">#prc.planData.SummaryDescription#</div>
                    <div class="price">$#int(prc.planData.MonthlyFee)#<!--- #dollarFormat(prc.planData.MonthlyFee)# ---></div>
                    <button class="btn btn-dark-gray btn-block">Select Package</button>
                    <div class="details-link">Plan Details</div>
                  </a>
                </div>
              </cfloop>
              
            </div>
          </div> <!--- tab-pane --->

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
                      <button class="btn btn-dark-gray btn-block">Select Package</button>
                      <div class="details-link">Plan Details</div>
                    </a>
                  </div>
                </cfloop>

              </div>
            </div> <!--- tab-pane --->
          </cfif>
          
          <cfif structKeyExists(session,"carrierObj")>
            <div role="tabpanel" class="tab-pane" id="existing">
              <div class="carousel" id="existingCarousel">
                

                ...

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
