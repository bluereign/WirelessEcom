<h1>Welcome to the CarrierFacade Test Page</h1><br/>
<cfoutput>
	<h3>
	AttCarrier Service URL: <a href="#replacenocase(rc.attCarrier.getServiceURL(),"/api","/help")#">#rc.attCarrier.getServiceURL()#</a><br/>
	VzwCarrier Service URL: <a href="#replacenocase(rc.vzwCarrier.getServiceURL(),"/api","/help")#">#rc.vzwCarrier.getServiceURL()#</a><br/>
	</h3>
	<a href="#event.buildLink('testFullApi.account_input')#"><h2>Account</h2></a>
	
</cfoutput>
