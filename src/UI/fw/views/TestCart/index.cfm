<h1>Welcome to the FW Shopping Cart Test Page</h1><br/>
<cfoutput>
	<h3>
	<a href="#event.buildLink('testCart.cart_input')#"><h2>Cart Input</h2></a>
	<br/><b>dBuilderCarthelper Functions</b>	
	<br/>application.model.dbuilderCarthelper.getNumberOfLines() = #application.model.dbuilderCarthelper.getNumberOfLines()#	
	<br/>application.model.dbuilderCarthelper.zipCodeEntered() = #application.model.dbuilderCarthelper.zipCodeEntered()#	
	<br/>
	<br/><b>dBuilderCart Functions</b>
	<br/>session.dBuilderCart.getZipCode() = #session.dBuilderCart.getZipCode()#
<cfset cartLines = 	session.dBuilderCart.getLines() />
	<br/>session.dBuilderCart.getLines() - There are #arraylen(cartlines)# line(s)
<cfif arraylen(cartlines )>
	<cfdump var="#cartlines#" />
</cfif>		
	
	</h3>
	<cfdump var="#session.dBuilderCart#" />
	
	
	<cfdump var="#application#" />
</cfoutput>
