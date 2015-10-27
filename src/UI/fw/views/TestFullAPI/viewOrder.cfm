<h1>End-to-End Test Order Details</h1><br/>
<cfset OrderView = createObject('Component','cfc.view.order').init() />
<cfset OrderDetailHtml = OrderView.getOrderEmailView(rc.order) />
<cfoutput>#OrderDetailHtml#</cfoutput>