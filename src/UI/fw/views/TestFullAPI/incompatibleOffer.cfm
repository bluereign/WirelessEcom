<cfoutput>
<h1>Welcome to the CarrierFacade Incompatible Offer Test Page</h1>
<a href="<cfoutput>#event.buildLink('testFullApi.IncompatibleOffer_input')#</cfoutput>"><button class="btn btn-default"  type="button">Do another Incompatible Offer</button></a><br/><br/>
<h2>
</cfoutput>
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
