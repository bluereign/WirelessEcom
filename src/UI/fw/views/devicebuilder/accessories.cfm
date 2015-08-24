<cfoutput>
<!--- <cfdump var="#prc.qAccessory#"> --->
  <section class="content accessories">
    <header class="main-header">
      <h1>Accessorize Your Device</h1>
      <p>When an accessory is selected you will see it added to Your Order.</p>
    </header>
    <form action="#rc.nextStep#">
      <div class="pull-right">
        <a href="#rc.prevStep#" class="btn">Previous</a>
        <button type="submit" class="btn btn-primary btn-lg">Continue</button>
      </div>
      <!--- <section class="featured">
        <h4>Featured Accessories for Your Device</h4>
        <div class="row">
          <div class="col-sm-4">
            <div class="product">
              <img src="https://placeholdit.imgix.net/~text?txtsize=14&txt=180px&w=180&h=180" alt="device picture" />
              <div class="info">Features Manufacturer, Device Name, and Color</div>
              <div class="price">$9.99</div>
              <button type="button" class="btn btn-primary">Add to Cart</button>
            </div>
          </div>
          <div class="col-sm-4">
            <div class="product">
              <img src="https://placeholdit.imgix.net/~text?txtsize=14&txt=180px&w=180&h=180" alt="device picture" />
              <div class="info">Features Manufacturer, Device Name, and Color</div>
              <div class="price">$9.99</div>
              <button type="button" class="btn btn-primary">Add to Cart</button>
            </div>
          </div>
          <div class="col-sm-4">
            <div class="product">
              <img src="https://placeholdit.imgix.net/~text?txtsize=14&txt=180px&w=180&h=180" alt="device picture" />
              <div class="info">Features Manufacturer, Device Name, and Color</div>
              <div class="price">$9.99</div>
              <button type="button" class="btn btn-primary">Add to Cart</button>
            </div>
          </div>
        </div>
      </section> --->
      <section class="filters">
        <div class="dropdown">
          <a href="##" id="dLabel" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Filter Accessories</a> <i>(filter not working)</i>
          <div class="dropdown-menu" aria-labelledby="dLabel">
            <div class="checkbox">
              <label>
                <input type="checkbox" value="">
                Show All Devices
              </label>
            </div>
            <div class="checkbox">
              <label>
                <input type="checkbox" value="">
                Cases
              </label>
            </div>
            <div class="checkbox">
              <label>
                <input type="checkbox" value="">
                Docks &amp; Mounts
              </label>
            </div>
            <div class="checkbox">
              <label>
                <input type="checkbox" value="">
                Screen Protectors
              </label>
            </div>
            <div class="checkbox">
              <label>
                <input type="checkbox" value="">
                Bluetooth
              </label>
            </div>
            <div class="checkbox">
              <label>
                <input type="checkbox" value="">
                Chargers &amp; Adapters
              </label>
            </div>
            <div class="checkbox">
              <label>
                <input type="checkbox" value="">
                Headphones &amp; Speakers
              </label>
            </div>
            <h4>Pricing</h4>
            <div class="checkbox">
              <label>
                <input type="checkbox" value="">
                Less than $15
              </label>
            </div>
            <div class="checkbox">
              <label>
                <input type="checkbox" value="">
                $15 - $30
              </label>
            </div>
            <div class="checkbox">
              <label>
                <input type="checkbox" value="">
                $30 and Up
              </label>
            </div>
            <h4>Brands</h4>
            <div class="checkbox">
              <label>
                <input type="checkbox" value="">
                LG
              </label>
            </div>
            <div class="checkbox">
              <label>
                <input type="checkbox" value="">
                Otterbox
              </label>
            </div>
            <div class="checkbox">
              <label>
                <input type="checkbox" value="">
                Random Order
              </label>
            </div>
            <div class="checkbox">
              <label>
                <input type="checkbox" value="">
                TYLT
              </label>
            </div>
            <div class="checkbox">
              <label>
                <input type="checkbox" value="">
                Naztech
              </label>
            </div>
            <div class="checkbox">
              <label>
                <input type="checkbox" value="">
                PDO
              </label>
            </div>
            <div class="checkbox">
              <label>
                <input type="checkbox" value="">
                Samsung
              </label>
            </div>
            <div class="checkbox">
              <label>
                <input type="checkbox" value="">
                Zagg
              </label>
            </div>
            <div class="checkbox">
              <label>
                <input type="checkbox" value="">
                Liteproof
              </label>
            </div>
            <div class="checkbox">
              <label>
                <input type="checkbox" value="">
                Qmadix
              </label>
            </div>
            <div class="checkbox">
              <label>
                <input type="checkbox" value="">
                Scosche
              </label>
            </div>
          </div>
        </div>
        <h4>Accessories Compatible with Your Device</h4>
        <ul class="nav nav-tabs">
          <li role="presentation" class="active">
            <a href="##all" aria-controls="all" role="tab" data-toggle="tab">All Accessories</a>
          </li>
          <li role="presentation">
            <a href="##cases" aria-controls="cases" role="tab" data-toggle="tab">Cases</a>
          </li>
          <li role="presentation">
            <a href="##screen" aria-controls="screen" role="tab" data-toggle="tab">Screen Protectors</a>
          </li>
          <li role="presentation">
            <a href="##onsale" aria-controls="onsale" role="tab" data-toggle="tab">On Sale Now</a>
          </li>
          <li role="presentation">
            <a href="##custom" aria-controls="screen" role="tab" data-toggle="tab">Custom</a>
          </li>
        </ul>
        <div class="tab-content">

          <div role="tabpanel" class="tab-pane active" id="all">
            <div class="row">

              <cfif prc.qAccessory.RecordCount>
                <cfloop query="prc.qAccessory">
                  <cfset local.stcFeeAccessoryPrimaryImages = application.model.imageManager.getPrimaryImagesForProducts(valueList(prc.qAccessory.accessoryGuid)) />
                  <div class="col-lg-3 col-sm-4">
                    <div class="product">
                      <cfif structKeyExists(local.stcFeeAccessoryPrimaryImages, prc.qAccessory.accessoryGuid[prc.qAccessory.currentRow])>
                        <img src="#application.view.imageManager.displayImage(imageGuid = local.stcFeeAccessoryPrimaryImages[prc.qAccessory.accessoryGuid[prc.qAccessory.currentRow]], height=100, width=0)#" alt="#htmlEditFormat(prc.qAccessory.summaryTitle[prc.qAccessory.currentRow])#" height="100" border="0" />
                      <cfelse>
                        <img src="#prc.assetPaths.common#images/catalog/noimage.jpg" height=100 border="0" alt="#htmlEditFormat(prc.qAccessory.summaryTitle[prc.qAccessory.currentRow])#" />
                      </cfif>
                      <!--- <img src="https://placeholdit.imgix.net/~text?txtsize=14&txt=120px&w=120&h=120" alt="device picture" /> --->
                      <div class="info" style="height:80px;">#prc.qAccessory.summaryTitle[prc.qAccessory.currentRow]#</div>
                      <div class="price">#dollarFormat(prc.qAccessory.price_retail[prc.qAccessory.currentRow])#</div>
                      <button type="button" class="btn btn-primary">Add to Cart</button>
                    </div>
                  </div>
                </cfloop>
              </cfif>

            </div>
          </div>
          <div role="tabpanel" class="tab-pane" id="cases">
            ...
          </div>
          <div role="tabpanel" class="tab-pane" id="screen">
            ...
          </div>
          <div role="tabpanel" class="tab-pane" id="onsale">
            ...
          </div>
          <div role="tabpanel" class="tab-pane" id="custom">
            ...
          </div>
        </div>
      </section>
      <div class="pull-right">
        <a href="#rc.prevStep#" class="btn btn-block">Previous</a>
        <button type="submit" class="btn btn-primary btn-block btn-lg">Continue</button>
      </div>
    </form>
  </section>

</cfoutput>
