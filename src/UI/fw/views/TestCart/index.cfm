<h1>Welcome to the FW Shopping Cart Test Page</h1><br/>
<cfoutput>
	<h3>
	<br/><a href="#event.buildLink('testCart.CartHelperTest')#"><h2>CartHelper Test</h2></a>
	<a href="#event.buildLink('testCart.cart_input')#"><h2>Cart Input</h2></a>
	<br/><b>dBuilderCarthelper Functions</b>	
	<br/>session.Carthelper.getNumberOfLines() = #session.Carthelper.getNumberOfLines()#	
	<br/>session.Carthelper.zipCodeEntered() = #session.Carthelper.zipCodeEntered()#	
	<br/>
	<br/><b>dBuilderCart Functions</b>
	<br/>session.cart.getZipCode() = #session.cart.getZipCode()#
<cfset cartLines = 	session.cart.getLines() />
	<br/>session.cart.getLines() - There are #arraylen(cartlines)# line(s)
<cfif arraylen(cartlines )>
	<cfdump var="#cartlines#" />
</cfif>		
	
	</h3>
	<cfdump var="#session.cart#" />
	
	
	<cfdump var="#application#" />
</cfoutput>
