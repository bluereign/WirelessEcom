<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.ServiceBus.CarrierRequestBase">
		<cfargument name="RequestHeader" type="cfc.model.carrierservice.ServiceBus.CarrierRequestHeader" default="#CreateObject('component', 'cfc.model.carrierservice.ServiceBus.CarrierRequestHeader').init()#" required="false" />
		<cfargument name="RequestBody" type="string" default="" required="false" />

		<cfscript>
			variables.instance = {};
			
			setRequestHeader( arguments.RequestHeader );
			setRequestBody( arguments.RequestBody );
		</cfscript>

		<cfreturn this />
	</cffunction>

	<cffunction name="setRequestHeader" output="false" access="public" returntype="void">
		<cfargument name="RequestHeader" type="cfc.model.carrierservice.ServiceBus.CarrierRequestHeader" default="0" required="false" />
		<cfset this.RequestHeader = arguments.RequestHeader />
	</cffunction>
	<cffunction name="getRequestHeader" output="false" access="public" returntype="cfc.model.carrierservice.ServiceBus.CarrierRequestHeader">
		<cfreturn this.RequestHeader />
	</cffunction>
	
	<cffunction name="setRequestBody" output="false" access="public" returntype="void">
		<cfargument name="RequestBody" type="string" default="" required="false" />
		<cfset variables.instance.RequestBody = arguments.RequestBody />
	</cffunction>
	<cffunction name="getRequestBody" output="false" access="public" returntype="string">
		<cfreturn variables.instance.RequestBody />
	</cffunction>

	<cffunction name="toXml" output="false" access="public" returntype="string">
		
		<!--- TODO:  --->
		
		<cfreturn variables.instance />
	</cffunction>
	
	<cffunction name="toJson" output="false" access="public" returntype="string">
		
		<!--- TODO:  --->
		
		<cfreturn variables.instance />
	</cffunction>	

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn variables.instance />
	</cffunction>

</cfcomponent>