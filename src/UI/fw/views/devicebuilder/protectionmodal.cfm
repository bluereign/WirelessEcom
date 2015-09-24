<cfif !structKeyExists(rc,"wid")>
  <cfset prc.SummaryTitle = "rc.wid does not exist" />
  <cfset prc.ShortDescription = "No plan selected" />
<cfelseif structKeyExists(prc,"warrantyInfo")>
  <!--- <cfdump var="#prc.warrantyInfo#"> --->
  <cfset prc.SummaryTitle = prc.warrantyInfo.SummaryTitle />
  <cfset prc.ShortDescription = prc.warrantyInfo.ShortDescription />
  <cfset prc.Price = prc.warrantyInfo.Price />
  <cfset prc.LongDescription = prc.warrantyInfo.LongDescription />
</cfif>

<cfparam name="prc.SummaryTitle" default="Warranty Modal Title" />
<cfparam name="prc.ShortDescription" default="Please close this modal and then refresh your page" />
<cfparam name="prc.Price" default="0" />

<cfoutput>
    <!--- <input type="hidden" name="wid" value="#rc.wid#"> --->
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
      <h4 class="modal-title">Carrier Mobile Protection Pack</h4>
      <p>#prc.SummaryTitle#</p>
    </div>
    <div class="modal-body">
      <div class="plans">
        <div class="info">
          <h3 style="height:40px"><span>#prc.SummaryTitle#</span></h3>
          <p>#prc.ShortDescription#</p>
          <p>#prc.LongDescription#</p>
          <div class="price">#dollarFormat(prc.Price)#/month</div>
        </div>
      </div>
    </div>
    
    <div class="modal-footer">
      <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      <a href="##" type="button" class="btn btn-primary" name="btnAddWarranty" id="btnAddWarranty" value="#rc.wid#">Add to Cart</a>
    </div>

    <script>
      $('##btnAddWarranty').click(function() {
          var thisvalue = $(this).attr("value");
          // console.log($("##warrantyoption_"+thisvalue));
          $("##warrantyoption_"+thisvalue).prop("checked",true);
          $('##protectionModal').modal('hide');

          // temp: submit the form:
          var form = $("##protectionForm");
          form.attr('action', '#event.buildLink('devicebuilder.protection')#/pid/#rc.pid#/type/#rc.type#/');
          form.submit();
        });
    </script>
</cfoutput>
