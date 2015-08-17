<cfcomponent hint="Star Card payment processor" displayname="MilitaryStarPaymentGateway" extends="AbstractPaymentGateway">

	<!-------------------------------- CONSTRUCTOR ---------------------------------->

	<cffunction name="init" access="public" returntype="MilitaryStarPaymentGateway" hint="Initalizes the Component">
		<cfargument name="name" required="true" type="string">
		<cfargument name="merchantID" required="true" type="string" hint="ssl_merchant_id">
		<cfargument name="processingURL" required="true" type="string" hint="Military Star processing URL.">
		<cfargument name="settleURL" required="true" type="string" hint="Military Star settlement URL.">
		<cfargument name="async" required="false" type="boolean" hint="Indicates whether payment details come in a different request than the user.">
		<cfargument name="isTestMode" required="false" type="boolean" default="false">

		<cfscript>
			super.init( argumentCollection=arguments );

			setMerchantID( arguments.merchantID );
			setTestMode( arguments.isTestMode );
			setSettleURL( arguments.settleURL );

			return this;
		</cfscript>

	</cffunction>

	<!----------------------------------- PUBLIC ------------------------------------>

	<cffunction name="processPaymentResult" access="public" output="false" returntype="any" hint="process the return data">
		<cfargument name="responseData" type="struct" required="true" />

		<cfscript>
			var Result = createObject('component','cfc.model.payment.PaymentResult').init();
			var Response = createObject('component','cfc.model.Response').init();
			
			Result.setSalesOrderNumber( responseData.salesOrderNumber );

			//	A – Approved D – Denied X – Error
			if (responseData.returnCode eq "A"){

				switch( responseData.transactionType ) {
					case "auth" : {
						Response.setResultCode("PG003");
						break;
					}
					case "capture" : {
						Response.setResultCode("PG001");
						break;
					}
					default : {
						Response.setResultCode("PG002");
						break;
					}
				}

				Result.setAmount( responseData.orderAmount - responseData.amountDue );
				Result.setCCType( 'MilitaryStar' );
				Result.setReceiptNumber( responseData.AuthCode );
				Result.setPaymentToken( responseData.AuthTkt );
				Result.setVerbiage( responseData.ReturnMessage );
				Result.setGUID( responseData.txn_Id );
				Result.setTransactionType( super.translateTransactionType( responseData.TransactionType, Result.getCCType() ) ); //auth|capture

			} else {

				Response.setResultCode('PG002');

			}

			Response.setResult( Result );

			return Response;
		</cfscript>
	</cffunction>

	<cffunction name="buildGatewayFormElements" access="public" returntype="string" output="false">
		<cfargument name="billingAddress" type="cfc.model.Address" required="false" />
		<cfargument name="email" type="string" required="true" />
		<cfargument name="userId" type="string" required="true" />
		<cfargument name="phone" type="string" required="true" />
		<cfargument name="totalPrice" type="numeric" required="true" />
		<cfargument name="salesOrderNumber" type="string" required="true" />
		<cfargument name="backLinkURL" type="string" required="false" default="" />
		<cfargument name="fwdLinkURL" type="string" required="false" default="" />
		<cfargument name="errLinkURL" type="string" required="false" default="" />
		<cfargument name="returnURL" type="string" required="false" />
		<cfargument name="billingOrderAddress" type="cfc.model.OrderAddress" required="false" />
		<cfargument name="trx" type="string" required="false" default="" />
		<cfargument name="guid" type="string" required="false" default="" />
		<cfargument name="shouldCapture" type="boolean" required="false" default="false" />
		<cfargument name="saveToCustomerDB" type="numeric" required="false" default="1" />

		<cfscript>
			var formElements = "";
			var transactionType = "auth";
			var theURL = buildReturnURL();
			var Address = "";
			var stateName = "";

			if( arguments.shouldCapture ) {
				transactionType = "capture";
			}

			if( structKeyExists( arguments, "returnURL") ) {
				theURL = trim(arguments.returnURL);
			}

			if( structKeyExists( arguments, "BillingAddress" ) ) {
				Address = arguments.BillingAddress;
			}
			else if( structKeyExists( arguments, "BillingOrderAddress") ) {
				Address = arguments.BillingOrderAddress;
			}
			
		</cfscript>

		<cfsavecontent variable="formElements">
			<cfoutput>
				<input name="salesOrderNumber" type="hidden" value="#arguments.salesOrderNumber#" />
				<input name="testMode" type="hidden" value="#getIntegrationMode()#" />
				
				<cfif arguments.enablePreAuth or arguments.shouldCapture>
					<input name="gatewayName" type="hidden" value="#getName()#" /> <!--- Tells us which gateway is responsible for processing the response --->
					<input name="transactionType" type="hidden" value="#transactionType#" />
					<input name="msc_facility_id" type="hidden" value="#getMerchantID()#" />
					<input name="msc_amount" type="hidden" value="#decimalFormat(arguments.totalPrice)#" />
					<input name="msc_first_name" type="hidden" value="#Address.getFirstName()#" />
					<input name="msc_last_name" type="hidden" value="#Address.getLastName()#" />
					<input name="msc_company" type="hidden" value="#Address.getCompany()#" />
					<input name="msc_avs_address" type="hidden" value="#Address.getAddressLine1()#" />
					<input name="msc_address2" type="hidden" value="#Address.getAddressLine2()#" />
					<input name="msc_city" type="hidden" value="#Address.getCity()#" />
					<input name="msc_state" type="hidden" value="#Address.getState()#" />
					<input name="msc_avs_zip" type="hidden" value="#Address.getZipCode()#" />
					
					
					<input name="msc_phone" type="hidden" value="#Address.getDayPhone()#" />
					<!---<cfif structKeyExists(session,"currentUser") and session.currentUser.getAuthenticationId() is not "" >
						<input name="cid" type="hidden" value="#session.currentUser.getAuthenticationid()#" />
					</cfif>--->
					<cfif structKeyExists(session,"authenticationId") and session.authenticationid is not "" >
						<input name="cid" type="hidden" value="#session.authenticationId#" />
					</cfif>
					
					<input name="msc_email" type="hidden" value="#arguments.email#" />
					<input name="msc_receipt_link_url" type="hidden" value="#theURL#?gatewayName=#getName()#" />
					<input name="msc_receipt_link_method" type="hidden" value="post" />
					<input name="msc_back_link_url" type="hidden" value="#arguments.backLinkURL#" />
					<input name="msc_fwd_link_url" type="hidden" value="#arguments.fwdLinkURL#" />
					<input name="msc_err_link_url" type="hidden" value="#arguments.errLinkURL#" />
				<cfelse>
					<input name="txnID" type="hidden" value="#arguments.guid#" />
					<input name="amount" type="hidden" value="#arguments.totalPrice#" />
				</cfif>
				
			</cfoutput>
		</cfsavecontent>

		<cfreturn formElements>
	</cffunction>
	
	<cffunction name="capturePayment" access="public" returntype="struct" output="false">
		<cfargument name="txnID" type="string" required="true">
		<cfargument name="amount" type="string" required="true">
		<cfargument name="orderID" type="numeric" required="true">
		
		<cfset var response = "">
		<cfset var integrationMode = getIntegrationMode()>
		
		<cfif integrationMode eq "S">
			 <!--- Override "Simulation" integration mode to "Test". SCINSS does not permit "Simulation" of payment capture. --->
			 <cfset integrationMode = "T">
		</cfif>
		
		<cfhttp method="post" url="#getSettleURL()#" result="response">
			<cfhttpparam type="formfield" name="GatewayName" value="#getName()#">
			<cfhttpparam type="formfield" name="SalesOrderNumber" value="#arguments.orderID#">
			<cfhttpparam type="formfield" name="TestMode" value="#integrationMode#">
			<cfhttpparam type="formfield" name="MscFacilityID" value="#getMerchantID()#">
			<cfhttpparam type="formfield" name="MscAmount" value="#decimalFormat(arguments.amount)#">
			<cfhttpparam type="formfield" name="TxnId" value="#arguments.txnID#">
		</cfhttp>
		
		<cfreturn processCapture( response, arguments.orderID, arguments.amount )>
				
	</cffunction>
	
	<cffunction name="processCapture" access="private" output="false" returntype="cfc.model.Response">
		<cfargument name="HTTPResponse" type="struct" required="true">
		<cfargument name="orderID" type="numeric" required="true">
		<cfargument name="amount" type="numeric" required="true">
		
		<cfscript>
			var Result = createObject('component','cfc.model.payment.PaymentResult').init();
			var Response = createObject('component','cfc.model.Response').init();
			
			var JSON = deserializeJSON( deserializeJSON( arguments.HTTPResponse.fileContent.toString() ) );
		
			Result.setSalesOrderNumber( arguments.orderID );
			
			if( arguments.HTTPResponse.responseHeader.status_code eq 201 ) {
				
				Response.setResultCode("PG001");
				Response.setMessage("Capture successful.");
				
				Result.setAmount( arguments.amount );
				Result.setCCType( 'MilitaryStar' );
				Result.setReceiptNumber( 'Not provided' );
				Result.setPaymentToken( 'Not provided' );
				Result.setVerbiage( JSON.returnMessage );
				Result.setGUID( JSON.txnID );
				Result.setTransactionType( "capture" );
				Result.setTotalAmount( arguments.amount );				
				
			} else {
				
				Response.setResultCode("PG002");
				Response.setMessage("Capture failed. #JSON.returnMessage#");
				
			}
			
			Response.setDetail( serializeJSON( HTTPResponse ) );
			Response.setResult( Result );
			
			return Response;
		</cfscript>
	
	</cffunction>
	
	<cffunction name="getIntegrationMode" access="private" output="false" returntype="string">
		<cfscript>
			/**
			*	SCINSS provides us with 3 integration modes:
			*		T = "Test" - Sends a "test" code to Military Star to allow us to use their test card numbers. Provides user with result of their transaction and requires them to click "continue" to notify us of the payment.
			*		S = "Simulation" - Sends a "test" code to Military Star to allow us to use their test card numbers. Provides asynchronous integration *without* payment receipt page and does not require user interaction to notify us.
			*		P = "Production" - Requires real card numbers. Provides asynchronous integration *without* payment receipt page and does not require user interaction to notify us.
			
			*	NOTE: Simulation occurs when isTestMode() and isAsync() are both set to "true" in our config files. Transactions from one SCINSS environment can not be settled or credited in another environment.
			*/
			
			//Production default
			var integrationMode = "P";

			if( isTestMode() && super.isAsync() ) {
				integrationMode = "S";
			} else if( isTestMode() ) {
				integrationMode = "T";
			}
			
			return integrationMode;
		</cfscript>
	</cffunction>

	<!----------------------------------- GETTERS/SETTERS ------------------------------------>
	<cffunction name="getMerchantID" access="public" output="false" returntype="any">
    	<cfreturn variables.instance["merchantID"]/>
    </cffunction>
    <cffunction name="setMerchantID" access="public" output="false" returntype="void">
    	<cfargument name="theVar" required="true" />
    	<cfset variables.instance["merchantID"] = arguments.theVar />
    </cffunction>
    <cffunction name="isTestMode" access="public" output="false" returntype="boolean">    
    	<cfreturn variables.instance["isTestMode"]/>    
    </cffunction>    
    <cffunction name="setTestMode" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["isTestMode"] = arguments.theVar />    
    </cffunction>
    <cffunction name="getSettleURL" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["settleURL"]/>    
    </cffunction>    
    <cffunction name="setSettleURL" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["settleURL"] = arguments.theVar />    
    </cffunction>

</cfcomponent>