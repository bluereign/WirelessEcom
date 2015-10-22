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
	<br/>financeAgreementRequest (JSON):<br/>
	<div><cfdump var="#rc.financeAgreementRequestJSON#" expand="false" /></div>
	<br/>accountRespObj:
	<cfdump var="#rc.accountRespObj.getResponse()#" expand="false" />
	<br/>financeAgreementRespObj:
	<cfdump var="#rc.financeAgreementRespObj.getResponse()#" expand="false" />
</div>
<br><Form action="#event.buildLink('testFullApi.FinanceAgreement')#" method="post">
	<input type="hidden" name="pdfEncoded" value="#rc.financeAgreementRespObj.getResponse().FinanceAgreement#"/>
	<input type="submit" value="View Finance Agreement PDF"></submit> 
	</form>
</h2>

	<!---<cfif structKeyExists(rc.financeAgreementRespObj.getResponse(),"financeAgreement")>
		<cfset chelper = createObject('component','fw.model.carrierApi.att.attCarrierHelper') />
		<cfset chelper.convertPdf(rc.financeAgreementRespObj.getResponse().financeAgreement) />
	</cfif>--->

</cfoutput>
