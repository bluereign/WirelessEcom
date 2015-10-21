<!--- Build a cart to be used in end to end testing  --->
<cfset phoneids = "27671,27665,27674" />
<cfset phonePrices = "799.99,199.00,299,98" />
<cfset phoneMandatoryDownPaymentPct = "10,15,5" />
<cfset phoneOptionalDownPaymentPct = "0,0,10" />
<cfset accessoryids = "515,25766,4212,26626,26721" />

<cfset application.model.dBuilderCartFacade.clearCart() />

<cfquery name="qPhones" datasource="wirelessadvocates" >
	select * from catalog.dn_phones where imeitype is not null and itemid is not null	
</cfquery>	


<!---<cfloop from="1" To="#listlen(phoneids)#" index="cartLineNo">--->
<cfloop from="1" To="1" index="cartLineNo">
<hr/>
<cfset rindex = randrange(1,qPhones.recordcount) />		
<cfset args = { 
	<!---productType = "phone:new",--->
	productType = "phone:financed-12-upgrade",
	product_id = "#listgetat(valuelist(qphones.productid),rindex)#",
	qty = 1,
	price = "#listgetat(valuelist(qphones.price_retail),rindex)#",
	cartLineNumber = #cartLineNo#,
	subscriberIndex = #cartLineNo#,
	mandatoryDownPmtPct = "#listgetat(phoneMandatoryDownPaymentPct,cartLineNo)#",
	mandatoryDownPmtAmt = #decimalformat(listgetat(phoneMandatoryDownPaymentPct,cartLineNo)/100 * listgetat(phoneprices,cartLineNo))#,
	optionalDownPmtPct = "#listgetat(phoneOptionalDownPaymentPct,cartLineNo)#",
	optionalDownPmtAmt = #listgetat(phoneOptionalDownPaymentPct,cartLineNo)#/100 * #listgetat(phoneprices,cartLineNo)#
} />
<cfset resultStr = application.model.dBuilderCartFacade.addItem(argumentCollection = args) />
Result = #resultStr#
<cfset args = { 
	productType = "plan",
	product_id = "46468",
	qty = 1,
	cartLineNumber = #cartLineNo#
} />	
<cfif cartLineNo is 1>
	<cfset resultStr = application.model.dBuilderCartFacade.addItem(argumentCollection = args) />
</cfif>

<cfset args = { 
	productType = "plan",
	product_id = "46468:46598,489,453",
	qty = 1,
	cartLineNumber = #cartLineNo#
} />	
<cfset resultStr = application.model.dBuilderCartFacade.addItem(argumentCollection = args) />

<cfset args = { 
	productType = "warranty",
	product_id = "26039",
	qty = 1,
	cartLineNumber = #cartLineNo#
} />	
<br/><br/>Add the Warranty for Line #cartlineno#
<cfset resultStr = application.model.dBuilderCartFacade.addItem(argumentCollection = args) />

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
<cfset resultStr = application.model.dBuilderCartFacade.addItem(argumentCollection = args) />
<cfset application.model.dBuilderCartFacade.updateAccessoryQty(#cartLineNo#,#listgetat(accessoryids,accessoryIndex)#,2) />
<cfelse>
<cfset application.model.carthelper.declineAccessories(#cartLineNo#) />
</cfif>
</cfloop>

<cfset accessoryIndex = randrange(1, listlen(accessoryIds))/>
<cfset args = { 
	productType = "accessory",
	product_id = "#listgetat(accessoryids,accessoryIndex)#",
	qty = 1,
	cartLineNumber = 999
} />	
<cfset resultStr = application.model.dBuilderCartFacade.addItem(argumentCollection = args) />

