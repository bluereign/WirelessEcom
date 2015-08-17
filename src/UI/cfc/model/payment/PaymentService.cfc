<cfcomponent output="false">
		
	<!--- This method breaks all kinds of rules for encapsulation, but at least this code lives in one place --->
	<cffunction name="getPaymentData" access="public" returntype="struct" output="false">
		
		<cfset var args = structNew() />
		<cfset args.billingAddress = session.checkout.billingAddress />
		<cfset args.shippingAddress = session.checkout.shippingAddress />
		<cfset args.email = session.currentUser.getEmail() />
		<cfset args.userId = session.currentUser.getUserId() />
		<cfset args.phone = session.checkout.billShipForm.billDayPhone />
		<cfset args.totalPrice = (application.model.checkoutHelper.getOrderTotal() - val(session.cart.getDiscountTotal())) />
		<cfset args.salesOrderNumber = application.model.checkoutHelper.getOrderId() />
		<cfset args.enablePreAuth = iif(application.model.checkoutHelper.isWirelessOrder(), de('true'), de('false')) />
		<cfset args.disableTestMode = request.config.disableTestMode />
		<cfset args.testModeType = 'accept' />
		<cfset args.shouldCapture = iif(application.model.checkoutHelper.isWirelessOrder(), de('false'), de('true')) />
		
		<cfreturn args>
	</cffunction> 
	
	<cffunction name="getOrderPaymentData" access="public" returntype="struct" output="false">
		<cfargument name="order" required="true" type="cfc.model.order">
		<cfscript>
			var out = {
				billingOrderAddress = arguments.order.getBillAddress()
				, shippingOrderAddress = arguments.order.getShipAddress()
				, email = arguments.order.getEmailAddress()
				, userID = arguments.order.getUserID()
				, phone = arguments.order.getBillAddress().getDaytimePhone()
				, totalprice = arguments.order.getTotalAfterDiscount()
				, salesOrderNumber = arguments.order.getOrderID()
				, enablePreAuth = false
				, trx = ""
				, guid = ""
				, token = ""
				, transactionSignature = ""
				, receiptNumber = ""
			};
			
			var orderPayments = arguments.order.getPayments();
			
			if( arrayLen( orderPayments ) ) {
				out.trx = orderPayments[1].getCreditCardAuthorizationNumber();
				out.guid = orderPayments[1].getAuthorizationOrigId();
				out.token = orderPayments[1].getPaymentToken();	
			}
			
			return out;
		</cfscript>
	</cffunction>
	
	<cffunction name="getPaymentGatewayIDByName" access="public" output="false" returntype="numeric">
		<cfargument name="name" required="true" type="string">
		
		<cfset var findGateway = "">
		
		<cfquery name="findGateway" datasource="#application.dsn.wirelessAdvocates#">
			SELECT PaymentGatewayId
			FROM [service].PaymentGatewayType
			WHERE Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">
		</cfquery>

		<cfif findGateway.recordCount neq 1>
			<cfthrow type="PaymentService.getPaymentGatewayIDByName.InvalidArgument" message="#arguments.name# is not a valid payment gateway.">
		</cfif>
		
		<cfreturn findGateway.PaymentGatewayId>
	</cffunction>

	<cffunction name="getPaymentGatewayNameById" access="public" output="false" returntype="string">
		<cfargument name="PaymentGatewayId" required="true" type="numeric" />
		
		<cfset var qGateway = "">
		
		<cfquery name="qGateway" datasource="#application.dsn.wirelessAdvocates#">
			SELECT Name
			FROM [service].PaymentGatewayType
			WHERE PaymentGatewayId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PaymentGatewayId#" />
		</cfquery>

		<cfif qGateway.recordCount neq 1>
			<cfthrow type="PaymentService.getPaymentGatewayNameById.InvalidArgument" message="#arguments.PaymentGatewayId# is not a valid payment gateway ID.">
		</cfif>
		
		<cfreturn qGateway.Name />
	</cffunction>	
	
	<cffunction name="getPaymentGatewayByName" access="public" output="false" returntype="any">
		<cfargument name="name" required="true" type="string">
		
		<cfset var beanName = arguments.name & "PaymentGateway">
		
		<cfif getBeanFactory().containsInstance( beanName )>
			<cfreturn getBeanFactory().getInstance( beanName )>
		<cfelse>
			<cfthrow type="PaymentService.getPaymentGatewayByName.InvalidBeanName" message="#beanName# is not a valid bean ID.">
		</cfif>
	</cffunction>
	
	<cffunction name="getPaymentGatewayByID" access="public" output="false" returntype="any">
		<cfargument name="ID" required="true" type="numeric">
		
		<cfset var findGateway = "">
		<cfset var Gateway = "">
		
		<cfquery name="findGateway" datasource="#application.dsn.wirelessAdvocates#">
			SELECT Name + 'PaymentGateway' AS name
			FROM [service].PaymentGatewayType
			WHERE PaymentGatewayId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ID#">
		</cfquery>
		
		<cfif findGateway.recordCount neq 1>
			<cfthrow type="PaymentService.getPaymentGatewayByID.InvalidArgument" message="The ID is not valid.">
		</cfif>
		
		<cfif getBeanFactory().containsInstance( findGateway.Name )>
			<cfreturn getBeanFactory().getInstance( findGateway.Name )>
		<cfelse>
			<cfthrow type="PaymentService.getPaymentGatewayByID.InvalidBeanID" message="#findGateway.Name# is not a valid bean ID.">
		</cfif>	
	</cffunction>
		
	<!---------------------------- GETTERS/SETTERS ------------------------------->
		
	<cffunction name="getBeanFactory" access="public" output="false" returntype="any">    
    	<cfreturn application.WireBox>
    </cffunction>    
	
</cfcomponent>