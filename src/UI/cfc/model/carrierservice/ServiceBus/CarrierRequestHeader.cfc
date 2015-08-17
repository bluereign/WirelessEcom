<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.ServiceBus.CarrierRequestHeader">
		<cfargument name="ClientAppName" type="string" default="0" required="false" />
		<cfargument name="ClientAppUserName" type="string" default="" required="false" />
		<cfargument name="ServiceAreaZip" type="string" default="0" required="false" />
		<cfargument name="StoreID" type="string" default="" required="false" />
		<cfargument name="ReferenceNumber" type="string" default="" required="false" />
		<cfargument name="ConversationId" type="string" default="" required="false" />

		<cfscript>
			variables.instance = {};

			setClientAppName( arguments.ClientAppName );
			setClientAppUserName( arguments.ClientAppUserName );
			setServiceAreaZip( arguments.ServiceAreaZip );
			setStoreID( arguments.StoreID );
			setReferenceNumber( arguments.ReferenceNumber );
			setConversationId( arguments.ConversationId );
		</cfscript>

		<cfreturn this />
	</cffunction> 
	
	<cffunction name="setClientAppName" output="false" access="public" returntype="void">
		<cfargument name="ClientAppName" type="string" default="0" required="false" />
		<cfset this.ClientAppName = ' ' & arguments.ClientAppName />
	</cffunction>
	<cffunction name="getClientAppName" output="false" access="public" returntype="string">
		<cfreturn this.ClientAppName />
	</cffunction>
	
	<cffunction name="setClientAppUserName" output="false" access="public" returntype="void">
		<cfargument name="ClientAppUserName" type="string" default="0" required="false" />
		<cfset this.ClientAppUserName = ' ' & arguments.ClientAppUserName />
	</cffunction>
	<cffunction name="getClientAppUserName" output="false" access="public" returntype="string">
		<cfreturn this.ClientAppUserName />
	</cffunction>
	
	<cffunction name="setServiceAreaZip" output="false" access="public" returntype="void">
		<cfargument name="ServiceAreaZip" type="string" default="0" required="false" />
		<cfset this.ServiceAreaZip = ' ' & arguments.ServiceAreaZip />
	</cffunction>
	<cffunction name="getServiceAreaZip" output="false" access="public" returntype="string">
		<cfreturn this.ServiceAreaZip />
	</cffunction>
	
	<cffunction name="setStoreID" output="false" access="public" returntype="void">
		<cfargument name="StoreID" type="string" default="0" required="false" />
		<cfset this.StoreID = ' ' & arguments.StoreID />
	</cffunction>
	<cffunction name="getStoreID" output="false" access="public" returntype="string">
		<cfreturn this.StoreID />
	</cffunction>
	
	<cffunction name="setReferenceNumber" output="false" access="public" returntype="void">
		<cfargument name="ReferenceNumber" type="string" default="0" required="false" />
		<cfset this.ReferenceNumber = ' ' & arguments.ReferenceNumber />
	</cffunction>
	<cffunction name="getReferenceNumber" output="false" access="public" returntype="string">
		<cfreturn this.ReferenceNumber />
	</cffunction>
	
	<cffunction name="setConversationId" output="false" access="public" returntype="void">
		<cfargument name="ConversationId" type="string" default="0" required="false" />
		<cfset this.ConversationId = ' ' & arguments.ConversationId />
	</cffunction>
	<cffunction name="getConversationId" output="false" access="public" returntype="string">
		<cfreturn this.ConversationId />
	</cffunction>	
	
	<cffunction name="toJson" output="false" access="public" returntype="string">

		<cfscript>
			var jsonString = '';
			var jsonObject = '';
			
			jsonString = {
				ClientAppName = " #this.ClientAppName#"
				, ClientAppUserName = " #this.ClientAppUserName#"
				, ServiceAreaZip = " #this.ServiceAreaZip#"
				, StoreID = " #this.StoreID#"
				, ReferenceNumber = " #this.ReferenceNumber#"
				, ConversationId = " #this.ConversationId#"
			};
			
			jsonObject = serializeJSON(jsonString);
		</cfscript>
		
		<cfreturn jsonObject />
	</cffunction>

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>