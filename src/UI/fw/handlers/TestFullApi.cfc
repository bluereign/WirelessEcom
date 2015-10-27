<cfcomponent output="false" extends="BaseHandler">		<cfproperty name="CarrierFacade" inject="id:CarrierFacade" />	<cfproperty name="CarrierHelper" inject="id:CarrierHelper" />	<cfproperty name="AttCarrier" inject="id:AttCarrier" />	<cfproperty name="VzwCarrier" inject="id:VzwCarrier" />	<cfproperty name="MockCarrier" inject="id:MockCarrier" />	<cfproperty name="ChannelConfig" inject="id:ChannelConfig" />		<cffunction name="index" returntype="void" output="false">		<cfargument name="event">		<cfargument name="rc">		<cfargument name="prc">		<cfset rc.attCarrier = variables.AttCarrier />		<cfset rc.vzwCarrier = variables.VzwCarrier />		<cfset event.setView('TestFullAPI/index') />	</cffunction>			<cffunction name="account_input" returntype="void" output="false">		<cfargument name="event">		<cfargument name="rc">		<cfargument name="prc">				<cfset event.setView('TestFullAPI/account_input') />	</cffunction>		<cffunction name="address_input" returntype="void" output="false">		<cfargument name="event">		<cfargument name="rc">		<cfargument name="prc">				<cfset event.setView('TestFullAPI/address_input') />	</cffunction>			<cffunction name="address" returntype="void" output="false">		<cfargument name="event">		<cfargument name="rc">		<cfargument name="prc">				<cfset var local = structNew() />		<cfset local.address = createObject('component','cfc.model.address') />		<cfset local.address.setAddressLine1(form.address1) />		<cfset local.address.setAddressLine2(form.address2) />		<cfset local.address.setCity(form.city) />		<cfset local.address.setState(form.state) />		<cfset local.address.setZipCode(form.zip) />		<cfset local.address.setZipCodeExtension(form.zipExtension) />		<cfset local.address.setCountry(form.country) />		<cfset local.args_address = {			carrierId = form.carrierId,			address = local.address,			channel = getChannelValue() 		} />				<cfset rc.requestObj = local.args_address />			<cfset rc.respObj = carrierFacade.AddressValidation(argumentCollection = local.args_address) />			<cfset event.setView('TestFullAPI/address') />			</cffunction>		<cffunction name="account" returntype="void" output="false">		<cfargument name="event">		<cfargument name="rc">		<cfargument name="prc">		<cfset var local = {} />				<cfparam name="form.carrierId" default="109" />		<cfparam name="form.SubscriberNumber" default="2107097717" />		<cfparam name="form.ZipCode" default="78205" />		<cfparam name="form.SecurityId" default="9999" />		<cfparam name="form.Passcode" default="Robertph" />			<cfset local.args_account = {			carrierId = #form.carrierId#,			SubscriberNumber = "#form.subscriberNumber#",			ZipCode = "#form.ZipCode#",			SecurityId = "#form.SecurityId#",			Passcode = "#form.Passcode#"		} />				<cfset rc.AccountRequestJSON = AttCarrier.serializeJSonAddReferenceNumber(local.args_Account) /><!--- for testing only --->		<cfset rc.respObj = carrierFacade.Account(argumentCollection = local.args_account) />			<cfset event.setView('TestFullAPI/account') />	</cffunction>		<cffunction name="endToEnd_input" returntype="void" output="false">		<cfargument name="event">		<cfargument name="rc">		<cfargument name="prc">				<cfset event.setView('TestFullAPI/endToEnd_input') />	</cffunction>		<cffunction name="endToEnd" returntype="void" output="false">		<cfargument name="event">		<cfargument name="rc">		<cfargument name="prc">		<cfset var local = {} />				<cfparam name="form.carrierId" default="109" />		<cfparam name="form.SubscriberNumber" default="2107097717" />		<cfparam name="form.ZipCode" default="78205" />		<cfparam name="form.SecurityId" default="9999" />		<cfparam name="form.Passcode" default="Robertph" />		<!--- clear the shopping cart --->		<cfset application.model.dBuilderCartFacade.clearCart() />					<cfset local.args_account = {			carrierId = #rc.carrierId#,			SubscriberNumber = "#form.subscriberNumber#",			ZipCode = "#form.ZipCode#",			SecurityId = "#form.SecurityId#",			Passcode = "#form.Passcode#"		} />				<cfset rc.AccountRespObj = carrierFacade.Account(argumentCollection = local.args_account) />			<cfinclude template="/fw/views/TestFullAPI/buildCart.cfm" />						<cfswitch expression="#channelConfig.getDisplayName()#">			<cfcase value="Costco">				<cfset local.channel = 0>				<cfbreak/>			</cfcase>			<cfcase value="AAfes">				<cfset local.channel = 1>				<cfbreak/>			</cfcase>			<cfdefaultcase>				<cfset local.channel = 0>			</cfdefaultcase>		</cfswitch>				<cfset local.args_getFinanceAgreementRequest = {			carrierId = #rc.carrierId#,			AccountRespObj = #rc.accountRespObj#,			Channel = #local.channel#		} />				<cfset local.args_financeAgreementRequest = carrierHelper.getFinanceAgreementRequest(argumentCollection=local.args_getFinanceAgreementRequest) />		<cfset local.args_financeAgreementRequest.carrierId = rc.carrierid />		<cfset rc.financeAgreementRequest = local.args_financeAgreementRequest />		<cfset rc.financeAgreementRequestJSON = AttCarrier.serializeJSonAddReferenceNumber(local.args_financeAgreementRequest) /><!--- for testing only --->		<cfset rc.FinanceAgreementRespObj = carrierFacade.FinanceAgreement(argumentCollection = local.args_financeAgreementRequest) />					<cfset event.setView('TestFullAPI/endToEnd') />	</cffunction>		<cffunction name="financeAgreement" returntype="void" output="false">		<cfargument name="event">		<cfargument name="rc">		<cfargument name="prc">				<cfset rc.pdf = base64ToString(rc.pdfEncoded) />		<cfset event.setLayout('viewPdf') />		<cfset event.setView('TestFullAPI/ViewPDF') />	</cffunction>		<cffunction name="CreateOrder" returntype="void" output="false">		<cfargument name="event">		<cfargument name="rc">		<cfargument name="prc">				<cfset var local = structNew() />		<cfset local.address = {			firstName = 'Scott',			lastname= 'Hamilton',			address1 = '1234 Lany Lane',			city = 'Bellevue',			state = 'WA',			zip = '98006',			dayTimePhone = '206-345-8764',			eveningPhone = '425-998-3421'					} />				<cfset rc.order = createObject('component', 'cfc.model.order').init() />					<cfset rc.order.populateFromCart(session.cart) />		<cfset rc.order.populateFromCheckoutHelper() />		<cfset local.shipAddress = createObject('component','cfc.model.orderAddress').init(argumentCollection = local.address) />		<cfset local.billAddress = createObject('component','cfc.model.orderAddress').init(argumentCollection = local.address) />		<cfset rc.order.setShipAddress(local.shippingAddress) />		<cfset rc.order.setBillAddress(local.billingAddress) />		<cfset rc.order.setShipMethod(3) />		<cfset rc.order.save() />				<cfset event.setView('TestFullAPI/viewOrder') />			</cffunction>		<cffunction name="zip_input" returntype="void" output="false">		<cfargument name="event">		<cfargument name="rc">		<cfargument name="prc">						<cfset event.setView('TestFullAPI/zip_input') />	</cffunction>	<cffunction name="areacode" returntype="void" output="false">		<cfargument name="event">		<cfargument name="rc">		<cfargument name="prc">		<cfset var local = {} />				<cfset local.args_zip = {			carrierId = #form.carrierId#,			ZipCode = "#form.ZipCode#"		} />		<cfset rc.respObj = carrierFacade.areacode(argumentCollection = local.args_zip) />			<cfset event.setView('TestFullAPI/areacode') />	</cffunction><!------------------------------------------- PRIVATE EVENTS ------------------------------------------><!------------------------------------------- HELPER FUNCTIONS ------------------------------------------>	<cffunction name="base64ToString" returntype="any">		<cfargument name="base64Value" type="any" required="yes" />                <cfset var binaryValue = binaryDecode(base64Value,'base64' ) />		<cfset var stringValue = ToString(binaryValue,'iso-8859-1' ) />                <cfreturn stringValue />  	</cffunction>		<cffunction name="getOrderItems" returnType="array">			</cffunction>		<cffunction name="getChannelValue" returnType="Numeric">		<cfswitch expression="#channelConfig.getDisplayName()#">			<cfcase value="Costco">				<cfreturn 0>				<cfbreak/>			</cfcase>			<cfcase value="AAfes">				<cfreturn 1>				<cfbreak/>			</cfcase>			<cfdefaultcase>				<cfreturn 0>			</cfdefaultcase>		</cfswitch>	</cffunction>		</cfcomponent>