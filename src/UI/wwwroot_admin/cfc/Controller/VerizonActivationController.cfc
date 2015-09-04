<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="VerizonActivationController">
		<cfargument name="IsDeviceInfoFinal" type="boolean" required="true" />
		
		<cfscript>
			variables.instance = {};
			variables.instance.IsDeviceInfoFinal = arguments.IsDeviceInfoFinal;
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
			var featureLists = [];
			var contractIndex = 0;
			
			session.processMessages = [];

			//application.model.Util.cfdump( variables.instance.IsDeviceInfoFinal );
			//application.model.Util.cfabort();
			
			
			serviceBusRequest = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.ServiceBusRequest').init( argumentCollection = request.config.ServiceBusRequest );
			serviceBusRequest.setCarrier( request.config.CarrierServiceBusTarget.Verizon );
			
			order.load( arguments.OrderId );
			orderBillingAddress = order.getBillAddress();
			wirelessLines = order.getWirelessLines();
			
			requestHeader = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.CarrierRequestHeader').init( argumentCollection = request.config.VerizonRequestHeader );
			requestHeader.setServiceAreaZip( order.getServiceZipCode() );
			requestHeader.setReferenceNumber( order.getCheckoutReferenceNumber() );
			
			creditCheckKeyInfo = CreateObject('component', 'cfc.model.carrierservice.Verizon.common.CreditCheckKeyInfo').init();
			creditCheckKeyInfo.load( order.getCreditCheckKeyInfoId() );
			
			
			// CreditRead
			/*
				02050	Missing Driver License Info
				02051	Pending Credit Decision. Please check back later. <Credit-reason desc>
				02052	Account Number did not match 
				00053	Credit decision requires manual review. <may carry more message>
				02053	Provided SSN does not match.
				00054	Access denied due to Lifeline Customer, Please have the customer call (XXX)XXX XXXX for assistance
					
				02054	Only New Customers allowed for PrePay.
				02055	Customer Last Name is Blank.
				02056	Customer First Name is Blank.
				02057	Ssn is missing.
			*/
			
			creditReadRequest = CreateObject('component', 'cfc.model.carrierservice.Verizon.CreditReadRequest').init();
			creditReadRequest.setRequestHeader( requestHeader );
			creditReadRequest.setCreditCheckKeyInfo( creditCheckKeyInfo );
			
			serviceBusRequest.setAction( 'CreditRead' );
			serviceBusRequest.setRequestData( creditReadRequest );
			serviceBusResponse = application.model.RouteService.Route( serviceBusRequest );

			if (serviceBusResponse.ResponseStatus.ErrorCode eq 0)
			{
				creditReadReponse = deserializeJson(serviceBusResponse.ResponseData);

				ArrayAppend( session.processMessages, 'Processing Credit Application: ' & creditCheckKeyInfo.getCreditApplicationNum() );

				//TODO: Add check for capproval code
				if ( creditReadReponse.ResponseStatus.ErrorCode neq '000000' )
				{
					ArrayAppend( session.processMessages, 'Credit check error: ' & creditReadReponse.ResponseStatus.Message );
					return session.processMessages;
				}
				else if ( creditReadReponse.ResponseStatus.ErrorCode eq '000000' && creditReadReponse.Deposit > 0)
				{
					ArrayAppend( session.processMessages, 'Deposit amount required: ' & creditReadReponse.Deposit );
					return session.processMessages;
				}
				else
				{
					ArrayAppend( session.processMessages, 'Credit approved: ' & creditReadReponse.CreditStatus );
				}
			}
			else
			{
				//TODO: bubble up message
				application.model.Util.cfdump( session.processMessages );
				application.model.Util.cfdump( serviceBusResponse );
				application.model.Util.cfabort();
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

			if ( ArrayLen(portInMdnList) )
			{
				isPortInSucessful = submitPortIn( order, requestHeader, creditCheckKeyInfo, portInMdnList );
			}
			
			if ( !isPortInSucessful )
			{
				return session.processMessages;
			}

			
			planDetailList = getPlanDetailListFromOrder( order );
			
			pricePlanLookupRequest = CreateObject('component', 'cfc.model.carrierservice.Verizon.PricePlanLookupRequest').init();
			pricePlanLookupRequest.setRequestHeader( requestHeader );
			pricePlanLookupRequest.setCreditCheckKeyInfo( creditCheckKeyInfo );
			pricePlanLookupRequest.setPlanDetailsList( planDetailList ); 
			
			serviceBusRequest.setAction( 'PricePlanLookup' );
			serviceBusRequest.setRequestData( pricePlanLookupRequest );
			
			//application.model.Util.cfdump( deserializeJson(pricePlanLookupRequest.toJson()) );
			
			serviceBusResponse = application.model.RouteService.Route( serviceBusRequest );
			
			if (serviceBusResponse.ResponseStatus.ErrorCode eq 0)
			{					
				pricePlanLookupReponse = deserializeJson(serviceBusResponse.ResponseData);
				
				//application.model.Util.cfdump( pricePlanLookupReponse );
				//application.model.Util.cfabort(  );
				
				
				if ( pricePlanLookupReponse.ResponseStatus.ErrorCode neq '000000' )
				{
					ArrayAppend( session.processMessages, 'Price plan lookup error: ' & pricePlanLookupReponse.ResponseStatus.ErrorCode & ' - ' & pricePlanLookupReponse.ResponseStatus.Message );
					
					if ( StructKeyExists(pricePlanLookupReponse, 'MtnInfoList') )
					{
						for (i=1; i<= ArrayLen( pricePlanLookupReponse.MtnInfoList ); i++)
						{
							ArrayAppend( session.processMessages, 'Price plan lookup line ' & i & ' error: ' &  pricePlanLookupReponse.MtnInfoList[i].LineErrorCode & '  - ' & pricePlanLookupReponse.MtnInfoList[i].LineErrorMessage );
						}						
					}
					
					return session.processMessages;
				}
				else
				{
					ArrayAppend( session.processMessages, 'Price plan lookup successful' );
				}
			}
			else
			{
				//TODO: bubble up message
				application.model.Util.cfdump( session.processMessages );
				application.model.Util.cfdump( serviceBusResponse );
				application.model.Util.cfabort();
			}
			
			
			
			//save assigned mobile numbers to Wireless line
			for (i=1; i<= ArrayLen( wirelessLines ); i++)
			{
				wirelessLines[i].setNewMdn( pricePlanLookupReponse.MtnInfoList[i].AssignedMobileNumber );
				wirelessLines[i].save();
			}
			
			
			//application.model.Util.cfdump( pricePlanLookupReponse );
			//application.model.Util.cfdump( pricePlanLookupReponse.MtnInfoList );
			//application.model.Util.cfabort();


			//TODO: ServiceWriteRequest
			orderBillingAddress = order.getBillAddress();


			//TODO: Plan

			primaryUserAddress = CreateObject('component', 'cfc.model.carrierservice.Verizon.common.Address').init();
			primaryUserAddress.setAddressLine1( orderBillingAddress.getAddress1() );
			primaryUserAddress.setAddressLine2( orderBillingAddress.getAddress2() );
			primaryUserAddress.setAddressLine3( orderBillingAddress.getAddress3() );
			primaryUserAddress.setAptNum( '' );
			primaryUserAddress.setCity( orderBillingAddress.getCity() );
			primaryUserAddress.setState( orderBillingAddress.getState() );
			primaryUserAddress.setCountry( '' );
			primaryUserAddress.setZipCode( orderBillingAddress.getZip() );
			primaryUserAddress.setExtendedZipCode( '' );
			
			primaryUserInfo = CreateObject('component', 'cfc.model.carrierservice.Verizon.common.User').init();
			primaryUserInfo.setFirstName( orderBillingAddress.getFirstName() );
			primaryUserInfo.setMiddleInitials( '' );
			primaryUserInfo.setLastName( orderBillingAddress.getLastName() );
			primaryUserInfo.setPrefix( '' );
			primaryUserInfo.setAddress( primaryUserAddress );
			primaryUserInfo.setContactPersonName( '' );
			primaryUserInfo.setContactPersonPhone( orderBillingAddress.getDaytimePhone() );
			primaryUserInfo.setEmailId( order.getEmailAddress() );
			
			requestedWirelessLines = pricePlanLookupReponse.MtnInfoList;
			
			for (i=1; i<= ArrayLen( requestedWirelessLines ); i++)
			{
				serviceWriteRequest = CreateObject('component', 'cfc.model.carrierservice.Verizon.ServiceWriteRequest').init();
				serviceWriteRequest.setRequestHeader( requestHeader );
				serviceWriteRequest.setCreditCheckKeyInfo( creditCheckKeyInfo );
				serviceWriteRequest.setPrimaryUserInfo( primaryUserInfo );				

				if ( order.getActivationType() eq 'U' || order.getActivationType() eq 'A' )
				{
					serviceWriteRequest.setAccountNumber( order.getWirelessAccount().getCurrentAcctNumber() ); //Existing customer
					serviceWriteRequest.setAccountSubNumber( '' );  //Existing customer
				}

				serviceWriteRequest.setIsDeviceInfoFinal( variables.instance.IsDeviceInfoFinal );
				
				serviceWriteRequest.setCreditApprovalStatus( creditReadReponse.CreditStatus );
				serviceWriteRequest.setAssignedMobileNumber( requestedWirelessLines[i].AssignedMobileNumber );
				serviceWriteRequest.setMultiLineSeqNumber( requestedWirelessLines[i].MultiLineSeqNumber );
				serviceWriteRequest.setSecurityDepositAmount( 0 );

				//if (activationDate.length>0)
				//{	
					
					serviceWriteRequest.setActivationDate( activationDate );
				//}

				device = CreateObject('component', 'cfc.model.carrierservice.Verizon.common.Device').init();
				device.setDeviceId( requestedWirelessLines[i].EqptInfo.DeviceInfo.DeviceId );
				device.setDeviceType( requestedWirelessLines[i].EqptInfo.DeviceInfo.DeviceType );
				device.setSim( wirelessLines[i].getSim() ); //Need to use wireless line because SIM is not returned from Price Plan lookup


				
				serviceWriteRequest.setNewEqptInfo( device );
				
				switch ( order.getActivationType() )
				{
					case 'N':
					{
						serviceWriteRequest.setOrderType( 'NEW' );
						break;
					}
					case 'U':
					{
						serviceWriteRequest.setOrderType( 'UPGRADE' ); //NEW, UPGRADE, AAL
						
						oldDevice = getOldDeviceEquipment( order, requestHeader, requestedWirelessLines[i].AssignedMobileNumber );
						
						serviceWriteRequest.setUpgradeOldDevice( oldDevice );
						serviceWriteRequest.setIsUpgradePhoneSwap( false );
						
						break;
					}
					case 'A':
					{
						serviceWriteRequest.setOrderType( 'AAL' ); //NEW, UPGRADE, AAL
						break;
					}
				}
				

				
				//Features
				features = [];
				includeFeatures = [];
				
				if (structKeyExists(requestedWirelessLines[i], 'IncludedFeatureList' ))
				{
					includeFeatures = requestedWirelessLines[i].IncludedFeatureList;
				}
				

				for (j=1; j <= ArrayLen(includeFeatures); j++)
				{
					// THIS MIGHT NEED TO BE COMMENTED OUT FOR VERIZON - 1/11/2013 - WAITING FOR EMAIL FROM SHAM.
					feature = CreateObject('component', 'cfc.model.carrierservice.Verizon.common.Feature').init();
					feature.setCode( Left(includeFeatures[j].Code, 5) );
					feature.setDescription( includeFeatures[j].Description );
					feature.setPrice( includeFeatures[j].Price );
					feature.setIsAdding( false );

					ArrayAppend(features, feature);
		


					featuref = CreateObject('component', 'cfc.model.carrierservice.Verizon.common.Features').init();
					featuref.setCode( Left(includeFeatures[j].Code, 5) );
					featuref.setDescription( includeFeatures[j].Description );
					featuref.setPrice( includeFeatures[j].Price );					
					featuref.setMDN (requestedWirelessLines[i].AssignedMobileNumber );

					ArrayAppend(featureLists, featuref);
												
				
				}				

				//Add services from order details
				wirelessLines = order.getWirelessLines();
				lineServices = wirelessLines[i].getLineServices();
				

				for (j=1; j <= ArrayLen(lineServices); j++)
				{
					feature = CreateObject('component', 'cfc.model.carrierservice.Verizon.common.Feature').init();
					feature.setCode( Left(lineServices[j].getLineService().getCarrierServiceId(), 5) );
					feature.setDescription( '' );
					feature.setPrice( lineServices[j].getLineService().getMonthlyFee() );
					feature.setIsAdding( true );
					
					ArrayAppend(features, feature);
				}

				
				serviceWriteRequest.setFeatures( features );	

				if (wirelessLines[i].getIsMDNPort() eq 1)			
				{
					serviceWriteRequest.setMDNPort(true);
				}
				else
				{
					serviceWriteRequest.setMDNPort(false);
				}
					
				//TODO: Plan
				plan = CreateObject('component', 'cfc.model.carrierservice.Verizon.common.Plan').init();
				plan.setPlanType( requestedWirelessLines[i].PlanInfoList[1].PlanType );
				plan.setPricePlanId( requestedWirelessLines[i].PlanInfoList[1].PricePlanId );
				plan.setIsFamilySharedPlan( '' );
				plan.setParentPlanCode( '' );
				plan.setNafCode( '' );
				plan.setOldPricePlanCode( '' );
				planList = [plan];


				pricePlanInfo = CreateObject('component', 'cfc.model.carrierservice.Verizon.common.PricePlanInfo').init();
				for (contractIndex=1; contractIndex LTE arrayLen(pricePlanLookupReponse.MtnInfoList[1].PlanInfoList[1].AvailableContracts); contractIndex=contractIndex+1) {
					if (pricePlanLookupReponse.MtnInfoList[1].PlanInfoList[1].AvailableContracts[contractIndex].Description is "24 Months") break;
				}
				if (contractIndex gt arrayLen(pricePlanLookupReponse.MtnInfoList[1].PlanInfoList[1].AvailableContracts) ) {
					ArrayAppend( session.processMessages, 'Activation error - ' & "2-year contract not available for this device" );
					return session.processMessages;					
				}
				pricePlanInfo.setContractId( pricePlanLookupReponse.MtnInfoList[1].PlanInfoList[1].AvailableContracts[contractIndex].ID );
				pricePlanInfo.setContractDescription( pricePlanLookupReponse.MtnInfoList[1].PlanInfoList[1].AvailableContracts[contractIndex].Description );				
				
				pricePlanInfo.setPlanList( planList );
				
				serviceWriteRequest.setPricePlanInfo( pricePlanInfo );

				serviceBusRequest.setAction( 'ServiceWrite' );
				serviceBusRequest.setRequestData( serviceWriteRequest );
				serviceBusResponse = application.model.RouteService.Route( serviceBusRequest );
				
				
				if (serviceBusResponse.ResponseStatus.ErrorCode eq 0)
				{
					serviceWriteReponse = deserializeJson(serviceBusResponse.ResponseData);
					
					if ( serviceWriteReponse.ResponseStatus.ErrorCode eq '00000' )
					{
						if ( order.getActivationType() eq 'U') //Upgrades
						{
							wirelessLines[i].setActivationStatus( 2 );
						}
						
						ArrayAppend( session.processMessages, 'Service Write Line ' & serviceWriteReponse.MultiLineSeqNumber & ' successful' );
	
					
					}
					else
					{
						ArrayAppend( session.processMessages, 'Service Write error: ' &  serviceWriteReponse.ResponseStatus.Message);
						return session.processMessages;
					}
				}
				else
				{
					//TODO: bubble up message
					application.model.Util.cfdump( session.processMessages );
					application.model.Util.cfdump( serviceBusRequest.toJson() );
					application.model.Util.cfdump( serviceBusResponse );
					application.model.Util.cfabort();
				}
			}
			
			order.setWirelessLines( wirelessLines );
			order.save();
			
			//Perform activation process for only new and add-a-line
			if ( order.getActivationType() eq 'N' || order.getActivationType() eq 'A' )
			{
				isActivationSuccessful = submitActivation( order, requestHeader, creditCheckKeyInfo, requestedWirelessLines );
			}
			
			wirelessAccount = order.getWirelessAccount();
			wirelessAccount.setActivationStatusByLineStatus(); //We will fake activation status on upgrade orders since they are activated by the customer
			wirelessAccount.save();
			

			//application.model.Util.cfdump( featureLists );					
			//application.model.Util.cfabort();

			if ( wirelessAccount.getActivationStatus() eq 2 )
			{
				orderHtmlDocument = application.view.order.getOrderHtmlDocumentView( order, featureLists);

				submitReceiptRequest = CreateObject('component', 'cfc.model.carrierservice.Verizon.ReceiptSubmitRequest').init();
				submitReceiptRequest.setRequestHeader( requestHeader );
				submitReceiptRequest.setCreditCheckKeyInfo( creditCheckKeyInfo );
				
				switch ( order.getActivationType() )
				{
					case 'N':
					{
						submitReceiptRequest.setOrderType( 'NEW' );
						break;
					}
					case 'U':
					{
						submitReceiptRequest.setOrderType( 'UPGRADE' );
						break;
					}					
					case 'A':
					{
						submitReceiptRequest.setOrderType( 'AAL' );
						break;
					}
				}
				
				submitReceiptRequest.setSignatureData( '' );
				submitReceiptRequest.setContractReceiptSubmit( orderHtmlDocument, featureLists  );
				
				serviceBusRequest.setAction( 'ReceiptSubmit' );
				serviceBusRequest.setRequestData( submitReceiptRequest );
				serviceBusResponse = application.model.RouteService.Route( serviceBusRequest );
				
				if (serviceBusResponse.ResponseStatus.ErrorCode eq 0)
				{
					submitReceiptReponse = deserializeJson(serviceBusResponse.ResponseData);

					if ( submitReceiptReponse.ResponseStatus.ErrorCode neq '000000' )
					{
						ArrayAppend( session.processMessages, 'Receipt submit error: ' & creditReadReponse.ResponseStatus.Message );
						return session.processMessages;
					}
					else
					{
						order.setStatus( 3 );
						ArrayAppend( session.processMessages, 'Receipt submit submitted successfully' );
					}
				}
				else
				{
					//TODO: bubble up message
					application.model.Util.cfdump( session.processMessages );
					application.model.Util.cfdump( serviceBusResponse );
					application.model.Util.cfabort();
				}
				
			}
			
			order.save();
		</cfscript>

		<cfreturn session.processMessages />
	</cffunction>

	<!---
		Carrier Plan Types:
		
		IN - Individual Plans
		FP - Family Share Primary
		FS - Family Share Secondary
		V - ALP Voice Only Plan
		VM - ALP Voice and Messaging Plan
		D1 - ALP Data Plan 1
		D2 - ALP Data Plan 2
		ALP - Generic ALP Plans Lookup
		
		Device Types:
		
		4GE, VRA, CDM, and ""

	 --->
	<cffunction name="getPlanDetailListFromOrder" output="false" access="public" returntype="array">
		<cfargument name="Order" type="cfc.model.Order" required="true" />
	
		<cfscript>
			var planDetailsList = [];
			var orderDetails = arguments.Order.getOrderDetail();
			var wirelessLines = [];
			var carrierDeviceType = '';
			
			//application.model.Util.cfdump( orderDetails );
			//application.model.Util.cfabort();
			
			//Get number of device lines
			//Get plan info if family/ind/ALP
			
			wirelessLines = arguments.Order.getWirelessLines();
			
			for (i=1; i<= ArrayLen( wirelessLines ); i++)
			{

				planDetail = CreateObject('component', 'cfc.model.carrierservice.Verizon.common.PlanDetail').init();
				planDetail.setMultiLineSeqNumber( i );

				if ( Len(wirelessLines[i].getCarrierPlanType()) )
				{
					planDetail.setPlanType( wirelessLines[i].getCarrierPlanType() );
				}
				else 
				{
					if ( wirelessLines[i].getPlanType() eq 'individual' )
					{
						planDetail.setPlanType( 'IN' );
					}
					else if (  wirelessLines[i].getPlanType() eq 'family' )
					{
						planDetail.setPlanType( 'ALP' );
					}
					else
					{
						planDetail.setPlanType( '' );//Need to figure out when this is blank. Might need to store on customer lookup
					}					
				}

				
				planDetail.setPricePlanId( Left(wirelessLines[i].getCarrierPlanId(), 5) ); //Carrier billcode
				
				device = CreateObject('component', 'cfc.model.carrierservice.Verizon.common.Device').init();
				device.setDeviceId( wirelessLines[i].getImei() );
				
				carrierDeviceType = application.model.Phone.getCarrierDeviceType( wirelessLines[i].getLineDevice().getProductId(), arguments.order.getCarrierId() );
				
				//Log error if device type cannot be determined
				if ( carrierDeviceType eq '' )
				{
					ArrayAppend( session.processMessages, 'Technology type not found for: ' & wirelessLines[i].getLineDevice().getProductTitle() & ' - ID: ' & wirelessLines[i].getLineDevice().getProductId());
				}
			
				device.setDeviceType( carrierDeviceType ); //Device Type
				
				if ( carrierDeviceType eq 'Item4GE' )
				{
					device.setSim( wirelessLines[i].getSim() ); //4G devices require a SIM
				}
				
				planDetail.setEqptInfo( device );
				
				//Check to see if new MDN is already assigned
				if ( Len(Trim(wirelessLines[i].getNewMdn())) )
				{
					planDetail.setAssignedMobileNumber( wirelessLines[i].getNewMdn() );
				}
				else
				{
					if ( order.getActivationType() eq 'U')
					{
						planDetail.setAssignedMobileNumber( wirelessLines[i].getCurrentMdn() );
					}
					else if (wirelessLines[i].getIsMDNPort())
					{
						 //TODO: Figure out which field has the port MDN then set to setAssignedMobileNumber
						 planDetail.setAssignedMobileNumber( wirelessLines[i].getNewMdn() );
					}
					else
					{
						planDetail.setSelectedNpaNxx( wirelessLines[i].getNPArequested() );
					}
				}

				ArrayAppend(planDetailsList, planDetail);
			}
		</cfscript>
	
		<cfreturn planDetailsList />
	</cffunction>


	<cffunction name="submitPortIn" output="false" access="public" returntype="boolean">
		<cfargument name="Order" type="cfc.model.Order" required="true" />
		<cfargument name="RequestHeader" type="cfc.model.carrierservice.ServiceBus.CarrierRequestHeader" required="true" />
		<cfargument name="CreditCheckKeyInfo" type="cfc.model.carrierservice.Verizon.common.CreditCheckKeyInfo" required="true" />
		<cfargument name="portInMdnList" type="array" required="true" />
	
		<cfscript>
			var portInItems = [];
			var orderBillingAddress = arguments.order.getBillAddress();
			var isPortSuccessful = true;
			var wirelessLines = arguments.order.getWirelessLines();
			var ospAccountNumber = '';
			
			portInValidationRequest = CreateObject('component', 'cfc.model.carrierservice.Verizon.PortInValidationRequest').init();
			portInValidationRequest.setRequestHeader( arguments.RequestHeader );
			portInValidationRequest.setServiceAreaZip( order.getServiceZipCode() );
			portInValidationRequest.setMdns( portInMdnList );
			
			serviceBusRequest = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.ServiceBusRequest').init( argumentCollection = request.config.ServiceBusRequest );
			serviceBusRequest.setCarrier( request.config.CarrierServiceBusTarget.Verizon );
			serviceBusRequest.setAction( 'PortInValidation' );
			serviceBusRequest.setRequestData( portInValidationRequest );
			
			serviceBusResponse = application.model.RouteService.Route( serviceBusRequest );


			if (serviceBusResponse.ResponseStatus.ErrorCode eq 0)
			{
				ArrayAppend( session.processMessages, 'MDN Port-In validated successfully' );
				
				portInValidationReponse = deserializeJson(serviceBusResponse.ResponseData);
				
				for (i=1; i <= ArrayLen( portInValidationReponse.PortInfoList ); i++)
				{
					portInItem = CreateObject('component', 'cfc.model.carrierservice.Verizon.common.PortInItem').init();
					
					portInItem.setEtniValidationDate( portInValidationReponse.PortInfoList[i].AuthorizatinDate );
					portInItem.setFormerCompanyCode( portInValidationReponse.PortInfoList[i].FormerCarrierCode );
					portInItem.setPhoneUserName( '' ); //TODO: Find out how to populate
					portInItem.setPortInNumber( portInValidationReponse.PortInfoList[i].Mdn );
					portInItem.setRateCenter( portInValidationReponse.PortInfoList[i].RateCenter );
					portInItem.setState( portInValidationReponse.PortInfoList[i].State );
					portInItem.setWirelessPortInd( 'Y' );
					
					ArrayAppend(portInItems, portInItem);
				}
			}
			else
			{
				application.model.Util.cfdump( session.processMessages );
				application.model.Util.cfdump( serviceBusResponse );
				application.model.Util.cfabort();
			}

			ospAccountNumber = wirelessLines[1].getPortInCurrentCarrierAccountNumber();
			
			if ( ArrayLen(portInItems) )
			{
				portInSubmitRequest = CreateObject('component', 'cfc.model.carrierservice.Verizon.PortInSubmitRequest').init();
				portInSubmitRequest.setRequestHeader( arguments.RequestHeader );
				portInSubmitRequest.setCreditCheckKeyInfo( arguments.CreditCheckKeyInfo );
				
				portInUserAddress = CreateObject('component', 'cfc.model.carrierservice.Verizon.common.Address').init();
				portInUserAddress.setAddressLine1( orderBillingAddress.getAddress1() );
				portInUserAddress.setAddressLine2( orderBillingAddress.getAddress2() );
				portInUserAddress.setAddressLine3( orderBillingAddress.getAddress3() );
				portInUserAddress.setAptNum( '' );
				portInUserAddress.setCity( orderBillingAddress.getCity() );
				portInUserAddress.setState( orderBillingAddress.getState() );
				portInUserAddress.setCountry( '' );
				portInUserAddress.setZipCode( orderBillingAddress.getZip() );
				portInUserAddress.setExtendedZipCode( '' );
				
				portInUserInfo = CreateObject('component', 'cfc.model.carrierservice.Verizon.common.User').init();
				portInUserInfo.setFirstName( orderBillingAddress.getFirstName() );
				portInUserInfo.setMiddleInitials( '' );
				portInUserInfo.setLastName( orderBillingAddress.getLastName() );
				portInUserInfo.setPrefix( '' );
				portInUserInfo.setAddress( portInUserAddress );
				portInUserInfo.setContactPersonName( '' );
				portInUserInfo.setContactPersonPhone( orderBillingAddress.getDaytimePhone() );
				portInUserInfo.setEmailId( order.getEmailAddress() );
				
				portInSubmitRequest.setUserInfo( portInUserInfo );
			  	portInSubmitRequest.setBussOrIndCustomer( 'R' );
				portInSubmitRequest.setCBRPhone( portInItems[1].getPortInNumber() );
				portInSubmitRequest.setOSPAccountNum( ospAccountNumber );
				portInSubmitRequest.setAuthorizedSigner( orderBillingAddress.getFirstName() & ' ' & orderBillingAddress.getLastName() ); 
				portInSubmitRequest.setPasswordPin( '' ); //TODO: Same as the passwordPin from customer search.  This will be the customer’s pin in VZW billing system.  Optional, can pass empty string if customer does not want a password.
				
				portInSubmitRequest.setPortInItems( portInItems );
				
				
				serviceBusRequest = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.ServiceBusRequest').init( argumentCollection = request.config.ServiceBusRequest );
				serviceBusRequest.setCarrier( request.config.CarrierServiceBusTarget.Verizon );
				serviceBusRequest.setAction( 'PortInSubmit' );
				serviceBusRequest.setRequestData( portInSubmitRequest );
				
				serviceBusResponse = application.model.RouteService.Route( serviceBusRequest );		
				
				if (serviceBusResponse.ResponseStatus.ErrorCode eq 0)
				{
					portInSubmitResponse = deserializeJson(serviceBusResponse.ResponseData);
					
					if ( portInSubmitResponse.ResponseStatus.ErrorCode eq '00000' )
					{					
						ArrayAppend( session.processMessages, 'Port-in of was successful' );
					}
					else if ( portInSubmitResponse.ResponseStatus.ErrorCode eq '00150' )
					{
						ArrayAppend( session.processMessages, 'Port-in already submitted: ' & portInSubmitResponse.ResponseStatus.Message );
					}
					else
					{
						isPortSuccessful = false;
						ArrayAppend( session.processMessages, 'Port-in failed: ' & portInSubmitResponse.ResponseStatus.Message );
					}

				}
				else
				{
					isPortSuccessful = false;
					ArrayAppend( session.processMessages, 'Port-in request received an unexpected error: ' & serviceBusResponse.ResponseStatus.Message );
				}
				
			}
		</cfscript>
	
		<cfreturn isPortSuccessful />
	</cffunction>	
	
	
	<cffunction name="submitActivation" output="false" access="public" returntype="boolean">
		<cfargument name="Order" type="cfc.model.Order" required="true" />
		<cfargument name="RequestHeader" type="cfc.model.carrierservice.ServiceBus.CarrierRequestHeader" required="true" />
		<cfargument name="CreditCheckKeyInfo" type="cfc.model.carrierservice.Verizon.common.CreditCheckKeyInfo" required="true" />
		<cfargument name="RequestedWirelessLines" type="array" required="true" />
		
		<cfscript>
			var mtnInfoList = [];
			var wirelessLines = arguments.Order.getWirelessLines();
			var isActivationSuccessful = true;

			serviceBusRequest = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.ServiceBusRequest').init( argumentCollection = request.config.ServiceBusRequest );
			serviceBusRequest.setCarrier( request.config.CarrierServiceBusTarget.Verizon );

			activationRequest = CreateObject('component', 'cfc.model.carrierservice.Verizon.ActivationRequest').init();
			activationRequest.setRequestHeader( arguments.RequestHeader );
			activationRequest.setCreditCheckKeyInfo( arguments.CreditCheckKeyInfo );
			
			for (i=1; i<= ArrayLen( arguments.RequestedWirelessLines ); i++)
			{
				mtnInfo = CreateObject('component', 'cfc.model.carrierservice.Verizon.common.MtnInfo').init();
				mtnInfo.setMultiLineSeqNumber( arguments.RequestedWirelessLines[i].MultiLineSeqNumber );
				mtnInfo.setMobileNumber( arguments.RequestedWirelessLines[i].AssignedMobileNumber );
				
				ArrayAppend( mtnInfoList, mtnInfo );
			}
			
			activationRequest.setMtnInfoList( mtnInfoList );
			
			serviceBusRequest.setAction( 'Activation' );
			serviceBusRequest.setRequestData( activationRequest );
			serviceBusReponse = application.model.RouteService.Route( serviceBusRequest );
			
			if (serviceBusResponse.ResponseStatus.ErrorCode eq 0)
			{
				activationResponse = deserializeJson(serviceBusResponse.ResponseData);
			}
			else
			{
				//TODO: bubble up message
				application.model.Util.cfdump( session.processMessages );
				application.model.Util.cfdump( serviceBusResponse );
				application.model.Util.cfabort();
			}

			sleep(20000); //Pause for 20 seconds to give the Activations process some time to register in EROS

			activationReadRequest = CreateObject('component', 'cfc.model.carrierservice.Verizon.ActivationReadRequest').init();
			activationReadRequest.setRequestHeader( arguments.RequestHeader );
			activationReadRequest.setCreditCheckKeyInfo( arguments.CreditCheckKeyInfo );
			activationReadRequest.setMtnInfoList( mtnInfoList );
			
			serviceBusRequest.setAction( 'ActivationRead' );
			serviceBusRequest.setRequestData( activationReadRequest );
			
			isActivationInProgress = true;
			activationReadAttempts = 0;
			
			while ( isActivationInProgress || activationReadAttempts < 4 )
			{
				serviceBusResponse = application.model.RouteService.Route( serviceBusRequest );
				activationReadAttempts++;
				
				if (serviceBusResponse.ResponseStatus.ErrorCode eq 0)
				{
					activationReadResponse = deserializeJson(serviceBusResponse.ResponseData);
					
					ArrayAppend( session.processMessages, 'Activation read successful' );
					
					//02502	Activation in progress. Please refresh for activation status.
					//02503	Activation not triggered.
					if ( activationReadResponse.ResponseStatus.ErrorCode eq '02502' || activationReadResponse.ResponseStatus.ErrorCode eq '02503')
					{
						sleep(15000); //Pause for 15 seconds
						isActivationInProgress = true;
					}
					else
					{
						isActivationInProgress = false;
						activationReadAttempts = 4;
					}
					
					for (i=1; i <= ArrayLen(activationReadResponse.MtnInfoList); i++)
					{
						switch( activationReadResponse.MtnInfoList[i].ActivationStatus )
						{
							case 'SUCCESS':
							{
								wirelessLines[i].setActivationStatus( 2 );
								break;
							}
							case 'FAILED':
							{
								wirelessLines[i].setActivationStatus( 4 );
								isActivationSuccessful = false;
								break;
							}
							default:
							{
								wirelessLines[i].setActivationStatus( 5 );
								isActivationSuccessful = false;
								break;
							}
						}
	
						wirelessLines[i].save();
	
						ArrayAppend( session.processMessages, activationReadResponse.MtnInfoList[i].ActivationStatus & ' - Line ' & activationReadResponse.MtnInfoList[i].MultiLineSeqNumber & ': ' & activationReadResponse.MtnInfoList[i].MobileNumber & '| Message: ' & activationReadResponse.MtnInfoList[i].Message);
					}
	
					order.setWirelessLines( wirelessLines );
					order.save();
				}
				else
				{
					//TODO: bubble up message
					application.model.Util.cfdump( session.processMessages );
					application.model.Util.cfdump( serviceBusResponse );
					application.model.Util.cfabort();
				}				
				
			}
		</cfscript>
	
		<cfreturn isActivationSuccessful />
	</cffunction>
	
	
	<cffunction name="getOldDeviceEquipment" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.Device">
		<cfargument name="Order" type="cfc.model.Order" required="true" />
		<cfargument name="RequestHeader" type="cfc.model.carrierservice.ServiceBus.CarrierRequestHeader" required="true" />
		<cfargument name="Mdn" type="string" required="true" />
	
		<cfscript>
			var wirelessAccount = arguments.order.getWirelessAccount();
			var oldDeviceEquipment = CreateObject('component', 'cfc.model.carrierservice.Verizon.common.Device').init();
				
			customerLookupRequest = CreateObject('component', 'cfc.model.carrierservice.Verizon.CustomerLookupRequest').init();
			customerLookupRequest.setRequestHeader( arguments.requestHeader );
			customerLookupRequest.setZipCode( wirelessAccount.getAccountZipCode() );
			customerLookupRequest.setMdn( arguments.Mdn );
			customerLookupRequest.setSecretKey( wirelessAccount.getAccountPassword() ); //TODO: Get Account Password
			customerLookupRequest.setSSN( wirelessAccount.getCurrentAcctPIN() );
			
			serviceBusRequest = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.ServiceBusRequest').init( argumentCollection = request.config.ServiceBusRequest );
			serviceBusRequest.setCarrier( request.config.CarrierServiceBusTarget.Verizon );
			serviceBusRequest.setAction( 'CustomerLookup' );
			serviceBusRequest.setRequestData( customerLookupRequest );
			
			serviceBusReponse = application.model.RouteService.Route( serviceBusRequest );
			
			
			if ( serviceBusReponse.ResponseStatus.ErrorCode eq 0 )
			{
				carrierResponse = deserializeJSON( serviceBusReponse.ResponseData );

				if ( carrierResponse.ResponseStatus.ErrorCode eq '00000')
				{
					oldDeviceEquipment.setDeviceId( carrierResponse.Account.LineInfo.DeviceInfo.DeviceId );
					oldDeviceEquipment.setDeviceType( carrierResponse.Account.LineInfo.DeviceInfo.DeviceType );
					
					if ( carrierResponse.Account.LineInfo.DeviceInfo.DeviceType eq '4G' )
					{
						oldDeviceEquipment.setSim( carrierResponse.Account.LineInfo.DeviceInfo.Sim );
					}
				}
				else
				{
					ArrayAppend( session.processMessages, 'Account not found for ' & arguments.Mdn );
				}
			}
			else
			{
				ArrayAppend( session.processMessages, 'Account not found for ' & arguments.Mdn );
			}
		</cfscript>
	
		<cfreturn oldDeviceEquipment />
	</cffunction>


	<cffunction name="sendProrateReceipt" output="false" access="public" returntype="array">
		<cfargument name="OrderId" type="numeric" required="true" />
		
		<cfscript>
			var order = CreateObject('component', 'cfc.model.Order').init();
			var serviceBusRequest = '';
			var serviceBusResponse = '';
			var orderBillingAddress = '';
			var wirelessLines = '';
			var requestHeader = '';
			var creditCheckKeyInfo = '';
			var prorateReceiptRequest = '';
			var prorateResponseReponse = '';
			var i = 0;
			var emailArgs = {};

			serviceBusRequest = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.ServiceBusRequest').init( argumentCollection = request.config.ServiceBusRequest );
			serviceBusRequest.setCarrier( request.config.CarrierServiceBusTarget.Verizon );
			
			order.load( arguments.OrderId );
			wirelessLines = order.getWirelessLines();
			
			requestHeader = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.CarrierRequestHeader').init( argumentCollection = request.config.VerizonRequestHeader );
			requestHeader.setServiceAreaZip( order.getServiceZipCode() );
			requestHeader.setReferenceNumber( order.getCheckoutReferenceNumber() );
			
			creditCheckKeyInfo = CreateObject('component', 'cfc.model.carrierservice.Verizon.common.CreditCheckKeyInfo').init();
			creditCheckKeyInfo.load( order.getCreditCheckKeyInfoId() );			
			
			prorateReceiptRequest = CreateObject('component', 'cfc.model.carrierservice.Verizon.ProrateReceiptRequest').init();
			prorateReceiptRequest.setRequestHeader( requestHeader );
			prorateReceiptRequest.setCreditCheckKeyInfo( creditCheckKeyInfo );

				
			switch ( order.getActivationType() )
			{
				case 'N':
				{
					prorateReceiptRequest.setOrderType( 'NEW' );
					break;
				}
				case 'U':
				{
					prorateReceiptRequest.setOrderType( 'UPGRADE' );
					break;
				}
				case 'A':
				{
					prorateReceiptRequest.setOrderType( 'AAL' );
					break;
				}
			}

			for (i=1; i <= ArrayLen(wirelessLines); i++)
			{
				try
				{
					prorateReceiptRequest.setMobileNumber( wirelessLines[i].getNewMdn() );
					
					serviceBusRequest.setAction( 'ProrateReceipt ' );
					serviceBusRequest.setRequestData( prorateReceiptRequest );
					
					serviceBusResponse = application.model.RouteService.Route( serviceBusRequest );
					
					if (serviceBusResponse.ResponseStatus.ErrorCode eq 0)
					{			
						prorateResponseReponse = deserializeJson(serviceBusResponse.ResponseData);

						if ( prorateResponseReponse.ResponseStatus.ErrorCode eq '000000' )
						{
							emailArgs = {
								MailTo = order.getEmailAddress()
								, MailFrom = application.errorFromAddress
								, MailSubject = 'Verizon Prorate Receipt'
								, MailBody = prorateResponseReponse.ProRateHTML
							};
							
							application.model.Util.cfmail( argumentCollection = emailArgs );
							
							ArrayAppend( session.processMessages, 'Prorate Receipt successfully sent for line ' & wirelessLines[i].getNewMdn() );
						}
						else
						{
							ArrayAppend( session.processMessages, 'An error occured while sending the Prorate Receipt: ' & serviceBusResponse.ResponseStatus.Message);
						}
					}
					else
					{
						ArrayAppend( session.processMessages, 'An error occured while sending the Prorate Receipt: ' & serviceBusResponse.ResponseStatus.Message );
					}
				} 
				catch ( any e )
				{
					ArrayAppend( session.processMessages, 'An error occured while sending the Prorate Receipt: ' & e.message );
				}				
			}			
		</cfscript>
		
		
	
		<cfreturn session.processMessages />
	</cffunction>
	
</cfcomponent>
