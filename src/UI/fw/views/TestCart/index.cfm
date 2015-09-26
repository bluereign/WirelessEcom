<h1>Welcome to the FW Shopping Cart Test Page</h1><br/>
<cfoutput>
	<h3>
	<!---<br/><a href="#event.buildLink('testCart.CartHelperTest')#"><h2>CartHelper Test</h2></a>
	<a href="#event.buildLink('testCart.cart_input')#"><h2>Cart Input</h2></a>--->
	
	
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
<!---<cfset CartLineNo = 1 />--->

<cfset phoneids = "27716,27665,27674" />
<cfset accessoryids = "515,10099,25766,4212,26626,45144" />

<cfloop from="1" To="#listlen(phoneids)#" index="cartLineNo">
		
<cfset args = { 
	productType = "phone:new",
	product_id = "#listgetat(phoneids,cartLineNo)#",
	qty = 1,
	price = 197.99,
	cartLineNumber = #cartLineNo#
} />
<br/>Add the Phone for Line #cartlineno#
<br/>Calling application.model.dBuilderCartFacade.addItem(argumentCollection = args)
<cfdump var="#args#">
<cfset resultStr = application.model.dBuilderCartFacade.addItem(argumentCollection = args) />
<br/>Result = #resultStr#
<cfset args = { 
	productType = "plan",
	product_id = "46468",
	qty = 1,
	cartLineNumber = #cartLineNo#
} />	
<br/>Add the Plan for Line #cartlineno#
<br/>Calling application.model.dBuilderCartFacade.addItem(argumentCollection = args)
<cfdump var="#args#">
<cfset resultStr = application.model.dBuilderCartFacade.addItem(argumentCollection = args) />
<br/>Result = #resultStr#

<cfset args = { 
	productType = "plan",
	product_id = "46468:46598,489,453",
	qty = 1,
	cartLineNumber = #cartLineNo#
} />	
<br/>Add the Service/Additional Services (phone protection,ringtones) for Line #cartlineno#
<br/>Calling application.model.dBuilderCartFacade.addItem(argumentCollection = args)
<cfdump var="#args#">
<cfset resultStr = application.model.dBuilderCartFacade.addItem(argumentCollection = args) />
<br/>Result = #resultStr#

<cfset args = { 
	productType = "warranty",
	product_id = "26039",
	qty = 1,
	cartLineNumber = #cartLineNo#
} />	
<br/>Add the Warranty for Line #cartlineno#
<br/>Calling application.model.dBuilderCartFacade.addItem(argumentCollection = args)
<cfdump var="#args#">
<cfset resultStr = application.model.dBuilderCartFacade.addItem(argumentCollection = args) />
<br/>Result = #resultStr#

<cfset addAccessory = randrange(0,1) />

<cfif addAccessory is 1 >
<cfset accessoryIndex = randrange(1, listlen(accessoryIds))/>
<cfset args = { 
	productType = "accessory",
	product_id = "#listgetat(accessoryids,accessoryIndex)#",
	qty = 1,
	cartLineNumber = #cartLineNo#
} />	
<br/>Add the Accessory for Line #cartlineno#
<br/>Calling application.model.dBuilderCartFacade.addItem(argumentCollection = args)
<cfdump var="#args#">
<cfset resultStr = application.model.dBuilderCartFacade.addItem(argumentCollection = args) />
<br/>Result = #resultStr#

<cfelse>

<br/>Decline Accessories for Line #cartlineno#
<br/>Calling application.model.carthelper.declineAccessories(#cartLineNo#)
<cfset application.model.carthelper.declineAccessories(#cartLineNo#) />
</cfif>

</cfloop>

<cfset args = { 
	productType = "accessory",
	product_id = "#listgetat(accessoryids,accessoryIndex)#",
	qty = 1,
	cartLineNumber = 999
} />	
<br/>Add the Accessory to cart #cartlineno#
<br/>Calling application.model.dBuilderCartFacade.addItem(argumentCollection = args)
<cfdump var="#args#">
<cfset resultStr = application.model.dBuilderCartFacade.addItem(argumentCollection = args) />
<br/>Result = #resultStr#



<br/>session.Carthelper.getNumberOfLines() = #session.Carthelper.getNumberOfLines()#	
<cfset cartLines = 	session.cart.getLines() />
	<br/>session.cart.getLines() - There are #arraylen(cartlines)# line(s)
<cfset clnum = 0>
<cfloop array="#cartlines#" index="cl">
	<cfset clnum = clnum+1>
<br/><hr/>Line #clnum# Details:
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
