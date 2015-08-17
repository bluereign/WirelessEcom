<cfcomponent output="false" extends="cfc.model.carrierservice.ServiceBus.CarrierRequestBase">

	

	<cffunction name="setZipCode" output="false" access="public" returntype="void">
		<cfargument name="ZipCode" type="string" default="0" required="false" />
		<cfset variables.instance.ZipCode = arguments.ZipCode />
	</cffunction>
	<cffunction name="getZipCode" output="false" access="public" returntype="string">
		<cfreturn variables.instance.ZipCode />
	</cffunction>
	
	<cffunction name="setMdn" output="false" access="public" returntype="void">
		<cfargument name="Mdn" type="string" default="0" required="false" />
		<cfset variables.instance.Mdn = arguments.Mdn />
	</cffunction>
	<cffunction name="getMdn" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Mdn />
	</cffunction>

	<cffunction name="setSecretKey" output="false" access="public" returntype="void">
		<cfargument name="SecretKey" type="string" default="0" required="false" />
		<cfset variables.instance.SecretKey = arguments.SecretKey />
	</cffunction>
	<cffunction name="getSecretKey" output="false" access="public" returntype="string">
		<cfreturn variables.instance.SecretKey />
	</cffunction>
	
	<cffunction name="setSSN" output="false" access="public" returntype="void">
		<cfargument name="SSN" type="string" default="0" required="false" />
		<cfset variables.instance.SSN = arguments.SSN />
	</cffunction>
	<cffunction name="getSSN" output="false" access="public" returntype="string">
		<cfreturn variables.instance.SSN />
	</cffunction>

	<cffunction name="toXml" output="false" access="public" returntype="string">
		<!--- TODO:  --->
		<cfreturn '' />
	</cffunction>
	
	<!--- Using a leading space in strings because ColdFusion has a type casting limitation that converts the string to numeric values --->	
	<cffunction name="toJson" output="false" access="public" returntype="string">

		<cfscript>
			var jsonString = '';
			var jsonObject = '';
			
			jsonString = {
				//RequestHeader = #getRequestHeader().toJson()#
				RequestHeader = #getRequestHeader()#
				, RequestBody = {
					ZipCode = " #getZipCode()#"
					, Mdn = " #getMdn()#"
					, SecretKey = " #getSecretKey()#"
					, SSN = " #getSSN()#"
				}
			};
			
			jsonObject = serializeJSON(jsonString);
		</cfscript>
		
		<cfreturn jsonObject />
	</cffunction>	

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn variables.instance />
	</cffunction>

</cfcomponent>