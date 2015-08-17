<cfcomponent output="false" extends="BaseHandler">
	
	<!--- Use CFProperty to declare beans for injection.  By default, they will be placed in the variables scope --->
	<cfproperty name="assetPaths" inject="id:assetPaths" scope="variables" />
	
	<cfset variables.stepVals = structNew() />
	<cfset variables.stepVals.verify = 1 />
	<cfset variables.stepVals.searchForm = 2 />
	<cfset variables.stepVals.selectOrder = 3 />
	<cfset variables.stepVals.selectItems = 4 />
	<cfset variables.stepVals.carrierDeactivation = 5 />		
	<cfset variables.stepVals.campusShip = 6 />
	<cfset variables.stepVals.returnSummary = 7 />
	<cfset variables.stepVals.returnSubmit = 8 />
	
	<cffunction name="start" returntype="void" output="false">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
	
		<cfif not structKeyExists(session,"ddAdmin")>
			<cfset session.ddadmin = structNew() />
			<cfset session.ddadmin.searchArgs = {
				orderId = "",
				IMEI = "",
				wirelessPhone = "",
				lastName = "",
				firstName = "",
				orderDateFrom = "",
				orderDateTo = ""
			} />			
		</cfif>	
		
		<cfset rc.currentStep = variables.stepVals.verify />	
		<cfset event.setLayout('DDadmin') />
		<cfset event.setView('DDADMIN/start') />
		
		<cfif structKeyexists(session,"DDReturn") is false>
			<cfset session.DDReturn = {} />		
		</cfif>
	</cffunction>
	
	<cffunction name="searchForm" returntype="void" output="false">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">

		<cfset rc.currentStep = variables.stepVals.searchForm />	
		<cfset event.setLayout('DDadmin') />
		<cfset event.setView('DDADMIN/searchform') />
		
	</cffunction>
	
	<cffunction name="searchOrders" returntype="void" output="false">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		
		<cfset var local = {} />
		
		<cfset odfrom = "" />
		<cfset odto = "" />
		<cfif isDate(trim(rc.orderDateFrom))>
			<cfset odfrom = trim(rc.orderDateFrom) />
		</cfif>
		<cfif isDate(trim(rc.orderDateTo))>
			<cfset odto = trim(rc.orderDateTo) />
		</cfif>		
		
		<cfscript>
			local.searchArgs = {
				orderId = ReReplaceNoCase(rc.orderId,"[^0-9]","ALL"),
				IMEI = trim(rc.IMEI),
				wirelessPhone = ReReplaceNoCase(rc.wirelessPhone,"[^0-9]","ALL"),
				lastName = trim(rc.lastname),
				firstName = trim(rc.firstName),
				orderDateFrom = odfrom,
				orderDateTo = odto
			};
			session.ddadmin.searchArgs = local.searchArgs;
			
			local.argCt = 0;
			for (arg in local.searchArgs) {
				if (local.searchArgs[arg] is not "") {
					local.argCt++;
				}
			}
			
			if (local.argCt > 0) {
				rc.qOrders = application.model.order.getDirectDeliveryOrdersBySearchCriteria(local.searchArgs);
				rc.currentStep = variables.stepVals.selectOrder;
				event.setLayout('DDadmin');
				event.setView('DDADMIN/searchResults');
				
			} else {
				rc.currentStep = variables.stepVals.searchForm;
				rc.errorMsg = "You did not specify any search criteria. Please enter some search values and try again.";
				event.setLayout('DDadmin');
				event.setView('DDADMIN/searchform');	
			}
			
		</cfscript>
		
	</cffunction>
	
	<cffunction name="orderDetail" returntype="void" output="false">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		
		<cfset var local = {} />
		
		<cfset local.ddreturn = CreateObject( "component", "cfc.model.ddreturn" ).init() />
		<cfset local.ddreturns = local.ddreturn.getByOrderId(rc.orderId) />
		<cfset rc.groupNameList = ""/>
		<cfloop query="local.ddreturns">			
			<cfset local.ddreturn.load(local.ddreturns.ddreturnid) />
			<cfset rc.groupNameList = listAppend(rc.groupNameList, local.ddreturn.getReturnedGroupNames()) />
		</cfloop>
		<cfset rc.order = CreateObject( "component", "cfc.model.Order" ).init()>
		<cfset rc.order.load( rc.orderId )>
		<cfset rc.shipAddress = rc.order.getShipAddress() />
		<cfset rc.billAddress = rc.order.getBillAddress() />
		<cfset rc.wirelessAccount = rc.order.getWirelessAccount() />
		<cfset rc.wirelessLines = rc.order.getWirelessLines() />
		<cfset rc.OrderDetail = rc.order.getOrderDetail(true) />
		
		<cfset rc.currentStep = variables.stepVals.selectItems />
		<cfset event.setLayout('DDadmin') />
		<cfset event.setView('DDADMIN/orderDetail') />	
		
	</cffunction>
	
	<cffunction name="carrierDeactivation" returntype="void" output="false">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		
		<cfset var local = {} />
		
		<!--- Create the session variable --->
		<cfset session.ddadmin.returnRequest = {} />
		<cfset session.ddadmin.returnRequest.Order = createObject( "component", "cfc.model.Order" ).init() />
		<cfset session.ddadmin.returnRequest.Order.load(form.orderid)/>
		<cfset session.ddadmin.returnRequest.ItemsReturned = arrayNew(1) />
		<cfset session.ddadmin.returnRequest.ReturnDt = now() />

		<cfset local.errMsg = "" />
		<cfset local.missingReason = false />
		<cfset local.missingComment = false />
		<cfparam name="rc.itemsToReturn" default="" />
		<cfloop list="#rc.itemsToReturn#" index="i">
			<cfset local.returnItem = {} /> 
			<cfset local.returnItem.GroupName = i />
			<cfset local.returnItem.orderDetailId = "" />
			<cfset local.fixedGroupName = replace(i," ","_","ALL") />
			<cfif isDefined("#local.fixedGroupName#_Reason") >
				<cfset local.returnItem.Reason = evaluate("#local.fixedGroupName#_Reason") />
				<!---<cfset local.returnItem.ReasonText = getReasonText(local.returnItem.Reason) />--->
			<cfelse>
				<cfset local.errMsg = local.errMsg & "You must specify a reason for all devices/accessories to be returned." />	
				<cfset local.missingReason = true />
			</cfif>
			<cfif isDefined("#local.fixedGroupName#_Comment") and evaluate("#local.fixedGroupName#_Comment") is not "" >
				<cfset local.returnItem.Comment = evaluate("#local.fixedGroupName#_Comment") />
			<cfelse>
				<cfset local.errMsg = local.errMsg & "_br_You must specify a comment for all devices/accessories to be returned." />	
				<cfset local.missingComment = true />
			</cfif>
			<cfif local.errMsg is "">
				<cfset arrayAppend(session.ddadmin.returnRequest.ItemsReturned, local.returnItem) />
			</cfif>
		</cfloop>
		
		<cfparam name="rc.FreeAccessoriesToReturn" default="" />
		<cfloop list="#rc.FreeAccessoriesToReturn#" index="local.i">
			<cfset local.returnItem = {} /> 
			<cfset local.returnItem.GroupName = "" />
			<cfset local.returnItem.orderDetailId = local.i />
			<cfset local.returnItem.Reason = "Return" />
			<cfset local.returnItem.Comment = "Return" />
			<cfset arrayAppend(session.ddadmin.returnRequest.ItemsReturned, local.returnItem) />
		</cfloop>
		
		<cfparam name="rc.accessoriesToReturn" default="" />
		<cfloop list="#rc.accessoriesToReturn#" index="local.i">
			<cfset local.returnItem = {} /> 
			<cfset local.returnItem.GroupName = "" />
			<cfset local.returnItem.orderDetailId = local.i />
			<cfif isDefined("Reason_#local.i#") >
				<cfset local.returnItem.Reason = evaluate("Reason_#local.i#") />
				<!---<cfset local.returnItem.ReasonText = getReasonText(local.returnItem.Reason) />--->
			<cfelse>
				<cfif not local.missingReason>
					<cfset local.errMsg = local.errMsg & "You must specify a reason for all devices/accessories to be returned." />	
					<cfset local.missingReason = true />
				</cfif>
			</cfif>
			<cfif isDefined("Comment_#local.i#") >
				<cfset local.returnItem.Comment = evaluate("Comment_#local.i#") />
			<cfelse>
				<cfset local.errMsg = local.errMsg & "#chr(13)#You must specify a comment for all devices/accessories to be returned." />	
				<cfset local.missingComment = true />
			</cfif>
			<cfif local.errMsg is "">
				<cfset arrayAppend(session.ddadmin.returnRequest.ItemsReturned, local.returnItem) />
			</cfif>
		</cfloop>
		
		
		<cfif listlen(rc.ItemsToReturn) + listlen(rc.accessoriesToReturn) is 0>
			<cfset local.errMsg = "You must select at least one device or accessory to return." />
			<cfset setNextEvent( event='ddadmin.orderDetail',persist='orderid',queryString='errorMsg=#urlencodedformat(local.errMsg)#' ) />
			
		<cfelseif local.missingReason or local.missingComment>

			<!--- Show the error view --->
			<cfset rc.currentStep = variables.stepVals.selectItems />
			<cfset rc.errorMsg = local.errMsg />
			<cfset rc.order = session.ddadmin.returnRequest.Order />
			<cfset rc.orderid = session.ddadmin.returnRequest.Order.getOrderId() />
			<cfset local.errMsg = "You must specify a reason and a comment for all devices and accessories to be returned." />
			<cfset setNextEvent( event='ddadmin.orderDetail',persist='orderid',queryString='errorMsg=#urlencodedformat(local.errMsg)#' ) />

		<cfelse>
		
			<!--- Show the view, if no devices go directly to the campusShip View --->				
			<cfif listlen(rc.ItemsToReturn) gt 0>			
				<cfset rc.currentStep = variables.stepVals.carrierDeactivation />
				<cfset event.setLayout('DDadmin') />
				<cfset event.setView('DDADMIN/carrierDeactivation') />	
			<cfelse>
				<cfset rc.currentStep = variables.stepVals.carrierDeactivation />
				<cfset event.setLayout('DDadmin') />
				<cfset event.setView('DDADMIN/campusShip') />	
			</cfif>
			
		</cfif>
		
	</cffunction>
	
	<cffunction name="campusShip" returntype="void" output="false">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		
		<cfset rc.currentStep = variables.stepVals.campusShip />
		<cfset event.setLayout('DDadmin') />
		<cfset event.setView('DDADMIN/campusShip') />	
		
		
	</cffunction>
	
	<cffunction name="returnSummary" returntype="void" output="false">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		
		<cfset session.ddadmin.returnRequest.TrackingNumber = form.TrackingNumber />
		
		<cfset rc.currentStep = variables.stepVals.returnSummary />
		<cfset event.setLayout('DDadmin') />
		<cfset event.setView('DDADMIN/returnSummary') />			
	</cffunction>
	
	<cffunction name="printReturnSummary" returntype="void" output="false">
    	<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		
		<cfset event.setLayout('DDadmin_print') />
   		<cfset event.setView(view='DDADMIN/printReturnSummary') />
	</cffunction>		
	
	<cffunction name="reprintReturnSummary" returntype="void" output="false">
    	<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		
		<!--- Load the DDReturn and DDReturnItem records --->
		<cfset var local = {} />
		<cfset local.ddreturn = createObject( "component", "cfc.model.ddreturn" ).init() />
		<cfset local.ddReturn.load(rc.ddreturnid) />
		<cfset local.ddReturnItems_d = local.ddReturn.loadItems("d") />	
		<cfset local.ddReturnItems_a = local.ddReturn.loadItems("a") />	
		
		<!--- Create the session variable --->
		<cfif arrayLen(local.ddReturnItems_d)+arrayLen(local.ddReturnItems_a) >			
			<cfset session.ddadmin.returnRequest = {} />
			<cfset session.ddadmin.returnRequest.trackingNumber = local.ddreturn.getTrackingNumber() />
			<cfset session.ddadmin.returnRequest.Order = createObject( "component", "cfc.model.Order" ).init() />
			<cfset session.ddadmin.returnRequest.Order.load(local.ddReturn.getOrderid())/>
			<cfset session.ddadmin.returnRequest.ItemsReturned = arrayNew(1) />
			<cfset session.ddadmin.returnRequest.ReturnDt = now() />
			
			
			
			<cfloop array="#local.ddReturnItems_d#" index="local.i">
				<cfset local.orderDetail = createObject( "component", "cfc.model.OrderDetail" ).init() />
				<cfset local.orderDetail.load(local.i.getOrderDetailid()) />				
				<cfset local.returnItem = {} /> 
				<cfset local.returnItem.GroupName = local.orderDetail.getGroupName() />
				<cfif local.orderdetail.getOrderDetailType() is 'd'>
					<cfset local.returnItem.orderDetailId = local.orderDetail.getOrderDetailid() />
				</cfif>
				<cfset local.returnItem.Reason = local.i.getReason() />
				<cfset local.returnItem.Comment = local.i.getComment() />
				<cfset arrayAppend(session.ddadmin.returnRequest.ItemsReturned,local.returnItem) />
			</cfloop>
			
			<cfloop array="#local.ddReturnItems_a#" index="local.i">
				<cfset local.orderDetail = createObject( "component", "cfc.model.OrderDetail" ).init() />
				<cfset local.orderDetail.load(local.i.getOrderDetailid()) />				
				<cfset local.returnItem = {} /> 				
				<cfset local.returnItem.GroupName = "" />
				<cfset local.returnItem.orderDetailId = "" />
				<cfif local.orderdetail.getOrderDetailType() is 'a'>
					<cfset local.returnItem.orderDetailId = local.orderDetail.getOrderDetailid() />
				</cfif>
				<cfset local.returnItem.Reason = local.i.getReason() />
				<cfset local.returnItem.Comment = local.i.getComment() />
				<cfset arrayAppend(session.ddadmin.returnRequest.ItemsReturned,local.returnItem) />
			</cfloop>

			<cfset rc.reprint = true />
			<cfset event.setLayout('DDadmin') />
	   		<cfset event.setView('DDADMIN/returnSummary') />	
		<cfelse>
			<cfset rc.errorMsg = "We are unable to retrieve the information required to reprint this return." />
			<cfset event.setLayout('DDadmin') />
			<cfset event.setView('DDADMIN/generalError') />
		</cfif>
	</cffunction>		
		
		
	<cffunction name="returnSubmit" returntype="void" output="false">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		
		<cfset var local = structNew() />
		<cfset var numericDelimeter = "XYZNUMSTRING" />

		<cfset local.ddreturn = createObject( "component", "cfc.model.ddreturn" ).init() />
		<cfset local.ddreturn.setOrderId(session.ddadmin.returnRequest.Order.getOrderId()) />
		
		<cfset local.ddreturn.setAssociateId(application.model.VFD.getEmployeeNumber()) />
		<cfset local.ddreturn.setReturnDate(session.ddadmin.returnRequest.ReturnDt) />	
		<cfset local.ddreturn.setTrackingNumber(session.ddadmin.returnRequest.TrackingNumber) />	
		<cfset local.ddreturn.save() />
		
		<cfset local.appleCare = application.wirebox.getInstance("AppleCare") />
		<cfset local.isAppleCare = local.appleCare.isAppleCareOrder(local.ddreturn.getOrderId()) />
		<cfset local.orderAgeInDays = dateDiff("d",now(),session.ddadmin.returnRequest.Order.getOrderDate()) />
		
		<cfloop array="#session.ddadmin.returnRequest.ItemsReturned#" index="local.r">
			
			<!--- Process the device/line group(s) --->
			<cfloop array="#session.ddadmin.returnRequest.Order.getOrderDetail()#" index="local.od">
				<cfif local.r.GroupName is not "" and local.od.getGroupName() is local.r.groupName and local.od.GetOrderDetailType() is not "a">
					<cfset local.ddreturnItem = createObject( "component", "cfc.model.ddreturnItem" ).init() />
					<cfset local.ddreturnItem.setDDreturnId(local.ddreturn.getddReturnId()) />
					<cfset local.ddreturnItem.setOrderDetailId(local.od.getOrderDetailId()) />
					<cfset local.ddreturnItem.setReason(local.r.reason) />
					<cfset local.ddreturnItem.setComment(local.r.comment) />
					<cfif listfind("d,w",local.od.GetOrderDetailType())>
						<cfset local.od.setRmaStatus(1) />
						<cfset local.od.setRmaReason(local.r.reason) />		
						<cfset local.od.save() />				
					</cfif>
					
					<!--- if Applecare warrant and within 30 days, cancel applecare and store results in orderdetail --->
					<cfif local.od.getOrderDetailType() is 'w' and local.isAppleCare and local.orderAgeInDays le 30>
						<cfset local.cancelResp = deserializeJson(
							local.appleCare.sendCancelOrderRequest(local.ddreturn.getOrderId()),
							<!---getWirelessLineNumber(local.ddreturnItem.getOrderDetailId())--->
							local.od.getGroupNumber()
							) />	
						<!--- We also want to update the json in the orderdetail to indicate cancelled --->
						<cfset local.acjsonobj = {} />
						<cfset local.acjsonobj.op = "Cancel" />
						<cfif isdefined("local.cancelResp.errorResponse") and arrayLen(local.cancelResp.errorResponse) gt 0>
							<cfset local.acjsonobj.op_status = "Cancel Failed" /> 
							<cfset local.acjsonobj.errorCode = local.cancelResp.ErrorResponse[1].ErrorCode />
							<cfset local.acjsonobj.errorMessage = local.cancelResp.ErrorResponse[1].ErrorMessage />
						<cfelse>
							<cfset local.acjsonobj.op_status = "Cancelled" />
							<cfset local.acjsonobj.cancellationDate = local.cancelResp.CancelOrderResponse.CancellationDate />
							<cfset local.acjsonobj.deviceid = local.cancelResp.CancelOrderResponse.DeviceId />
							<cfset local.acjsonobj.agreement = numericDelimeter & local.cancelResp.CancelOrderResponse.AgreementNumber & numericDelimeter />
							<cfset local.acjsonobj.tranid = local.cancelResp.transactionid />
							<cfset local.acjsonobj.po = local.cancelResp.CancelOrderResponse.PurchaseOrderNumber />	
						</cfif>	
						<cfset local.acjson = serializeJson(local.acJsonobj) />
						<cfset local.acjson = replaceNoCase(local.acjson, numericDelimeter, "", "ALL"  ) />
						<cfset local.acjson = replaceNoCase(local.acjson, "@@@", "/", "ALL"  ) />
						<cfset local.od.setMessage(local.acJson) />
						<cfset local.od.save() />								
					</cfif>
					
					<cfset local.ddreturnItem.save() />

				</cfif>
			</cfloop>				
			<!--- Process the accessories --->
			<cfif local.r.orderDetailId is not "">
				<cfset local.od = createObject( "component", "cfc.model.orderDetail" ).init() />
				<cfset local.od.load(local.r.orderDetailId) />
				<cfset local.ddreturnItem = createObject( "component", "cfc.model.ddreturnItem" ).init() />
				<cfset local.ddreturnItem.setDDreturnId(local.ddreturn.getddReturnId()) />
				<cfset local.ddreturnItem.setOrderDetailId(local.od.getOrderDetailId()) />
				<cfset local.ddreturnItem.setReason(local.r.reason) />
				<cfset local.ddreturnItem.setComment(local.r.comment) />
				<cfset local.od.setRmaStatus(1) />
				<cfset local.od.setRmaReason(local.r.reason) />	
				<cfset local.od.save() />
				<cfset local.ddreturnItem.save() />				
			</cfif>

		</cfloop>
		
		<!--- remove the ddadmin structure from the session --->
		<cfset structDelete(session,"ddadmin") />	
		
		<cfset rc.currentStep = variables.stepVals.returnSubmit />
		<cfset event.setLayout('DDadmin') />
		<cfset event.setView('DDADMIN/returnSubmit') />	
		
		
	</cffunction>
	
	<cffunction name="noDevice" returntype="void" output="false">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">

		<cfset rc.currentStep = 0>
		<cfset event.setLayout('DDadmin') />
		<cfset event.setView('DDADMIN/noDevice') />
		
	</cffunction>
	
	<!--- Utility Functions --->
	<cffunction name="getWirelessLineNumber" returntype="integer" output="false">
		<cfargument name="orderDetailId" type="numeric" required="true" />
		
		<cfset var local = {} />
		<cfset local.wirelessLines = session.ddadmin.returnRequest.Order.getWirelessLines() />
		<cfloop index="local.i" from="1" to="#arraylen(local.wirelessLines)#">
			<cfif local.wirelesslines[local.i].getOrderDetailId() is arguments.orderDetailId>
				<cfreturn local.i />
			</cfif>
		</cfloop>
		
		<!--- Not found, so return 0 --->
		<cfreturn 0 />
		
	</cffunction>
	

</cfcomponent>