<cfoutput>
<h1>Welcome to the CarrierFacade End to End Test Page</h1>
<a href="<cfoutput>#event.buildLink('testFullApi.endToEnd_input')#</cfoutput>"><button class="btn btn-default"  type="button">Do Another Lookup</button></a><br/><br/>
<h2>
<br/>getHttpStatusCode() = #rc.accountRespObj.getHttpStatusCode()#
<br/>getTicks() = #rc.accountRespObj.getTicks()#ms (#rc.accountRespObj.getTicks()/1000# secs)
<br/>getHttpStatus() = #rc.accountRespObj.getHttpStatus()#
<br/>getResult() = #rc.accountRespObj.getResult()#
<br/>getResultDetail() = #rc.accountRespObj.getResultDetail()#
<br/>getCarrierName() = #rc.accountRespObj.getCarrierName()#
<br/>getCarrierId() = #rc.accountRespObj.getCarrierId()#

<br/><br/>CFDUMP of the Finance Agreement Carrier Response for FinanceAgreement

<div style="margin-top:25px;">
	<br/>financeAgreementRequest:
	<cfdump var="#rc.financeAgreementRequest#" expand="false" />
	<br/>financeAgreementRequest (JSON):
	<cfdump var="#rc.financeAgreementRequestJSON#" expand="false" />
	<br/>accountRespObj:
	<cfdump var="#rc.accountRespObj.getResponse()#" expand="false" />
	<br/>financeAgreementRespObj:
	<cfdump var="#rc.financeAgreementRespObj.getResponse()#" expand="false" />
</div>
</h2>

</cfoutput>
