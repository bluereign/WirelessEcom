<cfoutput>
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
  </div>
  <div class="modal-body">
    <div class="row">
      <div class="col-md-6">
        <div class="device-main">
          <!--- <cfdump var="#application.view.imageManager.displayImage(imageGuid = prc.stcPrimaryImages[prc.accessoryInfo.accessoryGuid], height = 230, width = 230)#"> --->
          <cfset prc.primaryImageSrc = application.view.imageManager.displayImage(imageGuid = prc.stcPrimaryImages[prc.accessoryInfo.accessoryGuid], height = 230, width = 230) />
          <img src="#trim(prc.primaryImageSrc)#"  width="230" border="0" />
          <!--- <img src="images/ex-featured-accessories.jpg" alt="something" /> --->

        </div>
        
        <cfif prc.accessoryImages.recordCount>
          <br /><br /><br />
          <div class="row">
            <cfloop query="prc.accessoryImages">
              <!--- prc.accessoryImages includes: BINIMAGE CAPTION CREATEDBY CREATEDDATE IMAGEGUID ISACTIVE ISPRIMARYIMAGE ORDINAL ORIGINALHEIGHT ORIGINALWIDTH REFERENCEGUID TITLE --->
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
            <div class="form-group form-inline">
              <label for="inputQuantity">Quantity</label>
              <select class="form-control" id="inputQuantity">
                <option>1</option>
                <option>2</option>
                <option>3</option>
                <option>4</option>
                <option>5</option>
              </select>
            </div>
          </div>
          <div class="col-md-8 price">Price: <strong>#dollarFormat(prc.accessoryInfo.Price)#</strong></div>

        </div>
        <button type="submit" class="btn btn-primary right"  name="btnAddAccessory" id="btnAddAccessory">Continue</button>
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

      $('##btnAddAccessory').click(function() {
          var thisvalue = $(this).attr("value");
          // console.log($("##warrantyoption_"+thisvalue));
          $("##accessoryoption_"+thisvalue).prop("checked",true);
          $('##protectionModal').modal('hide');

          // temp: submit the form:
          var form = $("##accessoryForm");
          form.attr('action', '#event.buildLink("devicebuilder.protection")#');
          form.submit();
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
