<h1>Welcome to the CarrierFacade Test Page</h1><br/>
<cfoutput>
	<h3>
	AttCarrier Service URL: <a href="#replacenocase(rc.attCarrier.getServiceURL(),"/api","/help")#" target="_blank">#rc.attCarrier.getServiceURL()#</a><br/>
	VzwCarrier Service URL: <a href="#replacenocase(rc.vzwCarrier.getServiceURL(),"/api","/help")#" target="_blank">#rc.vzwCarrier.getServiceURL()#</a><br/>
	</h3>
	
	<h2>
	<a href="#event.buildLink('testFullApi.account_input')#">Account</a>
	<br/><a href="#event.buildLink('testFullApi.address_input')#">Address Validation</a>
	<br/><a href="#event.buildLink('testFullApi.zip_input')#">Area Code Test</a>
	<br/><a href="#event.buildLink('testFullApi.endToEnd_input')#">End To End Test</a>
	</h2>
</cfoutput>

<cfif structKeyExists(session,"carrierFacade")>
<br/>Dump of the CarrierFacade Session Store:
<cfdump var="#session.carrierFacade#" expand="false" />
</cfif>

<cfif structKeyExists(session,"cartFacade")>
<br/>Dump of the CartFacade Session Store:
<cfdump var="#session.cartFacade#" expand="false" />
</cfif>

<!---<cfif structKeyExists(session,"order") and not structIsEmpty("session.order")>
<br/>Dump of the newly completed order in memory
<cfoutput>#session.order.dump()#</cfoutput>
</cfif>
--->