<cfcomponent displayname="Carrier Response" hint="Contains response from carrier info" output="false" extends="fw.model.BaseService">

	
	<cfset variables.instance = StructNew() />

	
	
	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.CarrierResponse">
		
		<cfset variables.instance.response = {} />
		<cfset variables.instance.status = "" />
		<cfset variables.instance.carrierId = 0 />
		<cfset variables.instance.carrierName = "N/A" />
		
		<cfreturn this />
		
	</cffunction>
	
	<cffunction name="getCarrierId" access="public" returnType="numeric">
		<cfreturn variables.instance.carrierId />
	</cffunction>
	
	<cffunction name="getCarrierName" access="public" returnType="string">
		<cfreturn variables.instance.carrierName />
	</cffunction>
	
	<cffunction name="setResponse" access="public" returnType="boolean">
		<cfargument name="response" type="any" required="true" hint="obj of response from carrier" > 
		
		<cfif isStruct(arguments.response)>
			<cfset variables.instance.response = arguments.response />
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
		
	</cffunction>	
	
	<cffunction name="getResponse" access="public" returnType="struct">
		<cfreturn variables.instance.response />
	</cffunction>	
	
	<cffunction name="setStatus" access="public" returnType="void">
		<cfargument name="status" type="string" required="true" />		
		<cfset variables.instance.status = arguments.status />
	</cffunction>
	
	<cffunction name="getStatus" access="public" returnType="string">
		<cfif isDefined("variables.instance.status")>
			<cfreturn variables.instance.status />
		<cfelse>
			<cfreturn "Undefined" />
		</cfif>
	</cffunction>
	
	<cffunction name="setHttpStatus" access="public" returnType="void">
		<cfargument name="httpStatus" type="string" required="true" />		
		<cfset variables.instance.httpStatus = arguments.httpStatus />
	</cffunction>
	
	<cffunction name="getHttpStatus" access="public" returnType="string">
		<cfif isDefined("variables.instance.httpStatus")>
			<cfreturn variables.instance.httpStatus />
		<cfelse>
			<cfreturn "Undefined" />
		</cfif>
	</cffunction>
	
	<cffunction name="setHttpStatusCode" access="public" returnType="void">
		<cfargument name="httpStatusCode" type="numeric" required="true" />		
		<cfset variables.instance.httpStatusCode = arguments.httpStatusCode />
	</cffunction>
	
	<cffunction name="getHttpStatusCode" access="public" returnType="numeric">
		<cfif isDefined("variables.instance.httpStatusCode")>
			<cfreturn variables.instance.httpStatusCode />
		<cfelse>
			<cfreturn "0" />
		</cfif>
	</cffunction>
	
	
	<cffunction name="getAccountIdentifier" access="public" returnType="string">
		<cfset var resp = getResponse() />
		<cfif isdefined("resp.account.accountIdentifier")>
			<cfreturn resp.account.accountIdentifier />
		<cfelse>
			<cfreturn ""/>
		</cfif>
	</cffunction>
	
	<cffunction name="getActiveLines" access="public" returnType="numeric">
		<cfreturn -1 />
	</cffunction>

	<cffunction name="getConversationid" access="public" returnType="string">
		<cfset var resp = getResponse() />
		<cfif isdefined("resp.ConversationId")>
			<cfreturn resp.conversationId />
		<cfelse>
			<cfreturn ""/>
		</cfif>
	</cffunction>	
	
	<cffunction name="getReferenceNumber" access="public" returnType="string">
		<cfset var resp = getResponse() />
		<cfif isdefined("resp.ReferenceNumber")>
			<cfreturn resp.referenceNumber />
		<cfelse>
			<cfreturn ""/>
		</cfif>
	</cffunction>	
	
	<cffunction name="getMessageReferenceId" access="public" returnType="string">
		<cfset var resp = getResponse() />
		<cfif isdefined("resp.messageReferenceId")>
			<cfreturn resp.messageReferenceid />
		<cfelse>
			<cfreturn ""/>
		</cfif>
	</cffunction>	
	
	<cffunction name="getSubscribers" access="public" returnType="array">
		<cfset var local = {} />
		<cfset local.subscribers = arrayNew(1) />
		<cfreturn local.subscribers />
	</cffunction>
	
	<cffunction name="getAddress" access="public" returnType="cfc.model.address">
		<cfargument name="rawAddress" type="struct" required="false" default="#structNew()#" />
		<cfset var address = createObject('component','cfc.model.Address').init() />
		<cfreturn address />
	</cffunction>	
	
		<cffunction name="setResult" access="public" >
		<cfargument name="result" type="boolean" default="false"/>
		<cfset variables.instance.result = arguments.result />
	</cffunction>
	
	<cffunction name="getResult" access="public" returnType="boolean">
		<cfif isdefined("variables.instance.result")>
			<cfreturn variables.instance.result />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>
	
	<cffunction name="setResultDetail" access="public" >
		<cfargument name="resultDetail" type="string" default="No detail information provided"/>
		<cfset variables.instance.resultDetail = arguments.resultDetail />
	</cffunction>
	
	<cffunction name="getResultDetail" access="public" returnType="string">
		<cfif isdefined("variables.instance.resultDetail")>
			<cfreturn variables.instance.resultDetail />
		<cfelse>
			<cfreturn "not available" />
		</cfif>
	</cffunction>

	
	
	
	<!--- Methods that should be implemented in the derived object --->
	
	<cffunction name="OnMissingMethod" access="public" returntype="any" output="false" hint="Handles missing method exceptions.">
	    <cfargument name="MissingMethodName" type="string" required="true" hint="The name of the missing method." />
    	<cfargument name="MissingMethodArguments" type="struct" required="true" hint="The arguments that were passed to the missing method. This might be a named argument set or a numerically indexed set." />		
	    <cfreturn "CarrierResponse - #missingMethodName#: method not found" />
	</cffunction>

		
		


</cfcomponent>