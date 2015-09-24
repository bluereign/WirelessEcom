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
	<br>session.cart.setZipCode("78205")<cfset session.cart.setZipCode("78205") />
	<br/>session.cart.getZipCode() = #session.cart.getZipCode()#
<cfset cartLines = 	session.cart.getLines() />
	<br/>session.cart.getLines() - There are #arraylen(cartlines)# line(s)
<cfif arraylen(cartlines )>
	<cfdump var="#cartlines#" expand="false" />
</cfif>	
<br/>
<cfset args = { 
	productType = "phone:new",
	product_id = "27716",
	qty = 1,
	price = 197.99
} />
<br/>Add the Phone	
<br/>Calling application.model.dBuilderCartFacade.addItem(argumentCollection = args)
<cfdump var="#args#">
<cfset application.model.dBuilderCartFacade.addItem(argumentCollection = args) />

<cfset args = { 
	productType = "plan",
	product_id = "46468",
	qty = 1,
	cartLineNumber = 1
} />	
<br/>Add the Plan
<br/>Calling application.model.dBuilderCartFacade.addItem(argumentCollection = args)
<cfdump var="#args#">
<cfset application.model.dBuilderCartFacade.addItem(argumentCollection = args) />

<cfset args = { 
	productType = "plan",
	product_id = "46468:46598",
	qty = 1,
	cartLineNumber = 1
} />	
<br/>Add the Service
<br/>Calling application.model.dBuilderCartFacade.addItem(argumentCollection = args)
<cfdump var="#args#">
<cfset application.model.dBuilderCartFacade.addItem(argumentCollection = args) />

<cfset args = { 
	productType = "warranty",
	product_id = "26039",
	qty = 1,
	cartLineNumber = 1
} />	
<br/>Add the Warranty
<br/>Calling application.model.dBuilderCartFacade.addItem(argumentCollection = args)
<cfdump var="#args#">
<cfset application.model.dBuilderCartFacade.addItem(argumentCollection = args) />

<br/>session.Carthelper.getNumberOfLines() = #session.Carthelper.getNumberOfLines()#	
<cfset cartLines = 	session.cart.getLines() />
	<br/>session.cart.getLines() - There are #arraylen(cartlines)# line(s)
<cfloop array="#cartlines#" index="cl">
<br/><hr/>Line Details:
<br/>#cl.dump()#
<br>cl.getPhone().getType() = #cl.getphone().getType()#
<br>cl.getPhone().getDeviceServiceType() = #cl.getphone().getDeviceServiceType()#
<br>cl.getPhone().getIsShared() = #cl.getphone().getisShared()#
<br>cl.getPhone().getGersSku() = #cl.getphone().getGersSku()#
<br>cl.getPhone().getTitle() = #cl.getphone().getTitle()#
<br>cl.getPhone().dump() = #cl.getphone().dump()#
<br>cl.etPhone().getPrices().dump() = #cl.getphone().getPrices().dump()#
<br>cl.getActivationFee().dump() = #cl.getActivationFee().dump()#
<br>cl.getPhone().dump() = #cl.getphone().dump()#
<br/><br/>CartHelper:
<br/>session.carthelper.getLineWarrantyProductId(1) = #session.carthelper.getLineWarrantyProductId(1)#	
</cfloop>
	</h3>
	<cfdump var="#application#"  expand="false" />
</cfoutput>
