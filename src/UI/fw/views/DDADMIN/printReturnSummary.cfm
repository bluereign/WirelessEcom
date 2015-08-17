<cfset theOrder = session.ddadmin.returnRequest.Order />
<cfset local.shipAddress = theOrder.getShipAddress() />

<cfloop from="1" to="3" index="copyNum">
<cfset GrandTotal = 0.00 />
<!---<cfinclude template="wa_costcoHead.cfm" />--->
<cfoutput>
	#headerContent#
	<div class="row">
		<div class="col-sm-12 pageTitle">
			#textDisplayRenderer.getBusinessName()# Direct Delivery Return Summary
			<br/>
			<cfif copyNum is 1>
				<i>Customer Copy</i>
			<cfelseif copyNum is 2>
				<i>Include with Return Shipment</i>
			<cfelseif copyNum is 3>
				<i>#textDisplayRenderer.getStoreAliasName()# Copy</i>
			</cfif>
		</div>
	</div>
	
   	<div class="row rowpad tableHeading">
   		<div class="col-sm-3">Order Number</div>
		<div class="col-sm-4">Shipping Address</div>
		<div class="col-sm-2">GERS SO</div>
   	</div>
	
   	<div class="row rowpad">
		<div class="col-sm-3">#theOrder.getOrderid()#</div>
		<div class="col-sm-4">#local.shipAddress.getFirstName()# #local.shipAddress.getLastName()#<br />
			<cfif len(trim(local.shipAddress.getCompany()))>
				#local.shipAddress.getCompany()#<br />
			</cfif>
			#local.shipAddress.getAddress1()#<br/>
			<cfif len(trim(local.shipAddress.getAddress2()))>
				#local.shipAddress.getAddress2()#<br />
			</cfif>
			<cfif len(trim(local.shipAddress.getAddress3()))>
				#local.shipAddress.getAddress3()#<br />
			</cfif>
			#local.shipAddress.getCity()#, #local.shipAddress.getState()# #local.shipAddress.getZip()#
		</div>
		<div class="col-sm-2" style="font-weight:bolder;font-size:250%"><cfif theOrder.getGersRefNum() is not "">#theOrder.getGersRefNum()#<cfelse>N/A</cfif></div>
	</div>
	
	
		<cfset accessoryHeader = false />
		<cfloop array="#session.ddadmin.returnRequest.ItemsReturned#" index="r">
			<cfif r.groupName is not "">
				<div class="row tableHeading rowpad">
					<div class="col-sm-12">#r.groupName#</div>
				</div>				
			<cfelseif accessoryHeader is false>
					<div class="row tableHeading">
						<div class="col-sm-12">Accessories</div>						
					</div>
					<cfset accessoryHeader = true />
					<cfset ac_ct = 0 />
			</cfif>
				<cfset device_ct = 0 />
				
				<cfloop array="#session.ddadmin.returnRequest.Order.getOrderDetail(true)#" index="od">
					<cfif od.GetOrderDetailType() is "d" and od.getGroupName() is r.groupName >
					
						<cfset wl = getWirelessLine(od.getOrderdetailId(), session.ddadmin.returnRequest.Order.getWirelesslines()) />
   						<cfset device_ct = device_ct+1>
						<cfif device_ct gt 1>
								<div class="row">
									<div class="col-sm-2">
										<hr/>
									</div>
								</div>
						</cfif>

                        <div class="row">
                        	<div class="col-sm-2">Device:</div>
							<div class="col-sm-10">#od.getProductTitle()#</div>
						</div>
                        <div class="row">
							<div class="col-sm-10">#od.getGersSku()#</div>
						</div>
						<div class="row">
                        	<div class="col-sm-2 ">IMEI/ESN:</div>
							<div class="col-sm-10 ">#wl.getIMEI()#</div>
						</div>
						<div class="row">
                        	<div class="col-sm-2 ">SIM:</div>
							<div class="col-sm-10 ">#wl.getSIM()#</div>
						</div>
						<cfif wl.getCurrentMDN() is not "" >
							<div class="row">
	                        	<div class="col-sm-2 ">Current MDN:</div>
								<div class="col-sm-10 ">#wl.getCurrentMDN()#</div>
							</div>
						</cfif>
						<cfif wl.getNewMDN() is not "" >
							<div class="row">
	                        	<div class="col-sm-2 ">New MDN:</div>
								<div class="col-sm-10 ">#wl.getNewMDN()#</div>
							</div>
						</cfif>
						<div class="pricing" />
                        <div class="row"><div class="col-sm-3 orderDetailPrice">Retail Price:</div><div class="col-sm-1"><span style="float:right;">#decimalformat(od.getRetailPrice())#</span></div></div>
						<cfset OnlineDiscount = od.getRetailPrice() - od.getNetPrice()  />
                        <div class="row"><div class="col-sm-3 orderDetailPrice">Online Discount:</div><div class="col-sm-1"><span style="float:right">#decimalformat(OnlineDiscount)#</span></div></div>
                        <div class="row"><div class="col-sm-3 orderDetailPrice">Net Price:</div><div class="col-sm-1"><span style="float:right">#decimalformat(od.getNetPrice())#</span></div></div>
                        <div class="row"><div class="col-sm-3 orderDetailPrice">Taxes:</div><div class="col-sm-1"><span style="float:right">#decimalformat(od.getTaxes())#</span></div></div>
						<cfset TotalPrice = od.getNetPrice() + od.getTaxes() />
						<cfset GrandTotal = GrandTotal + TotalPrice />
                        <div class="row"><div class="col-sm-3 orderDetailPrice" >Total:</div><div class="col-sm-1 orderDetailLabel"><span style="float:right">#decimalformat(TotalPrice)#</span></div></div>
						</div>
						
						
						<cfset odw = wl.getLineWarranty() />	
						<cfif isObject(odw) >
                        	<div class="row"><div class="col-sm-2">Warranty:</div><div class="col-sm-7">#odw.getProductTitle()#  (#odw.getGersSku()#)</div></div>
                            <div class="row"><div class="col-sm-3 orderDetailPrice">Retail Price:</div><div class="col-sm-1"><span style="float:right;">#decimalformat(odw.getRetailPrice())#</span></div></div>
							<cfset OnlineDiscount = odw.getRetailPrice() - odw.getNetPrice()  />
                            <div class="row"><div class="col-sm-3 orderDetailPrice">Online Discount:</div><div class="col-sm-1"><span style="float:right">#decimalformat(OnlineDiscount)#</span></div></div>
                            <div class="row"><div class="col-sm-3 orderDetailPrice">Net Price:</div><div class="col-sm-1"><span style="float:right">#decimalformat(odw.getNetPrice())#</span></div></div>
                            <div class="row"><div class="col-sm-3 orderDetailPrice">Taxes:</div><div class="col-sm-1"><span style="float:right">#decimalformat(odw.getTaxes())#</span></div></div>
							<cfset TotalPrice = odw.getNetPrice() + odw.getTaxes() />
							<cfset GrandTotal = GrandTotal + TotalPrice />
                            <div class="row"><div class="col-sm-3 orderDetailPrice">Total:</div><div class="col-sm-1 orderDetailLabel"><span style="float:right">#decimalformat(TotalPrice)#</span></div></div>
						</cfif>

						<div class="row">
                        	<div class="col-sm-2 ">Reason:</div>
							<div class="col-sm-10 ">#r.Reason#</div>
						</div>
						<div class="row">
                        	<div class="col-sm-2 ">Comment:</div>
							<div class="col-sm-10 ">#r.Comment#</div>
						</div>						
					</cfif>					
				</cfloop>
				<cfif accessoryHeader is true>
					<cfset i = r />
					<cfif i.orderdetailid is not "" >
						<cfset ac_ct = ac_ct+1>
						<cfif ac_ct gt 1>
							<div class="row">
								<div class="col-sm-2">
									<hr/>
								</div>
							</div>
						</cfif>
						<cfset od = createObject( "component", "cfc.model.OrderDetail" ).init() />
						<cfset od.load(i.orderDetailId) />
						<div class="row">
							<div class="col-sm-2 ">Accessory:</div>
							<div class="col-sm-10 ">#od.getProductTitle()#</div>
						</div>
						<div class="row">
							<div class="col-sm-2 ">Gers Sku:</div>
							<div class="col-sm-10 ">#od.getGersSku()#</div>
						</div>
                        <div class="row"><div class="col-sm-3 orderDetailPrice">Retail Price:</div><div class="col-sm-1"><span style="float:right;">#decimalformat(od.getRetailPrice())#</span></div></div>
						<cfset OnlineDiscount = od.getRetailPrice() - od.getNetPrice()  />
                        <div class="row"><div class="col-sm-3 orderDetailPrice">Online Discount:</div><div class="col-sm-1"><span style="float:right">#decimalformat(OnlineDiscount)#</span></div></div>
                        <div class="row"><div class="col-sm-3 orderDetailPrice">Net Price:</div><div class="col-sm-1"><span style="float:right">#decimalformat(od.getNetPrice())#</span></div></div>
                        <div class="row"><div class="col-sm-3 orderDetailPrice">Taxes:</div><div class="col-sm-1"><span style="float:right">#decimalformat(od.getTaxes())#</span></div></div>
						<cfset TotalPrice = od.getNetPrice() + od.getTaxes() />
						<cfset GrandTotal = GrandTotal + TotalPrice />
                        <div class="row"><div class="col-sm-3 orderDetailPrice" >Total:</div><div class="col-sm-1 orderDetailLabel"><span style="float:right">#decimalformat(TotalPrice)#</span></div></div>
						
<!---						<div class="row">
							<div class="col-sm-2 orderDetailPrice">Retail Price:</div>
							<div class="col-sm-10 ">#decimalformat(od.getRetailPrice())#</div>
						</div>
						<cfset OnlineDiscount = od.getRetailPrice() - od.getNetPrice()  />
						<div class="row">
							<div class="col-sm-2 orderDetailPrice">Online Discount:</div>
							<div class="col-sm-10 ">#decimalformat(OnlineDiscount)#</div>
						</div>
						<div class="row">
							<div class="col-sm-2 orderDetailPrice">Net Price:</div>
							<div class="col-sm-10 ">#decimalformat(od.getNetPrice())#</div>
						</div>
						<div class="row">
							<div class="col-sm-2 orderDetailPrice">Taxes:</div>
							<div class="col-sm-10 ">#decimalformat(od.getTaxes())#</div>
						</div>
						<div class="row">
							<div class="col-sm-2 orderDetailPrice">Total:</div>
							<div class="col-sm-10 ">#decimalformat(od.getTaxes())#</div>
						</div>
--->						<div class="row">
							<div class="col-sm-2 ">Reason:</div>
							<div class="col-sm-10 ">#r.Reason#</div>
						</div>
						<div class="row">
							<div class="col-sm-2 ">Comment:</div>
							<div class="col-sm-10 ">#r.Comment#</div>
						</div>
						
					</cfif>
			</cfif>			

		</cfloop>
		<div class="row"><div class="col-sm-2"><hr/></div></div>
		<div class="row" style="font-weight: bolder; font-size:110%;"><div class="col-sm-2">Return Total:</div><div class="col-sm-10 ">#dollarformat(GrandTotal)#</div></div>
		#footerContent#
		</cfoutput>		
		<!---<cfinclude template="wa_costcoFoot.cfm" />--->		
		<cfif copyNum lt 3>
			<div class="page-break"></div>
		</cfif>
<!---	</div>
</div>--->




</cfloop>


<cffunction name="getWirelessLine" returnType="cfc.model.wirelessLine">
		<cfargument name="orderDetailId" type="numeric" required="true" />
		<cfargument name="wirelesslines" type="cfc.model.wirelessline[]" required="true" />
		
		<cfset var local = {} />
		<cfloop array="#arguments.wirelesslines#" index="local.wl">
			<cfif local.wl.getOrderDetailId() is arguments.orderdetailid >
				<cfreturn local.wl />
			</cfif>		
		</cfloop>
		<cfreturn "" />
</cffunction>	