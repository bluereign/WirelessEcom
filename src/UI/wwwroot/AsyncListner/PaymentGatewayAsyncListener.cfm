<cfparam name="form.refererURL" default="" />

<cfif form.refererURL is not "">
	<cfset testurl = replacenocase(form.RefererURL,"%2F","/","ALL") />
	<cfif listlen(testURL,"/") GE 2>
		<cfset IntendedURL = listgetat(testurl,2,"/") />
		<cfset IntendedURLList = "costcodirectdelivery.wasvcs.com,10.7.0.143" />
		<cfif SERVER_Name is not IntendedURL and listfindnocase(IntendedURLList,IntendedURL) >
			<cfhttp url="http://#intendedurl#/AsyncListner/PaymentGatewayAsyncListener.cfm" method="post">
			<cfloop collection="#form#" item="theField">
				<cfif theField is not "FieldNames">
					<cfhttpparam name="#theField#" type="FormField" value="#form[theField]#" encoded="true" >
				</cfif>
			</cfloop>
			</cfhttp>
			<cfoutput>#cfhttp.fileContent#</cfoutput><cfabort/>
		</cfif>
	</cfif>	
</cfif>

<cfset docContent = getHTTPRequestData().content />

<cfset isOrderProcessed = true />
<cfset errorMessage = ''>
<cftry>
	
	<cfif !isDefined( "gatewayName" )>
		<cfthrow type="PaymentGatewayAsyncListener" message="Unable to identify gateway.">
	</cfif>
	
	<cfset PaymentService = application.wirebox.getInstance("PaymentService") />
	<cfset PaymentGateway = PaymentService.getPaymentGatewayByName( gatewayName ) />
	
	<cfset Response = PaymentGateway.processPaymentResult(form) />
	<cfset Result =  Response.getResult() />
	
	<cfset paymentLogArgs = {
		OrderId = Result.getSalesOrderNumber()
		, Type = 'Response'
		, RequestType = 'AsyncPostback'
		, Data = docContent
	} />
	
	<cfset application.model.Log.logPaymentGatewayResponse( argumentCollection = paymentLogArgs ) />

	<!---
	**
	* Check to see if the payment was accepted.
	**
	--->
	<cfif Response.getResultCode() is 'PG001' or Response.getResultCode() is 'PG003' and (Result.getCCType() neq 'Test Card Number' || !PaymentGateway.isAsync())>
		<!---
		**
		* Update the order status to 1=submitted.
		**
		--->
		<cfset order = createObject('component', 'cfc.model.order').init() />
		<cfset order.load(Result.getSalesOrderNumber()) />

		<cfif variables.order.getStatus() lt 1>
			<cfset order.setStatus(1) />
		</cfif>

		<cfset pMethod = createObject('component', 'cfc.model.paymentMethod').init() />
		<cfset pMethod.getPaymentMethodByName( Result.getTransactionType() ) />
		
		<!---
		**
		* Insert initial payment minus the discount total if applicable.
		**
		--->
		<cfset p = createObject('component', 'cfc.model.payment').init() />
		<cfset p.setOrderId(variables.order.getOrderId()) />

		<cfset p.setPaymentAmount(Result.getAmount()) />

		<cfset p.setPaymentDate(now()) />
		<cfset p.setPaymentMethod(variables.pMethod) />
		<cfset p.setCreditCardAuthorizationNumber(Result.getReceiptNumber()) />
		<cfset p.setAuthorizationOrigId(Result.getGUID()) />
		<cfset p.setPaymentToken(Result.GetPaymentToken()) />

		<cfset order.addPayment(variables.p) />
		
		<!--- Insert discount payment total if applicable. --->
		<cfif val(variables.order.getOrderDiscountTotal()) gt 0>
			<cfset paymentMethod = createObject('component', 'cfc.model.paymentMethod').init() />

			<cfset paymentMethod.getPaymentMethodByName('Coupon') />

			<cfset p = createObject('component', 'cfc.model.payment').init() />
			<cfset p.setOrderId(variables.order.getOrderId()) />
			<cfset p.setPaymentAmount(variables.order.getOrderDiscountTotal()) />
			<cfset p.setPaymentDate(now()) />
			<cfset p.setPaymentMethod(variables.paymentMethod) />
			<cfset p.setCreditCardAuthorizationNumber(Result.getReceiptNumber()) />
			<cfset p.setAuthorizationOrigId(Result.getGUID()) />
			<cfset p.setPaymentToken(Result.getPaymentToken()) />

			<cfset order.addPayment(variables.p) />
		</cfif>
		
		<!--- If this is a $0 order then insert fake capture payment record for GERS --->
		<cfscript>
			if ( variables.order.getOrderTotal() lte 0 )
			{
				//Insert stubbed payment record that GERS is expecting
				paymentMethod = CreateObject('component', 'cfc.model.paymentMethod').init();
				paymentMethod.getPaymentMethodByName( 'Visa' ); //Use Visa for FI default
				
				payment = CreateObject('component', 'cfc.model.payment').init();
				payment.setOrderId( application.model.checkoutHelper.getOrderId() );
				payment.setPaymentAmount( order.getOrderTotal() );
				payment.setPaymentDate( Now() );
				payment.setPaymentMethod( paymentMethod );
				payment.setCreditCardAuthorizationNumber( 'zerodollar' );
				payment.setAuthorizationOrigId( 'zerodollar' );
				payment.setPaymentToken( 'zerodollar' );
				
				order.addPayment( payment );
			}
		</cfscript>


		<cfif order.getStatus() lt 2>
			<cfset order.setStatus(2) />
		</cfif>

		<cfset order.save() />

		<cfif len( Result.getTransactionType() )>
			<cfset hardReservationSuccess = order.hardReserveAllHardGoods() />

			<cfif not variables.hardReservationSuccess>
				<cfoutput><hr />Error attempting to make order hard reservations.<hr /></cfoutput>

				<cfabort />
			</cfif>
		</cfif>

		<cfif Result.getTransactionType() is not 'Pre-Auth'>
			<cfscript>
				if(request.config.commitTaxTransaction)	{
					if(not variables.order.getIsSalesTaxTransactionCommited() and len(variables.order.getSalesTaxTransactionId()))	{
						try	{
							args = {
									CommitDate 			=	variables.order.getOrderDate()
								,	InvoiceNumber 		=	request.config.InvoiceNumberPrefix & variables.order.getOrderId()
								, 	PriorTransactionId	=	variables.order.getSalesTaxTransactionId()
							};

							taxCalculator = application.wirebox.getInstance("TaxCalculator");
							taxCalculator.commitTaxTransaction(argumentCollection = variables.args);

							order.setIsSalesTaxTransactionCommited(true);
							order.save();
						}
						catch (any e)	{
							//Silently catch errors
							//TODO: log errors
						}
					}
				}
			</cfscript>
		</cfif>

		<cfif variables.order.getActivationType() is 'U'>
			<cfscript>
				// Transfer the IMEI and SIM to wireless line fields
				order.magic('upgrade');

				// Update group name and number fields for upgrade commission SKUs
				otherItems = order.getOtherItems();
				groupNumber = 0;

				if ( ArrayLen(otherItems) )
				{
					for (i=1; i <= ArrayLen(otherItems); i++)
					{
						if ( otherItems[i].getOrderDetailType() eq 'u' )
						{
							groupNumber++;
							otherItems[i].setGroupName( 'Line ' & groupNumber );
							otherItems[i].setGroupNumber( groupNumber );
							otherItems[i].save();
						}
					}
				}

				//Resolve conflicting SOC services with customer's carrier account for upgrade orders without a rateplan
				if ( ListFind( '109,128', order.getCarrierId() ) && !order.hasRatePlan() )
				{
					resolvedConflicts = application.model.CustomerAccountService.resolveConflictingSocCodesOnOrder( order );

					activityLog = CreateObject( 'component', 'cfc.model.ActivityLog' ).init();
					activityLog.setType( 'Order' );
					activityLog.setTypeReferenceId( order.getOrderId() );
					activityLog.setPrimaryActivityType( 'Resolve SOC Code' );
					activityLog.addEvent( 'Resolve SOC Code', 'Conflicts', resolvedConflicts );
					activityLog.save();
				}
			</cfscript>
		</cfif>

		<!--- TODO: Need to figure out order is a family plan (wireless acccount?) --->
		<cfif variables.order.getActivationType() is 'A'>
			<cfscript>
				// Update group name and number fields for AAL commission SKUs
				otherItems = order.getOtherItems();
				groupNumber = 0;

				if ( ArrayLen(otherItems) )
				{
					for (i=1; i <= ArrayLen(otherItems); i++)
					{
						if ( otherItems[i].getOrderDetailType() eq 'u' )
						{
							groupNumber++;
							otherItems[i].setGroupName( 'Line ' & groupNumber );
							otherItems[i].setGroupNumber( groupNumber );
							otherItems[i].save();
						}
					}
				}
			</cfscript>
		</cfif>

		<cfset orderAsHtml = application.view.order.getOrderFullView(variables.order) />
		<cfset orderAsHtml = replace(variables.orderAsHTML, '<div id="wrapper" width="100%">', '<div id="wrapper" width="500px">') />
		<!--- <cfset result = application.model.emailManager.sendEmailFromTemplate(templateId = 4, sendFrom = 'noreply@membershipwireless.com', sendTo = variables.order.getEmailAddress(), parameterValues = variables.order.getOrderId(), templateValues = variables.orderAsHtml) /> --->
		
		<!--- Send Order Confirmation Email --->
		<cfset request.p.do = "orderConfirmation" />
		<cfset orderId = variables.order.getOrderId() />
		<cfinclude template="/emailTemplate/index.cfm" />

		<cfset errorMessage = trim(variables.orderAsHTML) />
	</cfif>

	<cfcatch type="any">
		<cfset isOrderProcessed = false />
		
		<cfset error = structNew()>
		<cfset error.message = "#cfcatch.message#:#cfcatch.detail#">
		<cfset error.HTTPRequestData = getHTTPRequestData()>
		<cfset error.formScope = form>

		<cfquery name="qry_insertError" datasource="#application.dsn.wirelessadvocates#">
			INSERT INTO service.PaymentGatewayListener
			(
				Content,
				CreatedDate
			)
			VALUES
			(
				<cfqueryparam value="#serializeJSON(error)#" cfsqltype="cf_sql_longvarchar" />,
				GETDATE()
			)
		</cfquery>
		<cfdump var="#error.message#"><cfabort>
	</cfcatch>
</cftry>

<cfsavecontent variable="content">
	<cfdump var="#now()#" />
	<br />
	Order Processed Successfully: <cfoutput>#variables.isOrderProcessed#</cfoutput>
	<br />
	<cfoutput>#trim(variables.errorMessage)#</cfoutput>
	<br />
	<cfdump label="FORM" var="#form#" />
	<cfdump label="URL" var="#url#" />
	<cfdump label="DocContent" var="#trim(variables.docContent)#" />
	<cfdump label="RESULT" var="#Result.getInstanceData()#" />
	<hr />
</cfsavecontent>

<cfquery name="qry_insertContent" datasource="#application.dsn.wirelessadvocates#">
	INSERT INTO service.PaymentGatewayListener
	(
		Content,
		CreatedDate
	)
	VALUES
	(
		<cfqueryparam value="#trim(variables.content)#" cfsqltype="cf_sql_longvarchar" />,
		GETDATE()
	)
</cfquery>

<cfif structKeyExists(form, 'adminReturnUrl')><cflocation url="#form.adminReturnUrl#" addtoken="false" /><cfelse><cfif variables.isOrderProcessed><cfoutput>TRANSACTION-OK</cfoutput><cfabort /><cfelse><cfoutput>TRANSACTION-FAIL</cfoutput><cfabort /></cfif></cfif>
