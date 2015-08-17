<cfcomponent displayname="TextDisplayRenderer" hint="Handle text display differences between channels" output="false">

	<cfscript>
		variables.instance = {};
	</cfscript>

	<cffunction name="init" output="false" access="public">
		<cfargument name="BusinessName" type="string" required="true" />
		<cfargument name="StoreAliasName" type="string" required="true" />
		<cfargument name="KioskName" type="string" required="true" />
		<cfargument name="CustomerAliasName" type="string" required="true" />
		<cfargument name="GersCustomerIdPreFix" type="string" required="true" />
		<cfargument name="CartDialogWarrantyTitle" type="string" required="true" />
		<cfargument name="TmobilePriceBlockBonusOffer" type="string" required="true" /> <!--- Temp T-Mobile priceblock --->
		<cfargument name="OutOfStockButtonText" type="string" required="false" default="Out of Stock" />
		<cfargument name="OutOfStockAlertText" type="string" required="false" default="This item is currently out of stock." />
		<cfargument name="CreditCheckCustomerIdText" type="string" required="true" />
		<cfargument name="PriceLabelText" type="string" required="true" />
		<cfargument name="Hide2YearFinancingButtonText" type="string" required="false" />
		
		<cfscript>
        	setBusinessName( arguments.BusinessName );
        	setStoreAliasName( arguments.StoreAliasName );
        	setKioskName( arguments.KioskName );
        	setCustomerAliasName( arguments.CustomerAliasName );
        	setGersCustomerIdPreFix( arguments.GersCustomerIdPreFix );
        	setCartDialogWarrantyTitle( arguments.CartDialogWarrantyTitle );
        	setTmobilePriceBlockBonusOffer( arguments.TmobilePriceBlockBonusOffer );
        	setOutOfStockButtonText( arguments.OutOfStockButtonText );
         	setOutOfStockAlertText( arguments.OutOfStockAlertText );
         	setCreditCheckCustomerIdText( arguments.CreditCheckCustomerIdText );
         	setPriceLabelText( arguments.PriceLabelText );
         	setHide2YearFinancingButtonText( arguments.Hide2YearFinancingButtonText );
       </cfscript>

    	<cfreturn this />
    </cffunction>

	<cffunction name="getBusinessName" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.BusinessName />
    </cffunction>
    <cffunction name="setBusinessName" access="public" returntype="void" output="false">
    	<cfargument name="BusinessName" type="string" required="true" default="" />
    	<cfset variables.instance.BusinessName = arguments.BusinessName />
    </cffunction>

	<cffunction name="getStoreAliasName" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.StoreAliasName />
    </cffunction>
    <cffunction name="setStoreAliasName" access="public" returntype="void" output="false">
    	<cfargument name="StoreAliasName" type="string" required="true" default="" />
    	<cfset variables.instance.StoreAliasName = arguments.StoreAliasName />
    </cffunction>

	<cffunction name="getKioskName" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.KioskName />
    </cffunction>
    <cffunction name="setKioskName" access="public" returntype="void" output="false">
    	<cfargument name="KioskName" type="string" required="true" default="" />
    	<cfset variables.instance.KioskName = arguments.KioskName />
    </cffunction>

	<cffunction name="getCustomerAliasName" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.CustomerAliasName />
    </cffunction>
    <cffunction name="setCustomerAliasName" access="public" returntype="void" output="false">
    	<cfargument name="CustomerAliasName" type="string" required="true" default="" />
    	<cfset variables.instance.CustomerAliasName = arguments.CustomerAliasName />
    </cffunction>

	<cffunction name="getGersCustomerIdPreFix" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.GersCustomerIdPreFix />
    </cffunction>
    <cffunction name="setGersCustomerIdPreFix" access="public" returntype="void" output="false">
    	<cfargument name="GersCustomerIdPreFix" type="string" required="true" default="" />
    	<cfset variables.instance.GersCustomerIdPreFix = arguments.GersCustomerIdPreFix />
    </cffunction>

	<cffunction name="getCartDialogWarrantyTitle" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.CartDialogWarrantyTitle />
    </cffunction>
    <cffunction name="setCartDialogWarrantyTitle" access="public" returntype="void" output="false">
    	<cfargument name="CartDialogWarrantyTitle" type="string" required="true" default="" />
    	<cfset variables.instance.CartDialogWarrantyTitle = arguments.CartDialogWarrantyTitle />
    </cffunction>

	<cffunction name="getTmobilePriceBlockBonusOffer" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.TmobilePriceBlockBonusOffer />
    </cffunction>
    <cffunction name="setTmobilePriceBlockBonusOffer" access="public" returntype="void" output="false">
    	<cfargument name="TmobilePriceBlockBonusOffer" type="string" required="true" default="" />
    	<cfset variables.instance.TmobilePriceBlockBonusOffer = arguments.TmobilePriceBlockBonusOffer />
    </cffunction>
    
	<cffunction name="getOutOfStockButtonText" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.OutOfStockButtonText />
    </cffunction>
    <cffunction name="setOutOfStockButtonText" access="public" returntype="void" output="false">
    	<cfargument name="OutOfStockButtonText" type="string" required="true" default="" />
    	<cfset variables.instance.OutOfStockButtonText = arguments.OutOfStockButtonText />
    </cffunction>
    
	<cffunction name="getOutOfStockAlertText" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.OutOfStockAlertText />
    </cffunction>
    <cffunction name="setOutOfStockAlertText" access="public" returntype="void" output="false">
    	<cfargument name="OutOfStockAlertText" type="string" required="true" default="" />
    	<cfset variables.instance.OutOfStockAlertText = arguments.OutOfStockAlertText />
    </cffunction>

	<cffunction name="getCreditCheckCustomerIdText" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.CreditCheckCustomerIdText />
    </cffunction>
    <cffunction name="setCreditCheckCustomerIdText" access="public" returntype="void" output="false">
    	<cfargument name="CreditCheckCustomerIdText" type="string" required="true" default="" />
    	<cfset variables.instance.CreditCheckCustomerIdText = arguments.CreditCheckCustomerIdText />
    </cffunction>
    
	<cffunction name="getPriceLabelText" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.PriceLabelText />
    </cffunction>
    <cffunction name="setPriceLabelText" access="public" returntype="void" output="false">
    	<cfargument name="PriceLabelText" type="string" required="true" default="" />
    	<cfset variables.instance.PriceLabelText = arguments.PriceLabelText />
    </cffunction>
    
	<cffunction name="getHide2YearFinancingButtonText" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.Hide2YearFinancingButtonText />
    </cffunction>
    <cffunction name="setHide2YearFinancingButtonText" access="public" returntype="void" output="false">
    	<cfargument name="Hide2YearFinancingButtonText" type="string" required="true" default="" />
    	<cfset variables.instance.Hide2YearFinancingButtonText = arguments.Hide2YearFinancingButtonText />
    </cffunction>


</cfcomponent>