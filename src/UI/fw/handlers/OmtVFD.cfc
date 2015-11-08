<cfcomponent output="false" extends="BaseHandler">
	
	<!--- Use CFProperty to declare beans for injection.  By default, they will be placed in the variables scope --->
	<cfproperty name="assetPaths" inject="id:assetPaths" scope="variables" />

	<cfif cgi.server_port neq 443 and not request.config.disableSSL>
		<cflocation url="https://#cgi.HTTP_HOST##cgi.path_info#" addtoken="false" />
	</cfif>
	
	<cffunction name="searchOrders" returntype="void" output="false">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		
		<cfset var local = {} />
		<cfset currTime = now()>
		<cfset startDate = DateFormat(DateAdd('d', -31, currTime),'yyyy-mm-dd') >
		<cfset odfrom = startDate />	
		<cfset odto = "" />
		
		<cfscript>
			local.searchArgs = {
				kioskID = session.vfd.kioskNumber,
				orderDateFrom = odfrom,
				orderDateTo = odto
			};
			/*session.ddadmin.searchArgs = local.searchArgs;*/
			
			rc.qOrders = application.model.order.getDDOrderReprints(local.searchArgs);
			event.setLayout('CheckoutVFD');
			event.setView('VFD/omt/orderSearchVFD');
		</cfscript>
		
	</cffunction> 
	
	<cffunction name="orderConfirmationReprint" returntype="void" output="false">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		<cfset session.checkout.OrderId = orderID/>
		<cfset event.setView(view='VFD/checkout/confirmationCostco',nolayout=true) />
	</cffunction>
	
	<cffunction name="modifyOrder" returntype="void" output="false">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		<!---<cfset session.checkout.OrderId = orderID/>--->
		
		<cfset rc.qWirelesslines = application.model.WirelessLine.getWirelessLineByOrder(orderID)/>
		
		<cfset event.setLayout('CheckoutVFD') />
		<cfset event.setView(view='VFD/checkout/modifyOrder') />
	</cffunction>
	
	<cffunction name="printConfirmation" returntype="void" output="false">
    		<cfset event.setView(view='VFD/checkout/confirmationCostco',nolayout=true) />
    </cffunction>
    
    <cffunction name="cancelOrderSubmit" returntype="void" output="false">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		
		<!---<cfset orderId = 25155>--->
		<cfset request.p.cancelationReason = "Direct Delivery Store Initiated Cancellation">
		
		<cfscript>
			errors = [];
			selectedTab = 0;
	
			order = CreateObject( "component", "cfc.model.Order" ).init();
			order.load( rc.orderId );
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
				for (i = 1; i lte arraylen(local.appleCareMessages); i=i+1) {
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
	
			order.save( Session.VFD.employeeNumber );
	
		</cfscript>
		<cfset result = "Success" />
			 
		<cftry>
			<!--- Send Internal Order Cancellation Email --->
			<cfset request.p.do = "orderCancellationAlert" />
			<cfset orderId = order.getOrderId() />
			<cfset adminEmail = "customercare@wirelessadvocates.com" />
			<cfset cancellationReason = request.p.cancelationReason />
	
			<cfinclude template = "/emailTemplate/index.cfm" />
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message#" />
				<cfset result = cfcatch.message />
			</cfcatch>
		</cftry>
	
		<cfscript>
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
		<cfset setNextEvent('OmtVFD.searchOrders') />
	</cffunction>
	
</cfcomponent>