<cfcomponent output="false" extends="cfc.model.carrierservice.ServiceBus.CarrierRequestBase">

	

	<cffunction name="setOrderType" output="false" access="public" returntype="void">
		<cfargument name="OrderType" type="string" default="0" required="false" />
		<cfset variables.instance.OrderType = arguments.OrderType />
	</cffunction>
	<cffunction name="getOrderType" output="false" access="public" returntype="string">
		<cfreturn variables.instance.OrderType />
	</cffunction>
	
	<cffunction name="setBan" output="false" access="public" returntype="void">
		<cfargument name="Ban" type="string" default="0" required="false" />
		<cfset variables.instance.Ban = arguments.Ban />
	</cffunction>
	<cffunction name="getBan" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Ban />
	</cffunction>
	
	<cffunction name="setBillingZip" output="false" access="public" returntype="void">
		<cfargument name="BillingZip" type="string" default="0" required="false" />
		<cfset variables.instance.BillingZip = arguments.BillingZip />
	</cffunction>
	<cffunction name="getBillingZip" output="false" access="public" returntype="string">
		<cfreturn variables.instance.BillingZip />
	</cffunction>
	
	<cffunction name="setMsiSdn" output="false" access="public" returntype="void">
		<cfargument name="MsiSdn" type="string" default="0" required="false" />
		<cfset variables.instance.MsiSdn = arguments.MsiSdn />
	</cffunction>
	<cffunction name="getMsiSdn" output="false" access="public" returntype="string">
		<cfreturn variables.instance.MsiSdn />
	</cffunction>		

	<cffunction name="setNumberOfLines" output="false" access="public" returntype="void">
		<cfargument name="NumberOfLines" type="string" default="0" required="false" />
		<cfset variables.instance.NumberOfLines = arguments.NumberOfLines />
	</cffunction>
	<cffunction name="getNumberOfLines" output="false" access="public" returntype="string">
		<cfreturn variables.instance.NumberOfLines />
	</cffunction>	
	
	<cffunction name="setPin" output="false" access="public" returntype="void">
		<cfargument name="Pin" type="string" default="0" required="false" />
		<cfset variables.instance.Pin = arguments.Pin />
	</cffunction>
	<cffunction name="getPin" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Pin />
	</cffunction>		
	
	<!--- Using a leading space in strings because ColdFusion has a type casting limitation that converts the string to numeric values --->	
	<cffunction name="toJson" output="false" access="public" returntype="string">

		<cfscript>
			var jsonString = '';
			var jsonObject = '';
			
			jsonString = {
				//RequestHeader = #getRequestHeader().toJson()#
				RequestHeader =  #getRequestHeader()#
				, RequestBody = {
					OrderType = " #getOrderType()#"
					, Ban = " #getBan()#"
					, BillingZip = " #getBillingZip()#"
					, MsiSdn = " #getMsiSdn()#"
					, NumberOfLines = " #getNumberOfLines()#"
					, Pin = " #getPin()#"
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