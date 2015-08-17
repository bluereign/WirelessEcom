<cfcomponent output="false">
	
	<!------------------- CONSTRUCTOR --------------------->
		
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="name" required="true" type="string">
		<cfargument name="PaymentProcessorRegistry" required="true" type="any">
		<cfargument name="paymentReturnPath" required="true" type="string">
		<cfargument name="paymentReturnPathRequiresSSL" required="true" type="boolean">
		<cfargument name="paymentMethods" required="true" type="array">
		<cfargument name="processingURL" required="true" type="string">
		<cfargument name="async" required="false" default="false" type="boolean">
		
		<cfset setName( arguments.name )>
		<cfset setPaymentProcessorRegistry( arguments.PaymentProcessorRegistry )>
		<cfset setPaymentMethods( arguments.paymentMethods )>
		<cfset setPaymentReturnPath( arguments.paymentReturnPath )>
		<cfset setPaymentReturnPathRequiresSSL( arguments.paymentReturnPathRequiresSSL )>
		<cfset setProcessingURL( arguments.processingURL )>
		<cfset isAsync( arguments.async )>
		
		<cfreturn this>
	</cffunction>

	<!--------------------- PUBLIC ------------------------>
		
	<cffunction name="buildGatewayFormAction" access="public" returntype="string" output="false">
		<cfreturn getProcessingURL() />
	</cffunction>

	<cffunction name="register" access="public" returntype="void" output="false">
		<cfloop array="#getPaymentMethods()#" index="paymentMethod">
			<cfset getPaymentProcessorRegistry().registerGateway( paymentMethod, this )>
		</cfloop>
	</cffunction>
	
	<cffunction name="isAsync" access="public" returntype="boolean" output="false">
		<cfargument name="bool" type="boolean" required="false">
		
		<cfif structKeyExists( arguments, "bool" )>
			<cfset VARIABLES.isAsync = arguments.bool>
		</cfif>
		
		<cfreturn variables.isAsync>	
	</cffunction>
	
	<!--------------------- PRIVATE ------------------------>
		
	<cffunction name="buildReturnURL" access="private" returntype="string" output="false">
		<cfscript>
			var protocol = "http://";
			
			if( getPaymentReturnPathRequiresSSL() ) {
				protocol = "https://";
			}
			
			return protocol & cgi.http_host & getPaymentReturnPath();
		</cfscript>		
	</cffunction>
		
	<cffunction name="translateCCType" access="private" returntype="string" output="false">
		<cfargument name="abbreviation" type="string" required="true">
		
		<cfscript>
			switch( arguments.abbreviation ) {
				
				case "American Express" :
				case "AM" : 
				case "Amex" : {
					strOut = "Amex";
					break;
				}
				 
				case "Visa" : 
				case "VI" :{
					strOut = "Visa";
					break;
				}
				 
				case "Discover" :
				case "DI" : 
				case "NN" : {
					strOut = "Discover";
					break;
				}
				 
				case "Mastercard" :
				case "MC" : {
					strOut = "Mastercard";
					break;
				}
				
				default : {
					strOut = arguments.abbreviation;
					break;
				}
				
			}
			
			return strOut;
		</cfscript>

	</cffunction>
	
	<cffunction name="translateTransactionType" access="private" returntype="string" output="false" hint="Translates this gateway's transaction codes to a common set of strings">
		<cfargument name="gatewayTransactionType" type="string" required="true">
		<cfargument name="cardType" type="string" required="false" hint="Credit card name used for this txn.">
		
		<cfscript>
			var strOut = "";
			
			switch( arguments.gatewayTransactionType ) {
				case "22" : case "auth" : {
					strOut = 'Pre-Auth';
					break;	
				}
				case "00" : case "capture" : {
					strOut = arguments.cardType;
					break;
				}
				
				default : {
					strOut = arguments.gatewayTransactionType;
					break;
				}
			}
			
			return strOut;
		</cfscript>
	</cffunction>
	
	<!----------------- GETTERS/SETTERS -------------------->
		
	<cffunction name="getName" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["name"]/>    
    </cffunction>    
    <cffunction name="setName" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["name"] = arguments.theVar />    
    </cffunction>
		
	<cffunction name="getPaymentProcessorRegistry" access="public" output="false" returntype="any">    
    	<cfreturn variables.instance["PaymentProcessorRegistry"]/>    
    </cffunction>    
    <cffunction name="setPaymentProcessorRegistry" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["PaymentProcessorRegistry"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getPaymentMethods" access="public" output="false" returntype="array">    
    	<cfreturn variables.instance["paymentMethods"]/>    
    </cffunction>    
    <cffunction name="setPaymentMethods" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["paymentMethods"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getProcessingURL" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["processingURL"]/>    
    </cffunction>    
    <cffunction name="setProcessingURL" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["processingURL"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getPaymentReturnPath" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["paymentReturnPath"]/>    
    </cffunction>    
    <cffunction name="setPaymentReturnPath" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["paymentReturnPath"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getPaymentReturnPathRequiresSSL" access="public" output="false" returntype="boolean">    
    	<cfreturn variables.instance["paymentReturnPathRequiresSSL"]/>    
    </cffunction>    
    <cffunction name="setPaymentReturnPathRequiresSSL" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["paymentReturnPathRequiresSSL"] = arguments.theVar />    
    </cffunction>
	
</cfcomponent>