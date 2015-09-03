<cfoutput>
    <div class="col-md-12">
      <section class="content">
        <cfif structKeyExists(prc,"warningMessage")>
          <p class="bg-warning" style="padding:10px">#prc.warningMessage#</p>
        </cfif>
        <header class="main-header">
          <h1>Cart</h1>
        </header>
        <form>
          <div class="pull-right">
            <cfif prc.showAddAnotherDeviceButton>
              <a href="#prc.addxStep#">ADD ANOTHER DEVICE</a>
            </cfif>
            <cfif prc.showCheckoutnowButton>
              <button type="submit" class="btn btn-primary">Checkout Now</button>
            </cfif>
          </div>
          <div class="content">
            <div class="row hidden-xs">
              <div class="head">
                <div class="col-md-2">Item</div>
                <div class="col-md-8"></div>
                <div class="col-md-2">Quantity</div>
                <div class="col-md-2">Monthly</div>
                <div class="col-md-2">Due Today</div>
              </div>
            </div>
            <div class="row">
              <div class="col-md-2 col-xs-6 item">
                <img class="img-responsive" id="prodDetailImg" src="#prc.productImages[1].imagesrc#" border="0" width="100" alt="#prc.productImages[1].imageAlt#"/>
              </div>
              <div class="col-md-8 col-xs-10 data">
                <h3>#prc.productData.summaryTitle#</h3>
                <p>Includes: 3GB Data, Unlimited Talk, Unlmited Text, Mobile Hotspot, Line Access Fee</p>
              </div>
              <div class="col-md-2 col-xs-16 quantity"></div>
              <div class="col-md-2 col-xs-16 monthly">$65.00 <span class="visible-xs-inline">Monthly</span></div>
              <div class="col-md-2 col-xs-16 due"></div>

              <div class="col-md-2 col-xs-16"></div>
              <div class="col-md-14 col-xs-16">

                <div class="row">
                  <div class="collapse" id="plan-details1">
                    <div class="col-md-12 col-xs-11">Apple iPhone 6 64GB - Space Gray</div>
                    <div class="col-md-4 col-xs-5">$50.00</div>

                    <div class="col-md-12 col-xs-11">Apple iPhone 6 64GB - Space Gray</div>
                    <div class="col-md-4 col-xs-5">$50.00</div>

                    <div class="col-md-12 col-xs-11">Apple iPhone 6 64GB - Space Gray</div>
                    <div class="col-md-4 col-xs-5">$50.00</div>

                    <div class="col-md-12 col-xs-11">Apple iPhone 6 64GB - Space Gray</div>
                    <div class="col-md-4 col-xs-5">$50.00</div>
                  </div>
                </div>
                <a
                  role="button"
                  class="plan-details collapsed"
                  data-toggle="collapse"
                  href="##plan-details1"
                  aria-expanded="false"
                  aria-controls="plan-details1">Show Plan Details</a>
              </div>
            </div>
            <div class="row">
              <div class="col-md-2 col-xs-6 item">
                <img src="https://placeholdit.imgix.net/~text?txtsize=12&txt=80px&w=80&h=80" alt="device picture" />
              </div>
              <div class="col-md-8 col-xs-10 data">
                <h3>Manufacturer, Model, Memory, and Color</h3>
                <p>(425) 977-XXXX<br>
                  Includes: SquareTrade Prod Line Access Fee</p>
              </div>
              <div class="col-md-2 col-xs-16 quantity">
                <select class="form-control">
                  <option>1</option>
                  <option>2</option>
                </select>
                <a href="##">Remove</a>
              </div>
              <div class="col-md-2 col-xs-16 monthly">$76.99 <span class="visible-xs-inline">Monthly</span></div>
              <div class="col-md-2 col-xs-16 due">$199.99 <span class="visible-xs-inline">Due Today</span></div>

              <div class="col-md-2 col-xs-16"></div>
              <div class="col-md-14 col-xs-16">

                <div class="row">
                  <div class="collapse" id="plan-details2">
                    <div class="col-md-12 col-xs-11">Apple iPhone 6 64GB - Space Gray</div>
                    <div class="col-md-4 col-xs-5">$50.00</div>

                    <div class="col-md-12 col-xs-11">Apple iPhone 6 64GB - Space Gray</div>
                    <div class="col-md-4 col-xs-5">$50.00</div>

                    <div class="col-md-12 col-xs-11">Apple iPhone 6 64GB - Space Gray</div>
                    <div class="col-md-4 col-xs-5">$50.00</div>

                    <div class="col-md-12 col-xs-11">Apple iPhone 6 64GB - Space Gray</div>
                    <div class="col-md-4 col-xs-5">$50.00</div>
                  </div>
                </div>
                <a role="button"
                  class="plan-details collapsed"
                  data-toggle="collapse"
                  href="##plan-details2"
                  aria-expanded="false"
                  aria-controls="plan-details2">Show Plan Details</a>
              </div>
            </div>
          </div>
        </form>
      </section>
    </div>
    <div class="col-md-4">
      <cfif prc.showClearCartLink>
        <a href="#prc.clearCartAction#" class="clear">Clear Entire Cart</a>
      <cfelse>
        <a href="#prc.browseDevicesUrl#" class="clear">Browse Devices</a>
      </cfif>
      
      <!--- 
      //TODO:
        The link "Clear Entire Cart" needs to 
          - drop carrierObj and ZipCode from the session
          - clear any devices, plans, accessories, etc. that the user has added to their cart view the devicebuilder.
       --->
      <div class="sidebar">
        <h4>Have Questions?</h4>
        <ul>
          <li><a href="##">Call us at 1-800-555-1212</a></li>
          <li><a href="##">Chat with one of our representatives</a></li>
          <li><a href="##">E-mail one of our experts</a></li>
          <li><a href="##">Frequently Asked Questions</a></li>
        </ul>
        <h4>Our Signature Promise</h4>
        <ul>
          <li><a href="##">Free UPS ground shipping</a></li>
          <li><a href="##">90 day return policy</a></li>
          <li><a href="##">Return in store</a></li>
        </ul>
      </div>
    </div>
  </div>
  <div class="row summary">
    <div class="col-md-12">

      <div class="col-md-16 promo">
        <div class="form-inline">
          <div class="form-group">
            <label for="promoInputName">Promotional Code</label>
            <input type="text" class="form-control input-sm" id="promoInputName">
          </div>
          <button type="submit" class="btn btn-default btn-sm">Apply</button>
        </div>
      </div>
      <div class="row">
      <div class="col-md-10 col-md-offset-6">
        <div class="table-wrap">
        <table class="table table-responsive">
          <thead>
          <tr class="head">
            <th colspan="3">Order Summary</th>
          </tr>
          <tr>
            <th></th>
            <th>Monthly Price</th>
            <th>Due Now</th>
          </tr>
          </thead>
          <tbody>
          <tr>
            <td>Sub-Total</td>
            <td>$141.66</td>
            <td>$209.98</td>
          </tr>
          <tr>
            <td>Shipping</td>
            <td></td>
            <td>FREE</td>
          </tr>
          <tr>
            <td>
              <div class="form-inline">
                <div class="form-group">
                  <label for="taxInputName">Est. Tax</label>
                  <input type="text" class="form-control input-sm" id="taxInputName">
                </div>
                <button type="submit" class="btn btn-default btn-sm">Apply</button>
              </div>
            </td>
            <td></td>
            <td>$22.00</td>
          </tr>
          <tr>
            <td>Discount Code: SPL10OFF</td>
            <td></td>
            <td>$22.00</td>
          </tr>
          </tbody>
          <tfoot>
          <tr>
            <td>Total Due Today</td>
            <td colspan="2">$209.98</td>
          </tr>
          <tr>
            <td>Total Due Monthly</td>
            <td colspan="2">$219.32</td>
          </tr>
          </tfoot>
        </table>
        </div>
      </div>
      </div>
      <div class="pull-right">
        <a href="##">ADD ANOTHER DEVICE</a>
        <button type="submit" class="btn btn-primary">Checkout Now</button>
      </div>
    </div>

    <div class="col-md-12">
      <p class="legal">*Legal Goes Here: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed diam eget risus varius blandit sit amet non magna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Cras mattis consectetur purus sit amet fermentum.</p>
    </div>
  </div>
</div>

</cfoutput>
