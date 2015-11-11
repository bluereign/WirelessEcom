<cfoutput>

  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h4 class="modal-title">#prc.warrantyInfo.SummaryTitle#</h4>
  </div>
  <div class="modal-body">
    <div class="plans">
      <div class="info">
        <h3 style="height:40px"><span>#prc.warrantyInfo.SummaryTitle#</span></h3>
        <p>#prc.warrantyInfo.LongDescription#</p>
        <div class="price">#dollarFormat(prc.warrantyInfo.Price)#</div>
      </div>
    </div>
  </div>
  
  <div class="modal-footer">
    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
    <a href="##" type="button" class="btn btn-primary" name="btnAddWarranty" id="btnAddWarranty" value="#rc.wid#">Add to Cart</a>
  </div>

  <script>
    $('##btnAddWarranty').on('click', function(e) {
      var thisvalue = $(this).attr("value");
      $("##warrantyoption_"+thisvalue).prop("checked",true);
      $('##protectionModal').modal('hide');

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
