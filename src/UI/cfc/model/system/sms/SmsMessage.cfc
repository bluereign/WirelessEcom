<!--- COMPONENT --->
<cfcomponent displayname="SmsMessage" output="false" hint="I am the SmsMessage class.">

<cfproperty name="messageId" type="string" default="" />
<cfproperty name="phoneNumber" type="string" default="" />
<cfproperty name="carrierId" type="string" default="" />
<cfproperty name="message" type="string" default="" />
<cfproperty name="runDate" type="string" default="" />
<cfproperty name="smsMessageId" type="string" default="" />
<cfproperty name="resultCode" type="string" default="" />
<cfproperty name="result" type="string" default="" />
<cfproperty name="orderDetailId" type="string" default="" />

<!--- PSEUDO-CONSTRUCTOR --->
<cfset variables.instance = StructNew() />
<cfset variables.instance.messageId = '0' />
<cfset variables.instance.phoneNumber = '' />
<cfset variables.instance.carrierId = '' />
<cfset variables.instance.message = '' />
<cfset variables.instance.runDate = '' />
<cfset variables.instance.smsMessageId = '' />
<cfset variables.instance.resultCode = '' />
<cfset variables.instance.result = '' />
<cfset variables.instance.orderDetailId = '0' />

<!--- INIT --->
<cffunction name="init" access="public" output="false" returntype="any" hint="I am the constructor method for the SmsMessage class.">
  <cfargument name="messageId" type="string" required="true" default="0" hint="" />
  <cfargument name="phoneNumber" type="string" required="true" default="" hint="" />
  <cfargument name="carrierId" type="string" required="true" default="" hint="" />
  <cfargument name="message" type="string" required="true" default="" hint="" />
  <cfargument name="runDate" type="string" required="true" default="" hint="" />
  <cfargument name="smsMessageId" type="string" required="false" default="" hint="" />
  <cfargument name="resultCode" type="string" required="false" default="0" hint="" />
  <cfargument name="result" type="string" required="false" default="" hint="" />
  <cfargument name="orderDetailId" type="string" required="false" default="0" hint="" />
  
  <!--- set the initial values of the bean --->
  <cfscript>
	setMessageId(ARGUMENTS.messageId);
  setPhoneNumber(ARGUMENTS.phoneNumber);
	setCarrierId(ARGUMENTS.carrierId);
	setMessage(ARGUMENTS.message);
	setRunDate(ARGUMENTS.runDate);
  setSmsMessageId(ARGUMENTS.smsMessageId);
  setResultCode(ARGUMENTS.resultCode);
  setResult(ARGUMENTS.result);
  </cfscript>
  <cfreturn this>
</cffunction>

<!--- SETTERS --->
<cffunction name="setMessageId" access="public" output="false" hint="I set the messageId value into the variables.instance scope.">
  <cfargument name="messageId" type="string" required="true" default="0" hint="I am the messageId value." />
  <cfset variables.instance.messageId = ARGUMENTS.messageId />
</cffunction>

<cffunction name="setPhoneNumber" access="public" output="false" hint="I set the phoneNumber value into the variables.instance scope.">
  <cfargument name="phoneNumber" type="string" required="true" default="" hint="I am the phoneNumber value." />
  <cfset variables.instance.phoneNumber = ARGUMENTS.phoneNumber />
</cffunction>

<cffunction name="setCarrierId" access="public" output="false" hint="I set the carrierId value into the variables.instance scope.">
  <cfargument name="carrierId" type="string" required="true" default="" hint="I am the carrierId value." />
  <cfset variables.instance.carrierId = ARGUMENTS.carrierId />
</cffunction>

<cffunction name="setMessage" access="public" output="false" hint="I set the message value into the variables.instance scope.">
  <cfargument name="message" type="string" required="true" default="" hint="I am the carrierId value." />
  <cfset variables.instance.message = ARGUMENTS.message />
</cffunction>

<cffunction name="setRunDate" access="public" output="false" hint="I set the runDate value into the variables.instance scope.">
  <cfargument name="runDate" type="string" required="true" default="" hint="I am the runDate value." />
  <cfset variables.instance.runDate = ARGUMENTS.runDate />
</cffunction>

<cffunction name="setSmsMessageId" access="public" output="false" hint="I set the smsMessageId value into the variables.instance scope.">
  <cfargument name="smsMessageId" type="string" required="true" default="" hint="I am the smsMessageId value." />
  <cfset variables.instance.smsMessageId = ARGUMENTS.smsMessageId />
</cffunction>

<cffunction name="setResultCode" access="public" output="false" hint="I set the resultCode value into the variables.instance scope.">
  <cfargument name="resultCode" type="string" required="true" default="" hint="I am the resultCode value." />
  <cfset variables.instance.resultCode = ARGUMENTS.resultCode />
</cffunction>

<cffunction name="setResult" access="public" output="false" hint="I set the result value into the variables.instance scope.">
  <cfargument name="result" type="string" required="true" default="" hint="I am the result value." />
  <cfset variables.instance.result = ARGUMENTS.result />
</cffunction>

<cffunction name="setOrderDetailId" access="public" output="false" hint="I set the order Detail id value into the variables.instance scope.">
  <cfargument name="orderDetailId" type="numeric" required="true" default="" hint="I am the orderDetailId value." />
  <cfset variables.instance.orderDetailId = ARGUMENTS.orderDetailId />
</cffunction>


<!--- GETTERS --->
<cffunction name="getMessageId" access="public" output="false" returntype="string" hint="I return the messageId value.">
  <cfreturn variables.instance.messageId />
</cffunction>

<cffunction name="getPhoneNumber" access="public" output="false" returntype="string" hint="I return the phoneNumber value.">
  <cfreturn variables.instance.phoneNumber />
</cffunction>

<cffunction name="getCarrierId" access="public" output="false" returntype="string" hint="I return the carrierId value.">
  <cfreturn variables.instance.carrierId />
</cffunction>

<cffunction name="getMessage" access="public" output="false" returntype="string" hint="I return the message value.">
  <cfreturn variables.instance.message />
</cffunction>

<cffunction name="getRunDate" access="public" output="false" returntype="string" hint="I return the runDate value.">
  <cfreturn variables.instance.runDate />
</cffunction>

<cffunction name="getSmsMessageId" access="public" output="false" returntype="string" hint="I return the smsMessageId value.">
  <cfreturn variables.instance.smsMessageId />
</cffunction>

<cffunction name="getResultCode" access="public" output="false" returntype="string" hint="I return the resultCode value.">
  <cfreturn variables.instance.resultCode />
</cffunction>

<cffunction name="getResult" access="public" output="false" returntype="string" hint="I return the result value.">
  <cfreturn variables.instance.result />
</cffunction>

<cffunction name="getOrderDetailId" access="public" output="false" returntype="any" hint="I return the result value.">
  <cfreturn variables.instance.orderDetailId />
</cffunction>

<!--- UTILITY METHODS --->
<cffunction name="getMemento" access="public" output="false" hint="I return a struct of the variables.instance scope.">
  <cfreturn variables.instance />
</cffunction>

</cfcomponent>