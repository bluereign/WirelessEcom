<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.VerizonCarrierService">
		<cfargument name="EndPoint" type="string" required="true" />

		<cfscript>
			variables.instance = {};
			variables.instance.EndPoint = arguments.EndPoint;
		</cfscript>

		<cfreturn this />
	</cffunction>


	<cffunction name="NpaNxxLookup" output="false" access="public" returntype="Struct">
		<cfargument name="NpaNxxRequest" type="cfc.model.carrierservice.Verizon.NpaNxxRequest" required="false" />
		<cfset var response = '' />

		<cfhttp url="#variables.instance.EndPoint#/NpaNxxLookup" method="post" result="response">
			<cfhttpparam type="header" name="Content-Type" value="application/json" />
			<cfhttpparam type="body" value="#arguments.NpaNxxRequest.toJson()#" />
		</cfhttp>

		<cfset response = deserializeJSON( response.filecontent.toString() ) />

		<cfreturn response />
	</cffunction>


	<cffunction name="PortInValidation" output="false" access="public" returntype="Struct">
		<cfargument name="PortInValidationRequest" type="cfc.model.carrierservice.Verizon.PortInValidationRequest" required="false" />
		<cfset var response = '' />

		<cfhttp url="#variables.instance.EndPoint#/PortInValidation" method="post" result="response">
			<cfhttpparam type="header" name="Content-Type" value="application/json" />
			<cfhttpparam type="body" value="#arguments.PortInValidationRequest.toJson()#" />
		</cfhttp>

		<cfset response = deserializeJSON( response.filecontent.toString() ) />

		<cfreturn response />
	</cffunction>


	<cffunction name="AddressValidation" output="false" access="public" returntype="Struct">
		<cfargument name="AddressValidationRequest" type="cfc.model.carrierservice.Verizon.AddressValidationRequest" required="false" />
		<cfset var response = '' />

		<cfhttp url="#variables.instance.EndPoint#/AddressValidation" method="post" result="response">
			<cfhttpparam type="header" name="Content-Type" value="application/json" />
			<cfhttpparam type="body" value="#arguments.AddressValidationRequest.toJson()#" />
		</cfhttp>

		<cfset response = deserializeJSON( response.filecontent.toString() ) />

		<cfreturn response />
	</cffunction>


	<cffunction name="CustomerLookup" output="false" access="public" returntype="Struct">
		<cfargument name="CustomerLookupRequest" type="cfc.model.carrierservice.Verizon.CustomerLookupRequest" required="false" />
		<cfset var response = '' />

		<cfhttp url="#variables.instance.EndPoint#/CustomerLookup" method="post" result="response">
			<cfhttpparam type="header" name="Content-Type" value="application/json" />
			<cfhttpparam type="body" value="#arguments.CustomerLookupRequest.toJson()#" />
		</cfhttp>
		
		<cfset response = deserializeJSON( response.filecontent.toString() ) />

		<cfreturn response />
	</cffunction>


	<cffunction name="CreditWrite" output="false" access="public" returntype="Struct">
		<cfargument name="CreditWriteRequest" type="cfc.model.carrierservice.Verizon.CreditWriteRequest" required="false" />
		<cfset var response = '' />

		<cfhttp url="#variables.instance.EndPoint#/CreditWrite" method="post" result="response">
			<cfhttpparam type="header" name="Content-Type" value="application/json" />
			<cfhttpparam type="body" value="#arguments.CreditWriteRequest.toJson()#" />
		</cfhttp>

		<cfset response = deserializeJSON( response.filecontent.toString() ) />

		<cfreturn response />
	</cffunction>


	<cffunction name="AddALineEligibility" output="false" access="public" returntype="Struct">
		<cfargument name="AddALineEligibilityRequest" type="cfc.model.carrierservice.Verizon.AddALineEligibilityRequest" required="false" />
		<cfset var response = '' />

		<cfhttp url="#variables.instance.EndPoint#/AddALineEligibility" method="post" result="response">
			<cfhttpparam type="header" name="Content-Type" value="application/json" />
			<cfhttpparam type="body" value="#arguments.AddALineEligibilityRequest.toJson()#" />
		</cfhttp>
		
		<cfset response = deserializeJSON( response.filecontent.toString() ) />

		<cfreturn response />
	</cffunction>
	

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn variables.instance />
	</cffunction>

</cfcomponent>