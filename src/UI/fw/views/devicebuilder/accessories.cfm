<cfoutput>
<!--- <cfdump var="#prc.qAccessory#"> --->
  <div class="col-md-12">
    <section class="content accessories">
      <header class="main-header">
        <h1>Accessorize Your Device</h1>
        <p>When an accessory is selected you will see it added to Your Order.</p>
      </header>
      <form action="#prc.nextStep#" method="post">
        <div class="pull-right">
          <cfif structKeyExists(rc,"line")>
            <input type="hidden" name="line" value="#rc.line#">
          </cfif>
          <a href="#prc.prevStep#">BACK</a>
          <button type="submit" class="btn btn-primary">Continue</button>
        </div>

        <!--- TODO: Add cfif clause here to check for featured items.  Only display this section if count gt 0 --->
        <section class="featured">
          <h4>Featured Accessories for Your Device</h4>
            <div class="row">
              
              <cfif prc.qAccessory.RecordCount>
                <cfloop query="prc.qAccessory">
                  <cfset local.stcFeeAccessoryPrimaryImages = application.model.imageManager.getPrimaryImagesForProducts(valueList(prc.qAccessory.accessoryGuid)) />
                
                  <div class="col-sm-5">
                    <div class="product clearfix">
                      <cfif structKeyExists(local.stcFeeAccessoryPrimaryImages, prc.qAccessory.accessoryGuid[prc.qAccessory.currentRow])>
                        <img src="#application.view.imageManager.displayImage(imageGuid = local.stcFeeAccessoryPrimaryImages[prc.qAccessory.accessoryGuid[prc.qAccessory.currentRow]], height=100, width=0)#" alt="#htmlEditFormat(prc.qAccessory.summaryTitle[prc.qAccessory.currentRow])#" height="100" border="0" />
                      <cfelse>
                        <img src="#prc.assetPaths.common#images/catalog/noimage.jpg" height=100 border="0" alt="#htmlEditFormat(prc.qAccessory.summaryTitle[prc.qAccessory.currentRow])#" />
                      </cfif>
                      <div class="info" style="height:60px;">#prc.qAccessory.summaryTitle[prc.qAccessory.currentRow]#</div>
                      <div class="price">#dollarFormat(prc.qAccessory.price_retail[prc.qAccessory.currentRow])#</div>
                      <button type="button" class="btn btn-remove">Remove</button>
                    </div>
                  </div>

                </cfloop>
              <cfelse>
                There are featured accessories at this time.
              </cfif>

            </div>
        </section>
        

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
            <cfif prc.qAccessory.RecordCount>
              <cfloop query="prc.qAccessory">
                <cfset local.stcFeeAccessoryPrimaryImages = application.model.imageManager.getPrimaryImagesForProducts(valueList(prc.qAccessory.accessoryGuid)) />
                <div class="col-lg-4 col-xs-8">
                  <div class="product clearfix">
                    <cfif structKeyExists(local.stcFeeAccessoryPrimaryImages, prc.qAccessory.accessoryGuid[prc.qAccessory.currentRow])>
                      <img src="#application.view.imageManager.displayImage(imageGuid = local.stcFeeAccessoryPrimaryImages[prc.qAccessory.accessoryGuid[prc.qAccessory.currentRow]], height=100, width=0)#" alt="#htmlEditFormat(prc.qAccessory.summaryTitle[prc.qAccessory.currentRow])#" height="100" border="0" />
                    <cfelse>
                      <img src="#prc.assetPaths.common#images/catalog/noimage.jpg" height=100 border="0" alt="#htmlEditFormat(prc.qAccessory.summaryTitle[prc.qAccessory.currentRow])#" />
                    </cfif>
                    <div class="info" style="height:80px;">
                      #prc.qAccessory.summaryTitle[prc.qAccessory.currentRow]#
                    </div>
                    <div class="price">
                      #dollarFormat(prc.qAccessory.price_retail[prc.qAccessory.currentRow])#
                    </div>
                    <a type="button" class="btn btn-sm" onclick="alert('addToCart accessory pid: #prc.qAccessory.productId[prc.qAccessory.currentRow]#', '#prc.qAccessory.productId[prc.qAccessory.currentRow]#', 1);return false;" href="##"><span style="color:white">Add to Cart</span></a>
                  </div>
                </div>
              </cfloop>
            </cfif>
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

        <div class="pull-right">
          <a href="#prc.prevStep#">BACK</a>
          <button type="submit" class="btn btn-primary btn-block">Continue</button>
        </div>
      </form>
    </section>
  </div>
</cfoutput>
