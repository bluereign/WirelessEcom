<cfoutput>
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
          <li role="presentation">
            <a href="##shared" aria-controls="shared" role="tab" data-toggle="tab">Shared Plans</a>
          </li>
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
                    <div class="details-link">Plan Details (tooltip)</div>
                  </a>
                </div>
              </cfloop>
              
            </div>
          </div>

          <div role="tabpanel" class="tab-pane" id="shared">
            <div class="carousel" id="sharedCarousel">
              
              <cfloop query="prc.planData">
                <cfif prc.planData.IsShared>
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
                </cfif>
              </cfloop>

            </div>
          </div> <!--- tab-pane --->

        </div> <!--- tab content plans --->
        <div class="legal">
          <p>Legal Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed diam eget risus varius blandit sit amet non magna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Cras mattis consectetur purus sit amet fermentum. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Aenean lacinia bibendum nulla sed consectetur.</p>
          <p>**Legal Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed diam eget risus varius blandit sit amet non magna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Cras mattis consectetur purus sit amet fermentum. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Aenean lacinia bibendum nulla sed consectetur.</p>
          <p>†Legal Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed diam eget risus varius blandit sit amet non magna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Cras mattis consectetur purus sit amet fermentum. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Aenean lacinia bibendum nulla sed consectetur.</p>
        </div>
      </section>
    </form>
  </div>
</cfoutput>
