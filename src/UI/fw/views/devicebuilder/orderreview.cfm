<cfoutput>

      <section class="content">
        <header class="main-header">
          <h1>Cart</h1>
        </header>
        <form>
          <div class="pull-right">
            <a href="##" class="btn">Add another device</a>
            <button type="submit" class="btn btn-primary btn-lg">Checkout Now</button>
          </div>
          <div class="content">
            <div class="row hidden-xs">
              <div class="head">
                <div class="col-lg-2 col-md-2">Item</div>
                <div class="col-lg-6 col-md-5"></div>
                <div class="col-lg-1 col-md-2">Quantity</div>
                <div class="col-lg-1 col-md-1">Monthly</div>
                <div class="col-lg-2 col-md-2">Due Today</div>
              </div>
            </div>
            <div class="row">
              <div class="col-lg-2 col-md-2 col-xs-4 item">
                <img src="https://placeholdit.imgix.net/~text?txtsize=12&txt=80px&w=80&h=80" alt="device picture" />
                <a href="##">Edit Plan</a>
              </div>
              <div class="col-lg-6 col-md-5 col-xs-8 data">
                <h3>Plan Name Goes Here</h3>
                <p> Includes: 3GB Data, Unlimited Talk, Unlmited Text, Mobile Hotspot, Line Access Fee</p>
                <a href="##">Show Plan Details</a>
              </div>
              <div class="col-lg-1 col-md-2 col-xs-12 quantity"></div>
              <div class="col-lg-1 col-md-1 col-xs-12 monthly">$65.00 <span class="visible-xs-inline">Monthly</span></div>
              <div class="col-lg-2 col-md-2 col-xs-12 due"></div>
            </div>
            <div class="row">
              <div class="col-lg-2 col-md-2 col-xs-4 item">
                <img src="https://placeholdit.imgix.net/~text?txtsize=12&txt=80px&w=80&h=80" alt="device picture" />
                <a href="##">Edit Options</a>
              </div>
              <div class="col-lg-6 col-md-5 col-xs-8 data">
                <h3>Manufacturer, Model, Memory, and Color</h3>
                <p>(425) 977-XXXX<br>
                  Includes: SquareTrade Prod Line Access Fee</p>
                <a href="##">Show Plan Details</a>
              </div>
              <div class="col-lg-1 col-md-2 col-xs-8 quantity">
                <select class="form-control">
                  <option>1</option>
                  <option>2</option>
                </select>
                <a href="##">Remove</a>
              </div>
              <div class="col-lg-1 col-md-1 col-xs-12 monthly">$76.99 <span class="visible-xs-inline">Monthly</span></div>
              <div class="col-lg-2 col-md-2 col-xs-12 due">$199.99 <span class="visible-xs-inline">Due Today</span></div>
            </div>
            <div class="row">
              <div class="col-lg-2 col-md-2 col-xs-4 item">
                <img src="https://placeholdit.imgix.net/~text?txtsize=12&txt=80px&w=80&h=80" alt="device picture" />
                <a href="##">Edit Plan</a>
              </div>
              <div class="col-lg-6 col-md-5 col-xs-8 data">
                <h3>Accessory Manufacturer, Device, Name, Property, Color</h3>
                <p>Category: Type (Bluetooth, Cases, Screen Protectors, ...)</p>
              </div>
              <div class="col-lg-1 col-md-2 col-xs-8 quantity">
                <select class="form-control">
                  <option>1</option>
                  <option>2</option>
                </select>
                <a href="##">Remove</a>
              </div>
              <div class="col-lg-1 col-md-1 col-xs-12 monthly"></div>
              <div class="col-lg-2 col-md-2 col-xs-12 due">$99.99 <span class="visible-xs-inline">Due Today</span></div>
            </div>
          </div>
        </form>
      </section>
    </div>
    <div class="col-md-3 sidebar">
      <a href="##" class="clear">Clear Entire Cart</a>
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
  <div class="row summary">
    <div class="col-md-9">
      <div class="row">
      <div class="col-md-5 promo">
        <div class="form-inline">
          <div class="form-group">
            <label for="promoInputName">Promotional Code</label>
            <input type="text" class="form-control input-sm" id="promoInputName">
          </div>
          <button type="submit" class="btn btn-default btn-sm">Apply</button>
        </div>
      </div>
      <div class="col-md-7">
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
    </div>
    <div class="legal col-md-9">
      <p>*Legal Goes Here: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed diam eget risus varius blandit sit amet non magna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Cras mattis consectetur purus sit amet fermentum.</p>
    </div>
  </div>

</cfoutput>
