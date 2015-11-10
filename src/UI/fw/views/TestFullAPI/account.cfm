<cfoutput>
<h1>Welcome to the CarrierFacade Test Page</h1>
<a href="<cfoutput>#event.buildLink('testFullApi.account_input')#</cfoutput>"><button class="btn btn-default"  type="button">Do Another Lookup</button></a><br/><br/>
<h2>
<br/>getHttpStatusCode() = #rc.respObj.getHttpStatusCode()#
<br/>getTicks() = #rc.respObj.getTicks()#ms (#rc.respObj.getTicks()/1000# secs)
<br/>getHttpStatus() = #rc.respObj.getHttpStatus()#
<br/>getResult() = #rc.respObj.getResult()#
<br/>getResultDetail() = #rc.respObj.getResultDetail()#
<br/>getCarrierName() = #rc.respObj.getCarrierName()#
<br/>getCarrierId() = #rc.respObj.getCarrierId()#
<cfif rc.respObj.getHttpStatus() is "200 OK">
<br/>getAccountIdentifier() = #rc.respObj.getAccountIdentifier()#
<br/>getActiveLines() = #rc.respObj.getActiveLines()#
<br/>getCustomerEmail() = #rc.respObj.getCustomerEmail()#
<br/>getCustomerFirstName() = #rc.respObj.getCustomerFirstName()#
<br/>getCustomerLastName() = #rc.respObj.getCustomerLastName()#
<br/>getAddress().getAddressLine1() = #rc.respobj.getAddress().getAddressLine1()#
<br/>getAddress().getAddressLine2() = #rc.respobj.getAddress().getAddressLine2()#
<br/>getAddress().getCity() = #rc.respobj.getAddress().getCity()#
<br/>getAddress().getState() = #rc.respobj.getAddress().getState()#
<br/>getAddress().getZipCode() = #rc.respobj.getAddress().getZipCode()#
<br/>getAddress().getZipCodeExtension() = #rc.respobj.getAddress().getZipCodeExtension()#
<br/>getAddress().getCountry() = #rc.respobj.getAddress().getCountry()#
<br/>rc.carrierHelper.isGroupPlan() = #rc.carrierHelper.isGroupPlan()#
<cfset subscribers = rc.respObj.getSubscribers() />
<cfset s_count = 1 />
<cfloop array="#subscribers#" index="s">
	<hr/>
	<b>Subscriber ###s_count#</b><br/>
	<br/>Subscriber.getAccountStatus() = #s.getAccountStatus()#
	<br/>Subscriber.getUpgradeDownPaymentPercent("NE",20,"P6") = #s.getUpgradeDownPaymentPercent("NE","20","p6")#
	<br/>Subscriber.getEligibilityDate() = #dateformat(s.getEligibilityDate(),"mm/dd/yyyy")#
	<br/>Subscriber.getEligibilityStatus() = #s.getEligibilityStatus()#
	<br/>Subscriber.getIsEligible() = #s.getIsEligible()#
	<cfif s.getRatePlan().recordcount gt 0>
		<br/>subscriber.getRatePlan()  - returns query
		<br/><cfdump var="#s.getRatePlan()#" expand="false">
	<cfelse>
		<br/>subscriber.getRatePlan() returned an empty query
	</cfif>
	<br/>Subscriber.getEmail() = #s.getEmail()#
	<br/>Subscriber.getNumber() = #s.getNumber()#
	<br/>Subscriber.getAddress().getAddressLine1() = #s.getAddress().getAddressLine1()#
	<br/>Subscriber.getAddress().getAddressLine2() = #s.getAddress().getAddressLine2()#
	<br/>Subscriber.getAddress().getCity() = #s.getAddress().getCity()#
	<br/>Subscriber.getAddress().getState() = #s.getAddress().getState()#
	<br/>Subscriber.getAddress().getZipCode() = #s.getAddress().getZipcode()#
	<br/>Subscriber.getAddress().getZipCodeExtension() = #s.getAddress().getZipcodeExtension()#
	<br/>Subscriber.getAddress().getCountry() = #s.getAddress().getCountry()#
	<br/>rc.iorespObj.getHasConflicts(s.getNumber()) = #rc.respObj.getHasConflicts(s.getNumber())#
	<br/>rc.iorespObj.getConflictResolvable(s.getNumber()) = #rc.respObj.getConflictResolvable(s.getNumber())#
	<cfdump var="#s.getResponse()#" expand="false" />
	
	<cfset s_count = s_count + 1 />
</cfloop>	

<br/><br/>Intentional Missing Method- getIDoNotExist() = #rc.respObj.getIDoNotExist()#
</cfif>

<br/><br/>CFDUMP of the Carrier Request/Response for Account Login
</h2>
<div style="margin-top:25px;">
<cfif structKeyExists(session,"carrierFacade")>
<br/>Dump of the CarrierFacade Session Store:
<cfdump var="#session.carrierFacade#" expand="false" />
</cfif>

<cfif structKeyExists(session,"cartFacade")>
<br/>Dump of the CartFacade Session Store:
<cfdump var="#session.cartFacade#" expand="false" />
</cfif>

<cfif structKeyExists(session,"order")>
<br/>Dump of the newly completed order in memory
<cfoutput>#session.order.dump()#</cfoutput>
</cfif>
</div>


</cfoutput>
