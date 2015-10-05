
<cfoutput>
  <!-- zipModal -->
  <div class="modal fade" id="zipModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title">Your ZIP Code is Required</h4>
        </div>
        <div class="modal-body">
          <p>Please enter the zip codewhere you will most frequently use your wireless device, or if changing carriers use the zip code from your existing account.</p>

          <div class="row">
            <div class="col-md-6 col-md-offset-2">
              <form id="zipCodeForm" action="#event.buildLink('devicebuilder.plans')#" method="post">
                <input type="hidden" name="type" value="#rc.type#" />
                <input type="hidden" name="pid" value="#rc.pid#" />
                <input type="hidden" name="cartLineNumber" value="#rc.cartLineNumber#" />
                <div class="form-group zip">
                  <label for="inputZip"><h4>ZIP Code</h4></label>
                  <input type="number" class="form-control" id="inputZip" name="inputZip" width="50%" min="11111" max="99999" required>
                </div>
                <button type="submit" class="btn btn-lg btn-primary" style="padding-left:50px;padding-right:50px;">See Plans</button>
              </form>
            </div>
          </div>

        </div>
        <div class="modal-footer">
        </div>
      </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
  </div><!-- /.modal -->


  <!--- planModal --->
  <div class="modal fade" id="planModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="true">
    <div class="modal-dialog"> 
      <div class="modal-content">
      </div><!-- /.modal-content --> 
    </div><!-- /.modal-dialog --> 
  </div>



<!---
  <script type="text/javascript">
      jQuery(function($){
           $('a.showme').click(function(ev){
               ev.preventDefault();
               var plan = $(this).data('id');
               var title = "new title";
               $("##planModal .modal-title").text( title );
               $('##planModal').modal('show');
           });
      });
  </script>
--->



</cfoutput>
