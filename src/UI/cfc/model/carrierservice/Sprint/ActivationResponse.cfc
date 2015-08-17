<cfcomponent output="false" extends="AbstractAPI">
	
	<cffunction name="init" output="false" access="public" returntype="ActivationResponse">
		<cfargument name="orderId" type="string" required="true" />
		<cfargument name="wirelessLineId" type="numeric" required="true" />
		<cfargument name="errorMessage" type="string" default="" />
		<cfargument name="errorMessageDetail" type="string" default="" />
		<cfargument name="responseCode" type="string" default="" />
		<cfargument name="responseResult" type="string" default="" />
		<cfargument name="responseMessage" type="string" default="" />
		<cfargument name="responseAdvice" type="string" default="" />
		<cfargument name="activationStatus" type="string" default="" />
		
		<cfscript>
			setOrderId(arguments.orderId);
			setWirelessLineId(arguments.wirelessLineId);
			setErrorMessage(arguments.errorMessage);
			setErrorMessageDetail(arguments.errorMessageDetail);
			setResponseCode(arguments.responseCode);
			setResponseResult(arguments.responseResult);
			setResponseMessage(arguments.responseMessage);
			setResponseAdvice(arguments.responseAdvice);
			setActivationStatus(arguments.activationStatus);
			
			return this;
		</cfscript>

	</cffunction>
	
	<cffunction name="populateFromResponse" output="false" access="public" returntype="void">
		<cfargument name="ServiceBusResponse" required="true" type="any" />
		
		<cfscript>
			setErrorMessage( ServiceBusResponse.getPrimaryErrorMessageBrief() );
			setErrorMessageDetail( ServiceBusResponse.getPrimaryErrorMessageLong() );
			setResponseCode( ServiceBusResponse.getSprintErrorCode() );
			setResponseResult( ServiceBusResponse.getErrorCodeEnum().toString() );
			setResponseMessage( ServiceBusResponse.getSprintResponseMessage() );
			setResponseAdvice( ServiceBusResponse.getSprintResponseAdvice() );
			setActivationStatus( ServiceBusResponse.getActivationStatus().toString() );
		</cfscript>

	</cffunction> 
	
	<cffunction name="isSuccess" access="public" output="false" returntype="boolean">
		<!---<cfreturn getResponseResult() eq 'Success'>--->
		<cfreturn getActivationStatusForUI() eq 'Success'>
	</cffunction>
	
	<cffunction name="getActivationStatusID" access="public" output="false" returntype="numeric">
			
		<cfscript>
			var statusName =  getActivationStatus();
			var statuses = {
				None = 0, 
				RequestSubmitted = 1, 
				Success = 2, 
				PartialSuccess = 3, 
				Failure = 4, 
				Error = 5, 
				Manual = 6, 
				Canceled = 7
			};
			if( structKeyExists( statuses, statusName ) )
				return statuses[statusName];
			else 
				return -1;
		</cfscript>
		
	</cffunction>
	
	<cffunction name="getActivationStatusForUI" access="public" output="false" returntype="string" hint="The web service returns statuses that Care isn't used to seeing. Thus, we translate those statuses here.">
		
		<cfscript>
			switch( getActivationStatusID() ) {
				case "" : 
				case "0" : {
					return 'Ready';
				}
				case "1" : {
					return 'Requested';
				}
				case "2" : {
					return 'Success';
				}
				case "3" : {
					return 'Partial Success';
				}
				case "4" : {
					return 'Failure';
				}
				case "5" : {
					return 'Error';
				}
				case "6" : {
					return 'Manual';
				}
				case "7" : {
					return 'Canceled';
				}
			}
		</cfscript>
		
	</cffunction>
	
	<cffunction name="getWirelessLineId" access="public" output="false" returntype="numeric">    
		<cfreturn variables.instance["wirelessLineId"]/>    
	</cffunction>    
	<cffunction name="setWirelessLineId" access="public" output="false" returntype="void">    
		<cfargument name="theVar" required="true" />    
		<cfset variables.instance["wirelessLineId"] = arguments.theVar />    
	</cffunction>
	
	<cffunction name="getOrderId" access="public" output="false" returntype="numeric">    
		<cfreturn variables.instance["orderId"]/>    
	</cffunction>    
	<cffunction name="setOrderId" access="public" output="false" returntype="void">    
		<cfargument name="theVar" required="true" />    
		<cfset variables.instance["orderId"] = arguments.theVar />    
	</cffunction>
	
	<cffunction name="getErrorMessage" access="public" output="false" returntype="string">    
		<cfreturn variables.instance["errorMessage"]/>    
	</cffunction>    
	<cffunction name="setErrorMessage" access="public" output="false" returntype="void">    
		<cfargument name="theVar" required="false" />
		<cfif structKeyExists( arguments, 'theVar' )>
			<cfset variables.instance["errorMessage"] = arguments.theVar />
		<cfelse>
			<cfset variables.instance["errorMessage"] = "" />
		</cfif>    
	</cffunction>
	
	<cffunction name="getErrorMessageDetail" access="public" output="false" returntype="string">    
		<cfreturn variables.instance["errorMessageDetail"]/>    
	</cffunction>    
	<cffunction name="setErrorMessageDetail" access="public" output="false" returntype="void">    
		<cfargument name="theVar" required="false" />
		<cfif structKeyExists( arguments, 'theVar' )>
			<cfset variables.instance["errorMessageDetail"] = arguments.theVar />
		<cfelse>
			<cfset variables.instance["errorMessageDetail"] = "" />
		</cfif>    
	</cffunction>
	
	<cffunction name="getResponseCode" access="public" output="false" returntype="string">    
		<cfreturn variables.instance["responseCode"]/>    
	</cffunction>    
	<cffunction name="setResponseCode" access="public" output="false" returntype="void">    
		<cfargument name="theVar" required="true" />    
		<cfset variables.instance["responseCode"] = arguments.theVar />    
	</cffunction>
	
	<cffunction name="getResponseResult" access="public" output="false" returntype="string">   
		<cfreturn variables.instance["responseResult"]/>   
	</cffunction>   
	<cffunction name="setResponseResult" access="public" output="false" returntype="void">   
		<cfargument name="theVar" required="true" />   
		<cfset variables.instance["responseResult"] = arguments.theVar />   
	</cffunction>
	
	<cffunction name="getResponseMessage" access="public" output="false" returntype="string">    
		<cfreturn variables.instance["responseMessage"]/>    
	</cffunction>    
	<cffunction name="setResponseMessage" access="public" output="false" returntype="void">    
		<cfargument name="theVar" required="false" />    
		<cfif structKeyExists( arguments, 'theVar' )>
			<cfset variables.instance["responseMessage"] = arguments.theVar />
		<cfelse>
			<cfset variables.instance["responseMessage"] = '' />
		</cfif>
	</cffunction>
	
	<cffunction name="getResponseAdvice" access="public" output="false" returntype="string">    
		<cfreturn variables.instance["responseAdvice"]/>    
	</cffunction>    
	<cffunction name="setResponseAdvice" access="public" output="false" returntype="void">    
		<cfargument name="theVar" required="false" />    
		<cfif structKeyExists( arguments, 'theVar' )>
			<cfset variables.instance["responseAdvice"] = arguments.theVar />
		<cfelse>
			<cfset variables.instance["responseAdvice"] = '' />
		</cfif>
	</cffunction>
	
	<cffunction name="getActivationStatus" access="public" output="false" returntype="string">    
		<cfreturn variables.instance["activationStatus"]/>    
	</cffunction>    
	<cffunction name="setActivationStatus" access="public" output="false" returntype="void">    
		<cfargument name="theVar" required="true" />    
		<cfset variables.instance["activationStatus"] = arguments.theVar />    
	</cffunction>
	
	<cffunction name="getMemento">
		<cfreturn variables.instance>
	</cffunction>

</cfcomponent>