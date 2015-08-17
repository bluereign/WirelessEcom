<cfparam name="url.productguid" default="7519c3e0-a691-4294-aa90-a971dce1c4d3" />



<!---<cfif IsDefined("url.productGuid") and len(url.productGuid) gt 0>
	<div>
    	<cfset productDetails = application.model.AdminPhone.getPhone(url.productguid)>

		<cfset upc = productDetails.UPC>

    	<cfoutput>
        <!--- USCA --->
    	<div>
			<a href="http://www.uscurrencyauctions.com/cgi-bin/categories.cgi?Operation=ItemSearch&Keywords=#upc#&SearchIndex=Wireless" target="_blank">USCA</a>
        </div>

        </cfoutput>
    </div>
<cfelse>
	<p>
    	No phone selected.
    </p>
</cfif>--->