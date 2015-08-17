<!---<cfoutput>
		<iframe src="#event.buildLink('ddadmin.reprintReturnSummary')#" style="display: none" 
		        id="confirmationPrint">
		</iframe>
</cfoutput>--->

<div class="row"/>		
	<div class="col-md-12 instructions"><span class="instructionLabel">Instructions:</span> <span class="instructionText">Select an order or use the 'Try Another Search' button  to perform another search.</span></div>
</div>
<div>
<table id="searchResults" class="table table-striped table-bordered" cellspacing="0" width="100%">
	<thead>
		<th>Order ID</th>
		<th>Order Date</th>
		<th>Customer</th>
		<th>Phone</th>
		<th>IMEI(s)</th>
		<th>Reprint Return Summary</th>
	</thead>
	<tbody>
		<cfset prevOrderId = "" />
		<cfset prevIMEIs = "" />
		<cfloop query="rc.qOrders">
			<cfif orderid is not prevOrderid>
				<cfset prevOrderId = orderId />
				<cfset prevIMEIs = IMEI />
				<tr>
					<cfoutput>
						<td><a href="#event.buildLink('ddadmin.orderDetail?orderid=#orderid#')#">#orderid#</a></td>
						<td>#dateformat(orderdate,"MM/DD/yyyy")#</td>
						<td>#firstname# #lastName#</td>
						<td>#CurrentMDN#</td>
						<td><cfif trim(IMEI) is not "">#IMEI#<br/></cfif>
							<cfset local.i = 1 />
							<cfloop condition = "rc.qOrders.orderId[currentRow+local.i] is orderid" >
								<cfif rc.qOrders.IMEI[currentRow+local.i] is not "" and listfind(prevIMEIs,rc.qOrders.IMEI[currentRow+local.i]) is 0 >
									#rc.qOrders.IMEI[currentRow+local.i]#
									<br/>
									<cfset prevIMEIs = listAppend(prevIMEIs,rc.qOrders.IMEI[currentRow+local.i]) />
								</cfif>
								<cfset local.i = local.i+1 />
							</cfloop>						
						</td>
						<td>
							<cfif ddReturnid is not "">
								<a href="#event.buildLink('ddadmin.reprintReturnSummary')#?ddreturnid=#ddReturnId#">Reprint</a> <span class="smallDate">(returned #dateformat(returnDate, "mm/dd/yy")# #timeformat(returnDate, "hh:mm tt")#)</span>
								<cfset local.i = 1 />
								<cfset prevDdReturnIds = ddReturnid />
								<cfloop condition = "rc.qOrders.orderId[currentRow+local.i] is orderid" >
									<cfif rc.qOrders.DdReturnId[currentRow+local.i] is not "" and listfind(prevddREturnIds,rc.qOrders.ddReturnId[currentRow+local.i]) is 0>
										<cfset rdate = rc.qOrders.returnDate[currentRow+local.i] />
										<br/><a href="#event.buildLink('ddadmin.reprintReturnSummary')#?ddreturnid=#rc.qOrders.DdReturnId[currentRow+local.i]#">Reprint</a> <span class="smallDate">(returned #dateformat(rDate, "mm/dd/yy")# #timeformat(rDate, "hh:mm tt")#)</span>
										<cfset prevDdReturnIds = listAppend(prevDdReturnIds,rc.qOrders.DdReturnId[currentRow+local.i]) />
									</cfif>
									<cfset local.i = local.i+1 />
								</cfloop>			
							</cfif>
						</td>
					</cfoutput>
				</tr>
			</cfif>
		</cfloop>
	</tbody>
</table>
</div>

<div class="row" style="clear:left">
    <div class="col-md-4"></div>
    <div class="col-md-8">
    	
    	<form action="<cfoutput>#event.buildLink('ddadmin.searchForm')#</cfoutput>">
    	<a href="<cfoutput>#event.buildLink('mainVFD.homepageVFD')#</cfoutput>"><button class="btn btn-default"  type="button">Cancel</button></a>
		<button class="btn btn-primary" style="width: 200px;" type="submit" Title="Try a new search">Try Another Search</button>
		</form>
    </div>
</div>

<script>
	
		//Changes states of Print Order Confirmation and Finish Buttons
		function printClicked(){
		    if ((allValidNums==true && allActivated==true && allFinanceAgreement==true)||(!(hasActivations == "true"))) {
		        document.getElementById('printConfirm').classList.remove('progressBtnLarge');
		        document.getElementById('printConfirm').classList.add('waitForActionBtnLarge');
		        document.getElementById('finishConfirm').classList.remove('waitForActionBtn');
		        document.getElementById('finishConfirm').classList.add('progressBtn');
		    }
		};
		
		//Prints out confirmation on local printer.  Also checks to see if browser is IE and then executes IE specific print command 
		function printConfirmation(){
			var ms_ie = false;
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
    		}
		    
		};
	
	
</script>	

