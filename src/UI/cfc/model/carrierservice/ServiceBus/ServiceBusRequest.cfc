<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.ServiceBus.ServiceBusRequest">
		<cfargument name="ChannelName" type="string" default="" required="false" />
		<cfargument name="Carrier" type="string" default="" required="false" />
		<cfargument name="Action" type="string" default="" required="false" />
		<cfargument name="RequestData" type="cfc.model.carrierservice.ServiceBus.CarrierRequestBase" default="#CreateObject('component', 'cfc.model.carrierservice.ServiceBus.CarrierRequestBase').init()#" required="false" />

		<cfscript>
			variables.instance = {};
			
			setChannelName( arguments.ChannelName );
			setCarrier( arguments.Carrier );
			setAction( arguments.Action );
			setRequestData( arguments.RequestData );
		</cfscript>

		<cfreturn this />
	</cffunction>
	
	<cffunction name="setChannelName" output="false" access="public" returntype="void">
		<cfargument name="ChannelName" type="string" default="" required="false" />
		<cfset variables.instance.ChannelName = arguments.ChannelName />
	</cffunction>
	<cffunction name="getChannelName" output="false" access="public" returntype="string">
		<cfreturn variables.instance.ChannelName />
	</cffunction>
	
	
	<cffunction name="setCarrier" output="false" access="public" returntype="void">
		<cfargument name="Carrier" type="string" default="" required="false" />
		<cfset variables.instance.Carrier = arguments.Carrier />
	</cffunction>
	<cffunction name="getCarrier" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Carrier />
	</cffunction>
	
	
	<cffunction name="setAction" output="false" access="public" returntype="void">
		<cfargument name="Action" type="string" default="" required="false" />
		<cfset variables.instance.Action = arguments.Action />
	</cffunction>
	<cffunction name="getAction" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Action />
	</cffunction>
	
	
	<cffunction name="setRequestData" output="false" access="public" returntype="void">
		<cfargument name="RequestData" type="cfc.model.carrierservice.ServiceBus.CarrierRequestBase" default="" required="false" />
		<cfset variables.instance.RequestData = arguments.RequestData />
	</cffunction>
	<cffunction name="getRequestData" output="false" access="public" returntype="cfc.model.carrierservice.ServiceBus.CarrierRequestBase">
		<cfreturn variables.instance.RequestData />
	</cffunction>
	
	<!--- Using a leading space in strings because ColdFusion has a type casting limitation that converts the string to numeric values --->	
	<cffunction name="toJson" output="false" access="public" returntype="string">

		<cfscript>
			var jsonString = '';
			var jsonObject = '';
			
			jsonString = {
				channelName = " #variables.instance.ChannelName#"
				, carrier = " #variables.instance.Carrier#"
				, action = " #variables.instance.Action#"
				, requestData = " #getRequestData().toJson()#"
			};
			
			jsonObject = serializeJSON(jsonString);
		</cfscript>
		
		<cfreturn jsonObject />
	</cffunction>

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn variables.instance />
	</cffunction>

</cfcomponent>