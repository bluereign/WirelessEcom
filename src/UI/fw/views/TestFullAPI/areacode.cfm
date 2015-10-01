<cfoutput>
<h1>Welcome to the CarrierFacade Area Code Test Page</h1>
<a href="<cfoutput>#event.buildLink('testFullApi.zip_input')#</cfoutput>"><button class="btn btn-default"  type="button">Do another zip code</button></a><br/><br/>
<h2>
<br/>getHttpStatusCode() = #rc.respObj.getHttpStatusCode()#
<br/>getTicks() = #rc.respObj.getTicks()#ms (#rc.respObj.getTicks()/1000# secs)
<br/>getHttpStatus() = #rc.respObj.getHttpStatus()#
<br/>getResult() = #rc.respObj.getResult()#
<br/>getResultDetail() = #rc.respObj.getResultDetail()#
<br/>getCarrierName() = #rc.respObj.getCarrierName()#
<br/>getCarrierId() = #rc.respObj.getCarrierId()#
<br/>
<br/>Area Code Methods:
<hr/>
<br/>IsValidZipCode() = #rc.respObj.isValidZipCode()#
<br/>GetAreaCodes() = #rc.respObj.getAreaCodes()#
<cfif rc.respObj.getHttpStatus() is "200 OK">

<br/><br/>Intentional Missing Method- getIDoNotExist() = #rc.respObj.getIDoNotExist()#
</cfif>

<br/><br/>CFDUMP of the Carrier Response for Area Code lookup
</h2>
<div style="margin-top:25px;">
	<cfdump var="#rc.respObj.getResponse()#" expand="true" />
</div>


</cfoutput>
