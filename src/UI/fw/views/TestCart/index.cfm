<h1>Welcome to the FW Shopping Cart Test Page</h1><br/>
<cfoutput>
	<h3>
	
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

<cfset phoneids = "27671,27665,27674" />
<cfset phonePrices = "799.99,199.00,299,98" />
<cfset phoneMandatoryDownPaymentPct = "10,15,5" />
<cfset phoneOptionalDownPaymentPct = "0,0,10" />
<cfset accessoryids = "515,25766,4212,26626,26721" />

<cfloop from="1" To="#listlen(phoneids)#" index="cartLineNo">
<hr/>		
<cfset args = { 
	<!---productType = "phone:new",--->
	productType = "phone:financed-12-new",
	product_id = "#listgetat(phoneids,cartLineNo)#",
	qty = 1,
	price = "#listgetat(phoneprices,cartLineNo)#",
	cartLineNumber = #cartLineNo#,
	subscriberIndex = #cartLineNo#,
	mandatoryDownPmtPct = "#listgetat(phoneMandatoryDownPaymentPct,cartLineNo)#",
	mandatoryDownPmtAmt = #decimalformat(listgetat(phoneMandatoryDownPaymentPct,cartLineNo)/100 * listgetat(phoneprices,cartLineNo))#,
	optionalDownPmtPct = "#listgetat(phoneOptionalDownPaymentPct,cartLineNo)#",
	optionalDownPmtAmt = #listgetat(phoneOptionalDownPaymentPct,cartLineNo)#/100 * #listgetat(phoneprices,cartLineNo)#
} />
<br/>Add the Phone for Line #cartlineno#
<br/>Calling application.model.dBuilderCartFacade.addItem(argumentCollection = args)
<cfdump var="#args#">
<cfset resultStr = application.model.dBuilderCartFacade.addItem(argumentCollection = args) />
Result = #resultStr#
<cfset args = { 
	productType = "plan",
	product_id = "46468",
	qty = 1,
	cartLineNumber = #cartLineNo#
} />	
<cfif cartLineNo is 1>
	<br/><br/>Add the Plan for Line #cartlineno#
	<br/>Calling application.model.dBuilderCartFacade.addItem(argumentCollection = args)
	<cfdump var="#args#">
	<cfset resultStr = application.model.dBuilderCartFacade.addItem(argumentCollection = args) />
	Result = #resultStr#
</cfif>

<cfset args = { 
	productType = "plan",
	product_id = "46468:46598,489,453",
	qty = 1,
	cartLineNumber = #cartLineNo#
} />	
<br/><br/>Add the Service/Additional Services (phone protection,ringtones) for Line #cartlineno#
<br/>Calling application.model.dBuilderCartFacade.addItem(argumentCollection = args)
<cfdump var="#args#">
<cfset resultStr = application.model.dBuilderCartFacade.addItem(argumentCollection = args) />
Result = #resultStr#

<cfset args = { 
	productType = "warranty",
	product_id = "26039",
	qty = 1,
	cartLineNumber = #cartLineNo#
} />	
<br/><br/>Add the Warranty for Line #cartlineno#
<br/>Calling application.model.dBuilderCartFacade.addItem(argumentCollection = args)
<cfdump var="#args#">
<cfset resultStr = application.model.dBuilderCartFacade.addItem(argumentCollection = args) />
Result = #resultStr#

<cfset randomize(timeformat(now(),"hhmmssl"))/>
<cfset addAccessory = randrange(1,100) />
<cfif addAccessory gt 5 >
<cfset accessoryCount = randRange(1,4) />
<cfset accessoryIndex = randrange(1, listlen(accessoryIds))/>
<cfset args = { 
	productType = "accessory",
	product_id = "#listgetat(accessoryids,accessoryIndex)#",
	qty = #accessoryCount#,
	cartLineNumber = #cartLineNo#
} />	
<br/><br/>Add #accessoryCount# Accessory(s) for Line #cartlineno#
<br/>Calling application.model.dBuilderCartFacade.addItem(argumentCollection = args)
<cfdump var="#args#">
<cfset resultStr = application.model.dBuilderCartFacade.addItem(argumentCollection = args) />
Result = #resultStr#
<br/>Item count for #listgetat(accessoryids,accessoryIndex)# on line #cartLineNo# = #application.model.dBuilderCartFacade.getItemCount(cartLineNo,listgetat(accessoryids,accessoryIndex))#
<br/>Now set the quantity to 2 regardless of how many were added
<br/>application.model.dBuilderCartFacade.updateAccessoryQty(#cartLineNo#,#listgetat(accessoryids,accessoryIndex)#,2)
<cfset application.model.dBuilderCartFacade.updateAccessoryQty(#cartLineNo#,#listgetat(accessoryids,accessoryIndex)#,2) />
<br/>Item count for #listgetat(accessoryids,accessoryIndex)# on line #cartLineNo# = #application.model.dBuilderCartFacade.getItemCount(cartLineNo,listgetat(accessoryids,accessoryIndex))#
<cfelse>
<br/><br/>Decline Accessories for Line #cartlineno#
<br/>Calling application.model.carthelper.declineAccessories(#cartLineNo#)
<cfset application.model.carthelper.declineAccessories(#cartLineNo#) />
</cfif>

</cfloop>

<hr/>
<cfset accessoryIndex = randrange(1, listlen(accessoryIds))/>
<cfset args = { 
	productType = "accessory",
	product_id = "#listgetat(accessoryids,accessoryIndex)#",
	qty = 1,
	cartLineNumber = 999
} />	
<br/>Add the Accessory to cart(Other)
<br/>Calling application.model.dBuilderCartFacade.addItem(argumentCollection = args)
<cfdump var="#args#">
<cfset resultStr = application.model.dBuilderCartFacade.addItem(argumentCollection = args) />
Result = #resultStr#

<br/><br/>session.Carthelper.getNumberOfLines() = #session.Carthelper.getNumberOfLines()#	
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
<br>cl.getPhone().getPrices().dump() = #cl.getphone().getPrices().dump()#
<br>cl.getActivationFee().dump() = #cl.getActivationFee().dump()#
<br>cl.getPhone().dump() = #cl.getphone().dump()#
<br/><br/>CartHelper:
<br/>session.carthelper.getLineWarrantyProductId(1) = #session.carthelper.getLineWarrantyProductId(1)#	
</cfloop>

<hr/>
Get the list of subscriber indices from the cart
<br/>application.model.dBuilderCartFacade.getSubscriberIndices() = #application.model.dBuilderCartFacade.getSubscriberIndices()#

<hr/>
Get the Phone for each line in the cart:
<cfloop from="1" to ="#session.Carthelper.getNumberOfLines()#" index="ln">
	<cfif not structIsEmpty(application.model.dBuilderCartFacade.getDevice(ln))>
		<br/>application.model.dBuilderCartFacade.getDevice(#ln#) = <cfdump var="#application.model.dBuilderCartFacade.getDevice(ln)#" />
		<br/>application.model.dBuilderCartFacade.getDevice(ln).cartItem.dump()
		<br/>#application.model.dBuilderCartFacade.getDevice(ln).cartItem.dump()#
	</cfif>
</cfloop>

<hr/>
Get the Rate Plan for the cart:
<br/>application.model.dBuilderCartFacade.getPlan() = <cfdump var="#application.model.dBuilderCartFacade.getPlan()#" />


<hr/>
Loop thru lines and display accessory counts per line
<cfloop from="1" to ="#session.Carthelper.getNumberOfLines()#" index="ln">
	<cfloop list="#accessoryids#" index="a">
		<cfif application.model.dBuilderCartFacade.getItemCount(ln,a) gt 0>
			<br/>Item count for #a# on line #ln# = #application.model.dBuilderCartFacade.getItemCount(ln,a)#
		</cfif>
	</cfloop>		
</cfloop>		

<hr/>
Get a list of all accessory product_ids for each line:
<cfloop from="1" to ="#session.Carthelper.getNumberOfLines()#" index="ln">
<br/>application.model.dBuilderCartFacade.getAccessoryIds(#ln#) = #application.model.dBuilderCartFacade.getAccessoryIds(ln)#
</cfloop>
<br/>application.model.dBuilderCartFacade.getAccessoryIds(999) = #application.model.dBuilderCartFacade.getAccessoryIds(999)#

<hr/>Get the Warranty for each line
<cfloop from="1" to ="#session.Carthelper.getNumberOfLines()#" index="ln">
application.model.dBuilderCartFacade.getWarranty(#ln#) = <cfdump var="#application.model.dBuilderCartFacade.getWarranty(ln)#" />
</cfloop>

<hr/>Get theFeatures for each line
<cfloop from="1" to ="#session.Carthelper.getNumberOfLines()#" index="ln">
application.model.dBuilderCartFacade.getFeatures(#ln#) = 
<cfset features = #application.model.dBuilderCartFacade.getFeatures(ln)# />
<cfdump var="#features#" />
</cfloop>



<hr/>
Get an array of accessory info for each line:
<cfloop from="1" to ="#session.Carthelper.getNumberOfLines()#" index="ln">
<br/>application.model.dBuilderCartFacade.getAccessories(#ln#) = <cfdump var="#application.model.dBuilderCartFacade.getAccessories(ln)#"/>
</cfloop>
<br/>application.model.dBuilderCartFacade.getAccessories(999) = <cfdump var="#application.model.dBuilderCartFacade.getAccessories(999)#"/>

<hr/>
<cfset randlineNo = randRange(1,session.Carthelper.getNumberOfLines()) />
Delete Randomly Selected Line #randLineNo#
<br/>session.Carthelper.getNumberOfLines() = #session.Carthelper.getNumberOfLines()#	
<br/>application.model.dBuilderCartFacade.deleteLine(#randLineNo#)
<cfset application.model.dBuilderCartFacade.deleteLine(#randLineNo#) />
<br/>and now session.Carthelper.getNumberOfLines() = #session.Carthelper.getNumberOfLines()#	

	</h3>
	<cfdump var="#application#"  expand="false" />
</cfoutput>
