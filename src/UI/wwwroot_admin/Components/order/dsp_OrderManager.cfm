<cfparam name="orderId" default="#request.p.orderId#" />
<cfparam name="selectedTab" default="0" />

<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<cfset PaymentService = application.wirebox.getInstance("PaymentService") />
<cfset local = {} />

<cfif structKeyExists(form, 'doCapture') and not structKeyExists(form, 'process')>
	
	<cftry>
		
		<cfset order = CreateObject( "component", "cfc.model.Order" ).init()>
		<cfset order.load( form.orderId )>

		<cfset PaymentGateway = PaymentService.getPaymentGatewayByID( order.getPaymentGatewayID() ) />
		<cfset Response = PaymentGateway.capturePayment( argumentCollection = form )>
		<cfset Result = Response.getResult()>

		<cfquery datasource="#application.dsn.wirelessadvocates#">
			INSERT INTO service.PaymentGatewayLog
			(
				LoggedDateTime
				, OrderId
				, Type
				, RequestType
				, Data
			)
			VALUES
			(
				GETDATE()
				, <cfqueryparam value="#Result.getSalesOrderNumber()#" cfsqltype="cf_sql_integer" />
				, <cfqueryparam value="Response" cfsqltype="cf_sql_varchar" />
				, <cfqueryparam value="Capture" cfsqltype="cf_sql_varchar" />
				, <cfqueryparam value="#Response.getDetail()#" cfsqltype="cf_sql_longvarchar" />
			)
		</cfquery>
		
		<cfif Response.getResultCode() eq "PG001">
			
			<cfquery name="qry_getPaymentMethod" datasource="#application.dsn.wirelessadvocates#">
				SELECT PaymentMethodId FROM salesorder.PaymentMethod 
				WHERE [Name] = <cfqueryparam value="#Result.getCCType()#" cfsqltype="cf_sql_varchar" />
			</cfquery>
			
			<cfif qry_getPaymentMethod.recordCount>
				<cfset payMethodId = qry_getPaymentMethod.paymentMethodId />
			<cfelse>
				<cfset payMethodId = 1 />
			</cfif>
			
			<cfquery name="qry_insertPayment" datasource="#application.dsn.wirelessadvocates#">
				INSERT INTO salesorder.Payment (
					OrderId,
					PaymentAmount,
					PaymentDate,
					CreditCardExpDate,
					CreditCardAuthorizationNumber,
					PaymentMethodId,
					BankCode,
					AuthorizationOrigId,
					RefundOrigId,
					ChargebackOrigId,
					PaymentToken
				)
				VALUES
				(
					<cfqueryparam value="#Result.getSalesOrderNumber()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#Result.getTotalAmount()#" cfsqltype="cf_sql_money" />,
					GETDATE(),
					NULL,
					<cfqueryparam value="#Result.getReceiptNumber()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#variables.payMethodId#" cfsqltype="cf_sql_integer" />,
					'OMT',
					<cfqueryparam value="#Result.getGUID()#" cfsqltype="cf_sql_varchar" />,
					NULL,
					NULL,
					( 	
						SELECT TOP 1 PaymentToken 
						FROM salesorder.Payment 
						WHERE OrderId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Result.getSalesOrderNumber()#" />
							AND PaymentToken IS NOT NULL
						ORDER BY PaymentId DESC
					)
				)
			</cfquery>
			
			<cfscript>
				// Commit Tax Transaction
				args = {
					CommitDate 			=	order.getOrderDate()
					,InvoiceNumber 		=	request.config.InvoiceNumberPrefix & order.getOrderId()
					,PriorTransactionId	=	order.getSalesTaxTransactionId()
				};

				taxCalculator = application.wirebox.getInstance("TaxCalculator");
				taxCalculator.commitTaxTransaction(argumentCollection = variables.args);

				order.setIsSalesTaxTransactionCommited(true);
				
				order.setStatus( 2 ); //Update status to submitted
				order.setPaymentCapturedById( session.adminUser.adminUserId ); //Log user that captured payment
				order.save();
			
				application.model.actionCaptures.insertActionCapture(adminUserId = session.adminUser.adminUserId, actionId = 2, orderId = Result.getSalesOrderNumber(), message = '');
	
				// Add order note
				local.ticketStruct = StructNew();
				local.ticketStruct.NoteBody = 'Payment Capture Sucessful - Verbiage: #Result.getVerbiage()#';
				local.ticketStruct.OrderNoteSubjectId = 52;
				local.ticketStruct.OrderId = Result.getSalesOrderNumber();
				local.ticketStruct.CreatedById = session.adminuser.adminuserid;
				local.void = application.model.TicketService.addOrderNote(argumentCollection = local.ticketStruct);
			</cfscript>
			
			<div class="message">
				Payment has been captured
			</div>
			
		<cfelse>
			
			<cfquery datasource="#application.dsn.wirelessadvocates#">
				INSERT INTO service.PaymentGatewayLog
				(
					LoggedDateTime
					, OrderId
					, Type
					, RequestType
					, Data
				)
				VALUES
				(
					GETDATE()
					, <cfqueryparam value="#form.orderID#" cfsqltype="cf_sql_integer" />
					, <cfqueryparam value="Response" cfsqltype="cf_sql_varchar" />
					, <cfqueryparam value="Capture" cfsqltype="cf_sql_varchar" />
					, <cfqueryparam value="#Response.getMessage()# - #Response.getDetail()#" cfsqltype="cf_sql_longvarchar" />
				)
			</cfquery>
						
			<!--- Add order note --->
			<cfset local.ticketStruct = StructNew()>
			<cfset local.ticketStruct.NoteBody = 'Payment Response: #Response.getMessage()#' />
			<cfset local.ticketStruct.OrderNoteSubjectId = 52 />
			<cfset local.ticketStruct.OrderId = form.orderId />
			<cfset local.ticketStruct.CreatedById = session.adminuser.adminuserid />
			<cfset local.void = application.model.TicketService.addOrderNote(argumentCollection = local.ticketStruct) />			
			
			<div class="message">
				Payment Response: <cfoutput>#Response.getMessage()#</cfoutput>
			</div>
		</cfif>	
	
		<cfcatch>
			<!--- Add order note --->
			<cfset local.ticketStruct = StructNew()>
			<cfset local.ticketStruct.NoteBody = 'Payment capture unsuccessful: #cfcatch.message# - #cfcatch.detail#' />
			<cfset local.ticketStruct.OrderNoteSubjectId = 52 />
			<cfset local.ticketStruct.OrderId = form.orderId />
			<cfset local.ticketStruct.CreatedById = session.adminuser.adminuserid />
			<cfset local.void = application.model.TicketService.addOrderNote(argumentCollection = local.ticketStruct) />
			
			<div class="message-sticky">
				<cfoutput>Payment capture unsuccessful: #cfcatch.message# - #cfcatch.detail#</cfoutput>
			</div>
		</cfcatch>

	</cftry>

	<cfset selectedTab = 2 />
<cfelseif structKeyExists(url, 'remove')>
	<cftry>
		<cfquery name="qry_removeService" datasource="#application.dsn.wirelessAdvocates#">
			DELETE
			FROM	salesorder.LineService
			WHERE	OrderDetailId	=	<cfqueryparam value="#url.remove#" cfsqltype="cf_sql_integer" />;
			DELETE
			FROM	salesorder.OrderDetail
			WHERE	OrderDetailId	=	<cfqueryparam value="#url.remove#" cfsqltype="cf_sql_integer" />
		</cfquery>
		<cfcatch type="any">
			<cfdump var="#cfcatch#">
			<cfabort />
		</cfcatch>
	</cftry>
	<cfset selectedTab = 2 />
	<div class="message">
		Line service has been successfully removed
	</div>
<cfelseif structKeyExists( form, "activationDetailSubmit" )>
	<!--- Update Line Services --->
	<cfloop collection="#form#" item="formField">
		<cfif listFirst(formField, '_') is 'service'>
			<cfset orderDetailId = listLast(formField, '_') />
			<cfset productId = form[formField] />
			<cfquery name="qry_updateOrderDetail" datasource="#application.dsn.wirelessAdvocates#">
				UPDATE	salesorder.OrderDetail
				SET		ProductId		=	<cfqueryparam value="#variables.productId#" cfsqltype="cf_sql_integer" />,
						GersSku			=	<cfqueryparam value="#form['serviceGersSku_' & variables.orderDetailId]#" cfsqltype="cf_sql_varchar" />,
						ProductTitle	=	<cfqueryparam value="#form['serviceTitle2_' & variables.orderDetailId]#" cfsqltype="cf_sql_varchar" maxlength="500" />
				WHERE	OrderDetailId	=	<cfqueryparam value="#variables.orderDetailId#" cfsqltype="cf_sql_integer" />
			</cfquery>
			<!--- TODO: Update Line Service --->
		</cfif>
		<cfif listFirst(formField, '_') is 'addService'>
			<!--- Add Service --->
		</cfif>
	</cfloop>
	<cftry>
		<cfscript>
		selectedTab = 2;

		wirelessLine = CreateObject( "component", "cfc.model.WirelessLine" ).init();
		wirelessLine.load( request.p.wirelessLineId );
		wirelessLine.setCurrentCarrier( request.p.currentCarrier );
		wirelessLine.setNewMdn( "" );
		wirelessLine.setCurrentMdn( request.p.currentMdn );
		wirelessLine.setActivationStatus( request.p.activationStatus );

		if ( StructKeyExists(form, "prepaidAccountNumber") )
		{
			wirelessLine.setPrepaidAccountNumber( request.p.prepaidAccountNumber );
		}

		wirelessLine.save();

		wirelessAccount = CreateObject( "component", "cfc.model.WirelessAccount" ).init();
		wirelessAccount.load( request.p.wirelessAccountId );
		wirelessAccount.setCurrentAcctNumber( request.p.currentAcctNumber );
		//Sets status to active if all wireless lines are activated successfully
		wirelessAccount.setActivationStatusByLineStatus(session.adminuser.adminuserid );
		wirelessAccount.save();
	</cfscript>
		<cfcatch type="any">
			<!--- <cfdump var="#cfcatch#"><cfabort> --->
		</cfcatch>
	</cftry>
	
	<!--- SMS Lines that opt In send sms message --->
<!---	<cfset order = CreateObject( "component", "cfc.model.Order" ).init()>
	<cfset order.load( form.orderId )>
	
	<cfscript>
		if (order.getSmsOptIn() and application.wirebox.containsInstance("CampaignService")) {
			campaignService = application.wirebox.getInstance("CampaignService");
			wl = wirelessLine;
			smsSvc = getSmsMessageService();
			acType = order.getActivationType();
			if (acType == 'N') {
				smsDateOffset = 1;
			} else {
				smsDateOffset = 5;
			}
			smsDate = dateAdd('d',smsDateOffset, now());
			campaign = campaignService.getCampaignById(order.getCampaignid());
			smsMDN = wl.getCurrentMDN();
			if (smsMDN is "") {
				smsMDN = wl.getNewMDN();
			}
			if (smsMDN is "") {
				SMSResultCode = -1;
				SMSResult = "MDN Missing";
			}

			smsMsg = createObject('component','cfc.model.system.sms.SmsMessage').init( 	
									"0"												// message id
								   	,smsMDN 										// phone number
								   	,order.getCarrierId()							// carrier id
									,campaign.getSmsMessage()						// message
									,smsDate										// runDate
									);
									
			if (isdefined("SMSResult") and len(SMSResult)) {
				smsMsg.setResultCode(SMSResultCode);
				smsMsg.setResult(SMSResult);
			}
									
			smsMsg.setOrderDetailId(wl.getOrderDetailId());						
			smsSvc.createNewSmsMessage(smsMsg);						
		}
	</cfscript> 	--->

	<div class="message-sticky">
		Line has been successfully updated
	</div>
</cfif>
<!--- Convert this order to a PCR ---->
<cfif structKeyExists(form, 'pcrSubmit')>
	<cfset local.ticketStruct = StructNew()>
	<cfset local.ticketStruct.NoteBody = 'Order specified as PCR'>
	<cfset local.ticketStruct.OrderNoteSubjectId = 50>
	<cfset local.ticketStruct.OrderId = form.orderId>
	<cfset local.ticketStruct.CreatedById = session.adminuser.adminuserid>
	<cfset local.void = application.model.TicketService.addOrderNote(argumentCollection = local.ticketStruct) />
	<cfquery datasource="#application.dsn.wirelessAdvocates#">
    UPDATE salesorder.[order]
	SET pcrDate = GETDATE()
	WHERE orderid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.orderId#">
	AND pcrDate is null
    </cfquery>
	<cfset selectedTab = 2 />
</cfif>

<cfif structKeyExists(form, 'verifyAppleCareSubmit')>
	<cfset local.appleCare = application.wirebox.getInstance("AppleCare") />
	<cfset local.order = CreateObject( "component", "cfc.model.Order" ).init()>
	<cfset local.order.load( request.p.orderId )>
	<cfset local.wirelessLines = local.order.getWirelesslines() />
	<!--- loop thru po's and attach each line --->
	<cfloop list="#request.p.polist#" index="local.po">
		<cfset local.verifyLine = listgetat(local.po,3,"-") />
		<cfif local.verifyLine is not "">			
			<cfset local.wOrderDetail = local.wirelesslines[local.verifyLine].getLineWarranty() />
			<cfset local.acVerifyResponse = deserializeJson(local.appleCare.sendVerifyOrderRequest(form.orderid, local.verifyLine)) />
			
			<!--- Figure out which errors we have --->
			<cfset local.AcGeneralErrors = 0 />
			<cfset local.AcNonDeviceErrors = 0 />
			<cfset local.AcDeviceErrors = 0 />							
			<cfif isDefined("local.acVerifyResponse.Message")><cfset local.AcGeneralErrors = local.AcGeneralErrors+1 /></cfif>
			<cfif isdefined("local.acVerifyResponse.errorResponse") and arrayLen(local.acVerifyResponse.errorResponse) gt 0><cfset local.AcNonDeviceErrors = local.AcNonDeviceErrors+1 /></cfif>
			<cfif isdefined("local.acVerifyResponse.OrderDetailsResponses.DeviceEligibility.errorResponse") AND arraylen(local.acVerifyResponse.OrderDetailsResponses.DeviceEligibility.errorResponse) gt 0><cfset local.AcDeviceErrors = local.AcDeviceErrors+1 /></cfif>
			<cfset local.AcAllErrors = local.AcGeneralErrors + local.AcNonDeviceErrors + local.AcDeviceErrors />
			<cfset local.wOrderDetailMessage = {} />
			<cfset local.wOrderDetailMessage.op = "Verify" />
						
			<cfif local.AcAllErrors is 0>
			<!--- Update the order detail record with Verification info --->			
				<cfset local.wOrderDetailMessage.op_status = "Verified" /> 
				<cfset local.wOrderDetailMessage.TransactionId = local.acVerifyResponse.TransactionId />
				<cfset local.wOrderDetailMessage.po = local.acVerifyResponse.originalRequest.purchaseOrderNumber />
				<cfset local.wOrderDetailMessage.deviceid = local.acVerifyResponse.originalRequest.DeviceRequest[1].deviceid />
				<cfset local.wOrderDetailMessage.referenceid = local.acVerifyResponse.originalRequest.referenceid />
				<cfset local.wOrderDetail.setMessage(serializeJson(local.wOrderDetailMessage)) />
				<cfset local.wOrderDetail.save() />
				<div class="message-sticky">
					<cfoutput>AppleCare successfully verified line #local.verifyLine#.</cfoutput>
				</div>	
			<!--- Device specific errors --->	
			<cfelseif local.AcDeviceErrors gt 0 > 
				<cfset local.wOrderDetailMessage.op_status = "Device Failed" /> 
				<cfset local.wOrderDetailMessage.errorCode = local.acVerifyResponse.OrderDetailsResponses.DeviceEligibility.ErrorResponse[1].errorCode />
				<cfset local.wOrderDetailMessage.errorMessage = local.acVerifyResponse.OrderDetailsResponses.DeviceEligibility.ErrorResponse[1].errorMessage />
				<cfset local.wOrderDetailMessage.deviceid = local.acVerifyResponse.originalRequest.DeviceRequest[1].deviceid />
				<cfset local.wOrderDetailMessage.referenceid = local.acVerifyResponse.originalRequest.referenceid />
				<cfset local.wOrderDetailMessage.deviceid = local.acVerifyResponse.originalRequest.DeviceRequest[1].deviceid />
				<!--- Make sure we don't overflow the column size (currently 255) --->
				<cfset local.jsonLength =  len(serializeJson(local.wOrderDetailMessage))/>
				<cfif local.jsonLength gt 255>
					<!--- trim the length of the error message --->
					<cfset local.wOrderDetailMessage.errorMessage = left(local.wOrderDetailMessage.errorMessage,(len(local.wOrderDetailMessage.errorMessage)-(local.jsonLength-255)) ) />
				</cfif>
				<div class="message-sticky">
					<cfoutput>AppleCare verify device error: #local.wOrderDetailMessage.errorMessage# (#local.verifyLine#).</cfoutput>
				</div>	

			<!--- Non-Device Errors --->	
			<cfelseif local.AcNonDeviceErrors gt 0>
				<cfset local.wOrderDetailMessage.op_status = "General Error" />
				<cfset local.wOrderDetailMessage.errorCode = local.acVerifyResponse.errorResponse[1].errorCode />
				<cfset local.wOrderDetailMessage.errorMessage = local.acVerifyResponse.errorResponse[1].errorMessage />
				<div class="message-sticky">
					<cfoutput>AppleCare verify non-device error: #local.wOrderDetailMessage.errorMessage# (line #local.verifyLine#).</cfoutput>
				</div>	
			<!--- General errors --->
			<cfelse>
				<cfset local.wOrderDetailMessage.op_status = "General Error" /> 
				<cfset local.wOrderDetailMessage.errorCode = local.acVerifyResponse.OrderDetailsResponses.DeviceEligibility.ErrorResponse.errorCode />
				<cfset local.wOrderDetailMessage.errorCode = local.acVerifyResponse.OrderDetailsResponses.DeviceEligibility.ErrorResponse.errorCode />
				<cfset local.wOrderDetailMessage.errorMessage = local.acVerifyResponse.OrderDetailsResponses.DeviceEligibility.ErrorResponse.errorMessage />
				<div class="message-sticky">
					<cfoutput>AppleCare verify general error: #local.wOrderDetailMessage.errorMessage# (line #local.verifyLine#).</cfoutput>
				</div>	
			</cfif>				
			<!--- Write the results to the order detail message column --->
			<cfset local.wOrderDetail.setMessage(serializeJson(local.wOrderDetailMessage)) />
			<cfset local.wOrderDetail.save() />
		</cfif>	
	</cfloop>	
	
</cfif>

<cfif structKeyExists(form, 'attachAppleCareSubmit')>
	<cfset local.appleCare = application.wirebox.getInstance("AppleCare") />
	<cfset local.order = CreateObject( "component", "cfc.model.Order" ).init()>
	<cfset local.order.load( request.p.orderId )>
	<cfset local.wirelessLines = local.order.getWirelesslines() />
	<!--- loop thru po's and attach each line --->
	<cfloop list="#request.p.polist#" index="local.po">
		<cfset local.attachLine = listgetat(local.po,3,"-") />
		<cfif local.attachLine is not "">			
			<cfset local.wOrderDetail = local.wirelesslines[local.attachLine].getLineWarranty() />
			<cfset local.acAttachResponse = deserializeJson(local.appleCare.sendCreateOrderRequest(form.orderid, local.attachLine)) />
			<cfif structKeyExists(local.acattachResponse,"ErrorResponse") and arrayLen(local.acattachResponse.ErrorResponse) is 0>
			<!--- Create the xml string to write to the orderDetailLog --->			
			<cfset local.xmlStr ='<?xml version="1.0" encoding="UTF-8"?>' &
				'<applecareattach>' &
					'<transactionid>#local.acattachResponse.transactionid#</transactionid>' &
					'<DeviceEligibility>' &
						'<DeviceDateOfPurchase>#local.acattachResponse.OrderDetailsResponses.DeviceEligibility.DeviceDateOfPurchase#</DeviceDateOfPurchase>' &
						'<SerialNumber>#local.acattachResponse.OrderDetailsResponses.DeviceEligibility.SerialNumber#</SerialNumber>' &
					'</DeviceEligibility>' &
					'<OrderConfirmation>' &
						'<AppleCareSalesDate>#local.acattachResponse.OrderDetailsResponses.OrderConfirmation.AppleCareSalesDate#</AppleCareSalesDate>' &
						'<partNumber>#local.acattachResponse.OrderDetailsResponses.OrderConfirmation.PartNumber#</partNumber>' &
						'<AgreementNumber>#local.acattachResponse.OrderDetailsResponses.OrderConfirmation.AgreementNumber#</AgreementNumber>' &
						'<PurchaseOrderNumber>#local.acattachResponse.OrderDetailsResponses.OrderConfirmation.PurchaseOrderNumber#</PurchaseOrderNumber>' &
						'</OrderConfirmation>' &
				'</applecareattach>' />

				<cfset local.orderDetailLog = CreateObject( "component", "cfc.model.OrderDetailLog" ).init(
					 orderDetailId = local.wOrderDetail.getOrderDetailId()
				   , type = "AppleCare Attach"
				   , log = local.xmlStr
				)>
				<cfset local.orderDetailLog.save() />
				<div class="message-sticky">
					<cfoutput>AppleCare successfully attached line #local.attachLine#.</cfoutput>
				</div>	
				
				<!--- We also want to update the json in the orderdetail to indicate attached --->
				<cfset local.acjson = {} />
				<cfset local.acjson.op = "Create" />
				<cfset local.acjson.op_status = "Created" />
				<cfset local.acjson.acdate = "#local.acattachResponse.OrderDetailsResponses.OrderConfirmation.AppleCareSalesDate#" />
				<cfset local.acjson.IMEI = "#local.acattachResponse.OrderDetailsResponses.DeviceEligibility.SerialNumber#" />
				<cfset local.acjson.agreement = "#local.acattachResponse.OrderDetailsResponses.OrderConfirmation.AgreementNumber#" />
				<cfset local.acjson.tranid = "#local.acattachResponse.transactionid#" />
				<cfset local.acjson.po = "#local.acattachResponse.OrderDetailsResponses.OrderConfirmation.PurchaseOrderNumber#" />			
				<cfset local.wOrderDetail.setMessage(serializeJson(local.acJson)) />
				<cfset local.wOrderDetail.save() />

			<cfelse>
				<!--- Attach error handling here --->
			</cfif>	
		</cfif>	
	</cfloop>	
	
</cfif>

<cfif structKeyExists(form, 'btnAddTicket')>
	<cfif structKeyExists(form, 'btnAddTicketUpdate')>
		<cfset ticketId = application.model.TicketService.addOrderNote(argumentCollection = form) />
		<div class="message">
			The note has been added successfully.
		</div>
		<cfset selectedTab = 3 />
	<cfelse>
		<cfset addTicketView = trim(application.view.TicketService.getAddTicketView()) />
		<cfoutput>
			#trim(variables.addTicketView)#
		</cfoutput>
		<cfabort />
	</cfif>
</cfif>
<cfif structKeyExists(url, 'deleteNoteSubmit')>
	<cfscript>
		application.model.TicketService.deleteOrderNote( OrderNoteId = url.OrderNoteId );

		selectedTab = 3;
	</cfscript>
	<div class="message">
		The note has been successfully deleted.
	</div>
</cfif>

<cfif structKeyExists( form, "cancelOrderSubmit" )>
	<cfscript>
		errors = [];
		selectedTab = 0;

		order = CreateObject( "component", "cfc.model.Order" ).init();
		order.load( orderId );
		originalStatus = order.getStatus();

		order.cancel( request.p.cancelationReason );
		order.setStatus( 4 ); //Set status to 'Cancelled'

		args = {
			order = order
			, refundDate = Now()
		};

		if ( request.config.CommitTaxTransaction AND order.getIsSalesTaxTransactionCommited() )
		{
			try
			{
				taxResponse = application.model.TaxCalculation.refundTaxTransaction( argumentCollection = args );
				order.setSalesTaxRefundTransactionId( taxResponse.getRefundResponse().getTransactionId() );
			}
			catch ( any e )
			{
				ArrayAppend( errors, "An error occured on Tax Service refund." );
			}
		}

		local.appleCare = application.wirebox.getInstance("AppleCare");
		local.numericDelimeter = "XYZNUMSTRING";

		if (local.appleCare.isAppleCareOrder(order.getOrderId())) {
			local.wirelessLines = order.getWirelessLines();
			local.appleCareMessages = local.appleCare.getMessages(order.getOrderId());
			// Loop thru the applecare messages and cancel those that were attached 
			for (local.i = 1; i lte arraylen(local.appleCareMessages); i=i+1) {
				if (structKeyExists(local.appleCareMessages[i],"op_status") and local.appleCareMessages[i].op_status is "Created") {
					local.wOrderDetail = local.wirelesslines[i].getLineWarranty();
					local.cancelResp = deserializeJson(local.appleCare.sendCancelOrderRequest(order.getOrderId(),i));	
					
				// We also want to update the json in the orderdetail to indicate cancelled
				local.acjsonobj = {};
				local.acjsonobj.op = "Cancel";
				local.acjsonobj.op_status = "Cancelled";
				local.acjsonobj.cancellationDate = local.cancelResp.CancelOrderResponse.CancellationDate;
				local.acjsonobj.deviceid = local.cancelResp.CancelOrderResponse.DeviceId;
				local.acjsonobj.agreement = local.numericDelimeter & local.cancelResp.CancelOrderResponse.AgreementNumber & local.numericDelimeter;
				local.acjsonobj.tranid = local.cancelResp.transactionid;
				local.acjsonobj.po = local.cancelResp.CancelOrderResponse.PurchaseOrderNumber;	
				local.acjson = serializeJson(local.acJsonobj);
				local.acjson = replaceNoCase(local.acjson, local.numericDelimeter, "", "ALL"  );
				local.acjson = replaceNoCase(local.acjson, "@@@", "/", "ALL"  );
				local.wOrderDetail.setMessage(local.acJson);
				local.wOrderDetail.save();									
				}
			} 

		}

		order.save( session.AdminUser.AdminUserId );

	</cfscript>
	<cfset result = "Success" />
			 
	<cftry>
		<!--- Send Internal Order Cancellation Email --->
		<cfset request.p.do = "orderCancellationAlert" />
		<cfset orderId = order.getOrderId() />
		<cfset adminEmail = session.Adminuser.UserName />
		<cfset cancellationReason = request.p.cancelationReason />

		<cfinclude template = "/emailTemplate/index.cfm" />
		<cfcatch type="any">
			<cfthrow message="#cfcatch.message#" />
			<cfset result = cfcatch.message />
		</cfcatch>
	</cftry>
	
	<cfscript>
		//result = application.model.EmailManager.sendEmailFromTemplate( argumentCollection = args );

		if ( result NEQ 'Success' )
		{
			ArrayAppend( errors, "Email to stake holders was not sent due to error: " & result );
		}
		</cfscript>

		<!--- //Send cancellation email to customer --->
		<cfif ( order.getActivationType() neq 'E' OR (order.getActivationType() eq 'E' && originalStatus gt 1) )>
			<cfset result = "Success" />
					 
			<cftry>
				<!--- Send Customer Order Cancellation Email --->
				<cfset request.p.do = "orderCancellation" />
				<cfset orderId = order.getOrderId() />
				<cfinclude template = "/emailTemplate/index.cfm" />
				<cfcatch type="any">
					<cfthrow message="#cfcatch.message#" />
					<cfset result = cfcatch.message />
				</cfcatch>
			</cftry>
			
			<!--- //	result = application.model.EmailManager.sendEmailFromTemplate( argumentCollection = args ); --->
	
			<cfif result NEQ 'Success'>
				ArrayAppend( errors, "Email to customer was not sent due to error: " & result );			}
			</cfif>
		</cfif>
	<div class="message">
		Order has been cancelled and reserve stock has been released.
	</div>
	<cfif ArrayLen( errors )>
		<cfloop array="#errors#" index="error">
			<div class="errormessage">
				<cfoutput>
					#error#
				</cfoutput>
			</div>
		</cfloop>
	</cfif>
</cfif>
<cfif structKeyExists( form, "orderShippingSubmit" )>
	<cfscript>
		selectedTab = 0;
		order = CreateObject( "component", "cfc.model.Order" ).init();
		order.load( orderId );

		addressGuid = order.getShipAddress().getAddressGuid();

		shippingAddress = CreateObject( "component", "cfc.model.OrderAddress" ).init();
		shippingAddress.load( addressGuid );
		
		// save the orig military base so if it changed we can up the billing address base as well to keep them in sync
		orig_militaryBase = shippingAddress.getMilitaryBase();

		shippingAddress.setFirstName( request.p.firstName );
		shippingAddress.setLastName( request.p.lastName );
		shippingAddress.setCompany( request.p.company );
		shippingAddress.setAddress1( request.p.address1 );
		shippingAddress.setAddress2( request.p.address2 );
		shippingAddress.setCity( request.p.city );
		shippingAddress.setZip( request.p.zip );
		shippingAddress.setDaytimePhone( request.p.daytimePhone );
		shippingAddress.setEveningPhone( request.p.eveningPhone );
		shippingAddress.setMilitaryBase( request.p.MilitaryBase );
		shippingAddress.save();
		
		// if military base has changed keep billing and shipping in sync
		if (orig_militaryBase neq request.p.MilitaryBase) {
			billAddressGuid = order.getBillAddress().getAddressGuid();
			billAddress = CreateObject( "component", "cfc.model.OrderAddress" ).init();
			billAddress.load( billAddressGuid );
			billAddress.setMilitaryBase( request.p.MilitaryBase );
			billAddress.save();
		}
		
		
	</cfscript>
	<div class="message">
		Shipping information has been successfully updated
	</div>
</cfif>
<cfif structKeyExists( form, "rmaFormAction" )>
		<cfset selectedTab = 4 />
		<cfset message = '' />
		<cfset errors = [] />
		<cfset order = CreateObject( "component", "cfc.model.Order" ).init() />
		<cfset order.load( orderId ) />

		<cfif form.rmaFormAction eq 'rmaSubmit'>
			<cfset lines = order.getWirelessLines() />
			<cfset otherItems = order.getOtherItems() />
			<cfset rmaItems = [] />

			<!--- //Add lines items to RMA list --->
 			<cfloop array="#lines#" index="theLine">
				<cfset ArrayAppend( rmaItems, theLine.getLineDevice() ) />
				<cfset accessories = theLine.getLineAccessories() />
				<cfif theLine.getLineWarranty().getGroupNumber() is not 0>
					<cfset ArrayAppend( rmaItems, theLine.getLineWarranty() ) />
				</cfif>
				
				
				<cfloop array="#accessories#" index="theAccessory">
					<cfset ArrayAppend( rmaItems, theAccessory ) />
				</cfloop>
				
				
			</cfloop>

			<!--- //Add other items to RMA list --->
			<cfloop array="#otherItems#" index="theItem">
				<cfset ArrayAppend( rmaItems, theItem ) />
			</cfloop>

			<!--- //Update RMA items --->
			<cfloop array="#rmaItems#" index="rmaItem">
				<cfif rmaItem.getGroupNumber() is not 0>
					<cfset rmaItem.setRmaNumber( FORM[ "rmaNumber_#rmaItem.getOrderDetailId()#" ] ) />
					<cfset rmaItem.setRmaStatus( FORM[ "rmaStatus_#rmaItem.getOrderDetailId()#" ] ) />
					<cfset rmaItem.setRmaReason( FORM[ "rmaReason_#rmaItem.getOrderDetailId()#" ] ) />
					<cfset rmaItem.save() />
				</cfif>
			</cfloop>

			<cfset message = 'RMA information has been successfully updated' />
		
		<cfelseif form.rmaFormAction eq 'returnAuthorizationSubmit'>
			<cfset returnItems = ListToArray( form.returnAuthorizationItem ) />
			
			<cfloop array="#returnItems#" index="theReturnItem">
				<cfset result = "Success" />
				 
				<cftry>
					<!--- Send Return Authorization Form Email --->
					<cfset request.p.do = "returnAuthorization" />
					<cfset sendBcc = session.adminUser.username />
					<cfset orderDetailId = theReturnItem />
					<cfinclude template = "/emailTemplate/index.cfm" />
					<cfcatch type="any">
						<cfthrow message="#cfcatch.message#" />
						<cfset result = cfcatch.message />
					</cfcatch>
				</cftry>
				
				<cfif result NEQ 'Success'>
					<cfset ArrayAppend( errors, "Email to customer was not sent due to error: " & result ) />
				</cfif>
			</cfloop>

			<cfset message = 'Return authorization forms has been sent to the customer' />
		</cfif>
	<cfif ArrayLen( errors )>
		<cfloop array="#errors#" index="error">
			<div class="errormessage">
				<cfoutput>
					#error#
				</cfoutput>
			</div>
		</cfloop>
	<cfelse>
		<div class="message">
			<cfoutput>
				#message#
			</cfoutput>
		</div>
	</cfif>
</cfif>

<cfif structKeyExists( form, "exchangeSubmit" )>
	
	<cfset orderId = form.orderId />
	<cfset exchangeLineList = form.exchangeLineItems />
	<cfset exchangeProductList = form.exchangeDevices />
	<cfset exchangeProductPriceList = form.exchangePrices>
	<cfset exchangeCogsPriceList = form.exchangeCogsPrices />
	<cfset originalCogsPriceList = form.originalCogsPrices />
	<cfset exchangedNetPriceList = form.exchangedNetPrices />
	<cfset originalPriceList = form.originalPrices />
	<cfset sortCode = form.sortCode />
	<cfset needBillingMilitaryBase = false />
	<cfset needShipMilitaryBase = false />
	
	<!--- build the Exchange Order --->
	<cfscript>
		selectedTab = 6;

		originalOrder = createobject('component','cfc.model.Order').init();
		originalOrder.load(orderId);

		// create exchange order
		newOrder = createobject('component','cfc.model.Order').init();
		
		// create new shipping and billing addresses based on original order
		newOrder.getBillAddress().populateFromOrderAddress(originalOrder.getBillAddress());	
		newOrder.getShipAddress().populateFromOrderAddress(originalOrder.getShipAddress());	

		// Check if the military base is current and update it if necessary
		if ((newOrder.getBillAddress().getMilitaryBase() != "") and (!newOrder.getBillAddress().isCurrentMilitaryBase())) {
			newOrder.getBillAddress().setMilitaryBase(newOrder.getBillAddress().getMilitaryBase());	
		}
		if ((newOrder.getShipAddress().getMilitaryBase() != "") and (!newOrder.getShipAddress().isCurrentMilitaryBase())) {
			newOrder.getShipAddress().setMilitaryBase(newOrder.getShipAddress().getMilitaryBase());	
		}

		newOrder.setCarrierId( originalOrder.getCarrierId() );
		newOrder.setStatus(1); //still need to make a payment on the order.
		newOrder.setPaymentGatewayId( originalOrder.getPaymentGatewayId() );
		newOrder.setActivationType( 'E' ); // E = Exchange
		newOrder.setUserId( originalOrder.getUserId() );
		newOrder.setIPAddress( CGI.HTTP_HOST );
		shipMethod = createobject('component','cfc.model.ShipMethod').init();
		shipMethod.load( 3 );
		newOrder.setShipMethod( shipMethod );
		newOrder.setParentOrderId( originalOrder.getOrderId() );

		//set the wireless account details.
		newOrder.getWirelessAccount().setFirstName(originalOrder.getWirelessAccount().getFirstName());
		newOrder.getWirelessAccount().setInitial(originalOrder.getWirelessAccount().getInitial());
		newOrder.getWirelessAccount().setLastName(originalOrder.getWirelessAccount().getLastName());
		newOrder.setSortCode( UCASE(sortCode) );
		newOrder.save(); // save it so an orderid is assigned to it

		//build the wirelesslines
		exchangeLines = listToArray( exchangeLineList );
		exchangeProducts = listToArray( exchangeProductList );
		exchangeProductPrices = listToArray( exchangeProductPriceList );
		exchangeCogsPrices = listToArray( exchangeCogsPriceList );
		originalCogsPrices = listToArray( originalCogsPriceList );
		originalProductPrices = listToArray( originalPriceList );
		exchangedNetPrices = listToArray( exchangedNetPriceList );
		
		taxItems = ArrayNew(1);
		deviceCount = 0;
		otherItems = ArrayNew(1);

		lastLineCreated = ""; // break value for determining when to create a new wirelessLine
		
		for(i = 1; i <= arrayLen(exchangeLines); i++)
		{	
			// create a copy of the original orderDetail
			origOrderDetail = createobject('component','cfc.model.OrderDetail').init();
			origOrderDetail.load(exchangeLines[i]);

			if (lastLineCreated is not origOrderDetail.getGroupNumber()) {
				wirelessLine = createobject('component','cfc.model.WirelessLine').init(); // add a wirelessline
				lastLineCreated = origOrderDetail.getGroupNumber();
			}
			
			orderDetail = createobject('component','cfc.model.OrderDetail').init();
			orderDetail.setGroupNumber(origOrderDetail.getGroupNumber());
			orderDetail.setGroupName(origOrderDetail.getGroupName());
			orderDetail.setOrderId(newOrder.getOrderId());
			qTitle = application.model.Phone.getProductTitle( exchangeProducts[i] ); //Get Title from Property
			orderDetail.initAsProduct(exchangeProducts[i]);
			orderDetail.setProductTitle( qTitle.Title );
			
			//orderDetail.setProductTitle( origOrderDetail.getProductTitle());
			orderDetail.setOrderDetailType( origOrderDetail.getOrderDetailType());
			orderDetail.setQty(1);

			if(sortCode == "EXX")
			{
				netPrice = replace(originalProductPrices[i],"$","");
				cogs = replace(exchangeCogsPrices[i],"$","");
			}
			else
			{
				netPrice = replace(originalProductPrices[i],"$","");
				cogs = replace(originalCogsPrices[i],"$","");
			}

			orderDetail.setCogs(cogs);
			orderDetail.setNetPrice(netPrice);
			
			// if a new device then increment counter
			if ( orderDetail.getOrderDetailType() eq 'd' ) {
				deviceCount++;
				wirelessLine.setLineDevice(orderDetail);
				ArrayAppend(newOrder.getWirelessLines(), wirelessLine);
			}

			// Create the EXCHANGED OrderDetail line to add to rate plan line
			if ( orderDetail.getOrderDetailType() eq 'd' ) {
				exchangedOrderDetail = createobject('component','cfc.model.OrderDetail').init();
				exchangedOrderDetail.setGroupNumber(origOrderDetail.getGroupNumber());
				exchangedOrderDetail.setGroupName(origOrderDetail.getGroupName());
				exchangedOrderDetail.setOrderId(newOrder.getOrderId());
				exchangedOrderDetail.setProductTitle( "Exchange order - no new activation" );
				exchangedOrderDetail.setGersSku("EXCHANGED");
				exchangedOrderDetail.setQty(1);
				exchangedOrderDetail.setCOGS(0);
				exchangedOrderDetail.setRetailPrice(0);
				exchangedOrderDetail.setNetPrice(exchangedNetPrices[i]);
				exchangedOrderDetail.setOrderDetailType('r');
				exchangedOrderDetail.setProductId(0);
				exchangedOrderDetail.save();
			}

			// save the order detail and EXCHANGED detail
			orderDetail.save();

			// if a new device then add the free stuff for this device to the order
			if ( orderDetail.getOrderDetailType() eq 'd' ) {
				freebies = orderDetail.getFreeProducts();
				for (f=1; f<=arraylen(freebies); f++) {
					freebieProduct = createobject('component','cfc.model.product').init();
					orderDetailFreebie = createobject('component','cfc.model.OrderDetail').init();					
					orderDetailFreebie.setGroupNumber(origOrderDetail.getGroupNumber());
					orderDetailFreebie.setGroupName(origOrderDetail.getGroupName());
					orderDetailFreebie.setOrderId(newOrder.getOrderId());
					orderDetailFreebie.initAsProduct(freebies[f]);
					orderDetailFreebie.setProductTitle(freebieProduct.getProperty(orderDetailFreebie.getproductId(),"Title") );
					orderDetailFreebie.setQty(1);
					orderDetailFreebie.setOrderDetailType('a');
					orderDetailFreebie.setOrderId(newOrder.getOrderId());
					orderDetailFreebie.save();
				}	
			}
		}

		//save the order.
		newOrder.setOtherItems(otherItems);
		newOrder.save();

		//Create taxable list from order details
		taxItems = [];
		newOrderDetails = newOrder.getOrderDetail();
		
		for (i=1; i <= ArrayLen(newOrderDetails); i++)
		{
			item = {};
			item.ProductId = newOrderDetails[i].getProductId();
			item.SKU = newOrderDetails[i].getGersSku();
			item.Retail = newOrderDetails[i].getRetailPrice();
			item.Net = newOrderDetails[i].getNetPrice();
			item.COGS = newOrderDetails[i].getCogs();
			ArrayAppend(taxItems, item);
		}

		//tax the order.
		taxCalculator = application.wirebox.getInstance("TaxCalculator");
		
		args = {
			billToAddress = newOrder.ConvertOrderAddressToAddress(newOrder.getBillAddress() )
			, shipToAddress = newOrder.ConvertOrderAddressToAddress(newOrder.getShipAddress() )
			, items = taxItems
			, saleDate = DateFormat(Now(), "yyyy-mm-dd")
			, currencyCode = "USD"
		};

		result = taxCalculator.calculateTax( argumentCollection = args );
		results = result.getResult();

		//update taxes on order details
		if ( !StructIsEmpty(results) )
		{
			for (i=1; i <= ArrayLen(results.TaxResponseLineItems); i++)
			{
				newOrderDetails[i].setTaxes( results.TaxResponseLineItems[i].getTotalTaxAmount() );
				newOrderDetails[i].save();
			}
			
			newOrder.setSalesTaxTransactionId(results.SalesTaxTransactionId); //store tax transaction
		}
		
		newOrder.save(); //save the order.
		hardReservationSuccess = newOrder.hardReserveAllHardGoods(); //reserve goods
	</cfscript>
	
	<cfif IsDefined("form.sendExchangePaymentEmail")>
		<!--- //send a payment email --->
		<cftry>
			<!---  Send Payment Email --->
			<cfset request.p.do = "paymentExchange" />
			<!--- paymentExchange uses the value of orderId to work --->
			<cfset orderid = newOrder.getOrderId() />  <!---temporarily set orderid to new orderid to email to the customer--->
			<cfinclude template="/emailTemplate/index.cfm" />
			<cfset orderid = request.p.orderId /> <!--- and switch it back to the orig order id --->
			
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message#" />
				<cfset result = cfcatch.messsage />
			</cfcatch>
		</cftry>
	</cfif>

</cfif>



<cfif structKeyExists(form, 'activationFullSubmit')>
	<cfscript>
		selectedTab = 2;	
		session.processMessages = [];

		switch (form.carrier)
		{
			case '42': //Verizon
				message = application.controller.VerizonActivationController.activateOrder( form.OrderId, form.requestedActivationDate );
				
				order = CreateObject('component', 'cfc.model.Order').init();
				order.load( form.OrderId );
				
				//Prorate receipt for New and AAL
				if ( order.getActivationType() eq 'N' || order.getActivationType() eq 'A' )
				{
					message = application.controller.VerizonActivationController.sendProrateReceipt( form.OrderId );
				}
				
				break;
			case '109': //AT&T
				message = application.controller.AttActivationController.activateOrder( form.OrderId, form.requestedActivationDate );
				break;
			case '128': //T-Mobile
				wirelessAccount = createObject('component', 'cfc.model.WirelessAccount').init();
				wirelessAccount.load(request.p.wirelessAccountId);
		
				try	
				{
					if (structKeyExists(form, 'carrier') and structKeyExists(form, 'orderId'))
					{
						response = variables.wirelessAccount.activateWirelessLines(orderId = form.orderId, carrier = form.carrier);
	
						local.ticketStruct = StructNew();
						local.ticketStruct.NoteBody = 'Activated All';
						local.ticketStruct.OrderNoteSubjectId = 51;
						local.ticketStruct.OrderId = FORM.orderId;
						local.ticketStruct.CreatedById = session.adminuser.adminuserid;
		
						local.void = application.model.TicketService.addOrderNote(argumentCollection = local.ticketStruct);
					} 
					else 
					{
						response = variables.wirelessAccount.activateWirelessLines();
					}
					
					message = response.getResult().message;
				} 
				catch ( any e )
				{
					message = 'An error occured during your request. ' & e.message;
				}			
				break;
			case '299': //Sprint
			
				SprintActivationController = application.wirebox.getInstance('SprintActivationController');
				message = SprintActivationController.activateOrder( form.OrderId );
				
				break;
			default:
				message	= 'Unknown Carrier ID. Could not invoke activation process.';
		}
	</cfscript>
	
<!--- this logic was moved to the scheduled job CreateSMS by Scott H. 11/18/14 --->
<!--- Scott: SMS Request logic goes here --->
	<!---
		For SMS Opt In orders create an SMS record for each phone.
		Set date = Now+1 day for new, Now+5 days for other orders
	 --->
<!---	<cfif isdefined("order") is false>
		<cfset order = CreateObject( "component", "cfc.model.Order" ).init()>
		<cfset order.load( form.orderId )>
	</cfif>
	 
	<cfscript>
		if (application.wirebox.containsInstance("CampaignService")) {
			campaignService = application.wirebox.getInstance("CampaignService");
		}
		if (order.getSmsOptIn()) {
			wl = order.getWirelessLines();
			smsSvc = getSmsMessageService();
			acType = order.getActivationType();
			if (acType == 'N') {
				smsDateOffset = 1;
			} else {
				smsDateOffset = 5;
			}
			smsDate = dateAdd('d',smsDateOffset, now());
			campaign = campaignService.getCampaignById(order.getCampaignid());
			for (i=1; i<=arraylen(wl);i++) {
				smsMDN = wl[i].getCurrentMDN();
				if (smsMDN is "") {
					smsMDN = wl[i].getNewMDN();
				}
				if (smsMDN is "") {
					SMSResultCode = -1;
					SMSResult = "MDN Missing";
				}
				
				smsMsg = createObject('component','cfc.model.system.sms.SmsMessage').init( 	
										"0"												// message id
									   	,smsMDN 										// phone number
									   	,order.getCarrierId()							// carrier id
										,campaign.getSmsMessage()						// message
										,smsDate										// runDate
										);
				smsMsg.setOrderDetailId(wl[i].getOrderDetailId());
				
				if (isdefined("SMSResult") and len(SMSResult)) {
					smsMsg.setResultCode(SMSResultCode);
					smsMsg.setResult(SMSResult);
				}
				smsSvc.createNewSmsMessage(smsMsg);						
			}	
		}
	</cfscript> 	
--->
	<div class="message-sticky">
		
		<cfif IsArray(message)>
			<!--- Add order note --->
			<cfset ticketStruct = StructNew() />
			<cfset ticketStruct.OrderNoteSubjectId = 49 />
			<cfset ticketStruct.OrderId = form.orderId />
			<cfset ticketStruct.CreatedById = session.adminuser.adminuserid />
			<cfset ticketStruct.NoteBody = '' />
				
			<cfloop array="#message#" index="i">
				<cfset ticketStruct.NoteBody = ticketStruct.NoteBody & '#i# <br />' />
				<cfoutput>#i#</cfoutput><br />
			</cfloop>
			
			<cfset application.model.TicketService.addOrderNote(argumentCollection = ticketStruct) />
		<cfelse>
			<cfoutput>#trim(variables.message)#</cfoutput>
		</cfif>

	</div>
</cfif>



<cfif structKeyExists( form, "submitCommissionSkuForm" )>
	<cfquery name="qGersSku" datasource="#application.dsn.wirelessAdvocates#">
    	SELECT catalog.GetUpgradeCommissionSku (
			<cfqueryparam cfsqltype="cf_sql_integer" value="#request.p.carrierId#" />
			, <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.p.ratePlanType#" />
			, <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.p.lineType#" />
			, <cfqueryparam cfsqltype="cf_sql_money" value="#request.p.monthlyFee#" />
			, NULL --This only runs when customer care provides order assistance and no gers sku exists on the order detail record(s)
			, NULL --Line number not required for OMT
			, NULL --Product ID not required for OMT
		),  AS GersSku
    </cfquery>
	<cfscript>
		message = "";

		if ( qGersSku.RecordCount AND Len(qGersSku.GersSku) )
		{
			orderDetail = CreateObject( "component", "cfc.model.OrderDetail" ).init();
			orderDetail.load( request.p.orderDetailId );
			orderDetail.setGersSku( qGersSku.GersSku ); //Update Commission code
			orderDetail.save();

			message = "Commission GERS SKU has been successfully updated";
		}
		else
		{
			message = "No commission GERS SKU matches criteria supplied";
		}
	</cfscript>
	<div class="message">
		<cfoutput>
			#message#
		</cfoutput>
	</div>
</cfif>
<cfif structKeyExists( form, "orderConfirmationSubmit" )>
	<cfscript>
		errors = [];
		order = CreateObject( "component", "cfc.model.Order" ).init();
		order.load( orderId );
		orderAsHtml = application.view.order.getOrderFullView( order );
		result = 'Success';
		
		/* args = {
			templateId = 4 //Order Confirmation
			, sendFrom = "noreply@membershipwireless.com"
			, sendTo = order.getEmailAddress()
			, parameterValues = order.getOrderId()
			, templateValues = orderAsHtml
		};
		*/
		//result = application.model.EmailManager.sendEmailFromTemplate( argumentCollection = args );
		
	</cfscript>
		<cftry>
			<!---  Send Order Confirmation Email --->
			<cfset request.p.do = "orderConfirmation" />
			<!--- orderConfirmation uses the value of orderId to work --->
			<cfset orderId = order.getOrderId() />
			<cfinclude template="/emailTemplate/index.cfm" />
			
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message#" />
				<cfset result = cfcatch.messsage />
			</cfcatch>
		</cftry>
		<!--- <cfset application.mappings["/views"]="c:\websites\channelbranding\views">
		<cfset theEmailController = CreateObject('component', 'views.#request.config.view#.email.emailController').init() />
		<cfset orderId = orderId />
		<cfset theEmailController.orderConfirmation(orderId) /> --->
		<!--- <cfdump var="#ExpandPath('../views')#">
		<cfabort /> --->
		<!--- <cfinclude template="#ExpandPath('../views/#request.config.view#/email/OrderConfirmation.cfm')#" /> --->
	<cfscript>
		
		if ( result NEQ 'Success' )
		{
			ArrayAppend( errors, "Email to customer was not sent due to error: " & result );
		}
	</cfscript>
	<cfif ArrayLen( errors )>
		<cfloop array="#errors#" index="error">
			<div class="errormessage">
				<cfoutput>
					#error#
				</cfoutput>
			</div>
		</cfloop>
	<cfelse>
		<div class="message">
			<cfoutput>
				Confirmation email has been sent to #order.getEmailAddress()# for Order ###order.getOrderId()#
			</cfoutput>
		</div>
	</cfif>
</cfif>

<cfif structKeyExists( form, "exchangePaymentSubmit" )>
	<cfscript>
		errors = [];
		order = CreateObject( "component", "cfc.model.Order" ).init();
		order.load( orderId );
		result = 'Success';
		/*
		args = {
			templateId = 7
			, sendFrom = "noreply@membershipwireless.com"
			, sendTo = order.getEmailAddress()
			, parameterValues = order.getOrderId()
		};
		*/
	</cfscript>
		<cftry>
			<!---  Send Payment Email --->
			<cfset request.p.do = "paymentExchange" />
			<!--- paymentExchange uses the value of orderId to work --->
			<cfinclude template="/emailTemplate/index.cfm" />
			
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message#" />
				<cfset result = cfcatch.messsage />
			</cfcatch>
		</cftry>
	<cfscript>
		//send a payment email
		//result = application.model.EmailManager.sendEmailFromTemplate( argumentCollection = args );

		if ( result NEQ 'Success' )
		{
			ArrayAppend( errors, "Email to customer was not sent due to error: " & result );
		}
	</cfscript>
	<cfif ArrayLen( errors )>
		<cfloop array="#errors#" index="error">
			<div class="errormessage">
				<cfoutput>
					#error#
				</cfoutput>
			</div>
		</cfloop>
	<cfelse>
		<div class="message">
			<cfoutput>
				Exchange Payment has been sent to #order.getEmailAddress()# for Order ###order.getOrderId()#
			</cfoutput>
		</div>
	</cfif>
</cfif>

<cfif structKeyExists( form, "orderPaymentSubmit" )>
	<cfscript>
		errors = [];
		order = CreateObject( "component", "cfc.model.Order" ).init();
		order.load( orderId );
		result = 'Success';
		/*
		args = {
			templateId = 7
			, sendFrom = "noreply@membershipwireless.com"
			, sendTo = order.getEmailAddress()
			, parameterValues = order.getOrderId()
		};
		*/
	</cfscript>
		<cftry>
			<!---  Send Payment Email --->
			<cfset request.p.do = "paymentOrder" />
			<!--- paymentExchange uses the value of orderId to work --->
			<cfinclude template="/emailTemplate/index.cfm" />
			
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message#" />
				<cfset result = cfcatch.messsage />
			</cfcatch>
		</cftry>
	<cfscript>
		//send a payment email
		//result = application.model.EmailManager.sendEmailFromTemplate( argumentCollection = args );

		if ( result NEQ 'Success' )
		{
			ArrayAppend( errors, "Email to customer was not sent due to error: " & result );
		}
	</cfscript>
	<cfif ArrayLen( errors )>
		<cfloop array="#errors#" index="error">
			<div class="errormessage">
				<cfoutput>
					#error#
				</cfoutput>
			</div>
		</cfloop>
	<cfelse>
		<div class="message">
			<cfoutput>
				Order Payment has been sent to #order.getEmailAddress()# for Order ###order.getOrderId()#
			</cfoutput>
		</div>
	</cfif>
</cfif>

<cfif structKeyExists( form, "orderUpdateSubmit" )>
	<cfscript>
		order = CreateObject( "component", "cfc.model.Order" ).init();
		order.load( orderId );
		order.setKioskEmployeeNumber(form.kioskEmployeeNumber);
		order.setEmailAddress( form.emailAddress );
		order.save();
	</cfscript>
	<div class="message">
		<cfoutput>
			Order ###order.getOrderId()# has been updated
		</cfoutput>
	</div>
</cfif>

<cfif structKeyExists( form, "paymentAuthSubmit" )>
	<cfscript>
		order = CreateObject( "component", "cfc.model.Order" ).init();
		order.load( orderId );
		paymentmethod = createObject('component', 'cfc.model.PaymentMethod').init();
		paymentMethod.load(8);
	</cfscript>

	<cftry>
		<cfset paymentSaveErrorMsg = "" />
		<cfscript>
		payment = CreateObject( "component", "cfc.model.Payment" ).init();
		payment.setOrderId(orderid);
		payment.setPaymentAmount(paymentAmount);
		// payment.setPaymentMethod(paymentMethod);
		payment.setPaymentDate(now());
		payment.setBankcode(bankCode);
		payment.setAuthorizationOrigId(AuthorizationOrigId);
		payment.setCreditCardAuthorizationNumber(creditCardAuthorizationNumber);
		payment.setPaymentToken(paymentToken);
		payment.setIsDirty(true);
		payment.save();
		</cfscript>
	<cfcatch type="any" >
		<cfset paymentSaveErrorMsg = "#cfcatch.message# - #cfcatch.detail#" />
	</cfcatch>	
	</cftry>
	<div class="message">
		<cfif paymentSaveErrorMsg is "">
		<cfoutput>
			Order ###order.getOrderId()# payment authorization has been added
		</cfoutput>
		<cfelse>
			<cfoutput>
			Order ###order.getOrderId()#: Exception - #paymentSaveErrorMsg#
		</cfoutput>
		</cfif>	
	</div>
</cfif>


<cfif structKeyExists(form, 'bannedUserSubmit')>
	<cfset SecurityService = application.wirebox.getInstance("SecurityService") />
	
	<cfscript>
		local.ticketStruct = StructNew();
		local.ticketStruct.NoteBody = 'Order marked as fraud';
		local.ticketStruct.OrderNoteSubjectId = 54;
		local.ticketStruct.OrderId = form.orderId;
		local.ticketStruct.CreatedById = session.adminuser.adminuserid;
		local.void = application.model.TicketService.addOrderNote(argumentCollection = local.ticketStruct);
	
		order = CreateObject( "component", "cfc.model.Order" ).init();
		order.load( orderId );
	
		args = {
			FirstName = order.getShipAddress().getFirstName()
			, LastName = order.getShipAddress().getLastName()
			, Address1 = order.getShipAddress().getAddress1()
			, Address2 = order.getShipAddress().getAddress2()
			, City = order.getShipAddress().getCity()
			, State = order.getShipAddress().getState()
			, Zip = order.getShipAddress().getZip()
		};
	
		SecurityService.createBannedUser( argumentcollection = args );
	</cfscript>
	<div class="message">
		User information has been added to Fraud listing.
	</div>	
</cfif>

<cfif structKeyExists( form, "unlockOrderSubmit" )>
	<cfscript>
		order = CreateObject( "component", "cfc.model.Order" ).init();
		order.load( orderId );
		
		order.setLockedById(0);
		order.setLockDateTime('');
		order.save();
	</cfscript>

	<div class="message">
		Order has been unlocked.
	</div>
</cfif>

<!--- Current fraud check only handles no-contract phones so set status to 3. --->
<cfif structKeyExists( form, "passManualFraudCheck" )>
	<cfscript>
		order = CreateObject( "component", "cfc.model.Order" ).init();
		order.load( orderId );
		order.setStatus(form.status);
		order.save();
	</cfscript>

	<div class="message">
		Order status has been updated.
	</div>
</cfif>

<cfsavecontent variable="js">
<cfoutput>
	<link rel="stylesheet" type="text/css" href="#assetPaths.admin.common#styles/customerservice.css" />
	<script type="text/javascript" src="#assetPaths.admin.common#scripts/libs/jquery.metadata.js"></script>
	<script type="text/javascript" src="#assetPaths.admin.common#scripts/libs/jquery.validate.min.js"></script>
	<script type="text/javascript" src="#assetPaths.admin.common#scripts/libs/jquery.livequery.js"></script>
</cfoutput>

<!--- TODO: Move styles to main CSS stylesheet --->
<style>
input.disabled_field
{
	color: #000000;
	background-color: #ffffff;
	border: 0px solid #666666;
}

div.buttonContainer
{
	margin: 25px 0px 0px 0px;
	width: 100%;
	height: 35px;
	vertical-align: middle;
	/*text-align: center;*/
}

</style>

<script>
$(document).ready(function() {
	var isRmaTabLoaded = false;
	var isAccountTabLoaded = false;
	var isExchangeTabLoaded = false;
	var isCatsTabLoaded = false;

	//Tab Settings
	$( "#tabs" ).bind( "tabsselect", function(event, ui) {

		if ( (!isRmaTabLoaded && ui.tab.id == 'rma-tab')
			 || (!isAccountTabLoaded && ui.tab.id == 'account-tab')
			 || (!isExchangeTabLoaded && ui.tab.id == 'exchange-tab') )
		{
			$("#tabs ul li a").eq(ui.index).html("<span class='loader'>Loading...</span>");
		}
	});

	//Update Tab name after content loads
	$( "#tabs" ).bind( "tabsload", function(event, ui) {

		if (!isRmaTabLoaded && ui.tab.id == 'rma-tab')
		{
			$("#" + ui.tab.id).html("RMA");
			isRmaTabLoaded = true;
		}

		if (!isAccountTabLoaded && ui.tab.id == 'account-tab')
		{
			$("#" + ui.tab.id).html("Account");
			isAccountTabLoaded = true;
		}

		if (!isExchangeTabLoaded && ui.tab.id == 'exchange-tab')
		{
			$("#" + ui.tab.id).html("Exchanges");
			isExchangeTabLoaded = true;
		}
	});

	$('#tabs').tabs('option', 'cache', true);
	$('#tabs').tabs('option', 'ajaxOptions', { cache: false });
	$('#tabs').tabs('option', 'selected', <cfoutput>#selectedTab#</cfoutput>); //Preselect details tab

	//Bind click event to activation listing
	$('.activationListing').click(function(event) {
		$('#tabs').tabs('remove', 6 );
		$('#tabs').tabs('add', '#tabs-activation', 'Activate Line #' + $(this).metadata().lineNumber);
		$('#tabs').tabs('url', $('#tabs').tabs('length')-1, 'components/order/dsp_activationDetails.cfm?WirelessLineId=' + $(this).metadata().wirelessLineId);
		$('#tabs').tabs('option', 'selected', $('#tabs').tabs('length')-1);
	});

	//Set validation plugin defaults
	$.validator.setDefaults({
	   meta: "validate"
	   , errorElement: "em"
	});

	//Set up dialog
	$("#dialog-confirm").dialog({
		autoOpen: false,
		resizable: false,
		height:140,
		modal: true,
		buttons: {
			'Don\'t Cancel': function() {
				$(this).dialog('close');
			},
			'Cancel Order': function() {
				if ( $("#cancelOrderForm").valid() )
				{
					$('#cancelOrderForm').submit();
				}
			}
		}
	});


	//Set up dialog
	$("#dialog-confirm-delete-note").dialog({
		autoOpen: false,
		resizable: false,
		height:140,
		modal: true,
		buttons: {
			'Don\'t Delete': function() {
				$(this).dialog('close');
			},
			'Delete Note': function() {
				if ( $("#cancelOrderForm").valid() )
				{
					$('#cancelOrderForm').submit();
				}
			}
		}
	});


	//Bind click event to AJAX loaded form button
	$('#activationDetailSubmit').livequery('click', function(event) {

		//Validate form when status chosen is Success (6)
		if ( $("#activationStatus").val() == 6 )
		{
			$("#activationDetailsForm").validate();

			if ( $("#activationDetailsForm").valid() )
			{
				$('#activationDetailsForm').submit();
			}
		}
		else
		{
			//ignore form validation
			$('#activationDetailsForm')[0].submit();
		}
    });

	//Bind click event to AJAX loaded form button
	$('#ssnToggleButton').livequery('click', function(event) {

//console.log('SSN ' + $(this).metadata().wirelessAccountId);
$('#ssn').val( '');
		$.ajax({
			url: <cfoutput>'http://#CGI.server_name#:#CGI.server_port#/admin/cfc/remote/OrderProxy.cfc?method=getSSN'</cfoutput>,
			dataType: 'json',
			data: {wirelessAccountId: $(this).metadata().wirelessAccountId},
			context: document.body,

			success: function(response){
				console.log( 'Success' );
				console.log( $.trim(data.SSN) );
				
				data = $.parseJSON( response );
				$('#ssn').val( $.trim(data.SSN) );
			},
			cache: false
		});

		return false; //prevent form submit
    });

	//Toggle
	$('#cancelOrderForm #orderStatus').change(function() {
		if ( $(this).val() == 4 )
		{
			$('.cancel_field').removeClass('hidden');
		}
		else
		{
			$('.cancel_field').addClass('hidden');
		}
	});

	//Bind click event to cancel order button
	$('#cancelOrderSubmit').click(function(event) {
		$("#cancelOrderForm").validate();

		if ( $("#cancelOrderForm").valid() )
		{
			$('#dialog-confirm').dialog('open');
		}
	});

	//Toggle
	$('#toggleShippingButton').toggle(function() {
		$(this).text('Cancel');
		$('.shipping_data').addClass('hidden');
		$('.shipping_field').removeClass('hidden');
	}, function() {
		$(this).text('Edit');
		$('.shipping_data').removeClass('hidden');
		$('.shipping_field').addClass('hidden');
	});

	//Bind click event to update shipping button
	$('#orderShippingSubmit').click(function(event) {
		$("#orderShippingForm").validate();

		if ( $("#orderShippingForm").valid() )
		{
			$('#orderShippingForm').submit();
		}
	});

	//Bind click event to fraud user button
	$('#bannedUserSubmit').click(function(event) {
		
		if (confirm('Are you sure you want to mark this order as fraud?')) {
			$('#bannedUserForm').submit();
		}
	});

	//Toggle
	$('#toggleRmaButton').livequery('click', function(event) {
		if( $('#toggleRmaButton').text() == 'Edit')
		{
			$(this).text('Cancel')
			$('.rma_data').addClass('hidden');
			$('.rma_field').removeClass('hidden');
		}
		else
		{
			$(this).text('Edit');
			$('.rma_data').removeClass('hidden');
			$('.rma_field').addClass('hidden');
		}
	});

	//Bind click event to update shipping button
	$('#rmaSubmit').livequery('click', function(event) {
		$("#rmaForm").validate();

		if ( $("#rmaForm").valid() )
		{
			$('#rmaFormAction').val( 'rmaSubmit' );

			$('#rmaForm').submit();
		}
	});

	//Bind click event to update shipping button
	$('#returnAuthorizationSubmit').livequery('click', function(event) {
		$("#rmaForm").validate();

		//TODO: Check if one checkbox is checked

		if ( $("#rmaForm").valid() )
		{
			$('#rmaFormAction').val( 'returnAuthorizationSubmit' );

			$('#rmaForm').submit();
		}
	});

	//Bind click event to Activate All button
	$('#autoActivationSubmit').click(function(event) {
		$(this).hide();
		$("#progressbar").progressbar({ value: 100 });

		$('#fullActivationForm').submit();
	});

	//Bind click event to
	$('#commissionSkuSubmit').click(function(event) {

		$("#commissionSkuForm").validate();

		if ( $("#commissionSkuForm").valid() )
		{
			$('#commissionSkuForm').submit();
		}
	});

	//Bind click event to button
	$('#orderConfirmationSubmit').click(function(event) {
			
			$("#orderConfirmationForm").validate();
			
			if ($("#orderConfirmationForm").valid()) {
				$('#orderConfirmationForm').submit();
			}
	});

	//Bind click event to button
	$('#exchangePaymentSubmit').click(function(event) {

		$("#exchangePaymentForm").validate();

		if ( $("#exchangePaymentForm").valid() )
		{
			$('#exchangePaymentForm').submit();
		}
	});

	$('#orderPaymentSubmit').click(function(event) {

		$("#orderPaymentForm").validate();

		if ( $("#orderPaymentForm").valid() )
		{
			$('#orderPaymentForm').submit();
		}
	});

	//Toggle
	$('#toggleOrderUpdateButton').toggle(function() {
		$(this).text('Cancel');
		$('.order_data').addClass('hidden');
		$('.order_field').removeClass('hidden');
	}, function() {
		$(this).text('Edit');
		$('.order_data').removeClass('hidden');
		$('.order_field').addClass('hidden');
	});

	//Toggle
	$('#togglePaymentAuthButton').toggle(function() {
		$(this).text('Cancel Payment Authorization');
		$('.payment_field').removeClass('hidden');
	}, function() {
		$(this).text('Create Payment Authorization Record');
		$('.payment_field').addClass('hidden');
	});

	//Bind click event to
	$('#orderUpdateSubmit').click(function(event) {

		$("#orderUpdateSubmitForm").validate();

		if ( $("#orderUpdateSubmitForm").valid() )
		{
			$('#orderUpdateSubmitForm').submit();
		}
	});


	$('#capture').click(function(event) {
		$(this).attr('disabled', 'disabled');
		$('#paymentForm1')[0].submit();
	});


	$('.toggleNoteDisplay').click(function() {

		//Toggle text of link
		if ($(this).text() == 'Show')
		{
			$(this).text( 'Hide' );
		}
		else
		{
			$(this).text( 'Show' );
		}

		var data = $(this).metadata();
		$('#' + 'noteRow-' + data.noteId).toggle();
	});


});
</script>
</cfsavecontent>
<cfhtmlhead text="#js#">
<cftry>
	<cfscript>
	order = CreateObject( "component", "cfc.model.Order" ).init();
	order.load( orderId, true);

	user = CreateObject( "component", "cfc.model.User" ).init();
	user.getUserById( order.getUserId() ); //Loads user object

	view = application.view.OrderManager.getManagerView( order, user );
</cfscript>
	<cfoutput>
		#view#
	</cfoutput>
	<cfcatch type="any">
		<cfdump var="#cfcatch#">
		<cfabort>
	</cfcatch>
</cftry>


<cffunction
name="CleanHighAscii"
access="public"
returntype="string"
output="false"
hint="Cleans extended ascii values to make the as web safe as possible.">
 
<!--- Define arguments. --->
<cfargument
name="Text"
type="string"
required="true"
hint="The string that we are going to be cleaning."
/>
 
<!--- Set up local scope. --->
<cfset var LOCAL = {} />
 
<!---
When cleaning the string, there are going to be ascii
values that we want to target, but there are also going
to be high ascii values that we don't expect. Therefore,
we have to create a pattern that simply matches all non
low-ASCII characters. This will find all characters that
are NOT in the first 127 ascii values. To do this, we
are using the 2-digit hex encoding of values.
--->
<cfset LOCAL.Pattern = CreateObject(
"java",
"java.util.regex.Pattern"
).Compile(
JavaCast( "string", "[^\x00-\x7F]" )
)
/>
 
<!---
Create the pattern matcher for our target text. The
matcher will be able to loop through all the high
ascii values found in the target string.
--->
<cfset LOCAL.Matcher = LOCAL.Pattern.Matcher(
JavaCast( "string", ARGUMENTS.Text )
) />
 
 
<!---
As we clean the string, we are going to need to build
a results string buffer into which the Matcher will
be able to store the clean values.
--->
<cfset LOCAL.Buffer = CreateObject(
"java",
"java.lang.StringBuffer"
).Init() />
 
 
<!--- Keep looping over high ascii values. --->
<cfloop condition="LOCAL.Matcher.Find()">
 
<!--- Get the matched high ascii value. --->
<cfset LOCAL.Value = LOCAL.Matcher.Group() />
 
<!--- Get the ascii value of our character. --->
<cfset LOCAL.AsciiValue = Asc( LOCAL.Value ) />
 
<!---
Now that we have the high ascii value, we need to
figure out what to do with it. There are explicit
tests we can perform for our replacements. However,
if we don't have a match, we need a default
strategy and that will be to just store it as an
escaped value.
--->
 
<!--- Check for Microsoft double smart quotes. --->
<cfif (
(LOCAL.AsciiValue EQ 8220) OR
(LOCAL.AsciiValue EQ 8221)
)>
 
<!--- Use standard quote. --->
<cfset LOCAL.Value = """" />
 
<!--- Check for Microsoft single smart quotes. --->
<cfelseif (
(LOCAL.AsciiValue EQ 8216) OR
(LOCAL.AsciiValue EQ 8217)
)>
 
<!--- Use standard quote. --->
<cfset LOCAL.Value = "'" />
 
<!--- Check for Microsoft elipse. --->
<cfelseif (LOCAL.AsciiValue EQ 8230)>
 
<!--- Use several periods. --->
<cfset LOCAL.Value = "..." />
 
<cfelse>
 
<!---
We didn't get any explicit matches on our
character, so just store the escaped value.
--->
<cfset LOCAL.Value = "&###LOCAL.AsciiValue#;" />
 
</cfif>
 
 
<!---
Add the cleaned high ascii character into the
results buffer. Since we know we will only be
working with extended values, we know that we don't
have to worry about escaping any special characters
in our target string.
--->
<cfset LOCAL.Matcher.AppendReplacement(
LOCAL.Buffer,
JavaCast( "string", LOCAL.Value )
) />
 
</cfloop>
 
<!---
At this point there are no further high ascii values
in the string. Add the rest of the target text to the
results buffer.
--->
<cfset LOCAL.Matcher.AppendTail(
LOCAL.Buffer
) />
 
 
<!--- Return the resultant string. --->
<cfreturn LOCAL.Buffer.ToString() />
</cffunction>


<cffunction name="getCurrentCampaign" access="public" output="false" returntype="cfc.model.campaign.Campaign">
		
		<cfscript>
			var campaignService = '';
			var campaign = CreateObject('component', 'cfc.model.campaign.Campaign').init();
						
			if ( application.wirebox.containsInstance('CampaignService') )
			{
				campaignService = application.wirebox.getInstance('CampaignService');
				campaign = campaignService.getCampaignBySubdomain( campaignService.getCurrentSubdomain() );
			}
			
			if (!IsDefined('campaign'))
			{
				campaign = CreateObject('component', 'cfc.model.campaign.Campaign').init();
			}
		</cfscript>
		
    	<cfreturn campaign />
</cffunction>

<cffunction name="getSmsMessageService" access="public" output="false" returntype="cfc.model.system.sms.SmsMessageService">
		
		<cfscript>
			var smsMessageService = '';
						
			if ( application.wirebox.containsInstance('SmsMessageService') )
			{
				smsMessageService = application.wirebox.getInstance('SmsMessageService');
			}
			
			if (!IsDefined('smsMessageService'))
			{
				smsMessageService = CreateObject('component', 'cfc.model.system.sms.SmsMessageService').init();
			}
		</cfscript>
		
    	<cfreturn smsMessageService />
</cffunction>


