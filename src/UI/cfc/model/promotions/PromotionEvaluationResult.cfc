<cfcomponent output="false">
	
	<cffunction name="init" access="public" output="false" returntype="PromotionEvaluationResult">
		<cfargument name="passed" required="false" type="boolean" default="false">
		<cfargument name="message" required="false" type="string" default="Promotion does not apply to the cart.">
		<cfargument name="promotionID" required="false" type="numeric" default="0">
		<cfargument name="code" required="false" type="numeric" default="0">
		<cfargument name="discount" required="false" type="numeric" default="0">
		<cfargument name="discountType" required="false" type="string" default="" hint="Percent/Flat">
		<cfargument name="items" required="false" type="array" default="#arrayNew(1)#" hint="GERS SKUs">
		<cfargument name="name" required="false" type="string" default="">
		<cfargument name="discountFrom" required="false" type="string" default="" hint="cart,item,shipping">
		
		<cfscript>
			setPassed(arguments.passed);
			setMessage(arguments.message);
			setPromotionID(arguments.promotionID);
			setCode(arguments.code);
			setDiscount(arguments.discount);
			setDiscountType(arguments.discountType);
			setItems(arguments.items);
			setName(arguments.name);
			setDiscountFrom(arguments.discountFrom);
			
			return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="passed" access="public" output="false" returntype="any">
		<cfargument name="success" type="boolean" required="false">
		<cfif structKeyExists(arguments, "success")>
			<cfreturn setPassed(arguments.success)>
		<cfelse>
			<cfreturn getPassed()>
		</cfif>
	</cffunction>
	
	<!--- GETTERS/SETTERS --->
	
	<cffunction name="getPassed" access="public" output="false" returntype="boolean">    
    	<cfreturn variables.instance["passed"]/>    
    </cffunction>    
    <cffunction name="setPassed" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["passed"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getMessage" access="public" output="false" returntype="string">
    	<cfreturn variables.instance["message"]/>    
    </cffunction>    
    <cffunction name="setMessage" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["message"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getCode" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["code"]/>    
    </cffunction>    
    <cffunction name="setCode" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["code"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getPromotionID" access="public" output="false" returntype="numeric">    
    	<cfreturn variables.instance["promotionID"]/>    
    </cffunction>    
    <cffunction name="setPromotionID" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["promotionID"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getDiscount" access="public" output="false" returntype="numeric">    
    	<cfreturn variables.instance["discount"]/>    
    </cffunction>    
    <cffunction name="setDiscount" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["discount"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getDiscountType" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["discountType"]/>    
    </cffunction>    
    <cffunction name="setDiscountType" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["discountType"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getItems" access="public" output="false" returntype="array">    
    	<cfreturn variables.instance["items"]/>    
    </cffunction>    
    <cffunction name="setItems" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["items"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getName" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["name"]/>    
    </cffunction>    
    <cffunction name="setName" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["name"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getDiscountFrom" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["discountFrom"]/>    
    </cffunction>    
    <cffunction name="setDiscountFrom" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["discountFrom"] = arguments.theVar />    
    </cffunction>
    
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