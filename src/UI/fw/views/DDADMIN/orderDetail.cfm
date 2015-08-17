<style>
    .reasonContainer {
        border: 1px solid #AAA;
        margin: 15px 10px 10px 10px;
        background-color:  lightgreen;
        padding: 10px 10px 10px 10px;
    }
	.bootstrap #OrderDetails {
		padding: 0;
		font-size: 60%;
		margin: 0;
		padding-top: 0;
	}
	.bootstrap hr {
		padding 0;
		margin: 0;
	}
	.orderDetailLabel {
		font-weight: bolder;
		margin-top: 10px;
		margin-bottom: 0;
	}
	.alreadyReturned {
		font-weight: normal;
		font-style: italic;
		font-size: 85%;
	}	
	
	.freeAccessoryReturn {
		font-weight: normal;
		color: blue;
		text-align: right;
	}
</style>

<script>
	
    function ShowHideButtons() {
		
        var checkedDevices = $("input[name='ItemsToReturn']:checked");
        var checkedAccessories = $("input[name='AccessoriesToReturn']:checked");
        var nCheckedDevices = checkedDevices.length;
		var nCheckedAccessories = checkedAccessories.length;
		
        if (nCheckedDevices > 0) {
			$(".returnInProgress").show();
			
			$("input[name='ItemsToReturn']:checked").each(function(){
				var thisId = this.id;
				$("." + thisId).show();
			});
			
			$("input[name='ItemsToReturn']:not(:checked)").each(function(){
				var thisId = this.id;
				$("." + thisId).hide();
			});
		}
			
        if (nCheckedAccessories > 0) {
			$(".returnInProgress").show();
			
			$("input[name='AccessoriesToReturn']:checked").each(function(){
				var thisId = this.id;
				$("." + thisId).show();
			});
			
			$("input[name='AccessoriesToReturn']:not(:checked)").each(function(){
				var thisId = this.id;
				$("." + thisId).hide();
			});
		}	
			
		// if nothing is checked then hide buttons	
		if (nCheckedDevices + nCheckedAccessories == 0) {
            $('[class^="returnInProgress"]').hide();
        }
    }
	

</script>	


<cfoutput>
		<div class="row"/>		
			<div class="col-md-12 instructions"><span class="instructionLabel">Instructions:</span> <span class="instructionText">Select the items to be returned by checking the 'select item' box. For each return item complete the reason and comment fields. Click Next to proceed.</span></div>
		</div>
		
<form id="ReturnItemSelectForm" action="#event.buildLink('ddadmin.carrierDeactivation')#" method="post">
	<input type="hidden" name="orderid" value="#rc.order.getOrderid()#" />
	
    <div class="row">
	    <div class="col-lg-12">
	        <div id="tabs">
	            <ul>
	                <li><a href="##OrderGeneral">General</a></li>
	                <li><a href="##OrderDetails">Details</a></li>
	                <li><a href="##OrderNotes">Notes</a></li>
	            </ul>
				
				<!--- start of general tab --->
				<div id="OrderGeneral">
                    <div class="row"><div class="col-lg-8"><h4>Order Information</h4></div></div>
                    <div class="row"><div class="col-lg-3 ">OrderId:</div><div class="col-lg-5">#rc.order.getOrderId()#</div></div>
					<div class="row"><div class="col-lg-3">GERS Salesorder ##:</div><div class="col-lg-5">#rc.order.getGersRefNum()#</div></div>
                    <div class="row"><div class="col-lg-3">Kiosk:</div><div class="col-lg-5">#rc.order.getKioskId()#</div></div>
                    <div class="row"><div class="col-lg-3">Associate:</div><div class="col-lg-5">#rc.order.getAssociateId()#</div></div>
                    <div class="row"><div class="col-lg-3">Order Date/Time:</div><div class="col-lg-5">#rc.order.getOrderDate()#</div></div>
                    <div class="row"><div class="col-lg-3">Status (WA):</div><div class="col-lg-5">#rc.order.getStatusName()#(#rc.order.getStatus()#)</div></div>
                    <div class="row">
                        <div class="col-lg-3">Status (GERS):</div><div class="col-lg-5">
                            <cfif rc.order.getGersStatus() is not "" >
                            <span> #rc.order.getGersStatusName()# (#rc.order.getGersStatus()#)</span>
							</cfif>
                    </div>
                </div>
                <div class="row"><div class="col-lg-3">Email:</div><div class="col-lg-5">#rc.order.getEmailAddress()#</div></div>


                    <div class="row"><div class="col-lg-8"><h4>Billing Information</h4></div></div>
                    <div class="row"><div class="col-lg-3">First Name:</div><div class="col-lg-5">#rc.BillAddress.getFirstName()#</div></div>
                    <div class="row"><div class="col-lg-3">Last Name:</div><div class="col-lg-5">#rc.BillAddress.getLastName()#</div></div>
                    <div class="row"><div class="col-lg-3">Company:</div><div class="col-lg-5">#rc.BillAddress.getCompany()#</div></div>
                    <div class="row"><div class="col-lg-3">Address 1:</div><div class="col-lg-5">#rc.BillAddress.getAddress1()#</div></div>
                    <cfif (rc.BillAddress.getAddress2() is not "") >
                    	<div class="row"><div class="col-lg-3">Address 2:</div><div class="col-lg-5">#rc.BillAddress.getAddress2()#</div></div>
                    </cfif>
                    <cfif (rc.BillAddress.getAddress3()  is not "")>
                        <div class="row"><div class="col-lg-3">Address 3:</div><div class="col-lg-5">#rc.BillAddress.getAddress3()#</div></div>
                    </cfif>
                    <div class="row"><div class="col-lg-3">City:</div><div class="col-lg-5">#rc.BillAddress.getCity()#</div></div>
                    <div class="row"><div class="col-lg-3">State:</div><div class="col-lg-5">#rc.BillAddress.getState()#</div></div>
                    <div class="row"><div class="col-lg-3">Zip:</div><div class="col-lg-5">#rc.BillAddress.getZip()#</div></div>
                    <div class="row"><div class="col-lg-3">Day Phone:</div><div class="col-lg-5">#rc.BillAddress.getDayPhone()#</div></div>
                    <div class="row"><div class="col-lg-3">Eve Phone:</div><div class="col-lg-5">#rc.BillAddress.getEveningPhone()#</div></div>
                    <cfif (rc.BillAddress.getMilitaryBase()  is not "")>
                        <div class="row"><div class="col-lg-3">Military Base:</div><div class="col-lg-5">#rc.ShipAddress.getMilitaryBase()#</div></div>
					</cfif>
					
                    <div class="row"><div class="col-lg-8"><h4>Shipping Information</h4></div></div>
                    <div class="row"><div class="col-lg-3">First Name:</div><div class="col-lg-5">#rc.ShipAddress.getFirstName()#</div></div>
                    <div class="row"><div class="col-lg-3">Last Name:</div><div class="col-lg-5">#rc.ShipAddress.getLastName()#</div></div>
                    <div class="row"><div class="col-lg-3">Company:</div><div class="col-lg-5">#rc.ShipAddress.getCompany()#</div></div>
                    <div class="row"><div class="col-lg-3">Address 1:</div><div class="col-lg-5">#rc.ShipAddress.getAddress1()#</div></div>
                    <cfif (rc.ShipAddress.getAddress2()  is not "")>
                        <div class="row"><div class="col-lg-3">Address 2:</div><div class="col-lg-5">#rc.ShipAddress.getAddress2()#</div></div>
					</cfif>
                    <cfif (rc.ShipAddress.getAddress3()  is not "")>
                        <div class="row"><div class="col-lg-3">Address 3:</div><div class="col-lg-5">#rc.ShipAddress.getAddress3()#</div></div>
					</cfif>
                    <div class="row"><div class="col-lg-3">City:</div><div class="col-lg-5">#rc.ShipAddress.getCity()#</div></div>
                    <div class="row"><div class="col-lg-3">State:</div><div class="col-lg-5">#rc.ShipAddress.getState()#</div></div>
                    <div class="row"><div class="col-lg-3">Zip:</div><div class="col-lg-5">#rc.ShipAddress.getZip()#</div></div>
                    <div class="row"><div class="col-lg-3">Day Phone:</div><div class="col-lg-5">#rc.ShipAddress.getDayPhone()#</div></div>
                    <div class="row"><div class="col-lg-3">Eve Phone:</div><div class="col-lg-5">#rc.ShipAddress.getEveningPhone()#</div></div>
                    <cfif (rc.ShipAddress.getMilitaryBase()  is not "")>
                        <div class="row"><div class="col-lg-3">Military Base:</div><div class="col-lg-5">#rc.ShipAddress.getMilitaryBase()#</div></div>
					</cfif>
					
					<!--- start of additional information --->
                    <div class="row"><div class="col-lg-8"><b>Additional Information</b></div></div>
                    <div class="row"><div class="col-lg-3">Tax Transaction ID:</div><div class="col-lg-5">#rc.Order.getSalesTaxTransactionId()#</div></div>
                    <div class="row"><div class="col-lg-3">Was Tax Committed?:</div><div class="col-lg-5">#rc.Order.getIsSalesTaxTransactionCommited()#</div></div>
                    <div class="row"><div class="col-lg-3">Tax Refund Id:</div><div class="col-lg-5">#rc.Order.getSalesTaxRefundTransactionId()#</div></div>

 
				</div>
				<!--- end of order general tab --->
					
				<!--- start of detail tab --->	
				<div id="OrderDetails">
                    <div class="row rowpad">
                        <div class="col-lg-6">
                            <button class="btn btn-primary actionButton" onclick="javascript:$('.longView' ).toggle();"
                                    data-bind="click: showHideDetail" type="button">
                                Show/Hide Pricing Detail
                            </button>
                        </div>
                    </div>

					<cfset groupBreak = ""/>
					<cfset previousOrderDetailType = "" />
					<cfset odNext = 1 />
					<cfloop array="#rc.orderDetail#" index="od">
						<cfset odNext = odNext+1 />
						<cfset GroupNameId = "returnInProgress_" & replace(od.getGroupName(),' ', '_',"ALL")/>
						<cfset FreebieId = "freebie_" & replace(od.getGroupName(),' ', '_',"ALL")/>
						<cfif od.getGroupName() is not groupBreak and od.getGroupName() is not "Additional Items">
							<hr/>
							<div class="GroupHeader">
                            <div class="row">
                                <div class="col-lg-8">#od.getGroupName()#</div>
                                   <div class="col-lg-4">
                                        <div class="selectItem" style="float:right;">
											<cfif rc.groupNameList is "" or listfind(rc.groupNameList,od.getGroupName()) is 0>
                                            	<label for="ItemsToReturn">Select Item</label>											
                                            	<input class="itemGroup" type="checkbox" id="#GroupNameId#" name="ItemsToReturn" value="#od.getGroupName()#" onclick="ShowHideButtons()" />
											<cfelse>
												<span class="alreadyReturned">This item has already been returned</span>
											</cfif>
                                        </div>
                                    </div>
								</div>
							</div>
							<cfset groupBreak = od.getGroupName() />
						</cfif>	
						<!--- display the items in the group --->
							
						<!--- start of order detail type 'd' (devices) --->
						<cfif od.GetOrderDetailType() is "d">
							<cfset wl = getWirelessLine(od.getOrderdetailId(), rc.wirelesslines) />
                            <!---<div class="row"><div class="col-lg-1 orderDetailLabel">Device:</div></div>--->
                            <div class="row productname oddstripe"><div class="col-lg-2"><span class="orderDetailLabel">Device:</span></div><div class="col-lg-7 productTitle">#od.getProductTitle()#</div></div>
                            <div class="row"><div class="col-lg-2"></div><div class="col-lg-7">GERS SKU: #od.getGersSku()#</div></div>
                            <cfif wl.getCurrentMDN() is not "" >
	                            <div class="row"><div class="col-lg-2"></div><div class="col-lg-7">Current MDN: #wl.getCurrentMDN()#</div></div>
							</cfif>
                            <cfif wl.getNewMDN() is not "">
	                            <div class="row"><div class="col-lg-2"></div><div class="col-lg-7">New MDN: #wl.getNewMDN()#</div></div>
							</cfif>
                            <cfif wl.getIMEI() is not "">							
                                <div class="row"><div class="col-lg-2"></div><div class="col-lg-7">IMEI/ESN:#wl.getIMEI()#</div></div>
							</cfif>
							<cfif wl.getSIM() is not "">
                                <div class="row"><div class="col-lg-2"></div><div class="col-lg-7">SIM: #wl.getSIM()#</div></div>
							</cfif>
								
                            <div class="longView">
                                <div class="row"><div class="col-lg-2"></div><div class="col-lg-2 pricing">Retail Price:</div><div class="col-lg-1 pricing"><span style="float:right">#decimalformat(od.getRetailPrice())#</span></div></div>
								<cfset OnlineDiscount = od.getRetailPrice() - od.getNetPrice()  />
                                <div class="row"><div class="col-lg-2"></div><div class="col-lg-2 pricing">Online Discount:</div><div class="col-lg-1 pricing"><span style="float:right">#decimalformat(OnlineDiscount)#</span></div></div>
                                <div class="row"><div class="col-lg-2"></div><div class="col-lg-2 pricing">Net Price:</div><div class="col-lg-1 pricing"><span style="float:right">#decimalformat(od.getNetPrice())#</span></div></div>
                                <div class="row"><div class="col-lg-2"></div><div class="col-lg-2 pricing">Taxes:</div><div class="col-lg-1 pricing"><span style="float:right">#decimalformat(od.getTaxes())#</span></div></div>
								<cfset TotalPrice = od.getNetPrice() + od.getTaxes() />
                                <div class="row"><div class="col-lg-2"></div><div class="col-lg-2 pricing">Total:</div><div class="col-lg-1 pricing"><span style="float:right">#decimalformat(TotalPrice)#</span></div></div>
                            </div>
						</cfif>
						<!--- end of  order detail type 'd' (devices) --->

						<!--- Free Accessories --->
						<cfif od.GetOrderDetailType() is "a" and od.getRetailPrice() is 0>
							<div class="row productname oddstripe"><div class="col-lg-2"><span class="orderDetailLabel">Free Accessory:</span></div><div class="col-lg-7 productTitle">#od.getProductTitle()#</div>
							<cfset groupName = replace(od.getGroupName()," ","_","ALL") />
							<cfset className = "returnInProgress_" & groupName />
							<div class="#className# col-lg-3 freeAccessoryReturn" style="display: none;">
								Free Accessory Returned? <input type="checkbox" id="#FreebieId#" name="FreeAccessoriesToReturn" value="#od.getOrderDetailId()#" />
							</div>
							</div>
						</cfif>	
						<!--- End of Free Accessories --->
							
						<!--- start of order detail type 'r' (plans) --->	
						<cfif od.GetOrderDetailType() is "r">	
                            <!---<div class="row"><div class="col-lg-8 orderDetailLabel">Plan:</div></div>--->
                            <div class="row productname"><div class="col-lg-2"><span class="orderDetailLabel">Plan:</span></div><div class="col-lg-7 productTitle">#od.getProductTitle()#</div></div>
                            <div class="row"><div class="col-lg-2"></div><div class="col-lg-7">GERS SKU: #od.getGersSku()#</div></div>
                            <div class="longView">
                                <div class="row"><div class="col-lg-2"></div><div class="col-lg-2 pricing">Monthly:</div><div class="col-lg-1 pricing"><span style="float:right">#decimalformat(wl.getMonthlyFee())#</span></div></div>
                            </div>
						</cfif>								
						<!--- end of order detail type 'r' (plans) --->							

						<!--- start of order detail type 's' (services) --->
						<cfif od.GetOrderDetailType() is "r" and ArrayLen(wl.GetLineServices())>	
                            <!---<div class="row"><div class="col-lg-8 orderDetailLabel">Services:</div></div>--->
							<cfloop array="#wl.getLineServices()#" index = "ls">
                            	<div class="row productname"><div class="col-lg-2"><span class="orderDetailLabel">Services:</span></div><div class="col-lg-7 productTitle">#ls.getProductTitle()#</div></div>
                            	<div class="longView">
                                	<div class="row"><div class="col-lg-2"></div><div class="col-lg-2 pricing">Monthly:</div><div class="col-lg-1 pricing"><span style="float:right">#decimalformat(ls.getLineService().getMonthlyFee())#</span></div></div>
                            	</div>
							</cfloop>
						</cfif>								
						<!--- end of order detail type 's' (services) --->							


						<!--- start of order detail type 'w' (warranties) --->	
						<cfif od.GetOrderDetailType() is "w">	
							 <!---<div class="row"><div class="col-lg-8 orderDetailLabel">Protection Plan:</div></div>--->
                                <div class="row productname"><div class="col-lg-2"><span class="orderDetailLabel">Protection Plan:</span></div><div class="col-lg-7 productTitle">#od.getProductTitle()#</div></div>
                                <div class="longView">
                                    <div class="row"><div class="col-lg-2"></div><div class="col-lg-2 pricing">Retail Price:</div><div class="col-lg-1 pricing"><span style="float:right">#decimalformat(od.getRetailPrice())#</span></div></div>
									<cfset OnlineDiscount = od.getRetailPrice() - od.getNetPrice()  />
                                    <div class="row"><div class="col-lg-2"></div><div class="col-lg-2 pricing">Online Discount:</div><div class="col-lg-1 pricing"><span style="float:right">#decimalformat(OnlineDiscount)#</span></div></div>
                                    <div class="row"><div class="col-lg-2"></div><div class="col-lg-2 pricing">Net Price:</div><div class="col-lg-1 pricing"><span style="float:right">#decimalformat(od.getNetPrice())#</span></div></div>
                                    <div class="row"><div class="col-lg-2"></div><div class="col-lg-2 pricing">Taxes:</div><div class="col-lg-1 pricing"><span style="float:right">#decimalformat(od.getTaxes())#</span></div></div>
									<cfset TotalPrice = od.getNetPrice() + od.getTaxes() />
                                    <div class="row"><div class="col-lg-2"></div><div class="col-lg-2 pricing">Total:</div><div class="col-lg-1 pricing"><span style="float:right">#decimalformat(TotalPrice)#</span></div></div>
								</div>
                         </cfif>								
						<!--- end of order detail type 'w' (warranties) --->	
						
						<!--- Start of Reason/Comment Block --->
                        <cfif arraylen(rc.orderDetail)+1 is odNext or rc.OrderDetail[odNext].getGroupName() is not groupBreak>
							<cfset groupName = replace(rc.OrderDetail[odNext - 1].getGroupName()," ","_","ALL") />
                            <cfset reasonName = groupName & "_Reason" />
                            <cfset commentName = groupName & "_Comment" />
                            <cfset className = "returnInProgress_" & groupName />
                            <div class="#className#">
                                <div class="reasonContainer">
                                	<div>
                                		<div class="row rowpad">
                                			<div class="col-lg-12">
	                                    		You must provide both a reason and a comment for returning this device.
                                			</div>
                                		</div>
	                                    <div class="row rowpad">
	                                    	<div class="col-lg-1">Reason:</div>
												<div class="col-lg-5">													
			                                    	<select name="#reasonName#" class="validate[required:###GroupNameId#]:checked" data-message="Please select a reason returning this item">
				                                    	<option value="" disabled selected>Select reason...</option>
														<option value="Defective">Defective</option>
														<option value="Damaged">Damaged</option>
														<option value="Doesn't Like">Doesn't Like</option>
														<option value="Audio Issues">Audio Issues</option>
														<option value="Battery Issues">Battery Issues</option>
														<option value="Camera Issues">Camera Issues</option>
														<option value="Display Issues">Display Issues</option>
														<option value="Keypad Issues">Keypad Issues</option>
														<option value="Charging Issues">Charging Issues</option>
														<option value="Poor / No Service">Poor / No Service</option>
														<option value="Power Issues">Power Issues</option>
														<option value="Receive / Transmit Issues">Receive / Transmit Issues</option>
														<option value="Return">Return</option>
													</select>
												</div>
	                                    	</div>
										</div>
									<div>
	                                    <div class="row rowpad"><div class="col-lg-1">Comment:</div><div class="col-lg-5"><TextArea maxlength="250" rows="10" cols="60" name="#commentName#" id="#commentName#"  class="autosizeme validate[required:###GroupNameId#]:checked"></textarea>  <div class="countdown">(<span class="countdown" id="#commentName#_countdown"></span> characters left)</div></div></div>
												<script type="text/javascript">
    												$('###commentName#').limit('250','###commentName#_countdown');
												</script>		

									</div>
                                </div>
                            </div>
                        </cfif>
						<!--- End of Reason/Comment Block --->
                        
						<cfset previousOrderDetailType = od.GetOrderDetailType() />
						
					</cfloop>
					
					
					<!--- Count non-free accessories --->
					<cfset nfa_count = 0 />
					<cfloop array="#rc.orderDetail#" index="od">
						<cfif od.GetOrderDetailType() is "a" and od.getRetailPrice() gt 0>
							<cfset nfa_count = nfa_count+1 />
						</cfif>
					</cfloop>
					
					
					<!--- Show any non-free accessories --->
					<cfif nfa_count gt 0>
						<div class="GroupHeader accessories">
                            <div class="row">
                                <div class="col-lg-8">Accessories : <span style="font-weight:normal;font-size:85%;">(Check the accessories being returned)</span></div>								
							</div>
						</div>
						<cfset acc_ct = 0 />
						<cfloop array="#rc.orderDetail#" index="od">
							<cfif od.GetOrderDetailType() is "a" and od.getRetailPrice() gt 0>	
								<cfset acc_ct = acc_ct+1 />
								<cfset AccessoryId = "returnInProgress_" & replace(od.getOrderDetailId(),' ', '_',"ALL")/>
								<cfif acc_ct mod 2 is 0>
									<cfset stripeClass = "evenStripe">
								<cfelse>
									<cfset stripeClass = "oddStripe">
								</cfif>							
	
								<cfif len(od.getRMAReason()) >
									<cfset alreadyReturned = true />
								<cfelse>
									<cfset alreadyReturned = false />
								</cfif>							
								<div class="accessory #stripeClass#">
		                            <div class="row accessoryname #stripeClass#">
		                            	<div class="col-lg-9 productTitle"><cfif not alreadyReturned><input class="itemGroup" type="checkbox" id="#Accessoryid#" name="AccessoriesToReturn" value="#od.getOrderDetailId()#" onclick="ShowHideButtons()" /></cfif><cfif alreadyReturned> <span class="alreadyReturned">(already returned)</span></cfif>&nbsp;&nbsp;#od.getProductTitle()#</div>
	                                </div>
									
	
		                            <!---<div class="row"><div class="col-lg-1"></div><div class="col-lg-7">GERS Sku: #od.getGersSku()#</div></div>--->
		                            <div class="longView">
		                                <div class="row"><div class="col-lg-1"></div><div class="col-lg-2 pricing">Retail Price:</div><div class="col-lg-1 pricing"><span style="float:right">#decimalformat(od.getRetailPrice())#</span></div></div>
										<cfset OnlineDiscount = od.getRetailPrice() - od.getNetPrice()  />
		                                <div class="row"><div class="col-lg-1"></div><div class="col-lg-2 pricing">Online Discount:</div><div class="col-lg-1 pricing"><span style="float:right">#decimalformat(OnlineDiscount)#</span></div></div>
		                                <div class="row"><div class="col-lg-1"></div><div class="col-lg-2 pricing">Net Price:</div><div class="col-lg-1 pricing"><span style="float:right">#decimalformat(od.getNetPrice())#</span></div></div>
		                                <div class="row"><div class="col-lg-1"></div><div class="col-lg-2 pricing">Taxes:</div><div class="col-lg-1 pricing"><span style="float:right">#decimalformat(od.getTaxes())#</span></div></div>
										<cfset TotalPrice = od.getNetPrice() + od.getTaxes() />
		                                <div class="row"><div class="col-lg-1"></div><div class="col-lg-2 pricing">Total:</div><div class="col-lg-1 pricing"><span style="float:right">#decimalformat(TotalPrice)#</span></div></div>
		                            </div>	
									
									<!--- Start of Accessory Reason/Comment Block --->
		                            <cfset reasonName = "Reason_" &od.getOrderDetailId()  />
		                            <cfset commentName = "Comment_" & od.getOrderDetailId()   />
		                            <cfset className = "returnInProgress_" & #od.getOrderDetailId()# />
									
		                            <div class="#className#">
		                                <div class="reasonContainer">
		                                	<div>
			                                    <div class="row rowpad">
			                                    	<div class="col-lg-1">Reason:</div>
														<div class="col-lg-5">
					                                    	<select name="#reasonName#">
								                                <option value="" disabled selected>Select...</option>
																<option value="Defective">Defective</option>
																<option value="Damaged">Damaged</option>
																<option value="Doesn't Like">Doesn't Like</option>
																<option value="Audio Issues">Audio Issues</option>
																<option value="Battery Issues">Battery Issues</option>
																<option value="Camera Issues">Camera Issues</option>
																<option value="Display Issues">Display Issues</option>
																<option value="Keypad Issues">Keypad Issues</option>
																<option value="Charging Issues">Charging Issues</option>
																<option value="Poor / No Service">Poor / No Service</option>
																<option value="Power Issues">Power Issues</option>
																<option value="Receive / Transmit Issues">Receive / Transmit Issues</option>
																<option value="Return">Return</option>
															</select>
														</div>
			                                    	</div>
												</div>
											<div>
			                                    <div class="row rowpad"><div class="col-lg-1">Comment:</div><div class="col-lg-5"><TextArea maxlength="250" rows="10" cols="60" name="#commentName#" id="#commentName#"class="autosizeme"></textarea> <div class="countdown">(<span class="countdown" id="#commentName#_countdown"></span> characters left)</div></div></div>
												<script type="text/javascript">
    												$('###commentName#').limit('250','###commentName#_countdown');
												</script>		
											</div>
		                                </div>
		                            </div>
									<!--- End of Reason/Comment Block --->
								</div>
							</cfif>
						</cfloop>
					</cfif>
					
				</div>
				<!--- end of detail tab --->
				
				<!--- start of order notes --->
				<div id="OrderNotes">
					To be implemented in the future.
				</div>
				<!--- end of order notes --->
			</div>
		</div>
	</div>	
	<hr />
	<!---<div class="returnInProgress"> 
	<button class="btn btn-primary" type="submit" Title="Continue processing the return transaction with selected items">Next</button>&nbsp;&nbsp;
	</div>	--->
</form>

	<hr />
	<div class="xxxreturnInProgress">    
		<div class="row clearBackNext">
			<div class="col-md-12">
				<table cellpadding="10" border="0">
					<tr>
					<td><button class="btn btn-default" onclick="javascript: $('##ReturnItemSelectForm')[0].reset();"  type="button">Clear</button>&nbsp;&nbsp;</td>
					<td><form action="#event.buildLink('mainVFD.homepageVFD')#" method="post">
					<button class="btn btn-default" type="submit" style="width: 200px;">Cancel</button>&nbsp;&nbsp;
					</form></td>
					<td><form action="#event.buildLink('ddadmin.searchForm')#" method="post">
					<button class="btn btn-primary" type="submit" style="width: 200px;">Try Another Search</button>&nbsp;&nbsp;
					</form></td>
					<td class="returnInProgress">
						<button id="ReturnItemSelectFormSubmit" class="btn btn-next" type="submit" Title="Continue processing the return transaction with selected items">Continue to Carrier Deactivation...</button>
					</td
					</tr>
				</table>
			</div>
		</div>
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

