<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.Sprint.SprintCarrierService">
		<cfargument name="Environment" type="string" required="true" />
		<cfargument name="EndPointSourceMap" type="struct" required="true" />

		<cfscript>
			variables.instance = {};
			
			setEnvironment( arguments.Environment );
			setEndPointSourceMap( arguments.EndPointSourceMap );
		</cfscript>

		<cfreturn this />
	</cffunction>
	
	<cffunction name="getUpgradeRequest" output="false" access="public" returntype="ActivationRequest">
		<cfargument name="wirelessLineID" type="numeric" required="true">
		
		<cfscript>
			var ActivationRequest = "";
			var Line = createObject('component','cfc.model.WirelessLine').init();
			var Order = createObject('component', 'cfc.model.Order').init();
			var WirelessAccount = "";
			
			Line.load(arguments.wirelessLineID);
			Order.load(Line.getOrderID());
			WirelessAccount = Order.getWirelessAccount();
			
			ActivationRequest = createObject( "component", "ActivationRequest" ).init( 	
					orderId = Order.getOrderID(), 
					wirelessLineId = Line.getWirelessLineID() 
				);
			
			if( Line.getActivationStatus != 2 ) {
				
				ActivationRequest.populate(
					mdn = Line.getCurrentMDN(),
					secretPIN = WirelessAccount.getCurrentAcctPIN(),
					securityQuestionAnswer = WirelessAccount.getSecurityQuestionAnswer(),
					ssn = WirelessAccount.getLastFourSsn(),
					customerType = 'INDIVIDUAL',
					orderType = 'UPGRADE',
					handsetCount = arrayLen(Order.getWirelessLines()),
					referenceNumber = Order.getCheckoutReferenceNumber()
				);
				
			}
			
			return ActivationRequest;			
		</cfscript>
		
	</cffunction>
	
	
	<cffunction name="upgrade" output="false" access="public" returntype="any">
		<cfargument name="ActivationRequest" type="cfc.model.carrierservice.Sprint.ActivationRequest" required="true">
				
		<cfscript>
			var rawResponse = "";
			
			var ActivationResponse = createObject( "component", "ActivationResponse" ).init( 
				orderId = ActivationRequest.getOrderId(), 
				wirelessLineId = ActivationRequest.getWirelessLineId() 
			);
						
			rawResponse = getActivationService().activateUpgrade(
					orderNumber = ActivationRequest.getOrderId(),
					wirelessLineId = ActivationRequest.getWirelessLineId(),
					mdn = ActivationRequest.getMDN(),
					secretPin = ActivationRequest.getSecretPIN(),
					answer = ActivationRequest.getSecurityQuestionAnswer(),
					ssn = ActivationRequest.getSSN(),
					customerType = ActivationRequest.getCustomerType(),
					orderType = ActivationRequest.getOrderType(),
					handsetCount = ActivationRequest.getHandsetCount(),
					referenceNumber = ActivationRequest.getReferenceNumber()
				);

			ActivationResponse.populateFromResponse( rawResponse );
			
			return ActivationResponse;
		</cfscript>

	</cffunction>
		
	<cffunction name="activateAccount" output="false" access="public" returntype="string">
		<cfargument name="orderId" type="numeric" required="true">
		
		<cfscript>
			var Order = createObject( "component", "cfc.model.Order" ).init();
			var WirelessAccount = "";
		
			Order.load( arguments.OrderId );
			
			WirelessAccount = Order.getWirelessAccount();
			WirelessAccount.setActivationStatusByLineStatus();
			WirelessAccount.save();
			
			if( WirelessAccount.getActivationStatus() == 2 ) {
				Order.setStatus(3);
				Order.save();
			}
			
			return WirelessAccount.getActivationStatusName();
		</cfscript>
	</cffunction>


	<cffunction name="CustomerLookup" output="false" access="public" returntype="any">
		<cfargument name="CustomerLookUpRequest" type="cfc.model.carrierservice.Sprint.CustomerLookupRequest" required="true" />

		<cfscript>
			var customerLookUpResponse = '';
		</cfscript>

        <cfinvoke webservice="#getEndpoint()#"
                  method="CustomerLookupByMDN"
                  returnvariable="customerLookUpResponse">
                <cfinvokeargument name="MDN" value="#arguments.CustomerLookUpRequest.getMdn()#" />
                <cfinvokeargument name="SecretKey" value="#arguments.CustomerLookUpRequest.getSecretKey()#" />
				<cfinvokeargument name="SSN" value="#arguments.CustomerLookUpRequest.getSsn()#" />
				<cfinvokeargument name="QuestionAnswer" value="#arguments.CustomerLookUpRequest.getAnswerToSecurityQuestion()#" />
                <cfinvokeargument name="ReferenceNumber" value="#arguments.CustomerLookUpRequest.getReferenceNumber()#" />
        </cfinvoke>

		<cfreturn customerLookUpResponse />
	</cffunction>


	<cffunction name="RunCreditCheck" output="false" access="public" returntype="any">
		<cfargument name="CreditCheckRequest" type="cfc.model.carrierservice.Sprint.CreditCheckRequest" required="true" />

		<cfscript>
			var creditCheckResponse = '';
			var local = {};
			
			local.ZipCode = '98121';
			local.numberOfLinesRequested = '1';
			local.referenceNumber = '123412341233124324';
			
		</cfscript>

        <cfinvoke webservice="#getEndpoint()#"
				  method="CheckCredit" 
				  returnvariable="creditCheckResponse">
            <cfinvokeargument name="BillingName" value="#arguments.CreditCheckRequest.getBillingInfo()#" />
            <cfinvokeargument name="ContactInfo" value="#arguments.CreditCheckRequest.getContactInfo()#" />
            <cfinvokeargument name="BillingContactCredentials" value="#arguments.CreditCheckRequest.getCredentialsInfo()#" />

            <cfinvokeargument name="ServiceZipCode" value="#local.ZipCode#" />
            <cfinvokeargument name="NumberOfLines" value="#local.numberOfLinesRequested#" />
			<cfinvokeargument name="Question" value="" />
			<cfinvokeargument name="Answer" value="" />
            <cfinvokeargument name="ReferenceNumber" value="#local.referenceNumber#" />
        </cfinvoke>

		<cfreturn creditCheckResponse />
	</cffunction>


	<cffunction name="NpaNxxLookup" output="false" access="public" returntype="array">
		<cfargument name="NpaNxxRequest" type="cfc.model.carrierservice.Sprint.NpaNxxRequest" required="true" />

		<cfscript>
			var npaLookupResponse = '';
			var npaListResponse = '';
			var npaList = [];
		</cfscript>

		<cfinvoke webservice="#getEndpoint()#"
				  method="NpaNxx"
				  returnvariable="npaLookupResponse">
			<cfinvokeargument name="zipcode" value="#arguments.NpaNxxRequest.getZipcode()#" />
			<cfinvokeargument name="referenceNumber" value="#arguments.NpaNxxRequest.getReferenceNumber()#" />
		</cfinvoke>

		<cfscript>
			npaList = npaLookupResponse.getNpaSet().getNpaInfo();
			
			//If the NPA set is empty then response object returns an undefined variable
			if( !IsDefined("npaList") )
			{
				npaList = [];
			}
		</cfscript>

		<cfreturn npaList />
	</cffunction>
	
	<cffunction name="getActivationService" output="false" access="public" returntype="string">
		<cfreturn createObject( "webservice", getEndpoint() )>
	</cffunction>

    <cffunction name="getEndpoint" output="false" access="public" returntype="string">
	    <cfscript>
            var endpoints = getEndPointSourceMap();
            var environmentName = getEnvironment();
           
            if( structKeyExists( endpoints, environmentName ) ) 
            {
				return endpoints[environmentName];
            } 
            else 
            {
				throw( "No endpoint available for environment: #environmentName#" );
            }
	    </cfscript>
    </cffunction>

	<cffunction name="setEnvironment" output="false" access="public" returntype="void">
		<cfargument name="Environment" type="string" default="0" required="false" />
		<cfset variables.instance.Environment = arguments.Environment />
	</cffunction>
	<cffunction name="getEnvironment" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Environment />
	</cffunction>

	<cffunction name="setEndPointSourceMap" output="false" access="public" returntype="void">
		<cfargument name="EndPointSourceMap" type="struct" default="0" required="false" />
		<cfset variables.instance.EndPointSourceMap = arguments.EndPointSourceMap />
	</cffunction>
	<cffunction name="getEndPointSourceMap" output="false" access="public" returntype="struct">
		<cfreturn variables.instance.EndPointSourceMap />
	</cffunction>
	
</cfcomponent>	
