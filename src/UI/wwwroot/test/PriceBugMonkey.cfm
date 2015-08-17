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
    exclude - specifies a comma delimited list of product ids to be excluded
    include - specifies a comma delimited list of product ids to be included (productids not on this list are excluded)
           
EXAMPLE:
	local.costco.wa/test/pricebugmonkey.cfm?serverip=10.7.0.91&ds=wirelessadvocates_prod&loops=50
	local.costco.wa/test/pricebugmonkey.cfm?serverip=10.7.0.91&ds=wirelessadvocates_prod&loops=50&exclude=
	local.costco.wa/test/pricebugmonkey.cfm?serverip=10.7.0.91&ds=wirelessadvocates_prod&loops=50&include=

--->

<!--- Default URL parameters --->
<cfparam name="serverip" default="10.7.0.90" />
<cfparam name="ds" default="wirelessadvocates_prod" />
<cfparam name="loops" default="25" />
<cfparam name="exclude" default= "23708,23741,23740,26049,23691,23692"/>   <!--- "23708,23741,23740,26049,23691,23692" /> --->
<cfparam name="include" default="" />
<cfparam name="top" default="" />
<cfparam name="verbose" default="" />
<cfparam name="legacy" default="1" />

<cfoutput>#nowStr()#: Price Monkey Started for #serverip#<br/> 
include = #include#<br/>
exclude = #exclude#<br/>
</cfoutput>
<cfflush/>

<cfset bugCounter = 0 />

<cfset prodPrices = buildProductPrices() />
<cfoutput>#nowStr()#: Scanning #arrayLen(prodPrices)# products<br/> </cfoutput>
<cfif verbose is 1 or verbose is true>
<cfloop array="#prodPrices#" index="p">
	<cfoutput><br/>
		<strong>PRODID=</strong>#p.productid#
		<strong>GERSSKU=</strong>#p.gerssku#
		<strong>PRICE=</strong>#p.expectedPrice#
		<strong>PRODNAME=</strong>#p.expectedName#
	</cfoutput>
	</cfloop><br/>
</cfif>
<cfflush/>

<!--- Test for duplicate freeKits --->
<cfif verbose is 2>
	<cfloop array="#prodPrices#" index="p">
	
	<cfquery name="qFreebies" datasource="#ds#">
				SELECT ap.ProductID as freeProductId
				FROM catalog.Device d 
				INNER JOIN catalog.Product dp ON dp.ProductGuid = d.DeviceGuid
				INNER JOIN catalog.DeviceFreeAccessory da ON da.DeviceGuid = d.DeviceGuid
				INNER JOIN catalog.Accessory a ON a.AccessoryGuid = da.ProductGuid
				INNER JOIN catalog.Product ap ON ap.ProductGuid = a.AccessoryGuid
				INNER JOIN catalog.ProductTag pt on pt.ProductGuid = ap.ProductGuid
				WHERE dp.GersSku = '#p.gerssku#' and pt.Tag = 'freeaccessory' 
				ORDER BY ap.ProductID asc, ap.GersSku asc
	</cfquery>
	<cfoutput>Freebies for #p.gerssku# = #qFreebies.recordcount# </cfoutput><br/>
	</cfloop>
</cfif>

<!--- Repeatedly hit a page --->
<cfset loopcounter = 0>
<cfloop condition="loopCounter lt loops" >
	<cfset loopCounter = loopCounter + 1 />	
	<cfif loopCounter mod 5 is 0>
		<cfoutput>#nowStr()#: loopct = #loopCounter# of #loops#<br/></cfoutput>
		<cfflush/>
	</cfif>
	<cfloop array="#prodprices#" index="pp">
		<cfset theurl ="#serverip#/catalog/detail/pid/#pp.productid#"/>
		<cfset resultStr = doCfhttp(theurl,pp.productid,pp.expectedPrice,pp.expectedName) />
		<cfif resultStr is not "">
			<cfset bugCounter = bugCounter + 1 />
			<cfoutput>#resultStr#</cfoutput>
			<cfflush/>
			<!--- See how long this exists for --->
			<cfset innerloop = 0 />
			<cfloop condition='resultStr is not "" and innerloop le 20'>
				<cfset innerloop = innerloop+1 />
				<cfset resultStr = doCfHttp(theurl,pp.productid,pp.expectedPrice,pp.expectedName) />
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
	  <cfargument name="expectedName" type="string" required="yes">
      <cfset var thePrice = "" />
      <cfset var httpResult = "" />
	  <cfset var namematch = "" />
	  <cfset var theExpectedName = "" />
      
      <cfhttp url="#arguments.theURL#" result="httpResult" timeout="60">
      </cfhttp>
      <cfif legacy is 1>
	  	  <cfset thePrice = findPrice_legacy(httpResult.filecontent) />
	  <cfelse>
      	<cfset thePrice = findPrice(httpResult.filecontent) />
	  </cfif>
	  <cfset theName = findName(httpResult.filecontent) />
      <cfif thePrice is not -1 and thePrice is not arguments.expectedPrice>
	  	   <cfif theName is arguments.expectedName>
			   <cfset NameMatch = "Names Match" />
			   <cfset TheExpecteName = "" />
		   <cfelse>
		   	   <cfset NameMatch = "Names DO NOT Match" />
			   <cfset TheExpectedName = "<strong>EXPECTEDNAME=</strong>[#arguments.expectedName#]" />
		   </cfif>	 	
            <cfreturn "#nowStr()#: Found price bug (#NameMatch#) - <strong>PRODID=</strong>#arguments.productid# <strong>PRICE=</strong>[#theprice#] <strong>EXPECTED PRICE=</strong>[#arguments.expectedPrice#] <strong>NAME=</strong>[#thename#] #theExpectedName# <strong>LOOP=</strong>#loopCounter#<br/>" />"
      <cfelse>
            <cfreturn "" />
      </cfif>                 
</cffunction>     

<cffunction name="findPrice_legacy" returnType="numeric" output="true">
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

<cffunction name="findPrice" returnType="numeric" output="true">
	<cfargument name="searchString" type="string" required="true" />
	<cfset var findthis = 'id="priceBlockHeader-new"' />
	<cfset var pos =  findNoCase(findthis,arguments.searchString,1) />
	<cfset var skiplen = len(findthis) />
	<cfset var thePrice = "" />
	<cfif pos gt 0>
		<cfset thePrice = mid(arguments.searchString,pos+skiplen,250) />
		<cfif listlen(theprice,"$<") >
			<cfset thePrice = listgetat(theprice,5,"$<") />
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

<cffunction name="findName" returnType="string" output="true">
	<cfargument name="searchString" type="string" required="true" />
	<cfset var findthis = '<h1 class="productTitle">' />
	<cfset var pos =  findNoCase(findthis,arguments.searchString,1) />
	<cfset var skiplen = len(findthis) />
	<cfset var theName = "" />
	<cfif pos gt 0>
		<cfset theName = mid(arguments.searchString,pos+skiplen,250) />
<!---<cfoutput><br/>Debug: listlen=#listlen(theName,"<>")# 1=#listgetat(theName,1,"<>")# 2=#listgetat(theName,2,"<>")# 3=#listgetat(theName,3,"<>")# 4=#listgetat(theName,4,"<>")#</cfoutput>--->

		<cfif listlen(theName,"<,>") >
			<cfset theName = listgetat(theName,1,"<>") />
		<cfelse>
			<cfset theName = "Not Found" />
		</cfif>
		<cfif theName is not "Not Found">
			<cfreturn theName />
		<cfelse>
			<cfoutput>#nowStr()#: Error - unable to parse product name. Found '#theName#'.</cfoutput>
			<cfreturn "" />
		</cfif>
	<cfelse>
		<cfreturn "Not Found" />
	</cfif>		
	
</cffunction>	


<cffunction name="nowStr" returntype="string" >
	<cfset s = '#dateformat(now(),"mm/dd/yyyy")# #timeformat(now(),"hh:mm:ss")#' />
	<cfreturn s />	
</cffunction>

<cffunction name="buildProductPrices" returntype="array"  > 
	<cfset ppa = arrayNew(1) />

<cfquery name="qprice" datasource="#ds#">
		SELECT summaryTitle, ProductId, GersSku, price_new FROM catalog.dn_phones
		WHERE isAvailableOnline = '1' 
		<cfif exclude is not "">
			and productId not in (#exclude#)
		</cfif>
		<cfif include is not "">
			and productId in (#include#)
		</cfif>
		ORDER BY GersSku
	</cfquery>

	<cfif qprice.recordcount is not 0>
		<cfloop query="qprice">
			<cfset pp = {} />
			<cfset pp.expectedName = #summaryTitle# />
			<cfset pp.productid = #productId# />
			<cfset pp.GersSku = #GersSku# />
			<cfset pp.expectedPrice = #decimalformat(price_new)# />
			<cfset arrayAppend(ppa,pp) />
		</cfloop>		
	</cfif>
	<cfreturn ppa />
</cffunction>	

