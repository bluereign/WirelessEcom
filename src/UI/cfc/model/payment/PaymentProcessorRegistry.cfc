<cfcomponent output="false" hint="Maintains configuration of registered payment gateways by payment method (visa, mastercard, starcard, paypal, etc.)">

	<cffunction name="init" access="public" output="false" returntype="PaymentProcessorRegistry">
		<cfset setRegistry(structNew())>
		<cfreturn this>
	</cffunction>

	<!--------------------- PUBLIC ------------------------>

	<cffunction name="findGateway" access="public" output="false" returntype="any">
		<cfargument name="paymentMethod" required="true" type="string">

		<cfset var registeredGateways = getRegistry()>

		<cfif !structKeyExists( getRegistry(), arguments.paymentMethod )>
			<cfthrow type="PaymentProcessor.findGateway().UnknownPaymentMethod" message="Unable to locate registered gateway for #arguments.paymentMethod#.">
			<cfabort>
		</cfif>

		<cfreturn registeredGateways[arguments.paymentMethod]>
	</cffunction>

	<cffunction name="registerGateway" access="public" output="false" returntype="void">
		<cfargument name="paymentMethod" type="string" required="true">
 		<cfargument name="Gateway" type="any" required="true" hint="Gateway implementing PaymentGateway interface">

		<cfset var metadata = "">

		<cfif structKeyExists( getRegistry(), arguments.paymentMethod )>
			<cfset metadata = getMetaData( arguments.Gateway )>
			<cfthrow type="PaymentProcessor.registerGateway().DuplicatePaymentMethod" message="Unable to add #metadata.name# for existing payment method: #arguments.paymentMethod#.">
		</cfif>

		<cfset structInsert( getRegistry(), arguments.paymentMethod, arguments.Gateway )>
	</cffunction>

	<cffunction name="hasMultipleRegistered" access="public" output="false" returntype="boolean">
		<cfif listLen( listGateways() ) gt 1>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<cffunction name="listPaymentMethods" access="public" output="false" returntype="string">
		<cfreturn structKeyList( getRegistry() )>
	</cffunction>
	
	<!--------------------- PRIVATE ------------------------>
		
	<cffunction name="listGateways" access="private" output="false" returntype="string" hint="This returns the friendly name of the processor. Use with caution.">
		<cfset var gateways = {}>
		<cfset var registry = getRegistry()>
		<cfset var paymentMethod = "">
		
		<cfloop collection="#registry#" item="paymentMethod">
			<cfset structInsert( gateways, registry[paymentMethod].getName(), "", true )>
		</cfloop>
		
		<cfreturn structKeyList( gateways )>
	</cffunction>

	<!----------------- GETTERS/SETTERS -------------------->

    <cffunction name="getRegistry" access="private" output="false" returntype="struct">
    	<cfreturn variables.instance["registry"]/>
    </cffunction>
    <cffunction name="setRegistry" access="private" output="false" returntype="void">
    	<cfargument name="theVar" required="true" />
    	<cfset variables.instance["registry"] = arguments.theVar />
    </cffunction>

</cfcomponent>