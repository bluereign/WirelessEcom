<cfoutput>
<cfset GrandTotal = 0.00 />	
		<div class="row"/>		
			<div class="col-md-12 instructions"><span class="instructionLabel">Instructions:</span> 
			<cfif rc.reprint>
				<span class="instructionText">To reprint the return summary click the 'Reprint Return Order Summary Button'.
			<cfelse>
				<span class="instructionText">Review the Return Summary information. Click the 'Print Return Order Summary Button'
				To print out 3 copies of the summary. One is for the customer, one should be included with the return shipment to the DC,
				and the third copy can stay at the Kiosk. </span></div>
			</cfif>
		</div>	
		<div class="returnSummary">
			<div class="row">
				<div class="col-md-12"><strong>Return Order Summary Information</strong></div>
			</div>				
			<div class="row">
				<div class="col-md-12">&nbsp;</div>
			</div>				
			<div class="row">
				<div class="col-md-3 formLabel">Order ID:</div>
				<div class="col-md-9">#session.ddadmin.returnRequest.Order.getOrderId()#</div>
			</div>	
			<div class="row">
				<div class="col-md-3 formLabel">Date/Time:</div>
				<div class="col-md-9">#dateformat(session.ddadmin.returnRequest.returnDt,"mm/dd/yyyy")# #timeformat(session.ddadmin.returnRequest.returnDt,"hh:mm tt")#</div>
			</div>				
			<div class="row">
				<div class="col-md-3 formLabel">GERS Salesorder Number:</div>
				<div class="col-md-9">#session.ddadmin.returnRequest.Order.getGersRefNum()#</div>
			</div>	
						
			<div class="row">
				<div class="col-md-3 formLabel">Customer:</div>
				<div class="col-md-9">#session.ddadmin.returnRequest.Order.getBillAddress().getFirstName()# #session.ddadmin.returnRequest.Order.getBillAddress().getLastName()#</div>
			</div>				
			<div class="row">
				<div class="col-md-3 formLabel">Tracking Number:</div>
				<div class="col-md-9">#session.ddadmin.returnRequest.TrackingNumber#</div>
			</div>
			<cfset accessoryHeader = false />		
			<cfloop array="#session.ddadmin.returnRequest.ItemsReturned#" index="r">
			<div class="row">
				<cfif r.groupName is not "">
					<div class="col-md-12 GroupHeader">#r.groupName#:</div>
				<cfelseif accessoryHeader is false>
					<div class="col-md-12 GroupHeader">Accessories:</div>
					<cfset accessoryHeader = true />
					<cfset ac_ct = 0 />
				</cfif>
			</div>		
			<cfif accessoryHeader is false>
				<cfloop array="#session.ddadmin.returnRequest.Order.getOrderDetail()#" index="od">
					<cfif od.GetOrderDetailType() is "d" and od.getGroupName() is r.groupName >
						<cfset wl = getWirelessLine(od.getOrderdetailId(), session.ddadmin.returnRequest.Order.getWirelesslines()) />
                        <!---<div class="row"><div class="col-lg-3 orderDetailLabel">Device:</div></div>--->
                        <div class="row productname"><div class="col-lg-3 orderDetailLabel">Device Name:</div><div class="col-lg-7">#od.getProductTitle()#</div></div>
                        <div class="row"><div class="col-lg-3 orderDetailLabel">GERS SKU:</div><div class="col-lg-7">#od.getGersSku()#</div></div>
                        <div class="row"><div class="col-lg-3 orderDetailLabel">IMEI/ESN:</div><div class="col-lg-7">#wl.getIMEI()#</div></div>
                        <div class="row"><div class="col-lg-3 orderDetailLabel">SIM:</div><div class="col-lg-7">#wl.getSIM()#</div></div>
                        <cfif wl.getCurrentMDN() is not "" >
                            <div class="row"><div class="col-lg-3 orderDetailLabel">Current MDN:</div><div class="col-lg-7">#wl.getCurrentMDN()#</div></div>
						</cfif>
                        <cfif wl.getNewMDN() is not "">
                            <div class="row"><div class="col-lg-3 orderDetailLabel">New MDN:</div><div class="col-lg-7">#wl.getNewMDN()#</div></div>
						</cfif>
                        <!---<div class="longView">--->
                            <div class="row"><div class="col-lg-3 orderDetailPrice">Retail Price:</div><div class="col-lg-1"><span style="float:right;">#decimalformat(od.getRetailPrice())#</span></div></div>
							<cfset OnlineDiscount = od.getRetailPrice() - od.getNetPrice()  />
                            <div class="row"><div class="col-lg-3 orderDetailPrice">Online Discount:</div><div class="col-lg-1"><span style="float:right">#decimalformat(OnlineDiscount)#</span></div></div>
                            <div class="row"><div class="col-lg-3 orderDetailPrice">Net Price:</div><div class="col-lg-1"><span style="float:right">#decimalformat(od.getNetPrice())#</span></div></div>
                            <div class="row"><div class="col-lg-3 orderDetailPrice">Taxes:</div><div class="col-lg-1"><span style="float:right">#decimalformat(od.getTaxes())#</span></div></div>
							<cfset TotalPrice = od.getNetPrice() + od.getTaxes() />
							<cfset GrandTotal = GrandTotal + TotalPrice />
                            <div class="row"><div class="col-lg-3 orderDetailPrice">Total:</div><div class="col-lg-1 orderDetailLabel"><span style="float:right">#decimalformat(TotalPrice)#</span></div></div>
                        <!---</div>--->
						<cfset odw = wl.getLineWarranty() />	
						<cfif isObject(odw) and len(odw.getProductTitle()) >
                        	<div class="row productname"><div class="col-lg-3 orderDetailLabel">Warranty:</div><div class="col-lg-7">#odw.getProductTitle()#  (#odw.getGersSku()#)</div></div>
                            <div class="row"><div class="col-lg-3 orderDetailPrice">Retail Price:</div><div class="col-lg-1"><span style="float:right;">#decimalformat(odw.getRetailPrice())#</span></div></div>
							<cfset OnlineDiscount = odw.getRetailPrice() - odw.getNetPrice()  />
                            <div class="row"><div class="col-lg-3 orderDetailPrice">Online Discount:</div><div class="col-lg-1"><span style="float:right">#decimalformat(OnlineDiscount)#</span></div></div>
                            <div class="row"><div class="col-lg-3 orderDetailPrice">Net Price:</div><div class="col-lg-1"><span style="float:right">#decimalformat(odw.getNetPrice())#</span></div></div>
                            <div class="row"><div class="col-lg-3 orderDetailPrice">Taxes:</div><div class="col-lg-1"><span style="float:right">#decimalformat(odw.getTaxes())#</span></div></div>
							<cfset TotalPrice = odw.getNetPrice() + odw.getTaxes() />
							<cfset GrandTotal = GrandTotal + TotalPrice />
                            <div class="row"><div class="col-lg-3 orderDetailPrice">Total:</div><div class="col-lg-1 orderDetailLabel"><span style="float:right">#decimalformat(TotalPrice)#</span></div></div>
						</cfif>

						<div class="row">
							<div class="col-md-3 orderDetailLabel">Reason:</div>
							<div class="col-md-9">#r.Reason#</div>
						</div>		
						<div class="row">
							<div class="col-md-3 orderDetailLabel">Comment:</div>
							<div class="col-md-9">#r.Comment#</div>
						</div>						
					</cfif>
				</cfloop>
			</cfif>
			
				<cfif accessoryHeader is true>
					<!---<cfloop array="#session.ddadmin.returnRequest.ItemsReturned#" index="i">--->
						<cfset i = r />
						<cfif i.orderdetailid is not "" >
							<cfset ac_ct = ac_ct+1 />
							<cfif ac_ct gt 1>
								<div class="row">
									<div class="col-md-12"><hr/></div>
								</div>					
							</cfif>
							<cfset od = createObject( "component", "cfc.model.OrderDetail" ).init() />
							<cfset od.load(i.orderDetailId) />
							<div class="row productname">
								<div class="col-lg-3 orderDetailLabel">Accessory(#ac_ct#):</div>
								<div class="col-lg-9">#od.getProductTitle()#</div>
							</div>
							<div class="row">
								<div class="col-lg-3 orderDetailLabel">GERS SKU:</div>
								<div class="col-lg-9">#od.getGersSku()#</div>
							</div>
                            <div class="row"><div class="col-lg-3 orderDetailPrice">Retail Price:</div><div class="col-lg-1"><span style="float:right;">#decimalformat(od.getRetailPrice())#</span></div></div>
							<cfset OnlineDiscount = od.getRetailPrice() - od.getNetPrice()  />
                            <div class="row"><div class="col-lg-3 orderDetailPrice">Online Discount:</div><div class="col-lg-1"><span style="float:right">#decimalformat(OnlineDiscount)#</span></div></div>
                            <div class="row"><div class="col-lg-3 orderDetailPrice">Net Price:</div><div class="col-lg-1"><span style="float:right">#decimalformat(od.getNetPrice())#</span></div></div>
                            <div class="row"><div class="col-lg-3 orderDetailPrice">Taxes:</div><div class="col-lg-1"><span style="float:right">#decimalformat(od.getTaxes())#</span></div></div>
							<cfset TotalPrice = od.getNetPrice() + od.getTaxes() />
							<cfset GrandTotal = GrandTotal + TotalPrice />
                            <div class="row"><div class="col-lg-3 orderDetailPrice">Total:</div><div class="col-lg-1 orderDetailLabel"><span style="float:right">#decimalformat(TotalPrice)#</span></div></div>
							<div class="row">
								<div class="col-md-3 orderDetailLabel">Reason:</div>
								<div class="col-md-9">#r.Reason#</div>
							</div>		
							<div class="row">
								<div class="col-md-3 orderDetailLabel">Comment:</div>
								<div class="col-md-9">#r.Comment#</div>
							</div>		
						</cfif>
					<!---</cfloop>--->
				</cfif>			
			</cfloop>
			<div class="row"><div class="col-lg-3"><hr/></div></div>
			<div class="row" style="font-weight: bolder; font-size:110%;"><div class="col-lg-3">Return Total:</div><div class="col-lg-2 ">#dollarformat(GrandTotal)#</div></div>

	
		</div>


	
<!---<a id="printConfirm" href="##" class="progressBtnLarge" style="text-decoration: none"
		   onclick="javascript: if(checkAll()){printConfirmation();setFinishVar();};printClicked();">
						<span>
							Print Order Confirmation
</a>--->

	


	<iframe src="#event.buildLink('ddadmin.printReturnSummary')#" style="display: none" 
	        id="confirmationPrint">
	</iframe>


		<div class="row"/>		
<!---			<div class="col-md-5 buttonSpacer">
				<form action="#event.buildLink('ddadmin.printReturnSummary')#" method="post">
					<button class="btn btn-primary" type="submit" style="width: 150px;">Test Print</button>&nbsp;&nbsp;
				</form>		
			</div>	--->	
			
			<cfif rc.reprint>
				<div class="col-md-5 buttonSpacer">
					<a id="printConfirm" href="##" class="progressBtnLarge" onclick="javascript: printConfirmation();setFinishVar();printClicked();" >
						<button class="btn btn-primary" type="submit" style="width: 400px;" Title="Reprints the return summary for (customer, shipment, kiosk). Requires Chrome or Safari browser.">Reprint Return Order Summary</button>
					</a>				
				</div>
				<div class="col-md-5 buttonSpacer">
					<form action="#event.buildLink('mainVFD.homepageVFD')#" method="post">
						<button class="btn btn-next" type="submit" style="width: 400px;">Return to DD Main Page</button>&nbsp;&nbsp;
					</form>		
				</div>
			<cfelse>
				<div class="col-md-2 buttonSpacer">	
					<form action="#event.buildLink('mainVFD.homepageVFD')#" method="post">
						<button class="btn btn-default" type="submit" style="width: 150px;">Cancel</button>&nbsp;&nbsp;
					</form>		
				</div>	
				<div class="col-md-5 buttonSpacer">
					<a id="printConfirm" href="##" class="progressBtnLarge" onclick="javascript: printConfirmation();setFinishVar();printClicked();" >
						<button class="btn btn-primary" type="submit" style="width: 400px;" Title="Prints the return summary for (customer, shipment, kiosk). Requires Chrome or Safari browser.">Print Return Order Summary</button>
					</a>				
				</div>
				<div class="col-md-5 buttonSpacer">
					<a onclick="return confirmSubmitReturn()" href="#event.buildLink('ddadmin.returnSubmit')#" method="post">
						<button class="btn btn-next" type="submit" style="width: 400px; ">Submit Return</button>
					</a>				
				</div>
			</cfif>
		</div>

</cfoutput>

	<cffunction name="getWirelessLine" returnType="cfc.model.wirelessLine">
		<cfargument name="orderDetailId" type="numeric" required="true" />
		<cfargument name="wirelesslines" type="cfc.model.wirelessline[]" required="true" />
		
		<cfloop array="#arguments.wirelesslines#" index="wl">
			<cfif wl.getOrderDetailId() is arguments.orderdetailid >
				<cfreturn wl />
			</cfif>		
		</cfloop>
		<cfreturn "" />
	</cffunction>	
	
	
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
	
