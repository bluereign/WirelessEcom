<cfcomponent output="false">
	
	<cffunction name="init" access="public" output="false" returntype="InstantRebateService">
		<cfargument name="accessoryMinPurchaseAmt" type="numeric" required="true">
		<cfargument name="InstantRebateGateway" type="any" required="true">
		<cfargument name="ChannelConfig" type="any" required="true">

		<cfscript>
			setAccessoryMinPurchaseAmt( arguments.accessoryMinPurchaseAmt );
			setInstantRebateGateway( arguments.InstantRebateGateway );
			setChannelConfig( arguments.ChannelConfig );
			
			return this;
		</cfscript>
		
	</cffunction>
	
	<!----------------- PUBLIC ------------------->
	
	<cffunction name="getQualifyingAmt" access="public" output="false" returntype="numeric" hint="Determines if cart line item qualifies for converting a MIR to an instant rebate. Returns 0.00 if no instant rebate is available.">
		<cfargument name="cartLine" required="true" type="cfc.model.CartLine">
		
		<cfscript>
			var i = 1;
			var ineligibleAmt = "0.00";
			var accessoryTotalAmt = "0.00";
			var sku = "";
			var regularPriceGroup = "";
			var rebatePriceGroup = "";
			var rebateAmt = 0;
			var accessories = "";
			
			//Disabled instant rebates using config setting
			if( !getChannelConfig().isInstantRebateOfferAvailable() ) {
				return 0;
			}
			
			sku = arguments.cartLine.getPhone().getGersSku();
			regularPriceGroup = getRegularPriceGroup( arguments.cartLine.getCart().getActivationType() );
			rebatePriceGroup = getRebatePriceGroup( regularPriceGroup );
			rebateAmt = getRebateAmtBySKU( sku, regularPriceGroup, rebatePriceGroup );
			accessories = arguments.cartLine.getAccessories();

			// Check sku for rebate
			if( rebateAmt eq ineligibleAmt ) {
				return ineligibleAmt;
			}
				
			// Calculate accessory total
			for( i=1; i <= arrayLen(accessories); i++ ) {
				if( accessories[i].getType() eq "accessory" ) {
					accessoryTotalAmt += accessories[i].getPrices().getDueToday();
				}
			}
			
			// Check additional business rules for eligibility
			if( arguments.cartLine.getWarranty().hasBeenSelected() || accessoryTotalAmt gte getAccessoryMinPurchaseAmt() ) {
				return rebateAmt;
			} else {
				return ineligibleAmt;
			}
		</cfscript>
		
	</cffunction>
	
	<cffunction name="getRebateAmtBySKU" access="public" output="false" returntype="numeric" hint="Returns the dollar amount of an eligible instant rebate. If no rebates are available, returns 0.00">
		<cfargument name="sku" required="true" type="string">
		<cfargument name="regularPriceGroup" required="true" type="string">
		<cfargument name="rebatePriceGroup" required="true" type="string">
		
		<cfscript>
			var qRebateAmt = getInstantRebateGateway().getInstantRebateAmt( argumentCollection = arguments );
				
			if( isNumeric( qRebateAmt.rebateAmount ) ) {
				return qRebateAmt.rebateAmount;
			} else {
				return 0;
			}		
		</cfscript>
		
	</cffunction>
	
	<cffunction name="getRegularPriceGroup" access="public" output="false" returntype="string" hint="Returns the regular price group code based upon activation type.">
		<cfargument name="activationType" type="string" required="true">
		
		<cfscript>
			switch( arguments.activationType ) {
				case "new" : {
					return "ECN";
				}
				
				case "upgrade" : {
					return "ECU";
				}
				
				case "addaline" : {
					return "ECA";
				}
				
				default : {
					return "ECP";
				}
			}
		</cfscript>
		
	</cffunction> 
	
	<cffunction name="getRebatePriceGroup" access="public" output="false" returntype="string" hint="Returns the rebate price group code based upon regular price group.">
		<cfargument name="priceGroup" type="string" required="true">
		
		<cfscript>
			switch( arguments.priceGroup) {
				case "ECN" : {
					return "ERN";
				}
				
				case "ECU" : {
					return "ERU";
				}
				
				case "ECA" : {
					return "ERA";
				}
				
				default : {
					return arguments.priceGroup;
				}
			}
		</cfscript>
		
	</cffunction> 
	
	<!----------------- GETTERS/SETTERS ------------------->
	
	<cffunction name="getAccessoryMinPurchaseAmt" access="public" output="false" returntype="numeric">    
		<cfreturn variables.instance["accessoryMinPurchaseAmt"]/>    
	</cffunction>    
	<cffunction name="setAccessoryMinPurchaseAmt" access="public" output="false" returntype="void">    
		<cfargument name="theVar" required="true" />    
		<cfset variables.instance["accessoryMinPurchaseAmt"] = arguments.theVar />    
	</cffunction>
	
	<cffunction name="getInstantRebateGateway" access="public" output="false" returntype="any">    
    	<cfreturn variables.instance["InstantRebateGateway"]/>    
    </cffunction>    
    <cffunction name="setInstantRebateGateway" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["InstantRebateGateway"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getChannelConfig" access="public" output="false" returntype="any">    
    	<cfreturn variables.instance["ChannelConfig"]/>    
    </cffunction>    
    <cffunction name="setChannelConfig" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["ChannelConfig"] = arguments.theVar />    
    </cffunction>

</cfcomponent>