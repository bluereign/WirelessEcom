<cfoutput>
<h1>Welcome to the CarrierFacade Address Validation Test Page</h1>
<a href="<cfoutput>#event.buildLink('testFullApi.address_input')#</cfoutput>"><button class="btn btn-default"  type="button">Enter Another Address</button></a><br/><br/>
<h2>
<br/>getHttpStatusCode() = #rc.respObj.getHttpStatusCode()#
<br/>getTicks() = #rc.respObj.getTicks()#ms (#rc.respObj.getTicks()/1000# secs)
<br/>getHttpStatus() = #rc.respObj.getHttpStatus()#
<br/>getResult() = #rc.respObj.getResult()#
<br/>getResultDetail() = #rc.respObj.getResultDetail()#
<br/>getCarrierName() = #rc.respObj.getCarrierName()#
<br/>getCarrierId() = #rc.respObj.getCarrierId()#
<br/><br/>
<br/>Address Validation Request:
<br/>rc.requestObject.address.getAddressLine1() = #rc.requestObj.address.getAddressLine1()#
<br/>rc.requestObject.address.getAddressLine2() = #rc.requestObj.address.getAddressLine2()#
<br/>rc.requestObject.address.getCity() = #rc.requestObj.address.getCity()#
<br/>rc.requestObject.address.getState() = #rc.requestObj.address.getState()#
<br/>rc.requestObject.address.getZipCode()= #rc.requestObj.address.getZipCode()#
<br/>rc.requestObject.address.getZipCodeExtension()= #rc.requestObj.address.getZipCodeExtension()#
<br/>rc.requestObject.address.getCountry()= #rc.requestObj.address.getCountry()#
<cfdump var="#rc.requestObj#" expand="true" />


<br/>Address Validation Response:
<cfdump var="#rc.respObj.getResponse()#" expand="true" />

</cfoutput>
