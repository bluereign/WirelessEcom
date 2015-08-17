<cfcomponent output="false" displayname="CartLine">

	<cffunction name="init" returntype="cfc.model.CartLine">
		<cfargument name="alias" type="string" required="false" default="" />
		<cfargument name="phone" type="any" required="false" default="#createobject('component','cfc.model.CartItem').init()#" />
		<cfargument name="plan" type="any" required="false" default="#createobject('component','cfc.model.CartItem').init()#" />
		<cfargument name="planType" type="string" required="false" default="" />
        <cfargument name="addALineType" type="string" required="false" default="" /> <!--- Ind, Family --->
		<cfargument name="activationFee" type="any" required="false" default="#createobject('component','cfc.model.CartItem').init()#" />
		<cfargument name="features" type="array" required="false" default="#arrayNew(1)#" />
		<cfargument name="declineFeatures" type="boolean" required="false" default="false" />
		<cfargument name="accessories" type="array" required="false" default="#arrayNew(1)#" />
		<cfargument name="declineAccessories" type="boolean" required="false" default="false" />
		<cfargument name="prices" type="any" required="false" default="#createobject('component','cfc.model.CartPriceBlock').init()#" />
		<cfargument name="taxes" type="any" required="false" default="#createobject('component','cfc.model.CartPriceBlock').init()#" />
		<cfargument name="Warranty" type="any" required="false" default="#createobject('component','cfc.model.CartItem').init()#" />
		<cfargument name="declineWarranty" type="boolean" required="false" default="false" />
		<cfargument name="instantRebateAmount" type="numeric" required="false" default="0" />
		<cfargument name="planIDCount" type="numeric" required="false" default="1" /> <!--- Num of previous lines (in cart) with the same plan ID (running total) --->
		<cfargument name="cartLineActivationType" type="string" required="false" default="" />
		
		<cfscript>
			variables.instance = {};
			setAlias(arguments.alias);
			setPhone(arguments.phone);
			setPlan(arguments.plan);
			setPlanType(arguments.planType);
			setActivationFee(arguments.activationFee);
			setFeatures(arguments.features);
			setDeclineFeatures(arguments.declineFeatures);
			setAccessories(arguments.accessories);
			setDeclineAccessories(arguments.declineAccessories);
			setPrices(arguments.prices);
			setTaxes(arguments.taxes);
	        setAddALineType(arguments.addALineType);
	        setWarranty(arguments.Warranty);
			setDeclineWarranty(arguments.declineWarranty);
			setInstantRebateAmount(arguments.instantRebateAmount);
			setPlanIDCount(arguments.planIDCount);
			setCartLineActivationType(arguments.cartLineActivationType);
		</cfscript>
		
		<cfreturn this />
	</cffunction>

	<!--- getters --->

	<cffunction name="getAlias" returntype="string" output="false">
		<cfreturn variables.instance.alias>
	</cffunction>

	<cffunction name="getPhone" returntype="any" output="false">
		<cfreturn variables.instance.phone>
	</cffunction>

	<cffunction name="getPlan" returntype="any" output="false">
		<cfreturn variables.instance.plan>
	</cffunction>

	<cffunction name="getPlanType" returntype="string" output="false">
		<cfreturn variables.instance.planType>
	</cffunction>
    
    <cffunction name="getAddALineType" returntype="string" output="false">
		<cfreturn variables.instance.addALineType>
	</cffunction>

	<cffunction name="getActivationFee" returntype="any" output="false">
		<cfreturn variables.instance.activationFee>
	</cffunction>

	<cffunction name="getFeatures" returntype="array" output="false">
		<cfreturn variables.instance.features>
	</cffunction>

	<cffunction name="getDeclineFeatures" returntype="boolean" output="false">
		<cfreturn variables.instance.declineFeatures>
	</cffunction>

	<cffunction name="getAccessories" returntype="array" output="false">
		<cfreturn variables.instance.accessories>
	</cffunction>

	<cffunction name="getDeclineAccessories" returntype="boolean" output="false">
		<cfreturn variables.instance.declineAccessories>
	</cffunction>

	<cffunction name="getWarranty" returntype="any" output="false">
		<cfreturn variables.instance.Warranty>
	</cffunction>

	<cffunction name="getDeclineWarranty" returntype="boolean" output="false">
		<cfreturn variables.instance.declineWarranty>
	</cffunction>

	<cffunction name="getPrices" returntype="any" output="false">
		<cfreturn variables.instance.prices>
	</cffunction>
    
	<cffunction name="getTaxes" returntype="any" output="false">
		<cfreturn variables.instance.taxes>
	</cffunction>
	
	<cffunction name="getInstantRebateAmount" access="public" output="false" returntype="numeric">
    	<cfreturn variables.instance["instantRebateAmount"]/>    
    </cffunction> 
    
    <cffunction name="getCartLineActivationType" returntype="string" output="false">
		<cfreturn variables.instance.cartLineActivationType>
	</cffunction>

	<!--- setters --->

	<cffunction name="setAlias" returntype="void">
		<cfargument name="alias" type="string" required="true">
		<cfset variables.instance.alias = arguments.alias>
	</cffunction>

	<cffunction name="setPhone" returntype="void">
		<cfargument name="phone" type="any" required="true">
		<cfset variables.instance.phone = arguments.phone>
	</cffunction>

	<cffunction name="setPlan" returntype="void">
		<cfargument name="plan" type="any" required="true">
		<cfset variables.instance.plan = arguments.plan>
	</cffunction>

	<cffunction name="setPlanType" returntype="void" hint="Ind, Family">
		<cfargument name="planType" type="string" required="true">
		<cfset variables.instance.planType = arguments.planType>
	</cffunction>
    
    <cffunction name="setAddALineType" returntype="void">
		<cfargument name="addALineType" type="string" required="true">
		<cfset variables.instance.addALineType = arguments.addALineType>
	</cffunction>

	<cffunction name="setActivationFee" returntype="void">
		<cfargument name="activationFee" type="any" required="true">
		<cfset variables.instance.activationFee = arguments.activationFee>
	</cffunction>

	<cffunction name="setFeatures" returntype="void">
		<cfargument name="features" type="array" required="true">
		<cfset variables.instance.features = arguments.features>
	</cffunction>

	<cffunction name="setDeclineFeatures" returntype="void">
		<cfargument name="declineFeatures" type="boolean" required="true">
		<cfset variables.instance.declineFeatures = arguments.declineFeatures>
	</cffunction>

	<cffunction name="setAccessories" returntype="void">
		<cfargument name="accessories" type="array" required="true">
		<cfset variables.instance.accessories = arguments.accessories>
	</cffunction>

	<cffunction name="setDeclineAccessories" returntype="void">
		<cfargument name="declineAccessories" type="boolean" required="true">
		<cfset variables.instance.declineAccessories = arguments.declineAccessories>
	</cffunction>

	<cffunction  name="setWarranty" returntype="void">
		<cfargument name="Warranty" type="any" required="true" />
		<cfset variables.instance.Warranty = arguments.Warranty />
	</cffunction>

	<cffunction  name="setDeclineWarranty" returntype="void">
		<cfargument name="declineWarranty" type="boolean" required="true" />
		<cfset variables.instance.declineWarranty = arguments.declineWarranty />
	</cffunction>

	<cffunction name="setPrices" returntype="void">
		<cfargument name="prices" type="any" required="true">
		<cfset variables.instance.prices = arguments.prices>
	</cffunction>

	<cffunction name="setTaxes" returntype="void">
		<cfargument name="taxes" type="any" required="true">
		<cfset variables.instance.taxes = arguments.taxes>
	</cffunction>
	
    <cffunction name="setInstantRebateAmount" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["instantRebateAmount"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getPlanIDCount" access="public" output="false" returntype="numeric">    
    	<cfreturn variables.instance["planIDCount"]/>    
    </cffunction>
        
    <cffunction name="setPlanIDCount" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["planIDCount"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getCart" access="public" output="false" returntype="any">
		<cfif structKeyExists( session, "cart" )>
			<cfreturn session.cart>
		<cfelse>
			<cfreturn createObject( "component", "cfc.model.Cart" ).init()>
		</cfif>
	</cffunction>
	
	<cffunction name="setCartLineActivationType" returntype="void" hint="">
		<cfargument name="cartLineActivationType" type="string" required="true">
		<cfset variables.instance.cartLineActivationType = arguments.cartLineActivationType>
	</cffunction>

	<cffunction name="getCartItems" access="public" output="false" returntype="array">
		<cfargument name="includeWithoutSKU" type="boolean" default="false" />
		
		<cfscript>
			var Accessory = "";
			var items = [];
			var Phone = getPhone();
			var Plan = getPlan();
			var ActivationFee = getActivationFee();
			var Warranty = getWarranty();
			var accessories = getAccessories();
			var i = 1;
			
			if( includeWithoutSKU ) {
				
				arrayAppend( items, Phone );
				arrayAppend( items, Plan );
				arrayAppend( items, ActivationFee );
				arrayAppend( items, Warranty );
				
				if( arrayLen(accessories) ) {
					for( i=1; i <= arrayLen(accessories); i++ ) {
						arrayAppend( items, accessories[i] );
					}
				}
				
			} else {
				
				if( len(Phone.getGersSKU()) )
					arrayAppend( items, Phone );
				if( len(Plan.getGersSKU()) )
					arrayAppend( items, Plan );
				if( len(ActivationFee.getGersSKU() ) )
					arrayAppend( items, ActivationFee );
				if( len(Warranty.getGersSKU() ) )
					arrayAppend( items, Warranty );
				
				if( arrayLen(accessories) ) {
					for( i=1; i <= arrayLen(accessories); i++ ) {
						if( len(accessories[i].getGersSKU() ) )
							arrayAppend( items, accessories[i] );
					}
				}
			}

			return items;
		</cfscript>
	</cffunction>

	<!--- DUMP --->

	<cffunction name="dump" access="public" output="true" return="void">
		<cfargument name="abort" type="boolean" default="FALSE" />
		<cfdump var="#variables.instance#" />
		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>

	<!--- GETINSTANCE --->

	<cffunction name="getInstanceData" access="public" output="false" return="struct">
		<cfargument name="recursive" type="boolean" required="false" default="false">
		<cfset var local = structNew()>
		<cfset local.instance = duplicate(variables.instance)>

		<cfif arguments.recursive>
			<cfloop collection="#local.instance#" item="local.key">
				<cfif not isSimpleValue(local.instance[local.key])>
					<cfif isArray(local.instance[local.key])>
						<cfloop from="#1#" to="#arrayLen(local.instance[local.key])#" index="local.ii">
							<cfset local.instance[local.key][local.ii] = local.instance[local.key][local.ii].getInstanceData(arguments.recursive)>
						</cfloop>
					<cfelseif structKeyExists(local.instance[local.key],"getInstanceData")>
						<cfset local.instance[local.key] = local.instance[local.key].getInstanceData(arguments.recursive)>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>

		<cfreturn local.instance>
	</cffunction>

</cfcomponent>