<cfoutput>
<h1>Welcome to the CarrierFacade Test Page</h1>
<a href="<cfoutput>#event.buildLink('testFullApi.account_input')#</cfoutput>"><button class="btn btn-default"  type="button">Do Another Lookup</button></a><br/><br/>
<h2>
<br/>getHttpStatus() = #rc.respObj.getHttpStatus()#
<cfif rc.respObj.getHttpStatus() is "200 OK">
<br/>getAccountIdentifier() = #rc.respObj.getAccountIdentifier()#
<br/>getActiveLines() = #rc.respObj.getActiveLines()#
<br/>getAddress().getAddressLine1() = #rc.respobj.getAddress().getAddressLine1()#
<br/>getAddress().getAddressLine2() = #rc.respobj.getAddress().getAddressLine2()#
<br/>getAddress().getCity() = #rc.respobj.getAddress().getCity()#
<br/>getAddress().getState() = #rc.respobj.getAddress().getState()#
<br/>getAddress().getZipCode() = #rc.respobj.getAddress().getZipCode()#
<br/>getAddress().getZipCodeExtension() = #rc.respobj.getAddress().getZipCodeExtension()#
<br/>getAddress().getCountry() = #rc.respobj.getAddress().getCountry()#
<br/><br/>Intentional Missing Method- getIDoNotExist() = #rc.respObj.getIDoNotExist()#
</cfif>
</h2>
<cfdump var="#rc.respObj.getResponse()#" />
</cfoutput>
