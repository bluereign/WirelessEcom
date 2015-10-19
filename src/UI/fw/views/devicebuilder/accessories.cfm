<cfoutput>
  <div class="col-md-12">
    <section class="content accessories">
      <header class="main-header">
        <h1>Accessorize Your Device</h1>
        <p>When an accessory is selected you will see it added to Your Order.</p>
      </header>
      <form action="#prc.nextStep#" name="accessoryForm" id="accessoryForm" method="post">
        <div class="right">
          <input type="hidden" name="cartLineNumber" value="#rc.cartLineNumber#" />
          <a href="#prc.prevStep#">BACK</a>
          <button type="submit" class="btn btn-primary">Continue</button>
        </div>
        
        <section class="featured">

          <div class="row">
            <cfif prc.qAccessory.RecordCount>
              <cfloop query="prc.qAccessory">
                <cfset local.stcFeeAccessoryPrimaryImages = application.model.imageManager.getPrimaryImagesForProducts(valueList(prc.qAccessory.accessoryGuid)) />
              
                <div class="col-sm-5">
                  <div class="product clearfix">
                    <a class="image" href="##">
                      <cfif structKeyExists(local.stcFeeAccessoryPrimaryImages, prc.qAccessory.accessoryGuid[prc.qAccessory.currentRow])>
                        <img src="#application.view.imageManager.displayImage(imageGuid = local.stcFeeAccessoryPrimaryImages[prc.qAccessory.accessoryGuid[prc.qAccessory.currentRow]], height=100, width=0)#" alt="#htmlEditFormat(prc.qAccessory.summaryTitle[prc.qAccessory.currentRow])#" border="0" />
                      <cfelse>
                        <img src="#prc.assetPaths.common#images/catalog/noimage.jpg" height=100 border="0" alt="#htmlEditFormat(prc.qAccessory.summaryTitle[prc.qAccessory.currentRow])#" />
                      </cfif>
                    </a>
                    <div class="info-wrap">
                      <div class="info">#prc.qAccessory.summaryTitle[prc.qAccessory.currentRow]#</div>
                      <div class="price">#dollarFormat(prc.qAccessory.price_retail[prc.qAccessory.currentRow])#</div>
                      <cfif listFindNoCase(prc.selectedAccessories, prc.qAccessory.productId[prc.qAccessory.currentRow])>
                        <button type="button" class="btn btn-remove btnAddToCart" name="btnRemoveFromCart" value="#prc.qAccessory.productId[prc.qAccessory.currentRow]#" id="removeacc_#prc.qAccessory.productId[prc.qAccessory.currentRow]#" data-fn="remove">Remove</button>
                      <cfelse>
                        <button type="button" class="btn btnAddToCart" name="btnAddToCart" value="#prc.qAccessory.productId[prc.qAccessory.currentRow]#" id="accessory_#prc.qAccessory.productId[prc.qAccessory.currentRow]#" data-fn="add">Add to Cart</button>
                      </cfif>
                    </div>
                    <div class="callout">
                        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="##accessoryModal"  href="#event.buildLink('devicebuilder.accessorymodal')#/aid/#prc.qAccessory.productId[prc.qAccessory.currentRow]#/cartLineNumber/#rc.cartLineNumber#">Quick View</button>
                    </div>

                    
                  </div>
                </div>

              </cfloop>
            <cfelse>
              There are featured accessories at this time.
            </cfif>

          </div>
        </section>

        <div class="right">
          <a href="#prc.prevStep#">BACK</a>
          <button type="submit" class="btn btn-primary btn-block">Continue</button>
        </div>
      </form>
    </section>
  </div>
</cfoutput>
