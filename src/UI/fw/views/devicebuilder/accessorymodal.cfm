<cfset cartQty = application.model.dBuilderCartFacade.getItemCount(cartLineNo = rc.cartLineNumber, productId = prc.accessoryInfo.productId) />

<cfoutput>

  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
  </div>
  
  <div class="modal-body">
    <div class="row">
      
      <div class="col-md-6">
        <div class="device-main">
          <cfset prc.primaryImageSrc = application.view.imageManager.displayImage(imageGuid = prc.stcPrimaryImages[prc.accessoryInfo.accessoryGuid], height = 230, width = 230) />
          <img src="#trim(prc.primaryImageSrc)#"  width="230" border="0" />
        </div>
        
        <cfif prc.accessoryImages.recordCount>
          <br /><br /><br />
          <div class="row">
            <cfloop query="prc.accessoryImages">
              <cfset prc.primaryImageSrc = application.view.imageManager.displayImage(imageGuid = prc.accessoryImages.imageGuid[prc.accessoryImages.currentrow], height = "0", width = "130") />
              <div class="col-md-5">
                <a href="##" class="device-thumb">
                  <img src="#trim(prc.primaryImageSrc)#" data-full-src="#trim(prc.primaryImageSrc)#" />
                </a>
              </div>
            </cfloop>
          </div>
        </cfif>
      </div>

      <div class="col-md-10">
        <h4 id="deviceDetailModalLabel">#prc.accessoryInfo.SummaryTitle#</h4>
        <div class="description">#prc.accessoryInfo.SummaryDescription#</div>
        <p>#prc.accessoryInfo.DetailDescription#</p>

        <div class="row">
          <div class="col-md-8">
            
            <form id="formAccessory" action="#event.buildLink('devicebuilder.accessories')#" method="post">
              <input type="hidden" name="cartLineNumber" value="#rc.cartLineNumber#" />
              <input type="hidden" name="addaccessory" id="addaccessory" value="#prc.accessoryInfo.productId#" />

              <div class="form-group form-inline">
                <label for="accessoryqty">Quantity</label>
                <select class="form-control" name="accessoryqty" id="accessoryqty">
                  <cfloop from="1" to="#IIF(prc.accessoryInfo.qtyOnHand lte 10, DE(prc.accessoryInfo.qtyOnHand), DE(10))#" index="iqty">
                    <option value="#iqty#" <cfif iqty eq cartQty>selected</cfif> >#iqty#</option>
                  </cfloop>
                </select>
              </div>

            </form>

          </div>
          <div class="col-md-8 price">Price: <strong>#dollarFormat(prc.accessoryInfo.Price)#</strong></div>
        </div>

        <button type="button" class="btn btn-primary right"  name="btnAddAccessory" id="btnAddAccessory" >Add to Cart</button>
        <button class="btn btn-gray right" data-dismiss="modal" aria-label="Close">No Thanks</button>

      </div>

    </div>
  </div>
  
  
  <script>
    function swapDeviceImage(src) {
      var $mainImage = $('.device-main img');
      $mainImage.attr('src', src);
    }

    $(function() {

      $('##btnAddAccessory').on('click', function() {
        // $('##formAccessory').submit();
        $.post('#event.buildLink('devicebuilder.tallybox')#', $('##formAccessory').serialize(), function(data){
          $('##myTallybox').html( data )
        });
        $('##accessoryModal').modal('hide');

        var id = $('##addaccessory').attr('value');

        $('##accessory_'+id).data('fn', 'remove');
        $('##accessory_'+id).text('Remove');
        $('##accessory_'+id).addClass('btn-remove');

        $('##removeacc_'+id).data('fn', 'remove');
        $('##removeacc_'+id).text('Remove');
        $('##removeacc_'+id).addClass('btn-remove');

      });

      // Swap images on thumbnail click in view details modal
      $('.device-thumb').on('click', function(e) {
        e.preventDefault();
        var $this = $(this),
          newSrc = $this.children('img').data('full-src');

        $('.device-thumb').removeClass('active');
        $this.addClass('active');

        swapDeviceImage(newSrc);
      });

    });
  </script>
</cfoutput>
