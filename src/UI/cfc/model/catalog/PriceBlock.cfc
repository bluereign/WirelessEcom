<cfcomponent displayname="PriceBlock" output="false">

	<cfscript>
		variables.instance = {};
	</cfscript>

	<cffunction name="init" output="false" access="public">
		<cfargument name="RetailPrice" type="numeric" default="0" required="false" />
		<cfargument name="NewPrice" type="numeric" default="0" required="false" />
		<cfargument name="UpgradePrice" type="numeric" default="0" required="false" />
		<cfargument name="AddALinePrice" type="numeric" default="0" required="false" />
		<cfargument name="NewPriceAfterRebate" type="numeric" default="0" required="false" />
		<cfargument name="UpgradePriceAfterRebate" type="numeric" default="0" required="false" />
		<cfargument name="AddALinePriceAfterRebate" type="numeric" default="0" required="false" />
		<cfargument name="MonthlyPayment" type="numeric" default="0" required="false" />
		<cfargument name="DownPayment" type="numeric" default="0" required="false" />					

		<cfscript>
        	setRetailPrice( arguments.RetailPrice );
        	setNewPrice( arguments.NewPrice );
        	setUpgradePrice( arguments.UpgradePrice );
        	setAddALinePrice( arguments.AddALinePrice );
        	setNewPriceAfterRebate( arguments.NewPriceAfterRebate );
        	setUpgradePriceAfterRebate( arguments.UpgradePriceAfterRebate );
        	setAddALinePriceAfterRebate( arguments.AddALinePriceAfterRebate );
        	setMonthlyPayment( arguments.MonthlyPayment );
        	setDownPayment( arguments.DownPayment );
        </cfscript>

    	<cfreturn this />
    </cffunction>

	<cffunction name="getDownPayment" output="false" access="public" returntype="numeric">
		
		<cfreturn variables.instance.DownPayment />
    </cffunction>

	<cffunction name="getMonthlyPayment" output="false" access="public" returntype="numeric">
		
		<cfreturn variables.instance.MonthlyPayment />
    </cffunction>

	<cffunction name="getNewRebateAmount" output="false" access="public" returntype="numeric">
		<cfscript>
			var rebateAmount = 0;
			
			if (variables.instance.NewPriceAfterRebate gt 0)
			{
				rebateAmount = variables.instance.NewPrice - variables.instance.NewPriceAfterRebate;
			}
		</cfscript>
		
		<cfreturn rebateAmount />
    </cffunction>


	<cffunction name="getUpgradeRebateAmount" output="false" access="public" returntype="numeric">
		<cfscript>
			var rebateAmount = 0;
			
			if (variables.instance.UpgradePriceAfterRebate gt 0)
			{
				rebateAmount = variables.instance.UpgradePrice - variables.instance.UpgradePriceAfterRebate;
			}
		</cfscript>
		
		<cfreturn rebateAmount />
    </cffunction>

	<cffunction name="getAddaLineRebateAmount" output="false" access="public" returntype="numeric">

		<cfscript>
			var rebateAmount = 0;
			
			if (variables.instance.AddALinePriceAfterRebate gt 0)
			{
				rebateAmount = variables.instance.AddALinePrice - variables.instance.AddALinePriceAfterRebate;
			}
		</cfscript>
		
		<cfreturn rebateAmount />
    </cffunction>

	<cffunction name="hasNewPriceRebate" output="false" access="public" returntype="boolean">
		<cfscript>
			if (variables.instance.NewPriceAfterRebate gt 0)
				return true;
			else
				return false;
		</cfscript>
    </cffunction>

	<cffunction name="hasUpgradePriceRebate" output="false" access="public" returntype="boolean">
		<cfscript>
			if (variables.instance.UpgradePriceAfterRebate gt 0)
				return true;
			else
				return false;
		</cfscript>
    </cffunction>
    
 	<cffunction name="hasAddALinePriceRebate" output="false" access="public" returntype="boolean">
		<cfscript>
			if (variables.instance.AddALinePriceAfterRebate gt 0)
				return true;
			else
				return false;
		</cfscript>
    </cffunction>

	<!--- Savings total after instant savings plus mail-in or instant rebate --->
 	<cffunction name="getSavingsTotal" output="false" access="public" returntype="numeric">
	 	<cfargument name="ActivationType" type="string" required="true" />
	 	
	 	<cfscript>
			var priceAfterSavings = 0;
		
		 	switch (arguments.ActivationType)
		 	{
		 		case 'New':
		 			priceAfterSavings = variables.instance.NewPrice - getNewRebateAmount();
		 			break;
		 		case 'Upgrade':
		 			priceAfterSavings = variables.instance.UpgradePrice - getUpgradeRebateAmount();
		 			break;
		 		case 'Addaline':
		 			priceAfterSavings = variables.instance.AddALinePrice - getAddALineRebateAmount();
		 			break;
		 		case 'NoContract':
		 			priceAfterSavings = variables.instance.RetailPrice;
		 			break;
		 		default:
		 			throw("Invalid activation type provided.");
		 			break;
		 	}
		 	
		 	if ( priceAfterSavings lte 0 && application.wirebox.getInstance("ChannelConfig").getDisplayZeroPricedItems())
		 	{
		 		//Account for rebates that push the pricing to under zero cents that should show up as free
		 		priceAfterSavings = .00;
		 	}
		 	else if ( priceAfterSavings lte .01 )
		 	{
		 		//Account for rebates that push the pricing to under zero cents but should *NOT* show up as free
		 		priceAfterSavings = .01;
		 	}
		</cfscript>
	 	
		<cfreturn priceAfterSavings />
    </cffunction>

	<!--- Setters/Getters--->
	
    <cffunction name="setMonthlyPayment" output="false" access="public" returntype="void">
    	<cfargument name="MonthlyPayment" type="numeric" required="true" default="" />
    	<cfset variables.instance.MonthlyPayment = arguments.MonthlyPayment />
    </cffunction>

    <cffunction name="setDownPayment" output="false" access="public" returntype="void">
    	<cfargument name="DownPayment" type="numeric" required="true" default="" />
    	<cfset variables.instance.DownPayment = arguments.DownPayment />
    </cffunction>
    
    <cffunction name="setRetailPrice" output="false" access="public" returntype="void">
    	<cfargument name="RetailPrice" type="numeric" required="true" default="" />
    	<cfset variables.instance.RetailPrice = arguments.RetailPrice />
    </cffunction>
	<cffunction name="getRetailPrice" output="false" access="public" returntype="numeric">
    	<cfreturn variables.instance.RetailPrice />
    </cffunction>

    <cffunction name="setNewPrice" output="false" access="public" returntype="void">
    	<cfargument name="NewPrice" type="numeric" required="true" default="" />
    	<cfset variables.instance.NewPrice = arguments.NewPrice />
    </cffunction>
	<cffunction name="getNewPrice" output="false" access="public" returntype="numeric">
    	<cfreturn variables.instance.NewPrice />
    </cffunction>
    
    <cffunction name="setUpgradePrice" output="false" access="public" returntype="void">
    	<cfargument name="UpgradePrice" type="numeric" required="true" default="" />
    	<cfset variables.instance.UpgradePrice = arguments.UpgradePrice />
    </cffunction>
	<cffunction name="getUpgradePrice" output="false" access="public" returntype="numeric">
    	<cfreturn variables.instance.UpgradePrice />
    </cffunction>
    
    <cffunction name="setAddALinePrice" output="false" access="public" returntype="void">
    	<cfargument name="AddALinePrice" type="numeric" required="true" default="" />
    	<cfset variables.instance.AddALinePrice = arguments.AddALinePrice />
    </cffunction>
	<cffunction name="getAddALinePrice" output="false" access="public" returntype="numeric">
    	<cfreturn variables.instance.AddALinePrice />
    </cffunction>
    
     <cffunction name="setNewPriceAfterRebate" output="false" access="public" returntype="void">
    	<cfargument name="NewPriceAfterRebate" type="numeric" required="true" default="" />
    	<cfset variables.instance.NewPriceAfterRebate = arguments.NewPriceAfterRebate />
    </cffunction>
	<cffunction name="getNewPriceAfterRebate" output="false" access="public" returntype="numeric">
    	<cfreturn variables.instance.NewPriceAfterRebate />
    </cffunction>
    
    <cffunction name="setUpgradePriceAfterRebate" output="false" access="public" returntype="void">
    	<cfargument name="UpgradePriceAfterRebate" type="numeric" required="true" default="" />
    	<cfset variables.instance.UpgradePriceAfterRebate = arguments.UpgradePriceAfterRebate />
    </cffunction>
	<cffunction name="getUpgradePriceAfterRebate" output="false" access="public" returntype="numeric">
    	<cfreturn variables.instance.UpgradePriceAfterRebate />
    </cffunction>
    
    <cffunction name="setAddALinePriceAfterRebate" output="false" access="public" returntype="void">
    	<cfargument name="AddALinePriceAfterRebate" type="numeric" required="true" default="" />
    	<cfset variables.instance.AddALinePriceAfterRebate = arguments.AddALinePriceAfterRebate />
    </cffunction>
	<cffunction name="getAddALinePriceAfterRebate" output="false" access="public" returntype="numeric">
    	<cfreturn variables.instance.AddALinePriceAfterRebate />
    </cffunction>

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
    	<cfreturn variables.instance />
    </cffunction>

</cfcomponent>