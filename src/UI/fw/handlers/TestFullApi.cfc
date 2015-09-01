<cfcomponent output="false" extends="BaseHandler">		<cfproperty name="CarrierFacade" inject="id:CarrierFacade" />	<cfproperty name="AttCarrier" inject="id:AttCarrier" />	<cfproperty name="VzwCarrier" inject="id:VzwCarrier" />	<cfproperty name="MockCarrier" inject="id:MockCarrier" />		<cffunction name="index" returntype="void" output="false">		<cfargument name="event">		<cfargument name="rc">		<cfargument name="prc">		<cfset rc.attCarrier = variables.AttCarrier />		<cfset rc.vzwCarrier = variables.VzwCarrier />		<cfset event.setView('TestFullAPI/index') />	</cffunction>			<cffunction name="account_input" returntype="void" output="false">		<cfargument name="event">		<cfargument name="rc">		<cfargument name="prc">				<cfset event.setView('TestFullAPI/account_input') />	</cffunction>		<cffunction name="account" returntype="void" output="false">		<cfargument name="event">		<cfargument name="rc">		<cfargument name="prc">				<cfparam name="form.carrierId" default="109" />		<cfparam name="form.PhoneNumber" default="2107097717" />		<cfparam name="form.ZipCode" default="78205" />		<cfparam name="form.SecurityId" default="9999" />		<cfparam name="form.Passcode" default="Robertph" />			<cfset args_account = {			carrierId = #form.carrierId#,			PhoneNumber = "#form.PhoneNumber#",			ZipCode = "#form.ZipCode#",			SecurityId = "#form.SecurityId#",			Passcode = "#form.Passcode#"		} />				<cfset rc.respObj = carrierFacade.Account(argumentCollection = args_account) />				<!---<cfset event.setLayout('DDadmin') />--->		<cfset event.setView('TestFullAPI/account') />	</cffunction><!------------------------------------------- PRIVATE EVENTS ------------------------------------------></cfcomponent>