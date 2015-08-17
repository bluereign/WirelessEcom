<cfcomponent output="false" extends="AbstractAPI">

	<cffunction name="init" output="false" access="public" returntype="ActivationRequest">
		<cfargument name="orderId" type="numeric" required="true" />
		<cfargument name="wirelessLineId" type="numeric" required="true" />
		<cfargument name="mdn" type="string" default="" />
		<cfargument name="secretPin" type="string" default="" />
		<cfargument name="securityQuestionAnswer" type="string" default="" />
		<cfargument name="ssn" type="string" default="" />
		<cfargument name="customerType" type="string" default="INDIVIDUAL" />
		<cfargument name="orderType" type="string" default="" />
		<cfargument name="handsetCount" type="numeric" default="0" />
		<cfargument name="referenceNumber" type="string" default="" />
		
		<cfscript>
			setOrderId(arguments.orderId);
			setWirelessLineId(arguments.wirelessLineId);
			setMDN(arguments.mdn);
			setSecretPIN(arguments.secretPin);
			setSecurityQuestionAnswer(arguments.securityQuestionAnswer);
			setSSN(arguments.ssn);
			setCustomerType(arguments.customerType);
			setOrderType(arguments.orderType);
			setHandsetCount(arguments.handsetCount);
			setReferenceNumber(arguments.referenceNumber);
			
			return this;
		</cfscript>

	</cffunction>
	
	<cffunction name="getOrderId" access="public" output="false" returntype="numeric">    
    	<cfreturn variables.instance["orderId"]/>    
    </cffunction>    
    <cffunction name="setOrderId" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["orderId"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getWirelessLineId" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["wirelessLineId"]/>    
    </cffunction>    
    <cffunction name="setWirelessLineId" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["wirelessLineId"] = arguments.theVar />    
    </cffunction>
	
	<cffunction name="getMDN" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["mdn"]/>    
    </cffunction>    
    <cffunction name="setMDN" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["mdn"] = arguments.theVar />    
    </cffunction>
	
	<cffunction name="getSecretPIN" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["secretPIN"]/>    
    </cffunction>    
    <cffunction name="setSecretPIN" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["secretPIN"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getSecurityQuestionAnswer" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["securityQuestionAnswer"]/>    
    </cffunction>    
    <cffunction name="setSecurityQuestionAnswer" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["securityQuestionAnswer"] = arguments.theVar />    
    </cffunction>
	
	<cffunction name="getSSN" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["ssn"]/>    
    </cffunction>    
    <cffunction name="setSSN" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["ssn"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getCustomerType" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["customerType"]/>    
    </cffunction>    
    <cffunction name="setCustomerType" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["customerType"] = ucase(arguments.theVar) />    
    </cffunction>
	
	<cffunction name="getOrderType" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["orderType"]/>    
    </cffunction>    
    <cffunction name="setOrderType" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["orderType"] = ucase(arguments.theVar) />    
    </cffunction>
    
	<cffunction name="getHandsetCount" access="public" output="false" returntype="numeric">    
    	<cfreturn variables.instance["handsetCount"]/>    
    </cffunction>    
    <cffunction name="setHandsetCount" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["handsetCount"] = arguments.theVar />    
    </cffunction>
    
	<cffunction name="getReferenceNumber" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["referenceNumber"]/>    
    </cffunction>    
    <cffunction name="setReferenceNumber" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["referenceNumber"] = arguments.theVar />    
	</cffunction>
	
</cfcomponent>	
