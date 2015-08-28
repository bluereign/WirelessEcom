<cfoutput>
Welcome to the CarrierFacade Test Page<br/>
<a href="<cfoutput>#event.buildLink('testFullApi.account_input')#</cfoutput>"><button class="btn btn-default"  type="button">Do Another Lookup</button></a><br/><br/>
<br/>Account Identifier: #rc.respObj.getAccountIdentifier()#
<br/>Active Lines: #rc.respObj.getActiveLines()#

<br/>Account Address:
	<br/><span style="margin-left:10px;">#rc.respobj.getAddress().getAddressLine1()#</span>
	<br/><span style="margin-left:10px;">#rc.respobj.getAddress().getAddressLine2()#</span>
	<br/><span style="margin-left:10px;">#rc.respobj.getAddress().getCity()#, #rc.respobj.getAddress().getState()# #rc.respobj.getAddress().getZipCode()#-#rc.respobj.getAddress().getZipCodeExtension()#</span>
	<br/><span style="margin-left:10px;">#rc.respobj.getAddress().getCountry()#</span>
	
<br/><br/>Intentional Missing Method: <b>#rc.respObj.getIDoNotExist()#</b><p/>
<cfdump var="#rc.respObj.getResponse()#" />
</cfoutput>
