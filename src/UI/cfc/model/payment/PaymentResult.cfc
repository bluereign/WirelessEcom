<!---
	Transient bean containing results of payment processing. Used in each concrete payment gateway
	as well as the PaymentGatewayAsyncListener.cfm and dsp_OrderManager.cfm
--->
<cfcomponent output="false">
	
	<cfset variables.instance = structNew()>

	<!-------------------------- CONSTRUCTOR ---------------------------->

	<cffunction name="init" access="public" returntype="PaymentResult" output="false">
		<cfreturn this>
	</cffunction>

	<!------------------------ GETTERS/SETTERS -------------------------->

	<cffunction name="getAmount" access="public" output="false" returntype="any">
    	<cfreturn variables.instance["Amount"]/>
    </cffunction>
    <cffunction name="setAmount" access="public" output="false" returntype="void">
    	<cfargument name="theVar" required="true" />
    	<cfset variables.instance["amount"] = arguments.theVar />
    </cffunction>

	<cffunction name="getTotalAmount" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["totalAmount"]/>    
    </cffunction>    
    <cffunction name="setTotalAmount" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["totalAmount"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getSalesOrderNumber" access="public" output="false" returntype="string">
    	<cfreturn variables.instance["salesOrderNumber"]/>
    </cffunction>
    <cffunction name="setSalesOrderNumber" access="public" output="false" returntype="void">
    	<cfargument name="theVar" required="true" />
    	<cfset variables.instance["salesOrderNumber"] = arguments.theVar />
    </cffunction>

    <cffunction name="getCustomerIP" access="public" output="false" returntype="string">
    	<cfreturn variables.instance["customerIP"]/>
    </cffunction>
    <cffunction name="setCustomerIP" access="public" output="false" returntype="void">
    	<cfargument name="theVar" required="true" />
    	<cfset variables.instance["customerIP"] = arguments.theVar />
    </cffunction>

    <cffunction name="getReceiptNumber" access="public" output="false" returntype="string">
    	<cfreturn variables.instance["receiptNumber"]/>
    </cffunction>
    <cffunction name="setReceiptNumber" access="public" output="false" returntype="void">
    	<cfargument name="theVar" required="true" />
    	<cfset variables.instance["receiptNumber"] = arguments.theVar />
    </cffunction>

    <cffunction name="getCCType" access="public" output="false" returntype="string">
    	<cfreturn variables.instance["CCType"]/>
    </cffunction>
    <cffunction name="setCCType" access="public" output="false" returntype="void">
    	<cfargument name="theVar" required="true" />
    	<cfset variables.instance["CCType"] = arguments.theVar />
    </cffunction>

    <cffunction name="getGUID" access="public" output="false" returntype="string">
    	<cfreturn variables.instance["GUID"]/>
    </cffunction>
    <cffunction name="setGUID" access="public" output="false" returntype="void">
    	<cfargument name="theVar" required="true" />
    	<cfset variables.instance["GUID"] = arguments.theVar />
    </cffunction>

    <cffunction name="getVerbiage" access="public" output="false" returntype="string">
    	<cfreturn variables.instance["verbiage"]/>
    </cffunction>
    <cffunction name="setVerbiage" access="public" output="false" returntype="void">
    	<cfargument name="theVar" required="true" />
    	<cfset variables.instance["verbiage"] = arguments.theVar />
    </cffunction>

    <cffunction name="getPaymentToken" access="public" output="false" returntype="string">
    	<cfreturn variables.instance["paymentToken"]/>
    </cffunction>
    <cffunction name="setPaymentToken" access="public" output="false" returntype="void">
    	<cfargument name="theVar" required="true" />
    	<cfset variables.instance["paymentToken"] = arguments.theVar />
    </cffunction>

    <cffunction name="getTransactionType" access="public" returntype="any" output="false">
    	<cfreturn variables.instance["transactionType"] />
    </cffunction>
    <cffunction name="setTransactionType" access="public" returntype="void" output="false">
    	<cfargument name="theVar" type="any" required="true" default="" />
    	<cfset variables.instance["transactionType"] = arguments.theVar>
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