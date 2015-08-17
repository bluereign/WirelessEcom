<!---
Script Name: PriceBugMonkey.cfm
     Author: Scott Hamilton
     
Description: Builds an internal table of active devices and then loops thru that table
             using CFHTTP to request the product detail page. It then screen scraps
             the final price (in red) and compares that to the New price from the database
             contained in the internal table. 
             
NOTES: If you are running the script on an instance that is using a different database than the
the server you are testing you will want to set up another datasource and specify that in the ds
argument (see example). I placed my script in the /test folder under wwwroot.

URL Parameters:
    serverip - specifies the server to be test 
    ds - specifies the datasource to use
    loops - specifies how many times the script should loop over the entire product list. 
           
EXAMPLE:
	local.costco.wa/test/pricebugmonkey.cfm?serverip=10.7.0.91&ds=wirelessadvocates_prod&loops=50

--->

<!--- Default URL parameters --->
<cfparam name="serverip" default="http://10.7.0.80" />
<cfparam name="ds" default="wirelessadvocates" />
<cfparam name="loops" default="15" />
<cfparam name="exclude" default="" />


<cfoutput>#nowStr()#: Price Monkey Started for #serverip#<br/> </cfoutput>
<cfflush/>

<cfset bugCounter = 0 />


<cfset prodPrices = buildProductPrices() />
<cfoutput>#nowStr()#: Scanning #arrayLen(prodPrices)# products<br/> </cfoutput>

<!--- Repeatedly hit a page --->
<cfset loopcounter = 0>
<cfloop condition="loopCounter lt loops" >
	<cfset loopCounter = loopCounter + 1 />	
	<cfif loopCounter mod 5 is 0>
		<cfoutput>#nowStr()#: loopct = #loopCounter# of #loops#<br/></cfoutput>
		<cfflush/>
	</cfif>
	<cfloop array="#prodprices#" index="pp">
		<cfset theurl ="#serverip#/index.cfm/go/shop/do/PhoneDetails/productid/#pp.productid#"/>
		<cfset resultStr = doCfhttp(theurl,pp.productid,pp.expectedPrice) />
		<cfif resultStr is not "">
			<cfset bugCounter = bugCounter + 1 />
			<cfoutput>#resultStr#</cfoutput>
			<cfflush/>
			<!--- See how long this exists for --->
			<cfset innerloop = 0 />
			<cfloop condition='resultStr is not "" and innerloop le 20'>
				<cfset innerloop = innerloop+1 />
				<cfset resultStr = doCfHttp(theurl,pp.productid,pp.expectedPrice) />
				<cfif resultStr is not "">
					<cfoutput>Retry ###innerloop# of 20 -  #resultStr#</cfoutput>
				<cfelse>
					<cfoutput>#nowStr()#: Price bug has cleared for productid=#pp.productid#<br/></cfoutput>
				</cfif>	
				<cfflush/>
			</cfloop>
			<cfflush/>
		</cfif>
		</cfloop>
</cfloop>

<cfoutput>#nowStr()#: Completed. Bugs=#bugCounter#.<br/></cfoutput>


<cffunction name="doCfhttp" returntype="string">
	<cfargument name="theurl" type="string" required="yes">
	<cfargument name="productid" type="numeric" required="yes">
	<cfargument name="expectedPrice" type="numeric" required="yes">
	<cfset var thePrice = "" />
	<cfhttp url="#arguments.theURL#" timeout="60">
	</cfhttp>
	<cfset thePrice = findPrice(mid(cfhttp.filecontent,22000,2000)) />
	<cfif thePrice is not -1 and thePrice is not arguments.expectedPrice>
		<cfreturn "#nowStr()#: Found price bug - productid=#arguments.productid# price=#theprice# expectedPrice=#arguments.expectedPrice# loopct=#loopCounter#<br/>" />"
	<cfelse>
		<cfreturn "" />
	</cfif>			
</cffunction>	

<cffunction name="findPrice" returnType="numeric" output="true">
	<cfargument name="searchString" type="string" required="true" />
	<cfset var findthis = '<div class="final-price-container">$' />
	<cfset var pos =  findNoCase(findthis,arguments.searchString,1) />
	<cfset var skiplen = len(findthis) />
	<cfset var thePrice = "" />
	<cfif pos gt 0>
		<cfset thePrice = mid(arguments.searchString,pos+skiplen,50) />
		<cfif listlen(theprice,"<") >
			<cfset thePrice = listgetat(theprice,1,"<,N") />
		<cfelse>
			<cfset thePrice = -1 />
		</cfif>
		<cfif isNumeric(thePrice)>
			<cfreturn thePrice />
		<cfelse>
			<cfoutput>#nowStr()#: Error - unable to parse price. Found '#thePrice#'.</cfoutput>
			<cfreturn "-1" />
		</cfif>
	<cfelse>
		<cfreturn "-1" />
	</cfif>		
	
</cffunction>	

<cffunction name="nowStr" returntype="string" >
	<cfset s = '#dateformat(now(),"mm/dd/yyyy")# #timeformat(now(),"hh:mm:ss")#' />
	<cfreturn s />	
</cffunction>

<cffunction name="buildProductPrices" returntype="array"  > 
	<cfset ppa = arrayNew(1) />
	<cfquery name="qprice" datasource="#ds#">
		SELECT cp.ProductId, cp.GersSku, Price AS 'NewPrice' FROM catalog.product cp
		INNER JOIN catalog.gersprice cgp ON cgp.GersSKu = cp.GersSku AND cgp.PriceGroupCode = 'ECN'
		INNER JOIN catalog.device cd ON cd.deviceguid = cp.productguid
		WHERE cp.Active = '1' 
		AND StartDate <= GETDATE() AND EndDate > GETDATE()
		<cfif exclude is not "">
			and cp.productId not in (#exclude#)
		</cfif>
		ORDER BY cp.GersSku
	</cfquery>
	<cfif qprice.recordcount is not 0>
		<cfloop query="qprice">
			<cfset pp = {} />
			<cfset pp.productid = #productId# />
			<cfset pp.GersSku = #GersSku# />
			<cfset pp.expectedPrice = #decimalformat(newPrice)# />
			<cfset arrayAppend(ppa,pp) />
		</cfloop>		
	</cfif>
	<cfreturn ppa />
</cffunction>	

