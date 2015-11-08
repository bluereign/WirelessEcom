<cfoutput>
<input type="hidden" id="orderID" name="orderID" value="" />
</cfoutput>
<h3>Direct Delivery Orders for the past month by Kiosk Number</h3>
<h4 style="color:red;">*** Orders in red show as missing activation and require immediate attention.</h4>
<div class="row" style="clear:left">
    <div class="col-md-4"></div>
    <div class="col-md-8">
    	
    	<form action="<cfoutput>#event.buildLink('ddadmin.searchForm')#</cfoutput>">
    	<a href="<cfoutput>#event.buildLink('mainVFD.homepageVFD')#</cfoutput>"><button class="btn btn-default"  type="button">Return to Home Page</button></a>
		</form>
    </div>
</div>
<div class="bootstrap">
		<div class="container">	
			<div>
				<table id="searchResults" class="table table-striped table-bordered" cellspacing="0" width="100%" >
					<thead>
						<th>Order ID</th>
						<th>Order Date</th>
						<th>Customer Name</th>
						<th>Order Status</th>
						<th>Employee Name</th>
						<th>Kiosk #</th>
					</thead>
					<tbody>
						<cfloop query="rc.qOrders">
								<tr <cfif (Status eq 2) AND (GersStatus eq 0)>style="color:red;font-weight:bold;"<cfelseif (Status eq 4) AND (GersStatus eq 0)>style="color:blue;font-weight:bold;"<cfelse></cfif>>
									<cfoutput>
										<td><a href="##" onclick="javascript: viewOrderConfirmation(orderID=#orderid#);">View Order</a> #orderid#
											<cfif (Status eq 2) AND (GersStatus eq 0)>
												<br/>
												<a href="##" onclick="javascript: modifyOrder(orderID=#orderid#);"><button class="btn btn-default" type="button" style="color:red;font-weight:bolder">Fix It</button></a>
												<!---<a href="<cfoutput>#event.buildLink('omtVFD/cancelOrderSubmit?orderID=#orderid#')#</cfoutput>"><button class="btn btn-default" type="button" style="color:red;font-weight:bolder">Cancel</button></a>--->
												<a onclick="javascript: {var ok=confirm('This will cancel the selected order and it CANNOT be undone.  Click OK to proceed with cancellation'); if(ok){location.href='<cfoutput>#event.buildLink('omtVFD/cancelOrderSubmit?orderID=#orderid#')#</cfoutput>'; }}"><button class="btn btn-default" type="button" style="color:red;font-weight:bolder" >Cancel</button></a>
											</cfif>
											<!---<button type="button" class="btn btn-info btn-lg" data-toggle="modal" data-target="##cancelModal" data-id="#orderID#">Cancel Order</button>--->
										</td><!---href="#event.buildLink('OmtVFD.orderConfirmationReprint?orderid=#orderid#')#" onclick="javascript: printConfirmation();" --->
										<td>#dateformat(orderdate,"MM/DD/yyyy")#</td>
										<td>#CustomerName#</td>
										<td><cfif (Status eq 2) AND (GersStatus eq 0)>ACTIVATION MISSING, please fix<cfelseif ((Status eq 4) AND (GersStatus eq 0))>ORDER CANCELLED<cfelse>#CombinedStatus#</cfif></td>
										<td><cfif len(trim(EmployeeName))>#EmployeeName#<cfelse>#AssociateId#</cfif></td>
										<td><cfif len(trim(KioskNumber))>#KioskNumber#<cfelse>NA</cfif></td>					
									</cfoutput>
								</tr>
						</cfloop>
					</tbody>
				</table>
			</div>
		</div>
		
		
		
		
<!---<div id="cancelModal" class="modal fade" role="dialog">
  <div class="modal-dialog">

    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Cancel Order Header</h4>
      </div>
      <div class="modal-body">
        Body Text
      </div>
      <div class="modal-footer">
      	<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-default">Agree</button>
      </div>
    </div>
  </div>
</div>--->
		
		
		
		
		
		
</div>	
<div class="row" style="clear:left">
    <div class="col-md-4"></div>
    <div class="col-md-8">
    	
    	<form action="<cfoutput>#event.buildLink('ddadmin.searchForm')#</cfoutput>">
    	<a href="<cfoutput>#event.buildLink('mainVFD.homepageVFD')#</cfoutput>"><button class="btn btn-default"  type="button">Return to Home Page</button></a>
		</form>
    </div>
</div>
<iframe src="#event.buildLink('checkoutVFD/printConfirmation')#" style="display: none" 
	        id="confirmationPrint">
</iframe>
<script>
		var $j = jQuery.noConflict();
		//Changes states of Print Order Confirmation and Finish Buttons
		function printClicked(){
			//document.getElementById('confirmationPrint').src = "#event.buildLink( linkto="general.maintain", queryString="userid=#User.getUserID()#" )#"
		};
		
		//Prints out confirmation on local printer.  Also checks to see if browser is IE and then executes IE specific print command 
		
		function viewOrderConfirmation(orderID){
			document.getElementById("orderID").value = orderID;
			window.open("/OmtVFD/orderConfirmationReprint?orderID="+orderID, 'confirmationReprint', 'menubar=yes,toolbar=yes,resizable=1,scrollbars=1,personalbar=1');		    
		};
		
		function modifyOrder(orderID){
			document.getElementById("orderID").value = orderID;
			window.open("/OmtVFD/modifyOrder?orderID="+orderID, 'modifyOrder', 'menubar=yes,toolbar=yes,resizable=1,scrollbars=1,personalbar=1');		    
		};
		
		function printConfirmation(){
			
			window.open("/OmtVFD/orderConfirmationReprint", 'confirmationReprint', 'menubar=yes,toolbar=yes,resizable=1,scrollbars=1,personalbar=1');
			
			/*var ms_ie = false;
   			var ua = window.navigator.userAgent;
    		var old_ie = ua.indexOf('MSIE ');
    		var new_ie = ua.indexOf('Trident/');

    		if ((old_ie > -1) || (new_ie > -1)) {
        		ms_ie = true;
   			 }
    		if ( ms_ie ) {
    			var iframe = document.getElementById('confirmationPrint');
        		iframe.contentWindow.document.execCommand('print', false, null);
    		}
    		else {
    			parent.document.getElementById('confirmationPrint').contentWindow.print();
    		}*/
		    
		};
	
	
</script>	

