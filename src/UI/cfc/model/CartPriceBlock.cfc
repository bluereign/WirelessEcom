<cfcomponent output="false" displayname="CartPriceBlock">

	<cffunction name="init" access="public" returntype="cfc.model.CartPriceBlock" output="false">
		<cfargument name="dueToday" type="numeric" required="false" default="0" />
		<cfargument name="firstBill" type="numeric" required="false" default="0" />
		<cfargument name="monthly" type="numeric" required="false" default="0" />
		<cfargument name="COGS" type="numeric" required="false" default="0" />
		<cfargument name="retailPrice" type="numeric" required="false" default="0" />
		<cfargument name="discountTotal" type="numeric" required="false" default="0" />
		<cfargument name="promotionCodes" type="struct" required="false" default="#structNew()#" />

		<cfset variables.instance = structNew() />
		<cfset setDueToday(arguments.dueToday) />
		<cfset setFirstBill(arguments.firstBill) />
		<cfset setMonthly(arguments.monthly) />
		<cfset setCOGS(arguments.cogs) />
		<cfset setRetailPrice(arguments.retailPrice) />
		<cfset setDiscountTotal(arguments.discountTotal) />
		<cfset setPromotionCodes(arguments.promotionCodes) />

		<cfreturn this />
	</cffunction>

	<cffunction name="getDueToday" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.dueToday />
	</cffunction>

	<cffunction name="getFirstBill" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.firstBill />
	</cffunction>

	<cffunction name="getMonthly" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.monthly />
	</cffunction>

	<cffunction name="getCOGS" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.cogs />
	</cffunction>

	<cffunction name="getRetailPrice" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.retailPrice />
	</cffunction>

	<cffunction name="getDiscountTotal" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.discountTotal />
	</cffunction>

	<cffunction name="setDueToday" access="public" returntype="void" output="false">
		<cfargument name="dueToday" type="numeric" required="true" />

		<cfset variables.instance.dueToday = arguments.dueToday />
	</cffunction>

	<cffunction name="setFirstBill" access="public" returntype="void" output="false">
		<cfargument name="firstBill" type="numeric" required="true" />

		<cfset variables.instance.firstBill = arguments.firstBill />
	</cffunction>

	<cffunction name="setMonthly" access="public" returntype="void" output="false">
		<cfargument name="monthly" type="numeric" required="true" />

		<cfset variables.instance.monthly = arguments.monthly />
	</cffunction>

	<cffunction name="setCOGS" access="public" returntype="void" output="false">
		<cfargument name="cogs" type="numeric" required="true" />

		<cfset variables.instance.cogs = arguments.cogs />
	</cffunction>

	<cffunction name="setRetailPrice" access="public" returntype="void" output="false">
		<cfargument name="retailPrice" type="numeric" required="true" />

		<cfset variables.instance.retailPrice = arguments.retailPrice />
	</cffunction>

	<cffunction name="setDiscountTotal" access="public" returntype="void" output="false">
		<cfargument name="discountTotal" type="numeric" required="true" />

		<cfset variables.instance.discountTotal = arguments.discountTotal />
	</cffunction>

	<cffunction name="getPromotionCodes" access="public" output="false" returntype="struct">    
    	<cfreturn variables.instance["promotionCodes"]/>    
    </cffunction>    

    <cffunction name="setPromotionCodes" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["promotionCodes"] = arguments.theVar />    
    </cffunction> 
        
    <cffunction name="addPromotion" access="public" output="false" returntype="void">
		<cfargument name="code" type="string" required="true">
		<cfargument name="name" type="String" required="true">
		<cfargument name="promotionID" type="numeric" required="true">
		<cfargument name="value" type="any" required="true">
		<cfset variables.instance.promotionCodes[arguments.code] = { name = arguments.name, promotionID = arguments.promotionID, value = arguments.value }>
	</cffunction>
	
	<cffunction name="removePromotion" access="public" output="false" returntype="void">
		<cfargument name="code" type="string" required="true">
		<cfset structDelete( variables.instance.promotionCodes, arguments.code )>
	</cffunction>
	
	<cffunction name="hasPromotion" access="public" output="false" returntype="boolean">
		<cfargument name="code" type="string" required="false">
		<cfargument name="promotionID" type="numeric" required="false">
		
		<cfscript>
			var i = 1;
			var codes = getPromotionCodes();
			var keys = listToArray( structKeyList( codes ) );
			
			if( structKeyExists( arguments, "promotionID" ) ) {
				for( i=1; i <= arrayLen(keys); i++  ) {
					if( codes[keys[i]].promotionID == arguments.promotionID ) {
						return true;
					}
				}
				return false;	
			} else {
				return structKeyExists( variables.instance.promotionCodes, arguments.code ); 
			}
		</cfscript>
		
	</cffunction>

	<cffunction name="dump" access="public" output="true" return="void">
		<cfargument name="abort" type="boolean" default="false" />

		<cfdump var="#variables.instance#" />

		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>

	<cffunction name="getInstanceData" access="public" output="false" return="struct">
		<cfargument name="recursive" type="boolean" required="false" default="false" />

		<cfset var local = structNew() />
		<cfset local.instance = duplicate(variables.instance) />

		<cfif arguments.recursive>
			<cfloop collection="#local.instance#" item="local.key">
				<cfif not isSimpleValue(local.instance[local.key])>
					<cfif isArray(local.instance[local.key])>
						<cfloop from="#1#" to="#arrayLen(local.instance[local.key])#" index="local.ii">
							<cfset local.instance[local.key][local.ii] = local.instance[local.key][local.ii].getInstanceData(arguments.recursive) />
						</cfloop>
					<cfelseif structKeyExists(local.instance[local.key], 'getInstanceData')>
						<cfset local.instance[local.key] = local.instance[local.key].getInstanceData(arguments.recursive) />
					</cfif>
				</cfif>
			</cfloop>
		</cfif>

		<cfreturn local.instance />
	</cffunction>
</cfcomponent>