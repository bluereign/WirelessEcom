<cfcomponent output="false" displayname="TaxCalculator" >

	<cffunction name="init" returntype="TaxCalculator">
		<cfargument name="MerchantId" type="string" required="true" />
		<cfargument name="UserId" type="string" required="true" />
		<cfargument name="TaxServiceUrl" type="string" required="true" />
		<cfargument name="ShipFromAddress" type="cfc.model.Address" required="true" />
		
		<cfscript>
			variables.instance.exactorService = CreateObject( "component", "cfc.com.exactor.webservice.ExactorTaxService").init( arguments.TaxServiceUrl );		
			variables.MERCHANT_ID = arguments.MerchantId;
			variables.USER_ID = arguments.UserId;
			variables.ShipFromAddress = arguments.ShipFromAddress;
		</cfscript>
		 
		<cfreturn this />
	</cffunction>
 
 	<cffunction name="calculateTax" returntype="cfc.model.Response">
		<cfargument name="billToAddress" type="cfc.model.Address" required="true" />
        <cfargument name="shipToAddress" type="cfc.model.Address" required="true" />
        <cfargument name="shipFromAddress" type="cfc.model.Address" default="#variables.ShipFromAddress#" required="false" />
		<cfargument name="items" type="array" required="true" />
        <cfargument name="resultCode" type="string" default="" required="false" />
        <cfargument name="saleDate" type="date" default="#DateFormat(Now(), "yyyy-mm-dd")#" required="false" />
        <cfargument name="currencyCode" type="string" default="USD" required="false" />
		<cfargument name="cartItems" type="cfc.model.cartItem[]" required="false" />
        
		<cfset local.myResponse = createobject('component','cfc.model.Response').init() />
		<cfset local.items = arguments.items>
        
        <cfif Len(arguments.resultCode) eq 0>
			
			<cfscript>
				//Only run tax calculation if items exist
				if ( ArrayLen( local.items ) )
				{
					//Use Exactor tax service to calculate taxes
					local.myResponse = calculateTaxWithExactor( argumentCollection = arguments );
				}
				else
				{
					//TODO: handle errors. 			
				}
				
				//TODO: handle errors.
				
			</cfscript>
        <cfelse>
        	<!--- else return test data in Reponse object based on the resultCode passed --->

            <cfswitch expression="#arguments.resultCode#">
				<cfcase value="TC001">
                	<!--- Tax calculated --->
                    <cfset local.myResponse.setResultCode("TC001")>
                    
					<!--- return a calculation for each line passed in --->
                    <cfset local.result.lines = arrayNew(1)>
                    <cfset local.result.TotalTaxAmount = 0>
					<cfloop from="1" to="#ArrayLen(arguments.lines)#" index="i">
                    	<cfset local.result.lines[i] = structNew()>
                        <cfset local.result.lines[i].GrossAmount = arguments.lines[i].GrossAmount>
                        <cfset local.result.lines[i].TaxAmount = 0.80>
                        <cfset local.result.TotalTaxAmount = local.result.TotalTaxAmount + local.result.lines[i].TaxAmount>
                    </cfloop>
					
                </cfcase>
                
                <cfcase value="TC002">
                	<!--- One or more lines failed. --->
                    <cfset local.myResponse.setResultCode("TC002")>
                    <cfset local.result = {}>
                    
                </cfcase>
                
                <cfcase value="TC010">
                	<!--- Invalid Request --->
                    <cfset local.myResponse.setResultCode("TC010")>
                    <cfset local.result = {}>
                </cfcase>
                
                <cfcase value="TC011">
                	<!--- Unable to Connect to Carrier Service --->
                    <cfset local.myResponse.setResultCode("TC011")>
                    <cfset local.result = {}>
                </cfcase>
                
                <cfcase value="TC012">
                	<!--- Service Timeout --->
                    <cfset local.myResponse.setResultCode("TC012")>
                    <cfset local.result = {}>
                </cfcase>
                                
                
                <cfdefaultcase>
					<!--- TODO: error code not implemented,  throw exception ---->
                    <cfthrow message="ResultCode passed in is not defined.">
            	</cfdefaultcase>
            </cfswitch>
			
            <!--- attach result to the response --->
            <cfset local.myResponse.setResult(local.result)>

        </cfif>		
		
  		<cfreturn local.myResponse />
    </cffunction>
	
	<cffunction name="calculateTaxWithExactorB" returntype="any">
    	<cfargument name="cartItems" type="cfc.model.cartItem[]" required="false" />
    	<cfdump var="cart: #arguments.cartItems#"><cfabort>
    </cffunction>
	
 	<cffunction name="calculateTaxWithExactor" returntype="cfc.model.Response">
		<cfargument name="billToAddress" type="cfc.model.Address" required="true" />
        <cfargument name="shipToAddress" type="cfc.model.Address" required="true" />
        <cfargument name="shipFromAddress" type="cfc.model.Address" required="true" />
		<cfargument name="items" type="array" required="true" />
        <cfargument name="saleDate" type="date" default="#DateFormat(Now(), "yyyy-mm-dd")#" required="false" />
        <cfargument name="currencyCode" type="string" default="USD" required="false" />
        <cfargument name="cartItems" type="cfc.model.cartItem[]" required="false" />
        
		<cfscript>
			var local = {};
			var response = Createobject( "component", "cfc.model.Response" ).init();
			var taxRequest = CreateObject( "component", "cfc.com.exactor.webservice.TaxRequest" ).init();
			var invoiceRequest = CreateObject( "component", "cfc.com.exactor.webservice.InvoiceRequest" ).init();

			var lineItems = [];
			var lineItem = "";
			var taxResponse = "";
			var taxResponseLineItems = [];
			var i = 0;
			var j = 0;
			var productIds = [];
			var taxableAmount = 0;
			var instantRebates = [];
			var promotions = [];
			
			//FIXME: Won't compile var declaration of variables
			local.billToAddress = CreateObject( "component", "cfc.com.exactor.webservice.Address" ).init();
			local.shipToAddress = CreateObject( "component", "cfc.com.exactor.webservice.Address" ).init();
			local.shipFromAddress = CreateObject( "component", "cfc.com.exactor.webservice.Address" ).init();			

			local.billToAddress.setFullName( arguments.billToAddress.getFirstName() & " " & arguments.billToAddress.getLastName() );
			local.billToAddress.setStreet1( arguments.billToAddress.getAddressLine1() );
			local.billToAddress.setCity( arguments.billToAddress.getCity() );
			local.billToAddress.setStateOrProvince( arguments.billToAddress.getState() );
			local.billToAddress.setPostalCode( arguments.billToAddress.getZipCode() );
			local.billToAddress.setCountry( arguments.billToAddress.getCountry() );	

			local.shipToAddress.setFullName( arguments.shipToAddress.getFirstName() & " " & arguments.shipToAddress.getLastName() );
			local.shipToAddress.setStreet1( arguments.shipToAddress.getAddressLine1() );
			local.shipToAddress.setCity( arguments.shipToAddress.getCity() );
			local.shipToAddress.setStateOrProvince( arguments.shipToAddress.getState() );
			local.shipToAddress.setPostalCode( arguments.shipToAddress.getZipCode() );
			local.shipToAddress.setCountry( arguments.shipToAddress.getCountry() );
			
			local.shipFromAddress.setFullName( arguments.shipFromAddress.getFirstName() & " " & arguments.shipFromAddress.getLastName() );
			local.shipFromAddress.setStreet1( arguments.shipFromAddress.getAddressLine1() );
			local.shipFromAddress.setCity( arguments.shipFromAddress.getCity() );
			local.shipFromAddress.setStateOrProvince( arguments.shipFromAddress.getState() );
			local.shipFromAddress.setPostalCode( arguments.shipFromAddress.getZipCode() );
			local.shipFromAddress.setCountry( arguments.shipFromAddress.getCountry() );

			//TODO: Use future taxable attribute to check which items to send to tax service
			
			//Create lineItems from item array
			for (i=1; i<=ArrayLen( arguments.items ); i++)
			{
				lineItem = CreateObject( "component", "cfc.com.exactor.webservice.LineItem" ).init();
				lineItem.setId( i );
				lineItem.setQuantity( 1 );
				if (structKeyExists(arguments.items[i],"SKU")) {
					lineItem.setSKU( arguments.items[i].SKU ); // Overridden with getProductGersSkuInfo for most items
				}

				//Determine taxable amount based on state rules
				if (not structkeyExists(arguments.items[i],"COGS")) {
					arguments.items[i].COGS = 0.00; // default cogs to 0.00
				}
				taxableAmount = getTaxableAmount( arguments.items[i], arguments.shipToAddress.getState() );
				lineItem.setGrossAmount( taxableAmount );
				
				//Determine if this item is an instant rebate
				if(arguments.items[i].productId eq -1337) {
					ArrayAppend(instantRebates, lineItem);
				} else if (arguments.items[i].productId eq -1338 ){
					ArrayAppend(promotions, lineItem);
				} else {
					ArrayAppend(lineItems, lineItem);
					// Collect product Ids for Gers query
					ArrayAppend( productIds, items[i].ProductId );
				}
				
			}
			
			//Update line items with GersSku information (except instant rebate)
			qProducts = getProductGersSkuInfo( productIds );
					
			//If the query count does not match the count of line items then at least 1 Product ID was not valid
			if ( qProducts.RecordCount EQ ArrayLen( lineItems ) )
			{
				for (i=1; i<=ArrayLen( lineItems ); i++)
				{
					lineItems[i].setSku( qProducts['GersSku'][i] );
					lineItems[i].setDescription( qProducts['Description'][i] );
				}
				
				//Merge rebates back into line items
				for( i=1; i<=ArrayLen( instantRebates ); i++ ) 
				{
					instantRebates[i].setDescription( 'MIR CONVRSN TO INSTANT RBT');
					ArrayAppend( lineItems, instantRebates[i] );
				}
				
				//Merge promotions back 
				for( i=1; i <=Arraylen( promotions ); i++ )
				{
					promotions[i].setDescription('PROMO/COUPON CODE');
					ArrayAppend( lineItems, promotions[i] );
				}
			}
			
			//Ensure instant rebates appear after the devices for which they apply
			lineItems = sortLineItems(lineItems);

			invoiceRequest.setSaleDate( DateFormat(arguments.saleDate, "yyyy-mm-dd" ) );
			invoiceRequest.setCurrencyCode( arguments.currencyCode );
			invoiceRequest.setBillTo( local.billToAddress );
			invoiceRequest.setShipTo( local.shipToAddress );
			invoiceRequest.setShipFrom( local.shipFromAddress );
			invoiceRequest.setLineItem( lineItems );

			taxRequest.setMerchantId( variables.MERCHANT_ID );
			taxRequest.setUserId( variables.USER_ID );
			taxRequest.setInvoiceRequest( invoiceRequest );
		</cfscript>
		
		<cftry>
			<cfscript>
				local.result = structnew();
								
				taxResponse = variables.instance.exactorService.sendTaxRequest( taxRequest, "Invoice" );
				local.result.taxResponseLineItems = taxResponse.getInvoiceResponse().getLineItem();
			</cfscript>
			
            <cfif isDefined("arguments.cartItems")>
            	<!--- TODO: this is horrible --->
				<cfset this.updateCartItemTaxes( arguments.cartItems, local.result.taxResponseLineItems ) >
                <cfset session.cart.setSalesTaxTransactionId( taxResponse.getInvoiceResponse().getTransactionId() ) >
			</cfif>
            
			<cfscript>	
				//TODO: Move this out of this object
				local.result.SalesTaxTransactionId = taxResponse.getInvoiceResponse().getTransactionId();
				
				response.setResult( local.result );
				response.setResultCode( "TC001" );					
			</cfscript>
			
			<cfcatch type="COM.Allaire.ColdFusion.HTTPFailure">
				<cfset response.setResult( "Connection Failure" ) />
				<cfset response.setResultCode( "TC011" ) />
			</cfcatch>
			<cfcatch type="ExactorTaxService.ResponseError">
				<cfset response.setResult( "Response error returned" ) />
				<cfset response.setResultCode( "TC002" ) />
			</cfcatch>				
			<cfcatch type="ExactorTaxService.InvalidXml">
				<cfset response.setResult( "Invalid XML" ) />
				<cfset response.setResultCode( "TC002" )>
			</cfcatch>
		</cftry>		
		
		<cfreturn response />
	</cffunction>


	
	<!--- TODO: Relocate this function to appropirate Gateway CFC --->
	<cffunction name="getProductGersSkuInfo" output="false" access="public" returntype="query">
		<cfargument name="productIds" type="array" required="true" /> 
		<cfset var qProducts = 0 />
		<cfset var i = 0 />
		
		<cfquery name="qProducts" datasource="#application.dsn.wirelessAdvocates#">
			<cfloop from="1" to="#ArrayLen( arguments.ProductIds )#" index="i">
				<cfif i GT 1>UNION</cfif>
				SELECT 
					#i# RowOrder
					, p.ProductId
					, g.GersSku
					, g.Description
				FROM catalog.Product p
				LEFT JOIN catalog.GersItm g ON g.GersSku = p.GersSku
				WHERE ProductId	= <cfqueryparam value="#arguments.ProductIds[i]#" /> 		
			</cfloop>
			ORDER BY RowOrder
		</cfquery>
	
		<cfreturn qProducts />
	</cffunction>


	<cffunction name="updateCartItemTaxes" output="false" access="public" returntype="void">
		<cfargument name="cartItems" type="cfc.model.CartItem[]" required="true" />
		<cfargument name="lineItems" type="cfc.com.exactor.webservice.LineItem[]" required="true" />
		
		<cfscript>
			var i = 0;
						
			//Only update cart items if array length matches returned line items
			if ( ArrayLen( arguments.lineItems ) EQ ArrayLen( arguments.cartItems ) )
			{
				
				//TODO: Compare product SKU or ID
				for (i=1; i <= ArrayLen( arguments.cartItems ); i++)
				{
					arguments.cartItems[i].getTaxes().setDueToday( arguments.lineItems[i].getTotalTaxAmount() );
				}
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="getTaxableAmount" output="false" access="public" returntype="numeric">
		<cfargument name="item" type="struct" required="true" />
		<cfargument name="state" type="string" required="true" />
		<cfset var taxableAmount = 0 />
		<cfset var comparableAmount = 0 />

		<cfscript>
			
			switch ( arguments.state )
			{
				case 'CA':
				{
					//Get the lower value between Net Price and Retail Price
					if ( arguments.item.NET LTE arguments.item.Retail )
					{
						comparableAmount = arguments.item.NET;
					}
					else
					{
						comparableAmount = arguments.item.Retail;
					}					
					//If price is less than COGS then send in COGS x 118%
					if ( comparableAmount LT arguments.item.COGS )
					{
						taxableAmount =  arguments.item.COGS * 1.18;
					}
					else
					{
						taxableAmount = comparableAmount;
					}					
					break;
				}
				default: 
				{
					//Tax the lower value between Net Price and Retail Price
					if ( arguments.item.NET LTE arguments.item.Retail )
					{
						taxableAmount = arguments.item.NET;
					}
					else
					{
						taxableAmount = arguments.item.Retail;
					}
					
					break;
				}
			}
		</cfscript>

		<cfreturn taxableAmount />
	</cffunction>


	<cffunction name="commitTaxTransaction" output="false" access="public" returntype="void">
		<cfargument name="CommitDate" type="date" required="true" />
		<cfargument name="InvoiceNumber" type="string" required="true" />
		<cfargument name="PriorTransactionId" type="string" required="true" />
	
		<cfscript>
			var taxRequest = CreateObject( "component", "cfc.com.exactor.webservice.TaxRequest" ).init();
			var commitRequest = CreateObject( "component", "cfc.com.exactor.webservice.CommitRequest" ).init();
			
			commitRequest.setCommitDate( DateFormat(arguments.CommitDate, "yyyy-mm-dd" ) );
			commitRequest.setInvoiceNumber( arguments.InvoiceNumber );
			commitRequest.setPriorTransactionId( arguments.PriorTransactionId );
			
			taxRequest.setMerchantId( variables.MERCHANT_ID );
			taxRequest.setUserId( variables.USER_ID );
			taxRequest.setCommitRequest( commitRequest );	

			variables.instance.exactorService.sendTaxRequest( taxRequest, "commit" );
		</cfscript>
	</cffunction>


	<cffunction name="refundTaxTransaction" output="false" access="public" returntype="cfc.com.exactor.webservice.TaxResponse">
		<cfargument name="order" type="cfc.model.Order" required="true" />
		<cfargument name="RefundDate" type="date" required="true" />
	
		<cfscript>
			var taxRequest = CreateObject( "component", "cfc.com.exactor.webservice.TaxRequest" ).init();
			var refundRequest = CreateObject( "component", "cfc.com.exactor.webservice.RefundRequest" ).init();
			var taxResponse = "";
			
			refundRequest.setRefundDate( DateFormat(arguments.RefundDate, "yyyy-mm-dd" ) );
			refundRequest.setPriorTransactionId( arguments.order.getSalesTaxTransactionId() );
			
			taxRequest.setMerchantId( variables.MERCHANT_ID );
			taxRequest.setUserId( variables.USER_ID );
			taxRequest.setRefundRequest( refundRequest );

			taxResponse = variables.instance.exactorService.sendTaxRequest( taxRequest, "refund" );
		</cfscript>
		
		<cfreturn taxResponse />
	</cffunction>
	
	<cffunction name="sortLineItems" access="private" output="false" returntype="array">
		<cfargument name="aOfS" required="true" type="array">
		<cfargument name="sortOrder" required="false" default="asc">
		<cfargument name="sortType" required="false" default="numeric">
		<cfargument name="delim" required="false" default=".">
		
		<cfscript>
			var sortArray = [];
			var arrOut = [];
			var count = arrayLen(arguments.aOfS);
			var i = 1;
			
			for(i=1; i <= count; i++) {
				sortArray[i] = arguments.aOfS[i].getID() & arguments.delim & i;
			}
			
			arraySort( sortArray, arguments.sortType, arguments.sortOrder );
			
			for(i=1; i <= count; i++) {
				arrOut[i] = arguments.aOfS[listLast(sortArray[i],arguments.delim)];
			}
				
			return arrOut;
		</cfscript>
	</cffunction>

</cfcomponent>