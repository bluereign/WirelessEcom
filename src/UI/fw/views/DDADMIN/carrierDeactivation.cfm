

<!---<cfdump var="#form#" />
<cfdump var="#session.ddadmin.returnRequest#" />--->


<!--- Putting this in local just to make the C&P code below work --->
<cfset local = {} />
<cfset local.carrierid =  session.ddadmin.returnRequest.Order.getCarrierId() />
<cfoutput>
		<div class="row"/>		
			<div class="col-md-12 instructions"><span class="instructionLabel">Instructions:</span> <span class="instructionText">Click the <b style="color:blue;">Carrier Deactivation Link</b> to bring up the activation window. Using the carrier activation window, deactivate the device or devices being returned. 
			When you have completed the deactivations, click the 'Continue to CampusShip' button below.</span></div>
		</div>	
		<div class="row"/>
		<cfset wirelessLines = session.ddadmin.returnRequest.order.getWirelessLines() />
		<div class="col-md-12 instructions">
			The following device(s) need to be deactivated:
			<ul>
			<cfloop array="#session.ddadmin.returnRequest.ItemsReturned#" index="r">
				<cfloop array="#session.ddadmin.returnRequest.Order.getOrderDetail()#" index="od">
					<cfif r.GroupName is not "" and od.getGroupName() is r.groupName and od.GetOrderDetailType() is  "d">
						<cfset wl = GetWirelessLine(od.getOrderDetailId(),wirelessLines) />
						<li>#od.getProductTitle()#: IMEI=#wl.getIMEI()#, GERSSKU=#od.GetGersSku()#</li>
					</cfif>
				</cfloop>				
			</cfloop>
			</ul>
			</div>							
		</div>	
			
		<div class="row"/>	
			<div class="col-md-2 buttonSpacer">	
				<form action="#event.buildLink('mainVFD.homepageVFD')#" method="post">
					<button class="btn btn-default" type="submit" style="width: 150px;">Cancel</button>&nbsp;&nbsp;
				</form>		
			</div>	
			<div class="col-md-4 buttonSpacer">
			<!--- Bring up a window with the carrier activation site --->

		
				<cfif local.carrierId eq "109"><!--- ATT --->
				<form action="http://opusld.att.com/opus/findhome.do" method="get" target="_blank">
					<button class="btn btn-primary" type="submit" style="width: 375px;">Click for AT&T Deactivation</button>
				</form>	
					
				<cfelseif local.carrierId eq "299"><!--- SPRINT --->
				<form action="https://indirect.sprint.com/indrestricted/nrgen" method="get" target="_blank">
					<button class="btn btn-primary" type="submit" style="width: 375px;">Click for Sprint Deactivation</button>
				</form>
						
				<cfelseif local.carrierId eq "128"><!--- TMOBILE --->															
				<form action="https://quikview.t-mobile.com/mosaic/##/applications/QuikViewWeb" method="get" target="_blank">
					<button class="btn btn-primary" type="submit" style="width: 375px;">Click for T-Mobile Deactivation</button>
				</form>	
					
				<cfelseif local.carrierId eq "42"><!--- VERIZON --->					
				<form action="https://cim.verizonwireless.com/cimPreAuth‎" method="post" target="_blank">
					<input type="hidden" name="mode" value="friendly" />
					<input type="hidden" name="destinationURL" value="https://eroes-ss.west.verizonwireless.com/eroes/eROES.jsp" />
					<button class="btn btn-primary" type="submit" style="width: 375px;">Click for Verizon Deactivation</button>
				</form>		
				</cfif>
	
			</div>
			
			<div class="col-md-5 buttonSpacer">
				<form action="#event.buildLink('ddadmin.campusShip')#" method="post">
					<button class="btn btn-next" type="submit" style="width: 400px;">Continue to CampusShip...</button>
				</form>		
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
