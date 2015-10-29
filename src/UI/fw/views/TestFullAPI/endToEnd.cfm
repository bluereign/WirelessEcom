<cfoutput>
<h1>Welcome to the CarrierFacade End to End Test Page</h1>
<cfset session.userid = 26007508 /><!--- Make shamilton@wirelessadvocate.com the user for the session (being lazy on my test) --->
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
<br><Form action="#event.buildLink('testFullApi.FinanceAgreement')#" method="post" target="_blank">
	<input type="hidden" name="pdfEncoded" value="#rc.financeAgreementRespObj.getResponse().FinanceAgreement#"/>
	<input type="submit" value="View Finance Agreement PDF"></submit> 
	</form>
<br><Form action="#event.buildLink('testFullApi.CreateOrder')#" method="post" target="_blank">
	<input type="submit" value="Create Order"></submit> 
	</form>
</h2>

<br><Form action="#event.buildLink('testFullApi.SaveFinanceAgreement')#" method="post" target="_blank">
	<input type="hidden" name="carrierid" value="#trim(rc.accountRespObj.getCarrierId())#"/>
	<input type="hidden" name="installmentPlanId" value="#trim(rc.financeAgreementRespObj.getResponse().AgreementItems[1].InstallmentPLanId)#" />
	<input type="hidden" name="subscriberNumber" value="#trim(rc.subscriberNumber)#"/>
	<input type="hidden" name="accountNumber" value="#trim(rc.AccountRespObj.getAccount().accountIdentifier)#"/>
	<input type="hidden" name="nameOnAccount" value="#trim(rc.AccountRespObj.getAccount().primaryAccountHolder)#"/>
	<input type="hidden" name="agreementEntry" value="#trim(rc.financeAgreementRespObj.getResponse().FinanceAgreement)#"/>
	<input type="submit" value="Save the Finance Agreement"></submit> 
	</form>
	
<br><Form action="#event.buildLink('testFullApi.SubmitOrder')#" method="post" target="_blank">
	<input type="hidden" name="carrierid" value="#trim(rc.accountRespObj.getCarrierId())#"/>
 	<input type="submit" value="Submit the Order"></submit> 
	</form>	
	
<br><Form action="#event.buildLink('testFullApi.SubmitCompletedOrder')#" method="post" target="_blank">
	<input type="hidden" name="carrierid" value="#trim(rc.accountRespObj.getCarrierId())#"/>
	OrderId: <input type="text" name="orderid" value=""/>
 	<input type="submit" value="Submit the Completed Order"></submit> 
	</form>		
</h2>


	<!---<cfif structKeyExists(rc.financeAgreementRespObj.getResponse(),"financeAgreement")>
		<cfset chelper = createObject('component','fw.model.carrierApi.att.attCarrierHelper') />
		<cfset chelper.convertPdf(rc.financeAgreementRespObj.getResponse().financeAgreement) />
	</cfif>--->

</cfoutput>
