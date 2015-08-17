<!doctype html>
<cfparam name="action" default="" />
<cfparam name="orderid" default="" />
<cfparam name="forceIMEI" default="" />
<html>
<head>
		<title></title>AppleCare Unit Test Page</title>
	
		<link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.9/themes/base/jquery-ui.css" type="text/css" media="all" /> 
		<script src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.5.min.js" type="text/javascript"></script>
		<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.9/jquery-ui.min.js" type="text/javascript"></script>
		<script>
		$( document ).ready(function() {
			$( "#accordion" ).accordion();
		});	
		</script>	
</head>

<body>

<cfif action is "OrderDetailUpdate">
	<cfset appleCare = application.wirebox.getInstance("AppleCare") />
	<cfset thisOrder = createObject('component', 'cfc.model.order').init() />
	<cfset thisOrder.load(orderid) />
	<cfset wirelessLines = thisOrder.getWirelessLines() />	
	<cfset wOrderDetail = wirelessLines[1].getLineWarranty() />
	<cfset acVerify = appleCare.sendVerifyOrderRequest(orderid,1) />
	<cfoutput>Response=<br/>#acVerify#<br/></cfoutput>
	<cfset acv = deserializeJson(acVerify) />
	<cfdump var="#acv#" />
	<!---<cfset wOrderDetail.setMessage("This is a test 1.") />
	<cfset wOrderDetail.save() />--->	
</cfif>
	
<cfif action is "ShowVerifyOrderRequest">
	<cfset appleCare = application.wirebox.getInstance("AppleCare") />
	<cfset acjson = appleCare.createVerifyOrderJSON(#orderid#,1) />
	<cfoutput>
		Json Request:<br/>
		#acjson#<br/><p/>
	</cfoutput>

	<cfset local = {} />
	<cfset local.appleCare = application.wirebox.getInstance("AppleCare") />
	<cfset local.wOrderDetailMessage = {} />
	<cfset local.wOrderDetailMessage.op = "Verify" />
	<cfset local.acVerify = deserializeJson(local.appleCare.sendVerifyOrderRequest(orderid,1,forceIMEI)) />

	<cfset local.thisOrder = createObject('component', 'cfc.model.order').init() />
	<cfset local.thisOrder.load(orderid) />
	<cfset local.wirelessLines = local.thisOrder.getWirelessLines() />

	
	<cfoutput>
	<B>Returned from the API:<br/></B>	
	#serializeJSON(local.acVerify)#<br/>&nbsp;<br/>
	</cfoutput>
	
	<cfset local.AcGeneralErrors = 0 />
	<cfset local.AcNonDeviceErrors = 0 />
	<cfset local.AcDeviceErrors = 0 />
	
	<cfif isDefined("local.acVerifyMessage")><cfset local.AcGeneralErrors = local.AcGeneralErrors+1 /></cfif>
	<cfif isdefined("local.acVerify.errorResponse") and arrayLen(local.acVerify.errorResponse) gt 0><cfset local.AcNonDeviceErrors = local.AcNonDeviceErrors+1 /></cfif>
	<cfif isdefined("local.acVerify.OrderDetailsResponses.DeviceEligibility.errorResponse") AND arraylen(local.acVerify.OrderDetailsResponses.DeviceEligibility.errorResponse) gt 0><cfset local.AcDeviceErrors = local.AcDeviceErrors+1 /></cfif>
	<cfset local.AcAllErrors = local.AcGeneralErrors + local.AcNonDeviceErrors + local.AcDeviceErrors />
	
							<!--- No error --->
							<cfif local.AcAllErrors is 0>
								<cfset local.wOrderDetailMessage.op_status = "Verified" /> 
								<cfset local.wOrderDetailMessage.TransactionId = local.acVerify.TransactionId />
								<cfset local.wOrderDetailMessage.po = local.acVerify.originalRequest.purchaseOrderNumber />
								<cfset local.wOrderDetailMessage.deviceid = local.acVerify.originalRequest.DeviceRequest[1].deviceid />
								<cfset local.wOrderDetailMessage.referenceid = local.acVerify.originalRequest.referenceid />
								<cfset local.acDone = true />
							<!--- Device specific error --->	
							<cfelseif structKeyExists(local.acVerify,"OrderDetailsResponses") and structKeyExists(local.acVerify.OrderDetailsResponses.DeviceEligibility,"errorResponse") > 
									<cfset local.wOrderDetailMessage.op_status = "Device Failed" /> 
									<cfset local.wOrderDetailMessage.errorCode = local.acVerify.OrderDetailsResponses.DeviceEligibility.ErrorResponse[1].errorCode />
									<cfset local.wOrderDetailMessage.errorMessage = local.acVerify.OrderDetailsResponses.DeviceEligibility.ErrorResponse[1].errorMessage />
									<cfset local.wOrderDetailMessage.deviceid = local.acVerify.originalRequest.DeviceRequest[1].deviceid />
									<cfset local.wOrderDetailMessage.referenceid = local.acVerify.originalRequest.referenceid />
									<cfset local.wOrderDetailMessage.deviceid = local.acVerify.originalRequest.DeviceRequest[1].deviceid />
									<!--- Make sure we don't overflow the column size (currently 255) --->
									<cfset local.jsonLength =  len(serializeJson(local.wOrderDetailMessage))/>
									<cfif local.jsonLength gt 255>
										<!--- trim the length of the error message --->
										<cfset local.wOrderDetailMessage.errorMessage = left(local.wOrderDetailMessage.errorMessage,(len(local.wOrderDetailMessage.errorMessage)-(local.jsonLength-255)) ) />
									</cfif>
									<!--- If we have a bad IMEI we will attempt to fix it (but only once) --->
									<cfset local.acTries = 1 />	
									<cfif local.wOrderDetailMessage.errorCode is "GRX-30020" and local.acTries is 1>
										<cfoutput><br/>CALLING SwapOutBadApplecareIMEI<br/></cfoutput>
										<cfset SwapOutBadApplecareIMEI(local.wirelessLines[1]) />		
										
										<cfset local.acDone = false />							
									<cfelse>
										<cfset local.acDone = true />
									</cfif>
							<!--- Non-Device Error --->	
							<cfelseif isdefined("local.acVerify.errorResponse") and arrayLen(local.acVerify.errorResponse) gt 0>
								<cfset local.wOrderDetailMessage.op_status = "General Error" />
								<cfset local.wOrderDetailMessage.errorCode = local.acverify.errorResponse[1].errorCode />
								<cfset local.wOrderDetailMessage.errorMessage = local.acverify.errorResponse[1].errorMessage />
								<cfset local.acDone = true />
	
							<!--- General error --->
							<cfelse>
								<cfset local.wOrderDetailMessage.op_status = "General Error" /> 
								<cfset local.wOrderDetailMessage.errorCode = local.acVerify.OrderDetailsResponses.DeviceEligibility.ErrorResponse.errorCode />
								<cfset local.wOrderDetailMessage.errorCode = local.acVerify.OrderDetailsResponses.DeviceEligibility.ErrorResponse.errorCode />
								<cfset local.wOrderDetailMessage.errorMessage = local.acVerify.OrderDetailsResponses.DeviceEligibility.ErrorResponse.errorMessage />
								<cfset local.acDone = true />	
							</cfif>
								
<cfoutput>#serializeJson(local.acVerify)#<br/><p/>
JSON for writing to OrderDetail record (len=#len(serializeJson(local.wOrderDetailMessage))#):<br/><p/>
#serializeJson(local.wOrderDetailMessage)#</cfoutput><br/>	
	
</cfif>	

<cfif action is "ShowCancelOrderRequest">
	<cfset appleCare = application.wirebox.getInstance("AppleCare") />
	<cfset acjson = appleCare.createCancelOrderJSON(#orderid#,1) />
	<cfoutput>
		CancelOrder Json Request:<br/>
		#acjson#<br/><p/>
	</cfoutput>
	
	<cfset local.acCreate = deserializeJson(appleCare.sendCancelOrderRequest(orderid,1)) />
	
	<cfoutput>
	<B>Returned from the API:<br/></B>	
	#serializeJSON(local.acCreate)#<br/>&nbsp;<br/>
	</cfoutput>	
</cfif>

<cfif action is "ShowCreateOrderRequest">
	<cfset appleCare = application.wirebox.getInstance("AppleCare") />
	<cfset acjson = appleCare.createVerifyOrderJSON(#orderid#,1) />
	<cfoutput>
		Json Request:<br/>
		#acjson#<br/><p/>
	</cfoutput>

	<cfset local = {} />
	<cfset local.appleCare = application.wirebox.getInstance("AppleCare") />
	<cfset local.wOrderDetailMessage = {} />
	<cfset local.wOrderDetailMessage.op = "Verify" />
	<cfset local.acCreate = deserializeJson(local.appleCare.sendCreateOrderRequest(orderid,1,forceIMEI)) />
	
	<cfoutput>
	<B>Returned from the API:<br/></B>	
	#serializeJSON(local.acCreate)#<br/>&nbsp;<br/>
	</cfoutput>
	
	<!--- No error --->
	<cfif not(isdefined("local.acCreate.Message")) and (arraylen(local.acCreate.ErrorResponse)) is 0 and (isStruct(local.acCreate.OrderDetailsResponses.DeviceEligibility.errorResponse) is false) > 
		<cfset local.wOrderDetailMessage.op_status = "Verified" /> 
		<cfset local.wOrderDetailMessage.TransactionId = local.acCreate.TransactionId />
		<cfset local.wOrderDetailMessage.po = local.acCreate.originalRequest.purchaseOrderNumber />
		<cfset local.wOrderDetailMessage.deviceid = local.acCreate.originalRequest.DeviceRequest[1].deviceid />
		<cfset local.wOrderDetailMessage.referenceid = local.acCreate.originalRequest.referenceid />
		<cfset local.acDone = true />
	<!--- Device specific error --->	
	<cfelseif structKeyExists(local.acCreate,"OrderDetailsResponses") and isStruct(local.acCreate.OrderDetailsResponses.DeviceEligibility.errorResponse) is true> 
			<cfset local.wOrderDetailMessage.op_status = "Device Failed" /> 
			<cfset local.wOrderDetailMessage.errorCode = local.acCreate.OrderDetailsResponses.DeviceEligibility.ErrorResponse.errorCode />
			<cfset local.wOrderDetailMessage.errorMessage = local.acCreate.OrderDetailsResponses.DeviceEligibility.ErrorResponse.errorMessage />
			<cfset local.wOrderDetailMessage.deviceid = local.acCreate.originalRequest.DeviceRequest[1].deviceid />
			<cfset local.wOrderDetailMessage.referenceid = local.acCreate.originalRequest.referenceid />
			<cfset local.wOrderDetailMessage.deviceid = local.acVerify.originalRequest.DeviceRequest[1].deviceid />
			<!--- Make sure we don't overflow the column size (currently 255) --->
			<cfset local.jsonLength =  len(serializeJson(local.wOrderDetailMessage))/>
			<cfif local.jsonLength gt 255>
				<!--- trim the length of the error message --->
				<cfset local.wOrderDetailMessage.errorMessage = left(local.wOrderDetailMessage.errorMessage,(len(local.wOrderDetailMessage.errorMessage)-(local.jsonLength-255)) ) />
			</cfif>
			<cfset local.acDone = true />	
	<!--- General error --->
	<cfelse>
		<cfset local.wOrderDetailMessage.op_status = "General Error" /> 
		<cfset local.wOrderDetailMessage.errorCode = local.acCreate.OrderDetailsResponses.DeviceEligibility.ErrorResponse.errorCode />
		<cfset local.wOrderDetailMessage.errorCode = local.acCreate.OrderDetailsResponses.DeviceEligibility.ErrorResponse.errorCode />
		<cfset local.wOrderDetailMessage.errorMessage = local.acCreate.OrderDetailsResponses.DeviceEligibility.ErrorResponse.errorMessage />
		<cfset local.acDone = true />	
	</cfif>
								
<cfoutput>#serializeJson(local.acCreate)#<br/><p/>
JSON for writing to OrderDetail record (len=#len(serializeJson(local.wOrderDetailMessage))#):<br/><p/>
#serializeJson(local.wOrderDetailMessage)#</cfoutput><br/>	
	
	
	
</cfif>	

<h1>Apple Care Unit Test Page</h1>
<div>
<form name="testform" action="index.cfm" method="post">
OrderId: <input type="text" name="orderId" value="<cfoutput>#orderid#</cfoutput>" /><br/>
<input type="hidden" name="LineNo" value="1"/>
Action: <select id="action" name="action">
<option value="ShowVerifyOrderRequest">Show Verify Order Request</option>
<option value="ShowCreateOrderRequest">Show Create Order Request</option>
<option value="OrderDetailUpdate">Order Detail Update</option>
<option value="ShowCancelOrderRequest">Show Cancel Order Request</option>

</select><br/>
Force IMEI:<br/>
<input type="radio" name="forceImei" value="" <cfif forceImei is "">checked</cfif>>Nothing<br/>
<input type="radio" name="forceImei" value="R" <cfif forceImei is "R">checked</cfif>>R<br/>
<input type="radio" name="forceImei" value="A" <cfif forceImei is "A">checked</cfif>>A<br/>
<input type="submit"><br/>
</form>
</div>
</body>

</html>

	<!---<cffunction name="SwapOutBadApplecareIMEI" output="false" access="public" returntype="query">
		<cfargument name="wirelessLine" type="cfc.model.WirelessLine" required="yes" hint="OrderDetailId of the record with the bad IMEI" />

		<cfset local = {} />
		<cfset local.newIMEI = "" />
			
		<!--- Get the orderDetailId of the device for this line --->
		<cfset local.orderDetailId = arguments.wirelessLine.getOrderDetailId() />
		
		<!--- Call the SwapDevice Sproc --->
		<cfstoredproc procedure="allocation.SwapDevice" datasource="#application.dsn.wirelessAdvocates#" >
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#local.orderDetailId#" />
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="-30002" /> 
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" type="out" variable="local.newIMEI">
		</cfstoredproc>
		
		<!--- Remove the IMEI/SIM from the WirelessLines --->
		<cfset arguments.wirelessLine.setIMEI(local.newIMEI) />
		<cfset arguments.wirelessLine.save() />
		
	</cffunction>--->

