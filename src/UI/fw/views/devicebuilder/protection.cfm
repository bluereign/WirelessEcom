<cfoutput>
  <div class="col-md-12">
    <section class="content">
      <header class="main-header">
        <h1>Payment, Protection &amp; Services Plans</h1>
        <p>The following services are available for your device based on your plan.</p>
      </header>
      <form action="#prc.nextStep#" method="post">
        <div class="pull-right">
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
          <h4>CARRIER Device Payment Options</h4>
          <div class="radio">
            <label>
              <input type="radio" name="devicePayment" id="optionsDevicePayment1" value="devicePayment1" checked>
              <select class="form-control">
                <option>Financing Option 1: $21.67/mo</option>
                <option>2</option>
                <option>3</option>
                <option>4</option>
                <option>5</option>
              </select>
              CARRIER is requiring a down payment
              <div class="checkbox">
                <label>
                  <input type="checkbox" value="">
                  <a href="##">I Agree to the required CARRIER down payment of:</a> $XX.XX
                </label>
              </div>
            </label>
          </div>
          <div class="radio">
            <label>
              <input type="radio" name="devicePayment" id="optionsDevicePayment2" value="devicePayment2">
              Full Retail Price $599.99
            </label>
          </div>
        </section>
        <section>
          <h4>Device Protection Options</h4>
          <a href="##">Help me choose a Protection Plan</a>
          <div class="radio">
            <label>
              <input type="radio" name="deviceProtection" id="optionsDeviceProtection1" value="deviceProtection1" checked>
              No Equipment Protection Plan
            </label>
          </div>
          <div class="radio">
            <label>
              <input type="radio" name="deviceProtection" id="optionsDeviceProtection1" value="deviceProtection1">
              <a href="##"
                type="button"
                data-toggle="modal"
                data-target="##carrierMobileProtectionModal">Carrier Mobile Protection Pack</a> $3.00/mo
            </label>
          </div>
          <div class="radio">
            <label>
              <input type="radio" name="deviceProtection" id="optionsDeviceProtection1" value="deviceProtection1">
              <a href="##">SquareTrade Device Protection</a> $99.99
            </label>
          </div>
          <!-- Carrier Mobile Protection Modal -->
          <div class="modal fade" id="carrierMobileProtectionModal" tabindex="-1" role="dialog" aria-labelledby="carrierMobileProtectionModalLabel">
            <div class="modal-dialog" role="document">
              <div class="modal-content">
                <div class="modal-header">
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                  <h4 class="modal-title" id="carrierMobileProtectionModalLabel">Carrier Mobile Protection Pack</h4>
                  <p>Protection provided to you from your carrier for your new device.</p>
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
        <section>
          <h4>Additional Service</h4>
          <div class="checkbox">
            <label>
              <input type="checkbox" value="">
              <a href="##" type="button" data-toggle="modal" data-target="##roadsideModal">Roadside Assistance</a> $2.99/mo
            </label>
          </div>
          <div class="checkbox">
            <label>
              <input type="checkbox" value="">
              <a href="##">Navigation Subscription</a> $9.99/mo
            </label>
          </div>
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
        <div class="pull-right">
          <a href="#prc.prevStep#">BACK</a>
          <button type="submit" class="btn btn-primary btn-block">Continue</button>
        </div>
      </form>
    </section>
    <div class="legal">
      <p>Legal Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed diam eget risus varius blandit sit amet non magna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Cras mattis consectetur purus sit amet fermentum. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Aenean lacinia bibendum nulla sed consectetur.</p>
      <p>**Legal Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed diam eget risus varius blandit sit amet non magna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Cras mattis consectetur purus sit amet fermentum. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Aenean lacinia bibendum nulla sed consectetur.</p>
      <p>†Legal Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed diam eget risus varius blandit sit amet non magna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Cras mattis consectetur purus sit amet fermentum. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Aenean lacinia bibendum nulla sed consectetur.</p>
    </div>
  </div>
</cfoutput>
