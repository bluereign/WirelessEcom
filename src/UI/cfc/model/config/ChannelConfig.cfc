<cfcomponent displayname="ChannelConfig" hint="config options for channels" output="false">

	<cfscript>
		variables.instance = {};
 		variables.instance.thirdPartyAuth = '';
 		variables.instance.allowAPOFPO = '';
 		variables.instance.allowDifferstShippingOnNewActivations = '';
	</cfscript>

	<cffunction name="init" access="public" hint="Initalizes the Component">
		<cfargument name="ThirdPartyAuth" type="boolean" required="true"/>
		<cfargument name="AllowAPOFPO" type="boolean" required="true"/>
		<cfargument name="OfferWarrantyCoverage" type="boolean" required="false" default="false" />
		<cfargument name="DisplayFreeKit" type="boolean" required="false" default="false" />
		<cfargument name="OfferShippingPromo" type="boolean" required="false" default="false" />
		<cfargument name="OfferWarrantyPlan" type="boolean" required="false" default="false" />
		<cfargument name="OfferPrepaidDeviceWarrantyPlan" type="boolean" required="false" default="false" />
		<cfargument name="DefaultWarrantyPlanId" type="string" required="false" default="" />
		<cfargument name="TrackMercentAnalytics" type="boolean" required="false" default="false" />
		<cfargument name="DisplayOnlineValue" type="boolean" required="false" default="false" />
		<cfargument name="AllowDifferstShippingOnNewActivations" type="boolean" required="false" default="false" />
		<cfargument name="ActivationFeeWavedByCarrier" type="string" required="false" default="" hint="List of carrier ID's that waive the activation fee" />
		<cfargument name="DisplayNoInventoryItems" type="boolean" required="false" default="false" />
		<cfargument name="DisplayZeroPricedItems" type="boolean" required="false" default="false" />
		<cfargument name="DisplayName" type="string" required="true" hint="Channel Display Name"/>
		<cfargument name="OfferNoContractDevices" type="boolean" required="false" default="false" />
		<cfargument name="NoContractDevices" type="string" required="false" default="" />
		<cfargument name="InstantRebateOfferAvailable" type="boolean" default="false" hint="Enables MIR conversion to instant online rebates during checkout based upon wireless line criteria.">
		<cfargument name="OfferPrepaidFreeShipping" type="boolean" required="false" default="false" />
		<cfargument name="OrderProcessingTime" type="numeric" required="false" default="0" />
		<cfargument name="PromotionCodeAvailable" type="boolean" required="false" default="false" hine="Enables promotion/coupon codes." />
		<cfargument name="Environment" type="string" required="false" hint="The current environment (dev,test,production)" default="UNKNOWN" />
		<cfargument name="DdAdminReturnFilterEnabled" type="struct" required="false" hint="The DDadmin Return Filter enabled value for each environment" />
		<cfargument name="CEXCHANGEMap" type="struct" required="false" hint="The proper fully qualified domain to use for CEXCHANGE" />
		<cfargument name="DomainNameMap" type="struct" required="false" hint="The proper fully qualified domain to use for links from admin" />
		<cfargument name="AppleCareEnabled" type="boolean" required="false" default="false" hint="Turns AppleCare support on and off" />
		<cfargument name="AppleCarePrefix" type="string" required="false" default="" hint="The environment prefix for applecare order numbers" />
		<cfargument name="AppleCareAPIMap" type="struct" required="false" hint="The environment specific urls for the wa-appleCare apis" />
		<cfargument name="DisplayCustomerSurveyLink" type="boolean" required="false" default="false" />
		<cfargument name="DisplayWarrantyDetailInCart" type="boolean" required="false" default="false" />
		<cfargument name="CustomerCareEmail" type="string" default="" required="false" />
		<cfargument name="CustomerCarePhone" type="string" default="" required="false" />
		<cfargument name="DisplayProductRebates" type="boolean" default="true" required="false" />
		<cfargument name="DisplayCarrierCustomerLetter" type="boolean" default="true" required="false" />
		<cfargument name="DisplaySmsOptIn" type="boolean" default="false" required="false" />
		<cfargument name="DisplayPrepaidDevices" type="boolean" default="false" required="false" />
		<cfargument name="DisplayPrePaymentGatewayPage" type="boolean" default="false" required="false" />
		<cfargument name="OfferFinancedDevices" type="boolean" default="false" required="false" />
        <cfargument name="DefaultProductSort" type="string" default="" required="false" />
		<cfargument name="DirectToRedesignDetailsPage" type="boolean" default="false" required="false" />
		<cfargument name="VfdEnabled" type="boolean" default="false" required="false" />
		<cfargument name="CarrierTwoYearRemoval" type="string" default="" required="false" />
		<cfargument name="VfdMkey" type="string" default="false" required="false" />
		<cfargument name="VfdIV" type="string" default="false" required="false" />
		<cfargument name="ScenarioDescription" type="string" default="false" required="false" />		
		<cfargument name="TMORedirectEnabled" type="boolean" default="true" required="false" />
		
		<cfscript>
			setEnvironment( arguments.Environment );
        	setThirdPartyAuth( arguments.ThirdPartyAuth );
        	setAllowAPOFPO( arguments.AllowAPOFPO );
        	setOfferWarrantyCoverage( arguments.OfferWarrantyCoverage );
        	setDisplayFreeKit( arguments.DisplayFreeKit );
        	setOfferShippingPromo( arguments.OfferShippingPromo );
			setOfferWarrantyPlan( arguments.OfferWarrantyPlan );
			setOfferPrepaidDeviceWarrantyPlan( arguments.OfferPrepaidDeviceWarrantyPlan );
			setDefaultWarrantyPlanId( arguments.DefaultWarrantyPlanId );
			setTrackMercentAnalytics( arguments.TrackMercentAnalytics );
			setDisplayOnlineValue( arguments.DisplayOnlineValue );
			setAllowDifferstShippingOnNewActivations( arguments.AllowDifferstShippingOnNewActivations );
			setActivationFeeWavedByCarrier( arguments.ActivationFeeWavedByCarrier );
			setDisplayNoInventoryItems( arguments.DisplayNoInventoryItems );
			setDisplayZeroPricedItems( arguments.DisplayZeroPricedItems );
			setDisplayName( arguments.DisplayName );
			setOfferNoContractDevices( arguments.OfferNoContractDevices );
			setNoContractDevices( arguments.NoContractDevices );
			setInstantRebateOfferAvailable( arguments.InstantRebateOfferAvailable );
			setOfferPrepaidFreeShipping( arguments.OfferPrepaidFreeShipping );
			setOrderProcessingTime( arguments.OrderProcessingTime );
			setPromotionCodeAvailable( arguments.PromotionCodeAvailable );
			if (isdefined("arguments.environment") and isdefined("arguments.DdAdminReturnFilterEnabled")) {
				setDDadminReturnFilterEnabled(arguments.environment, arguments.DdAdminReturnFilterEnabled);
			}
			if (isdefined("arguments.environment") and isdefined("arguments.CEXCHANGEMap")) {
				setCEXCHANGE(arguments.environment, arguments.CEXCHANGEMap);
			}
			if (isdefined("arguments.environment") and isdefined("arguments.DomainNameMap")) {
				setDomainName(arguments.environment, arguments.DomainNameMap);
			}
			setAppleCareEnabled( arguments.AppleCareEnabled );
			setAppleCarePrefix( arguments.AppleCarePrefix );
			if (isdefined("arguments.environment") and isdefined("arguments.AppleCareAPIMap")) {
				setAppleCareApiEnabled(arguments.environment, arguments.AppleCareAPIMap);
				setAppleCareApiUrl(arguments.environment, arguments.AppleCareAPIMap);
				setAppleCareApiUsername(arguments.environment, arguments.AppleCareAPIMap);
				setAppleCareApiPassword(arguments.environment, arguments.AppleCareAPIMap);
			}
			setDisplayCustomerSurveyLink(arguments.DisplayCustomerSurveyLink);
			setDisplayWarrantyDetailInCart(arguments.DisplayWarrantyDetailInCart);
			setCustomerCareEmail( arguments.CustomerCareEmail );
			setCustomerCarePhone( arguments.CustomerCarePhone );
			setDisplayProductRebates( arguments.DisplayProductRebates );
			setDisplayCarrierCustomerLetter( arguments.DisplayCarrierCustomerLetter );
			setDisplaySmsOptIn( arguments.DisplaySmsOptIn );
			setDisplayPrepaidDevices( arguments.DisplayPrepaidDevices );
			setDisplayPrePaymentGatewayPage( arguments.DisplayPrePaymentGatewayPage );
			setOfferFinancedDevices( arguments.OfferFinancedDevices );
            setDefaultProductSort( arguments.DefaultProductSort );
            setDirectToRedesignDetailsPage( arguments.DirectToRedesignDetailsPage );
            setVfdEnabled( arguments.VfdEnabled );
            setCarrierTwoYearRemoval( arguments.CarrierTwoYearRemoval) ;
            setVfdMkey( arguments.VfdMkey );
            setVfdIV( arguments.VfdIV );
            setScenarioDescription( arguments.ScenarioDescription );
            setTMORedirectEnabled( arguments.TmoRedirectEnabled);
        </cfscript>

    	<cfreturn this />
    </cffunction>

    <cffunction name="getEnvironment" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.Environment />
    </cffunction>
    <cffunction name="setEnvironment" access="public" returntype="void" output="false">
    	<cfargument name="Environment" type="string" required="true" />
    	<cfset variables.instance.Environment = arguments.Environment />
    </cffunction>

	<cffunction name="getActivationFeeWavedByCarrier" access="public" returntype="any" output="false">
    	<cfreturn variables.instance.activationFeeWavedByCarrier />
    </cffunction>
    <cffunction name="setActivationFeeWavedByCarrier" access="public" returntype="void" output="false">
    	<cfargument name="activationFeeWavedByCarrier" type="string" required="true" default="" />
    	<cfset variables.instance.activationFeeWavedByCarrier = arguments.activationFeeWavedByCarrier>
    </cffunction>

	<cffunction name="getAllowDifferstShippingOnNewActivations" access="public" returntype="boolean" output="false">
    	<cfreturn variables.instance.allowDifferstShippingOnNewActivations />
    </cffunction>
    <cffunction name="setAllowDifferstShippingOnNewActivations" access="public" returntype="void" output="false">
    	<cfargument name="allowDifferstShippingOnNewActivations" type="boolean" required="true" default="" />
    	<cfset variables.instance.allowDifferstShippingOnNewActivations = arguments.allowDifferstShippingOnNewActivations>
    </cffunction>

	<cffunction name="getThirdPartyAuth" access="public" returntype="boolean" output="false">
    	<cfreturn variables.instance.thirdPartyAuth />
    </cffunction>
    <cffunction name="setThirdPartyAuth" access="public" returntype="void" output="false">
    	<cfargument name="thirdPartyAuth" type="boolean" required="true" />
    	<cfset variables.instance.thirdPartyAuth = arguments.thirdPartyAuth />
    </cffunction>

    <cffunction name="getAllowAPOFPO" access="public" returntype="boolean" output="false">
    	<cfreturn variables.instance.allowAPOFPO />
    </cffunction>
    <cffunction name="setAllowAPOFPO" access="public" returntype="void" output="false">
    	<cfargument name="allowAPOFPO" type="boolean" required="true"  />
    	<cfset variables.instance.allowAPOFPO = arguments.allowAPOFPO />
    </cffunction>

    <cffunction name="getOfferWarrantyCoverage" access="public" returntype="boolean" output="false">
    	<cfreturn variables.instance.OfferWarrantyCoverage />
    </cffunction>
    <cffunction name="setOfferWarrantyCoverage" access="public" returntype="void" output="false">
    	<cfargument name="OfferWarrantyCoverage" type="boolean" required="true" />
    	<cfset variables.instance.OfferWarrantyCoverage = arguments.OfferWarrantyCoverage />
    </cffunction>

    <cffunction name="getDisplayFreeKit" access="public" returntype="boolean" output="false">
    	<cfreturn variables.instance.DisplayFreeKit />
    </cffunction>
    <cffunction name="setDisplayFreeKit" access="public" returntype="void" output="false">
    	<cfargument name="DisplayFreeKit" type="boolean" required="true" />
    	<cfset variables.instance.DisplayFreeKit = arguments.DisplayFreeKit />
    </cffunction>

    <cffunction name="getOfferShippingPromo" access="public" returntype="boolean" output="false">
    	<cfreturn variables.instance.OfferShippingPromo />
    </cffunction>
    <cffunction name="setOfferShippingPromo" access="public" returntype="void" output="false">
    	<cfargument name="OfferShippingPromo" type="boolean" required="true" />
    	<cfset variables.instance.OfferShippingPromo = arguments.OfferShippingPromo />
    </cffunction>

    <cffunction name="getOfferWarrantyPlan" access="public" returntype="boolean" output="false">
    	<cfreturn variables.instance.OfferWarrantyPlan />
    </cffunction>
    <cffunction name="setOfferWarrantyPlan" access="public" returntype="void" output="false">
    	<cfargument name="OfferWarrantyPlan" type="boolean" required="true" />
    	<cfset variables.instance.OfferWarrantyPlan = arguments.OfferWarrantyPlan />
    </cffunction>

    <cffunction name="getOfferPrepaidDeviceWarrantyPlan" access="public" returntype="boolean" output="false">
    	<cfreturn variables.instance.OfferPrepaidDeviceWarrantyPlan />
    </cffunction>
    <cffunction name="setOfferPrepaidDeviceWarrantyPlan" access="public" returntype="void" output="false">
    	<cfargument name="OfferPrepaidDeviceWarrantyPlan" type="boolean" required="true" />
    	<cfset variables.instance.OfferPrepaidDeviceWarrantyPlan = arguments.OfferPrepaidDeviceWarrantyPlan />
    </cffunction>

    <cffunction name="getDefaultWarrantyPlanId" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.DefaultWarrantyPlanId />
    </cffunction>
    <cffunction name="setDefaultWarrantyPlanId" access="public" returntype="void" output="false">
    	<cfargument name="DefaultWarrantyPlanId" type="string" required="true" />
    	<cfset variables.instance.DefaultWarrantyPlanId = arguments.DefaultWarrantyPlanId />
    </cffunction>

    <cffunction name="getTrackMercentAnalytics" access="public" returntype="boolean" output="false">
    	<cfreturn variables.instance.TrackMercentAnalytics />
    </cffunction>
    <cffunction name="setTrackMercentAnalytics" access="public" returntype="void" output="false">
    	<cfargument name="TrackMercentAnalytics" type="boolean" required="true" />
    	<cfset variables.instance.TrackMercentAnalytics = arguments.TrackMercentAnalytics />
    </cffunction>

    <cffunction name="getDisplayOnlineValue" access="public" returntype="boolean" output="false">
    	<cfreturn variables.instance.DisplayOnlineValue />
    </cffunction>
    <cffunction name="setDisplayOnlineValue" access="public" returntype="void" output="false">
    	<cfargument name="DisplayOnlineValue" type="boolean" required="true" />
    	<cfset variables.instance.DisplayOnlineValue = arguments.DisplayOnlineValue />
    </cffunction>

    <cffunction name="getDisplayNoInventoryItems" access="public" output="false" returntype="boolean">
    	<cfreturn variables.instance["displayNoInventoryItems"]/>
    </cffunction>
    <cffunction name="setDisplayNoInventoryItems" access="public" output="false" returntype="void">
    	<cfargument name="theVar" required="true" />
    	<cfset variables.instance["displayNoInventoryItems"] = arguments.theVar />
    </cffunction>

    <cffunction name="getDisplayZeroPricedItems" access="public" output="false" returntype="boolean">
    	<cfreturn variables.instance["DisplayZeroPricedItems"]/>
    </cffunction>
    <cffunction name="setDisplayZeroPricedItems" access="public" output="false" returntype="void">
    	<cfargument name="theVar" required="true" />
    	<cfset variables.instance["DisplayZeroPricedItems"] = arguments.theVar />
    </cffunction>

	<cffunction name="getDisplayName" access="public" returntype="any" output="false">
    	<cfreturn variables.instance.displayName />
    </cffunction>
    <cffunction name="setDisplayName" access="public" returntype="void" output="false">
    	<cfargument name="displayName" type="string" required="true" default="" />
    	<cfset variables.instance.displayName = arguments.displayName>
    </cffunction>


    <cffunction name="getOfferNoContractDevices" access="public" returntype="boolean" output="false">
    	<cfreturn variables.instance.OfferNoContractDevices />
    </cffunction>
    <cffunction name="setOfferNoContractDevices" access="public" returntype="void" output="false">
    	<cfargument name="OfferNoContractDevices" type="boolean" required="true" />
    	<cfset variables.instance.OfferNoContractDevices = arguments.OfferNoContractDevices />
    </cffunction>
    
     <cffunction name="IsNoContractDevice" access="public" returntype="boolean" output="false">
		<cfargument name="deviceType" type="string" required="true" />
    	<cfreturn listContainsNoCase(getNoContractDevices(),arguments.deviceType) is not 0 />
    </cffunction>    
   <cffunction name="getNoContractDevices" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.NoContractDevices />
    </cffunction>
    <cffunction name="setNoContractDevices" access="public" returntype="void" output="false">
    	<cfargument name="NoContractDevices" type="string" required="true" />
    	<cfset variables.instance.NoContractDevices = arguments.NoContractDevices />
    </cffunction>

	<cffunction name="getAllConfig" access="public" output="false" returntype="struct" hint="">
    	<cfreturn variables.instance />
    </cffunction>

	<cffunction name="getConfigValue" access="public" output="false" returntype="any" hint="">
		<cfargument name="valueName" type="string" required="true" />
		<cfreturn variables.instance[arguments.valueName] />
	</cffunction>
	<cffunction name="setConfigValue" access="public" output="false" returntype="any" hint="">
		<cfargument name="valueName" type="string" required="true" />
		<cfargument name="value" type="any" required="true"/>
		<cfset variables.instance[arguments.valueName]  = arguments.value />
	</cffunction>
	
	<cffunction name="isInstantRebateOfferAvailable" access="public" output="false" returntype="boolean">    
    	<cfreturn variables.instance["instantRebateOfferAvailable"]/>    
    </cffunction>    
    <cffunction name="setInstantRebateOfferAvailable" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["instantRebateOfferAvailable"] = arguments.theVar />    
    </cffunction>

    <cffunction name="getOfferPrepaidFreeShipping" access="public" returntype="boolean" output="false">
    	<cfreturn variables.instance.OfferPrepaidFreeShipping />
    </cffunction>
    <cffunction name="setOfferPrepaidFreeShipping" access="public" returntype="void" output="false">
    	<cfargument name="OfferPrepaidFreeShipping" type="boolean" required="true" />
    	<cfset variables.instance.OfferPrepaidFreeShipping = arguments.OfferPrepaidFreeShipping />
    </cffunction>

	<cffunction name="getOrderProcessingTime" access="public" returntype="numeric" output="false">
    	<cfreturn variables.instance.OrderProcessingTime />
    </cffunction>
    <cffunction name="setOrderProcessingTime" access="public" returntype="void" output="false">
    	<cfargument name="OrderProcessingTime" type="numeric" required="true" default="" />
    	<cfset variables.instance.OrderProcessingTime = arguments.OrderProcessingTime />
    </cffunction>
    
    <cffunction name="isPromotionCodeAvailable" access="public" output="false" returntype="boolean">    
    	<cfreturn variables.instance["PromotionCodeAvailable"]/>    
    </cffunction>    
    <cffunction name="setPromotionCodeAvailable" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["PromotionCodeAvailable"] = arguments.theVar />    
    </cffunction>

    <cffunction name="getDisplayCustomerSurveyLink" access="public" returntype="boolean" output="false">
    	<cfreturn variables.instance.DisplayCustomerSurveyLink />
    </cffunction>
    <cffunction name="setDisplayCustomerSurveyLink" access="public" returntype="void" output="false">
    	<cfargument name="DisplayCustomerSurveyLink" type="boolean" required="true" />
    	<cfset variables.instance.DisplayCustomerSurveyLink = arguments.DisplayCustomerSurveyLink />
    </cffunction>
    
    <cffunction name="getDisplayWarrantyDetailInCart" access="public" returntype="boolean" output="false">
    	<cfreturn variables.instance.DisplayWarrantyDetailInCart />
    </cffunction>
    <cffunction name="setDisplayWarrantyDetailInCart" access="public" returntype="void" output="false">
    	<cfargument name="DisplayWarrantyDetailInCart" type="boolean" required="true" />
    	<cfset variables.instance.DisplayWarrantyDetailInCart = arguments.DisplayWarrantyDetailInCart />
    </cffunction>
 	
 	<cffunction name="getDdAdminReturnFilterEnabled" access="public" returntype="boolean" output="false">
    	<cfreturn variables.instance.DdAdminReturnFilterEnabled />
    </cffunction>
    
	<cffunction name="setDdAdminReturnFilterEnabled" output="false" access="public" returntype="void">
		<cfargument name="environment" type="string" default="0" required="false" />
		<cfargument name="DdAdminReturnFilterEnabled" type="struct" default="0" required="false" />
	    <cfscript>
	        if( structKeyExists( arguments.DdAdminReturnFilterEnabled, arguments.environment ) ) 
	        {
				variables.instance.DdAdminReturnFilterEnabled = arguments.DdAdminReturnFilterEnabled[arguments.environment];
	        } 
	        else 
	        {
				throw( "DdAdminReturnFilterEnabled not defined for environment: #arguments.environment#" );
	        }
	    </cfscript>
	</cffunction>
 	
 	<cffunction name="getCEXCHANGE" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.cexchange />
    </cffunction>
    
	<cffunction name="setCEXCHANGE" output="false" access="public" returntype="void">
		<cfargument name="environment" type="string" default="0" required="false" />
		<cfargument name="CEXCHANGEMap" type="struct" default="0" required="false" />
	    <cfscript>
	        if( structKeyExists( arguments.CEXCHANGEMap, arguments.environment ) ) 
	        {
				variables.instance.cexchange = arguments.CEXCHANGEMap[arguments.environment];
	        } 
	        else 
	        {
				throw( "No domain name specified for environment: #arguments.environment#" );
	        }
	    </cfscript>
	</cffunction>
    
 	<cffunction name="getDomainName" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.DomainName />
    </cffunction>
    
	<cffunction name="setDomainName" output="false" access="public" returntype="void">
		<cfargument name="environment" type="string" default="0" required="false" />
		<cfargument name="domainNameMap" type="struct" default="0" required="false" />
	    <cfscript>
	        if( structKeyExists( arguments.domainNameMap, arguments.environment ) ) 
	        {
				variables.instance.domainName = arguments.domainNameMap[arguments.environment];
	        } 
	        else 
	        {
				throw( "No domain name specified for environment: #arguments.environment#" );
	        }
	    </cfscript>
	</cffunction>
	    
    <cffunction name="getAppleCareEnabled" access="public" returntype="boolean" output="false">
    	<cfreturn variables.instance.AppleCareEnabled />
    </cffunction>
    <cffunction name="setAppleCareEnabled" access="public" returntype="void" output="false">
    	<cfargument name="AppleCareEnabled" type="boolean" required="true" />
    	<cfset variables.instance.AppleCareEnabled = arguments.AppleCareEnabled />
    </cffunction>

    <cffunction name="getAppleCarePrefix" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.AppleCarePrefix />
    </cffunction>
    <cffunction name="setAppleCarePrefix" access="public" returntype="void" output="false">
    	<cfargument name="AppleCarePrefix" type="string" required="true" />
    	<cfset variables.instance.AppleCarePrefix = arguments.AppleCarePrefix />
    </cffunction>

	<cffunction name="getAppleCareApiUrl" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.AppleCareAPIUrl />
    </cffunction>
    
	<cffunction name="setAppleCareApiUrl" output="false" access="public" returntype="void">
		<cfargument name="environment" type="string" default="0" required="false" />
		<cfargument name="appleCareAPIMap" type="struct" default="0" required="false" />
	    <cfscript>
	        if( structKeyExists( arguments.AppleCareAPIMap, arguments.environment ) ) 
	        {
				variables.instance.AppleCareApiUrl = arguments.appleCareAPIMap[arguments.environment].url;
	        } 
	        else 
	        {
				throw( "No Apple Care API Map specified for environment: #arguments.environment#" );
	        }
	    </cfscript>
	</cffunction>
	
 	<cffunction name="getAppleCareApiUsername" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.AppleCareApiUsername />
    </cffunction>
    
	<cffunction name="setAppleCareApiUsername" output="false" access="public" returntype="void">
		<cfargument name="environment" type="string" default="0" required="false" />
		<cfargument name="appleCareAPIMap" type="struct" default="0" required="false" />
	    <cfscript>
	        if( structKeyExists( arguments.AppleCareAPIMap, arguments.environment ) ) 
	        {
				variables.instance.AppleCareApiUsername = arguments.appleCareAPIMap[arguments.environment].username;
	        } 
	    </cfscript>
	</cffunction>
	
 	<cffunction name="getAppleCareApiPassword" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.AppleCareApiPassword />
    </cffunction>
    
	<cffunction name="setAppleCareApiPassword" output="false" access="public" returntype="void">
		<cfargument name="environment" type="string" default="0" required="false" />
		<cfargument name="appleCareAPIMap" type="struct" default="0" required="false" />
	    <cfscript>
	        if( structKeyExists( arguments.AppleCareAPIMap, arguments.environment ) ) 
	        {
				variables.instance.AppleCareApiPassword = arguments.appleCareAPIMap[arguments.environment].password;
	        } 
	    </cfscript>
	</cffunction>
	
 	<cffunction name="getAppleCareApiEnabled" access="public" returntype="boolean" output="false">
    	<cfreturn variables.instance.AppleCareApiEnabled />
    </cffunction>
    
	<cffunction name="setAppleCareApiEnabled" output="false" access="public" returntype="void">
		<cfargument name="environment" type="string" default="0" required="false" />
		<cfargument name="appleCareAPIMap" type="struct" default="0" required="false" />
	    <cfscript>
	        if( structKeyExists( arguments.AppleCareAPIMap, arguments.environment ) ) 
	        {
				variables.instance.AppleCareApiEnabled = arguments.appleCareAPIMap[arguments.environment].enabled;
	        } 
	    </cfscript>
	</cffunction>
	
    <cffunction name="getSearchIndexMethod" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.SearchIndexMethod />
    </cffunction>
    <cffunction name="setSearchIndexMethod" access="public" returntype="void" output="false">
    	<cfargument name="SearchIndexMethod" type="string" required="true" />
    	<cfset variables.instance.SearchIndexMethod = arguments.SearchIndexMethod />
    </cffunction>

	<cffunction name="getCustomerCareEmail" output="false" access="public" returntype="string" >
    	<cfreturn variables.instance.CustomerCareEmail />
    </cffunction>
    <cffunction name="setCustomerCareEmail" output="false" access="public" returntype="void">
    	<cfargument name="CustomerCareEmail" type="string" required="true" default="" />
    	<cfset variables.instance.CustomerCareEmail = arguments.CustomerCareEmail>
    </cffunction>

	<cffunction name="getCustomerCarePhone" output="false" access="public" returntype="string">
    	<cfreturn variables.instance.CustomerCarePhone />
    </cffunction>
    <cffunction name="setCustomerCarePhone" output="false" access="public" returntype="void">
    	<cfargument name="CustomerCarePhone" type="string" required="true" default="" />
    	<cfset variables.instance.CustomerCarePhone = arguments.CustomerCarePhone>
    </cffunction>

    <cffunction name="getDisplayProductRebates" access="public" returntype="boolean" output="false">
    	<cfreturn variables.instance.DisplayProductRebates />
    </cffunction>
    <cffunction name="setDisplayProductRebates" access="public" returntype="void" output="false">
    	<cfargument name="DisplayProductRebates" type="boolean" required="true" />
    	<cfset variables.instance.DisplayProductRebates = arguments.DisplayProductRebates />
    </cffunction>

    <cffunction name="getDisplayCarrierCustomerLetter" access="public" returntype="boolean" output="false">
    	<cfreturn variables.instance.DisplayCarrierCustomerLetter />
    </cffunction>
    <cffunction name="setDisplayCarrierCustomerLetter" access="public" returntype="void" output="false">
    	<cfargument name="DisplayCarrierCustomerLetter" type="boolean" required="true" />
    	<cfset variables.instance.DisplayCarrierCustomerLetter = arguments.DisplayCarrierCustomerLetter />
    </cffunction>
    
    <cffunction name="getDisplaySmsOptIn" access="public" returntype="boolean" output="false">
    	<cfreturn variables.instance.DisplaySmsOptIn />
    </cffunction>
    <cffunction name="setDisplaySmsOptIn" access="public" returntype="void" output="false">
    	<cfargument name="DisplaySmsOptIn" type="boolean" required="true" />
    	<cfset variables.instance.DisplaySmsOptIn = arguments.DisplaySmsOptIn />
    </cffunction>

    <cffunction name="getDisplayPrepaidDevices" access="public" returntype="boolean" output="false">
    	<cfreturn variables.instance.DisplayPrepaidDevices />
    </cffunction>
    <cffunction name="setDisplayPrepaidDevices" access="public" returntype="void" output="false">
    	<cfargument name="DisplayPrepaidDevices" type="boolean" required="true" />
    	<cfset variables.instance.DisplayPrepaidDevices = arguments.DisplayPrepaidDevices />
    </cffunction>
    
    <cffunction name="getDisplayPrePaymentGatewayPage" access="public" returntype="boolean" output="false">
    	<cfreturn variables.instance.DisplayPrePaymentGatewayPage />
    </cffunction>
    <cffunction name="setDisplayPrePaymentGatewayPage" access="public" returntype="void" output="false">
    	<cfargument name="DisplayPrePaymentGatewayPage" type="boolean" required="true" />
    	<cfset variables.instance.DisplayPrePaymentGatewayPage = arguments.DisplayPrePaymentGatewayPage />
    </cffunction>    

    <cffunction name="getOfferFinancedDevices" access="public" returntype="boolean" output="false">
    	<cfreturn variables.instance.OfferFinancedDevices />
    </cffunction>
    <cffunction name="setOfferFinancedDevices" access="public" returntype="void" output="false">
    	<cfargument name="OfferFinancedDevices" type="boolean" required="true" />
    	<cfset variables.instance.OfferFinancedDevices = arguments.OfferFinancedDevices />
    </cffunction> 

    <cffunction name="getDirectToRedesignDetailsPage" access="public" returntype="boolean" output="false">
    	<cfreturn variables.instance.DirectToRedesignDetailsPage />
    </cffunction>
    <cffunction name="setDirectToRedesignDetailsPage" access="public" returntype="void" output="false">
    	<cfargument name="DirectToRedesignDetailsPage" type="boolean" required="true" />
    	<cfset variables.instance.DirectToRedesignDetailsPage = arguments.DirectToRedesignDetailsPage />
    </cffunction>

    <cffunction name="getDefaultProductSort" access="public" returntype="string" output="false">
        <cfreturn variables.instance.DefaultProductSort />
    </cffunction>
    <cffunction name="setDefaultProductSort" access="public" returntype="void" output="false">
        <cfargument name="DefaultProductSort" type="string" required="true" />
        <cfset variables.instance.DefaultProductSort = arguments.DefaultProductSort />
    </cffunction>

    <cffunction name="getVfdEnabled" access="public" returntype="boolean" output="false">
    	<cfreturn variables.instance.VfdEnabled />
    </cffunction>
    <cffunction name="setVfdEnabled" access="public" returntype="void" output="false">
    	<cfargument name="VfdEnabled" type="boolean" required="true" />
    	<cfset variables.instance.VfdEnabled = arguments.VfdEnabled />
    </cffunction>
    
    <cffunction name="getTmoRedirectEnabled" access="public" returntype="boolean" output="false">
    	<cfreturn variables.instance.TmoRedirectEnabled />
    </cffunction>
    <cffunction name="setTmoRedirectEnabled" access="public" returntype="void" output="false">
    	<cfargument name="TmoRedirectEnabled" type="boolean" required="true" />
    	<cfset variables.instance.TmoRedirectEnabled = arguments.TmoRedirectEnabled />
    </cffunction>


	<!---<cffunction name="isVfdEnabled" access="public" output="false" returntype="boolean">    
    	<cfreturn variables.instance["VfdEnabled"]/>    
    </cffunction>---> 
    <cffunction name="getCarrierTwoYearRemoval" access="public" returntype="string" output="false">
    	<!---logic here based on variables.instance.CarrierTwoYearRemoval---->
    	<cfset local.carrierExcludeIDs = "">
		<cfloop list="#variables.instance.CarrierTwoYearRemoval#" index="local.i">
		
		<cfset local.thisCarrierDate = ListGetat(local.i, 2, "|")>
		 
		<cfif DateDiff("d", local.thisCarrierDate, Now()) GTE 0>
			<cfset local.thisCarrierID = ListGetat(local.i, 1, "|")>	            			
			<cfset local.carrierExcludeIDs = ListAppend(local.carrierExcludeIDs, local.thisCarrierID)>	
		</cfif>	 
		   			
		</cfloop>
    	<cfreturn local.carrierExcludeIDs />
    </cffunction>
    <cffunction name="setCarrierTwoYearRemoval" access="public" returntype="void" output="false">
    	<cfargument name="CarrierTwoYearRemoval" type="string" required="true" />
    	<cfset variables.instance.CarrierTwoYearRemoval = arguments.CarrierTwoYearRemoval />
    </cffunction>

	<cffunction name="getVfdMkey" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.VfdMkey />
    </cffunction>
    <cffunction name="setVfdMkey" access="public" returntype="void" output="false">
    	<cfargument name="VfdMkey" type="string" required="true" />
    	<cfset variables.instance.VfdMkey = arguments.VfdMkey />
    </cffunction>
    
    <cffunction name="getVfdIV" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.VfdIV />
    </cffunction>
    <cffunction name="setVfdIV" access="public" returntype="void" output="false">
    	<cfargument name="VfdIV" type="string" required="true" />
    	<cfset variables.instance.VfdIV = arguments.VfdIV />
    </cffunction>
    
    <cffunction name="getScenarioDescription" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.ScenarioDescription />
    </cffunction>
    <cffunction name="setScenarioDescription" access="public" returntype="void" output="false">
    	<cfargument name="ScenarioDescription" type="string" required="true" />
    	<cfset variables.instance.ScenarioDescription = arguments.ScenarioDescription />
    </cffunction>
 
    <cffunction name="throw" access="public" returntype="void" output="false" hint="Util function to mimic throw in CF8">
		<cfargument name="detail" type="string" required="true" hint="detail of exception to be thrown">
		<cfthrow message="#arguments.detail#" detail="#arguments.detail#" />
    </cffunction>
    
    <cffunction name="takeADump" returntype="string" >
		<cfsavecontent variable="channelConfigDump">
			<cfdump var="#variables.instance#" />
		</cfsavecontent>
		<cfreturn channelConfigDump />
	</cffunction>	

</cfcomponent>