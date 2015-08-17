<cfcomponent output="false" extends="AbstractPaymentGateway">
	
	<cfproperty name="GeoService" inject="id:GeoService" />
	
	<!-------------------------------- CONSTRUCTOR ---------------------------------->
	
	<cffunction name="init" access="public" returntype="VirtualMerchantPaymentGateway" output="false">
		<cfargument name="name" required="true" type="string">
		<cfargument name="merchantID" required="true" type="string" hint="ssl_merchant_id">
		<cfargument name="userID" required="true" type="string" hint="ssl_user_id (case sensitive)">
		<cfargument name="PIN" required="true" type="string" hint="ssl_pin (case sensitive)">
		<cfargument name="processingURL" required="true" type="string" hint="VirtualMerchant processing URL.">
		<cfargument name="async" required="false" type="boolean" hint="Indicates whether payment details come in a different request than the user.">
		
		<cfscript>
			super.init( argumentCollection=arguments );
			
			setMerchantID( arguments.merchantID );
			setUserID( arguments.userID );
			setPIN( arguments.PIN );
			
			return this;
		</cfscript>
				
	</cffunction>

	<!----------------------------------- PUBLIC ------------------------------------>
	
	<cffunction name="processPaymentResult" access="public" returntype="any" output="false">
		<cfargument name="responseData" type="struct" required="true" />

		<cfscript>
			var Result = createObject('component','cfc.model.payment.PaymentResult').init();
			var Response = createObject('component','cfc.model.Response').init();
			
			Result.setSalesOrderNumber( responseData.salesOrderNumber );
			
			// ssl_result will be 0 if transaction was successful
			if( responseData.ssl_result eq 0 ) {
				
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
				
				Result.setAmount( numberFormat( responseData.ssl_amount - responseData.ssl_account_balance, "9.99" ) );
				Result.setCCType( "Unknown" ); //This gateway doesn't provide it
				Result.setGUID( responseData.ssl_txn_id );
				Result.setVerbiage( responseData.ssl_result_message );
				Result.setTransactionType( translateTransactionType( responseData.transactionType ) );
				Result.setPaymentToken( "" );
				Result.setReceiptNumber( responseData.ssl_approval_code );
				
			} else {
				
				Response.setResultCode("PG002");
				
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
		<cfargument name="returnURL" type="string" required="false" />
		<cfargument name="description" type="string" required="false" default="" />
		<cfargument name="qty" type="numeric" required="true" default="1" />
		<cfargument name="enablePreAuth" required="false" type="boolean" default="false" />
		<cfargument name="disableTestMode" required="false" type="boolean" default="true" />
		<cfargument name="testModeType" required="false" type="string" default="decline" />
		<cfargument name="billingOrderAddress" type="cfc.model.OrderAddress" required="false" />
		<cfargument name="trx" type="string" required="false" default="" />
		<cfargument name="guid" type="string" required="false" default="" />
		<cfargument name="shouldCapture" type="boolean" required="false" default="false" />
		<cfargument name="saveToCustomerDB" type="numeric" required="false" default="1" />
		
		<cfscript>
			var formElements = "";
			var transactionType = "auth";
			var URL = buildReturnURL();
			var Address = "";
			var stateName = "";
			var	merchantTxnType = "ccauthonly";
		
			if( arguments.shouldCapture ) {
				transactionType = "capture";
				merchantTxnType = "ccforce";
			}
			
			if( structKeyExists( arguments, "returnURL") ) {
				URL = trim(arguments.returnURL);
			}
			
			if( structKeyExists( arguments, "BillingAddress" ) ) {
				Address = arguments.BillingAddress;
			} 
			else if( structKeyExists( arguments, "BillingOrderAddress") ) {
				Address = arguments.BillingOrderAddress;
			}
			
			stateName = GeoService.findStateName( Address.getState() );
		</cfscript>	
		
		<cfsavecontent variable="formElements">
			<cfoutput>
				<!--- Custom fields --->
				<input name="gatewayName" type="hidden" value="VirtualMerchant" /> <!--- Tells us which gateway is responsible for processing the response --->
				<input name="transactionType" type="hidden" value="#transactionType#" />
				<input name="salesOrderNumber" type="hidden" value="#arguments.salesOrderNumber#" />
				
				<!--- Standard fields --->
				<cfif transactionType eq "auth">
					
					<input name="ssl_show_form" type="hidden" value="true" />
					<input name="ssl_merchant_id" type="hidden" value="#getMerchantID()#" />
					<input name="ssl_user_id" type="hidden" value="#getUserID()#" />
					<input name="ssl_pin" type="hidden" value="#getPIN()#" />
					<input name="ssl_transaction_type" type="hidden" value="#merchantTxnType#" />
					<input name="ssl_amount" type="hidden" value="#arguments.totalPrice#" />
					
					<input name="ssl_first_name" type="hidden" value="#Address.getFirstName()#" />
					<input name="ssl_last_name" type="hidden" value="#Address.getLastName()#" />
					<input name="ssl_company" type="hidden" value="#Address.getCompany()#" />
					<input name="ssl_avs_address" type="hidden" value="#Address.getAddressLine1()#" />
					<input name="ssl_address2" type="hidden" value="#Address.getAddressLine2()#" />
					<input name="ssl_city" type="hidden" value="#Address.getCity()#" />
					<input name="ssl_state" type="hidden" value="#stateName#" />
					<input name="ssl_avs_zip" type="hidden" value="#Address.getZipCode()#" />
					<input name="ssl_phone" type="hidden" value="#Address.getDayPhone()#" />
					
					<input name="ssl_email" type="hidden" value="#arguments.email#" />
					<input name="ssl_receipt_link_url" type="hidden" value="#URL#" />
					<input name="ssl_receipt_link_method" type="hidden" value="post" />
				
				<cfelseif transactionType eq "capture">
					
					<input name="approvalCode" type="hidden" value="#arguments.trx#" />
					<input name="amount" type="hidden" value="#arguments.totalPrice#" />
					
				</cfif>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn formElements>
	</cffunction>
	
	<cffunction name="capturePayment" access="public" returntype="struct" output="false">
		<cfargument name="approvalCode" type="string" required="true">
		<cfargument name="amount" type="string" required="true">
		<cfargument name="orderID" type="numeric" required="true">
		
		<cfset var postResult = "">
		<cfset var xmlResponse = "">
		
		<cfhttp method="post" url="#getProcessingURL()#" result="xmlResponse">
			<cfhttpparam type="formfield" name="ssl_approval_code" value="#arguments.approvalCode#">
			<cfhttpparam type="formfield" name="ssl_amount" value="#arguments.amount#">
			<cfhttpparam type="formfield" name="ssl_show_form" value="false">
			<cfhttpparam type="formfield" name="ssl_transaction_type" value="ccforce">
			<cfhttpparam type="formfield" name="ssl_merchant_id" value="#getMerchantID()#">
			<cfhttpparam type="formfield" name="ssl_user_id" value="#getUserID()#">
			<cfhttpparam type="formfield" name="ssl_pin" value="#getPIN()#">
		</cfhttp>

		<cfreturn processCapture( xmlResponse, arguments.orderID )>
				
	</cffunction>
	
	<cffunction name="processCapture" access="private" output="false" returntype="cfc.model.Response">
		<cfargument name="xmlString" type="string" required="true">
		<cfargument name="orderID" type="numeric" required="true">
		
		<cfscript>
			var Result = createObject('component','cfc.model.payment.PaymentResult').init();
			var Response = createObject('component','cfc.model.Response').init();
		
			Result.setSalesOrderNumber( arguments.orderID );
		
			if( postResult.ssl_result eq 0 ) {
				
				Response.setResultCode("PG001");
				Response.setMessage("Capture successful. Transaction placed into current unsettled batch.");
				
				Result.setAmount( postResult.ssl_amount );
				Result.setVerbiage( postResult.ssl_result_message );
				Result.setGUID( postResult.ssl_txn_id );
				Result.setReceiptNumber( postResult.ssl_approval_code );
				Result.setTransactionType( "capture" );
				
			} else {
				
				Response.setResultCode("PG002");
				Response.setMessage("Capture failed. #postResult.errorMessage#");
				
			}
			
			Response.setDetail( serializeJSON( postResult ) );
			Response.setResult( Result );
			
			return Response;
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
    
    <cffunction name="getUserID" access="public" output="false" returntype="any">    
    	<cfreturn variables.instance["userID"]/>    
    </cffunction>    
    <cffunction name="setUserID" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["userID"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getPIN" access="public" output="false" returntype="any">    
    	<cfreturn variables.instance["PIN"]/>    
    </cffunction>    
    <cffunction name="setPIN" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["PIN"] = arguments.theVar />    
    </cffunction>
	
</cfcomponent>