<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="AttActivationController">
		<cfscript>
			variables.instance = {};
		</cfscript>

		<cfreturn this />
	</cffunction>


	<cffunction name="activateOrder" output="false" access="public" returntype="array">
		<cfargument name="OrderId" type="numeric" required="true" />
		<cfargument name="activationDate" type="date" required="false" />
		
		<cfscript>
			var order = CreateObject('component', 'cfc.model.Order').init();
			var requestHeader = '';
			var customerLookupRequest = '';
			var serviceBusRequest = '';
			var serviceBusReponse = '';
			var creditCheckKeyInfo = '';
			var planDetailList = [];
			var	portInItems = [];
			var orderBillingAddress = '';
			var wirelessLines = '';
			var isPortInSucessful = true;
			var isActivationSuccessful = true;
			//var activationDate = DateFormat( DateAdd( 'd', Now(), 2), 'mm/dd/yyyy' ); //Future activation date
			var carrierTechnologyType = '';
			var results = [];
			var newmdn = '';
			var sbresponse = '';
			var qPlan = '';
			var linesActivationStatuses = [];
			var linesActivatedSuccessfully = 0;
			var itemId = "";


			session.processMessages = [];
			
			serviceBusRequest = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.ServiceBusRequest').init( argumentCollection = request.config.ServiceBusRequest );
			serviceBusRequest.setCarrier( request.config.CarrierServiceBusTarget.Att );
			
			order.load( arguments.OrderId );
			orderBillingAddress = order.getBillAddress();
			wirelessLines = order.getWirelessLines();
			
			requestHeader = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.CarrierRequestHeader').init( argumentCollection = request.config.AttRequestHeader );
			requestHeader.setServiceAreaZip( order.getServiceZipCode() );
			requestHeader.setReferenceNumber( order.getCheckoutReferenceNumber() );
			requestHeader.setConversationId( order.getCarrierConversationId() );
			
			//Build out SubmitOrder
			submitOrderRequest = CreateObject('component', 'cfc.model.carrierservice.Att.SubmitOrderRequest').init();
			submitOrderRequest.setRequestHeader( requestHeader );
		
			submitOrderRequest.setActivationType( order.getActivationType() );


			submitOrderRequest.setFamilyPlan( false );
			submitOrderRequest.setApprovalNumber('');
			submitOrderRequest.setBillingAccountNumber( order.getWirelessAccount().getCurrentAcctNumber() );
			submitOrderRequest.setNewSalesChannel('');
			submitOrderRequest.setPIN( order.getWirelessAccount().getCurrentAcctPIN() );
			submitOrderRequest.setQtySubscriberNumbers( 0 );
			submitOrderRequest.setSSN( '555551234' );

			if ( order.getActivationType() eq 'U' || order.getActivationType() eq 'A' )
			{
 				submitOrderRequest.setServiceZipCode(order.getWirelessAccount().getAccountZipCode() );
			}
			else
			{
				submitOrderRequest.setServiceZipCode( order.getServiceZipCode() );
			}

			//Port In Submit
			portInMdnList = [];

			for (i=1; i <= ArrayLen( wirelessLines ); i++)
			{
				if ( wirelessLines[i].getIsMDNPort() )
				{
					ArrayAppend(portInMdnList, ' ' & wirelessLines[i].getNewMDN()); //Add leading white space for CF8 JSON issue
				}
			}

			//Order details
			orderDetails = [];
			
			for (i=1; i <= ArrayLen(wirelessLines); i++)
			{
				orderDetail = CreateObject('component', 'cfc.model.carrierservice.Att.Common.OrderLine').init();
				
				lineDetail = wirelessLines[i];

				//Account level info
				orderDetail.setTermsConditionStatus( 'W' );
				orderDetail.setAddressLine1( orderBillingAddress.getAddress1() );
				orderDetail.setAddressLine2( orderBillingAddress.getAddress2() );
				orderDetail.setCity( orderBillingAddress.getCity() );
				orderDetail.setState( orderBillingAddress.getState() );
				orderDetail.setZipCode( orderBillingAddress.getZip() );
				orderDetail.setContactFirstName( orderBillingAddress.getFirstName() );
				orderDetail.setContactLastName( orderBillingAddress.getLastName() );
				orderDetail.setHomePhone( orderBillingAddress.getDaytimePhone() );
				orderDetail.setContractTerm( '24' );
				orderDetail.setDepositAmount( '0' );
				orderDetail.setEmailAddress( order.getEmailAddress() );
				orderDetail.setWorkPhone( orderBillingAddress.getDaytimePhone() );
				orderDetail.setWorkPhoneExtension( '' );

				//Line level info
				orderDetail.setServiceArea( order.getServiceZipCode() );
				orderDetail.setSubscriberNumber( wirelessLines[i].getCurrentMdn() );	
				orderDetail.setActivationDate( activationDate );
				orderDetail.setPrimarySubscriber( 'false' );				
				orderDetail.setSuspendImmediate(  false );
				orderDetail.setIMEI( wirelessLines[i].getImei() );
				itemId = lookupItemId(wirelessLines[i]);
				if (len(itemId)) {
					orderDetail.setItemId(itemId);
				}
				orderDetail.setSIM( wirelessLines[i].getSim() );
				
				//orderDetail.setSingleUserPlanCode( 'SDDVRP' );
				
				if ( wirelessLines[i].getLineRateplan().getProductId() )
				{
					qPlan = application.model.Plan.getDetail( wirelessLines[i].getLineRateplan().getProductId() );
					orderDetail.setSingleUserPlanCode( qPlan.CarrierBillCode );
				}
				else
				{
					orderDetail.setSingleUserPlanCode( '' ); //Equipment-only upgrade
				}
				

				carrierTechnologyType = application.model.Phone.getCarrierTechnologyType( wirelessLines[i].getLineDevice().getProductId(), order.getCarrierId() );
				
				//Log error if technology type cannot be determined
				if ( carrierTechnologyType eq '' )
				{
					ArrayAppend( session.processMessages, 'Technology type not found for: ' & wirelessLines[i].getLineDevice().getProductTitle() & ' - ID: ' & wirelessLines[i].getLineDevice().getProductId());
			
				}

				//This needs to be set to UMTS or GSM
				orderDetail.setEquipmentType( 'G' );
				orderDetail.setTechnologyType( carrierTechnologyType );	
	
				orderDetail.setGroupPlanCode( '' ); //TODO: This might be needed to be set for family plans
				orderDetail.setNPARequested( lineDetail.getNPArequested()  );


				if ( lineDetail.getIsMDNPort() )
				{
					orderDetail.setIsMDNPort( true );					
					orderDetail.setPortInCarrierAccount( lineDetail.getPortInCurrentCarrierAccountNumber() ); // PortInCarrierAccount
					orderDetail.setPortInCarrierPin( lineDetail.getPortInCurrentCarrierPin() ); // PortInCarrierPin
					orderDetail.setSubscriberNumber (lineDetail.getNewMDN() );
				}

				//TODO: Get Line Services
				lineServices = wirelessLines[i].getLineServices();
				orderServices = [];
				
				for (j=1; j <= ArrayLen(lineServices); j++)
				{
					orderService = CreateObject('component', 'cfc.model.carrierservice.Att.Common.OrderLineService').init();
					orderService.setOfferingAction( 'A' );
					orderService.setOfferingCode( lineServices[j].getLineService().getCarrierServiceId() );
					
					ArrayAppend(orderServices, orderService);
				}
				
				orderDetail.setServices( orderServices );
			

			ArrayAppend(orderDetails, orderDetail); }
			
			submitOrderRequest.setOrderDetails( orderDetails );

			serviceBusRequest.setAction( 'SubmitOrder' );
			serviceBusRequest.setRequestData( submitOrderRequest );
			serviceBusResponse = application.model.RouteService.Route( serviceBusRequest );
			
			//Handle webservice response
			if (serviceBusResponse.ResponseStatus.ErrorCode eq 0)
			{
			
				sbresponse = deserializeJson(serviceBusResponse.ResponseData);

				//application.model.Util.cfdump(sbresponse);
				//application.model.Util.cfabort();


				if (StructKeyExists(sbresponse, 'ActivationStatus'))
				{
					linesActivationStatuses = sbresponse.ActivationStatus;
					
					for (i=1; i <= ArrayLen(wirelessLines); i++)
					{				
						for (j=1; j <= ArrayLen(linesActivationStatuses); j++)
						{
							if (wirelessLines[i].getCurrentMdn() eq linesActivationStatuses[j].mdn)
							{
								if ( linesActivationStatuses[i].Status eq 'success' )
								{
									wirelessLines[i].setActivationStatus(2); //Success
				  					wirelessLines[i].save();
				  					linesActivatedSuccessfully++;
								}	
								else
								{
									wirelessLines[i].setActivationStatus(4); //Failure
				  					wirelessLines[i].save();
								}
							}
						}
					}
	
					wirelessAccount = order.getWirelessAccount();
					wirelessAccount.setActivationStatusByLineStatus();
					wirelessAccount.save();
	
					if (ArrayLen(wirelessLines) eq linesActivatedSuccessfully)
					{
						order.setStatus(3); //Order ready for weblink
					}
					
					order.save();
					
				}
				
				ArrayAppend( session.processMessages, sbresponse.ResponseStatus.Message );
				ArrayAppend( session.processMessages, '------------------ New Processing Message format ------------------' );
				
				for (i=1; i <= ArrayLen(sbresponse.ProcessingMessages); i++)
				{
					ArrayAppend( session.processMessages, sbresponse.ProcessingMessages[i] );
				}
			}
			else
			{			
				ArrayAppend( session.processMessages, serviceBusResponse.ResponseStatus.ErrorCode & ' - ' & serviceBusResponse.ResponseStatus.Message);
			}
		</cfscript>

		<cfreturn session.processMessages />
	</cffunction>
	
	<cffunction name="lookupItemId" returnType="String" >
		<cfargument name="wl" type="cfc.model.WirelessLine" required="true" />
		
			<cfset var od = "" />
			
			<!--- find the orderdetail from the wirelessLine --->
			<cfset od = createObject("component","cfc.model.OrderDetail").init() />
			<cfset od.load(wl.getOrderDetailId()) />
			
			<cfquery name="qItemId" datasource="wirelessadvocates">
				SELECT cpy1.Value AS 'itemId' 
				FROM catalog.product cp 
				INNER JOIN catalog.property cpy1 
				ON cpy1.productguid = cp.productguid 
				AND cpy1.Name = 'itemId' 
				Where productid = <cfqueryparam cfsqltype="cf_sql_integer" value="#od.getProductId()#" > 
			</cfquery>
			<cfif qItemid.recordCount gt 0>
				<cfreturn qItemid.itemid />
			<cfelse>
				<cfreturn ""/>
			</cfif>
	</cffunction>


	
</cfcomponent>
