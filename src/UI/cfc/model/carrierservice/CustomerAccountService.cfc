<cfcomponent output="false">
	
	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.CustomerAccountService">

		<cfscript>
			variables.customerAccountGateway = CreateObject( 'component', 'cfc.model.carrierservice.CustomerAccountGateway' ).init();
		</cfscript>

		<cfreturn this />
	</cffunction>


	<!---
	  - Checks to see if the service SOC code is already on the customer's MDN line. If it is then update the Order Detail title and NULL the GERS SKU
	  - so that WebLink does not push that item to GERS.
	  --->
	<cffunction name="resolveConflictingSocCodesOnOrder" output="false" access="public" returntype="numeric">
		<cfargument name="order" type="cfc.model.Order" required="true" />
		
		<cfscript>
			var qIdenticalSocCodes = '';
			var qCustomerLookupResponses = '';
			var orderDetail = '';
			var i = 0;
			var resolvedConflicts = 0;
			var plans = [];
		
			//get account plans and services from carrier log responses
			qCustomerLookupResponses = variables.customerAccountGateway.getCustomerLookupResponses( arguments.order );
			
			for (i=1; i <= qCustomerLookupResponses.RecordCount; i++)
			{
				if ( IsXml(qCustomerLookupResponses['data'][i]) )
				{
					plans = parseCustomerAccountXml( qCustomerLookupResponses['data'][i], arguments.order.getCheckoutReferenceNumber(), arguments.order.getCarrierId() );
				
					if ( ArrayLen(plans) )
					{
						saveCustomerAccountInfo( plans );
					}				
				}
			}
			
			//Update order details that conflict with customer's current account
			qIdenticalSocCodes = variables.customerAccountGateway.getConflictingOrderSocCodes( arguments.order );
			
			if ( qIdenticalSocCodes.RecordCount )
			{
				for (i=1; i <= qIdenticalSocCodes.RecordCount; i++)
				{
					orderDetail = CreateObject( 'component', 'cfc.model.OrderDetail' ).init();
					orderDetail.load( qIdenticalSocCodes['OrderDetailId'][i] );
					orderDetail.setGersSku( '' ); //NULL
					orderDetail.save();
			
					resolvedConflicts++;
				}
			}
		</cfscript>

		<cfreturn resolvedConflicts />
	</cffunction>


	<cffunction name="parseCustomerAccountXml" output="false" access="public" returntype="cfc.model.carrierservice.CustomerAccountPlan[]">
		<cfargument name="responseAsXml" type="xml" required="true" />
		<cfargument name="referenceNumber" type="string" required="true" />
		<cfargument name="carrierId" type="numeric" required="true" />

		<cfscript>
			var plans = [];

			switch ( arguments.carrierId )
			{
				case 42:
				{
					plans = parseVerizonXml( argumentCollection = arguments );
					break;
				}
				case 109:
				{
					plans = parseAttXml( argumentCollection = arguments );
					break;
				}
				case 128:
				{
					plans = parseTmobileXml( argumentCollection = arguments );
					break;
				}
			}
		</cfscript>
		
		<cfreturn plans />
	</cffunction>


	<cffunction name="saveCustomerAccountInfo" output="false" access="public" returntype="void">
		<cfargument name="customerAccountPlans" type="cfc.model.carrierservice.CustomerAccountPlan[]" required="true">

		<cfscript>
			var plan = '';
			var services = '';
			var service = '';
			var planId = 0;
			var i = 0;
			var j = 0;

			for (i=1; i <= ArrayLen(arguments.customerAccountPlans); i++)
			{
				plan = customerAccountPlans[i];
				planId = variables.customerAccountGateway.createPlan( plan );
				services = plan.getCustomerAccountServices();

				if ( ArrayLen(services) )
				{
					for (j=1; j <= ArrayLen( services ); j++)
					{
						service = services[j];
						service.setCustomerLookUpPlanId( planId ); //Assign plan ID
					}
					customerAccountGateway.createFeatures( services );
				}
			}
		</cfscript>

	</cffunction>
	
	
	<cffunction name="parseVerizonXml" output="false" access="public" returntype="cfc.model.carrierservice.CustomerAccountPlan[]">
		<cfargument name="responseAsXml" type="xml" required="true" />
		<cfargument name="referenceNumber" type="string" required="true" />
		
		<cfscript>
			var plans = [];
			var plan = '';
			var lineFeatures = '';
			var features = [];
			var feature = '';
			var carrierId = 42;
			var subscribers = '';
			var subscriber = '';
			var i = 0;
			var j = 0;

			isErrorCode = XmlSearch( responseAsXml, "/oasOrderResponse/authenticateSubscriberResponse/authResponse[normalize-space(statusCode) = 'ERROR']/statusCode | /oasOrderResponse/orderResponse[normalize-space(errorCode) = '03']/errorCode" );


			if ( !ArrayLen(isErrorCode) )
			{
				subscribers = XmlSearch( responseAsXml, "/oasOrderResponse/authenticateSubscriberResponse/lineInformation" );
				
				for (i=1; i <= ArrayLen(subscribers); i++)
				{
					plan = CreateObject( 'component', 'cfc.model.carrierservice.CustomerAccountPlan' ).init();
					plan.setReferenceNumber( arguments.referenceNumber );
					plan.setCarrierId( carrierId );
					plan.setMdn( Trim( subscribers[i]['mdn'].XMLText ) );
					plan.setIsPrimary( false ); //TODO: FamilyShareLineIndicator????
					plan.setCarrierBillCode( Trim( subscribers[i]['planCode'].XMLText  ) );
					plan.setTitle( Trim( subscribers[i]['planDescription'].XMLText ) );
					
					lineFeatures = XmlSearch( subscribers[i], 'features/featureInfo' );
					
					for (j=1; j <= ArrayLen(lineFeatures); j++)
					{
						feature = CreateObject( 'component', 'cfc.model.carrierservice.CustomerAccountFeature' ).init();
						feature.setReferenceNumber( referenceNumber );
						feature.setCarrierId( carrierId );
						feature.setCarrierBillCode( Trim( lineFeatures[j]['featureCode'].XmlText ) );
						feature.setTitle( Trim( lineFeatures[j]['description'].XmlText ) );
						ArrayAppend( features, feature );
					}
					
					plan.setCustomerAccountServices( features );
					ArrayAppend( plans, plan );
				}
			}
		</cfscript>
		
		<cfreturn plans />
	</cffunction>


	<cffunction name="parseAttXml" output="false" access="public" returntype="cfc.model.carrierservice.CustomerAccountPlan[]">
		<cfargument name="responseAsXml" type="xml" required="true" />
		<cfargument name="referenceNumber" type="string" required="true" />
		
		<cfscript>
			var plans = [];
			var plan = '';
			var lineFeatures = '';
			var features = [];
			var feature = '';
			var carrierId = 109;
			var subscribers = '';
			var subscriber = '';
			var i = 0;
			var j = 0;
			
			subscribers = XmlSearch( responseAsXml, "//*[local-name()='Subscriber' and namespace-uri()='http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireSubscriberProfileResponse.xsd']" );

			for (i=1; i <= ArrayLen(subscribers); i++)
			{
				plan = CreateObject( 'component', 'cfc.model.carrierservice.CustomerAccountPlan' ).init();
			
				plan.setReferenceNumber( referenceNumber );
				plan.setCarrierId( carrierId );
				plan.setMdn( Trim( subscribers[i]['subscriberNumber'].XMLText ) );
			
				if ( ArrayLen( XmlSearch( subscribers[i], "*[local-name()='PricePlan' and namespace-uri()='http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireSubscriberProfileResponse.xsd']/*[local-name()='groupPlanDetails' and namespace-uri()='http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd']" ) ) )
				{
					plan.setIsPrimary( Trim( subscribers[i]['PricePlan']['groupPlanDetails']['primarySubscriber'].XMLText ) );
					plan.setCarrierBillCode( Trim( subscribers[i]['PricePlan']['groupPlanDetails']['groupPlanCode'].XMLText ) );
					plan.setTitle( Trim( subscribers[i]['PricePlan']['description'].XMLText ) );
				}
				else if ( ArrayLen( XmlSearch( subscribers[i], "*[local-name()='PricePlan' and namespace-uri()='http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireSubscriberProfileResponse.xsd']/*[local-name()='singleUserCode' and namespace-uri()='http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd']" ) ) )
				{
					plan.setCarrierBillCode( Trim( subscribers[i]['PricePlan']['singleUserCode'].XMLText ) );
					plan.setTitle( Trim( subscribers[i]['PricePlan']['description'].XMLText ) );
				}

				subscriber = subscribers[i];
				lineFeatures = XmlSearch( subscriber, "//*[local-name()='AdditionalOfferings' and namespace-uri()='http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireSubscriberProfileResponse.xsd']" );
				features = [];
				
				for (j=1; j <= ArrayLen(lineFeatures); j++)
				{
					feature = CreateObject( 'component', 'cfc.model.carrierservice.CustomerAccountFeature' ).init();
					feature.setReferenceNumber( referenceNumber );
					feature.setCarrierId( carrierId );
					feature.setCarrierBillCode( Trim( lineFeatures[j]['offeringCode'].XmlText ) );
					feature.setTitle( Trim( lineFeatures[j]['offeringDescription'].XmlText ) );
					ArrayAppend( features, feature );
				}
		
				plan.setCustomerAccountServices( features );
				ArrayAppend( plans, plan );
			}
		</cfscript>
		
		<cfreturn plans />
	</cffunction>
	
	
	<cffunction name="parseTmobileXml" output="false" access="public" returntype="cfc.model.carrierservice.CustomerAccountPlan[]">
		<cfargument name="responseAsXml" type="xml" required="true" />
		<cfargument name="referenceNumber" type="string" required="true" />
		
		<cfscript>
			var plans = [];
			var plan = '';
			var lineFeatures = '';
			var features = [];
			var feature = '';
			var carrierId = 128;
			var subscribers = '';
			var subscriber = '';
			var i = 0;
			var j = 0;
			
			subscribers = XmlSearch( responseAsXml, "//*[local-name()='subscriberDetails' and namespace-uri()='http://retail.tmobile.com/sdo']" );

			for (i=1; i <= ArrayLen(subscribers); i++)
			{
				plan = CreateObject( 'component', 'cfc.model.carrierservice.CustomerAccountPlan' ).init();
			
				plan.setReferenceNumber( referenceNumber );
				plan.setCarrierId( carrierId );
				plan.setMdn( Trim( subscribers[i]['msisdn'].XMLText ) );
				plan.setIsPrimary( Trim( false ) );
				plan.setCarrierBillCode( Trim( subscribers[i]['ratePlan']['rateplanInfo']['rateplanCode'].XMLText ) );
				plan.setTitle( Trim( subscribers[i]['ratePlan']['rateplanInfo']['name'].XMLText ) );

				subscriber = subscribers[i];

				lineFeatures = XmlSearch( subscriber, "*[local-name()='ratePlan' and namespace-uri()='http://retail.tmobile.com/sdo']/*[local-name()='optionalServices' and namespace-uri()='http://retail.tmobile.com/sdo']/*[local-name()='optionalService' and namespace-uri()='http://retail.tmobile.com/sdo']" );
				features = [];
				
				//dump( lineFeatures, TRUE );
				
				for (j=1; j <= ArrayLen(lineFeatures); j++)
				{
					feature = CreateObject( 'component', 'cfc.model.carrierservice.CustomerAccountFeature' ).init();
					feature.setReferenceNumber( referenceNumber );
					feature.setCarrierId( carrierId );
					feature.setCarrierBillCode( Trim( lineFeatures[j]['serviceSpec']['soc'].XmlText ) );
					feature.setTitle( Trim( lineFeatures[j]['serviceSpec']['name'].XmlText ) );
		
					ArrayAppend( features, feature );
				}
				
				plan.setCustomerAccountServices( features );
				ArrayAppend( plans, plan );
			}
		</cfscript>

		<cfreturn plans />
	</cffunction>
	
</cfcomponent>