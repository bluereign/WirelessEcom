<h1>Welcome to the CarrierFacade Test Page</h1><br/>
<cfoutput>
	<h3>
	AttCarrier Service URL: <a href="#replacenocase(rc.attCarrier.getServiceURL(),"/api","/help")#" target="_blank">#rc.attCarrier.getServiceURL()#</a><br/>
	VzwCarrier Service URL: <a href="#replacenocase(rc.vzwCarrier.getServiceURL(),"/api","/help")#" target="_blank">#rc.vzwCarrier.getServiceURL()#</a><br/>
	</h3>
	
	<h2>
	<a href="#event.buildLink('testFullApi.account_input')#">Account</a>
	<br/><a href="#event.buildLink('testFullApi.zip_input')#">Area Code Test</a>
	<br/><a href="#event.buildLink('testFullApi.endToEnd_input')#">End To End Test</a>
	</h2>
</cfoutput>
