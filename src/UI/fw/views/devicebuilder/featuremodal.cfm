<cfoutput>
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h4 class="modal-title">#prc.featureInfo.detailTitle#</h4>
  </div>
  <div class="modal-body">
    <div class="plans">
      <div class="info">
        <h3 style="height:40px"><span>#prc.featureInfo.title#</span></h3>
        <p>#prc.featureInfo.detailDescription#</p>
        <div class="price">#dollarFormat(prc.featureInfo.Price)#/month</div>
      </div>
    </div>
  </div>
  
  <div class="modal-footer">
    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
    <a href="##" type="button" class="btn btn-primary" name="btnAddFeature" id="btnAddFeature" value="#rc.fid#">Add to Cart</a>
  </div>

  <script>
    $('##btnAddFeature').click(function() {
        var thisvalue = $(this).attr("value");
        $("##chk_features_"+thisvalue).prop("checked",true);
        $('##featureModal').modal('hide');

        $.post('#event.buildLink('devicebuilder.tallybox')#', $('##protectionForm').serialize(), function(data){
          $('##myTallybox').html( data )
        });


        // temp: submit the form:
        // var form = $("##protectionForm");
        // form.attr('action', '#event.buildLink('devicebuilder.protection')#');
        // form.submit();
      });
  </script>
</cfoutput>
