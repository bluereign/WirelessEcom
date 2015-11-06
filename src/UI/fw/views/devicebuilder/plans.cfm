<cfparam name="prc.activetab" default="shared" />
<cfparam name="prc.existingPlanEligible" default="false" />

<cfoutput>
  <div class="col-md-12">

    <form action="#prc.nextStep#" method="post">
      <input type="hidden" name="cartLineNumber" value="#rc.cartLineNumber#" />
      <input type="hidden" name="HasExistingPlan" value="No" />

      <section class="content plans">

        <header class="main-header">
          <h1>Pick Your Plan and Data</h1>
          <p>Pick a Plan and the amount of Data you will use per month.</p> <!--- ( ZIP: #session.cart.getZipcode()# ) --->
        </header>
		
    		<cfif structKeyExists(session,"carrierObj")>
      		<div class="plan-chooser">
      			<button class="btn btn-primary btn-block keep-your-existing-plan" id="keep-your-existing-plan" onclick="this.form.HasExistingPlan.value='Yes';">Keep Your Existing Plan</button>
      			<span class="plan-seperator">OR</span>
      			<button class="btn btn-secondary btn-block" id="choose-a-new-plan">Choose A New Plan</button>
      		</div>
    		</cfif>
		
    		<cfif structKeyExists(session,"carrierObj") and structKeyExists(prc,"planDataExisting") >
    			<div id="plan-options" style="display:none;">
    				<div class="plan-seperator">OR</div>
    		<cfelse>
    			<div id="plan-options">
    		</cfif>
    			<ul class="nav nav-tabs">
    			  
            <!--- INDIVIDUAL --->
    			  <!--<li role="presentation" <cfif prc.activetab is 'individual'>class="active"</cfif> >
    				  <a href="##individual" aria-controls="individual" role="tab" data-toggle="tab">Individual Plans</a>
    			  </li>-->
    			  
    			  <!--- SHARED --->
    			  <cfif prc.planDataShared.recordcount>
      				<li role="presentation" <cfif prc.activetab is 'shared'>class="active"</cfif>>
      				  <a href="##shared" aria-controls="shared" role="tab" data-toggle="tab">Choose A New Plan</a>
      				</li>
    			  </cfif>

    			</ul>

          <div class="tab-content plans-carousel">
          
            <!--- INDIVIDUAL --->
            <div role="tabpanel" class="tab-pane <cfif prc.activetab is 'individual'>active</cfif>" id="individual">
              <div class="carousel" id="individualCarousel">
                
                <cfloop query="prc.planData">
                  <div class="info">
                    <a href="##">
                      <h3><span>#prc.planData.DetailTitle#</span></h3>
                      <ul>
                        <li class="large"><span>#prc.planData.DataLimitGB#GB</span></li>
                      </ul>
                      #prc.planData.SummaryDescription#
                      <div class="price">$#int(prc.planData.MonthlyFee)#</div>
                      <button class="btn btn-primary btn-block" name="planid" value="#prc.planData.productid#">Select Plan</button>
                      <div class="details-link" data-toggle="modal" data-target="##planModal" 
                        href="#event.buildLink('devicebuilder.planmodal')#/plan/#prc.planData.productid#/cartLineNumber/#rc.cartLineNumber#">Plan Details </div>
                    </a>
                  </div>
                </cfloop>
                
              </div>
            </div> <!--- tab-pane --->
          
            <!--- SHARED --->
            <cfif prc.planDataShared.recordcount>
              <div role="tabpanel" class="tab-pane <cfif prc.activetab is 'shared'>active</cfif>" id="shared">
                <div class="carousel" id="sharedCarousel">
                  
                  <cfloop query="prc.planDataShared">
                    <div class="info <cfif #prc.planDataShared.DataLimitGB# eq 2 or #prc.planDataShared.DataLimitGB# eq 3>featured</cfif>">
                      <a href="##">
                        <h3><span>#prc.planDataShared.DetailTitle#</span></h3>
                        <ul>
                          <li class="large">Total Data Included:<span>#prc.planDataShared.DataLimitGB#GB</span></li>
                        </ul>
                        #prc.planDataShared.SummaryDescription#
                        <div class="price">$#int(prc.planDataShared.MonthlyFee)#</div>
                        <button class="btn btn-primary btn-block" name="planid" value="#prc.planDataShared.productid#">Select Plan</button>
                        <div class="details-link" data-toggle="modal" data-target="##planModal" 
                          href="#event.buildLink('devicebuilder.planmodal')#/plan/#prc.planDataShared.productid#/cartLineNumber/#rc.cartLineNumber#">Plan Details</div>
                      </a>
                    </div>
                  </cfloop>

                </div>
              </div> <!--- tab-pane --->
            </cfif>

          </div> <!--- tab-content plans --->
		    </div>
        <div class="bs-callout bs-callout-warning switchWarning">
          <h4>Choosing a new plan will replace your existing plan</h4>
        </div>
      </section>

    </form>
		
  </div>
</cfoutput>
