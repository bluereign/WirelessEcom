<cfcomponent output="false" displayname="InternetSecurePaymentGateway" extends="AbstractPaymentGateway">

	<!---------------------------------- CONSTRUCTOR ------------------------------------>
			
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="name" required="true" type="string">
		<cfargument name="PaymentProcessorRegistry" required="true" type="any">
		<cfargument name="paymentReturnPath" required="true" type="string">
		<cfargument name="paymentReturnPathRequiresSSL" required="true" type="any">
		<cfargument name="paymentMethods" required="true" type="array">
		<cfargument name="async" required="false" type="boolean" hint="Indicates whether payment details come in a different request than the user." />
		<cfargument name="processingURL" required="true" type="string" />
		<cfargument name="gatewayID" required="true" type="any" />
		<cfargument name="sendCustomerEmailReceipt" required="true" type="string" hint="N=None, A=Approvals only, D=Decines only, Y=all receipts">
		<cfargument name="sendMerchantEmailReceipt" required="true" type="string" hint="N=None, A=Approvals only, D=Decines only, Y=all receipts">
		<cfargument name="appID" required="true" type="any" />
		<cfargument name="transactionKey" required="true" type="any" />

		<cfscript>
			super.init( argumentCollection = arguments );
			
			setGatewayID( arguments.gatewayID );
			setSendCustomerEmailReceipt( arguments.sendCustomerEmailReceipt );
			setSendMerchantEmailReceipt( arguments.sendMerchantEmailReceipt );
			setAppID( arguments.appID );
			setTransactionKey( arguments.transactionKey );
			
			return this;
		</cfscript>
		
	</cffunction>
	
	<!---------------------------------- PUBLIC ------------------------------------>

	<cffunction name="processPaymentResult" access="public" returntype="any" output="false">
		<cfargument name="form" type="struct" required="true" />

		<cfscript>
			var Result = createObject('component','cfc.model.payment.PaymentResult').init();
			var Response = createObject('component','cfc.model.Response').init();
			var resultCode = 'PG003';

			// Orders that are Captured Immediately do not return this field
			if( !structKeyExists( arguments.form, 'xxxTransType') ) {
				resultCode = 'PG001';
				arguments.form.xxxTransType = '00';
			}

			// TODO: Distinquish between Order ID and SalesOrderNumber
			if( structKeyExists( arguments.form, 'xxxMerchantInvoiceNumber') ) {
				Result.setSalesOrderNumber( arguments.form.xxxMerchantInvoiceNumber );
			} else if( structKeyExists( arguments.form, 'orderId') ) {
				Result.setSalesOrderNumber( arguments.form.orderID );
			}

			if( arguments.form.verbage contains 'Authenticated' ||
				arguments.form.verbage contains 'Test Approved' ||
				arguments.form.verbage contains 'Approved' ) {

				Response.setResultCode(resultCode);

				Result.setAmount( arguments.form.amount );
				Result.setCustomerIP( arguments.form.xxxCustomerIP );
				Result.setReceiptNumber( arguments.form.receiptNumber );
				Result.setCCType( translateCCType(arguments.form.xxxCCType) );
				Result.setGUID( arguments.form.guid );
				Result.setVerbiage( arguments.form.verbage );
				Result.setTransactionType( translateTransactionType( arguments.form.xxxTransType, Result.getCCType() ) );
				Result.setPaymentToken( 'ManualTransaction' );

				if( structKeyExists( arguments.form, 'token') ) {
					Result.setPaymentToken( arguments.form.token );
				}

			} else {

				Response.setResultCode('PG002');

			}

			Response.setResult( Result );

			return Response;
		</cfscript>

	</cffunction>

	<!---
	**
	* Note, creating a single line item on checkout for now. Optionally pass in the description.
	**
	--->
	<cffunction name="buildGatewayFormElements" access="public" returntype="string" output="false">
		<cfargument name="billingAddress" type="cfc.model.Address" required="false" />
		<cfargument name="shippingAddress" type="cfc.model.Address" required="false" />
		<cfargument name="email" type="string" required="true" />
		<cfargument name="userId" type="string" required="true" />
		<cfargument name="phone" type="string" required="true" />
		<cfargument name="totalPrice" type="numeric" required="true" />
		<cfargument name="salesOrderNumber" type="string" required="true" />
		<cfargument name="sendCustomerEmailReceipt" type="string" required="false" default="#getSendCustomerEmailReceipt()#" />
		<cfargument name="sendMerchantEmailReceipt" type="string" required="false" default="#getSendMerchantEmailReceipt()#" />
		<cfargument name="returnUrl" type="string" required="false" />
		<cfargument name="description" type="string" required="false" default="" />
		<cfargument name="qty" type="numeric" required="true" default="1" />
		<cfargument name="enablePreAuth" required="false" type="boolean" default="false" />
		<cfargument name="disableTestMode" required="false" type="boolean" default="true" />
		<cfargument name="testModeType" required="false" type="string" default="decline" />
		<cfargument name="billingOrderAddress" type="cfc.model.OrderAddress" required="false" />
		<cfargument name="shippingOrderAddress" type="cfc.model.OrderAddress" required="false" />
		<cfargument name="trx" type="string" required="false" default="" />
		<cfargument name="guid" type="string" required="false" default="" />
		<cfargument name="shouldCapture" type="boolean" required="false" default="false" />
		<cfargument name="saveToCustomerDB" type="numeric" required="false" default="1" />
		
		<cfset var channelConfig = application.wirebox.getInstance("ChannelConfig") >
		
		<cfset var local = structNew() />
		
		<cfif structKeyExists(arguments, 'billingAddress')>
			<cfset local.billingAddress = arguments.billingAddress />
		</cfif>
		<cfif structKeyExists(arguments, 'shippingAddress')>
			<cfset local.shippingAddress = arguments.shippingAddress />
		</cfif>
		<cfif structKeyExists(arguments, 'billingOrderAddress')>
			<cfset local.billingOrderAddress = arguments.billingOrderAddress />
		</cfif>
		<cfif structKeyExists(arguments, 'shippingOrderAddress')>
			<cfset local.shippingOrderAddress = arguments.shippingOrderAddress />
		</cfif>
		<cfset local.email = trim(arguments.email) />
		<cfset local.userId = arguments.userId />
		<cfset local.phone = trim(arguments.phone) />
		<cfset local.totalPrice = NumberFormat(arguments.totalPrice,'.00') />
		<cfset local.description = trim(arguments.description) />
		<cfset local.qty = arguments.qty />
		<cfset local.salesOrderNumber = trim(arguments.salesOrderNumber) />
		<cfset local.sendCustomerEmailReceipt = arguments.sendCustomerEmailReceipt />
		<cfset local.sendMerchantEmailReceipt = arguments.sendMerchantEmailReceipt />
		<cfset local.saveToCustomerDB = arguments.saveToCustomerDB />

		<cfset local.activeDescription = 'Wireless Advocates Order' />

		<cfif len(trim(local.description))>
			<cfset local.activeDescription = trim(local.description) />
		</cfif>
		
		<cfif !structKeyExists( arguments, "returnURL" )>
			<cfset local.returnURL = buildReturnURL()>
		<cfelse>
			<cfset local.returnURL = trim(arguments.returnUrl) />
		</cfif>

		<cfsavecontent variable="local.html">
			<cfoutput>
				<input type="hidden" name="gatewayName" value="InternetSecure" /> <!--- Tells us which gateway is responsible for processing the response --->
				<cfif arguments.enablePreAuth or arguments.shouldCapture>
					<input type="hidden" name="gatewayID" value="#getGatewayID()#" />
					<input type="hidden" name="returnCGI" value="#local.returnURL#" />
					<input type="hidden" name="language" value="English" />
					<input type="hidden" name="xxxMerchantCustomerID" value="#local.userId##local.salesOrderNumber#" />
					<input type="hidden" name="xxxMerchantInvoiceNumber" value="#local.salesOrderNumber#" />
					<input type="hidden" name="xxxCustomerDB" value="#local.saveToCustomerDB#" />

					<cfif structKeyExists(local, 'billingAddress')>
						<input type="hidden" name="xxxName" value="#trim(local.billingAddress.getFirstName())# #trim(local.billingAddress.getLastName())#" />
						<input type="hidden" name="xxxAddress" value="#trim(local.billingAddress.getAddressLine1())# #trim(local.billingAddress.getAddressLine2())# #trim(local.billingAddress.getAddressLine3())#" />
						<input type="hidden" name="xxxCity" value="#trim(local.billingAddress.getCity())#" />
						<input type="hidden" name="xxxState" value="#trim(local.billingAddress.getState())#" />
						<input type="hidden" name="xxxCountry" value="#trim(local.billingAddress.getCountry())#" />
						<input type="hidden" name="xxxZipCode" value="#trim(local.billingAddress.getZipCode())#" />
						<input type="hidden" name="xxxCompany" value="#trim(local.shippingAddress.getCompany())#" />
					</cfif>

					<cfif structKeyExists(local, 'billingOrderAddress')>
						<input type="hidden" name="xxxName" value="#trim(local.billingOrderAddress.getFirstName())# #trim(local.billingOrderAddress.getLastName())#" />
						<input type="hidden" name="xxxAddress" value="#trim(local.billingOrderAddress.getAddress1())# #trim(local.billingOrderAddress.getAddress2())# #trim(local.billingOrderAddress.getAddress3())#" />
						<input type="hidden" name="xxxCity" value="#trim(local.billingOrderAddress.getCity())#" />
						<input type="hidden" name="xxxState" value="#trim(local.billingOrderAddress.getState())#" />
						<input type="hidden" name="xxxCountry" value="US" />
						<input type="hidden" name="xxxZipCode" value="#trim(local.billingOrderAddress.getZip())#" />
						<input type="hidden" name="xxxCompany" value="#trim(local.billingOrderAddress.getCompany())#" />
					</cfif>

					<cfif structKeyExists(local, 'shippingAddress')>
						<input type="hidden" name="xxxShippingName" value="#trim(local.shippingAddress.getName())#" />
						<input type="hidden" name="xxxShippingAddress" value="#trim(local.shippingAddress.getAddressLine1())# #trim(local.shippingAddress.getAddressLine2())# #trim(local.shippingAddress.getAddressLine3())#" />
						<input type="hidden" name="xxxShippingCity" value="#trim(local.shippingAddress.getCity())#" />
						<input type="hidden" name="xxxShippingState" value="#trim(local.shippingAddress.getState())#" />
						<input type="hidden" name="xxxShippingCountry" value="#trim(local.shippingAddress.getCountry())#" />
						<input type="hidden" name="xxxShippingZipCode" value="#trim(local.shippingAddress.getZipCode())#" />
						<input type="hidden" name="xxxShippingPhone" value="#trim(local.shippingAddress.getDayPhone())#" />
						<input type="hidden" name="xxxShippingEmail" value="" />
					</cfif>

					<cfif structKeyExists(local, 'shippingOrderAddress')>
						<input type="hidden" name="xxxShippingName" value="#trim(local.shippingOrderAddress.getFirstName())# #trim(local.shippingOrderAddress.getLastName())#" />
						<input type="hidden" name="xxxShippingAddress" value="#trim(local.shippingOrderAddress.getAddress1())# #trim(local.shippingOrderAddress.getAddress2())# #trim(local.shippingOrderAddress.getAddress3())#" />
						<input type="hidden" name="xxxShippingCity" value="#trim(local.shippingOrderAddress.getCity())#" />
						<input type="hidden" name="xxxShippingState" value="#trim(local.shippingOrderAddress.getState())#" />
						<input type="hidden" name="xxxShippingCountry" value="US" />
						<input type="hidden" name="xxxShippingZipCode" value="#trim(local.shippingOrderAddress.getZip())#" />
						<input type="hidden" name="xxxShippingPhone" value="#trim(local.shippingOrderAddress.getDaytimePhone())#" />
						<input type="hidden" name="xxxShippingEmail" value="" />
					</cfif>

					<input type="hidden" name="xxxEmail" value="#trim(local.email)#" />
					<input type="hidden" name="xxxPhone" value="#trim(local.phone)#" />
					<input type="hidden" name="xxxSendCustomerEmailReceipt" value="#local.sendCustomerEmailReceipt#" />
					<input type="hidden" name="xxxSendMerchantEmailReceipt" value="#local.sendMerchantEmailReceipt#" />
					<cfif not arguments.shouldCapture>
						<cfif !channelConfig.getVFDEnabled()>
							<input type="hidden" name="xxxTransType" value="22" />
						<cfelse>
							<cfif local.totalPrice lte 0 >
								<input type="hidden" name="xxxTransType" value="22" /><!---zero dollar transactions get auth --->
							<cfelse>
								<input type="hidden" name="xxxTransType" value="00" /><!--- Direct Delivery transactions should automatically be captured --->
							</cfif>
						</cfif>
					</cfif>					
					<input type="hidden" name="Products" value="Price::Qty::Code::Description::Flags|#local.totalPrice#::#local.qty#::WA1::#trim(local.activeDescription)#<cfif not arguments.disableTestMode>::{TEST<cfif arguments.testModeType is 'decline'>D</cfif>}</cfif>" />
				<cfelse>
					<input type="hidden" name="xxxRequestMode" value="X" />
					<input type="hidden" name="TRX" value="#trim(arguments.trx)#" />
					<input type="hidden" name="GUID" value="#trim(arguments.guid)#" />
					<input type="hidden" name="Token" value="#trim(arguments.token)#" />
					<input type="hidden" name="TotalPrice" value="#trim(local.totalPrice)#" />
					<input type="hidden" name="xxxMerchantInvoiceNumber" value="#local.salesOrderNumber#" />
					<input type="hidden" name="Products" value="#local.totalPrice#::#local.qty#::WA1::#trim(local.activeDescription)#::" />
				</cfif>
			</cfoutput>
		</cfsavecontent>

		<cfreturn trim(local.html) />
	</cffunction>
	
	<cffunction name="capturePayment" access="public" output="false" returntype="cfc.model.Response">
		<cfargument name="orderID" type="numeric" required="true">
		<cfargument name="xxxRequestMode" type="string" required="true">
		<cfargument name="totalPrice" type="string" required="true">
		<cfargument name="products" type="string" required="true">
		<cfargument name="token" type="string" required="true">

		<cfset var local = structNew()>

		<cfset local.postResult = "">
		
		<cfset local.source = '#getGatewayID()#,#getAppID()#,#arguments.token#,#arguments.totalPrice#,,#getTransactionKey()#'>
		<cfset local.requestData = '<?xml version="1.0" encoding="UTF-8"?><TranxRequest><GatewayID>#getGatewayID()#</GatewayID><Products>#arguments.products#</Products><Token>#arguments.token#</Token><xxxApplicationID>#getAppID()#</xxxApplicationID><TransactionSignature>#signHash(local.source)#</TransactionSignature><xxxTransType>00</xxxTransType><xxxMerchantInvoiceNumber>#arguments.orderID#</xxxMerchantInvoiceNumber></TranxRequest>' />
		
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
				, <cfqueryparam value="#arguments.orderID#" cfsqltype="cf_sql_integer" />
				, <cfqueryparam value="Transmission" cfsqltype="cf_sql_varchar" />
				, <cfqueryparam value="Settle" cfsqltype="cf_sql_varchar" />
				, <cfqueryparam value="#serializeJSON(local)#" cfsqltype="cf_sql_longvarchar" />
			)
		</cfquery>

		<cfhttp method="post" url="#getProcessingURL()#" result="local.postResult">
			<cfhttpparam type="formfield" name="xxxRequestMode" value="#arguments.xxxRequestMode#">
			<cfhttpparam type="formfield" name="xxxRequestData" value="#local.requestData#">
		</cfhttp>
		
		<cfreturn processCapture( local.postResult.fileContent, arguments.orderID )>
	</cffunction>
	
	<!---------------------------------- PRIVATE ------------------------------------>
		
	<cffunction name="processCapture" access="private" output="false" returntype="cfc.model.Response">
		<cfargument name="xmlString" type="string" required="true">
		<cfargument name="orderID" type="numeric" required="true">
		
		<cfscript>
			var xmlResult = "";
			var Response = createObject('component','cfc.model.Response').init();
			var Result = createObject( "component", "cfc.model.payment.PaymentResult" ).init();
			
			Result.setSalesOrderNumber( arguments.orderID );
			
			if( isXML( arguments.xmlString ) ) {
				
				xmlResult = xmlParse( arguments.xmlString );
				
				if( trim(xmlResult['TranxResponse']['ApprovalCode'].xmlText) neq '' && 
					trim(xmlResult['TranxResponse']['ApprovalCode'].xmlText) neq 'NA' && 
					trim(xmlResult['TranxResponse']['Page'].xmlText) eq '90000' ) {
					
					Response.setResultCode("PG001");
					Response.setMessage("Capture successful.");
					
					Result.setAmount( xmlResult['TranxResponse']['xxxAmount'].xmlText );				
					Result.setVerbiage( xmlResult['TranxResponse']['Verbiage'].xmlText );
					Result.setGUID( xmlResult['TranxResponse']['GUID'].xmlText );
					Result.setTransactionType( xmlResult['TranxResponse']['xxxTransType'].xmlText );
					Result.setCustomerIP( xmlResult['TranxResponse']['xxxMerchantIPAddress'].xmlText );
					Result.setReceiptNumber( xmlResult['TranxResponse']['ReceiptNumber'].xmlText );
					Result.setCCType( translateCCType( xmlResult['TranxResponse']['xxxCardType'].xmlText ) );
					Result.setTotalAmount( xmlResult['TranxResponse']['TotalAmount'].xmlText );
					
				} else {
					
					Response.setResultCode("PG002");
					Response.setMessage("Capture failed. #xmlResult['TranxResponse']['Verbiage'].xmlText#");
					Response.setErrorMessage( xmlResult['TranxResponse']['Verbiage'].xmlText );
					
				}
				
				Response.setDetail( xmlResult );
				
			} else {
				
				Response.setResultCode("PG002");
				Response.setMessage("Capture failed. Response from gateway was not XML.");
				Response.setDetail( xmlResult );
				
			}
			
			Response.setResult( Result );
			
			return Response;
		</cfscript>
	</cffunction>
	
	<cffunction name="signHash" access="private" returntype="string" output="true">
		<cfargument name="str" type="string" required="true" />

		<cfset messageDigest = CreateObject("java", "java.security.MessageDigest") />
		<cfset digest = messageDigest.getInstance("SHA512") />

		<cfset result = digest.digest(str.getBytes()) />
		<cfset resultStr = ToBase64(result) />

		<cfreturn resultStr />
	</cffunction>
	
	<!---------------------------------- GETTERS/SETTERS ------------------------------------>
		
	<cffunction name="getGatewayID" access="public" output="false" returntype="numeric">    
    	<cfreturn variables.instance["gatewayID"]/>    
    </cffunction>    
    <cffunction name="setGatewayID" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["gatewayID"] = arguments.theVar />    
    </cffunction>
    
	<cffunction name="getSendCustomerEmailReceipt" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["sendCustomerEmailReceipt"]/>    
    </cffunction>    
    <cffunction name="setSendCustomerEmailReceipt" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["sendCustomerEmailReceipt"] = arguments.theVar />    
    </cffunction>
    
	<cffunction name="getSendMerchantEmailReceipt" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["sendMerchantEmailReceipt"]/>    
    </cffunction>    
    <cffunction name="setSendMerchantEmailReceipt" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["sendMerchantEmailReceipt"] = arguments.theVar />    
    </cffunction>
    
	<cffunction name="getAppID" access="public" output="false" returntype="any">    
    	<cfreturn variables.instance["appID"]/>    
    </cffunction>    
    <cffunction name="setAppID" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["appID"] = arguments.theVar />    
    </cffunction>
    
	<cffunction name="getTransactionKey" access="public" output="false" returntype="any">    
    	<cfreturn variables.instance["transactionKey"]/>    
    </cffunction>    
    <cffunction name="setTransactionKey" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["transactionKey"] = arguments.theVar />    
    </cffunction>
    
</cfcomponent>
