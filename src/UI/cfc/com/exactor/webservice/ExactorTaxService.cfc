<cfcomponent output="false">

	<cffunction name="init" output="false" returntype="any">
		<cfargument name="serviceUrl" type="string" default="http://taxrequest.exactor.com/request/xml" required="false" />		
		<cfset variables.serviceUrl = arguments.serviceUrl />
		<cfreturn this />
	</cffunction>

	<cffunction name="sendTaxRequest" output="false" returntype="any">
		<cfargument name="taxRequest" type="TaxRequest" required="true" />
		<cfargument name="requestType" type="string" required="true" />
	
		<cfscript>
			var taxRequestInXml = "";
			var taxResponseInXml = "";
			var taxResponseAsObject = "";
			var taxResponse = "";
			var errors = [];
			var errorResponse = "";
			var isValidResponse = true;
			
			taxResponseInXml = createTaxRequestXml( arguments.taxRequest, arguments.requestType );
		</cfscript>
		
        
        
		<cfhttp url="#variables.serviceUrl#" 
			method="post"
			throwOnError="yes"
			result="taxResponse">
			<cfhttpparam type="xml" value="#Trim( taxResponseInXml )#" />
		</cfhttp>

		<!--- Throw custom error if response is not valid XML --->
		<cfif NOT IsXML( Trim(taxResponse.Filecontent) )>
			<cfthrow type="ExactorTaxService.InvalidXml" message="Reponse content is invalid XML" />
		</cfif>
		<!--- Throw custom error if error response was returned--->
		<cfset errors = XmlSearch( taxResponse.Filecontent, "/:TaxResponse/:ErrorResponse" ) />
		<cfif ArrayLen(errors) >
			<cfset errorResponse = createErrorResponseFromXml( errors[1] ) />
			<cfthrow type="ExactorTaxService.ResponseError" message="An error response was returned from web service: #errorResponse.getErrorDescription()#" />
		</cfif>
		
		<cfset taxResponseInXml = XmlParse( Trim(taxResponse.Filecontent), false ) />
		<cfset taxResponseAsObject = createTaxResponseFromXml( taxResponseInXml, arguments.requestType ) />
	
		<cfreturn taxResponseAsObject />
	</cffunction>


	<cffunction name="createCommitRequestXml" output="false" returntype="any">
		<cfargument name="commitRequest" type="CommitRequest" required="true" />
		
		<cfscript>
			var commitRequestInXml = "";
		</cfscript>

		<cfsavecontent variable="commitRequestInXml">
			<cfoutput>
				<CommitRequest>
					<CommitDate>#Trim( arguments.commitRequest.getCommitDate() )#</CommitDate>
					<InvoiceNumber>#Trim( arguments.commitRequest.getInvoiceNumber() )#</InvoiceNumber>
					<PriorTransactionId>#Trim( arguments.commitRequest.getPriorTransactionId() )#</PriorTransactionId>
				</CommitRequest>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn Trim(commitRequestInXml) />
	</cffunction>


	<cffunction name="createRefundRequestXml" output="false" returntype="any">
		<cfargument name="refundRequest" type="RefundRequest" required="true" />
		
		<cfscript>
			var refundRequestInXml = "";
		</cfscript>

		<cfsavecontent variable="refundRequestInXml">
			<cfoutput>
				<RefundRequest>
					<RefundDate>#Trim( arguments.refundRequest.getRefundDate() )#</RefundDate>
					<PriorTransactionId>#Trim( arguments.refundRequest.getPriorTransactionId() )#</PriorTransactionId>
				</RefundRequest>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn Trim(refundRequestInXml) />
	</cffunction>


	<cffunction name="createInvoiceRequestXml" output="false" returntype="any">
		<cfargument name="invoiceRequest" type="InvoiceRequest" required="true" />
		
		<cfscript>
			var invoiceRequestInXml = "";
			var item = "";
		</cfscript>

		<cfsavecontent variable="invoiceRequestInXml">
			<cfoutput>		
				<InvoiceRequest>
					<SaleDate>#Trim( arguments.invoiceRequest.getSaleDate() )#</SaleDate>
					<CurrencyCode>#Trim( arguments.invoiceRequest.getCurrencyCode() )#</CurrencyCode>
					<BillTo>
						<FullName>#Trim( arguments.invoiceRequest.getBillTo().getFullName() )#</FullName>
						<Street1>#Trim( arguments.invoiceRequest.getBillTo().getStreet1() )#</Street1>
						<City>#Trim( arguments.invoiceRequest.getBillTo().getCity() )#</City>
						<StateOrProvince>#Trim( arguments.invoiceRequest.getBillTo().getStateOrProvince() )#</StateOrProvince>
						<PostalCode>#Trim( arguments.invoiceRequest.getBillTo().getPostalCode() )#</PostalCode>
						<Country>#Trim( arguments.invoiceRequest.getBillTo().getCountry() )#</Country>
					</BillTo>
					<ShipTo>
						<FullName>#Trim( arguments.invoiceRequest.getShipTo().getFullName() )#</FullName>
						<Street1>#Trim( arguments.invoiceRequest.getShipTo().getStreet1() )#</Street1>
						<City>#Trim( arguments.invoiceRequest.getShipTo().getCity() )#</City>
						<StateOrProvince>#Trim( arguments.invoiceRequest.getShipTo().getStateOrProvince() )#</StateOrProvince>
						<PostalCode>#Trim( arguments.invoiceRequest.getShipTo().getPostalCode() )#</PostalCode>
						<Country>#Trim( arguments.invoiceRequest.getShipTo().getCountry() )#</Country>
					</ShipTo>
					<ShipFrom>
						<FullName>#Trim( arguments.invoiceRequest.getShipFrom().getFullName() )#</FullName>
						<Street1>#Trim( arguments.invoiceRequest.getShipFrom().getStreet1() )#</Street1>
						<City>#Trim( arguments.invoiceRequest.getShipFrom().getCity() )#</City>
						<StateOrProvince>#Trim( arguments.invoiceRequest.getShipFrom().getStateOrProvince() )#</StateOrProvince>
						<PostalCode>#Trim( arguments.invoiceRequest.getShipFrom().getPostalCode() )#</PostalCode>
						<Country>#Trim( arguments.invoiceRequest.getShipFrom().getCountry() )#</Country>
					</ShipFrom>
					<cfloop array="#arguments.invoiceRequest.getLineItem()#" index="item">
						<LineItem id="#Trim( item.getId() )#">
							<SKU>#Trim( item.getSku() )#</SKU>
							<Description>#Trim( XmlFormat( Left( item.getDescription(), 300 ) ) )#</Description>
							<Quantity>#Trim( item.getQuantity() )#</Quantity>
							<GrossAmount>#Trim( item.getGrossAmount() )#</GrossAmount>
						</LineItem>
					</cfloop>
				</InvoiceRequest>
			</cfoutput>			
		</cfsavecontent>
		
		<!---<cfreturn XmlParse( Trim(invoiceRequestInXml), true ) />--->
		<cfreturn Trim(invoiceRequestInXml) />
	</cffunction>


	<!--- TODO: Possibly turn this into a private function --->
	<cffunction name="createTaxRequestXml" output="false" access="public" returntype="xml">
		<cfargument name="taxRequest" type="TaxRequest" required="true" />
		<cfargument name="requestType" type="string" required="true" />
		
		<cfscript>
			var taxRequestInXml = "";
		</cfscript>

		<!--- TODO: Inhierit from base TaxRequest class --->
		<cfsavecontent variable="taxRequestInXml">
			<cfoutput>
				<TaxRequest xmlns="http://www.exactor.com/ns">
					<MerchantId>#Trim( arguments.taxRequest.getMerchantId() )#</MerchantId>
					<UserId>#Trim( arguments.taxRequest.getUserId() )#</UserId>
					<cfif arguments.requestType EQ "invoice">
						#createInvoiceRequestXml( taxRequest.getInvoiceRequest() )#
					</cfif>
					<cfif arguments.requestType EQ "commit">
						#createCommitRequestXml( taxRequest.getCommitRequest() )#
					</cfif>
					<cfif arguments.requestType EQ "refund">
						#createRefundRequestXml( taxRequest.getRefundRequest() )#
					</cfif>					
				</TaxRequest>
			</cfoutput>			
		</cfsavecontent>

		<cfreturn XmlParse( Trim(taxRequestInXml), true ) />
	</cffunction>		


	<cffunction name="createTaxResponseFromXml" output="false" access="public" returntype="TaxResponse">
		<cfargument name="taxResponseInXml" type="any" required="true" />
		<cfargument name="responseType" type="string" required="true" />

		<cfscript>
			var taxResponse = CreateObject( "component", "TaxResponse" ).init();
			var invoiceResponse = "";
			var commitResponse = "";
			var refundResponse = "";
			
			taxResponse.setMerchantId( arguments.taxResponseInXml['TaxResponse']['MerchantId'].XMLText );
			taxResponse.setUserId( arguments.taxResponseInXml['TaxResponse']['UserId'].XMLText );
		
			switch( arguments.responseType )
			{
				case 'invoice':
				{
					invoiceResponse = createInvoiceResponseFromXml( arguments.taxResponseInXml['TaxResponse']['InvoiceResponse'] );	
					taxResponse.setInvoiceResponse( invoiceResponse );
					break;
				}
				case 'commit':
				{
					commitResponse = createCommitResponseFromXml( arguments.taxResponseInXml['TaxResponse']['CommitResponse'] );
					taxResponse.setCommitResponse( commitResponse );
					break;
				}
				case 'refund':
				{
					refundResponse = createRefundResponseFromXml( arguments.taxResponseInXml['TaxResponse']['RefundResponse'] );
					taxResponse.setRefundResponse( refundResponse );
					break;
				}				
			}
		</cfscript>

		<cfreturn taxResponse />
	</cffunction>



	<cffunction name="createInvoiceResponseFromXml" output="false" access="public" returntype="InvoiceResponse">
		<cfargument name="invoiceResponseInXml" type="any" required="true" />
		
        
        
		<cfscript>
			var invoiceResponse = CreateObject( "component", "InvoiceResponse" ).init();
			var lineItem = "";
			var lineItems = [];
			var lineItemXmlNodes = "";
			var i = 0;						
						
			invoiceResponse.setTransactionId( arguments.invoiceResponseInXml['TransactionId'].XMLText  );
			invoiceResponse.setTransactionDate( arguments.invoiceResponseInXml['TransactionDate'].XMLText  );
			invoiceResponse.setSaleDate( arguments.invoiceResponseInXml['SaleDate'].XMLText  );
			invoiceResponse.setCurrencyCode( arguments.invoiceResponseInXml['CurrencyCode'].XMLText  );
			invoiceResponse.setTaxClass( arguments.invoiceResponseInXml['TaxClass'].XMLText  );
			invoiceResponse.setGrossAmount( arguments.invoiceResponseInXml['GrossAmount'].XMLText  );
			invoiceResponse.setTotalTaxAmount( arguments.invoiceResponseInXml['TotalTaxAmount'].XMLText  );
			invoiceResponse.setTaxObligation( arguments.invoiceResponseInXml['TaxObligation'].XMLText  );
			
			//FIXME: This is a brittle hack because XPATH in ColdFusion has case-sensitive issues with nodes
			lineItemXmlNodes = XmlSearch( arguments.invoiceResponseInXml, "*[@id]" );
			
			for (i=1; i <= ArrayLen(lineItemXmlNodes); i++)
			{
				lineItem = CreateObject( "component", "LineItem" ).init();
				lineItem.setGrossAmount( lineItemXmlNodes[i]['GrossAmount'].XMLText );
				lineItem.setTaxDirection( lineItemXmlNodes[i]['TaxDirection'].XMLText );
				lineItem.setTotalTaxAmount( lineItemXmlNodes[i]['TotalTaxAmount'].XMLText );
				lineItem.setId( lineItemXmlNodes[i].XmlAttributes.Id );
				ArrayAppend( lineItems, lineItem );
			}
			
			invoiceResponse.setLineItem( lineItems );
		</cfscript>		
		
        
        
		<cfreturn invoiceResponse />
	</cffunction>
	

	<cffunction name="createCommitResponseFromXml" output="false" access="public" returntype="CommitResponse">
		<cfargument name="commitResponseInXml" type="any" required="true" />

		<cfscript>
			var commitResponse = CreateObject( "component", "CommitResponse" ).init();
			//Parse date from Format 2008-04-01T03:09:50.557-08:00
			var transactionDate = DateFormat( Left( arguments.commitResponseInXml['TransactionDate'].XMLText, 10 ), "yyyy-mm-dd" );
						
			commitResponse.setTransactionId( arguments.commitResponseInXml['TransactionId'].XMLText );
			commitResponse.setTransactionDate( transactionDate );
			commitResponse.setCommitDate( arguments.commitResponseInXml['CommitDate'].XMLText );
			commitResponse.setInvoiceNumber( arguments.commitResponseInXml['InvoiceNumber'].XMLText );
			commitResponse.setPriorTransactionId( arguments.commitResponseInXml['PriorTransactionId'].XMLText );
		</cfscript>		
			
		<cfreturn commitResponse />
	</cffunction>
	

	<cffunction name="createRefundResponseFromXml" output="false" access="public" returntype="RefundResponse">
		<cfargument name="refundResponseInXml" type="any" required="true" />

		<cfscript>
			var refundResponse = CreateObject( "component", "RefundResponse" ).init();
			//Parse date from Format 2008-04-01T03:09:50.557-08:00
			var transactionDate = DateFormat( Left( arguments.refundResponseInXml['RefundDate'].XMLText, 10 ), "yyyy-mm-dd" );
						
			refundResponse.setTransactionId( arguments.refundResponseInXml['TransactionId'].XMLText );
			refundResponse.setTransactionDate( transactionDate );
			refundResponse.setRefundDate( arguments.refundResponseInXml['RefundDate'].XMLText );
			refundResponse.setPriorTransactionId( arguments.refundResponseInXml['PriorTransactionId'].XMLText );
		</cfscript>

		<cfreturn refundResponse />
	</cffunction>

	
	<cffunction name="createErrorResponseFromXml" output="false" access="public" returntype="ErrorResponse">
		<cfargument name="errorResponseInXml" type="any" required="true" />

		<cfscript>
			var errorResponse = CreateObject( "component", "ErrorResponse" ).init();
						
			errorResponse.setLineNumber( arguments.errorResponseInXml['LineNumber'].XMLText );
			errorResponse.setColumnNumber( arguments.errorResponseInXml['ColumnNumber'].XMLText );
			errorResponse.setErrorCode( arguments.errorResponseInXml['ErrorCode'].XMLText );
			errorResponse.setErrorDescription( arguments.errorResponseInXml['ErrorDescription'].XMLText );
		</cfscript>		
			
		<cfreturn errorResponse />
	</cffunction>	

</cfcomponent>